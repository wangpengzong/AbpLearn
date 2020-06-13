using Abp.EntityFrameworkCore.Configuration;
using Abp.Modules;
using Abp.Reflection.Extensions;
using Abp.Zero.EntityFrameworkCore;
using AbpLearn.EntityFrameworkCore.Seed;
using Microsoft.Extensions.Logging;

namespace AbpLearn.EntityFrameworkCore
{
    [DependsOn(
        typeof(AbpLearnCoreModule), 
        typeof(AbpZeroCoreEntityFrameworkCoreModule))]
    public class AbpLearnEntityFrameworkModule : AbpModule
    {
        /* Used it tests to skip dbcontext registration, in order to use in-memory database of EF Core */
        public bool SkipDbContextRegistration { get; set; }

        public bool SkipDbSeed { get; set; }

        private readonly ILoggerFactory _loggerFactory;

        public AbpLearnEntityFrameworkModule(ILoggerFactory loggerFactory)
        {
            _loggerFactory = loggerFactory;
        }



        public override void PreInitialize()
        {
            if (!SkipDbContextRegistration)
            {
                Configuration.Modules.AbpEfCore().AddDbContext<AbpLearnDbContext>(options =>
                {
                    if (options.ExistingConnection != null)
                    {
                        AbpLearnDbContextConfigurer.Configure(options.DbContextOptions, options.ExistingConnection);
                    }
                    else
                    {
                        AbpLearnDbContextConfigurer.Configure(options.DbContextOptions, options.ConnectionString);
                    }

                    options.DbContextOptions.UseLoggerFactory(_loggerFactory);
                    options.DbContextOptions.EnableSensitiveDataLogging(true);

                });
            }
        }

        public override void Initialize()
        {
            IocManager.RegisterAssemblyByConvention(typeof(AbpLearnEntityFrameworkModule).GetAssembly());
        }

        public override void PostInitialize()
        {
            if (!SkipDbSeed)
            {
                SeedHelper.SeedHostDb(IocManager);
            }
        }
    }
}
