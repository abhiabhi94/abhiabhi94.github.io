---
title: "Writing unit tests for migrations in django"
date: 2021-03-01T11:30:03+00:00
weight: 3000
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

Writing tests for migration can be a bit tricky because all of your migrations are generally run before any of your test. In case you want to test your code for a particular migration, you will have to revert the database to that particular state. Make sure you don’t forget to revert to the latest state after this test ends. In this post, we will see who we can do this.

### Usecase
Whenever you write custom migrations. Suppose you add a new attribute to your model. Now you want the attribute to be backward compatible. So, you write a custom function inside your migration to fill in the attribute for the older instances of the model.

Let us consider an example to understand this better. We have a `Comment` model. Now we want to add a property `urlhash` so that we can give permalinks to each comment. In this case, we would have to write a custom function inside our migrations to fill in the `urlhash` attribute for comments that were created before this migration.

### Writing a Base class

To assist us in writing migration tests, we will create a base class. It will be used to handle all the intricacies required here.

Let us try to list some of the things that we need to keep in mind when writing this class. We will try to distribute these tasks to separate methods.

- Child classes(classes that inherit this) should be able to perform some setup before the migration(this helps us in setting up data for the test case).
- We need an instance of both the states of the model i.e. old and new both.
- The database should revert to the latest migration state irrespective of the fact that tests pass, fail or raise exceptions.
- We should know the migration states to go to.

Keeping all the above points, we shall proceed to write some code.

```python
from django.test import TransactionTestCase
from django.apps import apps
from django.db.migrations.executor import MigrationExecutor

class BaseMigrationTest(TransactionTestCase):
    """
    Test specific migrations
        Make sure that `self.migrate_from` and `self.migrate_to` are defined.
    """

    @property
    def app(self):
        return apps.get_containing_app_config(type(self).__module__).name

    migrate_from = None
    migrate_to = None

    def setUp(self):
        super().setUp()
        assert self.migrate_to and self.migrate_from, \
            f'TestCase {type(self).__name} must define migrate_to and migrate_from properties'

        self.migrate_from = [(self.app, self.migrate_from)]
        self.migrate_to = [(self.app, self.migrate_to)]
        self.executor = MigrationExecutor(connection)
        self.old_apps = self.executor.loader.project_state(self.migrate_from).apps

        # revert to the original migration
        self.executor.migrate(self.migrate_from)
        # ensure return to the latest migration, even if the test fails
        self.addCleanup(self.force_migrate)

        self.setUpBeforeMigration(self.old_apps)
        self.executor.loader.build_graph()
        self.executor.migrate(self.migrate_to)
        self.new_apps = self.executor.loader.project_state(self.migrate_to).apps

    def setUpBeforeMigration(self, apps):
        pass

    @property
    def new_model(self):
        return self.new_apps.get_model(self.app, 'MyModel')

    @property
    def old_model(self):
        return self.old_apps.get_model(self.app, 'MyModel')

    def force_migrate(self, migrate_to=None):
        self.executor.loader.build_graph()  # reload.
        if migrate_to is None:
            # get latest migration of current app
            migrate_to = [key for key in self.executor.loader.graph.leaf_nodes() if key[0] == self.app]
        self.executor.migrate(migrate_to)
```
### Writing the migration test

Now that we are done writing the base class, it is time to use this class to our migration test. We can use the setUpBeforeMigration method to perform some initialization in our migration test.

Continuing with the earlier mentioned example, we are testing below that the urlhash attribute is present on a comment that was created prior to this migration. The below code is written keeping this example in mind. You can transform this according to your use case.

```python
class CommentMigrationTest(BaseCommentMigrationTest):
    migrate_from = '0007_auto_20200620_1259'  # name of the migration module 
    migrate_to = '0009_auto_20200811_1945'

    def create_comment(self):
       return self.old_model.objects.create()

    def setUpBeforeMigration(self, apps):
        self.comment = self.create_comment()

    def test_urlhash_migrated(self):
        comment = self.new_model.objects.get(id=self.comment.id)
        # old comment has a urlhash attribute
        self.assertIs(hasattr(instance, 'urlhash'), True)
```

### Conclusion

Unit testing is an important cog in the development wheel. I hope this gives you a guide to write tests for your migration.

Till we meet in another post, keep hacking!