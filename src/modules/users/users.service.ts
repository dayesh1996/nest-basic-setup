import { HttpException, HttpStatus, Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.service";
import { UsersRepository } from "./users.repository";

@Injectable()
export class UsersService {
    constructor(private readonly prisma: PrismaService,
        private readonly usersRepository: UsersRepository
    ) { }

    async findAll() {
        const users = await this.usersRepository.findMany();
        return users;
    }

    async getCustomer(where: any): Promise<any> {
        const customer = await this.usersRepository.findOne(where);

        if (!customer) {
            throw new HttpException(
                `Customer not found`,
                HttpStatus.NOT_FOUND,
            );
        }
        return customer;
    }

    async getCustomerById(id: string) {
        return this.getCustomer({ id });
    }
}
