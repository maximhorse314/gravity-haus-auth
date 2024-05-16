import { v4 as uuidv4 } from 'uuid';

import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import UserMembership from '@gravity-haus/gh-common/dist/models/userMembership.model';

class UserMembershipFactory extends SequelizeFactoryMixin(UserMembership) {}

export const userMembershipFactory = UserMembershipFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    subscriptionId: params.id,
    UserMembershipId: params.UserMembershipId,
  };
});
