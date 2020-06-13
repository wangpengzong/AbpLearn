using System.Collections.Generic;
using AbpLearn.Roles.Dto;

namespace AbpLearn.Web.Models.Common
{
    public interface IPermissionsEditViewModel
    {
        List<FlatPermissionDto> Permissions { get; set; }
    }
}