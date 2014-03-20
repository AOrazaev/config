config
======

Configurations for my developing environment.


# Usage

    git clone https://github.com/AOrazaev/config.git
    cd config
    ./config.sh

All modified files will be backup'ed to the `${HOME}/.config_backup` directory.

# Try

You can also just try this configuration by modifying `HOME` variable.
For example:

    git clone https://github.com/AOrazaev/config.git
    mkdir local_home
    export HOME=${PWD}/local_home
    cd config
    ./config.sh

Now all configuration will be applied to `local_home` directory. And you
can just try this configurations before use it.
