# Ensure the script is run from the correct directory (assuming it's a Git repo with a NixOS configuration)
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Not inside a git repository."
    exit 1
fi

# Commit message passed as argument, or fallback to "Automated commit before NixOS rebuild"
COMMIT_MSG="${1:-Automated commit before NixOS rebuild}"

# Stage all changes and commit
git add .
if ! git commit -m "$COMMIT_MSG"; then
    echo "Git commit failed. Exiting."
    exit 1
fi

# Attempt to perform nixos-rebuild
if ! nixos-rebuild switch --flake .; then
    echo "nixos-rebuild failed. Undoing the git commit."
    git reset HEAD~1  # Undo the commit
    exit 1
fi

echo "Successfully committed changes and switched NixOS configuration."