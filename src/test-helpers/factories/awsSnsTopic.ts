import { SequelizeFactoryMixin } from '../sequelize-factory-mixin';
import AwsSnsTopic from '../../models/awsSnsTopic.model';

class AwsSnsTopicFactory extends SequelizeFactoryMixin(AwsSnsTopic) {}

export const awsSnsTopicFactory = AwsSnsTopicFactory.define(({ sequence, params }) => {
  return {
    id: sequence,
    topicArn: params.topicArn,
    name: params.name,
    createdAt: Date.now(),
    updatedAt: Date.now(),
  };
});
