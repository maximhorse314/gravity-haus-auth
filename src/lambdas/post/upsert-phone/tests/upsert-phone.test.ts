import method from '../upsert-phone';
import * as auth from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import eventObj from './events/event';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';

import Phone from '@gravity-haus/gh-common/dist/models/phone.model';
import { phoneFactory } from '../../../../test-helpers/factories/phone';
import mockGetSecret from '../../../../test-helpers/mockGetSecret';

describe('function', () => {
  beforeEach(async () => {
    mockGetSecret();
  });

  afterEach(async () => {
    await Promise.all([Phone.destroy({ where: {}, truncate: true })]);
  });

  describe('success', () => {
    it('should return a 200 and create a phone rec', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const phoneNumber = '13033031234';
      const event = constructAPIGwEvent(
        eventObj({
          phoneNumber,
          countryCode: 1,
        }),
      );

      const result = await method(event);

      expect(result.statusCode).toBe(200);

      const body = JSON.parse(result.body);
      const newNumber = await Phone.findByPk(body.phone.id);
      expect(newNumber.number).toEqual(3033031234);
    });

    it('should return a 200 and update a phone rec', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token');

      const currentPhone = await phoneFactory.create({ number: 3033033033 });

      const event = constructAPIGwEvent(
        eventObj({
          phoneNumber: '13034567890',
          id: currentPhone.dataValues.id,
        }),
      );
      const result = await method(event);

      expect(result.statusCode).toBe(200);

      const body = JSON.parse(result.body);
      const numberById = await Phone.findByPk(body.phone.id);
      expect(numberById.number).toEqual(3034567890);
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
