import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import Stripe from '@gravity-haus/gh-common/dist/models/stripe.model';

class StripeFactory extends SequelizeFactoryMixin(Stripe) {}

export const stripeFactory = StripeFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    userId: params.userId,
    customerId: params.customerId,
  };
});
