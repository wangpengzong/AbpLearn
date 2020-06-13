using Abp.AspNetCore.Mvc.Views;
using Abp.Runtime.Session;
using Microsoft.AspNetCore.Mvc.Razor.Internal;

namespace AbpLearn.Web.Views
{
    public abstract class AbpLearnRazorPage<TModel> : AbpRazorPage<TModel>
    {
        [RazorInject]
        public IAbpSession AbpSession { get; set; }

        protected AbpLearnRazorPage()
        {
            LocalizationSourceName = AbpLearnConsts.LocalizationSourceName;
        }
    }
}
