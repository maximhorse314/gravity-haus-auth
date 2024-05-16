// tslint:disable:no-console

import * as dotenv from 'dotenv';

const runAsScript = async (callback: () => void) => {
  dotenv.config();

  if (process.env.NODE_ENV === 'scripts') {
    (async () => {
      const totalStart = new Date();
      console.log('start time:', totalStart);
      await callback();
      const endTime = new Date();
      const seconds = (endTime.getTime() - totalStart.getTime()) / 1000;
      console.log('total run time in seconds:', seconds); // 3339.29
    })();
  } else {
    console.log('process.env.NODE_ENV must be set to "scripts" to run as a script');
  }
};

export default runAsScript;
