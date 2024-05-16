import { Op } from 'sequelize';
import Stripe from 'stripe';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import addMonthsToDate from '@gravity-haus/gh-common/dist/date/add-months-to-date/add-months-to-date';
import SignUpPhasePromotion from '@gravity-haus/gh-common/dist/models/signUpPhasePromotion.model';

import getStripePlanTerm from '../../../../utils/get-stripe-plan-term/get-stripe-plan-term';

const applySignUpPhasePromo = async (phases: Stripe.SubscriptionScheduleCreateParams.Phase[], planId: string) => {
  Client.getInstance();
  const today = new Date();
  const term = getStripePlanTerm(planId);

  const promo = await SignUpPhasePromotion.findOne({
    where: {
      active: true,
      term,
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
    let termEndDate;
    if (today.getDate() >= 6) {
      termEndDate = addMonthsToDate(today, term + promo.freeMonths + 1);
    } else {
      termEndDate = addMonthsToDate(today, term + promo.freeMonths);
    }

    const freeMonthsEnd = new Date(termEndDate.getFullYear(), termEndDate.getMonth(), 1, 0, 0, 0, 0).valueOf() / 1000;
    const phasesLength = phases.length - 1;
    const lastPhase = phases[phasesLength];

    const phase = {
      end_date: freeMonthsEnd,
      billing_cycle_anchor: 'phase_start',
      items: [{ price: planId }],
      coupon: 'free_months_promo',
      metadata: {
        ...lastPhase.metadata,
        free_months_promo: promo.freeMonths,
      },
    } as Stripe.SubscriptionScheduleCreateParams.Phase;

    phases.splice(phasesLength, 0, phase);

    return phases;
  }

  return phases;
};

export default applySignUpPhasePromo;
