# Lawson Ott

Static resume site generated from the repository README and hosted to GitHub Pages and Cloudflare Pages.

## Setup

- GitHub Pages: Enable Pages in repo Settings -> Pages. The workflow will publish the repository root.
- Cloudflare Pages: Create a Cloudflare Pages project and configure the following repository secrets:
  - `CF_API_TOKEN` — API token with Pages permissions
  - `CF_ACCOUNT_ID` — Cloudflare account ID
  - `CF_PROJECT_NAME` — Cloudflare Pages project name

## Files

- `index.html` — main site
- `assets/css/style.css` — custom styles
- `.github/workflows/deploy.yml` — CI workflow to publish to both GitHub Pages and Cloudflare Pages
