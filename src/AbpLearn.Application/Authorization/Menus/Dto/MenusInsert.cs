using Abp.Application.Services.Dto;
using Abp.AutoMapper;
using System;
using System.Collections.Generic;
using System.Text;

namespace AbpLearn.Authorization.Menus.Dto
{
    [AutoMapFrom(typeof(AbpMenus))]
    public class MenusInsert : EntityDto<int>
    {
        public string MenuName { set; get; }
        public string LName { set; get; }
        public string Url { set; get; }
        public string Icon { set; get; }
        public string PageName { set; get; }
        public int ParentId { set; get; }
        public bool IsActive { set; get; }
        public int Orders { set; get; }
        public int? TenantId { get; set; }
        public List<MenusInsert> menusInserts { get; set; }
    }
}
