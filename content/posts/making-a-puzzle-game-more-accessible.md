---
title: "Making a puzzle game more accessible"
date: 2026-11-02T10:01:00+05:30
tags: ["arrow", "accessibility", "flutter", "games"]
categories: ["tech"]
showToc: true
TocOpen: false
draft: true
weight: 1
hidemeta: false
comments: false
description: "What it took to make Arrow work with a screen reader, a keyboard, less motion, no clock and a Hindi phone, and how it stays that way."
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
cover:
    hidden: true
---

*This is part 4 of a series on building Arrow:*

1. [*Learnings from building Arrow, a mobile game*]({{< relref "learnings-from-building-arrow" >}})
2. [*Setting up a Flutter project for Claude Code*]({{< relref "setting-up-a-flutter-project-for-claude-code" >}})
3. [*Releasing to the Play Store with one command*]({{< relref "releasing-to-the-play-store-with-one-command" >}})
4. *Making a puzzle game more accessible (this post)*
5. [*The Play Store and individual developers*]({{< relref "the-play-store-and-individual-developers" >}})

Arrow is a visual puzzle. Bent arrows on a grid, and you tap one to slide it out the way it points. It's easy to assume a game like that can only be played by looking at it.

Here's what it took to make it work for more people.

## A board a screen reader can read

The board is drawn on a canvas, so to a screen reader it starts out as one blank picture. Nothing on it can be found or tapped.

The fix is to describe the board to the screen reader in its own terms. Every arrow still on the board becomes its own button, with a label that says what a sighted player would see:

> Arrow pointing right, 2 cells long, head at row 2, column 3. Clear path to the edge.

If the path isn't clear, the label says so, with how far ahead the blocking arrow is. Double-tapping an arrow plays it, like a tap would.

The rest of the screen talks too. The clock, the count of arrows out and the lives are read out. Each arrow that leaves and each life lost is announced as it happens. When a level ends, the result card announces itself and hides the board behind it, the same way it blocks a finger.

Small things matter here as well. Decorative emoji are hidden from the screen reader, so it doesn't read them out. Each level on the home trail is a single button whose label carries everything on it: the level, its stars and its best time.

## A keyboard instead of a finger

The game also runs in a browser, where people play it on a laptop. There, the arrow keys move a cursor from arrow to arrow, Enter plays the one under it, and a ring on the board shows where the cursor is. H gives a hint, plus and minus zoom, G toggles the grid and Space pauses.

## Settings for motion and time

![Arrow's Settings screen: Remove time limits and Extra time under Gameplay, and Reduce motion under Accessibility](/images/arrow/settings.png)

**Reduce motion.** A bump normally shakes the screen, and a cleared level throws confetti. With *Reduce motion* on, anything that moves without telling you something stops moving: no screen shake, no hops, no confetti. The arrows still slide out, because that motion is the game. The phone's own reduce-motion setting does the same.

**Time.** Every level has a clock, and the clock is brisk on purpose. Two switches change that. *Remove time limits* takes the clock away completely. *Extra time* keeps it but doubles it. Removing time limits is off by default, because turning it on for everyone would have changed the game for every existing player.

## Contrast, text size and touch targets

- Every pair of text and background colours meets WCAG AA contrast, 4.5:1, in both light and dark themes. Nothing is told by colour alone.
- Text follows the phone's font size. Nothing sits in a fixed-height box around text, so large text grows the box instead of getting cut off.
- Everything tappable is at least 44 pixels. The riddle's hint chip was 34, and it got bigger. On the biggest boards, where the cells themselves are small, zoom is the answer.

## A Hindi phone without a Hindi keyboard

Arrow is in English and Hindi, riddles included, and it follows the phone's language by default.

Riddles mean typing an answer. Many phones set to Hindi don't have a Devanagari keyboard installed, so every Hindi answer also accepts its romanized spellings, like "paani" and "jal" for पानी. The answer field says so.

## Keeping it that way

Accessibility that's only checked once quietly breaks. So it's checked on every pull request:

- Flutter's own accessibility guideline checks run over every screen and card in both themes: tap target sizes, labelled buttons and text contrast.
- Tests pin the behaviour described above, from the arrow labels to the keyboard cursor.
- An Accessibility workflow posts the results on the pull request, along with before-and-after screenshots with the changes boxed.

How the checks run is in [Setting up a Flutter project for Claude Code]({{< relref "setting-up-a-flutter-project-for-claude-code" >}}).
