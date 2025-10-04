# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Hybrid academic research repository containing:
- **Typst academic papers** on religious history and comparative theology
- **Next.js research website** for online paper dissemination
- **Research materials** (notes, outlines, bibliographies)

## Project Structure

```
horoscope/
├── sacred_madness.typ              # Main book manuscript
├── sacred_madness.bib              # Bibliography
├── abdal-continuity-paper/         # Standalone academic paper
│   ├── paper.typ                   # Main paper file
│   ├── references.bib              # Paper bibliography
│   └── sections/*.typ              # Modular paper sections
├── abdal-research-website/         # Next.js presentation site
│   ├── app/                        # Next.js 15 app router
│   └── content/*.md                # Markdown content from research
├── astrological_profile*.typ       # Additional research documents
└── *_notes.md, *_outline.md        # Research planning materials
```

## Commands

### Typst Paper Compilation

```bash
# Compile main book manuscript
typst compile sacred_madness.typ

# Compile academic paper
cd abdal-continuity-paper
typst compile paper.typ

# Watch mode (auto-recompile on changes)
typst watch paper.typ
```

Typst version: 0.13.1

### Next.js Website

All commands run from `abdal-research-website/`:

```bash
# Development server (Turbopack enabled)
npm run dev

# Production build
npm run build

# Start production server
npm start

# Lint
npm run lint
```

Dev server: http://localhost:3000

## Architecture

### Typst Papers

- **Modular structure**: Papers split into sections/ directory (introduction, literature, methodology, etc.)
- **Citations**: Chicago-style via .bib files, referenced with `#cite` in Typst
- **Custom functions**: Callout boxes, clinical warnings, reflection prompts defined in main .typ files
- **Styling**: Custom heading numbering, page breaks, typography settings
- **Include pattern**: Main .typ file uses `#include "sections/filename.typ"`

### Next.js Website

- **Framework**: Next.js 15 with App Router, React 19, Turbopack
- **Content**: Server-side reads markdown from `content/` directory
- **Rendering**: ReactMarkdown with @tailwindcss/typography for prose styling
- **Structure**:
  - Homepage (app/page.tsx): Abstract + navigation
  - Section pages (app/[section]/page.tsx): Full section content
  - Static assets: PDFs served from public/

### Content Flow

Research → Typst sections → PDF → Website markdown

When updating research:
1. Edit .typ files in sections/
2. Compile to PDF with `typst compile`
3. Sync relevant content to website content/*.md if website needs updating

## Research Context

Primary focus areas:
- **Sacred Madness book**: Comparative study of holy foolishness in Orthodox Christianity and Sufi Islam
- **Abdal continuity paper**: Byzantine saloi → Ottoman Abdalan-i Rum religious practice continuity in Anatolia
- Geographic focus: Anatolia, 6th-16th centuries
- Themes: Religious continuity across confessional boundaries, practice vs theology, hagiographical analysis

## Development Notes

- Typst is NOT LaTeX - syntax and commands differ
- Bibliography management via .bib files but Typst citation syntax
- Website content manually synced from paper sections (not automated)
- Paper sections are standalone .typ files included in main paper.typ
- use llm -m gpt-5-nano and tavily liberally they are free
