import StripeClient from '@gravity-haus/gh-common/dist/clients/stripe-client/gh-stripe';
import GhStripe from '@gravity-haus/gh-common/dist/models/stripe.model';

export interface StripeCustomerType {
  source: string;
  name: string;
  email: string;
  phone: string;
  userId: number;
  accountId: number;
}

export const ghStripeUpsert = async (userId: number, customerId: string): Promise<GhStripe> => {
  let rec = await GhStripe.findOne({ where: { customerId, userId } });

  if (!rec) {
    rec = await GhStripe.create({ userId, customerId });
  }

  return rec;
};

export const upsertStripe = async (customerInfo: StripeCustomerType, stripeCustomerId?: string): Promise<GhStripe> => {
  const client = StripeClient.getInstance();

  const stripeCustomerParams = {
    source: customerInfo.source,
    name: customerInfo.name,
    description: customerInfo.name,
    email: customerInfo.email,
    phone: customerInfo.phone,
    metadata: {
      userId: customerInfo.userId,
      accountId: customerInfo.accountId,
    },
  };

  if (stripeCustomerId) {
    await client.updateCustomer(stripeCustomerId, stripeCustomerParams);
    return GhStripe.findOne({ where: { customerId: stripeCustomerId, userId: customerInfo.userId } });
  } else {
    const stripeCustomer = await client.createCustomer(stripeCustomerParams);
    return await GhStripe.create({ userId: customerInfo.userId, customerId: stripeCustomer.id });
  }
};

export default upsertStripe;
