import Stripe from 'stripe';
import StripeClient from '@gravity-haus/gh-common/dist/clients/stripe-client/gh-stripe';
import getSchedule from './get-schedule/get-schedule';
import addCouponToPhases from './get-schedule/add-coupon-to-phases';
import applySignUpPhasePromo from './applySignUpPhasePromo';

const getSubscriptionPhases = async (
  customerId: string,
  priceId: string,
  coupon: string,
): Promise<Stripe.SubscriptionSchedule> => {
  const date = new Date();
  const firstDayOfTheMonth = new Date(date.getFullYear(), date.getMonth(), 1, 0, 0, 0, 0);

  const scheduleDefaults = {
    customer: customerId,
    start_date: firstDayOfTheMonth.getTime() / 1000,
    end_behavior: 'release',
  };

  const subscriptionSchedule = await getSchedule(priceId);

  const schedule = {
    ...scheduleDefaults,
    ...subscriptionSchedule,
  };

  if (coupon) {
    const couponPhases = await addCouponToPhases(schedule.phases, coupon);
    schedule.phases = couponPhases;
  }

  const freePhases = await applySignUpPhasePromo(schedule.phases, priceId);
  schedule.phases = freePhases;

  const client = StripeClient.getInstance();
  const subscriptionSchedules = await client.createSubscriptionSchedule(schedule);

  return subscriptionSchedules;
};

// export const createSubscription = async (customerId: string, priceId: string): Promise<Stripe.SubscriptionSchedule> => {
export const createSubscription = async (
  customerId: string,
  priceId: string,
  coupon: string,
): Promise<Stripe.SubscriptionSchedule> => {
  try {
    const subscription = await getSubscriptionPhases(customerId, priceId, coupon);
    return subscription;
  } catch (error) {
    // console.log('error', error);
    throw error;
  }
};

export default createSubscription;
