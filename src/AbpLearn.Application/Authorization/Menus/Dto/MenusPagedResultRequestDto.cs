using Abp.Application.Services.Dto;
using System;
using System.Collections.Generic;
using System.Text;

namespace AbpLearn.Authorization.Menus.Dto
{
    [Serializable]
    public class MenusPagedResultRequestDto: PagedResultRequestDto, IPagedAndSortedResultRequest
    {
        public virtual int? TenantId { get; set; }

        public virtual string Sorting { get; set; }

        public virtual bool ShowAll { get; set; }

    }
}
