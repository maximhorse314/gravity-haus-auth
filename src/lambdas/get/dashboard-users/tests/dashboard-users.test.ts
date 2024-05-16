import method from '../dashboard-users';
import * as auth from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';

import Stripe from '@gravity-haus/gh-common/dist/models/stripe.model';
import User from '@gravity-haus/gh-common/dist/models/user.model';
import MembershipApplicationStatus from '@gravity-haus/gh-common/dist/models/membershipApplicationStatus.model';
import Account from '@gravity-haus/gh-common/dist/models/account.model';
import Participant from '@gravity-haus/gh-common/dist/models/participant.model';
import Address from '@gravity-haus/gh-common/dist/models/address.model';
import Phone from '@gravity-haus/gh-common/dist/models/phone.model';
import Subscription from '@gravity-haus/gh-common/dist/models/subscription.model';
import UserMembership from '@gravity-haus/gh-common/dist/models/userMembership.model';
import MembershipApplication from '@gravity-haus/gh-common/dist/models/membershipApplication.model';

import createAccount from '../../../../test-helpers/createAccount';
import createSubscriptionsAndApps from '../../../../test-helpers/createSubscriptionsAndApps';
import mockGetSecret from '../../../../test-helpers/mockGetSecret';

describe('function', () => {
  let subscriptions;
  beforeEach(async () => {
    ({ subscriptions } = await createSubscriptionsAndApps());
    mockGetSecret();
  });

  afterEach(async () => {
    await Promise.all([
      Stripe.destroy({ where: {}, truncate: true }),
      User.destroy({ where: {}, truncate: true }),
      MembershipApplication.destroy({ where: {}, truncate: true }),
      MembershipApplicationStatus.destroy({ where: {}, truncate: true }),
      Account.destroy({ where: {}, truncate: true }),
      Participant.destroy({ where: {}, truncate: true }),
      Address.destroy({ where: {}, truncate: true }),
      Phone.destroy({ where: {}, truncate: true }),
      UserMembership.destroy({ where: {}, truncate: true }),
      Subscription.destroy({ where: {}, truncate: true }),
    ]);
  });

  describe('success', () => {
    it('should return a 200 with all users', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const userOne = await createAccount({
        email: 'test1@gmail.com',
        stripeSubscriptionId: 'sub_1234',
        stripeCustomerId: 'cust_1234',
      });

      const userTwo = await createAccount({
        email: 'test2@gmail.com',
        stripeSubscriptionId: 'sub_56789',
        stripeCustomerId: 'cust_56789',
      });

      const event = constructAPIGwEvent({});
      const result = await method(event);

      expect(result.statusCode).toBe(200);
      const { users } = JSON.parse(result.body);

      expect(users.length).toEqual(2);
      expect(users.map((u) => u.email).includes(userOne.user.email)).toBe(true);
      expect(users.map((u) => u.email).includes(userTwo.user.email)).toBe(true);
    });

    it('should return a 200 and find a user by an id', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const userOne = await createAccount({
        email: 'test1@gmail.com',
        stripeSubscriptionId: 'sub_1234',
        stripeCustomerId: 'cust_1234',
      });

      const event = constructAPIGwEvent({ queryStringParameters: { id: userOne.user.dataValues.id } });
      const result = await method(event);
      expect(result.statusCode).toBe(200);
      const { users } = JSON.parse(result.body);

      expect(users.length).toEqual(1);
      const user = users[0];
      expect(user.email).toEqual(userOne.user.email);

      expect(user.id).toEqual(userOne.user.id);
      expect(user.account.id).toEqual(userOne.account.id);

      expect(user.stripeAccountOwner.id).toEqual(userOne.user.id);
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
