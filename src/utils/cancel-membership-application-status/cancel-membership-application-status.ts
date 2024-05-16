import MembershipApplicationStatus, { StatusEnum } from '../../models/membershipApplicationStatus.model';

/**
 * cancel a Membership Application Status by updating its status to CANCEL
 *
 * @param membership to be canceled
 * @returns the updated MembershipApplicationStatus with status CANCEL
 */
export const cancelMembershipApplicationStatus = async (
  membership: MembershipApplicationStatus,
  transaction: any,
): Promise<MembershipApplicationStatus> => {
  membership.status = StatusEnum.CANCEL;
  return membership.save({ transaction });
};

export default cancelMembershipApplicationStatus;
