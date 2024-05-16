// tslint:disable:no-console

import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import ProspectTracker from '../../../models/prospectTracker.model';

const upsertProspectTracker = async (values: any = {}, id?: number, userId?: number) => {
  let tracker;
  tracker = await ProspectTracker.findByPk(id);

  if (tracker === null) {
    tracker = await ProspectTracker.create({ values: JSON.stringify(values), userId });
  } else {
    const currentValues = JSON.parse(tracker.values);
    tracker = await tracker.update({ values: JSON.stringify({ ...currentValues, ...values }), userId });
  }

  return tracker;
};

export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  try {
    const { id = null, userId = null, values = {} } = JSON.parse(event.body || JSON.stringify({}));

    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();

    Client.getInstance([ProspectTracker]);

    const prospect = await ProspectTracker.findByPk(id);

    const ip = event.headers['X-Forwarded-For'];

    const trackerValues = {
      ip,
      ...values,
    };

    const tracker = await upsertProspectTracker(trackerValues, prospect?.id, userId);

    return response(200, { prospectTrackerId: tracker.id });
  } catch (error) {
    return response(500, { error });
  }
};
