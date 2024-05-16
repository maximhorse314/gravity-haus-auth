import { Op } from 'sequelize';
import StripeClient from '@gravity-haus/gh-common/dist/clients/stripe-client/gh-stripe';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import SignUpCouponPromotion from '@gravity-haus/gh-common/dist/models/signUpCouponPromotion.model';
import getStripePlanTerm from '../../../../utils/get-stripe-plan-term/get-stripe-plan-term';

const applySignUpPromo = async (planId: string, customerId: string) => {
  Client.getInstance();
  const today = new Date();

  const promo = await SignUpCouponPromotion.findOne({
    where: {
      active: true,
      term: getStripePlanTerm(planId),
      pif: planId.includes('_pif'),
      startDate: {
        [Op.lte]: today,
      },
      endDate: {
        [Op.gte]: today,
      },
    },
  });

  if (promo) {
    const ghStripe = StripeClient.getInstance();
    const customer = await ghStripe.updateCustomer(customerId, { coupon: promo.couponId });
    return customer;
  }
};

export default applySignUpPromo;
