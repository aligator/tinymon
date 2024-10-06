namespace Tinymon.Entities;

public class FightResult
{
    public readonly int AttackerDamage;
    public readonly int DefenderDamage;

    public FightResult(int attackerDamage, int defenderDamage)
    {
        AttackerDamage = attackerDamage;
        DefenderDamage = defenderDamage;
    }
}