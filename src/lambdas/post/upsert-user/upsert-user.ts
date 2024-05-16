import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import verifyToken from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import User from '@gravity-haus/gh-common/dist/models/user.model';
import { genSalt, hash } from 'bcryptjs';
import { v4 as uuidv4 } from 'uuid';

import removeUndefinedKeysFromObject from '@gravity-haus/gh-common/dist/validator/removeUndefinedKeysFromObject';

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
    const { id, email, password, roleId, lastActivityDate } = body;

    let hashPassword;
    if (password) {
      const salt = await genSalt(10);
      hashPassword = await hash(password, salt);
    }

    const fields = removeUndefinedKeysFromObject({
      password: hashPassword || undefined,
      email,
      roleId,
      lastActivityDate,
    });

    let user = await User.findByPk(id);

    if (user === null) {
      if (!fields.email || !fields.password)
        return response(404, {
          error: {
            message: 'Missing Required Fields To Create User',
            email: `${fields.email}`,
            password: `${fields.password}`,
          },
        });

      user = await User.create({
        uuid: uuidv4(),
        ...fields,
      });
    } else {
      user = await user.update(fields);
    }

    return response(200, { user: { ...user.dataValues, password: '***' } });
  } catch (error) {
    return response(500, { error });
  }
};
