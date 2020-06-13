using Abp;
using Abp.Application.Features;
using Abp.Application.Navigation;
using Abp.Authorization;
using Abp.Dependency;
using Abp.Localization;
using Abp.MultiTenancy;
using Abp.Runtime.Session;
using AbpLearn.Authorization.Menus.Dto;
using AbpLearn.Sessions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AbpLearn.Authorization.Menus
{
    public class UserNavigationManager : IUserNavigationManager, ITransientDependency
    {
        public IAbpSession AbpSession { get; set; }

        private readonly INavigationManager _navigationManager;
        private readonly ILocalizationContext _localizationContext;
        private readonly IIocResolver _iocResolver;
        private readonly IMenusAppService _menuAppService;
        private readonly ISessionAppService _sessionAppService;

        public IDictionary<string, MenuDefinition> Menus { get; private set; }
        public MenuDefinition MainMenu
        {
            get { return Menus["MainMenu"]; }
        }
        public UserNavigationManager(
            INavigationManager navigationManager,
            ILocalizationContext localizationContext,
            IMenusAppService menuAppService,
            ISessionAppService sessionAppService,
            IIocResolver iocResolver)
        {
            _navigationManager = navigationManager;
            _localizationContext = localizationContext;
            _iocResolver = iocResolver;
            AbpSession = NullAbpSession.Instance;
            _menuAppService = menuAppService;
            _sessionAppService = sessionAppService;
        }

        public async Task<UserMenu> GetMenuAsync(string menuName, UserIdentifier user)
        {
            var loginInfo = await _sessionAppService.GetCurrentLoginInformations();

            Menus = new Dictionary<string, MenuDefinition>
                    {
                        {"MainMenu", new MenuDefinition("MainMenu", new LocalizableString("MainMenu", AbpConsts.LocalizationSourceName))}
                    };

            var lists = await _menuAppService.GetAllAsync(new MenusPagedResultRequestDto() { ShowAll = true, TenantId = (loginInfo.Tenant == null ? 0 : loginInfo.Tenant.Id) });
            var ParentMenu = lists.Items.Where(k => k.IsActive).ToList().Where(x => x.ParentId == 0).ToList();
            if (ParentMenu.Any())
            {
                ParentMenu.ForEach(g =>
                {
                    var menu = new MenuItemDefinition(
                          g.LName,
                          MenuL(g.MenuName),
                          g.Icon,
                          g.Url,
                          false,
                          g.Orders
                          );
                    BuildSubMenu(menu, g.Id, lists.Items.Where(k => k.IsActive).ToList());
                    MainMenu.AddItem(menu);
                });
            }
            
            var menuDefinition = MainMenu;
            if (menuDefinition == null)
            {
                throw new AbpException("There is no menu with given name: " + menuName);
            }
            var userMenu = new UserMenu();
            userMenu.Name = menuDefinition.Name;
            userMenu.DisplayName = menuDefinition.DisplayName.Localize(_localizationContext);
            userMenu.CustomData = menuDefinition.CustomData;
            userMenu.Items = new List<UserMenuItem>();
            await FillUserMenuItems(user, menuDefinition.Items, userMenu.Items);
            return userMenu;
        }

        public async Task<IReadOnlyList<UserMenu>> GetMenusAsync(UserIdentifier user)
        {
            var userMenus = new List<UserMenu>();

            foreach (var menu in _navigationManager.Menus.Values)
            {
                userMenus.Add(await GetMenuAsync(menu.Name, user));
            }

            return userMenus;
        }
        public void BuildSubMenu(MenuItemDefinition menu, int parentId, List<MenuDto> list)
        {
            var nList = list.Where(x => x.ParentId == parentId).ToList();
            if (nList != null && nList.Count > 0)
            {
                nList.ForEach(g =>
                {
                    var subMenu = new MenuItemDefinition(
                         g.PageName,
                        MenuL(g.MenuName),
                        g.Icon,
                        g.Url,
                        false,
                      g.Orders
                        );
                    menu.AddItem(subMenu);
                    BuildSubMenu(subMenu, g.Id, list);
                });
            }
        }

        private static ILocalizableString MenuL(string name)
        {
            return new LocalizableString(name, AbpLearnConsts.LocalizationSourceName);
        }
        private async Task<int> FillUserMenuItems(UserIdentifier user, IList<MenuItemDefinition> menuItemDefinitions, IList<UserMenuItem> userMenuItems)
        {
            //TODO: Can be optimized by re-using FeatureDependencyContext.

            var addedMenuItemCount = 0;

            using (var scope = _iocResolver.CreateScope())
            {
                var permissionDependencyContext = scope.Resolve<PermissionDependencyContext>();
                permissionDependencyContext.User = user;

                var featureDependencyContext = scope.Resolve<FeatureDependencyContext>();
                featureDependencyContext.TenantId = user == null ? null : user.TenantId;

                foreach (var menuItemDefinition in menuItemDefinitions)
                {
                    if (menuItemDefinition.RequiresAuthentication && user == null)
                    {
                        continue;
                    }

                    if (menuItemDefinition.PermissionDependency != null &&
                        (user == null || !(await menuItemDefinition.PermissionDependency.IsSatisfiedAsync(permissionDependencyContext))))
                    {
                        continue;
                    }

                    if (menuItemDefinition.FeatureDependency != null &&
                        (AbpSession.MultiTenancySide == MultiTenancySides.Tenant || (user != null && user.TenantId != null)) &&
                        !(await menuItemDefinition.FeatureDependency.IsSatisfiedAsync(featureDependencyContext)))
                    {
                        continue;
                    }

                    var userMenuItem = new UserMenuItem(menuItemDefinition, _localizationContext);
                    if (menuItemDefinition.IsLeaf || (await FillUserMenuItems(user, menuItemDefinition.Items, userMenuItem.Items)) > 0)
                    {
                        userMenuItems.Add(userMenuItem);
                        ++addedMenuItemCount;
                    }
                }
            }

            return addedMenuItemCount;
        }
    }
}
