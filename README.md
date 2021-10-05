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
