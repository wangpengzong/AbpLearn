using System.Threading.Tasks;
using Abp.Application.Services;
using AbpLearn.Sessions.Dto;

namespace AbpLearn.Sessions
{
    public interface ISessionAppService : IApplicationService
    {
        Task<GetCurrentLoginInformationsOutput> GetCurrentLoginInformations();
    }
}
