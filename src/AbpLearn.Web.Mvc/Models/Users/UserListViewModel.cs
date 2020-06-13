using System.Collections.Generic;
using AbpLearn.Roles.Dto;

namespace AbpLearn.Web.Models.Users
{
    public class UserListViewModel
    {
        public IReadOnlyList<RoleDto> Roles { get; set; }
    }
}
