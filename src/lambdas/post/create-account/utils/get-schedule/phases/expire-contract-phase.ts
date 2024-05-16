import Stripe from 'stripe';

import getStripePlanTerm from '../../../../../../utils/get-stripe-plan-term/get-stripe-plan-term';

export const expireContractPhase = (
  priceId: string,
  startPhase: number = 0,
): Stripe.SubscriptionScheduleCreateParams.Phase[] => {
  const priceTerm = getStripePlanTerm(priceId);
  const remainingIterations = priceTerm - startPhase;

  const items = [{ price: priceId }];

  const defaultPhase = {
    items,
    proration_behavior: 'none',
    iterations: remainingIterations,
    billing_cycle_anchor: 'phase_start',
  } as Stripe.SubscriptionScheduleCreateParams.Phase;

  const expiredPhase = {
    items,
    proration_behavior: 'none',
    iterations: 1,
    billing_cycle_anchor: 'phase_start',
    metadata: {
      expired: 'true',
    },
  } as Stripe.SubscriptionScheduleCreateParams.Phase;

  if (remainingIterations > 0) {
    return [defaultPhase, expiredPhase];
  } else {
    return [expiredPhase];
  }
};

export default expireContractPhase;
