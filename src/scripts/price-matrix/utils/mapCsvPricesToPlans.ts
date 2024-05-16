import Stripe from 'stripe';
import getId from './getPlanId';
import getName from './getPlanName';

const mapCsvPricesToPlans = (data: {
  products: any[];
  term: number;
  interval: Stripe.PlanCreateParams.Interval; // day, week, month or year.
  intervalCount: number; //  (1 year, 12 months, or 52 weeks).
  isPif?: boolean;
  isC1?: boolean;
}): Stripe.PlanCreateParams[] => {
  const { products, term, interval, intervalCount, isPif, isC1 } = data;
  return Object.entries(products)
    .map((product) => {
      const key = product[0];
      const value = product[1] as string;

      const amount = parseInt(value, 10).toLocaleString('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      });

      if (value) {
        const name = getName(key, term, isPif);
        return {
          id: getId(key, value, term, isPif, isC1),
          currency: 'USD',
          amount: parseInt(value, 10) * 100,
          nickname: name,
          interval, // day, week, month or year.
          interval_count: intervalCount, //  (1 year, 12 months, or 52 weeks).
          product: {
            name,
          },
          metadata: {
            description: `${term} months (${amount} ${isPif ? 'Pay in full and save' : '/ month'})`,
          },
        };
      }
    })
    .filter((x) => x && x.id !== 'plan_gh_' && x.id !== 'plan_ghc1_');
};

export default mapCsvPricesToPlans;
