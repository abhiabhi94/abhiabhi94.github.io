---
title: "Use named tuples to stop yourself from remembering order of tuples"
date: 2021-04-15T11:30:03+00:00
# weight: 1
tags: ["python", "utils"]
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
Let’s consider an example where you’re returning some info about a `Person` object from a `function` in the form of a `tuple`.

```python
def info():
    ...
    return name, address, age
```

Now, in this scenario the receiving `function` needs to know the sequence in which the values are being returned.

Although, this might not seem to be much of an issue for a one-time use case, let me try to explain some possible issues with this.

- You or someone else has to remember the exact sequence of value when reading this code.
- When you come back and read this code after a month, there is a high probability that you might not remember the exact sequence and have to refer to the original `function` info.

Since code is read more often that it is written, it is important to write code that is more readable. This is where `namedtuple` come in.

### Using namedtuple
We can use `namedtuple` to return an object and access the attributes of that object to get our values. The code below does this for you. Keep in mind, we will learn the newer syntax(using the `typing` module) later in this post.

```python
from collections import namedtuple

def info():
    ...
    Person = namedtuple('Person', ['name', 'address', 'age'])
    # initialize using positional or keyword arguments
    person = Person('foo', 'bar', age=25)
    return person
```

Now you can access the same values as:

```python
def access_info():
    person = info()
    # access fields via name
    name = person.name
    age = person.age
    ...
```
​
The above syntax is more readable and you no longer have to remember the sequence. Yippee !!!

### Compatibility with older code
The older syntax is still valid, i.e. you can still unpack this to use the earlier syntax

```python
name, address, age = info()
```

### Accessing namedtuple as dictionary
In case you want to access the attributes as a dictionary, you can use the `_asdict` method of the `namedtuple`.

```python
def access_info():
    person = info()
    person_dict = person._asdict()
    # OrderedDict([('name', 'foo'), ('address', 'bar'), ('age', 25)])
```

### Newer Syntax
If you’re using `python` _3.6_ or above(hopefully), and want to use static `typing`(I love it), you can use the newer syntax. The code below works the same as above.

```python
from typing import NamedTuple

class Person(NamedTuple):
    name: str
    address: str
    age: int

# the inline syntax below also works, although I prefer the one above as it seems more readable to me.
Person = NamedTuple('Person', name=str, address=str, age=int)
```
You can still access this `NamedTuple` object as a normal method and also, use its `_asdict` method if you want.

### Conclusion
In case, you’re writing code for `python` versions _>= 3.6_, I would advise you to use the newer syntax. Hopefully you would have enjoyed reading this post, and use the power of `namedtuple` to write cleaner code.


Till we meet in another post, keep hacking and take care.