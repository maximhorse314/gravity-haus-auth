import User from '@gravity-haus/gh-common/dist/models/user.model';

import createSubscription from '../../create-account/utils/create-subscription';
import getStripeClient from '../../../../utils/get-stripe-client/get-stripe-client';

const updateStripe = async (accountHolder: User, planId: string, coupon: string, c1: boolean): Promise<any> => {
  const stripeClient = getStripeClient(c1);

  const stripeCustomer = await stripeClient.getCustomerById(accountHolder.stripe.customerId);

  const currentSubscription = stripeCustomer.subscriptions.data.filter((s) => {
    const priceId = s.items?.data?.[0]?.price?.id;
    if (!priceId.includes('addon') || !priceId.includes('add_on')) return s;
  })[0];

  // cancel stripe current membership subscription
  if (currentSubscription?.id) {
    await stripeClient.cancelSubscription(currentSubscription.id, { prorate: false });
  }

  const stripeCustomerId = accountHolder.stripe.customerId;
  // create new subscription with schedule
  const subscriptionSchedule = await createSubscription(stripeCustomerId, planId, coupon);
  const subscriptionId = `${subscriptionSchedule.subscription}`;

  return {
    subscriptionSchedule,
    subscriptionId,
    stripeCustomerId,
  };
};

export default updateStripe;
