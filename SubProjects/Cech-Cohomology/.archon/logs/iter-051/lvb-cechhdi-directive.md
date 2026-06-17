# Lean ↔ blueprint check — CechHigherDirectImage.lean

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(Consolidated chapter `% archon:covers` this file — see header.)

## What to verify
Bidirectional, narrow file-vs-chapter view.

1. The blueprint lemma `lem:cech_augmented_resolution` (chapter line ~6979) is `\lean{}`-pinned by
   `AlgebraicGeometry.cechAugmented_exact`. THIS DECLARATION DOES NOT EXIST in the Lean file yet —
   the prover built the augmented-complex OBJECT layer but NOT the exactness theorem (blocked on a
   genuine Mathlib gap: no stalkwise-exactness criterion for `X.Modules` complexes). Confirm the
   `\lean{}` pin points at a not-yet-existing decl (aspirational), and assess whether the blueprint
   block should be split into "object (built) + exactness (pending)".

2. These NEW Lean decls were added this iter and have NO blueprint block yet (coverage debt; report
   as blueprint→Lean gaps): `cechComplexOnX`, `cechNervePointIso`, `cechAugmentation`,
   `cechAugmentation_comp_d`, `cechAugmentedComplex`, and private
   `augmentation_comp_alternatingCofaceMap_objD_zero`. For each, note what it is and what its Lean
   proof depends on (read the source), so the planner can blueprint them.

3. Confirm the existing `lem:cech_augmented_resolution` proof sketch (stalk-at-prime, "one fᵢ is a
   unit" contracting homotopy) is detailed enough to guide the pending exactness proof — OR flag that
   it omits the missing-infrastructure steps (the stalkwise-exactness reflection for `X.Modules`)
   the Lean clearly needs.

Report Lean→blueprint AND blueprint→Lean findings with must-fix severity tags.
