---
title: "Using watch to monitor output change for a command"
date: 2021-08-21T11:30:03+00:00
# weight: 1
tags: ["shell", "linux", "watch"]
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
This is one of the things I wish I knew earlier. There have been a lot of times, where I needed to constantly monitor the output of a command and all I would do is use the up(arrow) and enter key to constantly run the previous command. If you, too, have been in this situation, I hope you do what is required in a more optimized manner after reading this post.

### The `watch` command
You can use this to execute a command repeatedly and monitor the output in full-screen mode. Suppose you want to constantly monitor the files inside a directory(e.g. `/tmp/images`), you may use the `ls` command with watch.

```sh
watch ls /tmp/images
```

By default, `watch` runs the command every 2 seconds, in case you need to change that value, you can pass the required value to the `n` parameter.

```sh
watch -n 3 ls /tmp/images
```

### Highlighting the difference
While monitoring, it is generally a pain to monitor the difference manually. This is where the `-d` parameter comes to our rescue. You can use it to highlight the difference.

```sh
watch -d ls /tmp/images
```

### A complex example
Now that we know what powers are bestowed to us by the `watch` command, let us try to monitor a more complicated scenario. Consider a situation where you would want to monitor the state of all `python` processes. The below command can help you do it.

```sh
watch -n 3 "ps aux | grep python"
```

The below screenshots try to show some part of the images when run on my machine.
![](https://miro.medium.com/v2/resize:fit:640/format:webp/0*EM9Z77SETeSmMZW0.jpg)
![](https://miro.medium.com/v2/resize:fit:640/format:webp/0*oRbLoVy69SIbIS-k.jpg)

### Conclusion
In case, you are interested in hacking more into the `watch` command, you can use the `-h` flag to display all the options that you can use with it.

### Seeing the complete list of options
```sh
watch -h
```

I hope you find this post useful and build some exciting stuff using the `watch` command.

Till we meet in another post, keep hacking and take care.