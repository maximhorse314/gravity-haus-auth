import { SQSEvent } from 'aws-lambda';

import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import upsertHubspotContact from '../../lambdas/post/create-account/utils/upsert-hubspot-contact';

import { reportToSlack } from '../../lambdas/post/create-account/utils/post-message-to-slack';

const fixEmails = (email) => {
  let cleanEmail = email;

  const replaceList = {
    '.ckm': '.com',
  };

  Object.keys(replaceList).forEach((x) => (cleanEmail = email.replace(x, replaceList[x])));

  return cleanEmail;
};

export default async (event: SQSEvent) => {
  const { Message } = JSON.parse(event.Records[0].body);

  const {
    email,
    firstName,
    lastName,
    dateOfBirth,
    phoneNumber,
    address1,
    postalCode,
    city,
    state,
    familyMembers,
    planId,
    memberCode,
    groupCode,
    referralCode,
    childAccount,
    parentAccount,
  } = JSON.parse(Message);

  try {
    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();

    Client.getInstance();

    await upsertHubspotContact({
      email: fixEmails(email),
      firstName,
      lastName,
      dateOfBirth,
      phoneNumber,
      address1,
      postalCode,
      city,
      state,
      familyMembers,
      planId,
      memberCode,
      groupCode,
      referralCode,
      childAccount,
      parentAccount,
    });

    return {};
  } catch (error) {
    await reportToSlack({
      header: 'Hubspot Error',
      pretext: 'Error creating or updating Record in hubspot',
      slackChannel: 'C04MCJ93UA1',
      values: {
        name: `${firstName} ${lastName}`,
        email: `${email}`,
        message: `${error} ${JSON.stringify(error?.response?.data)}`,
      },
      color: '#fc0328',
    });
    throw error;
  }
};
