import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { CustomersModule } from '../customers/customers.module';
import { UsersModule } from '../users/users.module';
import { OtpsModule } from '../otps/otps.module';

@Module({
  imports: [CustomersModule, UsersModule, OtpsModule],
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}
