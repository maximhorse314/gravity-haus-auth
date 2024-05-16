import User from '@gravity-haus/gh-common/dist/models/user.model';
import addMonthsToDate from '@gravity-haus/gh-common/dist/date/add-months-to-date/add-months-to-date';
import MembershipApplicationStatus from '@gravity-haus/gh-common/dist/models/membershipApplicationStatus.model';

import upsertMembershipApplicationStatus from '../../../../utils/upsert-membership-application-status/upsert-membership-application-status';

export const setStatus = async (
  accountHolder: User,
  subscriptionId: string,
  planId: string,
  membershipApplicationId: number,
): Promise<MembershipApplicationStatus> => {
  const startDate = new Date();
  let renewalDate;
  if (planId.includes('1_months')) {
    renewalDate = addMonthsToDate(startDate, 1);
  } else if (planId.includes('6_months')) {
    renewalDate = addMonthsToDate(startDate, 6);
  } else {
    renewalDate = addMonthsToDate(startDate, 12);
  }

  const status = await upsertMembershipApplicationStatus(
    {
      userId: accountHolder.id,
      status: 'APPROVE',
      stripeSubscriptionId: subscriptionId,
      applicationId: membershipApplicationId,
      startDate,
      renewalDate,
    },
    accountHolder?.membershipApplicationStatus?.id,
  );

  return status;
};

export default setStatus;
