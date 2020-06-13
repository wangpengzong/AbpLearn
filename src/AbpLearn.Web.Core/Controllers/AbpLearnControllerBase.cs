using Abp.AspNetCore.Mvc.Controllers;
using Abp.IdentityFramework;
using Microsoft.AspNetCore.Identity;

namespace AbpLearn.Controllers
{
    public abstract class AbpLearnControllerBase: AbpController
    {
        protected AbpLearnControllerBase()
        {
            LocalizationSourceName = AbpLearnConsts.LocalizationSourceName;
        }

        protected void CheckErrors(IdentityResult identityResult)
        {
            identityResult.CheckErrors(LocalizationManager);
        }
    }
}
