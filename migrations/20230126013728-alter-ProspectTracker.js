
'use strict';

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    try {
      const t = 'ProspectTracker'
      const { INTEGER } = Sequelize
      await queryInterface.addColumn(t, 'userId', INTEGER);

    } catch (error) {
      console.log('error', error)
    }
  },

  async down (queryInterface) {
    try {
      const t = 'ProspectTracker'
      await queryInterface.removeColumn(t, 'userId');
    } catch (error) {
      console.log('error', error)
    }
  }
};
