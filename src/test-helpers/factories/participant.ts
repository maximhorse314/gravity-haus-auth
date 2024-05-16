import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import Participant from '@gravity-haus/gh-common/dist/models/participant.model';

class ParticipantFactory extends SequelizeFactoryMixin(Participant) {}

export const participantFactory = ParticipantFactory.define(({ sequence, params }) => {
  const dateNow = Date.now();
  return {
    id: sequence,
    accountId: params.accountId,
    userId: params.userId,
    firstName: params.firstName || '',
    middleName: params.middleName || '',
    lastName: params.lastName || '',
    dateOfBirth: params.dateOfBirth || dateNow,
    active: params.active || 1,
  };
});
