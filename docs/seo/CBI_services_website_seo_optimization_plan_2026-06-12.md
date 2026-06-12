# Crain Bros Inc Services Website SEO Optimization Plan

Generated: 2026-06-12

## Purpose

This document plans the next Crain Bros Inc services website optimization phases for normal organic search, Google search, Google Maps/local discovery, and AI-search/entity discovery.

This is a planning document only. It does not approve or perform HTML edits.

## Current verified inventory baseline

- Total HTML pages inventoried: 210
- Homepage pages: 1
- Service category pages: 9
- Service area pages: 20
- Ads / ZIP landing pages: 180
- Pages missing canonical tags: 210
- Pages with JSON-LD structured data: 0
- Pages with FAQ mentions: 0
- Pages with missing image alt text: 0

## Non-negotiable guardrails

- Do not commit or push until Bebo explicitly approves.
- Do not change sitemap.xml, robots.txt, staticwebapp.config.json, redirects, page URLs, canonical URLs, metadata, or service text unless that exact phase is approved.
- Do not organize the homepage under a single ZIP code.
- Homepage / index.html is market-wide and represents Northeast Arkansas.
- Service category pages are service-specific and may mention Northeast Arkansas without being forced into one ZIP.
- Area pages are location/service-area credibility pages.
- Ads pages are service + ZIP/location landing pages.
- Keep the current staged homepage image-system work separate from future SEO edits until commit scope is deliberately reviewed.

## Page-family strategy

### 1. Homepage / market-wide page

- File: index.html
- Intent: Market-wide company and service overview for Crain Bros Inc across Northeast Arkansas.
- Current issue to review: homepage title is still Jonesboro-centered instead of clearly market-wide.
- Metadata direction: Crain Bros Inc | Restoration, Repairs & Construction | Northeast Arkansas
- Description direction: summarize restoration, repair, construction, inspection, consulting, plumbing, waterproofing, and remodeling services across Northeast Arkansas.
- Schema direction: LocalBusiness or construction/restoration business entity, organization identity, service area, major services, logo/image references, and website identity.
- FAQ direction: broad company/service FAQs that help users and AI systems understand who Crain Bros Inc serves, what services are offered, and how the company approaches inspection/documentation/restoration work.

### 2. Service category pages

- Folder: pages/
- Intent: Service-specific pages.
- Current issue to review: all service pages are Jonesboro-centered and have no images, no canonicals, no Open Graph tags, no Twitter card tags, no JSON-LD, and no FAQ content.
- Metadata direction: {Service} | Crain Bros Inc | Northeast Arkansas
- Description direction: service-specific summary across Northeast Arkansas.
- Schema direction: Service JSON-LD associated with Crain Bros Inc plus BreadcrumbList where navigation supports it.
- FAQ direction: service-specific FAQs for water damage, fire damage, construction, remodeling, plumbing, waterproofing, inspection, consulting, and restoration.

### 3. Service area pages

- Folder: areas/
- Intent: Location/service-area credibility pages.
- Current issue to review: no canonicals, no social metadata, no JSON-LD, no FAQ content, and no images.
- Metadata direction: Restoration & Construction Services in {City, State ZIP} | Crain Bros Inc
- Description direction: summarize services available in that city/ZIP and nearby Northeast Arkansas communities.
- Schema direction: WebPage or area-served supporting page; avoid pretending each page is a separate physical business location unless actual business location data supports it.

### 4. Ads / ZIP landing pages

- Folder: ads/
- Intent: Service + ZIP/location landing pages.
- Current issue to review: no canonicals, no social metadata, no JSON-LD, no FAQ content, and no images.
- Metadata direction: {Service} in {City, State ZIP} | Crain Bros Inc
- Description direction: concise service + location promise for the specific ZIP page.
- Schema direction: WebPage + Service where useful, with careful canonical strategy to avoid accidental duplicate/thin-page signals.

## Proposed implementation phases

### Phase 1 - Metadata plan, no edits

- Create a current-vs-proposed metadata plan for every page family.
- Include proposed title, meta description, page intent, page family, and whether the page should receive social metadata.
- Do not edit HTML in this phase.

### Phase 2 - Canonical plan, no edits

- Base domain components to use when approved: scheme=https; host=services.crainbrosinc.com
- Map every page path to its intended canonical URL.
- Decide whether ads pages should self-canonicalize, canonicalize to service pages, or remain indexable with unique content.
- Do not edit HTML in this phase.

### Phase 3 - Open Graph and Twitter/X card plan, no edits

- Define default og:title, og:description, og:type, og:url, and og:image rules by page family.
- Decide whether the homepage service-card images or a brand image should be used for social previews.
- Do not edit HTML in this phase.

### Phase 4 - Structured data / JSON-LD plan, no edits

- Define schema blocks by page family.
- Candidate schema families: LocalBusiness, HomeAndConstructionBusiness or related subtype, Service, WebPage, FAQPage, BreadcrumbList, ImageObject.
- Do not add schema blindly; use only verified business facts, service facts, URL facts, and page-family facts.
- Do not edit HTML in this phase.

### Phase 5 - FAQ content plan, no edits

- Draft homepage FAQs for company-wide and market-wide questions.
- Draft service-specific FAQs for each service category page.
- Decide whether area pages and ads pages need FAQs or should stay lean.
- FAQPage JSON-LD should only be added where matching visible FAQ content exists on the page.
- Do not edit HTML in this phase.

### Phase 6 - Image/content expansion plan, no edits

- Decide which unreferenced service-category image assets should be used.
- Add service-page images only after page layout and alt-text strategy are approved.
- Keep homepage images market-wide using northeast-arkansas naming.
- Keep service-category and ads-page images location/ZIP-specific where appropriate.

### Phase 7 - Sitemap / robots / static config audit, no edits until approved

- Compare actual public HTML pages to sitemap.xml.
- Verify robots.txt points to the correct sitemap.
- Review staticwebapp.config.json behavior only after page strategy is settled.
- Do not edit protected indexing/config files unless that exact phase is approved.

## Immediate next document to create

The next planning artifact should be a metadata and canonical proposal CSV/Markdown generated from the existing inventory. That plan should list current values and proposed values before any HTML edit script is written.
