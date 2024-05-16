'use strict';

const exec = require('node-async-exec');

module.exports = {
  async up() {
    const copyDev = 'mysql --host=127.0.0.1 --port=3305 -uroot -ppassword gh_develop_db < ./seeders/schema.sql';
    const copyTest = 'mysql --host=127.0.0.1 --port=3305 -uroot -ppassword gh_develop_test < ./seeders/schema.sql';

    try {
      await exec({ cmd: copyDev });
      await exec({ cmd: copyTest });
    } catch (err) {
      console.log(err);
    }
  },

  down: () => {
    console.log('No Down');
  },
};