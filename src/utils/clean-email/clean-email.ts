export const cleanEmail = (email: string): string => {
  let userEmail = email ? email : '';
  if (userEmail.includes('DEACTIVATED__')) userEmail = email.split('__')[1];
  if (!userEmail) userEmail = email;
  return userEmail;
};

export default cleanEmail;
