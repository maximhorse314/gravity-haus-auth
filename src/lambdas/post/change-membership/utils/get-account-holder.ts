import { Op } from 'sequelize';

import User from '@gravity-haus/gh-common/dist/models/user.model';
import Stripe from '@gravity-haus/gh-common/dist/models/stripe.model';
import MembershipApplicationStatus from '@gravity-haus/gh-common/dist/models/membershipApplicationStatus.model';
import Account from '@gravity-haus/gh-common/dist/models/account.model';
import Phone from '@gravity-haus/gh-common/dist/models/phone.model';
import Address from '@gravity-haus/gh-common/dist/models/address.model';
import Participant from '@gravity-haus/gh-common/dist/models/participant.model';
import MembershipApplication from '@gravity-haus/gh-common/dist/models/membershipApplication.model';
import Subscription from '@gravity-haus/gh-common/dist/models/subscription.model';
import UserProfileData from '@gravity-haus/gh-common/dist/models/userProfileData.model';

export const getAccountHolder = async ({ email, userId }: { email?: string; userId?: number }): Promise<User> => {
  let where = { email: { [Op.substring]: email } };
  if (userId) where = { id: userId } as any;

  const user = await User.findAll({
    where,
    limit: 1,
    order: [['id', 'DESC']],
    include: [
      { model: Stripe, as: 'stripe' },
      { model: UserProfileData, as: 'userProfileData' },
      {
        model: MembershipApplicationStatus,
        as: 'membershipApplicationStatus',
        include: [
          {
            model: MembershipApplication,
            as: 'membershipApplication',
            include: [
              {
                model: Subscription,
                as: 'subscription',
              },
            ],
          },
        ],
      },
      {
        model: Account,
        as: 'account',
        include: [
          { model: Phone, as: 'phone' },
          { model: Address, as: 'mailingAddress' },
          {
            model: Participant,
            as: 'participants',
            include: [
              {
                model: User,
                as: 'user',
                include: [
                  {
                    model: Account,
                    as: 'account',
                    include: [
                      { model: Phone, as: 'phone' },
                      { model: Address, as: 'mailingAddress' },
                    ],
                  },
                  { model: MembershipApplicationStatus, as: 'membershipApplicationStatus' },
                ],
              },
            ],
          },
        ],
      },
    ],
  });

  return user.map((u) => {
    return u.get({ plain: true });
  });
};

export default getAccountHolder;
