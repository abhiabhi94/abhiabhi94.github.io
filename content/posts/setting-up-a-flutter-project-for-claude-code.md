---
title: "Setting up a Flutter project for Claude Code"
date: 2026-11-05T23:00:00+05:30
tags: ["arrow", "flutter", "claude", "ci", "github-actions"]
categories: ["tech"]
showToc: true
TocOpen: false
draft: false
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

*This is the second post on building Arrow, an Android puzzle game. The first, [Learnings from building Arrow, a mobile game]({{< relref "learnings-from-building-arrow" >}}), covers why I built it and what I learned. Posts on releases, accessibility and the Play Store are coming soon.*

## How it got built

I'm a backend developer. I work with Python, Django and databases.

Claude Code wrote nearly all of Arrow's code. Arrow is built with Flutter, and I didn't write the Dart. My job was being the thought partner and the decision maker: what went in, what stayed out, and how the game should look and feel. Most of that turned out to be keeping things simple, because Claude doesn't necessarily come up with the clean, simple solution first.

That meant I had to judge every change without reading the code. Most of the setup in this post exists to make that possible, and it starts with the choice of Flutter.

## Why Flutter

Two reasons:

- **Clean, modern animations.** A puzzle game lives on how it feels: an arrow sliding out, a bump, a block turning. Flutter's animations look clean and modern.
- **One codebase for every device.** The same code runs on Android, iOS and the web, with no extra code for each platform.

The second one is what the rest of this setup leans on, because of where the code was being written.

## No emulator in the cloud

Claude Code worked on Arrow in the cloud, in [Claude Code on the web](https://code.claude.com/docs/en/claude-code-on-the-web). Each session starts in a fresh container, and that container has no Android emulator, because there's no hardware virtualisation to run one on.

That leaves two problems. Every session starts with nothing installed. And the agent can't see the game on a phone, so it can't check its own work. The first one is the easier fix.

## Every session starts ready

The Flutter version lives in one file, `.flutter-version`. Everything that installs Flutter reads it, so there's never a question of which version built what.

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


The script only runs in cloud sessions. It installs the pinned Flutter SDK if it isn't there, runs `flutter pub get` and `flutter gen-l10n`, makes sure Playwright and Chromium are ready for screenshots, and puts Flutter on the session's `PATH`. A session that already has Flutter skips straight past the download.

So every session can build the game. The next problem is letting it see the game.

## The agent sees the game through a browser

This is where the web build comes in. Since the same code runs in a browser, a browser can stand in for the phone.

`tool/screenshot.mjs` serves the web build, opens it in headless Chromium at a phone's size and drives it: home, settings, any level, a hint, a bump, a riddle, the desktop layout, keyboard shortcuts. It saves a screenshot of each screen, and the agent looks at those to check what it changed. If the app logs a Flutter error along the way, such as an overflowing layout, the script fails, so it doubles as a smoke test.

Getting there took a few workarounds, all handled in the script:

- **Flutter draws to a canvas**, so there's no HTML to click. The script turns on Flutter's accessibility tree and finds buttons by their accessible names instead.
- **The browser couldn't fetch from Google's servers** through the cloud session's network proxy, though command-line tools could. So everything the page needs comes from the local server: the web build bundles its rendering engine (`--no-web-resources-cdn`), the game's font is bundled, and the script serves the emoji fonts itself.
- **A debug web build unlocks every level**, so the script can open level 200 without playing the first 199.

Workarounds like these are easy to lose between sessions, and the next session shouldn't have to find them again.

## Writing down what each session learns

Claude Code reads `CLAUDE.md` at the start of every session. In Arrow it describes the rules of the game, every chapter, the architecture, the build and test commands, and every gotcha found along the way, each with its fix. It's now about 1,300 lines. There's also a skill, `.claude/skills/run/SKILL.md`, that says exactly how to build, screenshot and review.

When a session figures something out the hard way, it goes in there, and the next session starts with it.

That covers what the agent knows. What it still needs is something fixed to measure each change against.

## Give the agent something to check against

An LLM does its best work when it has a fixed reference to compare against: a test that must pass, a budget it must stay under, a screen it can look at. CI is where those references live, and it holds every change to them, every time.

Every pull request runs:

- **Analyze and test.** `flutter analyze` must be clean, infos included. Tests must pass with at least 92% coverage.
- **Web smoke and screenshots.** The same screenshot script, at phone and desktop sizes, keyboard included. The screenshots are saved with the run.
- **Performance.** This one came from a real miss. The game lagged on phones, a tap and then a wait before the arrow moved, while every test and screenshot passed, because nothing measured speed. Now `tool/perf.mjs` plays levels of the release web build with the CPU slowed down four times, about a mid-range phone's speed, and fails the change if a frame's work goes over budget. It posts the numbers on the pull request.
- **Debug APK.** An Android build anyone can install, linked from a comment on the pull request.
- **Accessibility.** Flutter's own accessibility checks over every screen, with screenshots on the pull request. More on this in a later post.

CI has to stay quick for this to work. At one point the test suite took about 12 minutes, mostly because one file generated every level several times over on a single core. Splitting the level checks into files that run side by side, and generating each level once per file, brought it down to about 2.

All of this tells me a change didn't break anything. Whether the change is any good is still my call, and for that I need to play it.

## Playing every change before it merges

This is the part I relied on most. Every pull request deploys its own web build to GitHub Pages, at `/arrow-game/pr-preview/pr-<number>/`, with every level unlocked, and keeps a comment on the pull request with the link. The preview is deleted when the pull request closes, and the main branch deploys the real game to the same site.

So reviewing a change meant opening a link and playing it. I didn't need to check out the branch, build anything or reinstall the app, and I could judge it without reading the Dart.

The same link is also the easiest way to ask people for feedback: they can play a change with nothing to install.

Once a change is in, it still has to reach the Play Store. That's the next post, coming soon.
