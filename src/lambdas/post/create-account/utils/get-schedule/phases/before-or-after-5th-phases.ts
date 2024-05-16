import Stripe from 'stripe';

interface BeforeOrAfter5thPhasesType {
  priceId: string;
  beforeThe5thCallback: (priceId: string) => Stripe.SubscriptionScheduleCreateParams;
  afterThe5thCallback: (priceId: string) => Stripe.SubscriptionScheduleCreateParams;
}

const beforeOrAfter5thPhases = (args: BeforeOrAfter5thPhasesType): Stripe.SubscriptionScheduleCreateParams => {
  const { priceId, beforeThe5thCallback, afterThe5thCallback } = args;
  const date = new Date();
  const day = date.getDate();

  if (day >= 6) {
    return afterThe5thCallback(priceId);
  } else {
    return beforeThe5thCallback(priceId);
  }
};

export default beforeOrAfter5thPhases;
