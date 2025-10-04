# Git Submodule Conversion Guide

**Repository**: `horoscope` → `abdal-research-website` as submodule
**Date**: 2025-10-04
**Recommended By**: Repository analysis via Tavily research + Claude Sonnet 4.5

---

## Why Git Submodule?

### Decision Rationale
After comparing submodules vs monorepo vs separate repos vs subtree, **git submodule** is optimal because:

✅ **Independent CI/CD**: Papers and website deploy separately
✅ **Clean history**: Academic paper commits not polluted by `node_modules` changes
✅ **Version coupling**: Main repo explicitly tracks which website version to use
✅ **Selective cloning**: Collaborators can clone just papers without website infrastructure

### Current Problem
```
horoscope/
  ├── .git/ (main repo)
  ├── abdal-research-website/
  │   └── .git/ (nested repo, UNTRACKED)
```

The website has its own git repository but is untracked by the parent, causing:
- No version coupling
- Potential divergence
- Uncommitted changes (40+ modified files)

---

## Conversion Steps

### Prerequisites
1. Ensure all website changes are committed
2. Create GitHub repository for website
3. Backup current state

### Step 1: Check Website Status

```bash
cd /Users/erdalgunes/horoscope/abdal-research-website
git status
```

**Expected output**: Clean working directory or specific uncommitted files

**If dirty**: Commit changes first:
```bash
git add .
git commit -m "Prepare for submodule conversion

- Finalize all pending changes before conversion
- Current status: [describe changes]

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"
```

### Step 2: Create Remote Repository

**Option A: Via GitHub CLI (Recommended)**
```bash
cd /Users/erdalgunes/horoscope/abdal-research-website

# Create repo (requires gh authentication)
gh repo create erdalgunes/abdal-research-website \
  --public \
  --description "Sacred Madness Wiki - Interactive Research Documentation" \
  --source=. \
  --remote=origin \
  --push
```

**Option B: Manual**
1. Go to https://github.com/new
2. Repository name: `abdal-research-website`
3. Description: "Sacred Madness Wiki - Interactive Research Documentation"
4. Visibility: Public
5. **DO NOT** initialize with README (repo already exists locally)
6. Create repository

Then push:
```bash
cd /Users/erdalgunes/horoscope/abdal-research-website
git remote add origin https://github.com/erdalgunes/abdal-research-website.git
git branch -M main
git push -u origin main
```

### Step 3: Remove from Parent Tracking

```bash
cd /Users/erdalgunes/horoscope

# Remove from git tracking (keeps local files)
git rm -r --cached abdal-research-website/

# Commit removal
git commit -m "$(cat <<'EOF'
Remove abdal-research-website from direct tracking

Preparing to convert to git submodule for:
- Independent CI/CD pipelines
- Clean academic paper history
- Explicit version coupling

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Step 4: Add as Submodule

```bash
cd /Users/erdalgunes/horoscope

# Remove local directory (will be re-cloned via submodule)
rm -rf abdal-research-website/

# Add as submodule
git submodule add https://github.com/erdalgunes/abdal-research-website.git abdal-research-website

# Initialize submodule
git submodule update --init --recursive

# Commit submodule addition
git commit -m "$(cat <<'EOF'
Convert abdal-research-website to git submodule

Benefits:
- Independent deployment (Vercel tracks website repo separately)
- Clean paper repository history
- Explicit version pinning
- Selective cloning for collaborators

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Step 5: Verify Setup

```bash
# Check .gitmodules file was created
cat .gitmodules

# Should show:
# [submodule "abdal-research-website"]
#     path = abdal-research-website
#     url = https://github.com/erdalgunes/abdal-research-website.git
#     branch = main

# Verify submodule status
git submodule status

# Should show:
# +[commit-hash] abdal-research-website (branch-name)

# Check that website directory exists
ls -la abdal-research-website/
```

---

## Workflow After Conversion

### Daily Website Development

```bash
# Work inside submodule
cd abdal-research-website/

# Make changes
npm run dev  # develop features
git add .
git commit -m "Add AI chat improvements"
git push origin main

# Update parent repo to track new version
cd ..
git add abdal-research-website
git commit -m "Update website to latest (AI chat improvements)"
git push
```

### Updating Papers (No website changes)

```bash
cd /Users/erdalgunes/horoscope

# Edit papers
vim sacred_madness.typ
git add sacred_madness.typ
git commit -m "Add Chapter 3: Comparative Analysis"
git push

# Website version stays pinned (no update needed)
```

### Syncing Website Content from Papers

```bash
cd abdal-research-website/

# Reference parent repo paper sources
cat ../sacred_madness.typ  # read source
vim content/chapters/chapter3.md  # update website content

git add content/
git commit -m "Sync chapter 3 content from main paper"
git push

# Update parent
cd ..
git add abdal-research-website
git commit -m "Update website: sync chapter 3"
git push
```

### Collaborator Cloning

**Option 1: Just Papers (Academic Collaborator)**
```bash
git clone https://github.com/erdalgunes/horoscope.git
cd horoscope
# Work on papers, ignore website submodule
```

**Option 2: Full Project (Web Developer)**
```bash
git clone --recurse-submodules https://github.com/erdalgunes/horoscope.git
cd horoscope/abdal-research-website
npm install
npm run dev
```

**Option 3: Add Submodule Later**
```bash
git clone https://github.com/erdalgunes/horoscope.git
cd horoscope
git submodule update --init --recursive
```

---

## Deployment Configuration

### Vercel Setup (Website)

The website repo should deploy independently:

1. **Go to Vercel Dashboard**: https://vercel.com/new
2. **Import Git Repository**: `erdalgunes/abdal-research-website`
3. **Configure**:
   - Framework Preset: Next.js
   - Root Directory: `./`
   - Build Command: `npm run build`
   - Output Directory: `.next`
4. **Environment Variables**:
   ```
   OPENROUTER_API_KEY=sk-or-v1-...
   TAVILY_API_KEY=tvly-...
   NEXTAUTH_URL=https://your-domain.vercel.app
   NEXTAUTH_SECRET=...
   ```

5. **Deploy**: Vercel will auto-deploy on every push to `main`

### Main Repo (Papers)

No deployment needed (research repository only).

Alternatively, set up GitHub Pages for compiled PDFs:
```bash
# .github/workflows/compile-papers.yml
name: Compile Papers
on:
  push:
    paths:
      - '**.typ'
      - '**.bib'

jobs:
  compile:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: typst-community/setup-typst@v1
      - run: |
          typst compile sacred_madness.typ
          typst compile abdal-continuity-paper/paper.typ
      - uses: actions/upload-artifact@v3
        with:
          name: pdfs
          path: '**/*.pdf'
```

---

## Troubleshooting

### Problem: Submodule shows modified but no changes

```bash
cd abdal-research-website
git status  # check for uncommitted changes
git diff    # see what changed

# If clean but still shows modified:
cd ..
git submodule update --remote
git add abdal-research-website
git commit -m "Update submodule pointer"
```

### Problem: Forgot to clone with --recurse-submodules

```bash
git submodule update --init --recursive
```

### Problem: Submodule HEAD detached

```bash
cd abdal-research-website
git checkout main
git pull origin main
cd ..
git add abdal-research-website
git commit -m "Update submodule to track main branch"
```

### Problem: Want to switch back to monorepo

```bash
# Remove submodule
git submodule deinit abdal-research-website
git rm abdal-research-website
rm -rf .git/modules/abdal-research-website

# Clone website directly into parent
git clone https://github.com/erdalgunes/abdal-research-website.git
rm -rf abdal-research-website/.git
git add abdal-research-website/
git commit -m "Revert to monorepo structure"
```

---

## Alternative: Keep Separate Repos

If submodule seems too complex, use **separate repositories** with manual sync:

### Structure
```
~/projects/
  ├── horoscope/           (papers only)
  └── abdal-research-website/  (independent clone)
```

### Sync Script
```bash
# ~/projects/sync-content.sh
#!/bin/bash

PAPERS_DIR="$HOME/projects/horoscope"
WEBSITE_DIR="$HOME/projects/abdal-research-website"

# Compile latest papers
cd "$PAPERS_DIR"
typst compile sacred_madness.typ
typst compile abdal-continuity-paper/paper.typ

# Copy PDFs to website
cp sacred_madness.pdf "$WEBSITE_DIR/public/papers/"
cp abdal-continuity-paper/paper.pdf "$WEBSITE_DIR/public/papers/"

# Update website
cd "$WEBSITE_DIR"
git add public/papers/
git commit -m "Update papers from source: $(date +%Y-%m-%d)"
git push

echo "✅ Papers synced to website"
```

**Pros**: Simpler, no submodule complexity
**Cons**: Manual sync required, no automatic version coupling

---

## Recommended Decision Tree

```
START
  │
  ├─ Do papers and website deploy together?
  │  ├─ YES → Monorepo
  │  └─ NO → Continue
  │
  ├─ Do you need version coupling (paper v1.2 → website v3.4)?
  │  ├─ YES → Submodule ✅ (Recommended)
  │  └─ NO → Separate repos
  │
  └─ Will multiple devs contribute to both?
     ├─ YES → Submodule ✅ (Recommended)
     └─ NO (solo) → Separate repos OK
```

**For this project**: **Submodule recommended** ✅

---

## Next Steps

1. **Decision**: Confirm submodule approach (vs alternatives)
2. **Execute**: Run Steps 1-5 above
3. **Update**: Modify `.github/README.md` badges to use new website repo URL
4. **Deploy**: Configure Vercel to track `abdal-research-website` repo
5. **Document**: Update CLAUDE.md with submodule workflow

---

**Research Sources**:
- Tavily: Git submodule best practices, academic workflow patterns
- Claude Sonnet 4.5: Decision matrix analysis, troubleshooting scenarios
- Community consensus: Submodules for independent deployment, clean history

**Date**: 2025-10-04
**Status**: Ready for execution (requires user approval for GitHub repo creation)
