# IMARL Technologies Website

A single-page website for **IMARL Technologies**: colourful claymorphism, real 3D with Three.js, editorial typography and a frosted-glass navigation bar. No build step and no dependencies to install.

## Contents
- [Features](#features)
- [Project structure](#project-structure)
- [Run locally](#run-locally)
- [Edit before publishing](#edit-before-publishing)
- [Customise](#customise)
- [Deploy](#deploy)
- [Accessibility](#accessibility)
- [Browser support](#browser-support)
- [Testing checklist](#testing-checklist)
- [Troubleshooting](#troubleshooting)
- [Tech and credits](#tech-and-credits)

## Features
**Sections:** hero with an interactive 3D clay sculpture, About, Services (Web Development, Software Development, UI/UX Design, AI & Automation, IT Consultancy, Digital Transformation), Innovation Lab, Selected Projects, Process (Discover, Design, Develop, Deliver), Contact, Footer.

**Interactions:**
- Cursor-responsive 3D sculpture and floating objects (Three.js)
- Live 3D clay blob in the Innovation Lab: squish slider, colour swatches, poke button
- Magnetic buttons and tilting 3D cards
- Soft clay-style button compression
- Scroll-triggered reveals and smooth anchor navigation
- Glass navigation bar with a highlight that follows the cursor
- Contact form with validation

**Palette:** violet, coral, aqua, yellow, mint, warm ivory, charcoal. Light and dark modes follow the visitor's system setting.

## Project structure
```
imarl-website/
├── index.html   # the whole site: markup, styles and scripts
├── README.md
└── .gitignore
```

## Run locally
Open `index.html` in a browser, or serve the folder:

```bash
python3 -m http.server 8080
# then visit http://localhost:8080
```

An internet connection is needed for Three.js (cdnjs) and Google Fonts.

## Edit before publishing
The site contains placeholders so nothing about the company is invented. Replace them with real information:

| What | Where in `index.html` |
|---|---|
| Contact email (form sends here) | Search for `TO=` and replace `hello@your-domain.example` |
| Company story, team size, location | About section, yellow `[...]` text |
| Email and phone | Contact section and footer, yellow `[...]` text |
| Projects | Selected Projects: three cards labelled "Demonstration concept". Replace with real case studies and remove the label when you do. |

**How the contact form works:** it has no server. On submit it validates the fields, then opens the visitor's email app with the message ready to send to your address. For a hosted form (Formspree, Netlify Forms, your own API), replace the `mailto:` line at the end of the script.

## Customise
- **Colours and fonts:** CSS variables at the top of the `<style>` block (`--violet`, `--coral`, `--aqua`, `--yellow`, `--mint`, `--bg`, `--ink`).
- **Services:** the `S` array in the script.
- **Process steps and copy:** edit the HTML in the matching `<section>`.
- **3D scenes:** the two `scene(...)` calls (hero and lab). Colours are hex values passed to `mat(...)`.
- **Glass nav:** the `nav.glass` rules (blur strength is the `blur(18px)` value).

## Deploy
Any static host works. No build command; the publish directory is the repo root.
- **GitHub Pages:** Settings → Pages → Deploy from branch `main`, folder `/ (root)`.
- **Netlify, Vercel, Cloudflare Pages:** connect the repo or drag the folder in.

If you attach a custom domain, update the `<title>` and meta description in `<head>`.

## Accessibility
Skip-to-content link, visible keyboard focus, labelled form fields with live error and status messages, keyboard-operable menu (Escape closes it), and `prefers-reduced-motion` support (animations, cursor effect and 3D motion are switched off or frozen).

## Browser support
Current Chrome, Edge, Safari and Firefox on desktop and mobile. The 3D scenes need WebGL; if it is unavailable, the canvases are hidden and the rest of the site works. Where `backdrop-filter` is unsupported, the nav bar falls back to a solid background.

## Testing checklist
1. Open at 360px, 768px and 1440px wide, and in landscape on a phone.
2. Hero sculpture follows the cursor or finger.
3. Menu opens, closes, and links scroll to each section.
4. Cards tilt on hover (desktop) and buttons squash when pressed.
5. Lab blob reacts to the slider, swatches and Poke.
6. Submit the empty form to see errors; submit a valid one to open your email app.
7. Enable "reduce motion" in your system settings and confirm motion stops.

## Troubleshooting
- **Blank 3D areas:** check your connection (Three.js loads from cdnjs) and that hardware acceleration is on.
- **Fonts look different:** Google Fonts failed to load; the site falls back to system fonts.
- **Form does nothing:** your device has no default email app set up. Use a hosted form service instead.

## Tech and credits
HTML, CSS and vanilla JavaScript. [Three.js](https://threejs.org) r128. Fonts: Bricolage Grotesque and Fraunces via Google Fonts.

## Licence
© IMARL Technologies. All rights reserved. (Change this if you choose an open-source licence.)
