/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.TensorObjSubstrate.StalkTensor
import AlgebraicJacobian.Picard.TensorObjSubstrate.Vestigial
import AlgebraicJacobian.Picard.TensorObjSubstrate.PresheafInternalHom
import AlgebraicJacobian.Picard.LineBundlePullback

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

## Status (current)

`tensorObj` and `tensorObj_functoriality` are fully defined (no `sorry`), lifting
`PresheafOfModules.Monoidal.tensorObj` through sheafification on the small Zariski
site. There are now THREE tracked typed-`sorry` residuals (iter-262): (a) the deferred
`⊗`-inverse lane (`exists_tensorObj_inverse`, ~L690, cross-file gated — closes via the
dual chain in `DualInverse.lean`); (b) the D3′ Sq1 sub-lemma `sheafificationCompPullback_comp`
(the `leftAdjointUniq` composition-coherence of the sheafification–pullback comparison — reduced
to the concrete unit identity, with the verified `conv_rhs` distribution applied and the
`R0`-peel building block `sheaf_unit_comp_pushforward_pullbackComp_inv` in place; see its proof);
and (c) the D3′-outer `pullbackTensorMap_restrict` (~L2620, the 4-square composition paste, gated
on Sq1 + the Sq4 connecting-iso coherence).  **D1′ (`pullbackTensorMap_natural`) is CLOSED
axiom-clean (iter-255)** via the mapin255 LIGHT `show…from` `δ_natural` `F`-ascription
(Sq2) plus the `.val`/`.obj` `erw`/`refine`-isDefEq Sq3/Sq4 assembly (see its proof
below).  **STEP A — the D1′-helper
`sheafifyTensorUnitIso_hom_natural` — is CLOSED axiom-clean (iter-254)** via the tscmp254
`tensorHom`-pin: `sheafifyTensorUnitIso_hom_eq'` states the comparison as ONE `a.map (η ⊗ η)`
(single monoidal instance on the `⋙ forget₂` carrier), and the naturality reduces to
bifunctoriality (`tensorHom_comp_tensorHom`, applied as a defeq-matched TERM with explicit
`(C := …)` to bridge the non-canonical instance) + the two single-component unit squares.
**D2′ is CLOSED axiom-clean** (iter-250):
the unit-square `(∗∗)` presheaf residual inside `pullbackEtaUnitSquare` is discharged,
so `pullbackEtaUnitSquare` → `pullbackTensorMap_unit_isIso` are sorry-free
(`pullbackTensorMap_unit_isIso` verified axiom-clean: only `propext`/`Classical.choice`/
`Quot.sound`). The `(∗∗)` close is the assembly of three project lemmas — the Y-side
sheafification right-triangle `pullbackSheafifyUnitEtaTriangle`, the presheaf mate
`presheafUnit_comp_map_eta`, and the step-7 `ε`-reconciliation `epsilonPresheafToSheafUnit`
(both sides act sectionwise as `φ.hom.app X`) — after the substep-(i) `.val` reshaping and a
SYNTACTIC `restrictScalars (𝟙)`-strip via the project lemma `restrictScalarsId_map` (stripping
`restrictScalars (𝟙)` by `whnf`/`show` on the sheafification-laden composites is catastrophic;
the propositional rewrite + `erw` reassociation sidesteps it). The whole abstract mate-calculus
telescope (steps 1–6: `homEquiv` transposition, `compHomEquivFactor`/`leftAdjointUniqUnitEta` via
`hkey`, the two `homEquiv_naturality` folds, the X-side triangle `hXtri`, the X-side `homEquiv`
collapse `hrhs`) is upstream of the close. (The route-(e)
whiskering residual `isLocallyInjective_whiskerLeft_of_W` was CLOSED iter-237 in
`Vestigial.lean`, so `tensorObj_assoc_iso` is now unconditional and axiom-clean.)
The dual-block is now
complete axiom-clean: the value layer (`InternalHom.internalHom`, `dual`,
`evalLin`/`internalHomEvalApp`) plus the evaluation morphism `internalHomEval`
(its naturality CLOSED iter-224, see below). The consumer `PicSharp.addCommGroup`
was rewired downstream in `RelPicFunctor.lean` (iter-247).

iter-224 on `internalHomEval`'s naturality: CLOSED axiom-clean. The iter-222/223 `whnf`
heartbeat-bomb diagnosis (the codomain `𝟙_` forcing `kabstract` to whnf the monoidal-unit
machinery on the first rewrite) was STALE — a Mathlib update made the composition split cleanly
with `erw [ModuleCat.hom_comp, …]`, after which the six-step `evalLin`/`naturality_apply`/`hdt`
reduction goes through with no bomb, no `with_reducible`, and no `maxHeartbeats` bump.

The 2 blueprint-pinned declarations are:

1. `AlgebraicGeometry.Scheme.Modules.tensorObj` (def) — the substrate binary
   operation `⊗ : Scheme.Modules X × Scheme.Modules X → Scheme.Modules X`,
   lifting `PresheafOfModules.Monoidal.tensorObj` on underlying presheaves
   composed with sheafification on the small Zariski site.
   Per blueprint `def:scheme_modules_tensorobj`.

2. `AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality` (def) — the
   functorial action of `⊗` on morphisms: a pair `f : M ⟶ M'`, `g : N ⟶ N'`
   determines `f ⊗ g : tensorObj M N ⟶ tensorObj M' N'`.
   Per blueprint `lem:scheme_modules_tensorobj_functoriality`.

(A full `MonoidalCategory (Scheme.Modules X)` instance is **deliberately not
built** — see §2 and blueprint `rem:scheme_modules_monoidal_off_path`. The group
law on iso-classes consumes only the *existence* of the three coherence
isomorphisms, never a coherent monoidal category, so no such instance is on the
critical path.)

The consumer `tensorObjOnProduct` and the `addCommGroup_via_tensorObj` stub now
live downstream in `RelPicFunctor.lean` (iter-247 import-cycle fix).

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

## Sub-module layout (iter-232 split)

The 2375-line monolith was split into sub-files under
`AlgebraicJacobian/Picard/TensorObjSubstrate/` (all imported by this file):

- `StalkTensor.lean` — the d.2 ingredient `stalkTensorIso` (`(A⊗ᵖB).stalk ≅ A.stalk ⊗ B.stalk`).
- `Vestigial.lean` — quarantined vestigial/route-(e) sections:
  `FlatWhisker`/`WhiskerOfW` (the route-(e) whisker sorry was CLOSED iter-237;
  `isIso_sheafification_map_of_W` lives here), `StalkLinearMap`, `OverSliceSheafEquiv`.
- `PresheafInternalHom.lean` — foundational presheaf algebra + C-bridge substrate:
  `RestrictScalarsRingIsoTensor`, lax-monoidal `restrictScalars`, pushforward
  adjunction (H1), `StrongMonoidalRestrictScalars` (H2), `InternalHom`, `Dual`.
- `TensorObjSubstrate.lean` (this file) — public API:
  `Scheme.Modules.tensorObj`, unitors/braiding/assoc, `tensorObj_restrict_iso`,
  `isIso_of_isIso_restrict`, `homMk`, `exists_tensorObj_inverse` (sorry).
  Consumer `tensorObjOnProduct` and the `addCommGroup_via_tensorObj` stub now live
  downstream in `RelPicFunctor.lean` (iter-247 import-cycle fix).
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

Per blueprint `def:scheme_modules_tensorobj`. The body lifts
`PresheafOfModules.Monoidal.tensorObj` through the sheafification functor on
the small Zariski site of `X` (fully defined, no `sorry`). -/
noncomputable def tensorObj {X : Scheme.{u}} (M N : X.Modules) : X.Modules :=
  ((PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
      (PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) M.val N.val) :
    SheafOfModules X.ringCatSheaf)

/-- **Functoriality of `⊗_X`.**

A pair of morphisms `f : M ⟶ M'` and `g : N ⟶ N'` in `X.Modules` determines a
morphism `f ⊗ g : tensorObj M N ⟶ tensorObj M' N'`, compatible with identities
and composition; the assignment `(M, N) ↦ tensorObj M N` thereby extends to a
bifunctor `X.Modules × X.Modules ⥤ X.Modules` natural in both arguments.

Per blueprint `lem:scheme_modules_tensorobj_functoriality`. The body inherits
the morphism action from `PresheafOfModules.Monoidal.tensorObj` under
sheafification (fully defined, no `sorry`). -/
noncomputable def tensorObj_functoriality {X : Scheme.{u}} {M M' N N' : X.Modules}
    (f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N' :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).map
    (MonoidalCategory.tensorHom
      (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) f.val g.val)

/-- **`⊗`-invertibility of an `𝒪_X`-module.** (Blueprint
`def:scheme_modules_isinvertible`.) `M : X.Modules` is `⊗`-invertible when it
admits a tensor inverse: an object `N` with `M ⊗_X N ≅ 𝒪_X`, where
`𝒪_X = SheafOfModules.unit X.ringCatSheaf` is the designated unit. This is the
scheme-level analogue of Mathlib's `Module.Invertible`; the predicate carries its
inverse witness existentially, so the dual needed by the relative Picard group
law is definitional. -/
def IsInvertible {X : Scheme.{u}} (M : X.Modules) : Prop :=
  ∃ N : X.Modules, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)

/-- **The sheaf-level dual `M^∨ := ℋom_{𝒪_X}(M, 𝒪_X)`** of an `𝒪_X`-module.

For a scheme `X` and `M : X.Modules`, the dual `dual M : X.Modules` is the
sheafification of the presheaf-of-modules dual `PresheafOfModules.dual` of the
underlying presheaf of `M` (the internal hom into the structure presheaf,
`M^∨(U) = ℋom_{𝒪_X|_U}(M|_U, 𝒪_X|_U)`).

Construction = the **exact dual analogue of `tensorObj`** (this file, `tensorObj`):
apply the sheafification functor `PresheafOfModules.sheafification (𝟙 …)` on the
small Zariski site of `X` to the (axiom-clean, sub-step-3) presheaf dual
`PresheafOfModules.dual M.val`. The scheme's structure presheaf `X.presheaf` is
`CommRingCat`-valued over the single-universe topological site `Opens X`, hence is
exactly the base `R₀ : Dᵒᵖ ⥤ CommRingCat.{u}` that `PresheafOfModules.dual`
requires (the value `M^∨(U) = M|_U ⟶ R|_U` is an `R(U)`-module, needing
commutativity) — no CommRingCat/RingCat re-bridging is needed, since
`tensorObj` already takes `(R := X.presheaf)` over the same CommRingCat presheaf
and `X.ringCatSheaf.val = X.presheaf ⋙ forget₂ CommRingCat RingCat` definitionally.

The sheafification functor already lands in `SheafOfModules`, so no manual
`Presheaf.IsSheaf` / sheaf-condition descent is needed (sheafifying an already-sheaf
gives an iso object; this is the file's convention, matching `tensorObj`).

Per blueprint `lem:internal_hom_isSheaf` (§`sec:tensorobj_dual_infra`); Stacks
tags 01CM (internal hom into a sheaf is a sheaf) / 01CR item 2. This is the
`⊗`-inverse candidate of an invertible sheaf, feeding `exists_tensorObj_inverse`. -/
noncomputable def dual {X : Scheme.{u}} (M : X.Modules) : X.Modules :=
  ((PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
      (PresheafOfModules.dual (R₀ := X.presheaf) M.val) :
    SheafOfModules X.ringCatSheaf)

/-- **The sheaf-level dual is contravariantly functorial in isomorphisms.** An isomorphism
`e : M ≅ M'` in `X.Modules` induces `dual M' ≅ dual M`, obtained by sheafifying the presheaf-level
dual iso `PresheafOfModules.dualIsoOfIso` of the underlying presheaf isomorphism. This is the
reusable "dual respects isos" ingredient (the dual analogue of `tensorObjIsoOfIso`) feeding the
assembly of `dual_isLocallyTrivial`: a trivialisation `L.restrict f ≅ 𝒪` yields, contravariantly,
`dual 𝒪 ≅ dual (L.restrict f)`. -/
noncomputable def dualIsoOfIso {X : Scheme.{u}} {M M' : X.Modules} (e : M ≅ M') :
    dual M' ≅ dual M :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).mapIso
    (PresheafOfModules.dualIsoOfIso (R₀ := X.presheaf)
      ((SheafOfModules.forget X.ringCatSheaf).mapIso e))

/-! ## §2. (Off the critical path) the full monoidal-category structure

iter-206 PIVOT: the full `MonoidalCategory (X.Modules)` instance is
**deliberately not built**. Per blueprint `rem:scheme_modules_monoidal_off_path`,
the relative Picard group law is a structure on *isomorphism classes* of line
bundles — every group axiom is a `Nonempty (… ≅ …)` proposition, so no monoidal
coherence (pentagon/triangle/hexagon) and no `MonoidalClosed` structure is ever
consumed. The earlier `monoidalCategory := sorry` instance (and the two
localization-transport supplements `isMonoidal_W_of_whiskerLeft`,
`monoidalCategoryOfIsMonoidalW`) routed through the verified-absent
`MonoidalClosed (PresheafOfModules R₀)` wall; they are removed here. The group
law is built directly on the line-bundle subcategory from the four
existence-of-iso lemmas below, mirroring Mathlib's `CommRing.Pic`. -/

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

/-- **Left unitor for `⊗_X`.** `𝒪_X ⊗_X M ≅ M`. (Blueprint
`lem:tensorobj_unit_iso`, left half, `AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor`.)
Sheafification of the presheaf-level left unitor `λ_ M.val`, composed with the
sheafification counit identifying `sheafification M.val` with the (already-sheaf)
`M`. The cheap `mapIso` pattern; uses no abstract pullback. -/
noncomputable def tensorObj_left_unitor {X : Scheme.{u}} (M : X.Modules) :
    tensorObj (SheafOfModules.unit X.ringCatSheaf) M ≅ M :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).mapIso
      ((PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).leftUnitor M.val) ≪≫
    (asIso (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.val)).counit).app M

/-- **Right unitor for `⊗_X`.** `M ⊗_X 𝒪_X ≅ M`. (Blueprint
`lem:tensorobj_unit_iso`, right half, `AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor`.)
Sheafification of the presheaf-level right unitor `ρ_ M.val`, composed with the
sheafification counit. -/
noncomputable def tensorObj_right_unitor {X : Scheme.{u}} (M : X.Modules) :
    tensorObj M (SheafOfModules.unit X.ringCatSheaf) ≅ M :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).mapIso
      ((PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).rightUnitor M.val) ≪≫
    (asIso (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.val)).counit).app M

/-- **Braiding for `⊗_X`.** `M ⊗_X N ≅ N ⊗_X M`. (Blueprint
`lem:tensorobj_comm_iso`, `AlgebraicGeometry.Scheme.Modules.tensorObj_braiding`.)
The presheaf-of-modules monoidal category is symmetric; its braiding `β_ M.val
N.val` sheafifies to the asserted isomorphism by the cheap `mapIso` pattern. -/
noncomputable def tensorObj_braiding {X : Scheme.{u}} (M N : X.Modules) :
    tensorObj M N ≅ tensorObj N M :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).mapIso
    (BraidedCategory.braiding
      (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) M.val N.val)

/-- **Associator for `⊗_X`.** (Blueprint
`lem:tensorobj_assoc_iso`, `AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso`.)
For arbitrary `M, N, P : X.Modules` there is an isomorphism
`(M ⊗_X N) ⊗_X P ≅ M ⊗_X (N ⊗_X P)`. This is the objectwise existence-of-iso datum the
group law consumes (associativity as a `Nonempty (… ≅ …)`).

**UNCONDITIONAL and axiom-clean (iter-238 ROUTE (d)).** No flatness or local-triviality
hypothesis is used: the earlier flatness route (`W_whisker{Right,Left}_of_flat`, needing
sectionwise flatness — false for a general line bundle on a non-affine open) is RETIRED.
Writing `a = PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)` and `η` the
sheafification-adjunction unit, the three-step composite is:
  1. `a(η_{M.val ⊗ᵖ N.val} ▷ P.val)` is iso, giving
     `(M ⊗ N) ⊗ P ≅ a((M.val⊗N.val) ⊗ P.val)`;
  2. `a.mapIso α : a((M.val⊗N.val)⊗P.val) ≅ a(M.val⊗(N.val⊗P.val))`, `α` the
     presheaf-of-modules associator;
  3. `a(M.val ◁ η_{N.val ⊗ᵖ P.val})` is iso, giving
     `a(M.val⊗(N.val⊗P.val)) ≅ M ⊗ (N ⊗ P)`.
Steps 1/3 invert the whiskered sheafification unit via the flatness-free
`PresheafOfModules.W_whisker{Right,Left}_of_W` (η = `toSheafify ∈ J.W`, and `J.W` is
stable under whiskering) together with `isIso_sheafification_map_of_W` (the sheafification
functor IS the localization at `J.W.inverseImage (toPresheaf _)`). The defeq carrier bridge
`X.ringCatSheaf.val = X.presheaf ⋙ forget₂ CommRingCat RingCat` is handled by the leading
`letI instMS` below. -/
noncomputable def tensorObj_assoc_iso {X : Scheme.{u}} {M N P : X.Modules} :
    tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P) := by
  -- UNCONDITIONAL (iter-238, step 0): the locally-trivial hypotheses are dropped —
  -- the body never consumed them (the whiskered-unit localizer fact holds for
  -- arbitrary modules under ROUTE (d)). Matches the blueprint `lem:tensorobj_assoc_iso`
  -- framed unconditional and enables `tensorObj_assoc_iso_invertible`.
  -- Bridge the monoidal structure across the `rfl`-defeq carrier
  -- `Sheaf.val X.ringCatSheaf = X.presheaf ⋙ forget₂ CommRingCat RingCat`.
  letI instMS : MonoidalCategoryStruct (_root_.PresheafOfModules (Sheaf.val X.ringCatSheaf)) :=
    inferInstanceAs (MonoidalCategoryStruct
      (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)))
  set a := PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val) with ha
  -- Underlying presheaf tensors and the sheafification unit `η = toSheafify`.
  set MN := PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) M.val N.val with hMN
  set NP := PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) N.val P.val with hNP
  set η := (PresheafOfModules.sheafificationAdjunction
    (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).unit with hη
  -- The two whiskered-unit localizer facts (ROUTE (d), via `W_whisker{Right,Left}_of_W`).
  -- `η_A = toSheafify` lies in `J.W` (`W_toSheafify`).
  have hηMN : (Opens.grothendieckTopology X).W
      ((PresheafOfModules.toPresheaf _).map (η.app MN)) := by
    rw [hη, PresheafOfModules.toPresheaf_map_sheafificationAdjunction_unit_app]
    exact CategoryTheory.GrothendieckTopology.W_toSheafify _ _
  have hηNP : (Opens.grothendieckTopology X).W
      ((PresheafOfModules.toPresheaf _).map (η.app NP)) := by
    rw [hη, PresheafOfModules.toPresheaf_map_sheafificationAdjunction_unit_app]
    exact CategoryTheory.GrothendieckTopology.W_toSheafify _ _
  have hW1 : (Opens.grothendieckTopology X).W
      ((PresheafOfModules.toPresheaf _).map (η.app MN ▷ P.val)) :=
    PresheafOfModules.W_whiskerRight_of_W (R := X.presheaf) P.val (η.app MN) hηMN
  have hW3 : (Opens.grothendieckTopology X).W
      ((PresheafOfModules.toPresheaf _).map (M.val ◁ η.app NP)) :=
    PresheafOfModules.W_whiskerLeft_of_W (R := X.presheaf) M.val (η.app NP) hηNP
  -- Steps 1 and 3: the sheafification functor inverts the whiskered units.
  have hi1 : IsIso (a.map (η.app MN ▷ P.val)) :=
    PresheafOfModules.isIso_sheafification_map_of_W (𝟙 X.ringCatSheaf.val) _ hW1
  have hi3 : IsIso (a.map (M.val ◁ η.app NP)) :=
    PresheafOfModules.isIso_sheafification_map_of_W (𝟙 X.ringCatSheaf.val) _ hW3
  -- Step 2: the presheaf-of-modules associator, transported under `a`.
  have e2 := a.mapIso
    ((PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).associator M.val N.val P.val)
  exact (@asIso _ _ _ _ _ hi1).symm ≪≫ e2 ≪≫ (@asIso _ _ _ _ _ hi3)

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

This is the single substrate linchpin of `A.1.c.SubT` — **CLOSED, axiom-clean**
(iter-217). It says the substrate `⊗` (sheafification of the presheaf-of-modules
tensor) commutes with the restriction functor along an open immersion. The proof
is the blueprint's four-step composite:
  Step 1 (`restrictFunctorIsoPullback`): reduce `restrict` to the abstract pullback.
  Step 2 (`SheafOfModules.sheafificationCompPullback`): move the pullback inside the
    sheafification (sheafification commutes with pullback).
  Step 3: strip the outer sheafification (`.mapIso`), descending to the presheaf goal
    `(pullback φ).obj (M.val ⊗ₚ N.val) ≅ (M.restrict f).val ⊗ₚ (N.restrict f).val`.
  Step 4: close that presheaf goal by **H1 ∘ H2**:
    • H1 (the sole Mathlib-ABSENT ingredient, BUILT this iter): the presheaf-level iso
      `pushforward β ≅ pullback φ`, obtained from the de-sheafified presheaf
      `PresheafOfModules.pushforwardPushforwardAdj` (adjunction along the open-immersion
      pair `f.opensFunctor ⊣ Opens.map f.base`) against the existing
      `pullbackPushforwardAdjunction` via `Adjunction.leftAdjointUniq`. Here `β` is the
      `restrictFunctor` structure map, so `(M.restrict f).val = (pushforward β).obj M.val`
      definitionally.
    • H2 (strong-monoidal tensorator): `pushforward β = pushforward₀ ⋙ restrictScalars β`
      with `β` sectionwise the open-immersion ring ISO `f.appIso`, so `restrictScalars β`
      is STRONG monoidal (`restrictScalarsMonoidalOfBijective`, resting on the closed
      `restrictScalarsRingIsoTensorEquiv` / `restrictScalars_isIso_{μ,ε}`); the composite
      `μIso` is the tensorator.
The superseded `Localization.Monoidal` / `J.W.IsMonoidal` route is NOT used. -/
noncomputable def tensorObj_restrict_iso {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M N : X.Modules) :
    (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f) := by
  -- Step 1. Reduce `restrict` to `pullback` along the open immersion `f`
  -- (`restrictFunctorIsoPullback`, Mathlib).
  refine (Scheme.Modules.restrictFunctorIsoPullback f).app (tensorObj M N) ≪≫ ?_
  -- Step 2. **Sheafification commutes with pullback.** `tensorObj M N` is, by
  -- definition, `sheafification.obj (PresheafOfModules.Monoidal.tensorObj
  -- M.val N.val)`, so the genuine Mathlib lemma
  -- `SheafOfModules.sheafificationCompPullback`
  -- (`Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackContinuous`,
  -- `sheafification ⋙ pullback φ ≅ PresheafOfModules.pullback φ.hom ⋙
  -- sheafification`) moves the pullback *inside* the sheafification. This
  -- discharges half (ii) of the original obstruction (sheafification commuting
  -- with pullback). After it the goal is the purely **presheaf-level** residual
  -- `sheafify ((PresheafOfModules.pullback φ.hom).obj (M.val ⊗ N.val))
  --    ≅ (M.restrict f).tensorObj (N.restrict f)`.
  refine (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).app
      (PresheafOfModules.Monoidal.tensorObj M.val N.val) ≪≫ ?_
  -- Step 3. **Strip the outer sheafification.** Both sides are
  -- `PresheafOfModules.sheafification (𝟙 Y.ringCatSheaf.obj)` applied to a
  -- presheaf-of-modules: the LHS to `(pullback φ.hom).obj (M.val ⊗ₚ N.val)`, and
  -- the RHS `(M.restrict f).tensorObj (N.restrict f)` *by definition* to
  -- `(M.restrict f).val ⊗ₚ (N.restrict f).val`. So it suffices to give the
  -- comparison at the PRESHEAF level and sheafify it. This is a genuine reduction
  -- step (verified: the goal below has no sheafification).
  refine (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).mapIso ?_
  -- Step 4 (RESIDUAL CLOSURE — iter-217 H1 build). The remaining presheaf goal is
  --   `(PresheafOfModules.pullback φ).obj (M.val ⊗ₚ N.val)
  --      ≅ (M.restrict f).val ⊗ₚ (N.restrict f).val`
  -- where `φ = (Scheme.Hom.toRingCatSheafHom f).hom` and `⊗ₚ =
  -- PresheafOfModules.Monoidal.tensorObj`. We close it via:
  --  (H1, the linchpin) the presheaf-level iso `pushforward β ≅ pullback φ`, built from
  --      the presheaf `pushforwardPushforwardAdj` (above) against the existing
  --      `pullbackPushforwardAdjunction` via `leftAdjointUniq`. Here `β` is the
  --      open-immersion structure map of `restrictFunctor f`, so
  --      `(M.restrict f).val = (pushforward β).obj M.val` definitionally.
  --  (H2) the strong-monoidal comparison `(pushforward β).obj (A ⊗ₚ B) ≅
  --      (pushforward β).obj A ⊗ₚ (pushforward β).obj B`.
  -- `φR` (the scheme structure map) and `β` (the restrictFunctor structure map) are kept as
  -- `let`-bindings (zeta-transparent) so the unit/counit triangle goals below reduce; the
  -- open-immersion adjunction is INLINED for the same reason (a `have` would make `adj.unit`
  -- opaque and block the `congr` defeq, exactly as in Mathlib's sheaf-level `restrictAdjunction`).
  let φR := (Scheme.Hom.toRingCatSheafHom f).hom
  -- The restrictFunctor structure map `β` (so `(M.restrict f).val = (pushforward β).obj M.val`).
  let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
    { app := fun U => (f.appIso U.unop).inv }
  let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
    Functor.whiskerRight α (forget₂ CommRingCat RingCat)
  -- H1 via the presheaf pushforward-pushforward adjunction + `leftAdjointUniq`.
  have hadj : PresheafOfModules.pushforward β ⊣ PresheafOfModules.pushforward φR :=
    PresheafOfModules.pushforwardPushforwardAdj f.isOpenEmbedding.isOpenMap.adjunction β φR
      (by ext U x; exact congr($((f.app_appIso_inv _).symm).hom x))
      (by ext U x; exact congr($(f.appIso_inv_app_presheafMap U.unop) x))
  let H1 := hadj.leftAdjointUniq (PresheafOfModules.pullbackPushforwardAdjunction φR)
  refine (H1.app (PresheafOfModules.Monoidal.tensorObj M.val N.val)).symm ≪≫ ?_
  -- H2: the strong-monoidal tensorator of `pushforward β = pushforward₀ ⋙ restrictScalars β`.
  -- `β` is sectionwise bijective (it is the `forget₂`-image of the open-immersion structure ring
  -- ISO `f.appIso`), so `restrictScalars β` is STRONG monoidal (`restrictScalarsMonoidalOfBijective`),
  -- and `pushforward₀OfCommRingCat` is `Monoidal` (Mathlib); the composite's `μIso` is the tensorator.
  -- It is built over the SYNTACTIC `_ ⋙ forget₂` base form (where the `MonoidalCategory` instance is
  -- found canonically); the result is DEFEQ to the goal — whose base `X.ringCatSheaf.obj` is only
  -- defeq, not syntactically, `X.presheaf ⋙ forget₂` — and `(pushforward β).obj M.val =
  -- (M.restrict f).val` definitionally, so `exact` closes it without any instance diamond.
  have hβ : ∀ U, Function.Bijective (β.app U).hom := by
    intro U
    haveI : IsIso (β.app U) :=
      inferInstanceAs (IsIso ((forget₂ CommRingCat RingCat).map (f.appIso U.unop).inv))
    exact ConcreteCategory.bijective_of_isIso (β.app U)
  let β' : (Y.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (f.opensFunctor.op ⋙ X.presheaf) ⋙ forget₂ CommRingCat RingCat := β
  haveI : (PresheafOfModules.restrictScalars β').Monoidal :=
    PresheafOfModules.restrictScalarsMonoidalOfBijective β' hβ
  exact (Functor.Monoidal.μIso
    (PresheafOfModules.pushforward₀OfCommRingCat f.opensFunctor X.presheaf
      ⋙ PresheafOfModules.restrictScalars β')
    (M.val : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))
    (N.val : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))).symm

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

/-! ## Project-local Mathlib supplement — the d.2-free descent re-route (B-connector)

The "locally-iso ⇒ iso" half of the descent assembly of `exists_tensorObj_inverse`:
a morphism of `𝒪_X`-modules that restricts to an isomorphism on an open
neighbourhood of every point is a global isomorphism. The route is the stalkwise
iso criterion `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso` (for sheaves valued
in `Ab`, whose forgetful functor reflects isos and preserves limits / filtered
colimits) together with `Scheme.Modules.restrictStalkNatIso` (restriction along an
open immersion commutes with stalks). **No stalk-⊗ ("d.2") is invoked**: this is a
statement about a single module morphism, never about the tensor stalk. -/

/-- **B-connector: a morphism of `𝒪_X`-modules that restricts to an isomorphism on
an open cover is an isomorphism.** For `φ : M ⟶ N` in `X.Modules`, if every point
`x` lies in an open `U x` on which the restriction `(restrictFunctor (U x).ι).map φ`
is an isomorphism, then `φ` is an isomorphism. This is the B-bridge of the d.2-free
descent re-route assembling `exists_tensorObj_inverse`. -/
lemma isIso_of_isIso_restrict {X : Scheme.{u}} {M N : X.Modules} (φ : M ⟶ N)
    (U : X → X.Opens) (hxU : ∀ x, x ∈ U x)
    (h : ∀ x, IsIso ((Scheme.Modules.restrictFunctor (U x).ι).map φ)) :
    IsIso φ := by
  -- It suffices that each stalk map of the underlying `Ab`-sheaf morphism is iso.
  have hst : ∀ x : X, IsIso ((TopCat.Presheaf.stalkFunctor Ab.{u} x).map
      ((Scheme.Modules.toPresheaf X).map φ)) := by
    intro x
    obtain ⟨x', hx'⟩ : ∃ x', (U x).ι x' = x := by
      have hmem : x ∈ (U x).ι.opensRange := by
        rw [Scheme.Opens.opensRange_ι]; exact hxU x
      exact AlgebraicGeometry.Scheme.Hom.mem_opensRange.mp hmem
    haveI : IsIso ((Scheme.Modules.restrictFunctor (U x).ι).map φ) := h x
    -- `(restrictFunctor … ⋙ toPresheaf … ⋙ stalkFunctor x').map φ` is iso (functor of an iso).
    haveI hFφ : IsIso ((Scheme.Modules.restrictFunctor (U x).ι ⋙
        Scheme.Modules.toPresheaf _ ⋙ TopCat.Presheaf.stalkFunctor Ab.{u} x').map φ) := by
      dsimp only [Functor.comp_map]; exact Functor.map_isIso _ _
    -- Transport the iso across `restrictStalkNatIso` to the stalk at `(U x).ι x' = x`.
    have hGφ : IsIso ((TopCat.Presheaf.stalkFunctor Ab.{u} ((U x).ι x')).map
        ((Scheme.Modules.toPresheaf X).map φ)) :=
      (CategoryTheory.NatIso.isIso_map_iff
        (Scheme.Modules.restrictStalkNatIso (U x).ι x') φ).mp hFφ
    exact hx' ▸ hGφ
  -- Package as a morphism of `TopCat.Sheaf Ab X` and apply the stalkwise iso criterion.
  let MS : TopCat.Sheaf Ab.{u} X := ⟨M.presheaf, M.isSheaf⟩
  let NS : TopCat.Sheaf Ab.{u} X := ⟨N.presheaf, N.isSheaf⟩
  let fS : MS ⟶ NS := ⟨(Scheme.Modules.toPresheaf X).map φ⟩
  haveI : ∀ x : X, IsIso ((TopCat.Presheaf.stalkFunctor Ab.{u} x).map fS.hom) := hst
  haveI hSiso : IsIso fS := TopCat.Presheaf.isIso_of_stalkFunctor_map_iso fS
  have h1 : IsIso ((Scheme.Modules.toPresheaf X).map φ) := by
    have := (TopCat.Sheaf.forget Ab.{u} X).map_isIso fS
    exact this
  exact (CategoryTheory.isIso_iff_of_reflects_iso φ (Scheme.Modules.toPresheaf X)).mp h1

/-- **A-bridge step (ii): promote an `𝒪_X`-linear `Ab`-presheaf morphism to a module
morphism.** Given a morphism `g : M.presheaf ⟶ N.presheaf` of the underlying
`Ab`-presheaves that is sectionwise `𝒪_X`-linear, package it as a morphism `M ⟶ N`
of `𝒪_X`-modules. This wraps `PresheafOfModules.homMk` at the `Scheme.Modules` level;
it is the "promote to `𝒪_X`-linear" half of the descent A-bridge `homOfLocalCompat`
(the ab-sheaf gluing produces the linear `g`; this lemma turns it into a module map).
Sectionwise linearity is a property the consumer checks on a separated presheaf. -/
noncomputable def homMk {X : Scheme.{u}} {M N : X.Modules}
    (g : M.val.presheaf ⟶ N.val.presheaf)
    (hg : ∀ (V : (TopologicalSpace.Opens X)ᵒᵖ) (r : X.ringCatSheaf.obj.obj V) (m : M.val.obj V),
      (g.app V).hom (r • m) = r • (g.app V).hom m) :
    M ⟶ N :=
  ⟨PresheafOfModules.homMk (M₁ := M.val) (M₂ := N.val) g hg⟩

/-- The underlying `Ab`-presheaf morphism of `homMk g hg` is `g` itself. -/
@[simp] lemma toPresheaf_map_homMk {X : Scheme.{u}} {M N : X.Modules}
    (g : M.val.presheaf ⟶ N.val.presheaf)
    (hg : ∀ (V : (TopologicalSpace.Opens X)ᵒᵖ) (r : X.ringCatSheaf.obj.obj V) (m : M.val.obj V),
      (g.app V).hom (r • m) = r • (g.app V).hom m) :
    (Scheme.Modules.toPresheaf X).map (homMk g hg) = g :=
  rfl

/-! ### iter-230 C-wiring diagnostic (the binding probe) — OUTCOME (ii)

The PRIMARY `dual_isLocallyTrivial` reduces, exactly as `tensorObj_isLocallyTrivial`
does, to a `dual_restrict_iso : (dual M).restrict f ≅ dual (M.restrict f)` for an open
immersion `f : Y ⟶ X`. Mirroring `tensorObj_restrict_iso` verbatim (Step 1
`restrictFunctorIsoPullback`, Step 2 `sheafificationCompPullback`, Step 3 strip the
outer sheafification, Step 4 H1 `pushforwardPushforwardAdj`∘`leftAdjointUniq`) all
TYPECHECK and leave the residual presheaf goal — verified live this iter:

  `(PresheafOfModules.pushforward β).obj (PresheafOfModules.dual M.val)
      ≅ PresheafOfModules.dual ((PresheafOfModules.pushforward β).obj M.val)`

(`(M.restrict f).val = (pushforward β).obj M.val` definitionally, `change`-confirmed).

**This residual CANNOT be discharged by the shared root `overSliceSheafEquiv`** —
outcome (ii), not (i):
  • The root is a `Sheaf`-category equivalence `Sheaf ((gt X).over U) A ≌
    Sheaf (gt ↥U) A`; the residual is a `PresheafOfModules`-level iso (Step 3 already
    stripped the outer sheafification). Different categories — no direct application
    (`overSliceSheafEquiv` is not even in scope here, and its codomain type is
    `Sheaf`, not `PresheafOfModules`).
  • The root is value-category-FIXED (arbitrary `A`); the residual is an iso of
    `ModuleCat` over the VARYING ring `𝒪_Y(V) = R_Y(V)`. The per-`V` module action
    (`internalHomObjModule` over `Over V`) is exactly what a fixed-value-cat site
    equivalence does NOT transport for free.
  • The dual's value uses the per-open slice `restr W = pushforward₀ (Over.forget W)`
    (slice over a single `W`), a finer slicing than the whole-`U` slice site
    `(gt X).over U` the root is built over.

**Precise decomposition of what (ii) actually needs** (the genuine new build; the
substrate has grown a 4th time, as strategy-critic ts230 anticipated): a
PRESHEAF-level, `R`-linear slice comparison
  `Hom_{Over_X (fV)}(restr (fV) A, restr (fV) 𝟙_X)
     ≅  Hom_{Over_Y V}(restr V ((pushforward β) A), restr V 𝟙_Y)`
natural in `V` and `𝒪_Y(V)`-linear, induced by the slice equivalence
`Over_Y V ≌ Over_X (fV)` (the per-`V` shadow of `Opens.overEquivalence`, valid because
`f.opensFunctor` is fully faithful with image `= {W ≤ U}` and `fV ≤ U`), TOGETHER WITH
the identification `restr (fV) A ≅ G^* (restr V (pushforward β A))` under that
equivalence `G` and the ring-iso transport `β = f.appIso`. This is the presheaf+module
analogue of `overSliceSheafEquiv`; the sheaf-level root does not cover it. See the
task result for the full statement of the missing ingredient.

The diagnostic def is intentionally NOT committed (it would pin a new `sorry`, which
the iter-230 HARD-TRIPWIRE directive forbids). -/

/-- **Inverse of an invertible module.**

Every line bundle `L : X.Modules` has a two-sided tensor inverse: there is a
locally-trivial `Linv : X.Modules` (the dual `L⁻¹ = Hom(L, O_X)`) together with
a tensor isomorphism `L ⊗_X Linv ≅ 𝒪_X`. Per blueprint
`lem:tensorobj_inverse_invertible`. iter-206 flat-pivot: the designated unit is
`SheafOfModules.unit X.ringCatSheaf = 𝒪_X` (the `MonoidalCategory` unit `𝟙_` is
no longer available — the full monoidal instance is off the critical path, see
§2).

**iter-226+ d.2-free descent re-route (current state).** `Linv := Scheme.Modules.dual L`
IS nameable: the sheaf-level dual `dual` (this file) landed iter-225, so the FIRST
step is no longer blocked and the iter-218 "infrastructure-missing" gate is retired.
The closure is now assembled WITHOUT the categorical "invertible object ⇒ inverse"
escape (still unavailable — no `MonoidalCategory (X.Modules)` for the varying
structure sheaf, §2) and WITHOUT the forbidden sheafify-the-presheaf-evaluation
shortcut (it re-hits the `M ◁ η` whiskering = the abandoned tensor-stalk "d.2"
gap, a DEAD END — analogist `ts226descent.md`, verdict D). Instead it glues local
trivialising data, touching no tensor stalk. Two bridges remain before this sorry
closes (see body comment): the C-bridge `dual_isLocallyTrivial` and the A-bridge
`homOfLocalCompat` (SheafOfModules morphism descent). The B-bridge
`isIso_of_isIso_restrict` (local-iso ⇒ global iso, mirroring the CLOSED
`tensorObj_isLocallyTrivial` at L1912) is DONE (iter-226, above, axiom-clean). EXACT
decomposition: `informal/exists_tensorObj_inverse.md` and `analogies/ts226descent.md`.
-/
lemma exists_tensorObj_inverse {X : Scheme.{u}} {L : X.Modules}
    (hL : LineBundle.IsLocallyTrivial L) :
    ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧
      Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf) :=
  -- iter-226 descent re-route (d.2-FREE). `Linv := Scheme.Modules.dual L` is now
  -- nameable (dual OBJECT landed iter-225). The B-connector
  -- `isIso_of_isIso_restrict` (above, axiom-clean) closes the final "locally-iso ⇒
  -- global iso" step. Two bridges REMAIN before this sorry closes:
  --   (C) `dual_isLocallyTrivial : IsLocallyTrivial L → IsLocallyTrivial (dual L)`,
  --       via `(dual M).restrict f ≅ dual (M.restrict f)` — the dual analogue of the
  --       CLOSED `tensorObj_restrict_iso`, mirroring its H1∘H2 recipe with
  --       `ModuleCat.restrictScalarsEquivalenceOfRingEquiv` carrying the bespoke
  --       presheaf `dual` (= `internalHom(-, R)`) across the open-immersion ring iso.
  --   (A) SheafOfModules morphism descent: glue the canonical local trivialising isos
  --       `(L ⊗ dual L)|_{Uᵢ} ≅ 𝒪_{Uᵢ}` (pattern of `tensorObj_isLocallyTrivial`,
  --       L1920) — agreeing on overlaps (bounded cocycle check, NOT d.2) — to a global
  --       `tensorObj L (dual L) ⟶ 𝒪_X` via `CategoryTheory.Presheaf.IsSheaf.hom` /
  --       `sheafHomSectionsEquiv` + `PresheafOfModules.homMk`. Then `isIso_of_isIso_restrict`
  --       upgrades the glued morphism to a global iso, closing this sorry (80→79).
  -- The FORBIDDEN sheafify-the-presheaf-eval shortcut re-hits the `M ◁ η` whiskering
  -- (d.2) and is a DEAD END; only the gluing route escapes. See the docstring and
  -- `informal/exists_tensorObj_inverse.md`.
  sorry

/-! ## §5. The invertibility-carrier Picard group `picCommGroup`

This is the by-hand commutative-group law on isomorphism classes of `⊗`-invertible
`𝒪_X`-modules (blueprint §`sec:tensorobj_pic_carrier`). Every group axiom is a single
existence-of-isomorphism `Nonempty (… ≅ …)` read as an equality of iso-classes; no
pentagon/triangle/hexagon coherence and no `MonoidalCategory` instance is invoked.
The inverse is carried by the membership witness of `IsInvertible` itself. -/

/-- **Step 1 — associator on `⊗`-invertible objects** (blueprint
`lem:tensorobj_assoc_iso_invertible`). An immediate specialisation of the now
*unconditional* `tensorObj_assoc_iso`; the invertibility hypotheses are not consumed
(they match the blueprint statement). -/
noncomputable def tensorObj_assoc_iso_invertible {X : Scheme.{u}} {M N P : X.Modules}
    (_hM : IsInvertible M) (_hN : IsInvertible N) (_hP : IsInvertible P) :
    tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P) :=
  tensorObj_assoc_iso

/-- **Middle-four interchange for `⊗_X`** (helper). For arbitrary `𝒪_X`-modules
`A, B, C, D`, there is an isomorphism `(A ⊗ B) ⊗ (C ⊗ D) ≅ (A ⊗ C) ⊗ (B ⊗ D)`,
assembled from the unconditional associator and the braiding (no coherence consumed).
Used to reassociate the four factors in `IsInvertible.tensorObj`. -/
private noncomputable def tensorObj_middleFour {X : Scheme.{u}} (A B C D : X.Modules) :
    tensorObj (tensorObj A B) (tensorObj C D)
      ≅ tensorObj (tensorObj A C) (tensorObj B D) :=
  tensorObj_assoc_iso ≪≫
    tensorObjIsoOfIso (Iso.refl A)
      (tensorObj_assoc_iso.symm ≪≫
        tensorObjIsoOfIso (tensorObj_braiding B C) (Iso.refl D) ≪≫
        tensorObj_assoc_iso) ≪≫
    tensorObj_assoc_iso.symm

/-- **Step 3 — `⊗`-invertibility is closed under tensor product** (blueprint
`lem:isinvertible_tensor`). If `M, M'` are `⊗`-invertible with inverses `N, N'`,
then `N ⊗ N'` is a tensor inverse of `M ⊗ M'`. -/
theorem IsInvertible.tensorObj {X : Scheme.{u}} {M M' : X.Modules}
    (hM : IsInvertible M) (hM' : IsInvertible M') :
    IsInvertible (Scheme.Modules.tensorObj M M') := by
  obtain ⟨N, ⟨e⟩⟩ := hM
  obtain ⟨N', ⟨e'⟩⟩ := hM'
  exact ⟨Scheme.Modules.tensorObj N N',
    ⟨tensorObj_middleFour M M' N N' ≪≫ tensorObjIsoOfIso e e' ≪≫ tensorObj_unit_iso⟩⟩

/-- **Step 4 — the structure sheaf is `⊗`-invertible** (blueprint
`lem:isinvertible_unit`). Witness `𝒪_X`, iso `tensorObj_unit_iso`. -/
theorem isInvertible_unit {X : Scheme.{u}} :
    IsInvertible (SheafOfModules.unit X.ringCatSheaf) :=
  ⟨SheafOfModules.unit X.ringCatSheaf, ⟨tensorObj_unit_iso⟩⟩

/-- **Step 5 — the tensor inverse is determined up to isomorphism** (blueprint
`lem:isinvertible_inverse_welldef`). If `M ⊗ N ≅ 𝒪_X` and `M ⊗ N' ≅ 𝒪_X` then
`N ≅ N'`, via the inverse-of-inverse chain. -/
theorem IsInvertible.inverse_unique {X : Scheme.{u}} {M N N' : X.Modules}
    (e : Scheme.Modules.tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)
    (e' : Scheme.Modules.tensorObj M N' ≅ SheafOfModules.unit X.ringCatSheaf) :
    Nonempty (N ≅ N') :=
  ⟨(tensorObj_right_unitor N).symm ≪≫
    tensorObjIsoOfIso (Iso.refl N) e'.symm ≪≫
    tensorObj_assoc_iso.symm ≪≫
    tensorObjIsoOfIso (tensorObj_braiding N M ≪≫ e) (Iso.refl N') ≪≫
    tensorObj_left_unitor N'⟩

/-- The setoid of `⊗`-invertible `𝒪_X`-modules: `M ∼ M'` iff there exists an
isomorphism `M ≅ M'` (blueprint `def:pic_carrier`). -/
instance picSetoid (X : Scheme.{u}) : Setoid {M : X.Modules // IsInvertible M} where
  r M M' := Nonempty ((M : X.Modules) ≅ (M' : X.Modules))
  iseqv :=
    ⟨fun _ => ⟨Iso.refl _⟩, fun ⟨e⟩ => ⟨e.symm⟩, fun ⟨e⟩ ⟨f⟩ => ⟨e ≪≫ f⟩⟩

/-- **Step 2 — the invertibility-carrier Picard group** (blueprint
`def:pic_carrier`): the quotient of `⊗`-invertible `𝒪_X`-modules by isomorphism. -/
def PicGroup (X : Scheme.{u}) : Type _ := Quotient (picSetoid X)

/-- Multiplication on `PicGroup X`: `[M] · [M'] := [M ⊗_X M']`, well-defined on
iso-classes by bifunctoriality (`tensorObjIsoOfIso`), landing in `PicGroup` by
`IsInvertible.tensorObj`. -/
noncomputable def picMul {X : Scheme.{u}} : PicGroup X → PicGroup X → PicGroup X :=
  Quotient.lift₂
    (fun a b => Quotient.mk _ ⟨tensorObj a.1 b.1, a.2.tensorObj b.2⟩)
    (by
      rintro ⟨a, ha⟩ ⟨b, hb⟩ ⟨a', ha'⟩ ⟨b', hb'⟩ ⟨ea⟩ ⟨eb⟩
      exact Quotient.sound ⟨tensorObjIsoOfIso ea eb⟩)

/-- The inverse class on `PicGroup X`: `[M] ↦ [N]` for the membership witness `N`
of `IsInvertible M`, well-defined by `IsInvertible.inverse_unique`. -/
noncomputable def picInv {X : Scheme.{u}} : PicGroup X → PicGroup X :=
  Quotient.lift
    (fun a => Quotient.mk _
      ⟨Classical.choose a.2,
        a.1, ⟨tensorObj_braiding _ a.1 ≪≫ (Classical.choose_spec a.2).some⟩⟩)
    (by
      rintro ⟨a, ha⟩ ⟨a', ha'⟩ ⟨ea⟩
      refine Quotient.sound ?_
      -- both `Classical.choose ha` and `Classical.choose ha'` are tensor inverses of `a`
      have h1 : tensorObj a (Classical.choose ha) ≅ SheafOfModules.unit X.ringCatSheaf :=
        (Classical.choose_spec ha).some
      have h2 : tensorObj a (Classical.choose ha') ≅ SheafOfModules.unit X.ringCatSheaf :=
        tensorObjIsoOfIso ea (Iso.refl _) ≪≫ (Classical.choose_spec ha').some
      exact IsInvertible.inverse_unique h1 h2)

/-- **Step 6 — the invertibility-carrier Picard group is abelian** (blueprint
`thm:pic_commgroup`). `[M] · [M'] := [M ⊗_X M']`, `1 := [𝒪_X]`, and `[M]⁻¹` the
class of any membership witness of `IsInvertible M`. Each group axiom is a single
existence-of-isomorphism: unit laws ← unitors, associativity ← associator,
commutativity ← braiding, left inverse ← the witness iso. No monoidal coherence. -/
noncomputable instance picCommGroup (X : Scheme.{u}) : CommGroup (PicGroup X) where
  mul := picMul
  one := Quotient.mk _ ⟨SheafOfModules.unit X.ringCatSheaf, isInvertible_unit⟩
  inv := picInv
  mul_assoc := by
    rintro a b c
    induction a using Quotient.ind with | _ a => ?_
    induction b using Quotient.ind with | _ b => ?_
    induction c using Quotient.ind with | _ c => ?_
    exact Quotient.sound ⟨tensorObj_assoc_iso⟩
  one_mul := by
    rintro a
    induction a using Quotient.ind with | _ a => ?_
    exact Quotient.sound ⟨tensorObj_left_unitor a.1⟩
  mul_one := by
    rintro a
    induction a using Quotient.ind with | _ a => ?_
    exact Quotient.sound ⟨tensorObj_right_unitor a.1⟩
  inv_mul_cancel := by
    rintro a
    induction a using Quotient.ind with | _ a => ?_
    exact Quotient.sound
      ⟨tensorObj_braiding (Classical.choose a.2) a.1 ≪≫ (Classical.choose_spec a.2).some⟩
  mul_comm := by
    rintro a b
    induction a using Quotient.ind with | _ a => ?_
    induction b using Quotient.ind with | _ b => ?_
    exact Quotient.sound ⟨tensorObj_braiding a.1 b.1⟩

/-! ## §6. Pullback-monoidality substrate (A.1.c): `IsInvertible.pullback`

Project-local Mathlib supplement. The relative Picard consumer re-bases onto the
`IsInvertible` carrier and its structure maps are *pullback* maps for GENERAL scheme
morphisms (the projection `C ×_S T → T` and base-change maps are neither open
immersions nor flat). We need that pullback preserves `⊗`-invertibility. This requires
`pullbackTensorIso` (`f^*(M ⊗ N) ≅ f^*M ⊗ f^*N`) and `pullbackUnitIso`
(`f^*𝒪_X ≅ 𝒪_Y`). Blueprint §`sec:tensorobj_pullback_monoidality`. -/

/-- **Composition coherence of the unit→pushforward-unit comparison.**

For composable scheme morphisms `h : Z ⟶ Y`, `f : Y ⟶ X`, the canonical comparison
`unitToPushforwardObjUnit` of the composite `h ≫ f` factors through the comparisons
of `f` and `h` and the pushforward pseudofunctor coherence `pushforwardComp`. This is
the *pushforward-side* (right-adjoint) half of the composition coherence; it is
concrete (sectionwise it is just functoriality of the structure-sheaf ring maps,
hence `rfl` after the `ext`-chain) and is the pushforward-side input from which the
genuinely-needed *pullback-side* coherence of `pullbackObjUnitToUnit` is obtained by
adjunction-mate transport. Mathlib-absent at the pinned commit. -/
lemma unitToPushforwardObjUnit_comp {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X) :
    SheafOfModules.unitToPushforwardObjUnit (h ≫ f).toRingCatSheafHom =
      SheafOfModules.unitToPushforwardObjUnit f.toRingCatSheafHom ≫
        (Scheme.Modules.pushforward f).map
          (SheafOfModules.unitToPushforwardObjUnit h.toRingCatSheafHom) ≫
        (Scheme.Modules.pushforwardComp h f).hom.app (SheafOfModules.unit Z.ringCatSheaf) := by
  apply SheafOfModules.Hom.ext
  apply PresheafOfModules.hom_ext
  intro U
  apply ModuleCat.hom_ext
  apply LinearMap.ext
  intro a
  rfl

/-- **Composition coherence of the unit comparison `pullbackObjUnitToUnit`
(the genuinely-new ingredient for `pullbackUnitIso`).**

For composable scheme morphisms `h : Z ⟶ Y`, `f : Y ⟶ X`, the canonical comparison
`f^*𝒪 ⟶ 𝒪` of the composite `h ≫ f` factors through the comparisons of `f` and `h`
and the pullback pseudofunctor coherence `pullbackComp`:
`pullbackObjUnitToUnit (h≫f) = (pullbackComp h f).inv ≫ (pullback h).map (pbu f) ≫ pbu h`.

This is the pullback-side (left-adjoint) composition coherence — Mathlib-absent at the
pinned commit and NOT a sectionwise statement (the abstract left-adjoint pullback has no
sectionwise value). It is obtained by adjunction-mate transport from the pushforward-side
coherence `unitToPushforwardObjUnit_comp`: transposing both sides under
`pullbackPushforwardAdjunction (h≫f)`, the left side becomes `unitToPushforwardObjUnit (h≫f)`
and the right side is reassembled via the conjugate/mate identity
`conjugateEquiv_pullbackComp_inv` (relating `pullbackComp.inv` to `pushforwardComp.hom`),
`unit_conjugateEquiv`, and the composite-adjunction unit `Adjunction.comp_unit_app`.

Consumed by `pullbackUnitIso`: on an affine chart `V` the inclusion `V.ι ≫ f` factors as
`g ≫ U.ι` with `Opens.map g.base` `Final`, so two applications of this coherence (one for
each factorisation) express the restricted global comparison as a composite of isomorphisms
(`pbu` for an open immersion / a `Final`-chart morphism is an iso), whence
`pullbackObjUnitToUnit f` is an iso by `isIso_of_isIso_restrict`.

The proof uses `erw` for the associativity / functoriality steps because the `SheafOfModules`
category compositions appear in defeq-but-not-syntactic forms (`Scheme.Modules.pullback f`
vs `SheafOfModules.pullback f.toRingCatSheafHom`) on which plain `rw [Category.assoc]` /
`rw [Functor.map_comp]` fail to unify. -/
lemma pullbackObjUnitToUnit_comp {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X) :
    SheafOfModules.pullbackObjUnitToUnit (h ≫ f).toRingCatSheafHom =
      (Scheme.Modules.pullbackComp h f).inv.app (SheafOfModules.unit X.ringCatSheaf) ≫
      (Scheme.Modules.pullback h).map (SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom) ≫
      SheafOfModules.pullbackObjUnitToUnit h.toRingCatSheafHom := by
  have key := unitToPushforwardObjUnit_comp h f
  have conj := unit_conjugateEquiv
    ((Scheme.Modules.pullbackPushforwardAdjunction f).comp
      (Scheme.Modules.pullbackPushforwardAdjunction h))
    (Scheme.Modules.pullbackPushforwardAdjunction (h ≫ f))
    (Scheme.Modules.pullbackComp h f).inv (SheafOfModules.unit X.ringCatSheaf)
  rw [Scheme.Modules.conjugateEquiv_pullbackComp_inv] at conj
  apply (Scheme.Modules.pullbackPushforwardAdjunction (h ≫ f)).homEquiv _ _ |>.injective
  have hL : (Scheme.Modules.pullbackPushforwardAdjunction (h ≫ f)).homEquiv _ _
      (SheafOfModules.pullbackObjUnitToUnit (h ≫ f).toRingCatSheafHom)
    = SheafOfModules.unitToPushforwardObjUnit (h ≫ f).toRingCatSheafHom := by
    exact SheafOfModules.pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit
      (h ≫ f).toRingCatSheafHom
  have hi : (Scheme.Modules.pullbackPushforwardAdjunction (h ≫ f)).homEquiv _ _
      ((Scheme.Modules.pullbackComp h f).inv.app (SheafOfModules.unit X.ringCatSheaf))
    = ((Scheme.Modules.pullbackPushforwardAdjunction f).comp
          (Scheme.Modules.pullbackPushforwardAdjunction h)).unit.app
          (SheafOfModules.unit X.ringCatSheaf) ≫
        (Scheme.Modules.pushforwardComp h f).hom.app
          ((Scheme.Modules.pullback f ⋙ Scheme.Modules.pullback h).obj
            (SheafOfModules.unit X.ringCatSheaf)) := by
    rw [Adjunction.homEquiv_unit]; exact conj.symm
  have hLf : (Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _
      (SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom)
    = SheafOfModules.unitToPushforwardObjUnit f.toRingCatSheafHom := by
    exact SheafOfModules.pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit
      f.toRingCatSheafHom
  have hLh : (Scheme.Modules.pullbackPushforwardAdjunction h).homEquiv _ _
      (SheafOfModules.pullbackObjUnitToUnit h.toRingCatSheafHom)
    = SheafOfModules.unitToPushforwardObjUnit h.toRingCatSheafHom := by
    exact SheafOfModules.pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit
      h.toRingCatSheafHom
  have hinner : (Scheme.Modules.pullbackPushforwardAdjunction h).unit.app
        ((Scheme.Modules.pullback f).obj (SheafOfModules.unit X.ringCatSheaf)) ≫
      (Scheme.Modules.pushforward h).map
        ((Scheme.Modules.pullback h).map
            (SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom) ≫
          SheafOfModules.pullbackObjUnitToUnit h.toRingCatSheafHom)
    = SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom ≫
        SheafOfModules.unitToPushforwardObjUnit h.toRingCatSheafHom := by
    have e := Adjunction.homEquiv_unit (adj := Scheme.Modules.pullbackPushforwardAdjunction h)
      (X := (Scheme.Modules.pullback f).obj (SheafOfModules.unit X.ringCatSheaf))
      (Y := SheafOfModules.unit Z.ringCatSheaf)
      (f := (Scheme.Modules.pullback h).map
          (SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom) ≫
        SheafOfModules.pullbackObjUnitToUnit h.toRingCatSheafHom)
    have key2 : (Scheme.Modules.pullbackPushforwardAdjunction h).homEquiv _ _
          ((Scheme.Modules.pullback h).map
              (SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom) ≫
            SheafOfModules.pullbackObjUnitToUnit h.toRingCatSheafHom)
        = SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom ≫
            SheafOfModules.unitToPushforwardObjUnit h.toRingCatSheafHom := by
      rw [Adjunction.homEquiv_naturality_left]; exact congrArg _ hLh
    exact e.symm.trans key2
  have hcomp' : ((Scheme.Modules.pullbackPushforwardAdjunction f).comp
        (Scheme.Modules.pullbackPushforwardAdjunction h)).unit.app
        (SheafOfModules.unit X.ringCatSheaf) ≫
      (Scheme.Modules.pushforward h ⋙ Scheme.Modules.pushforward f).map
        ((Scheme.Modules.pullback h).map
            (SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom) ≫
          SheafOfModules.pullbackObjUnitToUnit h.toRingCatSheafHom)
    = SheafOfModules.unitToPushforwardObjUnit f.toRingCatSheafHom ≫
        (Scheme.Modules.pushforward f).map
          (SheafOfModules.unitToPushforwardObjUnit h.toRingCatSheafHom) := by
    have ef := Adjunction.homEquiv_unit (adj := Scheme.Modules.pullbackPushforwardAdjunction f)
      (X := SheafOfModules.unit X.ringCatSheaf) (Y := SheafOfModules.unit Y.ringCatSheaf)
      (f := SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom)
    rw [Adjunction.comp_unit_app, Functor.comp_map]
    erw [Category.assoc, ← Functor.map_comp, hinner, Functor.map_comp]
    erw [← Category.assoc]
    rw [show (Scheme.Modules.pullbackPushforwardAdjunction f).unit.app
            (SheafOfModules.unit X.ringCatSheaf) ≫
          (Scheme.Modules.pushforward f).map
            (SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom)
        = SheafOfModules.unitToPushforwardObjUnit f.toRingCatSheafHom from ef.symm.trans hLf]
    rfl
  rw [hL, key, Adjunction.homEquiv_naturality_right, hi]
  erw [Category.assoc, ← (Scheme.Modules.pushforwardComp h f).hom.naturality
      ((Scheme.Modules.pullback h).map (SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom) ≫
        SheafOfModules.pullbackObjUnitToUnit h.toRingCatSheafHom)]
  erw [← Category.assoc, hcomp']
  erw [Category.assoc]

/-! ### Phase 1 — `pullbackUnitIso` (`f^*𝒪_X ≅ 𝒪_Y`), blueprint `lem:pullback_unit_iso`

**iter-241 RESOLUTION (the chart-chase is NOT needed).** The unit comparison
`SheafOfModules.pullbackObjUnitToUnit f` is an isomorphism for *every* morphism of
schemes `f`, not just for `Final`-chart morphisms. The Mathlib instance
`SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal` fires whenever the comparison
functor `Opens.map f.base` is `Final`, and that functor is **always** `Final`: the
preimage functor on opens preserves finite limits (it is a frame homomorphism), so it is
representably flat, whence `final_of_representablyFlat` supplies `(Opens.map f.base).Final`
unconditionally. (Verified axiom-clean for a general `f`.) The elaborate affine
chart-chase contemplated by the blueprint proof — and the iter-240 coherence linchpin
`pullbackObjUnitToUnit_comp` — are therefore unnecessary for this lemma (the linchpin is
retained above as it is the genuine Mathlib-absent pseudofunctor coherence, of independent
use for the harder Phase-2 tensor comparison).

The remaining friction was purely a Lean typeclass-resolution accident: in a context with
several `(Opens.map _).Final` hypotheses (or after a `pullbackObjUnitToUnit_comp` rewrite)
the buried implicit instance args of `pullbackObjUnitToUnit` (`[F.IsContinuous]`,
`[(pushforward φ).IsRightAdjoint]`) are defeq-but-not-syntactic, so `asIso`/`infer_instance`
fails to synthesise `IsIso (pbu f)`. The fix (mathlib-analogist `pbu-canon`, the
`Functor.Monoidal.μIso` idiom): isolate the single `Final` hypothesis in the helper
`isIso_pbu_of_final` whose body `inferInstance` runs at a clean site, then transport the
resulting witness through `asIso` by passing it *explicitly* (`@asIso … (isIso_pbu_of_final g)`)
— the application's defeq check runs at default transparency and succeeds, whereas instance
synthesis (reducible transparency) does not. -/

/-- **`IsIso (pullbackObjUnitToUnit g)` from a single `Final` hypothesis, at a clean site.**
Project-local: isolates the lone `(Opens.map g.base).Final` instance so that the Mathlib
`OfFinal` instance synthesises without colliding with other in-scope `Final`/`IsIso`
hypotheses (see the section note). -/
private lemma isIso_pbu_of_final {X Y : Scheme.{u}} (g : Y ⟶ X)
    [(TopologicalSpace.Opens.map g.base).Final] :
    IsIso (SheafOfModules.pullbackObjUnitToUnit g.toRingCatSheafHom) := inferInstance

/-- **Bundled `Iso` form of the unit comparison `pullbackObjUnitToUnit g`** for a `Final`
comparison functor — the analogue of `CategoryTheory.Functor.Monoidal.μIso`. Project-local:
hands out the isomorphism (rather than a bare `IsIso` instance) so downstream coherence
reasoning stays at the `Iso` level and never re-triggers the `pbu` instance synthesis. -/
noncomputable def pullbackObjUnitToUnitIso {X Y : Scheme.{u}} (g : Y ⟶ X)
    [(TopologicalSpace.Opens.map g.base).Final] :
    (Scheme.Modules.pullback g).obj (SheafOfModules.unit X.ringCatSheaf) ≅
      SheafOfModules.unit Y.ringCatSheaf :=
  @asIso _ _ _ _ (SheafOfModules.pullbackObjUnitToUnit g.toRingCatSheafHom)
    (isIso_pbu_of_final g)

@[simp] lemma pullbackObjUnitToUnitIso_hom {X Y : Scheme.{u}} (g : Y ⟶ X)
    [(TopologicalSpace.Opens.map g.base).Final] :
    (pullbackObjUnitToUnitIso g).hom =
      SheafOfModules.pullbackObjUnitToUnit g.toRingCatSheafHom := rfl

/-- **Pullback preserves the structure sheaf** (blueprint `lem:pullback_unit_iso`):
`f^*𝒪_X ≅ 𝒪_Y` for an arbitrary morphism of schemes `f : Y ⟶ X`, where
`𝒪_X = SheafOfModules.unit X.ringCatSheaf`. The comparison functor `Opens.map f.base` is
always `Final` (preimage on opens is representably flat), so the Mathlib unit comparison
`pullbackObjUnitToUnit f` is an isomorphism unconditionally. -/
noncomputable def pullbackUnitIso {X Y : Scheme.{u}} (f : Y ⟶ X) :
    (Scheme.Modules.pullback f).obj (SheafOfModules.unit X.ringCatSheaf) ≅
      SheafOfModules.unit Y.ringCatSheaf :=
  haveI : (TopologicalSpace.Opens.map f.base).Final := final_of_representablyFlat _
  pullbackObjUnitToUnitIso f

/-- **Sheafification reconciles the presheaf tensor with the tensor of the
sheafified factors.** For presheaves of modules `P, Q` on `X`, sheafifying the
presheaf tensor `P ⊗ Q` agrees with sheafifying the tensor of the underlying
presheaves of their sheafifications `(a P).val ⊗ (a Q).val`, where
`a = PresheafOfModules.sheafification (𝟙 𝒪_X)`. This is the "sheafification is
monoidal" reconciliation, built — exactly as in `tensorObj_assoc_iso` — by
whiskering the sheafification unit `η` (a `J.W`-morphism, hence locally bijective)
on each side and inverting under `a` via `isIso_sheafification_map_of_W` together
with the flatness-free `W_whisker{Right,Left}_of_W`. It is the bridge reconciling a
presheaf-level tensorator with the substrate `⊗_X` (whose `.val` carries an extra
sheafification on each factor), as needed by the pullback-monoidality comparison
`pullbackTensorIso`. -/
private noncomputable def sheafifyTensorUnitIso {X : Scheme.{u}}
    (P Q : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) :
    (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
        (PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) P Q) ≅
      (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
        (PresheafOfModules.Monoidal.tensorObj (R := X.presheaf)
          ((PresheafOfModules.sheafification
              (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj P).val
          ((PresheafOfModules.sheafification
              (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj Q).val) := by
  letI instMS : MonoidalCategoryStruct (_root_.PresheafOfModules (Sheaf.val X.ringCatSheaf)) :=
    inferInstanceAs (MonoidalCategoryStruct
      (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)))
  set a := PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val) with ha
  set η := (PresheafOfModules.sheafificationAdjunction
    (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).unit with hη
  have hηP : (Opens.grothendieckTopology X).W
      ((PresheafOfModules.toPresheaf _).map (η.app P)) := by
    rw [hη, PresheafOfModules.toPresheaf_map_sheafificationAdjunction_unit_app]
    exact CategoryTheory.GrothendieckTopology.W_toSheafify _ _
  have hηQ : (Opens.grothendieckTopology X).W
      ((PresheafOfModules.toPresheaf _).map (η.app Q)) := by
    rw [hη, PresheafOfModules.toPresheaf_map_sheafificationAdjunction_unit_app]
    exact CategoryTheory.GrothendieckTopology.W_toSheafify _ _
  have hW1 : (Opens.grothendieckTopology X).W
      ((PresheafOfModules.toPresheaf _).map (η.app P ▷ Q)) :=
    PresheafOfModules.W_whiskerRight_of_W (R := X.presheaf) Q (η.app P) hηP
  have hW2 : (Opens.grothendieckTopology X).W
      ((PresheafOfModules.toPresheaf _).map ((a.obj P).val ◁ η.app Q)) :=
    PresheafOfModules.W_whiskerLeft_of_W (R := X.presheaf) (a.obj P).val (η.app Q) hηQ
  have hi1 : IsIso (a.map (η.app P ▷ Q)) :=
    PresheafOfModules.isIso_sheafification_map_of_W (𝟙 X.ringCatSheaf.val) _ hW1
  have hi2 : IsIso (a.map ((a.obj P).val ◁ η.app Q)) :=
    PresheafOfModules.isIso_sheafification_map_of_W (𝟙 X.ringCatSheaf.val) _ hW2
  exact (@asIso _ _ _ _ _ hi1) ≪≫ (@asIso _ _ _ _ _ hi2)

/-- **The presheaf-of-modules pushforward is lax monoidal** (the analogist-named `μ_G`,
Mathlib-absent at the pin). For a morphism `φ : S₀ ⋙ forget₂ ⟶ F.op ⋙ (R₀ ⋙ forget₂)`
of presheaves of *commutative* rings, `PresheafOfModules.pushforward φ` unfolds to
`pushforward₀OfCommRingCat F R₀ ⋙ restrictScalars φ`, the composite of the strong-monoidal
topological pushforward `pushforward₀OfCommRingCat` (Mathlib) and the lax-monoidal
`restrictScalars φ` (project `restrictScalarsLaxMonoidal`), hence lax monoidal by
`Functor.LaxMonoidal.comp`.

The hypothesis necessarily uses the *inner* `forget₂` association (`F.op ⋙ (R₀ ⋙ forget₂)`,
the form `PresheafOfModules.pushforward` expects), but the monoidal-category instance on the
middle presheaf is keyed on the *outer* association `(F.op ⋙ R₀) ⋙ forget₂` (the form
`pushforward₀OfCommRingCat`'s target carries). The two are defeq; bridging them with a local
`MonoidalCategory` instance triggers a kernel-rejected diamond, so instead `φ` is defeq-cast
to the outer form (`φ'`) for the `restrictScalars` factor, and the resulting composite — defeq
to `pushforward φ` — is transported back by `exact`. This is the right-adjoint lax structure
that an eventual oplax comparison `δ` on the abstract left-adjoint pullback would inherit.
Project-local supplement; reusable for the general pullback-monoidality build. -/
noncomputable instance presheafPushforwardLaxMonoidal
    {C D : Type u} [Category.{u} C] [Category.{u} D] {F : C ⥤ D}
    {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}} {S₀ : Cᵒᵖ ⥤ CommRingCat.{u}}
    (φ : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      F.op ⋙ (R₀ ⋙ forget₂ CommRingCat RingCat)) :
    (PresheafOfModules.pushforward φ).LaxMonoidal := by
  let φ' : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      (F.op ⋙ R₀) ⋙ forget₂ CommRingCat RingCat := φ
  have h : (PresheafOfModules.pushforward₀OfCommRingCat F R₀ ⋙
      PresheafOfModules.restrictScalars φ').LaxMonoidal := inferInstance
  exact h

/-- **The abstract presheaf-of-modules pullback is oplax monoidal**, with canonical
comparison map `δ_{A,B} : f^*(A ⊗ B) ⟶ f^*A ⊗ f^*B`. This is the mate of the lax
tensorator of `pushforward φ` (`presheafPushforwardLaxMonoidal`) across the
pullback–pushforward adjunction, via Mathlib's doctrinal `leftAdjointOplaxMonoidal`. It
supplies the canonical comparison map that the eventual `pullbackTensorIso` upgrades to an
isomorphism — note the map exists for the *abstract* left adjoint with no sectionwise value
(no `MonoidalCategory (SheafOfModules)` is needed, contra the earlier reading: the comparison
lives at the presheaf level where `PresheafOfModules` IS monoidal). Project-local supplement;
what remains Mathlib-absent is the concrete inverse-image model needed to prove `δ` is an
iso (see the Phase-2 note below). -/
noncomputable instance presheafPullbackOplaxMonoidal
    {C D : Type u} [Category.{u} C] [Category.{u} D] {F : C ⥤ D}
    {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}} {S₀ : Cᵒᵖ ⥤ CommRingCat.{u}}
    (φ : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      F.op ⋙ (R₀ ⋙ forget₂ CommRingCat RingCat))
    [(PresheafOfModules.pushforward φ).IsRightAdjoint] :
    (PresheafOfModules.pullback φ).OplaxMonoidal :=
  (PresheafOfModules.pullbackPushforwardAdjunction φ).leftAdjointOplaxMonoidal

/-! ### Phase 2 — `pullbackTensorIso` status (iter-242 finding)

`pullbackUnitIso` (Phase 1) is DONE (above). The remaining `pullbackTensorIso`
(`f^*(M ⊗ N) ≅ f^*M ⊗ f^*N`, general `f`) is a genuine Mathlib-scale build, blocked
on a Mathlib-absent ingredient confirmed this iter:

  • `Scheme.Modules.pullback f` and the underlying `PresheafOfModules.pullback φ.hom`
    are BOTH `(pushforward _).leftAdjoint` — an ABSTRACT left adjoint with no sectionwise
    value. The blueprint route "build a concrete strong-monoidal `P` ≅ pullback, then
    transport via `leftAdjointUniq`" requires a CONCRETE model `P` of the pullback.
  • For an OPEN immersion (`tensorObj_restrict_iso`) the concrete model was
    `pushforward β` (β = the structure ring ISO), strong-monoidal via
    `restrictScalarsMonoidalOfBijective`. For a GENERAL `f` the concrete left adjoint is
    the inverse-image `(inverse-image presheaf) ⋙ extendScalars`: the underlying-presheaf
    inverse image is a LEFT KAN EXTENSION along `(Opens.map f.base).op` (a colimit, NOT
    sectionwise), and neither `PresheafOfModules.extendScalars` nor a concrete
    inverse-image-of-presheaves-of-modules functor exists in Mathlib at the pin. Building
    that concrete strong-monoidal functor + its adjunction to `pushforward` is the genuine
    multi-hundred-LOC obligation (Mathlib-scale; the `distribBaseChange` strong-monoidal
    core exists only at `ModuleCat.extendScalars`, the topological inverse image does not).

The reusable presheaf-level prerequisites toward that build are supplied just below
(`PresheafOfModules.pushforward` is LAX monoidal; hence the abstract presheaf pullback is
OPLAX monoidal with a canonical comparison map `δ`).

**SUPERSEDED (iter-243 pivot, see §D1'–D4' below).** The general-`f` concrete-model route is
ABANDONED and off-path. The relative Picard consumer only ever needs `δ` to be an iso on LINE
BUNDLES, and there iso-ness comes via the **local-trivialisation chart-chase** (D2'–D4'), NOT via a
concrete inverse-image model: the oplax `δ` is sheafified (`pullbackTensorMap`), reduced to the
single sheafified-presheaf comparison (`isIso_pullbackTensorMap_of_isIso_sheafifyDelta`), shown iso
on the unit pair (D2'), and globalised over a trivialising cover (D4', `isIso_of_isIso_restrict`).
The "no free oplax ⇒ preserves invertibles" obstruction (`Γ(ℙ¹,𝒪(1)) = 0`) is real for a GENERAL
module but is sidestepped for line bundles by the chart-chase — no concrete model is built. -/

/-- **Identifying the sheafified presheaf-pullback of `M.val` with the abstract pullback.**
For `f : Y ⟶ X` and `M : X.Modules`, sheafifying the presheaf-level pullback of the
underlying presheaf `M.val` recovers the abstract `𝒪`-module pullback `(pullback f).obj M`.
This is the per-object form of `SheafOfModules.sheafificationCompPullback` composed with the
sheafification counit on the (already-sheaf) `M`; it is the bridge used to reconcile the
right-hand side of the pullback–tensor comparison `pullbackTensorMap` with the substrate
`tensorObj` of the pullbacks. -/
noncomputable def pullbackValIso {X Y : Scheme.{u}} (f : Y ⟶ X) (M : X.Modules) :
    (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).obj
        ((PresheafOfModules.pullback (f.toRingCatSheafHom).hom).obj M.val)
      ≅ (Scheme.Modules.pullback f).obj M :=
  ((SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).app M.val).symm ≪≫
    (Scheme.Modules.pullback f).mapIso
      ((asIso (PresheafOfModules.sheafificationAdjunction
        (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).counit).app M)

/-- **The sheaf-level pullback–tensor comparison map `δ_sheaf`** (blueprint
`lem:pullback_tensor_map`). For a morphism of schemes `f : Y ⟶ X` and arbitrary
`M N : X.Modules`, the canonical comparison morphism
`f^*(M ⊗_X N) ⟶ f^*M ⊗_Y f^*N`. It is the sheaf-level transport of the presheaf-level
oplax comparison `δ` (`presheafPullbackOplaxMonoidal`) through sheafification, assembled
from the `sheafificationCompPullback` device, `sheafifyTensorUnitIso`, and `pullbackValIso`.
This is a *map only*: in general it is not asserted to be an isomorphism (the invertible
case is upgraded to an iso by local trivialisation in `IsInvertible.pullback`). -/
noncomputable def pullbackTensorMap {X Y : Scheme.{u}} (f : Y ⟶ X) (M N : X.Modules) :
    (Scheme.Modules.pullback f).obj (tensorObj M N) ⟶
      tensorObj ((Scheme.Modules.pullback f).obj M) ((Scheme.Modules.pullback f).obj N) := by
  let φ := f.toRingCatSheafHom
  let φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) := φ.hom
  let a_Y := PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)
  refine ((SheafOfModules.sheafificationCompPullback φ).app
      (PresheafOfModules.Monoidal.tensorObj M.val N.val)).hom ≫ ?_
  refine a_Y.map (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ') M.val N.val) ≫ ?_
  refine (sheafifyTensorUnitIso (X := Y)
      ((PresheafOfModules.pullback φ').obj M.val)
      ((PresheafOfModules.pullback φ').obj N.val)).hom ≫ ?_
  exact a_Y.map (MonoidalCategory.tensorHom
    (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
    ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
    ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom))

/-! ## Project-local Mathlib supplement — D1: the presheaf pullback Lan decomposition

These are general `PresheafOfModules` statements (any `F : C ⥤ D`, ring presheaves
`R, S`), not specific to schemes; they are project-local because Mathlib's pinned commit
exposes neither `extendScalars` nor `pullback₀` at the presheaf-of-modules level. Both are
realised as the left adjoint of an existing right adjoint: `pushforward₀ F R` is
definitionally `pushforward (𝟙 (F.op ⋙ R))` (because `restrictScalars (𝟙) = 𝟭` on the nose,
witnessed by Mathlib's `restrictScalars (𝟙 R)).Full := inferInstanceAs (𝟭 _).Full`), and
`restrictScalars φ` is definitionally `pushforward (F := 𝟭) φ`; since `pushforward _` is
always a right adjoint, so are these two, and their left adjoints `pullback₀`/`extendScalars`
exist. The decomposition `pullback φ ≅ extendScalars φ ⋙ pullback₀` then follows from the
definitional factorisation `pushforward φ = pushforward₀ F R ⋙ restrictScalars φ` by
uniqueness of left adjoints (`Adjunction.leftAdjointCompIso`).

Per blueprint `lem:pullback_lan_decomposition` (D1). **OFF-PATH (iter-243 pivot).** D1 is
axiom-clean and self-contained, but it was the first brick of the ABANDONED general
strong-monoidal pullback build (`sec:tensorobj_pullback_monoidality`, route (e)); the active
route is the loc-triv chart-chase D1'–D4' (§below), which does NOT consume `extendScalars`/
`pullback₀`. Retained as a correct, reusable presheaf-level decomposition; do NOT extend it
toward the general build (D2 scalar-strong / D3 topological-interchange are NOT pursued). -/

section PullbackLanDecomposition

variable {C : Type u} [Category.{u} C] {D : Type u} [Category.{u} D]
  {F : C ⥤ D} {R : Dᵒᵖ ⥤ RingCat.{u}} {S : Cᵒᵖ ⥤ RingCat.{u}}

/-- `pushforward₀ F R` is a right adjoint: it is definitionally `pushforward (𝟙 (F.op ⋙ R))`
(since `restrictScalars (𝟙) = 𝟭` on the nose). Project-local; carries the existence of the
topological inverse image `pullback₀`. -/
private lemma pushforward₀IsRightAdjoint (F : C ⥤ D) (R : Dᵒᵖ ⥤ RingCat.{u}) :
    (PresheafOfModules.pushforward₀.{u} F R).IsRightAdjoint :=
  inferInstanceAs (PresheafOfModules.pushforward.{u} (𝟙 (F.op ⋙ R))).IsRightAdjoint

/-- `restrictScalars φ` is a right adjoint: it is definitionally `pushforward (F := 𝟭) φ`.
Project-local; carries the existence of the extension of scalars `extendScalars`. -/
private lemma restrictScalarsIsRightAdjoint (φ : S ⟶ F.op ⋙ R) :
    (PresheafOfModules.restrictScalars.{u} φ).IsRightAdjoint :=
  inferInstanceAs
    (PresheafOfModules.pushforward.{u} (F := 𝟭 C) (R := F.op ⋙ R) φ).IsRightAdjoint

/-- **The topological inverse image `pullback₀ := (pushforward₀ F R).leftAdjoint`**, the
left adjoint of the fixed-ring pushforward. On underlying presheaves it is the left Kan
extension along `F.op`. Project-local (no `PresheafOfModules` inverse-image functor at the
pin); the carrier of D3. -/
noncomputable def pullback0 (F : C ⥤ D) (R : Dᵒᵖ ⥤ RingCat.{u}) :
    _root_.PresheafOfModules.{u} (F.op ⋙ R) ⥤ _root_.PresheafOfModules.{u} R :=
  haveI := pushforward₀IsRightAdjoint F R
  (PresheafOfModules.pushforward₀ F R).leftAdjoint

/-- **Extension of scalars `extendScalars φ := (restrictScalars φ).leftAdjoint`**, the left
adjoint of restriction of scalars along a morphism of ring presheaves. Project-local; the
carrier of D2 (strong monoidal via `distribBaseChange`). -/
noncomputable def extendScalars (φ : S ⟶ F.op ⋙ R) :
    _root_.PresheafOfModules.{u} S ⥤ _root_.PresheafOfModules.{u} (F.op ⋙ R) :=
  haveI := restrictScalarsIsRightAdjoint φ
  (PresheafOfModules.restrictScalars φ).leftAdjoint

/-- The adjunction `pullback₀ ⊣ pushforward₀`. -/
noncomputable def pullback0Adjunction (F : C ⥤ D) (R : Dᵒᵖ ⥤ RingCat.{u}) :
    pullback0 F R ⊣ PresheafOfModules.pushforward₀ F R :=
  haveI := pushforward₀IsRightAdjoint F R
  Adjunction.ofIsRightAdjoint (PresheafOfModules.pushforward₀ F R)

/-- The adjunction `extendScalars φ ⊣ restrictScalars φ`. -/
noncomputable def extendScalarsAdjunction (φ : S ⟶ F.op ⋙ R) :
    extendScalars φ ⊣ PresheafOfModules.restrictScalars φ :=
  haveI := restrictScalarsIsRightAdjoint φ
  Adjunction.ofIsRightAdjoint (PresheafOfModules.restrictScalars φ)

/-- **D1 — the presheaf pullback Lan decomposition** (blueprint `lem:pullback_lan_decomposition`).
For `φ : S ⟶ F.op ⋙ R` presenting a pushforward of presheaves of modules, the presheaf
pullback factors as extension of scalars followed by the topological inverse image,
`pullback φ ≅ extendScalars φ ⋙ pullback₀`. This is the left-adjoint reversal of the
definitional factorisation `pushforward φ = pushforward₀ F R ⋙ restrictScalars φ`, obtained
from `Adjunction.leftAdjointCompIso` (uniqueness of left adjoints). Project-local. -/
noncomputable def pullbackLanDecomposition (φ : S ⟶ F.op ⋙ R) :
    PresheafOfModules.pullback φ ≅ extendScalars φ ⋙ pullback0 F R :=
  (Adjunction.leftAdjointCompIso
    (extendScalarsAdjunction φ) (pullback0Adjunction F R)
    (PresheafOfModules.pullbackPushforwardAdjunction φ)
    (Iso.refl (PresheafOfModules.pushforward φ))).symm

end PullbackLanDecomposition

/-! ## Project-local Mathlib supplement — D1'–D4' loc-triv pullback–tensor comparison

The locally-trivial-restricted upgrade of the oplax comparison map
`pullbackTensorMap` (`f^*(M ⊗ N) ⟶ f^*M ⊗ f^*N`) to an isomorphism, blueprint
§`sec:tensorobj_pullback_monoidality`, sub-lemmas D1'–D4'. -/

section LocTrivPullbackTensor

/-- **The sheafified `⊗ₘ` of the two `pullbackValIso`s (piece 4 of `pullbackTensorMap`) is an
iso.** Factored out as a top-level lemma so the `tensorIso (C := _ ⋙ forget₂)` elaboration mirrors
the proven `tensorObjIsoOfIso` (it does not elaborate cleanly inside a tactic block carrying
`extract_lets` locals). Project-local helper for `isIso_pullbackTensorMap_of_isIso_sheafifyDelta`. -/
private lemma isIso_sheafify_tensorHom_pullbackValIso {X Y : Scheme.{u}}
    (f : Y ⟶ X) (M N : X.Modules) :
    IsIso ((PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
      (MonoidalCategory.tensorHom
        (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
        ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
        ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom))) :=
  ((PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).mapIso
    (MonoidalCategory.tensorIso
      (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
      ((SheafOfModules.forget Y.ringCatSheaf).mapIso (pullbackValIso f M))
      ((SheafOfModules.forget Y.ringCatSheaf).mapIso (pullbackValIso f N)))).isIso_hom

/-- **Reduction of `pullbackTensorMap` iso-ness to the sheafified presheaf δ.**

`pullbackTensorMap f M N` is the four-fold composite
`(sheafificationCompPullback).hom ≫ a_Y.map δ ≫ (sheafifyTensorUnitIso).hom ≫ a_Y.map (tensorHom …)`.
Three of the four factors (`sheafificationCompPullback`, `sheafifyTensorUnitIso`,
and the `tensorHom` of the two `pullbackValIso`s) are isomorphisms unconditionally;
the only conditional factor is the sheafification `a_Y.map δ` of the presheaf-level
oplax comparison `δ`. Hence `pullbackTensorMap f M N` is an iso whenever that
sheafified δ is an iso. This isolates the SOLE remaining content (the sheafified δ)
for D2' (unit pair) and D4' (chart-chase). Project-local. -/
lemma isIso_pullbackTensorMap_of_isIso_sheafifyDelta {X Y : Scheme.{u}}
    (f : Y ⟶ X) (M N : X.Modules)
    (h : letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
          (f.toRingCatSheafHom).hom
        IsIso ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
          (𝟙 Y.ringCatSheaf.val)).map
          (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ') M.val N.val))) :
    IsIso (pullbackTensorMap f M N) := by
  unfold pullbackTensorMap
  extract_lets φ φ' a_Y
  -- piece 2 (the sheafified δ) is the only conditional factor — supplied by `h`.
  haveI hδ : IsIso (a_Y.map
      (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ') M.val N.val)) := h
  -- pieces 1 and 3 are `Iso.hom`s; piece 4 is `a_Y.map` of the (iso) `⊗ₘ` of the two
  -- `pullbackValIso`s, supplied by the factored top-level helper.
  exact IsIso.comp_isIso' inferInstance (IsIso.comp_isIso' hδ
    (IsIso.comp_isIso' inferInstance (isIso_sheafify_tensorHom_pullbackValIso f M N)))

/-- **Converse of `isIso_sheafification_map_of_W`.** A morphism of presheaves of modules whose
image under the associated-sheaf functor is an isomorphism lies (on underlying additive presheaves)
in the sheafification localizer `J.W`. This is the same morphism-property identity
`PresheafOfModules.inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` (the sheafification
functor *is* the localization at `J.W.inverseImage (toPresheaf _)`) read backwards. Project-local:
needed to feed the flatness-free whiskering lemmas `W_whisker{Left,Right}_of_W` from a sheafified
iso (the D2' η-bridge route, below). -/
private lemma W_of_isIso_sheafification {C : Type u} [Category.{u} C] {J : GrothendieckTopology C}
    {R₀ : Cᵒᵖ ⥤ RingCat} {Rsh : CategoryTheory.Sheaf J RingCat} (α : R₀ ⟶ Rsh.obj)
    [Presheaf.IsLocallyInjective J α] [Presheaf.IsLocallySurjective J α]
    [J.WEqualsLocallyBijective AddCommGrpCat] [CategoryTheory.HasWeakSheafify J AddCommGrpCat]
    {A B : _root_.PresheafOfModules.{u} R₀} (f : A ⟶ B)
    (hf : IsIso ((PresheafOfModules.sheafification α).map f)) :
    J.W ((PresheafOfModules.toPresheaf R₀).map f) := by
  have h := PresheafOfModules.inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms (J := J) α
  have h2 : (CategoryTheory.MorphismProperty.isomorphisms (SheafOfModules Rsh)).inverseImage
      (PresheafOfModules.sheafification α) f := hf
  rw [← h] at h2
  exact h2

/-- **D2' δ-wrapping — the sheafified cotensorator on the unit pair is an iso, given the η-bridge.**

The presheaf-level oplax unitality `Functor.OplaxMonoidal.left_unitality_hom` factors the
cotensorator `δ (pullback φ') 𝟙_ 𝟙_` of the abstract presheaf pullback through the unit comparison
`η (pullback φ')` (right-whiskered by `F.obj 𝟙_`) and the (iso) left unitor. Sheafifying, the
unitor factor and the `F.map (λ_ 𝟙_)` factor are isomorphisms unconditionally; the whiskered
`η`-factor `a_Y.map (η F ▷ F.obj 𝟙_)` is an iso whenever `a_Y.map (η F)` is — because a sheafified
iso lies in `J.W` (`W_of_isIso_sheafification`), `J.W` is stable under right-whiskering
(`W_whiskerRight_of_W`, flatness-free), and `J.W`-morphisms sheafify to isos
(`isIso_sheafification_map_of_W`). Hence the sheafified `δ` on the unit pair is an iso, which is
exactly the hypothesis the reduction brick `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` consumes
on `M = N = 𝒪`. Project-local; the **δ-wrapping** half of D2' (`lem:pullback_tensor_iso_unit`),
self-contained modulo the η-bridge `IsIso (a_Y.map (η (pullback φ')))`. -/
lemma isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta {X Y : Scheme.{u}} (f : Y ⟶ X)
    (h : letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
          (f.toRingCatSheafHom).hom
        IsIso ((PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
          (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')))) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    IsIso ((PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
      (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ')
        (SheafOfModules.unit X.ringCatSheaf).val (SheafOfModules.unit X.ringCatSheaf).val)) := by
  letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
      (f.toRingCatSheafHom).hom
  set a_Y := PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val) with ha
  change IsIso (a_Y.map (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ') (𝟙_ _) (𝟙_ _)))
  set F := PresheafOfModules.pullback φ' with hF
  have hWη : (Opens.grothendieckTopology (Y : TopCat)).W
      ((PresheafOfModules.toPresheaf _).map (Functor.OplaxMonoidal.η F)) :=
    W_of_isIso_sheafification (𝟙 Y.ringCatSheaf.val) _ h
  have hWw : (Opens.grothendieckTopology (Y : TopCat)).W
      ((PresheafOfModules.toPresheaf _).map (Functor.OplaxMonoidal.η F ▷ F.obj (𝟙_ _))) :=
    PresheafOfModules.W_whiskerRight_of_W (R := Y.presheaf) _ _ hWη
  haveI hIsoW : IsIso (a_Y.map (Functor.OplaxMonoidal.η F ▷ F.obj (𝟙_ _))) :=
    PresheafOfModules.isIso_sheafification_map_of_W (𝟙 Y.ringCatSheaf.val) _ hWw
  haveI hIsoLam : IsIso (a_Y.map (λ_ (F.obj (𝟙_ _))).hom) := inferInstance
  have hBC : IsIso (a_Y.map
      (Functor.OplaxMonoidal.η F ▷ F.obj (𝟙_ _) ≫ (λ_ (F.obj (𝟙_ _))).hom)) := by
    rw [Functor.map_comp]; infer_instance
  haveI hD : IsIso (a_Y.map (F.map (λ_ (𝟙_ _)).hom)) := inferInstance
  have hlu := Functor.OplaxMonoidal.left_unitality_hom F (𝟙_ _)
  have key : a_Y.map (Functor.OplaxMonoidal.δ F (𝟙_ _) (𝟙_ _)) ≫
      a_Y.map (Functor.OplaxMonoidal.η F ▷ F.obj (𝟙_ _) ≫ (λ_ (F.obj (𝟙_ _))).hom)
      = a_Y.map (F.map (λ_ (𝟙_ _)).hom) := by
    rw [← Functor.map_comp]; exact congrArg _ hlu
  have heq : a_Y.map (Functor.OplaxMonoidal.δ F (𝟙_ _) (𝟙_ _))
      = a_Y.map (F.map (λ_ (𝟙_ _)).hom) ≫
        inv (a_Y.map (Functor.OplaxMonoidal.η F ▷ F.obj (𝟙_ _) ≫ (λ_ (F.obj (𝟙_ _))).hom)) := by
    rw [← key, Category.assoc, IsIso.hom_inv_id, Category.comp_id]
  rw [heq]; infer_instance

/-- **D2' assembly — `pullbackTensorMap` on the unit pair is an iso, given the η-bridge.**
Chains the δ-wrapping `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` into the reduction brick
`isIso_pullbackTensorMap_of_isIso_sheafifyDelta` (on `M = N = 𝒪`). This is the full statement of
D2' (`lem:pullback_tensor_iso_unit`) modulo the single remaining η-bridge hypothesis
`IsIso (a_Y.map (η (pullback φ')))` (the sheafification-mate identification of the sheafified
presheaf unit comparison with `pullbackUnitIso`, the unit-side analog of
`pullbackObjUnitToUnit_comp`). Project-local. -/
lemma isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta {X Y : Scheme.{u}} (f : Y ⟶ X)
    (h : letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
          (f.toRingCatSheafHom).hom
        IsIso ((PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
          (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')))) :
    IsIso (pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf)
      (SheafOfModules.unit X.ringCatSheaf)) := by
  apply isIso_pullbackTensorMap_of_isIso_sheafifyDelta
  exact isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta f h

/-! **D2' onward — handoff (iter-246).** The δ-wrapping half of D2' is now LANDED axiom-clean:
`isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` reduces the sheafified `δ` on the unit pair to
the η-bridge `IsIso (a_Y.map (η (pullback φ')))` (via `left_unitality_hom` + the W-stable
right-whiskering `W_whiskerRight_of_W` fed by the new converse `W_of_isIso_sheafification`), and
`isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` chains it into the reduction brick. So the
SOLE remaining content of D2' is the **η-bridge**

  `IsIso (a_Y.map (η (PresheafOfModules.pullback φ')))`.

This is the commuting square (`sheafifyUnitIso` is its right vertical, built above)
`a_Y.map (η F) ≫ sheafifyUnitIso.hom = (pullbackValIso f 𝒪_X).hom ≫ pullbackObjUnitToUnit φ`.
Transposing across `SheafOfModules.pullbackPushforwardAdjunction φ` (apply `.homEquiv.injective`,
then `pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit`, `homEquiv_unit`,
`leftAdjointOplaxMonoidal_η`, `homEquiv_counit`) reduces the square to the concrete pushforward-side
identity (sheafification-mate bridge):

  `sheafAdj.unit.app 𝒪_X ≫ (pushforward φ).map ((pullbackValIso).inv ≫
      a_Y.map (pullback_pre.map ε_pre ≫ presheafAdj.counit) ≫ sheafifyUnitIso.hom)
    = unitToPushforwardObjUnit φ`,

where `ε_pre = LaxMonoidal.ε (PresheafOfModules.pushforward φ.hom)`. The glue is the leftAdjointUniq
compatibility of `SheafOfModules.sheafificationCompPullback`/`pullbackIso` (the bridges inside
`pullbackValIso`) — `Adjunction.{homEquiv_,unit_,}leftAdjointUniq_hom_app`,
`leftAdjointUniq_hom_app_counit` — relating the presheaf and sheaf adjunction units; this is the
unit-side analog of `pullbackObjUnitToUnit_comp`, NOT yet assembled (a self-contained next step).

* **D3'/D4'** (the chart-chase): use `isIso_of_isIso_restrict` (L546) over the common trivialising
  cover; on each chart D3' (δ commutes with the open-immersion base-change square — the sole
  genuinely-new mate calculus, analog of `pullbackObjUnitToUnit_comp`) localises the sheafified δ,
  the naturality D1' transports to the unit pair, and D2' closes. Each stays inside
  `IsIso (a_Y.map δ …)`, so `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` is the shared entry. -/

/-- **Codomain identification for the D2' η-bridge.** The sheafification counit identifies the
sheafified presheaf monoidal unit `a_Y.obj 𝟙_` with the sheaf-level structure module
`𝒪_Y = SheafOfModules.unit Y.ringCatSheaf` (`𝟙_ = (unit Y).val` definitionally, and `unit Y` is
already a sheaf, so the counit at it is an isomorphism). This is the right-hand vertical of the
η-bridge square `a_Y.map (η (pullback φ')) ≫ sheafifyUnitIso.hom
= (pullbackValIso f 𝒪_X).hom ≫ pullbackObjUnitToUnit φ` whose commutativity is the remaining
content of D2' (see the handoff note above and `task_results`). Project-local building block. -/
noncomputable def sheafifyUnitIso {Y : Scheme.{u}} :
    (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).obj
        (𝟙_ (_root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)))
      ≅ SheafOfModules.unit Y.ringCatSheaf :=
  (asIso (PresheafOfModules.sheafificationAdjunction
    (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).counit).app (SheafOfModules.unit Y.ringCatSheaf)

/-- **Presheaf-side mate identity for the η-bridge** (`unit_app_unit_comp_map_η` instantiated).
For a scheme morphism `f : Y ⟶ X` with `φ' = f.toRingCatSheafHom.hom`, the presheaf-of-modules
adjunction unit at the monoidal unit, post-composed with the pushforward of the oplax unit
comparison `η (pullback φ')`, recovers the lax unit `ε (pushforward φ')`. This is the
presheaf-level driver of the D2' η-bridge: under sheafification (via `sheafificationCompPullback`)
it transports to the sheaf identity
`homEquiv (pullbackObjUnitToUnit φ) = unitToPushforwardObjUnit φ`.
Project-local: it certifies that the project's `presheafPushforwardLaxMonoidal` /
`presheafPullbackOplaxMonoidal` instances are `Adjunction.IsMonoidal`-compatible, so the Mathlib
mate identity fires for this concrete adjunction. -/
lemma presheafUnit_comp_map_eta {X Y : Scheme.{u}} (f : Y ⟶ X) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    (PresheafOfModules.pullbackPushforwardAdjunction φ').unit.app
        (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))) ≫
      (PresheafOfModules.pushforward φ').map
        (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ'))
      = Functor.LaxMonoidal.ε (PresheafOfModules.pushforward φ') := by
  letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
      (f.toRingCatSheafHom).hom
  haveI : (PresheafOfModules.pushforward φ').IsRightAdjoint :=
    (PresheafOfModules.pullbackPushforwardAdjunction φ').isRightAdjoint
  exact Adjunction.unit_app_unit_comp_map_η (PresheafOfModules.pullbackPushforwardAdjunction φ')

/-- **D2' η-bridge — IsIso reduction to the unit comparison square** (axiom-clean plumbing).
Given the commuting square identifying the sheafified presheaf unit comparison `a_Y.map (η F)`
with the sheaf-level `pullbackObjUnitToUnit φ` through the canonical isos `pullbackValIso` and
`sheafifyUnitIso`, the η-bridge `IsIso (a_Y.map (η (pullback φ')))` follows (the comparison
`pullbackObjUnitToUnit φ` is an iso since `Opens.map f.base` is always `Final`). This isolates the
SOLE remaining mathematical content of the η-bridge as the square hypothesis `hsq` (= the unit-side
analog of `pullbackObjUnitToUnit_comp`, see handoff in `task_results`). Project-local. -/
lemma isIso_sheafifyEta_of_unitSquare {X Y : Scheme.{u}} (f : Y ⟶ X)
    (hsq : letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
          (f.toRingCatSheafHom).hom
        (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).inv ≫
          (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
            (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')) ≫ sheafifyUnitIso.hom
          = SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    IsIso ((PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
      (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ'))) := by
  letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
      (f.toRingCatSheafHom).hom
  set a_Y := PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val) with ha
  set F := PresheafOfModules.pullback φ' with hF
  haveI hfin : (TopologicalSpace.Opens.map f.base).Final := final_of_representablyFlat _
  haveI hpbu : IsIso (SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom) :=
    isIso_pbu_of_final f
  have key : a_Y.map (Functor.OplaxMonoidal.η F) ≫ sheafifyUnitIso.hom
      = (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).hom ≫
        SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom :=
    (Iso.inv_comp_eq _).mp hsq
  rw [(Iso.eq_comp_inv sheafifyUnitIso).mpr key]
  exact IsIso.comp_isIso' (IsIso.comp_isIso' inferInstance hpbu) inferInstance

/-- **Composite-adjunction `homEquiv` factorisation** (blueprint
`lem:comp_homequiv_factor_sheafify_pullback`, ★ step 3). For composable adjunctions
`adj₁ : L₁ ⊣ R₁` and `adj₂ : L₂ ⊣ R₂`, the hom-set bijection of the composite adjunction
`A = adj₁.comp adj₂ : L₁ ⋙ L₂ ⊣ R₂ ⋙ R₁` factors as the composite of the two factor
bijections: a morphism `(L₁ ⋙ L₂).obj c ⟶ e` is transposed first across `adj₂` and then
across `adj₁`. This is the standard naturality of `homEquiv` under composition of adjunctions,
read off the `homEquiv = unit ≫ R.map` formula together with `Adjunction.comp_unit_app`.
Project-local. -/
lemma compHomEquivFactor {C₁ : Type*} {C₂ : Type*} {C₃ : Type*}
    [Category C₁] [Category C₂] [Category C₃]
    {L₁ : C₁ ⥤ C₂} {R₁ : C₂ ⥤ C₁} {L₂ : C₂ ⥤ C₃} {R₂ : C₃ ⥤ C₂}
    (adj₁ : L₁ ⊣ R₁) (adj₂ : L₂ ⊣ R₂) {c : C₁} {e : C₃}
    (g : (L₁ ⋙ L₂).obj c ⟶ e) :
    (adj₁.comp adj₂).homEquiv c e g
      = adj₁.homEquiv c (R₂.obj e) (adj₂.homEquiv (L₁.obj c) e g) := by
  simp only [Adjunction.homEquiv_unit, Adjunction.comp_unit_app, Functor.comp_map,
    Functor.map_comp]
  exact Category.assoc _ _ _

/-- **The `sheafificationCompPullback` comparison is the canonical `leftAdjointUniq`** of the
two composite adjunctions of the unit square. With
`A = (sheafificationAdjunction 𝟙_X).comp (SheafOfModules.pullbackPushforwardAdjunction φ)` (left
adjoint `a_X ⋙ SheafOfModules.pullback φ`) and
`B = (PresheafOfModules.pullbackPushforwardAdjunction φ').comp (sheafificationAdjunction 𝟙_Y)`
(left adjoint `PresheafOfModules.pullback φ' ⋙ a_Y`), the Mathlib device
`SheafOfModules.sheafificationCompPullback φ` is, on the nose (`rfl`),
`Adjunction.leftAdjointUniq A B`. This is the definitional identification the blueprint asserts
(`lem:leftadjointuniq_app_unit_eta`): it is what makes the mate-calculus `homEquiv_leftAdjointUniq`
identities fire for the concrete unit-square adjunctions. Project-local linchpin. -/
lemma sheafificationCompPullback_eq_leftAdjointUniq {X Y : Scheme.{u}} (f : Y ⟶ X) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom
      = ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
            (𝟙 X.ringCatSheaf.val)).comp
          (SheafOfModules.pullbackPushforwardAdjunction f.toRingCatSheafHom)).leftAdjointUniq
        ((PresheafOfModules.pullbackPushforwardAdjunction φ').comp
          (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.val))) :=
  rfl

/-- **leftAdjointUniq transport of the composite unit** (blueprint
`lem:leftadjointuniq_app_unit_eta`, ★ step 4). For the two composite adjunctions `A`, `B` of the
unit square, applying `A.homEquiv` to the `𝟙_`-component of the comparison
`sheafificationCompPullback φ` recovers `B.unit.app 𝟙_`, which expands (by
`Adjunction.comp_unit_app` on `B`) into the presheaf pullback–pushforward unit followed by the
pushforward of the sheafification unit. This is the genuinely adjunction-theoretic head of step 4
of `lem:eta_bridge_unit_square`. Project-local. -/
lemma leftAdjointUniqUnitEta {X Y : Scheme.{u}} (f : Y ⟶ X) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
          (𝟙 X.ringCatSheaf.val)).comp
        (SheafOfModules.pullbackPushforwardAdjunction f.toRingCatSheafHom)).homEquiv
        (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))) _
        ((SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.app
          (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))))
      = (PresheafOfModules.pullbackPushforwardAdjunction φ').unit.app
          (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))) ≫
        (PresheafOfModules.pushforward φ').map
          ((PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
              (𝟙 Y.ringCatSheaf.val)).unit.app
            ((PresheafOfModules.pullback φ').obj
              (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))))) := by
  letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
      (f.toRingCatSheafHom).hom
  set A := (PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
      (𝟙 X.ringCatSheaf.val)).comp
      (SheafOfModules.pullbackPushforwardAdjunction f.toRingCatSheafHom)
    with hA
  set B := (PresheafOfModules.pullbackPushforwardAdjunction φ').comp
      (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val))
    with hB
  have hg : (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.app
        (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)))
      = (A.leftAdjointUniq B).hom.app
        (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))) := rfl
  rw [hg]
  refine Eq.trans (Adjunction.homEquiv_leftAdjointUniq_hom_app A B
    (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)))) ?_
  rw [hB, Adjunction.comp_unit_app]
  rfl

/-- **leftAdjointUniq transport of the composite unit, general object** (the `P`-general form of
`leftAdjointUniqUnitEta`, ma-d3264 step 1). For the two composite adjunctions `A`, `B` of the unit
square and ANY presheaf of modules `P`, applying `A.homEquiv` to the `P`-component of the comparison
`sheafificationCompPullback φ` recovers `B.unit.app P`, expanded by `Adjunction.comp_unit_app` on `B`
as `PrPbPushAdj φ' .unit P ≫ pushforward φ' .map (sheafAdj_Y.unit (pullback φ' P))`. This is the
R1/R5-recovery brick of `sheafificationCompPullback_comp_tail`: it identifies the `sheafCompPb f .hom.app P`
factor with the composite-adjunction `B_f`-unit. The proof is the object-generic version of
`leftAdjointUniqUnitEta` (which is the `P := 𝟙_` specialization); nothing about `𝟙_` is used. -/
lemma leftAdjointUniqUnitEta_app {X Y : Scheme.{u}} (f : Y ⟶ X)
    (P : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
          (𝟙 X.ringCatSheaf.val)).comp
        (SheafOfModules.pullbackPushforwardAdjunction f.toRingCatSheafHom)).homEquiv P _
        ((SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.app P)
      = (PresheafOfModules.pullbackPushforwardAdjunction φ').unit.app P ≫
        (PresheafOfModules.pushforward φ').map
          ((PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
              (𝟙 Y.ringCatSheaf.val)).unit.app
            ((PresheafOfModules.pullback φ').obj P)) := by
  letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
      (f.toRingCatSheafHom).hom
  set A := (PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
      (𝟙 X.ringCatSheaf.val)).comp
      (SheafOfModules.pullbackPushforwardAdjunction f.toRingCatSheafHom)
    with hA
  set B := (PresheafOfModules.pullbackPushforwardAdjunction φ').comp
      (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val))
    with hB
  have hg : (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.app P
      = (A.leftAdjointUniq B).hom.app P := rfl
  rw [hg]
  refine Eq.trans (Adjunction.homEquiv_leftAdjointUniq_hom_app A B P) ?_
  rw [hB, Adjunction.comp_unit_app]
  rfl

/-- **`restrictScalars (𝟙 R)` is the identity on morphisms.** `restrictScalars (𝟙 R)` is defeq to the
identity functor `𝟭`, so its action on a morphism is the morphism itself. Stated as a *propositional*
rewrite (proved once over an abstract `g`, hence cheap) so that the `restrictScalars (𝟙)` wrappers in
the D2′ `(∗∗)` goal can be stripped by a single SYNTACTIC `rw` — avoiding the catastrophic whole-term
`whnf` that a `show`/`rfl` triggers on the sheafification-laden composites. Project-local. -/
lemma restrictScalarsId_map {C : Type u} [Category.{u} C] {R : Cᵒᵖ ⥤ RingCat.{u}}
    {M N : _root_.PresheafOfModules R} (g : M ⟶ N) :
    (PresheafOfModules.restrictScalars (𝟙 R)).map g = g := rfl

set_option backward.isDefEq.respectTransparency false in
/-- **Step 7 — the presheaf lax-unit `ε` of `pushforward φ'` is the underlying presheaf map of
the sheaf-level structure-unit comparison `unitToPushforwardObjUnit φ`** (blueprint
`lem:epsilon_presheaf_to_sheaf_unit`). Both act sectionwise as `φ.hom.app X`. This is the SOLE
genuinely-new ingredient of the D2′ `(∗∗)` close: after the abstract telescope and the Y-side
sheafification triangle fold the big `homEquiv` argument down to `ε (pushforward φ')`, this lemma
lands it on `(unitToPushforwardObjUnit φ).val` (defeq `R_X.map (unitToPushforwardObjUnit φ)`).
Proved sectionwise via the `Functor.LaxMonoidal.comp` ε-formula (`pushforward₀`'s `ε = 𝟙`),
`restrictScalarsLaxε`, `ModuleCat.restrictScalars_η`, and `unitToPushforwardObjUnit_val_app_apply`.
Project-local. -/
lemma epsilonPresheafToSheafUnit {X Y : Scheme.{u}} (f : Y ⟶ X) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    Functor.LaxMonoidal.ε (PresheafOfModules.pushforward φ')
      = (SheafOfModules.unitToPushforwardObjUnit f.toRingCatSheafHom).val := by
  apply PresheafOfModules.hom_ext
  intro X₀
  apply ModuleCat.hom_ext
  ext r
  -- Provide the `CommRing` instance on the scalar ring `S₀` in the `(restrictScalars f).obj 𝟙_`
  -- spelling that `ModuleCat.restrictScalars_η` synthesises against (synthInstance does not reduce
  -- `(restrictScalars f).obj 𝟙_` to the `forget₂`-carrier where the canonical instance is keyed).
  letI : CommRing ↑((ModuleCat.restrictScalars
      (RingCat.Hom.hom ((Hom.toRingCatSheafHom f).hom.app X₀))).obj (𝟙_ (ModuleCat
        ↑((((TopologicalSpace.Opens.map f.base).op ⋙ Y.presheaf) ⋙
            forget₂ CommRingCat RingCat).obj X₀)))) :=
    inferInstanceAs (CommRing ↑((((TopologicalSpace.Opens.map f.base).op ⋙ Y.presheaf) ⋙
      forget₂ CommRingCat RingCat).obj X₀))
  -- LHS: `ε (pushforward φ')` reduces (through the `pushforward₀ ⋙ restrictScalars` composite,
  -- `pushforward₀`'s `ε = 𝟙`) to `ε (restrictScalars φ'.app X₀)`, hence to `φ'.app X₀` by
  -- `restrictScalars_η`.  RHS: `unitToPushforwardObjUnit_val_app_apply` gives `φ.hom.app X₀`.
  erw [SheafOfModules.unitToPushforwardObjUnit_val_app_apply, ModuleCat.restrictScalars_η]
  rfl

-- The sheafification-adjunction right-triangle / unit-naturality composites force `whnf` on the heavy
-- sheafification machinery (`𝟙_Yp` vs `(unit Y).val` defeq), exceeding the default 200000 budget.
set_option maxHeartbeats 1600000 in
/-- **Y-side sheafification right-triangle for the oplax unit comparison** (substep (ii) of the D2′
`(∗∗)` close). For `f : Y ⟶ X` with `φ' = f.toRingCatSheafHom.hom` and `F = pullback φ'`, the
sheafification unit at `F.obj 𝟙ᵖ`, post-composed with the underlying presheaf maps of `a_Y.map (η F)`
and `sheafifyUnitIso.hom`, recovers the oplax unit comparison `η F`. This is exactly
`Equiv.apply_symm_apply` for the presheaf sheafification adjunction `homEquiv`: the second factor
`a_Y.map (η F) ≫ sheafifyUnitIso.hom` is `homEquiv.symm (η F)` (its counit factor `sheafifyUnitIso.hom`
is the adjunction counit at the sheaf `𝒪_Y`), so `homEquiv` of it is `η F`. Extracted as a standalone
lemma so its elaboration cost does not bloat the heavy `pullbackEtaUnitSquare` telescope. Project-local. -/
lemma pullbackSheafifyUnitEtaTriangle {X Y : Scheme.{u}} (f : Y ⟶ X) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    (PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val Y.ringCatSheaf))).unit.app
        ((PresheafOfModules.pullback φ').obj
          (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))))
      ≫ (((PresheafOfModules.sheafification (𝟙 (Sheaf.val Y.ringCatSheaf))).map
            (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ'))).val ≫ sheafifyUnitIso.hom.val)
      = Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ') := by
  letI : (PresheafOfModules.pushforward (Hom.toRingCatSheafHom f).hom).IsRightAdjoint :=
    (PresheafOfModules.pullbackPushforwardAdjunction _).isRightAdjoint
  -- Reassociate, fold the sheafification-unit naturality at `η F`, then the right-triangle on `𝒪_Y`.
  rw [← Category.assoc]
  erw [← (PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val Y.ringCatSheaf))).unit.naturality,
    Category.assoc, Functor.id_map]
  -- Y-side right triangle on the SHEAF `𝒪_Y = unit Y`: `sheafifyUnitIso = (asIso counit).app 𝒪_Y`.
  have htri : (PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val Y.ringCatSheaf))).unit.app
        (𝟙_ (_root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)))
      ≫ sheafifyUnitIso.hom.val = 𝟙 _ := by
    rw [sheafifyUnitIso]
    simpa only [Iso.app_hom, asIso_hom] using
      (PresheafOfModules.sheafificationAdjunction
        (𝟙 (Sheaf.val Y.ringCatSheaf))).right_triangle_components (SheafOfModules.unit Y.ringCatSheaf)
  -- `rw [htri]` cannot fire on the LHS (the codomain `𝟙_Yp` vs `(unit Y).val` are defeq only at
  -- non-reducible transparency).  Expand the RHS `η F` to `η F ≫ 𝟙` via `Category.comp_id` (its
  -- `η F` is read off the goal — no `OplaxMonoidal` re-synthesis), then `congr 1` reduces to `htri`.
  refine Eq.trans ?_ (Category.comp_id _)
  congr 1

-- The mate-calculus telescope (steps 1–6) plus the substep-(i) `.val` reshaping and the syntactic
-- `restrictScalars (𝟙)`-strip (`kabstract` on the sheafification-laden composites) exceed the default
-- 200000 budget; 3200000 is comfortably sufficient for the assembled proof.
set_option maxHeartbeats 3200000 in
/-- **The unit square** (blueprint `lem:eta_bridge_unit_square`, the assembly target). The
sheafified presheaf unit comparison `a_Y.map (η F)`, conjugated by the canonical isos
`pullbackValIso` and `sheafifyUnitIso`, equals the sheaf-level structure-unit comparison
`pullbackObjUnitToUnit φ`. The proof transposes the square across the *sheaf* pullback–pushforward
adjunction `pullbackPushforwardAdjunction φ` (`homEquiv.injective`); the right-hand side image is
`unitToPushforwardObjUnit φ` by `pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit`,
reducing the square to the concrete pushforward-side identity (∗∗), which telescopes through the
already-closed `compHomEquivFactor` (step 3), `leftAdjointUniqUnitEta` (step 4) and
`presheafUnit_comp_map_eta` (step 6). Project-local. -/
lemma pullbackEtaUnitSquare {X Y : Scheme.{u}} (f : Y ⟶ X) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).inv ≫
        (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
          (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')) ≫ sheafifyUnitIso.hom
        = SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom := by
  letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
      (f.toRingCatSheafHom).hom
  set φ := f.toRingCatSheafHom with hφ
  -- Transpose across the sheaf pullback–pushforward adjunction.
  apply ((SheafOfModules.pullbackPushforwardAdjunction φ).homEquiv
    (SheafOfModules.unit X.ringCatSheaf) (SheafOfModules.unit Y.ringCatSheaf)).injective
  rw [SheafOfModules.pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit]
  -- We keep the goal in `homEquiv` form (NOT unfolding via `homEquiv_unit`), driving the
  -- telescope through the closed mate-lemmas `compHomEquivFactor`, `leftAdjointUniqUnitEta`,
  -- `presheafUnit_comp_map_eta` and the `rfl`-linchpin `sheafificationCompPullback_eq_leftAdjointUniq`.
  -- Step 1: decompose `pullbackValIso.inv` into `(pullback φ).map c⁻¹ ≫ (sheafificationCompPullback φ).hom`
  -- where `c = (asIso (sheafification-counit_X)).app 𝒪_X`.
  simp only [pullbackValIso, Iso.trans_inv, Iso.symm_inv, Functor.mapIso_inv]
  rw [Category.assoc]
  -- Step 2: pull the leading `(pullback φ).map c⁻¹` out of `homEquiv` (`homEquiv_naturality_left`),
  -- then peel off the trailing `rest = a_Y.map (η F) ≫ sheafifyUnitIso.hom` (`homEquiv_naturality_right`).
  erw [Adjunction.homEquiv_naturality_left, Adjunction.homEquiv_naturality_right]
  -- Steps 3+4: rewrite `sheafAdj.homEquiv (sheafificationCompPullback φ).hom.app 𝟙ᵖ` via the
  -- composite-adjunction factorisation `compHomEquivFactor` and then `leftAdjointUniqUnitEta`.
  have hkey :
      (SheafOfModules.pullbackPushforwardAdjunction φ).homEquiv _ _
          ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app
            (SheafOfModules.unit X.ringCatSheaf).val).hom
        = ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
              (𝟙 X.ringCatSheaf.val)).homEquiv _ _).symm
            (((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                (𝟙 X.ringCatSheaf.val)).comp
                (SheafOfModules.pullbackPushforwardAdjunction φ)).homEquiv _ _
              ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app
                (SheafOfModules.unit X.ringCatSheaf).val).hom) := by
    rw [Equiv.eq_symm_apply, ← compHomEquivFactor]
  erw [hkey, leftAdjointUniqUnitEta f]
  -- Fold the trailing `(pushforward φ).map rest` into the X-side `homEquiv.symm`
  -- (`homEquiv_naturality_right_symm`): `symm(x) ≫ k = symm(x ≫ R_X.map k)`.
  erw [← Adjunction.homEquiv_naturality_right_symm]
  -- X-triangle (`right_triangle_components`): the sheafification unit/counit on the sheaf `𝒪_X`
  -- cancel, collapsing `homEquiv (c.hom ≫ unitToPushforwardObjUnit φ)` to `(unitToPushforwardObjUnit φ).val`.
  have hXtri : (PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val X.ringCatSheaf))).unit.app
        (SheafOfModules.unit X.ringCatSheaf).val ≫
      (PresheafOfModules.restrictScalars (𝟙 (Sheaf.val X.ringCatSheaf))).map
        ((SheafOfModules.forget X.ringCatSheaf).map
          ((asIso (PresheafOfModules.sheafificationAdjunction
              (𝟙 (Sheaf.val X.ringCatSheaf))).counit).app (SheafOfModules.unit X.ringCatSheaf)).hom)
      = 𝟙 _ := by
    simpa only [Iso.app_hom, asIso_hom, Functor.comp_map] using
      (PresheafOfModules.sheafificationAdjunction
        (𝟙 (Sheaf.val X.ringCatSheaf))).right_triangle_components (SheafOfModules.unit X.ringCatSheaf)
  have hrhs : ((PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val X.ringCatSheaf))).homEquiv
        (SheafOfModules.unit X.ringCatSheaf).val
        ((SheafOfModules.pushforward φ).obj (SheafOfModules.unit Y.ringCatSheaf)))
      (((asIso (PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val X.ringCatSheaf))).counit).app
          (SheafOfModules.unit X.ringCatSheaf)).hom ≫ SheafOfModules.unitToPushforwardObjUnit φ)
      = (SheafOfModules.forget X.ringCatSheaf ⋙
          PresheafOfModules.restrictScalars (𝟙 (Sheaf.val X.ringCatSheaf))).map
          (SheafOfModules.unitToPushforwardObjUnit φ) := by
    rw [Adjunction.homEquiv_unit]
    simp only [Functor.comp_map, Functor.map_comp]
    exact (Category.assoc _ _ _).symm.trans (hXtri ▸ Category.id_comp _)
  -- Move `c⁻¹` to the RHS (`Iso.inv_comp_eq`), transpose the X-side `homEquiv.symm`
  -- (`Equiv.symm_apply_eq`), and collapse via `hrhs`, reducing to a PRESHEAF-level equation
  -- whose RHS is `(unitToPushforwardObjUnit φ).val`.
  rw [Iso.inv_comp_eq, Equiv.symm_apply_eq]
  refine Eq.trans ?_ hrhs.symm
  -- REMAINING (∗∗): the concrete pushforward-side presheaf identity.  Substep (i): split the `.val`
  -- of `g = a_Y.map (η F) ≫ sheafifyUnitIso.hom` and reduce `R_X.map ((pushforward φ).map g)`.
  simp only [Functor.comp_map, SheafOfModules.forget_map, SheafOfModules.pushforward_map_val,
    SheafOfModules.comp_val]
  -- Strip the two `restrictScalars (𝟙)` wrappers SYNTACTICALLY via `restrictScalarsId_map`, landing
  -- the goal in the syntactic presheaf category (no `whnf` on `rs`-over-sheafification — that is
  -- catastrophic).  This succeeds and leaves the CLEAN presheaf goal
  --   `(u ≫ pf₁.map toSheafify_Y) ≫ pf₂.map ((a_Y.map (η F)).val ≫ sheafifyUnitIso.hom.val)
  --      = (unitToPushforwardObjUnit (Hom.toRingCatSheafHom f)).val`,
  -- where `pf₁ = pushforward (Hom.toRingCatSheafHom f).hom` and `pf₂ = pushforward φ.hom` are DEFEQ
  -- but spelled differently (`Hom.toRingCatSheafHom f` from `leftAdjointUniqUnitEta` vs the `set`-local
  -- `φ`).  The remaining math is exactly: merge the two `pushforward`-images via `Functor.map_comp`,
  -- fold `toSheafify_Y ≫ (a_Y.map (η F)).val ≫ sheafifyUnitIso.hom.val = η F` by the (closed)
  -- `pullbackSheafifyUnitEtaTriangle f`, then `presheafUnit_comp_map_eta f` and (closed)
  -- `epsilonPresheafToSheafUnit f` collapse to `(unitToPushforwardObjUnit φ).val`.
  rw [restrictScalarsId_map, restrictScalarsId_map]
  -- Reassociate and merge the two `pushforward φ'`-images via `erw` (keyed-defeq matching tolerates the
  -- `pf₁`/`pf₂` zeta-spelling at the connecting object), fold the argument to `η F` (ii), and collapse
  -- to `(unitToPushforwardObjUnit φ).val` via (6) `presheafUnit_comp_map_eta` + (iii) `epsilonPresheafToSheafUnit`.
  erw [Category.assoc, ← Functor.map_comp, pullbackSheafifyUnitEtaTriangle f,
    presheafUnit_comp_map_eta f, epsilonPresheafToSheafUnit f]

/-- **D2′ — the pullback–tensor comparison on the unit pair is an isomorphism** (blueprint
`lem:pullback_tensor_iso_unit`). Feeds the unit square `pullbackEtaUnitSquare` into the IsIso
plumbing `isIso_sheafifyEta_of_unitSquare` (yielding `IsIso (a_Y.map (η (pullback φ')))`), then into
the iter-246 δ-wrapping `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta`. Project-local. -/
lemma pullbackTensorMap_unit_isIso {X Y : Scheme.{u}} (f : Y ⟶ X) :
    IsIso (pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf)
      (SheafOfModules.unit X.ringCatSheaf)) :=
  isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta f
    (isIso_sheafifyEta_of_unitSquare f (pullbackEtaUnitSquare f))

/-- **Characterisation of `sheafifyTensorUnitIso.hom` on the `⋙ forget₂` carrier.** Strips the
`letI instMS` cast so the two `a.map` whisker factors are stated on the same presheaf carrier as
the rest of `pullbackTensorMap` — the bridge that lets `Functor.map_comp` merge them. -/
private lemma sheafifyTensorUnitIso_hom_eq {X : Scheme.{u}}
    (P Q : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) :
    (sheafifyTensorUnitIso P Q).hom
      = (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).map
          (MonoidalCategory.whiskerRight
            (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))
            ((PresheafOfModules.sheafificationAdjunction
              (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).unit.app P) Q) ≫
        (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).map
          (MonoidalCategory.whiskerLeft
            (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))
            ((PresheafOfModules.sheafification (R := X.ringCatSheaf)
              (𝟙 X.ringCatSheaf.val)).obj P).val
            ((PresheafOfModules.sheafificationAdjunction
              (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).unit.app Q)) := by
  rfl

/-- **`sheafifyTensorUnitIso.hom` as `a.map` of a single `tensorHom`** (tscmp254 carrier-pin). The
two whisker factors of `sheafifyTensorUnitIso_hom_eq` merge (`← Functor.map_comp`) into a single
`a.map` of `η_P ▷ Q ≫ (aP).val ◁ η_Q`, which is the `tensorHom` `η_P ⊗ η_Q` of the two
sheafification-unit components by `tensorHom_def` (the `exact` absorbs the defeq `restrictScalars (𝟙)`
wrapper on `η`'s codomain that blocks a syntactic `← tensorHom_def`).  Stating the comparison as ONE
`tensorHom` keeps every term in the single monoidal instance on the `⋙ forget₂` carrier, so the
naturality reduces to plain bifunctoriality (`← tensor_comp`) + the two single-component unit
squares — no `whisker_exchange`, no cross-instance crossing. -/
private lemma sheafifyTensorUnitIso_hom_eq' {X : Scheme.{u}}
    (P Q : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) :
    (sheafifyTensorUnitIso P Q).hom
      = (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).map
          (MonoidalCategory.tensorHom
            (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))
            ((PresheafOfModules.sheafificationAdjunction
              (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).unit.app P)
            ((PresheafOfModules.sheafificationAdjunction
              (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).unit.app Q)) := by
  rw [sheafifyTensorUnitIso_hom_eq, ← Functor.map_comp]
  congr 1
  exact (MonoidalCategory.tensorHom_def
    (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) _ _).symm

-- The `erw` defeq matching across the `SheafOfModules`/`Scheme.Modules` carrier and the
-- sheafification-laden composites is heartbeat-heavy; bump past the default.
set_option maxHeartbeats 1600000 in
/-- **Naturality of `pullbackValIso` in the module argument.** For `u : M ⟶ M'` in `X.Modules`,
the identification `pullbackValIso f` (sheafified presheaf-pullback ≅ abstract pullback) is natural:
`a_Y.map (F.map u.val) ≫ (pullbackValIso f M').hom = (pullbackValIso f M).hom ≫ (pullback f).map u`,
where `F = PresheafOfModules.pullback φ'`. Both factors of `pullbackValIso`
(`sheafificationCompPullback` and the sheafification counit) are natural; this is their paste.
Helper for `pullbackTensorMap_natural` (D1′). -/
lemma pullbackValIso_hom_natural {X Y : Scheme.{u}} (f : Y ⟶ X) {M M' : X.Modules} (u : M ⟶ M') :
    (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
        ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).map u.val) ≫
      (pullbackValIso f M').hom
      = (pullbackValIso f M).hom ≫ (Scheme.Modules.pullback f).map u := by
  simp only [pullbackValIso, Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom, Category.assoc]
  rw [← Category.assoc]
  erw [(SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).inv.naturality u.val]
  rw [Functor.comp_map,
    show (SheafOfModules.pullback (Hom.toRingCatSheafHom f)).map
          ((PresheafOfModules.sheafification (R := X.ringCatSheaf)
            (𝟙 X.ringCatSheaf.val)).map u.val)
        = (Scheme.Modules.pullback f).map
          ((PresheafOfModules.sheafification (R := X.ringCatSheaf)
            (𝟙 X.ringCatSheaf.val)).map u.val) from rfl]
  erw [Category.assoc]
  erw [← Functor.map_comp (Scheme.Modules.pullback f)
      ((PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).map u.val)
      ((asIso (PresheafOfModules.sheafificationAdjunction
        (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).counit).app M').hom,
    ← Functor.map_comp (Scheme.Modules.pullback f)
      ((asIso (PresheafOfModules.sheafificationAdjunction
        (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).counit).app M).hom u]
  congr 1
  congr 1
  exact (PresheafOfModules.sheafificationAdjunction
    (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).counit.naturality u

-- Whiskered sheafification-unit naturality across the sheafification-laden composites is
-- heartbeat-heavy; bump past the default.
set_option maxHeartbeats 1600000 in
/-- **Naturality of `sheafifyTensorUnitIso`.** For presheaf maps `p : P ⟶ P'`, `q : Q ⟶ Q'`,
the reconciliation `sheafifyTensorUnitIso` (relating `a(P⊗Q)` with `a((aP).val ⊗ (aQ).val)`) is
natural. It is the paste of the naturality of the sheafification unit `η` whiskered on each side.
Helper for `pullbackTensorMap_natural` (D1′). -/
lemma sheafifyTensorUnitIso_hom_natural {X : Scheme.{u}}
    {P P' Q Q' : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)}
    (p : P ⟶ P') (q : Q ⟶ Q') :
    (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).map
        (MonoidalCategory.tensorHom (C := _root_.PresheafOfModules
          (X.presheaf ⋙ forget₂ CommRingCat RingCat)) p q) ≫
      (sheafifyTensorUnitIso P' Q').hom
      = (sheafifyTensorUnitIso P Q).hom ≫
        (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).map
          (MonoidalCategory.tensorHom (C := _root_.PresheafOfModules
            (X.presheaf ⋙ forget₂ CommRingCat RingCat))
            ((SheafOfModules.forget X.ringCatSheaf).map
              ((PresheafOfModules.sheafification (R := X.ringCatSheaf)
                (𝟙 X.ringCatSheaf.val)).map p))
            ((SheafOfModules.forget X.ringCatSheaf).map
              ((PresheafOfModules.sheafification (R := X.ringCatSheaf)
                (𝟙 X.ringCatSheaf.val)).map q))) := by
  -- Pin both comparison factors as a single `a.map (η ⊗ η)` (tscmp254 `sheafifyTensorUnitIso_hom_eq'`):
  -- the naturality is then a `Functor.map_comp` merge + plain bifunctoriality, with every term in the
  -- ONE monoidal instance on the `⋙ forget₂` carrier — no `whisker_exchange`, no cross-instance
  -- crossing, no `erw`-on-`restrictScalars (𝟙)`-over-sheafification `whnf`.
  rw [sheafifyTensorUnitIso_hom_eq', sheafifyTensorUnitIso_hom_eq']
  -- Merge both `a.map _ ≫ a.map _` (`erw`: the connecting tensor object is defeq-but-not-syntactic
  -- — `Monoidal.tensorObj` vs the `⋙ forget₂` instance, plus the `restrictScalars (𝟙)` wrapper on
  -- `η`'s codomain — but cheap: no `restrictScalars`-over-sheafification `whnf` at the boundary).
  erw [← Functor.map_comp, ← Functor.map_comp]
  congr 1
  -- Presheaf goal: (p ⊗ q) ≫ (η_{P'} ⊗ η_{Q'}) = (η_P ⊗ η_Q) ≫ (a.map p ⊗ a.map q).
  -- Single-component unit-naturality squares (`restrictScalars (𝟙)` map-wrapper stripped).
  have hp : p ≫ (PresheafOfModules.sheafificationAdjunction
        (𝟙 (Sheaf.val X.ringCatSheaf))).unit.app P'
      = (PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val X.ringCatSheaf))).unit.app P ≫
        (SheafOfModules.forget X.ringCatSheaf).map
          ((PresheafOfModules.sheafification (𝟙 (Sheaf.val X.ringCatSheaf))).map p) := by
    simpa only [Functor.id_map, Functor.comp_map, restrictScalarsId_map]
      using (PresheafOfModules.sheafificationAdjunction
        (𝟙 (Sheaf.val X.ringCatSheaf))).unit.naturality p
  have hq : q ≫ (PresheafOfModules.sheafificationAdjunction
        (𝟙 (Sheaf.val X.ringCatSheaf))).unit.app Q'
      = (PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val X.ringCatSheaf))).unit.app Q ≫
        (SheafOfModules.forget X.ringCatSheaf).map
          ((PresheafOfModules.sheafification (𝟙 (Sheaf.val X.ringCatSheaf))).map q) := by
    simpa only [Functor.id_map, Functor.comp_map, restrictScalarsId_map]
      using (PresheafOfModules.sheafificationAdjunction
        (𝟙 (Sheaf.val X.ringCatSheaf))).unit.naturality q
  -- Split the LHS `tensorHom`-composite (`tensorHom_comp_tensorHom`, applied as a defeq-matched TERM
  -- since `rw` cannot bridge the non-canonical monoidal instance baked into the goal), apply the two
  -- unit squares, then reassemble into the RHS `tensorHom`-composite.  `(C := …)` is supplied so the
  -- `MonoidalCategory` instance resolves (the underscore form leaves it a stuck metavariable).
  refine (MonoidalCategory.tensorHom_comp_tensorHom
    (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) _ _ _ _).trans ?_
  rw [hp, hq]
  exact (MonoidalCategory.tensorHom_comp_tensorHom
    (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) _ _ _ _).symm

-- The 4-square diagram chase pastes naturality across the sheafification-laden composites and is
-- driven by `erw` keyed-defeq merges (bridging the `Sheaf.val`/`.obj` and monoidal-instance
-- spellings); bump well past the default.
set_option maxHeartbeats 3200000 in
/-- **D1′ — naturality of the sheaf-level pullback–tensor comparison `pullbackTensorMap`**
(blueprint `lem:pullback_tensor_map_natural`). For `a : M ⟶ M'`, `b : N ⟶ N'` in `X.Modules`,
the comparison `δ_sheaf = pullbackTensorMap f` commutes with `f^*(a ⊗ b)` on the source and
`f^*a ⊗ f^*b` on the target. Project-local. -/
lemma pullbackTensorMap_natural {X Y : Scheme.{u}} (f : Y ⟶ X)
    {M M' N N' : X.Modules} (a : M ⟶ M') (b : N ⟶ N') :
    (Scheme.Modules.pullback f).map (tensorObj_functoriality a b) ≫ pullbackTensorMap f M' N'
      = pullbackTensorMap f M N ≫
        tensorObj_functoriality ((Scheme.Modules.pullback f).map a)
          ((Scheme.Modules.pullback f).map b) := by
  -- `pullbackTensorMap f M N` is the four-fold composite
  --   S1 ≫ S2 ≫ S3 ≫ S4 with
  --   S1 = (sheafificationCompPullback φ).app (M.val ⊗ N.val) .hom,
  --   S2 = a_Y.map (δ (pullback φ') M.val N.val),
  --   S3 = (sheafifyTensorUnitIso (F M.val) (F N.val)).hom,
  --   S4 = a_Y.map (tensorHom (pullbackValIso f M).hom.val (pullbackValIso f N).hom.val).
  -- Naturality is the paste of four squares:
  --   • S1 : naturality of `sheafificationCompPullback φ` at `tensorHom a.val b.val` (NatTrans);
  --   • S2 : `Functor.OplaxMonoidal.δ_natural` for `pullback φ'`, under `a_Y.map`;
  --   • S3 : `sheafifyTensorUnitIso_hom_natural` (helper above, CLOSED);
  --   • S4 : `pullbackValIso_hom_natural` (helper above, CLOSED) + bifunctoriality of `⊗`.
  -- The cleaner route (avoiding the sheaf-level carrier friction at S1) is to merge
  -- `a_Y.map δ ≫ S3 ≫ S4` into a single `a_Y.map Ψ` (Ψ presheaf-level), move S1 by its NatTrans
  -- naturality, and discharge the resulting PRESHEAF equation by `δ_natural` + the η-naturality of
  -- the two helpers — the same merge that `sheafifyTensorUnitIso_hom_natural` reduces to.
  simp only [pullbackTensorMap, tensorObj_functoriality]
  -- Square 1 (S1) — CLOSED: naturality of the `sheafificationCompPullback φ` natural iso at
  -- `a.val ⊗ₘ b.val`.  After this the goal is
  --   S1 ≫ a_Y.map (Fp.map (a.val ⊗ b.val)) ≫ a_Y.map δ' ≫ S3' ≫ S4'
  --     = (S1 ≫ a_Y.map δ ≫ S3 ≫ S4) ≫ Q0,   Fp = PresheafOfModules.pullback φ'.
  erw [(SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).hom.naturality_assoc]
  rw [Functor.comp_map]
  -- Square 2 (S2): `Functor.comp_map` left the first `a_Y` spelled `sheafification (𝟙 Y.ringCatSheaf.obj)`
  -- while the `δ`-factor reads `sheafification (𝟙 (Sheaf.val Y.ringCatSheaf))` (SAME functor,
  -- `Sheaf.val = .obj`).  Normalise `Sheaf.val → .obj` so the two `a_Y.map`s share a functor, merge
  -- them, and commute `δ` past `Fp.map (a.val ⊗ b.val)` by `δ_natural` (reverse), then split.
  dsimp only [CategoryTheory.Sheaf.val]
  -- Square 2 merge — SOLVED (iter-254): the `← Functor.map_comp` of the iter-253 BLOCKER fails because
  -- the two `a_Y.map`s are right-associated (`a.map A ≫ (a.map B ≫ rest)`), so `A`/`B` are not the
  -- direct operands of one `≫`.  The fix is the *reassoc* form `← Functor.map_comp_assoc` (`erw`, to
  -- bridge the non-canonical monoidal instance baked into the goal exactly as STEP A does): it merges
  -- `a.map (Fp.map (a.val ⊗ b.val)) ≫ a.map (δ_{M',N'}) ≫ rest`
  --   into `a.map (Fp.map (a.val ⊗ b.val) ≫ δ_{M',N'}) ≫ rest`, with `Fp = PresheafOfModules.pullback φ'`.
  erw [← Functor.map_comp_assoc]
  -- ── REMAINING (Square 2 — δ commutation): under the merged `a.map (…)` the argument is
  --   `Fp.map (a.val ⊗ b.val) ≫ δ_{M'.val,N'.val}`,  Fp = PresheafOfModules.pullback φ',
  -- which by oplax naturality `Functor.OplaxMonoidal.δ_natural` equals
  --   `δ_{M.val,N.val} ≫ (Fp.map a.val ⊗ Fp.map b.val)`.
  -- Square 2 (δ commutation) — CLOSED via the mapin255 LIGHT fix: re-present `F`'s ring-hom at the
  -- canonical `⋙ forget₂` spelling with a `show … from` ascription inside the `δ_natural` application,
  -- so the registered `MonoidalCategory` instance synthesizes.  `erw` (not `rw`): the ascription
  -- pretty-prints as `have this := …; this`, whose reducible-defeq match to the bare hom only `erw`
  -- bridges.  After this Square 2 is done; `dsimp only []` strips the cosmetic `have this := …; this`.
  erw [← Functor.OplaxMonoidal.δ_natural
    (F := PresheafOfModules.pullback
      (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
        from (Hom.toRingCatSheafHom f).hom))
    a.val b.val]
  dsimp only []
  -- Now: S1 ≫ a_Y.map (δ_{M,N} ≫ (Fp.map a.val ⊗ Fp.map b.val)) ≫ S3(M',N') ≫ S4(M',N')
  --    = (S1 ≫ a_Y.map δ_{M,N} ≫ S3(M,N) ≫ S4(M,N)) ≫ a_Y.map (a.val^* ⊗ b.val^*).
  -- Split `a_Y.map (δ ≫ φ)` and right-associate so S1 and `a_Y.map δ_{M,N}` are common prefixes.
  erw [Functor.map_comp]
  simp only [Category.assoc]
  -- Peel the common S1 (`.hom.app` vs `.app … .hom`, defeq) and `a_Y.map δ_{M,N}` via `rfl` legs.
  refine congr_arg₂ (· ≫ ·) rfl ?_
  refine congr_arg₂ (· ≫ ·) rfl ?_
  -- Residual (key): a_Y.map (Fp.map a.val ⊗ Fp.map b.val) ≫ S3(M',N') ≫ S4(M',N')
  --              = S3(M,N) ≫ S4(M,N) ≫ a_Y.map (a.val^* ⊗ b.val^*).
  -- Square 3: naturality of `sheafifyTensorUnitIso` (reassoc form, post-composed by S4(M',N')).
  erw [reassoc_of% (sheafifyTensorUnitIso_hom_natural
    ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).map a.val)
    ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).map b.val))]
  dsimp only [CategoryTheory.Sheaf.val]
  -- Now: S3(M,N) ≫ a_Y.map (forget(a_Y(Fp a.val)) ⊗ forget(a_Y(Fp b.val))) ≫ S4(M',N')
  --    = S3(M,N) ≫ a_Y.map (forget(pullbackValIso M).hom ⊗ forget(pullbackValIso N).hom) ≫ a_Y.map (a^* ⊗ b^*).
  -- `erw [Category.assoc]` bridges the `Sheaf.val`/`.obj` defeq gap in the connecting object
  -- (`pullbackValIso`'s type carries `Y.ringCatSheaf.val`, the helper carries `.obj`); plain `rw`
  -- cannot see the `(f ≫ g) ≫ h` pattern across this gap.
  erw [Category.assoc]
  -- Cancel the common `S3(M,N)` iso prefix, then merge each side's two `a_Y.map`s into a single
  -- `a_Y.map (_ ≫ _)` via `Functor.map_comp` (applied as defeq-matched TERMS so `refine`'s `isDefEq`
  -- bridges the same `.val`/`.obj` gap that blocks `rw`).
  erw [Iso.cancel_iso_hom_left]
  refine ((Functor.map_comp _ _ _).symm.trans ?_).trans (Functor.map_comp _ _ _)
  congr 1
  -- Square 4 (presheaf-level): bifunctoriality of `⊗` + naturality of `pullbackValIso` per leg.
  --   (forget(a_Y(Fp a.val)) ⊗ forget(a_Y(Fp b.val))) ≫ (forget(pullbackValIso M').hom ⊗ forget(pullbackValIso N').hom)
  -- = (forget(pullbackValIso M).hom ⊗ forget(pullbackValIso N).hom) ≫ (a^*.val ⊗ b^*.val).
  -- Per-leg naturality of `pullbackValIso` (= `pullbackValIso_hom_natural` under `forget`): merge the two
  -- `forget.map`s, apply the sheaf-level naturality, split back.  `((pullback f).map u).val` is `forget`
  -- of `(pullback f).map u`, so the closing `rfl` discharges the `forget`/`.val` boundary.
  have hleg : ∀ {P P' : X.Modules} (u : P ⟶ P'),
      (SheafOfModules.forget Y.ringCatSheaf).map
          ((PresheafOfModules.sheafification (𝟙 Y.ringCatSheaf.obj)).map
            ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).map u.val)) ≫
        (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f P').hom
        = (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f P).hom ≫
          ((Scheme.Modules.pullback f).map u).val := by
    intro P P' u
    rw [← Functor.map_comp]
    erw [pullbackValIso_hom_natural]
    rw [Functor.map_comp]
    rfl
  -- Split the LHS `tensorHom`-composite by bifunctoriality, rewrite each leg by `hleg`, reassemble into
  -- the RHS `tensorHom`-composite.  `(C := …)` pins the monoidal instance on the `⋙ forget₂` carrier;
  -- `erw` bridges the `Sheaf.val`/`.obj` connecting-object gap that blocks a plain `rw [hleg …]`.
  refine (MonoidalCategory.tensorHom_comp_tensorHom
    (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) _ _ _ _).trans ?_
  erw [hleg a, hleg b]
  exact (MonoidalCategory.tensorHom_comp_tensorHom
    (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) _ _ _ _).symm

/-- **Sq2 prerequisite — ring-map reconciliation.** For composable `h : Z ⟶ Y`, `f : Y ⟶ X`,
the structure ring-presheaf map of the composite factors through the whiskered ring maps of `f`
and `h`. This is the presheaf-level identity needed to feed `PresheafOfModules.pullbackComp` into
the oplax `comp_δ` decomposition (Sq2 of `pullbackTensorMap_restrict`). -/
private lemma toRingCatSheafHom_comp_hom_reconcile {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X) :
    (Hom.toRingCatSheafHom (h ≫ f)).hom =
      (Hom.toRingCatSheafHom f).hom ≫
        (TopologicalSpace.Opens.map f.base).op.whiskerLeft (Hom.toRingCatSheafHom h).hom := by
  rfl

set_option backward.isDefEq.respectTransparency false in
/-- **Sectionwise value of the presheaf `restrictScalars` lax tensorator.** The lax μ of
`PresheafOfModules.restrictScalars α`, evaluated at a section `W`, is by definition the `ModuleCat`
lax μ of `restrictScalars (α.app W).hom`. Exposed as a `rfl`-lemma so the heavy ambient term need not
be `whnf`-ed: rewriting with it turns `(μ (restrictScalars α) M₁ M₂).app W` into a `ModuleCat` μ on
which `ModuleCat.restrictScalars_μ_tmul` matches syntactically (a direct `erw` on the presheaf form
`whnf`-explodes). -/
private lemma restrictScalars_μ_app
    {C : Type u} [Category.{u} C] {R S : Cᵒᵖ ⥤ CommRingCat.{u}}
    (α : (R ⋙ forget₂ CommRingCat RingCat) ⟶ (S ⋙ forget₂ CommRingCat RingCat))
    (M₁ M₂ : _root_.PresheafOfModules (S ⋙ forget₂ CommRingCat RingCat)) (W : Cᵒᵖ) :
    (Functor.LaxMonoidal.μ (PresheafOfModules.restrictScalars α) M₁ M₂).app W
      = Functor.LaxMonoidal.μ (ModuleCat.restrictScalars (α.app W).hom)
          (M₁.obj W) (M₂.obj W) := rfl

set_option backward.isDefEq.respectTransparency false in
/-- **Pure-tensor value of the `ModuleCat` `restrictScalars` lax tensorator, in `ModuleCat.Hom.hom`
application form, with `forget₂`-carrier rings.** Bridges `ModuleCat.restrictScalars_μ_tmul` (stated
with the bundled coercion) to the `ModuleCat.Hom.hom`-applied form goals carry after
`ModuleCat.hom_comp`/`LinearMap.comp_apply`.  The source/target rings are `forget₂`-carriers of
presheaves of *commutative* rings (`Rc.obj W'`, `Sc.obj W'`), so the `CommRing` instances the goal's
`⊗ₜ` carries (coming from `CommRingCat`) are exactly the ones the statement uses — a generic
`Type`-level form fails to synthesise `CommRing` on a bare `RingCat` carrier.  Applied in context to
the goal's heavy objects as explicit arguments and discharged by `erw` (matching only the residual
defeq instance differences, no `whnf` of the heavy `pushforward₀` sections, which would explode). -/
private lemma forget₂_restrictScalars_μ_hom_tmul
    {C : Type u} [Category.{u} C] {Rc Sc : Cᵒᵖ ⥤ CommRingCat.{u}} {W' : Cᵒᵖ}
    (f : (Rc ⋙ forget₂ CommRingCat RingCat).obj W' ⟶ (Sc ⋙ forget₂ CommRingCat RingCat).obj W')
    (M₁ M₂ : ModuleCat.{u} ((Sc ⋙ forget₂ CommRingCat RingCat).obj W'))
    (m : M₁) (n : M₂) :
    ModuleCat.Hom.hom (Functor.LaxMonoidal.μ (ModuleCat.restrictScalars f.hom) M₁ M₂)
        (m ⊗ₜ[(Rc ⋙ forget₂ CommRingCat RingCat).obj W'] n) = m ⊗ₜ n :=
  ModuleCat.restrictScalars_μ_tmul f.hom M₁ M₂ m n

set_option backward.isDefEq.respectTransparency false in
/-- **Pure-tensor value of the presheaf `restrictScalars` lax tensorator (full collapse).**
On a pure tensor, `(μ (restrictScalars α) M₁ M₂).app W` is the identity.  Combines
`restrictScalars_μ_app` (rfl, exposes the `ModuleCat` μ) with `ModuleCat.restrictScalars_μ_tmul`.
Stated with `M₁ M₂` as *atoms*, so the proof never `whnf`s heavy ambient objects; in context it is
`rw`-applied with `R`, `S` pinned (the `forget₂`-association the goal carries), so keyed matching
succeeds without `whnf`. -/
private lemma restrictScalars_μ_app_tmul
    {C : Type u} [Category.{u} C] {R S : Cᵒᵖ ⥤ CommRingCat.{u}}
    (α : (R ⋙ forget₂ CommRingCat RingCat) ⟶ (S ⋙ forget₂ CommRingCat RingCat))
    (M₁ M₂ : _root_.PresheafOfModules (S ⋙ forget₂ CommRingCat RingCat)) (W : Cᵒᵖ)
    (m : (M₁.obj W)) (n : (M₂.obj W)) :
    ModuleCat.Hom.hom ((Functor.LaxMonoidal.μ (PresheafOfModules.restrictScalars α) M₁ M₂).app W)
        (m ⊗ₜ[(R ⋙ forget₂ CommRingCat RingCat).obj W] n) = m ⊗ₜ n := by
  rw [restrictScalars_μ_app]
  exact ModuleCat.restrictScalars_μ_tmul (α.app W).hom (M₁.obj W) (M₂.obj W) m n

set_option backward.isDefEq.respectTransparency false in
/-- **Pure-tensor value of the `pushforward`-mapped `restrictScalars` lax tensorator.**  The "outer
leg" of `pushforwardComp_lax_μ`: `((pushforward φ).map (μ (restrictScalars ψ) N₁ N₂)).app W` applied
to a pure tensor is the identity.  Reindexes through `pushforward_map_app_apply` (`pushforward φ` is
`pushforward₀ ⋙ restrictScalars φ`, so the section map at `W` is the `μ` at `F.op.obj W`), then
collapses by `restrictScalars_μ_app_tmul`.  `N₁ N₂` are *atoms*; in context the lemma is applied to
the goal's heavy objects as explicit arguments and discharged by `erw` (which matches the residual
defeq instance differences without `whnf`-ing the heavy objects). -/
private lemma pushforward_map_restrictScalars_μ_app_tmul
    {C D E : Type u} [Category.{u} C] [Category.{u} D] [Category.{u} E]
    {F : C ⥤ D} {G : D ⥤ E}
    {S₀ : Cᵒᵖ ⥤ CommRingCat.{u}} {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}} {T₀ : Eᵒᵖ ⥤ CommRingCat.{u}}
    (φ : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      F.op ⋙ (R₀ ⋙ forget₂ CommRingCat RingCat))
    (ψ : (R₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      G.op ⋙ (T₀ ⋙ forget₂ CommRingCat RingCat))
    (N₁ N₂ : _root_.PresheafOfModules ((G.op ⋙ T₀) ⋙ forget₂ CommRingCat RingCat)) (W : Cᵒᵖ)
    (m : (N₁.obj (F.op.obj W))) (n : (N₂.obj (F.op.obj W))) :
    ModuleCat.Hom.hom
        (((PresheafOfModules.pushforward φ).map
          (Functor.LaxMonoidal.μ (PresheafOfModules.restrictScalars
            (show (R₀ ⋙ forget₂ CommRingCat RingCat) ⟶
              ((G.op ⋙ T₀) ⋙ forget₂ CommRingCat RingCat) from ψ)) N₁ N₂)).app W)
        (m ⊗ₜ[(R₀ ⋙ forget₂ CommRingCat RingCat).obj (F.op.obj W)] n) = m ⊗ₜ n := by
  erw [PresheafOfModules.pushforward_map_app_apply]
  exact restrictScalars_μ_app_tmul _ N₁ N₂ (F.op.obj W) m n

/-- **Reduction of the `pushforward` lax tensorator to the `restrictScalars` μ (morphism level).**
The lax μ of a single `PresheafOfModules.pushforward φ` equals the lax μ of the change-of-rings
`restrictScalars φ'` on the (strongly-monoidal, `μIso = refl`) reindexed objects
`pushforward₀OfCommRingCat F R₀`. This unfolds the opaque `presheafPushforwardLaxMonoidal` μ (the
`Functor.LaxMonoidal.comp` of `pushforward₀`'s μ = identity and `restrictScalars`'s μ) to the
directly-computable `restrictScalars` μ — staying at the `PresheafOfModules` morphism level so the
`(presheaf-tensor).obj W` vs `ModuleCat`-tensor mismatch never surfaces. Mirrors the ε-twin
`epsilonPresheafToSheafUnit`. -/
private lemma pushforward_μ_eq
    {C D : Type u} [Category.{u} C] [Category.{u} D] {F : C ⥤ D}
    {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}} {S₀ : Cᵒᵖ ⥤ CommRingCat.{u}}
    (φ : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      F.op ⋙ (R₀ ⋙ forget₂ CommRingCat RingCat))
    (A B : _root_.PresheafOfModules (R₀ ⋙ forget₂ CommRingCat RingCat)) :
    letI φ' : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶
        (F.op ⋙ R₀) ⋙ forget₂ CommRingCat RingCat := φ
    Functor.LaxMonoidal.μ (PresheafOfModules.pushforward φ) A B
      = Functor.LaxMonoidal.μ (PresheafOfModules.restrictScalars φ')
          ((PresheafOfModules.pushforward₀OfCommRingCat F R₀).obj A)
          ((PresheafOfModules.pushforward₀OfCommRingCat F R₀).obj B) := by
  rfl

/-- **Sq2b residual — the lax-μ composition coherence of `PresheafOfModules.pushforward`
(monoidality of `pushforwardComp`).** Since `PresheafOfModules.pushforwardComp φ ψ = Iso.refl`,
the right-adjoint side of Sq2b reduces to the statement that the lax tensorator `μ` of the
*composite* pushforward `pushforward ψ ⋙ pushforward φ` (built by `Functor.LaxMonoidal.comp`)
agrees with the lax tensorator of the *single* pushforward `pushforward (φ ≫ F.op ◁ ψ)` (built by
`presheafPushforwardLaxMonoidal`).

**Status (iter-261): CLOSED, axiom-clean.** The equality is genuinely *not* `rfl`/`simp` at the
presheaf level (the `restrictScalars` μ on a pure tensor is real `ModuleCat` base-change content,
`ModuleCat.restrictScalars_μ_tmul`, not definitional).  The working route is sectionwise +
pure-tensor reduction: `Functor.LaxMonoidal.comp_μ` unfolds the composite μ, `pushforward_μ_eq`
lightens each `μ (pushforward _)` to a `restrictScalars` μ, and each leg is then collapsed to the
identity by the atomic-object helpers `forget₂_restrictScalars_μ_hom_tmul` (inner) and
`pushforward_map_restrictScalars_μ_app_tmul` (the `(pushforward φ).map …` leg, reindexed by
`pushforward_map_app_apply`).  Both helpers are applied to the goal's concrete objects as explicit
arguments and matched by `erw` — this is the only way to avoid the `whnf`-explosion that a direct
`rw`/`erw`/`simp` of `ModuleCat.restrictScalars_μ_tmul` triggers on the heavy `pushforward₀`
sections.  After both legs collapse, the LHS pure tensor is defeq to the RHS single-pushforward μ on
the same tensor, closing the goal. -/
private lemma pushforwardComp_lax_μ
    {C D E : Type u} [Category.{u} C] [Category.{u} D] [Category.{u} E]
    {F : C ⥤ D} {G : D ⥤ E}
    {S₀ : Cᵒᵖ ⥤ CommRingCat.{u}} {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}} {T₀ : Eᵒᵖ ⥤ CommRingCat.{u}}
    (φ : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      F.op ⋙ (R₀ ⋙ forget₂ CommRingCat RingCat))
    (ψ : (R₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      G.op ⋙ (T₀ ⋙ forget₂ CommRingCat RingCat))
    [(PresheafOfModules.pushforward φ).IsRightAdjoint]
    [(PresheafOfModules.pushforward ψ).IsRightAdjoint]
    (X Y : _root_.PresheafOfModules (T₀ ⋙ forget₂ CommRingCat RingCat)) :
    Functor.LaxMonoidal.μ
        (PresheafOfModules.pushforward ψ ⋙ PresheafOfModules.pushforward φ) X Y =
      Functor.LaxMonoidal.μ
        (PresheafOfModules.pushforward (F := F ⋙ G)
          (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ)) X Y := by
  -- PROOF (iter-261): the equality is checked sectionwise (`hom_ext`) and on pure tensors
  -- (`tensor_ext`).  `Functor.LaxMonoidal.comp_μ` unfolds the composite μ to
  --   `μ (pushforward φ) (..) (..)  ≫  (pushforward φ).map (μ (pushforward ψ) X Y)`,
  -- and `pushforward_μ_eq` (×2) reduces each `μ (pushforward _)` to the lighter
  -- `μ (restrictScalars _)` on the strong-monoidal `pushforward₀` objects.  On a pure tensor every
  -- `restrictScalars` μ is the identity (`ModuleCat.restrictScalars_μ_tmul`): the inner leg is
  -- collapsed by `forget₂_restrictScalars_μ_hom_tmul` (`hinner`) and the `(pushforward φ).map …`
  -- leg by `pushforward_map_restrictScalars_μ_app_tmul` (`houter`, which reindexes the section map to
  -- `F.op.obj W` via `pushforward_map_app_apply` and collapses there).  After both legs the LHS is
  -- `m ⊗ₜ n`, which is defeq to the RHS single-pushforward μ on the same pure tensor — so the final
  -- `erw [houter]` closes the goal by its trailing `rfl`.  The heavy `pushforward₀` sections never
  -- get `whnf`-ed: all collapse lemmas are stated with atomic objects and applied to the goal's
  -- concrete objects as explicit arguments, then matched by `erw` up to the residual defeq
  -- `forget₂`-association / instance differences only.
  refine PresheafOfModules.hom_ext (fun W => ?_)
  refine ModuleCat.MonoidalCategory.tensor_ext (fun m n => ?_)
  rw [Functor.LaxMonoidal.comp_μ]
  rw [pushforward_μ_eq, pushforward_μ_eq]
  rw [PresheafOfModules.comp_app]
  erw [ModuleCat.hom_comp, LinearMap.comp_apply]
  rw [restrictScalars_μ_app (R := S₀) (S := F.op ⋙ R₀)]
  have hinner := forget₂_restrictScalars_μ_hom_tmul (Rc := S₀) (Sc := F.op ⋙ R₀) (φ.app W)
    (((PresheafOfModules.pushforward₀OfCommRingCat F R₀).obj ((PresheafOfModules.pushforward ψ).obj X)).obj W)
    (((PresheafOfModules.pushforward₀OfCommRingCat F R₀).obj ((PresheafOfModules.pushforward ψ).obj Y)).obj W)
    m n
  erw [hinner]
  have houter := pushforward_map_restrictScalars_μ_app_tmul φ ψ
    ((PresheafOfModules.pushforward₀OfCommRingCat G T₀).obj X)
    ((PresheafOfModules.pushforward₀OfCommRingCat G T₀).obj Y) W m n
  erw [houter]

/-- **Sq2b — monoidality of `PresheafOfModules.pullbackComp` (the δ-transport across the
left-adjoint composition iso).** The presheaf-level core of D3′: the canonical oplax comparison
`δ` of the pullback for a composite ring map `φ ≫ F.op ◁ ψ` transports, through the pullback
pseudofunctor coherence `pullbackComp φ ψ`, into the `Functor.OplaxMonoidal.comp` comparison of
the composite `pullback φ ⋙ pullback ψ`.

This is the η→δ analogue of `pullbackObjUnitToUnit_comp`, proved at the `PresheafOfModules` level
(dissolving the `forget₂`-instance / associativity / reconcile frictions of working at the
`Scheme`/`forget₂` level). The proof is the adjunction-mate calculus: transpose under
`pullbackPushforwardAdjunction (φ ≫ F.op ◁ ψ)`, rewrite the oplax δ as the mate of the lax μ
(`Adjunction.unit_app_tensor_comp_map_δ`), and use the conjugate identity
`conjugateEquiv_leftAdjointCompIso_inv` (here `pushforwardComp = Iso.refl`, so the mate of
`pullbackComp.inv` is the identity). The sole residual is the lax-μ composition coherence of
`PresheafOfModules.pushforward` across `pushforwardComp` (`pushforwardComp_lax_μ`). -/
private lemma pullbackComp_δ
    {C D E : Type u} [Category.{u} C] [Category.{u} D] [Category.{u} E]
    {F : C ⥤ D} {G : D ⥤ E}
    {S₀ : Cᵒᵖ ⥤ CommRingCat.{u}} {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}} {T₀ : Eᵒᵖ ⥤ CommRingCat.{u}}
    (φ : (S₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      F.op ⋙ (R₀ ⋙ forget₂ CommRingCat RingCat))
    (ψ : (R₀ ⋙ forget₂ CommRingCat RingCat) ⟶
      G.op ⋙ (T₀ ⋙ forget₂ CommRingCat RingCat))
    [(PresheafOfModules.pushforward φ).IsRightAdjoint]
    [(PresheafOfModules.pushforward ψ).IsRightAdjoint]
    (M N : _root_.PresheafOfModules (S₀ ⋙ forget₂ CommRingCat RingCat)) :
    Functor.OplaxMonoidal.δ
        (PresheafOfModules.pullback (F := F ⋙ G)
          (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ)) M N =
      (PresheafOfModules.pullbackComp φ ψ).inv.app (M ⊗ N) ≫
        Functor.OplaxMonoidal.δ
          (PresheafOfModules.pullback φ ⋙ PresheafOfModules.pullback ψ) M N ≫
        ((PresheafOfModules.pullbackComp φ ψ).hom.app M ⊗ₘ
          (PresheafOfModules.pullbackComp φ ψ).hom.app N) := by
  -- MATE CALCULUS (iter-259 derivation; reduces Sq2b to `pushforwardComp_lax_μ`).
  -- Transpose both sides under `aχ.homEquiv` (`aχ := pullbackPushforwardAdjunction (φ ≫ F.op ◁ ψ)`):
  apply (PresheafOfModules.pullbackPushforwardAdjunction
    (F := F ⋙ G) (R := T₀ ⋙ forget₂ CommRingCat RingCat)
    (φ ≫ F.op.whiskerLeft ψ)).homEquiv _ _ |>.injective
  -- Both sides become `aχ.unit (M⊗N) ≫ (pushforward χ).map (…)`:
  rw [Adjunction.homEquiv_unit, Adjunction.homEquiv_unit]
  -- The remaining reduction (verified on paper; the wiring `rw`s are mechanical but fragile, and
  -- the *only* genuine gap is `pushforwardComp_lax_μ`, which is `rfl`-FALSE — see below):
  --
  --   LHS = aχ.unit(M⊗N) ≫ (pushforward χ).map (δ (pullback χ) M N)
  --       = (aχ.unit M ⊗ₘ aχ.unit N) ≫ μ(pushforward χ) (pullback χ M) (pullback χ N)
  --                                          [Adjunction.unit_app_tensor_comp_map_δ (adj := aχ)]
  --
  --   RHS = aχ.unit(M⊗N) ≫ (pushforward χ).map (c.inv(M⊗N) ≫ comp_δ ≫ (c.hom M ⊗ₘ c.hom N))
  --       where c := pullbackComp φ ψ.  Expand `map_comp`, then:
  --   (MATE)   aχ.unit(M⊗N) ≫ (pushforward χ).map (c.inv(M⊗N)) = aC.unit(M⊗N)
  --                              [Adjunction.unit_conjugateEquiv + conjugateEquiv_leftAdjointCompIso_inv;
  --                               here pushforwardComp = Iso.refl ⇒ the conjugate of c.inv is 𝟙, so the
  --                               `pc.hom` factor vanishes]   (aC := aφ.comp aψ)
  --   (U-C)    aC.unit(M⊗N) ≫ (pushforward ψ ⋙ pushforward φ).map (comp_δ) =
  --              (aC.unit M ⊗ₘ aC.unit N) ≫ μ(pushforward ψ ⋙ pushforward φ) (LM) (LN)
  --                              [Adjunction.unit_app_tensor_comp_map_δ (adj := aC); aC.IsMonoidal via
  --                               Adjunction.isMonoidal_comp; (pushforward χ).map ≡ (G'⋙G).map defeq]
  --   (μ-NAT)  μ(pushforward χ) (LM)(LN) ≫ (pushforward χ).map (c.hom M ⊗ₘ c.hom N) =
  --              ((pushforward χ).map (c.hom M) ⊗ₘ (pushforward χ).map (c.hom N)) ≫
  --                μ(pushforward χ) (pullback χ M) (pullback χ N)   [Functor.LaxMonoidal.μ_natural]
  --   (TRI)    aC.unit P ≫ (pushforward χ).map (c.hom P) = aχ.unit P   [(MATE) + c.inv ≫ c.hom = 𝟙]
  --   tensorHom_comp_tensorHom merges the three ⊗ₘ legs; with (TRI) the RHS becomes
  --              (aχ.unit M ⊗ₘ aχ.unit N) ≫ μ(pushforward ψ ⋙ pushforward φ) (pullback χ M)(pullback χ N).
  --
  -- LHS = RHS then holds IFF
  --   μ(pushforward ψ ⋙ pushforward φ) X Y = μ(pushforward χ) X Y   (= `pushforwardComp_lax_μ`).
  -- This is the SOLE residual.  It is NOT `rfl` (the `d3sq2b258` recipe's "rfl/short ext" prediction
  -- is empirically false): it is a genuine `ModuleCat` change-of-rings base-change coherence
  -- (`ModuleCat.restrictScalarsComp` / `homEquiv_extendScalarsComp`), with NO analog in the
  -- `rfl`-closed unit twin `unitToPushforwardObjUnit_comp`.  Pinned as `pushforwardComp_lax_μ` above.
  -- The mate-`rw` wiring of the steps above is left for the follow-up (each step's Mathlib lemma is
  -- named); the reduction itself is complete.  The LHS step (U) is wired here:
  erw [Adjunction.unit_app_tensor_comp_map_δ
    (adj := PresheafOfModules.pullbackPushforwardAdjunction
      (F := F ⋙ G) (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ))]
  -- (MATE): the conjugate/mate of `pullbackComp.inv` is `pushforwardComp.hom = 𝟙`.
  -- (MATE) — the conjugate of `pullbackComp.inv` is `pushforwardComp.hom = 𝟙`:
  have hconj : conjugateEquiv
        ((PresheafOfModules.pullbackPushforwardAdjunction φ).comp
          (PresheafOfModules.pullbackPushforwardAdjunction ψ))
        (PresheafOfModules.pullbackPushforwardAdjunction
          (F := F ⋙ G) (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ))
        (PresheafOfModules.pullbackComp φ ψ).inv = 𝟙 _ := by
    simp only [PresheafOfModules.pullbackComp, Adjunction.conjugateEquiv_leftAdjointCompIso_inv,
      PresheafOfModules.pushforwardComp, Iso.refl_hom]
  have hmate : ∀ (P : _root_.PresheafOfModules (S₀ ⋙ forget₂ CommRingCat RingCat)),
      (PresheafOfModules.pullbackPushforwardAdjunction
          (F := F ⋙ G) (R := T₀ ⋙ forget₂ CommRingCat RingCat)
          (φ ≫ F.op.whiskerLeft ψ)).unit.app P ≫
        (PresheafOfModules.pushforward (F := F ⋙ G)
          (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ)).map
          ((PresheafOfModules.pullbackComp φ ψ).inv.app P) =
      ((PresheafOfModules.pullbackPushforwardAdjunction φ).comp
        (PresheafOfModules.pullbackPushforwardAdjunction ψ)).unit.app P := by
    intro P
    have hu := unit_conjugateEquiv
      ((PresheafOfModules.pullbackPushforwardAdjunction φ).comp
        (PresheafOfModules.pullbackPushforwardAdjunction ψ))
      (PresheafOfModules.pullbackPushforwardAdjunction
        (F := F ⋙ G) (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ))
      (PresheafOfModules.pullbackComp φ ψ).inv P
    rw [hconj] at hu
    simp only [NatTrans.id_app, Category.comp_id] at hu
    exact hu.symm
  -- Expand the RHS `map` of the composite and apply (MATE):
  rw [Functor.map_comp, Functor.map_comp]
  erw [reassoc_of% (hmate (M ⊗ N))]
  -- (U-C): rewrite `aC.unit(M⊗N) ≫ map(comp_δ)` via the mate of the composite adjunction `aC`:
  erw [reassoc_of% (Adjunction.unit_app_tensor_comp_map_δ
    (adj := (PresheafOfModules.pullbackPushforwardAdjunction φ).comp
      (PresheafOfModules.pullbackPushforwardAdjunction ψ)) M N)]
  -- (μ-COH): replace the composite-pushforward μ by the χ-pushforward μ (the genuine residual):
  rw [pushforwardComp_lax_μ φ ψ]
  -- (TRI): for any `P`, `aC.unit P ≫ (pushforward χ).map (c.hom P) = aχ.unit P`.
  have htri : ∀ (P : _root_.PresheafOfModules (S₀ ⋙ forget₂ CommRingCat RingCat)),
      ((PresheafOfModules.pullbackPushforwardAdjunction φ).comp
          (PresheafOfModules.pullbackPushforwardAdjunction ψ)).unit.app P ≫
        (PresheafOfModules.pushforward (F := F ⋙ G)
          (R := T₀ ⋙ forget₂ CommRingCat RingCat) (φ ≫ F.op.whiskerLeft ψ)).map
          ((PresheafOfModules.pullbackComp φ ψ).hom.app P) =
      (PresheafOfModules.pullbackPushforwardAdjunction
        (F := F ⋙ G) (R := T₀ ⋙ forget₂ CommRingCat RingCat)
        (φ ≫ F.op.whiskerLeft ψ)).unit.app P := by
    intro P
    erw [← reassoc_of% (hmate P)]
    erw [← Functor.map_comp]
    erw [(PresheafOfModules.pullbackComp φ ψ).inv_hom_id_app P, CategoryTheory.Functor.map_id,
      Category.comp_id]
  -- (μ-NAT): slide μ past `map (c.hom ⊗ c.hom)`, merge the legs, then apply (TRI):
  erw [← Functor.LaxMonoidal.μ_natural]
  conv_lhs => rw [← htri M, ← htri N]
  erw [← MonoidalCategory.tensorHom_comp_tensorHom
    (C := _root_.PresheafOfModules (S₀ ⋙ forget₂ CommRingCat RingCat))]
  exact Category.assoc _ _ _

/-- **Sheaf-level conjugate/mate of `pullbackComp.inv` (the R0-peel building block for Sq1).**
For composable scheme morphisms `h : Z ⟶ Y`, `f : Y ⟶ X` and any `Q : X.Modules`, the unit of the
composite-pullback adjunction `pullbackPushforwardAdjunction (h ≫ f)`, post-composed with the
pushforward of `pullbackComp.inv`, equals the unit of the *composite* of the `f`- and `h`-adjunctions,
post-composed with `pushforwardComp.hom`.  This is the `Scheme.Modules` (sheaf-level) instance of
`unit_conjugateEquiv` combined with `conjugateEquiv_pullbackComp_inv` (the mate of `pullbackComp.inv`
is `pushforwardComp.hom`); it is the cheap, sheafification-free piece of the Sq1 mate calculus that
peels the leading `R0 = pullbackComp.inv` factor.  Extracted from the inline `conj` of
`pullbackObjUnitToUnit_comp` so the (expensive, sheafification-laden) Sq1 reassembly can cite it
directly.  Project-local. -/
private lemma sheaf_unit_comp_pushforward_pullbackComp_inv {X Y Z : Scheme.{u}}
    (h : Z ⟶ Y) (f : Y ⟶ X) (Q : X.Modules) :
    (SheafOfModules.pullbackPushforwardAdjunction (Scheme.Hom.toRingCatSheafHom (h ≫ f))).unit.app Q ≫
        (SheafOfModules.pushforward (Scheme.Hom.toRingCatSheafHom (h ≫ f))).map
          ((Scheme.Modules.pullbackComp h f).inv.app Q) =
      ((Scheme.Modules.pullbackPushforwardAdjunction f).comp
          (Scheme.Modules.pullbackPushforwardAdjunction h)).unit.app Q ≫
        (Scheme.Modules.pushforwardComp h f).hom.app
          ((Scheme.Modules.pullback f ⋙ Scheme.Modules.pullback h).obj Q) := by
  have conj := unit_conjugateEquiv
    ((Scheme.Modules.pullbackPushforwardAdjunction f).comp
      (Scheme.Modules.pullbackPushforwardAdjunction h))
    (Scheme.Modules.pullbackPushforwardAdjunction (h ≫ f))
    (Scheme.Modules.pullbackComp h f).inv Q
  rw [Scheme.Modules.conjugateEquiv_pullbackComp_inv] at conj
  exact conj.symm

/-- **STEP-1 bridge (presheaf↔sheaf pushforward compatibility, the binding obligation of the D3′
Sq1 tail).** The forgetful functor `SheafOfModules.forget` intertwines the sheaf-level
`SheafOfModules.pushforward φ` with the presheaf-level `PresheafOfModules.pushforward φ.hom`:
for any morphism `g` of sheaves of modules over `R`,
`forget.map ((pushforward φ).map g) = (PresheafOfModules.pushforward φ.hom).map (forget.map g)`.

This is the compatibility named in the blueprint's `lem:pullback_tensor_map_basechange` Sq1-tail
binding-obligation paragraph: it is what lets the recovered sheaf-level `B_f`/`B_h` unit factors
(which live under `SheafOfModules.pushforward`) be slid across into the presheaf-level
`PresheafOfModules.pushforward` of the unit identity.  It is *definitional* — `SheafOfModules.pushforward`
is built sectionwise from `PresheafOfModules.pushforward` (`pushforward_map_val`) and `forget` is the
`.val` projection (`forget_map`), so the two sides are equal by `rfl`. -/
private lemma forget_map_pushforward_map
    {C : Type u} [Category.{u} C] {D : Type u} [Category.{u} D]
    {J : GrothendieckTopology C} {K : GrothendieckTopology D} {F : C ⥤ D}
    {S : Sheaf J RingCat.{u}} {R : Sheaf K RingCat.{u}} [Functor.IsContinuous F J K]
    (φ : S ⟶ (F.sheafPushforwardContinuous RingCat.{u} J K).obj R)
    {A B : SheafOfModules.{u} R} (g : A ⟶ B) :
    (SheafOfModules.forget S).map ((SheafOfModules.pushforward φ).map g) =
      (PresheafOfModules.pushforward φ.hom).map ((SheafOfModules.forget R).map g) := by
  rfl

/-- **The R1/R5/δ collapse tail of `sheafificationCompPullback_comp` (extracted, pc263).**
This is the reduced goal of `sheafificationCompPullback_comp` AFTER the R0-peel
(`sheaf_unit_comp_pushforward_pullbackComp_inv`) and the two `← Functor.map_comp` merges that fold
the `(forget ⋙ restrictScalars)`-image of the R0-peeled-and-`pushforwardComp`-glued unit factor
together with the `(forget ⋙ restrictScalars)`-image of the `R1 ≫ R5 ≫ δ_pre` factor into a single
`(forget ⋙ restrictScalars).map (· ≫ ·)`.  The LHS is `B_{h≫f}.unit.app P` (expanded by
`comp_unit_app` over `B_{h≫f} = (PrPbPushAdj φ'_{h≫f}).comp (sheafAdj_Z)`); the RHS is
`sheafAdj_X.homEquiv` (the `η^{sX} ≫ (forget⋙restr).map _` form) of the merged unit composite.

The collapse is the `sheafificationCompPullback` twin of the tail of `pullbackObjUnitToUnit_comp`
(L969–1001): recover the two `sheafCompPb` factors `R1 = (pullback h).map (sheafCompPb f .app P).hom`
and `R5 = (sheafCompPb h .app (PrPb_f P)).hom` as `B_f`/`B_h` units via
`homEquiv_leftAdjointUniq_hom_app` on their `sheafificationCompPullback_eq_leftAdjointUniq` form,
slide `(pushforwardComp h f).hom` past them by `(pushforwardComp h f).hom.naturality`, and collapse
`comp_unit_app` + `Adjunction.unit_naturality` to `B_{h≫f}.unit`.  Project-local. -/
private lemma sheafificationCompPullback_comp_tail {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    (P : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) :
    (PresheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom (h ≫ f)).hom).unit.app P ≫
        (PresheafOfModules.pushforward (Hom.toRingCatSheafHom (h ≫ f)).hom).map
          ((PresheafOfModules.sheafificationAdjunction (𝟙 Z.ringCatSheaf.val)).unit.app
            ((PresheafOfModules.pullback (Hom.toRingCatSheafHom (h ≫ f)).hom).obj P)) =
      (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.val)).unit.app P ≫
        (PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.val)).map
          ((SheafOfModules.forget X.ringCatSheaf).map
            ((((pullbackPushforwardAdjunction f).comp (pullbackPushforwardAdjunction h)).unit.app
                  ((PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)).obj P) ≫
                (pushforwardComp h f).hom.app
                  ((pullback h).obj
                    ((pullback f).obj
                      ((PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)).obj P)))) ≫
              (SheafOfModules.pushforward (Hom.toRingCatSheafHom (h ≫ f))).map
                ((pullback h).map
                    ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app P).hom ≫
                  ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
                        ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj P)).hom ≫
                    (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.val)).map
                      ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
                          (Hom.toRingCatSheafHom h).hom).hom.app P)))) := by
  -- The LHS is ALREADY the content-bearing concrete form `B_{h≫f}.unit.app P`
  --   (B_{h≫f} := (PrPbPushAdj φ'_{h≫f}).comp sheafAdj_Z), expanded by `comp_unit_app` as
  --   `PrPbPushAdj φ'_{h≫f} .unit P ≫ pushforward φ'_{h≫f} .map (sheafAdj_Z.unit (Pf_{h≫f} P))`,
  -- produced by `homEquiv_leftAdjointUniq_hom_app` in the caller — this is the analog of the model
  -- `pullbackObjUnitToUnit_comp`'s `hL` step (`homEquiv (pbu (h≫f)) = uToPf (h≫f)`).  **The correct
  -- direction is to keep the LHS concrete and ASSEMBLE the RHS into it** — do NOT re-transpose the LHS
  -- (`← homEquiv_leftAdjointUniq` re-opaquifies it to `A.homEquiv (sheafCompPb (h≫f) .hom.app P)`, which
  -- is circular: that goal is `homEquiv.injective`-equivalent to the original un-transposed statement,
  -- verified by re-folding the R0-peel `sheaf_unit_comp_pushforward_pullbackComp_inv`).
  --
  -- GENUINE MISSING INGREDIENT (the iter-264 fine-grain target): the **composite-adjunction-unit
  -- composition coherence** `B_{h≫f}.unit = (decompose through B_f, B_h + the pseudofunctor coherences
  -- pullbackComp / pushforwardComp / sheafificationCompPullback)`.  This is the `sheafification`-laden
  -- analog of `unitToPushforwardObjUnit_comp` (which, for the bare `pushforward` adjunctions, is `rfl`
  -- sectionwise); here B_f, B_h are COMPOSITE adjunctions `(PrPbPushAdj φ').comp sheafAdj`, so the
  -- coherence is the mate calculus, NOT `rfl`.  Route: distribute the RHS `merged` argument and recover
  -- the two `sheafCompPb f/h .app _ .hom` factors as `B_f`/`B_h` units via
  -- `homEquiv_leftAdjointUniq_hom_app` (`A_f.homEquiv (sheafCompPb f .hom.app P) = B_f.unit P`), then
  -- reassemble into `B_{h≫f}.unit` by the unit naturality of `pushforwardComp` / `pullbackComp` — the
  -- `homEquiv_leftAdjointUniq` twin of the `hinner`/`hcomp'` chain of `pullbackObjUnitToUnit_comp`
  -- (L952–1001).  ~50–80 LOC across the two sheafification layers (X↔Y for `f`, Y↔Z for `h`).
  --
  -- ITER-264 (prover, fine-grained) — landed structural steps + the genuine R1/R5-recovery brick:
  --   * `restrictScalarsId_map` strips the outer `restrictScalars (𝟙_X).map` wrapper (defeq-identity).
  --   * `conv_rhs => rw [Functor.map_comp]` splits the merged sheaf composite under `forget.map` into
  --     `forget.map (B'_unit ≫ pushforwardComp.hom) ≫ forget.map (pushforward^sheaf.map (R1 ≫ R5 ≫ a_Z.δ))`,
  --     exposing the two `sheafCompPb f/h .app _ .hom` factors (R1/R5) for recovery.  CONFINED to the RHS
  --     (a bare `erw/rw [Functor.map_comp]` on the whole goal instead contaminates the LHS `sheafAdj_Z.unit`,
  --     unfolding it to `toSheafify ≫ restrictHomEquiv` — verified iter-264).
  --   * NEW brick `leftAdjointUniqUnitEta_app` (proved above, axiom-clean): the `P`-general form of the
  --     existing `leftAdjointUniqUnitEta`, recovering `sheafCompPb f .hom.app P` as the composite-adjunction
  --     unit `B_f.unit.app P` via `homEquiv_leftAdjointUniq_hom_app` (ma-d3264 step 1).
  -- DO-NOT (verified circular this iter): `← sheaf_unit_comp_pushforward_pullbackComp_inv` (the R0-peel) on
  --   the RHS folds `B'_unit ≫ pushforwardComp.hom ≫ pushforward.map(R1≫R5≫δ)` back into
  --   `PrPbPush_{h≫f}.unit ≫ pushforward.map(pullbackComp.inv ≫ R1 ≫ R5 ≫ δ)`, whose inner factor is
  --   `(sheafCompPb (h≫f)).hom.app P` ONLY by `sheafificationCompPullback_comp` itself (the caller) — circular.
  -- REMAINING (the genuine residual handed to the next iter): recover R1/R5 via `leftAdjointUniqUnitEta_app`
  --   as `B_f`/`B_h` units, slide `(pushforwardComp h f).hom` past them by `.hom.naturality`, and collapse
  --   `comp_unit_app` + `Adjunction.unit_naturality` to `B_{h≫f}.unit` — the `hinner`/`hcomp'` twin.
  rw [restrictScalarsId_map]
  conv_rhs => rw [Functor.map_comp]
  -- STEP (d) — consume the STEP-1 bridge `forget_map_pushforward_map`: the second RHS factor
  -- `forget.map ((SheafOfModules.pushforward φ_{h≫f}).map (R1 ≫ R5 ≫ a_Z.map δ))` is rewritten to the
  -- presheaf-level `(PresheafOfModules.pushforward φ'_{h≫f}).map (forget.map (R1 ≫ R5 ≫ a_Z.map δ))`,
  -- crossing the sheaf↔presheaf boundary so the recovered sheaf-level B_f/B_h units can be slid in.
  -- `erw` (not `rw`) — the `SheafOfModules.pushforward`/`forget` composite is defeq-but-not-syntactic.
  erw [forget_map_pushforward_map]
  -- STEP (e.0) — split the RHS first `forget.map (B'_unit ≫ pushforwardComp.hom)` factor into
  -- `forget.map B'_unit ≫ forget.map pushforwardComp.hom` by a *plain* `rw [Functor.map_comp]`.
  -- CRITICAL: plain `rw` is required, NOT `erw` — the head `forget.map (_ ≫ _)` is a syntactic
  -- composite so `rw` fires there only, leaving the LHS untouched.  An `erw` here instead matches
  -- the LHS `pushforward.map (sheafAdj_Z.unit.app _)` by defeq and UNFOLDS the unit to its
  -- `toSheafify ≫ restrictHomEquivOfIsLocallySurjective` expansion (verified iter-265 contamination),
  -- which is the exact failure the iter-262 R0-peel comment warned about one square up.
  rw [Functor.map_comp]
  -- STEP (i) — distribute the inner `forget.map (R1 ≫ R5 ≫ a_Z.map δ_pre)` into
  -- `forget.map R1 ≫ forget.map R5 ≫ forget.map (a_Z.map δ_pre)`, CONFINED to the RHS
  -- (verified iter-271: `conv_rhs => rw [Functor.map_comp, Functor.map_comp]` does not touch the
  -- LHS `pushforward.map (sheafAdj_Z.unit _)`).  This exposes R1 = `(pullback h).map (sheafCompPb f .app P).hom`
  -- (forget-wrapped) as the first factor for the conjugateEquiv_whiskerRight recovery (step (ii)).
  conv_rhs => rw [Functor.map_comp, Functor.map_comp]
  -- REMAINING TAIL (the genuine residual — the `hinner`/`hcomp'` twin of `pullbackObjUnitToUnit_comp`
  -- L952–1001, now framed at the sheafification-laden composite-adjunction level).  Goal:
  --   B_{h≫f}.unit P   (LHS, concrete: PrPbPushAdj φ'_{h≫f}.unit P ≫ pushforward φ'_{h≫f}.map (a_Z.unit (Pf P)))
  --   = a_X.unit P ≫ (forget.map B'_unit ≫ forget.map pushforwardComp.hom)
  --       ≫ pushforward φ'_{h≫f}.map (forget.map (R1 ≫ R5 ≫ a_Z.map δ_pre)),
  -- where B'_unit = (A_f.comp A_h).unit (a_X P), pushforwardComp.hom = (SheafOfModules.pushforwardComp h f).hom,
  -- R1 = (pullback h).map (sheafCompPb f .app P).hom, R5 = (sheafCompPb h .app (PrPb_f P)).hom,
  -- δ_pre = a_Z.map (PresheafOfModules.pullbackComp φ'_f φ'_h).hom.app P.
  -- NEXT STEPS (each its own sub-lemma, mirroring the model's hinner/hcomp'):
  --  (i)  `conv_rhs => rw [Functor.map_comp]` (or `erw` confined to RHS) to distribute the inner
  --       `forget.map (R1 ≫ R5 ≫ δ_pre)` into `forget.map R1 ≫ forget.map R5 ≫ forget.map δ_pre`,
  --       WITHOUT touching the LHS unit (use `conv` to confine, as above).
  --  (ii) recover R1/R5 as the f-/h-composite-adjunction units B_f.unit / B_h.unit via
  --       `leftAdjointUniqUnitEta_app` (proved above, axiom-clean) — this is the
  --       `homEquiv_leftAdjointUniq_hom_app` recovery, the twin of the model's hLf/hLh + hinner.
  --       This requires reframing `forget.map ((pullback h).map (sheafCompPb f .app P).hom)` through the
  --       f-adjunction `homEquiv` (a `have` mirroring model hinner L952–973), since the bare goal has
  --       no `homEquiv` head.  BLOCKER: building this `have` is the genuinely-novel sheafification-laden
  --       mate step with no existing project lemma — the `unitToPushforwardObjUnit`-analog at the
  --       composite-adjunction level is absent (the model's `unitToPushforwardObjUnit_comp` was `rfl`;
  --       here the units are composite sheafify∘pushforward adjunctions, so it is NOT `rfl`).
  --  (iii) slide `(SheafOfModules.pushforwardComp h f).hom` past the recovered units by `.hom.naturality`
  --       (model L997), then collapse `Adjunction.comp_unit_app` + `Adjunction.unit_naturality` to the
  --       LHS `B_{h≫f}.unit` (model hcomp' L974–995 + final erw chain L1000–1001).
  sorry

/-- **Sq1 — composition coherence of `SheafOfModules.sheafificationCompPullback` (the S1 paste
square of D3′).** For composable scheme morphisms `h : Z ⟶ Y`, `f : Y ⟶ X` and any presheaf of
modules `P` over `X`, the sheafification–pullback comparison of the composite `h ≫ f` factors
through the comparisons of `f` and `h`, conjugated by the sheaf-level pullback pseudofunctor iso
`Scheme.Modules.pullbackComp h f` on the left and the presheaf-level pullback pseudofunctor iso
`PresheafOfModules.pullbackComp φ'_f φ'_h` (sheafified) on the right. Mathlib-absent at the pin;
the S1-foundational composition coherence consumed by `pullbackTensorMap_restrict`. It is the
`sheafificationCompPullback` twin of `pullbackObjUnitToUnit_comp`: both `sheafificationCompPullback`
isos are `leftAdjointUniq` of composite adjunctions (`sheafificationCompPullback_eq_leftAdjointUniq`),
so the coherence is proved by the adjunction-mate calculus, transposing under the composite
`A_{h≫f} = (sheafAdj_X).comp (pullbackPushforwardAdjunction (h≫f))`. -/
private lemma sheafificationCompPullback_comp {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    (P : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) :
    ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom (h ≫ f))).app P).hom =
      (Scheme.Modules.pullbackComp h f).inv.app
          ((PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)).obj P) ≫
        (Scheme.Modules.pullback h).map
          ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app P).hom ≫
        ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj P)).hom ≫
        (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.val)).map
          ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
            (Hom.toRingCatSheafHom h).hom).hom.app P) := by
  -- Both `sheafificationCompPullback` isos are `leftAdjointUniq` of composite adjunctions
  -- (`sheafificationCompPullback_eq_leftAdjointUniq`).  Transpose the whole identity under
  -- `A_{h≫f} = (sheafAdj_X).comp (pullbackPushforwardAdjunction (h≫f))` and evaluate the LHS by the
  -- mate identity `homEquiv_leftAdjointUniq_hom_app`: the transpose of `(leftAdjointUniq A B).hom.app P`
  -- is `B_{h≫f}.unit.app P`, the unit of `B_{h≫f} = (PrPbPushAdj φ'_{h≫f}).comp (sheafAdj_Z)`.
  apply ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
    (𝟙 X.ringCatSheaf.val)).comp
      (SheafOfModules.pullbackPushforwardAdjunction
        (Hom.toRingCatSheafHom (h ≫ f)))).homEquiv _ _ |>.injective
  rw [sheafificationCompPullback_eq_leftAdjointUniq]
  erw [Adjunction.homEquiv_leftAdjointUniq_hom_app]
  -- LHS is now `B_{h≫f}.unit.app P` (B := (PrPbPushAdj φ'_{h≫f}).comp (sheafAdj_Z)).  Expand BOTH
  -- composite-adjunction units (`homEquiv_unit` on the RHS, `comp_unit_app` on both) so the goal is
  -- the concrete UNIT-LEVEL identity
  --   (PrPbPushAdj φ'_{h≫f}).unit P ≫ (pushforward φ'_{h≫f}).map (sheafAdj_Z.unit (pullback φ'_{h≫f} P))
  --     = (sheafAdj_X.unit P ≫ (forget⋙restrictScalars).map ((ShPbPushAdj (h≫f)).unit (a_X P)))
  --        ≫ (pushforward (h≫f) ⋙ forget⋙restrictScalars).map (R0 ≫ R1 ≫ R5 ≫ a_Z.map δ_pre),
  -- where R0 = (pullbackComp h f).inv, R1 = (pullback h).map (sheafCompPb f .app P).hom,
  -- R5 = (sheafCompPb h .app (PrPb_f P)).hom, δ_pre = (PresheafOfModules.pullbackComp φ'_f φ'_h).hom.app P.
  -- REMAINING (the genuine residual): transport the two `pullbackComp` factors across the adjunctions
  -- — sheaf `pullbackComp h f` via `conjugateEquiv_pullbackComp_inv` / `unit_conjugateEquiv`
  -- (`pushforwardComp = Iso.refl`, exactly as in `pullbackObjUnitToUnit_comp` L920), and the
  -- presheaf `pullbackComp φ'_f φ'_h` sheafified — re-expressing R0/R1/R5/δ_pre under the right-adjoint
  -- `map` as the f- and h-unit factors (`homEquiv_leftAdjointUniq_hom_app` recovers each
  -- `sheafCompPb _ .app _ .hom` as a `B_·.unit`), then collapse via `comp_unit_app` +
  -- `Adjunction.unit_naturality` to the LHS `B_{h≫f}.unit`.  This is the `sheafificationCompPullback`
  -- twin of the `pullbackObjUnitToUnit_comp` mate calculus (L910); the concrete unit identity above is
  -- the reduced goal handed to the next iteration.
  rw [Adjunction.homEquiv_unit, Adjunction.comp_unit_app, Adjunction.comp_unit_app]
  -- ITER-262 (prover) — VERIFIED forward step.  The `conv_rhs` distribution below is the
  -- contamination-free way to expose the four RHS factors: a plain `erw [Functor.map_comp]` on the
  -- whole goal instead rewrites the *LHS* `sheafAdj_Z.unit` into its `toSheafify ≫ restrictHomEquiv`
  -- expansion (and `rw [Functor.map_comp]` does not fire — the outer functor is a defeq-but-not-
  -- syntactic composite, and the unconfined `erw` `whnf`-times-out).  Confining the rewrites to the
  -- RHS with `conv_rhs` distributes the outer `(pushforward (h≫f) ⋙ forget ⋙ restr).map` over the
  -- four-factor composite and pushes the leading `pushforward (h≫f)` inside via `Functor.comp_map`.
  -- After it the RHS reads
  --   (sheafAdj_X.unit P ≫ (forget⋙restr).map (ShPbPushAdj(h≫f).unit (a_X P)))
  --     ≫ (forget⋙restr).map ((pushforward (h≫f)).map R0)
  --     ≫ (pushforward (h≫f) ⋙ forget⋙restr).map (R1 ≫ R5 ≫ a_Z.map δ_pre),
  -- so the second and third factors are now BOTH `(forget⋙restr).map _` and adjacent.
  conv_rhs =>
    erw [Functor.map_comp]
    erw [Functor.comp_map (SheafOfModules.pushforward (Hom.toRingCatSheafHom (h ≫ f)))]
  -- ITER-262 (prover) — R0 PEELED.  Merge the two adjacent `(forget⋙restr).map _` factors and peel
  -- the leading `R0 = (pullbackComp h f).inv` by the building block.  Plain `rw [Category.assoc]` does
  -- NOT re-expose the `(f ≫ g) ≫ h` head, and `slice_rhs` keeps the `comp_unit_app`-glued
  -- `(sheafAdj_X.unit ≫ A)` as a single factor — so we derive the merged-and-peeled equation under
  -- `(forget⋙restr).map` via `congrArg` + `Functor.map_comp`, then splice it in with `reassoc_of%`
  -- (which matches the `A ≫ (B' ≫ rest)` association in place).
  -- `key` IS the merged-and-peeled R0 equation, PROVEN (axiom-clean) and in the goal's exact spelling:
  --   `(forget⋙restr).map (ShPbPushAdj(h≫f).unit (a_X P)) ≫ (forget⋙restr).map ((pushforward (h≫f)).map R0)
  --     = (forget⋙restr).map ((ShPbPushAdj f .comp ShPbPushAdj h).unit (a_X P) ≫ pushforwardComp.hom _)`,
  -- obtained by mapping the building block `sheaf_unit_comp_pushforward_pullbackComp_inv` under
  -- `(forget⋙restr).map` and splitting with `Functor.map_comp`.  Its LHS is precisely the 2nd ≫ 3rd RHS
  -- factors of the goal.
  have key := congrArg
    (SheafOfModules.forget X.ringCatSheaf ⋙
      PresheafOfModules.restrictScalars (𝟙 (Sheaf.val X.ringCatSheaf))).map
    (sheaf_unit_comp_pushforward_pullbackComp_inv h f
      ((PresheafOfModules.sheafification (𝟙 (Sheaf.val X.ringCatSheaf))).obj P))
  rw [Functor.map_comp] at key
  -- SPLICE `key` IN (R0-peel).  `simp only [Functor.comp_map]` puts goal + `key` in the same unfolded
  -- `restrictScalars.map (forget.map _)` normal form; `erw [Category.assoc]` (NOT `rw`/`simp` — the
  -- intermediate objects are defeq-but-not-syntactic `Functor.obj` applications, so only `erw`'s
  -- defeq-implicit matching flattens the `comp_unit_app`-glued `(sheafAdj_X.unit ≫ A)`) right-associates
  -- the RHS; `erw [reassoc_of% key]` then rewrites `A ≫ (B' ≫ C)` → `merged ≫ C`, replacing the leading
  -- `R0 = (pullbackComp h f).inv` factor by the composite `f`/`h`-adjunction unit + `pushforwardComp.hom`.
  simp only [Functor.comp_map] at key ⊢
  erw [Category.assoc]
  erw [reassoc_of% key]
  -- R0 PEELED.  Goal RHS now reads (X-side sheafification discharged):
  --   sheafAdj_X.unit P
  --     ≫ (forget⋙restr).map ((ShPbPushAdj f .comp ShPbPushAdj h).unit (a_X P) ≫ pushforwardComp.hom _)
  --     ≫ (forget⋙restr).map ((pushforward (h≫f)).map (R1 ≫ R5 ≫ a_Z.map δ_pre)),
  -- LHS = `B_{h≫f}.unit.app P` = `PrPbPushAdj(φ'_{h≫f}).unit P ≫ (pushforward φ'_{h≫f}).map (sheafAdj_Z.unit …)`.
  -- REMAINING TAIL (the analog of `pullbackObjUnitToUnit_comp`'s tail, L969-996): recover the two
  -- `sheafCompPb` factors R1 = `(pullback h).map (sheafCompPb f .app P).hom` and
  -- R5 = `(sheafCompPb h .app (PrPb_f P)).hom` as `B_f`/`B_h` units via `homEquiv_leftAdjointUniq_hom_app`
  -- on their `sheafificationCompPullback_eq_leftAdjointUniq` form, slide `pushforwardComp.hom` past them by
  -- `(pushforwardComp h f).hom.naturality`, and collapse `comp_unit_app` + `Adjunction.unit_naturality`
  -- to `B_{h≫f}.unit` — mirroring `hinner`/`hcomp'` + the final `erw` chain of `pullbackObjUnitToUnit_comp`.
  -- MERGE the two adjacent `(forget ⋙ restrictScalars).map _` RHS factors into one (verified `erw`),
  -- then discharge the merged tail by the extracted named lemma.
  erw [← Functor.map_comp, ← Functor.map_comp]
  exact sheafificationCompPullback_comp_tail h f P

/-- **D3′ — composition coherence of the sheaf-level pullback–tensor comparison `pullbackTensorMap`**
(blueprint `lem:pullback_tensor_map_basechange`).

This is the *tensorator* analog of the unit composition coherence
`pullbackObjUnitToUnit_comp`: for composable scheme morphisms `h : Z ⟶ Y`, `f : Y ⟶ X` and
arbitrary `M N : X.Modules`, the comparison `δ_sheaf = pullbackTensorMap (h ≫ f)` of the composite
factors through the comparisons of `f` and `h` and the pullback pseudofunctor coherence
`pullbackComp`:
`pullbackTensorMap (h≫f) M N = (pullbackComp h f).inv ≫ (pullback h).map (pullbackTensorMap f) ≫
  pullbackTensorMap h (f^*M) (f^*N) ≫ tensorObjIsoOfIso (pullbackComp h f) (pullbackComp h f)`.

The base-change-square form of the blueprint (`f ∘ j' = j ∘ g` with `j, j'` open immersions) is the
specialisation `h := j'`, `f`, applied to the two factorisations `j' ≫ f = g ≫ j` of the equal
underlying morphisms; the displayed identity of the restricted comparisons follows by equating the
two instances of this coherence. Consumed by D4′ `pullbackTensorIsoOfLocallyTrivial`.

Mathlib-absent at the pinned commit; NOT a sectionwise statement (the left-adjoint pullback exposes
no sectionwise value). Proved by the mate calculus through the oplax comparison `δ` of a composite of
left adjoints (`Functor.OplaxMonoidal.comp_δ`) and the adjunction-mate identity
`conjugateEquiv_pullbackComp_inv` (`pullbackComp` for the left adjoints ↔ `pushforwardComp` for the
right adjoints), exactly mirroring `pullbackObjUnitToUnit_comp`. -/
lemma pullbackTensorMap_restrict {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    (M N : X.Modules) :
    pullbackTensorMap (h ≫ f) M N =
      (Scheme.Modules.pullbackComp h f).inv.app (tensorObj M N) ≫
      (Scheme.Modules.pullback h).map (pullbackTensorMap f M N) ≫
      pullbackTensorMap h ((Scheme.Modules.pullback f).obj M)
        ((Scheme.Modules.pullback f).obj N) ≫
      (tensorObjIsoOfIso ((Scheme.Modules.pullbackComp h f).app M)
        ((Scheme.Modules.pullbackComp h f).app N)).hom := by
  -- ROADMAP (iter-256 handoff). Unfolding `pullbackTensorMap` on both sides (verified) exposes the
  -- four-fold composite `S1 ≫ a.map δ ≫ S3 ≫ S4` with
  --   S1 = (sheafificationCompPullback φ_{·}).app (M.val ⊗ₚ N.val) .hom,
  --   S2 = a_·.map (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ'_{·}) M.val N.val),
  --   S3 = (sheafifyTensorUnitIso (Fp M.val) (Fp N.val)).hom,
  --   S4 = a_·.map (forget(pullbackValIso · M).hom ⊗ₘ forget(pullbackValIso · N).hom).
  -- Unlike D1′ (naturality, a 4-square *paste*), this is a 4-square *composition*-coherence: the LHS
  -- is the composite-morphism `· = h ≫ f` instance, the RHS interleaves the `f` instance (pushed
  -- forward by `(pullback h).map`) with the `h` instance (on the pulled-back modules `(pullback f).obj`),
  -- all conjugated by the pseudofunctoriality iso `pullbackComp h f`.
  --
  -- **Why the unit-analog mirror does NOT transfer.** `pullbackObjUnitToUnit_comp` (L907) works because
  -- `pullbackObjUnitToUnit` is BY DEFINITION an adjunction transpose, so its composition coherence is
  -- obtained by transposing through `pullbackPushforwardAdjunction.homEquiv` and invoking the bridge
  -- `pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit`. `pullbackTensorMap` is NOT a
  -- transpose — it is the hand-built 4-fold composite above — and there is NO analogous
  -- `…homEquiv_pullbackTensorMap` bridge. Hence the mirror's very first move
  -- (`(pullbackPushforwardAdjunction (h≫f)).homEquiv.injective`) leaves an un-evaluable transpose of a
  -- concrete composite and stalls. This is the planner's anticipated "genuinely new obstacle beyond the
  -- unit-analog pattern" — per the iter-256 reversing signal, the scaffolded statement is retained with
  -- this typed `sorry` rather than forcing a non-applicable device.
  --
  -- **The genuine route (four composition-coherence squares; each its own sub-lemma).**
  --  • Sq2 (the δ core): `δ (PresheafOfModules.pullback φ'_{h≫f})` decomposes via
  --    `CategoryTheory.Functor.OplaxMonoidal.comp_δ` once `pullback φ'_{h≫f}` is identified with
  --    `pullback φ'_f ⋙ pullback φ'_h` through the Mathlib presheaf coherence
  --    `PresheafOfModules.pullbackComp φ'_f ψ` (verified to exist; composite ring map
  --    `φ'_f ≫ F.op.whiskerLeft ψ`), which requires the ring-map reconciliation
  --    `(toRingCatSheafHom (h≫f)).hom = φ'_f ≫ (Opens.map f.base).op.whiskerLeft φ'_h` (functoriality
  --    of `toRingCatSheafHom` under `≫`).  `PresheafOfModules.{pullbackId, pullback_assoc}` are the
  --    coherence-bookkeeping lemmas.
  --  • Sq1 (sheafification ↔ pullback): the composition coherence of
  --    `SheafOfModules.sheafificationCompPullback` across `h≫f` (analog of `pullbackComp` for the
  --    `sheafification ⋙ pullback` natural iso) — Mathlib-absent, a project sub-lemma.
  --  • Sq3: `sheafifyTensorUnitIso` carried through the same `pullbackComp` identification.
  --  • Sq4 (the connecting iso): a Scheme-level `pullbackValIso` composition coherence relating
  --    `pullbackValIso (h≫f) M` to `(pullback h).map (pullbackValIso f M)`, `pullbackValIso h (f^*M)`
  --    and `(pullbackComp h f).app M` — Mathlib-absent, the second project sub-lemma; it is the
  --    bookkeeping that produces the final `tensorObjIsoOfIso (pullbackComp h f) (pullbackComp h f)`.
  -- The two project sub-lemmas (Sq1, Sq4 composition coherences) + the Sq2 ring-map reconciliation are
  -- the missing ingredients; they are the iter-257 work items (each ~40-120 LOC, mate-calculus style).
  --
  -- ITER-257 FINDINGS (prover):
  --  (1) The Sq2 RING-MAP RECONCILIATION IS DEFINITIONAL — `toRingCatSheafHom_comp_hom_reconcile`
  --      (just above) closes by `rfl`: `(toRingCatSheafHom (h≫f)).hom =
  --      (toRingCatSheafHom f).hom ≫ (Opens.map f.base).op.whiskerLeft (toRingCatSheafHom h).hom`.
  --      The blueprint's "non-trivial because the two sides live in functor categories that agree only
  --      up to Opens.map_comp" is in fact a `rfl` (the `Opens.map`/`Scheme` comp defeqs hold). This
  --      means `PresheafOfModules.pullbackComp φ'_f φ'_h` lands in `pullback φ'_{h≫f}` ON THE NOSE.
  --  (2) The genuine Sq2 content is "Sq2b": the MONOIDALITY of `pullbackComp` — that `δ` of the single
  --      `pullback φ'_{h≫f}` (leftAdjoint-oplax of the composite adjunction) transports, through
  --      `pullbackComp`, to `δ` of the composite functor `pullback φ'_f ⋙ pullback φ'_h`
  --      (`Functor.OplaxMonoidal.comp_δ`). Mathlib has NO ready lemma for the δ-transport of
  --      `Adjunction.leftAdjointCompIso` (searched: no `leftAdjointOplaxMonoidal`-of-composite lemma).
  --      It must be proved by the mate calculus (mirror `Adjunction.isMonoidal_comp`, Functor.lean:990).
  --  (3) STATEMENT-LEVEL FRICTION to budget for: (a) `Functor.OplaxMonoidal.δ (pullback φ')` needs the
  --      CommRingCat/forget₂ monoidal-instance pinning (the D1′ `show … from`/`let φ' : … ⋙ forget₂`
  --      device — bare `δ (pullback (toRingCatSheafHom f).hom)` leaves `MonoidalCategory` metavars
  --      stuck); (b) `pullbackComp φ'_f φ'_h` pins `(F := Opens.map f.base ⋙ Opens.map h.base)` with the
  --      morphism `φ'_f ≫ whiskerLeft (Opens.map f.base).op φ'_h`, and unifying the standalone δ's
  --      pullback against that codomain needs explicit `(F := …)` + the associativity defeq
  --      `(F⋙G).op⋙T = F.op⋙(G.op⋙T)` — write the LHS δ over `pullback (F := _ ⋙ _) (toRingCatSheafHom
  --      (h≫f)).hom` (typechecks) and bridge the RHS connecting object by `eqToHom` via finding (1).
  -- ITER-261 (prover): the proof is now OPENED to the paste-ready form.  `simp only` unfolds
  -- `pullbackTensorMap` on BOTH sides into the four-fold composite `S1 ≫ a.map δ ≫ S3 ≫ S4`; the RHS
  -- `(pullback h).map (S1_f ≫ … ≫ S4_f)` is distributed by `Functor.map_comp` and everything
  -- right-associated.  The goal is then the explicit 4-vs-10 factor identity
  --   S1_{hf} ≫ a_Z.map δ_{hf} ≫ S3_{hf} ≫ S4_{hf}
  --     = R0 ≫ (pullback h).map S1_f ≫ (pullback h).map (a_Y.map δ_f) ≫ (pullback h).map S3_f
  --        ≫ (pullback h).map S4_f ≫ S1_h ≫ a_Z.map δ_h ≫ S3_h ≫ S4_h ≫ a_Z.mapIso(pbComp ⊗ pbComp).hom
  -- with R0 = (pullbackComp h f).inv.app (M⊗N).  This is the four-square *composition* paste:
  --   • Sq1 (the S1 connecting iso):  `sheafificationCompPullback_comp` (stated+opened just above —
  --     the foundational Mathlib-absent coherence; LHS already reduced to the unit identity).
  --   • Sq2b (the δ core):           `pullbackComp_δ` (CLOSED, axiom-clean) under `a_Z.map`.
  --   • Sq3 (the unit iso):          `sheafifyTensorUnitIso` carried through `pullbackComp`.
  --   • Sq4 (the connecting iso):    a `pullbackValIso` composition coherence (Mathlib-absent; it
  --     factors through Sq1 since `pullbackValIso = sheafCompPb.symm ≪≫ pullback.mapIso counit`).
  -- The squares INTERLEAVE (e.g. `S1_h` here acts on `tensorObj ((pullback f).obj M) …`, NOT on
  -- `PrPb_f (M⊗N)`), so the paste slides factors past each other by `δ_natural` / NatTrans naturality
  -- exactly as the D1′ naturality paste (`pullbackTensorMap_natural`, L2007) does — merging
  -- `a.map δ ≫ S3 ≫ S4` into a single `a.map Ψ` to move S1 by its mate coherence.  The remaining work
  -- is: finish Sq1's unit reassembly, build Sq4, then run the interleaved merge.  Typed sorry retained
  -- (race-safe: file compiles; `DualInverse.lean` imports it).
  simp only [pullbackTensorMap, tensorObjIsoOfIso]
  rw [Functor.map_comp, Functor.map_comp, Functor.map_comp]
  simp only [Category.assoc]
  sorry

end LocTrivPullbackTensor

end Modules

end Scheme

end AlgebraicGeometry
