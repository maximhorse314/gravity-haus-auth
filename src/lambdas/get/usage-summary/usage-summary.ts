import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { response } from '@gravity-haus/gh-common/dist/faas/response';
import verifyToken from '@gravity-haus/gh-common/dist/auth/jwt/verify-token';
import { Client } from '@gravity-haus/gh-common/dist/db/client';
import SM from '@gravity-haus/gh-common/dist/clients/aws/sm/sm';
import User from '@gravity-haus/gh-common/dist/models/user.model';
import HausReservations from '@gravity-haus/gh-common/dist/models/hausReservations.model';
import RentalBooking from '@gravity-haus/gh-common/dist/models/rentalBooking.model';
import EventBooking from '@gravity-haus/gh-common/dist/models/eventBooking.model';
import GymBooking from '@gravity-haus/gh-common/dist/models/gymBooking.model';
import GymLocation from '@gravity-haus/gh-common/dist/models/gymLocation.model';
import Event from '@gravity-haus/gh-common/dist/models/event.model';

export default async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  // check for user authentication
  try {
    verifyToken(event);
  } catch {
    return response(401, { message: 'Unauthorized' });
  }

  try {
    const { id } = event.queryStringParameters;

    const secretsManager = SM.getInstance();
    await secretsManager.getSecret();
    Client.getInstance();

    let user = await User.findOne({
      where: { id },
      include: [
        { model: RentalBooking, as: 'rentalBookings' },
        { model: GymBooking, as: 'gymBookings', include: [{ model: GymLocation, as: 'location' }] },
        { model: Event, as: 'events' },
        { model: EventBooking, as: 'eventBookings' },
        { model: HausReservations, as: 'hausReservations' },
      ],
    });

    user = user.get({ plain: true });
    delete user.password;

    return response(200, { user });
  } catch (error) {
    return response(500, { error });
  }
};
