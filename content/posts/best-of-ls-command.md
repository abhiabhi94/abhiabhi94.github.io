---
title: "The best of ls command"
date: 2021-07-06T11:30:03+00:00
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
The `ls` command lists the files in the current directory in alphabetical order, if no directory is specified. This command is extremely useful in gathering information about the details of the files present in a directory. Many other useful information can be displayed using this command.

In this article, we would learn about the different options available alongside the `ls` command.

### Simple Listing
```sh
ls
```
This displays the files inside the directory in an alphabetically sorted order in a column format.

```sh
curious@tinker:$ ls
i_am_a_dir  random.txt  script.py  some_data.json
```
### `ls -l`
List the files inside the directory in a long list format. It displays more information(file size, permissions, owners, etc) and is more intuitive especially when we need to sort the files based upon different parameters. The format is also easier to read.

```sh
curious@tinker:$ ls -l
total 4
drwxr-xr-x 2 curious curious 4096 Jan 28 19:00 i_am_a_dir
-rw-r--r-- 1 curious curious    0 Jan 28 19:01 random.txt
-rw-r--r-- 1 curious curious    0 Jan 28 19:01 script.py
-rw-r--r-- 1 curious curious    0 Jan 28 19:01 some_data.json
```

### `ls -a`
Display all the files(even hidden ones). The hidden files aren’t shown by default.

```sh
curious@tinker:$ ls -a
.  ..  i_am_a_dir  .i_am_a_hidden_file  .i_am_hidden_dir  random.txt  script.py  some_data.json
```

This is generally used along with the `-l` option.

```sh
curious@tinker:~/temp$ ls -la
total 20
drwxr-xr-x 5 curious curious 4096 Jan 28 19:07 .
drwxr-xr-x 6 curious curious 4096 Jan 28 19:00 ..
drwxr-xr-x 2 curious curious 4096 Jan 28 19:00 i_am_a_dir
drwxr-xr-x 2 curious curious 4096 Jan 28 19:07 .i_am_a_hidden_file
drwxr-xr-x 2 curious curious 4096 Jan 28 19:07 .i_am_hidden_dir
-rw-r--r-- 1 curious curious    0 Jan 28 19:01 random.txt
-rw-r--r-- 1 curious curious    0 Jan 28 19:01 script.py
-rw-r--r-- 1 curious curious    0 Jan 28 19:01 some_data.json
```
### Sorting
```sh
ls -t
```
Sort the files by modification time, the latest one is displayed first.
```sh
curious@tinker:temp$ ls -lt
total 16
-rw-r--r-- 1 curious curious  194 Jan 28 19:28 script.py
-rw-r--r-- 1 curious curious   19 Jan 28 19:26 some_data.json
-rw-r--r-- 1 curious curious   18 Jan 28 19:26 random.txt
drwxr-xr-x 2 curious curious 4096 Jan 28 19:00 i_am_a_dir
```

### `ls -r`
Sort in reverse order.

```sh
curious@tinker:$ ls -ltr
total 16
drwxr-xr-x 2 curious curious 4096 Jan 28 19:00 i_am_a_dir
-rw-r--r-- 1 curious curious   18 Jan 28 19:26 random.txt
-rw-r--r-- 1 curious curious   19 Jan 28 19:26 some_data.json
-rw-r--r-- 1 curious curious  194 Jan 28 19:28 script.py
```

### `ls -S`
Sort by file size, the largest file is shown first.

```sh
curious@tinker:~/Desktop/temp$ ls -lS
total 16
drwxr-xr-x 2 curious curious 4096 Jan 28 19:00 i_am_a_dir
-rw-r--r-- 1 curious curious  194 Jan 28 19:28 script.py
-rw-r--r-- 1 curious curious   19 Jan 28 19:26 some_data.json
-rw-r--r-- 1 curious curious   18 Jan 28 19:26 random.txt
```

### `ln -U`
Do not sort. List the directories in directory order.

```sh
curious@tinker:~/Desktop/temp$ ls -lU
total 16
drwxr-xr-x 2 curious curious 4096 Jan 28 19:00 i_am_a_dir
-rw-r--r-- 1 curious curious   19 Jan 28 19:26 some_data.json
-rw-r--r-- 1 curious curious   18 Jan 28 19:26 random.txt
-rw-r--r-- 1 curious curious  194 Jan 28 19:28 script.py
```

### Other Useful Options
```sh
ls -h
```
This is generally used with `-l` and/or `-s` option, display the file sizes in a more human-readable format (e.g., _1K 234M 2G_)

```sh
curious@tinker:~/Desktop/temp$ ls -lh
total 16K
drwxr-xr-x 2 curious curious 4.0K Jan 28 19:00 i_am_a_dir
-rw-r--r-- 1 curious curious   18 Jan 28 19:26 random.txt
-rw-r--r-- 1 curious curious  194 Jan 28 19:28 script.py
-rw-r--r-- 1 curious curious   19 Jan 28 19:26 some_data.json
```

### `ls -R`
This recursively lists the sub-directories inside the directories.

When used with `-la`(list and all files) in hidden format, the output can be something as the one below.

```sh
curious@tinker:~/Desktop/temp$ ls -laR
.:
total 32
drwxr-xr-x 5 curious curious 4096 Jan 28 19:28 .
drwxr-xr-x 6 curious curious 4096 Jan 28 19:00 ..
drwxr-xr-x 2 curious curious 4096 Jan 28 19:00 i_am_a_dir
drwxr-xr-x 2 curious curious 4096 Jan 28 19:07 .i_am_a_hidden_file
drwxr-xr-x 2 curious curious 4096 Jan 28 19:07 .i_am_hidden_dir
-rw-r--r-- 1 curious curious   18 Jan 28 19:26 random.txt
-rw-r--r-- 1 curious curious  194 Jan 28 19:28 script.py
-rw-r--r-- 1 curious curious   19 Jan 28 19:26 some_data.json

./i_am_a_dir:
total 8
drwxr-xr-x 2 curious curious 4096 Jan 28 19:00 .
drwxr-xr-x 5 curious curious 4096 Jan 28 19:28 ..

./.i_am_a_hidden_file:
total 8
drwxr-xr-x 2 curious curious 4096 Jan 28 19:07 .
drwxr-xr-x 5 curious curious 4096 Jan 28 19:28 ..

./.i_am_hidden_dir:
total 8
drwxr-xr-x 2 curious curious 4096 Jan 28 19:07 .
drwxr-xr-x 5 curious curious 4096 Jan 28 19:28 ..
```

There are more options available under the `ls` command. They may be useful in different situations as per requirement. The above options just highlight some of them. These help you get start jogging in the world of Linux.

Till we meet in another post, keep hacking and take care.