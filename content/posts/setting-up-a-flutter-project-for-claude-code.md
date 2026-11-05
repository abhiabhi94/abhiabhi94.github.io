---
title: "Setting up a Flutter project for Claude Code"
date: 2026-11-02T10:03:00+05:30
tags: ["arrow", "flutter", "claude", "ci", "github-actions"]
categories: ["tech"]
showToc: true
TocOpen: false
draft: true
weight: 1
hidemeta: false
comments: false
description: "The repeatable parts of Arrow's setup: a pinned toolchain, a session hook, the web build standing in for an emulator, CI gates and a playable preview for every pull request."
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
cover:
    hidden: true
---

*This is part 2 of a series on building Arrow:*

1. [*Learnings from building Arrow, a mobile game*]({{< relref "learnings-from-building-arrow" >}})
2. *Setting up a Flutter project for Claude Code (this post)*
3. [*Releasing to the Play Store with one command*]({{< relref "releasing-to-the-play-store-with-one-command" >}})
4. [*Making a puzzle game more accessible*]({{< relref "making-a-puzzle-game-more-accessible" >}})
5. [*The Play Store and individual developers*]({{< relref "the-play-store-and-individual-developers" >}})

## How it got built

I'm a backend developer. I work with Python, Django and databases. I had built one or two apps before Arrow, but I had never shipped a mobile app.

Claude Code wrote nearly all of the code. Arrow is built with Flutter, and I didn't write the Dart. My job was being the thought partner and the decision maker: what went in, what stayed out, and how the game should look and feel.

Most of that job turned out to be keeping things simple. Claude doesn't necessarily come up with the clean, simple solution first. It will happily build something complex that somehow works. A game I want to keep adding to has to stay easy to change, so a lot of my time went into asking whether there was a simpler way, and saying no to the parts we didn't need.

The block is a good example. Its first version squeezed the hundred flat levels into fifty and needed a migration to move everyone's progress onto the new layout. The version that shipped leaves levels 1 to 100 exactly as they were and adds the block after them, so nothing needed migrating. Under the hood, a cube is the same kind of board as a flat level, just six faces laid side by side, which meant saved games and hints needed no changes for it.

For that to work, I had to be able to judge each change without reading the code. The rest of this post is the setup that made that possible.

## No emulator in the cloud

Most of Arrow was written by Claude Code running in the cloud, in [Claude Code on the web](https://code.claude.com/docs/en/claude-code-on-the-web). Each session starts in a fresh container. That container has no Android emulator, because there's no hardware virtualisation to run one on.

So the setup had two jobs. Every session had to be able to build and test the app from scratch. And every change had to be checkable, by the agent and by me, without a phone emulator in the loop.

Everything below is in the [arrow-game repo](https://github.com/abhiabhi94/arrow-game), and none of it is specific to Arrow.

## Pin the toolchain in one place

The Flutter version lives in a single file, `.flutter-version`. The session hook reads it, and so does every CI job. There's never a question of which Flutter built what.

## A hook that sets up every session

Claude Code can run a script when a session starts. The repo registers one in `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh"
          }
        ]
      }
    ]
  }
}
```

The script only runs in cloud sessions. It installs the pinned Flutter SDK if it isn't there, runs `flutter pub get` and `flutter gen-l10n`, makes sure Playwright and Chromium are available for screenshots, and puts Flutter on the session's `PATH`. It's safe to run twice, so a session that already has Flutter skips straight past the download.

## The web build stands in for the emulator

Flutter builds for the web as well as Android, so the game also runs in a browser. That's what the agent checks its work against.

`tool/screenshot.mjs` serves the web build, opens it in headless Chromium at a phone's size, and drives it: home, settings, any level, a hint, a bump, a riddle, the desktop layout, keyboard shortcuts. It saves a PNG of each screen, and the agent reads those images to check what it changed.

The same script is also a smoke test. If the app logs a Flutter error while it's being driven, such as an overflowing layout, the script exits with an error.

A few things it has to work around, all handled in the script:

- **Flutter draws to a canvas**, so there's no HTML for a script to click. The script turns on Flutter's accessibility tree and finds buttons by their accessible names instead.
- **The browser couldn't fetch from Google's servers** through the cloud session's network proxy, though command-line tools could. So everything the page needs comes from the local server: the web build bundles its rendering engine (`--no-web-resources-cdn`), the game's font is bundled, and the script serves the emoji fonts itself.
- **A debug web build unlocks every level**, so the script can open level 200 without playing the first 199.

There's also a skill, `.claude/skills/run/SKILL.md`, that tells Claude how to build, screenshot and review, so a new session doesn't have to work it out again.

## `CLAUDE.md` as the project's memory

Claude Code reads `CLAUDE.md` at the start of every session. In Arrow it describes the rules of the game, every chapter, the architecture, the build and test commands, and the gotchas found along the way, each with its fix. It's now about 1,300 lines.

When a session figures something out the hard way, it goes in there. The next session starts with it, instead of finding it again.

## CI that checks what a person would check

Every pull request runs these checks:

- **Analyze and test.** `flutter analyze` must be clean, infos included. Tests must pass with at least 92% coverage.
- **Web smoke and screenshots.** The screenshot script runs at phone and desktop sizes, keyboard included, and the screenshots are uploaded with the run.
- **Performance.** This one came from a real miss. The game lagged on phones, a tap and then a wait before the arrow moved, while every test and screenshot passed, because nothing measured speed. Now `tool/perf.mjs` plays levels of the release web build with the CPU slowed down four times, about a mid-range phone's speed, and fails the change if a frame's work goes over budget. It posts the numbers on the pull request.
- **Debug APK.** An Android build anyone can install, linked from a comment on the pull request.
- **Accessibility.** Flutter's own accessibility checks run over every screen, and screenshots go up on the pull request. More on this in [part 4]({{< relref "making-a-puzzle-game-more-accessible" >}}).

Speed matters for CI too. At one point the test suite took about 12 minutes, mostly because one file generated every level several times over on a single core. Splitting the level checks into files that run side by side, and generating each level once per file, brought it down to about 2.

## A playable preview for every pull request

This is the part I relied on most. Every pull request deploys its own web build to GitHub Pages, at `/arrow-game/pr-preview/pr-<number>/`, with every level unlocked, and keeps a comment on the pull request with the link. The preview is deleted when the pull request closes. The main branch deploys the real game to the same site.

So reviewing a change meant opening a link and playing it. I didn't need to check out the branch, build anything, or install the app again.

The web build has a second use: it's the easiest way to ask people for feedback. Send a link and they can play it, with nothing to install.

## If you want to copy this

The pieces, roughly in order:

1. Pin the SDK version in one file, and read it everywhere.
2. Add a session-start hook that installs the toolchain and dependencies.
3. Build for the web and write a script that drives it in a headless browser and fails on errors.
4. Start a `CLAUDE.md` early, and add to it every time something takes a while to figure out.
5. Put the same checks in CI, then add a preview deploy for every pull request.

The release side, from a version bump to a signed bundle, is in the next post: [Releasing to the Play Store with one command]({{< relref "releasing-to-the-play-store-with-one-command" >}}).
