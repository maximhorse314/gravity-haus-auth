// tslint:disable:no-console

// npm run secret:update:<dev | stage | prod>

import { SecretsManagerClient, UpdateSecretCommand } from '@aws-sdk/client-secrets-manager';

import fs from 'fs';

import * as dotenv from 'dotenv';

const updateSecret = async () => {
  dotenv.config();
  process.env.SCRIPT = 'true';

  const evnName = process.env.ENV;
  const secretName = process.env.SECRET_NAME;
  const secretId = `${secretName}/${evnName}`;

  const secretString = fs.readFileSync(`secrets/${evnName}.json`, 'utf8');

  const client = new SecretsManagerClient({
    region: 'us-east-1',
  });

  try {
    const command = new UpdateSecretCommand({
      SecretId: secretId,
      SecretString: secretString,
    });
    await client.send(command);
    console.log(`Updated ${secretId}`);
    process.env.SCRIPT = '';
  } catch (error) {
    console.log('Error', error);
  }
};

(async () => {
  await updateSecret();
})();
