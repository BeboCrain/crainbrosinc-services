# Crain Bros Inc Website Image System

## Build order

1. Main services page first: index.html
2. Service category pages next: pages\*.html
3. Ads / ZIP landing pages last: ads\*.html

## Main services page image folders - market-wide

Target page:

index.html

The main services page is market-wide. It must not be organized under one ZIP code.

Drop one representative photo per service here:

images\_incoming\home-page\service-cards\{service-slug}\service-card

Examples:

images\_incoming\home-page\service-cards\water-damage-restoration\service-card
images\_incoming\home-page\service-cards\fire-damage-restoration\service-card
images\_incoming\home-page\service-cards\construction\service-card
images\_incoming\home-page\service-cards\remodeling\service-card
images\_incoming\home-page\service-cards\plumbing\service-card
images\_incoming\home-page\service-cards\waterproofing\service-card
images\_incoming\home-page\service-cards\building-inspection\service-card
images\_incoming\home-page\service-cards\building-consultant\service-card
images\_incoming\home-page\service-cards\building-restoration\service-card

Final homepage images go here:

images\page-assets\home-page\service-cards\{service-slug}

Final homepage filename pattern:

{service-slug}-northeast-arkansas-crain-bros-inc-service-card-01.jpg

## Service category page image folders - ZIP/location supporting

Target pages:

pages\water-damage.html
pages\fire-damage.html
pages\construction.html
pages\remodeling.html
pages\plumbing.html
pages\waterproofing.html
pages\building-inspector.html
pages\building-consultant.html
pages\building-restoration.html

Drop selected photos here:

images\_incoming\service-category-pages\{service-slug}\{city-state-zip}\{role}

Final images go here:

images\page-assets\service-category-pages\{service-slug}\{city-state-zip}

Final filename pattern:

{service-slug}-{city-state-zip}-crain-bros-inc-{role}-01.jpg

## Ads / ZIP landing page image folders - ZIP-specific

Target pages:

ads\{city-state-zip}-{service}-ad.html

Drop selected photos here:

images\_incoming\ads-pages\{city-state-zip}\{service-slug}\{role}

Final images go here:

images\page-assets\ads-pages\{city-state-zip}\{service-slug}

Final filename pattern:

{service-slug}-{city-state-zip}-crain-bros-inc-{role}-01.jpg

## Live-site rule

No commit and no push until raw files are verified, git diff --check passes, and Bebo explicitly approves.