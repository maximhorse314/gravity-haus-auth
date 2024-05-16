import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import MembershipApplicationStatus, {
  StatusEnum,
} from '@gravity-haus/gh-common/dist/models/membershipApplicationStatus.model';

class MembershipApplicationStatusFactory extends SequelizeFactoryMixin(MembershipApplicationStatus) {}

export const membershipApplicationStatusFactory = MembershipApplicationStatusFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    userId: params.userId,
    applicationId: params.applicationId || 123,
    status: params.status || StatusEnum.APPROVE,
    stripeSubscriptionId: params.stripeSubscriptionId || 'sub_1KZgz7GuI3uPg2Uz3yhSrvxM',
    startDate: Date.now(),
    renewalDate: Date.now(),
  };
});
