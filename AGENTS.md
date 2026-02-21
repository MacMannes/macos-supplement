# AGENTS.md

This document provides guidelines for AI coding agents working in the macos-supplement repository.

## Project Overview

macos-supplement is a macOS setup automation tool built with Bash scripts. It installs Homebrew packages, manages dotfiles, and configures a fresh macOS installation using a profile-based system.

## Project Structure

```
macos-supplement/
├── run.sh                 # Main entry point
├── functions.sh           # Shared utility functions
├── colors.sh              # ANSI color definitions
├── install-brew.sh        # Homebrew installation
├── install-gum.sh         # gum CLI tool installation
├── select-profiles.sh     # Interactive profile selection
├── install-profiles.sh    # Profile installation orchestrator
├── install-dotfiles.sh    # Dotfiles setup via stow
├── cache/                 # Runtime cache (gitignored)
└── profiles/              # Installation profiles
    ├── core/
    │   ├── Brewfile       # Homebrew bundle file
    │   └── install.sh     # Profile-specific installation
    ├── dev/
    └── personal/
```

## Running and Testing

### Main Commands

```bash
# Run full installation (interactive)
./run.sh

# Dry-run mode (show what would happen without executing)
./run.sh --dry-run

# Show help
./run.sh --help

# Run specific installation scripts individually
bash ./install-brew.sh
bash ./install-gum.sh
bash ./select-profiles.sh
bash ./install-profiles.sh
bash ./install-dotfiles.sh
```

### Testing Individual Components

Since this is a shell script project without a formal test suite:

1. **Test a specific script**: Run it directly with bash
   ```bash
   bash ./install-brew.sh
   ```

2. **Test with dry-run**: Set DRY_RUN=1 environment variable
   ```bash
   export DRY_RUN=1
   bash ./install-brew.sh
   ```

3. **Test profile installation**: Manually select profiles first
   ```bash
   bash ./select-profiles.sh
   bash ./install-profiles.sh
   ```

4. **Verify script syntax**: Use shellcheck if available
   ```bash
   shellcheck *.sh
   ```

### Requirements

- macOS Sonoma (14) or higher
- Apple Silicon or 64-bit Intel CPU
- Bash 3.x+ (macOS default)
- Internet connection (for Homebrew/package installations)

## Code Style Guidelines

### General Bash Conventions

1. **Shebang**: Always use `#!/bin/bash` as the first line
2. **Sourcing**: Source dependencies at the top of each script
   ```bash
   source ./colors.sh
   source ./functions.sh
   ```
3. **Error handling**: Use the `run()` function for commands that should exit on failure
4. **Indentation**: Use 4 spaces (not tabs)
5. **Line endings**: Unix (LF)

### Variables and Naming

1. **Variable naming**:
   - Use SCREAMING_SNAKE_CASE for constants and exported variables: `DRY_RUN`, `ROOT_DIR`, `CACHE_FILE`
   - Use lowercase for local variables: `end`, `elapsed`, `status`
2. **Quoting**: Always quote variables to prevent word splitting
   ```bash
   "$VARIABLE"           # Good
   $VARIABLE             # Avoid
   ```
3. **Arrays**: Use proper array syntax (Bash 3 compatible)
   ```bash
   ARRAY=("item1" "item2")
   "${ARRAY[@]}"         # Expand all elements
   ```

### Functions

1. **Function naming**: Use snake_case: `run_script()`, `clone_or_update()`, `done_step()`
2. **Local variables**: Declare with `local` keyword
   ```bash
   function_name() {
       local var="value"
   }
   ```
3. **Return values**: Use exit codes (0 for success, non-zero for failure)

### Output and Messaging

Use the standard messaging functions from `functions.sh`:

```bash
msg "informational message"          # Dim output
ok "success message"                 # Green checkmark
warn "warning message"               # Yellow warning symbol
step "Step name"                     # Cyan arrow, starts timer
done_step                            # Green checkmark with elapsed time
run command args                     # Executes and exits on failure
```

### Control Flow

1. **Conditionals**: Use `[[ ]]` for tests (not `[ ]`)
   ```bash
   if [[ -f "$FILE" ]]; then
       # do something
   fi
   ```

2. **Command existence checks**:
   ```bash
   if command -v brew >/dev/null 2>&1; then
       # brew exists
   fi
   
   # Alternative style also used:
   if which gum >/dev/null 2>&1; then
       # gum exists
   fi
   ```

3. **Exit on error**: Use `|| exit 1` or the `run()` function
   ```bash
   cd "${PROFILE_DIR}" || exit 1
   run brew install package
   ```

### Comments

1. **Section headers**: Use comment blocks with `#` symbols
   ```bash
   ########################################
   # SECTION NAME
   ########################################
   ```

2. **Inline comments**: Place above code or at end of line with spacing
   ```bash
   # This is what we're doing
   command
   
   command  # Inline explanation
   ```

3. **Dependencies**: Document at top of file
   ```bash
   # dependency: source colors.sh first!
   ```

### File Organization

1. **Script structure**:
   - Shebang
   - Source statements
   - Variable declarations
   - Function definitions
   - Main execution logic
   - Cleanup/done_step call

2. **Profiles**: Each profile should have:
   - `Brewfile` (optional) - Homebrew packages to install
   - `install.sh` (optional) - Custom installation logic

### Error Handling

1. **Check file existence** before sourcing or executing
2. **Use the `run()` function** for critical commands
3. **Exit with non-zero status** on errors: `exit 1`
4. **Provide helpful warnings** using `warn()` function

### Best Practices

1. **Idempotency**: Scripts should be safe to run multiple times
   - Check if tools are already installed before installing
   - Use conditional logic: `if command -v tool; then skip; else install; fi`

2. **Environment awareness**:
   - Respect `$DRY_RUN` flag for testing
   - Use `$ROOT_DIR` to reference project root
   - Change directories carefully with error checks

3. **User experience**:
   - Provide clear progress indicators using `step()` and `done_step()`
   - Use appropriate message types (msg, ok, warn)
   - Show elapsed time for long operations

4. **Compatibility**:
   - Write for Bash 3.x (macOS default)
   - Avoid bashisms that require Bash 4+
   - Test array operations for Bash 3 compatibility

## Common Patterns

### Checking if a tool exists
```bash
if command -v tool >/dev/null 2>&1; then
    msg "tool found — skipping install…"
else
    msg "tool missing — installing…"
    run brew install tool
fi
```

### Running a subscript
```bash
run_script "./install-brew.sh" "Installing Homebrew"
```

### Conditional execution based on dry-run
```bash
if [ $DRY_RUN -eq 1 ]; then
    msg "Would run: $command"
else
    run $command
fi
```

## Making Changes

1. **Test locally** on macOS before committing
2. **Use dry-run mode** to verify behavior: `./run.sh --dry-run`
3. **Maintain idempotency** - scripts should be safe to re-run
4. **Follow existing patterns** - consistency is key
5. **Update README.md** if adding new features or requirements
6. **Consider profile organization** - group related tools in profiles
