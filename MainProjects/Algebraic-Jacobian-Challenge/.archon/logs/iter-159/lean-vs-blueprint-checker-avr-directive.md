# Lean ↔ Blueprint Checker Directive

## Slug
avr-iter159

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex

## Known issues
- The lemmas `rigidity_lemma`, `rigidity_core`, `rigidity_eqOn_dense_open` are the route-(c)
  Rigidity-Lemma chain; the three scaffolds `morphism_P1_to_grpScheme_const`,
  `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme` are KNOWN deferred gaps
  (theorem-of-the-cube / Riemann–Roch). Do not re-report these as surprises.
- This iter (159) the prover: (a) added `[IsAlgClosed kbar]` to `rigidity_eqOn_dense_open`,
  `rigidity_core`, `rigidity_lemma`; (b) closed the internal `hfib` sorry inside
  `rigidity_eqOn_dense_open` (now sorry-free in its own body); (c) EXTRACTED the residual
  "bridge 2" (slice-constancy / affine-constancy) obligation into a NEW top-level helper
  `rigidity_eqOn_saturated_open_to_affine` whose body is `sorry`.

## What I specifically need verified
1. Does `AbelianVarietyRigidity.tex` have a blueprint block for the NEW helper
   `rigidity_eqOn_saturated_open_to_affine`? (The prover reported it has none yet.) If absent,
   flag the chapter as needing a block — this is the formal home of the "Bridge 2" prose.
2. Does the chapter's `\lean{...}` hint for `lem:rigidity_eqOn_dense_open` still match the
   current Lean signature now that `[IsAlgClosed kbar]` was added and the proof body changed?
3. Is the statement of `rigidity_eqOn_saturated_open_to_affine` faithful to the blueprint's
   "Bridge 2" prose (proper slice into affine ⟹ constant in the X-direction), or does it
   differ mathematically?
4. Confirm no laundering: the chapter must not claim `rigidity_eqOn_dense_open` /
   `rigidity_lemma` are fully proven when they transitively depend on the helper's `sorry`.
