# AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean

## Overall verdict — NO LEAN EDITS THIS ITER (documented sketch instead)

PROGRESS.md iter-182 lists this file under **Off-limits this iteration** with
rationale **"Mathlib-gap scaffolds"**. Both sorries are well-documented
Mathlib gaps (re-confirmed by exhaustive Mathlib search this iter) and require
~150-350 LOC of new infrastructure each. They are NOT on any iter-182 lane.

Per the prover prompt's `When infrastructure is missing` section
(steps 1-3), the disciplined move is to:

1. Confirm the Mathlib gap (DONE — search log below).
2. NOT degrade the existing structured `sorry`-with-rich-docstring scaffolds.
3. Write proof-route sketches to `informal/<theorem>.md` (DONE — two files).
4. Document this in the task_result so the next planner can route to a
   dedicated lane.

`lake build AlgebraicJacobian.Genus0BaseObjects.BareScheme` GREEN; 2 sorries
(L154 + L161, both bare scaffold-sorries with multi-line rationale docstrings).
The Lean file is unchanged this iter.

---

## projectiveLineBar_geomIrred (L154)

### Attempt 1
- **Approach**: Search Mathlib for `GeometricallyIrreducible` on `Proj` or `ProjectiveSpace`.
- **Result**: FAILED — `Mathlib/AlgebraicGeometry/Geometrically/Irreducible.lean`
  defines the class but ships no instance for any `Proj _`. Search of
  `.lake/packages/mathlib/Mathlib/AlgebraicGeometry/ProjectiveSpectrum/`
  finds zero hits on `GeometricallyIrreducible`. Confirmed via:
  - `lean_leansearch "projective line is geometrically irreducible"`
  - `lean_local_search GeometricallyIrreducible` (3 hits — class def + 2
    structural lemmas, nothing constructive for `Proj`)
  - `grep -r GeometricallyIrreducible Mathlib/AlgebraicGeometry/ProjectiveSpectrum/`
- **Sketch**: see `informal/projectiveLineBar_geomIrred.md`. Plan is
  Helper A (`Proj 𝒜 ⊗ K ≅ Proj 𝒜 ×_S Spec K`) + Helper B (re-parameterise
  the `ChartIso` infrastructure over an arbitrary field) + Helper C
  (`IsDomain K[T] ⟹ IrreducibleSpace (Spec K[T])`) + Helper D
  (two-chart irreducibility-from-cover lemma) + Helper E (chart intersection
  nonemptiness) + Final assembly. ETA ~200-350 LOC across iter-183+.
- **Risk flagged**: Helper A is genuinely hard (base-change distributes
  over `Proj`); there is NO Mathlib lemma for this in the form needed.
- **Alternative ruled out**: `Algebra.IsGeometricallyReduced` (the
  `tensor-with-AlgebraicClosure-is-reduced` variant) does NOT substitute
  because downstream `iotaGm_isDominant` consumes `GeometricallyIrreducible`
  specifically.

---

## projectiveLineBar_smoothOfRelDim (L161)

### Attempt 1
- **Approach**: Search Mathlib for `SmoothOfRelativeDimension n` on `Proj`,
  on `ProjectiveSpace`, or on any concrete `Spec` of a polynomial ring.
- **Result**: FAILED — `Mathlib/AlgebraicGeometry/Morphisms/Smooth.lean`
  defines the class but ships no concrete instance beyond `IsOpenImmersion ⟹
  SmoothOfRelativeDimension 0`. No `Algebra.IsStandardSmoothOfRelativeDimension R (MvPolynomial σ R)`
  lemma exists. Confirmed via:
  - `lean_local_search SmoothOfRelativeDimension` (2 hits — class + reduction
    to `Smooth`)
  - `lean_local_search IsStandardSmoothOfRelativeDimension` (14 hits — all
    structural; nothing for `MvPolynomial` or `Polynomial`)
  - `lean_loogle "Algebra.IsStandardSmoothOfRelativeDimension _ _ (MvPolynomial _ _)"` — empty
  - `grep -r "MvPolynomial.*StandardSmooth\|StandardSmooth.*MvPolynomial" .lake/packages/mathlib` — no matches
  - `grep -r "SmoothOfRelativeDimension" .lake/packages/mathlib/Mathlib/AlgebraicGeometry/ProjectiveSpectrum/` — no matches
- **Sketch**: see `informal/projectiveLineBar_smoothOfRelDim.md`. Plan is
  Helper 1 (`SubmersivePresentation k (MvPolynomial Unit k) Empty Unit` — by-hand) +
  Helper 2 (extract `IsStandardSmoothOfRelativeDimension 1` instance) + Helper 3
  (transfer via `homogeneousLocalizationAwayIso` already in
  `Genus0BaseObjects/ChartIso.lean:328`) + Helper 4 (chart sheaf-section iso
  threading) + Final (per-point witness via `projectiveLineBarAffineCover`).
  ETA ~150-250 LOC iter-183+.
- **Key existing assets**: `homogeneousLocalizationAwayIso` (`ChartIso.lean:328`)
  and `homogeneousLocalizationAwayIso_algebraMap` (`ChartIso.lean:347`) provide
  the chart-iso AND the `k̄`-algebra preservation lemma, so Helper 3 is
  well-supported. `projectiveLineBarAffineCover` (`BareScheme.lean:197`)
  provides the per-point chart-finding.
- **Risk flagged**: the upgrade `RingEquiv ⟶ AlgEquiv` needed for
  `Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv` is the messy bit
  but the existing `homogeneousLocalizationAwayIso_algebraMap` lemma is the
  exact statement needed.

---

## Recommendation for plan agent (iter-183+)

These are the right move *whenever the project routes through this file*,
not iter-183 (other lanes have higher leverage):

1. **Smoothness lane (~150-250 LOC, ~2-3 iters)**: open
   `AlgebraicJacobian/Genus0BaseObjects/AffineLineSmooth.lean` (new file)
   to host Helpers 1+2; land Helper 3 in `ChartIso.lean` extensions; land
   Helpers 4 + Final in `BareScheme.lean` proper. Coordinate with
   smoothness-using callers (`Albanese/CodimOneExtension`, `Jacobian.lean`
   `positiveGenusWitness`).
2. **GeomIrred lane (~200-350 LOC, ~3-5 iters)**: prerequisite — generalise
   `BareScheme.lean` + `ChartIso.lean` over an arbitrary field (Helper B).
   This is the load-bearing refactor; once landed, Helpers C-E + Final are
   routine. **Reach lane** — schedule only if `iotaGm_isDominant` or other
   `GeometricallyIrreducible (ProjectiveLineBar _).hom` consumer becomes
   blocking; until then leave the `sorry` documented as it is.

If the project never routes through `GeometricallyIrreducible (ProjectiveLineBar _).hom`
(plausible — most downstream uses go through `IrreducibleSpace` directly,
not the geometric variant), iter-183+ planner may consider whether to keep
this instance at all, or relax the file to expose only the unparam'd
`IrreducibleSpace` version.

---

## Lemmas / API discovered

- **`homogeneousLocalizationAwayIso` + `_algebraMap`** (`ChartIso.lean:328, 347`) —
  the chart-ring iso for `Away 𝒜 (X i) ≅+* MvPolynomial Unit k̄` with
  `k̄`-algebra-map preservation. Both load-bearing for the smoothness sketch.
- **`Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv`** (`RingTheory/Smooth/StandardSmooth.lean`) —
  the right transfer lemma. Needs an `AlgEquiv`.
- **`Algebra.SubmersivePresentation.ofBijectiveAlgebraMap`** (`Submersive.lean:523`) —
  the construction template for the dim-0 case. The dim-1 case (free `R[T]`
  over `R`) is **not** shipped; needs custom construction.
- **`Proj.affineOpenCoverOfIrrelevantLESpan`** (already in `Mathlib`,
  threaded into `projectiveLineBarAffineCover`) — provides the per-chart
  affine open + sheaf section identification needed by Final assembly of
  smoothness.
- **`AlgebraicGeometry.GeometricallyIrreducible.iff_geometricallyIrreducible_fiber`** —
  the fiber-reduction lemma for the geom-irred sketch. Reduces the
  field-extension quantifier to fibers `f.fiberToSpecResidueField s`.

## Dead-end log

- **Search "IsStandardSmoothOfRelativeDimension MvPolynomial"**: empty.
- **Search "Proj.GeometricallyIrreducible" / "Proj.IrreducibleSpace"**: empty.
- **Search "ProjectiveSpace.smooth" / "ProjectiveSpace.geometricallyIrreducible"**: empty.
- **`MvPolynomial.standardSmooth` / `Polynomial.standardSmooth`**: do not exist.

## Note for next iter

PROGRESS.md should keep this file under `## Off-limits this iteration`
unless the smoothness/geom-irred sketches above are explicitly chosen as a
dedicated iter-183+ lane (with the LOC budget allocated). No prior
task_result for this file (it's never been actively worked) — the planner
is correctly leaving it as a Mathlib-gap scaffold pending a real lane.
