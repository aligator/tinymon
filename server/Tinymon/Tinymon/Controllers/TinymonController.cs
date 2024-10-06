using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Tinymon.Data;
using Tinymon.DTO;
using Tinymon.Entities;

namespace Tinymon.Controllers;

[ApiController]
[Route("[controller]")]
public class TinymonController : ControllerBase
{
    private readonly DataContext _context;

    private readonly Dictionary<FightCombination, FightResult> _fightMatrix;
    private readonly ILogger<TinymonController> _logger;
    private readonly Random _randomRobert;

    public TinymonController(DataContext context, ILogger<TinymonController> logger)
    {
        _logger = logger;
        _context = context;
        _randomRobert = new Random((int)DateTime.Now.Ticks);

        _fightMatrix = new Dictionary<FightCombination, FightResult>
        {
            // Tackle is always the same
            { new FightCombination(ElementType.Fire, ElementType.Water, AttackType.Tackle), new FightResult(0, 1) },
            { new FightCombination(ElementType.Fire, ElementType.Earth, AttackType.Tackle), new FightResult(0, 1) },
            { new FightCombination(ElementType.Fire, ElementType.Fire, AttackType.Tackle), new FightResult(0, 1) },
            { new FightCombination(ElementType.Water, ElementType.Fire, AttackType.Tackle), new FightResult(0, 1) },
            { new FightCombination(ElementType.Water, ElementType.Earth, AttackType.Tackle), new FightResult(0, 1) },
            { new FightCombination(ElementType.Water, ElementType.Water, AttackType.Tackle), new FightResult(0, 1) },
            { new FightCombination(ElementType.Earth, ElementType.Fire, AttackType.Tackle), new FightResult(0, 1) },
            { new FightCombination(ElementType.Earth, ElementType.Water, AttackType.Tackle), new FightResult(0, 1) },
            { new FightCombination(ElementType.Earth, ElementType.Earth, AttackType.Tackle), new FightResult(0, 1) },

            // Attack1 
            // Firestorm
            { new FightCombination(ElementType.Fire, ElementType.Water, AttackType.Firestorm), new FightResult(0, 2) },
            { new FightCombination(ElementType.Fire, ElementType.Earth, AttackType.Firestorm), new FightResult(0, 3) },
            { new FightCombination(ElementType.Fire, ElementType.Fire, AttackType.Firestorm), new FightResult(1, 1) },

            // Flood
            { new FightCombination(ElementType.Water, ElementType.Fire, AttackType.Flood), new FightResult(0, 3) },
            { new FightCombination(ElementType.Water, ElementType.Earth, AttackType.Flood), new FightResult(0, 2) },
            { new FightCombination(ElementType.Water, ElementType.Water, AttackType.Flood), new FightResult(1, 1) },

            // Earthshake
            { new FightCombination(ElementType.Earth, ElementType.Fire, AttackType.Earthquake), new FightResult(0, 2) },
            {
                new FightCombination(ElementType.Earth, ElementType.Water, AttackType.Earthquake), new FightResult(0, 3)
            },
            {
                new FightCombination(ElementType.Earth, ElementType.Earth, AttackType.Earthquake), new FightResult(1, 1)
            },

            // Attack2 
            // Fireball
            { new FightCombination(ElementType.Fire, ElementType.Water, AttackType.Fireball), new FightResult(0, 1) },
            { new FightCombination(ElementType.Fire, ElementType.Earth, AttackType.Fireball), new FightResult(0, 2) },
            { new FightCombination(ElementType.Fire, ElementType.Fire, AttackType.Fireball), new FightResult(0, 0) },

            // Splash
            { new FightCombination(ElementType.Water, ElementType.Fire, AttackType.Splash), new FightResult(0, 2) },
            { new FightCombination(ElementType.Water, ElementType.Earth, AttackType.Splash), new FightResult(0, 1) },
            { new FightCombination(ElementType.Water, ElementType.Water, AttackType.Splash), new FightResult(0, 0) },

            // Meteor
            { new FightCombination(ElementType.Earth, ElementType.Fire, AttackType.Meteor), new FightResult(0, 1) },
            {
                new FightCombination(ElementType.Earth, ElementType.Water, AttackType.Meteor), new FightResult(0, 2)
            },
            { new FightCombination(ElementType.Earth, ElementType.Earth, AttackType.Meteor), new FightResult(0, 0) }
        };
    }

    private async Task<Entities.Tinymon?> _won(Guid attackerId, int modifier)
    {
        var attacker = await _context.Tinymons.FindAsync(attackerId);

        if (attacker is null) return null;


        attacker.Progress -= 10 + modifier * 5;
        if (attacker.Progress <= 0)
        {
            attacker.Level += 1;
            attacker.Progress += attacker.Level * 100;
        }

        await _context.SaveChangesAsync();

        return attacker;
    }

    private AttackType _randomAttack(ElementType elementType)
    {
        var attackIndex = _randomRobert.Next(0, 2);
        if (attackIndex == 0) return AttackType.Tackle;

        switch (elementType)
        {
            case ElementType.Fire:
                return (AttackType)attackIndex;
            case ElementType.Water:
                return (AttackType)attackIndex + 2;
            case ElementType.Earth:
                return (AttackType)attackIndex + 4;
            default:
                return AttackType.Tackle;
        }
    }

    [HttpPost(Name = "PostNewTinymon")]
    public async Task<ActionResult<Entities.Tinymon>> PostNewTinymon([FromBody] CreateTinymon newTinymon)
    {
        _logger.LogInformation("PostNewTinymon");

        var createdTinymon = _context.Tinymons.Add(new Entities.Tinymon
        {
            Id = Guid.NewGuid(),
            Name = newTinymon.Name,
            Level = 1,
            Progress = 100,
            Image = newTinymon.Image,
            ElementType = newTinymon.ElementType
        });

        await _context.SaveChangesAsync();

        return Ok(createdTinymon.Entity);
    }

    [HttpGet("{id}/enemy", Name = "GetEnemy")]
    public async Task<ActionResult<Entities.Tinymon>> GetAnyEnemy(Guid id, [FromQuery] int level)
    {
        var anyEnemy = await _context.Tinymons.Where(t =>
                t.Level >= level - 3 ||
                t.Level <= level + 2).Where(t => !t.Id.Equals(id)).OrderBy(e => EF.Functions.Random())
            .FirstOrDefaultAsync();

        if (anyEnemy is null)
            return Ok(new Entities.Tinymon
            {
                Id = Guid.Empty,
                Name = "Enemy",
                Level = level,
                Progress = 100,
                Image =
                    "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAAXNSR0IArs4c6QAAAnFJREFUeJztmj9rFEEYh5/Nv0IiXJEUSZN0gTQKFnYpxD524lcIIR9GxO+QLvkCKewsBLUQRAgK4hUJGERCNJC1SMbbnezuvHOzc3M6769Zbm7nvbn5PfPuzM6AKm8VsQI/fLEnvbW8uRYAr3efd9Y33/elmV6j/YOa860gdXZl+QsAw5O1slq+eOesALi6mgXg/OIuAEuDIQA7R/cB+HZyq34UWpWAgLplU6FxeH7uFwAPNl8B8ObDFgA/zwdlU/na6qdavNURQcCIkGcHjwH4/mO5djXyzRFKQEBde0yWMHJ4Y/197Uvbcbvcln2fTcjx101Xe0TKnoDgzPpkfxuAy8sFAE7PVmpOtTk8rmwylgbD65wz/xuAg6eHXvGUgHErmud1RTXnjVN9E9Chzv/y8tHbxnIlwLeCy/kpVO0/2iQoAdIbfZ2/t7Fe+/zu42fpT8VSIwnZE+CcCYY6b5ePS0JbXI94javK7AlozQF9Od8mqXPSuB4kFKA54K8kq8Ekz3lfosbNMdkToB2QugGp1ZUDvMa+GXuusds2Ru0xLI3niuuSEtB3wDbnXM7bn6UkhK4xlIBYgfte/cVaTWZPQI4dUFJ5wuXYATVpB6RuQGp1dUBBxBMk06LsCYg2D5DKnulN+u2xEpC6AUap9g2UgNQNSCDdF6hK0gH/9XwgewJac4DZOWnYIQqS9HkfYV7QSHH2BDjHdoWAoB0i350eWwEk6AmRLk1sHuD7nr9v6SmxFvkQYMZSUC6Y1I6PVNkTEO2UmFQR3wN0Zn8jJcC3QsfMcFpOjIqcN1ICQgN4rBX6IkTUZpfzRtkToFKp8tYfzpzQNeVLQ1QAAAAASUVORK5CYII=",
                ElementType = ElementType.Fire
            });

        return Ok(anyEnemy);
    }

    [HttpPost("{attackerId}/enemy/{defenderId}/fight", Name = "StartFight")]
    public async Task<ActionResult<Fight>> StartFight(Guid attackerId, Guid defenderId)
    {
        var attacker = await _context.Tinymons.FindAsync(attackerId);
        var defender = await _context.Tinymons.FindAsync(defenderId);

        if (attacker is null || defender is null) return NotFound();


        _logger.LogInformation(Convert.ToInt32(10 * attacker.Level * 0.8).ToString());
        _logger.LogInformation(Convert.ToInt32(10 * attacker.Level * 0.2).ToString());
        var createdFight = _context.Fights.Add(new Fight
        {
            Id = Guid.NewGuid(),
            Attacker = attacker,
            Defender = defender,
            HpAttacker = attacker.Level * 100 +
                         _randomRobert.Next(Convert.ToInt32(10 * attacker.Level * 0.2),
                             Convert.ToInt32(10 * attacker.Level * 0.8)),
            HpDefender = defender.Level * 100 +
                         _randomRobert.Next(Convert.ToInt32(10 * defender.Level * 0.2),
                             Convert.ToInt32(10 * defender.Level * 0.8))
        });

        await _context.SaveChangesAsync();

        return Ok(createdFight.Entity);
    }

    [HttpPatch("{attackerId}/fight/{fightId}", Name = "Attack")]
    public async Task<ActionResult<FightResponse>> Attack(Guid attackerId, Guid fightId, [FromBody] FightTinymon action)
    {
        var fight = await _context.Fights
            .Where(f => f.Id == fightId && f.Attacker.Id == attackerId)
            .Include(f => f.Attacker)
            .Include(f => f.Defender).FirstOrDefaultAsync();


        if (fight is null) return NotFound();

        var combi = new FightCombination(fight.Attacker.ElementType, fight.Defender.ElementType, action.Attack);

        _fightMatrix.TryGetValue(combi, out var fightResult);
        fightResult ??= new FightResult(0, 0);

        // level-diff
        var levelDiff = fight.Attacker.Level - fight.Defender.Level;


        fight.HpAttacker -= fightResult.AttackerDamage * 10 - 5 * -levelDiff;
        fight.HpDefender -= fightResult.DefenderDamage * 10 - 5 * levelDiff;
        await _context.SaveChangesAsync();

        // Make clone to disconnect the instance from the db.
        fight = new Fight
        {
            Attacker = fight.Attacker,
            Defender = fight.Defender,
            Id = fightId,
            HpAttacker = fight.HpAttacker,
            HpDefender = fight.HpDefender
        };

        // Fight back 
        var fightBack = await _context.Fights
            .Where(f => f.Id == fightId && f.Attacker.Id == attackerId)
            .Include(f => f.Attacker)
            .Include(f => f.Defender).FirstOrDefaultAsync();
        if (fightBack is null) return NotFound();

        if (fightBack.HpDefender <= 0 || fightBack.HpAttacker <= 0)
        {
            if (fightBack.HpDefender <= 0)
            {
                var updatedAttacker = await _won(attackerId, levelDiff);
                if (updatedAttacker is not null)
                {
                    fight.Attacker = updatedAttacker;
                    fightBack.Attacker = updatedAttacker;
                }
            }

            return Ok(new FightResponse
            {
                Fight = fight,
                FightBack = fightBack
            });
        }

        var fightBackAttack = _randomAttack(fightBack.Defender.ElementType);
        var combiBack = new FightCombination(fightBack.Defender.ElementType, fightBack.Attacker.ElementType,
            fightBackAttack);

        _fightMatrix.TryGetValue(combiBack, out var fightBackResult);
        fightBackResult ??= new FightResult(0, 0);

        // level-diff
        var levelBackDiff = fightBack.Defender.Level - fightBack.Attacker.Level;

        fightBack.HpDefender -= fightBackResult.AttackerDamage * 10 - 5 * -levelBackDiff;
        fightBack.HpAttacker -= fightBackResult.DefenderDamage * 10 - 5 * levelBackDiff;
        await _context.SaveChangesAsync();

        if (fightBack.HpDefender <= 0)
        {
            var updatedAttacker = await _won(attackerId, levelDiff);
            if (updatedAttacker is not null) fightBack.Attacker = updatedAttacker;
        }


        return Ok(new FightResponse
        {
            Fight = fight,
            FightBack = fightBack,
            FightBackAttack = fightBackAttack
        });
    }
}