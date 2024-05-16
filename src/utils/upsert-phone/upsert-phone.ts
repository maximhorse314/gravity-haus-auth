import Phone from '@gravity-haus/gh-common/dist/models/phone.model';
import removeUndefinedKeysFromObject from '@gravity-haus/gh-common/dist/validator/removeUndefinedKeysFromObject';

interface UpsertPhoneType {
  number: string;
  countryCode: string;
}

export const upsertPhone = async (phoneFields: UpsertPhoneType, id?: number) => {
  let phone;
  phone = await Phone.findByPk(id);

  const phoneData = removeUndefinedKeysFromObject({
    number: phoneFields.number ? `${phoneFields.number}`.slice(-10) : undefined,
    countryCode: '1',
  });

  if (phone === null) {
    phone = await Phone.create(phoneData);
  } else {
    phone = await phone.update(phoneData);
  }

  return phone;
};

export default upsertPhone;
