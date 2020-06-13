using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;
using AbpLearn.Configuration;
using AbpLearn.Web;

namespace AbpLearn.EntityFrameworkCore
{
    /* This class is needed to run "dotnet ef ..." commands from command line on development. Not used anywhere else */
    public class AbpLearnDbContextFactory : IDesignTimeDbContextFactory<AbpLearnDbContext>
    {
        public AbpLearnDbContext CreateDbContext(string[] args)
        {
            var builder = new DbContextOptionsBuilder<AbpLearnDbContext>();
            var configuration = AppConfigurations.Get(WebContentDirectoryFinder.CalculateContentRootFolder());

            AbpLearnDbContextConfigurer.Configure(builder, configuration.GetConnectionString(AbpLearnConsts.ConnectionStringName));

            return new AbpLearnDbContext(builder.Options);
        }
    }
}
