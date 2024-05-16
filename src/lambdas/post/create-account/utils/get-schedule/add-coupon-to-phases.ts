import Stripe from 'stripe';
import GhStripe from '@gravity-haus/gh-common/dist/clients/stripe-client/gh-stripe';

const applyCoupon = (
  phase: Stripe.SubscriptionScheduleCreateParams.Phase,
  stripeCoupon: Stripe.Coupon,
  appliedToPhaseCount: number,
): string => {
  if (phase.coupon) return phase.coupon;

  if (stripeCoupon.duration === 'forever') {
    return stripeCoupon.id;
  }

  if (stripeCoupon.duration === 'once' && appliedToPhaseCount === 0) {
    return stripeCoupon.id;
  }

  if (stripeCoupon.duration === 'repeating' && appliedToPhaseCount <= stripeCoupon.duration_in_months) {
    return stripeCoupon.id;
  }
};

export const addCouponToPhases = async (
  phases: Stripe.SubscriptionScheduleCreateParams.Phase[],
  couponId: string,
): Promise<Stripe.SubscriptionScheduleCreateParams.Phase[]> => {
  const ghStripe = GhStripe.getInstance();
  const stripeCoupon = await ghStripe.client.coupons.retrieve(couponId);

  let appliedToPhaseCount = 0;
  return phases.map((phase) => {
    const coupon = applyCoupon(phase, stripeCoupon, appliedToPhaseCount);
    if (coupon === stripeCoupon.id) appliedToPhaseCount++;

    return {
      ...phase,
      coupon,
    };
  });
};

export default addCouponToPhases;
