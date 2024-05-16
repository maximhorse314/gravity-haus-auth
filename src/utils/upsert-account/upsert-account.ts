import Account from '@gravity-haus/gh-common/dist/models/account.model';
import removeUndefinedKeysFromObject from '@gravity-haus/gh-common/dist/validator/removeUndefinedKeysFromObject';

export const upsertAccount = async (accountFields: Account, id?: number): Promise<Account> => {
  let account = await Account.findByPk(id);

  const fields = removeUndefinedKeysFromObject(accountFields);

  if (account === null) {
    account = await Account.create({
      preferredLocation: 'Unspecified',
      preferredIntensity: 'Medium',
      middleName: '',
      title: '',
      suffix: '',
      emailOptIn: 0,
      liabilityWaiver: 0,
      verified: 1, // TODO: should this be set to 0?
      ...fields,
    });
  } else {
    account = await account.update(fields);
  }

  return account;
};

export default upsertAccount;
