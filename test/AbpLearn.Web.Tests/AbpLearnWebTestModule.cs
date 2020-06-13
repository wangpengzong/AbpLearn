using Abp.AspNetCore;
using Abp.AspNetCore.TestBase;
using Abp.Modules;
using Abp.Reflection.Extensions;
using AbpLearn.EntityFrameworkCore;
using AbpLearn.Web.Startup;
using Microsoft.AspNetCore.Mvc.ApplicationParts;

namespace AbpLearn.Web.Tests
{
    [DependsOn(
        typeof(AbpLearnWebMvcModule),
        typeof(AbpAspNetCoreTestBaseModule)
    )]
    public class AbpLearnWebTestModule : AbpModule
    {
        public AbpLearnWebTestModule(AbpLearnEntityFrameworkModule abpProjectNameEntityFrameworkModule)
        {
            abpProjectNameEntityFrameworkModule.SkipDbContextRegistration = true;
        } 
        
        public override void PreInitialize()
        {
            Configuration.UnitOfWork.IsTransactional = false; //EF Core InMemory DB does not support transactions.
        }

        public override void Initialize()
        {
            IocManager.RegisterAssemblyByConvention(typeof(AbpLearnWebTestModule).GetAssembly());
        }
        
        public override void PostInitialize()
        {
            IocManager.Resolve<ApplicationPartManager>()
                .AddApplicationPartsIfNotAddedBefore(typeof(AbpLearnWebMvcModule).Assembly);
        }
    }
}