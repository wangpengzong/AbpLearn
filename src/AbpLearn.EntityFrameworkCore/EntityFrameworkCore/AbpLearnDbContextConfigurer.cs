using System.Data.Common;
using Microsoft.EntityFrameworkCore;

namespace AbpLearn.EntityFrameworkCore
{
    public static class AbpLearnDbContextConfigurer
    {
        public static void Configure(DbContextOptionsBuilder<AbpLearnDbContext> builder, string connectionString)
        {
            builder.UseMySql(connectionString);
        }

        public static void Configure(DbContextOptionsBuilder<AbpLearnDbContext> builder, DbConnection connection)
        {
            builder.UseMySql(connection);
        }
    }
}
