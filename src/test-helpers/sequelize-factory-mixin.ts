import { Factory } from 'fishery';

export const SequelizeFactoryMixin = (model: any) =>
  class extends Factory<any> {
    build(params: any = {}, options: any = {}) {
      const attributes = super.build(params, options);
      return model.build(attributes);
    }

    async create(params: any = {}, options: any = {}) {
      return await this.build(params, options).save();
    }
  };
