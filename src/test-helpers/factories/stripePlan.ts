import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import StripePlan from '@gravity-haus/gh-common/dist/models/stripePlan.model';

class StripePlanFactory extends SequelizeFactoryMixin(StripePlan) {}

export const stripePlanFactory = StripePlanFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    stripePlanVersionId: params.stripePlanVersionId,
    intervalCount: params.intervalCount || 12,
    planId: params.planId || 'gh_plan_allin_family_12_months_100',
    name: params.name || 'cool name',
    interval: params.interval || 'month',
    description: params.description || 'description',

    createdAt: Date.now(),
    updatedAt: Date.now(),
  };
});

export default stripePlanFactory;
