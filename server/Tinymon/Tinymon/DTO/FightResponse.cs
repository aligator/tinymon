using Tinymon.Entities;

namespace Tinymon.DTO;

public class FightResponse
{
    public required Fight Fight { get; set; }
    public required Fight FightBack { get; set; }
    public AttackType FightBackAttack { get; set; }
}