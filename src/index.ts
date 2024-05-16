// tslint:disable:no-console

import express, { Request, Response } from 'express';
import bodyParser from 'body-parser';
import { createServer, Server } from 'http';
import { config } from 'dotenv';
import { APIGatewayProxyEvent } from 'aws-lambda';
import { lambdaHandler } from './lambdas/faas/faas';
import cors from 'cors';

config();

const app = express();
const port = 9000;

app.use(bodyParser.json());
app.use(cors());

const getProxy = (url: string): string => {
  let proxy = `${process.env.PROJECT_NAME}${url}`.replace('/faas/', '/');

  if (proxy[proxy.length - 1] === '/') {
    proxy = proxy.slice(0, -1);
  }
  return proxy;
};

app.all('*', async (req: Request, res: Response): Promise<any> => {
  const event: APIGatewayProxyEvent = {
    body: JSON.stringify(req.body),
    headers: {
      Authorization: req.headers.authorization,
    },
    httpMethod: req.method,
    isBase64Encoded: false,
    path: req.path,
    pathParameters: {
      proxy: getProxy(req.params['0']),
    },
    queryStringParameters: req.query as any,
    requestContext: null,
    resource: '',
    stageVariables: null,
    multiValueHeaders: undefined,
    multiValueQueryStringParameters: undefined,
  };

  const lambda = await lambdaHandler(event);
  res.status(lambda.statusCode);
  res.send(lambda.body);
});

const server: Server = createServer(app);

server.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});

process.on('SIGINT', () => {
  console.log('Server shutting down');
  server.close();
  process.exit();
});
