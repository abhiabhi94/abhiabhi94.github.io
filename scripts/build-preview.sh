#!/usr/bin/env bash
# Build the whole site as a self-contained preview that the Claude Artifact
# tool can publish: every link relative and ending in .html, no feeds.
#
#   scripts/build-preview.sh [OUT_DIR]     # default: /tmp/blog-preview
#
# Writes the site to OUT_DIR/site and the list of files to publish next to
# index.html to OUT_DIR/files.json. Draft posts (draft: true) are included.
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
out="$(mkdir -p "${1:-/tmp/blog-preview}" && cd "${1:-/tmp/blog-preview}" && pwd)"
site="$out/site"

# Same Hugo version as the deploy workflow.
version="$(sed -n 's/^ *HUGO_VERSION: *//p' "$repo/.github/workflows/hugo.yaml")"

hugo_bin="$(command -v hugo || true)"
if [[ -z "$hugo_bin" ]] || ! "$hugo_bin" version | grep -q "v$version"; then
    hugo_bin="$out/bin/hugo"
    if [[ ! -x "$hugo_bin" ]]; then
        echo "Building Hugo v$version from source (needs Go, takes a few minutes)..." >&2
        GOBIN="$out/bin" CGO_ENABLED=0 go install "github.com/gohugoio/hugo@v$version"
    fi
fi

git -C "$repo" submodule update --init --depth 1 themes/PaperMod >/dev/null 2>&1

rm -rf "$site"
(cd "$repo" && HUGO_UGLYURLS=true HUGO_RELATIVEURLS=true HUGO_MINIFY_MINIFYOUTPUT=false \
    "$hugo_bin" --quiet --buildDrafts --destination "$site" --baseURL /)

# Feeds and robots.txt aren't needed in a preview.
find "$site" \( -name '*.xml' -o -name robots.txt \) -delete

python3 -I - "$site" "$out/files.json" <<'PY'
import json, pathlib, re, sys

site, files_json = pathlib.Path(sys.argv[1]), sys.argv[2]

# Hugo still writes section links as directories ("../tags/"); point them
# at the .html files uglyURLs produced.
def fix(match):
    attr, url = match.groups()
    if url.startswith(("http", "#", "mailto")) or not url.endswith("/"):
        return match.group(0)
    if re.fullmatch(r"\./|(\.\./)+", url):
        return f'{attr}="{url}index.html"'
    return f'{attr}="{url[:-1]}.html"'

# A republished artifact reloads on index.html. Remember the last page opened
# (in this browser only) and send index.html back to it, unless the reader
# just chose index.html themselves.
REMEMBER = """<script>(function(){try{
var root=new URL(%r,location.href),key='preview-last',page=%r;
function rel(u){return u.pathname.slice(root.pathname.length)}
document.addEventListener('click',function(e){var a=e.target.closest&&e.target.closest('a[href]');
if(a&&a.origin===location.origin&&a.pathname.indexOf(root.pathname)===0)localStorage.setItem(key,rel(a)||'index.html')});
var nav=performance.getEntriesByType&&performance.getEntriesByType('navigation')[0];
if(page==='index.html'&&!(nav&&nav.type==='back_forward')){var last=localStorage.getItem(key);
if(last&&last!=='index.html'){location.replace(new URL(last,root));return}}
localStorage.setItem(key,page)}catch(e){}})();</script>"""

for page in site.rglob("*.html"):
    text = re.sub(r'(href|src)="([^"]*)"', fix, page.read_text())
    # The artifact host may serve files from another origin, where these make
    # the browser drop the stylesheet and fall back to its default font.
    text = re.sub(r'\s(?:integrity="[^"]*"|crossorigin="[^"]*")', "", text)
    path = page.relative_to(site)
    script = REMEMBER % ("../" * (len(path.parts) - 1) or "./", str(path))
    text = text.replace("<head>", "<head>" + script, 1)
    page.write_text(text)

files = sorted(
    str(p.relative_to(site)) for p in site.rglob("*")
    if p.is_file() and str(p.relative_to(site)) != "index.html"
)
json.dump([{"path": f} for f in files], open(files_json, "w"), indent=1)
PY

echo "Site:  $site"
echo "Files: $out/files.json ($(grep -c '"path"' "$out/files.json") files)"
