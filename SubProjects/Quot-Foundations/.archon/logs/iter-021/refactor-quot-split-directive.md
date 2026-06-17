# Refactor directive — QUOT file-split + de-private (iter-021)

Honor the standing user PARALLELISM directive: split the large `QuotScheme.lean` (1696 lines) into two
semantically-distinct files so future provers can work the graded-Hilbert–Serre layer and the
Quot/Grassmannian-defs layer in parallel. This is a pure structural MOVE — do NOT fill any sorry, do NOT
change any signature, do NOT rename any declaration or label.

## Target
`AlgebraicJacobian/Picard/QuotScheme.lean` → split into:
- `AlgebraicJacobian/Picard/QuotScheme.lean` (KEEPS the Quot/Grassmannian/predicate layer)
- `AlgebraicJacobian/Picard/GradedHilbertSerre.lean` (NEW — the graded-Hilbert–Serre rationality layer)

## What MOVES to GradedHilbertSerre.lean
The entire final `namespace AlgebraicGeometry` block that contains the graded-Hilbert–Serre machinery:
- the `IsRatHilb` toolkit (`coeff_invOneSubPow_one_mul`, `rationalHilbert_antidiff`, `IsRatHilb` and its
  closure lemmas `ofEventuallyZero`/`bump`/`sub`/`shiftRight`/`antidiff`/`ofDiffEq`), currently starting
  at the second `namespace AlgebraicGeometry` (~line 427, `private lemma coeff_invOneSubPow_one_mul`);
- the entire `namespace GradedModule` block (all G1/D5/D6/Subquotient/Induction machinery through the
  keystone `gradedModule_hilbertSeries_rational`, ~line 1651) to end of file.
Read the file to find the exact split line: everything from the start of that final
`namespace AlgebraicGeometry` (the `open PowerSeries Polynomial in` / `private lemma
coeff_invOneSubPow_one_mul` cluster) through EOF moves. Everything BEFORE it stays.

## What STAYS in QuotScheme.lean
- `namespace Scheme` with the four PROTECTED stubs `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`,
  `Grassmannian.representable` (signatures FROZEN — see archon-protected.yaml; do not touch);
- `namespace SheafOfModules` (`IsLocallyFreeOfRank`);
- `namespace Scheme.Modules` (`annihilator`, `annihilator_ideal_le`, `schematicSupport`,
  `schematicSupportι`, `HasProperSupport`);
- `namespace Module` (`annihilator_isLocalizedModule_eq_map`).

## De-privatization (do this DURING the move)
Remove the `private` modifier from EVERY moved declaration that currently carries it — the IsRatHilb
toolkit (`coeff_invOneSubPow_one_mul`, `rationalHilbert_antidiff`, `IsRatHilb`, and all six closure
lemmas) AND the two GradedModule helpers `finrank_comap_subtype` and `iSupIndep_map_of_mem_ker_sup`.
Their public qualified names (`AlgebraicGeometry.IsRatHilb`, `AlgebraicGeometry.GradedModule.finrank_comap_subtype`,
`AlgebraicGeometry.GradedModule.iSupIndep_map_of_mem_ker_sup`, etc.) are pinned in the blueprint and must
resolve for `sync_leanok`. Names/namespaces/signatures stay EXACTLY as written — only the `private`
keyword is dropped. (This clears the recurring M1 hygiene debt for the QUOT toolkit.)

## Stale-comment removal
Inside `subquotient_base_eventuallyZero` (moved to GradedHilbertSerre.lean), delete the stale comment
block currently at QuotScheme.lean lines ~1510–1519 — the "(RESIDUAL LEAF — the only `sorry` in the QUOT
keystone chain)" / "OBSTRUCTION: building the κ-linear `Φ` … `Submodule.liftQ` clashes on the scalar
ring …" paragraph. The proof below it is complete and sorry-free; the comment is factually wrong (flagged
major by both the lean-auditor and the lean-vs-blueprint checker iter-020). Remove it cleanly.

## Imports / wiring
- `GradedHilbertSerre.lean`: head with `import Mathlib` (mirror QuotScheme's current import) + the same
  `open CategoryTheory Limits` / `open PowerSeries Polynomial` opens the moved code needs, and the
  `namespace AlgebraicGeometry` wrapper.
- `QuotScheme.lean`: if NO remaining declaration references a moved declaration (expected — the four
  stubs are `:= sorry` and the predicate/annihilator defs are independent), do NOT add an import of the
  new file. If some remaining decl DOES reference a moved one, add `import AlgebraicJacobian.Picard.GradedHilbertSerre`.
- Root `AlgebraicJacobian.lean`: add `import AlgebraicJacobian.Picard.GradedHilbertSerre` alongside the
  existing leaf imports so the new module is in the build graph.
- `archon-protected.yaml`: the four protected stubs STAY in QuotScheme.lean — no path change needed; do
  not edit the YAML.

## Verification (required)
`lake build AlgebraicJacobian.Picard.GradedHilbertSerre` and `lake build AlgebraicJacobian.Picard.QuotScheme`
must both succeed (the only `sorry`s afterwards: the 4 protected stubs in QuotScheme.lean; ZERO in
GradedHilbertSerre.lean — the keystone chain is axiom-clean). Report the exact final sorry inventory per
file and confirm the keystone `gradedModule_hilbertSeries_rational` remains axiom-clean post-move.
