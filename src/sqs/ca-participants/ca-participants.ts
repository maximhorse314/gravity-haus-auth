import { SQSEvent } from 'aws-lambda';

import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import AwsSNSClient from '@gravity-haus/gh-common/dist/clients/aws/sns/aws-sns-client';

import { reportToSlack } from '../../lambdas/post/create-account/utils/post-message-to-slack';

export default async (event: SQSEvent) => {
  const { Message } = JSON.parse(event.Records[0].body);
  const {
    familyMembers,
    address1,
    postalCode,
    city,
    state,
    accountOwnerId,
    accountOwnerEmail,
    planId,
    subscriptionId,
    customerId,
  } = JSON.parse(Message);

  try {
    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();

    const sns = AwsSNSClient.getInstance();
    Client.getInstance();

    await Promise.all(
      familyMembers.map(async (member) => {
        return sns.publish(
          'ca-participant',
          JSON.stringify({
            member,
            email: member.email.toLowerCase(),
            address1,
            postalCode,
            city,
            state,
            accountOwnerId,
            accountOwnerEmail,
            planId,
            subscriptionId,
            customerId,
          }),
        );
      }),
    );

    return {};
  } catch (error) {
    await reportToSlack({
      header: 'New Family Member Member Error',
      pretext: 'Error Creating One Or More Accounts',
      values: {
        accountOwner: accountOwnerEmail,
        emails: `${familyMembers.map((x) => x.email).join(' ')}`,
        message: `${error}`,
      },
      color: '#fc0328',
    });

    throw error;
  }
};
