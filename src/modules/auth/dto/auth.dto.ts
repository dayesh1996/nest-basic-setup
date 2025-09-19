import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsNotEmpty, IsString } from 'class-validator';
import { UserType } from 'src/common/enums/userEnum/user.enum';

export class SignInAuthDto {
  @ApiProperty({
    description: 'Type of user (allowed values: USER, CUSTOMER, NBFC)',
    enum: UserType,
    example: UserType.USER,
  })
  @IsEnum(UserType)
  @IsNotEmpty()
  userType: UserType;

  @ApiProperty({
    description: 'Phone number of the user',
    example: '7760563063',
  })
  @IsString()
  @IsNotEmpty()
  phoneNumber: string;
}
