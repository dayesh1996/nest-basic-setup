import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class UsersRepository {
  constructor(private readonly prisma: PrismaService) { }

  create(data: any) {
    return this.prisma.user.create({ data });
  }

  findMany(where: any = {}) {
    return this.prisma.user.findMany({ where });
  }

  findOne(where: any) {
    return this.prisma.user.findUnique({ where });
  }

  update(id: string, data: any) {
    return this.prisma.user.update({ where: { id }, data });
  }

  delete(id: string) {
    return this.prisma.user.delete({ where: { id } });
  }
}
