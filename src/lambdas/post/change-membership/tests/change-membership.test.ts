import method from '../change-membership';
import * as auth from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import eventObj from './events/event';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';

import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import * as cancelAll from '@gravity-haus/gh-common/dist/utils/cancel-all/cancel-all';

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

import HttpRequestMock from 'http-request-mock';

import { participantFactory } from '../../../../test-helpers/factories/participant';

import createAccount from '../../../../test-helpers/createAccount';
import createSubscriptionsAndApps from '../../../../test-helpers/createSubscriptionsAndApps';

import mockStripe from '../../../../test-helpers/mockStripe';
import mockHubspot from '../../../../test-helpers/mockHubspot';

// test subs and accounts
const stripeSubscriptionId = 'sub_1MZPZKGuI3uPg2UzfRYXe0to';
const stripeCustomerId = 'cus_NK3gjOkgu0tdDu';

const planIds = [
  'plan_gh_local_individual_steamboat_12_months_1296_pif10',
  'plan_gh_local_individual_steamboat_6_months_864_pif10',
  'plan_gh_local_individual_breck_12_months_140',
  'plan_gh_local_individual_steamboat_12_months_120',
  'plan_gh_local_individual_steamboat_6_months_160',
  'plan_gh_local_individual_steamboat_1_months_320',
  'plan_gh_local_individual_breck_12_months_140',
  'plan_gh_local_family_winterpark_12_months_2496_pif',
];

const mockGetCustomerById = (planId: string) => {
  return mockStripe('getCustomerById', {
    id: stripeCustomerId,
    subscriptions: {
      data: [
        {
          id: 'sub_123',
          items: {
            data: [
              {
                price: {
                  id: planId,
                },
              },
            ],
          },
        },
      ],
    },
  });
};

describe('function', () => {
  jest.setTimeout(10000000);

  let hubspotMock;
  let getCustomerByIdMock;
  let mockGetPrices;
  let mockCancelSubscription;
  let mockCreateSubscriptionSchedule;
  let dbSubs;
  let mockCancelAll;
  let mocker;

  beforeEach(async () => {
    mockCancelAll = jest.spyOn(cancelAll, 'cancelAll').mockReturnValue('');

    mockGetPrices = mockStripe('getPrice', { recurring: { interval: 'year', interval_count: 1 } });
    getCustomerByIdMock = mockGetCustomerById('plan_gh_local_individual_steamboat_12_months_1296_pif10');
    mockCancelSubscription = mockStripe('cancelSubscription', {});
    mockCreateSubscriptionSchedule = mockStripe('createSubscriptionSchedule', {
      id: 'ss_123',
      subscription: 'sub_123',
      customer: stripeCustomerId,
    });

    mocker = HttpRequestMock.setup();

    mocker.mock({
      url: 'https://api.stripe.com/v1/coupons/',
      method: 'get',
      status: 200,
      body: {
        id: '123',
        object: 'coupon',
        valid: true,
      },
    });

    hubspotMock = mockHubspot('createOrUpdateContactByEmail');

    const subData = await createSubscriptionsAndApps(planIds);
    dbSubs = subData.subscriptions;

    jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
      return new Promise((resolve) => {
        return resolve({
          ...process.env,
          STRIPE_API_KEY: process.env.STRIPE_API_KEY || 'API_KEY',
        });
      });
    });
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
    it('should return a 200', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const accountHolderEmail = 'test99@test.com';
      const accountHolder = await createAccount({
        email: `DEACTIVATED__${accountHolderEmail}__123123`,
        stripeSubscriptionId: stripeSubscriptionId,
        stripeCustomerId: stripeCustomerId,
      });
      const familyMember = await createAccount({
        email: 'familyMember@test.com',
        stripeSubscriptionId: stripeSubscriptionId,
        stripeCustomerId: stripeCustomerId,
      });

      await participantFactory.create({
        userId: familyMember.user.dataValues.id,
        accountId: accountHolder.account.dataValues.id,
      });

      const event = constructAPIGwEvent(
        eventObj({
          email: accountHolderEmail,
          c1: false,
          coupon: 'PIFONEMONTOFF',
          // planId: 'plan_gh_local_individual_steamboat_6_months_864_pif10',
          planId: 'plan_gh_local_family_winterpark_12_months_2496_pif',
        }),
      );
      const result = await method(event);
      expect(getCustomerByIdMock).toBeCalledWith(stripeCustomerId);
      expect(mockCancelSubscription).toBeCalledWith('sub_123', { prorate: false });
      expect(mockCreateSubscriptionSchedule).toBeCalled();
      expect(mockGetPrices).toBeCalled();
      expect(hubspotMock).toBeCalled();

      expect(result.statusCode).toBe(200);
    });
  });

  describe('failure', () => {
    it('should return 404 when invalid coupon is passed', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');
      mocker.mock({
        url: 'https://api.stripe.com/v1/coupons/',
        method: 'get',
        status: 200,
        body: {
          id: '123',
          object: 'coupon',
          valid: false,
        },
      });

      const event = constructAPIGwEvent(
        eventObj({
          email: 'test@test.com',
          c1: false,
          coupon: 'PIFONEMONTOFF',
          planId: 'plan_gh_local_family_winterpark_12_months_2496_pif',
        }),
      );

      const result = await method(event);
      expect(result.body).toContain('Invalid Coupon');
      expect(result.statusCode).toBe(404);
    });

    it('should throw 401 Unauthorized', async () => {
      const event = constructAPIGwEvent({});
      const result = await method(event);
      expect(result.statusCode).toBe(401);
      expect(result.body).toContain('Unauthorized');
    });

    it('should throw error when its not the account holders account', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const owner = await createAccount({
        email: 'owner@email.com',
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
          email: member.user.dataValues.email,
          c1: false,
          coupon: 'PIFONEMONTOFF',
          planId: 'plan_gh_local_family_winterpark_12_months_2496_pif',
        }),
      );

      const result = await method(event);

      expect(result.statusCode).toBe(400);
      expect(result.body).toContain('Only The Account Owner Can Change A Membership.');
    });
  });
});
