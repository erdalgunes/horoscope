# Self-Improving Repository: Agent Architecture

**Version**: 1.0
**Last Updated**: October 4, 2025
**Status**: Implementation Phase 1 (Perception Layer)

## Executive Summary

The Sacred Madness repository is being transformed into a **self-improving autonomous system** that:
- Detects gaps in academic research (missing citations, weak arguments, outdated references)
- Autonomously researches solutions using Tavily academic search + Claude AI
- Generates improvements via GitHub pull requests with human review
- Maintains strict academic rigor (no hallucinated citations, plagiarism checks)
- Operates within existing $87/month budget

**Timeline**: 12 weeks for full implementation
**Current Phase**: Week 1-2 (Perception Layer)
**Expected ROI**: 20 hours/month saved on citation work, measurable improvement in paper quality

---

## Architecture Overview

### 5-Layer Self-Improving System

```
┌─────────────────────────────────────────────────────────────┐
│  Layer 5: LEARNING & FEEDBACK                               │
│  - Track PR acceptance rates                                │
│  - Build knowledge repository of successful patterns        │
│  - Refine gap prioritization over time                      │
└─────────────────────────────────────────────────────────────┘
                            ▲
                            │ Metrics, Success Patterns
                            │
┌─────────────────────────────────────────────────────────────┐
│  Layer 4: EXECUTION & PR GENERATION                         │
│  - Multi-agent orchestrator (Research, Frontend, Perf)      │
│  - Autonomous GitHub PR creation                            │
│  - Detailed documentation & rollback instructions           │
└─────────────────────────────────────────────────────────────┘
                            ▲
                            │ Tasks, Prompts, Budget Allocation
                            │
┌─────────────────────────────────────────────────────────────┐
│  Layer 3: PLANNING & TASK GENERATION                        │
│  - Task decomposer (atomic tasks from gaps)                 │
│  - Prompt constructor (context-optimized for caching)       │
│  - Branch strategy generator                                │
└─────────────────────────────────────────────────────────────┘
                            ▲
                            │ Prioritized Gaps, Cost Estimates
                            │
┌─────────────────────────────────────────────────────────────┐
│  Layer 2: REASONING & DIAGNOSIS                             │
│  - Gap prioritizer (severity × user_impact × confidence)    │
│  - Academic rigor checker (citation validation)             │
│  - Budget manager (token allocation)                        │
└─────────────────────────────────────────────────────────────┘
                            ▲
                            │ Raw Gaps, Analytics, Code Health
                            │
┌─────────────────────────────────────────────────────────────┐
│  Layer 1: PERCEPTION & MONITORING                           │
│  - Research quality analyzer (scan .typ files)              │
│  - Website analytics collector (user confusion patterns)    │
│  - Code health monitor (bundle size, cache hits)            │
└─────────────────────────────────────────────────────────────┘
```

---

## Layer 1: Perception & Monitoring

**Purpose**: Automated detection of gaps, issues, and improvement opportunities

### Components

#### 1.1 Research Quality Analyzer
**File**: `abdal-research-website/lib/monitoring/research-analyzer.ts`

**Capabilities:**
- Parse Typst `.typ` files for citations and claims
- Extract all `@cite_key[page]` references
- Detect claims without supporting citations (high assertiveness + no nearby citation)
- Validate citations against `.bib` files
- Identify orphaned sections (high concept density, low citation count)
- Check for outdated references (>15 years old in active research fields)

**Output**: `.ai-insights/research-gaps.json`
```json
[
  {
    "gap_id": "sacred_madness.typ:156:weak-argument",
    "type": "weak_argument",
    "file": "sacred_madness.typ",
    "line": 156,
    "section": "Chapter 2: Byzantine Saloi",
    "claim": "Ibn Arabi's wahdat al-wujud was controversial",
    "assertiveness": 0.85,
    "nearby_citations": [],
    "severity": "high",
    "suggested_action": "Add citation documenting controversy"
  }
]
```

**Detection Algorithms:**

*Weak Argument Detection:*
```typescript
// Claims with assertiveness but no citations
function detectWeakArguments(content: string): WeakArgument[] {
  const sentences = splitIntoSentences(content);
  const weakArgs: WeakArgument[] = [];

  for (const [index, sentence] of sentences.entries()) {
    const assertiveness = calculateAssertiveness(sentence);
    const hasCitation = hasNearbyCitation(sentences, index, radius=2);

    if (assertiveness > 0.7 && !hasCitation) {
      weakArgs.push({
        sentence,
        line: getLineNumber(content, sentence),
        assertiveness,
        severity: assertiveness > 0.85 ? 'high' : 'medium'
      });
    }
  }

  return weakArgs;
}

// Assertiveness indicators:
// - Definitive language: "was", "is", "demonstrates"
// - Causal claims: "therefore", "thus", "consequently"
// - Superlatives: "most", "primary", "key"
// - Absence of hedging: NOT "perhaps", "suggests", "may"
```

*Missing Citation Detection:*
```typescript
function validateCitations(typstContent: string, bibContent: string): MissingCitation[] {
  const citations = extractCitations(typstContent); // @cite_key[page]
  const bibEntries = parseBibTeX(bibContent);
  const missing: MissingCitation[] = [];

  for (const citation of citations) {
    if (!bibEntries.has(citation.key)) {
      missing.push({
        citation: citation.key,
        line: citation.line,
        severity: 'critical'
      });
    }
  }

  return missing;
}
```

#### 1.2 Website Analytics Collector
**File**: `abdal-research-website/lib/monitoring/analytics-collector.ts`

**Capabilities:**
- Query Vercel Analytics API for user behavior
- Track scroll depth per section (identify abandonment points)
- Monitor AI chat queries (identify confusion patterns)
- Record failed searches (gaps in content coverage)
- Measure performance metrics (LCP, CLS, TTI)

**Output**: `.ai-insights/user-behavior.json`
```json
{
  "period": "2025-10-01 to 2025-10-07",
  "section_engagement": {
    "chapter-2-byzantine-saloi": {
      "views": 342,
      "avg_time_seconds": 187,
      "scroll_depth_avg": 0.68,
      "bounce_rate": 0.23
    }
  },
  "chat_confusion_patterns": [
    {
      "query": "what does wahdat al-wujud mean",
      "frequency": 12,
      "section": "chapter-2-sufi-parallels",
      "suggests": "missing_definition"
    }
  ],
  "failed_searches": [
    {
      "query": "Hızır Elijah syncretism",
      "attempts": 5,
      "suggests": "missing_content"
    }
  ]
}
```

**User Impact Scoring:**
```typescript
function calculateUserImpact(gap: ResearchGap, analytics: Analytics): number {
  const section = gap.location.section;

  // High impact if users frequently visit this section
  const pageViews = analytics.sectionViews[section] || 0;
  const viewScore = Math.min(pageViews / 100, 1.0); // Normalize to 0-1

  // High impact if users ask questions about this topic
  const chatMentions = analytics.chatQueries.filter(q =>
    q.toLowerCase().includes(section.toLowerCase())
  ).length;
  const chatScore = Math.min(chatMentions / 10, 1.0);

  // High impact if users abandon section (low scroll depth)
  const scrollDepth = analytics.scrollDepth[section] || 1.0;
  const abandonmentScore = scrollDepth < 0.5 ? 0.8 : 0.2;

  return (viewScore * 0.5) + (chatScore * 0.3) + (abandonmentScore * 0.2);
}
```

#### 1.3 Code Health Monitor
**File**: `abdal-research-website/lib/monitoring/code-health.ts`

**Capabilities:**
- Analyze Next.js bundle sizes
- Track dependency bloat
- Monitor prompt cache hit rates
- Detect code duplication
- Measure API latency percentiles

**Output**: `.ai-insights/code-health.json`
```json
{
  "bundle_analysis": {
    "main_bundle_size": 487000,
    "threshold": 350000,
    "status": "exceeds_threshold",
    "largest_dependencies": [
      {"name": "@tailwindcss/typography", "size": 89000},
      {"name": "react-markdown", "size": 67000}
    ]
  },
  "cache_performance": {
    "prompt_cache_hit_rate": 0.87,
    "tavily_cache_hit_rate": 0.94,
    "cost_savings_monthly": 58.32
  },
  "code_quality": {
    "duplication_percentage": 12,
    "complexity_hotspots": [
      {"file": "lib/ai-router.ts", "complexity": 18}
    ]
  }
}
```

### Implementation: GitHub Actions Workflow

**File**: `.github/workflows/perception-layer.yml`

```yaml
name: Perception Layer - Daily Scan
on:
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM UTC
  workflow_dispatch:

jobs:
  analyze-research-quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Dependencies
        run: |
          cd abdal-research-website
          npm install

      - name: Analyze Typst Papers
        run: |
          cd abdal-research-website
          npm run monitor:research-quality
          # Outputs to ../ai-insights/research-gaps.json

      - name: Collect Website Analytics
        run: |
          cd abdal-research-website
          npm run monitor:analytics
          # Outputs to ../.ai-insights/user-behavior.json
        env:
          VERCEL_TOKEN: ${{ secrets.VERCEL_TOKEN }}

      - name: Monitor Code Health
        run: |
          cd abdal-research-website
          npm run monitor:code-health
          # Outputs to ../.ai-insights/code-health.json

      - name: Upload Perception Data
        uses: actions/upload-artifact@v3
        with:
          name: perception-data
          path: .ai-insights/
          retention-days: 30

      - name: Trigger Reasoning Layer
        if: success()
        uses: peter-evans/repository-dispatch@v2
        with:
          event-type: perception-complete
          client-payload: '{"artifacts": "perception-data"}'
```

**NPM Scripts** (add to `abdal-research-website/package.json`):
```json
{
  "scripts": {
    "monitor:research-quality": "tsx lib/monitoring/run-research-analyzer.ts",
    "monitor:analytics": "tsx lib/monitoring/run-analytics-collector.ts",
    "monitor:code-health": "tsx lib/monitoring/run-code-health.ts"
  }
}
```

---

## Layer 2: Reasoning & Diagnosis

**Purpose**: Prioritize gaps, validate constraints, allocate budget

### Components

#### 2.1 Gap Prioritizer
**File**: `abdal-research-website/lib/reasoning/gap-prioritizer.ts`

**Scoring Algorithm:**
```typescript
interface PrioritizedGap extends ResearchGap {
  score: number;
  estimatedCost: number;
  userImpact: number;
  fixConfidence: number;
}

function prioritizeGaps(gaps: ResearchGap[], analytics: Analytics): PrioritizedGap[] {
  return gaps.map(gap => {
    const severityScore = { low: 0.3, medium: 0.6, high: 1.0 }[gap.severity];
    const userImpact = calculateUserImpact(gap, analytics);
    const fixConfidence = estimateFixConfidence(gap);
    const estimatedCost = estimateTokenCost(gap);

    const score = severityScore * userImpact * fixConfidence;

    return { ...gap, score, estimatedCost, userImpact, fixConfidence };
  }).sort((a, b) => b.score - a.score);
}

function estimateFixConfidence(gap: ResearchGap): number {
  const confidenceMap = {
    'missing_citation': 0.9,    // Easy: add from .bib
    'weak_argument': 0.6,       // Medium: need research
    'orphaned_section': 0.4,    // Hard: major rewrite
    'outdated_reference': 0.8   // Easy: find newer source
  };
  return confidenceMap[gap.type];
}

function estimateTokenCost(gap: ResearchGap): number {
  const contextTokens = gap.context.length / 4; // ~4 chars per token

  const solutionTokens = {
    'missing_citation': 500,      // Just fetch + format
    'weak_argument': 2000,        // Research + write
    'orphaned_section': 5000,     // Extensive rewrite
    'outdated_reference': 1000    // Find + replace
  }[gap.type];

  return contextTokens + solutionTokens;
}
```

**Output**: `.ai-insights/prioritized-gaps.json`
```json
[
  {
    "gap_id": "sacred_madness.typ:156:weak-argument",
    "score": 0.51,
    "estimatedCost": 2500,
    "userImpact": 0.72,
    "fixConfidence": 0.85,
    "budgetApproved": true,
    "priority": 1
  }
]
```

#### 2.2 Academic Rigor Checker
**File**: `abdal-research-website/lib/reasoning/rigor-checker.ts`

**Validation Gates:**
```typescript
async function validateSolution(gap: ResearchGap, solution: Solution): Promise<ValidationResult> {
  const violations: string[] = [];

  // Gate 1: No hallucinated citations
  for (const citation of solution.newCitations) {
    const exists = await verifyCitationExists(citation.doi || citation.isbn);
    if (!exists) {
      violations.push(`Hallucinated citation: ${citation.key}`);
    }
  }

  // Gate 2: No plagiarism
  const similarity = await checkPlagiarism(solution.text);
  if (similarity > 0.8) {
    violations.push(`High plagiarism risk: ${similarity.toFixed(2)}`);
  }

  // Gate 3: Argument structure preserved
  if (gap.type === 'weak_argument') {
    const structureValid = validateArgumentStructure(solution.text);
    if (!structureValid) {
      violations.push('Argument structure altered');
    }
  }

  // Gate 4: Source quality
  for (const source of solution.sources) {
    const quality = await assessSourceQuality(source);
    if (quality < 10) {
      violations.push(`Low-quality source: ${source.title} (score: ${quality}/25)`);
    }
  }

  return {
    isValid: violations.length === 0,
    violations,
    quality_score: calculateQualityScore(violations)
  };
}

async function verifyCitationExists(identifier: string): Promise<boolean> {
  if (identifier.startsWith('10.')) {
    // DOI verification
    const response = await fetch(`https://doi.org/${identifier}`, { method: 'HEAD' });
    return response.ok;
  } else {
    // ISBN verification via WorldCat
    const response = await fetch(`https://www.worldcat.org/isbn/${identifier}`);
    return !response.url.includes('error');
  }
}

async function checkPlagiarism(text: string): Promise<number> {
  // Semantic similarity using embeddings (Claude or OpenAI)
  const embedding = await generateEmbedding(text);
  const existingEmbeddings = await loadExistingPaperEmbeddings();

  const similarities = existingEmbeddings.map(existing =>
    cosineSimilarity(embedding, existing)
  );

  return Math.max(...similarities);
}
```

#### 2.3 Budget Manager
**File**: `abdal-research-website/lib/reasoning/budget-manager.ts`

**Budget Allocation:**
```typescript
interface BudgetAllocation {
  totalMonthly: number;
  websiteTraffic: number;      // Reserve for user queries
  agentOperations: number;      // Available for autonomous improvements
  allocated: number;            // Used so far this month
  remaining: number;
}

async function getRemainingBudget(): Promise<BudgetAllocation> {
  const now = new Date();
  const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);

  const costs = await getCostSummary(monthStart.getTime(), now.getTime());

  return {
    totalMonthly: 87.00,
    websiteTraffic: 60.00,       // ~70% reserved for users
    agentOperations: 27.00,      // ~30% for agents
    allocated: costs.totalCost,
    remaining: 27.00 - costs.totalCost
  };
}

function approveBudget(gaps: PrioritizedGap[]): PrioritizedGap[] {
  const budget = await getRemainingBudget();
  let accumulatedCost = 0;

  return gaps.map(gap => {
    const costInDollars = (gap.estimatedCost / 1_000_000) * 3.0; // Assume Sonnet

    if (accumulatedCost + costInDollars <= budget.remaining) {
      accumulatedCost += costInDollars;
      return { ...gap, budgetApproved: true };
    } else {
      return { ...gap, budgetApproved: false, deferredUntil: nextMonth };
    }
  });
}
```

---

## Layer 3: Planning & Task Generation

**Purpose**: Convert prioritized gaps into executable agent tasks

### Components

#### 3.1 Task Decomposer
**File**: `abdal-research-website/lib/planning/task-decomposer.ts`

```typescript
interface AgentTask {
  id: string;
  agent: 'research' | 'frontend' | 'performance' | 'documentation';
  type: 'code_generation' | 'content_writing' | 'optimization' | 'testing';
  description: string;
  files: string[];
  prompt: string;
  estimatedTokens: number;
  dependencies: string[];
}

function decomposeGap(gap: PrioritizedGap): AgentTask[] {
  const tasks: AgentTask[] = [];

  switch (gap.type) {
    case 'weak_argument':
      tasks.push({
        id: `${gap.gap_id}-research`,
        agent: 'research',
        type: 'content_writing',
        description: `Strengthen argument at ${gap.location.section}`,
        files: [gap.file],
        prompt: buildResearchPrompt(gap),
        estimatedTokens: gap.estimatedCost,
        dependencies: []
      });
      break;

    case 'missing_citation':
      tasks.push({
        id: `${gap.gap_id}-cite`,
        agent: 'research',
        type: 'content_writing',
        description: `Add citation for: ${gap.context.slice(0, 50)}...`,
        files: [gap.file, gap.file.replace('.typ', '.bib')],
        prompt: buildCitationPrompt(gap),
        estimatedTokens: gap.estimatedCost,
        dependencies: []
      });
      break;

    // ... other gap types
  }

  return tasks;
}

function buildResearchPrompt(gap: PrioritizedGap): string {
  return `
You are Sophia, the academic research agent for Sacred Madness repository.

TASK: Strengthen argument with proper citation

LOCATION: ${gap.file}:${gap.line}
SECTION: ${gap.location.section}

CURRENT TEXT:
${gap.context}

ISSUE: This claim lacks supporting citation (assertiveness: ${gap.assertiveness})

INSTRUCTIONS:
1. Search Tavily for peer-reviewed sources on this topic
2. Verify each source via DOI/ISBN
3. Select the most authoritative source (prefer tier 1 journals)
4. Add BibTeX entry to ${gap.file.replace('.typ', '.bib')}
5. Modify the text to include inline citation with page numbers
6. Preserve the original scholarly voice
7. Compile with Typst to verify no errors

CONSTRAINTS:
- NEVER hallucinate citations
- Use peer-reviewed sources only
- Budget: ${gap.estimatedCost} tokens available
- Target cost: <$0.10

OUTPUT FORMAT:
{
  "bibentry": "...",
  "modified_text": "...",
  "verification": {
    "doi_verified": true,
    "compilation_passed": true
  }
}
`;
}
```

#### 3.2 Prompt Constructor
**File**: `abdal-research-website/lib/planning/prompt-builder.ts`

**Integrates with existing prompt caching:**
```typescript
import { buildCachedMessages } from '@/lib/prompt-cache';

function buildAgentPrompt(task: AgentTask): CachedMessage[] {
  // Load Sophia system prompt
  const sophiaPrompt = fs.readFileSync('.ai-agents/sophia-prompt.md', 'utf-8');

  // Build messages using existing caching infrastructure
  const messages = buildCachedMessages(
    task.prompt,  // User query
    sophiaPrompt, // Page context (cached)
    task.context  // Selected text (not cached)
  );

  return messages;
}
```

#### 3.3 Branch Strategy Generator
**File**: `abdal-research-website/lib/planning/branch-strategy.ts`

```typescript
function generateBranchName(tasks: AgentTask[]): string {
  const primaryTask = tasks[0];

  const prefix = {
    'research': 'research',
    'frontend': 'enhance',
    'performance': 'optimize',
    'documentation': 'docs'
  }[primaryTask.agent];

  const descriptor = primaryTask.description
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, '')
    .split(' ')
    .slice(0, 5)
    .join('-');

  return `${prefix}/${descriptor}`;
}

// Example: research/add-citation-symeon-controversy
// Example: enhance/improve-search-ui-clarity
// Example: optimize/reduce-bundle-size-tailwind
```

---

## Layer 4: Execution & PR Generation

**Purpose**: Autonomous agents execute tasks and create GitHub PRs

### Sophia Research Agent

**File**: `abdal-research-website/lib/agents/research-agent.ts`

**Core Logic:**
```typescript
async function executeResearchTask(task: AgentTask): Promise<PRResult> {
  // Step 1: Search Tavily for sources
  const sources = await searchTavily({
    query: extractSearchQuery(task.prompt),
    maxResults: 10,
    searchDepth: 'advanced'
  });

  // Step 2: Verify each source
  const verified = await Promise.all(
    sources.map(async source => {
      const valid = await verifyCitation(source.doi);
      return valid ? source : null;
    })
  ).then(results => results.filter(Boolean));

  // Step 3: Generate solution with Claude
  const solution = await generateSolution(task, verified);

  // Step 4: Validate academic rigor
  const validation = await validateSolution(task.gap, solution);
  if (!validation.isValid) {
    throw new Error(`Validation failed: ${validation.violations.join(', ')}`);
  }

  // Step 5: Apply changes to files
  await applyChanges(solution.fileChanges);

  // Step 6: Compile Typst to verify
  await compileTypst(solution.affectedFiles);

  // Step 7: Create Git branch and commit
  const branch = generateBranchName([task]);
  await createBranch(branch);
  await commitChanges(solution, task);

  // Step 8: Generate PR
  const pr = await createPullRequest({
    title: generatePRTitle(task),
    body: generatePRBody(task, solution, validation),
    branch,
    labels: ['research', 'citation-added', 'needs-review']
  });

  return pr;
}
```

### GitHub Actions Workflow

**File**: `.github/workflows/autonomous-improvement.yml`

```yaml
name: Autonomous Improvement - Sophia Agent
on:
  schedule:
    - cron: '0 3 * * 1'  # Weekly on Monday 3 AM
  workflow_dispatch:
  repository_dispatch:
    types: [perception-complete]

jobs:
  research-agent:
    runs-on: ubuntu-latest
    if: github.event_name == 'repository_dispatch' || github.event_name == 'workflow_dispatch'
    steps:
      - uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install Dependencies
        run: |
          cd abdal-research-website
          npm install

      - name: Download Perception Data
        uses: actions/download-artifact@v3
        with:
          name: perception-data
          path: .ai-insights/

      - name: Run Reasoning Layer
        run: |
          cd abdal-research-website
          npm run reason:prioritize-gaps
          # Outputs: ../.ai-insights/prioritized-gaps.json

      - name: Generate Tasks
        run: |
          cd abdal-research-website
          npm run plan:generate-tasks
          # Outputs: ../.ai-insights/agent-tasks.json

      - name: Execute Research Agent
        run: |
          cd abdal-research-website
          npm run agent:execute-research
        env:
          TAVILY_API_KEY: ${{ secrets.TAVILY_API_KEY }}
          OPENROUTER_API_KEY: ${{ secrets.OPENROUTER_API_KEY }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

      - name: Report Results
        if: always()
        run: |
          cd abdal-research-website
          npm run agent:report-results
```

---

## Layer 5: Learning & Feedback

**Purpose**: Track performance, build knowledge, improve over time

### Components

#### 5.1 PR Success Tracker
**File**: `abdal-research-website/lib/learning/pr-tracker.ts`

```typescript
interface PRMetrics {
  pr_id: number;
  gap_type: string;
  accepted: boolean;
  revision_cycles: number;
  time_to_merge_hours: number;
  reviewer_comments: string[];
  lessons_learned: string[];
}

async function trackPROutcome(pr: PullRequest): Promise<void> {
  const metrics: PRMetrics = {
    pr_id: pr.number,
    gap_type: extractGapType(pr.title),
    accepted: pr.merged,
    revision_cycles: pr.commits.length - 1,
    time_to_merge_hours: (pr.merged_at - pr.created_at) / 3600000,
    reviewer_comments: pr.comments.map(c => c.body),
    lessons_learned: extractLessons(pr.comments)
  };

  await savePRMetrics(metrics);

  // Update confidence estimates
  if (pr.merged) {
    await updateFixConfidence(metrics.gap_type, 'increase');
  } else {
    await updateFixConfidence(metrics.gap_type, 'decrease');
  }
}
```

#### 5.2 Knowledge Repository
**File**: `.ai-insights/knowledge-base.json`

```json
{
  "reliable_sources_by_topic": {
    "byzantine_holy_fools": [
      "krueger_symeon_1996",
      "ivanov_holy_2006",
      "ryden_life_1995"
    ],
    "ibn_arabi_wahdat_al_wujud": [
      "knysh_ibn_1999",
      "chittick_ibn_2005"
    ]
  },
  "successful_search_patterns": [
    {
      "topic": "Byzantine saloi",
      "query": "Byzantine holy fools saloi theological controversy Leontius",
      "success_rate": 0.92
    }
  ],
  "fix_confidence_history": {
    "weak_argument": [
      {"date": "2025-10-01", "confidence": 0.60},
      {"date": "2025-10-15", "confidence": 0.68},
      {"date": "2025-11-01", "confidence": 0.75}
    ]
  }
}
```

---

## Implementation Roadmap

### Phase 1: Perception Layer (Weeks 1-2) ← CURRENT
- [ ] Create `lib/monitoring/research-analyzer.ts`
  - Citation extraction from `.typ` files
  - Weak argument detection
  - DOI validation
- [ ] Create `lib/monitoring/analytics-collector.ts`
  - Vercel Analytics integration
  - User confusion pattern detection
- [ ] Create `lib/monitoring/code-health.ts`
  - Bundle size analysis
  - Cache performance tracking
- [ ] Create `.github/workflows/perception-layer.yml`
  - Daily scheduled run
  - Artifact upload
- [ ] Test with real repository files
- **Deliverable**: `.ai-insights/` directory with daily gap reports

### Phase 2: Reasoning Layer (Weeks 3-4)
- [ ] Create `lib/reasoning/gap-prioritizer.ts`
- [ ] Create `lib/reasoning/rigor-checker.ts`
- [ ] Create `lib/reasoning/budget-manager.ts`
- [ ] Integrate with cost-tracker.ts (already implemented)
- [ ] Test prioritization with real gaps
- **Deliverable**: Prioritized gap queue with budget approval

### Phase 3: Planning Layer (Weeks 5-6)
- [ ] Create `lib/planning/task-decomposer.ts`
- [ ] Create `lib/planning/prompt-builder.ts`
- [ ] Create `lib/planning/branch-strategy.ts`
- [ ] Test task generation from gaps
- **Deliverable**: Executable agent tasks with context-optimized prompts

### Phase 4: Execution Layer (Weeks 7-8)
- [ ] Create `lib/agents/research-agent.ts`
- [ ] Integrate Tavily academic search
- [ ] Implement BibTeX generation
- [ ] Add Typst compilation validation
- [ ] Create `lib/execution/pr-generator.ts`
- [ ] Create `.github/workflows/autonomous-improvement.yml`
- [ ] **DRY RUN MODE**: Generate PRs without actually creating them
- **Deliverable**: Autonomous PR generation (dry-run tested)

### Phase 5: Learning Layer (Weeks 9-10)
- [ ] Create `lib/learning/pr-tracker.ts`
- [ ] Build knowledge repository
- [ ] Implement confidence adjustment
- [ ] Add dashboard for metrics
- **Deliverable**: Self-improving system with learning loop

### Phase 6: Integration & Launch (Weeks 11-12)
- [ ] End-to-end testing with human supervision
- [ ] Transition from dry-run to live PRs
- [ ] Monitor first week of autonomous operation
- [ ] Adjust confidence thresholds based on acceptance rate
- **Deliverable**: Fully operational self-improving repository

---

## Success Metrics

### Month 1 (Validation Phase)
- **PRs created**: 4-8
- **Focus**: High-confidence gaps (missing citations)
- **Budget**: <$10/month for agents
- **Target acceptance rate**: >75%

### Month 3 (Expansion Phase)
- **PRs created**: 10-15
- **Expand to**: Weak arguments, performance
- **Budget**: <$20/month for agents
- **Target acceptance rate**: >85%

### Month 12 (Mature Phase)
- **PRs created**: 15-20
- **Full scope**: All gap types
- **Budget**: Full $27/month allocation
- **Target acceptance rate**: >90%
- **Self-improvement**: 20% token reduction via learning

---

## Budget Breakdown

**Monthly Total**: $87.00

| Component | Allocation | Purpose |
|-----------|------------|---------|
| Website user traffic | $60.00 | AI chat, search (70%) |
| Agent operations | $27.00 | Autonomous improvements (30%) |

**Agent Budget Allocation**:
- Tavily searches: $0.50/month (100 queries @ $0.005 each)
- Claude Haiku: $6.50/month (routing, analysis)
- Claude Sonnet: $20.00/month (complex research, writing)

**Expected ROI**:
- Human time saved: 20 hours/month on citation work
- Paper quality improvement: Measurable (citation density, argument strength)
- Website engagement: Increased time-on-page, reduced confusion queries

---

## Risk Mitigation

### Risk 1: Hallucinated Citations
**Mitigation**:
- DOI/ISBN verification before PR creation
- Academic rigor checker (mandatory gate)
- Human review required for all PRs

### Risk 2: Budget Overrun
**Mitigation**:
- Budget manager approves each gap before execution
- Monthly limits enforced
- Alert when 80% budget consumed

### Risk 3: Low PR Acceptance Rate
**Mitigation**:
- Start with high-confidence gaps only
- Dry-run mode for first month
- Adjust confidence thresholds based on feedback
- Human can override/defer any gap

### Risk 4: Thesis Alteration
**Mitigation**:
- Academic rigor checker validates argument structure
- PRs limited to <200 lines changed
- Preservation of scholarly voice requirement
- Author (erdalgunes) required reviewer

---

## Files Structure

```
horoscope/
├── .ai-agents/
│   └── sophia-prompt.md          # Full Sophia agent specification
├── .ai-insights/                  # Gitignored - daily scan outputs
│   ├── research-gaps.json
│   ├── user-behavior.json
│   ├── code-health.json
│   ├── prioritized-gaps.json
│   ├── agent-tasks.json
│   └── knowledge-base.json
├── .github/workflows/
│   ├── perception-layer.yml      # Daily gap detection
│   └── autonomous-improvement.yml # Weekly PR generation
├── abdal-research-website/
│   └── lib/
│       ├── monitoring/
│       │   ├── research-analyzer.ts
│       │   ├── analytics-collector.ts
│       │   └── code-health.ts
│       ├── reasoning/
│       │   ├── gap-prioritizer.ts
│       │   ├── rigor-checker.ts
│       │   └── budget-manager.ts
│       ├── planning/
│       │   ├── task-decomposer.ts
│       │   ├── prompt-builder.ts
│       │   └── branch-strategy.ts
│       ├── agents/
│       │   └── research-agent.ts
│       ├── execution/
│       │   └── pr-generator.ts
│       └── learning/
│           └── pr-tracker.ts
└── docs/
    └── AGENT_ARCHITECTURE.md     # This document
```

---

## Next Steps

1. **Immediate** (This week):
   - Implement `research-analyzer.ts`
   - Test citation extraction on `sacred_madness.typ`
   - Validate gap detection accuracy

2. **Week 2**:
   - Add analytics collector
   - Create perception GitHub Action
   - Generate first `.ai-insights/research-gaps.json`

3. **Week 3**:
   - Begin reasoning layer implementation
   - Integrate with existing cost-tracker.ts
   - Test prioritization algorithm

**Status**: Ready to begin implementation
**Owner**: Sophia autonomous agent (supervised by erdalgunes)
**Timeline**: 12 weeks to full deployment
**Budget**: Within existing $87/month allocation

🤖 Built with Claude Code
📚 Self-improving academic research infrastructure
