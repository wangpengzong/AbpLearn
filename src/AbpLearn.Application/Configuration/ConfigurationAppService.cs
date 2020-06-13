using System.Threading.Tasks;
using Abp.Authorization;
using Abp.Runtime.Session;
using AbpLearn.Configuration.Dto;

namespace AbpLearn.Configuration
{
    [AbpAuthorize]
    public class ConfigurationAppService : AbpLearnAppServiceBase, IConfigurationAppService
    {
        public async Task ChangeUiTheme(ChangeUiThemeInput input)
        {
            await SettingManager.ChangeSettingForUserAsync(AbpSession.ToUserIdentifier(), AppSettingNames.UiTheme, input.Theme);
        }
    }
}
