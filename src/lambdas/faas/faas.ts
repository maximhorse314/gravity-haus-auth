import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';

/**
 *
 * Event doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format
 * @param {Object} event - API Gateway Lambda Proxy Input Format
 *
 * Return doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
 * @returns {Object} object - API Gateway Lambda Proxy Output Format
 *
 */

export const lambdaHandler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  try {
    const result = await lazyLoad(event);

    if (result.default) return await result.default(event);
    return result;
  } catch (error) {
    // TODO: LOGS
    return {
      statusCode: error.statusCode || 500,
      body: JSON.stringify({ error, message: 'FAAS ERROR' }),
    };
  }
};

const getFunctionPath = (httpMethod: string, functionName: string): string => {
  const fName = `${functionName}/${functionName}`;
  // import functions from lambda layers
  let path = `/opt/nodejs/lambdas/${httpMethod}/${fName}`;
  if (process.env.LOCAL_FAAS === 'true') {
    // import functions from project src
    path = `${process.cwd()}/src/lambdas/${httpMethod}/${fName}`;
  }
  return path.toLowerCase();
};

export const lazyLoad = async (event: APIGatewayProxyEvent): Promise<any> => {
  const splitPathParameters = event.pathParameters.proxy.split('/');
  const functionName = splitPathParameters[splitPathParameters.length - 1];
  const functionPath = getFunctionPath(event.httpMethod, functionName);

  try {
    const method = await import(functionPath);
    return method;
  } catch (error) {
    // TODO: LOGS
    return response(500, { error });
  }
};
