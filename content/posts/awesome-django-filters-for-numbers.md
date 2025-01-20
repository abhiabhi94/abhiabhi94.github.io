---
title: "An awesome django filter for displaying numbers"
date: 2021-04-01T11:30:03+00:00
# weight: 1
tags: ["python", "django", "django-filters"]
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
Displaying large numbers like _1234_, _1243423_, etc. in their raw form can be less intuitive for viewers. Such large numbers make it difficult to calculate the actual value of the number.

Hence I thought of making a filter inside my Django application(you may call it app), for displaying numbers in a more informative format(and awesome too, I guess). The file structure and format might be specific to Django, but the logic can be used in any other framework or language. By the end of this post, you should be able to display these numbers in the form _1.2K_, _1.24M_.

In case, you are not using Django, and only concerned about the logic, you may skip this part. If you aren’t interested in reading through the logic and just want to go through the code, this gist is for you.

### Adding a template tag
If you don’t already have one, add a directory `templatetags` inside the application where you intend to use this tag. Inside this directory create a file, `cool_num.py`. This file will hold all the logic for us.

### Registering the filter
- First of all, we need to import the necessary module
```python
from django import register
```


This will import the `register` module which will be used to register the filter. In case, you are interested in knowing more, you may view the official django documentation.

- Now, we need to go ahead and create an object of the `Library` class define inside template.

```python
register = template.Library()
```

- The function filter defined inside `Library` will be used to register the name of the filter. Before defining the logic for the function, we use the decorator function filter to register our cool_nums filter.

```python
@register.filter(name='cool_num', is_safe=False)
def cool_num(val, precision=2):
```

- In case you want to use a different name, you may pass the desired value to the name parameter for the filter function. You may also ignore this field, in case you want to use the name for the filter to be the same as the name of the function.

### Logic
- For numbers less than _1000_, we can display them as they are since they values is easier to estimate.
- For numbers between _1K_(_1000_ or one thousand) and _1M_(_1_000_000_ or one million),
  Divide them by 1000.
    - Calculate the values with a precision of up to 2 decimal values.
    - Remove the 0’s from the right-side if there are some.
    - Now, remove the `.` sign from the right-side if there is any.
    - Change the number to string form and add the string `K` in the end.
    - The input-output relation will be of the form:
    
    |Input| Output |
    |------|----------|
    |_1234_ | 1.23K |
    |_12345_| 12.3K |
    |_123456_ | 123.4K |
    ------------------

- For numbers greater than 1 million(_1_000_000_, ten lakhs)
    - The steps will be the same but for the first and last steps. Divide the number by 1_000_000(1M)
    - Add the string `M` in the end.
    - The input-output relation will be of the form:
    
    |Input| Output |
    |------|----------|
    |_1234567_| 1.23M |
    |_12345678_| 12.3M |
    | _123456789_ | 123.4M |

You may extend the logic in case, you need to expect larger numbers.

Inside the function, we can put the lines:

```python
try:
    int_val = int(val)
except ValueError:
    raise template.TemplateSyntaxError(
        f'Value must be an integer. {val} is not an integer')
if int_val < 1000:
    return str(int_val)
elif int_val < 1_000_000:
    return f'{ int_val/1000.0:.{precision}f}'.rstrip('0').rstrip('.') + 'K'
else:
    return f'{int_val/1_000_000.0:.{precision}f}'.rstrip('0').rstrip('.') + 'M'
```

For `django` users, to use this filter inside a template, you need to load the filter first and then use it:

```jinja2
{% load cool_num %}
...
...
{{ my_num|cool_num }}
...
```
where `my_num` is the name of the variable that you want to display using this awesome filter.

You may need to restart your server(development) before you can use the newly registered filter.

The whole code regarding the template can be found in the [gist](https://gist.github.com/abhiabhi94/0aa114241e34537c00f0130b0868b882). In case you have any suggestions or require any help, you may comment there.

I hope this filter serves the purpose of your project. Till we meet again in another blog post, keep Hacking.


Till we meet in another post, keep hacking!