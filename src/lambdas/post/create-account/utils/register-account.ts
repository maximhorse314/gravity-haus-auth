import User from '@gravity-haus/gh-common/dist/models/user.model';

import upsertStripe from '../../../../utils/upsert-stripe/upsert-stripe';
import createSubscription from './create-subscription';
import upsertUserAccountData from './upsert-user-account-data';
import applySignUpPromo from './applySignUpPromo';

import grantAccess from './grant-access';

interface RegisterAccountType {
  password: string;
  email: string;
  firstName: string;
  lastName: string;
  dateOfBirth: string;
  phoneNumber: string;
  phoneNumberCountryCode: string;
  address1: string;
  postalCode: string;
  city: string;
  state: string;
  stripeToken: string;
  planId: any;
  coupon?: string;
}

interface RegisterAccountReturnType {
  user: User;
  subscriptionId: string;
  customerId: string;
}

export const registerAccount = async (data: RegisterAccountType): Promise<RegisterAccountReturnType> => {
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
    stripeToken,
    planId,
    coupon,
  } = data;

  const emailLowerCase = email.toLowerCase().trim();

  // TODO: should this be wraped in transaction https://sequelize.org/docs/v6/other-topics/transactions/#managed-transactions

  const accountHolder = await upsertUserAccountData({
    password,
    email: emailLowerCase,
    firstName,
    lastName,
    dateOfBirth,
    phoneNumber,
    phoneNumberCountryCode,
    address1,
    postalCode,
    city,
    state,
  });

  const ghStripe = await upsertStripe(
    {
      source: stripeToken,
      name: `${firstName} ${lastName}`,
      email: emailLowerCase,
      phone: phoneNumber,
      userId: accountHolder.id,
      accountId: accountHolder.account.id,
    },
    accountHolder?.stripe?.customerId,
  );

  const subscriptionSchedule = await createSubscription(ghStripe.customerId, planId, coupon);
  const subscriptionId = `${subscriptionSchedule.subscription}`;

  await applySignUpPromo(planId, ghStripe.customerId);

  await grantAccess(accountHolder, subscriptionId, planId);

  return {
    user: accountHolder,
    customerId: ghStripe.customerId,
    subscriptionId,
  };
};

export default registerAccount;
