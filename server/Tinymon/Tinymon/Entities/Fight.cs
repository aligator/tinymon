namespace Tinymon.Entities;

public class Fight
{
    public required Guid Id { get; set; }
    public required Tinymon Attacker { get; set; }
    public required Tinymon Defender { get; set; }
    public required int HpAttacker { get; set; }
    public required int HpDefender { get; set; }
}