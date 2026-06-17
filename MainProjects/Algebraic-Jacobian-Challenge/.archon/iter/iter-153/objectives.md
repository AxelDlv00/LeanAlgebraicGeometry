# Iter-153 objectives — detail

## Lane 1: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

Blueprint: `chapters/RigidityKbar.tex` § "Chart-algebra piece (ii) first-class
decomposition" (L1844–2515). HARD GATE cleared by `blueprint-reviewer-iter153`.

### (a) PRIMARY — `constants_integral_over_base_field` (L468; sorry L485)

GUARANTEED 9→8. Goal: `RingHom.range ((X ↘ Spec (CommRingCat.of k)).appTop.hom) = ⊤`
under `[Field k] [IsAlgClosed k]`, `X` smooth proper geometrically irreducible
`[IsReduced X]`. Blueprint proof block lines 2295–2305 is the exact recipe.

Three steps (each lemma confirmed by the reviewer; (3) verified by plan agent):
1. `IsReduced X` + `GeometricallyIrreducible (X ↘ Spec k)` over the singleton
   base ⟹ `IrreducibleSpace X` (`GeometricallyIrreducible.irreducibleSpace_of_subsingleton`)
   ⟹ `IsIntegral X` (`isIntegral_of_irreducibleSpace_of_isReduced`); `IsProper ⟹
   UniversallyClosed` ⟹ `isField_of_universallyClosed` gives `Γ(X,O_X)` a field.
2. `finite_appTop_of_universallyClosed` ⟹ appTop `k → Γ` finite ⟹ integral.
3. `IsAlgClosed.algebraMap_bijective_of_isIntegral`
   (`Mathlib.FieldTheory.IsAlgClosed.Basic`; `[Field k] [Ring K] [IsDomain K]
   [IsAlgClosed k] [Algebra k K] [Algebra.IsIntegral k K] : Bijective (algebraMap k K)`)
   on `K := Γ(X,O_X)` ⟹ surjective ⟹ `RingHom.range ... = ⊤` (`RingHom.range_eq_top`).

Plumbing note: relate `algebraMap k Γ` to the structure-morphism `appTop.hom`
(Γ-Spec adjunction). The body comment L475–484 already lays out the route.
Also REPLACE the stale docstring L433–467 (abandoned base-change-to-k̄ recipe).

### (b) SECONDARY — KDM `mem_range_algebraMap_of_D_eq_zero` (L256; sorry L383)

Now-TRUE under `[IsAlgClosed k] [CharZero k] [IsDomain B]` + finite-type +
standard-smooth. Field-of-fractions transfer (blueprint FT.1–FT.3): `k` alg-closed
in `Frac B` for char-0 geometrically-integral `B` ⟹ `ker d_{Frac B/k} = k` ⟹
`D b = 0 ⟹ b ∈ range(algebraMap k B)`. Reuse closed `_mvPoly_*` FREE-CASE helpers
+ `_hFunct` (L262–360).

**BRIGHT-LINE (STRATEGY.md):** if Mathlib lacks the "ker d = field of constants /
relative algebraic closure for separable extensions" lemma, STOP and report the
exact missing lemma name + signature. Do NOT add a helper layer or re-decompose.

### (c) HYGIENE (comment-only, no signature change)

- File-header status block L39–61: cites `: True := sorry` skeletons (gone) +
  abandoned closure chain. Refresh.
- KDM docstring L227–255 + `df_zero_factors_through_constant_on_chart` docstring
  L387–428: add the iter-152 `[IsAlgClosed k]`+`[IsDomain B]` hypotheses note.

## Expected outcome

- Minimum (high confidence): (a) closes → 9→8, pivot validated.
- Stretch: (b) closes → 9→7; or (b) reports a precise Mathlib gap for the
  iter-154 analogist consult.
