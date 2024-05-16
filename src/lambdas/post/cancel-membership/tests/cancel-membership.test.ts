import { Client } from '@gravity-haus/gh-common/dist/db/client';
import * as auth from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import User from '@gravity-haus/gh-common/dist/models/user.model';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

import method from '../cancel-membership';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';
import event from './events/event';

import { userFactory } from '../../../../test-helpers/factories/user';

import { membershipApplicationStatusFactory } from '../../../../test-helpers/factories/membershipApplicationStatus';
import MembershipApplicationStatus, { StatusEnum } from '../../../../models/membershipApplicationStatus.model';

describe('cancel membership', () => {
  Client.getInstance([User, MembershipApplicationStatus]);

  let user;
  let membershipApplicationStatus;
  beforeEach(async () => {
    jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
      return new Promise((resolve) => {
        return resolve({
          ...process.env,
        });
      });
    });

    // create user for test
    user = await userFactory.create();
    membershipApplicationStatus = await membershipApplicationStatusFactory.create({ userId: user.dataValues.id });
  });

  afterEach(async () => {
    // delete every this so we always start fresh
    await User.destroy({
      where: {},
      truncate: true,
    });

    await MembershipApplicationStatus.destroy({
      where: {},
      truncate: true,
    });
  });

  describe('success', () => {
    it('should return a 200, update a MembershipApplicationStatus to CANCEL and hit the stripe api', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token'); // pass auth

      const lambdaEvent = constructAPIGwEvent(event(user.dataValues.id));
      const result = await method(lambdaEvent);
      expect(result.statusCode).toBe(200);

      const status = await MembershipApplicationStatus.findByPk(membershipApplicationStatus.dataValues.id);
      expect(status?.status).toBe(StatusEnum.CANCEL);

      expect(result?.body).toContain(`${membershipApplicationStatus.dataValues.userId}`);

      const deactivatedUser = await User.findByPk(membershipApplicationStatus.dataValues.userId);
      expect(deactivatedUser?.email).toContain('DEACTIVATED__');
    });

    it('should return a 200 should not update an email of an already deactivated member', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token'); // pass auth

      const deactivatedEmail = 'DEACTIVATED__cool@email.com__b2328188-894a-4e3f-88f8-cc0a7a18edad';
      await user.update({ email: deactivatedEmail });

      const lambdaEvent = constructAPIGwEvent(event(user.dataValues.id));
      const result = await method(lambdaEvent);
      expect(result.statusCode).toBe(200);

      const status = await MembershipApplicationStatus.findByPk(membershipApplicationStatus.dataValues.id);
      expect(status?.status).toBe(StatusEnum.CANCEL);

      expect(result?.body).toContain(`${membershipApplicationStatus.dataValues.id}`);

      const deactivatedUser = await User.findByPk(membershipApplicationStatus.dataValues.userId);
      expect(deactivatedUser?.email).toEqual(deactivatedEmail);
    });
  });

  describe('failure', () => {
    it('should return a 401 when unauthorized', async () => {
      const lambdaEvent = constructAPIGwEvent(event(user.dataValues.id));
      const result = await method(lambdaEvent);
      expect(result.statusCode).toBe(401);
    });

    it('should return a 404 when a membership does not exist', async () => {
      await MembershipApplicationStatus.destroy({
        where: {},
        truncate: true,
      });

      jest.spyOn(auth, 'default').mockReturnValue('token'); // pass auth

      const lambdaEvent = constructAPIGwEvent(event(user.dataValues.id));
      const result = await method(lambdaEvent);
      expect(result.statusCode).toBe(404);
      expect(result?.body).toContain('Membership does not exist');
    });

    it('should return a 500 when a user id is not valid', async () => {
      jest.spyOn(auth, 'default').mockReturnValue('token'); // pass auth

      const lambdaEvent = constructAPIGwEvent(event('bad'));
      const result = await method(lambdaEvent);
      expect(result.statusCode).toBe(500);
      expect(result?.body).toContain('Failed to find account for deactivation');
    });
  });
});
