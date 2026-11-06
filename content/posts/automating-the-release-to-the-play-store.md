---
title: "Automating the release to the Play Store"
date: 2026-11-06T10:00:00+05:30
tags: ["arrow", "android", "flutter", "github-actions", "play-store"]
categories: ["tech"]
showToc: true
TocOpen: false
draft: false
weight: 1
hidemeta: false
comments: false
description: "How Arrow goes from a version bump to a signed Play Store bundle, and the release mistake that shaped it."
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
cover:
    hidden: true
---

*This is the fourth post on building Arrow, an Android puzzle game. The first three are [Learnings from building Arrow, a mobile game]({{< relref "learnings-from-building-arrow" >}}), [Setting up a Flutter project for Claude Code]({{< relref "setting-up-a-flutter-project-for-claude-code" >}}) and [Making a puzzle game more accessible]({{< relref "making-a-puzzle-game-more-accessible" >}}).*

## Releasing often

Arrow's first release was tagged on 13 September 2026. Build 20, version 2.2.3, was tagged on 2 November. That's a release every few days.

Done by hand, every one of those is a chance to get something wrong. Arrow got something wrong early, and it shaped how releases work now.

## The mistake

The first three releases were cut by putting a version tag on a commit. But the version inside the app, the one the build actually uses, was never changed. Only the build number moved.

So three releases tagged 1.0.0, 1.1.0 and 1.2.0 all reached the Play Store as version 1.0.0. Nothing noticed, because a tag is just a label. It doesn't change what gets built.

The lesson was simple: a version should have one source of truth, and anything that claims a version has to agree with it, or the release stops.

## Setting the version

So the version is never typed in two places. One step updates the app's version, commits it, and tags that same commit, so the tag and the version always come from the same place. The build number goes up every time, because the Play Store rejects any build whose number isn't higher than every one before it.

That step shows the change and asks before pushing anything, and it asks separately for the tag, because the tag is what starts a release. Nothing reaches GitHub until I say yes.

## Signing, set up once

Every bundle on the Play Store has to be signed. With Play App Signing, Google keeps the key that signs what players install. I keep a separate *upload* key, which only proves that a bundle came from me. If it's ever lost, it can be reset through Play Console support, though that's slow.

The upload key lives in GitHub as a secret, in a protected environment that only release builds can use. It's never committed. Each build writes it out, uses it, and deletes it.

## What happens after the tag

Pushing a version tag starts the release workflow on GitHub Actions. It checks the cheap things first, like the tag matching the app's version and the upload key working, so a mistake fails in seconds rather than after a long build. Then it builds the signed bundle and attaches it to a GitHub release.

## The last step, and the release notes

The workflow stops at a signed bundle. Uploading it to the Play Console and rolling it out is still done by hand.

The release notes are written by Claude, in English and Hindi, following a short guide in the repo.

## What's automated, and what isn't

Everything from setting the version to the signed bundle runs the same way every time, and the mistake that slipped through early can't happen again without the release stopping. What's still manual is uploading the bundle to the Play Store. I'm not very familiar with the Play Console yet, so I've kept that step by hand for now. Automating it is something for the future.

More about the release code can be read in the [release guide](https://github.com/abhiabhi94/arrow-game/blob/main/docs/release.md).
