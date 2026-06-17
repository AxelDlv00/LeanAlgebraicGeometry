# AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean

## Summary
- **5 new axiom-clean declarations added** (Mathlib supplement substrate):
  - `mvPolyGenerators` (L165) — canonical Generators of `MvPolynomial α R`.
  - `mvPolyPresentation` (L173) — Presentation with `σ = PEmpty` (no relations).
  - `mvPolyPreSubmersivePresentation` (L187) — PreSubmersive with empty `map`.
  - `mvPolySubmersivePresentation` (L196) — SubmersivePresentation; jacobian = det of 0×0 matrix = 1.
  - `mvPolynomialFin_isStandardSmoothOfRelativeDimension` (L207) — instance
    `Algebra.IsStandardSmoothOfRelativeDimension n R (MvPolynomial (Fin n) R)`.
- **1 structural reduction landed** for the smoothness sorry:
  - `projectiveLineBar_smooth_chart_aux` (L316) carves the per-chart gap.
  - `projectiveLineBar_smoothOfRelDim` (L325) now uses `IsZariskiLocalAtSource.of_openCover` axiom-clean,
    delegating to the focused per-chart aux.
- **Sorry count**: 2 → 2 (qualitative refinement: bare → focused per-chart gap on smoothness;
  geomIrred remains bare).
- **Build**: GREEN; full `lake build` passes (8361 jobs).
- **Axiom-cleanliness**: all 5 substrate declarations verify as
  `{propext, Classical.choice, Quot.sound}`.

## Session summary
- Built axiom-clean: `mvPolyGenerators`, `mvPolyPresentation`,
  `mvPolyPreSubmersivePresentation`, `mvPolySubmersivePresentation`,
  `mvPolynomialFin_isStandardSmoothOfRelativeDimension` (lines 165–211).
- Structural reduction: `projectiveLineBar_smoothOfRelDim` (L325) now uses
  the 2-chart cover + `IsZariskiLocalAtSource.of_openCover` axiom-clean,
  delegating to `projectiveLineBar_smooth_chart_aux` (L316).
- Blocked on: `projectiveLineBar_smooth_chart_aux` body — needs chart-ring iso
  `MvPolynomial (Fin 1) kbar ≃ₐ[kbar] HomogeneousLocalization.Away 𝒜 X_i`
  which lives in `ChartIso.lean` (downstream of BareScheme).
- Blocked on: `projectiveLineBar_geomIrred` — Mathlib does not ship
  base-change-of-Proj infrastructure; ~200-350 LOC substrate gap unchanged from iter-182.

## mvPolyGenerators / mvPolyPresentation / mvPolyPreSubmersivePresentation / mvPolySubmersivePresentation / mvPolynomialFin_isStandardSmoothOfRelativeDimension (lines 165–211)
- **Approach:** Direct construction from `Algebra.Generators.ofSurjective` (val := `X`)
  + naive Presentation with empty relations
  + PreSubmersive with empty `map : PEmpty → α`
  + SubmersivePresentation with Jacobian = det of empty matrix = 1.
  Final: `SubmersivePresentation.isStandardSmoothOfRelativeDimension` with
  `dimension = Nat.card (Fin n) - Nat.card PEmpty = n`.
- **Result:** RESOLVED — all 5 declarations axiom-clean (`{propext, Classical.choice, Quot.sound}`).
- **Mathlib relevance:** this is a genuine Mathlib gap that iter-182 prover scout flagged
  as missing. The substrate is now available as a project-local supplement.

## projectiveLineBar_smoothOfRelDim (line 325) — PARTIAL via cover reduction
- **Approach 1:** Use `IsZariskiLocalAtSource.of_openCover` with
  `(projectiveLineBarAffineCover kbar).openCover` (the 2-chart cover already in
  this file at L284). Reduce to per-chart smoothness.
- **Result:** PARTIAL — the cover reduction itself is axiom-clean. The remaining
  per-chart gap is `projectiveLineBar_smooth_chart_aux` (private helper at L316),
  which has a focused sorry.
- **Cover-reduction substrate:** uses Mathlib's
  `IsZariskiLocalAtSource.of_openCover` (proven for `SmoothOfRelativeDimension n`
  via the `HasRingHomProperty` ⟹ `IsZariskiLocalAtSource` chain in
  `RingHomProperties.lean:375`).

## projectiveLineBar_smooth_chart_aux (line 316) — focused per-chart sorry
- **Approach 1:** Apply `HasRingHomProperty.iff_of_isAffine` (both source and
  target are affine) to reduce smoothness to a
  `RingHom.Locally (RingHom.IsStandardSmoothOfRelativeDimension 1)` on the composite
  ring map `kbar → Γ(chart_i, ⊤) = HomogeneousLocalization.Away 𝒜 X_i`.
  Then `RingHom.locally_of` reduces further to direct
  `RingHom.IsStandardSmoothOfRelativeDimension 1`.
- **Result:** PARTIAL — two structural reduction steps land axiom-clean; the
  remaining direct-IsStandardSmoothOfRelativeDimension goal on the composite
  needs the chart-ring iso to push through.
- **Closure recipe (~10 LOC) when ChartIso is in scope:** combine
  `mvPolynomialFin_isStandardSmoothOfRelativeDimension` (this file) with
  `homogeneousLocalizationAwayIso` (ChartIso.lean) via
  `Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv` to transfer rel dim 1
  from `MvPolynomial (Fin 1) kbar` to the chart ring. The
  `kbar → Γ(chart_i, ⊤)` ring map then has `IsStandardSmoothOfRelativeDimension 1`.
- **Dead end avoided:** Do NOT re-attempt building the chart-ring iso here —
  ChartIso.lean already has it (`homogeneousLocalizationAwayIso`), and replicating
  it in BareScheme.lean is ~80+ LOC of duplication.

## projectiveLineBar_geomIrred (line 218) — bare sorry (unchanged)
- **Approach 1:** Searched Mathlib for `GeometricallyIrreducible` on `Proj` —
  zero hits (per iter-182 prover scout, re-confirmed iter-196). Mathlib does
  not ship base-change-of-Proj infrastructure.
- **Result:** NOT ADDED — substrate gap unchanged from iter-182.
- **Recipe (~200-350 LOC across multiple iters):** Helper A (`Proj 𝒜 ⊗ K ≅ Proj 𝒜 ×_S Spec K` — the load-bearing piece) + Helper B (re-parameterise the
  `ChartIso` infrastructure over an arbitrary field) + Helpers C-E + Final.
- **Dead end:** Direct `infer_instance` fails — no instance for `Proj` is shipped.
- **Next step:** Defer to a dedicated geom-irred lane (iter-197+); current
  blueprint expansion ack'd the gap (AbelianVarietyRigidity.tex:972-993).

## Why I stopped

`Partial progress`: 5 axiom-clean substrate declarations added
(`mvPolyGenerators` L165, `mvPolyPresentation` L173,
`mvPolyPreSubmersivePresentation` L187, `mvPolySubmersivePresentation` L196,
`mvPolynomialFin_isStandardSmoothOfRelativeDimension` L207) + 1 structural
reduction landed (`projectiveLineBar_smoothOfRelDim` L325 uses cover reduction
axiom-clean, delegating to `projectiveLineBar_smooth_chart_aux` L316).

Blocked on: closing `projectiveLineBar_smooth_chart_aux` body — needs the chart-ring
iso `MvPolynomial (Fin 1) kbar ≃ₐ[kbar] HomogeneousLocalization.Away 𝒜 X_i`
which is in `ChartIso.lean` (downstream of BareScheme.lean, so cannot be
imported here without a refactor). Closure path:
- (a) Refactor: relocate `projectiveLineBar_smoothOfRelDim` instance to a downstream
  file (e.g., `Genus0BaseObjects/ChartIso.lean` itself, or a new
  `Genus0BaseObjects/Smooth.lean`) where `homogeneousLocalizationAwayIso` is in
  scope, then close the per-chart gap via
  `Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv` (~10 LOC).
- (b) Duplicate the iso in BareScheme.lean (~80+ LOC duplication, not recommended).

Blocked on: `projectiveLineBar_geomIrred` — Mathlib does not ship
`GeometricallyIrreducible` for `Proj` of a polynomial ring (iter-182 scout
verdict re-confirmed). ~200-350 LOC substrate gap unchanged. Recipe in iter-182
task result still applies: Helper A is the load-bearing piece.

## Recommendation for iter-197 plan-phase

1. **Smoothness closure**: dispatch a refactor subagent (or prover with broader
   write domain) to relocate `projectiveLineBar_smoothOfRelDim` to a downstream
   file where ChartIso.lean's `homogeneousLocalizationAwayIso` is in scope. Closure
   then ~10 LOC. The substrate piece `mvPolynomialFin_isStandardSmoothOfRelativeDimension`
   is permanent project asset, regardless of where the final instance lives.
2. **GeomIrred lane**: dedicated multi-iter lane needed (~200-350 LOC), with
   Helper A (`Proj base-change`) as the load-bearing piece. Alternatively,
   evaluate whether downstream consumers truly need `GeometricallyIrreducible`
   vs the weaker `IrreducibleSpace`.

## Lemmas / API verified

- **`Algebra.SubmersivePresentation.isStandardSmoothOfRelativeDimension`** — extracts
  `IsStandardSmoothOfRelativeDimension n` from a SubmersivePresentation with
  `dimension = n`.
- **`Algebra.PreSubmersivePresentation.jacobian_eq_jacobiMatrix_det`** — connects
  Jacobian to determinant of `jacobiMatrix`.
- **`Matrix.det_isEmpty`** — det of empty matrix = 1.
- **`Algebra.Generators.ofSurjective`** — build Generators from a surjective `aeval val`.
- **`MvPolynomial.aeval_X_left`** — `aeval X = AlgHom.id` (the load-bearing fact).
- **`Algebra.Generators.ker_eq_ker_aeval_val`** — Generators.ker = ker (aeval val).
- **`IsZariskiLocalAtSource.of_openCover`** — discharge `P f` from `∀ i, P (𝒰.f i ≫ f)`.
- **`HasRingHomProperty.iff_of_isAffine`** — for an affine target and `HasRingHomProperty P Q`,
  `P f` iff `Q f.appTop.hom`.
- **`RingHom.locally_of`** — discharge `RingHom.Locally P f` from `P f` (given `RespectsIso`).
- **`RingHom.isStandardSmoothOfRelativeDimension_respectsIso`** — the RespectsIso witness.
- **`Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv`** — transfer along
  algebra isomorphism.

## Dead-end log

- `infer_instance` on the smoothness goal: FAILED (no automatic instance synthesis).
- Reusing ChartIso.lean's iso in BareScheme.lean: BLOCKED (BareScheme.lean is
  upstream of ChartIso.lean; can't import).
- Direct construction of `MvPolynomial.algEquiv (HomogeneousLocalization.Away 𝒜 X_i)`
  in BareScheme.lean: NOT ATTEMPTED — would duplicate ~80+ LOC of ChartIso.lean.
- Building `Algebra.IsStandardSmoothOfRelativeDimension 1 kbar
  (HomogeneousLocalization.Away 𝒜 X_i)` directly (without the iso): EQUIVALENT
  to building the iso, so same blocker.

## Note for next planner

The 5 substrate pieces (lines 165-211) are pure Mathlib supplement — they make
no reference to `ProjectiveLineBar` or any project-specific definition. They
are immediately usable by anyone needing
`Algebra.IsStandardSmoothOfRelativeDimension n R (MvPolynomial (Fin n) R)`. The
iter-182 task result called this out as a Mathlib gap; iter-196 has now closed
the gap as a project-local supplement.
