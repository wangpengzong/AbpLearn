using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Abp.Application.Services.Dto;
using Abp.Domain.Repositories;
using Abp.Domain.Uow;
using Abp.Extensions;
using Abp.MultiTenancy;
using Abp.Web.Minifier;
using Abp.Web.Navigation;
using AbpLearn.Authorization.Menus;
using AbpLearn.Authorization.Menus.Dto;
using AbpLearn.Authorization.Users;
using AbpLearn.Controllers;
using AbpLearn.MultiTenancy;
using AbpLearn.Sessions;
using AbpLearn.Users;
using AbpLearn.Web.Views.Shared.Components.TenantChange;
using Microsoft.AspNetCore.Mvc;

namespace AbpLearn.Web.Controllers
{
    public class MenusController : AbpLearnControllerBase
    {
        private readonly IMenusAppService _menuAppService;
        public IRepository<User, long> _userRepository;
        private readonly INavigationScriptManager _navigationScriptManager;
        private readonly IJavaScriptMinifier _javaScriptMinifier;
        private readonly ITenantAppService _tenantAppService;
        private readonly ISessionAppService _sessionAppService;
        private readonly TenantManager _tenantManager;
        private readonly IUnitOfWorkManager _unitOfWorkManager;
        public MenusController(
            IMenusAppService menuAppService,
            IUserAppService userAppService,
            INavigationScriptManager navigationScriptManager,
            ITenantCache tenantCache,
            IRepository<User, long> userRepository, 
            IJavaScriptMinifier javaScriptMinifier,
            ISessionAppService sessionAppService, 
            TenantManager tenantManager, 
            ITenantAppService tenantAppService,
            IUnitOfWorkManager unitOfWorkManager)
        {
            _menuAppService = menuAppService;
            _userRepository = userRepository;
            _navigationScriptManager = navigationScriptManager;
            _javaScriptMinifier = javaScriptMinifier;
            _tenantAppService = tenantAppService;
            _sessionAppService = sessionAppService;
            _tenantManager = tenantManager;
            _unitOfWorkManager = unitOfWorkManager;
        }
        public async Task<IActionResult> IndexAsync(int? id = 0)
        {
            var loginTenant = id <= 0 ? null : _tenantManager.GetById((int)id);

            var viewModel = new ChangeModalViewModel
            {
                TenancyName = loginTenant?.TenancyName,
                TenantId = id
            };

            viewModel.TeneacyItems = _tenantManager.Tenants
                .Select(p => new ComboboxItemDto(p.Id.ToString(), p.Name) { IsSelected = viewModel.TenancyName == p.TenancyName })
                .ToList();

            viewModel.TeneacyItems.Add(new ComboboxItemDto("0","Host管理员") { IsSelected = id == 0 });

            viewModel.TeneacyItems.Add(new ComboboxItemDto("-1", "默认菜单") { IsSelected = id == -1 });

            ViewBag.LoginInfo = await _sessionAppService.GetCurrentLoginInformations();

            return View(viewModel);
        }

        public async Task<ActionResult> EditModal(int menuId)
        {
            var tenantDto = await _menuAppService.GetAsync(new EntityDto(menuId));
            return PartialView("_EditModal", tenantDto);
        }

        private static string GetTriggerScript()
        {
            var script = new StringBuilder();

            script.AppendLine("(function(){");
            script.AppendLine("    abp.event.trigger('abp.dynamicScriptsInitialized');");
            script.Append("})();");

            return script.ToString();
        }

    }
}