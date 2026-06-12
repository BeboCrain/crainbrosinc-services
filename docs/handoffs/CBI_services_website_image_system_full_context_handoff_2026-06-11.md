# Crain Bros Inc Services Website — Image System + Homepage Photo Update Handoff

**Document purpose:** This is a full-context handoff and repeatable playbook for continuing the Crain Bros Inc services website optimization work in a future Copilot/chat session. Upload this document into the next session so the assistant has the actual workflow, rules, folder paths, mistakes corrected, and next-step checklist.

**Created:** 2026-06-11
**Owner/User:** Bebo Crain
**Business:** Crain Bros Inc
**Website:** `services.crainbrosinc.com`
**Local working repo:** `P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services`
**Branch used during this work:** `local-water-damage-visual-test`
**Status at time of handoff:** Homepage service-card photos have been selected, imported into `page-assets`, and referenced locally in `index.html`; local preview worked; no commit and no push were performed in this conversation.

\---

## 0\. Critical Rules for the Next Session

These rules are mandatory. Do not violate them.

### 0.1 No live push without explicit approval

Do **not** commit or push live website changes until all of the following are true:

1. The repo state is understood.
2. Raw file content is verified directly.
3. `git diff --check` passes with zero issues.
4. Protected SEO/indexing files are verified untouched unless Bebo explicitly approves touching them.
5. Bebo explicitly approves the commit/push.

### 0.2 Do not change indexing/SEO structure during photo-only work

For photo-only updates, do **not** change:

* `sitemap.xml`
* `robots.txt`
* `staticwebapp.config.json`
* canonical tags
* page URLs
* redirects
* existing page filenames
* page titles
* meta descriptions
* existing service text or links unless Bebo explicitly approves

### 0.3 Main services page is market-wide, not ZIP-specific

The main services page is `index.html`. It represents the full market / overall service categories.

**Do not organize homepage service-card photos under a single ZIP code like `72404`.**

Correct homepage incoming pattern:

```text
images\\\_incoming\\home-page\\service-cards\\{service-slug}\\service-card
```

Correct homepage final pattern:

```text
images\\page-assets\\home-page\\service-cards\\{service-slug}\\{service-slug}-northeast-arkansas-crain-bros-inc-service-card-01.jpg
```

Correct homepage market identifier:

```text
northeast-arkansas
```

### 0.4 Service category pages and ads pages may remain location/ZIP-specific

Service category pages and ads/ZIP landing pages use service + city/ZIP folders.

Service category page incoming pattern:

```text
images\\\_incoming\\service-category-pages\\{service-slug}\\{city-state-zip}\\{role}
```

Service category page final pattern:

```text
images\\page-assets\\service-category-pages\\{service-slug}\\{city-state-zip}\\{service-slug}-{city-state-zip}-crain-bros-inc-{role}-01.jpg
```

Ads page incoming pattern:

```text
images\\\_incoming\\ads-pages\\{city-state-zip}\\{service-slug}\\{role}
```

Ads page final pattern:

```text
images\\page-assets\\ads-pages\\{city-state-zip}\\{service-slug}\\{service-slug}-{city-state-zip}-crain-bros-inc-{role}-01.jpg
```

### 0.5 Command sequencing rule

When giving Bebo shell commands, give **one clear executable block** and do not combine the command with a question in the same response. Explain first, command last.

### 0.6 Avoid bare URLs in commands/source

Avoid pasteable commands that contain bare public URLs when writing source files. Construct URLs from parts if needed to prevent rich-link artifacts.

\---

## 1\. High-Level Summary of What Was Done

The session built and corrected a structured image workflow for the Crain Bros Inc services website.

### 1.1 Created/updated the local image system

The image system now supports three content families:

1. **Homepage/main services page** — market-wide service cards for `index.html`.
2. **Service category pages** — pages like `pages/water-damage.html`, `pages/fire-damage.html`, etc.
3. **Ads / ZIP landing pages** — `ads\\\*.html` pages targeted by location and service.

### 1.2 Imported existing service-category water damage photos

Earlier water-damage service-category photos had been placed in an old folder family:

```text
images\\\_incoming\\service-pages\\water-damage-restoration\\...
```

That was corrected to:

```text
images\\\_incoming\\service-category-pages\\water-damage-restoration\\...
```

Then 12 water-damage service-category photos were imported into:

```text
images\\page-assets\\service-category-pages\\water-damage-restoration\\...
```

with SEO filenames such as:

```text
water-damage-restoration-jonesboro-ar-72401-crain-bros-inc-before-after-01.jpg
water-damage-restoration-jonesboro-ar-72401-crain-bros-inc-equipment-01.jpg
water-damage-restoration-jonesboro-ar-72401-crain-bros-inc-equipment-02.jpg
water-damage-restoration-jonesboro-ar-72401-crain-bros-inc-equipment-03.jpg
water-damage-restoration-jonesboro-ar-72402-crain-bros-inc-documentation-01.jpg
```

### 1.3 Corrected homepage/main page mistake

A major correction occurred: the homepage service cards were initially being discussed with `jonesboro-ar-72404` as a default anchor. Bebo corrected this. The final locked rule is:

> The homepage/main services page is market-wide and must not be organized under or named with a single ZIP code.

Correct homepage paths now use:

```text
images\\\_incoming\\home-page\\service-cards\\{service-slug}\\service-card
images\\page-assets\\home-page\\service-cards\\{service-slug}\\{service-slug}-northeast-arkansas-crain-bros-inc-service-card-01.jpg
```

### 1.4 Created a raw photo gallery picker concept

A raw-photo gallery picker was planned/created from:

```text
P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\photos\\01\_raw\\ProjectPhotos\_
```

The purpose of the gallery is visual selection only. It does not edit `index.html`. The improved gallery concept includes copy commands so Bebo can choose a photo visually and paste a generated `Copy-Item` command into PowerShell to stage that raw photo into the correct homepage service-card intake folder.

### 1.5 Bebo selected and staged 9 homepage service-card photos

Bebo copied one raw photo into each market-wide homepage service-card intake folder:

```text
water-damage-restoration
fire-damage-restoration
building-restoration
construction
remodeling
plumbing
waterproofing
building-inspection
building-consultant
```

### 1.6 Imported the 9 homepage photos into final page-assets

The importer moved and renamed the 9 staged homepage photos into:

```text
images\\page-assets\\home-page\\service-cards\\...
```

Final files created:

```text
images/page-assets/home-page/service-cards/building-consultant/building-consultant-northeast-arkansas-crain-bros-inc-service-card-01.jpg
images/page-assets/home-page/service-cards/building-inspection/building-inspection-northeast-arkansas-crain-bros-inc-service-card-01.jpg
images/page-assets/home-page/service-cards/building-restoration/building-restoration-northeast-arkansas-crain-bros-inc-service-card-01.jpg
images/page-assets/home-page/service-cards/construction/construction-northeast-arkansas-crain-bros-inc-service-card-01.jpg
images/page-assets/home-page/service-cards/fire-damage-restoration/fire-damage-restoration-northeast-arkansas-crain-bros-inc-service-card-01.jpg
images/page-assets/home-page/service-cards/plumbing/plumbing-northeast-arkansas-crain-bros-inc-service-card-01.jpg
images/page-assets/home-page/service-cards/remodeling/remodeling-northeast-arkansas-crain-bros-inc-service-card-01.jpg
images/page-assets/home-page/service-cards/water-damage-restoration/water-damage-restoration-northeast-arkansas-crain-bros-inc-service-card-01.jpg
images/page-assets/home-page/service-cards/waterproofing/waterproofing-northeast-arkansas-crain-bros-inc-service-card-01.jpg
```

### 1.7 Added homepage image references to `index.html`

After verifying the existing homepage tile structure, 9 `<img class="tile-photo">` tags were inserted into existing service tiles only.

No service text, links, titles, sitemap, robots, metadata, redirects, canonical URLs, or URLs were changed.

### 1.8 Added CSS rule to active stylesheet

`index.html` loads:

```html
<link rel="stylesheet" href="css/styles-v3.css">
```

So only `css/styles-v3.css` was updated with:

```css
.tile-photo{
  width: 100%;
  height: 170px;
  display: block;
  object-fit: cover;
  border-radius: 12px;
  border: 1px solid var(--border);
  background: rgba(255,255,255,.03);
  margin: 0 0 12px;
}
```

### 1.9 Local preview worked

Bebo reported the local homepage preview worked after these changes.

### 1.10 No commit / no push

No commit or push was done in this session.

\---

## 2\. Exact Local Paths

### 2.1 Repo path

```text
P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services
```

### 2.2 Raw source photo folder

```text
P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\photos\\01\_raw\\ProjectPhotos\_
```

### 2.3 Optimized source photo folder

```text
P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\photos\\03\_optimized
```

### 2.4 Homepage incoming folder root

```text
P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services\\images\\\_incoming\\home-page\\service-cards
```

### 2.5 Homepage final page-assets root

```text
P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services\\images\\page-assets\\home-page\\service-cards
```

### 2.6 Service category incoming root

```text
P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services\\images\\\_incoming\\service-category-pages
```

### 2.7 Service category final root

```text
P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services\\images\\page-assets\\service-category-pages
```

### 2.8 Ads incoming root

```text
P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services\\images\\\_incoming\\ads-pages
```

### 2.9 Ads final root

```text
P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services\\images\\page-assets\\ads-pages
```

### 2.10 Image importer

```text
P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services\\tools\\website-images\\Import-CbiWebsiteImages.ps1
```

### 2.11 Image manifest

```text
P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services\\images\\cbi-website-image-manifest.csv
```

### 2.12 README for image system

```text
P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services\\tools\\website-images\\README\_CBI\_WEBSITE\_IMAGE\_SYSTEM.md
```

\---

## 3\. Service Slugs

Use these exact service slugs unless Bebo explicitly changes them:

```text
water-damage-restoration
fire-damage-restoration
building-restoration
construction
remodeling
plumbing
waterproofing
building-inspection
building-consultant
```

Homepage service-card folder pattern:

```text
images\\\_incoming\\home-page\\service-cards\\{service-slug}\\service-card
```

\---

## 4\. Role Names for Service Category and Ads Pages

For `pages\\\*.html` and `ads\\\*.html`, use roles like:

```text
hero
process
documentation
before-after
equipment
team
proof
gallery
callout
```

For homepage/main page use only:

```text
service-card
```

\---

## 5\. Detailed Step-by-Step Workflow to Repeat Homepage Photo Selection

Use this when adding or replacing homepage service-card photos in a future session.

### Step 1 — Verify repo state

```powershell
$RepoPath = 'P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services'
Push-Location $RepoPath
git status -sb
git status --short
Pop-Location
```

### Step 2 — Open raw photo source and homepage intake root

```powershell
Start-Process explorer 'P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\photos\\01\_raw\\ProjectPhotos\_'
Start-Process explorer 'P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services\\images\\\_incoming\\home-page\\service-cards'
```

### Step 3 — Copy one chosen photo per homepage service

For example:

```powershell
Copy-Item -Path 'P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\photos\\01\_raw\\ProjectPhotos\_\\water-damage\\water-damage-ceiling-leak-002.jpg' -Destination 'P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services\\images\\\_incoming\\home-page\\service-cards\\water-damage-restoration\\service-card' -Force
```

Repeat for each service. Do not manually rename the files. The importer handles SEO names.

### Step 4 — Preview importer result before execute

```powershell
$RepoPath = 'P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services'
$ImportScriptPath = Join-Path $RepoPath 'tools\\website-images\\Import-CbiWebsiteImages.ps1'
Push-Location $RepoPath
powershell -NoProfile -ExecutionPolicy Bypass -File $ImportScriptPath
Pop-Location
```

Expected preview for homepage images:

```text
PREVIEW: ... -> images/page-assets/home-page/service-cards/{service-slug}/{service-slug}-northeast-arkansas-crain-bros-inc-service-card-01.jpg
```

### Step 5 — Execute importer after preview is correct

```powershell
$RepoPath = 'P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services'
$ImportScriptPath = Join-Path $RepoPath 'tools\\website-images\\Import-CbiWebsiteImages.ps1'
Push-Location $RepoPath
powershell -NoProfile -ExecutionPolicy Bypass -File $ImportScriptPath -Execute
Pop-Location
```

### Step 6 — Verify imported homepage assets

```powershell
$RepoPath = 'P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services'
$PageAssetsHomeRoot = Join-Path $RepoPath 'images\\page-assets\\home-page\\service-cards'
Get-ChildItem -Path $PageAssetsHomeRoot -File -Recurse | Sort-Object FullName | Select-Object FullName, Length | Format-List
```

### Step 7 — Add image references to `index.html` only if not already present

Current `index.html` service tiles now contain `class="tile-photo"` image tags. If replacing photos with same final filename, no HTML change may be needed. If a new sequence filename like `-02.jpg` is used, then `index.html` must be updated surgically.

Allowed HTML change:

```html
<img class="tile-photo" src="images/page-assets/home-page/service-cards/{service-slug}/{filename}.jpg" alt="..." loading="lazy">
```

Do not change any other homepage content unless Bebo explicitly approves.

\---

## 6\. Current Homepage HTML Changes

The homepage service section originally had text-only tiles:

```html
<article class="tile">
  <h3>Water Damage Restoration</h3>
  <p class="muted">Inspection, documentation, drying, repairs, and reconstruction following water damage events.</p>
  <a class="text-link" href="pages/water-damage.html">Learn more</a>
</article>
```

Now each tile has one image before the `<h3>`.

Example:

```html
<article class="tile">
  <img class="tile-photo" src="images/page-assets/home-page/service-cards/water-damage-restoration/water-damage-restoration-northeast-arkansas-crain-bros-inc-service-card-01.jpg" alt="Water damage restoration services by Crain Bros Inc in Northeast Arkansas" loading="lazy">
  <h3>Water Damage Restoration</h3>
  <p class="muted">Inspection, documentation, drying, repairs, and reconstruction following water damage events.</p>
  <a class="text-link" href="pages/water-damage.html">Learn more</a>
</article>
```

Current count verified:

```text
TilePhotoTagCount: 9
```

\---

## 7\. Current CSS Change

Active stylesheet confirmed by `index.html`:

```html
<link rel="stylesheet" href="css/styles-v3.css">
```

CSS block added:

```css
.tile-photo{
  width: 100%;
  height: 170px;
  display: block;
  object-fit: cover;
  border-radius: 12px;
  border: 1px solid var(--border);
  background: rgba(255,255,255,.03);
  margin: 0 0 12px;
}
```

\---

## 8\. Git / Line Ending / Diff Notes

The repo has:

```text
core.autocrlf=true
```

During the session, `git diff --check` flagged CRLF `^M` as trailing whitespace. To make checks pass for CRLF in this Windows repo, repo-local config was set:

```powershell
git config --local core.whitespace cr-at-eol
```

After setting this, `git diff --check` returned clean.

Important: Do not broadly rewrite files or line endings. Keep diffs narrow.

Final clean content diff for the homepage HTML/CSS was:

```text
css/styles-v3.css | 11 +++++++++++
index.html        |  9 +++++++++
2 files changed, 20 insertions(+)
```

Protected indexing files showed no diff:

```text
sitemap.xml
robots.txt
staticwebapp.config.json
```

\---

## 9\. Current Git Status Context

At the end of the work shown in the conversation, status included:

```text
 M css/styles-v3.css
 M index.html
?? .gitignore
?? images/
?? tools/
```

Tracked file changes:

```text
css/styles-v3.css
index.html
```

Untracked file families expected:

```text
.gitignore
images/
tools/
```

Expected untracked/created contents include:

* new `images/page-assets/...` image files
* local image manifest CSV
* image review folders
* image incoming folders, which should be ignored
* image importer under `tools/website-images/`
* image system README

Important: `\_incoming` and `\_review` should remain local-only and ignored by `.gitignore`.

`.gitignore` should contain:

```text
# Crain Bros website image local work folders
images/\_incoming/
images/\_review/
```

\---

## 10\. Local Preview

The local preview server command used:

```powershell
$RepoPath = 'P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services'
$Port = 8787

Push-Location $RepoPath
Start-Process powershell -ArgumentList @(
    '-NoExit',
    '-Command',
    "Set-Location '$RepoPath'; python -m http.server $Port"
)
Start-Sleep -Seconds 2
Start-Process ('http://localhost:' + $Port + '/index.html')
Pop-Location
```

Bebo reported this worked after the homepage image inserts.

This preview does not deploy, commit, push, or change live files. It only serves the local repo folder to the local browser.

\---

## 11\. Service Category Page Workflow for Future Work

After homepage work, use this pattern for service pages like:

```text
pages\\water-damage.html
pages\\fire-damage.html
pages\\construction.html
pages\\remodeling.html
pages\\plumbing.html
pages\\waterproofing.html
pages\\building-inspector.html
pages\\building-consultant.html
pages\\building-restoration.html
```

### 11.1 Copy selected photos into incoming service category folders

Pattern:

```text
images\\\_incoming\\service-category-pages\\{service-slug}\\{city-state-zip}\\{role}
```

Example:

```text
images\\\_incoming\\service-category-pages\\water-damage-restoration\\jonesboro-ar-72404\\hero
images\\\_incoming\\service-category-pages\\water-damage-restoration\\jonesboro-ar-72404\\process
images\\\_incoming\\service-category-pages\\water-damage-restoration\\jonesboro-ar-72404\\before-after
```

### 11.2 Preview importer

```powershell
$RepoPath = 'P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services'
$ImportScriptPath = Join-Path $RepoPath 'tools\\website-images\\Import-CbiWebsiteImages.ps1'
Push-Location $RepoPath
powershell -NoProfile -ExecutionPolicy Bypass -File $ImportScriptPath
Pop-Location
```

### 11.3 Execute importer after preview

```powershell
$RepoPath = 'P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services'
$ImportScriptPath = Join-Path $RepoPath 'tools\\website-images\\Import-CbiWebsiteImages.ps1'
Push-Location $RepoPath
powershell -NoProfile -ExecutionPolicy Bypass -File $ImportScriptPath -Execute
Pop-Location
```

### 11.4 Update only the relevant service page image references

Do not change service text, title, metadata, sitemap, robots, or page URL unless Bebo approves.

\---

## 12\. Ads / ZIP Page Workflow for Future Work

Ads pages are ZIP-specific.

Incoming pattern:

```text
images\\\_incoming\\ads-pages\\{city-state-zip}\\{service-slug}\\{role}
```

Final pattern:

```text
images\\page-assets\\ads-pages\\{city-state-zip}\\{service-slug}\\{service-slug}-{city-state-zip}-crain-bros-inc-{role}-01.jpg
```

Example:

```text
images\\\_incoming\\ads-pages\\jonesboro-ar-72404\\water-damage-restoration\\hero
images\\page-assets\\ads-pages\\jonesboro-ar-72404\\water-damage-restoration\\water-damage-restoration-jonesboro-ar-72404-crain-bros-inc-hero-01.jpg
```

Do not change ads page metadata/sitemap/URL structure unless Bebo explicitly approves that phase.

\---

## 13\. Important Mistakes Corrected During This Session

### 13.1 Wrong topic drift

The assistant accidentally answered an unrelated GFCI/electrical code question in the middle of the website optimization workflow. That was wrong. Future sessions must stay on the active task: Crain Bros Inc website image/SEO/content optimization.

### 13.2 Homepage ZIP mistake

The assistant kept carrying `jonesboro-ar-72404` into homepage image logic. Bebo corrected this. Homepage is market-wide. Use `northeast-arkansas`, not a ZIP.

### 13.3 Failed HTML insertion due to multiline structure

Initial image insertion script looked for:

```html
<article class="tile"><h3>Water Damage Restoration</h3>
```

Actual file used multiline structure:

```html
<article class="tile">
  <h3>Water Damage Restoration</h3>
```

Final fixed logic searched for the heading line and inserted image immediately after the preceding `<article class="tile">`.

### 13.4 Line-ending noise

A line-ending normalization attempt created noisy whole-file diffs. This was corrected by restoring CRLF and setting repo-local Git whitespace config:

```powershell
git config --local core.whitespace cr-at-eol
```

\---

## 14\. Things Still To Do Before Commit/Push

Before any commit/push, the next session should verify:

1. `git status -sb`
2. `git diff --stat`
3. `git diff --check`
4. `git diff --name-only -- sitemap.xml robots.txt staticwebapp.config.json`
5. `TilePhotoTagCount: 9`
6. local preview still renders correctly
7. image files are present under `images/page-assets/home-page/service-cards/...`
8. `\_incoming` and `\_review` are ignored and not staged
9. no protected indexing files changed
10. Bebo approves exact files to stage and commit

\---

## 15\. Future Non-Photo SEO / Metadata / Website Optimization Checklist

Bebo wants to add metadata and all other important website optimization items after the photo phase. This should be handled as a separate approved phase, not mixed into photo-only changes.

### 15.1 Metadata / on-page SEO items to review

For each major page, review and intentionally optimize:

* `<title>`
* `<meta name="description">`
* Open Graph tags:

  * `og:title`
  * `og:description`
  * `og:image`
  * `og:url`
  * `og:type`
* Twitter/X card tags if desired
* canonical URL
* heading structure (`h1`, `h2`, `h3`)
* image alt text
* internal links
* service/category consistency
* market-wide vs ZIP-specific wording
* NAP consistency where business name/address/phone appears
* service area language
* local business schema / structured data
* restoration/construction service schema where appropriate

### 15.2 Technical SEO items to review

Do not change automatically. Audit first:

* `sitemap.xml`
* `robots.txt`
* `staticwebapp.config.json`
* redirect rules
* 404 behavior
* canonical path consistency
* trailing slash behavior
* duplicate URL forms
* image paths
* broken links
* missing pages
* orphan pages
* Core Web Vitals / page weight
* image dimensions/compression
* lazy loading strategy
* cache headers, if configured

### 15.3 Content strategy items

Potential future work:

* Expand homepage intro with stronger market-wide service positioning.
* Add service summaries for each category.
* Improve individual service category page content.
* Add FAQ sections per service category.
* Add market/service area pages if already part of the site strategy.
* Add before/after galleries for service pages.
* Add inspection/documentation credibility content.
* Add restoration process sections.
* Add call-to-action sections.
* Add trust signals: locally owned/operated, since 1984, full-service restoration contractor, etc.

### 15.4 Indexing caution

Any changes to sitemap, robots, canonical tags, redirects, titles, metadata, or page URLs affect SEO/indexing and require explicit Bebo approval.

\---

## 16\. Suggested Next Session Opener

Use this opener in the next chat:

```text
We are continuing the Crain Bros Inc services website optimization build from the handoff document I uploaded. Read the handoff fully before giving commands. Current local repo is P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services on branch local-water-damage-visual-test. Do not guess. Do not push. Do not commit. Do not change sitemap, robots, staticwebapp.config.json, canonical URLs, metadata, page URLs, redirects, or service text unless I explicitly approve. The last completed phase added market-wide homepage service-card photos to index.html and css/styles-v3.css only. Homepage image filenames use northeast-arkansas, not a ZIP. Service category pages and ads pages remain ZIP/location-specific. First, verify git status, diff stat, diff check, protected indexing file diff, TilePhotoTagCount, and local preview before proceeding.
```

\---

## 17\. Verification Commands for Next Session

Start with:

```powershell
$RepoPath = 'P:\\projectRESTCON\_OS\\businesses\\crainbrosinc\\git\\crainbrosinc-services'
Push-Location $RepoPath

git status -sb
git status --short

git config --get core.autocrlf
git config --get core.whitespace

git diff --stat -- index.html css/styles-v3.css sitemap.xml robots.txt staticwebapp.config.json
git diff --check -- index.html css/styles-v3.css sitemap.xml robots.txt staticwebapp.config.json

git diff --name-only -- sitemap.xml robots.txt staticwebapp.config.json

$TilePhotoTags = Select-String -Path (Join-Path $RepoPath 'index.html') -Pattern 'class="tile-photo"' -SimpleMatch
Write-Host "TilePhotoTagCount: $($TilePhotoTags.Count)"

Get-ChildItem -Path (Join-Path $RepoPath 'images\\page-assets\\home-page\\service-cards') -File -Recurse |
    Sort-Object FullName |
    Select-Object FullName, Length |
    Format-List

Pop-Location
```

Expected:

```text
TilePhotoTagCount: 9
Protected indexing files: no diff
Diff check: clean
Tracked changed files: index.html and css/styles-v3.css
No commit/no push unless Bebo approves
```

\---

## 18\. Current Homepage Service-Card Final Images

```text
building-consultant-northeast-arkansas-crain-bros-inc-service-card-01.jpg
building-inspection-northeast-arkansas-crain-bros-inc-service-card-01.jpg
building-restoration-northeast-arkansas-crain-bros-inc-service-card-01.jpg
construction-northeast-arkansas-crain-bros-inc-service-card-01.jpg
fire-damage-restoration-northeast-arkansas-crain-bros-inc-service-card-01.jpg
plumbing-northeast-arkansas-crain-bros-inc-service-card-01.jpg
remodeling-northeast-arkansas-crain-bros-inc-service-card-01.jpg
water-damage-restoration-northeast-arkansas-crain-bros-inc-service-card-01.jpg
waterproofing-northeast-arkansas-crain-bros-inc-service-card-01.jpg
```

\---

## 19\. End State Summary

At the end of this handoff:

* The homepage now has 9 service-card images locally.
* Image assets are market-wide and use `northeast-arkansas` filenames.
* Service category and ads page folder systems exist and are ready for future photo work.
* `sitemap.xml`, `robots.txt`, and `staticwebapp.config.json` were not changed.
* No metadata/title/description/canonical/redirect/page URL changes were made.
* No commit was made.
* No push was made.
* Local preview worked.
* Next phase should either:

  1. verify and commit/push the photo-only change after Bebo approval, or
  2. start a separate metadata/SEO audit phase after freezing the photo-only diff.
