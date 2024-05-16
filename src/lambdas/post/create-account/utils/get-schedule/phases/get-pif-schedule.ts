import Stripe from 'stripe';
import beforeOrAfter5thPhases from './before-or-after-5th-phases';
import addMonthsToDate from '@gravity-haus/gh-common/dist/date/add-months-to-date/add-months-to-date';
import getStripePlanTerm from '../../../../../../utils/get-stripe-plan-term/get-stripe-plan-term';

const firstPhase = (priceId: string): Stripe.SubscriptionScheduleCreateParams.Phase => {
  return {
    proration_behavior: 'none',
    iterations: 1,
    items: [{ price: priceId }],
    billing_cycle_anchor: 'phase_start',
    metadata: {
      pif: 'true',
    },
  };
};

const secondPhase = (priceId: string): Stripe.SubscriptionScheduleCreateParams => {
  return {
    ...firstPhase(priceId),
    metadata: {
      expired: 'true',
    },
  };
};

const beforeThe5thCallback = (priceId: string) => {
  return {
    phases: [firstPhase(priceId), secondPhase(priceId)] as any,
  };
};

const afterThe5thCallback = (priceId): Stripe.SubscriptionScheduleCreateParams => {
  const date = new Date();
  const firstDayOfTheMonth = new Date(date.getFullYear(), date.getMonth(), 1, 0, 0, 0, 0);
  const endDateTerm = getStripePlanTerm(priceId) + 1;
  const endDate = addMonthsToDate(firstDayOfTheMonth, endDateTerm).valueOf() / 1000;

  const paymentHoliday = {
    items: [{ price: priceId }],
    end_date: endDate,
    billing_cycle_anchor: 'phase_start',
    coupon: 'payment_holiday',
    metadata: {
      payment_holiday: true,
    },
  };

  const expiredPh = {
    ...secondPhase(priceId),
    metadata: {
      payment_holiday: false,
      expired: true,
    },
  };

  return {
    phases: [firstPhase(priceId), paymentHoliday, expiredPh] as any,
  };
};

const getPifSchedule = (priceId): Stripe.SubscriptionScheduleCreateParams => {
  return beforeOrAfter5thPhases({ priceId, beforeThe5thCallback, afterThe5thCallback });
};

export default getPifSchedule;
