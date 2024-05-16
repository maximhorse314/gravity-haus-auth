import UserMembership from '@gravity-haus/gh-common/dist/models/userMembership.model';

export const upsertUserMembership = async (userId: number, ghSubscriptionId: number): Promise<UserMembership> => {
  let membership = await UserMembership.findOne({ where: { userId } });

  if (!membership) {
    membership = await UserMembership.create({ subscriptionId: ghSubscriptionId, userId });
  } else {
    membership = await membership.update({ subscriptionId: ghSubscriptionId });
  }
  return membership;
};

export default upsertUserMembership;
