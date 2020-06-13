using Microsoft.EntityFrameworkCore;
using Abp.Zero.EntityFrameworkCore;
using AbpLearn.Authorization.Roles;
using AbpLearn.Authorization.Users;
using AbpLearn.MultiTenancy;
using AbpLearn.Authorization.Menus;

namespace AbpLearn.EntityFrameworkCore
{
    public class AbpLearnDbContext : AbpZeroDbContext<Tenant, Role, User, AbpLearnDbContext>
    {
        /* Define a DbSet for each entity of the application */
        
        public AbpLearnDbContext(DbContextOptions<AbpLearnDbContext> options)
            : base(options)
        {
            
        }

        public DbSet<AbpMenus> AbpMenus { set; get; }

    }
}
