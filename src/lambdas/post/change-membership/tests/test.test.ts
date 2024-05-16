import method from '../change-membership';
import * as auth from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import eventObj from './events/event';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';
import { Client } from '@gravity-haus/gh-common/dist/db/client';

describe('function', () => {
  jest.setTimeout(10000000);

  describe('success', () => {
    it.skip('here to test live ', async () => {
      // try {
      //   jest.spyOn(auth, 'default').mockReturnValue('token');
      //   Client.getInstance();
      //   const event = constructAPIGwEvent(
      //     eventObj({
      //       email: '',
      //       userId: 43,
      //       planId: 'plan_gh_traveler_individual_anylocation_12_months_110',
      //       c1: false,
      //       coupon: 'test',
      //     }),
      //   );
      //   const result = await method(event);
      //   console.log('result', result);
      //   expect(result.statusCode).toBe(200);
      // } catch (error) {
      //   console.log('what', error);
      // }
    });
  });
});
