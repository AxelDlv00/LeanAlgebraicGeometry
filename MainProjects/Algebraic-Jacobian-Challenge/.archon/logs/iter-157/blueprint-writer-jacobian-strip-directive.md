# Blueprint Writer Directive

## Slug
jacobian-strip

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Context
The committed genus-0 route-(c) AV-rigidity stack has been MOVED into its own new chapter
`blueprint/src/chapters/AbelianVarietyRigidity.tex`
(`\label{chap:AbelianVarietyRigidity}`, covers `AlgebraicJacobian/AbelianVarietyRigidity.lean`),
which is upstream of `Jacobian.lean` in the import graph. That new chapter now OWNS the
route-(c) blocks. `Jacobian.tex` currently still contains a DUPLICATE copy of those blocks in
its subsection `\subsection{Route (c)...}` `\label{sec:av_rigidity_route_c}` (the blocks
`thm:theorem_of_the_cube`, `lem:rigidity_theorem`, `cor:complete_product_to_AV_decomp`,
`lem:rational_map_to_AV_extends`, `prop:unirational_to_AV_constant`,
`prop:rigidity_genus0_curve_to_AV`, currently around lines 448–592). The duplicate labels
`thm:theorem_of_the_cube` and `prop:rigidity_genus0_curve_to_AV` now clash with the new
chapter, which must be fixed.

The new chapter's labels you may cross-reference (defined there):
`\cref{chap:AbelianVarietyRigidity}`, `thm:rigidity_lemma`, `thm:theorem_of_the_cube`,
`prop:morphism_P1_to_AV_constant`, `prop:genusZero_curve_iso_P1`,
`thm:rigidity_genus0_curve_to_AV` (with a carry-over alias `prop:rigidity_genus0_curve_to_AV`).

## Required content (the edits)
1. **Delete the entire `\subsection{Route (c)...}` `\label{sec:av_rigidity_route_c}`
   subsection** (the six duplicated route-(c) theorem/lemma/corollary/proposition blocks and
   their proofs). Replace it with a SHORT pointer paragraph: the committed genus-0 route (c)
   AV-rigidity stack is developed in its own chapter `\cref{chap:AbelianVarietyRigidity}`; the
   genus-0 arm consumes its headline `\cref{thm:rigidity_genus0_curve_to_AV}` (the char-free
   replacement for `thm:rigidity_over_kbar`). Keep a `\label{sec:av_rigidity_route_c}` on this
   short paragraph IF other prose still `\cref`s it, so existing references resolve; otherwise
   redirect those references (next item).
2. **Redirect every `\cref` in Jacobian.tex that pointed at a now-deleted route-(c) label**
   (the C.2.d sub-step item (c) ~line 397; C.2.g ~line 417; infrastructure-(γ) ~line 434; the
   `sec:genusZeroWitness` intro ~line 446; Layer I ~line 701; and the body-closure paragraph
   ~line 659) to the corresponding label in the new chapter:
   - the Milne-chain prose listing (`prop:unirational_to_AV_constant`,
     `lem:rational_map_to_AV_extends`, `cor:complete_product_to_AV_decomp`,
     `lem:rigidity_theorem`, `thm:theorem_of_the_cube`) → re-point to the new chapter's chain
     (`thm:rigidity_lemma` → `thm:theorem_of_the_cube` → `prop:morphism_P1_to_AV_constant` →
     `prop:genusZero_curve_iso_P1` → `thm:rigidity_genus0_curve_to_AV`), and to
     `\cref{chap:AbelianVarietyRigidity}` for the section reference.
   - Keep the mathematical claims correct: the committed route is route (c); the cube is
     REQUIRED (the base case `ℙ¹→A constant` rests on it — see the new chapter); the rigidity
     LEMMA is cube-free but not alone sufficient.
3. **Drop the spurious `\uses{thm:theorem_of_the_cube}`** on the old `lem:rigidity_theorem`
   block — that block is being deleted anyway, but ensure no surviving block in Jacobian.tex
   claims the Rigidity Lemma/Theorem `\uses` the cube (the Rigidity Lemma proof is cube-free).
4. **Land the live carry-over NOTE corrections** flagged by the blueprint-reviewer (iter157):
   - `def:genusZeroWitness` proof, the **Uniqueness** paragraph: replace the mathematically
     loose "universal property of the terminal object" justification with the SOUND
     epi-cancellation argument already used in the Existence paragraph just above (uniqueness
     of `g : 𝟙 → A` follows by right-cancelling the epimorphism `toUnit C` —
     `Flat.epi_of_flat_of_surjective` + `Over.epi_of_epi_left` + `cancel_epi` — NOT from
     terminality). The `% NOTE:` (1) gives the exact argument.
   - The descent sub-step **C.2.f**: it is currently billed "∼2 lines"; re-cost it honestly as
     a multi-iter base-change sub-build (no `Over (Spec k) → Over (Spec k̄)` functor exists in
     project or Mathlib; instance transfer + genus-stability + base-change-square identities
     all needed before the final `Flat.epi_of_flat_of_surjective` epi-cancellation). Update the
     prose at C.2.f, C.2.g, and infrastructure-(γ) where the "∼2 lines" framing appears.
5. **Import-cycle honesty:** wherever the prose describes `genusZeroWitness` consuming
   `rigidity_over_kbar` "directly", correct it: the consumed declaration is now the new
   upstream `thm:rigidity_genus0_curve_to_AV` (in `AbelianVarietyRigidity.lean`, imported by
   `Jacobian.lean`); the old `rigidity_over_kbar` lives downstream in `RigidityKbar.lean` and
   is the fallback-(a) artifact, NOT consumed by `genusZeroWitness`.

## Out of scope
- Do NOT edit `AbelianVarietyRigidity.tex` or `RigidityKbar.tex` (other writers/plan-agent own
  them) or `content.tex`.
- Do NOT add/remove `\leanok` / `\mathlibok` markers.
- Do NOT touch the protected-signature declarations' statements.
- Do NOT develop Route A representability here.

## References
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` — READ to confirm the new chapter's
  exact labels before redirecting crefs.
- The `% NOTE:` comments already present in `def:genusZeroWitness` give the exact corrections
  for item 4.
