import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import SignUpCouponPromotion from '@gravity-haus/gh-common/dist/models/signUpCouponPromotion.model';

class SignUpCouponPromotionFactory extends SequelizeFactoryMixin(SignUpCouponPromotion) {}

export const signUpCouponPromotionFactory = SignUpCouponPromotionFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    term: params.term,
    active: params.active,
    pif: params.pif,
    couponId: params.couponId,
    name: params.name,
    startDate: params.startDate,
    endDate: params.endDate,
    createdAt: Date.now(),
    updatedAt: Date.now(),
  };
});
