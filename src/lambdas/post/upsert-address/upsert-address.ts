import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import verifyToken from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import upsertAddress from '../../../utils/upsert-address/upsert-address';

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
    const { id, address1, address2, address3, address4, city, county, state, postalCode, country } = body;

    const address = await upsertAddress(
      {
        address1,
        address2,
        address3,
        address4,
        city,
        county,
        state,
        postalCode,
        country,
      },
      id,
    );

    return response(200, { address });
  } catch (error) {
    return response(500, { error });
  }
};
