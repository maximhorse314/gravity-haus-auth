// tslint:disable:no-console

// npm run secret:read:<dev | stage | prod>

import fs from 'fs';
import * as dotenv from 'dotenv';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

const getSecretValue = async () => {
  dotenv.config();
  process.env.SCRIPT = 'true';

  const secretsManager = SM.getInstance();
  const secret = await secretsManager.getSecret();

  const path = `secrets/${secret.ENV}.json`;
  fs.writeFile(path, JSON.stringify(secret, null, 4), () => {
    return;
  });

  console.log(`Write File ${path}`);
  process.env.SCRIPT = '';
};

(async () => {
  await getSecretValue();
})();
