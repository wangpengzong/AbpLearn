using Abp.Domain.Entities;
using Abp.Domain.Entities.Auditing;
using System;
using System.Collections.Generic;
using System.Text;

namespace AbpLearn.Authorization.Menus
{
    public class AbpMenus : Entity<int> //, IMayHaveTenant不继承，因为需要设置TenantId=-1来当作租户标准菜单,继承后生成的sql语句将自动增加TenantId的查询条件
    {
        public string MenuName { set; get; }
        public string PageName { set; get; }
        public string LName { set; get; }
        public string Url { set; get; }
        public string Icon { set; get; }
        public int ParentId { set; get; }
        public bool IsActive { set; get; }
        public int Orders { set; get; }
        public int? TenantId { set; get; }
    }
}
