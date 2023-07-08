# Doodle-jump-game
This is one of the most popular games in the world that I created with assembly language.

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


