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
    private readonly ILogger<TinymonController> _logger;
    private readonly DataContext _context;

    public TinymonController(DataContext context, ILogger<TinymonController> logger)
    {
        _logger = logger;
        _context = context;
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

    [HttpGet("enemy", Name = "GetEnemy")]
    public async Task<ActionResult<Entities.Tinymon>> GetAnyEnemy([FromQuery] int level)
    {
        var rand = new Random((int)DateTime.Now.Ticks);
        var anyEnemy = await _context.Tinymons.Where(t => t.Level == level).OrderBy(e => EF.Functions.Random()).FirstOrDefaultAsync();
        
        if (anyEnemy is null)
        {
            return Ok(new Entities.Tinymon
            {
                Id = Guid.Empty, 
                Name = "Enemy", 
                Level = level, 
                Progress = 100, 
                Image = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAAXNSR0IArs4c6QAAAnFJREFUeJztmj9rFEEYh5/Nv0IiXJEUSZN0gTQKFnYpxD524lcIIR9GxO+QLvkCKewsBLUQRAgK4hUJGERCNJC1SMbbnezuvHOzc3M6769Zbm7nvbn5PfPuzM6AKm8VsQI/fLEnvbW8uRYAr3efd9Y33/elmV6j/YOa860gdXZl+QsAw5O1slq+eOesALi6mgXg/OIuAEuDIQA7R/cB+HZyq34UWpWAgLplU6FxeH7uFwAPNl8B8ObDFgA/zwdlU/na6qdavNURQcCIkGcHjwH4/mO5djXyzRFKQEBde0yWMHJ4Y/197Uvbcbvcln2fTcjx101Xe0TKnoDgzPpkfxuAy8sFAE7PVmpOtTk8rmwylgbD65wz/xuAg6eHXvGUgHErmud1RTXnjVN9E9Chzv/y8tHbxnIlwLeCy/kpVO0/2iQoAdIbfZ2/t7Fe+/zu42fpT8VSIwnZE+CcCYY6b5ePS0JbXI94javK7AlozQF9Od8mqXPSuB4kFKA54K8kq8Ekz3lfosbNMdkToB2QugGp1ZUDvMa+GXuusds2Ru0xLI3niuuSEtB3wDbnXM7bn6UkhK4xlIBYgfte/cVaTWZPQI4dUFJ5wuXYATVpB6RuQGp1dUBBxBMk06LsCYg2D5DKnulN+u2xEpC6AUap9g2UgNQNSCDdF6hK0gH/9XwgewJac4DZOWnYIQqS9HkfYV7QSHH2BDjHdoWAoB0i350eWwEk6AmRLk1sHuD7nr9v6SmxFvkQYMZSUC6Y1I6PVNkTEO2UmFQR3wN0Zn8jJcC3QsfMcFpOjIqcN1ICQgN4rBX6IkTUZpfzRtkToFKp8tYfzpzQNeVLQ1QAAAAASUVORK5CYII=", 
                ElementType = ElementType.Fire
            });
        }

        return Ok(anyEnemy);
    }
}