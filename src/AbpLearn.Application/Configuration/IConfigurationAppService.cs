using System.Threading.Tasks;
using AbpLearn.Configuration.Dto;

namespace AbpLearn.Configuration
{
    public interface IConfigurationAppService
    {
        Task ChangeUiTheme(ChangeUiThemeInput input);
    }
}
