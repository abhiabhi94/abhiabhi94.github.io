---
title: "The Play Store and individual developers"
date: 2026-11-02T10:00:00+05:30
tags: ["arrow", "android", "play-store"]
categories: ["tech"]
showToc: true
TocOpen: false
draft: true
weight: 1
hidemeta: false
comments: false
description: "A new personal developer account can't publish straight away. What the closed-testing rule asks of an individual developer, how long it all took for Arrow, and how to plan around it."
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
cover:
    hidden: true
---

*This is part 5 of a series on building Arrow:*

1. [*Learnings from building Arrow, a mobile game*]({{< relref "learnings-from-building-arrow" >}})
2. [*Setting up a Flutter project for Claude Code*]({{< relref "setting-up-a-flutter-project-for-claude-code" >}})
3. [*Releasing to the Play Store with one command*]({{< relref "releasing-to-the-play-store-with-one-command" >}})
4. [*Making a puzzle game more accessible*]({{< relref "making-a-puzzle-game-more-accessible" >}})
5. *The Play Store and individual developers (this post)*

This is the part of shipping Arrow that had nothing to do with code.

## A new account can't publish straight away

If you sign up as an individual developer, your first app can't go straight to a public release. First it has to go through a closed test:

- **12 testers** have to install the app.
- They have to **keep it installed for 14 days**.

Only after that does Google ask a set of questions about the test, and let you apply for a public release.

For one person building something on the side, that means finding 12 people who'll install an unfinished app and leave it on their phones for two weeks.

## Then the review

Approval for the public release took close to another 7 days.

## About a month, end to end

Put together, expect about a month from the first test install to the app going live.

## How to plan around it

**Launch early.** The 14 days need testers with the app installed, not a finished app. Get a rough first version into a closed test as soon as it runs, and keep building while the clock runs.

**Build a web version too.** During testing, every change means asking testers to update, or uninstall and reinstall, the app. That gets old quickly, for them and for you. Arrow also runs in the browser, so I could check a change myself and send people a link for feedback, without anyone touching their phone's app list. How that's set up is in [part 2]({{< relref "setting-up-a-flutter-project-for-claude-code" >}}).

**Have the release pipeline ready before the test starts.** Every update during the closed test is a new build to sign and upload. If cutting a release is one command, that part costs nothing. [Part 3]({{< relref "releasing-to-the-play-store-with-one-command" >}}) covers how.
