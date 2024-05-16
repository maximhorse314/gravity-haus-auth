import Stripe from '@gravity-haus/gh-common/dist/models/stripe.model';
import User from '@gravity-haus/gh-common/dist/models/user.model';
import GhStripe from '@gravity-haus/gh-common/dist/clients/stripe-client/gh-stripe';

const checkForDupEmails = (emails): any[] => {
  const dupEmails = [...new Set(emails.filter((item, index) => emails.indexOf(item) !== index))];

  if (dupEmails.length) {
    return dupEmails.map((de) => {
      return { email: de, error: 'All Member Emails Must Be Unique' };
    });
  }

  return [];
};

const checkStripe = async (emails: string[]) => {
  const users = await User.findAll({
    where: { email: emails },
    include: [{ model: Stripe, as: 'stripe' }],
  });

  const customerIds = [...new Set(users.map((x) => x?.stripe?.customerId))].filter((x) => x);

  let errors = [];
  if (customerIds.length) {
    const stripeClient = GhStripe.getInstance();
    const stirpeCustomers = await stripeClient.getCustomersByIds(customerIds);

    errors = stirpeCustomers
      .map((customer) => {
        const user = users.find((u) => u.stripe.customerId === customer.id);
        const activeSubs = customer.subscriptions.data.filter((s) => {
          const priceId = s.items?.data?.[0]?.price?.id;
          const isAddon = priceId.includes('add_on') || priceId.includes('addon');
          if (!isAddon) return s;
        });

        if (activeSubs.length) {
          return { email: user.email, error: 'Account already exist' };
        }
      })
      .filter((x) => x);
  }

  return errors;
};

const checkForExistingActiveAccount = async (emails: string[]): Promise<any> => {
  const dupEmails = checkForDupEmails(emails);
  if (dupEmails.length) return dupEmails;

  const activeInStripe = await checkStripe(emails);
  if (activeInStripe.length) return activeInStripe;

  return [];
};

export default checkForExistingActiveAccount;
