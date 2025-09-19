import { Controller, Post, Body } from '@nestjs/common';
import { AuthService } from './auth.service';
import { SignInAuthDto } from './dto/auth.dto';
import { ApiBody, ApiOperation } from '@nestjs/swagger';
import { successResponse } from 'src/common/helpers/response.helper';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) { }

  @Post('sign-in')
  @ApiOperation({ summary: 'Sign in with user type (allowed values: USER, CUSTOMER, NBFC) and phone number' })
  signIn(@Body() dto: SignInAuthDto) {
    return successResponse(this.authService.signIn(dto), `Otp sent successfully to ${dto.phoneNumber}`)
  }

  

}
