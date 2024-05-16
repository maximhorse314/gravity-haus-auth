import HubspotClient from '@gravity-haus/gh-common/dist/hubspot-client/hubspot-client';

export const mockHubspot = (method: string) => {
  jest.mock('@gravity-haus/gh-common/dist/hubspot-client/hubspot-client');
  const mock = jest.fn();
  HubspotClient.getInstance = () => ({
    [method]: mock,
  });
  return mock;
};

export default mockHubspot;
