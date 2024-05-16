import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import { compare } from 'bcryptjs';
import { sign } from 'jsonwebtoken';

import User from '@gravity-haus/gh-common/dist/models/user.model';

export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  try {
    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();

    const { email, password } = JSON.parse(event.body || '');

    Client.getInstance([User]);

    const user = await User.findOne({ where: { email } });
    const passwordCheck = await compare(password, `${user?.password}`);

    if (passwordCheck) {
      const token = sign(
        {
          id: user?.id,
          roleId: user?.roleId,
          email: user?.email,
        },
        `${process.env.JWT_SECRET_KEY}`,
        {
          expiresIn: '2 days',
        },
      );
      return response(200, { token });
    } else {
      return response(401, { message: 'Invalid Login credentials' });
    }
  } catch (error) {
    return response(500, { error });
  }
};
