import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class OtpsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(otpData: any) {
    try {
      return await this.prisma.otpLogin.create({ data: otpData });
    } catch (error) {
      console.log("Failed to create OTP >>>", error);
      throw new HttpException(error.message, HttpStatus.BAD_REQUEST);
    }
  }

  async findLatestOtp(referenceBy: string,) {
    try {
      const otpEntry = await this.prisma.otpLogin.findFirst({
        where: {
          referenceBy,
          isUsed: false,
        },
        orderBy: { createdAt: 'desc' },
        // include: {
        //   user: true,
        //   customer: true,
        //   nbfcUser: true,
        // },
      });

      if (!otpEntry) {
        throw new HttpException('OTP not found or already used', HttpStatus.NOT_FOUND);
      }

      // mark as used
      await this.prisma.otpLogin.update({
        where: { id: otpEntry.id },
        data: { isUsed: true },
      });

      return otpEntry;
    } catch (error) {
      console.error('Error finding latest OTP:', error);
      throw new HttpException(error.message, HttpStatus.BAD_REQUEST);
    }
  }
}
