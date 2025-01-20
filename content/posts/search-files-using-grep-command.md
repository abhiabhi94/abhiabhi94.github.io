---
title: "Search through files using the grep command in linux"
date: 2021-06-01T11:30:03+00:00
# weight: 1
tags: ["shell", "linux", "grep"]
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
The `grep` command is one of the most powerful commands in Linux. It is used for searching a pattern inside files. The pattern can range from a simple alphabet to a complex regular expression. There are various scenarios where `grep` can be useful. I will try to list some of them in this post.

### List all the lines in a file that contain the word
```sh
grep -i 'hello world' main.txt
```
The `-i` option is used to ignore case distinctions i.e makes the search case insensitive. The above command will try to find the lines in the file `main.txt` that contain the word _hello world_.

We may give more than 1 file if we need.

```sh
grep -i 'hello world' main.txt main.c
```

### List just the name of the matching files
```sh
grep -l 'main' *.py
```

This will list all Python modules (`*.py` files) inside the current directory that contain the word main inside them.

### List the name of the matching files alongside the matching lines

```sh
grep -H 'main' *.py
```
### Search recursively inside directories
```sh
grep -r 'hello' /home
```
Both `-r` and `-R` specify the search to be recursive, except the fact that `-R` also follows symlinks.

### Search recursively only through files that match a particular pattern
```sh
grep -ir 'main' include='*.cpp' /home
```
This will look recursively but only inside the `C++` files(end with `.cpp`)

### Search only for a word
Our last search would even match with word _mains_ or _really_main_ but if we want it to just match a word not just a part of the word, we can use the option `-w`

```sh
grep -irw 'main' include='*.cpp' /home
```

For more control, you may use the `\<`, `\>` to match the start and end of words. For example

```sh
grep '\<main' *
```
will search only for the words starting with main. So this will match the word _mains_ but not _really_mains_.

### List the file names with no matching lines
```sh
grep -L 'import' *.py
```

### Invert the match
```sh
grep -v 'import' *.py
```

### Count the number of lines when the word matches
```sh
grep -c 'import' *.py
```

### Print the line number alongside the matched line

```sh
grep -n 'import' *.py
```

### Print the context around matching lines

```sh
grep -C 2 'math.log' *.py
```
This will print 2 lines of context around each matching line.

### Using Regular Expression
```sh
grep -e '[[:digit:]]' info.txt
```
The `-e` option is used to specify regular expression patterns. In this case, the pattern is a digit. You can use more complex expressions according to your needs.

### Using pipes to redirect output from another command
```sh
tail /var/log/apache2/error.log | grep -e '[[:digit:]]'
```

These were some of the use cases that I thought could be useful for you when learning about the `grep` command. It can help you in saving time, especially when searching through a chunk of files. I hope it helps you swim to deeper depths into the world of Linux.


Till we meet in another post, keep hacking and take care.