import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import User from '@gravity-haus/gh-common/dist/models/user.model';

import method from '../prospect-tracker';
import eventObj from './events/event';

import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';
import { userFactory } from '../../../../test-helpers/factories/user';
import ProspectTracker from '../../../../models/prospectTracker.model';
import { prospectTrackerFactory } from '../../../../test-helpers/factories/prospectTracker';

describe('function', () => {
  Client.getInstance([ProspectTracker]);

  beforeEach(async () => {
    jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
      return new Promise((resolve) => {
        return resolve(process.env);
      });
    });
  });

  afterEach(async () => {
    await Promise.all([
      ProspectTracker.destroy({ where: {}, truncate: true }),
      User.destroy({ where: {}, truncate: true }),
    ]);
  });

  describe('success', () => {
    const ip = '00.000.000.000';
    it('should add a userId', async () => {
      const trackerF = await prospectTrackerFactory.create();
      const user = await userFactory.create();

      const event = constructAPIGwEvent(
        eventObj(
          {
            id: trackerF.dataValues.id,
            userId: user.dataValues.id,
          },
          {
            'X-Forwarded-For': ip,
          },
        ),
      );
      const result = await method(event);
      const { prospectTrackerId } = JSON.parse(result.body);

      expect(result.statusCode).toBe(200);

      const tracker = await ProspectTracker.findByPk(prospectTrackerId, { include: [{ model: User, as: 'user' }] });

      expect(tracker?.id).toEqual(trackerF.dataValues.id);
      expect(tracker?.user.id).toEqual(user.dataValues.id);
    });

    it('should create a new ProspectTracker', async () => {
      const event = constructAPIGwEvent(
        eventObj(
          {},
          {
            'X-Forwarded-For': ip,
          },
        ),
      );
      const result = await method(event);

      expect(result.statusCode).toBe(200);

      const { prospectTrackerId } = JSON.parse(result.body);

      const tracker = await ProspectTracker.findByPk(prospectTrackerId);
      expect(tracker?.id).toEqual(prospectTrackerId);
      expect(tracker?.values.includes(ip)).toBe(true);
    });

    it('should update a ProspectTracker', async () => {
      const trackerF = await prospectTrackerFactory.create({ values: JSON.stringify({ foo: 'bar' }) });

      const ip = '00.000.000.000';
      const event = constructAPIGwEvent(
        eventObj(
          {
            id: trackerF.dataValues.id,
            values: { cool: 'stuff' },
          },
          {
            'X-Forwarded-For': ip,
          },
        ),
      );
      const result = await method(event);

      expect(result.statusCode).toBe(200);

      const { prospectTrackerId } = JSON.parse(result.body);

      const tracker = await ProspectTracker.findByPk(prospectTrackerId);
      expect(tracker?.id).toEqual(trackerF.dataValues.id);
      expect(tracker?.values.includes('stuff')).toBe(true);
      expect(tracker?.values.includes('bar')).toBe(true);
    });
  });
});
