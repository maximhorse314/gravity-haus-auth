import method from '../remove-family-member';
import * as auth from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import * as cancelAll from '@gravity-haus/gh-common/dist/utils/cancel-all/cancel-all';

import User from '@gravity-haus/gh-common/dist/models/user.model';
import Account from '@gravity-haus/gh-common/dist/models/account.model';
import Participant from '@gravity-haus/gh-common/dist/models/participant.model';
import GhStripe from '@gravity-haus/gh-common/dist/models/stripe.model';
import MembershipApplicationStatus from '@gravity-haus/gh-common/dist/models/membershipApplicationStatus.model';
import Address from '@gravity-haus/gh-common/dist/models/address.model';
import Subscription from '@gravity-haus/gh-common/dist/models/subscription.model';
import MembershipApplication from '@gravity-haus/gh-common/dist/models/membershipApplication.model';
import Phone from '@gravity-haus/gh-common/dist/models/phone.model';

import eventObj from './events/event';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';
import createAccount from '../../../../test-helpers/createAccount';
import mockGetSecret from '../../../../test-helpers/mockGetSecret';

describe('function', () => {
  let mockCancelAll;
  beforeEach(async () => {
    mockCancelAll = jest.spyOn(cancelAll, 'cancelAll').mockReturnValue('');
    mockGetSecret();
  });

  afterEach(async () => {
    await Promise.all([
      Account.destroy({ where: {}, truncate: true }),
      Participant.destroy({ where: {}, truncate: true }),
      Phone.destroy({ where: {}, truncate: true }),
      Address.destroy({ where: {}, truncate: true }),
      User.destroy({ where: {}, truncate: true }),
      GhStripe.destroy({ where: {}, truncate: true }),
      MembershipApplicationStatus.destroy({ where: {}, truncate: true }),
      MembershipApplication.destroy({ where: {}, truncate: true }),
      Subscription.destroy({ where: {}, truncate: true }),
    ]);
  });

  describe('success', () => {
    it('should return a 200', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const owner = await createAccount({
        email: 'test@email.com',
        stripeSubscriptionId: 'sub_123',
        stripeCustomerId: 'cust_123',
      });

      const event = constructAPIGwEvent(
        eventObj({
          userId: owner.user.dataValues.id,
          accountId: owner.account.dataValues.id,
        }),
      );

      const result = await method(event);

      expect(result.statusCode).toBe(200);
      expect(mockCancelAll).lastCalledWith([owner.user.dataValues.id], expect.anything());

      const account = await Account.findByPk(owner.account.dataValues.id, {
        include: [{ model: Participant, as: 'participants' }],
      });

      expect(account.participants.length).toBe(0);
    });
  });

  describe('failure', () => {
    it('should throw 401 Unauthorized', async () => {
      const event = constructAPIGwEvent({});
      const result = await method(event);
      expect(result.statusCode).toBe(401);
      expect(result.body).toContain('Unauthorized');
    });

    it('should throw 400 when Missing Required Parameters', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const event = constructAPIGwEvent(eventObj({}));
      const result = await method(event);
      expect(result.statusCode).toBe(400);

      const { error } = JSON.parse(result.body);
      const { message, userId, accountId } = error;
      expect(message).toContain('Missing Required Parameters');
      expect(userId).toBe('undefined');
      expect(accountId).toBe('undefined');
    });
  });
});
