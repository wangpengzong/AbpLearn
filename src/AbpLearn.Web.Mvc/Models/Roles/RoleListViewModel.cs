using System.Collections.Generic;
using AbpLearn.Roles.Dto;

namespace AbpLearn.Web.Models.Roles
{
    public class RoleListViewModel
    {
        public IReadOnlyList<PermissionDto> Permissions { get; set; }
    }
}
