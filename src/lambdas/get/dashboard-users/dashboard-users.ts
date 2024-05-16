import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import verifyToken from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import User from '@gravity-haus/gh-common/dist/models/user.model';

import Account from '@gravity-haus/gh-common/dist/models/account.model';
import Phone from '@gravity-haus/gh-common/dist/models/phone.model';
import MembershipApplicationStatus from '@gravity-haus/gh-common/dist/models/membershipApplicationStatus.model';
import Address from '@gravity-haus/gh-common/dist/models/address.model';
import MembershipApplication from '@gravity-haus/gh-common/dist/models/membershipApplication.model';
import Subscription from '@gravity-haus/gh-common/dist/models/subscription.model';

import getAccountHolder from '../../post/change-membership/utils/get-account-holder';
import cleanEmail from '@gravity-haus/gh-common/dist/utils/clean-email/clean-email';
import { getStripeAccountOwner } from '../../../utils/get-stripe-account-owner/get-stripe-account-owner';

const getAllUsers = async (): Promise<User> => {
  const users = await User.findAll({
    order: [['id', 'DESC']],
    where: {},
    include: [
      {
        model: MembershipApplicationStatus,
        as: 'membershipApplicationStatus',
        include: [
          {
            model: MembershipApplication,
            as: 'membershipApplication',
            include: [
              {
                model: Subscription,
                as: 'subscription',
              },
            ],
          },
        ],
      },
      {
        model: Account,
        as: 'account',
        include: [
          {
            model: Phone,
            as: 'phone',
          },
          {
            model: Address,
            as: 'mailingAddress',
          },
        ],
      },
    ],
  });

  return users.map((u) => {
    return u.get({ plain: true });
  });
};

export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  // check for user authentication
  try {
    verifyToken(event);
  } catch {
    return response(401, { message: 'Unauthorized' });
  }

  try {
    const queryStringParameters = event?.queryStringParameters || {};
    const { id } = queryStringParameters;
    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();
    Client.getInstance();

    let users;
    if (id) {
      const userData = await getAccountHolder({ userId: parseInt(id, 10) });
      const stripeAccountOwner = await getStripeAccountOwner(userData[0].stripe.customerId);
      users = [
        {
          ...userData[0],
          stripeAccountOwner: stripeAccountOwner?.user,
        },
      ];
    } else {
      users = await getAllUsers();

      users = users
        .filter((u) => u)
        .map((u) => {
          return {
            id: u.id,
            fullName: `${u?.account?.firstName} ${u?.account?.lastName}`,
            city: u?.account?.mailingAddress?.city,
            state: u?.account?.mailingAddress?.state,
            phoneNumber: u?.account?.phone?.number,
            status: u?.membershipApplicationStatus?.status,
            email: cleanEmail(u?.email),
            joined: u?.createdAt && new Date(u.createdAt).toLocaleDateString('en-US'),
            membership: u?.membershipApplicationStatus?.membershipApplication?.subscription?.name,
          };
        });
    }

    return response(200, { users });
  } catch (error) {
    return response(500, { error: `${error}` });
  }
};
