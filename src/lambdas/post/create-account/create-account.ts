import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import AwsSNSClient from '@gravity-haus/gh-common/dist/clients/aws/sns/aws-sns-client';
import capitalizeFirstLetter from '@gravity-haus/gh-common/dist/capitalize-first-letter/capitalize-first-letter';

import registerAccount from './utils/register-account';
import validateData from './utils/validateData';
import checkForExistingActiveAccount from './utils/checkForExistingActiveAccount';
import getStripeClient from '../../../utils/get-stripe-client/get-stripe-client';
import { reportToSlack } from './utils/post-message-to-slack';
import getMembershiptType from './utils/getMembershipType';

export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  process.env.TZ = 'America/Denver';

  const body = JSON.parse(event.body || '');

  const isInvalid = validateData(body);
  if (isInvalid) return response(400, { error: isInvalid });

  const {
    password,
    email,
    firstName,
    lastName,
    dateOfBirth,
    phoneNumber,
    phoneNumberCountryCode,
    address1,
    postalCode,
    city,
    state,
    familyMembers,
    stripeToken,
    stripePlanId,
    coupon,
    referralName,
    c1,
  } = body;

  try {
    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();
    const sns = AwsSNSClient.getInstance();
    Client.getInstance();
    getStripeClient(c1);

    const anyActive = await checkForExistingActiveAccount([email, ...familyMembers.map((x) => x.email)]);
    if (anyActive.length) return response(400, { error: anyActive });

    const accountHolder = await registerAccount({
      password,
      email,
      firstName,
      lastName,
      dateOfBirth,
      phoneNumber,
      phoneNumberCountryCode,
      address1,
      postalCode,
      city,
      state,
      stripeToken,
      planId: stripePlanId,
      coupon,
    });

    await sns.publish(
      'ca-hubspot',
      JSON.stringify({
        email,
        firstName,
        lastName,
        dateOfBirth,
        phoneNumber,
        // phoneNumberCountryCode,
        address1,
        postalCode,
        city,
        state,
        familyMembers,
        planId: stripePlanId,
        referralCode: referralName,
        memberCode: '',
        groupCode: coupon,
      }),
    );

    if (familyMembers.length) {
      await sns.publish(
        'ca-participants',
        JSON.stringify({
          familyMembers,
          address1,
          postalCode,
          city,
          state,
          accountOwnerId: accountHolder.user.account.id,
          accountOwnerEmail: email,
          planId: stripePlanId,
          subscriptionId: accountHolder.subscriptionId,
          customerId: accountHolder.customerId,
        }),
      );
    }

    if (referralName) {
      await sns.publish(
        'ca-referral',
        JSON.stringify({
          recipientUser: accountHolder.user,
          referralName,
          stripePlanId,
          stripeToken,
        }),
      );
    }

    await reportToSlack({
      header: 'New Member Created',
      slackChannel: 'C04M10W4TMM',
      color: '#026b43',
      values: {
        name: `${capitalizeFirstLetter(firstName)} ${capitalizeFirstLetter(lastName)}`,
        membershipType: getMembershiptType(stripePlanId),
        pifOrMonthly: stripePlanId.includes('pif') ? 'PIF' : 'Monthly',
        email,
        phoneNumber,
        city,
        referrer: referralName || 'None',
        stripePlanId,
        subscriptionId: accountHolder.subscriptionId,
        customerId: accountHolder.customerId,
      },
    });

    return response(200, { userId: accountHolder.user.id });
  } catch (error) {
    await reportToSlack({
      header: 'New Member Error',
      pretext: 'Error Creating Account',
      slackChannel: 'C04MCJ93UA1',
      color: '#fc0328',
      values: {
        name: `${capitalizeFirstLetter(firstName)} ${capitalizeFirstLetter(lastName)}`,
        email,
        stripePlanId,
        message: `${error}`,
      },
    });

    return response(500, { error });
  }
};
