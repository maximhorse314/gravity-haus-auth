import User from '@gravity-haus/gh-common/dist/models/user.model';
import MembershipApplicationStatus from '@gravity-haus/gh-common/dist/models/membershipApplicationStatus.model';
import Account from '@gravity-haus/gh-common/dist/models/account.model';
import GhStripe from '@gravity-haus/gh-common/dist/models/stripe.model';
import { Op } from 'sequelize';
import { v4 as uuidv4 } from 'uuid';
import { genSalt, hash } from 'bcryptjs';

const getUserPassword = async (user: User, plainTextPassword?: string) => {
  let userPassword = user?.password;
  if (plainTextPassword) {
    const salt = await genSalt(10);
    userPassword = await hash(plainTextPassword, salt);
  }

  return userPassword;
};

export const upsertUserByEmail = async (email: string, plainTextPassword?: string): Promise<User> => {
  let user;

  user = await User.findOne({
    where: { email: { [Op.substring]: email } },
    include: [
      { model: GhStripe, as: 'stripe' },
      { model: Account, as: 'account' },
      { model: MembershipApplicationStatus, as: 'membershipApplicationStatus' },
    ],
  });

  const userPassword = await getUserPassword(user, plainTextPassword);

  if (user === null) {
    user = await User.create({
      email,
      password: userPassword,
      roleId: 2,
      uuid: uuidv4(),
      createdAt: new Date(),
      updatedAt: new Date(),
    });
  } else {
    await user.update({ password: userPassword, email, updatedAt: new Date() });
  }

  return user;
};

export default upsertUserByEmail;
