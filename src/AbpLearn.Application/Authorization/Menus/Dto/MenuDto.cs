using Abp.Application.Services.Dto;
using Abp.AutoMapper;
using AbpLearn.Authorization.Menus;

namespace AbpLearn.Authorization.Menus.Dto
{
    [AutoMapFrom(typeof(AbpMenus))]
    public class MenuDto : EntityDto<int>
    {
        public string MenuName { set; get; }
        public string LName { set; get; }
        public string Url { set; get; }
        public string Icon { set; get; }
        public string PageName { set; get; }
        public int ParentId { set; get; }
        public bool IsActive { set; get; }
        public int Orders { set; get; }
    }

}
