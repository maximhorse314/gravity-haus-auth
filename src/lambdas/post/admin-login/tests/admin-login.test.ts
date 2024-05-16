import { Client } from '@gravity-haus/gh-common/dist/db/client';
import * as jwt from 'jsonwebtoken';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import method from '../admin-login';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';
import eventObj from './events/event';
import { userFactory } from '../../../../test-helpers/factories/user';
import User from '@gravity-haus/gh-common/dist/models/user.model';

describe('login function', () => {
  const email = 'dev@test.com';

  Client.getInstance([User]);

  beforeEach(async () => {
    jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
      return new Promise((resolve) => {
        return resolve({
          ...process.env,
        });
      });
    });
  });

  afterEach(async () => {
    // delete every this so we always start fresh
    await User.destroy({
      where: {},
      truncate: true,
    });
  });

  it('should return a 200 with a jwt token', async () => {
    const user = await userFactory.create({ email, roleId: 1 });

    const body = {
      email: user.dataValues.email,
      password: 'password',
    };
    const event = constructAPIGwEvent(eventObj(body));
    const result = await method(event);
    const { token } = JSON.parse(result.body);

    const decoded = (await jwt.verify(token, `${process.env.JWT_SECRET_KEY}`)) as jwt.JwtPayload;
    expect(decoded.email).toBe(email);
    expect(decoded.roleId).toBe(1);

    expect(result.statusCode).toBe(200);
  });

  it('should return a 401 invalid login', async () => {
    const user = await userFactory.create({ email, roleId: 2 });

    const body = {
      email: user.dataValues.email,
      password: 'password',
    };
    const event = constructAPIGwEvent(eventObj(body));
    const result = await method(event);
    const { message } = JSON.parse(result.body);

    expect(message).toBe('Invalid Login User Role');
    expect(result.statusCode).toBe(401);
  });

  it('should return a 401 invalid login when password is incorect', async () => {
    const user = await userFactory.create({ email, roleId: 2 });

    const body = {
      email: user.dataValues.email,
      password: 'bad',
    };
    const event = constructAPIGwEvent(eventObj(body));
    const result = await method(event);
    const { message } = JSON.parse(result.body);

    expect(message).toBe('Invalid Login credentials');
    expect(result.statusCode).toBe(401);
  });

  it('should return a 500 if we have an error', async () => {
    const event = constructAPIGwEvent(eventObj);
    const result = await method(event);

    expect(result.statusCode).toBe(500);
  });
});
