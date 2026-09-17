# Step 1: Create fresh virtual environment
Remove-Item -Path ".venv" -Recurse -Force -ErrorAction SilentlyContinue
uv venv

# Step 2: Sync dependencies - this should install all base dependencies from pyproject.toml
uv sync

# Step 3: Verify dotenv is installed
uv pip list | Select-String "dotenv"
Write-Host "Done"
