using Abp.AutoMapper;
using Abp.Modules;
using Abp.Reflection.Extensions;
using AbpLearn.Authorization;

namespace AbpLearn
{
    [DependsOn(
        typeof(AbpLearnCoreModule), 
        typeof(AbpAutoMapperModule))]
    public class AbpLearnApplicationModule : AbpModule
    {
        public override void PreInitialize()
        {
            Configuration.Authorization.Providers.Add<AbpLearnAuthorizationProvider>();
        }

        public override void Initialize()
        {
            var thisAssembly = typeof(AbpLearnApplicationModule).GetAssembly();

            IocManager.RegisterAssemblyByConvention(thisAssembly);

            Configuration.Modules.AbpAutoMapper().Configurators.Add(
                // Scan the assembly for classes which inherit from AutoMapper.Profile
                cfg => cfg.AddMaps(thisAssembly)
            );
        }
    }
}
