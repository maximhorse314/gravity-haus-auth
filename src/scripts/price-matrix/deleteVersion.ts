// tslint:disable:no-console

import Stripe from 'stripe';
import throttledQueue from 'throttled-queue';

import GhStripe from '@gravity-haus/gh-common/dist/clients/stripe-client/gh-stripe';
import C1Stripe from '@gravity-haus/gh-common/dist/clients/stripe-client/c1-stripe';
import StripePlan from '@gravity-haus/gh-common/dist/models/stripePlan.model';
import StripePlanVersion from '@gravity-haus/gh-common/dist/models/stripePlanVersion.model';
import Subscription from '@gravity-haus/gh-common/dist/models/subscription.model';
import Product from '@gravity-haus/gh-common/dist/models/product.model';
import MembershipApplication from '@gravity-haus/gh-common/dist/models/membershipApplication.model';
import OldMembershipInfo from '@gravity-haus/gh-common/dist/models/oldMembershipInfo.model';

import getSmAndDb from './utils/getSmAndDb';
import runAsScript from '../run-as-script';

const getPlans = async (ids: string[], isC1: boolean): Promise<Stripe.Plan[]> => {
  const throttle = throttledQueue(10, 1000);

  const stripeClient = isC1 ? C1Stripe.getInstance() : GhStripe.getInstance();

  const plans = ids.map(async (id) => {
    return throttle(async () => {
      return stripeClient.client.plans.retrieve(id);
    });
  });

  return Promise.all(plans);
};

const deletePlanAndProduct = async (plans: Stripe.Plan[], isC1: boolean) => {
  const throttle = throttledQueue(10, 1000);
  const stripeClient = isC1 ? C1Stripe.getInstance() : GhStripe.getInstance();

  const deletedPlans = plans.map(async (plan) => {
    return throttle(async () => {
      const p = await stripeClient.client.plans.del(plan.id);
      const product = await stripeClient.client.products.del(plan.product);
      return { plan: p, product };
    });
  });

  return Promise.all(deletedPlans);
};

const stripeDel = async (planIds) => {
  const c1PlanIds: string[] = Array.from(
    new Set(planIds.filter((id) => id.includes('plan_ghc1_') || id.includes('c1plan_gh_'))),
  );
  const c1Plans = await getPlans(c1PlanIds, true);
  await deletePlanAndProduct(c1Plans, true);

  const ghPlanIds: string[] = Array.from(new Set(planIds.filter((id) => id.includes('plan_gh_'))));
  const ghPlans = await getPlans(ghPlanIds, false);
  await deletePlanAndProduct(ghPlans, false);
};

export const script = async () => {
  try {
    await getSmAndDb();

    const versions = await StripePlanVersion.findAll({
      where: {},
      order: [['id', 'DESC']],
      include: [
        {
          model: StripePlan,
          as: 'stripePlans',
        },
      ],
    });

    const version = versions[0];

    const planIds = version.stripePlans.map((x) => x.planId);

    const stripePlans = await StripePlan.findAll({ where: { stripePlanVersionId: version.id } });
    await Promise.all(
      stripePlans.map(async (p) => {
        return p.destroy({ truncate: true });
      }),
    );

    const stripePlanVersion = await StripePlanVersion.findByPk(version.id);
    await stripePlanVersion.destroy({ truncate: true });

    const subs = await Subscription.findAll({ where: { stripePlanId: planIds } });
    const subsInNewstVersion = subs.slice(0, planIds.length);
    const subIds = subsInNewstVersion.map((x) => x.id);
    const productIds = subsInNewstVersion.map((x) => x.productId);

    const membershipApplications = await MembershipApplication.findAll({ where: { subscriptionId: subIds } });
    await Promise.all(
      membershipApplications.map(async (p) => {
        return p.destroy({ truncate: true });
      }),
    );

    const subscriptions = await Subscription.findAll({ where: { id: subIds } });
    await Promise.all(
      subscriptions.map(async (p) => {
        return p.destroy({ truncate: true });
      }),
    );

    const products = await Product.findAll({ where: { id: productIds } });
    await Promise.all(
      products.map(async (p) => {
        return p.destroy({ truncate: true });
      }),
    );

    const oldMembershipInfos = await OldMembershipInfo.findAll({ where: { membershipName: planIds } });
    const oldMembershipInfosInNewstVersion = oldMembershipInfos.slice(0, planIds.length);
    await Promise.all(
      oldMembershipInfosInNewstVersion.map(async (p) => {
        return p.destroy({ truncate: true });
      }),
    );

    const existingSubsWithPlaId = await Subscription.findAll({
      where: { stripePlanId: planIds },
      order: [['id', 'DESC']],
    });

    if (!existingSubsWithPlaId.length) {
      await stripeDel(planIds);
    }
  } catch (error) {
    console.log('error ===', error);
  }
};

// run file with comand:
// NODE_ENV='scripts' SECRET_NAME='dev' npx ts-node -T src/scripts/price-matrix/deleteVersion.ts
runAsScript(script);
