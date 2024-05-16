import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import Phone from '@gravity-haus/gh-common/dist/models/phone.model';

class PhoneFactory extends SequelizeFactoryMixin(Phone) {}

export const phoneFactory = PhoneFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    countryCode: params.countryCode || 'us',
    number: params.number || 11234567890,
  };
});
