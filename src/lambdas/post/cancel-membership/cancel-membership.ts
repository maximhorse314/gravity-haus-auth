import verifyToken from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { Transaction } from 'sequelize';

import MembershipApplicationStatus from '../../../models/membershipApplicationStatus.model';
import User from '@gravity-haus/gh-common/dist/models/user.model';

import deactivateUser from '../../../utils/deactivate-user/deactivate-user';
import cancelMembershipApplicationStatus from '../../../utils/cancel-membership-application-status/cancel-membership-application-status';

/**
 * cancel a Membership Application Status and a stripe subscription
 * @param event APIGatewayProxyEvent
 * @returns APIGatewayProxyResult
 */
export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  try {
    verifyToken(event);
  } catch {
    return response(401, { message: 'Unauthorized' });
  }

  try {
    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();

    const { id } = JSON.parse(event.body || '');
    const { db } = Client.getInstance([User, MembershipApplicationStatus]);

    const user = await User.findByPk(id);
    const membership = await MembershipApplicationStatus.findOne({ where: { userId: user.id } });

    if (!membership) {
      return response(404, { message: 'Membership does not exist' });
    }

    const actions = await db.transaction(
      { isolationLevel: Transaction.ISOLATION_LEVELS.READ_COMMITTED },
      async (t: Transaction) => {
        return Promise.all([cancelMembershipApplicationStatus(membership, t), deactivateUser(user, t)]);
      },
    );

    const [exMembership, exUser] = actions;

    return response(200, {
      message: `Membership Canceled. ${exMembership.id}, User: ${exUser.id}`,
    });
  } catch (error) {
    const statusCode = error.statusCode || 500;
    return response(statusCode, { error, message: 'Failed to find account for deactivation' });
  }
};
