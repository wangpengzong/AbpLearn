using Abp.Authorization;
using AbpLearn.Authorization.Roles;
using AbpLearn.Authorization.Users;

namespace AbpLearn.Authorization
{
    public class PermissionChecker : PermissionChecker<Role, User>
    {
        public PermissionChecker(UserManager userManager)
            : base(userManager)
        {
        }
    }
}
