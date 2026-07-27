/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib
import AlgebraicJacobian.Picard.RelPicFunctor
import AlgebraicJacobian.Picard.DivFunctorDef

/-!
# FGA representability of the Picard scheme

This file states the FGA representability of the relative Picard functor of a
smooth proper geometrically integral curve `C/k`, following Kleiman, "The
Picard scheme", §2 and §4 (cf. FGA Explained Ch. 9; arXiv:math/0504020).

The relative Picard functor is

```
picSharp C := PicSharp.relPresheaf C ⋙ forget AddCommGrpCat
```

the set-valued shadow of the `H_T`-coset carrier
`T ↦ Pic(C ×_k T)/π_T^* Pic(T)` of `Picard/RelPicFunctor.lean` (Kleiman §2
Def. `df:Pfs`; blueprint `def:rel_pic_sharp`). A `RepresentableBy` witness
against it is a natural bijection
`(T ⟶ Pic_{C/k}) ≃ Pic(C ×_k T)/π_T^* Pic(T)`, which is what the downstream
tangent-space computation (`AJC.pic0av`, `Pic0.tangentSpaceIso`) attaches to.

## The étale-sheafification route: Kleiman §2 Thm 2.5

Kleiman §4 represents the **étale-sheafified** functor `Pic_{(C/k)ét}`.
Mathlib at the pinned revision has no étale Grothendieck topology on
schemes, so instead of sheafifying we use Kleiman §2 **Thm 2.5**: when
`f : X → S` has a **section** and `O_S = f_* O_X` holds universally (true
for our proper geometrically integral `C/k`), the comparison maps

```
Pic_{X/S}(T) → Pic_{(X/S)ét}(T) → Pic_{(X/S)fppf}(T)
```

are all **bijective**. Hence, under a `k`-rational-point hypothesis
(`HasRationalPoint C` below), the *plain* relative functor `picSharp C` is
itself representable, and the FGA statement can be made against it directly
— no étale topology needed. Without a section the plain functor is not
representable in general (it need not even be a Zariski sheaf), which is why
representability is asserted only **conditionally on `[HasRationalPoint C]`**:
an unconditional statement would be false. For the same reason `picSharp` may
not be wired to the *absolute* functor `PicSharp.presheaf`.

## Main results

* `picSharp` — the relative Picard functor `Pic^♯_{C/k}`.
* `divFunctor` — the relative-divisor functor `Scheme.DivFunctor C.hom` of
  `Picard/DivFunctorDef.lean` (Kleiman §3 Def. `df:div`, invertible-kernel
  quotient encoding).
* `PicScheme`, `representable`, `instPicSharpRepresentable` — the representing
  scheme and the natural bijection
  `(T ⟶ Pic_{C/k}) ≃ Pic(C ×_k T)/π_T^* Pic(T)` it induces.
* `instPicSchemeLocallyOfFiniteType`, `isSeparated` — `Pic_{C/k}` is locally
  of finite type and separated over `k` (Kleiman §4 Thm `th:main`(1): it is a
  disjoint union of open quasi-projective `k`-subschemes).
* `groupSchemeStructure` — `Pic_{C/k}` is a commutative `k`-group scheme, by
  Yoneda transport (`CommGrpObj.ofRepresentableBy`) of the abelian-group
  structure of `PicSharp.relPresheaf`.
* `abelMapWitness`, `abelMap`, `abelMap_app_mk` — the Abel map
  `Div_{C/k} ⟶ Pic^♯_{C/k}`, `[D] ↦ [O(D)] = -[ker q]` (Kleiman §3
  Def. `dfn:Abel`), assembled as `abelKernelNatTrans C ≫ picNeg C`.
* `smoothProperQuotient` — the Altman–Kleiman quotient lemma (Kleiman §4
  Lem. `lm:qt`), relative to the use-site hypothesis class
  `HasSmoothProperQuotient`.

## Remaining obligations

One statement in this file is still `sorry`: `instHasPicScheme`, the existence
of a scheme that represents `picSharp C` and is separated and locally of
finite type over `k`, given a rational point. Mathematically this is Kleiman
§4 Thm `th:main`(1) together with Cor `cor:algsch`, transported through §2
Thm 2.5. Everything else here — in particular representability of the chosen
scheme, its local finiteness, its separatedness, and its group-scheme
structure — is derived from that one existence statement.

`smoothProperQuotient` is stated against an explicit hypothesis class rather
than proved outright, because the hypothesis list expressible here is weaker
than Kleiman §4 Lem. `lm:qt`: it omits quasi-projectivity of the representing
scheme `Y`, for which Mathlib has no vocabulary at the pinned revision.
Without that hypothesis the statement is false — a Hironaka-type free
`ℤ/2`-action on a smooth proper non-projective 3-fold gives a smooth proper
equivalence relation whose quotient étale sheaf is an algebraic space that is
not a scheme. The class must therefore be supplied at the use site, where
quasi-projectivity of the Abel-map slice is available.

## References

Blueprint: `blueprint/src/chapters/Picard_FGAPicRepresentability.tex`.
Kleiman, "The Picard scheme" (arXiv:math/0504020): §2 Thm 2.5
(`th:comp` comparison under a section), §3 Def `dfn:Abel` + Thm `th:repDiv`,
§4 Thm `th:main` + Cor `cor:algsch` + Lem `lm:qt`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

/-- **`C` has a `k`-rational point**: the structural morphism `C.hom` admits a
section `σ : Spec k ⟶ C.left`. For the smooth proper geometrically integral
curves of this project this is the pointing `P : 𝟙_ (Over (Spec k)) ⟶ C`
already threaded through the Albanese statements (`AlgebraicJacobian.IsAlbanese`).

This is the hypothesis of Kleiman §2 **Thm 2.5**: together with
`O_S = f_* O_X` universally (automatic for proper geometrically integral
fibers), a section forces the comparison maps
`Pic_{X/S}(T) → Pic_{(X/S)ét}(T) → Pic_{(X/S)fppf}(T)` to be bijective, so
the *plain* relative Picard functor is already the étale sheaf that FGA
representability (Kleiman §4) represents. -/
class HasRationalPoint {k : Type u} [Field k] (C : Over (Spec (.of k))) : Prop where
  nonempty_section :
    Nonempty {σ : Spec (.of k) ⟶ C.left // σ ≫ C.hom = 𝟙 (Spec (.of k))}

namespace PicScheme

/-! ## §0. The relative Picard functor and the divisor functor

`picSharp` is the honest relative Picard functor of sibling
`Picard/RelPicFunctor.lean` (Kleiman §2 Def `df:Pfs`), with the group
structure forgotten (representability is a statement about the underlying
set-valued functor; the group structure is transported back onto the
representing scheme by `groupSchemeStructure` below).

`divFunctor` (the relative-effective-divisor functor `Div_{C/k}`, Kleiman §3
Def `df:div`) is the functor `Scheme.DivFunctor C.hom` of sibling
`Picard/DivFunctorDef.lean`. -/

/-- **The relative Picard functor** `Pic^♯_{C/k} : (Sch/k)^op ⥤ Type (u+1)`,
`T ↦ Pic(C ×_k T)/π_T^* Pic(T)` — the set-valued shadow of the group-valued
presheaf `PicSharp.relPresheaf` of `Picard/RelPicFunctor.lean` (the honest
`H_T`-coset carrier of Kleiman §2 Def `df:Pfs`).

Universe note: the values live in `Type (u+1)` because the line-bundle
carrier `LineBundle.OnProduct` is a quotient of (large) sheaves of modules.
`Functor.RepresentableBy` is universe-polymorphic, so representability by a
(`Type u`-homed) scheme remains a well-formed — and, under a rational point,
true — statement. -/
noncomputable def picSharp {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    (Over (Spec (.of k)))ᵒᵖ ⥤ Type (u+1) :=
  PicSharp.relPresheaf C ⋙ CategoryTheory.forget AddCommGrpCat.{u+1}

/-- Typeclass asserting existence of the relative-divisor functor `Div_{C/k}`.
The instance `instHasDivFunctor` below discharges it, with witness
`divFunctor C = DivFunctor C.hom`; the class survives as the blueprint-pinned
existence carrier (`def:has_div_functor`).

**Vacuity warning.** The field
`has_div_functor : Nonempty ((Over (Spec (.of k)))ᵒᵖ ⥤ Type (u+1))` does not
mention `C` at all: any functor (e.g. a constant functor) witnesses it, so
the class is vacuously true and carries no mathematical content. It must
never be cited as evidence that the relative-divisor functor of `C` exists —
use `Scheme.DivFunctor C.hom` (`Picard/DivFunctorDef.lean`) directly, as
`divFunctor` below does. -/
class HasDivFunctor {k : Type u} [Field k] (C : Over (Spec (.of k))) : Prop where
  has_div_functor : Nonempty ((Over (Spec (.of k)))ᵒᵖ ⥤ Type (u+1))

/-- **The relative-divisor functor** `Div_{C/k} : (Sch/k)^op ⥤ Type (u+1)`,
sending a `k`-scheme `T` to the set of relative effective Cartier divisors on
`C ×_k T` flat over `T` (Kleiman §3 Def. `df:div`).

It is defined as

```
divFunctor C := Scheme.DivFunctor C.hom
```

with `Scheme.DivFunctor` from sibling `Picard/DivFunctorDef.lean`: `T`-flat
invertible-kernel quotients of `O_{C ×_k T}` modulo `ker q = ker q'`, i.e.
Kleiman's set of relative effective divisors. The definition does not route
through the `HasDivFunctor` carrier class above. -/
noncomputable def divFunctor {k : Type u} [Field k]
    (C : Over (Spec (.of k))) :
    (Over (Spec (.of k)))ᵒᵖ ⥤ Type (u+1) :=
  DivFunctor C.hom

/-- Existence instance for `HasDivFunctor`: the relative-divisor functor
`divFunctor C = Scheme.DivFunctor C.hom` witnesses the existential. -/
instance instHasDivFunctor {k : Type u} [Field k]
    (C : Over (Spec (.of k))) : HasDivFunctor C :=
  ⟨⟨divFunctor C⟩⟩

end PicScheme

/-! ## §1. The Picard scheme

The Picard scheme `Pic_{C/k}` of a smooth proper geometrically integral curve
`C/k` **with a `k`-rational point** is the `k`-scheme representing the
relative Picard functor `picSharp C` (which, under the rational point, agrees
with the étale-sheafified functor of Kleiman §4 Thm `th:main` by Kleiman §2
Thm 2.5). The scheme is separated, locally of finite type over `k`, and a
disjoint union of open quasi-projective `k`-subschemes; the
abelian-group-scheme structure is `groupSchemeStructure` below.

Blueprint reference: `def:pic_scheme` (Kleiman §4 Def. `df:Psch`). -/

/-- Typeclass asserting existence of a scheme over `Spec k` that represents
the relative Picard functor `picSharp C` and is **separated and locally of
finite type over `k`**. The instance below is the file's only `sorry`, and it
is **conditional on `[HasRationalPoint C]`** — without a section the plain
relative functor is not representable in general, so an unconditional instance
would assert a false statement. Consumers that quantify over `[HasPicScheme
C]` as a hypothesis remain kernel-clean.

Representability, local finiteness and separatedness are bundled into a single
existential because Kleiman §4 Thm `th:main`(1) delivers them as one package:
`Pic_{C/k}` is a separated scheme locally of finite type over `k`, a disjoint
union of open quasi-projective `k`-subschemes. Bundling therefore adds no
strength beyond representability, and lets the carriers
`PicScheme.instPicSchemeLocallyOfFiniteType` and `PicScheme.isSeparated` be
obtained by extraction. -/
class HasPicScheme {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] : Prop where
  has_pic_scheme : ∃ (X : Over (Spec (.of k))),
    Nonempty ((PicScheme.picSharp C).RepresentableBy X) ∧
      LocallyOfFiniteType X.hom ∧ IsSeparated X.hom

/-- The **Picard scheme** `Pic_{C/k}` of a smooth proper geometrically
integral curve `C/k`, encoded as an object of `Over (Spec (.of k))`.

Extracted (`Classical.choose`) from the `HasPicScheme` existence field, so it
carries the identity "this scheme represents the relative Picard functor
`picSharp C`" through `representable` below — a natural bijection onto
`Pic(C ×_k T)/π_T^* Pic(T)`. -/
noncomputable def PicScheme {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] :
    Over (Spec (.of k)) :=
  (HasPicScheme.has_pic_scheme (C := C)).choose

/-- Existence instance for `HasPicScheme` — the **one unproved statement of
this file**. Mathematical content: Kleiman §4 Thm `th:main` + Cor
`cor:algsch` (the étale-sheafified relative Picard functor of a smooth proper
geometrically integral curve is representable by a separated `k`-scheme
locally of finite type, a disjoint union of open quasi-projective
`k`-subschemes), combined with Kleiman §2 Thm 2.5 (under the `k`-rational
point of `[HasRationalPoint C]`, the plain relative functor `picSharp C`
coincides with the étale-sheafified one, so the same scheme represents it).
All three conjuncts of the existential — representability, local finiteness,
separatedness — are parts of that one Kleiman theorem.

The conditionality on `[HasRationalPoint C]` is essential for truth: without
a section, `Pic(C ×_k T)/π_T^* Pic(T)` need not even be a Zariski sheaf. -/
noncomputable instance instHasPicScheme {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasRationalPoint C] : HasPicScheme C :=
  ⟨sorry⟩

namespace PicScheme

/-! ## §2. The Abel map — line-bundle / Quot correspondence

The bridge from line bundles on `C ×_k T` to the Quot scheme is the **Abel
map**: a relative effective divisor `D ⊆ C ×_k T` over `T` determines a
`T`-point of `Div_{C/k}`, and the dual ideal sheaf
`O_{C ×_k T}(D) := I_D⁻¹` represents a class in `Pic^♯_{C/k}(T)`.

Blueprint reference: `lem:line_bundle_quot_correspondence` (Kleiman §3
Def. `dfn:Abel` + Thm. `th:repDiv`). -/

/-! ### The Abel map

The class `HasAbelMap` carries the map itself (a data field `abel`), so that
`abelMap` has the defining property `abelMap_app_mk` below; the instance
supplies the explicit natural transformation `abelMapWitness C`.

Construction of `abelMapWitness C : Div_{C/k} ⟶ Pic^♯_{C/k}`, `[D] ↦ [O(D)]`:
a relative effective divisor family `⟨F, q⟩` on `C ×_k T` has invertible ideal
`I_D = ker q`; the Abel map sends its class to
`[O(D)] = [I_D⁻¹] = -[I_D]`, the additive inverse (in the group-valued target
`Pic^♯_{C/k}(T)`) of the class of the ideal sheaf.  It is assembled as the
composite `abelKernelNatTrans C ≫ picNeg C`, where `abelKernelNatTrans` is the
substantive `[D] ↦ [I_D]` transformation and `picNeg` is the (natural)
negation on the group-valued functor.

Naturality of `abelKernelNatTrans` is the mathematical heart: for a test map
`g : T' ⟶ T` the base-change square is cartesian (`quotBaseSquare`), and the
**kernel–pullback comparison** `g_C^*(ker q) ⟶ ker(g_C^* q)` is an isomorphism
under the divisor conditions (`Modules.isIso_pullbackKernelComparison`, whose
side hypotheses — epi `q`, quasi-coherent source, finitely-presented `F`,
`T`-flat `F`, invertible kernel — are exactly the fields of `DivFamily`), so
`ker` commutes with base change and the class `[ker q]` is natural.  Negation
is natural because `Pic^♯`'s pullback maps are group homomorphisms.

The `dual` route (`Modules.dual (ker q)` as an explicit inverse) is available
for the *object-level* invertibility (`dual_isLocallyTrivial`) but is not used
here: the group-inverse `-[ker q]` is the canonical `[I_D⁻¹]` and makes
naturality rest only on the kernel–pullback comparison, avoiding the
not-yet-formalised sheaf-level dual-pullback commutation.

Blueprint reference: `lem:line_bundle_quot_correspondence` (Kleiman §3
Def. `dfn:Abel`); this instance is the **natural-transformation half** — `Div`
representability (Kleiman §3 Thm. `th:repDiv`) is NOT claimed here. -/

/-- Well-definedness of the ideal-class assignment `⟨F, q⟩ ↦ [ker q]` on the
divisor equivalence relation `DivFamily.Rel`: an equivalence `f : x.F ≅ y.F`
with `x.q ≫ f.hom = y.q` gives `ker x.q ≅ ker y.q` (`kernelCompMono` at the
iso `f.hom`), hence equal `H_T`-coset classes (`relPicRel_of_iso`). -/
private theorem abelKernel_welldef {k : Type u} [Field k] (C : Over (Spec (.of k)))
    (T : (Over (Spec (.of k)))ᵒᵖ) {x y : DivFamily C.hom T.unop} (h : x.Rel y) :
    Quotient.mk (PicSharp.relPicSetoid C.hom T.unop.hom)
        (⟨kernel x.q, x.kerLocallyTrivial⟩ : LineBundle.OnProduct C.hom T.unop.hom) =
      Quotient.mk (PicSharp.relPicSetoid C.hom T.unop.hom)
        (⟨kernel y.q, y.kerLocallyTrivial⟩ : LineBundle.OnProduct C.hom T.unop.hom) := by
  obtain ⟨f, hf⟩ := h
  exact Quotient.sound (PicSharp.relPicRel_of_iso
    ⟨(kernelCompMono x.q f.hom).symm ≪≫ Limits.kernelIsoOfEq hf⟩)

/-- **Kernel commutes with base change for a divisor family** (the mathematical
heart of Abel-map naturality).  For a test map `g : T ⟶ T'` and a divisor family
`x` over `T`, the ideal of the pulled-back family is the pullback of the ideal:
`ker((g_C^* x).q) ≅ g_C^*(ker x.q)`.  Proof: `(pullbackAlong g.unop x).q` is
`triangleIso.inv ≫ g_C^*(x.q)`, so its kernel agrees with `ker(g_C^* x.q)`
(`kernelIsIsoComp`, precomposition by the iso `triangleIso.inv`); the
**kernel–pullback comparison** `g_C^*(ker q) ⟶ ker(g_C^* q)` is an isomorphism
under the divisor conditions (`Modules.isIso_pullbackKernelComparison`, whose
side hypotheses are exactly the `DivFamily` fields `epi`, quasi-coherent source,
`isFinitePresentation`, `flat`, `kerLocallyTrivial` over the cartesian
`quotBaseSquare`). -/
private noncomputable def abelKernelBaseChangeIso {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    {T T' : (Over (Spec (.of k)))ᵒᵖ} (g : T ⟶ T') (x : DivFamily C.hom T.unop) :
    kernel ((DivFamily.pullbackAlong g.unop x).q) ≅
      (Scheme.Modules.pullback (quotBaseMap C.hom g.unop)).obj (kernel x.q) := by
  haveI hiso : IsIso (Modules.pullbackKernelComparison (quotBaseMap C.hom g.unop) x.q) :=
    Modules.isIso_pullbackKernelComparison (quotBaseSquare C.hom g.unop) x.q x.epi
      (pullback_isQuasicoherent_hom (pullback.fst C.hom T.unop.hom)
        (SheafOfModules.unit C.left.ringCatSheaf) inferInstance)
      x.isFinitePresentation x.flat x.kerLocallyTrivial
  exact kernelIsIsoComp
      (pullbackTriangleIso (quotBaseMap_fst C.hom g.unop)
        (SheafOfModules.unit C.left.ringCatSheaf)).inv
      ((Scheme.Modules.pullback (quotBaseMap C.hom g.unop)).map x.q) ≪≫
    (asIso (Modules.pullbackKernelComparison (quotBaseMap C.hom g.unop) x.q)).symm

/-- **The ideal-class transformation** `[D] ↦ [I_D] = [ker q]`
(`Div_{C/k} ⟶ Pic^♯_{C/k}`), the additive negative of the Abel map.  On
objects it is `⟦⟨F, q⟩⟧ ↦ ⟦ker q⟧`; naturality is the invertible
kernel–pullback comparison over the cartesian base-change square
(`abelKernelBaseChangeIso`, fed by the `DivFamily` fields).  Well-definedness on
`DivFamily.Rel` is `abelKernel_welldef`. -/
noncomputable def abelKernelNatTrans {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    divFunctor C ⟶ picSharp C where
  app T := TypeCat.ofHom (Quotient.lift
    (fun x : DivFamily C.hom T.unop =>
      Quotient.mk (PicSharp.relPicSetoid C.hom T.unop.hom)
        (⟨kernel x.q, x.kerLocallyTrivial⟩ : LineBundle.OnProduct C.hom T.unop.hom))
    (fun _ _ h => abelKernel_welldef C T h))
  naturality {T T'} g := by
    ext a
    induction a using Quotient.ind with | _ x => ?_
    apply Quotient.sound
    apply PicSharp.relPicRel_of_iso
    exact ⟨abelKernelBaseChangeIso C g x⟩

/-- **Negation on the group-valued relative Picard presheaf**
`PicSharp.relPresheaf C ⟶ PicSharp.relPresheaf C`.  Pointwise it is the group
homomorphism `a ↦ -a` (`-AddMonoidHom.id`, valid since `Pic^♯_{C/k}(T)` is
abelian); naturality is `map_neg` of the group-homomorphism pullback maps of
`Pic^♯` (`PicSharp.relFunctorial`).  Building the negation at the
`AddCommGrpCat`-valued level (rather than on the forgotten set-valued
`picSharp`) keeps the group structure directly available — the forget-composite
`(picSharp C).obj T` does not expose its `AddGroup` to instance search. -/
noncomputable def relPresheafNeg {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    PicSharp.relPresheaf C ⟶ PicSharp.relPresheaf C where
  app T := AddCommGrpCat.ofHom (-AddMonoidHom.id _)
  naturality {T T'} g := by
    ext a
    exact (map_neg (PicSharp.relFunctorial C.hom T.unop.hom T'.unop.hom
      g.unop.left (Over.w g.unop).symm) a).symm

/-- **Negation on the relative Picard functor**, as a natural transformation
`Pic^♯_{C/k} ⟶ Pic^♯_{C/k}`.  Pointwise it is `a ↦ -a` in the group
`Pic^♯_{C/k}(T)`; it is the set-valued shadow (`whiskerRight … (forget _)`) of
the group-presheaf negation `relPresheafNeg`, so its naturality is inherited
for free. -/
noncomputable def picNeg {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    picSharp C ⟶ picSharp C :=
  Functor.whiskerRight (relPresheafNeg C) (CategoryTheory.forget AddCommGrpCat.{u+1})

/-- **The Abel map witness** `A_{C/k} : Div_{C/k} ⟶ Pic^♯_{C/k}`,
`[D] ↦ [O(D)] = [I_D⁻¹] = -[ker q]`, the substantive natural transformation
underlying the line-bundle / Quot correspondence (Kleiman §3 Def. `dfn:Abel`).
Assembled as `abelKernelNatTrans C ≫ picNeg C`. -/
noncomputable def abelMapWitness {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    divFunctor C ⟶ picSharp C :=
  abelKernelNatTrans C ≫ picNeg C

/-- Class **carrying the Abel map** `Div_{C/k} ⟶ Pic^♯_{C/k}`.  It is a
data-carrying class with field `abel`, so `abelMap := HasAbelMap.abel`
inherits the concrete construction and the defining property
`abelMap_app_mk`.  The instance `instHasAbelMap` supplies the witness
`abelMapWitness C`. -/
class HasAbelMap {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] where
  /-- The Abel map itself (data). -/
  abel : divFunctor C ⟶ picSharp C

/-- The **Abel map** `A_{C/k} : Div_{C/k} ⟶ Pic^♯_{C/k}`, sending a relative
effective Cartier divisor `D ⊆ C ×_k T` over `T` to its associated invertible
sheaf `[O_{C ×_k T}(D)] = [I_D⁻¹]`.

It is the map carried by `HasAbelMap`; the instance `instHasAbelMap` fixes it
to `abelMapWitness C`, and its defining property is `abelMap_app_mk`. -/
noncomputable def abelMap {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasAbelMap C] :
    divFunctor C ⟶ picSharp C :=
  HasAbelMap.abel

/-- Existence instance for `HasAbelMap`: the Abel map `abelMapWitness C`
witnesses the carrier. -/
noncomputable instance instHasAbelMap {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] : HasAbelMap C :=
  ⟨abelMapWitness C⟩

/-- **Defining property of the Abel map** (Kleiman §3 Def. `dfn:Abel`): on the
class of a relative divisor family `⟨F, q⟩` it returns `[O(D)] = [I_D⁻¹]`, the
additive inverse of the class of the ideal sheaf `I_D = ker q`. -/
theorem abelMap_app_mk {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom]
    (T : (Over (Spec (.of k)))ᵒᵖ) (x : DivFamily C.hom T.unop) :
    (abelMap C).app T (Quotient.mk (DivFamily.setoid C.hom T.unop) x) =
      - Quotient.mk (PicSharp.relPicSetoid C.hom T.unop.hom)
        (⟨kernel x.q, x.kerLocallyTrivial⟩ : LineBundle.OnProduct C.hom T.unop.hom) := by
  rfl

/-! ## §3. The smooth-proper quotient lemma — Altman–Kleiman descent

The structural lemma underlying Step 4 of Kleiman §4 Thm. `th:main`: given a
surjection `α : Z ⟶ P` of étale sheaves with `R := Z ×_P Z` representable,
`Z` representable **by a quasi-projective scheme**, and the first projection
`R ⟶ Z` smooth and proper, the quotient `P` is representable.

The hypothesis list expressible here is strictly weaker than Kleiman §4 Lem
`lm:qt`: it lacks **quasi-projectivity of `Y`**, for which Mathlib has no
vocabulary at the pinned revision. Without it the statement is false: a
Hironaka-type free `ℤ/2`-action on a smooth proper non-projective 3-fold
gives a smooth proper equivalence relation satisfying hypotheses (1)–(4)
whose quotient étale sheaf is an algebraic space that is not a scheme. In
particular there is no global instance of `HasSmoothProperQuotient`; such an
instance would assert that every presheaf receiving any natural
transformation is representable.

`HasSmoothProperQuotient α` is therefore an **explicit use-site hypothesis**:
the intended consumer (the FGA assembly, Step 4 of `th:main`) instantiates it
for the Abel-map slice `Z ⟶ P^{φ_0}_0`, where `Z` is a quasi-projective open
of `Div_{C/k}` and Altman–Kleiman descent genuinely applies. Supplying that
instance is part of the `instHasPicScheme` obligation, not a standalone
global fact.

Blueprint reference: `lem:smooth_proper_quotient` (Kleiman §4 Lem. `lm:qt`). -/

/-- Hypothesis class packaging the CONCLUSION of the Altman–Kleiman
smooth-proper quotient lemma for a specific étale-sheaf surjection `α`:
that the target presheaf is representable.

There is deliberately no global instance: an unconditional one would be a
false statement (see the section header). The class is supplied at the use
site, where the Kleiman `lm:qt` hypotheses — including quasi-projectivity of
the representing scheme, which the `smoothProperQuotient` statement below
cannot express — actually hold.

The class is kept as the blueprint-pinned record of the Altman–Kleiman
`lm:qt` interface. A route to `instHasPicScheme` that takes only finite
Galois quotients with an orbit-in-affine hypothesis sidesteps the
Hironaka-type counterexample above, and so needs neither this class nor
`smoothProperQuotient`. -/
class HasSmoothProperQuotient {k : Type u} [Field k]
    {Z P : (Over (Spec (.of k)))ᵒᵖ ⥤ Type (u + 1)}
    (_α : Z ⟶ P) : Prop where
  is_representable : P.IsRepresentable

/-- **The smooth-proper quotient lemma — Altman–Kleiman descent of an
étale-sheaf surjection** (Kleiman §4 Lem. `lm:qt`).

Let `Z, P : (Sch/k)^op ⥤ Type (u+1)` be presheaves and `α : Z ⟶ P` a natural
transformation with: (1) `Z` representable by `Y`; (2) `R := Z ×_P Z`
representable by `R`; (3) the first projection `π : R ⟶ Y` smooth and proper;
(4) `α` an étale-local surjection (every `T`-point of `P` lifts along some
test morphism). Then, granting the use-site hypothesis
`[HasSmoothProperQuotient α]` (which additionally encodes Kleiman's
quasi-projectivity of `Y` — see the section header for why it cannot yet be
stated internally), `P` is representable.

The Lean body extracts the conclusion from the hypothesis class; the
mathematical content (Altman–Kleiman effective-equivalence-relation descent
+ EGA IV 8.11.5) lives at the use site supplying the instance. -/
theorem smoothProperQuotient {k : Type u} [Field k]
    {Z P : (Over (Spec (.of k)))ᵒᵖ ⥤ Type (u + 1)}
    (α : Z ⟶ P)
    (Y : Over (Spec (.of k)))
    (_hZ : Z.RepresentableBy Y)
    (R : Over (Spec (.of k)))
    (_hR : (Limits.pullback α α).RepresentableBy R)
    (π : R ⟶ Y)
    [Smooth π.left] [IsProper π.left]
    (_hα : ∀ ⦃T : (Over (Spec (.of k)))ᵒᵖ⦄ (p : P.obj T),
        ∃ (T' : (Over (Spec (.of k)))ᵒᵖ) (e : T ⟶ T') (z : Z.obj T'),
          α.app T' z = P.map e p)
    [HasSmoothProperQuotient α] :
    P.IsRepresentable :=
  HasSmoothProperQuotient.is_representable (_α := α)

/-! ## §4. The FGA representability theorem

Grothendieck's existence theorem for the Picard scheme (Kleiman §4 Thm.
`th:main`, specialised via Cor. `cor:algsch` to `S = Spec k`, `X = C`),
transported through Kleiman §2 Thm 2.5 to the plain relative functor under
the rational-point hypothesis: `picSharp C` is representable by `PicScheme C`.

Blueprint reference: `thm:fga_pic_representability`. -/

/-- Typeclass asserting that `picSharp C` is representable by `PicScheme C`.

It follows from `HasPicScheme` — the representing witness is
`Classical.choose`-extracted, so its `choose_spec` is exactly this statement.
The class survives to preserve the blueprint-pinned consumer signature of
`representable`. -/
class PicSharpRepresentable {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] : Prop where
  has_representable : Nonempty ((picSharp C).RepresentableBy (PicScheme C))

/-- Existence instance for `PicSharpRepresentable`: `PicScheme C` is
`Classical.choose` of the `HasPicScheme` existential, and the first component
of `Exists.choose_spec` says precisely that the chosen scheme represents
`picSharp C` (the remaining components are local finiteness and
separatedness). The FGA content lives upstream in `instHasPicScheme`. -/
instance instPicSharpRepresentable {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] : PicSharpRepresentable C :=
  ⟨(HasPicScheme.has_pic_scheme (C := C)).choose_spec.1⟩

/-- **FGA representability of the Picard scheme.**

Let `k` be a field and `C` a smooth proper geometrically integral curve over
`k` (with, through the `HasPicScheme` hypothesis chain, a `k`-rational
point). Then the relative Picard functor `Pic^♯_{C/k}` is representable by
the Picard scheme `PicScheme C`: there is a natural bijection

```
(T ⟶ Pic_{C/k}) ≃ Pic(C ×_k T)/π_T^* Pic(T)
```

for every `k`-scheme `T`. This `RepresentableBy` structure is a comparison
against the relative Picard functor itself, so downstream consumers
(tangent-space computation at the identity, `Pic⁰` degree theory) can compose
with its `homEquiv` to transfer line-bundle data to scheme points. -/
noncomputable def representable {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] [PicSharpRepresentable C] :
    (picSharp C).RepresentableBy (PicScheme C) :=
  Classical.choice (PicSharpRepresentable.has_representable (C := C))

/-! ## §5. The abelian group-scheme structure

The Picard scheme `Pic_{C/k}` inherits an abelian group-scheme structure from
the tensor product of invertible sheaves on `C ×_k T`: the relative Picard
presheaf is group-valued (`PicSharp.relPresheaf`), and a representing object
of (the set-valued shadow of) a group-valued presheaf is canonically a group
object, by Yoneda transport (`GrpObj.ofRepresentableBy`).

Since `picSharp` is by definition `relPresheaf ⋙ forget`, the transport
applies directly.

Blueprint reference: `thm:pic_is_group_scheme` (Kleiman §2 Def. `df:Pfs` +
§4 Def. `df:Psch`). -/

/-- The multiplicative (`CommGrpCat`-valued) avatar of the relative Picard
presheaf, used to feed `GrpObj.ofRepresentableBy` (whose API is
multiplicative). Carrier-level it is the same functor: `Multiplicative` is a
type synonym. -/
noncomputable def picSharpCommGrp {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u+1} :=
  PicSharp.relPresheaf C ⋙ AddCommGrpCat.toCommGrp

/-- The set-valued shadows of `picSharpCommGrp` and `picSharp` agree up to
the canonical `Multiplicative.ofAdd` bijection (a natural isomorphism, since
`Multiplicative` is carrier-preserving). -/
noncomputable def picSharpCommGrpForgetIso {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    picSharp C ≅ picSharpCommGrp C ⋙ CategoryTheory.forget CommGrpCat.{u+1} :=
  NatIso.ofComponents
    (fun T => Equiv.toIso (Multiplicative.ofAdd
      (α := ((PicSharp.relPresheaf C).obj T : Type (u+1)))))
    (fun _ => rfl)

/-- **The Picard scheme is a commutative `k`-group scheme** — a canonical
`CommGrpObj` structure (i.e. `GrpObj` + `IsCommMonObj`) on `PicScheme C`,
obtained by Yoneda transport (`CommGrpObj.ofRepresentableBy`) of the
abelian-group structure of the relative Picard presheaf
`PicSharp.relPresheaf` along the representability witness `representable C`.
Concretely: `[L] + [M] = [L ⊗ M]`, `-[L] = [L⁻¹]`, unit `[O_{C ×_k T}]`,
transported through `(T ⟶ Pic_{C/k}) ≃ Pic(C ×_k T)/π_T^* Pic(T)`.

Commutativity comes for free from the transport, so this is the full
abelian-group-scheme statement of the blueprint
(`thm:pic_is_group_scheme`). -/
noncomputable instance groupSchemeStructure {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] :
    CommGrpObj (PicScheme C) :=
  CommGrpObj.ofRepresentableBy (PicScheme C) (picSharpCommGrp C)
    ((representable C).ofIso (picSharpCommGrpForgetIso C))

/-! ## §6. Local finiteness of the Picard scheme

Kleiman §4 Thm `th:main`(1): the Picard scheme is separated and locally of
finite type over the base. `HasPicScheme` packages local finiteness together
with the representability existential (one existence package, as in Kleiman's
theorem), so the carrier below is obtained by extraction. It is what the
identity-component substrate (`Picard/IdentityComponent.lean`,
`GroupScheme.IdentityComponent`) consumes to specialise to
`G = PicScheme C`. -/

/-- Typeclass asserting that the structural morphism of the Picard scheme is
locally of finite type (Kleiman §4 Thm `th:main`(1): `Pic_{C/k}` is a
disjoint union of open quasi-projective `k`-subschemes, hence locally of
finite type). The `HasPicScheme` existential carries local finiteness, so the
property of the `Classical.choose` witness is its second `choose_spec`
component; the class survives to preserve the blueprint-pinned consumer
signature. -/
class PicSchemeLocallyOfFiniteType {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] : Prop where
  locallyOfFiniteType : LocallyOfFiniteType (PicScheme C).hom

/-- Existence instance for `PicSchemeLocallyOfFiniteType`: Kleiman §4 Thm
`th:main`(1) makes local finiteness part of the same existence package as
representability, so the `HasPicScheme` existential carries it and the
property of the chosen witness is the second component of its `choose_spec`.
The instance hypothesis is `[HasPicScheme C]` rather than
`[HasRationalPoint C]`: the rational-point conditionality lives entirely in
`instHasPicScheme` (which supplies `HasPicScheme C`), and any consumer able
to name `PicScheme C` already quantifies over `[HasPicScheme C]`. -/
instance instPicSchemeLocallyOfFiniteType {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] :
    PicSchemeLocallyOfFiniteType C :=
  ⟨(HasPicScheme.has_pic_scheme (C := C)).choose_spec.2.1⟩

/-- Projection of `PicSchemeLocallyOfFiniteType` to the Mathlib morphism
property, so that instance search finds `LocallyOfFiniteType (PicScheme
C).hom` whenever the carrier class is in scope (as the identity-component
substrate requires). -/
instance {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicSchemeLocallyOfFiniteType C] :
    LocallyOfFiniteType (PicScheme C).hom :=
  PicSchemeLocallyOfFiniteType.locallyOfFiniteType

/-- **`Pic_{C/k}` is separated over `k`.**

Kleiman §4 Thm `th:main` packages separatedness together with representability
and local finite type for `Pic_{C/k}` ("Then `Pic_{X/k}` is separated, ..."):
one existence package, as in the theorem. As with
`instPicSchemeLocallyOfFiniteType`, we extract this property from the
strengthened `HasPicScheme.has_pic_scheme` existential — its third
component — so downstream files (`Picard/Pic0AbelianVariety.lean`) can consume
`IsSeparated (PicScheme C).hom` as a normal instance without opening the axiom
layer. The conditionality on `[HasRationalPoint C]` lives entirely upstream in
`instHasPicScheme` (which supplies `HasPicScheme C`); this extraction only
names `[HasPicScheme C]`, as every consumer able to name `PicScheme C`
already does. -/
instance isSeparated {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] :
    IsSeparated (PicScheme C).hom :=
  (HasPicScheme.has_pic_scheme (C := C)).choose_spec.2.2

end PicScheme

end Scheme

end AlgebraicGeometry
