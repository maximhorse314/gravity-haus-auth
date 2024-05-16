require('dotenv').config({ path: '.test.env' });

module.exports = {
  transform: {
    '^.+\\.(t|j)sx?$': 'ts-jest',
  },
  testRegex: '(/__tests__/.*|(\\.|/)(test|spec))\\.(jsx?|tsx?)$',
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
  modulePathIgnorePatterns: ['dist'],
  setupFilesAfterEnv: ['<rootDir>/setupTests.js'],
  resetMocks: true,
  restoreMocks: true,
};