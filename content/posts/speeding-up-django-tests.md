---
title: "Speeding up your django tests"
date: 2021-03-01T11:30:03+00:00
weight: 2000
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

Running tests can become troublesome, if your tests take too long to execute. Ideally, you want an instant feedback from them. Lets us discuss some ways through which we can speed up the run time for our tests.

### Move data creation to `setUpTestData`

`setUpTestData` is pretty much like `setUpClass` in `unittest`. This method is run once before the test class runs. One of the main reasons, tests can be slow is if data creation in done in `setUp` method or inside individual tests. 

The `setUp` method is run once after every test method. Hence, creating data there can be expensive.

You may be surprised to know this change can alone speed up your tests by a long way(obviously depending upon the size of your tests). For reference, this sped up my test run by more than 200% in this [pull request](https://github.com/Radi85/Comment/pull/64)(I admit this time comparison is unscientific).

For example, this is somewhat close to what a minimal diff would look like, when moving from setUp to `setUpTestData` would look like.

```diff
-    def setUp(self):
-        super().setUp()
-        self.user = User.objects.create(username='foo', password='bar')
-        self.book = Book.objects.create(name='Deep Work', author=self.user)
+    @classmethod
+    def setUpTestData(cls):
+        super().setUpTestData()
+        cls.user = User.objects.create(username='foo', password='bar')
+        cls.book = Book.objects.create(name='Deep Work', author=cls.user)
```

### Use in memory database

By default (at the time of writing this), django uses a file based database(sqlite) for tests. Reading from files can be expensive. You can speed them by using an in memory instance of the database when running tests.

An example `diff` would be similar to the one shown below

```diff
DATABASES = {
     'default': {
         'ENGINE': 'django.db.backends.sqlite3',
-            'NAME': os.path.join(BASE_DIR, 'db.sqlite3')
-        }
+        'NAME': ':memory:',
     }
```

### Use a simpler password hasher

_TLDR_(Too long didn't read) of this is to use a simpler password hasher, because the default one are a bit slow. 

Although this is a bit insecure, you probably don't need that level of security for your tests. Adding the line below to your settings file for test, could be enough.
```python
PASSWORD_HASHERS = ["django.contrib.auth.hashers.MD5PasswordHasher"]
```

A combination of using an in memory database, and using a simpler password hasher sped up my tests more than 500%. You may look at the [pull request](https://github.com/Radi85/Comment/pull/209) for reference.

How I came to the above conclusion is an interesting(so it seems to me) story, which probably demands its own blog post. I will try to remember to link the story here.

### Use `SimpleTestCase` for non-database tests

Let us say, you're trying to test some custom template tag that you wrote. Now, this functionality doesn't necessarily require connection to a database. For such test cases, you may replace `TestCase` with `SimpleTestCase`.

```diff
-from django.test import TestCase
+from django.test import SimpleTestCase
 
 
-class TestTemplateTags(TestCase):
+class TestTemplateTags(SimpleTestCase):
```

If you're from the world of `pytest`, you shouldn't use the marker `@pytest.mark.django_db` or something similar for such tests(in case you aren't using one already).

### Don't use apps like `django-debug-toolbar` or `sentry` while testing

While tools like `django-debug-toolbar` are great for debugging while in development, similarly `sentry` for error capture and reporting in production, they slow up the tests. This is because they try to monitor every request, and create an unnecessary overhead.

### Don't create the test database for every run

Before running tests, django needs to run all your migrations to make sure all your tests are executed on the correct database schema. While there isn't much alternative to its first run, you can certainly save this time on subsequent runs. 

The test command when run with the `--keepdb` option preserves the test database, which can be used for subsequent runs.

This way you save the cost of running the migrations every time. For the world of `pytest`, you may use a similar option `--reuse-db`.

### Run tests in parallel

Most machines, these days, have a lot more cores than one. It would be wise to use them to save time. You can pass the `--parallel` flag followed by the number _(N)_ which states the maximum number of processes to be used when running tests.

You may have to play a bit with the number _N_ to exactly find the most appropriate one for your case. Something in between _4-10_ mostly does the job for me. Depending upon the size of your test suite, the results might vary.

The world of `pytest` has a plugin `pytest-xdist` for similar use cases.

_Caution: This might not work on your `CI`(continuous integration) systems, depending upon whether your providers have multiple cores or allow them. Nevertheless, this should almost always be useful for development._

### Profile your tests

While almost all the above advises are in general, if your tests still continue to be slow, you should strongly consider profiling them. This can help you find out the potential pain points.

It is always better than guessing. I will try to cover profiling python code in more detail in a future blog post, hopefully I remember to update the link here.

I hope these measures help in reducing your overall test run time, so that you get to spend some more time doing things that you love. 

Till we meet in another post, keep hacking!