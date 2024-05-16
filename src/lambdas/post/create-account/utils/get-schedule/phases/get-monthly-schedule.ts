import beforeOrAfter5thPhases from './before-or-after-5th-phases';
import expireContractPhase from './expire-contract-phase';
import Stripe from 'stripe';

const beforeThe5thCallback = (priceId: string): Stripe.SubscriptionScheduleCreateParams => {
  const phase = {
    proration_behavior: 'none',
    iterations: 1,
    items: [{ price: priceId }],
    billing_cycle_anchor: 'phase_start',
  } as Stripe.SubscriptionScheduleCreateParams.Phase;

  return {
    phases: [phase, ...expireContractPhase(priceId, 1)],
  };
};

const afterThe5thCallback = (priceId: string): Stripe.SubscriptionScheduleCreateParams => {
  const phase = {
    proration_behavior: 'none',
    iterations: 1,
    items: [{ price: priceId }],
    billing_cycle_anchor: 'phase_start',
    metadata: {
      payment_holiday: 'true',
    },
  } as Stripe.SubscriptionScheduleCreateParams.Phase;

  const holidayPhases = [
    phase,
    {
      ...phase,
      coupon: 'payment_holiday',
    },
    {
      ...phase,
      metadata: {
        payment_holiday: 'false',
      },
    },
  ];

  return {
    phases: [...holidayPhases, ...expireContractPhase(priceId, holidayPhases.length)],
  };
};

const getMonthlySchedule = (priceId: string): Stripe.SubscriptionScheduleCreateParams => {
  return beforeOrAfter5thPhases({ priceId, beforeThe5thCallback, afterThe5thCallback });
};

export default getMonthlySchedule;
