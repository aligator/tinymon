using Microsoft.EntityFrameworkCore;

namespace Tinymon.Data;

public class DataContext: DbContext
{
    public DataContext(DbContextOptions<DataContext> options) : base(options) {}
    
    public DbSet<Entities.Tinymon> Tinymons { get; set; }
    public DbSet<Entities.Fight> Fights { get; set; }
}