# CLAUDE.md

Personal blog built with Hugo and the PaperMod theme (`themes/PaperMod`, a
git submodule). Deployed to GitHub Pages by `.github/workflows/hugo.yaml` on
every push to `main`.

## Writing a post

- Posts live in `content/posts/<kebab-case-slug>.md`. Copy the front matter
  of the most recent post (`categories: ["tech"]`, `showToc: true`, a
  `description`, `cover.hidden: true`, and so on).
- Images go in `static/images/<topic>/` and are referenced as
  `/images/<topic>/<file>`.
- Show the user the draft before committing, and get their go-ahead first.

## Previewing a draft

Show the user the real rendered site, not screenshots. Build it, then
publish it as a private Claude Artifact they can click through.

1. Build the site (draft posts included):

   ```bash
   scripts/build-preview.sh <scratchpad>/blog-preview
   ```

   This uses the Hugo version pinned in `hugo.yaml`. If that version isn't
   on `PATH`, the script builds it from source with Go into
   `<out>/bin/hugo`, which takes about a minute. The script writes the site
   to `<out>/site` with relative `.html` links, and writes the list of files
   to publish to `<out>/files.json`.

2. Publish it to the existing preview artifact, so the user keeps one link:
   **https://claude.ai/artifact/NxhquzQRbsMqWEsrNNssUP** ("Abhyudai").
   - First, `Artifact` `action: "read"` on that URL, and `action: "list"`
     with `scope: "files"`. Republishing paths you haven't read or listed is
     refused.
   - Then publish with `url` set to that link,
     `file_path: <out>/site/index.html`, `root: <out>/site`, and `files`
     set to the contents of `<out>/files.json`. Add a short `label` naming
     the post.
   - If the artifact is gone or the user wants a separate one, publish
     without `url` and give it `icon: "blog"`.

3. Give the user the link, and say which post to open from the home page.

Rebuild and republish after every round of edits to the draft.
