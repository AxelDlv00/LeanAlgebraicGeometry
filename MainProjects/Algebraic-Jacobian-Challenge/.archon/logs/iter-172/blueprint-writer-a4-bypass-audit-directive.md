# Blueprint Writer Directive (iter-172, slug `a4-bypass-audit`)

## Slug
a4-bypass-audit

## Target chapter

`blueprint/src/chapters/Jacobian.tex` (EXISTING — 613 LOC, contains Route A § including A.1-A.4 sub-phase decomposition).

## Strategy context

STRATEGY.md row "Route A.4 — Albanese UP of `Pic⁰`" carries an OPEN strategic question (verbatim from STRATEGY.md `## Open strategic questions`):

> A.4 row claims "reuses in-tree Rigidity Lemma + Cor 1.2/1.5; no new Mathlib namespace", but Milne III §6's Albanese UP proof historically uses morphism-extension (Thm 3.1/3.2). If A.4 truly bypasses Thm 3.2 via Picard-functor functoriality alone, the blueprint must document the chain explicitly in `Jacobian.tex` Route A.4 section; if not, A.4 includes a Thm 3.2 sub-build whose emptiness half (Lemma 3.3) needs Auslander–Buchsbaum (absent in Mathlib) and the A.4 iter estimate is materially under-counted. **Resolve this question before scheduling A.4 prover lanes**.

Per iter-172 strategy-critic `route172` verdict: the question is "load-bearing uncertainty in the entire Route A budget" and "cheap to audit (~3 pages of Milne III §6)".

## Task

Audit Milne III §6 (Albanese universal property of `Pic⁰`) and DOCUMENT in `Jacobian.tex` the actual dependency chain. Two possible outcomes:

### Outcome (a) — bypass holds

Milne III §6's Albanese UP is derivable from:
- Picard scheme functoriality (sheafification + universal map);
- Cor 1.5 / Cor 1.2 (in-tree, axiom-clean);
- seesaw / cohomology-and-base-change pieces all present in Mathlib's `Mathlib.AlgebraicGeometry.Cohomology.*` chain.

**Action**: in the Route A.4 section of `Jacobian.tex`, write a clear theorem block stating the UP chain (with `\uses{}` annotations citing each in-tree dependency). This becomes the prover-ready spec for the A.4 lane.

### Outcome (b) — bypass fails

Milne's proof genuinely uses Thm 3.1/3.2 (rational-map extension over a complete surface). Then A.4 incorporates a Thm 3.2 sub-build, with the emptiness half (Lemma 3.3) requiring Auslander–Buchsbaum (absent in Mathlib).

**Action**: in the Route A.4 section, write a theorem block recording the Thm 3.2 sub-dependency + an honest deferral note (`% NOTE:`) flagging Auslander–Buchsbaum as a Mathlib gap requiring its own ~5-iter sub-build. The A.4 row in STRATEGY.md will be re-estimated by the planner accordingly.

### Outcome (c) — partial / both

If the audit reveals Milne's specific argument route in §6 admits a Picard-functoriality bypass for the EXISTENCE direction but NOT for the UNIQUENESS direction (or vice versa), document the split explicitly.

## Source

- `references/abelian-varieties.pdf` (Milne, *Abelian Varieties*, course notes 2008) — III §6 (Albanese universal property of `Pic⁰`/Jacobian, p. 104 per the project's reference summary).
- `references/kleiman-picard.pdf` — for Picard-functor functoriality context (FGA Explained).
- (Optional cross-check) Mumford *Abelian Varieties* §I.5 on theorem of the cube — for whether the cube re-enters the chain.

You may need to download `references/auslander-buchsbaum.pdf` if Outcome (b) materializes and you need to cite the formula's specific statement — your `--write-domain` authorizes `references/**`, so dispatch the `reference-retriever` child if needed.

## Required content for the Jacobian.tex A.4 update

1. Locate the existing Route A.4 section in `Jacobian.tex` (likely between L460-L500; verify by reading the file).
2. Replace whatever the current A.4 content is (a generic outline) with:
   - A clear `\textit{Source: Milne, Abelian Varieties, III §6, p.104.}` citation line.
   - A `% SOURCE QUOTE:` verbatim block quoting Milne's exact statement of the Albanese UP (read from `references/abelian-varieties.pdf`).
   - A `\begin{theorem}[Albanese universal property of Pic⁰]` block with `\label{thm:albanese_universal_property}` and `\lean{AlgebraicGeometry.Scheme.Pic.albaneseUP}` (project-bespoke).
   - A `\begin{proof}` block whose `\uses{}` annotation accurately enumerates the in-tree dependencies (Cor 1.5 + Cor 1.2 + Picard scheme + seesaw OR the Thm 3.2 sub-build + Lemma 3.3 + Auslander–Buchsbaum, depending on Outcome).
3. Add a `% NOTE:` LaTeX comment IMMEDIATELY before the theorem block recording:
   - The audit outcome (a / b / c).
   - The author of the audit (this writer).
   - One-sentence summary of the chain.

## Out of scope

- Do NOT touch other chapters.
- Do NOT add `\leanok` / `\mathlibok` markers (sync_leanok / review domain).
- Do NOT write a long proof — a 1-paragraph proof-sketch citing dependencies is sufficient; the chapter is for orientation, not formal proof.
- Do NOT modify STRATEGY.md (planner's domain).
- Do NOT modify the project's existing A.1/A.2/A.3 sub-sections in `Jacobian.tex` — only A.4 this iter.

## Verification

Verify the audit outcome before writing: open `references/abelian-varieties.pdf`, navigate to III §6 (~page 104), read the proof of the Albanese UP for `Pic⁰_X` of a smooth projective curve. Note which theorems Milne invokes by number, and check whether each is:
- In-tree as a proven axiom-clean lemma (Cor 1.5 / Cor 1.2 / Rigidity Lemma)?
- In Mathlib (Picard functor functoriality / seesaw / projection formula)?
- A gap (Thm 3.1/3.2 / Lemma 3.3 / Auslander–Buchsbaum)?

The audit verdict is your A.4 chapter content's `\uses{}` chain. Anything you cannot verify locally goes in a `% NOTE:` flagging the unresolved dependency.

## Expected outcome

A ~30-80 LOC update to `Jacobian.tex` Route A.4 section containing:
- A theorem block with `\lean{...}` pin for the Albanese UP.
- A `\uses{}` chain mapping the proof to in-tree + Mathlib dependencies (or flagging gaps).
- A `% NOTE:` recording the audit outcome.
- A `% SOURCE QUOTE:` verbatim from Milne III §6.

Time-budget: cap reading at ~10 minutes. If the audit can't be completed in that time, write a `% AUDIT PARTIAL:` placeholder + what you found and commit. Better a partial audit on disk than no audit.
