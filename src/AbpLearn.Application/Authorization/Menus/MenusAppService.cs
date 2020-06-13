using Abp.Application.Services;
using Abp.Application.Services.Dto;
using Abp.Authorization;
using Abp.Domain.Repositories;
using Abp.Domain.Uow;
using Abp.Localization;
using Abp.MultiTenancy;
using AbpLearn.Authorization.Menus.Dto;
using AbpLearn.Authorization.Roles;
using AbpLearn.MultiTenancy;
using AbpLearn.Roles;
using AbpLearn.Sessions;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AbpLearn.Authorization.Menus
{
    public class MenusAppService : AsyncCrudAppService<AbpMenus, MenuDto, int, MenusPagedResultRequestDto, CreateMenuDto, MenuDto>, IMenusAppService
    {
        private readonly ISessionAppService _sessionAppService;
        private readonly IUnitOfWorkManager _unitOfWorkManager;
        private readonly TenantManager _tenantManager;
        private readonly RoleManager _roleManager;
        private readonly IRoleAppService _roleAppService;
        public IRepository<Role, int> _roleRepository;

        public MenusAppService(
            IRepository<AbpMenus, int> repository,
            ISessionAppService sessionAppService,
            RoleManager roleManager,
            IUnitOfWorkManager unitOfWorkManager,
            TenantManager tenantManager,
            IRoleAppService roleAppService,
            IRepository<Role, int> roleRepository)
            : base(repository)
        {
            _sessionAppService = sessionAppService;
            _unitOfWorkManager = unitOfWorkManager;
            _tenantManager = tenantManager;
            _roleManager = roleManager;
            _roleAppService = roleAppService;
            _roleRepository = roleRepository;
        }

        protected override void MapToEntity(MenuDto updateInput, AbpMenus entity)
        {
            entity.MenuName = updateInput.MenuName;
            entity.LName = updateInput.LName;
            entity.Url = updateInput.Url;
            entity.Icon = updateInput.Icon;
            entity.PageName = updateInput.PageName;
            entity.ParentId = updateInput.ParentId;
            entity.IsActive = updateInput.IsActive;
            entity.Orders = updateInput.Orders;
        }

        #region 查询全部菜单
        /// <summary>
        /// 查询全部菜单
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public override async Task<PagedResultDto<MenuDto>> GetAllAsync(MenusPagedResultRequestDto input)
        {
            IQueryable<AbpMenus> query;

            query = CreateFilteredQuery(input).Where(o => o.TenantId == (input.TenantId == 0 ? null : input.TenantId));

            var totalCount = await AsyncQueryableExecuter.CountAsync(query);

            query = ApplySorting(query, input);
            if (!input.ShowAll) query = ApplyPaging(query, input);

            var entities = await AsyncQueryableExecuter.ToListAsync(query);

            return new PagedResultDto<MenuDto>(
                totalCount,
                entities.Select(MapToEntityDto).ToList()
            );
        }

        #endregion

        #region MyRegion
        public override async Task<MenuDto> CreateAsync(CreateMenuDto input)
        {
            var entity = MapToEntity(input);

            await Repository.InsertAsync(entity);
            await CurrentUnitOfWork.SaveChangesAsync();

            return MapToEntityDto(entity);
        }

        private async Task<MenuDto> CreateAsync(AbpMenus entity)
        {
            await Repository.InsertAsync(entity);
            await CurrentUnitOfWork.SaveChangesAsync();

            return MapToEntityDto(entity);
        }
        #endregion

        #region 更新
        //public override async Task<MenuDto> UpdateAsync(MenuDto input)
        //{
        //    CheckUpdatePermission();

        //    var entity = await GetEntityByIdAsync(input.Id);

        //    MapToEntity(input, entity);

        //    await CurrentUnitOfWork.SaveChangesAsync();

        //    return MapToEntityDto(entity);
        //}
        #endregion


        #region 赋予默认菜单
        public async Task GiveMenusAsync(EntityDto<int> input)
        {
            if (input.Id > 0)
            {
                var tenant = await _tenantManager.GetByIdAsync(input.Id);

                using (_unitOfWorkManager.Current.SetTenantId(tenant.Id))
                {
                    var query = CreateFilteredQuery(new MenusPagedResultRequestDto()).Where(o => o.TenantId == tenant.Id);

                    var systemMenus = await AsyncQueryableExecuter.ToListAsync(query);

                    if (!systemMenus.Any())
                    {
                        query = CreateFilteredQuery(new MenusPagedResultRequestDto()).Where(o => o.TenantId == -1);

                        var defaultMenus = await AsyncQueryableExecuter.ToListAsync(query);
                        if (defaultMenus.Any())
                        {
                            List<MenusInsert> GetMenusInserts(List<AbpMenus> abpMenus,int parentId = 0)
                            {
                                List<MenusInsert> menusInserts = new List<MenusInsert>();
                                foreach (var entity in abpMenus.Where(o => o.ParentId == parentId))
                                {
                                    var insert = new MenusInsert()
                                    {
                                        LName = entity.LName,
                                        MenuName = entity.MenuName,
                                        PageName = entity.PageName,
                                        Icon = entity.Icon,
                                        Url = entity.Url,
                                        IsActive = entity.IsActive,
                                        Orders = entity.Orders,
                                        ParentId = entity.ParentId,
                                        TenantId = tenant.Id
                                    };
                                    insert.menusInserts = GetMenusInserts(abpMenus, entity.Id);
                                    menusInserts.Add(insert);
                                }
                                return menusInserts;
                            }

                            async Task InsertMenusAsync(List<MenusInsert> inserts,int parentId = 0)
                            {
                                foreach (var insert in inserts)
                                {
                                    var entity = await CreateAsync(new AbpMenus()
                                    {
                                        LName = insert.LName,
                                        MenuName = insert.MenuName,
                                        PageName = insert.PageName,
                                        Icon = insert.Icon,
                                        Url = insert.Url,
                                        IsActive = insert.IsActive,
                                        Orders = insert.Orders,
                                        ParentId = parentId,
                                        TenantId = tenant.Id
                                    });
                                    if (insert.menusInserts.Any())
                                    {
                                        await InsertMenusAsync(insert.menusInserts, entity.Id);
                                    }
                                }
                            }
                            await InsertMenusAsync(GetMenusInserts(defaultMenus));
                            
                        }
                    }
                }
            }

        }
        #endregion

        #region 赋予当前租户Admin角色菜单权限
        /// <summary>
        /// 赋予当前租户Admin角色菜单权限
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public async Task GivePermissionsAsync(EntityDto<int> input)
        {
            if (input.Id > 0)
            {
                var tenant = await _tenantManager.GetByIdAsync(input.Id);

                using (_unitOfWorkManager.Current.SetTenantId(tenant.Id))
                {
                    var adminRoles = await _roleRepository.GetAllListAsync(o => o.Name == StaticRoleNames.Tenants.Admin && o.TenantId == tenant.Id);
                    if (adminRoles.FirstOrDefault() != null)
                    {
                        var adminRole = adminRoles.FirstOrDefault();

                        var query = CreateFilteredQuery(new MenusPagedResultRequestDto()).Where(o => o.TenantId == tenant.Id);

                        var systemMenus = await AsyncQueryableExecuter.ToListAsync(query);

                        var permissions = ConvertTenantPermissions(systemMenus);

                        //await _roleManager.ResetAllPermissionsAsync(adminRole.FirstOrDefault()); //重置授权

                        var active_BatchCount = 10;
                        var active_permissions = ConvertTenantPermissions(systemMenus.Where(o => o.IsActive).ToList());
                        for (int i = 0; i < active_permissions.Count(); i += 10)//每次后移5位
                        {
                            //await _roleManager.SetGrantedPermissionsAsync(adminRole.FirstOrDefault().Id, active_permissions.Take(active_BatchCount).Skip(i));
                            foreach (var notActive_permission in active_permissions.Take(active_BatchCount).Skip(i))
                            {
                                await _roleManager.GrantPermissionAsync(adminRole, notActive_permission);
                            }
                            active_BatchCount += 10;//每次从数组中选出N+10位，skip前N位
                        }

                        var notActive_BatchCount = 10;
                        var notActive_permissions = ConvertTenantPermissions(systemMenus.Where(o => !o.IsActive).ToList());
                        for (int i = 0; i < notActive_permissions.Count(); i += 10)//每次后移5位
                        {
                            foreach (var notActive_permission in notActive_permissions.Take(notActive_BatchCount).Skip(i))
                            {
                                await _roleManager.ProhibitPermissionAsync(adminRole, notActive_permission);
                            }
                            notActive_BatchCount += 10;//每次从数组中选出N+10位，skip前N位
                        }
                    }
                    else
                    {
                        throw new AbpDbConcurrencyException("未获取到当前租户的Admin角色！");
                    }
                }
            }
            else
            {
                var adminRoles = await _roleRepository.GetAllListAsync(o => o.Name == StaticRoleNames.Tenants.Admin && o.TenantId == null);
                if (adminRoles.FirstOrDefault() != null)
                {
                    var adminRole = adminRoles.FirstOrDefault();

                    var query = CreateFilteredQuery(new MenusPagedResultRequestDto()).Where(o => o.TenantId == null || o.TenantId == 0);

                    var systemMenus = await AsyncQueryableExecuter.ToListAsync(query);

                    //await _roleManager.ResetAllPermissionsAsync(adminRole.FirstOrDefault()); //重置授权

                    var active_BatchCount = 10;
                    var active_permissions = ConvertHostPermissions(systemMenus.Where(o => o.IsActive).ToList());
                    for (int i = 0; i < active_permissions.Count(); i += 10)//每次后移5位
                    {
                        //await _roleManager.SetGrantedPermissionsAsync(adminRole.FirstOrDefault().Id, active_permissions.Take(active_BatchCount).Skip(i));
                        foreach (var notActive_permission in active_permissions.Take(active_BatchCount).Skip(i))
                        {
                            await _roleManager.GrantPermissionAsync(adminRole, notActive_permission);
                        }
                        active_BatchCount += 10;//每次从数组中选出N+10位，skip前N位
                    }

                    var notActive_BatchCount = 10;
                    var notActive_permissions = ConvertHostPermissions(systemMenus.Where(o => !o.IsActive).ToList());
                    for (int i = 0; i < notActive_permissions.Count(); i += 10)//每次后移5位
                    {
                        foreach (var notActive_permission in notActive_permissions.Take(notActive_BatchCount).Skip(i))
                        {
                            await _roleManager.ProhibitPermissionAsync(adminRole, notActive_permission);
                        }
                        notActive_BatchCount += 10;//每次从数组中选出N+10位，skip前N位
                    }
                }
            }
        }

        public IEnumerable<Permission> ConvertTenantPermissions(IReadOnlyList<AbpMenus> systemMenus)
        {
            return systemMenus.Select(o => new Permission(o.PageName, L(o.MenuName), L(o.LName), MultiTenancySides.Tenant));
        }

        public IEnumerable<Permission> ConvertHostPermissions(IReadOnlyList<AbpMenus> systemMenus)
        {
            return systemMenus.Select(o => new Permission(o.PageName, L(o.MenuName), L(o.LName), MultiTenancySides.Host));
        }
        #endregion

        #region 删除改为改变IsActive状态
        /// <summary>
        /// 删除改为改变IsActive状态
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public override async Task DeleteAsync(EntityDto<int> input)
        {
            var menu = await GetEntityByIdAsync(input.Id);
            menu.IsActive = !menu.IsActive;
            await UpdateAsync(MapToEntityDto(menu));
        }
        #endregion

        #region 获取当前账户的菜单树
        /// <summary>
        /// 获取当前账户的菜单树
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public async Task<string> GetTreeAsync(MenusPagedResultRequestDto input)
        {
            var query = CreateFilteredQuery(new MenusPagedResultRequestDto()).Where(o => o.TenantId == input.TenantId);

            var systemMenus = await AsyncQueryableExecuter.ToListAsync(query);

            var childJObject = new JObject();
            var openJObject = new JObject();
            openJObject.Add("opened", true);
            childJObject.Add("id", 0);
            childJObject.Add("text", "根目录");
            childJObject.Add("icon", "");
            childJObject.Add("state", openJObject);
            childJObject.Add("children", GetJArray(systemMenus, 0));
            return childJObject.ToString();
        }

        #region 获取目录Array
        /// <summary>
        /// 获取目录Array
        /// </summary>
        /// <param name="systemMenus"></param>
        /// <param name="parentdId"></param>
        /// <returns></returns>
        private JArray GetJArray(List<AbpMenus> systemMenus, int parentdId)
        {
            JArray jArray = new JArray();
            foreach (var menu in systemMenus.Where(o => o.ParentId == parentdId))
            {
                var jObject = new JObject();
                var disabledJObject = new JObject();
                disabledJObject.Add("disabled", !menu.IsActive);

                jObject.Add("id", menu.Id);
                jObject.Add("text", menu.MenuName);
                jObject.Add("icon", menu.Icon);
                jObject.Add("state", disabledJObject);
                if (systemMenus.Any(o => o.ParentId == menu.Id))
                {
                    jObject.Add("children", GetJArray(systemMenus, menu.Id));
                }
                jArray.Add(jObject);
            }
            return jArray;
        }

        #endregion

        #endregion
        private static ILocalizableString L(string name)
        {
            return new LocalizableString(name, AbpLearnConsts.LocalizationSourceName);
        }
    }

}
