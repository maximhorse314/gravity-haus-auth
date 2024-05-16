import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import * as jwt from 'jsonwebtoken';

import login from '../login/login';

export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  try {
    const loginResponse = await login(event);
    if (loginResponse.statusCode !== 200) return loginResponse;

    const { token } = JSON.parse(loginResponse.body);
    const decoded = (await jwt.verify(token, `${process.env.JWT_SECRET_KEY}`)) as jwt.JwtPayload;

    if (decoded.roleId !== 1) {
      return response(401, { message: 'Invalid Login User Role' });
    }

    return response(200, { token });
  } catch (error) {
    return response(500, { error });
  }
};
