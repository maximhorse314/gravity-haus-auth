import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import SignUpPhasePromotion from '@gravity-haus/gh-common/dist/models/signUpPhasePromotion.model';

class SignUpPhasePromotionFactory extends SequelizeFactoryMixin(SignUpPhasePromotion) {}

export const signUpPhasePromotionFactory = SignUpPhasePromotionFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    term: params.term,
    active: params.active,
    pif: params.pif,
    freeMonths: params.freeMonths,
    name: params.name,
    startDate: params.startDate,
    endDate: params.endDate,
    createdAt: Date.now(),
    updatedAt: Date.now(),
  };
});
