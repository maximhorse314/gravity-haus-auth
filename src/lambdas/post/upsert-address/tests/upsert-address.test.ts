import method from '../upsert-address';
import * as auth from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import eventObj from './events/event';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';

import Address from '@gravity-haus/gh-common/dist/models/address.model';
import { addressFactory } from '../../../../test-helpers/factories/address';
import mockGetSecret from '../../../../test-helpers/mockGetSecret';

describe('function', () => {
  beforeEach(async () => {
    mockGetSecret();
  });

  afterEach(async () => {
    await Promise.all([Address.destroy({ where: {}, truncate: true })]);
  });

  describe('success', () => {
    it('should return a 200 and create a address rec', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const event = constructAPIGwEvent(
        eventObj({
          address1: 'address1',
          city: 'Denver',
          state: 'CO',
          postalCode: '80000',
          country: 'United States',
        }),
      );

      const result = await method(event);

      expect(result.statusCode).toBe(200);

      const body = JSON.parse(result.body);
      const newAddress = await Address.findByPk(body.address.id);
      expect(newAddress.address1).toEqual('address1');
      expect(newAddress.city).toEqual('Denver');
      expect(newAddress.state).toEqual('CO');
      expect(newAddress.postalCode).toEqual('80000');
      expect(newAddress.country).toEqual('United States');
    });

    it('should return a 200 and update a address rec', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const currentaddress = await addressFactory.create();

      const event = constructAPIGwEvent(
        eventObj({
          address2: 'HERE',
          id: currentaddress.dataValues.id,
        }),
      );
      const result = await method(event);

      expect(result.statusCode).toBe(200);

      const body = JSON.parse(result.body);
      const addressById = await Address.findByPk(body.address.id);
      expect(addressById.address2).toEqual('HERE');
      expect(addressById.address1).toEqual(currentaddress.address1);
    });
  });

  describe('failure', () => {
    it('should throw 401 Unauthorized', async () => {
      const event = constructAPIGwEvent({});
      const result = await method(event);
      expect(result.statusCode).toBe(401);
      expect(result.body).toContain('Unauthorized');
    });
  });
});
