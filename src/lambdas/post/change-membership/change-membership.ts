import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import verifyToken from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import updateStripe from './utils/update-stripe';
import getAccountHolder from './utils/get-account-holder';

import { getCoupon } from '../../get/stripe-coupon/stripe-coupon';
import isOwner from '../../../utils/get-stripe-account-owner/get-stripe-account-owner';

export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  process.env.TZ = 'America/Denver';

  try {
    verifyToken(event);
  } catch {
    return response(401, { message: 'Unauthorized' });
  }

  const body = JSON.parse(event.body || '');
  const { email, planId, c1, coupon, userId } = body;
  try {
    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();
    Client.getInstance();

    if (coupon) {
      try {
        const verifyStripeCouponRes = await getCoupon(coupon, c1);
        if (!verifyStripeCouponRes.valid) {
          return response(404, { error: 'Invalid Coupon' });
        }
      } catch (error) {
        return response(404, { error: 'Invalid Coupon' });
      }
    }

    const accountHolder = await getAccountHolder({ userId, email });

    const owner = await isOwner(accountHolder[0]);
    if (!owner) return response(400, { error: 'Only The Account Owner Can Change A Membership.' });

    await updateStripe(accountHolder[0], planId, coupon, c1);

    return response(200, { accountHolder });
  } catch (error) {
    return response(500, { error });
  }
};
