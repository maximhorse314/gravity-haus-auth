import method from '../ca-participant';
import { constructSqsEvent } from '@gravity-haus/gh-common/dist/clients/aws/sns/constructSqsEvent';
import User from '@gravity-haus/gh-common/dist/models/user.model';
import Account from '@gravity-haus/gh-common/dist/models/account.model';
import Address from '@gravity-haus/gh-common/dist/models/address.model';
import GhStripe from '@gravity-haus/gh-common/dist/models/stripe.model';
import Phone from '@gravity-haus/gh-common/dist/models/phone.model';
import MembershipApplicationStatus from '@gravity-haus/gh-common/dist/models/membershipApplicationStatus.model';
import Participant from '@gravity-haus/gh-common/dist/models/participant.model';
import UserMembership from '@gravity-haus/gh-common/dist/models/userMembership.model';
import Subscription from '@gravity-haus/gh-common/dist/models/subscription.model';
import MembershipApplication from '@gravity-haus/gh-common/dist/models/membershipApplication.model';

import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import AwsSNSClient from '@gravity-haus/gh-common/dist/clients/aws/sns/aws-sns-client';

import { userFactory } from '../../../test-helpers/factories/user';
import { accountFactory } from '../../../test-helpers/factories/account';
import { subscriptionFactory } from '../../../test-helpers/factories/subscription';
import { membershipApplicationFactory } from '../../../test-helpers/factories/membershipApplication';

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

describe('sqs', () => {
  const planId = 'plan_gh_local_individual_steamboat_12_months_1296_pif10';

  let snsSpy;
  beforeEach(async () => {
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
        });
      });
    });
  });

  afterEach(async () => {
    await Promise.all([
      User.destroy({ where: {}, truncate: true }),
      Account.destroy({ where: {}, truncate: true }),
      Address.destroy({ where: {}, truncate: true }),
      GhStripe.destroy({ where: {}, truncate: true }),
      Phone.destroy({ where: {}, truncate: true }),
      MembershipApplicationStatus.destroy({ where: {}, truncate: true }),
      Participant.destroy({ where: {}, truncate: true }),
      UserMembership.destroy({ where: {}, truncate: true }),
      Subscription.destroy({ where: {}, truncate: true }),
      MembershipApplication.destroy({ where: {}, truncate: true }),
    ]);
  });

  it('creates family member accounts', async () => {
    const subscription = await subscriptionFactory.create({
      stripePlanId: planId,
    });

    await membershipApplicationFactory.create({ subscriptionId: subscription.dataValues.id });

    const accountOwner = await userFactory.create();
    const account = await accountFactory.create({
      userId: accountOwner.dataValues.id,
    });

    const member = {
      firstName: 'friend',
      lastName: 'guy',
      email: 'friend@guy.com',
      phoneNumber: '13037206669',
      countryCode: 'us',
      dateOfBirth: '1993-03-01',
    };

    const event = constructSqsEvent({
      member,
      address1: '123 cool st',
      postalCode: '80229',
      city: 'Denver',
      state: 'CO',
      accountOwnerId: account.dataValues.id,
      accountOwnerEmail: accountOwner.dataValues.email,
      planId: planId,
      subscriptionId: 'sub_123',
      customerId: 'cus_123',
    });

    await method(event);

    const users = await User.findAll({
      where: { email: member.email },
      include: [
        { model: GhStripe, as: 'stripe' },
        { model: MembershipApplicationStatus, as: 'membershipApplicationStatus' },
        { model: UserMembership, as: 'userMemberships' },
        { model: Participant, as: 'participant' },
        {
          model: Account,
          as: 'account',
          include: [
            { model: Phone, as: 'phone' },
            { model: Address, as: 'mailingAddress' },
          ],
        },
      ],
    });

    const user = users[0];

    expect(user.dataValues.participant.accountId).toEqual(account.dataValues.id);

    expect(`${user.dataValues.account.phone.number}`).toEqual('3037206669');
    expect(user.dataValues.account.mailingAddress.address1).toEqual('123 cool st');

    expect(user.dataValues.membershipApplicationStatus.stripeSubscriptionId).toEqual('sub_123');
    expect(user.dataValues.membershipApplicationStatus.status).toEqual('APPROVE');

    expect(user.dataValues.stripe.customerId).toEqual('cus_123');
    expect(user.dataValues.userMemberships[0].subscriptionId).toEqual(subscription.dataValues.id);

    expect(snsSpy.mock.calls).toEqual([['ca-hubspot', expect.anything()]]);

    const owner = await User.findByPk(accountOwner.dataValues.id, {
      include: [
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
      ],
    });
    expect(owner.dataValues.account.participants[0].user.id).toEqual(user.dataValues.id);
    expect(slack.chat.postMessage).toBeCalled();

    const sub = await Subscription.findOne({
      where: { stripePlanId: planId },
      include: [
        {
          model: MembershipApplication,
          as: 'membershipApplication',
        },
      ],
    });
    expect(user.dataValues.userMemberships[0].subscriptionId).toEqual(sub.dataValues.id);
    expect(user.membershipApplicationStatus.applicationId).toEqual(sub.membershipApplication.id);
  });

  it('reports an error to slack', async () => {
    jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
      return new Promise(() => {
        throw new Error('bad');
      });
    });

    try {
      const event = constructSqsEvent({
        member: [],
        address1: '123 cool st',
        postalCode: '80229',
        city: 'Denver',
        state: 'CO',
        accountOwnerId: '1',
        accountOwnerEmail: 'coo@cool.com',
        planId: planId,
        subscriptionId: 'sub_123',
        customerId: 'cus_123',
      });

      await method(event);
    } catch (error) {
      expect(slack.chat.postMessage).toBeCalled();
    }
  });
});
