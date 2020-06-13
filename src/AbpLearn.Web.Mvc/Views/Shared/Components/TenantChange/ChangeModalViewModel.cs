using Abp.Application.Services.Dto;
using System.Collections.Generic;

namespace AbpLearn.Web.Views.Shared.Components.TenantChange
{
    public class ChangeModalViewModel
    {
        public int? TenantId { get; set; }

        public string TenancyName { get; set; }

        public int? TenantMenuType { get; set; }


        public List<ComboboxItemDto> TeneacyItems { get; set; }
    }
}
