import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import getStripeClient from '../../../utils/get-stripe-client/get-stripe-client';

export const getCoupon = async (coupon: string, c1: string) => {
  const ghStripe = getStripeClient(c1 === 'true');

  const stripeCoupon = await ghStripe.client.coupons.retrieve(coupon);
  return stripeCoupon;
};

export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  try {
    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();

    const { coupon, c1 } = event.queryStringParameters;

    const stripeCoupon = await getCoupon(coupon, c1);

    return response(200, { stripeCoupon });
  } catch (error) {
    return response(500, { error });
  }
};
