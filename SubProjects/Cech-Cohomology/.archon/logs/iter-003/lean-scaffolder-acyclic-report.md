# Lean Scaffolder Report: acyclic

## Status: SUCCESS

`AlgebraicJacobian/Cohomology/AcyclicResolution.lean` created and wired in.
Build result: **clean** — `8321/8321 jobs`, no errors. Warnings are linter style
warnings only (two long-line warnings in comment block).

---

## Declarations created

### `CategoryTheory.Functor.IsRightAcyclic` (compiling, no sorry)

```lean
class Functor.IsRightAcyclic (G : 𝒜 ⥤ ℬ) [G.Additive] (J : 𝒜) : Prop where
  vanish : ∀ k : ℕ, Limits.IsZero ((G.rightDerived (k + 1)).obj J)
```

Context variables:
```lean
variable {𝒜 : Type*} [Category 𝒜] [Abelian 𝒜] [HasInjectiveResolutions 𝒜]
variable {ℬ : Type*} [Category ℬ] [Abelian ℬ]
```

Note: directive specified `[EnoughInjectives 𝒜]` but `Functor.rightDerived` requires
`[HasInjectiveResolutions 𝒜]`; the correct typeclass is used.

### `CategoryTheory.Functor.IsRightAcyclic.ofInjective` (instance, no sorry)

```lean
instance (priority := 100) Functor.IsRightAcyclic.ofInjective
    (G : 𝒜 ⥤ ℬ) [G.Additive] (J : 𝒜) [Injective J] : Functor.IsRightAcyclic G J where
  vanish k := Functor.isZero_rightDerived_obj_injective_succ G k J
```

Closes cleanly from `Functor.isZero_rightDerived_obj_injective_succ` — one line,
no sorry needed.

---

## Build wiring

`AlgebraicJacobian.lean` now includes:
```lean
import AlgebraicJacobian.Cohomology.AcyclicResolution
```

---

## Signatures NOT scaffolded (left as commented targets in strategy block)

The following three declarations were **not** scaffolded as live Lean stubs because
their signatures could not be made to elaborate cleanly without either (a) building
substantial supporting infrastructure first, or (b) guessing at exact types for
`InjectiveResolution B` output that depend on the horseshoe construction itself.
The strategy block in the file documents their full intended signatures, routes, and
Mathlib building blocks.

| Blueprint target | Lean name | Reason not scaffolded |
|---|---|---|
| `lem:injective_resolution_of_ses` | `CategoryTheory.InjectiveResolution.ofShortExact` | Output type depends on horseshoe construction; signature requires building `InjectiveResolution ses.X₂` from scratch. Hard to elaborate without infrastructure. |
| `lem:acyclic_dimension_shift` | `CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic` | Requires `InjectiveResolution.ofShortExact` as input; statement involves complex Iso types. |
| `lem:acyclic_resolution_computes_derived` | `CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution` | Requires the two above; main comparison theorem. |

---

## One technical correction for the prover

The `IsZero` predicate lives at `CategoryTheory.Limits.IsZero` (not `IsZero` bare).
Within `namespace CategoryTheory`, use `Limits.IsZero`. The instance field and
`Functor.isZero_rightDerived_obj_injective_succ` both use this type correctly in the
compiled file.

---

## Uncovered declarations

None — all three unscaffolded declarations have corresponding `\lean{}` entries in
`blueprint/src/chapters/Cohomology_AcyclicResolution.tex`.
