using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Tinymon.Migrations
{
    /// <inheritdoc />
    public partial class fight : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Fights",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AttackerId = table.Column<Guid>(type: "uuid", nullable: false),
                    DefenderId = table.Column<Guid>(type: "uuid", nullable: false),
                    HpAttacker = table.Column<int>(type: "integer", nullable: false),
                    HpDefender = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Fights", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Fights_Tinymons_AttackerId",
                        column: x => x.AttackerId,
                        principalTable: "Tinymons",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Fights_Tinymons_DefenderId",
                        column: x => x.DefenderId,
                        principalTable: "Tinymons",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Fights_AttackerId",
                table: "Fights",
                column: "AttackerId");

            migrationBuilder.CreateIndex(
                name: "IX_Fights_DefenderId",
                table: "Fights",
                column: "DefenderId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Fights");
        }
    }
}
