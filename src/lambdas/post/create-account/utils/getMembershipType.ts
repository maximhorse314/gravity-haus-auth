import parseGHPlan from '@gravity-haus/gh-common/dist/parse-gh-plan/parse-gh-plan';
import capitalizeFirstLetter from '@gravity-haus/gh-common/dist/capitalize-first-letter/capitalize-first-letter';

const getMembershiptType = (planId: string): string => {
  const plan = parseGHPlan(planId);
  return `${capitalizeFirstLetter(plan.gh_membership_type.split('_').pop())} | ${capitalizeFirstLetter(
    plan.gh_membership_duration
      .split('_')
      .map((x) => capitalizeFirstLetter(x))
      .join(' '),
  )} | ${plan.gh_membership_group_type}`;
};

export default getMembershiptType;
