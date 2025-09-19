import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { SignInAuthDto } from './dto/auth.dto';
import { LoginViaPhoneNumberFailureMessage } from 'src/common/enums/failureMessages/failure.enum';
import { UsersService } from '../users/users.service';
import { CustomersService } from '../customers/customers.service';
import { OtpsService } from '../otps/otps.service';

@Injectable()
export class AuthService {
  private readonly userTypeLookup: Record<string, (phone: string) => Promise<any>>;

  constructor(private readonly customerService: CustomersService,
    private readonly usersService: UsersService,
    private readonly otpsService: OtpsService,
  ) {
    this.userTypeLookup = {
      customer: (phoneNumber) => this.customerService.getCustomerByPhoneNumber(phoneNumber),
      user: (phoneNumber) => this.usersService.getCustomer({ phoneNumber }),
      // nbfc: (phoneNumber) => this.nbfcService.getNbfcByPhoneNumber(phoneNumber),
    }
  }

  async signIn(signInAuthDto: SignInAuthDto) {
    try {
      const { userType, phoneNumber } = signInAuthDto;
      const user = await this.findUserByPhoneNumber(userType, phoneNumber);
      console.log("user>>", user);
      await this.generateOtp(phoneNumber, userType, user.id);
      return user
    } catch (error) {
      throw new Error(error);
    }
  }

  private async findUserByPhoneNumber(userType: string, phoneNumber: string) {
    const lookupFn = this.userTypeLookup[userType];
    try {
      return await lookupFn(phoneNumber);
    } catch (error) {
      console.error("Error finding user by phone number>>", error);
      throw new HttpException(error.message || 'Unexpected error', HttpStatus.BAD_REQUEST);
    }
  }

  async generateOtp(phone_number: string, userType: string, userId: string): Promise<void> {

    try {
      const otp = '1234'; // Fixed OTP for now

      // Commenting out the actual OTP sending logic
      /*
      const response = await axios.get(
        `https://2factor.in/API/V1/${this.apiKey}/SMS/${phone_number}/${otp}/OTP1`
      );
      if (response.data.Status !== 'Success') {
        throw new HttpException(
          'Failed to send OTP via SMS provider',
          HttpStatus.INTERNAL_SERVER_ERROR
        );
      }
      */

      const expiresAt = new Date();
      expiresAt.setMinutes(expiresAt.getMinutes() + 5);
      console.log("OTP Expiry Time (Local):", expiresAt.toLocaleString());

      await this.otpsService.create(
        {
          reference_by: userId,
          reference_by_type: userType,
          otp,
          is_used: false,
          expires_at: expiresAt,
        }
      );

    } catch (error) {
      console.log("Error while generating OTP:", error);
      if (error instanceof HttpException) {
        throw error;
      }
      throw new HttpException(error.message, HttpStatus.BAD_REQUEST);
    }
  }
}
