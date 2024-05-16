import { Client } from '@gravity-haus/gh-common/dist/db/client';
import * as jwt from 'jsonwebtoken';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import method from '../login';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';
import eventObj from './events/event';
import invalidLogin from './events/invalid-login';
import { userFactory } from '../../../../test-helpers/factories/user';
import User from '@gravity-haus/gh-common/dist/models/user.model';

describe('login function', () => {
  const email = 'dev@test.com';

  Client.getInstance([User]);

  beforeEach(async () => {
    await userFactory.create({ email });

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
    const event = constructAPIGwEvent(eventObj);
    const result = await method(event);
    const { token } = JSON.parse(result.body);

    const decoded = (await jwt.verify(token, `${process.env.JWT_SECRET_KEY}`)) as jwt.JwtPayload;
    expect(decoded.email).toBe(email);
    expect(result.statusCode).toBe(200);
  });

  it('should return a 401 invalid login', async () => {
    const event = constructAPIGwEvent(invalidLogin);
    const result = await method(event);
    const { message } = JSON.parse(result.body);

    expect(message).toBe('Invalid Login credentials');
    expect(result.statusCode).toBe(401);
  });

  it('should return a 500 if we have an error', async () => {
    const event = constructAPIGwEvent({});
    const result = await method(event);

    expect(result.statusCode).toBe(500);
  });
});
