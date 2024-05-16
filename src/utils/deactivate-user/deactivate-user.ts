import { v4 as uuidv4 } from 'uuid';

import User from '@gravity-haus/gh-common/dist/models/user.model';

/**
 * Deactivate a user
 * @param user The user to deactivate
 * @param transaction Sequelize.transaction or undefind
 * @returns the updated record of the user
 */
export const deactivateUser = (user: User, transaction?: any): Promise<User> => {
  const email = user.email.includes('DEACTIVATED__') ? user.email : `DEACTIVATED__${user.email}__${uuidv4()}`;
  user.email = email;

  return user.save({ transaction });
};

export default deactivateUser;
