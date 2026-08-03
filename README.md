# aborghi.fr

Source for [aborghi.fr](https://aborghi.fr), my personal / freelance website.

The entire site is authored in [Typst](https://typst.app) and compiled to a
static HTML bundle. There is no runtime, no JavaScript framework, and no build
tooling beyond the Typst compiler itself.

## Architecture

Typst's HTML export and multi-file `bundle` output (both currently behind
feature flags) are used as a small, typed static-site generator. A single
compile pass reads one entry point and writes the whole site to `dist/`.

```
site.typ            Entry point. Declares every page and asset in the bundle.
template.typ        Shared page shell + component helpers.
case-studies/       One .typ file per case study, included from site.typ.
assets/             CSS, favicon, icons sprite, images, emitted verbatim.
build.sh            One-command build into dist/.
.github/workflows/  GitHub Pages deploy on push to main.
```

### How it fits together

- `site.typ` is the manifest. Each `#document(path)[...]` call defines an output
  HTML page; each `#asset(path, ...)` copies a static file into the bundle.
- `template.typ` exposes the building blocks used across pages: the `page()`
  shell (meta tags, Open Graph, canonical links), `case-study-page()`, and
  small components (`btn`, `card`, `metric`, `section-head`, `contact-actions`,
  the closing `case-cta`). Centralizing the shell keeps `<head>`, SEO metadata,
  and the contact call-to-action consistent on every page.
- Icons are referenced from a single shared SVG sprite (`assets/icons.svg`) via
  `<use>`, so the browser caches one file across the whole site. Icons inherit
  their button's color through `currentColor`.
- Pages pass a `base` prefix (`""` at the root, `"../"` one level down) so
  shared asset URLs resolve correctly regardless of page depth.

## Build

Requires Typst >= 0.15 (the `bundle` and `html` outputs are behind feature
flags).

```sh
./build.sh
```

This runs:

```sh
typst compile --features bundle,html --format bundle site.typ dist
```

and writes the complete site to `dist/`. The directory is rebuilt from scratch
on each run and is git-ignored.

To preview locally, serve the output with any static file server, for example:

```sh
./build.sh && python3 -m http.server -d dist 8000
```

## Deployment

Pushing to `main` triggers `.github/workflows/deploy.yml`, which installs
Typst, runs `build.sh`, and publishes `dist/` to GitHub Pages. The workflow can
also be run manually via `workflow_dispatch`.

## Adding a case study

1. Create `case-studies/<slug>.typ` with the article body, using the helpers
   from `template.typ` (`article-header`, `standfirst`, `divider`, ...).
2. In `site.typ`, add a `#document("case-studies/<slug>.html")[...]` block
   wrapping the content in `case-study-page(...)` and `#include` the new file.
3. Link to it from the landing page's case-studies section.

The closing contact call-to-action and footer are added automatically by
`case-study-page()`.
