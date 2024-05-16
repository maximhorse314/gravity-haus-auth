import { Client } from '@gravity-haus/gh-common/dist/db/client';
import { genSalt, hash } from 'bcryptjs';

import User from '@gravity-haus/gh-common/dist/models/user.model';
import Account from '@gravity-haus/gh-common/dist/models/account.model';
import GhStripe from '@gravity-haus/gh-common/dist/models/stripe.model';
import MembershipApplicationStatus from '@gravity-haus/gh-common/dist/models/membershipApplicationStatus.model';

import upsertAddress from '../../../../utils/upsert-address/upsert-address';
import upsertPhone from '../../../../utils/upsert-phone/upsert-phone';
import upsertParticipant from '../../../../utils/upsert-participant/upsert-participant';

import upsertUserByEmail from '../../../../utils/upsert-user-by-email/upsert-user-by-email';
import upsertAccount from '../../../../utils/upsert-account/upsert-account';

interface UserAccountDataType {
  password?: string;
  email: string;
  firstName: string;
  lastName: string;
  dateOfBirth: string;
  phoneNumber: string;
  phoneNumberCountryCode: string; // ex: '1'
  address1: string;
  postalCode: string;
  city: string;
  state: string;
  accountOwnerId?: number;
}

const createHandle = (firstName: string, lastName: string): string => {
  return `${firstName[0]}${lastName}${(Math.random() + 1).toString(36).substring(9)}`.toUpperCase();
};

const addAccountParticipant = async (data: UserAccountDataType, user: User, account: Account): Promise<any> => {
  const query = { where: { userId: user.id } };
  const participantFields = {
    firstName: data.firstName,
    lastName: data.lastName,
    dateOfBirth: data.dateOfBirth,
    accountId: data?.accountOwnerId || account?.id,
    userId: user.id,
  };

  return upsertParticipant(participantFields, query);
};

const upsertUserAccountData = async (data: UserAccountDataType): Promise<User> => {
  try {
    Client.getInstance();

    const user = await upsertUserByEmail(data.email, data.password);

    const phone = await upsertPhone(
      { number: data.phoneNumber, countryCode: data.phoneNumberCountryCode },
      user?.account?.phoneId,
    );

    const addressFields = {
      state: data.state,
      address1: data.address1,
      postalCode: data.postalCode,
      city: data.city,
      country: 'US',
      county: '',
    };

    const address = await upsertAddress(addressFields, user?.account?.mailingAddressId);

    const handle = createHandle(data.firstName, data.lastName);

    const accountFields = {
      userId: user.id,
      firstName: data.firstName,
      lastName: data.lastName,
      dateOfBirth: data.dateOfBirth,
      billingAddressId: address.id,
      mailingAddressId: address.id,
      phoneId: phone.id,
      handle,
    };

    const account = await upsertAccount(accountFields, user?.account?.id);

    await addAccountParticipant(data, user, account);

    const updatedUser = await User.findByPk(user.id, {
      include: [
        { model: GhStripe, as: 'stripe' },
        { model: Account, as: 'account' },
        { model: MembershipApplicationStatus, as: 'membershipApplicationStatus' },
      ],
    });

    return updatedUser;
  } catch (error) {
    throw error; // TODO: set up aws cloudwatch logs
  }
};

export default upsertUserAccountData;
