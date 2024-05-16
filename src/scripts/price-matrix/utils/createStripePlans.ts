import Stripe from 'stripe';
import throttledQueue from 'throttled-queue';

import GhStripe from '@gravity-haus/gh-common/dist/clients/stripe-client/gh-stripe';
import C1Stripe from '@gravity-haus/gh-common/dist/clients/stripe-client/c1-stripe';

const createStripePlans = async (data: {
  priceMap: Stripe.PlanCreateParams[];
  isC1?: boolean;
}): Promise<Stripe.Plan[]> => {
  const throttle = throttledQueue(10, 1000);
  const stripeClient = data.isC1 ? C1Stripe.getInstance() : GhStripe.getInstance();

  const plans = data.priceMap.map(async (price) => {
    return throttle(async () => {
      let plan;
      try {
        plan = await stripeClient.client.plans.retrieve(price.id, {
          expand: ['product'],
        });
      } catch (error) {
        plan = await stripeClient.client.plans.create({
          ...price,
          expand: ['product'],
        });
      }

      await stripeClient.client.products.update(plan.product.id, { description: plan.metadata.description });

      return plan;
    });
  });

  return Promise.all(plans);
};

export default createStripePlans;
