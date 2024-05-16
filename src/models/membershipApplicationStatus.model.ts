import { Optional } from 'sequelize';
import { Table, Model, Column, DataType, BelongsTo } from 'sequelize-typescript';

import User from '@gravity-haus/gh-common/dist/models/user.model';

export enum StatusEnum {
  NEW = 'NEW',
  UNDER_REVIEW = 'UNDER_REVIEW',
  APPROVE = 'APPROVE',
  DENY = 'DENY',
  OVERDUE = 'OVERDUE',
  CANCEL = 'CANCEL',
  COUPON_FAILED = 'COUPON_FAILED',
  STRIPE_FAILED = 'STRIPE_FAILED',
}

const statusDataType = DataType.ENUM(
  'NEW',
  'UNDER_REVIEW',
  'APPROVE',
  'DENY',
  'OVERDUE',
  'CANCEL',
  'COUPON_FAILED',
  'STRIPE_FAILED',
);

export interface MembershipApplicationStatusAttributes {
  id: number;
  userId: number;
  user: User;
  applicationId: number;
  stripeSubscriptionId: string;
  stripeCoupon: string;
  status: StatusEnum;
  startDate: Date;
  renewalDate: Date;
}
interface MembershipApplicationStatusCreationAttributes extends Optional<MembershipApplicationStatusAttributes, 'id'> {}

@Table({ tableName: 'MembershipApplicationStatus' })
export default class MembershipApplicationStatus extends Model<
  MembershipApplicationStatusAttributes,
  MembershipApplicationStatusCreationAttributes
> {
  @Column({
    type: DataType.INTEGER,
    primaryKey: true,
  })
  id: number;

  @Column(statusDataType)
  status: string;

  @Column({ allowNull: null, type: DataType.TEXT })
  stripeSubscriptionId: string;

  @Column(DataType.DATE)
  startDate: string;

  @Column(DataType.DATE)
  renewalDate: string;

  @Column(DataType.INTEGER)
  userId: number;

  @BelongsTo(() => User, 'userId')
  user: User;
}
