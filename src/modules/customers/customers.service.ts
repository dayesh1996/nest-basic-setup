import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CustomersRepository } from './customers.repository';

@Injectable()
export class CustomersService {
  constructor(private readonly customersRepository: CustomersRepository) { }

  // ✅ Core reusable method
  async getCustomer(where: any): Promise<any> {
    const customer = await this.customersRepository.findOne(where);

    if (!customer) {
      throw new HttpException(
        `Customer not found`,
        HttpStatus.NOT_FOUND,
      );
    }
    return customer;
  }

  // ✅ Convenience wrappers
  async getCustomerById(id: string) {
    return this.getCustomer({ id });
  }

  async getCustomerByPhoneNumber(phone_number: string) {
    return this.getCustomer({ phone_number });
  }
}
