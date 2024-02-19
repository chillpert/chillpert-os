# Deploy dotfiles on new installation
dotfiles:
    #!/usr/bin/bash
    set -euo pipefail

    echo 'Setting up dotfiles'

    # Setup alias on new machine
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    
    # Clone the repo
    git clone --bare -b fedora <git-repo-url> $HOME/.dotfils
    
    # Get your files. This step might fail if files already exist, so create a backup and then delete the original files.
    config checkout
    
    # [Optional] Hide untracked files if you like
    config config --local status.showUntrackedFiles no

# Setup dev distrobox
distrobox-setup:
    #!/usr/bin/bash
    set -euo pipefail

    distrobox-assemble create --file /usr/share/chillpert-os/distrobox/distrobox.ini

# Download and install Jetbrains Toolbox
jetbrains-toolbox:
    #!/usr/bin/bash
    set -euo pipefail

    wget -cO jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
    tar -xzf jetbrains-toolbox.tar.gz
    DIR=$(find . -maxdepth 1 -type d -name jetbrains-toolbox-\* -print | head -n1)
    cd $DIR
    ./jetbrains-toolbox
    cd ..
    rm -r $DIR
    rm jetbrains-toolbox.tar.gz

# Helper to call all dev-relaed commands
dev-setup:
    just --unstable dotfiles
    just --unstable distrobox-setup
    just --unstable jetbrains-toolbox
