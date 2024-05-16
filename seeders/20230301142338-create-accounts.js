'use strict';

// TODO: NEED TO RUN `npm run build` before running this seed file
const createAccount = require('../dist/lambdas/post/create-account/create-account');
const constructAPIGwEvent = require('../dist/test-helpers/constructAPIGwEvent');

const db = require('@gravity-haus/gh-common/dist/db/client');
const StripeClient = require('@gravity-haus/gh-common/dist/clients/stripe-client/gh-stripe')

const StripePlan = require('@gravity-haus/gh-common/dist/models/stripePlan.model')
const StripePlanVersion = require('@gravity-haus/gh-common/dist/models/stripePlanVersion.model')

const Subscription = require('@gravity-haus/gh-common/dist/models/subscription.model')
const MembershipApplication = require('@gravity-haus/gh-common/dist/models/membershipApplication.model')

const dotenv = require('dotenv')

const setFamilyMember = (plan, index) => {
  if (plan.membershipType === 'family') {
    // const name = `member${plan.membershipType}${plan.location}${index}`
    // return [{
    //   firstName: `${name}`,
    //   lastName: `lastName`,
    //   email: `${name}@test.com`,
    //   phoneNumber: '13031231234',
    //   countryCode: "us",
    //   dateOfBirth: '2000-01-01',
    // }]
    return []
  }
  return []
}

module.exports = {
  async up (queryInterface, Sequelize) {
    dotenv.config();
    process.env.SEEDS = 'true'
    process.env.ENV = 'local'

    try {
      db.Client.getInstance([], {
        database: 'gh_quiver_develop',
        username: 'root',
        password: 'password',
        host: 'localhost',
        port: 3305
      });

      const stripeClient = StripeClient.default.getInstance(`${process.env.STRIPE_API_KEY}`);

      const stripePlanVersions = await StripePlanVersion.default.findAll({
        where: { active: true },
        order: [['id', 'DESC']],
        limit: 1,
        include: [
          {
            model: StripePlan.default,
            as: 'stripePlans',
          },
        ],
      });

      const plans = stripePlanVersions[0].stripePlans.filter(p => !p.c1 && p.membershipType === 'family').slice(0, 10)
      const data = plans.map(async (p, index) => {

        const token = await stripeClient.client.tokens.create({
          card: {
            number: '4242424242424242',
            exp_month: 12,
            exp_year: 2040,
            cvc: '314',
          },
        });

        const name = `${p.membershipPlan}${p.membershipType}${index}`
        const event = constructAPIGwEvent.constructAPIGwEvent({
            body: JSON.stringify({
              c1: false,
              stripePlanId: p.planId,
              stripeToken: token.id,
              password: 'password',
              email: `${name}@test.com`,
              firstName: `${name}`,
              lastName: 'lastName',
              dateOfBirth: '2000-01-01',
              phoneNumber: '13031231234',
              phoneNumberCountryCode: 'us',
              address1: `${index} cool st`,
              city: 'Denver',
              state: 'CO',
              postalCode: '80222',
              familyMembers: setFamilyMember(p, index),
            })
          });

        const account = await createAccount.default(event)
        return account
      })

      const users = await Promise.all(data)
      console.log(users)
    } catch (error) {
      console.log('up error', error)
    }
  },

  async down (queryInterface, Sequelize) {
    dotenv.config();

    try {
      await queryInterface.bulkDelete('User');
      await queryInterface.bulkDelete('Account');
      await queryInterface.bulkDelete('Address');
      await queryInterface.bulkDelete('Phone');
      await queryInterface.bulkDelete('MembershipApplicationStatus');
      await queryInterface.bulkDelete('Participant');
    } catch (error) {
      console.log('down error', error)
    }
  }
};
