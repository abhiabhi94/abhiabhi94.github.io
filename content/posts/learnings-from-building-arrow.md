---
title: "Learnings from building Arrow, a mobile game"
date: 2026-11-05T10:00:00+05:30
tags: ["arrow", "android", "flutter", "claude", "games"]
categories: ["tech"]
showToc: true
TocOpen: false
draft: false
weight: 1
hidemeta: false
comments: false
description: "Why I built Arrow, an Android puzzle game, how it stays clean while getting harder, and what working with Claude Code on it was like."
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
cover:
    hidden: true
---

*This is part 1 of a series on building Arrow:*

1. *Learnings from building Arrow, a mobile game (this post)*
2. *Setting up a Flutter project for Claude Code (coming soon)*
3. *Releasing to the Play Store with one command (coming soon)*
4. *Making a puzzle game more accessible (coming soon)*
5. *The Play Store and individual developers (coming soon)*

[Arrow](https://play.google.com/store/apps/details?id=app.curious.arrow) is a puzzle game for Android. You clear a board of arrows, one tap at a time. There are no ads, no in-app purchases, no accounts and no tracking. It works offline, and the code is open source.

In the first two weeks after it was published, it had about 1.4K installs (at the time of writing). I haven't run any ads or done any marketing for it.

## What I learned

- **Ads are a no-go.** A game can handle running out of lives without them. Arrow asks you a riddle instead.
- **Keep the screen clean, and find the difficulty somewhere else.** When the board ran out of room, the game got twists and then a 3D block, not more clutter.
- **Claude Code writes working code, not always simple code.** My job was to keep asking for the simpler version, so the game stays easy to change.
- **Judge a change by playing it.** Every change came with a playable build in the browser, so I never had to read the code to review it.
- **Write things down for the agent.** A `CLAUDE.md` file means each session starts with what the earlier ones figured out.
- **Launch early on the Play Store.** A new developer account needs 12 testers to keep the app installed for 14 days, and then approval took close to another 7 days. Expect about a month from the first test install to going live.
- **Build a web version too.** People can try a change from a link, without installing and uninstalling the app every time.

## Where the idea came from

I was watching a cousin play a similar puzzle game. The puzzle itself was good. The ads were not.

For me, ads will always be a no-go. They break your attention, they're annoying, and they're everywhere. In a puzzle game they're worse, because the whole point is getting into a rhythm, and an ad breaks it.

I wanted the same kind of puzzle without that. So I decided to build it.

## The game in one rule

Bent arrows sit on a grid. Tap one and it slides out the way its head points. If another arrow is in the way, it bumps back and you lose a life. Clear every arrow to finish the level.

That's the whole game, and I wanted the screen to feel that simple too. The arrows are thin dark lines, like a puzzle printed on paper, and colour on the board is saved for things that matter, like a hint or a bump. Above the board are the clock, your lives and a count of arrows out. Below it are four buttons. That's it.

## Clean, but still hard

Keeping the screen clean is easy when the puzzle is easy. The real question was how to keep the game challenging for a hundred levels and more without filling the screen with stuff.

The first answer was the obvious one: more arrows on bigger boards. That works for a while. But a phone screen doesn't grow. By level 100 there are 150 arrows on one board, and tapping exactly the arrow you meant gets tricky. Make the board any denser and the hard part stops being the puzzle and becomes touching the right line.

So the next levels needed more complexity without more crowding.

Part of the answer was twists. The hundred flat levels come in five chapters of twenty, and each chapter adds one idea and keeps the ones before it: mirrors that turn an arrow's path, padlocked arrows that wait for their key, arrows hidden in fog until a neighbour leaves, and pairs of arrows that leave together. Each of these makes you think harder without adding a single arrow.

The bigger answer was the block.

![Level 100, a flat board with 150 arrows, next to level 140, the 3D block with 28 arrows on the face in front](/images/arrow/flat-vs-block.png)

*Left: level 100, the last flat level. Right: level 140, on the block. Both are screenshots from the web build.*

After level 100, the board becomes a cube. Each of its six faces is a board of its own, and you drag the block to turn it and play the face in front. An arrow leaves by its own face's edge, so the faces never get in each other's way, and every twist means the same thing on a face as it did flat.

The numbers are the point. Level 140 has 167 arrows, more than level 100. But they're spread over six faces, never more than thirty to a face, so each arrow is big enough to tap. The level is harder and the screen is calmer.

The block then made room for more. In the next fifty levels, each face is packed so that only one arrow can go at a time. After that, the cube becomes a box, mostly taller than it is wide like a phone, with bigger faces in three sizes. The game is now 250 levels long, and the screen still has the same four buttons.

There's also a daily board, a fresh deal every day that keeps a streak, and a switch in Settings to remove time limits. How the game works with a screen reader, a keyboard and less motion is a post of its own, coming soon in this series.

## Riddles instead of ads

A free game has to decide what happens when you run out of lives. Many show an ad, or ask you to pay.

In Arrow, you solve a riddle. Run out of lives and you can carry on from exactly where you were by answering one. Run out of hints and a riddle buys you another.

![The riddle card: "I follow you all day long and stretch out tall at sunset, but I vanish the moment the lights go out. What am I?"](/images/arrow/riddle.png)

The riddles are simple but a bit quirky, and each answer is one everyday word. There are 250 of them in each language, English and Hindi. Each one has its own hint that gives a clue and then the first letter, and the answer only has to be close: a plural or a typo still counts.

They still break the flow a little. But they make the game more interesting rather than interrupting it, and that was the trade I wanted.

## How it got built

I'm a backend developer. I work with Python, Django and databases. I had built one or two apps before Arrow, but I had never shipped a mobile app.

Claude Code wrote nearly all of the code. Arrow is built with Flutter, and I didn't write the Dart. My job was being the thought partner and the decision maker: what went in, what stayed out, and how the game should look and feel.

Most of that job turned out to be keeping things simple. Claude doesn't necessarily come up with the clean, simple solution first. It will happily build something complex that somehow works. Working isn't enough, though. A game I want to keep adding to has to stay easy to change, so a lot of my time went into asking whether there was a simpler way, and saying no to the parts we didn't need.

The block is a good example. Its first version squeezed the hundred flat levels into fifty and needed a migration to move everyone's progress onto the new layout. The version that shipped leaves levels 1 to 100 exactly as they were and adds the block after them, so nothing needed migrating. Under the hood, a cube is the same kind of board as a flat level, just six faces laid side by side, which meant saved games and hints needed no changes for it.

The other half was making sure I could judge the work without reading the code. Every change came with a playable build I could open in the browser, and the agent checked its own work with screenshots. How that's set up, and how to repeat it, is the next post in this series.

The first commit went in on 13 September 2026. Version 2.2, with 250 levels, was tagged on 29 October.

## Links

- Play Store: [Arrow on Google Play](https://play.google.com/store/apps/details?id=app.curious.arrow)
- Play in the browser: [abhiabhi94.github.io/arrow-game](https://abhiabhi94.github.io/arrow-game/)
- Source: [github.com/abhiabhi94/arrow-game](https://github.com/abhiabhi94/arrow-game)
