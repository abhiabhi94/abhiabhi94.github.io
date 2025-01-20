---
title: "Caching expensive operations in python"
date: 2021-08-15T11:30:03+00:00
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
### Problem
You have a function that takes a lot of time to execute. You need to call that function frequently, at different points in your code with the same arguments. This expensive function seems to be the bottleneck. Hopefully, after reading this post you will be able to deal with this situation and make your code work faster.

### Caching the output
You can cache the output of the expensive function using `lru_cache`.
```python
from functools import lru_cache

@lru_cache()
def my_expensive_function():
    ...
```

Let us try to see with an example. For the sake of example, assume the function `foo` does some expensive operation(an operation that consumes a lot of time).

```python
>>> @lru_cache()
... def foo(x):
...     print('x has the value %d' % x)
...     return x
... 
>>> foo(11)
x has the value 11
11
>>> foo(12)
x has the value 12
12
...
# the call to the function didn't actually execute the function
>>> foo(11)
11
>>> foo(12)
12
```
Yippee! As you can see the subsequent calls for `foo(11)` and `foo(12)` were cached and the result was returned without even executing the function.

### Customizing Cache
You can pass some arguments to customize the way cache is treated.

#### Max Size
In case, you want to change the number of values that you want to be cached for the function, you can an argument to the `maxsize` parameter. It has a default value of _128_.

Depending on the machine which is executing this code, this customization can be helpful in performance improvements.

Example
```python
# only 2 values will be cached at a time for this function
>>> @lru_cache(maxsize=2)
... def foo(x):
...     print('x has the value %d' % x)
...     return x
... 
>>> foo(11)
x has the value 11
11
>>> foo(12)
x has the value 12
12

# cached
>>> foo(11)
11

>>> foo(21)
x has the value 21
21
# since only 2 least recently used values(11, 21 in this case) are cached, this is calculated again
>>> foo(12)
x has the value 12
12
```
In case, you pass a value `None` to maxsize, the features of LRU(least recently used) are disabled and the cache can grow indefinitely.

#### Typed
This is a boolean parameter. It has a default value as `False`. If set to `True`, arguments of different types will be cached differently.

Example: `foo(3.0)` and `foo(3)` will be treated as distinct calls with distinct results.

### Advance Usage
In case, you want to extract some information about the cached stuff, you can use `foo.cached_hits()`. This returns a `namedtuple` with the attributes hits, misses, maxsize, currsize.

This information can be useful when writing unit-tests.

You can use the function `foo.cache_clear()` to clear the cache and other statistics.

### Conclusion
Hopefully, after reading this post, you can reduce the run time for your expensive functions. You want to check out some other [utility articles](/tags/utils) that can be useful in improving your code.

Till we meet in another post, keep hacking and take care.