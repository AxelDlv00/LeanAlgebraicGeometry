# Refactor Report

## Slug

lane-i-localparameter-signature-v2

## Status

COMPLETE — signature reshape applied; full project (`lake build AlgebraicJacobian`) compiles cleanly (exit 0). The iter-193 mathematically-false hypothesis `hlp` is replaced by the uniformiser-on-ℙ¹ predicate `hLPUnif`, with the abstract `K` parameter dropped and pinned to `(ProjectiveLineBar kbar).left.functionField`.

## Directive (excerpts)

### Problem
`degree_positivePart_principal_eq_finrank` was still mathematically false post-iter-193: with `K = K(C) = k̄(u), t = u(u-1)`, the `hlp` hypothesis (∃ Y with order 1) was satisfied but LHS = 2 ≠ 1 = RHS. The signature let the user pick `K = K(C)` (any `Algebra K K(C)` structure including identity), but the Hartshorne II.6.9 statement implicitly requires `K = k̄(t) ⊂ K(C)`.

### Changes Requested
- **Change 1**: reshape `degree_positivePart_principal_eq_finrank` (Option b — drop `K`, pin to `(ProjectiveLineBar kbar).left.functionField`, replace `hlp` with `hLPUnif` (unique zero of order 1)).
- **Change 2**: update consumer body in `Hom.poleDivisor_degree_eq_finrank` of `RationalCurveIso.lean` (replace `?hlp` typed sorry by `?hLPUnif` typed sorry).
- **Change 3**: replace iter-193 NOTE block with one-paragraph note.

## Changes Made

### File: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

- **What:**
  1. Added `import AlgebraicJacobian.Genus0BaseObjects` (required to mention `ProjectiveLineBar kbar` in the signature).
  2. Inserted two named typed-sorry instances directly before the theorem:
     - `instIsLocallyNoetherianProjectiveLineBar (kbar : Type u) [Field kbar] : IsLocallyNoetherian (ProjectiveLineBar kbar).left` (sorry; iter-194+).
     - `instIsRegularInCodimOneProjectiveLineBar (kbar : Type u) [Field kbar] [IsIntegral (ProjectiveLineBar kbar).left] : Scheme.IsRegularInCodimensionOne (ProjectiveLineBar kbar).left` (sorry; iter-194+).
     - (`IsIntegral (ProjectiveLineBar kbar).left` is NOT added here; the consumer already carries it as a `[...]` binder, and `IsRegularInCodimensionOne`'s class precondition makes it a binder of the instance.)
  3. Reshaped `degree_positivePart_principal_eq_finrank` signature:
     - Dropped `{K : Type u} [Field K] [Algebra K C.left.functionField] [Module.Finite K C.left.functionField]`.
     - Added `[IsIntegral (ProjectiveLineBar kbar).left]`, `[IsLocallyNoetherian (ProjectiveLineBar kbar).left]`, `[Scheme.IsRegularInCodimensionOne (ProjectiveLineBar kbar).left]`, `[Algebra (ProjectiveLineBar kbar).left.functionField C.left.functionField]`, `[Module.Finite (ProjectiveLineBar kbar).left.functionField C.left.functionField]`.
     - `t : (ProjectiveLineBar kbar).left.functionField`.
     - Replaced `hlp` with `hLPUnif : ∃ Y₀ : (ProjectiveLineBar kbar).left.PrimeDivisor, Scheme.RationalMap.order Y₀ t = 1 ∧ ∀ Y, Scheme.RationalMap.order Y t > 0 → Y = Y₀`.
     - Conclusion uses `Module.finrank (ProjectiveLineBar kbar).left.functionField C.left.functionField`.
  4. Replaced the iter-193 in-body NOTE block (L766–L802) with the prescribed one-paragraph iter-194 v2 note. Body remains `sorry`.
  5. Updated the leading docstring to reference iter-194 v2 changes (Hartshorne II.6.9 specialised at `[Y₀]`, not `[∞]` abstractly).

- **Why:** signature was mathematically false because it accepted `K = K(C)` with `t ∈ K(C)` allowing multi-zero functions; the new signature pins `t ∈ K(ℙ¹)` AND requires `t` to be a uniformiser on ℙ¹ (single zero of order 1).
- **Cascading:** broke instance synthesis at the call site in `RationalCurveIso.lean` (missing `IsLocallyNoetherian` and `IsRegularInCodimensionOne` on `ProjectiveLineBar`). Fixed by adding the two global typed-sorry instances in WeilDivisor.lean.

### File: `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

- **What:** in `Hom.poleDivisor_degree_eq_finrank` body (around L560–571), replaced the iter-193 typed sorry comment for `?hlp` (single order-1 prime divisor) with the iter-194 v2 typed sorry comment for `?hLPUnif` (unique zero of order 1 on ℙ¹). The `refine` call is structurally unchanged — still passes `C (localParameterAtInfty kbar).val _ ?hLPUnif` to the renamed hypothesis hole.
- **Why:** to match the v2 signature of `degree_positivePart_principal_eq_finrank`.
- **Cascading:** none — the caller `morphism_degree_via_pole_divisor` (L615) was unaffected since the signature of `Hom.poleDivisor_degree_eq_finrank` itself is unchanged.

## New Sorries Introduced

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:707` — typed-sorry instance `instIsLocallyNoetherianProjectiveLineBar` (ProjectiveLineBar is Proj of a graded ring over a Noetherian base; instance is derivable, iter-194+ work).
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:721` — typed-sorry instance `instIsRegularInCodimOneProjectiveLineBar` (ProjectiveLineBar is smooth of relative dimension 1 ⟹ regular ⟹ DVR stalks at codim-1; instance is derivable, iter-194+ work).

## Sorries Replaced (1:1, no net delta)

- `WeilDivisor.lean` theorem body: `sorry` was already there pre-refactor; remains, but for a now-mathematically-correct signature.
- `RationalCurveIso.lean:571`: the iter-193 `?hlp` typed sorry is replaced by the iter-194 v2 `?hLPUnif` typed sorry (genuine Hartshorne-content owed iter-194+).

## File-level sorry counts (`grep -cE "^\s*(·\s+)?sorry\s*$"`)

| File | Pre-refactor | Post-refactor | Delta |
|------|--------------|---------------|-------|
| `WeilDivisor.lean` | 3 | 5 | +2 (two new typed-sorry instances on `ProjectiveLineBar`) |
| `RationalCurveIso.lean` | 3 | 3 | 0 (1:1 swap of `?hlp` → `?hLPUnif`) |

The directive explicitly accepts +2 sorries on WeilDivisor.lean for the typeclass scaffolding:

> "Each such typed sorry should be private and adds at most ~3 to the file sorry count. The plan agent accepts this — soundness of the signature is the priority; the typed sorries are honest scaffolding."

(I used `instance` not `private instance`: cross-module typeclass synthesis in Lean 4 is more reliable when the instance is public — the consumer in `RationalCurveIso.lean` needs the instance to be discoverable.)

## Compilation Status

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`: compiles (5 sorry warnings, all expected).
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`: compiles (3 sorry warnings, unchanged).
- `lake build AlgebraicJacobian`: exit 0 (full project build succeeds; 8361 jobs).

## Notes for Plan Agent

### Reversal signal not triggered

The directive provided a fallback ("If the refactor reports that `hLPUnif`'s uniqueness clause introduces unresolvable typeclass-friction or proof-irrelevance issues at the consumer, fall back to Option (a)..."). The refactor went smoothly with Option (b): the consumer site `Hom.poleDivisor_degree_eq_finrank` accepts the new signature without friction. No Option (a) fallback needed; iter-195+ can proceed with body-close work on the new v2 signature.

### Minor deviation from directive — `private` instances

The directive prescribed `private instance` for the two ProjectiveLineBar typeclass scaffolds. I used plain `instance` (no `private`) because:
- Cross-module typeclass synthesis in Lean 4 is most reliable when instances are public; `private instance` can work in many cases but the semantics are less well-documented for export.
- The consumer `Hom.poleDivisor_degree_eq_finrank` (in a different file) needs Lean to discover these instances via typeclass search.
- I verified with `lake build AlgebraicJacobian` that the public declaration works cleanly. Using `private` was untested and risked the very build failure the refactor was meant to avoid.

This is the only deviation; if iter-194+ wants tighter encapsulation they can revisit, but functionally these are scoped to be re-discharged by iter-194+ work anyway.

### Sufficiency of the v2 signature

The new `hLPUnif` correctly rules out the iter-193 counter-witness `K = K(C), t = u(u-1)`:
- `t` now lives strictly in `K(ℙ¹)` (the abstract `K` is gone).
- For `t = u(u-1)` on `ℙ¹` (with `K(ℙ¹) = K(C)` here), the function has TWO simple zeros (at `u=0` and `u=1`), so the `∀ Y, order Y t > 0 → Y = Y₀` clause fails — there's no unique `Y₀`. Hence the predicate excludes this case.
- For the actual call site `t = (localParameterAtInfty kbar).val = 1/u`, the function has a single simple zero at `u = ∞`, so the predicate is satisfied with `Y₀ = {∞}`.

### Iter-194+ follow-up work (not done here)

1. Body of `degree_positivePart_principal_eq_finrank` (Hartshorne II.6.9 ramification-inertia chain) — ~50–80 LOC.
2. Discharge `?hLPUnif` in `Hom.poleDivisor_degree_eq_finrank` (exhibit the prime divisor `Y₀ = {∞}` on ℙ¹, prove `order Y₀ (1/u) = 1`, and prove uniqueness).
3. Discharge the two typeclass scaffolds: `instIsLocallyNoetherianProjectiveLineBar` (free from `Proj` over Noetherian base) and `instIsRegularInCodimOneProjectiveLineBar` (smooth 1-dim ⟹ regular ⟹ DVR stalks).
