---
author: sync
content_type: theorem
created: '2026-07-16T21:14:29'
decl: AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine
docstring: "**Slice constancy on a saturated open: the agreement equation.** Let `X`\
  \ be complete (proper)\nover an algebraically closed `k̄`, `x₀` a\n`k̄`-point of\
  \ `X`, and `f : X ⊗ Y ⟶ Z` into a separated `Z`. Let `U = p₂⁻¹(V)` be a `p₂`-saturated\n\
  open of `X ⊗ Y` (the preimage of a set `Vset ⊆ Y`) on which `f` lands inside a single\
  \ **affine**\nopen `U₀ ⊆ Z`. Then `f` agrees on `U` with the collapsed map `retract\
  \ ≫ f`\n(`retract := lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y)`, i.e. `(x, y) ↦ (x₀,\
  \ y)`):\n\n  `U.ι ≫ f.left = U.ι ≫ (retract ≫ f).left`.\n\nThis is the cohomology-free\
  \ **route B** of the iter-159 `mathlib-analogist` consult\n(`analogies/rigidity-affineconst.md`);\
  \ it was the genuinely-deep residual of the Rigidity-Lemma\nchain and is now **PROVEN\
  \ axiom-clean** (iter-162), assembled here as a named top-level obligation\nfrom\
  \ Step 2 (`morphism_eq_of_eqAt_closedPoints`) over the per-slice Step 1\n(`rigidity_eqAt_closedPoint_of_proper_into_affine`).\
  \ The relative Stein-factorisation /\nproper-pushforward `f_*\U0001D4AA = \U0001D4AA\
  ` framing is a confirmed Mathlib gap and is **deliberately avoided**.\n\nThe intended\
  \ proof (no coherent cohomology):\n1. *Per closed slice.* For each closed point\
  \ `y ∈ Vset`, `κ(y) = k̄` (`[IsAlgClosed kbar]`, finite\n   type). Saturation puts\
  \ the whole fibre `X_y` inside `U`, so `f` maps the proper integral slice\n   `X_y\
  \ ≅ X` into the affine `U₀`. By `isField_of_universallyClosed` +\n   `finite_appTop_of_universallyClosed`\
  \ + alg-closedness, `Γ(X_y) = k̄`, so the slice maps to a\n   single `k̄`-point\
  \ of `U₀`\n   (`ext_of_isAffine`); that point is `f(x₀, y)`, since `(x₀, y) ∈ X_y`.\
  \ Hence `f` and `retract ≫ f`\n   agree at every closed point of `U`.\n2. *Globalise.*\
  \ Closed points are dense in the locally-of-finite-type `k̄`-scheme `U`\n   (`closure_closedPoints`,\
  \ the Jacobson-space property). Turning \"agrees at each closed point\"\n   into\
  \ one dominant probe (the coproduct `∐_{x∈closedPoints U} Spec κ(x) ⟶ U`, dense\
  \ range) and\n   feeding it to `ext_of_isDominant_of_isSeparated'` (the reduced-source\
  \ / separated-target rigidity\n   `rigidity_core` already uses) yields the morphism\
  \ equality on all of `U`. This last\n   \"dense-closed-points ⟹ hom-ext\" connective\
  \ is the one piece Mathlib does not package directly."
file: AlgebraicJacobian/RigidityLemma.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine
type: lean
updated: '2026-07-27T01:33:12'
---
theorem rigidity_eqOn_saturated_open_to_affine
    [IsAlgClosed kbar]
    {X Y Z : Over (Spec (.of kbar))}
    [IsProper X.hom]
    [GeometricallyIrreducible (X ⊗ Y).hom]
    [LocallyOfFiniteType (X ⊗ Y).hom]
    [IsReduced (X ⊗ Y).left]
    [IsSeparated Z.hom]
    (f : (X ⊗ Y) ⟶ Z)
    (x₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ X)
    (U : (X ⊗ Y).left.Opens)
    (Vset : Set Y.left)
    (_hUV : (U : Set (X ⊗ Y).left) = (snd X Y).left.base ⁻¹' Vset)
    (U₀ : Z.left.Opens) (_hU₀ : IsAffineOpen U₀)
    (_hfU : ∀ u ∈ (U : Set (X ⊗ Y).left), f.left.base u ∈ U₀) :
    (U.ι : (U : (X ⊗ Y).left.Opens).toScheme ⟶ (X ⊗ Y).left) ≫ f.left =
      (U.ι : (U : (X ⊗ Y).left.Opens).toScheme ⟶ (X ⊗ Y).left) ≫
        (lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f).left := by
  -- Target separatedness (absolute), from `IsSeparated Z.hom` and the affine base `Spec k̄`:
  -- `terminal.from Z.left = Z.hom ≫ terminal.from (Spec k̄)`, a composite of separated maps.
  haveI : Z.left.IsSeparated := by
    rw [Scheme.isSeparated_iff]
    have heq : terminal.from Z.left = Z.hom ≫ terminal.from (Spec (CommRingCat.of kbar)) :=
      terminal.hom_ext _ _
    rw [heq]; infer_instance
  -- A locally finite type scheme over the Jacobson base `Spec kbar` is Jacobson, and the
  -- open subscheme `U` inherits that property. Its closed points are therefore dense.
  haveI : JacobsonSpace ((U : (X ⊗ Y).left.Opens).toScheme) := by
    -- `Spec k̄` is Jacobson (a field is `IsArtinianRing`, hence `IsJacobsonRing`); transport
    -- across the locally-of-finite-type structure map to `(X ⊗ Y).left`; then inherit onto the
    -- open subscheme `U` along the open embedding `U.ι`.
    haveI : JacobsonSpace (X ⊗ Y).left :=
      LocallyOfFiniteType.jacobsonSpace (X ⊗ Y).hom
    exact JacobsonSpace.of_isOpenEmbedding U.ι.isOpenEmbedding
  -- Globalise the per-closed-point slice-constancy (Step 1,
  -- `rigidity_eqAt_closedPoint_of_proper_into_affine`) over the dense closed points (Step 2,
  -- `morphism_eq_of_eqAt_closedPoints`). This wires bridge 2's route B end to end.
  exact morphism_eq_of_eqAt_closedPoints fun x hx =>
    rigidity_eqAt_closedPoint_of_proper_into_affine f x₀ U Vset _hUV U₀ _hU₀ _hfU x hx