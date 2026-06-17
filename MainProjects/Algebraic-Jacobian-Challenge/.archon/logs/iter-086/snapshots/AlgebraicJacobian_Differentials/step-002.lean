/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib.RingTheory.Kaehler.Basic
import Mathlib.AlgebraicGeometry.AffineScheme
import Mathlib.AlgebraicGeometry.Morphisms.FinitePresentation
import Mathlib.AlgebraicGeometry.Morphisms.Smooth
import Mathlib.Algebra.Category.ModuleCat.Differentials.Presheaf
import Mathlib.Algebra.Category.ModuleCat.Sheaf
import Mathlib.AlgebraicGeometry.Modules.Presheaf
import Mathlib.AlgebraicGeometry.Modules.Sheaf
import AlgebraicJacobian.Cohomology.StructureSheafModuleK

/-! # Relative Kähler differentials for schemes

This file constructs the sheaf of relative Kähler differentials `Ω_{X/S}`
of a morphism of schemes `f : X → S`, together with its universal derivation
`d : 𝒪_X → Ω_{X/S}`. It also states the cotangent exact sequence and the
characterisation of smoothness in terms of local freeness of `Ω`.

The construction builds on Mathlib's ring-theoretic `KaehlerDifferential`
and the presheaf-of-modules differential construction
`PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`.

## Status (iteration 064 — scaffold)

All main declarations have `sorry` bodies. Closure trajectory is estimated
at ~10 iterations per `STRATEGY.md`.

## References

Blueprint: `blueprint/src/chapters/Differentials.tex`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace AlgebraicGeometry

namespace AlgebraicGeometry.Scheme

variable {X Y S : Scheme.{u}}

/-! ## The relative cotangent presheaf and sheaf -/

/-- The relative cotangent **presheaf** of a morphism of schemes `f : X ⟶ S`.

On each open `U ⊆ X`, the sections are the Kähler differential module of
the ring map `O_S(f(U)) → O_X(U)` induced by `f`. More precisely, we use
the inverse-image presheaf `f⁻¹ O_S` on `X` and the canonical map to `O_X`;
the Kähler differential construction then gives a presheaf of `O_X`-modules.

Mathlib leverage: `TopCat.Presheaf.pullback` for `f⁻¹`,
`PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`
for the presheaf of Kähler differentials. -/
noncomputable def relativeDifferentialsPresheaf (f : X ⟶ S) : X.PresheafOfModules :=
  let φ' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm
    f.c
  PresheafOfModules.DifferentialsConstruction.relativeDifferentials' φ'

/-! ### Sheaf condition: decomposition

Closing `relativeDifferentialsPresheaf_isSheaf` is the main outstanding
gap of Phase B step 1. The mathematical proof has three layers:

1. **`KaehlerDifferential` commutes with localisation.** For a ring map
   `A → B` and `f ∈ B`, `Ω_{B[1/f]/A} ≅ Ω_{B/A} ⊗_B B[1/f]`. Mathlib's
   `KaehlerDifferential.isLocalizedModule` (and the scheme variant
   `KaehlerDifferential.isLocalizedModule_map`) provides this.
2. **The presheaf is a sheaf on the basis of affine basic opens.** On a
   basic open `D(f)` of `Spec B`, sections are `Ω_{B[1/f]/A}`. Gluing on a
   basic-open cover `{D(fᵢ)}` of `Spec B` follows from the localisation
   compatibility of step 1, applied to each `fᵢ`.
3. **Globalisation to all opens.** A presheaf on a scheme is a sheaf iff
   it is a sheaf on the basis of affine opens (more precisely, on the
   basic opens of every affine open). This is the standard scheme
   sheaf-of-modules construction.

The substep theorems below are the natural decomposition. Each remains
`sorry` pending the full proof; the structure mirrors the blueprint at
`blueprint/src/chapters/Differentials.tex`. -/

/-- Substep 1 (localisation compatibility): For an affine open `V` of `X`
mapped to an affine open `U` of `S`, the sections of
`relativeDifferentialsPresheaf` over `V` are isomorphic (as additive groups)
to the Kähler differential module `KaehlerDifferential (φ'.app (op V))`. -/
theorem relativeDifferentialsPresheaf_obj_kaehler (f : X ⟶ S)
    (V : (TopologicalSpace.Opens X.toTopCat)ᵒᵖ) :
    ((relativeDifferentialsPresheaf f).presheaf.obj V : Type _) =
      CommRingCat.KaehlerDifferential
        (((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat
          f.base).homEquiv _ _).symm f.c |>.app V) :=
  rfl

/-- The presheaf of relative differentials is a **sheaf** in the Zariski
topology: Kähler differentials commute with localisation, which gives the
gluing axiom on affine opens.

**Status (iter-065):** Sorry. Proof requires combining:
- Substep 1 (`relativeDifferentialsPresheaf_obj_kaehler`, definitional)
- Substep 2: sheaf condition on the basis of basic opens, derived from
  `KaehlerDifferential.isLocalizedModule`
- Substep 3: globalisation from a basis to all opens (Mathlib has
  `TopCat.Presheaf.IsSheaf.isSheafUniqueGluing` and `isSheafFor` lemmas
  for restricting to a basis)

The route via `SheafOfModules.IsQuasicoherent` is not viable since that
requires the result we are trying to prove (the presheaf must already be
a sheaf to be packaged as a `SheafOfModules`). -/
theorem relativeDifferentialsPresheaf_isSheaf (f : X ⟶ S) :
    Presheaf.IsSheaf (Opens.grothendieckTopology X.toTopCat)
      (relativeDifferentialsPresheaf f).presheaf := by
  -- Strategy: reduce to the underlying presheaf of types via
  -- `isSheaf_iff_isSheaf_comp`, then verify the sheaf condition on
  -- affine opens using `KaehlerDifferential.isLocalizedModule_map`.
  -- The proof requires substantial development of a
  -- "sheaf condition restricted to affine basis" lemma + the localisation
  -- compatibility for Kähler differentials in the scheme-language.
  sorry

/-- The sheaf of relative differentials `Ω_{X/S}`.

Packages the presheaf `relativeDifferentialsPresheaf` with the sheaf axiom
`relativeDifferentialsPresheaf_isSheaf` into the standard `X.Modules` shape. -/
noncomputable def relativeDifferentials (f : X ⟶ S) : X.Modules :=
  ⟨relativeDifferentialsPresheaf f, relativeDifferentialsPresheaf_isSheaf f⟩

/-! ## Universal derivation -/

/-- The universal derivation `d : 𝒪_X → Ω_{X/S}`.

On each affine open `V = Spec B` over `Spec A`, this is the Mathlib universal
derivation `d_{B/A} : B → Ω_{B/A}`. It is an `A`-linear sheaf map satisfying
the Leibniz rule `d(ab) = a d(b) + b d(a)`. -/
noncomputable def universalDerivation (f : X ⟶ S) :
    X.ringCatSheaf.presheaf ⋙ forget₂ RingCat AddCommGrpCat ⟶
      (relativeDifferentials f).val.presheaf := by
  let φ' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm
    f.c
  let d' := PresheafOfModules.DifferentialsConstruction.derivation' φ'
  have h_eq : X.ringCatSheaf.presheaf = X.presheaf ⋙ forget₂ CommRingCat RingCat := rfl
  refine {
    app := fun U ↦ AddCommGrpCat.ofHom (d'.d (X := U)),
    naturality := fun U V g ↦ ?naturality
  }
  case naturality =>
    ext x
    simp only [sheafCompose_obj_obj, PresheafOfModules.presheaf_obj_coe, Functor.comp_obj,
      CommRingCat.forgetToRingCat_obj, Functor.comp_map, AddCommGrpCat.hom_comp]
    suffices d'.d ((ConcreteCategory.hom (X.presheaf.map g)) x) =
        (ConcreteCategory.hom ((relativeDifferentialsPresheaf f).map g)) (d'.d x) by
      simpa using this
    exact d'.d_map g x

/-! ## Cotangent exact sequence

The cotangent exact sequence
```
  f^* Ω_{Y/S} ⟶ Ω_{X/S} ⟶ Ω_{X/Y} ⟶ 0
```
for a composition `X ⟶ Y ⟶ S` is decomposed into five named sub-claims:

1. `cotangentExactSeqAlpha` — the base-change cotangent map
   `f^* Ω_{Y/S} ⟶ Ω_{X/S}`. Locally, this is
   `KaehlerDifferential.mapBaseChange A A' B`, where `A → A' → B` is the
   tower of structure ring maps on an affine chart.
2. `cotangentExactSeqBeta` — the relative-quotient cotangent map
   `Ω_{X/S} ⟶ Ω_{X/Y}`. Locally, this is the surjection
   `KaehlerDifferential.map A A' B B` induced by the inclusion `A → A'`
   that kills the `A`-linear derivations factoring through `A'`.
3. `cotangentExactSeqAlpha_comp_Beta` — composition zero `α ≫ β = 0`,
   from the ring-level `KaehlerDifferential.exact_mapBaseChange_map` (the
   range of `mapBaseChange` lies in the kernel of `map`).
4. `cotangentExactSeqShortComplexExact` — exactness `ker β = im α`,
   from the same ring-level theorem and gluing.
5. `cotangentExactSeqBetaEpi` — `β` is an epi, from
   `KaehlerDifferential.map_surjective` applied on each affine chart.

The headline theorem `cotangent_exact_sequence` then assembles the
existential bundle from these five components without further sorries. -/

set_option maxHeartbeats 16000000 in
-- The d_target structure carries four non-trivial fields whose elaboration cost
-- exceeds the default 200k-heartbeat budget; the increase covers the full body.
/-- The base-change cotangent map `f^* Ω_{Y/S} ⟶ Ω_{X/S}`.

For a composition `X ⟶ Y ⟶ S`, this is the natural map whose local
description on an affine chart with rings `A = O_S(W)`, `A' = O_Y(f(V))`,
`B = O_X(V)` is `KaehlerDifferential.mapBaseChange A A' B`:
```
  Ω_{A'/A} ⊗_{A'} B ⟶ Ω_{B/A}
```
sending `da ⊗ b ↦ b · da` (where the right-hand `da` is the universal
derivation in `Ω_{B/A}`).

**Status:** sorry — the global construction requires gluing the local
base-change maps, mediated by `PresheafOfModules.homMk` applied to the
ring-level `KaehlerDifferential.mapBaseChange`. -/
noncomputable def cotangentExactSeqAlpha (f : X ⟶ Y) (g : Y ⟶ S) :
    (Scheme.Modules.pullback f).obj (relativeDifferentials g) ⟶
      relativeDifferentials (f ≫ g) := by
  -- Strategy. Apply the `pullback ⊣ pushforward` adjunction to convert the goal into the
  -- adjoint hom on `Y`, then build that hom from its underlying presheaf-of-modules morphism via
  -- the universal property of `relativeDifferentials' φ_g'`.
  --
  -- After `homEquiv.symm`, the goal becomes
  --   `relativeDifferentials g ⟶
  --      (Scheme.Modules.pushforward f).obj (relativeDifferentials (f ≫ g))`,
  -- both `Y.Modules`. Their underlying presheaves are
  --   LHS.val = relativeDifferentialsPresheaf g
  --           = PresheafOfModules.DifferentialsConstruction.relativeDifferentials' φ_g'
  --   RHS.val = (PresheafOfModules.pushforward f.toRingCatSheafHom.hom).obj
  --               (relativeDifferentialsPresheaf (f ≫ g))
  -- so it suffices to build a `PresheafOfModules` morphism between the underlying values, then
  -- package via `⟨·⟩` as a `SheafOfModules.Hom`.
  refine ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).symm ?_
  -- Set up the two ring presheaf morphisms that drive the relativeDifferentials' construction.
  let φ_g' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat g.base).homEquiv
    S.presheaf Y.presheaf).symm g.c
  let φ_fg' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat (f ≫ g).base).homEquiv
    S.presheaf X.presheaf).symm (f ≫ g).c
  let D_X := PresheafOfModules.DifferentialsConstruction.derivation' φ_fg'
  let adj_f := TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base
  let d_target :
      ((PresheafOfModules.pushforward f.toRingCatSheafHom.hom).obj
        (relativeDifferentialsPresheaf (f ≫ g))).Derivation' φ_g' :=
    { d := fun {U} => AddMonoidHom.mk' (fun b => D_X.d ((f.c.app U).hom b))
        (fun a b => by
          change D_X.d ((f.c.app U).hom (a + b)) =
            D_X.d ((f.c.app U).hom a) + D_X.d ((f.c.app U).hom b)
          rw [show (f.c.app U).hom (a + b) = (f.c.app U).hom a + (f.c.app U).hom b
                from map_add _ _ _]
          exact map_add D_X.d _ _)
      d_mul := by
        intro U a b
        dsimp only [AddMonoidHom.mk', AddMonoidHom.coe_mk, ZeroHom.coe_mk]
        rw [show (f.c.app U).hom (a * b) = (f.c.app U).hom a * (f.c.app U).hom b
              from map_mul _ _ _]
        exact D_X.d_mul _ _
      d_map := by
        intro U V f' x
        dsimp only [AddMonoidHom.mk', AddMonoidHom.coe_mk, ZeroHom.coe_mk]
        have hnat' : (f.c.app V).hom (Y.presheaf.map f' x) =
            X.presheaf.map ((TopologicalSpace.Opens.map f.base).map f'.unop).op
              ((f.c.app U).hom x) := by
          have h := congr_arg (fun h : _ ⟶ _ => (ConcreteCategory.hom h) x) (f.c.naturality f')
          simpa using h
        erw [hnat']
        exact D_X.d_map _ _
      d_app := by
        intro U a
        -- Adjunction-coherence (iter-078 closure): the goal after unfolding the
        -- AddMonoidHom.mk' wrapper is
        --   `D_X.d ((f.c.app U).hom (φ_g'.app U a)) = 0`.
        -- We build a Y-presheaf bridge
        --   τ : (pullback g).obj S.presheaf ⟶
        --         (pushforward f).obj ((pullback (f≫g)).obj S.presheaf)
        -- (dual to the η-bridge used in `cotangentExactSeqBeta`) via
        --   τ := adj_g.homEquiv.symm (adj_fg.unit.app S.presheaf).
        -- Then we prove the coherence
        --   τ ≫ (pushforward f).map φ_fg' = φ_g' ≫ f.c
        -- by applying adj_g.homEquiv to both sides (both collapse to (f≫g).c via the
        -- two homEquiv_symm/apply identities and the rfl-level composition law
        -- (f≫g).c = g.c ≫ (pushforward g).map f.c).  Reading the coherence at U
        -- factors `(f.c.app U).hom (φ_g'.app U a)` through `φ_fg'.app _`, killing the
        -- derivation D_X.d.
        dsimp only [AddMonoidHom.mk', AddMonoidHom.coe_mk, ZeroHom.coe_mk]
        -- The bridge τ.
        let τ : (TopCat.Presheaf.pullback CommRingCat g.base).obj S.presheaf ⟶
              (TopCat.Presheaf.pushforward CommRingCat f.base).obj
                ((TopCat.Presheaf.pullback CommRingCat (f ≫ g).base).obj S.presheaf) :=
          ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat g.base).homEquiv
              S.presheaf _).symm
            ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat (f ≫ g).base).unit.app
              S.presheaf)
        -- Coherence: τ ≫ (pushforward f).map φ_fg' = φ_g' ≫ f.c, by injectivity of
        -- adj_g.homEquiv plus the two homEquiv/Equiv.apply_symm_apply collapses.
        have hτ : τ ≫ (TopCat.Presheaf.pushforward CommRingCat f.base).map φ_fg' =
            φ_g' ≫ f.c := by
          apply ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat g.base).homEquiv
            _ _).injective
          rw [Adjunction.homEquiv_naturality_right,
              Adjunction.homEquiv_naturality_right]
          -- LHS: homEquiv τ ≫ pushforward g.map (pushforward f.map φ_fg')
          -- RHS: homEquiv φ_g' ≫ pushforward g.map f.c
          -- Both reduce to (f≫g).c.
          have eq1 : ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat g.base).homEquiv
                S.presheaf _) τ ≫
                (TopCat.Presheaf.pushforward CommRingCat g.base).map
                  ((TopCat.Presheaf.pushforward CommRingCat f.base).map φ_fg') = (f ≫ g).c := by
            have h1 : ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat g.base).homEquiv
                S.presheaf _) τ =
                (TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat (f ≫ g).base).unit.app
                  S.presheaf := by
              dsimp only [τ]
              exact Equiv.apply_symm_apply _ _
            rw [h1]
            -- adj_fg.unit.app S.presheaf ≫ pushforward g.map (pushforward f.map φ_fg')
            -- = adj_fg.unit.app S.presheaf ≫ pushforward (f≫g).map φ_fg'  [rfl]
            -- = adj_fg.homEquiv φ_fg' = (f ≫ g).c   [Equiv.apply_symm_apply on φ_fg']
            change (TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat
                (f ≫ g).base).homEquiv S.presheaf X.presheaf φ_fg' = _
            dsimp only [φ_fg']
            exact Equiv.apply_symm_apply _ _
          have eq2 : ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat g.base).homEquiv
                S.presheaf Y.presheaf) φ_g' ≫
                (TopCat.Presheaf.pushforward CommRingCat g.base).map f.c = (f ≫ g).c := by
            have h4 : ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat g.base).homEquiv
                S.presheaf Y.presheaf) φ_g' = g.c := by
              dsimp only [φ_g']
              exact Equiv.apply_symm_apply _ _
            rw [h4]
            rfl
          rw [eq1, eq2]
        -- Read off the coherence at U applied to a, getting the rewriting of
        -- (f.c.app U).hom (φ_g'.app U a) in terms of φ_fg'.
        change D_X.d ((ConcreteCategory.hom (f.c.app U))
          ((ConcreteCategory.hom (φ_g'.app U)) a)) = 0
        have happ : (ConcreteCategory.hom (f.c.app U))
              ((ConcreteCategory.hom (φ_g'.app U)) a) =
            (ConcreteCategory.hom (φ_fg'.app
              (Opposite.op ((TopologicalSpace.Opens.map f.base).obj U.unop))))
              ((ConcreteCategory.hom (τ.app U)) a) := by
          have h := congr_arg (fun h : _ ⟶ _ =>
            (ConcreteCategory.hom (NatTrans.app h U)) a) hτ.symm
          simpa using h
        rw [happ]
        exact D_X.d_app _ }
  let presheafHom : relativeDifferentialsPresheaf g ⟶
      (PresheafOfModules.pushforward f.toRingCatSheafHom.hom).obj
        (relativeDifferentialsPresheaf (f ≫ g)) :=
    (PresheafOfModules.DifferentialsConstruction.isUniversal' φ_g').desc d_target
  exact ⟨presheafHom⟩

set_option maxHeartbeats 16000000 in
-- GAP-FILL (iter-083, Lane 2): The η-coherence square underlying the descent
-- of `cotangentExactSeqBeta`. Fully closed via the inline adjunction chain
-- preserved verbatim from the iter-081 in-flight body. This is one of four
-- permitted helpers for `cotangentExactSeq_structure`. The lemma is in
-- existential form (∃ η, η ≫ φ_2' = φ_1') so that the witness η is
-- accessible by `obtain` inside both `cotangentExactSeqBeta`'s body and the
-- `h_epi` branch of `cotangentExactSeq_structure`.
/-- The η-coherence square underlying the descent of `cotangentExactSeqBeta`.

For schemes `X →f Y →g S`, there exists a natural transformation of
ring-presheaves
`η : (g ∘ f)⁻¹ 𝒪_S ⟶ f_* (f⁻¹ 𝒪_Y)`
satisfying the coherence `η ≫ φ₂' = φ₁'`, where
`φ₁' = (adj_{(f≫g).base}.homEquiv).symm (f ≫ g).c` and
`φ₂' = (adj_{f.base}.homEquiv).symm f.c` are the adjoint transposes of
the comorphisms `(f ≫ g).c` and `f.c`. This coherence is what packages
the natural map into the descent map underlying `β`. -/
lemma cotangentExactSeqBeta_hη (f : X ⟶ Y) (g : Y ⟶ S) :
    ∃ (η : (TopCat.Presheaf.pullback CommRingCat (f ≫ g).base).obj S.presheaf ⟶
            (TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf),
        η ≫ ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv
              Y.presheaf X.presheaf).symm f.c =
          ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat
              (f ≫ g).base).homEquiv S.presheaf X.presheaf).symm (f ≫ g).c := by
  let φ1' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat (f ≫ g).base).homEquiv
    S.presheaf X.presheaf).symm (f ≫ g).c
  let φ2' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv
    Y.presheaf X.presheaf).symm f.c
  let adj_f := TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base
  let adj_fg := TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat (f ≫ g).base
  let η : (TopCat.Presheaf.pullback CommRingCat (f ≫ g).base).obj S.presheaf ⟶
      (TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf :=
    (adj_fg.homEquiv S.presheaf
      ((TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf)).symm
      (g.c ≫ (TopCat.Presheaf.pushforward CommRingCat g.base).map
        (adj_f.unit.app Y.presheaf))
  refine ⟨η, ?_⟩
  change η ≫ φ2' = φ1'
  have h1 : adj_fg.homEquiv S.presheaf X.presheaf (η ≫ φ2') =
      adj_fg.homEquiv S.presheaf ((TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf) η
        ≫ (TopCat.Presheaf.pushforward CommRingCat (f ≫ g).base).map φ2' := by
    rw [Adjunction.homEquiv_naturality_right]
  have h2 : adj_fg.homEquiv S.presheaf
      ((TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf) η =
      g.c ≫ (TopCat.Presheaf.pushforward CommRingCat g.base).map
        (adj_f.unit.app Y.presheaf) := by
    dsimp [η]
    exact Equiv.apply_symm_apply _ _
  have h3 : (TopCat.Presheaf.pushforward CommRingCat (f ≫ g).base).map φ2' =
      (TopCat.Presheaf.pushforward CommRingCat g.base).map
        ((TopCat.Presheaf.pushforward CommRingCat f.base).map φ2') := rfl
  have h4 : adj_f.unit.app Y.presheaf ≫
      (TopCat.Presheaf.pushforward CommRingCat f.base).map φ2' = f.c := by
    have : adj_f.unit.app Y.presheaf ≫
        (TopCat.Presheaf.pushforward CommRingCat f.base).map φ2' =
        adj_f.homEquiv Y.presheaf X.presheaf φ2' := rfl
    rw [this]
    exact Equiv.apply_symm_apply _ _
  have h5 : adj_fg.homEquiv S.presheaf X.presheaf (η ≫ φ2') = (f ≫ g).c := by
    rw [h1, h2, h3]
    have h6 : (TopCat.Presheaf.pushforward CommRingCat g.base).map
          (adj_f.unit.app Y.presheaf) ≫
        (TopCat.Presheaf.pushforward CommRingCat g.base).map
          ((TopCat.Presheaf.pushforward CommRingCat f.base).map φ2') =
        (TopCat.Presheaf.pushforward CommRingCat g.base).map f.c := by
      rw [← Functor.map_comp]
      congr 1
    calc
      (g.c ≫ (TopCat.Presheaf.pushforward CommRingCat g.base).map
            (adj_f.unit.app Y.presheaf)) ≫
          (TopCat.Presheaf.pushforward CommRingCat g.base).map
            ((TopCat.Presheaf.pushforward CommRingCat f.base).map φ2') =
        g.c ≫ ((TopCat.Presheaf.pushforward CommRingCat g.base).map
            (adj_f.unit.app Y.presheaf) ≫
          (TopCat.Presheaf.pushforward CommRingCat g.base).map
            ((TopCat.Presheaf.pushforward CommRingCat f.base).map φ2')) := by
        simp only [Category.assoc]
      _ = g.c ≫ (TopCat.Presheaf.pushforward CommRingCat g.base).map f.c := by erw [h6]
      _ = (f ≫ g).c := rfl
  have h7 : adj_fg.homEquiv S.presheaf X.presheaf φ1' = (f ≫ g).c := by
    dsimp [φ1']
    exact Equiv.apply_symm_apply _ _
  rw [← h7] at h5
  exact (adj_fg.homEquiv S.presheaf X.presheaf).injective h5

set_option maxHeartbeats 16000000 in
-- The β-construction now uses the extracted `cotangentExactSeqBeta_hη` helper
-- (iter-083, Lane 2). The η-witness is obtained via destructure; the rest
-- of the body (d1 derivation + isUniversal'.desc) remains structurally
-- unchanged. The heartbeat lift is preserved as the `desc` elaboration cost
-- of `d1`'s structure still exceeds the default 200k budget.
/-- The relative-quotient cotangent map `Ω_{X/S} ⟶ Ω_{X/Y}`.

For a composition `X ⟶ Y ⟶ S`, this is the natural surjection whose
local description on an affine chart with rings `A = O_S(W)`,
`A' = O_Y(f(V))`, `B = O_X(V)` is `KaehlerDifferential.map A A' B B`:
```
  Ω_{B/A} ⟶ Ω_{B/A'}
```
sending the universal `A`-linear derivation to the universal `A'`-linear
derivation. -/
noncomputable def cotangentExactSeqBeta (f : X ⟶ Y) (g : Y ⟶ S) :
    relativeDifferentials (f ≫ g) ⟶ relativeDifferentials f := by
  let φ1' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat (f ≫ g).base).homEquiv
    S.presheaf X.presheaf).symm (f ≫ g).c
  let φ2' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv
    Y.presheaf X.presheaf).symm f.c
  let η := (cotangentExactSeqBeta_hη f g).choose
  have hη : η ≫ φ2' = φ1' := (cotangentExactSeqBeta_hη f g).choose_spec
  let d2 := PresheafOfModules.DifferentialsConstruction.derivation' φ2'
  let d1 : (PresheafOfModules.DifferentialsConstruction.relativeDifferentials'
      φ2').Derivation' φ1' := {
    d := d2.d
    d_mul := d2.d_mul
    d_map := d2.d_map
    d_app := fun {Z} a => by
      have h : φ1'.app Z a = φ2'.app Z (η.app Z a) := by
        rw [← hη]
        rfl
      have key := d2.d_app (η.app Z a)
      rw [← h] at key
      exact key
  }
  let presheafHom := (PresheafOfModules.DifferentialsConstruction.isUniversal' φ1').desc d1
  exact ⟨presheafHom⟩

-- GAP-FILL (iter-079, Lane 1): SheafOfModules epi reflected from PresheafOfModules
-- epi via the faithful forgetful functor `SheafOfModules.forget R`.
-- This is a one-step bridge using `Functor.epi_of_epi_map` combined with the
-- `SheafOfModules.instFaithfulPresheafOfModulesValRingCatForget` instance.
-- It is one of three project-local helpers for the `cotangentExactSeq_structure`
-- closure (the others are `Derivation.postcomp_comp` and
-- `SheafOfModules.exact_iff_stalkwise` below).
lemma _root_.SheafOfModules.epi_of_epi_presheaf
    {C : Type*} [Category C] {J : CategoryTheory.GrothendieckTopology C}
    {R : CategoryTheory.Sheaf J RingCat} {F G : SheafOfModules R} (f : F ⟶ G)
    (h : CategoryTheory.Epi f.val) : CategoryTheory.Epi f := by
  have : CategoryTheory.Epi ((SheafOfModules.forget R).map f) := by
    rw [SheafOfModules.forget_map]; exact h
  exact (SheafOfModules.forget R).epi_of_epi_map this

-- GAP-FILL (iter-081, Lane 2, Route (c)): A `PresheafOfModules.Derivation`
-- distributes over composition of morphisms of presheaves of modules:
--   `d.postcomp (f ≫ g) = (d.postcomp f).postcomp g`.
-- Fully closed via the `@[ext]`-generated extensionality and the auto-generated
-- `Derivation.postcomp_d_apply` simp lemma combined with `PresheafOfModules.comp_app`
-- and the `ModuleCat`/`LinearMap` composition unfolds. This is the Mathlib-shape
-- helper recommended by the iter-080 prover that sidesteps the inline-`d_target`
-- matcher pathology in `cotangentExactSeq_structure`'s `h_zero` branch.
@[simp]
lemma _root_.PresheafOfModules.Derivation.postcomp_comp
    {C : Type*} [Category C] {D : Type*} [Category D]
    {F : C ⥤ D} {S : Cᵒᵖ ⥤ CommRingCat} {R : Dᵒᵖ ⥤ CommRingCat}
    {M N P : _root_.PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat)}
    {φ : S ⟶ F.op ⋙ R}
    (d : M.Derivation φ) (f : M ⟶ N) (g : N ⟶ P) :
    d.postcomp (f ≫ g) = (d.postcomp f).postcomp g := by
  ext X b
  simp only [_root_.PresheafOfModules.Derivation.postcomp_d_apply,
             _root_.PresheafOfModules.comp_app]
  rfl

set_option maxHeartbeats 16000000 in
-- The body re-derives the local ring-presheaf morphisms `φ_g'/φ_fg'/φ_2'/adj_f`
-- and the adjunction-coherence lemmas `hcoh/hcoh_app/hd_app/hβ_fac` inline; the
-- combined elaboration exceeds the default 200k-heartbeat budget.
/-- The composition `α ≫ β = 0` of the two cotangent maps.

On each affine chart `A → A' → B`, this is the statement that
`KaehlerDifferential.mapBaseChange A A' B ≫ KaehlerDifferential.map A A' B B = 0`,
which follows directly from `KaehlerDifferential.exact_mapBaseChange_map`
(the range of the first map is contained in the kernel of the second).

**Status (iter-082).** `h_zero` closed via Route (c) (uses the `Derivation.postcomp_comp`
helper above + `Universal.fac` + a final adjunction-coherence collapse). `h_epi`
attempted via Route 2 (identify the descent with `CommRingCat.KaehlerDifferential.map`).
`h_exact` still requires the `SheafOfModules.exact_iff_stalkwise` stalkwise-criterion
gap-fill (multi-iteration TopCat-stalk preserves-exactness chain). -/
lemma cotangentExactSeq_structure (f : X ⟶ Y) (g : Y ⟶ S) :
    ∃ (h : cotangentExactSeqAlpha f g ≫ cotangentExactSeqBeta f g = 0),
      (CategoryTheory.ShortComplex.mk
        (cotangentExactSeqAlpha f g) (cotangentExactSeqBeta f g) h).Exact ∧
      CategoryTheory.Epi (cotangentExactSeqBeta f g) := by
  refine ⟨?h_zero, ?h_rest⟩
  case h_zero =>
    -- Iter-082 reinstated Route (c) chain (closed in iter-081 in-flight).
    apply ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).injective
    rw [Adjunction.homAddEquiv_zero, Adjunction.homEquiv_naturality_right]
    unfold cotangentExactSeqAlpha
    simp only [Equiv.apply_symm_apply]
    apply SheafOfModules.hom_ext
    change (PresheafOfModules.DifferentialsConstruction.isUniversal' _).desc _ ≫
        (PresheafOfModules.pushforward f.toRingCatSheafHom.hom).map
          (cotangentExactSeqBeta f g).val = 0
    apply (PresheafOfModules.DifferentialsConstruction.isUniversal' _).postcomp_injective
    rw [PresheafOfModules.Derivation.postcomp_comp]
    simp only [PresheafOfModules.Derivation.Universal.fac]
    apply PresheafOfModules.Derivation.ext
    ext U b
    -- Reintroduce the named ring-presheaf morphisms inline (consistent with
    -- `cotangentExactSeqAlpha`/`cotangentExactSeqBeta` bodies).
    set φ_g' : (TopCat.Presheaf.pullback CommRingCat g.base).obj S.presheaf ⟶ Y.presheaf :=
      ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat g.base).homEquiv
        S.presheaf Y.presheaf).symm g.c with hφ_g'
    set φ_fg' : (TopCat.Presheaf.pullback CommRingCat (f ≫ g).base).obj S.presheaf ⟶
        X.presheaf :=
      ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat (f ≫ g).base).homEquiv
        S.presheaf X.presheaf).symm (f ≫ g).c with hφ_fg'
    set φ_2' : (TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf ⟶ X.presheaf :=
      ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv
        Y.presheaf X.presheaf).symm f.c with hφ_2'
    set adj_f := TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base with hadj_f
    have hcoh : adj_f.unit.app Y.presheaf ≫
        (TopCat.Presheaf.pushforward CommRingCat f.base).map φ_2' = f.c := by
      have h1 : adj_f.unit.app Y.presheaf ≫
          (TopCat.Presheaf.pushforward CommRingCat f.base).map φ_2' =
        adj_f.homEquiv Y.presheaf X.presheaf φ_2' := rfl
      rw [h1, hφ_2']
      exact Equiv.apply_symm_apply _ _
    have hcoh_app : (f.c.app U).hom b =
        (φ_2'.app (Opposite.op ((TopologicalSpace.Opens.map f.base).obj U.unop))).hom
          ((adj_f.unit.app Y.presheaf).app U b) := by
      have h1 := congr_arg
        (fun (h : Y.presheaf ⟶
            (TopCat.Presheaf.pushforward CommRingCat f.base).obj X.presheaf) =>
          (ConcreteCategory.hom (NatTrans.app h U)) b) hcoh.symm
      simpa using h1
    have hd_app : (PresheafOfModules.DifferentialsConstruction.derivation' φ_2').d
        (X := Opposite.op ((TopologicalSpace.Opens.map f.base).obj U.unop))
        ((f.c.app U).hom b) = 0 := by
      rw [hcoh_app]
      exact PresheafOfModules.Derivation'.d_app _ _
    have hβ_fac : ∀ (d_t : (PresheafOfModules.DifferentialsConstruction.relativeDifferentials'
          φ_2').Derivation' φ_fg')
        (b' : X.presheaf.obj (Opposite.op ((TopologicalSpace.Opens.map f.base).obj U.unop))),
        (((PresheafOfModules.DifferentialsConstruction.isUniversal' φ_fg').desc d_t).app
            (Opposite.op ((TopologicalSpace.Opens.map f.base).obj U.unop))).hom
          ((PresheafOfModules.DifferentialsConstruction.derivation' φ_fg').d b') = d_t.d b' := by
      intro d_t b'
      have hfac := (PresheafOfModules.DifferentialsConstruction.isUniversal' φ_fg').fac d_t
      have hpt := PresheafOfModules.Derivation.congr_d hfac b'
      simp only [PresheafOfModules.Derivation.postcomp_d_apply] at hpt
      exact hpt
    simp only [PresheafOfModules.Derivation.postcomp_d_apply]
    dsimp only [AddMonoidHom.mk', AddMonoidHom.coe_mk, ZeroHom.coe_mk]
    unfold cotangentExactSeqBeta
    change (((PresheafOfModules.DifferentialsConstruction.isUniversal' φ_fg').desc _).app
        (Opposite.op ((TopologicalSpace.Opens.map f.base).obj U.unop))).hom
          ((PresheafOfModules.DifferentialsConstruction.derivation' φ_fg').d
            ((f.c.app U).hom b)) = _
    rw [hβ_fac _ ((f.c.app U).hom b)]
    -- The remaining goal is `(d1_inline).d ((f.c.app U).hom b) = 0`.
    -- By the inline definition of d1 (in cotangentExactSeqBeta's body), this is
    -- definitionally `(derivation' φ_2').d ((f.c.app U).hom b)`, which is `hd_app`.
    exact hd_app
  case h_rest =>
    -- Iter-083 status: `h_zero` (the leading conjunct) is closed above via Route (c).
    -- The remaining conjunction is `h_exact ∧ h_epi`. **Helper `cotangentExactSeqBeta_hη`
    -- now extracted** (top-level lemma above; structural progress preserved across
    -- iterations even though closure still requires Mathlib gap-fills).
    --
    -- - `h_exact` requires the project-local `SheafOfModules.exact_iff_stalkwise`
    --   stalkwise-criterion helper (multi-iteration TopCat-stalk preserves-exactness
    --   chain) plus identifying the stalk of `relativeDifferentials` with
    --   `_root_.KaehlerDifferential` over local-ring stalks (no Mathlib equivalent
    --   exists). The stalkwise criterion itself would need a stalk functor on
    --   `SheafOfModules`, which is absent from Mathlib (only `TopCat.Presheaf.stalkFunctor`
    --   exists at the AddCommGrp level — bridging to `SheafOfModules` requires the
    --   `ModuleCat`-stalk infrastructure).
    --
    -- - `h_epi` Route 2: split via `SheafOfModules.epi_of_epi_presheaf` (iter-079) +
    --   `PresheafOfModules.epi_iff_surjective`. Reduces to per-section surjectivity
    --   of `((cotangentExactSeqBeta f g).val.app U)`. Identifying this descent with
    --   `CommRingCat.KaehlerDifferential.map (fac := hη.app U)` (whence `_root_.`-level
    --   surjectivity via `KaehlerDifferential.map_surjective`) requires
    --   `CommRingCat.KaehlerDifferential.ext` + tracing `desc_d` against the
    --   universal-property `(d1.app U).desc d b = d2.d b`. The iter-083 attempt
    --   discovered that `convert _root_.KaehlerDifferential.map_surjective using 1`
    --   leaves an iff residual whose forward direction is the identification step
    --   itself; the algebra-setup obstacle (need `Algebra`+`IsScalarTower` instances
    --   matching the bundled `CommRingCat.KaehlerDifferential` Module instance and
    --   the unbundled `_root_.KaehlerDifferential` instance simultaneously) survives
    --   even with `algebraize [(φ1'.app U).hom, (φ2'.app U).hom, (η.app U).hom]`
    --   because the bundled `Module` instance comes from `f.hom.toAlgebra` inside
    --   `CommRingCat.KaehlerDifferential`'s `letI`-block (which is unfolded by elaboration
    --   but does not unify with `algebraize`'s freshly-synthesised instance).
    --
    -- Iter-084 Lane 2: Option (c) — close `h_epi` via `_root_.KaehlerDifferential.span_range_derivation`
    -- (skips the bundled-vs-unbundled bridge by showing the descent's range contains
    -- every `d b` generator via `Universal.fac`, hence equals ⊤). `h_exact` deferred
    -- to iter-085+ pending `SheafOfModules.exact_iff_stalkwise` + ring-level
    -- `KaehlerDifferential.exact_mapBaseChange_map` chain — see comment block below.
    refine ⟨?h_exact, ?h_epi⟩
    case h_exact =>
      -- Iter-086 (Lane 2): the iter-085 false-signature helper has been reverted.
      -- Alternative route deferred: see `blueprint/src/chapters/Differentials.tex`
      -- § Cotangent exact sequence for the section-wise + sheafification strategy.
      sorry
    case h_epi =>
      -- Option (c) chain. The descent `(cotangentExactSeqBeta f g).val.app U`
      -- sends `(derivation' φ_fg').d b ↦ d2.d b = (derivation' φ_2').d b` by
      -- `Universal.fac`, so every `d b` is in the range. Since
      -- `KaehlerDifferential.span_range_derivation` (Mathlib) states that those
      -- generators span ⊤, the range is ⊤, hence the descent is surjective.
      apply SheafOfModules.epi_of_epi_presheaf
      rw [PresheafOfModules.epi_iff_surjective]
      intro U
      -- After unfolding, the descent's behaviour on generators is given by
      -- `ModuleCat.Derivation.desc_d`. We argue: every `(d b)` is in the range,
      -- and these generators span `⊤` by `_root_.KaehlerDifferential.span_range_derivation`.
      letI :=
        (((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv
              Y.presheaf X.presheaf).symm f.c).app U |>.hom.toAlgebra
      intro y
      -- Express `y` as a span of generators using `span_range_derivation`.
      have hspan := _root_.KaehlerDifferential.span_range_derivation
            ↑(((TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf).obj U)
            ↑(X.presheaf.obj U)
      have hy := hspan ▸ (Submodule.mem_top : y ∈ ⊤)
      induction hy using Submodule.span_induction with
      | mem x hx =>
        obtain ⟨b, rfl⟩ := hx
        refine ⟨CommRingCat.KaehlerDifferential.d b, ?_⟩
        unfold cotangentExactSeqBeta
        exact ModuleCat.Derivation.desc_d _ _
      | zero => exact ⟨0, map_zero _⟩
      | add x y hx hy ih_x ih_y =>
        obtain ⟨a₁, ha₁⟩ := ih_x
        obtain ⟨a₂, ha₂⟩ := ih_y
        refine ⟨a₁ + a₂, ?_⟩
        rw [map_add, ha₁, ha₂]; rfl
      | smul a x hx ih =>
        obtain ⟨a', ha'⟩ := ih
        refine ⟨a • a', ?_⟩
        rw [map_smul, ha']; rfl

/- ITER-076 disabled chain. Preserved as a reference block of the in-flight
strategy + Mathlib leverage names. Closure is iter-077+. The block was previously
a tactic chain with two trailing `sorry`s for `h_exact` and `h_epi`.

  -- Decomposition: produce the three named sub-claims in order. Each has a distinct
  -- ring-theoretic input via `KaehlerDifferential.exact_mapBaseChange_map` / `map_surjective`.
  -- The composition-zero witness depends on the concrete definition of `cotangentExactSeqAlpha`,
  -- so closure here is blocked behind that definition's completion.
  -- Iter-073 closure attempt. The strategy is identified for all three sub-claims; the
  -- mechanical execution of the lower-level identities below is the next-iteration target.
  -- The skeleton documents the proof shape and the local Mathlib leverage names so the
  -- next prover can drop straight into the inner identity-chasing.
  --
  -- The universal property of `relativeDifferentials' φ` lets us prove equalities of
  -- morphisms out of `relativeDifferentials' φ` by checking they postcompose with the
  -- universal derivation `derivation' φ` to the same Derivation
  -- (`isUniversal'.postcomp_injective`). Composed with the adjunction injectivity for the
  -- pullback/pushforward pair, this reduces `α ≫ β = 0` to a pointwise statement about
  -- `derivation' φ2'`-values; the ring-level inputs are
  -- `KaehlerDifferential.exact_mapBaseChange_map` (for `h_zero`/`h_exact`) and
  -- `KaehlerDifferential.map_surjective` (for `h_epi`).
  refine ⟨?_, ?_, ?_⟩
  · -- Sub-claim `h_zero` : `α ≫ β = 0`.
    --
    -- Strategy.
    -- Step 1: apply the adjunction injectivity for `Scheme.Modules.pullbackPushforwardAdjunction`.
    --   This converts the goal to a statement about the adjoint morphisms living in `Y.Modules`.
    -- Step 2: by `Adjunction.homEquiv_naturality_right` and additivity of the adjunction
    --   hom-set bijection (`Adjunction.homAddEquiv_zero`), the goal becomes
    --     `(homEquiv α) ≫ (pushforward f).map β = 0`   in `Y.Modules`.
    -- Step 3: unfolding `cotangentExactSeqAlpha`, the LHS factor `homEquiv α` simplifies to
    --   `⟨(isUniversal' φ_g').desc d_target⟩` (via `Equiv.apply_symm_apply`) where `d_target`
    --   is the Derivation' valued in the pushed-forward `relativeDifferentialsPresheaf (f ≫ g)`
    --   with `d_target.d b = D_X.d ((f.c.app U).hom b)` and `D_X := derivation' φ_fg'`.
    -- Step 4: drop to PresheafOfModules level via `SheafOfModules.hom_ext` (the morphisms
    --   agree iff their `.val`s agree).
    -- Step 5: apply `isUniversal'.postcomp_injective` to reduce the goal to a Derivation
    --   equality; both sides postcomposed with `derivation' φ_g'`.
    --   LHS-derivation maps `b ↦ (((pushforward f).map β.val).app U).hom (d_target.d b)
    --                            = (β.val.app (f⁻¹ U)).hom (D_X.d ((f.c.app U).hom b))`.
    --   RHS-derivation is zero (postcomp of zero is the zero derivation).
    -- Step 6: by `β.val`'s universal property (`(derivation' φ_fg').postcomp β.val = d1`,
    --   with `d1.d := d2.d := (derivation' φ2').d`), the LHS-derivation simplifies to
    --   `b ↦ d2.d ((f.c.app U).hom b)`.
    -- Step 7: the adjunction-coherence identity
    --   `f.c = adj_f.unit.app Y.presheaf ≫ (TopCat.Presheaf.pushforward _).map φ2'`
    --   gives `(f.c.app U).hom b = (φ2'.app (f⁻¹ U)).hom ((adj_f.unit.app _).app U b)`,
    --   so by `derivation' φ2'.d_app` the result vanishes.
    --
    -- Mathlib leverage names (all confirmed in iter-072):
    --   * `Adjunction.homEquiv_naturality_right` (Adjunction/Basic.lean L232)
    --   * `Adjunction.homAddEquiv_zero` (Adjunction/Additive.lean L66)
    --   * `Equiv.apply_symm_apply`
    --   * `SheafOfModules.hom_ext` (ModuleCat/Sheaf.lean L53)
    --   * `PresheafOfModules.DifferentialsConstruction.isUniversal'.postcomp_injective`
    --     (ModuleCat/Differentials/Presheaf.lean L101)
    --   * `PresheafOfModules.Derivation.d_app` (ModuleCat/Differentials/Presheaf.lean L63)
    --
    -- Tactic chain (Steps 1-7 of the strategy):
    apply ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).injective
    rw [Adjunction.homAddEquiv_zero, Adjunction.homEquiv_naturality_right]
    -- Goal: `(homEquiv α) ≫ (Scheme.Modules.pushforward f).map β = 0` in `Y.Modules`.
    -- Unfold α to expose `homEquiv α = ⟨isUniversal'.desc d_target⟩`:
    unfold cotangentExactSeqAlpha
    simp only [Equiv.apply_symm_apply]
    -- Goal: `⟨(isUniversal' φ_g').desc d_target⟩ ≫ (Scheme.Modules.pushforward f).map β = 0`
    --   in `Y.Modules`.
    -- Step 4: drop to PresheafOfModules level via `SheafOfModules.hom_ext`, then unfold
    -- the `.val` of the pushforward of `β` to expose
    -- `(PresheafOfModules.pushforward _).map β.val`.
    apply SheafOfModules.hom_ext
    simp only [SheafOfModules.comp_val, SheafOfModules.pushforward_map_val]
    -- Re-introduce local names for the ring presheaf morphisms inlined from
    -- `cotangentExactSeqAlpha`, so that the universal-property handle elaborates.
    set φ_g' : (TopCat.Presheaf.pullback CommRingCat g.base).obj S.presheaf ⟶ Y.presheaf :=
      ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat g.base).homEquiv
        S.presheaf Y.presheaf).symm g.c with hφ_g'
    set φ_fg' : (TopCat.Presheaf.pullback CommRingCat (f ≫ g).base).obj S.presheaf ⟶ X.presheaf :=
      ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat (f ≫ g).base).homEquiv
        S.presheaf X.presheaf).symm (f ≫ g).c with hφ_fg'
    set φ_2' : (TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf ⟶ X.presheaf :=
      ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv
        Y.presheaf X.presheaf).symm f.c with hφ_2'
    set adj_f := TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base with hadj_f
    -- Step 5: apply `isUniversal'.postcomp_injective`. Two morphisms out of
    -- `relativeDifferentials' φ_g'` agree iff their postcompositions with the
    -- universal derivation agree as Derivations.
    apply (PresheafOfModules.DifferentialsConstruction.isUniversal' φ_g').postcomp_injective
    -- Goal: equality of two `((pushforward).obj (relativeDifferentials' φ_fg'))`-valued
    -- Derivations over `φ_g'`. The RHS is the zero Derivation (postcomp of the zero hom).
    -- Step 6: reduce to pointwise via `Derivation` extensionality.
    ext U b
    -- Step 7: pointwise computation.
    --
    -- LHS `.d` at `b : Y.presheaf.obj U.unop` reduces, via the postcomp definition and the
    -- universal-property fact `(derivation' φ_g').postcomp αv = d_target`, to
    --   (β.val.app (f⁻¹ U) .hom) (D_X.d ((f.c.app U).hom b))
    -- where `D_X := derivation' φ_fg'`. By `β`'s universal property
    --   `(derivation' φ_fg').postcomp β.val = d1`   with `d1.d := (derivation' φ_2').d`
    -- (the `fac` from inside `cotangentExactSeqBeta`), this equals
    --   (derivation' φ_2').d ((f.c.app U).hom b).
    -- By the adjunction-coherence identity
    --   `f.c = adj_f.unit.app Y.presheaf ≫ (TopCat.Presheaf.pushforward _).map φ_2'`   (rfl)
    -- we have `(f.c.app U).hom b = (φ_2'.app (f⁻¹ U) .hom) ((adj_f.unit.app _).app U b)`.
    -- Then `Derivation'.d_app` for `φ_2'` (the universal derivation vanishes on the source
    -- presheaf of `φ_2'`) gives zero.
    --
    -- Note. `d_target` and `D_X` from `cotangentExactSeqAlpha`'s body are not in scope
    -- here (they are internal `let`s); they appear inline in the goal post-`unfold`.
    -- We work abstractly: build coherence and `d_app` ahead, then let simp + Universal.fac
    -- collapse the chain.
    --
    -- (a) Adjunction-coherence: f.c = adj_f.unit ≫ pushforward.map φ_2' (rfl chain).
    have hcoh : adj_f.unit.app Y.presheaf ≫
        (TopCat.Presheaf.pushforward CommRingCat f.base).map φ_2' = f.c := by
      have h1 : adj_f.unit.app Y.presheaf ≫
          (TopCat.Presheaf.pushforward CommRingCat f.base).map φ_2' =
        adj_f.homEquiv Y.presheaf X.presheaf φ_2' := rfl
      rw [h1, hφ_2']
      exact Equiv.apply_symm_apply _ _
    -- (c) Pointwise coherence at (U, b).
    have hcoh_app : (f.c.app U).hom b =
        (φ_2'.app (Opposite.op ((TopologicalSpace.Opens.map f.base).obj U.unop))).hom
          ((adj_f.unit.app Y.presheaf).app U b) := by
      have h1 := congr_arg (fun h => ConcreteCategory.hom (NatTrans.app h U) b) hcoh.symm
      simpa using h1
    -- (d) d_app for derivation' φ_2' via coherence.
    have hd_app : (PresheafOfModules.DifferentialsConstruction.derivation' φ_2').d
        (X := Opposite.op ((TopologicalSpace.Opens.map f.base).obj U.unop))
        ((f.c.app U).hom b) = 0 := by
      rw [hcoh_app]
      exact PresheafOfModules.Derivation'.d_app _ _
    -- (e) Reduce postcomp on both sides, split the composition αv ≫ βv, identify αv's
    --     effect via the universal property of `derivation' φ_g'`, then collapse via β.val's
    --     universal property combined with hd_app.
    --
    -- The simp chain below combines `postcomp_d_apply` (auto-generated `@[simps! d_apply]`
    -- on `Derivation.postcomp`), `PresheafOfModules.comp_app` (composition naturality), the
    -- ModuleCat composition/zero machinery, and `pushforward_map_app_apply` (the rfl-level
    -- description of `(pushforward _).map β.val` at U).
    simp only [PresheafOfModules.Derivation.postcomp_d_apply,
               PresheafOfModules.comp_app, PresheafOfModules.pushforward_map_app_apply,
               Limits.zero_app, ModuleCat.hom_zero, LinearMap.zero_apply, ModuleCat.hom_comp,
               LinearMap.comp_apply]
    -- After simp, the goal collapses the composition to nested linear-map applications.
    -- The inner `((isUniversal' φ_g').desc <inline-d_target>).app U .hom ((derivation' φ_g').d b)`
    -- reduces by the universal property (`Universal.fac`) to `<inline-d_target>.d U b`,
    -- which is definitionally `D_X.d ((f.c.app U).hom b)`. The outer application via
    -- `(pushforward _).map β.val` then drops to `β.val.app (op (f⁻¹ U.unop)) .hom (...)`,
    -- and by `β`'s universal property (the inner `fac` from `cotangentExactSeqBeta` applied
    -- to `d1`, whose `.d` is `(derivation' φ_2').d`) collapses further to
    -- `(derivation' φ_2').d ((f.c.app U).hom b)`. By `hd_app`, this is `0`.
    --
    -- Step 7c (residual `Universal.fac` chain, iter-076).
    -- We close the goal by chaining two pointwise instances of `Universal.fac` (one
    -- at the `φ_g'` level for `α`, one at the `φ_fg'` level for `β`) and then closing
    -- with `hd_app`. The pointwise versions are obtained from `Universal.fac` via
    -- `Derivation.congr_d` and the auto-simps `postcomp_d_apply`.
    --
    -- (α-fac) Pointwise universal property of `(isUniversal' φ_g')` applied to any
    -- `Derivation' φ_g'` valued in the pushed-forward target. Quantifying over `d_t`
    -- (rather than instantiating to the inline `d_target` from `cotangentExactSeqAlpha`'s
    -- body) lets `rw` unify with whichever inline term sits in the goal.
    have hα_fac : ∀ (d_t : ((PresheafOfModules.pushforward f.toRingCatSheafHom.hom).obj
          (relativeDifferentialsPresheaf (f ≫ g))).Derivation' φ_g')
        (b' : Y.presheaf.obj U),
        (((PresheafOfModules.DifferentialsConstruction.isUniversal' φ_g').desc d_t).app U).hom
          ((PresheafOfModules.DifferentialsConstruction.derivation' φ_g').d b') = d_t.d b' := by
      intro d_t b'
      have hfac := (PresheafOfModules.DifferentialsConstruction.isUniversal' φ_g').fac d_t
      have hpt := PresheafOfModules.Derivation.congr_d hfac b'
      simpa [PresheafOfModules.Derivation.postcomp_d_apply] using hpt
    rw [hα_fac _ b]
    -- After the rewrite, the inner expression is `<d_target_inline>.d b`. By the inline
    -- definition of `d_target` in `cotangentExactSeqAlpha`'s body (an `AddMonoidHom.mk'`
    -- wrapping `fun b' => D_X.d ((f.c.app U).hom b')` with `D_X := derivation' φ_fg'`),
    -- this equals `(derivation' φ_fg').d ((f.c.app U).hom b)` definitionally. A `dsimp`
    -- (or the implicit defeq used by `change`) collapses the structure projection.
    dsimp only [AddMonoidHom.mk', AddMonoidHom.coe_mk, ZeroHom.coe_mk]
    -- Goal now:
    --   ((cotangentExactSeqBeta f g).val.app (op (f⁻¹ U.unop))).hom
    --     ((derivation' φ_fg').d ((f.c.app U).hom b)) = 0
    -- Unfold `cotangentExactSeqBeta` so its `.val` exposes `(isUniversal' φ_fg').desc d1`.
    unfold cotangentExactSeqBeta
    -- (β-fac) Same pattern at φ_fg' level. The `d_t` here will unify with the inline `d1`
    -- from `cotangentExactSeqBeta`'s body.
    have hβ_fac : ∀ (d_t : (PresheafOfModules.DifferentialsConstruction.relativeDifferentials'
          φ_2').Derivation' φ_fg')
        (b' : X.presheaf.obj (Opposite.op ((TopologicalSpace.Opens.map f.base).obj U.unop))),
        (((PresheafOfModules.DifferentialsConstruction.isUniversal' φ_fg').desc d_t).app
            (Opposite.op ((TopologicalSpace.Opens.map f.base).obj U.unop))).hom
          ((PresheafOfModules.DifferentialsConstruction.derivation' φ_fg').d b') = d_t.d b' := by
      intro d_t b'
      have hfac := (PresheafOfModules.DifferentialsConstruction.isUniversal' φ_fg').fac d_t
      have hpt := PresheafOfModules.Derivation.congr_d hfac b'
      simpa [PresheafOfModules.Derivation.postcomp_d_apply] using hpt
    rw [hβ_fac _ ((f.c.app U).hom b)]
    -- Goal now: `<d1_inline>.d ((f.c.app U).hom b) = 0`. By the inline definition of
    -- `d1` in `cotangentExactSeqBeta` (`{ d := d2.d, ... }` with `d2 := derivation' φ_2'`),
    -- the `.d` field projects to `d2.d = (derivation' φ_2').d` (rfl after structure
    -- projection). So the goal is `(derivation' φ_2').d ((f.c.app U).hom b) = 0`, i.e.
    -- `hd_app`.
    exact hd_app
  · -- Sub-claim `h_exact` : the short complex is exact at the middle term.
    --
    -- Strategy.
    -- Same ring-level input as `h_zero`: `KaehlerDifferential.exact_mapBaseChange_map`
    -- states `Function.Exact (mapBaseChange R A B) (map R A B B)`, i.e. range equals kernel.
    -- For the sheaf-of-modules short complex, exactness is checked stalkwise: the
    -- stalk functor on sheaves of modules over a scheme preserves and reflects exactness,
    -- and at each stalk `Ω_{X/S,x}`, the cotangent short complex specialises to the
    -- ring-level exact sequence applied to the local ring chain
    -- `O_{S,g(f(x))} → O_{Y,f(x)} → O_{X,x}`.
    --
    -- The full implementation requires either:
    --   (a) a project-local `SheafOfModules.exact_iff_stalkwise` helper (the natural
    --       analogue of `Hom.isIso_iff_isIso_app` for stalks), or
    --   (b) routing through `ShortComplex.exact_iff_of_concrete_homology` with abelian-category
    --       infrastructure, or
    --   (c) building the exact-sequence witness directly from the ring-level Kähler exactness
    --       applied at each affine chart `A → A' → B`.
    -- Route (a) is the pragmatic choice. Left as `sorry` for the next iteration; the strategy
    -- + ring-level input are pinned.
    -- (sorry)
  · -- Sub-claim `h_epi` : `β` is an epimorphism.
    --
    -- Strategy.
    -- Local statement: on each affine chart, `KaehlerDifferential.map A A' B B` is surjective
    -- (Mathlib's `KaehlerDifferential.map_surjective`, RingTheory/Kaehler/Basic.lean L710).
    -- PresheafOfModules level: `PresheafOfModules.epi_iff_surjective`
    -- (ModuleCat/Presheaf/EpiMono.lean L59) characterises epi as locally-surjective.
    -- SheafOfModules level: an `epi_iff_epi_presheaf` helper is required to bridge from the
    -- PresheafOfModules-level epi to the SheafOfModules-level epi. Mathlib does not provide
    -- this directly; a project-local lemma using the abstraction layer of `Sheafify` /
    -- conservativity is the pragmatic route.
    -- Left as `sorry` for the next iteration; the strategy + ring-level input are pinned.
    -- (sorry)
-/

/-- Cotangent exact sequence for a composition of schemes `X ⟶ Y ⟶ S`.

For `f : X ⟶ Y` and `g : Y ⟶ S`, there is an exact sequence of
quasi-coherent `𝒪_X`-modules
```
  f^* Ω_{Y/S} ⟶ Ω_{X/S} ⟶ Ω_{X/Y} ⟶ 0.
```
Built on affine charts from the Mathlib ring-level cotangent exact
sequence (`KaehlerDifferential.exact_mapBaseChange_map`) and glued via the
compatibility above.

The three sub-declarations `cotangentExactSeqAlpha`, `cotangentExactSeqBeta`,
and `cotangentExactSeq_structure` carry the remaining sorries; this theorem
itself is closed by assembling them.

The composition-zero proof obligation is now an explicit existential
witness rather than an in-type `by sorry`, eliminating the iter-064/065
nested `by sorry` placeholder inside `ShortComplex.mk`. -/
theorem cotangent_exact_sequence (f : X ⟶ Y) (g : Y ⟶ S) :
    ∃ (α : (Scheme.Modules.pullback f).obj (relativeDifferentials g) ⟶
        relativeDifferentials (f ≫ g))
      (β : relativeDifferentials (f ≫ g) ⟶ relativeDifferentials f)
      (h : α ≫ β = 0),
      CategoryTheory.ShortComplex.Exact
        (CategoryTheory.ShortComplex.mk α β h) ∧
      CategoryTheory.Epi β := by
  obtain ⟨h, hex, hep⟩ := cotangentExactSeq_structure f g
  exact ⟨_, _, h, hex, hep⟩

/-! ## Smoothness and local freeness of `Ω` -/

/-- Smoothness of a finite-presentation morphism is equivalent to `Ω_{X/S}`
being locally free of the given rank.

The forward direction is the Jacobian criterion; the converse follows from
the cotangent exact sequence and Nakayama's lemma applied at each point. -/
theorem smooth_iff_locally_free_omega (f : X ⟶ S)
    (hfp : AlgebraicGeometry.LocallyOfFinitePresentation f) (n : ℕ) :
    Smooth f ↔
      ∀ (x : X), ∃ (U : X.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
        let R := X.ringCatSheaf.presheaf.obj (.op U)
        let M := (relativeDifferentials f).val.obj (.op U)
        Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n := by
  sorry

/-! ## Cotangent space at a section -/

/-- If `f : X ⟶ S` is smooth and `s : S ⟶ X` is a section of `f`, then the
cotangent space `s^* Ω_{X/S}` is a locally free `𝒪_S`-module of rank `n`.
In particular, if `S = Spec k` and `X` is smooth of relative dimension `n`,
the cotangent space at the corresponding `k`-point is an `n`-dimensional
`k`-vector space. -/
theorem cotangent_at_section (f : X ⟶ S)
    (hfp : AlgebraicGeometry.LocallyOfFinitePresentation f)
    (s : S ⟶ X) (hs : s ≫ f = 𝟙 S) (n : ℕ)
    (hsmooth : Smooth f) :
    ∀ (x : S), ∃ (U : S.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
      let R := S.ringCatSheaf.presheaf.obj (.op U)
      let M := ((Scheme.Modules.pullback s).obj (relativeDifferentials f)).val.obj (.op U)
      Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n := by
  sorry

/-! ## Restriction of scalars to k-modules -/

/-- The `O_C(U)`-module structure on `M(U)` viewed as a `k`-module via
restriction of scalars along the algebra map `k → O_C(U)`. -/
noncomputable abbrev moduleKPresheafOfModules_obj
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules)
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) : ModuleCat.{u} k :=
  (ModuleCat.restrictScalars (toModuleKSheaf.kToSection C U).hom).obj (M.val.obj U)

/-- Smul-naturality lemma for `moduleKPresheafOfModules`: the additive map
`M.val.presheaf.map f` commutes with the `k`-action on source and target after
restriction of scalars. -/
lemma moduleKPresheafOfModules_smul_compat
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules)
    {U V : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ} (f : U ⟶ V) (r : k) :
    M.val.presheaf.map f ≫ (moduleKPresheafOfModules_obj C M V).smul r =
      (moduleKPresheafOfModules_obj C M U).smul r ≫ M.val.presheaf.map f := by
  -- Strategy: lift to ModuleCat.smul_naturality applied to (M.val.map f) over O_C, then transport
  -- the smul argument from `(kToSection C U).hom r` to `(kToSection C V).hom r` using algebraMap
  -- naturality.
  have hsmul_src : (moduleKPresheafOfModules_obj C M U).smul r =
      (M.val.obj U).smul ((toModuleKSheaf.kToSection C U).hom r) := rfl
  have hsmul_tgt : (moduleKPresheafOfModules_obj C M V).smul r =
      (M.val.obj V).smul ((toModuleKSheaf.kToSection C V).hom r) := rfl
  rw [hsmul_src, hsmul_tgt]
  -- Now goal:
  --   M.val.presheaf.map f ≫ (M.val.obj V).smul (kV r)
  --     = (M.val.obj U).smul (kU r) ≫ M.val.presheaf.map f
  have hpres : M.val.presheaf.map f =
      (CategoryTheory.forget₂ (ModuleCat _) AddCommGrpCat).map (M.val.map f) := by
    apply AddCommGrpCat.Hom.ext
    ext x
    exact PresheafOfModules.presheaf_map_apply_coe M.val f x
  rw [hpres]
  -- Now goal in terms of (forget₂).map (M.val.map f); use ModuleCat.smul_naturality:
  have hnat := ModuleCat.smul_naturality (M.val.map f) ((toModuleKSheaf.kToSection C U).hom r)
  -- hnat has smul on the *target* of (M.val.map f) at index (kU r).
  -- That target is (restrictScalars (R.map f).hom).obj (M.val.obj V), so its .smul (kU r)
  -- is definitionally (M.val.obj V).smul ((R.map f).hom (kU r)).
  -- By algebraMap_naturality, (R.map f).hom (kU r) = (kV r), which is what we need.
  have halg : (RingCat.Hom.hom (C.left.ringCatSheaf.obj.map f))
        ((toModuleKSheaf.kToSection C U).hom r) =
      (toModuleKSheaf.kToSection C V).hom r := by
    rw [← toModuleKSheaf.algebraMap_eq_kToSection, ← toModuleKSheaf.algebraMap_eq_kToSection]
    exact toModuleKSheaf.algebraMap_naturality (C := C) f r
  -- Convert hnat's target smul to the desired form via halg
  have htarget : ((ModuleCat.restrictScalars
        (RingCat.Hom.hom (C.left.ringCatSheaf.obj.map f))).obj (M.val.obj V)).smul
        ((toModuleKSheaf.kToSection C U).hom r) =
      (M.val.obj V).smul ((toModuleKSheaf.kToSection C V).hom r) := by
    change (M.val.obj V).smul ((RingCat.Hom.hom (C.left.ringCatSheaf.obj.map f))
        ((toModuleKSheaf.kToSection C U).hom r)) =
      (M.val.obj V).smul ((toModuleKSheaf.kToSection C V).hom r)
    rw [halg]
  rw [htarget] at hnat
  exact hnat

/-- The restriction map for `moduleKPresheafOfModules`, extracted as a separate
definition so the elaborator does not have to inline the smul-naturality proof
inside the main `Functor` definition. -/
noncomputable def moduleKPresheafOfModules_map
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules)
    {U V : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ} (f : U ⟶ V) :
    moduleKPresheafOfModules_obj C M U ⟶ moduleKPresheafOfModules_obj C M V :=
  ModuleCat.homMk (M.val.presheaf.map f) (moduleKPresheafOfModules_smul_compat C M f)

@[simp] lemma moduleKPresheafOfModules_map_forget₂
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules)
    {U V : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ} (f : U ⟶ V) :
    (CategoryTheory.forget₂ (ModuleCat k) AddCommGrpCat).map
        (moduleKPresheafOfModules_map C M f) = M.val.presheaf.map f := by
  unfold moduleKPresheafOfModules_map
  exact ModuleCat.forget₂_map_homMk _ _

/-- The presheaf of `k`-modules obtained from an `O_C`-module by restriction of
scalars along the structure morphism `k → Γ(C, U)`.

On each open `U`, the sections are the `O_C(U)`-module `M(U)` viewed as a
`k`-module via the algebra map `k → O_C(U)`. The restriction maps are `k`-linear
by the naturality of this algebra map. -/
noncomputable def moduleKPresheafOfModules
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) :
    (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ ⥤ ModuleCat.{u} k where
  obj U := moduleKPresheafOfModules_obj C M U
  map f := moduleKPresheafOfModules_map C M f
  map_id U := by
    apply (CategoryTheory.forget₂ (ModuleCat k) AddCommGrpCat).map_injective
    rw [moduleKPresheafOfModules_map_forget₂, CategoryTheory.Functor.map_id]
    exact M.val.presheaf.map_id U
  map_comp {U V W} f g := by
    apply (CategoryTheory.forget₂ (ModuleCat k) AddCommGrpCat).map_injective
    rw [CategoryTheory.Functor.map_comp]
    simp only [moduleKPresheafOfModules_map_forget₂]
    exact M.val.presheaf.map_comp f g

/-- The presheaf of `k`-modules obtained by restriction of scalars is a sheaf:
its underlying presheaf of abelian groups coincides with that of the original
`O_C`-module. -/
lemma moduleKPresheafOfModules_isSheaf
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) :
    Presheaf.IsSheaf (Opens.grothendieckTopology C.left.toTopCat)
      (moduleKPresheafOfModules C M) := by
  rw [Presheaf.isSheaf_iff_isSheaf_comp _ _ (forget₂ (ModuleCat.{u} k) AddCommGrpCat.{u})]
  convert M.isSheaf using 1

/-- The sheaf of `k`-modules obtained from an `O_C`-module by restriction of
scalars along the structure morphism. -/
noncomputable def moduleKSheafOfModules
    {k : Type u} [CommRing k]
    (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) :
    Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k) :=
  ⟨moduleKPresheafOfModules C M, moduleKPresheafOfModules_isSheaf C M⟩

/-! ## Serre duality genus equality -/

/-- For a smooth proper geometrically irreducible curve `C` over a field `k`,
the dimension of `H^0(C, Ω_{C/k})` equals the dimension of `H^1(C, 𝒪_C)`,
and both equal the genus `g(C)`.

This is the dimension-one case of Serre duality applied to the canonical
sheaf `ω_C = Ω_{C/k}`. -/
theorem serre_duality_genus {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k))) [IsIntegral C.left] [IsProper C.hom]
    (hsmooth : Smooth C.hom) :
    Module.rank k (HModule k (toModuleKSheaf C) 0) =
      Module.rank k
        (HModule k (moduleKSheafOfModules C (relativeDifferentials C.hom)) 0) := by
  sorry

end AlgebraicGeometry.Scheme
