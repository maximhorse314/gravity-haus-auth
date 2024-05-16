import MembershipApplicationStatus from '@gravity-haus/gh-common/dist/models/membershipApplicationStatus.model';

export const upsertMembershipApplicationStatus = async (
  statusFields: any,
  id?: number,
): Promise<MembershipApplicationStatus> => {
  let status;
  status = await MembershipApplicationStatus.findByPk(id);

  if (status === null) {
    status = await MembershipApplicationStatus.create(statusFields);
  } else {
    status = await status.update(statusFields);
  }

  return status;
};

export default upsertMembershipApplicationStatus;
