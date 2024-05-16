import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import MembershipApplication from '@gravity-haus/gh-common/dist/models/membershipApplication.model';

class MembershipApplicationFactory extends SequelizeFactoryMixin(MembershipApplication) {}

export const membershipApplicationFactory = MembershipApplicationFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    formId: params.formId || 1,
    subscriptionId: params.subscriptionId,
  };
});
