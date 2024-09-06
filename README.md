# Doodle jump game(x86)
This is one of the most popular games in the world that I created with assembly-x86 language. 
The game features a character that jumps on platforms to reach higher levels while avoiding obstacles.

# Prerequisites 📋
To run this game, you will need the following:
    
  - Download DOSBox and install it on your system
  - Obtain the 8086 assembler and set it up
  - Clone the repository 

# How to use it?

First, you need to install and run Dosbox on your computer. Then, you should mount the c directory to the ASM folder:
```
mount c path:\to\the\folder\ASM
c:
```  
Next, you should assemble the doodle.asm file using the commands below:
```
masm /a doodle.asm
```
After typing this, it will ask you for object filename(OBJ), source listing(LST), and cross-reference(CRF) files, leave them blank by pressing `Enter` of type `;` and then press `Enter` to skip all those fields.
After assembling it is time to link the assembled file:
```
link doodle
```
Again it will show you some fields just type `;` and press `Enter`.
After that just type:
```
doodle
```

# How to play?🎮

Use the ```j``` and ```k``` to control the character's movement.

The character automatically jumps when landing on a platform.

Try to jump from one platform to another to reach higher levels.

Avoid falling off the screen or colliding with obstacles.

The game ends when the character falls off the screen or collides with a bug.



# License
This project is licensed under the ```MIT License```. You are free to use and modify the base code. enjoy:)


