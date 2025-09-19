import { Injectable } from "@nestjs/common";
import { PrismaService } from "src/prisma/prisma.service";


@Injectable()
export class CustomersRepository {
    constructor(private readonly prisma: PrismaService) { }

    create(data: any) {
        return this.prisma.customer.create({ data });
    }

    findAll(where: any) {
        return this.prisma.customer.findMany({ where });
    }

    findOne(where: any) {
        return this.prisma.customer.findUnique({ where });
    }

    update(id: string, data: any) {
        return this.prisma.customer.update({ where: { id }, data });
    }

    delete(id: string) {
        return this.prisma.customer.delete({ where: { id } });
    }
}