import method from '../ca-participants';
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
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import HubspotClient from '@gravity-haus/gh-common/dist/hubspot-client/hubspot-client';
import AwsSNSClient from '@gravity-haus/gh-common/dist/clients/aws/sns/aws-sns-client';

import { userFactory } from '../../../test-helpers/factories/user';
import { accountFactory } from '../../../test-helpers/factories/account';

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

const mockHubspot = () => {
  jest.mock('@gravity-haus/gh-common/dist/hubspot-client/hubspot-client');
  const mock = jest.fn();
  HubspotClient.getInstance = () => ({
    createOrUpdateContactByEmail: mock,
  });
  return mock;
};

describe('sqs', () => {
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
    ]);
  });

  it('creates family member accounts', async () => {
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
      familyMembers: [member],
      address1: '123 cool st',
      postalCode: '80229',
      city: 'Denver',
      state: 'CO',
      accountOwnerId: account.dataValues.id,
      accountOwnerEmail: accountOwner.dataValues.email,
      planId: 'plan_gh_local_individual_steamboat_12_months_1296_pif10',
      subscriptionId: 'sub_123',
      customerId: 'cus_123',
    });

    await method(event);

    expect(snsSpy.mock.calls).toEqual([['ca-participant', expect.anything()]]);
  });

  it('reports an error to slack', async () => {
    jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
      return new Promise(() => {
        throw new Error('bad');
      });
    });

    try {
      const event = constructSqsEvent({
        familyMembers: [],
        address1: '123 cool st',
        postalCode: '80229',
        city: 'Denver',
        state: 'CO',
        accountOwnerId: '1',
        accountOwnerEmail: 'coo@cool.com',
        planId: 'plan_gh_local_individual_steamboat_12_months_1296_pif10',
        subscriptionId: 'sub_123',
        customerId: 'cus_123',
      });

      await method(event);
    } catch (error) {
      expect(slack.chat.postMessage).toBeCalled();
    }
  });
});
