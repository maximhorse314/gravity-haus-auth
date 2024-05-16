import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import StripeClient from '@gravity-haus/gh-common/dist/clients/stripe-client/gh-stripe';

import method from '../stripe-coupon';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';

describe('function', () => {
  let mockInstance = {
    client: {
      coupons: {
        retrieve: jest.fn(),
      },
    },
  };

  beforeEach(async () => {
    jest.spyOn(StripeClient, 'getInstance').mockReturnValue(mockInstance);

    jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
      return new Promise((resolve) => {
        return resolve(process.env);
      });
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('success', () => {
    it('should return a 200', async () => {
      const event = constructAPIGwEvent({ queryStringParameters: { coupon: 'here' } });
      const result = await method(event);
      expect(result.statusCode).toBe(200);
      expect(mockInstance.client.coupons.retrieve).toBeCalled();
    });
  });

  describe('failure', () => {
    it('should throw 500 Unauthorized', async () => {
      const event = constructAPIGwEvent({});
      const result = await method(event);
      expect(result.statusCode).toBe(500);
    });
  });
});
