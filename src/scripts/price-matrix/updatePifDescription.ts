// tslint:disable:no-console
import runAsScript from '../run-as-script';
import getSmAndDb from './utils/getSmAndDb';

import StripePlan from '@gravity-haus/gh-common/dist/models/stripePlan.model';
import StripePlanVersion from '@gravity-haus/gh-common/dist/models/stripePlanVersion.model';

const formatNumber = (num: number) => {
  return num.toLocaleString('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  });
};

export const script = async () => {
  try {
    await getSmAndDb();

    const versions = await StripePlanVersion.findAll({
      where: {},
      order: [['id', 'DESC']],
      include: [
        {
          model: StripePlan,
          as: 'stripePlans',
        },
      ],
    });

    const version = versions[0];
    const stripePlans = await StripePlan.findAll({ where: { stripePlanVersionId: version.id } });

    const pifs = stripePlans.filter((sp) => sp.planId.includes('_pif'));

    const pifsWithSavings = pifs.map(async (p) => {
      const cost = p.unitAmount / 100;
      const savings = Math.trunc((11.12 / 100) * cost);

      // if (p.term === 12) savings = savings * 2; // THIS IS FOR FEB PROMO

      const description = `${p.term} months (${formatNumber(cost)} Pay in full and save ${formatNumber(savings)})`;
      return p.update({ description });
    });

    await Promise.all(pifsWithSavings);
  } catch (error) {
    console.log('error ===', error);
  }
};

// run file with comand:
// NODE_ENV='scripts' SECRET_NAME='dev' npx ts-node -T src/scripts/price-matrix/updatePifDescription.ts
runAsScript(script);

// NODE_ENV='scripts' SECRET_NAME='prod' npx ts-node -T src/scripts/price-matrix/updatePifDescription.ts
