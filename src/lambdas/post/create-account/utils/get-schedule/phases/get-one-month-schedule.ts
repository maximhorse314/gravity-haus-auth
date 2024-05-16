import Stripe from 'stripe';

import beforeOrAfter5thPhases from './before-or-after-5th-phases';

const firstPhase = (priceId: string): Stripe.SubscriptionScheduleCreateParams.Phase => {
  return {
    proration_behavior: 'none',
    iterations: 1,
    items: [{ price: priceId }],
    billing_cycle_anchor: 'phase_start',
  };
};

const beforeThe5thCallback = (priceId: string): Stripe.SubscriptionScheduleCreateParams => {
  return {
    end_behavior: 'cancel',
    phases: [firstPhase(priceId)] as any,
  };
};

const afterThe5thCallback = (priceId): Stripe.SubscriptionScheduleCreateParams => {
  const phase = {
    ...firstPhase(priceId),
    metadata: {
      payment_holiday: true,
    },
  };

  const phases = [
    phase,
    {
      ...phase,
      coupon: 'payment_holiday',
    },
  ] as any;

  return {
    end_behavior: 'cancel',
    phases,
  };
};

const getOneMonthSchedule = (priceId) => {
  return beforeOrAfter5thPhases({ priceId, beforeThe5thCallback, afterThe5thCallback });
};

export default getOneMonthSchedule;
