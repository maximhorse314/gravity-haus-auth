
  'use strict';

  /** @type {import('sequelize-cli').Migration} */
  module.exports = {
    async up (queryInterface, Sequelize) {
      try {
        const tableName = 'AwsSnsTopic'
        await queryInterface.bulkInsert(tableName, [{
          name: 'ca-participants',
          topicArn: 'local'
        }]);
      } catch (e) {
        console.log(e)
      }
    },
  
    async down (queryInterface, Sequelize) {
      try {
        await queryInterface.bulkDelete('AwsSnsTopic', {name: 'ca-participants'}, {})
      } catch (error) {
        console.log(error)
      }
    }
  };

  