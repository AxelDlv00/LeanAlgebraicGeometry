# Refactor Directive

## Slug
pin2-sig-strengthen

## Problem

`AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:310-320`
`Scheme.morphism_degree_via_pole_divisor` has a **weakened-wrong**
signature per the iter-181 `lean-vs-blueprint-checker iter181-ratcurveiso`
must-fix-this-iter finding:

```lean
theorem morphism_degree_via_pole_divisor
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (φ : C ⟶ ProjectiveLineBar kbar) (_hφ_non_const : ¬ IsConstant φ) :
    ∃ (d : ℕ) (D : C.left.WeilDivisor), 0 < d ∧ D.degree = (d : ℤ) := sorry
```

The output existential is discharged by ANY positive-degree divisor on
`C` — it does not reference `φ`, does not identify `D` with the pole
divisor `φ^*[∞]`, and does not pin `d = [K(C):k̄(ℙ¹)]`. A witness
`(d := 1, D := [P])` for any closed point `P ∈ C` satisfies the type
WITHOUT saying anything about `φ`.

The body is currently `sorry`, so no false proof is shipped. **But
iter-182 must strengthen the signature BEFORE any body work**, else
any body closes a vacuous statement — confirmed iter-181 lean-vs-
blueprint-checker MUST-FIX. The iter-181 review also routes the
progress-critic iter-182 STUCK→OVER_BUDGET trigger on
`RiemannRoch/WeilDivisor.lean` (`principal_degree_zero` non-constant
branch) through Pin 2 body landing this iter.

## Mathematical Justification

Per `analogies/ratcurveiso-pin2.md` (iter-181 mathlib-analogist
consult, verdict PROCEED) and the blueprint chapter
`blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex` L271-275:

The substantive claim is

> for a non-constant `φ : C → ℙ¹`, `[K(C) : k̄(ℙ¹)]` is finite, and
> equals `deg(φ^*[Q])` for every closed point `Q ∈ ℙ¹`; in
> particular for `Q = ∞` this gives a pole divisor of `φ` of degree
> exactly `[K(C):k̄(ℙ¹)]`.

The Lean signature that mirrors this — and is the right call-site
shape for `iso_of_degree_one` (Pin 3) consumption — is:

```lean
theorem morphism_degree_via_pole_divisor
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (φ : C ⟶ ProjectiveLineBar kbar) (_hφ_non_const : ¬ IsConstant φ)
    [Algebra (ProjectiveLineBar kbar).left.functionField C.left.functionField] :
    ∃ (D : C.left.WeilDivisor),
        D = Scheme.Hom.poleDivisor φ ∧
        Scheme.WeilDivisor.degree D =
          (Module.finrank
            (ProjectiveLineBar kbar).left.functionField
            C.left.functionField : ℤ) := sorry
```

Where `Scheme.Hom.poleDivisor : (C ⟶ ProjectiveLineBar kbar) →
C.left.WeilDivisor` is a NEW typed-sorry `noncomputable def` mirroring
the iter-181 plan-phase `lineBundleAtClosedPoint.toFunctionField`
refactor — its body is `:= sorry` and will be supplied by an iter-183+
body lane via `Ideal.sum_ramification_inertia` per
`analogies/ratcurveiso-pin2.md` body recipe.

The `[Algebra ...]` instance binder matches Pin 3's iter-181 sig
refinement convention (canonical `φ`-induced function-field map).

## Changes Requested

### File 1: `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

**Add** (immediately above `morphism_degree_via_pole_divisor`, around
L300):

```lean
/-- The pole divisor of a non-constant morphism `φ : C → ℙ¹` of
smooth proper curves over `k̄`: as a Weil divisor on `C`, it is
`φ^*[∞]` — the pullback of the divisor `[∞]` on `ℙ¹` along `φ`.
The body is iter-183+ work; see `analogies/ratcurveiso-pin2.md`
for the construction route via affine-chart-localised
`Ideal.sum_ramification_inertia`. -/
noncomputable def Scheme.Hom.poleDivisor
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (φ : C ⟶ ProjectiveLineBar kbar) :
    C.left.WeilDivisor := sorry
```

**Replace** the signature of `morphism_degree_via_pole_divisor`
(L310-320) to:

```lean
theorem morphism_degree_via_pole_divisor
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (φ : C ⟶ ProjectiveLineBar kbar) (_hφ_non_const : ¬ IsConstant φ)
    [Algebra (ProjectiveLineBar kbar).left.functionField C.left.functionField] :
    ∃ (D : C.left.WeilDivisor),
        D = Scheme.Hom.poleDivisor φ ∧
        Scheme.WeilDivisor.degree D =
          (Module.finrank
            (ProjectiveLineBar kbar).left.functionField
            C.left.functionField : ℤ) := by
  sorry
```

Leave the body as `sorry` (a fresh prover lane fires post-refactor in
the same iter to close it).

### File 2: `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`

Out of scope for this refactor — the chapter prose update is handled
by the `blueprint-writer ratcurveiso-pin3-prose` parallel dispatch.

## Affected Files

- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` — signature
  change + new def.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — `principal_degree_zero`
  non-constant branch CURRENTLY does NOT consume Pin 2 (verified by
  grep iter-181: no consumer of `morphism_degree_via_pole_divisor`
  outside this file). So no breakage.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — `genusZero_curve_iso_P1`
  (L337) is a `:= sorry` body that will eventually call Pin 2 + Pin 3
  but does not currently call them. No breakage.

## Expected Outcome

After the refactor:
- File `RationalCurveIso.lean` sorry count: 2 → 3 (Pin 3 body sorry
  unchanged + Pin 2 body sorry unchanged + NEW `poleDivisor` typed
  sorry). Net +1.
- Build: GREEN.
- Project axioms: unchanged (0).
- The `morphism_degree_via_pole_divisor` signature now references `φ`
  in the output existential — no longer vacuously satisfiable.

## Helper budget

Helpers introduced by the refactor: 1 (`Scheme.Hom.poleDivisor`
typed-sorry def). This is structurally necessary to pin the output
existential to `φ`.
