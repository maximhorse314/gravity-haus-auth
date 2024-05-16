export default (id) => ({
  httpMethod: 'POST',
  body: `{ "id": "${id}" }`,
});
