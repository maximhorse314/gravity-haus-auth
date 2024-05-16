import Stripe from 'stripe';

import StripeClient from '@gravity-haus/gh-common/dist/clients/stripe-client/gh-stripe';
import getMonthlySchedule from './phases/get-monthly-schedule';
import getOneMonthSchedule from './phases/get-one-month-schedule';
import getPifSchedule from './phases/get-pif-schedule';
import expireContractPhase from './phases/expire-contract-phase';

const getPrice = (priceId: string): Promise<Stripe.Price> => {
  const client = StripeClient.getInstance();
  return client.getPrice(priceId);
};

const getSchedule = async (priceId: string): Promise<Stripe.SubscriptionScheduleCreateParams> => {
  const price = await getPrice(priceId);

  const { interval, interval_count } = price.recurring;

  const is6MonthPif = interval === 'month' && interval_count === 6;
  const is12MonthPif = interval === 'year' && interval_count === 1;
  const isPif = is6MonthPif || is12MonthPif || priceId.includes('_pif');

  if (priceId.includes('1_months')) {
    return getOneMonthSchedule(priceId);
  } else if (interval === 'month' && interval_count === 1) {
    return getMonthlySchedule(priceId);
  } else if (isPif) {
    return getPifSchedule(priceId);
  } else {
    return { phases: expireContractPhase(priceId) };
  }
};

export default getSchedule;
