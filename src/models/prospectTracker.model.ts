import { Optional } from 'sequelize';
import { Table, Model, Column, DataType, BelongsTo } from 'sequelize-typescript';

import User from '@gravity-haus/gh-common/dist/models/user.model';

export interface ProspectTrackerAttributes {
  id?: number;
  values: string;
  userId: number;

  createdAt: Date;
  updatedAt: Date;

  user: User;
}
interface ProspectTrackerCreationAttributes extends Optional<ProspectTrackerAttributes, 'id'> {}

@Table({ tableName: 'ProspectTracker' })
export default class ProspectTracker extends Model<ProspectTrackerAttributes, ProspectTrackerCreationAttributes> {
  @Column({
    type: DataType.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  })
  id: number;

  @Column(DataType.INTEGER)
  userId: number;

  @Column(DataType.TEXT)
  values: string;

  @Column(DataType.DATE)
  createdAt: string;

  @Column(DataType.DATE)
  updatedAt: string;

  @BelongsTo(() => User, 'userId')
  user: User;
}
