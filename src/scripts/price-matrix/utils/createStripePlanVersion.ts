import Stripe from 'stripe';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import StripePlan from '@gravity-haus/gh-common/dist/models/stripePlan.model';
import StripePlanVersion from '@gravity-haus/gh-common/dist/models/stripePlanVersion.model';
import Subscription from '@gravity-haus/gh-common/dist/models/subscription.model';
import Product from '@gravity-haus/gh-common/dist/models/product.model';
import MembershipApplication from '@gravity-haus/gh-common/dist/models/membershipApplication.model';
import OldMembershipInfo from '@gravity-haus/gh-common/dist/models/oldMembershipInfo.model';

import capitalizeFirstLetter from '@gravity-haus/gh-common/dist/capitalize-first-letter/capitalize-first-letter';

const createSubs = async (plans): Promise<Subscription[]> => {
  const productData = plans.map((x) => {
    return {
      name: x.product.name,
      description: x.product.description,
      // unitOfMeasure:  '0',
      unitCost: 0,
      unitPrice: x.amount_decimal,
      stripeProductId: x.product.id,
      sku: x.product.id,
    };
  });
  const products = await Product.bulkCreate(productData);

  const subscriptionData = plans.map((x) => {
    const product = products.find((y) => y.stripeProductId === x.product.id);
    return {
      name: x.nickname,
      description: x.metadata.description,
      stripePlanId: x.id,
      productId: product.id,
    };
  });

  const subs = await Subscription.bulkCreate(subscriptionData);

  await MembershipApplication.bulkCreate(
    subs.map((s) => {
      return {
        subscriptionId: s.id,
        formId: 1,
      };
    }),
  );

  await OldMembershipInfo.bulkCreate(
    plans.map((x) => {
      const parts = x.id.replace('c1', '').split('_').slice(0, 7);
      // ['plan', 'gh', 'local', 'individual', 'steamboat', '1', 'months']
      let plan;
      if (x.id.includes('local')) plan = 'allinlocal';
      if (x.id.includes('allin')) plan = 'allin';
      if (x.id.includes('traveler') || x.id.includes('weekender')) plan = 'weekender';
      if (x.id.includes('explorer')) plan = 'explorer';

      const replacementName = `${parts[0]}_${parts[1]}_${plan}_${parts[3]}_${parts[4]}_${parts[5]}_${parts[6]}`;
      return {
        membershipName: x.id, // plan_gh_local_individual_denver_12_months_1
        replacementName, // plan_gh_allinlocal_individual_steamboat_1_months
      };
    }),
  );

  return subs;
};

const createVersion = async (plans): Promise<StripePlan[]> => {
  const stripePlanVersion = await StripePlanVersion.create({ active: true });
  const stripePlans = plans.map((x) => {
    const idParts = x.id.split('_');

    const location = capitalizeFirstLetter(idParts[4])
      .replace('Breck', 'Breckenridge')
      .replace('Winterpark', 'Winter Park');
    return {
      planId: x.id,
      name: x.nickname,
      interval: x.interval,
      intervalCount: x.interval_count,
      unitAmount: x.amount,
      description: x.metadata.description,
      membershipPlan: idParts[2],
      membershipType: idParts[3],
      location,
      term: parseInt(idParts[5], 10),
      c1: x.id.includes('c1'),
      stripePlanVersionId: stripePlanVersion.id,
    };
  });

  return StripePlan.bulkCreate(stripePlans);
};

const createStripePlanVersion = async (plans: Stripe.Plan[]): Promise<any> => {
  Client.getInstance();

  await createSubs(plans);
  await createVersion(plans);
};

export default createStripePlanVersion;
