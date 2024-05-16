import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';

export const mockGetSecret = (envVars: any = {}) => {
  return jest.spyOn(SM.prototype, 'getSecret').mockImplementation(() => {
    return new Promise((resolve) => {
      return resolve({ ...process.env, ...envVars });
    });
  });
};

export default mockGetSecret;
