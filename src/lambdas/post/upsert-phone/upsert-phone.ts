import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import verifyToken from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import upsertPhone from '../../../utils/upsert-phone/upsert-phone';

export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
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

    const { id, phoneNumber, countryCode } = body;

    const phone = await upsertPhone(
      {
        number: phoneNumber,
        countryCode: countryCode || 1,
      },
      id,
    );

    return response(200, { phone });
  } catch (error) {
    return response(500, { error });
  }
};
