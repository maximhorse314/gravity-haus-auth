import method from '../ca-referral';
import { constructSqsEvent } from '@gravity-haus/gh-common/dist/clients/aws/sns/constructSqsEvent';
import User from '@gravity-haus/gh-common/dist/models/user.model';
import Referral from '@gravity-haus/gh-common/dist/models/referral.model';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import { userFactory } from '../../../test-helpers/factories/user';

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

describe('sqs ca-referral', () => {
  beforeEach(async () => {
    jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
      return new Promise((resolve) => {
        return resolve({
          ...process.env,
        });
      });
    });
  });

  afterEach(async () => {
    await Promise.all([Referral.destroy({ where: {}, truncate: true }), User.destroy({ where: {}, truncate: true })]);
  });

  it('creates a referral', async () => {
    const user = await userFactory.create();
    const event = constructSqsEvent({
      recipientUser: user.dataValues,
      referralName: 'ricky bobby',
      stripePlanId: 'plan_gh_local_individual_steamboat_12_months_1296_pif10',
      stripeToken: 'tok_123',
    });

    await method(event);

    const referrals = await Referral.findAll({
      where: {
        recipientUserId: user.dataValues.id,
      },
    });

    expect(referrals[0].recipientEmail).toEqual(user.dataValues.email);
  });

  it('reports an error to slack', async () => {
    jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
      return new Promise(() => {
        throw new Error('bad');
      });
    });

    const user = await userFactory.create();
    const event = constructSqsEvent({
      recipientUser: user.dataValues,
      referralName: 'ricky bobby',
      stripePlanId: 'plan_gh_local_individual_steamboat_12_months_1296_pif10',
      stripeToken: 'tok_123',
    });

    try {
      await method(event);
    } catch (error) {
      expect(slack.chat.postMessage).toBeCalled();
    }
  });
});
