/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.RigidPushforwardFiberChart

/-!
# The chart comparison for an arbitrary affine base change

`Picard/RigidPushforwardFiberChart.lean` §3–§6 proves the degree-`0` "cohomology and base
change" chart comparison (Stacks 02KG, Mumford *Abelian Varieties* II §5, EGA III 7.7.5) for
the **fibre** base change `Spec κ(t) ⟶ Y` of a family `f : X ⟶ Y` over an affine base.  This
file is that same package for an **arbitrary** base change: any cartesian square

```
  X' --g'--> X
  |f'        |f
  v          v
  Y' --g---> Y
```

with `Y` and `Y'` affine.  Nothing else changes — the fibre is used in
`RigidPushforwardFiberChart` only through `Scheme.Hom.isPullback_fiberι`, i.e. only through
the cartesianness of its square, so the generalisation is a retargeting rather than new
mathematics.

`Picard/RigidPushforwardAffineDescent.lean` ("What remains, and the route the probe
identified for it", step 3) names exactly these two statements as the missing piece on the
route to `Adelic.RigidPushforwardGammaBaseChange`, the single open statement that the campaign
gate `Scheme.HasRigidPushforward` still costs.

## Contents

* `isPushout_appLE_chartBaseChange` — the section-ring pushout
  `Γ(X', g'⁻¹W) = Γ(X, W) ⊗_{Γ(Y, ⊤)} Γ(Y', ⊤)` on an affine chart `W ⊆ X`.  This is
  `isPushout_appLE_fiberChart` (`Picard/RigidPushforwardFiberChart.lean` §3) with the fibre
  square replaced by an arbitrary cartesian square; it is the *only* place where the fibre
  entered, and its general-square input `isPushout_appLE_of_isPullback'` (§1 of the same file)
  was already available.

* `exists_chartTensorEquiv` — the chart comparison
  `Γ(Y', ⊤) ⊗_{Γ(Y, ⊤)} Γ(M, W) ≅ Γ(g'^* M, g'⁻¹W)` for quasi-coherent `M`, sending
  `b ⊗ x` to `b · baseMap x`.  Generalises `exists_fiberChartTensorEquiv` (§5 there).

* `chart_smul_baseMap_res` — restriction naturality of that comparison, which is what makes
  the family `(Θ_W)_W` a map of Čech complexes.  Generalises `fiberChart_smul_baseMap_res`
  (§6 there); it carried no fibre-specific input to begin with.

Sources: Stacks 01HQ (affine base change of quasi-coherent modules), Stacks 02KG
(cohomology and base change) at `i = 0`; Mumford, *Abelian Varieties* II §5; EGA III 7.7.5.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace

namespace AlgebraicGeometry

namespace Adelic

/-! ## §1. The chart-level section-ring pushout for a general affine base change -/

/-- **The chart section-ring pushout of an arbitrary affine base change.**  For a cartesian
square

```
  X' --g'--> X
  |f'        |f
  v          v
  Y' --g---> Y
```

with `Y` and `Y'` affine, and an affine open `W ⊆ X`, the square

```
  Γ(Y, ⊤) ----> Γ(X, W)
     |             |
     v             v
  Γ(Y', ⊤) ---> Γ(X', g'⁻¹W)
```

is a pushout of commutative rings, i.e. `Γ(X', g'⁻¹W) = Γ(X, W) ⊗_{Γ(Y, ⊤)} Γ(Y', ⊤)`:
the chart `g'⁻¹W` of `X'` is the base change of the chart `W` along `Y' ⟶ Y` (Stacks 01HQ).

This is `isPushout_appLE_of_isPullback'` (`Picard/RigidPushforwardFiberChart.lean` §1) at
`V = O = ⊤`, `U = W`, `U' = g' ⁻¹ᵁ W = (g' ⁻¹ᵁ W) ⊓ (f' ⁻¹ᵁ ⊤)`; equivalently, it is
`isPushout_appLE_fiberChart` (§3 there) with the fibre square `X_t → X`, `X_t → Spec κ(t)`
replaced by an arbitrary cartesian square.  Affineness of `g' ⁻¹ᵁ W` is *not* assumed: it
follows from cartesianness inside `isPushout_appLE_of_isPullback'`. -/
theorem isPushout_appLE_chartBaseChange {X Y X' Y' : Scheme.{u}}
    {f : X ⟶ Y} {g : Y' ⟶ Y} {f' : X' ⟶ Y'} {g' : X' ⟶ X}
    (h : IsPullback g' f' f g) [IsAffine Y] [IsAffine Y']
    {W : X.Opens} (hW : IsAffineOpen W) :
    CategoryTheory.IsPushout
      (f.appLE ⊤ W le_top)
      (g.appLE ⊤ ⊤ le_top)
      (g'.appLE W (g' ⁻¹ᵁ W) le_rfl)
      (f'.appLE ⊤ (g' ⁻¹ᵁ W) le_top) :=
  isPushout_appLE_of_isPullback' h le_top le_top
    (inf_top_eq _).symm (isAffineOpen_top Y) (isAffineOpen_top Y') hW

/-! ## §2. The chart comparison isomorphism -/

/-- **The chart comparison isomorphism for an arbitrary affine base change** (Stacks 02KG at
`i = 0`, chart form; Mumford AV II §5).  For a cartesian square

```
  X' --g'--> X
  |f'        |f
  v          v
  Y' --g---> Y
```

with `Y` and `Y'` affine, a quasi-coherent module `M` on `X` and an affine open `W ⊆ X` whose
preimage chart `g' ⁻¹ᵁ W` is again affine, the sections of the pulled-back module `g'^* M`
over `g' ⁻¹ᵁ W` are the scalar extension of `Γ(M, W)` along `Γ(Y, ⊤) → Γ(Y', ⊤)`:

`Γ(Y', ⊤) ⊗_{Γ(Y, ⊤)} Γ(M, W) ≅ Γ(g'^* M, g' ⁻¹ᵁ W)`,

as additive groups, the isomorphism sending `b ⊗ x` to `b · (canonical base-map image of x)`.

The proof composes two existing pieces, exactly as for the fibre case:

* the **affine section formula**
  `pullback_app_isoTensor_baseMap_sectionLinearEquiv` (`Picard/QuotScheme.lean`, Stacks 01HQ)
  applied to `g'`, giving `Γ(X', g'⁻¹W) ⊗_{Γ(X, W)} Γ(M, W) ≅ Γ(g'^* M, g'⁻¹W)`;
* the **associativity bridge** `SectionBaseChange.bijective_addHom_of_isPushout`
  (`Picard/SectionBaseChange.lean`) along the chart section-ring pushout
  `isPushout_appLE_chartBaseChange` of §1, which rewrites the tensor factor
  `Γ(X', g'⁻¹W) = Γ(X, W) ⊗_{Γ(Y, ⊤)} Γ(Y', ⊤)` and cancels.

Only additivity is asserted: the source is a `Γ(Y', ⊤)`-module and the target a
`Γ(X', g'⁻¹W)`-module, and the comparison is semilinear over the structural map between them —
which is exactly the content of the displayed formula for `Θ (b ⊗ₜ x)`.

This is the base-change generalisation of `exists_fiberChartTensorEquiv`
(`Picard/RigidPushforwardFiberChart.lean` §5), obtained from it by the dictionary
`Y.fromSpecResidueField t ↝ g`, `f.fiberι t ↝ g'`, `f.fiberToSpecResidueField t ↝ f'`,
`f.fiberModule t M ↝ (Scheme.Modules.pullback g').obj M`, and the replacement of
`isPushout_appLE_fiberChart` by §1 above. -/
theorem exists_chartTensorEquiv {X Y X' Y' : Scheme.{u}}
    {f : X ⟶ Y} {g : Y' ⟶ Y} {f' : X' ⟶ Y'} {g' : X' ⟶ X}
    (h : IsPullback g' f' f g) [IsAffine Y] [IsAffine Y']
    (M : X.Modules) [M.IsQuasicoherent]
    {W : X.Opens} (hW : IsAffineOpen W) (hW' : IsAffineOpen (g' ⁻¹ᵁ W)) :
    letI : Algebra Γ(Y, ⊤) Γ(Y', ⊤) := (g.appLE ⊤ ⊤ le_top).hom.toAlgebra
    letI := f.baseSectionsModule M W
    Nonempty { Θ : TensorProduct Γ(Y, ⊤) Γ(Y', ⊤) Γ(M, W) ≃+
        Γ((Scheme.Modules.pullback g').obj M, g' ⁻¹ᵁ W) //
      ∀ (b : Γ(Y', ⊤)) (x : Γ(M, W)),
        Θ (b ⊗ₜ[Γ(Y, ⊤)] x) =
          (f'.appLE ⊤ (g' ⁻¹ᵁ W) le_top).hom b •
            pullback_app_isoTensor_baseMap g' M (le_refl (g' ⁻¹ᵁ W)) x } := by
  letI aAB : Algebra Γ(Y, ⊤) Γ(Y', ⊤) := (g.appLE ⊤ ⊤ le_top).hom.toAlgebra
  letI mAM := f.baseSectionsModule M W
  -- the algebra dictionary of the chart section-ring square
  letI aAC : Algebra Γ(Y, ⊤) Γ(X, W) := (f.appLE ⊤ W le_top).hom.toAlgebra
  letI aCD : Algebra Γ(X, W) Γ(X', g' ⁻¹ᵁ W) :=
    (g'.appLE W (g' ⁻¹ᵁ W) le_rfl).hom.toAlgebra
  letI aBD : Algebra Γ(Y', ⊤) Γ(X', g' ⁻¹ᵁ W) :=
    (f'.appLE ⊤ (g' ⁻¹ᵁ W) le_top).hom.toAlgebra
  letI aAD : Algebra Γ(Y, ⊤) Γ(X', g' ⁻¹ᵁ W) :=
    ((f.appLE ⊤ W le_top) ≫ (g'.appLE W (g' ⁻¹ᵁ W) le_rfl)).hom.toAlgebra
  have hsq := (isPushout_appLE_chartBaseChange h hW).w
  haveI tACD : IsScalarTower Γ(Y, ⊤) Γ(X, W) Γ(X', g' ⁻¹ᵁ W) :=
    IsScalarTower.of_algebraMap_eq (fun _ => rfl)
  haveI tABD : IsScalarTower Γ(Y, ⊤) Γ(Y', ⊤) Γ(X', g' ⁻¹ᵁ W) :=
    IsScalarTower.of_algebraMap_eq (fun r => by
      have h0 := congrArg
        (fun (φ : Γ(Y, ⊤) ⟶ Γ(X', g' ⁻¹ᵁ W)) => φ.hom r) hsq
      simp only [CommRingCat.hom_comp, RingHom.comp_apply] at h0
      exact h0)
  haveI pushAlg : Algebra.IsPushout Γ(Y, ⊤) Γ(X, W) Γ(Y', ⊤) Γ(X', g' ⁻¹ᵁ W) :=
    (CommRingCat.isPushout_iff_isPushout).mp (isPushout_appLE_chartBaseChange h hW)
  haveI tACM : IsScalarTower Γ(Y, ⊤) Γ(X, W) Γ(M, W) :=
    IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
  -- the affine section formula for the base-change projection `g'`
  obtain ⟨⟨eL, heL⟩⟩ :=
    pullback_app_isoTensor_baseMap_sectionLinearEquiv g' M hW' hW
      (le_refl (g' ⁻¹ᵁ W))
  -- the scalar-extension bridge along the chart pushout
  let s : TensorProduct Γ(Y, ⊤) Γ(Y', ⊤) Γ(M, W) →+
      TensorProduct Γ(X, W) Γ(X', g' ⁻¹ᵁ W) Γ(M, W) :=
    TensorProduct.liftAddHom
      (AddMonoidHom.mk' (fun b => AddMonoidHom.mk'
        (fun m => algebraMap Γ(Y', ⊤) Γ(X', g' ⁻¹ᵁ W) b ⊗ₜ[Γ(X, W)] m)
        (fun m₁ m₂ => TensorProduct.tmul_add _ m₁ m₂))
        (fun b₁ b₂ => by
          ext m
          simp [TensorProduct.add_tmul]))
      (fun r b m => by
        change algebraMap Γ(Y', ⊤) Γ(X', g' ⁻¹ᵁ W) (r • b) ⊗ₜ[Γ(X, W)] m =
          algebraMap Γ(Y', ⊤) Γ(X', g' ⁻¹ᵁ W) b ⊗ₜ[Γ(X, W)] (r • m)
        rw [Algebra.smul_def, map_mul,
          ← IsScalarTower.algebraMap_apply Γ(Y, ⊤) Γ(Y', ⊤) Γ(X', g' ⁻¹ᵁ W),
          IsScalarTower.algebraMap_apply Γ(Y, ⊤) Γ(X, W) Γ(X', g' ⁻¹ᵁ W),
          ← Algebra.smul_def, TensorProduct.smul_tmul,
          IsScalarTower.algebraMap_smul Γ(X, W) r m])
  have hs : ∀ (b : Γ(Y', ⊤)) (m : Γ(M, W)),
      s (b ⊗ₜ[Γ(Y, ⊤)] m) =
        algebraMap Γ(Y', ⊤) Γ(X', g' ⁻¹ᵁ W) b ⊗ₜ[Γ(X, W)] m :=
    fun b m => TensorProduct.liftAddHom_tmul _ _ b m
  have hs_bij : Function.Bijective s :=
    SectionBaseChange.bijective_addHom_of_isPushout s hs
  refine ⟨⟨AddEquiv.ofBijective (eL.toAddEquiv.toAddMonoidHom.comp s)
    ((EquivLike.bijective eL).comp hs_bij), ?_⟩⟩
  intro b x
  change eL (s (b ⊗ₜ[Γ(Y, ⊤)] x)) = _
  rw [hs b x]
  have hsm : (algebraMap Γ(Y', ⊤) Γ(X', g' ⁻¹ᵁ W) b ⊗ₜ[Γ(X, W)] x :
      TensorProduct Γ(X, W) Γ(X', g' ⁻¹ᵁ W) Γ(M, W)) =
      algebraMap Γ(Y', ⊤) Γ(X', g' ⁻¹ᵁ W) b •
        ((1 : Γ(X', g' ⁻¹ᵁ W)) ⊗ₜ[Γ(X, W)] x) := by
    rw [TensorProduct.smul_tmul', smul_eq_mul, mul_one]
  rw [hsm, map_smul, heL]
  rfl

/-! ## §3. Restriction naturality of the chart comparison -/

/-- **The chart comparison is compatible with restriction.**  In terms of the explicit formula
`Θ_W (b ⊗ x) = b · baseMap_W x` of §2 (`exists_chartTensorEquiv`), restricting along
`W'' ≤ g' ⁻¹ᵁ W` turns `Θ_W (b ⊗ x)` into `Θ_{W₀} (b ⊗ x|_{W₀})` for any `W₀ ≤ W` with
`W'' ≤ g' ⁻¹ᵁ W₀`:

`(Θ_W (b ⊗ x))|_{W''} = b · baseMap_{W''} (x|_{W₀})`.

Two ingredients, neither of them base-change specific: the section restriction of a sheaf of
modules is semilinear (`Scheme.Modules.map_smul`) and the structural scalar restricts correctly
(`Scheme.Hom.appLE_map`); and the canonical base map commutes with restriction
(`pullback_app_isoTensor_baseMap_res'`, `Picard/RigidPushforwardFiberChart.lean` §4, which is
already stated for a general `g'`).

This is the naturality that makes the family `(Θ_W)_W` a map of *complexes*, hence the
affine-base-change Čech square possible.  It generalises `fiberChart_smul_baseMap_res`
(`Picard/RigidPushforwardFiberChart.lean` §6); note that neither the cartesian square nor any
affineness is needed here — only the two morphisms `f'` and `g'` out of `X'`. -/
lemma chart_smul_baseMap_res {X X' Y' : Scheme.{u}} (f' : X' ⟶ Y') (g' : X' ⟶ X)
    (M : X.Modules) {W W₀ : X.Opens} {W'' : X'.Opens}
    (hWW₀ : W₀ ≤ W) (hW'' : W'' ≤ g' ⁻¹ᵁ W₀) (hle : W'' ≤ g' ⁻¹ᵁ W)
    (b : Γ(Y', ⊤)) (x : Γ(M, W)) :
    ((((Scheme.Modules.pullback g').obj M).presheaf.map (homOfLE hle).op).hom
        ((f'.appLE ⊤ (g' ⁻¹ᵁ W) le_top).hom b •
          pullback_app_isoTensor_baseMap g' M (le_refl (g' ⁻¹ᵁ W)) x) :
        Γ((Scheme.Modules.pullback g').obj M, W'')) =
      (f'.appLE ⊤ W'' le_top).hom b •
        pullback_app_isoTensor_baseMap g' M hW''
          ((M.presheaf.map (homOfLE hWW₀).op).hom x) := by
  have hms := Scheme.Modules.map_smul ((Scheme.Modules.pullback g').obj M)
    (homOfLE hle)
    ((f'.appLE ⊤ (g' ⁻¹ᵁ W) le_top).hom b)
    (pullback_app_isoTensor_baseMap g' M (le_refl (g' ⁻¹ᵁ W)) x)
  have hr : (X'.presheaf.map (homOfLE hle).op).hom
        ((f'.appLE ⊤ (g' ⁻¹ᵁ W) le_top).hom b) =
      (f'.appLE ⊤ W'' le_top).hom b := by
    have h0 := congrArg
      (fun (φ : Γ(Y', ⊤) ⟶ Γ(X', W'')) => φ.hom b)
      (f'.appLE_map (le_top : (g' ⁻¹ᵁ W) ≤ f' ⁻¹ᵁ ⊤) (homOfLE hle).op)
    simp only [CommRingCat.hom_comp, RingHom.comp_apply] at h0
    exact h0
  have hb := pullback_app_isoTensor_baseMap_res' g' M
    (le_refl (g' ⁻¹ᵁ W)) hW'' hWW₀ hle x
  refine hms.trans ?_
  exact Eq.trans (congrArg (fun z => (X'.presheaf.map (homOfLE hle).op).hom
      ((f'.appLE ⊤ (g' ⁻¹ᵁ W) le_top).hom b) • z) hb)
    (congrArg (fun r => r • pullback_app_isoTensor_baseMap g' M hW''
      ((M.presheaf.map (homOfLE hWW₀).op).hom x)) hr)

end Adelic

end AlgebraicGeometry
