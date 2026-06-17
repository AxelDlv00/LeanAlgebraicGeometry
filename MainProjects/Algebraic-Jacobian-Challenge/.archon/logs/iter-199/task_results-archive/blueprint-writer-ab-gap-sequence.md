# Blueprint Writer Report

## Slug
ab-gap-sequence

## Status
COMPLETE (with one directive item deliberately deferred — see Notes for Plan Agent).

## Target chapter
blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex

## Changes Made
- **Added subsection** `\subsection{Inductive-step substrate: per-gap
  decomposition of pd(M)=k+1}` / `\label{subsec:succ_pd_gap_sequence}`
  immediately after the `lem:depth_drops_by_one` proof block and
  before `\section{Corollary: regular local rings are
  Cohen--Macaulay}`. The new subsection logically sits under
  `\section{The Auslander--Buchsbaum formula}` (sec:ab_main), the
  same parent section that hosts
  `lem:auslander_buchsbaum_formula_succ_pd` and
  `lem:depth_drops_by_one`.
- The subsection contains the four directive-required components:
  1. A prose intro stating the 3-remaining-gap structure and the
     gap (1) → gap (3) sequencing constraint.
  2. An ASCII-style dependency diagram (`\begin{verbatim}` block)
     showing gap (1) → gap (3) → closure assembly, with gap (2)
     feeding the closure independently and gap (4) marked CLOSED
     and pointing at `lem:depth_drops_by_one`.
  3. A `\begin{tabular}` per-gap table with columns:
     Gap | Statement | LOC est. | Iters | Mathlib status | Depends on.
     Rows for gaps (1), (2), (3), (4) with the LOC / iter / status /
     dependency data from the directive.
  4. A "Closure assembly" paragraph with five-step assembly
     (a)–(e) describing how gaps (1)+(2)+(3)+(4) compose into the
     ~80–120 LOC body of `lem:auslander_buchsbaum_formula_succ_pd`.
  5. An "Iter budget refinement" paragraph aggregating to **5–8 iters
     sequential / 3–5 iters parallel-best**, explicitly noting this
     refines the prior `~6–12 iters` STRATEGY.md figure.
- Cross-references to the existing helpers: the new subsection uses
  `\cref{lem:auslander_buchsbaum_formula_succ_pd}` (the L1299 target)
  and `\cref{lem:depth_drops_by_one}` (the iter-198 closure) so the
  gap (4) = CLOSED status is visible alongside the gaps (1)–(3) =
  ABSENT entries.

LOC added: file grew 692 → 833 lines = **+141 LOC** of new content
(includes the verbatim diagram, the LaTeX table, four `\paragraph{}`
blocks of prose, and the `\subsection` + `\label`).

Line range of new content: blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
**L490–L629** (between the close of the `lem:depth_drops_by_one`
proof block at L488 and the start of the
`\section{Corollary: regular local rings are Cohen--Macaulay}`
at L631).

## Cross-references introduced
- `\cref{lem:auslander_buchsbaum_formula_succ_pd}` — used twice;
  target exists in this chapter at L417.
- `\cref{lem:depth_drops_by_one}` — used twice; target exists in
  this chapter at L465.
- No new `\uses{...}` lines (the new subsection is descriptive
  prose, not a declaration block — `\uses` clauses go inside
  `\begin{theorem}`/`\begin{lemma}` environments).

## References consulted
- No external `references/<file>.md` files were opened for the new
  content. The new subsection is **Archon-original analysis** of the
  project's gap structure, LOC estimates, and iter sequencing
  constraint — it does not derive from a single external source, so
  no `% SOURCE:` / `% SOURCE QUOTE:` blocks were required. The
  directive itself authorises this: "the gap (3) details + Stacks
  00MF assembly logic should be left at the level of 'what is
  needed; iter-N+ targets' without speculative Lean API hints."
- Two textbook references are cited *inline* (as `\emph{...}`
  attributions in prose) to anchor the LOC estimates: Bruns–Herzog,
  *Cohen–Macaulay Rings*, Construction 1.5.18 + §1.5 (for gap (1));
  Bruns–Herzog Theorem 1.4.13 + Eagon–Northcott +
  Buchsbaum–Eisenbud (for gap (2)). The directive explicitly
  permits citing Bruns–Herzog "by chapter/section only" since no
  local `references/bruns-herzog.*` summary exists in this project
  (`ls references/` confirms this — closest available local
  commutative-algebra references are `stacks-algebra.md`,
  `matsumura-commutative-ring-theory.md`, and
  `atiyah-macdonald-commutative-algebra.md`). These inline
  attributions are *not* verbatim quote blocks (no `% SOURCE:` /
  `% SOURCE QUOTE:` formalism) — they are scope-anchor prose,
  matching the directive's "at the level of 'what is needed'"
  instruction.

## Macros needed (if any)
- None. `\texorpdfstring`, `\paragraph`, `\subsection`, `\cref`,
  `\begin{verbatim}`, `\begin{tabular}`, and `\textbf` are all
  either part of standard LaTeX or already loaded by the project's
  preamble (which the existing chapter relies on — see the prior
  use of `\cref` in the `lem:auslander_buchsbaum_formula_succ_pd`
  block at L424).

## Reference-retriever dispatches (if any)
- None dispatched. No external retrieval was needed because the
  new subsection is project-internal planning prose (gap structure,
  LOC estimates, iter sequencing) rather than a derivation from an
  external source. The directive scoped it that way explicitly.

## Notes for Plan Agent

1. **Directive step 2 (stale block-internal references at L388–L412)
   deliberately skipped.** The directive's required edits include:

   > 2. Update the stale block-internal references: The existing
   >    chapter prose (proof block of `thm:auslander_buchsbaum`
   >    inductive step, L388-L412 area) references "Lemma REF"
   >    placeholders for gap (2). Refresh these to point at the new
   >    `subsec:succ_pd_gap_sequence` block by name (e.g.
   >    `\cref{subsec:succ_pd_gap_sequence}`).

   This conflicts directly with the directive's "Out-of-scope"
   ruling:

   > Do NOT touch the existing `lem:auslander_buchsbaum_formula_succ_pd`
   > block, `lem:depth_drops_by_one` block, or the main
   > `thm:auslander_buchsbaum` theorem block. Append the new
   > subsection AFTER the existing material.

   The L388–L412 line range cited in step 2 falls **inside** the
   `\begin{proof}` ... `\end{proof}` environment of
   `thm:auslander_buchsbaum` (its inductive-step paragraph, between
   L388 "We claim there exists \(x \in \mathfrak{m}\)..." and L412
   "as required."). Editing those lines requires touching the
   "main `thm:auslander_buchsbaum` theorem block" that the
   out-of-scope clause explicitly forbids.

   I followed the **stricter** rule (out-of-scope wins) on the
   basis that the writer-descriptor enforces directive-out-of-scope
   ruling at the file level, and that touching the main theorem's
   proof body risks introducing prose-vs-Stacks-quote divergence
   inside an established `% SOURCE QUOTE PROOF:` citation block
   (L298–L354). The "Lemma REF" placeholders are pre-existing — they
   were already in the chapter as of iter-198 — so leaving them
   unchanged does not introduce a regression; it just doesn't
   improve them this round.

   **Recommended plan-agent action next iter:** if the planner
   considers the placeholder cleanup high-value, dispatch a *separate*
   writer round with an explicit override of the out-of-scope clause
   for those four lines (`L379`, `L383`, `L394`, possibly one more)
   — or fold the cleanup into the iter-200+ writer that closes gap
   (2). I did not silently override the out-of-scope clause.

2. **The same "Lemma REF" pattern also appears at L379**
   ("applying Lemma~REF iteratively") in the **base case** of
   `thm:auslander_buchsbaum`'s proof, not just the inductive-step
   paragraph the directive cited. If the plan agent later authorises
   the placeholder refresh, the base-case reference at L379 should
   probably be refreshed to point at `\cref{lem:depth_short_exact_sequence}`
   (the depth-on-SES lemma whose name actually fits at that
   reference site), not at `subsec:succ_pd_gap_sequence` — the
   directive's mapping to `subsec:succ_pd_gap_sequence` applies to
   the inductive-step references, not to the base-case ones. Flagging
   this so a future writer round doesn't blanket-replace L379
   incorrectly.

3. **The `\label{subsec:succ_pd_gap_sequence}` is now a chapter
   anchor.** Future blueprint-doctor runs that scan for orphan
   `\ref` / `\cref` targets should find it. If the plan agent wires
   the iter-200 dispatch to gap (1), (2), or (3) prover lanes, the
   prover-mode prompts (and any new chapter-side `\uses{...}` lines
   added by a future writer round) can `\cref{subsec:succ_pd_gap_sequence}`
   as the canonical pointer to the per-gap budget table.

4. **No `\leanok` / `\mathlibok` markers were added** in keeping
   with the writer descriptor.

## Strategy-modifying findings

*None.* The new subsection does not surface any strategy-level
issue. The 5–8 iter (sequential) / 3–5 iter (parallel-best)
budget *refines* the existing STRATEGY.md "~6–12 iters" estimate
but does not contradict it. The gap (1) → gap (3) sequencing
constraint was the load-bearing fact the directive asked to make
explicit; it is now explicit in the chapter without altering the
strategy itself. If the plan agent wants to propagate the
refined budget into STRATEGY.md, that is a STRATEGY.md edit
(plan-agent domain), not a strategy-modifying surprise from this
chapter's prose.
