Done. Everything compiles green, sorry-free, with clean axioms.

## File

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardP1ChartRing.lean` (408 lines, single import `AlgebraicJacobian.RiemannRoch.Adelic.P1ChartData`). No other AJC file touched.

## Headline declarations (exact signatures)

```
AlgebraicGeometry.Adelic.p1AwayAlgEquiv : (R : Type u) → [CommRing R] →
  [GradedAlgebra (homogeneousSubmodule (ULift.{u} (Fin 2)) R)] → {i j : ULift.{u} (Fin 2)} →
  i ≠ j → Away (homogeneousSubmodule (ULift.{u} (Fin 2)) R) (X i) ≃ₐ[R] Polynomial R

AlgebraicGeometry.Adelic.p1AwayAlgEquiv_p1CoordAway : ∀ {i j : ULift.{u} (Fin 2)} (hij : i ≠ j),
  p1AwayAlgEquiv (ULift.{u} ℤ) hij (p1CoordAway (ULift.{u} (Fin 2)) i j) = Polynomial.X   -- @[simp]

AlgebraicGeometry.Adelic.instIsDomainAwayP1 : ∀ (R : Type u) [CommRing R]
  [GradedAlgebra (homogeneousSubmodule (ULift.{u} (Fin 2)) R)] [IsDomain R] (i : ULift.{u} (Fin 2)),
  IsDomain (Away (homogeneousSubmodule (ULift.{u} (Fin 2)) R) (X i))
```

Supporting chain (all public, `R`-algebra level): `p1X_mem_deg_one`, `p1Dehomogenize` (+`_X_self`, `_X_of_ne`), `exists_algebraMap_eq_gradeZero`, `adjoin_gradeZero_range_X`, `p1ChartCoord`, `val_p1ChartCoord`, `p1ChartCoord_pow`, `p1PolyToAway` (+`_X`), `p1AwayToPoly` (+`_mk`, `_p1ChartCoord`, `_comp_p1PolyToAway`, `_p1PolyToAway_apply`), `p1PolyToAway_surjective`, `p1PolyToAway_comp_p1AwayToPoly`, `p1AwayAlgEquiv_p1ChartCoord`, `p1AwayAlgEquiv_symm_X`, `p1AwayAlgEquiv_p1PolyToAway`. Integral-model section: `instIsDomainULiftInt`, `p1ChartCoord_eq_p1CoordAway` (proved by `rfl`), `p1AwayAlgEquiv_p1CoordAway`, plus an `example` witnessing that `IsDomain (Away 𝒫[2] (X i))` is found by instance search.

New in `namespace HomogeneousLocalization` (Mathlib gap, ported from the sibling): `val_fromZeroRingHom`, `instAlgebraBase : Algebra R (HomogeneousLocalization 𝒜 x)`, `algebraMap_eq_comp`, `IsScalarTower R (𝒜 0) (HomogeneousLocalization 𝒜 x)`, `@[simp] algebraMap_val`.

## Verification

```
$ timeout 1800 lake build AlgebraicJacobian.Picard.RigidPushforwardP1ChartRing
✔ [8586/8586] Built AlgebraicJacobian.Picard.RigidPushforwardP1ChartRing (13s)
Build completed successfully (8586 jobs).
```
LSP diagnostics: zero errors, zero warnings (including the unused-section-variable linter).

```
'AlgebraicGeometry.Adelic.p1AwayAlgEquiv' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Adelic.p1AwayAlgEquiv_p1CoordAway' … [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Adelic.p1AwayAlgEquiv_p1ChartCoord' … [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Adelic.p1AwayAlgEquiv_symm_X' … [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Adelic.p1PolyToAway_surjective' … [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Adelic.instIsDomainAwayP1' … [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Adelic.p1ChartCoord_eq_p1CoordAway' … [propext, Classical.choice, Quot.sound]
'HomogeneousLocalization.instAlgebraBase' … [propext, Classical.choice, Quot.sound]
```

Smoke test (scratch file): `#synth Algebra (𝒜 0) (Away …)` still resolves to mathlib's instance, `#synth Algebra (ULift ℤ) (Away …)` resolves to the new `instAlgebraBase` (no prior instance existed → no diamond), `span_p1CoordAway_pow_top` still typechecks verbatim, and `p1PolyToAway … (p1AwayAlgEquiv … z) = z` holds by `symm_apply_apply` (the inverse really is `p1PolyToAway`).

## Where the field hypothesis mattered

Nowhere. Every step of the sibling's proof goes through verbatim over `CommRing R`; the only field-flavoured ingredient, `gradeZeroAlgEquiv`, only used `MvPolynomial.C_injective` + `homogeneousSubmodule_zero`, and I replaced it by the weaker surjectivity statement `exists_algebraMap_eq_gradeZero`, which is all `p1PolyToAway_surjective` needs.

## Decisions / gotchas worth knowing

- **Grading as an instance hypothesis, not a global instance.** `[GradedAlgebra (homogeneousSubmodule (ULift (Fin 2)) R)]` is a section variable; at `R = ULift ℤ` it is discharged by AJC's project-wide `instance (n) : GradedRing 𝒫[n]`, so `p1AwayAlgEquiv (ULift ℤ) hij` lands on *exactly* the same chart-ring instance as `p1CoordAway` — `p1ChartCoord_eq_p1CoordAway` is `rfl`, no defeq wrangling. This avoids registering `MvPolynomial.gradedAlgebra` project-wide for arbitrary bases.
- **`local notation "𝒜"` is unusable here.** With `ULift.{u}` in the RHS it first fails quotPrecheck and then, with the check off, every use reports `unknown universe level u✝`. The grading is spelled out in full instead (AJC house style anyway).
- **The `ULift (Fin 2)` pain points named in the brief were avoidable.** Instead of `fin_cases` after `obtain ⟨i⟩` or `Fintype.prod_equiv Equiv.ulift`, I used `univ_eq_pair : i ≠ j → (univ : Finset (ULift (Fin 2))) = {i, j}` (via `Finset.eq_univ_of_card`) and then `Finset.prod_pair`/`Finset.sum_pair`. Both `prod_X_pow_eq` and the exponent bookkeeping (`add_eq_of_sum_smul_one`) become two-line proofs with no case split.
- **`IsDomain (ULift ℤ)` does not synthesize** in this import set (`NoZeroDivisors (ULift ℤ)` is missing), so the integral-model domain instance needed `instIsDomainULiftInt`, transported along `ULift.ringEquiv`.
- **New global instances introduced** (only visible to importers of this module): `HomogeneousLocalization.instAlgebraBase`, the companion `IsScalarTower`, `Adelic.instIsDomainAwayP1`, `Adelic.instIsDomainULiftInt`.
- **The module has no importer.** Per instructions I did not edit `AlgebraicJacobian.lean`, so this file is *not* in the root build target — it needs to be registered there (cf. inbox I-0362) before it counts as landed.

## AJC/Mathlib lemmas I wished existed

1. `Algebra R (HomogeneousLocalization 𝒜 x)` with `algebraMap_val` — a genuine Mathlib gap (Mathlib only has the `𝒜 0`-algebra structure); had to port it, as the sibling project did.
2. A general-base version of the `Picard/` grading toolkit: `ProjTwist.X_mem_deg_one`, `ProjectiveSpace.bijective_algebraMap_gradeZero`, and especially `Algebra.adjoin (𝒜 0) (Set.range X) = ⊤` — the last is proved *inline* inside `ProjTwist.iSup_basicOpen_X_eq_top` and not exported, so I re-proved all three for general `R`.
3. `IsDomain (ULift ℤ)` (or `NoZeroDivisors (ULift ℤ)`) somewhere early in AJC — `ULift ℤ` is the project's integral base and this is repeatedly going to be needed.
