# Blueprint Writer Report

## Slug
jacobian-strip

## Status
COMPLETE — all five directive items landed; chapter is balanced LaTeX with no broken
cross-references; no fabricated citations introduced.

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Changes Made

### Item 1 — Deleted the duplicate Route-(c) subsection
- **Deleted** the entire `\subsection{Route (c)...}` `\label{sec:av_rigidity_route_c}`
  body (the six duplicated blocks `thm:theorem_of_the_cube`, `lem:rigidity_theorem`,
  `cor:complete_product_to_AV_decomp`, `lem:rational_map_to_AV_extends`,
  `prop:unirational_to_AV_constant`, `prop:rigidity_genus0_curve_to_AV` and their proofs,
  ~145 lines incl. their verbatim Milne `% SOURCE QUOTE`s).
- **Replaced** with a short two-paragraph pointer that (a) states the route-(c) stack now
  lives in `\cref{chap:AbelianVarietyRigidity}` (upstream in the import graph, breaking the
  `RigidityKbar→Rigidity→Jacobian` cycle) and (b) walks the new chapter's four-link chain
  `thm:rigidity_lemma` → `thm:theorem_of_the_cube` → `prop:morphism_P1_to_AV_constant` →
  `prop:genusZero_curve_iso_P1` → `thm:rigidity_genus0_curve_to_AV`. **Kept**
  `\label{sec:av_rigidity_route_c}` on the pointer (harmless anchor; resolves any external
  reference even though all in-chapter crefs to it were redirected).
- This resolves the duplicate-label clash: `\label{thm:theorem_of_the_cube}` and
  `\label{prop:rigidity_genus0_curve_to_AV}` no longer exist in Jacobian.tex (verified 0
  matches); they now live solely in the new chapter.

### Item 2 — Redirected crefs that pointed at now-deleted route-(c) labels
- **C.2.d item (c)** (Milne-chain listing): re-pointed `prop:unirational_to_AV_constant`,
  `lem:rational_map_to_AV_extends`, `cor:complete_product_to_AV_decomp`,
  `lem:rigidity_theorem`, `thm:theorem_of_the_cube` → the new chain
  (`prop:genusZero_curve_iso_P1`, `prop:morphism_P1_to_AV_constant`, `thm:rigidity_lemma`,
  `thm:theorem_of_the_cube`, `thm:rigidity_genus0_curve_to_AV`) + `chap:AbelianVarietyRigidity`.
- **C.2.g**, **infrastructure-(γ)**, **sec:genusZeroWitness intro**, **body-closure**,
  **Layer I**: replaced `prop:unirational_to_AV_constant` / `prop:rigidity_genus0_curve_to_AV`
  citations with `prop:morphism_P1_to_AV_constant` / `thm:rigidity_genus0_curve_to_AV` and
  `chap:AbelianVarietyRigidity`.
- Kept the math correct per directive: the cube is REQUIRED (base case `ℙ¹→A` constant rests
  on it); the Rigidity Lemma is cube-free but not alone sufficient — stated explicitly in the
  pointer, item (c), C.2.g and (γ).

### Item 3 — No surviving block claims the Rigidity Lemma `\uses` the cube
- The spurious `\uses{thm:theorem_of_the_cube}` lived on the deleted `lem:rigidity_theorem`
  block; it is gone with the deletion. Grep confirms no surviving `lem:rigidity_theorem`
  reference and no Jacobian.tex block asserts a Rigidity-Lemma→cube dependency.

### Item 4 — Live carry-over NOTE corrections landed
- **Uniqueness paragraph** of `def:genusZeroWitness`: replaced the loose "universal property
  of the terminal object" justification with the sound epi-cancellation argument — right-cancel
  `α = toUnit C` whose underlying `C.hom` is faithfully flat + surjective hence epi
  (`Over.toUnit_left` + `Flat.epi_of_flat_of_surjective` + `Over.epi_of_epi_left` +
  `cancel_epi`), the SAME argument as Existence; added the explicit caveat that terminality
  gives uniqueness only of morphisms INTO `𝟙`, not out of it.
- **C.2.f re-cost**: rewrote the "∼2-line" framing — only the final epi-cancellation is short;
  the descent as a whole is a multi-iteration base-change sub-build (no
  `Over (Spec k) → Over (Spec k̄)` functor exists in project or Mathlib; needs (a) that functor,
  (b) instance transfer, (c) genus-stability, (d) base-change-square identities). Propagated the
  honest re-costing to **C.2.g**, **infrastructure-(γ)**, the **C.2-status bullet**, and
  **Layer I**.

### Item 5 — Import-cycle honesty
- Everywhere the prose had `genusZeroWitness` consuming `rigidity_over_kbar` "directly", the
  consumed declaration is now the upstream char-free `thm:rigidity_genus0_curve_to_AV`
  (`AbelianVarietyRigidity.lean`, imported by `Jacobian.lean` → no cycle). `rigidity_over_kbar`
  (`RigidityKbar.lean`, still carrying `[CharZero]`) is consistently relabelled the fallback-(a)
  artifact, NOT consumed by `genusZeroWitness`. Updated: chapter intro (L6),
  `nonempty_jacobianWitness` proof `\uses` + prose, C.2.f, C.2.g, (α), (γ), C.2-status,
  `sec:genusZeroWitness` intro, `genusZeroWitness` statement `\uses` + proof `\uses` + body +
  closure, `positiveGenusWitness` intro, Layer I.

## Cross-references introduced
- `\cref{chap:AbelianVarietyRigidity}`, `thm:rigidity_genus0_curve_to_AV`,
  `prop:morphism_P1_to_AV_constant`, `prop:genusZero_curve_iso_P1`, `thm:rigidity_lemma`,
  `thm:theorem_of_the_cube` — all verified present in
  `blueprint/src/chapters/AbelianVarietyRigidity.tex` (read this session).
- `thm:rigidity_over_kbar`, `chap:RigidityKbar`, `sec:RigidityKbar_shared_pile` — unchanged
  targets (RigidityKbar.tex, not edited).
- LaTeX balance check passes (begin/end counts equal across all environments); 0 in-chapter
  crefs to deleted labels; `sec:av_rigidity_route_c` label retained.

## References consulted
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` — read to confirm the exact label names
  before redirecting every cref (chap label, the four chain links, the headline + its
  carry-over alias `prop:rigidity_genus0_curve_to_AV`).
- `blueprint/src/chapters/Jacobian.tex` — the target.
- No `references/**` files opened: this round added **zero** new `% SOURCE:` / `% SOURCE QUOTE:`
  citation blocks (the citation-bearing blocks were DELETED, not authored; the pointer paragraph
  is Archon-original cross-reference prose). No citation-discipline obligation incurred.

## Macros needed (if any)
- None. (The new chapter locally `\providecommand`s `\fatsemi`; Jacobian.tex does not use it.)

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- **I removed the four `% NOTE:` comment blocks** (iter-155/iter-156 carry-overs, lines
  ~618–656 of the pre-edit file) inside `def:genusZeroWitness`, because the directive (item 4 +
  item 5) asked me to LAND their corrections and leaving stale "a blueprint-writer should do X"
  notes after doing X is misleading. `% NOTE:` is nominally the review agent's domain — flagging
  here so the reviewer knows the notes were consumed deliberately, not lost.
- `sec:av_rigidity_route_c` now has **0 in-chapter crefs** (all redirected to
  `chap:AbelianVarietyRigidity`). I kept the `\label` per directive item 1 in case another
  chapter references it; if a global grep shows no external user, the planner may drop the label
  in a later pass. (I did not check non-blueprint consumers.)
- The `prop:rigidity_genus0_curve_to_AV` alias label still exists in the new chapter; I pointed
  the body-closure cref at the primary `thm:rigidity_genus0_curve_to_AV` instead, so the alias is
  now unused from Jacobian.tex.

## Strategy-modifying findings
- None. The pivot (route (c) is committed; cube is load-bearing for the ℙ¹ base case; descent is
  a multi-iter base-change sub-build; rigidity stack relocated upstream of Jacobian) was already
  decided and recorded in the new chapter and the directive; this round only aligns Jacobian.tex
  prose to it.
