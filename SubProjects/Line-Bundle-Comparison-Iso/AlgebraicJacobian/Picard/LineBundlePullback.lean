/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Line-bundle pullback on a relative curve (A.1.b)

This file is the **A.1.b** file-skeleton sub-build chapter for the project's
positive-genus arm of `nonempty_jacobianWitness`. It packages the line-bundle
pullback functor `π_T^* : Pic(T) → Pic(C ×_S T)` along the projection
`π_T : C ×_S T → T` of a relative curve, and the set-valued relative Picard
presheaf

```
Pic^♯_{C/S}(T) := Pic(C ×_S T) / π_T^* Pic(T)
```

as a functor on `(Sch/S)^op`.

## Status (iter-174 Lane E file-skeleton)

This file is the **iter-174 Lane E** file-skeleton: each of the five pinned
declarations carries the *intended* substantive type signature (matching the
blueprint `\lean{...}` pin in `chapters/Picard_LineBundlePullback.tex`) with a
`sorry` body. The bodies are iter-175+ work after the sibling chapters
`Picard_RelativeSpec.lean` (A.1.a) settles its `QcohAlgebra` body, and after
`Picard_RelPicFunctor.lean` (A.1.c) lands the étale-sheafification overlay.

The 5 pinned declarations are:

1. `AlgebraicGeometry.Scheme.LineBundle.OnProduct` (def, ~5 LOC) — the type of
   line bundles on the product `C ×_S T`.
2. `AlgebraicGeometry.Scheme.LineBundle.pullbackAlongProjection`
   (noncomputable def, ~6 LOC) — the pullback map `Pic(T) → Pic(C ×_S T)`.
3. `AlgebraicGeometry.Scheme.LineBundle.pullback_pullback_eq` (theorem, ~10 LOC)
   — composition of pullbacks `g_C^* ∘ π_T^* = π_{T'}^* ∘ g^*` (Stacks 01HG).
4. `AlgebraicGeometry.Scheme.RelPicPresheaf.preimage_subgroup` (def, ~8 LOC)
   — well-definedness of the quotient `Pic(C ×_S T) / π_T^* Pic(T)`, encoded as
   the substantive `Setoid` on `OnProduct πC πT` that defines the equivalence
   relation `L ~ L' ↔ L ⊗ (L')⁻¹ ∈ π_T^* Pic(T)`.
5. `AlgebraicGeometry.Scheme.RelPicPresheaf.functorial`
   (noncomputable def, ~10 LOC) — for `g : T' ⟶ T` over `S`, the induced map
   `Pic^♯_{C/S}(T) → Pic^♯_{C/S}(T')` factoring `g_C^*` through the quotient.

## Note on type expressivity

Because Mathlib `b80f227` ships no `Module.Invertible`/`IsInvertible` predicate
on `Scheme.Modules` (the closest is `Module.Invertible R M` for `R : CommRing`),
the type `OnProduct` packaging *line bundles* (= invertible sheaves of
`O`-modules) on the product cannot yet be carved out of `Scheme.Modules` as a
subtype. Following the project rule "Never weaken the type to dodge the proof"
we encode `OnProduct` by a typed `sorry` at the type level: the iter-175+ body
will instantiate it as a structure pairing a `(pullback πC πT).Modules` carrier
with an `IsInvertible` witness once that predicate is in Mathlib (or proven
internally as the project-side definition).

The 4 pinned theorems/defs reference `OnProduct` as a typed-`sorry` carrier;
their signatures are still substantive (each declares a non-tautological claim:
a map between line-bundle types, a transitivity-of-pullback equality, an
equivalence relation on line bundles, an induced quotient map) and the bodies
collapse once `OnProduct` is unpacked.

## References

Blueprint: `blueprint/src/chapters/Picard_LineBundlePullback.tex` (444 LOC,
5 pins). Source: [Kleiman], "The Picard scheme", §2 (FGA Explained Ch.9 §9.2),
Definitions `df:aPf` (absolute Picard functor) and `df:Pfs` (relative Picard
functor). Stacks Project tags 01HG (pullback preserves invertibility),
01HH (functoriality of pullback), 01HK (invertible modules), 01CR
(Picard group of a scheme).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

namespace LineBundle

/-! ## §1. Line bundles on a product

A *line bundle* on the relative curve `C ×_S T` is an invertible
`O_(C ×_S T)`-module, i.e. a sheaf of modules locally free of rank one. In
Mathlib `b80f227` the `Scheme.Modules` category is in place
(`Mathlib.AlgebraicGeometry.Modules.Sheaf`), but there is no `IsInvertible`
predicate on its objects yet (the closest is `Module.Invertible R M` for rings,
in `Mathlib.RingTheory.PicardGroup`). iter-187 supplies the missing
predicate as a project-side definition via local trivialisation on an affine
open cover (see `IsLocallyTrivial` below), and refines `OnProduct` to the
corresponding subtype.

Blueprint reference: `def:line_bundle_on_product` (Kleiman §2, "absolute Picard
functor"; Stacks tag 01HK). -/

/-- A sheaf of `𝒪_X`-modules `M` is **locally trivial of rank one** if every
point `x : X` has an affine open neighbourhood `U` on which the restriction
`M|_U` is isomorphic to the structure sheaf-as-module `𝒪_U`. This is the
project-side stand-in for the missing Mathlib `IsInvertible` predicate on
`Scheme.Modules`: line bundles (invertible sheaves) are exactly the
`IsLocallyTrivial` modules, by Stacks tag 01HK / Hartshorne II §6. Local
trivialisability is the structural content that survives base change along
`f : Y ⟶ X` (Stacks 01HH) and is the source of the invertibility-preservation
step for `pullbackAlongProjection`.

The witness is bundled as `Nonempty (M.restrict U.ι ≅ SheafOfModules.unit _)`:
the existence of a sheaf-of-modules isomorphism over the affine chart. -/
def IsLocallyTrivial {X : Scheme.{u}} (M : X.Modules) : Prop :=
  ∀ x : X, ∃ U : X.Opens, x ∈ U ∧ IsAffineOpen U ∧
    Nonempty (M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf)

/-- The type of **line bundles on the product** `C ×_S T`: invertible sheaves of
`O_(C ×_S T)`-modules, where the product is the categorical pullback of the
projections `πC : C ⟶ S` and `πT : T ⟶ S`. In Kleiman's notation with `X = C`
and base `S`, this is `Pic_C(T) = Pic(C ×_S T)`, the value of the absolute
Picard functor at `T`.

iter-187: refined to the subtype of `(Limits.pullback πC πT).Modules` cut out
by the project-side predicate `IsLocallyTrivial` (locally trivial of rank one).
The carrier is now genuinely the line-bundle subobject of `Scheme.Modules`,
matching the blueprint statement `def:line_bundle_on_product`. Iter-186's
all-modules carrier is recovered by forgetting the second component. -/
def OnProduct {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S) : Type (u+1) :=
  { M : (Limits.pullback πC πT).Modules // IsLocallyTrivial M }

/-- Projection from a line bundle on the product to its underlying
sheaf of modules. -/
abbrev OnProduct.carrier {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S}
    (L : OnProduct πC πT) : (Limits.pullback πC πT).Modules := L.1

/-- A line bundle on the product is locally trivial of rank one. -/
lemma OnProduct.isLocallyTrivial {S C T : Scheme.{u}} {πC : C ⟶ S} {πT : T ⟶ S}
    (L : OnProduct πC πT) : IsLocallyTrivial L.carrier := L.2

/-- **Stacks 01HH (pullback of an invertible sheaf is invertible).** For any
morphism of schemes `f : Y ⟶ X` and any locally-trivial sheaf of `𝒪_X`-modules
`M`, the pulled-back module `f^* M : Y.Modules` is again locally trivial.

The proof unfolds an affine open cover trivialising `M`, pulls back along `f`,
and observes that `f^*` commutes with restriction along open immersions (the
`pullback`/`restrictFunctor` natural isomorphism in
`Mathlib.AlgebraicGeometry.Modules.Sheaf`) so that the trivialising chart for
`M|_U` becomes a trivialising chart for `(f^* M)|_(f⁻¹ U)`. The full chart-chase
involves the natural-isomorphism `restrictFunctorIsoPullback` plus the
preservation of `SheafOfModules.unit` under pullback (Mathlib
`Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackFree`'s
`unitToPushforwardObjUnit`). Iter-187 wraps this chase as a named typed sorry
(helper-budget = 1); iter-188+ instantiates the chart-chase. -/
lemma IsLocallyTrivial.pullback {X Y : Scheme.{u}} (f : Y ⟶ X) {M : X.Modules}
    (hM : IsLocallyTrivial M) :
    IsLocallyTrivial ((Scheme.Modules.pullback f).obj M) := by
  intro y
  obtain ⟨U, hxU, hU_aff, eM⟩ := hM (f.base y)
  have hyU' : y ∈ f ⁻¹ᵁ U := hxU
  obtain ⟨V, hV_aff, hyV, hVU⟩ := exists_isAffineOpen_mem_and_subset hyU'
  refine ⟨V, hyV, hV_aff, ?_⟩
  -- Stacks 01HH chart-chase: factor `V.ι ≫ f` through `U` using
  -- `Scheme.Hom.resLE`, then transport through `restrictFunctorIsoPullback`
  -- and `pullbackComp` to identify the pullback at `V` with the pullback of
  -- the unit on `U` to `V`. Close via `eM` and `pullbackObjUnitToUnit`
  -- (which is an iso since `Opens.map g.base` is final via the
  -- `RepresentablyFlat` instance).
  obtain ⟨eM⟩ := eM
  set g : (V : Scheme) ⟶ (U : Scheme) := f.resLE U V hVU with hg_def
  have hg_comp : g ≫ U.ι = V.ι ≫ f := Scheme.Hom.resLE_comp_ι f hVU
  haveI : (TopologicalSpace.Opens.map g.base).Final :=
    CategoryTheory.final_of_representablyFlat _
  refine ⟨?_⟩
  -- 1: ((pullback f).obj M).restrict V.ι ≅ (pullback V.ι).obj ((pullback f).obj M)
  let i1 :=
    (Scheme.Modules.restrictFunctorIsoPullback V.ι).app ((Scheme.Modules.pullback f).obj M)
  -- 2: ≅ (pullback (V.ι ≫ f)).obj M
  let i2 := (Scheme.Modules.pullbackComp V.ι f).app M
  -- 3: ≅ (pullback (g ≫ U.ι)).obj M  (using V.ι ≫ f = g ≫ U.ι)
  let i3 := (Scheme.Modules.pullbackCongr hg_comp.symm).app M
  -- 4: ≅ (pullback g).obj ((pullback U.ι).obj M)
  let i4 := ((Scheme.Modules.pullbackComp g U.ι).symm).app M
  -- 5: ≅ (pullback g).obj (M.restrict U.ι)
  let i5 := (Scheme.Modules.pullback g).mapIso
    ((Scheme.Modules.restrictFunctorIsoPullback U.ι).symm.app M)
  -- 6: ≅ (pullback g).obj (unit_U)
  let i6 := (Scheme.Modules.pullback g).mapIso eM
  -- 7: ≅ unit_V  (pullback of unit is unit via the Mathlib morphism, which is
  -- iso since the underlying `Opens.map g.base` is Final)
  let i7 := asIso (SheafOfModules.pullbackObjUnitToUnit g.toRingCatSheafHom)
  exact i1 ≪≫ i2 ≪≫ i3 ≪≫ i4 ≪≫ i5 ≪≫ i6 ≪≫ i7

/-! ## §2. The pullback functor along the projection

For a morphism of schemes `f : Y ⟶ Z` and an invertible `O_Z`-module `M`, the
pullback `f^* M` is an invertible `O_Y`-module (the pullback of an
open-cover-trivialisation of `M` trivialises `f^* M`, and the pullback of a free
module of rank one is free of rank one — Stacks tag 01HH). Specialising to the
projection `π_T = pullback.snd πC πT : C ×_S T ⟶ T` gives the pullback map
`π_T^* : Pic(T) → Pic(C ×_S T)`. Mathlib's underlying `Scheme.Modules.pullback`
functor (in `Mathlib.AlgebraicGeometry.Modules.Sheaf`) supplies the pullback on
the full category of sheaves of modules; iter-175+ will restrict it to
invertible sheaves once the `OnProduct` carrier is unpacked.

Blueprint reference: `def:pullback_along_projection` (Kleiman §2; Stacks tag
01HH). -/

/-- **Pullback along the projection** `π_T : C ×_S T ⟶ T` of a relative
curve. Sends a *line bundle on `T`* — i.e. an `O_T`-module `N` equipped with a
proof `hN : IsLocallyTrivial N` — to the line bundle `π_T^* N` on `C ×_S T`,
induced by the `Scheme.Modules.pullback` functor on `Scheme.Modules` together
with the preservation step `IsLocallyTrivial.pullback` (Stacks 01HH).

iter-187: refined to consume the `OnProduct`-style subtype on the source: the
underlying carrier is the direct application of Mathlib's
`Scheme.Modules.pullback (pullback.snd πC πT)` functor at `N`, and the
locally-trivial witness comes from the project-side helper
`IsLocallyTrivial.pullback` (Stacks 01HH, named typed sorry pending the affine
chart chase). -/
noncomputable def pullbackAlongProjection {S C T : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) (N : T.Modules) (hN : IsLocallyTrivial N) :
    OnProduct πC πT :=
  ⟨(Scheme.Modules.pullback (Limits.pullback.snd πC πT)).obj N,
    hN.pullback (Limits.pullback.snd πC πT)⟩

/-! ## §3. Composition of pullbacks

The composition law for line-bundle pullback (Stacks tag 01HG) says that for any
composable morphisms `f : X ⟶ Y, g : Y ⟶ Z` and any line bundle `M ∈ Pic(Z)`,
the natural isomorphism `(g ∘ f)^* M ≅ f^* g^* M` makes the pullback functor
into a (pseudo-)functor `Sch^op ⥤ Cat`.

Specialised to the relative curve setting: given `g : T' ⟶ T` over `S`, the
base-change morphism `g_C := id_C ×_S g : C ×_S T' ⟶ C ×_S T` satisfies
`π_T ∘ g_C = g ∘ π_{T'}` (definition of the fiber product). Therefore on
line bundles `g_C^* ∘ π_T^* = π_{T'}^* ∘ g^*`, with the equality realised as the
canonical natural isomorphism of pullback functors via the pseudo-functoriality
of `Scheme.Modules.pullback` (Mathlib `Modules.pullbackComp`).

Blueprint reference: `lem:pullback_compose` (Kleiman §2; Stacks tag 01HG). -/

end LineBundle

namespace RelPicPresheaf

/-! ## §4. The relative Picard quotient (set-valued)

The relative Picard presheaf `Pic^♯_{C/S}(T) := Pic(C ×_S T) / π_T^* Pic(T)`
quotients the line-bundle group of the product by the subgroup pulled back from
the base. As a quotient of abelian groups it is a quotient set; equivalently,
the equivalence relation `L ~ L' ↔ L ⊗ L'⁻¹ ∈ π_T^* Pic(T)` is captured by a
`Setoid` on the line-bundle type `OnProduct πC πT`. The quotient
`Quotient (preimage_subgroup πC πT)` is the underlying set of the relative
Picard presheaf at `T`.

The "preimage_subgroup" name follows the Kleiman/Stacks convention: the
quotient is by the preimage `π_T^* Pic(T) ⊆ Pic(C ×_S T)`, treated as a
subgroup (image of a group homomorphism); the project-side Lean encoding
extracts the *Setoid* that the quotient construction takes.

Blueprint reference: `thm:relative_pic_quotient_well_defined` (Kleiman §2,
Def. `df:Pfs`). -/

/-- **Well-definedness of the relative Picard quotient as a `Setoid`.**

The equivalence relation on `OnProduct πC πT` defining the relative Picard
presheaf
```
Pic^♯_{C/S}(T) := Pic(C ×_S T) / π_T^* Pic(T)
```
is the relation `L ~ L' ↔ L ⊗ L'⁻¹ ∈ π_T^* Pic(T)`. This relation is reflexive
(`L ⊗ L⁻¹ = O_(C ×_S T) = π_T^* O_T ∈ π_T^* Pic(T)`), symmetric (the inverse of
a line bundle in `π_T^* Pic(T)` is in `π_T^* Pic(T)`), and transitive
(`L ⊗ L'⁻¹ ∈ π_T^* Pic(T)` and `L' ⊗ L''⁻¹ ∈ π_T^* Pic(T)` give
`L ⊗ L''⁻¹ ∈ π_T^* Pic(T)`); hence is an equivalence relation, encoded by a
`Setoid` on `OnProduct πC πT`.

The substantive content is the well-definedness of the quotient: the canonical
projection `OnProduct πC πT → Quotient (preimage_subgroup πC πT)` is the
set-theoretic underlying map of the relative Picard presheaf at `T`.

iter-186: with `OnProduct := (pullback πC πT).Modules`, the carrier is the
modules category. We encode the **iso-class setoid** `L ~ L' ↔ Nonempty (L ≅ L')`.
This is a substantive simplification: it identifies isomorphic modules
(giving the underlying set of `Pic(C ×_S T)` once invertibility is imposed),
but does not yet quotient by the pullback subgroup `π_T^* Pic(T)`. The full
quotient requires a tensor-product structure on `Scheme.Modules` (Mathlib
ships `PresheafOfModules.Monoidal.tensorObj` but no monoidal structure on
`Scheme.Modules` directly at `b80f227`) plus an inverse for invertibles;
iter-187+: refine to `L ~ L' ↔ ∃ N : T.Modules, Nonempty (L ⊗ L'⁻¹ ≅
pullbackAlongProjection πC πT N)` once both are available. -/
noncomputable def preimage_subgroup {S C T : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) :
    Setoid (LineBundle.OnProduct πC πT) where
  r L L' := Nonempty (L.carrier ≅ L'.carrier)
  iseqv :=
    { refl := fun _ => ⟨Iso.refl _⟩
      symm := fun ⟨e⟩ => ⟨e.symm⟩
      trans := fun ⟨e₁⟩ ⟨e₂⟩ => ⟨e₁ ≪≫ e₂⟩ }

/-! ## §5. Naturality in the test scheme — the relative Picard presheaf as a functor

For a morphism `g : T' ⟶ T` over `S` (encoded by the equality `πT' = g ≫ πT`),
the base-change `g_C := id_C ×_S g : C ×_S T' ⟶ C ×_S T` induces a map
`g_C^* : Pic(C ×_S T) → Pic(C ×_S T')` on line bundles, which (by
`lem:pullback_compose` = `pullback_pullback_eq` above) sends the subgroup
`π_T^* Pic(T)` into `π_{T'}^* Pic(T')`. Therefore it descends to a unique map
on quotients
```
g^♯ : Pic^♯_{C/S}(T) ⟶ Pic^♯_{C/S}(T'),    [L] ↦ [g_C^* L],
```
making `Pic^♯_{C/S} : (Sch/S)^op ⥤ Set` a presheaf.

For the iter-174 file-skeleton, we pin the **object-level** functorial action
(i.e. the induced map of quotient sets for a single test morphism `g`). The
full `Functor` packaging (with the identity / composition laws supplied as
`map_id`, `map_comp` fields) is iter-175+ work once `OnProduct` and the
`preimage_subgroup` carrier are unpacked.

Blueprint reference: `thm:pullback_natural` (Kleiman §2, "absolute Picard
functor" + Def. `df:Pfs`; Stacks tag 01HG). -/

end RelPicPresheaf

end Scheme

end AlgebraicGeometry
