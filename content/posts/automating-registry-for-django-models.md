---
title: "Automating registry of django models to the admin"
date: 2021-04-01T11:30:03+00:00
# weight: 1
tags: ["python", "django"]
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

Registering models to `django-admin`(in general) is not much of a task, but is mostly boring. Many times it might feel like doing a chore. In this post, we'll try to see how we can automate this process.

### Registering models

Normally, models are registered inside the `admin.py` module of the apps. To automatically register all of our models, we can directly add these lines of code to this file.

```python
from django.contrib import admin
from django.apps import apps

models = apps.get_models()

for model in models:
    admin.site.register(model)
```

This fetches all the models in all `apps` and register them to the `admin` interface. This is especially useful when the django project has a lot of models.

### Handling Custom Admin Models

The above code may throw an exception if you have already registered a model somewhere manually in your Django Project. The error message will be similar to

```sh
django.contrib.admin.sites.AlreadyRegistered: The model MyModel is already registered in app 'myapp'.
```

This is happening because `django` doesn't allow registering a model more than once, and we're doing exactly that.

In such a scenario, you may process in either of the below two mentioned alternatives.

- In case you haven’t performed some sort of customization over the model(`MyModel` in this example), you can safely remove its manual entry. Our automated registration of models will take care of this.

- In case you’re performing some sort of customization, you can catch the exception and let it pass.

```python
from django.contrib import admin
from django.apps import apps

from .models import MyModel

# my custom registration
@admin.site.register(MyModel)
class MyModelAdmin(admin.ModelAdmin):
    list_display = ('fields', )
    search_fields = ('fields', )

models = apps.get_models()
for model in models:
    try:
        admin.site.register(model)
    except admin.sites.AlreadyRegistered:
        pass
```

### Customizing All Admin Models

Although we have registered all the models, it doesn’t display any metadata. This is not very informative for the users who may want some information about the model objects.

We can add a custom class `ModelAdmin` for such purposes. In this example, we will try to populate all the model fields to the list_display attribute for the admin models.

```python
from django.apps import apps
from django.contrib import admin

class ModelAdmin(admin.ModelAdmin):
    def __init__(self, model, admin_site):
        self.list_display = [field.name for field in model._meta.fields]
        super().__init__(model, admin_site)

models = apps.get_models()
for model in models:
    admin.site.register(model, ModelAdmin)
```

Hopefully, this saves your day from the mundane task of registering model to the admin interface. Maybe you can use that time to do better things.

Till we meet in another post, keep hacking!