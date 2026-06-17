/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.CechAugmentedResolution
import AlgebraicJacobian.Cohomology.OpenImmersionPushforward
import AlgebraicJacobian.Cohomology.AcyclicResolution

/-! # Čech term acyclicity for the pushforward

## IMPORTANT signature correction (iter-077 prover)

The originally-planned signature of `cechTerm_pushforward_acyclic` (no hypothesis on `S`) is
**mathematically false**.  Counterexample: let `S` be the affine plane with a doubled origin,
`X = 𝔸²` and `f : X ⟶ S` the open immersion onto the first copy (an open immersion is separated,
and `f` is quasi-compact since everything is noetherian); `X` is affine and separated, so the
one-element cover `𝒰 = {𝟙 X}` is a finite affine cover.  Every Čech term is then isomorphic to
`F`, so the claimed conclusion specializes to `R^k f_* F = 0` for `k ≥ 1` — but for `F = O_X`
the stalk of `R^1 f_* O_X` at the doubled origin `o₂` is
`colim_{W ∋ 0} H^1(W \ {0}, O) ≅ H²_𝔪(A) ≠ 0` (`A` the local ring of the plane at the origin).
The underlying error in the informal proof: for affine `U ⊆ X` and affine `V ⊆ S`,
`U ∩ f⁻¹(V) ≅ U ×_S V` is affine only when the *diagonal of `S`* is affine (e.g. `S`
separated); `f` separated does not suffice.  Accordingly the lemma below carries the extra
hypothesis `[S.IsSeparated]` (what is really used is that `S` has affine diagonal, so any
morphism from an affine scheme to `S` is affine).  The same hypothesis is consequently REQUIRED
by the capstone `cech_computes_higherDirectImage_of_affineCover` (same counterexample: the Čech
complex of the trivial cover is `f_* F` in degree 0, with vanishing `H^1`, while
`R^1 f_* F ≠ 0`).

In addition, the proof must pass through the category of modules on the intersection schemes
`U_σ = (coverInterOpen 𝒰 σ).toScheme`, whose `HasInjectiveResolutions` instance is NOT available
in Mathlib (`IsGrothendieckAbelian (SheafOfModules R)` is absent — see CechToCohomology.lean);
exactly as the frozen target carries `[HasInjectiveResolutions X.Modules]` as a hypothesis, this
lemma carries the corresponding hypothesis `hres` for the (finitely many) intersection opens. -/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

variable {X S : Scheme.{u}}

/-! ## Auxiliary: additivity of the right-derived functor

Mathlib defines `Functor.rightDerived` but registers no `Additive` instance for it (nor for
`injectiveResolutions`).  We supply both here: two descents of `f + g` between chosen injective
resolutions are homotopic, so in the homotopy category the descent of a sum is the sum of the
descents; additivity of the right-derived functor follows by composition. -/

section RightDerivedAdditive

variable {𝒜 ℬ : Type*} [Category 𝒜] [Abelian 𝒜] [HasInjectiveResolutions 𝒜]
  [Category ℬ] [Abelian ℬ]

/-- The chosen-injective-resolutions functor `𝒜 ⥤ HomotopyCategory 𝒜` is additive: `desc f +
desc g` is also a descent of `f + g`, and any two descents are homotopic
(`InjectiveResolution.descHomotopy`). Project-local Mathlib supplement. -/
instance injectiveResolutions_additive : (injectiveResolutions 𝒜).Additive where
  map_add {Z W f g} := by
    dsimp only [injectiveResolutions]
    rw [← (HomotopyCategory.quotient 𝒜 (ComplexShape.up ℕ)).map_add]
    apply HomotopyCategory.eq_of_homotopy
    apply InjectiveResolution.descHomotopy (f + g)
    · exact InjectiveResolution.desc_commutes _ _ _
    · rw [Preadditive.comp_add, InjectiveResolution.desc_commutes,
        InjectiveResolution.desc_commutes, ← Preadditive.add_comp, ← Functor.map_add]

/-- The right-derived functor of an additive functor is additive (composite of the additive
`injectiveResolutions`, `mapHomotopyCategory` and homotopy-category homology functors).
Project-local Mathlib supplement. -/
lemma rightDerived_additive (G : 𝒜 ⥤ ℬ) [G.Additive] (n : ℕ) : (G.rightDerived n).Additive :=
  letI : G.rightDerivedToHomotopyCategory.Additive :=
    inferInstanceAs (injectiveResolutions 𝒜 ⋙
      G.mapHomotopyCategory (ComplexShape.up ℕ)).Additive
  inferInstanceAs (G.rightDerivedToHomotopyCategory ⋙
    HomotopyCategory.homologyFunctor ℬ (ComplexShape.up ℕ) n).Additive

/-- A biproduct of zero objects is zero: the identity equals zero because every component map
into a zero object is unique. Project-local helper. -/
lemma isZero_biproduct {C : Type*} [Category C] [HasZeroMorphisms C] {J : Type*}
    (Z : J → C) [HasBiproduct Z] (h : ∀ j, IsZero (Z j)) : IsZero (⨁ Z) := by
  rw [IsZero.iff_id_eq_zero]
  apply biproduct.hom_ext
  intro j
  exact (h j).eq_of_tgt _ _

/-- Right-`G`-acyclicity transports along an isomorphism. Project-local helper. -/
lemma isRightAcyclic_of_iso (G : 𝒜 ⥤ ℬ) [G.Additive] {A B : 𝒜} (e : A ≅ B)
    [G.IsRightAcyclic A] : G.IsRightAcyclic B where
  vanish k := (Functor.IsRightAcyclic.vanish (G := G) (J := A) k).of_iso
    ((G.rightDerived (k + 1)).mapIso e).symm

end RightDerivedAdditive

/-! ## Auxiliary: finite products of acyclic objects -/

/- Planner strategy: lem:rightAcyclic_finite_prod ·
A finite categorical product (= finite biproduct in an abelian category) of right-G-acyclic
objects is right-G-acyclic.  Since `G.rightDerived (k+1)` is additive it preserves finite
biproducts; each factor `(G.rightDerived (k+1)).obj (X i)` is zero by the per-factor acyclicity
instance, so their finite product/biproduct is zero.
Proof route: `Functor.IsRightAcyclic.vanish` on the product reduces to
`IsZero (∏ᶜ i, (G.rightDerived (k+1)).obj (X i))` (additive right-derived preserves ∏ᶜ), then
each factor is zero by `Functor.IsRightAcyclic.vanish i`, and a finite product of zero objects is
zero (`IsZero.prod` / `Limits.IsZero.pi`). -/
/-- **A finite product of right-`G`-acyclic objects is right-`G`-acyclic**
(blueprint `lem:rightAcyclic_finite_prod`).

Let `G : 𝒜 ⥤ ℬ` be an additive functor between abelian categories with injective resolutions,
and let `(X i)_{i : ι}` be a finite family of objects each right `G`-acyclic.  Then the
categorical product `∏ᶜ i, X i` is also right `G`-acyclic. -/
lemma rightAcyclic_finite_prod
    {𝒜 ℬ : Type*} [Category 𝒜] [Abelian 𝒜] [HasInjectiveResolutions 𝒜]
    [HasFiniteProducts 𝒜] [Category ℬ] [Abelian ℬ]
    (G : 𝒜 ⥤ ℬ) [G.Additive] {ι : Type*} [Finite ι]
    (Xf : ι → 𝒜) [∀ i, G.IsRightAcyclic (Xf i)] :
    G.IsRightAcyclic (∏ᶜ i, Xf i) := by
  constructor
  intro k
  haveI : (G.rightDerived (k + 1)).Additive := rightDerived_additive G (k + 1)
  -- Reindex along an equivalence `ι ≃ Fin n` so the `Type 0` finite-biproduct instances apply.
  obtain ⟨n, ⟨e⟩⟩ := Finite.exists_equiv_fin ι
  haveI : ∀ j : Fin n, G.IsRightAcyclic ((Xf ∘ e.symm) j) :=
    fun j => inferInstanceAs (G.IsRightAcyclic (Xf (e.symm j)))
  -- `∏ᶜ Xf ≅ ∏ᶜ (Xf ∘ e.symm) ≅ ⨁ (Xf ∘ e.symm)`, and the additive right-derived functor
  -- takes the biproduct to the biproduct of the (vanishing) per-factor values.
  refine IsZero.of_iso ?_
    ((G.rightDerived (k + 1)).mapIso
      (Pi.whiskerEquiv e (fun i => eqToIso (congrArg Xf (e.symm_apply_apply i))) ≪≫
        (biproduct.isoProduct (Xf ∘ e.symm)).symm) ≪≫
      (G.rightDerived (k + 1)).mapBiproduct (Xf ∘ e.symm))
  exact isZero_biproduct _ fun j =>
    Functor.IsRightAcyclic.vanish (G := G) (J := (Xf ∘ e.symm) j) k

/-! ## Auxiliary: a morphism from an affine scheme to a separated scheme is affine -/

/-- **A morphism from an affine scheme to a separated scheme is affine** (Stacks 01S7).
`g ≫ terminal.from S = terminal.from U` is affine because `U` is affine, and `terminal.from S`
is separated, so the cancellation property of affine morphisms applies. Project-local (the
identical statement exists as a `private` lemma in `OpenImmersionPushforward.lean`). -/
lemma isAffineHom_of_isAffine_of_isSeparated {U Z : Scheme.{u}} (g : U ⟶ Z)
    [IsAffine U] [Z.IsSeparated] : IsAffineHom g := by
  haveI hcomp : IsAffineHom (g ≫ terminal.from Z) := by
    have he : g ≫ terminal.from Z = terminal.from U := terminal.hom_ext _ _
    rw [he]; infer_instance
  exact IsAffineHom.of_comp g (terminal.from Z)

/-! ## Relative Serre vanishing for an affine morphism from an affine scheme

This is the generalization of `higherDirectImage_openImmersion_acyclic` from affine open
immersions into a separated scheme to arbitrary affine morphisms from an affine scheme: the
open-immersion hypothesis was only used there to derive `IsAffineHom j`, so we take the latter
as the hypothesis.  The proof is the same Stacks 01XJ + Serre-vanishing argument: `R^q j_* H`
is the sheafification of `V ↦ H^q(j⁻¹V, H)`, which dies sectionwise on the affine basis since
`j⁻¹V` is affine for affine `V`. -/

section AffineHomAcyclic

variable {U Z : Scheme.{u}}

/-- **Higher direct images along an affine morphism from an affine scheme vanish**
(Stacks `lemma-relative-affine-vanishing`, project-local generalization of
`higherDirectImage_openImmersion_acyclic` from open immersions to affine morphisms). -/
theorem higherDirectImage_affineHom_acyclic [HasInjectiveResolutions U.Modules]
    (j : U ⟶ Z) [IsAffineHom j] [IsAffine U]
    (H : U.Modules) (hH : H.IsQuasicoherent) (q : ℕ) (hq : 0 < q) :
    IsZero (higherDirectImage j q H) := by
  -- Presheaf description (Stacks 01XJ): `Rᵠ j_* H ≅ sheafify(V ↦ Hᵠ((j_* I•)(V)))`
  -- for any injective resolution `I` of `H`. Reduce to the vanishing of that sheafification.
  refine IsZero.of_iso ?_
    (higherDirectImage_iso_sheafify_presheafHomology j q (injectiveResolution H))
  set α : Z.ringCatSheaf.obj ⟶ Z.ringCatSheaf.obj := 𝟙 Z.ringCatSheaf.obj with hα
  set P := (pushforwardResolutionPresheafComplex j (injectiveResolution H)).homology q with hP
  -- Reflect `IsZero` through the faithful, zero-preserving forgetful functor `toSheaf`.
  apply Functor.isZero_of_faithful_preservesZeroMorphisms (SheafOfModules.toSheaf Z.ringCatSheaf)
  -- Transport across the sheafification square
  -- `toSheaf ∘ sheafification ≅ presheafToSheaf ∘ toPresheaf`.
  refine IsZero.of_iso ?_ ((PresheafOfModules.sheafificationCompToSheaf α).app P)
  set Q := (PresheafOfModules.toPresheaf Z.ringCatSheaf.obj).obj P with hQ
  -- KEY VANISHING: the presheaf homology `Q` is a *zero object* over every affine open
  -- `W ⊆ Z`, because `j⁻¹W` is affine (`j` is an affine morphism) and Serre vanishing
  -- (via the `Ext`-transport to the spectrum) kills `Hᵠ(j⁻¹W, H)` for `q ≥ 1`.
  have hSec : ∀ (W : TopologicalSpace.Opens Z), IsAffineOpen W →
      IsZero (Q.obj (Opposite.op W)) := by
    intro W hW
    -- Evaluate-at-`W` the presheaf complex; this functor preserves homology, so
    -- `Q.obj (op W) ≅ Hᵠ(Γ(W, j_* I•)) = Hᵠ(j⁻¹W, H)`, which vanishes for affine `j⁻¹W`.
    set GW := PresheafOfModules.toPresheaf Z.ringCatSheaf.obj ⋙
      (evaluation (TopologicalSpace.Opens Z)ᵒᵖ AddCommGrpCat).obj (Opposite.op W) with hGW
    set Kp := pushforwardResolutionPresheafComplex j (injectiveResolution H) with hKp
    refine IsZero.of_iso ?_ (GW.mapHomologyIso' (ComplexShape.up ℕ) Kp q).symm
    -- The section complex `n ↦ Γ(W, j_* I^n) = Γ(j⁻¹W, I^n)` is the image of the chosen
    -- injective resolution of `H` under the additive sections-over-`j⁻¹W` functor.
    have hcomplex : (GW.mapHomologicalComplex (ComplexShape.up ℕ)).obj Kp
        = ((pushforwardSectionsFunctor j W).mapHomologicalComplex (ComplexShape.up ℕ)).obj
            (injectiveResolution H).cocomplex :=
      rfl
    rw [hcomplex]
    -- `isoRightDerivedObj` recognises this homology as the `q`-th right derived sections
    -- functor `Rᵠ Γ(j⁻¹W, -)` applied to `H`, i.e. the absolute cohomology `Hᵠ(j⁻¹W, H)`.
    refine IsZero.of_iso ?_ ((injectiveResolution H).isoRightDerivedObj
      (pushforwardSectionsFunctor j W) q).symm
    -- The sections functor `Γ(j⁻¹W, -)` is corepresented by `jShriekOU (j ⁻¹ᵁ W)`, so its
    -- `q`-th right derived functor agrees with that of `Hom(jShriekOU (j ⁻¹ᵁ W), -)`.
    refine IsZero.of_iso ?_ ((rightDerivedNatIso (sectionsFunctorCorepIso (j ⁻¹ᵁ W)) q).app H)
    -- `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` reduces the right-derived vanishing
    -- of `Hom(jShriekOU (j⁻¹W), -)` to the `Ext`-vanishing.
    refine isZero_coyoneda_rightDerived_of_forall_ext_eq_zero (jShriekOU (j ⁻¹ᵁ W)) H q hq ?_
    intro e
    -- Discharged by `ext_jShriekOU_eq_zero_of_specIso` (the spectrum `Ext`-transport).
    refine ext_jShriekOU_eq_zero_of_specIso U U.isoSpec (j ⁻¹ᵁ W) H q hq
      (U.isoSpec.inv ⁻¹ᵁ (j ⁻¹ᵁ W)) ?hV' ?hjt ?hqc e
    -- `j⁻¹W` is affine (`j` is an affine morphism, `W` affine), and its preimage along the
    -- iso `U.isoSpec.inv` is affine.
    case hV' => exact (hW.preimage j).preimage_of_isIso U.isoSpec.inv
    case hjt => exact jShriekOU_transport_along_iso U.isoSpec (j ⁻¹ᵁ W)
    case hqc => exact pushforward_iso_preserves_qcoh U.isoSpec H hH
  -- Since affine opens form a basis of `Z`, every section of `Q` restricts to `0` on the
  -- affine opens contained in its domain, so `Q` is sectionwise locally zero and its
  -- sheafification vanishes.
  apply CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero
    (Opens.grothendieckTopology Z) (Q := Q)
  intro V s
  refine ⟨{ arrows := fun {W'} _ => ∃ W : TopologicalSpace.Opens Z,
              IsAffineOpen W ∧ W' ≤ W ∧ W ≤ V,
            downward_closed := ?_ }, ?_, ?_⟩
  · rintro W' W'' g ⟨A, hA, hWA, hAV⟩ h
    exact ⟨A, hA, le_trans (leOfHom h) hWA, hAV⟩
  · -- membership in the opens topology: every point of `V` has an affine basis neighbourhood
    intro x hx
    obtain ⟨W, hWmem, hxW, hWV⟩ :=
      (TopologicalSpace.Opens.isBasis_iff_nbhd.mp (Scheme.isBasis_affineOpens Z)) hx
    exact ⟨W, homOfLE hWV, ⟨W, hWmem, le_refl W, hWV⟩, hxW⟩
  · -- the restriction of `s` to a sieve member `W' ≤ A ≤ V` (with `A` affine) factors through
    -- `Q.obj (op A) = 0`, hence vanishes.
    rintro W' g ⟨A, hA, hWA, hAV⟩
    haveI : Subsingleton (ToType (Q.obj (Opposite.op A))) :=
      AddCommGrpCat.subsingleton_of_isZero (hSec A hA)
    have hgfac : g.op = (homOfLE hAV).op ≫ (homOfLE hWA).op := by
      rw [← op_comp]; congr 1
    rw [hgfac, Q.map_comp, ConcreteCategory.comp_apply,
      Subsingleton.elim ((ConcreteCategory.hom (Q.map (homOfLE hAV).op)) s) 0, map_zero]

end AffineHomAcyclic

/-! ## Affineness of the intersection opens of an affine cover of a separated scheme -/

/-- A finite (nonempty-indexed) infimum of affine opens of a separated scheme is affine.
Induction on the index bound via `IsAffineOpen.inf` (which needs the affine diagonal of `X`,
available since `X` is separated). Project-local helper. -/
private lemma isAffineOpen_iInf_fin [X.IsSeparated] :
    ∀ (p : ℕ) (W : Fin (p + 1) → X.Opens), (∀ k, IsAffineOpen (W k)) →
      IsAffineOpen (⨅ k, W k) := by
  haveI : IsClosedImmersion (pullback.diagonal (terminal.from X)) :=
    IsSeparated.isClosedImmersion_diagonal
  intro p
  induction p with
  | zero =>
    intro W hW
    have heq : (⨅ k, W k) = W 0 :=
      le_antisymm (iInf_le _ 0) (le_iInf fun k => by rw [Subsingleton.elim k 0])
    rw [heq]; exact hW 0
  | succ p ih =>
    intro W hW
    have hsplit : (⨅ k, W k) = W 0 ⊓ ⨅ k : Fin (p + 1), W k.succ := by
      refine le_antisymm (le_inf (iInf_le _ 0) (le_iInf fun k => iInf_le _ k.succ))
        (le_iInf fun k => ?_)
      rcases Fin.eq_zero_or_eq_succ k with hk | ⟨j, hj⟩
      · subst hk; exact inf_le_left
      · subst hj; exact inf_le_of_right_le (iInf_le _ j)
    rw [hsplit]
    exact (hW 0).inf (ih (fun k => W k.succ) (fun k => hW k.succ))

/-- The intersection open `U_σ = U_{σ 0} ∩ ⋯ ∩ U_{σ p}` of an affine open cover of a separated
scheme is affine. Project-local helper for `cechTerm_pushforward_acyclic`. -/
lemma isAffineOpen_coverInterOpen [X.IsSeparated] (𝒰 : X.OpenCover)
    (h𝒰 : ∀ i, IsAffine (𝒰.X i)) {p : ℕ} (σ : Fin (p + 1) → 𝒰.I₀) :
    IsAffineOpen (coverInterOpen 𝒰 σ) := by
  have hco : ∀ i, IsAffineOpen (coverOpen 𝒰 i) := by
    intro i
    haveI : IsAffine (𝒰.X i) := h𝒰 i
    exact isAffineOpen_opensRange (𝒰.f i)
  exact isAffineOpen_iInf_fin p (fun k => coverOpen 𝒰 (σ k)) (fun k => hco (σ k))

/-! ## Quasi-coherence of the restriction to an open subscheme -/

/-- **Restriction of a quasi-coherent module to an open subscheme is quasi-coherent**
(Stacks 01XZ-adjacent; project-local Mathlib supplement — Mathlib's `IsQuasicoherent` has no
restriction stability lemma).

Route: quasi-coherence is local (`SheafOfModules.IsQuasicoherent.of_coversTop`), and the
preimages under `V.ι` of the quasi-coherence cover of `X` cover `V.toScheme`.  The per-slice
obligation is the transport of the presentations of `F.over (q.X i)` to the double slice
`((pullback V.ι).obj F).over (V.ι ⁻¹ᵁ q.X i)`, through the general-opens analogue of the
`QcohRestrictBasicOpen.lean` restrict–over bridge (`Opens.overEquivalence`-engine +
`presentationOverBasicOpen`-style over-restriction, both of whose proofs are generic in the
open). -/
theorem isQuasicoherent_pullback_opens (V : X.Opens) (F : X.Modules)
    (hF : F.IsQuasicoherent) :
    ((Scheme.Modules.pullback V.ι).obj F).IsQuasicoherent := by
  obtain ⟨⟨q⟩⟩ := hF
  -- The preimages of the quasi-coherence cover of `X` cover the open subscheme.
  have hcov : (Opens.grothendieckTopology V.toScheme).CoversTop
      (fun i => V.ι ⁻¹ᵁ q.X i) := by
    intro W x hx
    obtain ⟨U', f, hf, hU'⟩ := q.coversTop ⊤ (V.ι.base x) (by trivial)
    obtain ⟨i, ⟨g⟩⟩ := hf
    refine ⟨W ⊓ (V.ι ⁻¹ᵁ q.X i), homOfLE inf_le_left, ⟨i, ⟨homOfLE inf_le_right⟩⟩,
      ⟨hx, ?_⟩⟩
    exact (leOfHom g) hU'
  haveI hslice : ∀ i, (((Scheme.Modules.pullback V.ι).obj F).over
      (V.ι ⁻¹ᵁ q.X i)).IsQuasicoherent := by
    intro i
    -- Per-slice presentation transport (the general-opens restrict–over bridge):
    -- `((pullback V.ι).obj F).over (V.ι ⁻¹ᵁ q.X i)` is, across the slice-site equivalence
    -- `Opens.overEquivalence`, the over-restriction `F.over (V ⊓ q.X i)`, which carries a
    -- presentation by the `presentationOverBasicOpen`-style over-restriction of
    -- `q.presentation i` along `V ⊓ q.X i ≤ q.X i`.  Porting that bridge from
    -- `QcohRestrictBasicOpen.lean` (where it is stated for `specBasicOpen g` but proved
    -- generically) is mechanical but substantial; deferred.
    sorry
  exact SheafOfModules.IsQuasicoherent.of_coversTop _ _ hcov

/-! ## The per-factor acyclicity -/

/-- **Each single push–pull factor `(j_V)_* (F|_V)` over an affine open `V` is right
`f_*`-acyclic** (the single-σ case of `cechTerm_pushforward_acyclic`).

`R^k f_* ((j_V)_* (F|_V)) ≅ R^k (j_V ≫ f)_* (F|_V)` by the open-immersion composition formula;
`j_V ≫ f : V ⟶ S` is a morphism from an affine scheme to the separated scheme `S`, hence an
affine morphism, and the relative Serre vanishing `higherDirectImage_affineHom_acyclic` kills
all `k ≥ 1`. Project-local. -/
lemma pushPullObj_opens_pushforward_acyclic [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) [X.IsSeparated] [S.IsSeparated]
    (V : X.Opens) (hV : IsAffineOpen V)
    [HasInjectiveResolutions V.toScheme.Modules]
    (F : X.Modules) (hFV : ((Scheme.Modules.pullback V.ι).obj F).IsQuasicoherent) :
    (Scheme.Modules.pushforward f).IsRightAcyclic
      (pushPullObj F (Over.mk V.ι)) := by
  haveI : IsAffine V.toScheme := hV
  constructor
  intro k
  -- `pushPullObj F (Over.mk V.ι)` is definitionally `(V.ι)_* ((V.ι)^* F)`.
  show IsZero (((Scheme.Modules.pushforward f).rightDerived (k + 1)).obj
    ((Scheme.Modules.pushforward V.ι).obj ((Scheme.Modules.pullback V.ι).obj F)))
  haveI : IsAffineHom (V.ι ≫ f) := isAffineHom_of_isAffine_of_isSeparated _
  exact (higherDirectImage_affineHom_acyclic (V.ι ≫ f) _ hFV (k + 1) k.succ_pos).of_iso
    (higherDirectImage_openImmersion_comp V.ι f _ hFV (k + 1))

/-! ## Čech term acyclicity for the pushforward -/

/- Planner strategy: lem:cech_term_pushforward_acyclic ·
Each degree-`p` Čech term `(cechComplexOnX 𝒰 F).X p` decomposes (via `lem:pushPull_sigma_iso`)
as a finite product `∏_σ (j_σ)_*(F|_{U_σ})` over multi-indices `σ = (i₀,…,i_p)`, with each
`U_σ` affine (X separated + all U_i affine).  By `rightAcyclic_finite_prod` it suffices to treat
a single factor `(j_s)_*(F|_{U_s})`.
By `higherDirectImage_openImmersion_comp` (OpenImmersionPushforward.lean):
  `R^k f_*((j_s)_*(F|_{U_s})) ≅ R^k (f∘j_s)_*(F|_{U_s})`.
The composite `f∘j_s : U_s → S` is a morphism from the affine `U_s` to the separated `S`,
hence an AFFINE morphism (this is where `[S.IsSeparated]` is REQUIRED — see the module
docstring for the counterexample without it).  Relative Serre vanishing for affine morphisms
(`higherDirectImage_affineHom_acyclic`) kills `H^k` for `k ≥ 1`.
Assembling: `R^k f_*(Cᵖ) = 0` for all `k ≥ 1`. -/
/-- **Each Čech term is right-`(f_*)`-acyclic** (blueprint `lem:cech_term_pushforward_acyclic`;
Stacks `lemma-relative-affine-vanishing`).

For a quasi-compact separated morphism `f : X ⟶ S` with `X` separated, **`S` separated** (see
the module docstring: the statement is false without an `S`-side hypothesis), and a finite
affine open cover `𝒰` of `X`, every term `(cechComplexOnX 𝒰 F).X p` of the un-augmented Čech
complex on `X` is right-acyclic for the pushforward functor `f_*`.

`hres` threads the `HasInjectiveResolutions` instances of the intersection subschemes, which
Mathlib cannot yet synthesize (same gap as the `[HasInjectiveResolutions X.Modules]` hypothesis
of the frozen capstone). -/
lemma cechTerm_pushforward_acyclic [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] [X.IsSeparated] [S.IsSeparated]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i))
    (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ)
    (hres : ∀ σ : Fin (p + 1) → 𝒰.I₀,
      HasInjectiveResolutions (coverInterOpen 𝒰 σ).toScheme.Modules) :
    (Scheme.Modules.pushforward f).IsRightAcyclic ((cechComplexOnX 𝒰 F).X p) := by
  -- Step 1: the degree-`p` term is (definitionally) the push–pull object of the backbone.
  have hX : (cechComplexOnX 𝒰 F).X p =
      pushPullObj F ((coverCechNerveOver 𝒰).obj (Opposite.op (SimplexCategory.mk p))) := rfl
  rw [hX]
  -- Step 2: each σ-factor is acyclic (composition formula + affine relative Serre vanishing).
  haveI hfac : ∀ σ : Fin (p + 1) → 𝒰.I₀,
      (Scheme.Modules.pushforward f).IsRightAcyclic
        (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) := by
    intro σ
    haveI := hres σ
    exact pushPullObj_opens_pushforward_acyclic f (coverInterOpen 𝒰 σ)
      (isAffineOpen_coverInterOpen 𝒰 h𝒰 σ) F
      (isQuasicoherent_pullback_opens (coverInterOpen 𝒰 σ) F hF)
  -- Step 3: a finite product of acyclic objects is acyclic; transport along the σ-product
  -- decomposition `pushPull_sigma_iso`.
  haveI : (Scheme.Modules.pushforward f).IsRightAcyclic
      (∏ᶜ fun σ : Fin (p + 1) → 𝒰.I₀ =>
        pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) :=
    rightAcyclic_finite_prod (Scheme.Modules.pushforward f) _
  exact isRightAcyclic_of_iso (Scheme.Modules.pushforward f) (pushPull_sigma_iso 𝒰 F p).symm

end AlgebraicGeometry
