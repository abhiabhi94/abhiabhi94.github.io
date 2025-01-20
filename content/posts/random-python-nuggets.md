---
title: "Random python nuggets"
date: 2021-03-15T11:30:03+00:00
# weight: 1
tags: ["python"]
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
Python is already packed with insanely good standard libraries which often makes our job incredibly easy to solve. Apart from that, it comes with some hidden features(also known as [easter eggs](https://en.wikipedia.org/wiki/Easter_egg_(media)#Software)) that may amaze you. Let’s start:

### The Zen of Python
```python
>>> import this

The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
```

### Hello World
```python
>>> import __hello__
Hello World!
```

### Antigravity
```python
>>> import antigravity
```
This opens up the page containing _xkcd_ comic discussing about python.

It also contains a method `geohash`, which is an implementation of geohasing algorithm discussed in a [comic of xkcd](https://www.xkcd.com/426/).

```python
>>> from antigravity import geohash
>>> geohash(37.421542, -122.085589, b'2005-05-26-10458.68')
    37.857713 -122.544543
```

### Never Ever!!
```python
from __future__ import braces
File "<stdin>", line 1
SyntaxError: not a chance
```

### Replace `!=` with `<>`
`!=` works well but it is replaced by `<>`, when you run

```python
from __future__ import barry_as_FLUFL
```
_Fun fact_: This was introduced in [PEP-401](https://www.python.org/dev/peps/pep-0401/) on 01-Apr-2009.

### Cool Hash

```python
>>> hash(float('infinity'))
314159
>>> hash(float('nan'))
0
>>> hash(float('-infinity'))
-314159
```
If you notice hash of infinity is `​int(math.pi*1e5)`.

Till we meet in another post, keep hacking and take care.