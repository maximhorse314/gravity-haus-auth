import method from '../create-terms-and-conditions';
import eventObj from './events/event';
import { constructAPIGwEvent } from '../../../../test-helpers/constructAPIGwEvent';

import Docusign from '@gravity-haus/gh-common/dist/clients/docusign/docusign';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

describe('cancel function', () => {
  beforeEach(async () => {
    jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
      return new Promise((resolve) => {
        return resolve(process.env);
      });
    });
  });

  describe('success', () => {
    it('should return a 200', async () => {
      const setHeadersSpy = jest.spyOn(Docusign.prototype, 'setHeaders').mockImplementation((): Promise<any> => {
        return new Promise((resolve) => {
          return resolve({});
        });
      });

      const envelopeSpy = jest
        .spyOn(Docusign.prototype, 'createEnvelope')
        .mockImplementation((email: string, fullName: string, templateId: string): Promise<any> => {
          return new Promise((resolve) => {
            return resolve({ url: 'cool.com' });
          });
        });

      const envelopeViewSpy = jest
        .spyOn(Docusign.prototype, 'getEnvelopeView')
        .mockImplementation((email: string, fullName: string, returnUrl: string, envelopeId: string): Promise<any> => {
          return new Promise((resolve) => {
            return resolve({ url: 'cool.com' }) as any;
          });
        });

      const event = constructAPIGwEvent(
        eventObj({
          email: 'test@test.com',
          userName: 'cool@guy.com',
        }),
      );

      const result = await method(event);

      expect(result.statusCode).toBe(200);
      expect(result.body.includes('cool.com')).toBe(true);
      expect(envelopeSpy).toBeCalled();
      expect(envelopeViewSpy).toBeCalled();
      expect(setHeadersSpy).toBeCalled();
    });
  });
});
