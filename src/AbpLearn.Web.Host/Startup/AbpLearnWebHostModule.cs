using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Abp.Modules;
using Abp.Reflection.Extensions;
using AbpLearn.Configuration;

namespace AbpLearn.Web.Host.Startup
{
    [DependsOn(
       typeof(AbpLearnWebCoreModule))]
    public class AbpLearnWebHostModule: AbpModule
    {
        private readonly IWebHostEnvironment _env;
        private readonly IConfigurationRoot _appConfiguration;

        public AbpLearnWebHostModule(IWebHostEnvironment env)
        {
            _env = env;
            _appConfiguration = env.GetAppConfiguration();
        }

        public override void Initialize()
        {
            IocManager.RegisterAssemblyByConvention(typeof(AbpLearnWebHostModule).GetAssembly());
        }
    }
}
