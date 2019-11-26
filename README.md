Micropython Build Environment for ESP32 in a Docker Container
=============================================================

This is an attempt to allow compiling and flashing of Micropython
onto an ESP32 based system from any platform, that can run a docker
container as a command line alias.

Creating the Cross Compiler Tool Chain
--------------------------------------

Cross compiling the Micropython Firmware requires the compiler tool
chain to be installed and pointed to by Environment Variables.
On top of that, Micropython itself requires very specific commit hashes
of that tool chain to be checked out to compile different Micropython versions.
In order to avoid the need to rebuild the Docker container any time those
requirements change (which will be when you just checkout any release
tag of Micropython) we will setup those dependencies in
a directory $HOME/esp32-devel. The Docker container will use the tool chain
there and you can checkout and adjust as needed, without rebuilding the
container itself.

The components hosted there (for now) are
the Espressif Xtensa ESP32 cross compiler
and the Espressif ESP IDF. The script __setup.sh__ will create and populate
that directory. What it does is

```
mkdir $HOME/esp32-devel || exit 1
cd $HOME/esp32-devel || exit 1

wget https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz
tar xzf xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz

git clone --recursive https://github.com/espressif/esp-idf.git
cd esp-idf
git submodule update --init
cd ..
```

Do not forget to do the "git submodule update --init" part after
you checked out another version of the esp-idf. You will get very cryptic
and incomprehensible errors.

Installing Docker
-----------------

Well, this is Linux-Distro dependent and all Linux-Distro-Managers are
very opinionated people. So this all depends. It isn't too bad as it all
starts with something like
```
sudo yum install docker
```
or
```
sudo apt-get install docker
```

The trouble starts after that. Somehow you will need to make $USER
(that's you) a member of the Unix group, that is allowed to use docker.
__Since giving someone permission to use Docker is essentially giving
them root access, do not give it to anyone who isn't already allowed to
use sudo ALL.__ You have been warned. 

On a CentOS system one creates a group "docker" and adds the group to
the user's groups via usermod command.

```
sudo groupadd docker
sudo usermod -a -G docker myusername
```

Creating the Docker Image
-------------------------

Creating the docker image "esp32-devel" is done by running the
__build.sh__ script.

There will be intermediate delta images left behind (you can see them
with "docker images --all"). Leave them there for now as they can
significantly speed up the image build process in case there are any
problems and you need to modify the Dockerfile.
Once done and everything is working you probably want to issue
a "docker system prune -f" command, to reclaim all those GBs of wasted
space in /var.

The __build.sh__ script also tries to communicate to the Dockerfile
the GID of the group that is required to use /dev/ttyUSBx. This group is
normally called "dialout". Since UIDs and GIDs between Docker container
and host are only matched numerical, there can be problems here. I opted
for just attempting to create a group with that GID and make the docker
internal user a member of that. See above: If you already are allowed to
use root, no harm done.

Adding the "esp32" alias
------------------------

The __alias.sh__ file contains a line that belongs into your .bashrc file.
Assuming you use bash.

Check the line. Your ESP32 might not be on /dev/ttyUSB0.

After you do that and enabling it by logging in again or sourcing you
.bashrc, you should be able to do stuff like

```
cd .../micropython/ports/esp32
esp32 make -j4
esp32 make erase
esp32 make deploy
```

And that's it for now.

