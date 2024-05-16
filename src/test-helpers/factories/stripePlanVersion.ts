import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import StripePlanVersion from '@gravity-haus/gh-common/dist/models/stripePlanVersion.model';

class StripePlanVersionFactory extends SequelizeFactoryMixin(StripePlanVersion) {}

export const stripePlanVersionFactory = StripePlanVersionFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    active: params.active,
    createdAt: Date.now(),
    updatedAt: Date.now(),
  };
});

export default stripePlanVersionFactory;
