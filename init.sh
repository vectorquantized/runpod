#!/bin/bash

# Initialize Conda for Zsh
conda init zsh
chsh -s $(which zsh)

# Create the CUDA workspace if it doesn't exist
mkdir -p /workspace/cuda

# Function to append a line to .zshrc only if it's not already present
add_to_zshrc() {
    local line="$1"
    local file="$HOME/.zshrc"
    if ! grep -Fxq "$line" "$file"; then
        echo "$line" >> "$file"
    fi
}

# Add environment configurations to .zshrc only if they don't exist
add_to_zshrc "cd /workspace/cuda"
add_to_zshrc "alias ca='conda activate'"
add_to_zshrc "alias cel='conda env list'"
add_to_zshrc "alias concr='conda create'"
add_to_zshrc "ca cuda"

# Set Git to use config from /workspace/.gitconfig
add_to_zshrc "export GIT_CONFIG_GLOBAL=/workspace/.gitconfig"

# Reload Zsh configuration
source $HOME/.zshrc

# Print Git user information
echo "Git username: $(git config --global user.name)"
echo "Git email: $(git config --global user.email)"

# Install useful utilities
apt-get -y install less

# Ensure ~/.ssh directory exists
mkdir -p $HOME/.ssh
chmod 700 $HOME/.ssh

# Add SSH config entry to use the key from /workspace/.ssh
SSH_CONFIG_FILE="$HOME/.ssh/config"
if [ ! -f "$SSH_CONFIG_FILE" ]; then
    echo "Creating SSH config file..."
    touch "$SSH_CONFIG_FILE"
    chmod 600 "$SSH_CONFIG_FILE"
fi

# Copy the SSH private key if needed
if [ -f /workspace/.ssh/id_rsa ]; then
    cp /workspace/.ssh/id_rsa $HOME/.ssh/id_rsa
    chmod 600 $HOME/.ssh/id_rsa  # Secure the private key
else
    echo "Error: /workspace/.ssh/id_rsa not found!"
    exit 1
fi

# Configure Git and SSH to use the copied key
export GIT_SSH_COMMAND="ssh -i $HOME/.ssh/id_rsa -o StrictHostKeyChecking=no"

# Verify the permissions
ls -l $HOME/.ssh/id_rsa


# Clone the repository only if it does not exist
# REPO_URL and REPO_DIR are set as ENV VARS when we launch the runpod instance

if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning repository into $REPO_DIR..."
    GIT_SSH_COMMAND="ssh -i /workspace/.ssh/id_rsa -o StrictHostKeyChecking=no" git clone $REPO_URL $REPO_DIR
else
    echo "Repository already exists at $REPO_DIR. Skipping clone."
fi
