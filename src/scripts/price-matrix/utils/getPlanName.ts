const pifText = (isPif = false): string => {
  return isPif ? 'PIF' : '';
};

const localNameMapper = (key: string, term: number, isPif = false): string => {
  // // Gravity Haus Local Family 6-Month Membership (Tahoe)

  // LocalDenver || LocalDenverFamily
  const parts = key.match(/[A-Z][a-z]+/g);
  const location = parts[1];

  let name;
  if (key.includes('Family')) {
    name = `Local Family ${pifText(isPif)} ${term}-Month Membership (${location})`;
  } else {
    name = `Local Individual ${pifText(isPif)} ${term}-Month Membership (${location})`;
  }
  return name.replace('  ', ' ');
};

const allInNameMapper = (key: string, term: number, isPif = false): string => {
  // // All In Family 12-Month Membership
  // All In Individual 12-Month Membership

  let name;
  if (key.includes('Family')) {
    name = `All In Family ${pifText(isPif)} ${term}-Month Membership`;
  } else {
    name = `All In Individual ${pifText(isPif)} ${term}-Month Membership`;
  }
  return name.replace('  ', ' ');
};

const travelerNameMapper = (key: string, term: number, isPif = false): string => {
  // 'Traveler Individual 12-Month Membership',
  let name;
  if (key.includes('Family')) {
    name = `Traveler Family ${pifText(isPif)} ${term}-Month Membership`;
  } else {
    name = `Traveler Individual ${pifText(isPif)} ${term}-Month Membership`;
  }
  return name.replace('  ', ' ');
};

const getName = (key: string, term: number, isPif = false) => {
  let product = '';
  if (key.includes('Local')) {
    product = localNameMapper(key, term, isPif);
  } else if (key.includes('All-In')) {
    product = allInNameMapper(key, term, isPif);
  } else if (key.includes('Traveler')) {
    product = travelerNameMapper(key, term, isPif);
  }

  return `Gravity Haus ${product}`;
};

export default getName;
