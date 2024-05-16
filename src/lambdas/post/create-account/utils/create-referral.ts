import Referral from '@gravity-haus/gh-common/dist/models/referral.model';
import User from '@gravity-haus/gh-common/dist/models/user.model';

interface CreateReferralType {
  recipientUser: User;
  referralName: string;
  stripePlanId: string;
  stripeToken: string;
}

const createReferral = async (data: CreateReferralType): Promise<Referral> => {
  return Referral.create({
    recipientUserId: data.recipientUser.id,
    recipientEmail: data.recipientUser.email,
    coupon: data.referralName,
    stripePlanId: data.stripePlanId,
    stripeToken: data.stripeToken,
    createdAt: new Date(),
    lastUpdatedAt: new Date(),
    lastUpdatedBy: 0,
    createdBy: 0,
    status: 0,
  });
};

export default createReferral;
