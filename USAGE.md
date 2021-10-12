# mcserver-reversing-toolkit
I use this when reverse-engineering minecraft server code  
In the following, I will first discuss all tools and their use, and then show you how to set up a workspace and get started reversing and modifying.  

<br>

# Understanding the Tools  
This toolkit contains a few bash-scripts. Each one serves a specific purpose. All tools are located in the Projects "root", like './setup.sh'.  
The other bash-scripts, like 'tool/server_installers/vanilla.sh' are scripts called by the tools, so you are not intended to interact with them unless you know how to use them.  


File | Usage
-----|------
`./setup.sh` | Sets up all files and directories required by the other tools
`./install_server.sh` | Allows you to automatically install different minecraft servers
`./decompile.sh` | Allows you to run or install different decompilers (similar to ./install_servers.sh)
`./track.sh` | All modified files get added to the list of files to be compiled, when patching
`./patch.sh` | Re-compiles all changed and tracked files and packs them in a patched jar
`./run.sh` | Runs the patched jar

<br>

**setup.sh**  
Run this file at the beginning or if you want to clean up your workspace  
When you want to clean up it will always ask you whether you  _really_ want to reset the workspace, if you don't want that, run the file with `--confirm`  

<br>

**install_server.sh**  
Run this file to automatically install (3rd party) minecraft servers. Right now there is only an installer for the vanilla-jar, but due to the modular system, it is very easy to add more, which I will surely do.  

Option | Function
-------|---------
`./install_server.sh --list` | will get you a list of all installer scripts  
`./install_server.sh --install <name> <version>` | will run the specified installer. Supplying just the name of the installer (without suffix or path) is enough for the tool to find the script, assuming it is placed in the 'tools/server_installers' directory. The jar-file will be placed in 'server_jar' and 'patched_jar' directory. 

<br>

**decompile.sh**
All decompilers are run and installed via an individual bash-script in the './tools/decompilers' directory. That way, you can easily add other decompilers and commands to install them without changing the other scripts themselves. And sharing these scripts is just as simple.  

Option | Function
-------|---------
`./decompile.sh --list` | will get you a list of all decompiler-scripts  
`./decompile.sh --install <name>` | will run the code in the decompiler's installation-section. Supplying just the name of the file (without suffix or path) is enough for the tool to find the script, assuming it is placed in the './tools/decompilers' directory. The decompiler will then be placed in the './decompilers/bin' directory. Note that not always an installation is needed, eg. if your script uploads the server-jar to a website like decompiler.com  
`./decompile.sh --decompile` | will run the code in the decompiler's decompile-section. It will decompile the first jar-file it finds in the './server-jar' directory. The decompiled source is then placed in the './decompiled-jar' directory.

<br>

**track.sh**  
Initializing calculates the sha-1 sums for all decompiled .java files and stores them in a file. When running, it will check for all decompiled .java files, whether they have been modified or not, by validating their checksums.  
If they have been modified, the path gets added to the filetracker ('tool/files.txt'). All files listed there will be compiled and packed into the patched jar when running './patch.sh'.

Option | Function
-------|---------
`./track --init` | empties the filetracker ('tool/files.txt') and computes the sha-1 sums for all decompiled .java files 

<br>

**run.sh**  
If no further arguments are given, It will run the patched server-jar with all arguments listed in './tool/args.txt' (single line).  
Or directly run the bash script with the arguments you want the server to use.

<br><br>

# Getting started
1. Run `./setup.sh`. Make sure the file has the executable bit set, if not, set it with `chmod +x setup.sh`. Running setup will set the executable bit for all other tools
2. Install a server-jar. You can either download one from anywhere and place it in **both** the 'server_jar' and the 'patched_jar' directory, or you can use `./install_server.sh`:
  Run `./install_server.sh --install <name> <version>`. If you wanted vanilla 1.17, you would have to run it like this: `./install_server --install vanilla V1_17_00`. The downloaded server will be placed in both directories.  
3. Run `./decompile.sh --install <name>`, to install a decompiler. Right now, only fernflower is included. Confirm that by running with `--list`. Upon installation, you can run the decompiler (`--decompile`). The decompiled jar will be placed in the 'decompiled_jar' directory.  
4. Run `./track.sh --init` to compute all files checksums. If you want to modify code without having to manually add each modified file to the 'tool/files.txt' file, this is necessary.

You can now start modifying your decompiled code and add, just to give an example, debug stuff.  
Once you are done, follow the next steps to patch your changes into a new jar-file.  
1. Run `./track.sh` without arguments to add all modified files to the filetracker.
2. Run `./patch.sh` to compile all tracked files and patch them into a new jar-file.
Repeat this step over and over again, as you like.  

To run the patched jar file, use the `./run.sh`, explained above.  
