using Microsoft.AspNetCore.Mvc;
using Abp.AspNetCore.Mvc.Authorization;
using AbpLearn.Controllers;

namespace AbpLearn.Web.Controllers
{
    [AbpMvcAuthorize]
    public class HomeController : AbpLearnControllerBase
    {
        public ActionResult Index()
        {
            return View();
        }
    }
}
