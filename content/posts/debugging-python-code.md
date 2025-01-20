---
title: "Debugging Python code"
date: 2021-05-01T11:30:03+00:00
# weight: 1
tags: ["python", "pdb", "debugging"]
categories: ["tech"]
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: false
description: ""
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
searchHidden: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: false
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
---
Much of a programmer’s time is spent debugging code than writing one. While I agree that it’s not a great thing, we can’t do much about it. But what we can do is maybe make this process more efficient and fun. In this post, we will try to discuss some techniques that can be useful for debugging. The order goes from a beginner level to a more advanced one.

### Using `print`
_Caution: This is not one of the recommended ways to debug things._

This is one of the ways that most beginners tend to debug their code(I admit doing this during my early years). You try to use the print function to display the object in question. The below code is an example of it.

```python
# t.py
test_string = 'you should look to move away from print debugging'
words = test_string.split()
# in case, you're intersed in seeing what the variable words holds,
# you would do something like this
print(words)
```

Then run the program to view the results.

```sh
▶ python t.py               
['you', 'should', 'look', 'to', 'move', 'away', 'from', 'print', 'debugging']
```

While this method does what you expect it to do, it is a bit restrictive. If you want to know information from more than one object, you will have to add more print statements. You can’t really do much more than just seeing the value of the object at one place.

### Using `pdb`

`pdb`(python debugger) is the built-in module in `python` that could be used for more advance debugging. One of the ways you can use pdb is to use this in place of the `print` function.

```python
# t.py
test_string = 'you should look to move away from print debugging'
words = test_string.split()
# for python version >=3.7
breakpoint()
# otherwise
import pdb;  pdb.set_trace()
```

Now try to run this program, let us see what happens

```sh
▶ python t.py                                                                                                                      
--Return--
> /tmp/t.py(5)<module>()->None
-> breakpoint()
(Pdb)
```

This stops the execution of the program on the line where you inserted `breakpoint`, and drops you in the debugger. Inside the debugger, you can still view all your variables, something like this:

```sh
(Pdb) words
['you', 'should', 'look', 'to', 'move', 'away', 'from', 'print', 'debugging']
(Pdb) test_string
'you should look to move away from print debugging'
```

You can use the `quit` command to exit from this.

There are various other advanced capabilities that the debugger enchants you with. To observe more, let us use a larger program and use `pdb` with it.

```python
# is_prime.py
num = int(input('Enter a number:'))

prime = True
for i in range(2, num):
    if num % i == 0:
        prime = False
        break

if prime:
    print(num , 'is a prime number')
else:
    print(num , 'is NOT a prime number')
```

What the above program does is not important, but for what it is worth it tries to take an input from the user and inform them whether it is prime or not.

Now let us get back to the debugging part, suppose our program wasn’t working as expected, and we would want to debug it. Let just say, we add `breakpoint` inside the loop(for the sake of brevity, we will use breakpoint in our further discussion. If you're using a python version <=_3.6_, you could do the same with `import pdb; pdb.set_trace`).

```python
# in order to not repeat the above program, we just show
# the parts where we add breakpoint
...
for i in range(2, num):
    breakpoint()
    if num % i == 0:
        prime = False
        break
...
```

Now, let us run the program.

```sh
▶ python t.py                                                                                                                         
Enter a number:9
> /tmp/t.py(7)<module>()
-> if num % i == 0:
(Pdb) num
9
(Pdb) i
2
```

- To see where exactly we are inside this program, we can use the command `list`

```sh
(Pdb) list
  2  	num = int(input('Enter a number:'))
  3  	
  4  	prime = True
  5  	for i in range(2, num):
  6  	    breakpoint()
  7  ->	    if num % i == 0:
  8  	        prime = False
  9  	        break
 10  	
 11  	if prime:
 12  	    print(num , 'is a prime number')
```

- To `print` a variable we can use the `p` command

```sh
(Pdb) p num
9
(Pdb) p i
2
```

- To see the type of a variable, you may use the whatis command

```sh
(Pdb) whatis num
<class 'int'>
(Pdb) whatis i
<class 'int'>
```

- To continue the execution of code, you may use the command `continue`

```sh
(Pdb) continue
> is_prime.py(6)<module>()
-> breakpoint()
```

This stops here again, because we have put the `breakpoint` inside the loop. If you see the value for the variables here again, you will see:

```sh
(Pdb) i
3
(Pdb) num
9
```

To clear off all breaks i.e. remove all further breakpoints, you may use the `clear` command(this will give you a prompt to confirm first). Now, when you use the `continue` command, all further breakpoints are skipped.

```sh
(Pdb) clear
Clear all breaks? yes
(Pdb) continue
9 is NOT a prime number
```

Instead of using `continue`, you may also use its short-hand alias `c`. We will try to talk about this later.

_Note: To follow along the examples below, you probably will have to re-run the python program._

To see the complete list of all available commands, you can use the `help` command.

```sh
(Pdb) help

Documented commands (type help <topic>):
========================================
EOF    c          d        h         list      q        rv       undisplay
a      cl         debug    help      ll        quit     s        unt      
alias  clear      disable  ignore    longlist  r        source   until    
args   commands   display  interact  n         restart  step     up       
b      condition  down     j         next      return   tbreak   w        
break  cont       enable   jump      p         retval   u        whatis   
bt     continue   exit     l         pp        run      unalias  where    

Miscellaneous help topics:
==========================
exec  pdb
```

As you can see in the code block above, it tells us that we can view help on individual topics by using help `<topic>`. For example:

```sh
(Pdb) help whatis
whatis arg
        Print the type of the argument.
(Pdb) help p
p expression
        Print the value of the expression.
```

You can’t easily execute multi-line instructions here.(using `if`, `for`, etc.). For this, you can use the command `interact`. This drops you into the `python` interpreter with all your variables defined(up to the `breakpoint` part in your code) and now you can use this as the normal `python` interpreter.

```sh
(Pdb) interact
*interactive*
>>> for j in range(5):
...     print(j)
... 
0
1
2
3
4
```

Some of these commands are also aliased to a more short-term notation. For example, instead of typing `help` every time you can `h` for it, similarly `l` for list, `i` for interact and so on. The help section is the best place to play with this and look for some more advanced stuff.

### Other popular alternatives
There are plenty of other available alternatives. We can just list a few of them here:

- [`pdb++`](https://github.com/pdbpp/pdbpp) — provides colorful tab completion, among various other benefits.
- [`ipdb`](https://github.com/gotcha/ipdb) — a more advanced debugger that leverages the power of [IPython](https://ipython.org/) debugger.
- Most IDEs(like VSCode, PyCharm etc.) also come with their own debugging environment. If you use one, you can surely leverage their power.

I hope this helps in debugging your code more intuitively, and you can hopefully catch the bug in lesser time. In case you have some funny stories about debugging, feel free to share them.

Till we meet in another post, keep hacking and take care.