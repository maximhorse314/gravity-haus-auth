import method from '../upsert-user';
import * as auth from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import eventObj from './events/event';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';

import User from '@gravity-haus/gh-common/dist/models/user.model';
import { userFactory } from '../../../../test-helpers/factories/user';
import { compare } from 'bcryptjs';
import mockGetSecret from '../../../../test-helpers/mockGetSecret';

describe('function', () => {
  beforeEach(async () => {
    mockGetSecret();
  });

  afterEach(async () => {
    await Promise.all([User.destroy({ where: {}, truncate: true })]);
  });

  describe('success', () => {
    it('should return a 200 and create a user rec', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const event = constructAPIGwEvent(
        eventObj({
          password: 'password',
          email: 'email@email.com',
          roleId: 1,
        }),
      );

      const result = await method(event);

      expect(result.statusCode).toBe(200);

      const body = JSON.parse(result.body);
      const newUser = await User.findByPk(body.user.id);
      expect(newUser.email).toEqual('email@email.com');

      const passwordCheck = await compare('password', `${newUser?.password}`);
      expect(passwordCheck).toBe(true);
    });

    it('should return a 200 and update a user rec', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const currentuser = await userFactory.create();

      const event = constructAPIGwEvent(
        eventObj({
          roleId: 2,
          id: currentuser.dataValues.id,
        }),
      );
      const result = await method(event);

      expect(result.statusCode).toBe(200);

      const body = JSON.parse(result.body);
      const userById = await User.findByPk(body.user.id);
      expect(userById.roleId).toEqual(2);

      // check that the password has not been changed
      const passwordCheck = await compare('password', `${userById?.password}`);
      expect(passwordCheck).toBe(true);
    });
  });

  describe('failure', () => {
    it('should throw 401 Unauthorized', async () => {
      const event = constructAPIGwEvent({});
      const result = await method(event);
      expect(result.statusCode).toBe(401);
      expect(result.body).toContain('Unauthorized');
    });
  });
});
