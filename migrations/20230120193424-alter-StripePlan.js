
'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    try {
      const t = 'StripePlan'
      const { STRING, BOOLEAN, INTEGER, BIGINT } = Sequelize

      await queryInterface.addColumn(t,'membershipPlan', STRING);
      await queryInterface.addColumn( t,'membershipType', STRING);
      await queryInterface.addColumn(t, 'location', STRING);
      await queryInterface.addColumn(t,'c1', BOOLEAN );
      await queryInterface.addColumn(t, 'term', INTEGER);
      await queryInterface.addColumn(t, 'unitAmount', BIGINT);

    } catch (error) {
      console.log('error', error)
    }
  },

  async down (queryInterface) {
    try {
      const t = 'StripePlan'
      await queryInterface.removeColumn(t, 'membershipPlan');
      await queryInterface.removeColumn(t, 'membershipType');
      await queryInterface.removeColumn(t, 'term');
      await queryInterface.removeColumn(t, 'location');
      await queryInterface.removeColumn(t, 'c1');
      await queryInterface.removeColumn(t, 'unitAmount');
    } catch (error) {
      console.log('error', error)
    }
  }
};
