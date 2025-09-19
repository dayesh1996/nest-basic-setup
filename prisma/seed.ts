import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seeding for Dygus Plumbing E-commerce...');

  // Create admin user
  const superAdminUser = await prisma.user.upsert({
    where: { email: 'dayesh@geekonomy.in' },
    update: {},
    create: {
      firstName: 'Dayesh',
      lastName: 'Suvarna',
      phoneNumber: '7760563063',
      email: 'dayesh@geekonomy.in',
      role: 'super_admin',
      isActive: true,
    },
  });

  // Create admin user
  const adminUser = await prisma.user.upsert({
    where: { email: 'sachin@geekonomy.in' },
    update: {},
    create: {
      firstName: 'Sachin',
      lastName: 'Nayak',
      phoneNumber: '6364497927',
      email: 'sachin@geekonomy.in',
      role: 'admin',
      isActive: true,
    },
  });

  // Create account user
  const accountUser = await prisma.user.upsert({
    where: { email: 'kishan@geekonomy.in' },
    update: {},
    create: {
      firstName: 'Kishan',
      lastName: 'Kotecha',
      phoneNumber: '9980539949',
      email: 'kishan@geekonomy.in',
      role: 'account',
      isActive: true,
    },
  });

  // Create dispatch user
  const dispatchUser = await prisma.user.upsert({
    where: { email: 'dispatch@geekonomy.in' },
    update: {},
    create: {
      firstName: 'Dispatch',
      lastName: 'Team',
      phoneNumber: '9876543210',
      email: 'dispatch@geekonomy.in',
      role: 'dispatch',
      isActive: true,
    },
  });

  //Create support user
  const supportUser = await prisma.user.upsert({
    where: { email: 'support@geekonomy.in' },
    update: {},
    create: {
      firstName: 'Support',
      lastName: 'Team',
      phoneNumber: '9876543211',
      email: 'support@geekonomy.in',
      role: 'support',
      isActive: true,
    },
  });

  console.log('✅ Database seeding completed!');
  console.log('📊 Created:');
  console.log(`   - ${await prisma.user.count()} users`);
  //   console.log(`   - ${await prisma.nbfcCompany.count()} NBFC companies`);
  //   console.log(`   - ${await prisma.nbfcUser.count()} NBFC users`);
  //   console.log(`   - ${await prisma.customer.count()} customers`);
  //   console.log(`   - ${await prisma.sector.count()} sectors`);
  //   console.log(`   - ${await prisma.category.count()} categories`);
  //   console.log(`   - ${await prisma.subCategory.count()} sub-categories`);
  //   console.log(`   - ${await prisma.hsnCode.count()} HSN codes`);
  //   console.log(`   - ${await prisma.brand.count()} brands`);
  //   console.log(`   - ${await prisma.product.count()} products`);
  //   console.log(`   - ${await prisma.inventory.count()} inventory items`);
  //   console.log(`   - ${await prisma.cart.count()} cart items`);
  //   console.log(`   - ${await prisma.coupon.count()} coupons`);
}

main()
  .catch((e) => {
    console.error('❌ Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
