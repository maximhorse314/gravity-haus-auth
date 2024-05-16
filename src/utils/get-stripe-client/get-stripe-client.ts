import GhStripe from '@gravity-haus/gh-common/dist/clients/stripe-client/gh-stripe';

export const getStripeClient = (c1: boolean): GhStripe => {
  const apiKey = c1 ? process.env.STRIPE_C1_API_KEY : process.env.STRIPE_API_KEY;
  return GhStripe.getInstance(apiKey);
};

export default getStripeClient;
