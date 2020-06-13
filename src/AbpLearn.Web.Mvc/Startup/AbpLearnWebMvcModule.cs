using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Abp.Modules;
using Abp.Reflection.Extensions;
using AbpLearn.Configuration;

namespace AbpLearn.Web.Startup
{
    [DependsOn(typeof(AbpLearnWebCoreModule))]
    public class AbpLearnWebMvcModule : AbpModule
    {
        private readonly IWebHostEnvironment _env;
        private readonly IConfigurationRoot _appConfiguration;

        public AbpLearnWebMvcModule(IWebHostEnvironment env)
        {
            _env = env;
            _appConfiguration = env.GetAppConfiguration();
        }

        public override void PreInitialize()
        {
            //Configuration.Navigation.Providers.Add<AbpLearnNavigationProvider>();
        }

        public override void Initialize()
        {
            IocManager.RegisterAssemblyByConvention(typeof(AbpLearnWebMvcModule).GetAssembly());
        }
    }
}
