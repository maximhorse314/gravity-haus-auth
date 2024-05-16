import { Client } from '@gravity-haus/gh-common/dist/db/client';
import User from '@gravity-haus/gh-common/dist/models/user.model';
import Account from '@gravity-haus/gh-common/dist/models/account.model';
import GhStripe from '@gravity-haus/gh-common/dist/models/stripe.model';
import Participant from '@gravity-haus/gh-common/dist/models/participant.model';

export const getStripeAccountOwner = async (stripeCustomerId: string): Promise<GhStripe> => {
  Client.getInstance();

  const stripes = await GhStripe.findAll({
    where: { customerId: stripeCustomerId },
    include: [
      {
        model: User,
        as: 'user',
        include: [
          {
            model: Account,
            as: 'account',
            include: [{ model: Participant, as: 'participants' }],
          },
        ],
      },
    ],
  });

  const accountOwner = stripes.find((s) => {
    const pUsers = s?.user?.account?.participants?.map((p) => p.userId) || [];
    if (pUsers.includes(s?.user.id)) return s.get({ plain: true });
  });

  return accountOwner;
};

export const isAccountOwner = (account: Account, accountOwner: Account) => {
  if (account.id === accountOwner.id) return true;
  return false;
};

interface IsOwnerType extends User {
  stripe: GhStripe;
  account: Account;
}

export const isOwner = async (accountHolder: IsOwnerType): Promise<boolean> => {
  const stripeOwner = await getStripeAccountOwner(accountHolder.stripe.customerId);
  return isAccountOwner(accountHolder.account, stripeOwner.user.account);
};

export default isOwner;
