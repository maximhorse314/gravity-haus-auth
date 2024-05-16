import method from '../add-family-member';
import * as auth from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import eventObj from './events/event';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';

import User from '@gravity-haus/gh-common/dist/models/user.model';
import Account from '@gravity-haus/gh-common/dist/models/account.model';
import Participant from '@gravity-haus/gh-common/dist/models/participant.model';
import GhStripe from '@gravity-haus/gh-common/dist/models/stripe.model';
import MembershipApplicationStatus from '@gravity-haus/gh-common/dist/models/membershipApplicationStatus.model';
import Address from '@gravity-haus/gh-common/dist/models/address.model';
import Subscription from '@gravity-haus/gh-common/dist/models/subscription.model';
import MembershipApplication from '@gravity-haus/gh-common/dist/models/membershipApplication.model';
import Phone from '@gravity-haus/gh-common/dist/models/phone.model';

import createAccount from '../../../../test-helpers/createAccount';
import mockHubspot from '../../../../test-helpers/mockHubspot';
import mockGetSecret from '../../../../test-helpers/mockGetSecret';

describe('add-family-member', () => {
  let hubspotMock;
  beforeEach(async () => {
    hubspotMock = mockHubspot('createOrUpdateContactByEmail');
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
    jest.setTimeout(10000000);
    it('should return a 200', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const owner = await createAccount({
        email: 'test@email.com',
        stripeSubscriptionId: 'sub_123',
        stripeCustomerId: 'cust_123',
      });

      const event = constructAPIGwEvent(
        eventObj({
          firstName: 'family',
          lastName: 'member',
          dateOfBirth: '1993-02-01',
          phoneNumber: '13037209905',
          phoneNumberCountryCode: '+1',
          email: 'member@email.com',
          accountId: owner.account.dataValues.id,
        }),
      );

      const result = await method(event);

      console.log('result', result);

      expect(result.statusCode).toBe(200);

      const account = await Account.findByPk(owner.account.dataValues.id, {
        include: [
          {
            model: Participant,
            as: 'participants',
            include: [
              {
                model: User,
                as: 'user',
                include: [
                  { model: Account, as: 'account' },
                  { model: GhStripe, as: 'stripe' },
                  { model: MembershipApplicationStatus, as: 'membershipApplicationStatus' },
                ],
              },
            ],
          },
        ],
      });

      expect(account.participants.length).toBe(2);

      const newMember = account.participants.find((p) => p.user.email === 'member@email.com');

      expect(newMember.firstName).toEqual('family');
      expect(newMember.lastName).toEqual('member');
      expect(newMember.user.stripe.customerId).toEqual('cust_123');
      expect(hubspotMock).toBeCalled();

      expect(newMember.user.membershipApplicationStatus.stripeSubscriptionId).toEqual('sub_123');
    });
  });

  describe('failure', () => {
    it('should throw 401 Unauthorized', async () => {
      const event = constructAPIGwEvent({});
      const result = await method(event);
      expect(result.statusCode).toBe(401);
      expect(result.body).toContain('Unauthorized');
    });

    it('should throw 404 when account is not found', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const event = constructAPIGwEvent(eventObj({ accountId: 90000 }));
      const result = await method(event);
      expect(result.statusCode).toBe(404);
      expect(result.body).toContain('Account Not Found');
    });

    it('should throw 500 when missing data', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const owner = await createAccount({
        email: 'test@email.com',
        stripeSubscriptionId: 'sub_123',
        stripeCustomerId: 'cust_123',
      });

      const event = constructAPIGwEvent(eventObj({ accountId: owner.account.dataValues.id }));
      const result = await method(event);
      expect(result.statusCode).toBe(500);
    });

    it('should throw error when its not the account holders account', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const owner = await createAccount({
        email: 'test@email.com',
        stripeSubscriptionId: 'sub_123',
        stripeCustomerId: 'cust_123',
      });

      const member = await createAccount({
        email: 'test@email.com',
        stripeSubscriptionId: 'sub_123',
        stripeCustomerId: 'cust_123',
        accountId: owner.account.dataValues.id,
      });

      const event = constructAPIGwEvent(
        eventObj({
          firstName: 'family',
          lastName: 'member',
          dateOfBirth: '1993-02-01',
          phoneNumber: '13037209905',
          phoneNumberCountryCode: '+1',
          email: 'member@email.com',
          accountId: member.account.dataValues.id,
        }),
      );

      const result = await method(event);

      expect(result.statusCode).toBe(400);
      expect(result.body).toContain('Only The Account Owner Can add a member to the account.');
    });
  });
});
