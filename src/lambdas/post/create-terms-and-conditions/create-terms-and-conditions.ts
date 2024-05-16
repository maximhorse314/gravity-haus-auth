import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import Docusign from '@gravity-haus/gh-common/dist/clients/docusign/docusign';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  try {
    const { email, userName } = JSON.parse(event.body || '');

    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();

    const docusignClient = await Docusign.getInstance();
    const templateId = 'eab3f140-3d52-44b2-a4ee-2910621c18e2';
    const returnUrl = `${docusignClient.DOCUSIGN_REDIRECT_URI}/waiver-signed?hide_nav=true`;

    const envelope = await docusignClient.createEnvelope(email, userName, templateId);
    const envelopeView = await docusignClient.getEnvelopeView(email, userName, returnUrl, envelope.envelopeId);

    return response(200, { url: envelopeView.url });
  } catch (error) {
    return response(500, { error });
  }
};
