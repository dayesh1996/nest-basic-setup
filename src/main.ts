import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  //Swagger config 
  const config = new DocumentBuilder()
    .setTitle('Dygus Plumbing E-Commerce API')
    .setDescription('API documentation for Dygus Plumbing E-Commerce platform')
    .setVersion('1.0')
    .addBearerAuth()
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api-docs', app, document); // <--- Mount here


  await app.listen(process.env.PORT ?? 5050);
}
bootstrap();
