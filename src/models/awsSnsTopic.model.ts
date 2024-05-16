import { Optional } from 'sequelize';
import { Table, Model, Column, DataType } from 'sequelize-typescript';

export interface AwsSnsTopicAttributes {
  id: number;
  topicArn: string;
  name: string;
  createdAt: Date;
  updatedAt: Date;
}
interface AwsSnsTopicCreationAttributes extends Optional<AwsSnsTopicAttributes, 'id'> {}

@Table({ tableName: 'AwsSnsTopic' })
export default class AwsSnsTopic extends Model<AwsSnsTopicAttributes, AwsSnsTopicCreationAttributes> {
  @Column({
    type: DataType.INTEGER,
    primaryKey: true,
  })
  id: number;

  @Column(DataType.STRING)
  name: string;

  @Column(DataType.STRING)
  topicArn: string;

  @Column(DataType.DATE)
  createdAt: string;

  @Column(DataType.DATE)
  updatedAt: string;
}
