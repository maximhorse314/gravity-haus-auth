
'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    try {
      const tableName = 'AwsSnsTopic'
      await queryInterface.bulkInsert(tableName, [{
        name: 'register-account-owner',
        topicArn: 'local'
      }]);
    } catch (e) {
      console.log(e)
    }
  },

  async down (queryInterface, Sequelize) {
    try {
      await queryInterface.bulkDelete('AwsSnsTopic', {name: 'register-account-owner'}, {})
    } catch (error) {
      console.log(error)
    }
  }
};
