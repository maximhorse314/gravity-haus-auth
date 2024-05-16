import method from '../ca-hubspot';
import { constructSqsEvent } from '@gravity-haus/gh-common/dist/clients/aws/sns/constructSqsEvent';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import HubspotClient from '@gravity-haus/gh-common/dist/hubspot-client/hubspot-client';

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
  let hubspotMock;
  beforeEach(async () => {
    hubspotMock = mockHubspot();
    jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
      return new Promise((resolve) => {
        return resolve({
          ...process.env,
        });
      });
    });
  });

  it('should call hubspot', async () => {
    const event = constructSqsEvent({
      email: 'apjames93@gmail.com',
      firstName: 'Alex',
      lastName: 'James',
      dateOfBirth: '1993-03-01',
      phoneNumber: '13031231234',
      // phoneNumberCountryCode,
      address1: '123 cool st',
      city: 'Denver',
      state: 'CO',
      postalCode: '80229',
      familyMembers: [],
      // plan_gh_allin_individual_anylocation_12_months_1
      // plan_gh_allin_family_anylocation_6_months_1
      // plan_gh_traveler_individual_anylocation_12_months_1
      // plan_gh_traveler_family_anylocation_12_months_1
      // plan_gh_local_family_truckee_12_months_1
      // plan_gh_local_individual_winterpark_12_months_1
      // plan_gh_traveler_individual_anylocation_6_months_1_pif // ??

      planId: 'plan_gh_local_individual_denver_1_months_1',
      groupCode: 'CODE',
      memberCode: '',
      referralName: 'Tom Chikoore',
    });
    await method(event);
    expect(hubspotMock).toBeCalled();
  });

  it('report error to slack when thrown ', async () => {
    jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
      return new Promise(() => {
        throw new Error('bad');
      });
    });

    const event = constructSqsEvent({
      email: 'test@test.com',
      firstName: 'cool',
      lastName: 'guy',
      dateOfBirth: '2000-01-05',
      phoneNumber: '13037209905',
      // phoneNumberCountryCode,
      address1: '123 cool st',
      city: 'Denver',
      state: 'CO',
      postalCode: '80229',
      familyMembers: [],
      planId: 'plan_123',
    });

    try {
      await method(event);
    } catch (error) {
      expect(slack.chat.postMessage).toBeCalled();
    }
  });
});
