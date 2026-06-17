/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Picard.RelPicFunctor

/-!
# The `Scheme.Modules.tensorObj` substrate (A.1.c.SubT)

This file is the **A.1.c.SubT** file-skeleton sub-build chapter for the
positive-genus arm of `nonempty_jacobianWitness`. It records the dedicated
substrate on which the abelian-group instance of the relative Picard quotient
`Pic^♯_{C/k}(T) := Pic(C ×_k T) / π_T^* Pic(T)` rests (the residual `sorry`
of `AlgebraicJacobian/Picard/RelPicFunctor.lean`).

The mathematics is straightforward; the obstacle to formalisation is purely
infrastructural. The Lean construction of the abelian-group law
`[L] + [L'] := [L ⊗ L']` on isomorphism classes of line bundles requires three
ingredients on the Lean carrier:

1. a binary tensor-product operation
   `⊗ : Scheme.Modules X × Scheme.Modules X → Scheme.Modules X`;
2. the structure sheaf `O_X` as a designated unit object for `⊗`;
3. an inverse operation on the full subcategory of invertible objects, i.e.
   the dual `L⁻¹ = Hom(L, O_X)` of an invertible sheaf.

At Mathlib's pinned commit (`b80f227`), only a presheaf-level version of (1)
is available (`PresheafOfModules.Monoidal.tensorObj`); (2) and (3) are present
as scheme-level objects, but the binary operation in (1) that ties them
together at the `Scheme.Modules` level is missing, and there is no
`MonoidalCategory` instance on `Scheme.Modules X`. This file records the
project-side substrate that supplies (1) and consequently lifts (2) + (3)
into a monoidal-category structure on `Scheme.Modules X`.

## Status (iter-202 Lane TS — file-skeleton scaffold)

This file is the **iter-202 Lane TS** file-skeleton: each of the 4 pinned
declarations carries the *intended* substantive type signature (matching the
blueprint `\lean{...}` pin in `chapters/Picard_TensorObjSubstrate.tex`) with a
`sorry` body. The bodies are iter-203+ work: the `tensorObj` definition lifts
`PresheafOfModules.Monoidal.tensorObj` through sheafification, and the consumer
`PicSharp.addCommGroup_via_tensorObj` then closes the residual `addCommGroup`
sorry of `RelPicFunctor.lean` L235.

The 4 blueprint-pinned declarations are:

1. `AlgebraicGeometry.Scheme.Modules.tensorObj` (def) — the substrate binary
   operation `⊗ : Scheme.Modules X × Scheme.Modules X → Scheme.Modules X`,
   lifting `PresheafOfModules.Monoidal.tensorObj` on underlying presheaves
   composed with sheafification on the small Zariski site.
   Per blueprint `def:scheme_modules_tensorobj`.

2. `AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality` (def) — the
   functorial action of `⊗` on morphisms: a pair `f : M ⟶ M'`, `g : N ⟶ N'`
   determines `f ⊗ g : tensorObj M N ⟶ tensorObj M' N'`.
   Per blueprint `lem:scheme_modules_tensorobj_functoriality`.

3. `AlgebraicGeometry.Scheme.Modules.monoidalCategory` (instance) — the
   monoidal-category structure on `Scheme.Modules X` with tensor `⊗`, unit
   `O_X`, associator, unitors, and braiding inherited from
   `PresheafOfModules.Monoidal` under sheafification.
   Per blueprint `thm:scheme_modules_monoidal`.

4. `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` (def) — the
   `AddCommGroup` structure on the relative Picard quotient
   `Quotient (RelPicPresheaf.preimage_subgroup πC πT)`, built via the
   `tensorObj` substrate. This is the iter-204+ closure target for the Lane RPF
   L235/L266-269 `addCommGroup` residual sorry.
   Per blueprint `thm:rel_pic_addcommgroup_via_tensorobj`.

Plus (PUSH-BEYOND) the supporting helper lemmas of the lift section
(`lem:tensorobj_preserves_locally_trivial`,
`lem:tensorobj_inverse_invertible`, `lem:tensorobj_lift_onproduct`,
`lem:pullback_compatible_with_tensorobj`).

## References

Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (740 LOC,
4 pins). Source: [Kleiman], "The Picard scheme", §2 (FGA Explained Ch.9 §9.2),
Defs. `df:aPf` + `df:Pfs`; Stacks tags 01CR (Picard group), 03DM (relative
tensor product of `O_X`-modules). Mathlib module
`Mathlib.CategoryTheory.Monoidal.PresheafOfModules`
(`PresheafOfModules.Monoidal.tensorObj`).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

/-! ## §1. The substrate tensor-product operation -/

/-- **The substrate operation `⊗` on `Scheme.Modules X`.**

For a scheme `X` and `M, N : X.Modules`, the tensor product
`M ⊗_X N : X.Modules` is the sheafification of the presheaf-of-modules tensor
product `PresheafOfModules.Monoidal.tensorObj` of the underlying presheaves of
`M` and `N` (affine-locally `(M ⊗_X N)(Spec A) = M(Spec A) ⊗_A N(Spec A)`).

Per blueprint `def:scheme_modules_tensorobj`. iter-202 Lane TS scaffold: the
body is a typed `sorry`; the iter-203+ body lifts
`PresheafOfModules.Monoidal.tensorObj` through the sheafification functor on
the small Zariski site of `X`. -/
noncomputable def tensorObj {X : Scheme.{u}} (M N : X.Modules) : X.Modules :=
  ((PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
      (PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) M.val N.val) :
    SheafOfModules X.ringCatSheaf)

/-- **Functoriality of `⊗_X`.**

A pair of morphisms `f : M ⟶ M'` and `g : N ⟶ N'` in `X.Modules` determines a
morphism `f ⊗ g : tensorObj M N ⟶ tensorObj M' N'`, compatible with identities
and composition; the assignment `(M, N) ↦ tensorObj M N` thereby extends to a
bifunctor `X.Modules × X.Modules ⥤ X.Modules` natural in both arguments.

Per blueprint `lem:scheme_modules_tensorobj_functoriality`. iter-202 Lane TS
scaffold: the body is a typed `sorry`; the iter-203+ body inherits the
morphism action from `PresheafOfModules.Monoidal.tensorObj` under
sheafification. -/
noncomputable def tensorObj_functoriality {X : Scheme.{u}} {M M' N N' : X.Modules}
    (f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N' :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).map
    (MonoidalCategory.tensorHom
      (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) f.val g.val)

/-! ## §2. The monoidal-category structure -/

/-- **Monoidal-category structure on `Scheme.Modules X`.**

The bifunctor `⊗_X` of `tensorObj_functoriality`, with unit object the
structure sheaf `O_X`, associator `α`, left/right unitors `λ`, `ρ`, and
braiding `β` inherited from `PresheafOfModules.Monoidal` under sheafification,
satisfies the pentagon, triangle, and hexagon axioms; hence `Scheme.Modules X`
carries a canonical (symmetric) monoidal-category structure.

Per blueprint `thm:scheme_modules_monoidal`. iter-202 Lane TS scaffold: the
body is a typed `sorry`; the iter-203+ body discharges the coherence axioms
affine-locally (each reduces to the analogous identity for the tensor product
of modules over a commutative ring) and assembles the
`CategoryTheory.MonoidalCategory` instance. -/
noncomputable instance monoidalCategory {X : Scheme.{u}} :
    MonoidalCategory (X.Modules) :=
  sorry

/-! ## §3. The lift through `LineBundle.OnProduct` (PUSH-BEYOND supporting lemmas)

The following helper lemmas record the lift of the substrate to the
locally-trivial subcategory used by the relative Picard consumer. They are not
`\lean{...}`-pinned in the blueprint (their statements are descriptive); the
typed signatures here scaffold the iter-203+ bodies. -/

/-- **The substrate operation respects isomorphisms in both arguments.**

A pair of isomorphisms `e : M ≅ M'` and `e' : N ≅ N'` in `X.Modules` induces an
isomorphism `tensorObj M N ≅ tensorObj M' N'`, obtained by sheafifying the
tensor product (in the presheaf-of-modules monoidal category) of the underlying
presheaf isomorphisms `e.val`, `e'.val`. Its `hom` is
`tensorObj_functoriality e.hom e'.hom`. This is the reusable functor-of-isos
ingredient feeding `tensorObj_isLocallyTrivial`. -/
noncomputable def tensorObjIsoOfIso {X : Scheme.{u}} {M M' N N' : X.Modules}
    (e : M ≅ M') (e' : N ≅ N') : tensorObj M N ≅ tensorObj M' N' :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).mapIso
    (MonoidalCategory.tensorIso
      (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))
      ((SheafOfModules.forget X.ringCatSheaf).mapIso e)
      ((SheafOfModules.forget X.ringCatSheaf).mapIso e'))

/-- **The substrate tensor of the structure sheaf with itself is the structure
sheaf.**

`tensorObj 𝒪_X 𝒪_X ≅ 𝒪_X`, where `𝒪_X = SheafOfModules.unit X.ringCatSheaf` is the
designated unit object. Built from the presheaf-level left unitor
`λ_ (𝟙_)` (the unit of the `PresheafOfModules` monoidal category is exactly
`SheafOfModules.unit.val`) under sheafification, composed with the
sheafification-adjunction counit isomorphism on the (already-sheaf) unit. -/
noncomputable def tensorObj_unit_iso {X : Scheme.{u}} :
    tensorObj (SheafOfModules.unit X.ringCatSheaf) (SheafOfModules.unit X.ringCatSheaf)
      ≅ SheafOfModules.unit X.ringCatSheaf :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).mapIso
      (λ_ (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)))) ≪≫
    (asIso (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.val)).counit).app
      (SheafOfModules.unit X.ringCatSheaf)

/-- **Refining a trivialisation to a smaller open.** If `M` is trivialised on an
open `U` (`M.restrict U.ι ≅ 𝒪_U`), it is trivialised on every open `W ≤ U`.

The chart-chase is identical in spirit to `LineBundle.IsLocallyTrivial.pullback`:
factor `W.ι = (X.homOfLE hWU) ≫ U.ι`, transport through `restrictFunctorCongr`
and `restrictFunctorComp` to identify `M.restrict W.ι` with
`(M.restrict U.ι).restrict (X.homOfLE hWU)`, restrict the given trivialisation
`e` along that open immersion, and identify the restricted unit with the unit
via `restrictFunctorIsoPullback` + `pullbackObjUnitToUnit` (an isomorphism
because the open immersion's `Opens.map` is `Final`). -/
noncomputable def restrictIsoUnitOfLE {X : Scheme.{u}} {M : X.Modules} {U W : X.Opens}
    (hWU : W ≤ U)
    (e : M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    M.restrict W.ι ≅ SheafOfModules.unit (W : Scheme).ringCatSheaf := by
  have hWU' : W ≤ (𝟙 X) ⁻¹ᵁ U := hWU
  set j : (W : Scheme) ⟶ (U : Scheme) := Scheme.Hom.resLE (𝟙 X) U W hWU' with hj
  have hjι : j ≫ U.ι = W.ι := by rw [hj, Scheme.Hom.resLE_comp_ι, Category.comp_id]
  haveI : (TopologicalSpace.Opens.map j.base).Final :=
    CategoryTheory.final_of_representablyFlat _
  -- M.restrict W.ι ≅ (pullback W.ι).obj M
  refine (Scheme.Modules.restrictFunctorIsoPullback W.ι).app M ≪≫ ?_
  -- ≅ (pullback (j ≫ U.ι)).obj M
  refine (Scheme.Modules.pullbackCongr hjι.symm).app M ≪≫ ?_
  -- ≅ (pullback j).obj ((pullback U.ι).obj M)
  refine (Scheme.Modules.pullbackComp j U.ι).symm.app M ≪≫ ?_
  -- ≅ (pullback j).obj (M.restrict U.ι)
  refine (Scheme.Modules.pullback j).mapIso
    ((Scheme.Modules.restrictFunctorIsoPullback U.ι).symm.app M) ≪≫ ?_
  -- ≅ (pullback j).obj 𝒪_U
  refine (Scheme.Modules.pullback j).mapIso e ≪≫ ?_
  -- ≅ 𝒪_W
  haveI hI : IsIso (SheafOfModules.pullbackObjUnitToUnit j.toRingCatSheafHom) := inferInstance
  exact @asIso _ _ _ _ _ hI

/-- **Substrate tensor commutes with restriction along an open immersion.**

For an open immersion `f : Y ⟶ X` and `M N : X.Modules`,
`(tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`.

This is the single missing-infrastructure ingredient of `A.1.c.SubT`. It says
the substrate `⊗` (sheafification of the presheaf-of-modules tensor) commutes
with the restriction functor `restrictFunctor f ≅ pullback f` along an open
immersion. Mathematically it factors as: (i) the presheaf-of-modules tensor
commutes with the pullback of presheaves (sectionwise this is the
extension-of-scalars identity
`B ⊗_A (P ⊗_A Q) ≅ (B ⊗_A P) ⊗_B (B ⊗_A Q)` for `A → B`, Stacks 03DM); and
(ii) sheafification commutes with pullback along an open immersion (the
restriction is exact and the small-Zariski sheafification is local). Neither is
in Mathlib at the `SheafOfModules` level (there is no monoidal structure on
`SheafOfModules`, hence no strong-monoidal pullback). A genuine construction
requires either the `Localization.Monoidal` transport of the monoidal structure
through `PresheafOfModules.sheafification.IsLocalization` together with
`W.IsMonoidal` for `W := (J.W).inverseImage (toPresheaf _)` (an instance NOT
present in Mathlib and the real residual obstacle), or a direct sectionwise
construction. Left as a named typed `sorry` feeding `tensorObj_isLocallyTrivial`;
see the task result for the precise missing instance statement. -/
noncomputable def tensorObj_restrict_iso {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M N : X.Modules) :
    (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f) := by
  -- Reduce `restrict` to `pullback` along the open immersion `f`.
  refine (Scheme.Modules.restrictFunctorIsoPullback f).app (tensorObj M N) ≪≫ ?_
  -- Remaining genuine infrastructure goal: the pullback functor is strong
  -- monoidal for the substrate `⊗`, i.e.
  -- `(pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N`
  -- (here `(pullback f).obj M ≃ M.restrict f` again via
  -- `restrictFunctorIsoPullback`). At the underlying-presheaf level this is the
  -- extension-of-scalars identity `B ⊗_A (P ⊗_A Q) ≅ (B ⊗_A P) ⊗_B (B ⊗_A Q)`
  -- composed with the fact that sheafification commutes with pullback along an
  -- open immersion. Neither half exists at the `SheafOfModules` level in
  -- Mathlib (no monoidal structure ⇒ no strong-monoidal pullback). See the
  -- docstring above and the task result for the precise missing ingredient.
  sorry

/-- **Tensor product of locally-trivial modules is locally trivial.**

If `M, N : X.Modules` are locally trivial of rank one (line bundles), so is
their tensor product `tensorObj M N`. Per blueprint
`lem:tensorobj_preserves_locally_trivial`. The proof picks, for each point `x`,
a common affine open `W ∋ x` contained in trivialising opens `U` (for `M`) and
`U'` (for `N`), refines both trivialisations to `W` via `restrictIsoUnitOfLE`,
then transports through `tensorObj_restrict_iso`, the bifunctoriality
`tensorObjIsoOfIso`, and the unit isomorphism `tensorObj_unit_iso`:
`(M ⊗ N)|_W ≅ M|_W ⊗ N|_W ≅ 𝒪_W ⊗ 𝒪_W ≅ 𝒪_W`. The only residual gap is the
substrate-restriction compatibility `tensorObj_restrict_iso`. -/
lemma tensorObj_isLocallyTrivial {X : Scheme.{u}} {M N : X.Modules}
    (hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N) :
    LineBundle.IsLocallyTrivial (tensorObj M N) := by
  intro x
  obtain ⟨U, hxU, hU_aff, ⟨eM⟩⟩ := hM x
  obtain ⟨U', hxU', hU'_aff, ⟨eN⟩⟩ := hN x
  obtain ⟨W, hW_aff, hxW, hWsub⟩ :=
    exists_isAffineOpen_mem_and_subset (X := X) (x := x) (U := U ⊓ U') ⟨hxU, hxU'⟩
  have hWU : W ≤ U := le_trans hWsub inf_le_left
  have hWU' : W ≤ U' := le_trans hWsub inf_le_right
  refine ⟨W, hxW, hW_aff, ⟨?_⟩⟩
  exact tensorObj_restrict_iso W.ι M N ≪≫
    tensorObjIsoOfIso (restrictIsoUnitOfLE hWU eM) (restrictIsoUnitOfLE hWU' eN) ≪≫
    tensorObj_unit_iso

/-- **Inverse of an invertible module.**

Every line bundle `L : X.Modules` has a two-sided tensor inverse: there is a
locally-trivial `Linv : X.Modules` (the dual `L⁻¹ = Hom(L, O_X)`) together with
a tensor isomorphism `L ⊗_X Linv ≅ 𝟙_ (X.Modules)`. Per blueprint
`lem:tensorobj_inverse_invertible`. iter-202 Lane TS scaffold: typed `sorry`;
the iter-203+ body builds the dual and the contraction isomorphism, which is an
isomorphism affine-locally on a trivialising cover. -/
lemma exists_tensorObj_inverse {X : Scheme.{u}} {L : X.Modules}
    (hL : LineBundle.IsLocallyTrivial L) :
    ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧
      Nonempty (tensorObj L Linv ≅ 𝟙_ (X.Modules)) :=
  sorry

/-- **Restriction of `⊗` to the `LineBundle.OnProduct` carrier.**

For `S`-schemes `C, T`, the bifunctor `⊗_{C ×_S T}` restricts to the subtype
`LineBundle.OnProduct πC πT` of locally-trivial modules on `C ×_S T`, with unit
the structure sheaf and the dual as two-sided inverse. Per blueprint
`lem:tensorobj_lift_onproduct`. iter-202 Lane TS scaffold: typed `sorry`. -/
noncomputable def tensorObjOnProduct {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S)
    (L L' : LineBundle.OnProduct πC πT) : LineBundle.OnProduct πC πT :=
  ⟨tensorObj L.carrier L'.carrier,
    tensorObj_isLocallyTrivial L.isLocallyTrivial L'.isLocallyTrivial⟩

end Modules

/-! ## §4. Consumer: the `AddCommGroup` instance on the relative Picard quotient -/

namespace PicSharp

/-- **Abelian-group structure on the relative Picard quotient via
`Scheme.Modules.tensorObj`.**

For a base scheme `S`, a curve-side morphism `πC : C ⟶ S`, and a test object
`πT : T ⟶ S`, the relative Picard quotient
`Quotient (RelPicPresheaf.preimage_subgroup πC πT) = Pic(C ×_S T) / π_T^* Pic(T)`
carries a canonical `AddCommGroup` structure with addition the descent of the
tensor product `[L] + [L'] := [L ⊗ L']` of `Scheme.Modules.tensorObj`, neutral
element `[O_{C ×_S T}]`, and inverse `-[L] := [L⁻¹]`.

Per blueprint `thm:rel_pic_addcommgroup_via_tensorobj`. iter-202 Lane TS
scaffold: typed `sorry`. This is the iter-204+ closure target for the residual
`addCommGroup` sorry of `RelPicFunctor.lean` (L235); once this body lands, the
RPF instance closes against it. It is supplied as a `def` (rather than a global
`instance`) to avoid an instance diamond with the existing typed-`sorry`
`PicSharp.addCommGroup` instance in `RelPicFunctor.lean`. -/
noncomputable def addCommGroup_via_tensorObj {S C T : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) :
    AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT)) :=
  sorry

end PicSharp

end Scheme

end AlgebraicGeometry

/-! ## Project-local Mathlib supplement — monoidal sheafification of presheaves of modules

This section records the **verified axiom-clean decomposition** of the single
infrastructure obstacle blocking `Scheme.Modules.monoidalCategory` and
`Scheme.Modules.tensorObj_restrict_iso` (see `§2` and `§3` above): the absence,
at Mathlib's pinned commit, of a `MonoidalCategory` structure on
`SheafOfModules R` for the *relative* module tensor `⊗_R`.

The blueprint proof of `thm:scheme_modules_monoidal` (chapter
`Picard_TensorObjSubstrate.tex`) transports the monoidal structure through the
sheafification localization
`PresheafOfModules.sheafification α : PresheafOfModules R₀ ⥤ SheafOfModules R`,
which is an `IsLocalization` for
`W := (J.W).inverseImage (toPresheaf R₀)`
(Mathlib: `PresheafOfModules.sheafification.IsLocalization`,
`Mathlib.Algebra.Category.ModuleCat.Sheaf.Localization`). The generic
localization-monoidal transport
`CategoryTheory.Localization.Monoidal.instMonoidalCategoryLocalizedMonoidal`
produces the wanted `MonoidalCategory (SheafOfModules R)` from this localization
*together with* a `MorphismProperty.IsMonoidal W` instance.

The two declarations below close the **entire** transport pipeline
axiom-clean, reducing the whole substrate to the single residual fact
`whiskerLeft` (`W g → W (F ◁ g)`), which is the genuine Mathlib-absent
ingredient. They are stated at full generality (any site `J`, any presheaf of
commutative rings `R'`, any sheaf of rings `R` with the standard
locally-bijective/sheafify instances) so the `PresheafOfModules` monoidal
instance fires syntactically.

* `isMonoidal_W_of_whiskerLeft` builds `W.IsMonoidal` from `whiskerLeft` alone:
  `IsMultiplicative W` is automatic (an `inverseImage` of the multiplicative
  localizing property `J.W`), and `whiskerRight` follows from `whiskerLeft` via
  the symmetric braiding on `PresheafOfModules` (the `arrow_mk_iso_iff` trick of
  `CategoryTheory.GrothendieckTopology.W.whiskerRight`).
* `monoidalCategoryOfIsMonoidalW` is the transport proper: given
  `[W.IsMonoidal]`, it produces `MonoidalCategory (SheafOfModules R)` via
  `instMonoidalCategoryLocalizedMonoidal` with unit iso `Iso.refl`.

**Residual gap (precise).** The sole remaining fact is `whiskerLeft`:
for `g` inverted by sheafification (i.e. `W g`, equivalently `g` locally
bijective) and any `F`, the relative tensor `F ◁ g` is again inverted by
sheafification. The slick Mathlib proof for the *ambient* (cartesian / `⊗_ℤ`)
tensor on `Sheaf J A` (`CategoryTheory.GrothendieckTopology.W.whiskerLeft`)
goes through `MonoidalClosed A` and "the internal hom of a sheaf is a sheaf".
The analogue here requires `MonoidalClosed (PresheafOfModules R₀)` for the
relative `⊗_R` — **not present in Mathlib** (the closed structure on
`ModuleCat R` does not lift to presheaves of modules over a varying ring). That
closed-monoidal infrastructure (the module analogue of
`Mathlib.CategoryTheory.Sites.Monoidal`) is the genuine multi-file blocker. -/
section MathlibSupplementMonoidalSheafification

open CategoryTheory MonoidalCategory PresheafOfModules Localization.Monoidal

universe v' u'

variable {C : Type u'} [Category.{v'} C] {J : GrothendieckTopology C}
  {R' : Cᵒᵖ ⥤ CommRingCat.{v'}}

/-- **`W.IsMonoidal` reduces to `whiskerLeft`.** For the module-sheafification
localization property `W := (J.W).inverseImage (toPresheaf (R' ⋙ forget₂ _ _))`,
the `MorphismProperty.IsMonoidal W` structure follows from the single hypothesis
that `W` is stable under left whiskering (`W g → W (F ◁ g)`): the multiplicative
part is automatic, and the right-whiskering part follows from the symmetric
braiding on `PresheafOfModules`. Project-local: this is the precise, compiled
decomposition of the `thm:scheme_modules_monoidal` obstruction down to its lone
Mathlib-absent ingredient. -/
@[implicit_reducible]
noncomputable def isMonoidal_W_of_whiskerLeft
    (hwl : ∀ ⦃G₁ G₂ : PresheafOfModules (R' ⋙ forget₂ CommRingCat RingCat)⦄
        {g : G₁ ⟶ G₂}, ((J.W (A := AddCommGrpCat)).inverseImage (toPresheaf _)) g →
        ∀ (F : PresheafOfModules (R' ⋙ forget₂ CommRingCat RingCat)),
          ((J.W (A := AddCommGrpCat)).inverseImage (toPresheaf _)) (F ◁ g)) :
    ((J.W (A := AddCommGrpCat)).inverseImage
      (toPresheaf (R' ⋙ forget₂ CommRingCat RingCat))).IsMonoidal where
  whiskerLeft F _ _ g hg := hwl hg F
  whiskerRight {F₁ F₂} f hf G :=
    (((J.W (A := AddCommGrpCat)).inverseImage (toPresheaf _)).arrow_mk_iso_iff
      (Arrow.isoMk (β_ F₁ G) (β_ F₂ G))).2 (hwl hf G)

variable {R : Sheaf J RingCat.{v'}} (α : (R' ⋙ forget₂ CommRingCat RingCat) ⟶ R.obj)
  [Presheaf.IsLocallyInjective J α] [Presheaf.IsLocallySurjective J α]
  [J.WEqualsLocallyBijective AddCommGrpCat.{v'}]
  [HasWeakSheafify J AddCommGrpCat.{v'}]

/-- **Localization-monoidal transport for sheaves of modules.** Given a
`MorphismProperty.IsMonoidal W` instance for the module-sheafification
localization property `W := (J.W).inverseImage (toPresheaf R₀)`, the category
`SheafOfModules R` inherits a `MonoidalCategory` structure, transported from the
relative module tensor on `PresheafOfModules R₀` through the sheafification
localization functor `PresheafOfModules.sheafification α`
(`CategoryTheory.Localization.Monoidal.instMonoidalCategoryLocalizedMonoidal`
with unit iso `Iso.refl`). Project-local: this closes the transport half of
`thm:scheme_modules_monoidal` axiom-clean; combined with
`isMonoidal_W_of_whiskerLeft` it reduces `Scheme.Modules.monoidalCategory` to
exactly the `whiskerLeft` ingredient. -/
@[implicit_reducible]
noncomputable def monoidalCategoryOfIsMonoidalW
    [((J.W (A := AddCommGrpCat)).inverseImage
        (toPresheaf (R' ⋙ forget₂ CommRingCat RingCat))).IsMonoidal] :
    MonoidalCategory (SheafOfModules R) :=
  inferInstanceAs (MonoidalCategory
    (LocalizedMonoidal (L := sheafification α)
      (W := (J.W).inverseImage (toPresheaf _)) (Iso.refl _)))

end MathlibSupplementMonoidalSheafification

