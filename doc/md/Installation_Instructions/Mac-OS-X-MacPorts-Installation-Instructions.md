# MacPorts (Mac OS X), developer installation, ***experimental***

<b><h3>These insturctions are not tested on Apple Silicon!</h3></b>

## Prerequisites

These instructions will show how to setup the environment on OSX to the point where you'll be able to clone and compile the repo by yourself, as on Linux, Windows, etc.

1. Have MacPorts installed. Visit https://www.macports.org/ for more information.

    * MacPorts may require a bit more setup. You first need to set up your PATH variable:

    ```bash
    export "/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
    ```

    Although it is optional for proxmark3 repository, you can also set include variables:

    ```bash
    export C_INCLUDE_PATH="/opt/local/include"
    export CPLUS_INCLUDE_PATH="/opt/local/include"
    export LIBRARY_PATH="/opt/local/lib"
    export LDFLAGS="-L/opt/local/lib"
    export CFLAGS="-I/opt/local/include"
    export CPPFLAGS="-isystem/opt/local/include -I/opt/local/include"
    ```

2. Install dependencies:

    ```
    sudo port install readline qt5 qt5-qtbase pkgconfig arm-none-eabi-gcc arm-none-eabi-binutils lua52
    ```

3. Clamp Python version for pkg-config

    MacPorts doesn't handle Python version defaults when it comes to pkg-config. So even if you have done:

    ```
    sudo port install python39 cython39

    sudo port select --set python python39  # this also makes calls to "python" operate on python3.9
    sudo port select --set python3 python39
    sudo port select --set cython cython39 
    ```

    This won't set a default python3.pc (and python3-embed.pc) under the MacPorts pkgconfig includes folder.

    To fix that, follow these steps:

    ```
    cd /opt/local/lib/pkgconfig
    sudo ln -svf python3.pc python-3.9.pc
    sudo ln -svf python3-embed.pc python-3.9-embed.pc
    ```

4. (optional) Install makefile dependencies:

    ```
    sudo port install recode
    sudo port install astyle
    ```


## Compile and use the project

To use the compiled client, you can use `pm3` script, it is a wrapper of the proxmark3 client that handles automatic detection of your proxmark.

Now you're ready to follow the [compilation instructions](/doc/md/Use_of_Proxmark/0_Compilation-Instructions.md).

To flash on OS X, better to enter the bootloader mode manually, else you may experience errors.
With your Proxmark3 unplugged from your machine, press and hold the button on your Proxmark3 as you plug it into a USB port. You can release the button, two of the four LEDs should stay on. You're in bootloader mode, ready for the next step. In case the two LEDs don't stay on when you're releasing the button, you've an old bootloader, start over and keep the button pressed during the whole flashing procedure.
From there, you can follow the original compilation instructions.