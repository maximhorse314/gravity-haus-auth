import { Client } from '@gravity-haus/gh-common/dist/db/client';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

const getSmAndDb = async () => {
  const secretsManager = SM.getInstance();

  await secretsManager.getSecret(process.env.ENV, process.env.SECRET_NAME);

  if (process.env.ENV === 'dev') {
    Client.getInstance([], { host: 'localhost' });
  } else {
    Client.getInstance();
  }
};

export default getSmAndDb;
