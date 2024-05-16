import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import verifyToken from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import { v4 as uuidv4 } from 'uuid';

import User from '@gravity-haus/gh-common/dist/models/user.model';
import Account from '@gravity-haus/gh-common/dist/models/account.model';
import GhStripe from '@gravity-haus/gh-common/dist/models/stripe.model';
import MembershipApplicationStatus from '@gravity-haus/gh-common/dist/models/membershipApplicationStatus.model';
import Address from '@gravity-haus/gh-common/dist/models/address.model';
import Subscription from '@gravity-haus/gh-common/dist/models/subscription.model';
import MembershipApplication from '@gravity-haus/gh-common/dist/models/membershipApplication.model';

import upsertUserAccountData from '../create-account/utils/upsert-user-account-data';
import grantAccess from '../create-account/utils/grant-access';
import { ghStripeUpsert } from '../../../utils/upsert-stripe/upsert-stripe';
import upsertHubspotContact from '../create-account/utils/upsert-hubspot-contact';

import isOwner from '../../../utils/get-stripe-account-owner/get-stripe-account-owner';
import checkForExistingActiveAccount from '../create-account/utils/checkForExistingActiveAccount';

const getAccountData = async (accountId: number): Promise<Account> => {
  return Account.findByPk(accountId, {
    include: [
      {
        model: User,
        as: 'user',
        include: [
          { model: GhStripe, as: 'stripe' },
          {
            model: MembershipApplicationStatus,
            as: 'membershipApplicationStatus',
            include: [
              {
                model: MembershipApplication,
                as: 'membershipApplication',
                include: [{ model: Subscription, as: 'subscription' }],
              },
            ],
          },
        ],
      },
      { model: Address, as: 'mailingAddress' },
    ],
  });
};

interface MemberType {
  firstName: string;
  lastName: string;
  dateOfBirth: string;
  email: string;
  phoneNumber: string;
}

const addUserToAccount = async (account: Account, member: MemberType): Promise<User> => {
  const memberData = {
    firstName: member.firstName,
    lastName: member.lastName,
    dateOfBirth: member.dateOfBirth,
    email: member.email,
    phoneNumber: member.phoneNumber,
    phoneNumberCountryCode: '+1',
    accountOwnerId: account.id,
    accountOwnerEmail: account.user.email,
    planId: account.user.membershipApplicationStatus.membershipApplication.subscription.stripePlanId,
    subscriptionId: account.user.membershipApplicationStatus.stripeSubscriptionId,
    customerId: account.user.stripe.customerId,
    address1: account.mailingAddress.address1,
    postalCode: account.mailingAddress.postalCode,
    city: account.mailingAddress.city,
    state: account.mailingAddress.state,
    password: uuidv4(),
  };

  const user = await upsertUserAccountData(memberData);

  await Promise.all([
    grantAccess(user, memberData.subscriptionId, memberData.planId),
    ghStripeUpsert(user.id, memberData.customerId),
    upsertHubspotContact({
      /// TODO: add member to account holder
      ...(memberData as any),
      memberCode: '',
      groupCode: '',
      referralCode: 'Membership Upgraded',
      childAccount: 'Yes',
      parentAccount: account.user.email,
    }),
  ]);

  return user;
};

export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  // check for user authentication
  try {
    verifyToken(event);
  } catch {
    return response(401, { message: 'Unauthorized' });
  }

  try {
    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();
    Client.getInstance();

    const body = JSON.parse(event.body || '');
    const { firstName, lastName, dateOfBirth, phoneNumber, phoneNumberCountryCode, email, accountId } = body;

    const account = await getAccountData(accountId);
    if (account === null) return response(404, { error: 'Account Not Found' });

    const owner = await isOwner({ ...account.user, account });
    if (!owner) return response(400, { error: 'Only The Account Owner Can add a member to the account.' });

    const anyActive = await checkForExistingActiveAccount([email]);
    if (anyActive.length) return response(400, { error: anyActive });

    const user = await addUserToAccount(account, {
      firstName,
      lastName,
      dateOfBirth,
      phoneNumber,
      email,
    });

    return response(200, { user });
  } catch (error) {
    const hubspotError = JSON.stringify(error?.response?.data);
    return response(500, { error, hubspotError });
  }
};
