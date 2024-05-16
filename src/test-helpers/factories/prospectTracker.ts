import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import ProspectTracker from '../../models/prospectTracker.model';

class ProspectTrackerFactory extends SequelizeFactoryMixin(ProspectTracker) {}

export const prospectTrackerFactory = ProspectTrackerFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    userId: params.userId,
    values: params.values,
    createdAt: Date.now(),
    updatedAt: Date.now(),
  };
});
