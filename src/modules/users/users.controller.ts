import { Controller, Get, Param } from "@nestjs/common";
import { getSuccessResponse, successResponse } from "../../common/helpers/response.helper";
import { UsersService } from "./users.service";
import { ApiTags } from "@nestjs/swagger";


@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) { }

  @Get()
  async findAll() {
    return getSuccessResponse(await this.usersService.findAll());
  }
}
