---
title: "Synchronize panes in tmux"
date: 2021-05-09T11:30:03+00:00
weight: 1000
tags: ["tmux", "shell"]
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

So, you want to run the same command over different terminals? By the end of this blog, hopefully you will know about this neat trick/hack to solve this problem.

Hopefully, you're familiar with `tmux`. If not, basically it is a tool that is used as terminal multiplexer. You can create, access, control multiple terminals from a single screen(and many more things).

So, we will be using it to run the same command in different terminals. The command to do this is `[prefix]:setw synchronize-panes`. The default prefix is `Ctrl + B`.
To disable this you can re-run the above command (`[prefix]:setw synchronize-panes`) to toggle the functionality.

![](https://miro.medium.com/v2/resize:fit:640/format:webp/0*m3HKeGODmFpEmPKu.gif)

Let us go through the above demonstration step by step:
- ### Create a new session

```bash
tmux new -t random
```

- ### Split window

    Split the window into multiple panes. For horizontal splitting you can use the shortcut `[prefix] %`, for vertical use `[prefix] "`

- ### Synchronize Panes
    Use the command prefix `:setw synchronize-panes` to run the same command on all panes.

- ### Disable the functionality

    In case you want to disable the functionality, and get back to your stuff, you can use the command
```sh
prefix :setw synchronize-panes
```
---------------------------------------------
​
Some other situations where you may find this useful:
- When debugging the same code for a different version of a python(or any other language). Suppose your code works when well in `python3.6` but somehow fails in `python3.7`.
- You want to make the same change inside your different projects.

Hopefully you can now execute the same command in different panes to reduce your time. That's it in this post. 

Till we meet in another post, keep hacking!!!