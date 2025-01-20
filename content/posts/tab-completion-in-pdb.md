---
title: "Enabling tab completion in pdb"
date: 2021-04-01T11:30:03+00:00
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

I will admit being a big fan of `pdb`, and the debugging functionalities it provides. It still could do more by adding tab completion to guess attributes for python objects. In this post, we will try to address this caveat.

### Setting up Tab Completion

Create a `.pdbrc` in your home directory. Add the following contents to the file

```python
# this adds tab completion
import rlcompleter
__import__('pdb').Pdb.complete = rlcompleter.Completer(locals()).complete
```

Just save this file and use `breakpoint`(or `import pdb;pdb.set_trace`(for `py <=3.6`)) anywhere. 

Boom! This is it. You can now use the `Tab` key pretty similar to how you would use it with the python interpreter.

The example below show the newly added feature to our debugger.
```sh
▶ python3                                              
Python 3.8.5 (default, May 27 2021, 13:30:53) 
[GCC 9.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> breakpoint()
--Return--
> <stdin>(1)<module>()->None
(Pdb) import tempfile
(Pdb) tempfile.
tempfile.NamedTemporaryFile(    tempfile.TemporaryFile(         tempfile.gettempprefixb(        tempfile.tempdir
tempfile.SpooledTemporaryFile(  tempfile.gettempdir(            tempfile.mkdtemp(               tempfile.template
tempfile.TMP_MAX                tempfile.gettempdirb(           tempfile.mkstemp(               
tempfile.TemporaryDirectory(    tempfile.gettempprefix(         tempfile.mktemp(                
(Pdb) tempfile.
```

I hope this helps you in saving a ton of time when debugging. 

Till we meet in another post, keep hacking and take care.