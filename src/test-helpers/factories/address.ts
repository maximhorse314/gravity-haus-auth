import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import Address from '@gravity-haus/gh-common/dist/models/address.model';

class AddressFactory extends SequelizeFactoryMixin(Address) {}

export const addressFactory = AddressFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    address1: params.address1 || '1336 27th Street',
    address2: params.address2 || '',
    address3: params.address3 || '',
    address4: params.address4 || '',
    city: params.city || 'Denver',
    county: params.county || '',
    state: params.state || 'CO',
    postalCode: params.postalCode || '80212',
    country: params.country || 'United States',
  };
});
