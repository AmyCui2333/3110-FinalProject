# **Installation Index**

Installation process explained step by step:
1. Ubuntu
2. Graphics + CamlImages
3. Setting up X11
4. Running Game
5. Game Commands



# 1. Ubuntu (CS3110VM):
We assume that you have Ubuntu/3110VM, OCaml, and opam installed. If not, please find instructions for installation [here](https://canvas.cornell.edu/courses/25259/pages/install-ocaml). 



# 2. The Graphics Module + CamlImages:
This game uses a GUI that is dependent on the `libpng` package, `Graphics` module, and the `CamlImages` library (NOTE: `libpng` package needs to be installed before `Camlimages`).

To install these, run the following commands step by step:

## **Windows**:
Start with a looooong line of code below:
```
sudo apt-get install libpng-dev libjpeg-dev libtiff-dev libxpm-dev libfreetype6-dev libgif-dev
```
```
opam install graphics
opam install camlimages
```

## **MacOS**:
```
brew install libpng
opam install graphics
opam install camlimages
```



# 3. Setting up X11 on Your Computer:

The GUI we use is dependent on having an X11 server on your local machine. Here are the instructions:

## **Windows**:
1. Download an X11 server for Windows [here](https://sourceforge.net/projects/vcxsrv/) and install it.
2. Open `XLaunch` on your local **WINDOWS** computer, and you will get into the `Display settings` process. Until you get to the page that says "`Extra settings`", do not change any default option.
3. On the page of settings, which says "`Extra settings`", tick the box with "`Disable access control`". Then, continue until you complete settings, without changing any default option.

## **MacOS**:
1. `XQuartz` is usually already installed on mac. If your machine has `XQuartz` installed, there is no further action needed.
2. If `XQuartz` is not installed on your local machine, you can follow the instructions [here](https://www.xquartz.org/) for guidance.



# 4. Instructions on Running Game

Great! You have successfully installed all things required for this game. Now let's run it:

## **Windows**:
1. Open `XLaunch` on your local **Windows** computer. Don't change any default option, except for the page "`Extra settings`" where you should tick the box with "`Disable access control`". Then, continue until you complete all settings.
2. Find your local **WINDOWS** computer’s IP address. This can be done by Looking through your computer settings; but if you have no idea how to find it, follow the guidance below:
- Open the **WINDOWS** command prompt by pressing the `start` button on keyboard, typing "`cmd`", and press the `enter` button.
- Type "`ipconfig/all`" into the **WINDOWS** command prompt.
- Find the string of numbers in the "`IPv4 Address`" field. It may look like "`188.188.88.88`" with numbers different from here. Copy and save this string of numbers.
3. Open your **UBUNTU** command prompt. Type the following line into your **UBUNTU** command prompt, replacing "`<your-ip-address>`" with the IP address you found in the last step above:
```
export DISPLAY=<your-ip-address>:0.0
```
4. In your **UBUNTU** command prompt, change directory into the place you downloaded the game. The directory name should be "`3110-FinalProject`".
5. Run the command "`make play`" in your **UBUNTU** command prompt to start the game. You will see the following lines displayed in the **UBUNTU** command prompt:
```
Welcome to the 3110 Game engine.
Please enter the name of the game file you want to load.

>
```
6. Load the json file by typing "`background.json`" into the **UBUNTU** command prompt and pressing the `enter` button. Then, our game will immediately start!

## **MacOS**:
1. NOTE: we assume that MacOS has `XQuartz` installed in the local machine. If it is not the case, you can follow the instructions [here](https://www.xquartz.org/) for guidance.
2. In your **UBUNTU** command prompt, change directory into the place you downloaded the game. The directory name should be "`3110-FinalProject`".
3. Run the command "`make play`" in your **UBUNTU** command prompt to start the game. You will see the following lines displayed in the **UBUNTU** command prompt:
```
Welcome to the 3110 Game engine.
Please enter the name of the game file you want to load.

>
```
4. Load the json file by typing "`background.json`" into the **UBUNTU** command prompt and pressing the `enter` button. Then, our game will immediately start!



# 5. Commands on Keyboard:
**W** - move up

**S** - move down

**A** - move left

**D** - move right

**SPACE** - put a bomb at where the player locates in