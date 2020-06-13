using Abp.AspNetCore.Mvc.ViewComponents;

namespace AbpLearn.Web.Views
{
    public abstract class AbpLearnViewComponent : AbpViewComponent
    {
        protected AbpLearnViewComponent()
        {
            LocalizationSourceName = AbpLearnConsts.LocalizationSourceName;
        }
    }
}
