import { subscriptionFactory } from './factories/subscription';
import { membershipApplicationFactory } from './factories/membershipApplication';

export const defaultPlanIds = [
  'plan_gh_local_individual_steamboat_12_months_1296_pif10',
  'plan_gh_local_individual_steamboat_6_months_864_pif10',
  'plan_gh_local_individual_breck_12_months_140',
  'plan_gh_local_individual_steamboat_12_months_120',
  'plan_gh_local_individual_steamboat_6_months_160',
  'plan_gh_local_individual_steamboat_1_months_320',
  'plan_gh_local_individual_breck_12_months_140',
  'plan_gh_local_family_winterpark_12_months_2496_pif',
];

const createSubscriptionsAndApps = async (planIds: string[] = defaultPlanIds) => {
  const subscriptions = await Promise.all(
    planIds.map(async (plan) => subscriptionFactory.create({ stripePlanId: plan })),
  );

  const membershipApplication = await Promise.all(
    subscriptions.map(async (s) => {
      return membershipApplicationFactory.create({ subscriptionId: s.dataValues.id });
    }),
  );

  return {
    subscriptions,
    membershipApplication,
  };
};

export default createSubscriptionsAndApps;
