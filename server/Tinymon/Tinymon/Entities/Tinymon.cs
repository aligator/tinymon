namespace Tinymon.Entities;

public class Tinymon
{
    public required Guid Id { get; set; }
    public required string Name { get; set; }
    public required int Level { get; set; }
    public required int Progress { get; set; }
    public required string Image { get; set; }
    public required ElementType ElementType { get; set; }
}