import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import verifyToken from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import Participant from '@gravity-haus/gh-common/dist/models/participant.model';
import StripeModel from '@gravity-haus/gh-common/dist/models/stripe.model';

import { cancelAll } from '@gravity-haus/gh-common/dist/utils/cancel-all/cancel-all';

export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  // check for user authentication
  try {
    verifyToken(event);
  } catch {
    return response(401, { message: 'Unauthorized' });
  }

  try {
    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();
    Client.getInstance();

    const body = JSON.parse(event.body || '');
    const { userId, accountId } = body;

    if (!userId || !accountId)
      return response(400, {
        error: {
          message: 'Missing Required Parameters',
          userId: `${userId}`,
          accountId: `${accountId}`,
        },
      });

    await Participant.destroy({
      where: {
        userId,
        accountId,
      },
    });

    // TODO: talk about this when a participant is removed from an account, how should we handle removing the association to the stripe account?
    await StripeModel.update({ customerId: '' }, { where: { userId } });

    await cancelAll([userId], event);

    return response(200, event);
  } catch (error) {
    return response(500, { error });
  }
};
