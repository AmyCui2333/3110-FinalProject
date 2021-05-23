# **3110-FinalProject**

Developed by Amy, Yu, and Alex in 2021.

Please check [INSTALL.md](https://github.com/AmyCui2333/3110-FinalProject/blob/main/INSTALL.md) for the detailed guidance on how to install our game. After successful installation, you may read the following instructions on how to run our game.

# Instructions on Running Game

Great! You have successfully installed all things required for this game. Now let's run it:

## **Windows**:
1. Open `XLaunch` on your local **WINDOWS** computer. Don't change any default option, except for the page "`Extra settings`" where you should tick the box with "`Disable access control`". Then, continue until you complete all settings.
2. Find your local **WINDOWS** computer’s IP address. This can be done by Looking through your computer settings; but if you have no idea how to find it, follow the guidance below:
- Open the **WINDOWS** command prompt by pressing the `start` button on keyboard, typing "`cmd`", and press the `enter` button.
- Type "`ipconfig/all`" into the **WINDOWS** command prompt.
- Find the string of numbers in the "`IPv4 Address`" field. It may look like "`188.188.88.88`" with numbers different from here. Copy and save this string of numbers.
3. Open your **UBUNTU** command prompt. Type the following line into your **UBUNTU** command prompt, replacing "`<your-ip-address>`" with the IP address you found in the last step above:
```
export DISPLAY=<your-ip-address>:0.0
```
4. In your **UBUNTU** command prompt, change directory into the place you downloaded the game.
5. Run the command "`make play`" in your **UBUNTU** command prompt to start the game. You will see the following lines displayed in the **UBUNTU** command prompt:
```
Welcome to the 🐫 3110 Game engine.

~ Game has started ~

```
6. Our game will immediately start! Read the instruction page, Choose from three maps, Pick your favorite character (🦙lama? 🐫camel?), and Begin Your Adventure~

( Tips: if you are new to our game, you may want to choose the "`easy`" map to start with :D )

## **MacOS**:
1. NOTE: we assume that MacOS has `XQuartz` installed in the local machine. If it is not the case, you can follow the instructions [here](https://www.xquartz.org/) for guidance.
2. In your **UBUNTU** command prompt, change directory into the place you downloaded the game.
3. Run the command "`make play`" in your **UBUNTU** command prompt to start the game. You will see the following lines displayed in the **UBUNTU** command prompt:
```
Welcome to the 🐫 3110 Game engine.

~ Game has started ~

```
4. Our game will immediately start! Read the instruction page, Choose from three maps, Pick your favorite character (🦙lama? 🐫camel?), and Begin Your Adventure~

( Tips: if you are new to our game, you may want to choose the "`easy`" map to start with :D )



# 5. Commands on Keyboard:
**W** - move up

**S** - move down

**A** - move left

**D** - move right

**SPACE** - put a bomb at where the player locates in
