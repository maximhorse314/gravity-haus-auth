
'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    try {
      await queryInterface.describeTable('StripePlan')
    } catch (e) {
      await queryInterface.createTable('StripePlan', {
        id: {
          allowNull: false,
          autoIncrement: true,
          primaryKey: true,
          type: Sequelize.INTEGER
        },

        stripePlanVersionId: {
          allowNull: false,
          type: Sequelize.INTEGER,
        },

        intervalCount: {
          allowNull: false,
          type: Sequelize.INTEGER,
        },
        
        planId: {
          allowNull: false,
          type: Sequelize.STRING,
        },
        name: {
          allowNull: false,
          type: Sequelize.STRING,
        },

        interval: {
          allowNull: false,
          type: Sequelize.STRING,
        },

        description: {
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
      await queryInterface.dropTable('StripePlan');
    } catch (e) {
      console.log('no table')
    }
  }
};
