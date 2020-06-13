using Abp.Application.Services;
using Abp.Application.Services.Dto;
using AbpLearn.Authorization.Menus.Dto;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace AbpLearn.Authorization.Menus
{
    public interface IMenusAppService : IAsyncCrudAppService<MenuDto, int, MenusPagedResultRequestDto, CreateMenuDto, MenuDto>
    {
        /// <summary>
        /// 赋予默认菜单
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        Task GiveMenusAsync(EntityDto<int> input);

        /// <summary>
        /// 赋予当前租户Admin角色菜单权限
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        Task GivePermissionsAsync(EntityDto<int> input);
    }
}
