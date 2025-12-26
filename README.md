# ENV Var Shamer

Scans for potentially sensitive environment variables in .env files before they get committed. Run: `./env-shamer.sh [directory]` or add to pre-commit hooks. Exits with code 1 if shame is detected.