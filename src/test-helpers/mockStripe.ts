import StripeClient from '@gravity-haus/gh-common/dist/clients/stripe-client/gh-stripe';

export const mockStripe = (name: string, data: any) => {
  return jest.spyOn(StripeClient.prototype, name).mockImplementation((): Promise<any> => {
    return new Promise((resolve) => {
      return resolve(data);
    });
  });
};

export default mockStripe;
