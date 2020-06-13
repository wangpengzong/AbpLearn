using Abp.Application.Services;
using AbpLearn.MultiTenancy.Dto;

namespace AbpLearn.MultiTenancy
{
    public interface ITenantAppService : IAsyncCrudAppService<TenantDto, int, PagedTenantResultRequestDto, CreateTenantDto, TenantDto>
    {
    }
}

