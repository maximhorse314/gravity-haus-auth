const getAllPlans = (prices) => {
  return prices.map((price) => {
    Object.entries(price).forEach((p) => {
      const key = p[0];
      if (key.includes('|')) {
        const value = p[1];
        const locations = key.replace('Local', '').replace('Family', '').replace('WP', 'Winterpark').split('|');

        if (key.includes('Family')) {
          locations.forEach((location) => {
            price[`Local${location}Family`] = value;
          });
        } else {
          locations.forEach((location) => {
            price[`Local${location}`] = value;
          });
        }

        delete price[key];
      }
    });

    return price;
  });
};

export default getAllPlans;
