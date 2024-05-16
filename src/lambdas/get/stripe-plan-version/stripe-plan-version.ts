import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import StripePlan from '@gravity-haus/gh-common/dist/models/stripePlan.model';
import StripePlanVersion from '@gravity-haus/gh-common/dist/models/stripePlanVersion.model';

export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  try {
    const id = event?.queryStringParameters?.id;

    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();

    Client.getInstance();

    let where = { active: true } as any;
    if (id) {
      where = { active: true, id };
    }

    const stripePlanVersions = await StripePlanVersion.findAll({
      where,
      order: [['id', 'DESC']],
      limit: 1,
      include: [
        {
          model: StripePlan,
          as: 'stripePlans',
        },
      ],
    });

    return response(200, { stripePlanVersion: stripePlanVersions[0] });
  } catch (error) {
    return response(500, { error });
  }
};
