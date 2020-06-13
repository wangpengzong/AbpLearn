using System.Threading.Tasks;
using AbpLearn.Models.TokenAuth;
using AbpLearn.Web.Controllers;
using Shouldly;
using Xunit;

namespace AbpLearn.Web.Tests.Controllers
{
    public class HomeController_Tests: AbpLearnWebTestBase
    {
        [Fact]
        public async Task Index_Test()
        {
            await AuthenticateAsync(null, new AuthenticateModel
            {
                UserNameOrEmailAddress = "admin",
                Password = "123qwe"
            });

            //Act
            var response = await GetResponseAsStringAsync(
                GetUrl<HomeController>(nameof(HomeController.Index))
            );

            //Assert
            response.ShouldNotBeNullOrEmpty();
        }
    }
}