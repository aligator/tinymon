using Tinymon.Entities;

namespace Tinymon.DTO;

public class CreateTinymon
{
    public required string Name { get; set; }
    public required string Image { get; set; }
    public required ElementType ElementType { get; set; }
}