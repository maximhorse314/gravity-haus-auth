import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import Account from '@gravity-haus/gh-common/dist/models/account.model';

class AccountFactory extends SequelizeFactoryMixin(Account) {}

export const accountFactory = AccountFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    userId: params.userId,
    phoneId: params.phoneId,
    firstName: params.firstName || `firstName${sequence}`,
    lastName: params.lastName || `lastName${sequence}`,
    middleName: '',
    title: '',
    suffix: '',
    gender: 'OTHER',
    emailOptIn: 0,
    liabilityWaiver: 0,
    verified: 1,
    billingAddressId: params.billingAddressId,
    mailingAddressId: params.mailingAddressId,
  };
});
