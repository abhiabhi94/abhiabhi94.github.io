---
title: "Separate development and production settings for a django project"
date: 2021-02-01T11:30:03+00:00
weight: 5000
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

When I first started working on Django, I used to edit the settings file every time I had to push the code to deployment. Change the value of `DEBUG`, read the values for `SECURITY_KEY` from a config file and many other settings. It used to be a really painful experience and I would curse myself every time I had to do that.

Then, one fine day I decided that I have had enough and thought of finding ways through which I don’t need to make any changes when I push my code into deployment. I had to separate the settings for the development and production environment.

I decided we could to make settings a python module. Currently, the directory structure would look something like this:

```sh
├── manage.py
└── django_project
    ├── settings.py
    ├── urls.py
    ├── views.py
    └── wsgi.py
```

Let’s start setting up everything.

- ### Create a settings directory

The structure would look something like this now

```sh
.
    ├── manage.py
    └── django_project
        ├── settings
        ├── urls.py
        ├── views.py
        └── wsgi.py
```

- ### Common Settings

Inside settings create a `base.py` file. This file should contain the settings that will be used by both the development and production environment.

You can use set everything except `DEBUG`, `SECURITY_KEY`, `ALLOWED_HOSTS` inside this file. We will set them, don't worry.

- ### Developer Settings

Inside settings, create another python file with the name `dev.py`. The contents of this file should look something like this:

```python
from .base import *

DEBUG = True

ALLOWED_HOSTS = []
```

In case you use something like debug toolbar, you should initialize its settings here.

- ### Production Settings

You should create this file inside the settings directory. The contents of the file will be:

```python
from .base import *

DEBUG = False

ALLOWED_HOSTS = ['mysite.com', 'ip.of.my.site', 'www.mysite.com', ]
```

In case you use something like sentry for logging errors on the deployment server, initialize it in this file.

- ### Secrets

This `JSON` file will contain our security key and a key `PROD`. This key will help us in choosing which file to use for our django project based upon the environment.

You will have to create this file on both the development and production environment. You want to put this file outside the project’s directory in case you are using a version control software like Git, GitLab, etc. Exposing this key to the world may create a security issue.

Since I am working on a Linux machine, I am creating the file inside the directory `/etc/`.

```sh
nano /etc/config.json
```

Now on a development server, you only need to set the key `SECURITY_KEY`. So the contents of this file would be:
```json
{
    "SECRET_KEY": "my security key",
}
```

For the production server, this would contain an additional key, PROD.

```json
{
    "SECRET_KEY": "my security key",
    "PROD": "True"
}
```
_Note: You may use any other method to store `SECURITY_KEY` and other values. You can use environment variables or any other method that you like. This is just one of the methods. Just grab these value inside `__init__.py` file accordingly._ 

Let us see how we can do it in case we follow the `JSON` format.

- ### Initializing Settings

Create `__init__.py` file in the settings directory. This will allow us to use settings as a python module. We will also set `SECURITY_KEY` inside this.

The directory structure should now, look something of this:

```sh
.
    │   manage.py
    ├───data
    └───django-project
        ├───settings
        │   ├── base.py
        │   ├── dev.py
        │   ├── __init__.py
        │   ├── prod.py
        │   urls.py
        │   wsgi.py
```

`_init__.py` will be something similar to this:

```python
import os
import json

CONFIG_FILE = '/etc/config.json'

try:
    with open(CONFIG_FILE) as config_file:
        config = json.load(config_file)
        config['PROD']
    from .prod import *


except KeyError:
    from .dev import *

SECRET_KEY = config['SECRET_KEY']
```

_Note: If you have used any other method to store `SECURITY_KEY` and other values just modify this file, accordingly_.

This is it, you have just separated the settings for your production and deployment environment. Now, you won’t have to edit the files every time you push your code to deployment. Just push the code and experience Nirvana.

This was just an attempt to help you increase productivity so that you can save your time to work on other issues.

Till we meet, again in another blog post, keep hacking!!!