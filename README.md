# mcserver-patch-tool
I use this when reversing minecraft server code



# About  
Whenever I use decompilers to reverse the minecraft server code to understand its functionality, I want to be able to easily modify the code to add debug stuff, like sysouts. Therefore I wrote (still writing) this simple bash-script-collection to automate patching and running the server.  

<br>

# Understanding the tools
This collection contains some bash-scripts, that all have a unique function. Let me explain each one.  

File | Usage
-----|------
`./setup.sh` | Sets up all files and directories required by the other tools
`./decompile.sh` | Allows you to run or install different decompilers
`./patch.sh` | Recompiles all changed and tracked files and packs them in a patched jar
`./run.sh` | Runs the patched jar

<br>

# Usage
All files are explained below.  

<br><br>

# setup.sh
Run this file at the beginning or if you want to clean up your workspace  
When you want to clean up it will always ask you wether you  _really_ want to reset the workspace, if you don't want that, run the file with `--confirm`  

<br>

# decompile.sh
All decompilers are ran and installed via an individual bash-script in the 'decompilers' directory. They use the 'sample.sh' decompiler as a template. That way you can easily add other decompilers and commands to install them without changing the other scripts themselves. And sharing these scripts is just as simple.  

Option | Function
-------|---------
`./decompile.sh --list` | will get you a list of all decompiler-scripts  
`./decompile.sh --install` | will prompt you to enter the name of a decompiler script and then run all commands in the script's installer-section. The decompiler will then be placed in the './decompilers/bin' directory. Note that not always an install is needed, eg if your script uploads the server-jar to a website like decompiler.com  
`./decompile.sh --decompile` | will prompt you to enter the name of a decompiler and then run all commands in the script's decompile-section. It will decompile the first jar-file it finds in the './server' directory. The decompiled source is then placed in the './decompiled' directory.

<br>

# patch.sh
All files that are listed in './data/files.txt' will be compiled and packed into a new jar-file. This new file can be found in './patched_server'.  
Very important note: 
By default the original server-jar-file is added to the classpath when recompiling. That will most-likely not matter, at least I had no problems in the  past when using that. I will make sure to add the option to use the new jar-file for the classpath.  

<br>

# run.sh
If no further arguments are given, It will run the patched server-jar with all arguments listed in './data/args.txt' (single line).  
Or directly run the bash scipt with the arguments you want the server to use.  

<br><br>

# What's about to come?
- [x] Make a readme
- [ ] Rethink the classpath thing
- [ ] Make run.sh automatically agree to the eula
- [ ] Make another bash-script to automatically install any 3rd party server-jar (Spigot, Bukkit, Paper, etc.) for any minecraft version
- [ ] Damn I wanted to add somthing but now I forgot
