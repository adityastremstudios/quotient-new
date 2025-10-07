"""
✅ Production-ready config for the Quotient Discord Bot
Compatible with discord.py v2.x + Tortoise ORM.
"""

import os
from dotenv import load_dotenv

# Load environment variables (.env for local, Render for cloud)
load_dotenv()

# ======================================================
# 🔹 BOT SETTINGS
# ======================================================

DISCORD_TOKEN = os.getenv("DISCORD_TOKEN", "")
PREFIX = os.getenv("BOT_PREFIX", "q")
COLOR = 0x00FFB3
FOOTER = "quo is lub!"

# ======================================================
# 🔹 DATABASE (Tortoise ORM + PostgreSQL)
# ======================================================

# Example: postgresql://user:pass@host:port/dbname
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgres://quotient_db_a20z_user:lar4wZTUU7P2dtCWoVjZtqgxgUsvkKFw@dpg-d3i17re3jp1c73fufuvg-a/quotient_db_a20z",
)

TORTOISE = {
    "connections": {"default": DATABASE_URL},
    "apps": {
        "models": {
            "models": [
                "models.guild",
                "models.user",
                "models.premium",
                "aerich.models",
            ],
            "default_connection": "default",
        },
    },
}

# ======================================================
# 🔹 COGS / EXTENSIONS TO LOAD
# ======================================================

EXTENSIONS = (
    "cogs.general",
    "cogs.premium",
    "cogs.esports",
    "cogs.admin",
)

# ======================================================
# 🔹 OPTIONAL LINKS & DEV SETTINGS
# ======================================================

SERVER_LINK = os.getenv("SERVER_LINK", "")
BOT_INVITE = os.getenv("BOT_INVITE", "")
WEBSITE = os.getenv("WEBSITE", "")
REPOSITORY = os.getenv("REPOSITORY", "")
DEVS = tuple(map(int, os.getenv("DEVS", "123456789012345678").split(",")))

# ======================================================
# 🔹 LOGGING CHANNELS (optional)
# ======================================================

SHARD_LOG = os.getenv("SHARD_LOG", "")
ERROR_LOG = os.getenv("ERROR_LOG", "")
PUBLIC_LOG = os.getenv("PUBLIC_LOG", "")
