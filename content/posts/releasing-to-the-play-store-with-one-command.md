---
title: "Releasing to the Play Store with one command"
date: 2026-11-02T10:02:00+05:30
tags: ["arrow", "android", "flutter", "github-actions", "play-store"]
categories: ["tech"]
showToc: true
TocOpen: false
draft: true
weight: 1
hidemeta: false
comments: false
description: "How Arrow goes from a version bump to a signed Play Store bundle: one script, one tag, and a workflow that refuses a release that doesn't add up."
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
cover:
    hidden: true
---

*This is part 3 of a series on building Arrow:*

1. [*Learnings from building Arrow, a mobile game*]({{< relref "learnings-from-building-arrow" >}})
2. [*Setting up a Flutter project for Claude Code*]({{< relref "setting-up-a-flutter-project-for-claude-code" >}})
3. *Releasing to the Play Store with one command (this post)*
4. [*Making a puzzle game more accessible*]({{< relref "making-a-puzzle-game-more-accessible" >}})
5. [*The Play Store and individual developers*]({{< relref "the-play-store-and-individual-developers" >}})

Arrow's first release was tagged on 13 September 2026. Version 2.2.0, build 17, was tagged on 29 October. That's a release every few days, which only works if cutting one takes no thought.

Here's how it's set up. The full step-by-step is in the repo's [`docs/release.md`](https://github.com/abhiabhi94/arrow-game/blob/main/docs/release.md).

## One-time setup

**An upload key.** The Play Store wants every bundle signed. With Play App Signing, Google holds the key that signs what users install, and you keep an *upload* key that proves a bundle came from you. It's one `keytool` command:

```bash
keytool -genkey -v -keystore ~/keys/arrow-upload.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**Secrets in a GitHub environment.** The keystore, base64-encoded, and its password go into the secrets of a GitHub environment called `release`, not the repository-wide list. An environment can also require an approval click before every release build, and can be limited to `main` and version tags. Nothing secret is committed. The workflow writes the keystore on the runner and deletes it when the job ends.

**The Play Console side.** Create the app and accept Play App Signing on the first upload. The privacy policy is a Markdown file in the repo, published as a page, and its link goes into the store listing. Store screenshots come from the same screenshot script the agent uses, which saves phone-sized PNGs that Play accepts as they are.

## Cutting a release

From an up-to-date `main`, one command:

```bash
tool/bump_version.sh
```

It bumps the version in `pubspec.yaml`, commits, tags the commit and prints the change so you can read it. Then it asks before pushing, once for the branch and once for the tag. The tag is what starts the release, so it gets its own question. Say no to either and it prints the commands to finish later, and the one-line undo.

A few options cover the rest: `minor`, `major` or an exact version instead of the default patch bump, `--dry-run` to see the plan without committing, and `-y --push` for a run with nobody there to answer.

The version code always goes up, whatever else changes, because the Play Store rejects any build whose code isn't strictly higher than every build uploaded before.

## What the release workflow does

Pushing a `v*` tag starts `.github/workflows/release.yml`. In order, it:

1. Checks that the signing secrets exist, with a clear error if one is missing.
2. Checks that the tag matches the version in `pubspec.yaml` exactly.
3. Analyzes and tests the code.
4. Opens the keystore and prints its fingerprint before compiling anything. A wrong password or a badly pasted secret fails in seconds instead of after the build.
5. Builds the signed `.aab` for the Play Store and an `.apk` of the same build for checking on a device.
6. Attaches everything to a GitHub release, along with the R8 mapping file and Dart symbols for reading crash reports.

The last step is mine. In Play Console: Release, then Testing or Production, then create a release, upload the `.aab`, add notes, review and roll out.

## The bug that the tag check prevents

Step 2 exists because of a real mistake. The first three releases, v1.0.0, v1.1.0 and v1.2.0, were cut by tagging alone, while the version name in `pubspec.yaml` stayed at 1.0.0 and only the build number moved. The build reads `pubspec.yaml`, so all three bundles went out as version 1.0.0, under tags that claimed three different versions. Nothing downstream noticed. A tag is just a label on a commit.

Now a tag is `v` plus the whole version, build number included, like `v2.2.0+17`. The workflow fails in its first seconds if the two disagree, and the bump script writes the version and tags the same commit, so they agree by construction.

If the check ever fires, the fix is a proper bump and a new tag. Moving the old tag onto another commit would give a release whose files don't match the source it names.

## The permission I didn't add

Play Console lists three permissions for Arrow. The app only asks for two: vibration, for haptics, and one that a Flutter dependency adds, which users never see.

The third, `CHECK_LICENSE`, isn't in the uploaded bundle at all. Google Play adds it when it processes the bundle. Checking the bundle with Google's own tools (`bundletool` and `aapt2`) shows only the two. It's a normal-level permission, so it never prompts anyone, and there's nothing to remove on our side. It's written down in the release guide.

## Worth copying

- One command to cut a release, which shows you the change and asks before pushing.
- Signing secrets in a protected environment, checked before the build starts.
- A workflow that refuses a tag and a version that disagree.
- Notes in the repo for every surprise, like the extra permission.

None of this makes the Play Store itself faster, though. That part has its own post: [The Play Store and individual developers]({{< relref "the-play-store-and-individual-developers" >}}).
