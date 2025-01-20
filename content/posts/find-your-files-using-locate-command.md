---
title: "Find your files using the locate command on Linux"
date: 2021-07-26T11:30:03+00:00
# weight: 1
tags: ["shell", "linux", "locate"]
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
If you love doing things using the command-line interface(CLI) or automating stuff, you would love to know about the usage of the `locate` command. It helps to find files by their names. You may use different kinds of options as per your need. Here we are going to list some of the possible use cases.

### Basic use
```sh
locate foo
```
This will try to match the name _foo_ against the whole name of the file(this includes the path from the current directory). The pattern (in this case _foo_) must match part of the whole file name your pattern. In case it contains metacharacters, it must match exactly. This is the default behavior and is specified using the `-w` option.

### Matching pattern
If you do not exactly remember the name of the file but have some idea about the pattern of the name that you gave to this file, you can use this feature.

```sh
locate -r 'bot.py$'
```
The above command will look for all files whose names end with _bot.py_. You can use the `-i` option to ignore case will matching patterns and file names.

### Count the match
You may use the `-c` option to count the total number of matches, instead of printing the matched file names.

```sh
locate -c '.py'
```
This will count the number of python files in your system.

### Match the basename
The _base name_ of a file is just the last component of the name of the file. For example, the base name of `/var/log/apache2/error.log` is `error.log`.

```sh
locate -b .log
```
This will list out all from the log files (those that have `.log` at the end of their file name).

### Limit the results
In case you want to limit the results. This can be extremely useful when you are using the command inside a script or application and need to display limited entries.

```sh
locate -bl 2 .log
```
This will just print 2 results that include _.log_ in their base name.

These were some of the cases where we thought you may use the command `locate` to save your time. The possibilities are endless.

Till we meet in another post, keep hacking and take care.