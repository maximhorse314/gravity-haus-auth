
'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    try {
      await queryInterface.describeTable('SignUpCouponPromotion')
    } catch (e) {
      await queryInterface.createTable('SignUpCouponPromotion', {
        id: {
          allowNull: false,
          autoIncrement: true,
          primaryKey: true,
          type: Sequelize.INTEGER
        },
        term: {
          allowNull: false,
          type: Sequelize.INTEGER,
        },
        active: {
          type: Sequelize.BOOLEAN,
        },
        pif: {
          type: Sequelize.BOOLEAN,
        },
        couponId: {
          allowNull: false,
          type: Sequelize.STRING,
        },
        name: {
          allowNull: false,
          type: Sequelize.STRING,
        },
        startDate: {
          allowNull: false,
          type: Sequelize.DATE,
        },
        endDate: {
          allowNull: false,
          type: Sequelize.DATE,
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
      await queryInterface.dropTable('SignUpCouponPromotion');
    } catch (e) {
      console.log('no table')
    }
  }
};
