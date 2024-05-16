import { userFactory } from './factories/user';
import { membershipApplicationStatusFactory } from './factories/membershipApplicationStatus';
import { accountFactory } from './factories/account';
import { stripeFactory } from './factories/stripe';
import { addressFactory } from './factories/address';
import { phoneFactory } from './factories/phone';
import { participantFactory } from './factories/participant';

import { membershipApplicationFactory } from './factories/membershipApplication';
import { subscriptionFactory } from './factories/subscription';

import { defaultPlanIds } from './createSubscriptionsAndApps';

interface CreateAccountType {
  email: string;
  stripeSubscriptionId: string;
  stripeCustomerId: string;
  accountId?: number;
}

const createAccount = async (data: CreateAccountType, planId: string = defaultPlanIds[0]) => {
  const sub = await subscriptionFactory.create({ stripePlanId: planId });
  const app = await membershipApplicationFactory.create({ subscriptionId: sub.dataValues.id });

  const { email, stripeSubscriptionId, stripeCustomerId } = data;

  const accountHolder = await userFactory.create({ email });
  await membershipApplicationStatusFactory.create({
    userId: accountHolder.dataValues.id,
    stripeSubscriptionId,
    applicationId: app.dataValues.id,
  });

  await stripeFactory.create({
    customerId: stripeCustomerId,
    userId: accountHolder.dataValues.id,
  });

  const phone = await phoneFactory.create({ userId: accountHolder.dataValues.id });
  const address = await addressFactory.create({});

  const account = await accountFactory.create({
    userId: accountHolder.dataValues.id,
    phoneId: phone.dataValues.id,
    billingAddress: address.dataValues.id,
    mailingAddressId: address.dataValues.id,
  });

  await participantFactory.create({
    userId: accountHolder.dataValues.id,
    accountId: data.accountId || account.dataValues.id,
    firstName: account.firstName,
    middleName: account.middleName,
    lastName: account.lastName,
  });

  return {
    user: accountHolder,
    account,
  };
};

export default createAccount;
