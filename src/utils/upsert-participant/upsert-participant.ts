import Participant from '@gravity-haus/gh-common/dist/models/participant.model';

export const upsertParticipant = async (participantFields: any, query: any) => {
  let participant;
  participant = await Participant.findOne(query);

  if (participant === null) {
    participant = await Participant.create({
      middleName: '',
      ...participantFields,
    });
  } else {
    participant = await participant.update(participantFields);
  }

  return participant;
};

export default upsertParticipant;
