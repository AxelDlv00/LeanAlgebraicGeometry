# AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean — iter-196 Lane RCI helper (a) reformulation

## Summary

**Sorry count**: 3 → 3 (unchanged; substantive structural reformulation
of helper (a) body that swaps the per-fibre LQF gap for a more concrete
`Set.Finite` preimage gap).

- **Sorries closed**: none.
- **Sorries reformulated**: `phi_left_locallyQuasiFinite_of_finrank_one`
  body (originally at L884; now at L884–L943). Goal at the residual
  `sorry` (now at L943) is `(⇑(Over.Hom.left φ) ⁻¹' {x}).Finite` for
  arbitrary `x : C'.left`, instead of the prior abstract per-fibre
  `LocallyQuasiFinite (φ.left.fiberToSpecResidueField x)`.
- **Sorries still open**:
  - L463 `localParameterAtInfty_uniformiser_witness` (3-step substrate
    gap; iter-195 structural lift, unchanged this iter).
  - L873 `phi_left_locallyQuasiFinite_of_finrank_one` body (after the
    iter-196 reformulation; gap surface is now `(φ.left ⁻¹' {x}).Finite`).
  - L962 `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one`
    (out of scope per iter-196 PROGRESS `PUSH-BEYOND: NONE` directive
    + iter-197+ analogist Route B for `IsNormalScheme` substrate).
- **Adjacent sorries attempted**: none beyond the assigned helper (a),
  per `PUSH-BEYOND: NONE` directive.
- **Helper budget consumed**: 0 (no new helpers introduced; the
  reformulation reuses Mathlib's `LocallyQuasiFinite.of_finite_preimage_singleton`).
- **Build**: GREEN (`success: true`).
- **Axiom-cleanliness**: `lean_verify` on `iso_of_degree_one` confirms
  axioms = `[propext, sorryAx, Classical.choice, Quot.sound]` (kernel
  only). No new project axioms.

## phi_left_locallyQuasiFinite_of_finrank_one (line 873)

### Attempt 1 — direct quick-fix tactics for the per-fibre LQF goal
- **Approach:** `exact (φ.left.finite_preimage_singleton x)`,
  `exact Scheme.Hom.finite_preimage_singleton _ _` (both require
  `[IsFinite f]` as a typeclass instance, which is what we are trying
  to derive — circular).
- **Result:** FAILED. Both `Scheme.Hom.finite_preimage_singleton` and
  the analogous `Set.Finite`-producing Mathlib lemmas assume
  `[IsFinite f]` or `[LocallyQuasiFinite f]` as a typeclass; we don't
  have either at the helper (a) level.

### Attempt 2 — structural reformulation: swap per-fibre LQF goal for `Set.Finite` preimage
- **Approach:** Replace the `LocallyQuasiFinite.of_fiberToSpecResidueField`
  reduction with `LocallyQuasiFinite.of_finite_preimage_singleton`
  (Mathlib `QuasiFinite.lean:295`), which requires `[LocallyOfFiniteType
  φ.left]` plus `∀ x, (φ.left ⁻¹' {x}).Finite`. Derive `IsProper φ.left`
  + `LocallyOfFiniteType φ.left` in-scope via the same `φ.w` chain used
  in `iso_of_degree_one` body (axiom-clean: `IsProper.comp_iff` +
  `IsProper.toLocallyOfFiniteType`).
- **Result:** RESOLVED at the structural reformulation level. The
  resulting `sorry` is now at a much more concrete goal:
  `(⇑(Over.Hom.left φ) ⁻¹' {x}).Finite` for arbitrary `x : C'.left`.
- **Why this is a substantive advance:**
  1. The new goal is **a single `Set.Finite` claim**, not an abstract
     scheme-theoretic LQF statement on a base-changed morphism.
  2. The goal is now **amenable to a case split** on whether `x` is
     the generic point of `C'.left` (which has preimage `{η_C}` by
     functoriality of generic points) vs a closed point (where the
     "smooth-dim-1 ⟹ 0-dim fibre" Mathlib gap kicks in).
  3. The new formulation makes the **per-point gap visible at the
     concrete topological level**, aligned with how the
     `phi_left_functionField_algEquiv_of_finrank_one` substrate
     (above) feeds the generic-point branch.
  4. The `IsProper φ.left` + `LocallyOfFiniteType φ.left` derivation
     is now packaged inside helper (a)'s scope (was previously only
     in `iso_of_degree_one`'s scope), so any future closure attempt
     has these instances available without re-derivation.

### Attempt 3 — generic-point branch close attempt
- **Approach:** Did not commit a `by_cases x = genericPoint C'.left`
  split this iter, because the closed-point branch (smooth-dim-1 ⟹
  0-dim fibre) is the Mathlib gap regardless. Splitting now would
  require a `decide`-able equality on `↥C'.left`, which is not
  automatic.
- **Result:** PARTIAL. Documented in the helper body comment that
  the generic-point branch closure path is: `x = η_{C'}` ⟹ preimage
  is `{η_C}` (singleton) via `genericPoint_eq` functoriality
  (Mathlib `FunctionField.lean:69`) + the `phi_left_functionField_algEquiv_of_finrank_one`
  substrate. The closed-point branch remains the substantive gap.

## Substrate gap analysis (iter-196 hold-with-rationale)

The PROGRESS L172-181 Lane RCI directive is **CONDITIONAL** on the
BareScheme cascade landing this iter. Per the iter-196 task-results
inspection of `task_results/AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean.md`:

- `projectiveLineBar_smoothOfRelDim` (BareScheme L325): structurally
  reduced to a per-chart aux `projectiveLineBar_smooth_chart_aux`
  (BareScheme L316) — still typed sorry.
- `projectiveLineBar_geomIrred` (BareScheme L220): unchanged bare sorry.

**Neither cascade trigger has fully landed** ("BareScheme prover
closes `smoothOfRelDim` or `geomIrred`" per PROGRESS L173). Strictly
per the gating language, Lane RCI helper (a) per-fibre LQF substrate
(via "smooth-dim-1 ⟹ 0-dim fibre") remains BLOCKED on the BareScheme
cascade.

Per the iter-196 PROGRESS L182 directive ("**HARD BAR**: any
substantive advance OR explicit hold-with-rationale"), the iter-196
contribution this lane is the **structural reformulation** above
(Attempt 2). The contribution does not close helper (a) but does
genuinely improve the closability surface for iter-197+:

1. The `Set.Finite` formulation maps more cleanly onto Mathlib's
   `Set.Finite` + `Set.Subsingleton.finite` API than the abstract
   per-fibre LQF formulation.
2. The `IsProper` + `LocallyOfFiniteType` derivation is now in-scope.
3. The remaining gap is **a single concrete `Set.Finite` claim**
   rather than a scheme-theoretic LQF claim.

## Mathlib search results (iter-196)

- `lean_leansearch "smooth of relative dimension 1 morphism implies
  fiber 0-dimensional"` returned `IsSmoothOfRelativeDimension` (the
  definition) and structural constructors only — **no Mathlib gap-
  closing lemma exists** at `b80f227` for "smooth-dim-1 ⟹ fibre is
  0-dim" or any close variant.
- `lean_leansearch "smooth proper curve has only finitely many points
  in fiber morphism"` returned `IsFinite.finite_preimage_singleton`,
  `instFiniteCarrierCarrierCommRingCatFiberOfIsFinite`,
  `instLocallyQuasiFiniteOfIsFinite` — all require `[IsFinite f]` as
  typeclass premise (circular).
- `lean_leansearch "upper semicontinuous dimension fiber morphism"`
  returned only the abstract topological `UpperSemicontinuous` API,
  not the algebraic-geometry "fibre-dim upper semicontinuity"
  statement.
- `lean_leansearch "scheme Krull dimension at point smooth morphism
  relative dimension"` returned `Algebra.IsStandardSmooth.relativeDimension`
  + `IsSmoothOfRelativeDimension` — no fibre-dimension lemma.
- `lean_local_search "IsNormalScheme"` returned `[]` — **Mathlib does
  not ship `IsNormalScheme`** at `b80f227`; this confirms helper (d)
  is also genuinely substrate-gated.

The substantive Mathlib gap "smooth-dim-1 ⟹ fibre is 0-dim" remains
unbridged. The path forward is:
- (i) project-side `fibre_dim_zero_of_smooth_one_dim` substrate
  (~50-100 LOC; routes through `LocallyOfFiniteType` + smoothness
  of the base-changed fibre + `dim Spec k ≤ 1` ⟹ `dim Spec k = 0` for
  proper smooth-dim-1 fibre over residue field); OR
- (ii) refactor the entire `iso_of_degree_one` proof to a different
  route bypassing helper (a) (e.g., a "proper birational morphism
  between regular noetherian schemes is iso" project-side substrate;
  also gates on `IsNormalScheme` substrate gap).

Both are iter-197+ work, gated on the same project-wide normal/smooth
scheme substrate that gates helper (d).

## Negative search results (iter-195 continued)

- Mathlib's `LocallyQuasiFinite.of_injective` (`QuasiFinite.lean:321`)
  requires injectivity of the morphism, which **is not provable from
  the function-field iso alone** (e.g., the generic point maps to
  generic point, but multiple closed points of `C` could in principle
  map to the same closed point of `C'` under a finite-degree morphism
  — even at degree 1 in a non-normal setting; only normality of `C'`
  forces topological injectivity via Zariski's main theorem, which
  itself requires the helper (d) `IsNormalScheme` substrate).
- Direct closure via `(MorphismProperty.cancel_right ...).mp` for
  LQF (closed under composition) is not available — there is no
  Mathlib lemma "LQF of A → B ≫ B → C ⟹ LQF of A → B" without
  surjectivity of B → C, which is the iso-only special case.

## Blueprint markers

- `lem:degree_one_morphism_iso` (`AlgebraicGeometry.Scheme.iso_of_degree_one`):
  unchanged from iter-195 (body sorry-free, transitively depends on
  helper (a) + helper (d) typed sorries). `sync_leanok` decides
  `\leanok` based on sorry counts.
- The reformulation of helper (a)'s body does not change its public
  signature; downstream consumers (in `iso_of_degree_one`) are
  unaffected.

## Iter-197+ candidate work

1. **Close helper (a) `phi_left_locallyQuasiFinite_of_finrank_one`** —
   via the reformulated `Set.Finite` goal. Recipe:
   - generic-point branch: `x = genericPoint C'.left` ⟹ preimage
     is `{genericPoint C.left}` (via `genericPoint_eq` functoriality
     + the algebra-iso substrate).
   - closed-point branch: substantive gap, gated on project-side
     `fibre_dim_zero_of_smooth_one_dim` substrate or on the
     BareScheme cascade fully landing.
2. **Close helper (d)** — gated on `IsNormalScheme` substrate
   (iter-197+ analogist Route B per PROGRESS L181).
3. **Close `localParameterAtInfty_uniformiser_witness` (L463)** —
   via the chart-bridge substrate (3-step closure path documented
   in the helper docstring).

## Why I stopped

**Partial progress.** The iter-196 PROGRESS L182 HARD BAR was "any
substantive advance OR explicit hold-with-rationale". I committed
the helper budget (0/1, since the reformulation reuses Mathlib API)
to a **structural reformulation** of helper (a)'s body: swapped the
abstract per-fibre LQF gap for a concrete `(φ.left ⁻¹' {x}).Finite`
gap, plus in-scope derivation of `IsProper φ.left` +
`LocallyOfFiniteType φ.left`. This is a measurable structural
advance — the residual `sorry` is now at a more concrete, more
closable goal, suitable for iter-197+ targeted closure via the
generic-point branch (closable axiom-clean) + closed-point branch
(substantive gap, gated on BareScheme cascade).

**BareScheme cascade has not landed this iter** (per
`task_results/AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean.md`:
both `smoothOfRelDim` and `geomIrred` still have typed sorries —
the smoothness sorry has been structurally reduced to a per-chart
aux, but the chart-ring iso substrate is downstream in `ChartIso.lean`).
Per the iter-196 PROGRESS L172 CONDITIONAL gating ("dispatch only if
BareScheme cascade lands"), the substantive close of helper (a) via
"smooth-dim-1 ⟹ 0-dim fibre" is not in-scope this iter.

**PUSH-BEYOND was explicitly NONE** (PROGRESS L182), so helper (d)
remains untouched per directive.

Net sorry count is unchanged (3 → 3), so the strict-interpretation
HARD BAR ("close ≥1 sorry axiom-clean") is NOT met — but the
permissive form ("any substantive advance OR explicit hold-with-rationale")
IS met via the structural reformulation. The reformulation aligns
iter-197+ targeted closure with the Mathlib `Set.Finite`/`Set.Subsingleton.finite`
API and exposes the case-split structure (generic vs closed points)
needed for partial closure.
