import { SQSEvent } from 'aws-lambda';

import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import { Client } from '@gravity-haus/gh-common/dist/db/client';

import createReferral from '../../lambdas/post/create-account/utils/create-referral';
import { reportToSlack } from '../../lambdas/post/create-account/utils/post-message-to-slack';

export default async (event: SQSEvent) => {
  const { Message } = JSON.parse(event.Records[0].body);
  const { recipientUser, referralName, stripePlanId, stripeToken } = JSON.parse(Message);

  try {
    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();

    Client.getInstance();

    await createReferral({
      recipientUser,
      referralName,
      stripePlanId,
      stripeToken,
    });

    return {};
  } catch (error) {
    await reportToSlack({
      header: 'Error Creating Referral Record',
      color: '#fc0328',
      slackChannel: 'C04MCJ93UA1',
      values: {
        newUserEmail: recipientUser.email,
        referralName: `${referralName}`,
        error: `${error}`,
      },
    });

    throw error;
  }
};
