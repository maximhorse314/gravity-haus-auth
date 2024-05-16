import { SQSEvent } from 'aws-lambda';
import { v4 as uuidv4 } from 'uuid';
import AwsSNSClient from '@gravity-haus/gh-common/dist/clients/aws/sns/aws-sns-client';
import parseGHPlan from '@gravity-haus/gh-common/dist/parse-gh-plan/parse-gh-plan';
import capitalizeFirstLetter from '@gravity-haus/gh-common/dist/capitalize-first-letter/capitalize-first-letter';

import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import upsertUserAccountData from '../../lambdas/post/create-account/utils/upsert-user-account-data';
import { ghStripeUpsert } from '../../utils/upsert-stripe/upsert-stripe';
import { reportToSlack } from '../../lambdas/post/create-account/utils/post-message-to-slack';
import grantAccess from '../../lambdas/post/create-account/utils/grant-access';
import getMembershiptType from '../../lambdas/post/create-account/utils/getMembershipType';

const sendToCaHubsopt = async (data: {
  address1: string;
  postalCode: string;
  city: string;
  state: string;
  planId: string;
  accountOwnerEmail: string;
  member: any;
}) => {
  const { address1, postalCode, city, state, planId, accountOwnerEmail, member } = data;

  const sns = AwsSNSClient.getInstance();

  return sns.publish(
    'ca-hubspot',
    JSON.stringify({
      address1,
      postalCode,
      city,
      state,
      childAccount: 'Yes',
      parentAccount: accountOwnerEmail,
      planId,
      email: member.email,
      firstName: member.firstName,
      lastName: member.lastName,
      dateOfBirth: member.dateOfBirth,
      phoneNumber: member.phoneNumber,
      referralCode: '',
      memberCode: '',
      groupCode: '',
    }),
  );
};

export default async (event: SQSEvent) => {
  const { Message } = JSON.parse(event.Records[0].body);
  const {
    member,
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
    Client.getInstance();

    const memberData = {
      ...member,
      address1,
      postalCode,
      city,
      state,
      accountOwnerId,
      planId,
      password: uuidv4(),
    };

    const user = await upsertUserAccountData(memberData);

    await Promise.all([
      grantAccess(user, subscriptionId, planId),
      ghStripeUpsert(user.id, customerId),
      sendToCaHubsopt({
        address1,
        postalCode,
        city,
        state,
        accountOwnerEmail,
        planId,
        member,
      }),
    ]);

    await reportToSlack({
      header: 'New Family Member Member Created',
      color: '#026b43',
      slackChannel: 'C04M10W4TMM',
      values: {
        name: `${capitalizeFirstLetter(member.firstName)} ${capitalizeFirstLetter(member.lastName)}`,
        membershipType: getMembershiptType(planId),
        pifOrMonthly: planId.includes('pif') ? 'PIF' : 'Monthly',
        email: user.email,
        phoneNumber: member.phoneNumber,
        city,
        accountOwnerEmail,
        stripePlanId: planId,
        customerId,
      },
    });

    return {};
  } catch (error) {
    await reportToSlack({
      header: 'New Family Member Member Error',
      color: '#fc0328',
      slackChannel: 'C04MCJ93UA1',
      values: {
        name: `${member.firstName} ${member.lastName}`,
        email: member.email,
        stripePlanId: planId,
        message: `${error}`,
        accountOwner: accountOwnerEmail,
      },
    });

    throw error;
  }
};
