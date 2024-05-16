import method from '../upsert-account';
import * as auth from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import eventObj from './events/event';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';

import Account from '@gravity-haus/gh-common/dist/models/account.model';
import { accountFactory } from '../../../../test-helpers/factories/account';
import mockGetSecret from '../../../../test-helpers/mockGetSecret';

describe('function', () => {
  beforeEach(async () => {
    mockGetSecret();
  });

  afterEach(async () => {
    await Promise.all([Account.destroy({ where: {}, truncate: true })]);
  });

  describe('success', () => {
    it('should return a 200 and create a phone rec', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const event = constructAPIGwEvent(
        eventObj({
          firstName: 'firstName',
          lastName: 'lastName',
          dateOfBirth: '1993-03-01',
        }),
      );

      const result = await method(event);

      expect(result.statusCode).toBe(200);

      const body = JSON.parse(result.body);
      const newAccount = await Account.findByPk(body.account.id);
      expect(newAccount.firstName).toEqual('firstName');
      expect(newAccount.lastName).toEqual('lastName');
      expect(newAccount.dateOfBirth).toEqual('1993-03-01');
      expect(newAccount.preferredLocation).toEqual('Unspecified');
      expect(newAccount.preferredIntensity).toEqual('Medium');
      expect(newAccount.verified).toEqual(1);
    });

    it('should return a 200 and update a phone rec', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const currentAccount = await accountFactory.create({});

      const event = constructAPIGwEvent(
        eventObj({
          firstName: 'wasd',
          id: currentAccount.dataValues.id,
        }),
      );
      const result = await method(event);

      expect(result.statusCode).toBe(200);

      const body = JSON.parse(result.body);
      const accountById = await Account.findByPk(body.account.id);
      expect(accountById.firstName).toEqual('wasd');
      expect(accountById.lastName).toEqual(currentAccount.lastName);
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
