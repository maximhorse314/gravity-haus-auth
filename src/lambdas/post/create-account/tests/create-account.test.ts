import MockDate from 'mockdate';
import User from '@gravity-haus/gh-common/dist/models/user.model';
import Account from '@gravity-haus/gh-common/dist/models/account.model';
import Address from '@gravity-haus/gh-common/dist/models/address.model';
import GhStripe from '@gravity-haus/gh-common/dist/models/stripe.model';
import Phone from '@gravity-haus/gh-common/dist/models/phone.model';
import SignUpCouponPromotion from '@gravity-haus/gh-common/dist/models/signUpCouponPromotion.model';
import MembershipApplicationStatus from '@gravity-haus/gh-common/dist/models/membershipApplicationStatus.model';
import SignUpPhasePromotion from '@gravity-haus/gh-common/dist/models/signUpPhasePromotion.model';
import Referral from '@gravity-haus/gh-common/dist/models/referral.model';
import Subscription from '@gravity-haus/gh-common/dist/models/subscription.model';
import UserMembership from '@gravity-haus/gh-common/dist/models/userMembership.model';
import MembershipApplication from '@gravity-haus/gh-common/dist/models/membershipApplication.model';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import StripeClient from '@gravity-haus/gh-common/dist/clients/stripe-client/gh-stripe';
import AwsSNSClient from '@gravity-haus/gh-common/dist/clients/aws/sns/aws-sns-client';
import Participant from '@gravity-haus/gh-common/dist/models/participant.model';
import addMonthsToDate from '@gravity-haus/gh-common/dist/date/add-months-to-date/add-months-to-date';
import subtractMonthFromDate from '@gravity-haus/gh-common/dist/date/subtract-month-from-date/subtract-month-from-date';

import { userFactory } from '../../../../test-helpers/factories/user';
import { membershipApplicationStatusFactory } from '../../../../test-helpers/factories/membershipApplicationStatus';
import { accountFactory } from '../../../../test-helpers/factories/account';
import { stripeFactory } from '../../../../test-helpers/factories/stripe';
import { signUpCouponPromotionFactory } from '../../../../test-helpers/factories/signUpCouponPromotion';
import { signUpPhasePromotionFactory } from '../../../../test-helpers/factories/signUpPhasePromotion';
import { subscriptionFactory } from '../../../../test-helpers/factories/subscription';
import { membershipApplicationFactory } from '../../../../test-helpers/factories/membershipApplication';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';
import method from '../create-account';
import eventObj from './events/event';

import mockStripe from '../../../../test-helpers/mockStripe';

import { WebClient } from '@slack/web-api';
jest.mock('@slack/web-api', () => {
  const mockSlack = {
    chat: {
      postMessage: jest.fn(),
    },
  };
  return { WebClient: jest.fn(() => mockSlack) };
});

let slack: WebClient = new WebClient();

const newMember = {
  stripeToken: 'tok_1M32EXGuI3uPg2Uz8q0JmZHt',
  password: 'Ww123456',
  email: 'canceltest37@gravityhaus.com',
  firstName: 'buddy',
  lastName: 'guy',
  dateOfBirth: '1993-03-01',
  phoneNumber: '13037209905',
  phoneNumberCountryCode: 'us',
  address1: '123 cool st',
  city: 'Denver',
  state: 'CO',
  postalCode: '80229',
  familyMembers: [],
  // familyMembers: [
  //   {
  //     firstName: 'friend',
  //     lastName: 'guy',
  //     email: 'friend@guy.com',
  //     phoneNumber: '13037209905',
  //     countryCode: "us"
  //     dateOfBirth: '1993-03-01',
  //   },
  // ],

  // coupon: 'VAILHEALTH10',
  // coupon: '50OffOnce',
  // coupon: 'oNqbHOp5',
  coupon: '',
  referralName: '',
  stripePlanId: 'plan_gh_local_individual_breck_12_months_140',
};

const planIds = [
  'plan_gh_local_individual_steamboat_12_months_1296_pif10',
  'plan_gh_local_individual_steamboat_6_months_864_pif10',
  'plan_gh_local_individual_breck_12_months_140',
  'plan_gh_local_individual_steamboat_12_months_120',
  'plan_gh_local_individual_steamboat_6_months_160',
  'plan_gh_local_individual_steamboat_1_months_320',
  'plan_gh_local_individual_breck_12_months_140',
];

describe('create account function', () => {
  jest.setTimeout(10000000);
  let snsSpy;
  let dbSubs;
  beforeEach(async () => {
    mockStripe('getCustomersByIds', []);

    dbSubs = await Promise.all(planIds.map(async (plan) => subscriptionFactory.create({ stripePlanId: plan })));
    await Promise.all(
      dbSubs.map(async (s) => {
        return membershipApplicationFactory.create({ subscriptionId: s.dataValues.id });
      }),
    );

    snsSpy = jest.spyOn(AwsSNSClient.prototype, 'publish').mockImplementation(() => {
      return new Promise((resolve) => {
        return resolve({
          Message: JSON.stringify({ cool: 'stuff' }),
          MessageId: '123',
        });
      });
    });

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
    MockDate.reset();

    await Promise.all([
      User.destroy({ where: {}, truncate: true }),
      Account.destroy({ where: {}, truncate: true }),
      Address.destroy({ where: {}, truncate: true }),
      GhStripe.destroy({ where: {}, truncate: true }),
      Phone.destroy({ where: {}, truncate: true }),
      MembershipApplication.destroy({ where: {}, truncate: true }),
      MembershipApplicationStatus.destroy({ where: {}, truncate: true }),
      Participant.destroy({ where: {}, truncate: true }),
      SignUpCouponPromotion.destroy({ where: {}, truncate: true }),
      SignUpPhasePromotion.destroy({ where: {}, truncate: true }),
      Referral.destroy({ where: {}, truncate: true }),
      UserMembership.destroy({ where: {}, truncate: true }),
      Subscription.destroy({ where: {}, truncate: true }),
    ]);
  });

  const stripeCustomerId = 'cus_N3qbPcALPwNMoh';

  const makeData = async () => {
    const user = await userFactory.create({ email: `DEACTIVATED__${newMember.email}__12345` });

    const account = await accountFactory.create({
      userId: user.dataValues.id,
      firstName: 'firstName',
      lastName: 'lastName',
    });

    await stripeFactory.create({
      userId: user.dataValues.id,
      customerId: 'cus_N3qbPcALPwNMoh', // https://dashboard.stripe.com/test/customers/cus_N3qbPcALPwNMoh
    });

    const status = await membershipApplicationStatusFactory.create({
      userId: user.dataValues.id,
      status: 'CANCEL',
    });

    return {
      user,
      account,
      status,
    };
  };

  describe('success', () => {
    describe('gaurd', () => {
      it('gaurd for existing accounts and dup emails', async () => {
        const planData = (id) => {
          return {
            id,
            subscriptions: {
              data: [
                {
                  items: {
                    data: [
                      {
                        price: { id: planIds[0] },
                      },
                    ],
                  },
                },
              ],
            },
          };
        };

        const getCustomersByIdsSpy = mockStripe('getCustomersByIds', [
          planData('cus_N3qbPcALPwNMoh'),
          planData('cus_NFRBwmqksbdyN4'),
        ]);

        const user = await userFactory.create({ email: newMember.email });
        await stripeFactory.create({
          userId: user.dataValues.id,
          customerId: 'cus_N3qbPcALPwNMoh', // https://dashboard.stripe.com/test/customers/cus_N3qbPcALPwNMoh
        });

        const friendEmail = 'friend@guy.com';
        const friend = await userFactory.create({ email: friendEmail });
        await stripeFactory.create({
          userId: friend.dataValues.id,
          customerId: 'cus_NFRBwmqksbdyN4', // https://dashboard.stripe.com/test/customers/cus_N3qbPcALPwNMoh
        });

        const event = constructAPIGwEvent(
          eventObj({
            ...newMember,
            familyMembers: [
              {
                firstName: 'friend',
                lastName: 'guy',
                email: friendEmail,
                phoneNumber: '13037209905',
                countryCode: 'us',
                dateOfBirth: '1993-03-01',
              },
            ],
          }),
        );

        const result = await method(event);
        expect(result.statusCode).toBe(400);
        const body = JSON.parse(result.body);

        expect(body.error[0].email).toEqual(user.dataValues.email);
        expect(body.error[1].email).toEqual(friend.dataValues.email);

        expect(getCustomersByIdsSpy).toBeCalled();
      });

      it('gaurd for dup emails', async () => {
        const friendEmail = 'friend@guy.com';

        const e = constructAPIGwEvent(
          eventObj({
            ...newMember,
            email: friendEmail,
            familyMembers: [
              {
                firstName: 'friend',
                lastName: 'guy',
                email: friendEmail,
                phoneNumber: '13037209905',
                countryCode: 'us',
                dateOfBirth: '1993-03-01',
              },
            ],
          }),
        );
        const r = await method(e);
        const b = JSON.parse(r.body);
        expect(b.error[0].email).toEqual(friendEmail);
        expect(b.error[0].error).toEqual('All Member Emails Must Be Unique');
      });
    });

    it('should validate body', async () => {
      const event = constructAPIGwEvent(
        eventObj({
          ...newMember,
          firstName: '',
          lastName: '',
          email: '',
          phoneNumber: '',
          dateOfBirth: '',
          password: '',
          familyMembers: [
            {
              firstName: '',
              lastName: '',
              email: '',
              phoneNumber: '',
              countryCode: '',
              dateOfBirth: '',
            },
          ],
        }),
      );

      const result = await method(event);
      const { error } = JSON.parse(result.body);

      expect(error.firstName).toEqual('Required');
      expect(error.lastName).toEqual('Required');
      expect(error.email).toEqual('Required');
      expect(error.phoneNumber).toEqual('Invalid Phone Number');
      expect(error.password).toEqual('Required');
      expect(error.familyMembers.length).toEqual(1);
    });

    it('should apply a SignUpPhasePromotion', async () => {
      MockDate.set('1/03/2023');

      const pifStripePlanId = planIds[0];

      // coupon: 'VAILHEALTH10',
      // coupon: '50OffOnce',
      // coupon: 'oNqbHOp5',
      const coupon = '';

      await signUpPhasePromotionFactory.create({
        name: 'test',
        active: true,
        pif: true,
        freeMonths: 2,
        startDate: subtractMonthFromDate(new Date(), 1),
        endDate: addMonthsToDate(new Date(), 1),
        term: 12,
      });

      mockStripe('getPrice', {
        recurring: { interval: 'year', interval_count: 1 },
      });

      const updateCustomerSpy = mockStripe('updateCustomer', { id: stripeCustomerId });
      const createSubscriptionScheduleSpy = mockStripe('createSubscriptionSchedule', {
        id: 'ss_123',
        subscription: 'sub_123',
        customer: stripeCustomerId,
      });

      try {
        await makeData();
      } catch (error) {
        console.log('error', error);
      }

      const event = constructAPIGwEvent(eventObj({ ...newMember, stripePlanId: pifStripePlanId, coupon }));
      await method(event);

      expect(updateCustomerSpy).toHaveBeenCalledTimes(1);
      expect(createSubscriptionScheduleSpy).toBeCalled();
    });

    it('should apply a signUpCouponPromotion', async () => {
      MockDate.set('1/06/2023');
      const pifStripePlanId = planIds[0];

      // coupon: 'VAILHEALTH10',
      // coupon: '50OffOnce',
      // coupon: 'oNqbHOp5',
      const coupon = '';

      await signUpCouponPromotionFactory.create({
        name: 'test',
        active: true,
        pif: true,
        couponId: '20PercentOffOnce',
        startDate: subtractMonthFromDate(new Date(), 1),
        endDate: addMonthsToDate(new Date(), 1),
        term: 12,
      });

      mockStripe('getPrice', {
        recurring: { interval: 'year', interval_count: 1 },
      });

      const updateCustomerSpy = mockStripe('updateCustomer', { id: stripeCustomerId });
      const createSubscriptionScheduleSpy = mockStripe('createSubscriptionSchedule', {
        id: 'ss_123',
        subscription: 'sub_123',
        customer: stripeCustomerId,
      });

      await makeData();

      const event = constructAPIGwEvent(eventObj({ ...newMember, stripePlanId: pifStripePlanId, coupon }));
      await method(event);

      expect(updateCustomerSpy).toHaveBeenCalledTimes(2);
      expect(createSubscriptionScheduleSpy).toBeCalled();
    });

    it('should update an existing member and call sns for participants', async () => {
      MockDate.set('1/06/2023');
      const pifStripePlanId = planIds[0];

      // coupon: 'VAILHEALTH10',
      // coupon: '50OffOnce',
      // coupon: 'oNqbHOp5',
      const coupon = '';

      mockStripe('getPrice', {
        recurring: { interval: 'month', interval_count: 1 },
      });

      const updateCustomerSpy = mockStripe('updateCustomer', { id: stripeCustomerId });
      const createSubscriptionScheduleSpy = mockStripe('createSubscriptionSchedule', {
        id: 'ss_123',
        subscription: 'sub_123',
        customer: stripeCustomerId,
      });

      const { account, status, user } = await makeData();

      const referralName = 'isaac sunoo';
      const event = constructAPIGwEvent(
        eventObj({
          ...newMember,
          stripePlanId: pifStripePlanId,
          coupon,
          referralName,
        }),
      );
      const result = await method(event);

      expect(updateCustomerSpy).toBeCalled();
      expect(createSubscriptionScheduleSpy).toBeCalled();

      expect(result.statusCode).toBe(200);
      expect(JSON.parse(result.body).userId).toBe(user.id);

      const updatedUser = await User.findByPk(user.dataValues.id);
      expect(updatedUser.email).toEqual(newMember.email);

      const updatedAccount = await Account.findByPk(account.dataValues.id);
      expect(updatedAccount.firstName).toEqual(newMember.firstName);

      const updatedStatus = await MembershipApplicationStatus.findByPk(status.dataValues.id);
      expect(updatedStatus.status).toEqual('APPROVE');

      expect(snsSpy.mock.calls).toEqual([
        ['ca-hubspot', expect.anything()],
        ['ca-referral', expect.anything()],
      ]);
    });

    it('should create new member when does not exist', async () => {
      mockStripe('getPrice', {
        recurring: { interval: 'month', interval_count: 1 },
      });

      const createCustomerSpy = mockStripe('createCustomer', { id: stripeCustomerId });
      const createSubscriptionScheduleSpy = mockStripe('createSubscriptionSchedule', {
        id: 'ss_123',
        subscription: 'sub_123',
        customer: stripeCustomerId,
      });

      const member = {
        ...newMember,
        stripePlanId: planIds[0],
        familyMembers: [
          {
            firstName: 'friend',
            lastName: 'guy',
            email: 'friend@guy.com',
            phoneNumber: '13037209905',
            countryCode: 'us',
            dateOfBirth: '1993-03-01',
          },
        ],
      };

      const event = constructAPIGwEvent(eventObj(member));
      const result = await method(event);
      expect(result.statusCode).toBe(200);

      const body = JSON.parse(result.body);

      const user = await User.findByPk(body.userId, {
        include: [
          { model: GhStripe, as: 'stripe' },
          {
            model: Account,
            as: 'account',
            include: [
              {
                model: Participant,
                as: 'participants',
                include: [
                  {
                    model: User,
                    as: 'user',
                  },
                ],
              },
            ],
          },
          {
            model: MembershipApplicationStatus,
            as: 'membershipApplicationStatus',
            include: [
              {
                model: MembershipApplication,
                as: 'membershipApplication',
                include: [
                  {
                    model: Subscription,
                    as: 'subscription',
                  },
                ],
              },
            ],
          },
          { model: UserMembership, as: 'userMemberships' },
        ],
      });

      expect(user.account.participants.length).toEqual(1);
      expect(user.account.participants[0].userId).toEqual(user.id);
      expect(user.account.id).toEqual(user.account.participants[0].accountId);

      expect(createCustomerSpy).toBeCalled();
      expect(createSubscriptionScheduleSpy).toBeCalled();

      const sub = await Subscription.findOne({
        where: { stripePlanId: planIds[0] },
        include: [
          {
            model: MembershipApplication,
            as: 'membershipApplication',
          },
        ],
      });
      expect(user.dataValues.userMemberships[0].subscriptionId).toEqual(sub.dataValues.id);
      expect(user.membershipApplicationStatus.applicationId).toEqual(sub.membershipApplication.id);

      expect(user.email).toEqual(member.email);
      expect(user.account.firstName).toEqual(member.firstName);
      expect(user.account.lastName).toEqual(member.lastName);
      expect(user.membershipApplicationStatus.userId).toEqual(user.id);

      expect(slack.chat.postMessage).toBeCalled();

      expect(snsSpy.mock.calls).toEqual([
        ['ca-hubspot', expect.anything()],
        ['ca-participants', expect.anything()],
      ]);
    });
  });

  describe('failure', () => {
    it('will post an error to slack when fails', async () => {
      // throw error when trying to create customer in stipe
      jest.spyOn(StripeClient.prototype, 'createCustomer').mockImplementation((): Promise<any> => {
        return new Promise(() => {
          throw new Error('bad');
        });
      });

      const event = constructAPIGwEvent(eventObj(newMember));
      const result = await method(event);
      expect(result.statusCode).toBe(500);
      expect(slack.chat.postMessage).toBeCalled();
    });
  });
});
