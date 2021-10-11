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
`./install_server.sh` | Allows you to automatically install different minecraft servers
`./decompile.sh` | Allows you to run or install different decompilers (similar to ./install_servers.sh)
`./patch.sh` | Recompiles all changed and tracked files and packs them in a patched jar
`./run.sh` | Runs the patched jar

<br>

# Usage
First, place your server-jar in **both** the './server_jar' and the './patched_server' directory or install one **later** using './install_server.sh'.  
All files are explained below.  

<br><br>

# setup.sh
Run this file at the beginning or if you want to clean up your workspace  
When you want to clean up it will always ask you wether you  _really_ want to reset the workspace, if you don't want that, run the file with `--confirm`  

<br>

# install_server.sh  
Run this file to automatically install (3rd party) minecraft servers. Right now there is only an installer for the vanilla-jar, but due to the modular system, it is very easy to add more, which I will surely do.  

Option | Function
-------|---------
`./install_server.sh --list` | will get you a list of all installer scripts  
`./install_server.sh --install <name> <version>` | will run the specified installer. Supplying just the name of the installer (without suffix or path) is enough for the tool to find the script, assuming it is placed in the './tools/server_installers' directory. The jar-file will be placed in './server_jar' and './patched_jar' directory.  

<br>

# decompile.sh
All decompilers are ran and installed via an individual bash-script in the './tools/decompilers' directory. That way you can easily add other decompilers and commands to install them without changing the other scripts themselves. And sharing these scripts is just as simple.  

Option | Function
-------|---------
`./decompile.sh --list` | will get you a list of all decompiler-scripts  
`./decompile.sh --install <name>` | will run the code in the decompiler's installation-section. Supplying just the name of the file (without suffix or path) is enough for the tool to find the script, assuming it is placed in the './tools/decompilers' directory. The decompiler will then be placed in the './decompilers/bin' directory. Note that not always an install is needed, eg if your script uploads the server-jar to a website like decompiler.com  
`./decompile.sh --decompile` | will run the code in the decompiler's decompile-section. It will decompile the first jar-file it finds in the './server-jar' directory. The decompiled source is then placed in the './decompiled-jar' directory.

<br>

# patch.sh
All files that are listed in './tool/files.txt' will be compiled and packed into a new jar-file. This new file can be found in './patched_jar'.  
(currently) Important: make sure to add a newline to your files.txt file, or the tool thinks it is empty.  

<br>

# run.sh
If no further arguments are given, It will run the patched server-jar with all arguments listed in './tool/args.txt' (single line).  
Or directly run the bash scipt with the arguments you want the server to use.
