#!/bin/bash
#===============================================================================
# Hermes Rust Installer & Profile Setup
#===============================================================================
# Installs Hermes Rust (from hermes-rs-test) and sets up your profiles
# from the exported setup directory.
#
# Usage:
#   chmod +x install-hermes-rust.sh
#   ./install-hermes-rust.sh
#
# Requirements:
#   - macOS (M1/M2/M3) or Linux
#   - Internet connection (for Rust/cargo)
#   - ~5GB free disk space (for Rust build)
#===============================================================================

set -euo pipefail

#--- Configuration -------------------------------------------------------------
HERMES_REPO="https://github.com/AyoubMzian-Dev/hermes-rust.git"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
SETUP_DIR="${HERMES_SETUP_DIR:-$HOME/Hermes-setup}"
CRAFTS_DIR="${HOME}/Crafts"
BIN_DIR="${HOME}/.local/bin"
VERSION="0.1.1"

#--- Helper functions ----------------------------------------------------------

log_info()  { echo -e "\033[1;34m[INFO]\033[0m $1"; }
log_warn()  { echo -e "\033[1;33m[WARN]\033[0m $1"; }
log_success() { echo -e "\033[1;32m[OK]\033[0m $1"; }
log_error() { echo -e "\033[1;31m[ERROR]\033[0m $1"; }

check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_warn "Running as root. Some operations may fail. Continuing..."
    fi
}

#--- Step 1: Check prerequisites ----------------------------------------------

step_1_prereqs() {
    log_info "Step 1: Checking prerequisites..."

    # Check for Xcode CLT (macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! xcode-select -p &> /dev/null; then
            log_warn "Xcode Command Line Tools not found. Installing..."
            xcode-select --install
            while [[ ! -d "/Library/Developer/CommandLineTools" ]]; do
                sleep 2
            done
            log_success "Xcode CLT installed."
        else
            log_success "Xcode CLT found."
        fi
    fi

    # Check for git
    if ! command -v git &> /dev/null; then
        log_error "git is not installed. Please install git first."
        exit 1
    fi
    log_success "git found."

    # Check for curl (for rustup)
    if ! command -v curl &> /dev/null; then
        log_error "curl is not installed. Please install curl first."
        exit 1
    fi
    log_success "curl found."
}

#--- Step 2: Install Rust (if not installed) -----------------------------------

step_2_rust() {
    log_info "Step 2: Checking Rust installation..."

    if command -v rustc &> /dev/null && command -v cargo &> /dev/null; then
        RUSTC_VERSION=$(rustc --version)
        CARGO_VERSION=$(cargo --version)
        log_success "Rust ${RUSTC_VERSION} (cargo ${CARGO_VERSION}) already installed."
    else
        log_warn "Rust not found. Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        # Source rust environment
        if [[ -f "$HOME/.cargo/env" ]]; then
            source "$HOME/.cargo/env"
        fi
        log_success "Rust installed."
    fi

    # Verify installation
    if ! command -v cargo &> /dev/null; then
        log_error "cargo not found after installation. Please restart your terminal and try again."
        exit 1
    fi

    log_info "Rust version: $(cargo --version)"
}

#--- Step 3: Clone and build hermes-rs-test -------------------------------------

step_3_build() {
    log_info "Step 3: Cloning and building hermes-rs-test..."

    # Clone the repo
    if [[ ! -d "$CRAFTS_DIR/hermes-rs-test" ]]; then
        mkdir -p "$CRAFTS_DIR"
        log_info "Cloning hermes-rs-test from GitHub..."
        git clone "$HERMES_REPO" "$CRAFTS_DIR/hermes-rs-test"
        log_success "Repository cloned."
    else
        log_info "Repository already exists. Pulling latest changes..."
        cd "$CRAFTS_DIR/hermes-rs-test"
        git pull origin main
        cd - > /dev/null
    fi

    # Build the project
    log_info "Building hermes (this may take 5-15 minutes on M1)..."
    cd "$CRAFTS_DIR/hermes-rs-test"

    # Check if we're already built
    if [[ -f "target/release/hermes" ]]; then
        log_warn "Existing build found. Rebuilding..."
    fi

    cargo build --release -p hermes-cli
    cd - > /dev/null

    if [[ -f "$CRAFTS_DIR/hermes-rs-test/target/release/hermes" ]]; then
        log_success "Hermes binary built successfully."
    else
        log_error "Build failed. Check your internet connection and try again."
        exit 1
    fi
}

#--- Step 4: Set up profiles ----------------------------------------------------

step_4_setup_profiles() {
    log_info "Step 4: Setting up profiles..."

    # Check if the setup directory exists
    if [[ ! -d "$SETUP_DIR" ]]; then
        log_warn "Setup directory not found at $SETUP_DIR"
        log_warn "Please run the export script or download it from the repo."
        read -p "Continue without profile setup? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    # Create hermes home directory
    mkdir -p "$HERMES_HOME"
    mkdir -p "$HERMES_HOME/profiles"

    # Copy config.yaml
    if [[ -f "$SETUP_DIR/config.yaml" ]]; then
        cp "$SETUP_DIR/config.yaml" "$HERMES_HOME/config.yaml"
        log_success "Copied config.yaml"
    fi

    # Copy SOUL.md and SESSION.md
    for file in SOUL.md SESSION.md; do
        if [[ -f "$SETUP_DIR/$file" ]]; then
            cp "$SETUP_DIR/$file" "$HERMES_HOME/$file"
            log_success "Copied $file"
        fi
    done

    # Copy memories
    if [[ -d "$SETUP_DIR/memories" ]]; then
        cp -r "$SETUP_DIR/memories" "$HERMES_HOME/"
        log_success "Copied memories"
    fi

    # Copy .env.example
    if [[ -f "$SETUP_DIR/.env.example" ]]; then
        cp "$SETUP_DIR/.env.example" "$HERMES_HOME/.env"
        log_success "Copied .env (from .env.example template)"
    fi

    # Copy profiles
    if [[ -d "$SETUP_DIR/profiles" ]]; then
        cp -r "$SETUP_DIR/profiles/." "$HERMES_HOME/profiles/"
        log_success "Copied profiles:"
        for profile in "$HERMES_HOME"/profiles/*; do
            [[ -d "$profile" ]] || continue
            echo "  - $(basename "$profile")"
        done
    else
        log_warn "No profiles directory found in setup. Skipping profile setup."
    fi

    # Copy global skills
    if [[ -d "$SETUP_DIR/skills" ]]; then
        cp -r "$SETUP_DIR/skills" "$HERMES_HOME/"
        log_success "Copied global skills"
    fi

    log_success "Profile setup complete."
}

#--- Step 5: Post-installation --------------------------------------------------

step_5_post_install() {
    log_info "Step 5: Post-installation..."

    # Add bin to PATH if not already there
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        echo "" >> "$HOME/.zshrc"
        echo "# Hermes Rust" >> "$HOME/.zshrc"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$HOME/.zshrc"
        log_success "Added $BIN_DIR to PATH"
        log_warn "Please restart your terminal or run: source ~/.zshrc"
    fi

    # Ensure .env exists and is writable
    if [[ ! -f "$HERMES_HOME/.env" ]]; then
        log_warn "No .env file found. Creating from template..."
        if [[ -f "$SETUP_DIR/.env.example" ]]; then
            cp "$SETUP_DIR/.env.example" "$HERMES_HOME/.env"
            log_warn "Created ~/.hermes/.env from .env.example. Edit it with your API keys."
        fi
    fi

    # Show next steps
    log_info "Installation complete!"
    echo ""
    echo "  Hermes version: $VERSION"
    echo "  Binary:       $BIN_DIR/hermes"
    echo "  Config:       $HERMES_HOME/config.yaml"
    echo "  Profiles:     $HERMES_HOME/profiles/"
    echo ""
    echo "  To run:"
    echo "    hermes                    # interactive session"
    echo "    hermes --version          # show version"
    echo "    hermes doctor             # check system"
    echo ""
    echo "  To setup API keys:"
    echo "    nano ~/.hermes/.env"
    echo ""
    echo "  To run a test:"
    echo "    hermes chat -q 'Hello, test this working'"
}

#--- Main -----------------------------------------------------------------------

main() {
    log_info "========================================"
    log_info "  Hermes Rust Installer"
    log_info "  Version: $VERSION"
    log_info "========================================"
    echo ""

    check_root
    step_1_prereqs
    step_2_rust
    step_3_build
    step_4_setup_profiles
    step_5_post_install

    log_success "Installation complete!"
}

main "$@"]
