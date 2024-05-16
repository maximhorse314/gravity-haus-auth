import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import Subscription from '@gravity-haus/gh-common/dist/models/subscription.model';

class SubscriptionFactory extends SequelizeFactoryMixin(Subscription) {}

export const subscriptionFactory = SubscriptionFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    name: params.name || 'test',
    description: params.description || 'test',
    displayName: params.displayName || 'test',
    displayValue: params.displayValue || 'test',
    displayValueCondition: params.displayValueCondition || 'test',
    displayValueInfo: params.displayValueInfo || 'test',
    displayInstruction: params.displayInstruction || 'test',
    stripePlanId: params.stripePlanId || 'test',
    stripePlanCurrentCoupon: params.stripePlanCurrentCoupon || 'test',
    stripePlanReferralCoupon: params.stripePlanReferralCoupon || 'test',

    autoApprove: params.autoApprove || 1,
    serviceId: params.serviceId || 1,
    productId: params.productId || 1,
    subscriptionTypeId: params.subscriptionTypeId || 1,
  };
});
