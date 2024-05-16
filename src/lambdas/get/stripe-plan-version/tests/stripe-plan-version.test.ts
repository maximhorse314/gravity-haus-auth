import method from '../stripe-plan-version';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';

import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import StripePlan from '@gravity-haus/gh-common/dist/models/stripePlan.model';
import StripePlanVersion from '@gravity-haus/gh-common/dist/models/stripePlanVersion.model';

import { stripePlanFactory } from '../../../../test-helpers/factories/stripePlan';
import stripePlanVersionFactory from '../../../../test-helpers/factories/stripePlanVersion';

describe('function', () => {
  beforeEach(async () => {
    jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
      return new Promise((resolve) => {
        return resolve({
          ...process.env,
        });
      });
    });
  });

  afterEach(async () => {
    await Promise.all([
      StripePlan.destroy({ where: {}, truncate: true }),
      StripePlanVersion.destroy({ where: {}, truncate: true }),
    ]);
  });

  describe('success', () => {
    it('should get a plan version by id', async () => {
      const version = await stripePlanVersionFactory.create({ active: true });

      const plan = await stripePlanFactory.create({
        stripePlanVersionId: version.dataValues.id,
      });

      const event = constructAPIGwEvent({ queryStringParameters: { id: version.dataValues.id } });
      const result = await method(event);

      expect(result.statusCode).toBe(200);

      const body = JSON.parse(result.body);
      expect(body.stripePlanVersion.id).toEqual(version.dataValues.id);
      expect(body.stripePlanVersion.stripePlans[0].id).toEqual(plan.dataValues.id);
    });

    it('should get the latest plan version when no id is passed', async () => {
      await stripePlanVersionFactory.create({ active: true }); // old version
      const newVersion = await stripePlanVersionFactory.create({ active: true });

      const event = constructAPIGwEvent({ queryStringParameters: {} });
      const result = await method(event);

      expect(result.statusCode).toBe(200);

      const body = JSON.parse(result.body);
      expect(body.stripePlanVersion.id).toEqual(newVersion.dataValues.id);
    });
  });

  // describe('failure', () => {
  //   it('should throw 401 Unauthorized', async () => {
  //     const event = constructAPIGwEvent({});
  //     const result = await method(event);
  //     expect(result.statusCode).toBe(401);
  //     expect(result.body).toContain('Unauthorized');
  //   });
  // });
});
