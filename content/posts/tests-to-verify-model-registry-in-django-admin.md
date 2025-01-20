---
title: "Add tests to verify registry of models to django admin"
date: 2021-07-01T11:30:03+00:00
weight: 4000
tags: ["python", "django", "tests"]
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
In the last post, we learned [how to automate registration of models to the django-admin](../automating-registry-for-django-models). In this post, we will try to see how we can add tests to verify that all our models have been registered.

### Why do we need it?
Even though the `admin.py` module is run internally when running the tests, it doesn't actually verify whether all models have been registered or not. It is a very common thing to forget registering your model to the admin, especially when you aren't really customizing them.

### Writing tests
To test, we would need to get all models from the `apps` registry and iterate over them to see if they are registered or not. Let us try to put this to code.

```python
from django.test import TestCase
from django.contrib import admin
from django.apps import apps

class TestAdmin(TestCase):
    def test_all_models_are_registered(self):
        models = apps.get_models()

        for model in models:
            self.assertIs(
                    True,
                    admin.site.is_registered(model),
                    msg=f'Did you forget to register the "{model.__name__}" in the django-admin?')

```
### Advanced Usage
In case, you have registered some models as `Inlines` in the admin, the function `admin.site.is_registered()` would return `False` for them. To handle such cases, we would just need a small tinkering of our above code.

```python
from django.apps import apps
from django.contrib import admin
from django.test import TestCase

class TestAdmin(TestCase):
    def test_all_models_are_registered(self):
        models = apps.get_models()

        for model in models:
            try:
                self.assertIs(
                    True,
                    admin.site.is_registered(model),
                    msg=f'Did you forget to register the "{model.__name__}" in the django-admin?')
            except AssertionError as exception:
                # these models have been registred as inlines in the admin.
                if model in [MyInLnes]:
                    continue
                else:
                    raise exception
```

That’s it, now you’re done. Your tests(assuming they are part of your Continous Integration pipeline) will automatically inform you when you forget to register a model. Relax!!!, you deserve it.

Hopefully, this post helps in stopping you from last minute bloopers.

Till we meet in another post, keep hacking!