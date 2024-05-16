import Address from '@gravity-haus/gh-common/dist/models/address.model';
import removeUndefinedKeysFromObject from '@gravity-haus/gh-common/dist/validator/removeUndefinedKeysFromObject';

export const upsertAddress = async (addressFields: Address, id?: number) => {
  let address = await Address.findByPk(id);

  const fields = removeUndefinedKeysFromObject(addressFields);

  if (address === null) {
    address = await Address.create({
      address2: '',
      address3: '',
      address4: '',
      county: '',
      ...fields,
    });
  } else {
    address = await address.update(fields);
  }

  return address;
};

export default upsertAddress;
