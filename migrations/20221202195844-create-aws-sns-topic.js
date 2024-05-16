
'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    try {
      const tableName = 'AwsSnsTopic'
      await queryInterface.describeTable(tableName)
    } catch (e) {
      await queryInterface.createTable('AwsSnsTopic', {
        id: {
          allowNull: false,
          autoIncrement: true,
          primaryKey: true,
          type: Sequelize.INTEGER
        },
        name: {
          allowNull: false,
          type: Sequelize.STRING,
        },
        topicArn: {
          allowNull: false,
          type: Sequelize.STRING,
        },
        createdAt: {
          allowNull: false,
          type: Sequelize.DATE,
          defaultValue: Sequelize.literal('NOW()'),
        },
        updatedAt: {
          allowNull: false,
          type: Sequelize.DATE,
          defaultValue: Sequelize.literal('NOW()'),
        },
      });
    }
  },

  async down (queryInterface, Sequelize) {
    try {
      await queryInterface.dropTable('AwsSnsTopic');
    } catch (e) {
      console.log('no table')
    }
  }
};
