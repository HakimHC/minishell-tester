## Minimalistic tester for the 'minishell' project

This is a small script made in bash, for testing various features of my shell.
I have not made this script very portable, the prompt must contain 'minishell' in it.
If you want to use this tester, for some reason, change the variable ```prompt``` to the content of your prompt.

## Implementation

This simple tester is made up of 2 functions, one testing the standart output, and one testing the exit code of your shell.
They both take in one argument as input, it being the line of command that you wish to execute. It is dead simple.

### Usage

Make sure the ```test.sh``` and ```aux.sh``` files have the correct permissions, by executing ```chmod +x test.sh aux.sh```.
Execute test.sh with 1 argument, the path to your minishell executable (not the directory, but the binary itself).

This tester is very simple, and to be honest, i kind of made it for my own amusement, I'm enjoying bash scripting lately.
Maybe, in the near future, I'll make this tester more portable, and add a couple of more features.

Thanks for reading!
