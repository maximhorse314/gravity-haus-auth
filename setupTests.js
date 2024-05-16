
const ClientClass = require('@gravity-haus/gh-common/dist/db/client')
const HttpRequestMock = require('http-request-mock');

const ogEnv = process.env
let mocker

const mockBaseUrl = (url) => {
  mocker.mock({ url, method: 'get', status: 200, body: {} });
  mocker.mock({ url, method: 'post', status: 200, body: {} });
  mocker.mock({ url, method: 'put', status: 200, body: {} });
  mocker.mock({ url, method: 'patch', status: 200, body: {} });
  mocker.mock({ url, method: 'delete', status: 200, body: {} });
  mocker.mock({ url, method: 'head', status: 200, body: {} });
}

beforeAll(async () => {
    ClientClass.Client.getInstance([]);
    mocker = HttpRequestMock.default.setup();
    mockBaseUrl(`https://api.hubapi.com/`)
    mockBaseUrl(`https://api.stripe.com/`)
})

afterAll(async () => {
    process.env = ogEnv
    mocker.reset()
    await ClientClass.Client.close()
})
