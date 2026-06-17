# Recommendations for iter-147

## CRITICAL — actionable blockers from this iter

### 1. `Cohomology_MayerVietoris.tex` empty `\uses{}` annotations (BUILD BLOCKER)

The deterministic `blueprint-doctor` flagged **5 empty `\uses{}`** in
`blueprint/src/chapters/Cohomology_MayerVietoris.tex`. plastex emits
`Label '' could not be resolved` for each, and the leanblueprint
depgraph builder then enters infinite recursion (`RecursionError`).
**The next `leanblueprint web` run will crash until these are fixed.**

→ **iter-147 plan agent**: dispatch a `blueprint-writer` on
`Cohomology_MayerVietoris.tex` with directive to either fill in the
intended `\uses{...}` labels or delete the empty annotations
outright. Report: `.archon/logs/iter-146/blueprint-doctor.md`.

### 2. `Scheme.Over.ext_of_diff_zero` signature-reduction is now load-bearing-documented

The iter-146 Lean closure (L208 of `ChartAlgebra.lean`) drops the
`df = dg` hypothesis that the blueprint statement (`RigidityKbar.tex:lem:Scheme_Over_ext_of_diff_zero`)
lists as load-bearing, plus the `genus 0` / `smooth proper geom-irr
curve` / `smooth proper geom-irr group scheme` hypotheses on `C` / `A`.
The body is a one-line delegate to the iter-125 `ext_of_eqOnOpen`
packaging. A `% NOTE: (iter-146 review)` was added to the blueprint
block this review; the lemma is honestly documented as a renamed
alias.

→ **iter-147+** (after the β-core sub-piece
`df_zero_factors_through_constant_on_chart` lands): re-refine the
Lean signature to also take `df = dg` and derive `eqOnOpen` from it
via Steps 1–2 of the chart-algebra (β) recipe. Until then, the
iter-146 Lean form is fine, but it does not deliver the full
chart-algebra envelope content. Treat it as a partial closure for
M2.b body-closure accounting.

## HIGH — code-quality findings from `lean-auditor-iter146`

### 3. Two `: True := sorry` placeholders persist at iter-146 close

- `ChartAlgebra.lean:97` — `df_zero_factors_through_constant_on_chart`
  (β-core).
- `ChartAlgebra.lean:107` —
  `AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
  (KDM ring-side; also flagged as a parallel-namespace concern —
  `KaehlerDifferential.*` declared under `AlgebraicGeometry`
  shadows Mathlib's root-level `KaehlerDifferential`).

Both were declared OFF-LIMITS this iter pending the iter-147
mandatory blueprint-reviewer's green-light on the iter-146
rigiditykbar-writer's KDM step (p1) + step (p3) absorption.

→ **iter-147 plan agent**: once the blueprint-reviewer green-lights
`RigidityKbar.tex` (now `complete: true / correct: true` after the
iter-146 Wave 2 writer's 4-substep p1 recipe + step (p3)
chart-of-proper-curve helper extraction), dispatch the prover lane
on the β-core + KDM sub-pieces. The TODO comments attached to both
placeholders read `TODO iter-146: real signature; placeholder is `: True`.`
and are now stale by their own framing — either refresh to "iter-147"
or delete the placeholders pending real signatures.

### 4. `constants_integral_over_base_field` substep 3 (deferred)

Real-signature, in-progress proof with `sorry` at L177 of
`ChartAlgebra.lean`. Substeps 1–2 already land via
`isField_of_universallyClosed` + `finite_appTop_of_universallyClosed`
+ `GeometricallyIrreducible.irreducibleSpace_of_subsingleton` +
`isIntegral_of_irreducibleSpace_of_isReduced`. Substep 3 is the
geom-irr base-change step:
`Γ(X, ⊤) ⊗_k k̄ ≃ Γ(X_{k̄}, ⊤) = k̄ ⇒ dim_k Γ(X, ⊤) = 1`.

**Closure path (iter-147+)**:
1. Set up `X_{k̄} := pullback (X ↘ Spec k) (Spec.map (algebraMap k
   (AlgebraicClosure k)))`.
2. Invoke flat base change of `Γ` for proper schemes — Mathlib
   snapshot `b80f227` provides this in idiom only; may need a thin
   in-tree wrapper around `AlgebraicGeometry.IsBaseChange` for the
   `Γ`-functor specialisation (Stacks Tag 02KH).
3. Apply the same lemma to `X_{k̄}` over `k̄` using
   `IsStableUnderBaseChange` for `GeometricallyIrreducible`
   (already in Mathlib).
4. Conclude `dim_k Γ(X, ⊤) = 1` via `Module.finrank_baseChange` +
   `Subalgebra.finrank_bot` / `IntermediateField.bot_eq_top_iff_finrank_eq_one`.
5. Conclude `range = ⊤` via `Subalgebra.eq_top_of_finrank_eq` or a
   direct dimension argument.

→ Recommended for the iter-147 prover lane as a standalone target
(~50–100 LOC additional on top of the iter-146 substep 1–2 work).

### 5. `ChartAlgebra.lean` cleanup pass (auditor majors / minors)

The `lean-auditor-iter146` report flagged:
- **L11–L25** iter-history NOTE block duplicates the L70–L73
  inline justification of the `attribute [local instance]`
  re-enablement. **Action**: trim the leading block to a one-line
  pointer.
- **L37–L57** `## Status (iter-146 prover lane)` block bakes
  per-iter closure state into the file's literate docstring.
  **Action**: move to a one-line "see `STRATEGY.md` /
  `iter/iter-146/review.md`" pointer.
- **L64** `open CategoryTheory Limits TopologicalSpace` — `Limits`
  not used. **Action**: trim.
- **L74** `attribute [local instance] Algebra.TensorProduct.rightAlgebra`
  at file scope widens the instance-search surface for every
  downstream importer. **Action**: evaluate narrowing to a
  `local instance` inside a `section` around the `algebra_isPushout_*`
  declaration. (Acceptable file-scope for now; flag for review.)
- **L150 / L165** spelling inconsistency: body uses
  `Spec (CommRingCat.of k)` where signature uses `Spec (.of k)`.
  **Action**: normalize to one form.
- **L144** declaration name `constants_integral_over_base_field`
  understates the conclusion (`range = ⊤` is "equal to base field",
  not "integral over base field"). Rename candidate:
  `appTop_surjective_of_smooth_proper_geomIrreducible` or
  `globalSections_eq_baseField_of_*`. **Action**: defer renaming
  until substep 3 closes; rename in the same edit that closes the
  substep 3 sorry.

→ Recommended for an iter-147 cleanup pass on `ChartAlgebra.lean`
(small refactor, not a full prover round). Can be folded into the
iter-147 prover round if the prover edits the file substantively.

## MEDIUM — strategy / structural follow-ups

### 6. Iter-147 mandatory blueprint-reviewer re-confirms RigidityKbar + GrpObj pointer

The iter-146 plan agent's HARD GATE rebuttal turned on the
iter-146 Wave 2 writers absorbing 11 must-fix items on
`RigidityKbar.tex` + 2 must-fix items on
`AlgebraicJacobian_Cotangent_GrpObj.tex` (chapters were `partial /
partial` going into iter-146 plan-phase, became `true / true` after
the writers per the plan agent's reading). The iter-147 mandatory
blueprint-reviewer is the planned external verification — if it
returns `partial / partial` on either chapter, the rebuttal stands
challenged and the next prover lane on `Cotangent/ChartAlgebra.lean`
defers.

### 7. Iter-147 STRATEGY.md canonical-skeleton restructure (Q5 completion)

Carried over from iter-146 strategy-critic Q5 challenge. Target
post-iter-147 size: ~400–450 LOC (down from the current 624 LOC
post-iter-146 mechanical excise). Introduce `## Goal`, `## Phases &
estimations`, `## Routes`, `## Open strategic questions`, and
`## Mathlib gaps & new material` headings; relocate residual
per-route LOC/iter estimates into `## Phases & estimations`;
archive completed Mathlib-gap entries to `STRATEGY-history.md`.

### 8. Iter-147 progress-critic Route 1 verdict update

Per the iter-146 plan agent's watch criterion, the iter-147
mandatory progress-critic updates the Route 1 (chart-algebra piece
(ii)) verdict from UNCLEAR-fresh to one of: CONVERGING (≥2 of 3
substantive closures), UNCLEAR (1 substantive closure), or
CHURNING (0 substantive closures with signature non-refinement).

iter-146 closed 2 of 3 in-scope sub-pieces sorry-free + refined the
third signature to its real shape with a structured partial body —
this matches the CONVERGING criterion if the auditor's
named-concept-vs-body call-out on `ext_of_diff_zero` (a thin
renaming, not a substantive closure) is set aside as
"closes-by-letter-of-the-planner-spec". The progress-critic should
weigh whether the `ext_of_diff_zero` reduction-to-rename counts as
a substantive closure for CONVERGING accounting. The honest read is
**CONVERGING-with-caveat**: 1 strict substantive closure (α), 1
substantive partial (constants substep 1–2), 1 signature-reduction
rename (`ext_of_diff_zero`) — net +2 strict-count sorry-elimination,
the first such delta on this route since the iter-145 +2
decomposition cost.

## LOW — informational

### 9. Blueprint NOTE adds applied this iter

Three `% NOTE: (iter-146 review)` blocks added to
`blueprint/src/chapters/RigidityKbar.tex`:
- `lem:chart_algebra_isPushout_of_affine_product` —
  single-`inferInstance` discharge under locally re-enabled
  `Algebra.TensorProduct.rightAlgebra`.
- `lem:constants_integral_over_base_field` — explicit `[IsReduced X]`
  discipline (Mathlib `b80f227` gap); substep 1–2 iter-146 closure
  + substep 3 iter-147+ deferral.
- `lem:Scheme_Over_ext_of_diff_zero` — iter-146 signature reduction
  to the iter-125 `ext_of_eqOnOpen` thin rename.

### 10. Reusable proof patterns landed iter-146

(Documented in `PROJECT_STATUS.md` Knowledge Base under iter-146
adds.)

- **`attribute [local instance] Algebra.TensorProduct.rightAlgebra`
  at file scope** is the unlock for the canonical
  `Algebra.IsPushout k B₁ B₂ (TensorProduct k B₁ B₂)` instance in
  any file downstream of `Mathlib.RingTheory.IsTensorProduct`.
- **`isField_of_universallyClosed` + `finite_appTop_of_universallyClosed`
  + `IsProper` extends `UniversallyClosed` + `LocallyOfFiniteType`**
  is the cleanest Mathlib chain for "Γ(X, ⊤) is a finite-dim field
  extension of k" under `IsProper`.
- **Named-concept-vs-body mismatch as iter-146 review-phase pattern**
  — when a prover refines a `: True := sorry` placeholder by
  delegating to a renamed-but-existing lemma, the blueprint MUST
  get a `% NOTE:` flag for the deliberate signature reduction.
  Otherwise the chapter and Lean drift apart.

## Targets to NOT retry without a structural change

- **`Cotangent/GrpObj.lean` piece (i.b) bundled-route declarations**
  (excised iter-145). Re-introducing them requires an explicit
  rebuttal in `plan.md` naming why the iter-144 chart-algebra
  pivot is being walked back.
- **Symmetric `Algebra B₂ (TensorProduct k B₁ B₂)` instance
  synthesis without re-enabling `Algebra.TensorProduct.rightAlgebra`**
  — Mathlib leaves this `local`; the iter-146 prover lane confirmed
  4 separate `lean_run_code` failures before finding the unlock.
- **`Smooth (X → Spec k) ⇒ IsReduced X` over a general base** —
  Mathlib `b80f227` gap; perfect-base only via
  `Scheme.Hom.dense_smoothLocus_of_perfectField`. The project's
  discipline is to carry `[IsReduced X]` explicitly at every call
  site.
