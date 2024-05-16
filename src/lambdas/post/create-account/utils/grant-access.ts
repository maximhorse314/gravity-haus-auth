import User from '@gravity-haus/gh-common/dist/models/user.model';
import Subscription from '@gravity-haus/gh-common/dist/models/subscription.model';
import MembershipApplication from '@gravity-haus/gh-common/dist/models/membershipApplication.model';

import upsertUserMembership from '../../../../utils/upsert-user-membership/upsert-user-membership';
import setStatus from './set-status';

const grantAccess = async (user: User, stripeSubscriptionId: string, stripePlanId: string): Promise<any[]> => {
  const ghSubscription = await Subscription.findOne({
    where: { stripePlanId },
    include: [
      {
        model: MembershipApplication,
        as: 'membershipApplication',
      },
    ],
  });

  return Promise.all([
    setStatus(user, stripeSubscriptionId, stripePlanId, ghSubscription.membershipApplication.id),
    upsertUserMembership(user.id, ghSubscription.id),
  ]);
};

export default grantAccess;
