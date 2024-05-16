import { v4 as uuidv4 } from 'uuid';

import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import User from '@gravity-haus/gh-common/dist/models/user.model';

class UserFactory extends SequelizeFactoryMixin(User) {}

export const userFactory = UserFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    email: params.email || `gh-dev${sequence}@gravityhaus.com`,
    password: '$2a$04$RWtPV5CfUWktdmCCYuHxE.UtbY3UiJWI7s8EOVuWlXPPRLm96WtCq', // = password
    roleId: params.roleId,
    uuid: params.uuid || uuidv4(),
    createdAt: Date.now(),
    updatedAt: Date.now(),
  };
});
