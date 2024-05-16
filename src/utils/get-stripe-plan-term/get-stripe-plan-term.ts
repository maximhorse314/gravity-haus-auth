export const getStripePlanTerm = (priceId) => {
  const split = priceId.split('_');
  const monthsIndex = split.indexOf('months');
  const term = split[monthsIndex - 1];
  return parseInt(term, 10);
};

export default getStripePlanTerm;
