using Tinymon.Entities;

namespace Tinymon.Controllers;

public class FightCombination
{
    public readonly ElementType attackerType;
    public readonly AttackType attackType;
    public readonly ElementType defenderType;

    public FightCombination(ElementType attackerType, ElementType defenderType, AttackType attackType)
    {
        this.attackerType = attackerType;
        this.defenderType = defenderType;
        this.attackType = attackType;
    }

    // Override GetHashCode to provide a custom hash code algorithm
    public override int GetHashCode()
    {
        // Use a prime-based hash calculation similar to the previous example
        unchecked // Allow overflow
        {
            var hash = 17;
            hash = hash * 23 + attackerType.GetHashCode();
            hash = hash * 23 + defenderType.GetHashCode();
            hash = hash * 23 + attackType.GetHashCode();
            return hash;
        }
    }

    // Override Equals to ensure that two FightCombination objects are considered equal based on their fields
    public override bool Equals(object? obj)
    {
        if (obj == null || GetType() != obj.GetType())
            return false;

        var other = (FightCombination)obj;
        return attackerType == other.attackerType
               && defenderType == other.defenderType
               && attackType == other.attackType;
    }
}