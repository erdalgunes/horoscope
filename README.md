# Sacred Madness: Holy Foolishness in Orthodox Christianity and Sufi Islam

[![License](https://img.shields.io/badge/License-All%20Rights%20Reserved-red.svg)](LICENSE)
[![Research Website](https://img.shields.io/badge/Website-Live-brightgreen)](https://github.com/erdalgunes/abdal-research-website)
[![Typst](https://img.shields.io/badge/Typst-0.13.1-blue)](https://typst.app)

> Academic research repository exploring divine intoxication, sacred madness, and holy foolishness across Orthodox Christian and Sufi Islamic traditions, with a focus on Anatolian religious continuity.

---

## 📚 Repository Overview

This repository contains:
- **Typst Academic Papers**: Main book manuscript and standalone research papers
- **Research Materials**: Notes, outlines, and bibliographies
- **Next.js Research Website**: Interactive documentation and dissemination platform (as git submodule)

### Author

**Erdal Güneş**
Alevi Kalenderi Abdal tradition | Lived experience with Bipolar II | Comparative religious studies scholar

---

## 🗂️ Repository Structure

```
horoscope/
├── sacred_madness.typ              # Main book manuscript (1,336 lines)
├── sacred_madness.bib              # Bibliography (716 entries, 74+ sources)
├── abdal-continuity-paper/         # Standalone academic paper
│   ├── paper.typ                   # From Saloi to Abdal: Religious Continuity
│   ├── references.bib              # Paper-specific bibliography
│   ├── sections/                   # Modular paper sections
│   │   ├── abstract.typ
│   │   ├── introduction.typ
│   │   ├── literature.typ
│   │   └── ...                     # methodology, analysis, conclusion
│   └── paper.pdf                   # Compiled PDF (82KB)
├── abdal-research-website/         # Next.js website (git submodule)
│   └── → https://github.com/erdalgunes/abdal-research-website
├── sacred_madness_notes.md         # Research notes (35KB)
├── sacred_madness_outline.md       # Book outline
├── CLAUDE.md                       # Project documentation (commands, architecture)
├── COST_OPTIMIZATION_ANALYSIS.md   # API cost analysis ($325 → $87/month)
└── GIT_SUBMODULE_CONVERSION.md     # Submodule workflow guide
```

---

## 🚀 Quick Start

### Clone Repository

**Full clone (papers + website)**:
```bash
git clone --recurse-submodules https://github.com/erdalgunes/horoscope.git
cd horoscope
```

**Papers only** (skip website):
```bash
git clone https://github.com/erdalgunes/horoscope.git
cd horoscope
```

**Add website later**:
```bash
git submodule update --init --recursive
```

### Compile Papers

Requires [Typst](https://github.com/typst/typst) 0.13.1+

```bash
# Main book
typst compile sacred_madness.typ

# Abdal continuity paper
cd abdal-continuity-paper
typst compile paper.typ

# Watch mode (auto-recompile on changes)
typst watch paper.typ
```

### Run Research Website

```bash
cd abdal-research-website
npm install
npm run dev
```

Visit [http://localhost:3000](http://localhost:3000)

---

## 📖 Research Focus

### Sacred Madness Book

Comprehensive comparative study of holy foolishness exploring:
- **Byzantine Saloi**: 6th-11th century holy fools (Symeon, Andrew)
- **Russian Yurodivye**: Basil the Blessed, St. Xenia, Pelagia
- **Sufi Majdhub/Mast**: Divinely intoxicated mystics
- **Abdalan-i Rum**: Anatolian antinomian dervishes (Kalenderi, Bektashi)
- **Comparative Mysticism**: Cross-traditional phenomenology
- **Mental Health**: St. Dymphna, Geel care model, Bipolar II & mysticism

**Current Status**: Chapter 1 complete (scholarly infrastructure), Chapter 2 complete (19 saint profiles + 6 deep dives)

### Abdal Continuity Paper

**Title**: From Saloi to Abdal: Religious Continuity and Holy Foolishness in Anatolian Conversion to Islam

**Research Question**: Did Byzantine Christian holy fools (saloi) influence Ottoman Abdalan-i Rum dervish practices?

**Current Status**: ~20% complete
- ✅ Abstract (277 words)
- ✅ Introduction (2,428 words)
- ✅ Literature Review (2,019 words)
- ⏳ Pending: Methodology, Byzantine Saloi section, Abdalan section, Analysis, Evidence, Discussion, Conclusion, Limitations

**Geographic Focus**: Anatolia, 6th-16th centuries
**Thematic Focus**: Religious practice continuity across confessional boundaries

---

## 🌐 Research Website

Interactive Next.js 15 platform for academic dissemination:

**Implemented Features**:
- 📚 20+ converted research chapters
- 💬 AI Research Assistant (Claude Sonnet 4.5)
- 🔗 Zettelkasten backlinks system
- 🔍 Full-text search (Fuse.js)
- 📊 Knowledge graph visualization
- 🌓 Dark mode
- 📱 Mobile responsive
- ✅ Comprehensive testing (Vitest)
- 🔒 Security scanning (GitHub Actions)

**Planned Features** (from [INTERACTIVE_DOCUMENTATION_ARCHITECTURE.md](abdal-research-website/INTERACTIVE_DOCUMENTATION_ARCHITECTURE.md)):
- Text selection → AI-powered suggestions
- Academic citation integration (Tavily API)
- GitHub OAuth + PR generation workflow
- Contribution tracking & gamification
- Cost-optimized AI routing (Haiku + Sonnet)

**Repository**: [erdalgunes/abdal-research-website](https://github.com/erdalgunes/abdal-research-website)

---

## 🛠️ Technology Stack

### Papers
- **Typst**: Modern academic typesetting (LaTeX alternative)
- **BibTeX**: Bibliography management (Chicago style)
- **Git**: Version control with atomic commits

### Website
- **Framework**: Next.js 15 + React 19 + Turbopack
- **Styling**: Tailwind CSS v4 + shadcn/ui
- **Content**: MDX with gray-matter frontmatter
- **AI**: OpenRouter (Claude Sonnet 4.5, planned Haiku routing)
- **Deployment**: Vercel
- **Testing**: Vitest + React Testing Library + Playwright
- **CI/CD**: GitHub Actions (lint, test, security, deploy)

---

## 📝 Development Workflow

### Working on Papers

```bash
# Edit Typst files
vim sacred_madness.typ

# Compile to PDF
typst compile sacred_madness.typ

# Commit changes
git add sacred_madness.typ
git commit -m "Add Chapter 3: Comparative Analysis"
git push
```

### Working on Website (Submodule)

```bash
# Enter submodule
cd abdal-research-website/

# Make changes
vim app/page.tsx
git add .
git commit -m "Add new feature"
git push origin main

# Update parent to track new version
cd ..
git add abdal-research-website
git commit -m "Update website to latest"
git push
```

**Note**: Website deploys independently via Vercel tracking the submodule repository.

---

## 📊 Key Documentation

| Document | Description | Link |
|----------|-------------|------|
| **CLAUDE.md** | Project structure, commands, architecture | [View](CLAUDE.md) |
| **COST_OPTIMIZATION_ANALYSIS.md** | API cost reduction strategy (73% savings) | [View](COST_OPTIMIZATION_ANALYSIS.md) |
| **GIT_SUBMODULE_CONVERSION.md** | Submodule workflow guide | [View](GIT_SUBMODULE_CONVERSION.md) |
| **Website Architecture** | Interactive docs implementation plan | [View](abdal-research-website/INTERACTIVE_DOCUMENTATION_ARCHITECTURE.md) |
| **Website Security** | Security implementation details | [View](abdal-research-website/SECURITY.md) |
| **Website Testing** | Testing strategy and coverage | [View](abdal-research-website/TESTING.md) |

---

## 📚 Bibliography Highlights

716-line comprehensive bibliography including:

**Primary Sources**: Plotinus, Pseudo-Dionysius, Gregory of Nyssa, Maximus Confessor, Leontius of Neapolis, Desert Fathers

**Byzantine Studies**: Krueger, Rydén, Ivanov, Saward, Thompson

**Sufi Studies**: Karamustafa, Mélikoff, Ocak, Schimmel

**Theory**: Turner (liminality), Douglas (purity/danger), Bourdieu (symbolic capital), Butler (performativity), Foucault (power), Bell (ritual)

**Theology**: Lossky, Bulgakov, Coakley, Wright, Louth, von Balthasar

**Comparative**: Abramian, McDaniel, Kakar

---

## 🎯 Research Contributions

### Methodological Innovations
1. **Positionality-Grounded Research**: Explicit Alevi Kalenderi Abdal identity + Bipolar II lived experience
2. **Practice-Centered Analysis**: Focus on embodied practices vs theological doctrine
3. **Cross-Traditional Comparison**: Byzantine-Sufi parallels via phenomenology
4. **AI-Assisted Research**: Tavily + Claude for cost-optimized citation discovery

### Key Arguments
1. **Convergent Mysticism**: Holy foolishness emerges independently across traditions from shared phenomenological structures (NOT syncretism)
2. **Spatial Theology**: Urban vs desert monasticism creates distinct holy fool expressions
3. **Gender Performance**: Women's holy foolishness operates under double constraints (piety + gender norms)
4. **Living Tradition**: 20th century examples (Haralambis) prove continuity, not historical curiosity

---

## 📅 Current Status & Roadmap

### Completed ✅
- Repository structure and organization
- Git submodule configuration
- Sacred Madness book: Chapters 1-2 (~25,000 words)
- Abdal paper: Abstract, Introduction, Literature (~5,000 words)
- Website: Core features (AI chat, search, graph, backlinks)
- Cost optimization analysis
- CI/CD pipelines
- Comprehensive documentation

### In Progress 🚧
- Sacred Madness book: Chapters 3-7
- Abdal paper: Methodology through Conclusion
- Website: Interactive documentation features (Phases 1-4)

### Next Steps 🔜
1. **Immediate** (1 week): Implement cost optimizations (Haiku router, prompt caching)
2. **Short-term** (3 weeks): Text selection UI + AI research integration
3. **Medium-term** (4 weeks): GitHub OAuth + PR generation
4. **Long-term** (3 weeks): User tracking + gamification

**Timeline**: 11-12 weeks for full interactive documentation platform

---

## 🤝 Contributing

This is a solo academic research project with planned community contribution features via the website.

**Planned Contribution Workflow** (coming in Phase 3):
1. Select text on website
2. Ask AI for improvements
3. Review AI-suggested changes + citations
4. Create GitHub PR with one click
5. Earn reputation points & achievements

---

## 📄 License

**All Rights Reserved** © 2025 Erdal Güneş

Academic papers and research content are copyrighted. Website code may be open-sourced in future (TBD).

---

## 🔗 Links

- **Parent Repository**: [github.com/erdalgunes/horoscope](https://github.com/erdalgunes/horoscope)
- **Website Repository**: [github.com/erdalgunes/abdal-research-website](https://github.com/erdalgunes/abdal-research-website)
- **Website Live** (coming soon): TBD
- **Author**: [Erdal Güneş](mailto:erdalgns@gmail.com)

---

## 📖 Citation

If citing this research, please use:

```
Güneş, E. (2025). Sacred Madness: Holy Foolishness in Orthodox Christianity
and Sufi Islam. Unpublished manuscript.
https://github.com/erdalgunes/horoscope
```

---

🤖 *Repository structure and documentation generated with [Claude Code](https://claude.com/claude-code)*
