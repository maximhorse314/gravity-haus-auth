import validateAccountFields from '@gravity-haus/gh-common/dist/validator/validateAccountFields';
import validateRequired from '@gravity-haus/gh-common/dist/validator/validateRequired';
import validateFamilyMembers from '@gravity-haus/gh-common/dist/validator/validateFamilyMembers';
import removeUndefinedKeysFromObject from '@gravity-haus/gh-common/dist/validator/removeUndefinedKeysFromObject';

const validateData = (body: any): any | undefined => {
  const validate = removeUndefinedKeysFromObject({
    ...validateAccountFields({ ...body, countryCode: body.phoneNumberCountryCode }),
    familyMembers: validateFamilyMembers(body.familyMembers),
    stripeToken: validateRequired(body.stripeToken),
    stripePlanId: validateRequired(body.stripePlanId),
  });

  return Object.keys(validate).length === 0 ? undefined : validate;
};

export default validateData;
