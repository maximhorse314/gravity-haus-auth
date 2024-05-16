const allInIdMapper = (key: string, value: string, term: number, isPif: boolean) => {
  // plan_gh_allin_individual_anylocation_12_months_200
  // plan_gh_allin_family_anylocation_12_months_400
  const pif = isPif ? '_pif' : '';

  let id;
  if (key.includes('Family')) {
    id = `allin_family_anylocation_${term}_months_${value}${pif}`;
  } else {
    id = `allin_individual_anylocation_${term}_months_${value}${pif}`;
  }
  return id.toLowerCase();
};

const travelerIdMapper = (key: string, value: string, term: number, isPif: boolean) => {
  // plan_gh_weekender_individual_anylocation_12_months_100
  // plan_gh_weekender_family_anylocation_12_months_200

  const pif = isPif ? '_pif' : '';

  let id;
  if (key.includes('Family')) {
    id = `traveler_family_anylocation_${term}_months_${value}${pif}`;
  } else {
    id = `traveler_individual_anylocation_${term}_months_${value}${pif}`;
  }
  return id.toLowerCase();
};

const localIdMapper = (key: string, value: string, term: number, isPif: boolean): string => {
  // plan_gh_local_family_vail_12_months_300
  // plan_gh_local_individual_vail_6_months_190

  const pif = isPif ? '_pif' : '';

  // LocalDenver || LocalDenverFamily
  const parts = key.match(/[A-Z][a-z]+/g);
  const location = parts[1];

  let id;
  if (key.includes('Family')) {
    id = `local_family_${location}_${term}_months_${value}${pif}`;
  } else {
    id = `local_individual_${location}_${term}_months_${value}${pif}`;
  }

  return id.toLowerCase();
};

const getId = (key: string, value: string, term: number, isPif: boolean, isC1: boolean) => {
  let product = '';
  if (key.includes('Local')) {
    product = localIdMapper(key, value, term, isPif);
  }

  if (key.includes('All-In')) {
    product = allInIdMapper(key, value, term, isPif);
  }

  if (key.includes('Traveler')) {
    product = travelerIdMapper(key, value, term, isPif);
  }

  const plan = isC1 ? 'plan_ghc1_' : 'plan_gh_';
  return `${plan}${product}`;
};

export default getId;
