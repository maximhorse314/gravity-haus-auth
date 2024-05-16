export default (body = {}, headers = {}) => ({
  headers,
  body: JSON.stringify(body),
});
