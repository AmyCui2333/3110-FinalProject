# Installation
## Ubuntu(CS3110VM):
-----------------
We assume that you have Ubuntu/3110VM, OCaml, and opam installed. If not, please find instructions for installation here. 


## The Graphics Module + CamlImages:
-----------------
This game uses a GUI that is dependent on the “Graphics” module and the “CamlImages” library and needs “libpng” to be installed before Camlimages. 
To install these, run the following commands:

Windows:
```sh
sudo apt-get install libpng-dev libjpeg-dev libtiff-dev libxpm-dev libfreetype6-dev libgif-dev
opam install graphics
opam install camlimages 
```

MacOS:
```sh
brew install libpng (or other command)
opam install graphics
opam install camlimages```
## Setting up X11 on your computer:
-----------------
The GUI we use is dependent on having an X11 server on your local machine. Here are the instructions:

For Windows: 
- Download an X11 server for windows here.
- Open XLaunch on your local computer. On the last page which says Extra settings, tick the box with “disable access control.”
- Find your computer’s IP address. This can be done by looking through settings, or typing “ipconfig/all” into the windows - command prompt and finding the string of numbers in the IPv4 address field.
- Type the following line into your Ubuntu command prompt, replacing <your-ip-address>:
“`export DISPLAY=<your-ip-address>:0.0`”

For MAC: 
- XQuartz is usually already installed on mac. If your machine has XQuartz, there is no further action needed.
- If XQuartz is not installed on your local machine, you can follow the instructions here for installation: https://www.xquartz.org/ 

Finally, run the command “make play” to play the game and load the json file after the prompt.


## Game Command:
-----------------
“W”  : move up
“S”  : move down
“A”  : move left
“D”  : move right

Other keys: exit