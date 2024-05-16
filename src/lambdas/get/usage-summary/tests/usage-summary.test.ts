import method from '../usage-summary';
import * as auth from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';
import mockGetSecret from '../../../../test-helpers/mockGetSecret';

import User from '@gravity-haus/gh-common/dist/models/user.model';
import { userFactory } from '../../../../test-helpers/factories/user';

describe('function', () => {
  beforeEach(async () => {
    mockGetSecret();
  });

  afterEach(async () => {
    await Promise.all([User.destroy({ where: {}, truncate: true })]);
  });

  describe('success', () => {
    it('should return a 200', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const userF = await userFactory.create({});

      const event = constructAPIGwEvent({ queryStringParameters: { id: userF.dataValues.id } });
      const result = await method(event);
      const { user } = JSON.parse(result.body);

      expect(result.statusCode).toBe(200);
      expect(user.id).toBe(userF.dataValues.id);
      expect(user.password).toBe(undefined);
    });
  });

  describe('failure', () => {
    it('should throw 401 Unauthorized', async () => {
      const event = constructAPIGwEvent({});
      const result = await method(event);
      expect(result.statusCode).toBe(401);
      expect(result.body).toContain('Unauthorized');
    });

    it('should throw 500 missing id', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const event = constructAPIGwEvent({});
      const result = await method(event);
      expect(result.statusCode).toBe(500);
    });
  });
});
