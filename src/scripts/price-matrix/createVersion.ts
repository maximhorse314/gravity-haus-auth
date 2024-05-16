// tslint:disable:no-console

import csvToJson from 'convert-csv-to-json';

import runAsScript from '../run-as-script';
import getAllPlans from './utils/getAllPlans';
import createStripePlans from './utils/createStripePlans';
import mapCsvPricesToProducts from './utils/mapCsvPricesToPlans';
import createStripePlanVersion from './utils/createStripePlanVersion';
import getSmAndDb from './utils/getSmAndDb';

export const getProducts = (prices: any[], termString: string) => {
  return prices.find((x) => x.Term.toLowerCase().includes(termString.toLowerCase()));
};

const readCsvAsJson = (fileName: string = 'February 2023 Matrix.csv') => {
  return csvToJson
    .fieldDelimiter(',')
    .getJsonFromCsv(`src/scripts/price-matrix/price-matrix-csvs/${fileName}`)
    .map((x) => {
      Object.entries(x).map((y) => {
        x[y[0]] = x[y[0]].replaceAll('"', '');
      });
      return x;
    });
};

export const script = async () => {
  try {
    await getSmAndDb();

    let prices = readCsvAsJson(process.env.CSV);
    prices = getAllPlans(prices);

    const priceMap = [
      ...mapCsvPricesToProducts({
        products: getProducts(prices, '12mo - Monthly charge'),
        term: 12,
        interval: 'month',
        intervalCount: 1,
      }),
      ...mapCsvPricesToProducts({
        products: getProducts(prices, '6mo - Monthly charge'),
        term: 6,
        interval: 'month',
        intervalCount: 1,
      }),
      ...mapCsvPricesToProducts({
        products: getProducts(prices, '12mo PIF Annual (10% off)'),
        term: 12,
        interval: 'year',
        intervalCount: 1,
        isPif: true,
      }),
      // ...mapCsvPricesToProducts({
      //   products: getProducts(prices, '12mo PIF Annual (20% off) Feb 2023 promo'),
      //   term: 12,
      //   interval: 'year',
      //   intervalCount: 1,
      //   isPif: true,
      // }),
      ...mapCsvPricesToProducts({
        products: getProducts(prices, '6mo PIF - 10%'),
        term: 6,
        interval: 'month',
        intervalCount: 6,
        isPif: true,
      }),
      ...mapCsvPricesToProducts({
        products: getProducts(prices, '1 PIF'),
        term: 1,
        interval: 'month',
        intervalCount: 1,
      }),
    ];

    const plans = await createStripePlans({ priceMap });

    const c1PriceMap = [
      ...mapCsvPricesToProducts({
        products: getProducts(prices, '12mo C1 Monthly'),
        term: 12,
        interval: 'month',
        intervalCount: 1,
        isC1: true,
      }),
      ...mapCsvPricesToProducts({
        products: getProducts(prices, '12mo C1 Annual'),
        term: 12,
        interval: 'year',
        intervalCount: 1,
        isPif: true,
        isC1: true,
      }),
    ];

    const c1Plans = await createStripePlans({
      priceMap: c1PriceMap,
      isC1: true,
    });

    await createStripePlanVersion([...plans, ...c1Plans]);
  } catch (error) {
    console.log('error ===', error);
  }
};

// run file with comand:
// NODE_ENV='scripts' CSV='February 2023 Matrix.csv' SECRET_NAME='dev' npx ts-node -T src/scripts/price-matrix/createVersion.ts
runAsScript(script);

// NODE_ENV='scripts' CSV='February 2023 Matrix.csv' SECRET_NAME='prod' npx ts-node -T src/scripts/price-matrix/createVersion.ts
