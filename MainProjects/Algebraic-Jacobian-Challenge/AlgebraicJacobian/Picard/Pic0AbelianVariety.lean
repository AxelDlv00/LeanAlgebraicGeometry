/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Picard.IdentityComponent
import AlgebraicJacobian.Picard.TangentSpaceDualNumbers
import AlgebraicJacobian.Picard.TangentSpaceIdentitySection
import AlgebraicJacobian.Picard.Pic0TangentSpace
import AlgebraicJacobian.Picard.Pic0DualNumberCocycle
import AlgebraicJacobian.RiemannRoch.Adelic.GenusUnconditional
import AlgebraicJacobian.Genus

/-!
# `Pic⁰_{C/k}` as an abelian variety (A.3.iii–vii)

This file is the **iter-193 Pic0AbelianVariety** file-skeleton (NEW lane,
blueprint-doctor flagged orphan resolution for the iter-192 plan-phase chapter
`Picard_Pic0AbelianVariety.tex`). It packages the strategy phase A.3.iii–vi
substrate and the A.3.vii assembly into the load-bearing Route~A statement
`Pic⁰_{C/k}` is an abelian variety, the gate of `thm:nonempty_jacobianWitness`
for `g(C) ≥ 1` curves.

The chapter consumes the abstract identity-component substrate set up in
`Picard/IdentityComponent.lean` (`Pic⁰_{C/k}` as a clopen subgroup scheme of
finite type, geometrically irreducible, formation commuting with base change)
and adds the curve-specific input: the tangent-space isomorphism
`T₀ Pic⁰_{C/k} ≅ H¹(C, 𝒪_C)`, the resulting smoothness of dimension `g` at
the origin (hence everywhere by translation), properness inherited from the
projectivity of `Pic⁰_{C/k}` for `C/k` geometrically normal, and the assembly
into an abelian variety in the sense of Milne §I.1.

## Status (run 0015, T16 W12-tangent session; previously run 0008 T5)

Proved sorry-free in this file: `grpObj` (the `GrpObj (Pic0Scheme C)`
structure, via `IdentityComponent.isSubgroupHomomorphism` +
`PicScheme.groupSchemeStructure`), `tangentSpaceCotangentDual`,
`geometricallyIrreducible` (specialisation of the sibling's
`isFiniteTypeGeometricallyIrreducible`, whose QC∧GeomIrred conjuncts were
closed in run 0009 — `IdentityComponent.lean`, Kleiman §5 Lem.~`lem:agps`(3)),
the `isAbelianVariety` assembly, and the moved
`Pic0Scheme.isAbelianVariety` (blueprint pin `thm:pic_zero_is_abelian_variety`).

Remaining `sorry` bodies: `finrank_cotangentSpace_eq_finrank_hModuleOne` —
the Kleiman §5 Thm 5.11 dimension identity
`dim_{κ(e)} m_e/m_e² = dim_k H¹(C, 𝒪_C)` at the identity section, the single
named sub-lemma `tangentSpaceIso` now consumes (run 0015 W12-tangent reduced
the pinned statement to it via `nonempty_cotangentSpaceAddEquiv_of_finrank_eq`
of `Picard/Pic0TangentSpace.lean`; wave-4 W12-finrank closed the
**representability leg** — `pointedDualNumberPoints_equiv_relPicKernel`,
`cotangentSpaceDual_equiv_relPicKernel` below, set-level both directions —
and landed the Mumford `ε ↦ aε` scaling substrate in
`Picard/Pic0DualNumberCocycle.lean`); the remaining content is the
truncated-exponential Čech-cocycle computation of the kernel (algebra-level
splitting in sibling `Picard/DualNumberUnits.lean`, Čech carrier bridge
`AffineCoverMVSquare.hModuleOneEquivH1Cok_curve`) together with its
`k`-(semi)linearity bookkeeping — and `smooth`, `proper`.

The 5 blueprint-pinned declarations are:

1. `AlgebraicGeometry.Scheme.Pic0.tangentSpaceIso` (theorem, A.3.iii) — the
   canonical isomorphism `T₀ Pic⁰_{C/k} ≅ H¹(C, 𝒪_C)` (Kleiman §5
   Thm.~`thm:tgtsp`). Packaged as an `AddEquiv` between the cotangent space
   `m_e/m_e²` at a `k`-rational identity-section point `e` and the project's
   first-cohomology `k`-module `Scheme.HModule k (Scheme.toModuleKSheaf C) 1`
   (from `Genus.lean`). The `k`-module structure on the cotangent space at a
   `k`-rational point is supplied as part of the existential bundle.
2. `AlgebraicGeometry.Scheme.Pic0.smooth` (theorem, A.3.iv) — `Pic⁰_{C/k}` is
   `Smooth` over `k`. Kleiman §5 Cor.~`cor:sm` + Cor.~`cor:ch0`
   (characteristic-zero) + Ex.~`ex:jac` (curve case).
3. `AlgebraicGeometry.Scheme.Pic0.proper` (theorem, A.3.v) — `Pic⁰_{C/k}` is
   `IsProper` over `k`. Kleiman §5 Thm.~`th:qpp&p` (projectivity upgrade for
   geometrically normal `C/k`).
4. `AlgebraicGeometry.Scheme.Pic0.geometricallyIrreducible` (theorem, A.3.vi)
   — `Pic⁰_{C/k}` is `GeometricallyIrreducible` over `k`. Specialisation of
   `IdentityComponent.isFiniteTypeGeometricallyIrreducible` (sibling) to
   `G = PicScheme C`. Kleiman §5 Prp.~`prp:pic0`.
5. `AlgebraicGeometry.Scheme.Pic0.isAbelianVariety` (theorem, A.3.vii) —
   `Pic⁰_{C/k}` is an abelian variety: `IsProper ∧ Smooth ∧
   GeometricallyIrreducible ∧ Nonempty (GrpObj _)`. Milne §I.1, p.~8
   (defining axioms) + Kleiman §5 Rmk.~`rmk:Jac`. Load-bearing A.3.vii gate
   of Route~A.

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof", each
pinned declaration carries a substantive, non-tautological type:

- `tangentSpaceIso C` — existentially quantifies over a `k`-rational
  identity-section point `e : Spec k ⟶ (Pic0Scheme C).left` and a `k`-module
  structure on the cotangent space `m_e/m_e²` (the `k`-module structure
  arising via the `k`-algebra structure on the stalk at a `k`-rational point;
  for the file-skeleton this Module instance is bundled as part of the Σ').
  Bundles an `AddEquiv` between the cotangent space and the
  `H¹(C, 𝒪_C)`-as-`k`-module. The body is iter-194+ work.
- `smooth C`, `proper C`, `geometricallyIrreducible C` — genuine `Prop`-valued
  statements on the structural morphism `(Pic0Scheme C).hom : Pic⁰_{C/k} ⟶
  Spec k`, not tautological.
- `isAbelianVariety C` — assembles the conjunction of the four
  abelian-variety properties (proper, smooth, geometrically irreducible,
  group-object structure); not vacuous because each conjunct is a genuine
  property/structure on the (typed-sorry) `Pic0Scheme C`.

## Coordination with `Pic0Scheme`

The underlying `k`-scheme `Pic⁰_{C/k}` is supplied by
`AlgebraicGeometry.Scheme.Pic0Scheme C` from sibling
`Picard/IdentityComponent.lean` (`def:pic_zero_subscheme` in the blueprint).
We do not redefine the underlying scheme here; the `Pic0` namespace below
collects the curve-specific abelian-variety facts about `Pic0Scheme C`.

## References

Blueprint: `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex`
(735 LOC, 5 pins). Sources:
- Kleiman, "The Picard scheme", §5, Thm.~`thm:tgtsp` (tangent space),
  Cor.~`cor:sm` + Cor.~`cor:ch0` (smoothness), Thm.~`th:qpp&p`
  (quasi-projectivity/projectivity), Prp.~`prp:pic0` (irreducibility),
  Rmk.~`rmk:Jac` (assembly to abelian scheme); arXiv:math/0504020.
- Milne, "Abelian Varieties" (course notes, 2008), §I.1, p.~8
  (definition of abelian variety) + Rmk. III.1.4(e) (dimension equals genus).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

/-! ## §1. The `Pic0` namespace

The blueprint chapter pins five Lean declarations under the
`AlgebraicGeometry.Scheme.Pic0` namespace. Their underlying scheme
`Pic⁰_{C/k}` is `Pic0Scheme C` from sibling `Picard/IdentityComponent.lean`;
the declarations below collect the curve-specific abelian-variety facts
about `Pic0Scheme C` (tangent space at the identity, smoothness, properness,
geometric irreducibility, abelian-variety assembly). -/

namespace Pic0

/-- **`Pic⁰_{C/k}` is a `k`-group scheme** — the group-object structure on
the identity component of the Picard scheme, inherited from `Pic_{C/k}` via
the clopen inclusion `Pic⁰_{C/k} ↪ Pic_{C/k}`.

Since `Pic0Scheme C` unwinds definitionally to
`GroupScheme.IdentityComponent (PicScheme C)` (run-0008 FGA rewire), this is
`GroupScheme.IdentityComponent.isSubgroupHomomorphism` applied to
`G = PicScheme C`, whose `GrpObj` instance is
`PicScheme.groupSchemeStructure` (Yoneda transport of the abelian-group
structure of the relative Picard presheaf) and whose local finiteness is the
`PicSchemeLocallyOfFiniteType` carrier (Kleiman §4 Thm `th:main`(1)). -/
theorem grpObj {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    Nonempty (GrpObj (Pic0Scheme C)) :=
  GroupScheme.IdentityComponent.isSubgroupHomomorphism (PicScheme C)

/-! ### §1b. Harvested helper lemmas (from GitHub PR #1, Alex Nguyen)

Sorry-free scheme-general and `Pic⁰_{C/k}`-specific helpers adapted from the
PR: the `k`-rationality residue-field identification, finite-dimensionality of
the cotangent space over a field, the pointed dual-number tangent-space API,
the separatedness / local-finite-type / quasi-compactness transports of the
identity-component substrate, and the fpqc-descent reduction of universal
closedness. Each `Pic⁰`-specific helper carries the file's standard instance
hypotheses `[HasPicScheme C] [PicScheme.PicSchemeLocallyOfFiniteType C]` (rather
than the PR's `haveI := instHasPicScheme C` pattern, which needs the absent
`[HasRationalPoint C]`), exactly as every other pinned declaration here. -/

/-- **Sorry-free, scheme-general.** A section `e : Spec k ⟶ X` of a scheme over
`Spec k` is a `k`-rational point, so the residue field at `e` is canonically
`k`. The section `e` and structure map `π` induce residue-field maps
`sbar : κ(e) → κ(pt)` and `pbar : κ(pt') → κ(e)` with
`pbar ≫ sbar = (e ≫ π).residueFieldMap default`, an iso because `e ≫ π = 𝟙`
is an open immersion; hence `sbar` is a split epi, and being a field
homomorphism it is a mono, so `sbar` is an isomorphism
(`isIso_of_mono_of_isSplitEpi`). The base residue-field identification is
discharged by composing `Scheme.Spec.residueFieldIso` with
`Ideal.algEquivResidueFieldOfField`. -/
theorem residueFieldIso_of_section_over_field {k : Type u} [Field k]
    (X : Over (Spec (.of k))) (e : Spec (.of k) ⟶ X.left)
    (hsec : e ≫ X.hom = 𝟙 (Spec (.of k))) :
    Nonempty (X.left.residueField (e.base default) ≅ CommRingCat.of k) := by
  set sbar := e.residueFieldMap default with hsbar
  set pbar := X.hom.residueFieldMap (e.base default) with hpbar
  have hc : (e ≫ X.hom).residueFieldMap default = pbar ≫ sbar :=
    residueFieldMap_comp e X.hom default
  haveI : IsOpenImmersion (e ≫ X.hom) := by rw [hsec]; infer_instance
  haveI : IsIso (pbar ≫ sbar) :=
    hc ▸ (inferInstance : IsIso ((e ≫ X.hom).residueFieldMap default))
  haveI : IsSplitEpi sbar :=
    ⟨⟨inv (pbar ≫ sbar) ≫ pbar, by rw [Category.assoc, IsIso.inv_hom_id]⟩⟩
  haveI : Mono sbar :=
    ConcreteCategory.mono_of_injective sbar sbar.hom.injective
  haveI : IsIso sbar := isIso_of_mono_of_isSplitEpi sbar
  obtain ⟨hbase⟩ : Nonempty ((Spec (.of k)).residueField default ≅ CommRingCat.of k) := by
    let x : Spec (.of k) := default
    refine ⟨Scheme.Spec.residueFieldIso (.of k) default ≪≫ ?_⟩
    exact
      ((Ideal.algEquivResidueFieldOfField (k := k) x.asIdeal).toRingEquiv.toCommRingCatIso).symm
  exact ⟨asIso sbar ≪≫ hbase⟩

/-- **Sorry-free, scheme-general.** For a scheme locally of finite type over a
field, the cotangent space at any point is finite-dimensional over the residue
field — the local-Noetherianity input dimension arguments need. -/
theorem finiteDimensional_cotangentSpace_of_locallyOfFiniteType {k : Type u} [Field k]
    (X : Over (Spec (.of k))) [LocallyOfFiniteType X.hom] (x : X.left) :
    FiniteDimensional (IsLocalRing.ResidueField (X.left.presheaf.stalk x))
      (IsLocalRing.CotangentSpace (X.left.presheaf.stalk x)) := by
  letI : IsLocallyNoetherian X.left := LocallyOfFiniteType.isLocallyNoetherian X.hom
  infer_instance

/-- **Pointed dual-number points of `X` at `e`, over `Spec k`.** The
`k[ε]`-valued points of `X` lying over the closed point of `Spec k[ε]` and
landing at `e`; the functor-of-points model of the Zariski tangent space at
`e`. A named restatement of the anonymous subtype
`overDualNumberSectionEquivCotangentSpaceDual` targets, kept for readability
at the call sites below. -/
def pointedDualNumberPoints {k : Type u} [Field k] (X : Over (Spec (.of k)))
    (e : Spec (.of k) ⟶ X.left) :=
  {g : Spec (CommRingCat.of (DualNumber k)) ⟶ X.left //
      g ≫ X.hom = Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k)))
        ∧ g.base (IsLocalRing.closedPoint (DualNumber k)) = e.base default}

/-- **Axiom-clean.** The `k`-rational identity-section point of `Pic⁰_{C/k}`:
the lift of the Picard scheme's identity section `MonObj.one` through the open
immersion `Pic⁰_{C/k} ↪ Pic_{C/k}`, i.e. the sibling's
`GroupScheme.identityComponentSection` specialised to `G = PicScheme C`
(transported along the definitional identification
`Pic0Scheme C = GroupScheme.IdentityComponent (PicScheme C)`). This is the
`e`-witness of the Σ'-bundle in `tangentSpaceIso`. -/
noncomputable def identitySection {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    Spec (.of k) ⟶ (Pic0Scheme C).left :=
  GroupScheme.identityComponentSection (PicScheme C)

/-- **Axiom-clean.** The identity-section point is a genuine section of the
structural morphism: `identitySection C ≫ (Pic0Scheme C).hom = 𝟙 (Spec k)`.
Transport of the sibling's `identityComponentSection_isSection`. -/
theorem identitySection_isSection {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    identitySection C ≫ (Pic0Scheme C).hom = 𝟙 (Spec (.of k)) :=
  GroupScheme.identityComponentSection_isSection (PicScheme C)

/-- **Axiom-clean.** The Stacks 0B28 dictionary at the identity point: pointed
dual-number points of `Pic⁰_{C/k}` at `e` biject with `κ(e)`-linear functionals
on the cotangent space `m_e/m_e²`. Direct specialisation of
`overDualNumberSectionEquivCotangentSpaceDual`
(`Picard/TangentSpaceIdentitySection.lean`) to `e = identitySection C`; the two
points `(identitySection C).base default` and
`(identitySection C).base (IsLocalRing.closedPoint k)` are bridged by
`Subsingleton (Spec k)`, the same idiom `tangentSpaceCotangentDual` uses. -/
theorem pointedDualNumberPoints_equiv_cotangentSpaceDual {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    Nonempty (pointedDualNumberPoints (Pic0Scheme C) (identitySection C) ≃
      Module.Dual
        (IsLocalRing.ResidueField
          ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default)))
        (IsLocalRing.CotangentSpace
          ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default)))) := by
  haveI : Subsingleton ↥(Spec (CommRingCat.of k)) :=
    inferInstanceAs (Subsingleton (PrimeSpectrum k))
  exact ⟨overDualNumberSectionEquivCotangentSpaceDual (Pic0Scheme C)
    (identitySection_isSection C) (congrArg _ (Subsingleton.elim _ _))⟩

/-- **Axiom-clean.** The tangent space of `Pic⁰_{C/k}` at the identity is the
tangent space of `Pic_{C/k}` there (leg-(1) connector of the Kleiman §5
Thm.~5.11 dimension identity): along the clopen inclusion
`ι : Pic⁰_{C/k} ↪ Pic_{C/k}` (an open immersion by the sibling's
`IdentityComponent.isOpenSubgroupScheme`), composition identifies the pointed
dual-number points at the identity section with those of the ambient Picard
scheme at its image — `Spec k[ε]` is a one-point scheme, so dual-number
points landing in the open subscheme lift uniquely
(`pointedDualNumberPointsEquivOfOpenImmersion`,
`Picard/Pic0TangentSpace.lean`). This lets the representability leg compute
`T_e Pic⁰` on `Pic_{C/k}` itself, where `picSharp`-representability applies. -/
theorem pointedDualNumberPoints_equiv_picScheme {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    Nonempty (Σ' (ι : Pic0Scheme C ⟶ PicScheme C),
      pointedDualNumberPoints (Pic0Scheme C) (identitySection C) ≃
        pointedDualNumberPoints (PicScheme C) (identitySection C ≫ ι.left)) := by
  obtain ⟨f, hopen, -⟩ :=
    GroupScheme.IdentityComponent.isOpenSubgroupScheme (PicScheme C)
  haveI := hopen
  exact ⟨⟨f, pointedDualNumberPointsEquivOfOpenImmersion f (identitySection C)⟩⟩

/-- **Axiom-clean (through the `HasPicScheme` gate).** The Kleiman §5
Thm.~5.11 **representability leg, applied**: the pointed dual-number points
of `Pic⁰_{C/k}` at the identity section — the Zariski tangent space
`T₀ Pic⁰_{C/k}` in functor-of-points form — biject with the **kernel** of the
restriction homomorphism

```
Pic^♯_{C/k}(Spec k[ε]) →+ Pic^♯_{C/k}(Spec k)
```

of the relative Picard presheaf along the `ε ↦ 0` point. Composite of

1. the open-immersion transport `T₀ Pic⁰ ≃ T₀ Pic` along the clopen inclusion
   `Pic⁰_{C/k} ↪ Pic_{C/k}` (`pointedDualNumberPointsEquivOfOpenImmersion`,
   `Picard/Pic0TangentSpace.lean`), and
2. the represented-functor kernel description
   (`pointedDualNumberPointsEquivAddKernel`,
   `Picard/Pic0DualNumberCocycle.lean`) at the FGA representability witness
   `PicScheme.representable C : picSharp C ≅ (T ⟶ Pic_{C/k})` — note
   `picSharp C` is *by definition* the set-valued shadow of the group-valued
   `PicSharp.relPresheaf C`, so the kernel of the group-valued restriction is
   meaningful.

⚠ This is a bijection of **sets** — it does not by itself transport `finrank`
(a bare `Equiv` does not determine dimension over an infinite field). The
`k`-linearity bookkeeping (Mumford's `a · [L_ε] := (ε ↦ aε)^* [L_ε]` module
structure, `overDualNumberScale` of `Picard/Pic0DualNumberCocycle.lean`)
remains with `finrank_cotangentSpace_eq_finrank_hModuleOne` below. -/
theorem pointedDualNumberPoints_equiv_relPicKernel {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    Nonempty (pointedDualNumberPoints (Pic0Scheme C) (identitySection C) ≃
      {a : (PicSharp.relPresheaf C).obj (Opposite.op (overDualNumber k)) //
        ((PicSharp.relPresheaf C).map (overDualNumberZero k).op).hom a = 0}) := by
  obtain ⟨f, hopen, -⟩ :=
    GroupScheme.IdentityComponent.isOpenSubgroupScheme (PicScheme C)
  haveI := hopen
  have he' : (identitySection C ≫ f.left) ≫ (PicScheme C).hom
      = 𝟙 (Spec (.of k)) :=
    (Category.assoc _ _ _).trans
      ((congrArg (fun t => identitySection C ≫ t) (Over.w f)).trans
        (identitySection_isSection C))
  exact ⟨(pointedDualNumberPointsEquivOfOpenImmersion f (identitySection C)).trans
    (pointedDualNumberPointsEquivAddKernel (PicScheme C)
      (PicSharp.relPresheaf C) (PicScheme.representable C) he')⟩

/-- **Axiom-clean (through the `HasPicScheme` gate).** The two proved halves
of Kleiman §5 Thm.~5.11 composed: the `κ(e)`-linear dual of the cotangent
space `m_e/m_e²` at the identity of `Pic⁰_{C/k}` bijects with the kernel of
`Pic^♯_{C/k}(Spec k[ε]) →+ Pic^♯_{C/k}(Spec k)` — the Stacks 0B28 dictionary
(`pointedDualNumberPoints_equiv_cotangentSpaceDual`) chained through the
tangent space with the representability leg
(`pointedDualNumberPoints_equiv_relPicKernel`). Same linearity caveat as the
latter: this is a bijection of sets. -/
theorem cotangentSpaceDual_equiv_relPicKernel {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    Nonempty (Module.Dual
        (IsLocalRing.ResidueField
          ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default)))
        (IsLocalRing.CotangentSpace
          ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default)))
      ≃ {a : (PicSharp.relPresheaf C).obj (Opposite.op (overDualNumber k)) //
          ((PicSharp.relPresheaf C).map (overDualNumberZero k).op).hom a = 0}) := by
  obtain ⟨φ⟩ := pointedDualNumberPoints_equiv_cotangentSpaceDual C
  obtain ⟨ψ⟩ := pointedDualNumberPoints_equiv_relPicKernel C
  exact ⟨φ.symm.trans ψ⟩

/-- **Sorry-free source (carries the FGA existential's `sorryAx`).** The Picard
scheme `Pic_{C/k}` is separated over `k`. Kleiman delivers this as part of the
§4 representability package ("Then `Pic_{X/k}` is separated, ..."); its home is
the strengthened `HasPicScheme` existential in `FGAPicRepresentability.lean`,
which now bundles `IsSeparated X.hom` as its third conjunct; this helper is the
direct `Classical.choose_spec` extraction (same content as the global
`PicScheme.isSeparated` instance) consumed by the `isSeparated` assembly. -/
theorem picScheme_isSeparated {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C] :
    IsSeparated (PicScheme C).hom :=
  (HasPicScheme.has_pic_scheme (C := C)).choose_spec.2.2

/-- **Axiom-clean.** Separatedness of `Pic⁰_{C/k}` over `k`: the structural
morphism factors as the clopen inclusion `Pic⁰_{C/k} ↪ Pic_{C/k}` (an open
immersion by the sibling's axiom-clean
`IdentityComponent.isOpenSubgroupScheme`, hence a monomorphism, hence
separated) followed by the separated `(PicScheme C).hom`
(`picScheme_isSeparated`); separatedness is stable under composition. This is
the `IsSeparated` conjunct of the pinned `proper`. -/
theorem isSeparated {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    IsSeparated (Pic0Scheme C).hom := by
  haveI : IsSeparated (PicScheme C).hom := picScheme_isSeparated C
  obtain ⟨⟨f, hopen, -⟩⟩ :=
    GroupScheme.IdentityComponent.isOpenSubgroupScheme (PicScheme C)
  haveI := hopen
  change IsSeparated (GroupScheme.IdentityComponent (PicScheme C)).hom
  rw [← Over.w f]
  infer_instance

/-- **Axiom-clean.** `Pic⁰_{C/k}` is locally of finite type over `k`: the first
(sorry-free) conjunct of the sibling's
`IdentityComponent.isFiniteTypeGeometricallyIrreducible`, transported along the
definitional identification. The `LocallyOfFiniteType` conjunct of the pinned
`proper`. -/
theorem locallyOfFiniteType {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    LocallyOfFiniteType (Pic0Scheme C).hom :=
  (GroupScheme.IdentityComponent.isFiniteTypeGeometricallyIrreducible
    (PicScheme C)).1

/-- **Closed.** `Pic⁰_{C/k}` is quasi-compact over `k`: the second conjunct of
the sibling's `IdentityComponent.isFiniteTypeGeometricallyIrreducible` (Kleiman
§5 Lem.~`lem:agps`~(3): `α(U × U) = G⁰` is the image of the affine, hence
quasi-compact, `U × U`), fully proved since run 0009. Not needed for the
`proper` assembly (Mathlib's `IsProper` derives quasi-compactness from
universal closedness) but recorded for the blueprint's finite-type chain. -/
theorem quasiCompact {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    QuasiCompact (Pic0Scheme C).hom :=
  (GroupScheme.IdentityComponent.isFiniteTypeGeometricallyIrreducible
    (PicScheme C)).2.1

/-- **Sorry-free.** Universal closedness of `Pic⁰_{C/k}` descends from its base
change to the algebraic closure `Spec k̄ → Spec k`. That base-change map is
faithfully flat and quasi-compact (a field extension `k → k̄` is injective and
flat, so `Spec.map` of it is surjective and flat; being a map of affines it is
quasi-compact), and `UniversallyClosed` is fpqc-local on the base (Stacks 02KS;
EGA IV₂ 2.6.4). The pinned Mathlib packages exactly this descent as the
`@[stacks 02KS]` instance
`descendsAlong_universallyClosed_surjective_inf_flat_inf_quasicompact`
(`Mathlib/AlgebraicGeometry/Morphisms/FlatDescent.lean`), so the closure is a
one-line `of_pullback_snd_of_descendsAlong` application — the same
`MorphismProperty` descent pattern `smooth_of_grpObj` uses, with the three
`Surjective`/`Flat`/`QuasiCompact` facts about `Spec.map (algebraMap k k̄)`
supplied by `inferInstance`. -/
theorem universallyClosed_of_baseChange {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (h : UniversallyClosed (pullback.snd (Pic0Scheme C).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k)))))) :
    UniversallyClosed (Pic0Scheme C).hom := by
  exact MorphismProperty.of_pullback_snd_of_descendsAlong
    (Q := @Surjective ⊓ @Flat ⊓ @QuasiCompact)
    ⟨⟨inferInstance, inferInstance⟩, inferInstance⟩ h

/-- **Dual-number points of `Pic⁰_{C/k}` at the identity are the cotangent
dual** (Kleiman §5 Thm.~`thm:tgtsp`, LHS). Given the `k`-group-scheme
structure on `Pic0Scheme C` (supplied by `Pic0.grpObj`), the identity section
`e : Spec k ⟶ Pic⁰_{C/k}` hits a `k`-rational point, and the over-`Spec k`
dual-number points of `Pic⁰_{C/k}` at `e` — the Zariski tangent space
`T₀ Pic⁰_{C/k}` in its functor-of-points form — form the `κ(e)`-linear dual
of the cotangent space `m_e/m_e²`.

This is the geometric half of `tangentSpaceIso`; composing with the
`H¹(C, 𝒪_C)`-identification of `Dual (m_e/m_e²)` (gated on the `AJC.picrep`
representability cone) closes `thm:pic0_tangent_space_iso`. -/
theorem tangentSpaceCotangentDual {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    Nonempty (Σ' (e : Spec (.of k) ⟶ (Pic0Scheme C).left),
      (e ≫ (Pic0Scheme C).hom = 𝟙 (Spec (.of k))) ×'
      ({g : Spec (CommRingCat.of (DualNumber k)) ⟶ (Pic0Scheme C).left //
          g ≫ (Pic0Scheme C).hom
              = Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k)))
            ∧ g.base (IsLocalRing.closedPoint (DualNumber k)) = e.base default} ≃
        Module.Dual
          (IsLocalRing.ResidueField ((Pic0Scheme C).left.presheaf.stalk (e.base default)))
          (IsLocalRing.CotangentSpace
            ((Pic0Scheme C).left.presheaf.stalk (e.base default))))) := by
  obtain ⟨i⟩ := grpObj C
  letI := i
  haveI : Subsingleton ↥(Spec (CommRingCat.of k)) :=
    inferInstanceAs (Subsingleton (PrimeSpectrum k))
  exact ⟨GroupScheme.identitySection (Pic0Scheme C),
    GroupScheme.identitySection_comp (Pic0Scheme C),
    overDualNumberSectionEquivCotangentSpaceDual (Pic0Scheme C)
      (GroupScheme.identitySection_comp (Pic0Scheme C))
      (congrArg _ (Subsingleton.elim _ _))⟩

/-- **The Kleiman §5 Thm 5.11 dimension identity**
`dim_{κ(e)} m_e/m_e² = dim_k H¹(C, 𝒪_C)` at the identity section of
`Pic⁰_{C/k}` — the single remaining `sorry` of the tangent-space keystone
`tangentSpaceIso` (wave-4 W12-finrank reduction; the former in-line sorry of
`tangentSpaceIso`, now the smallest named sub-lemma).

STATE OF THE REDUCTION (what is PROVED around this sorry):

* set-level, both directions:
  `Dual_{κ(e)}(m_e/m_e²) ≃ T₀ Pic⁰ ≃ T₀ Pic ≃
     ker(Pic^♯(Spec k[ε]) →+ Pic^♯(Spec k))`
  — `cotangentSpaceDual_equiv_relPicKernel` above (Stacks 0B28 dictionary +
  open-immersion transport + FGA representability leg);
* the Mumford `ε ↦ aε` scaling substrate on that kernel, with its
  multiplicative-monoid action laws (`overDualNumberScale`,
  `relPicKernelSMul`, `Picard/Pic0DualNumberCocycle.lean`);
* the truncated-exponential unit splitting `(R[ε])ˣ ≃* Rˣ × (R, +)` with its
  naturality (`Picard/DualNumberUnits.lean`);
* the Čech target `H¹(C, 𝒪_C) ≃ₗ[k] H1Cok` on any 2-affine cover
  (`AffineCoverMVSquare.hModuleOneEquivH1Cok_curve`,
  `RiemannRoch/Adelic/GenusUnconditional.lean`) and finite-dimensionality of
  both sides (`finiteDimensional_cotangentSpace_of_locallyOfFiniteType`,
  `instModuleFiniteHModuleOne`).

REMAINING MATHEMATICAL CONTENT (Kleiman §5, proof of Thm 5.11):

1. **Cocycle leg**: an invertible sheaf on `C ×_k Spec k[ε]`, restricted
   trivial along `ε ↦ 0`, is trivial on the two charts of a 2-affine cover
   (nilpotent thickening does not change the underlying space) and its
   transition unit lies in `(Γ(U₁ ⊓ U₂, 𝒪_C)[ε])ˣ` with constant term the
   transition of the reduction; the truncated exponential then identifies
   `ker(Pic(C_ε) → Pic(C))` with `Γ(U₁ ⊓ U₂, 𝒪_C)/(coboundaries) = H1Cok`,
   additively and `k`-equivariantly for the `ε ↦ aε` action.
2. **Linearity bookkeeping**: the composite of
   `cotangentSpaceDual_equiv_relPicKernel` with the leg-1 identification is
   `k`-semilinear along `κ(e) ≃+* k`
   (`residueFieldIso_of_section_over_field`), where the kernel carries the
   Mumford structure; equal `finrank` then follows from
   `finrank κ(e) Dual(V) = finrank κ(e) V` (`Subspace.dual_finrank_eq`) and
   `LinearEquiv.finrank_eq`-style transport.

Neither step weakens the pinned `tangentSpaceIso`; both are multi-session. -/
theorem finrank_cotangentSpace_eq_finrank_hModuleOne {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    Module.finrank
        (IsLocalRing.ResidueField
          ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default)))
        (IsLocalRing.CotangentSpace
          ((Pic0Scheme C).left.presheaf.stalk ((identitySection C).base default)))
      = Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1) := by
  sorry

/-- **Tangent space at the identity: `T₀ Pic⁰_{C/k} ≅ H¹(C, 𝒪_C)`.**

The Kleiman §5 Thm.~`thm:tgtsp` tangent-space isomorphism. For a smooth
proper geometrically integral curve `C/k`, the Zariski tangent space at the
identity of `Pic⁰_{C/k}` is canonically isomorphic to the first sheaf
cohomology `H¹(C, 𝒪_C)`.

In Lean (skeleton form): we bundle existentially over a `k`-rational
identity-section point `e : Spec k ⟶ (Pic0Scheme C).left` and a `k`-module
structure on the cotangent space `m_e/m_e²` (the natural `k`-module structure
arising from the `k`-algebra structure on the stalk at a `k`-rational point;
for the file-skeleton this instance is supplied via Σ' to avoid hard-coding
a global instance prematurely). The substantive content is an `AddEquiv`
between the cotangent space and the project's `H¹(C, 𝒪_C)` module
`Scheme.HModule k (Scheme.toModuleKSheaf C) 1`.

A k-LinearEquiv refinement (iter-194+) replaces the `AddEquiv` once the
`k`-module structure on the cotangent space is consistently threaded through
downstream consumers; the underlying additive group structure is enough for
the dimension corollary `dim_k T₀ Pic⁰ = dim_k H¹ = g(C)`.

REDUCED (run 0015, W12-tangent): via the proved reduction
`nonempty_cotangentSpaceAddEquiv_of_finrank_eq`
(`Picard/Pic0TangentSpace.lean`, dimension-count transport of bases along
`κ(e) ≃+* k`; inputs: `Pic0.locallyOfFiniteType`, `identitySection_isSection`,
and the genus-lane finiteness `instModuleFiniteHModuleOne` of
`RiemannRoch/Adelic/GenusUnconditional.lean`), the remaining `sorry` is
exactly the Kleiman §5 Thm 5.11 **dimension identity**
`dim_{κ(e)} m_e/m_e² = dim_k H¹(C, 𝒪_C)` at the identity section. Its
intended proof: (1) `dim_{κ(e)} m_e/m_e² = dim_{κ(e)} Dual(m_e/m_e²)` and the
dual is the pointed dual-number points (`tangentSpaceCotangentDual`,
`pointedDualNumberPoints_equiv_cotangentSpaceDual`); (2) representability
identifies those points `κ(e)`-linearly with
`ker(Pic(C ×_k Spec k[ε]) / π^* → Pic(C))`; (3) the truncated-exponential
splitting (`Picard/DualNumberUnits.lean`) computes that kernel on a 2-affine
cover as the Čech carrier `AffineCoverMVSquare.H1Cok`, which is `H¹(C, 𝒪_C)`
by `AffineCoverMVSquare.hModuleOneEquivH1Cok_curve`
(`RiemannRoch/Adelic/GenusUnconditional.lean`). Steps (2)-(3) must be carried
out with enough (semi)linearity to preserve dimension — a bare `Equiv` does
not determine `finrank`. -/
theorem tangentSpaceIso {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    Nonempty (Σ' (e : Spec (.of k) ⟶ (Pic0Scheme C).left),
      IsLocalRing.CotangentSpace ((Pic0Scheme C).left.presheaf.stalk (e.base default))
        ≃+ Scheme.HModule k (Scheme.toModuleKSheaf C) 1) := by
  haveI : LocallyOfFiniteType (Pic0Scheme C).hom := locallyOfFiniteType C
  refine (nonempty_cotangentSpaceAddEquiv_of_finrank_eq (Pic0Scheme C)
      (identitySection_isSection C)
      (Scheme.HModule k (Scheme.toModuleKSheaf C) 1) ?_).map
    fun φ => ⟨identitySection C, φ⟩
  -- Kleiman §5 Thm 5.11 dimension identity `dim_{κ(e)} m_e/m_e² = dim_k H¹(C, 𝒪_C)`:
  -- the named sub-lemma above (its docstring records the reduction state).
  exact finrank_cotangentSpace_eq_finrank_hModuleOne C

/-- **Smoothness of `Pic⁰_{C/k}`.**

For a smooth proper geometrically integral curve `C/k`, the identity component
`Pic⁰_{C/k}` is smooth over `k` (Kleiman §5 Cor.~`cor:sm` + Cor.~`cor:ch0` in
characteristic zero + Ex.~`ex:jac` for the curve case).

The proof (iter-194+): smoothness at the identity propagates to smoothness
everywhere by translation (Pic⁰ is a `k`-group scheme, so multiplication by
any `λ ∈ Pic⁰(k̄)` is an automorphism). At the identity, smoothness reduces
to the inequality
`dim_0 Pic⁰_{C/k} ≤ dim_k T₀ Pic⁰_{C/k} = dim_k H¹(C, 𝒪_C) = g(C)`
(`tangentSpaceIso`) becoming an equality. For a smooth proper curve this
equality holds: in characteristic zero by Cartier's theorem (every
`k`-group scheme is smooth), in positive characteristic by the curve-specific
vanishing `H²(C, 𝒪_C) = 0` (the obstruction to lifting tangent vectors). -/
theorem smooth {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    Smooth (Pic0Scheme C).hom :=
  sorry

/-- **Properness of `Pic⁰_{C/k}`.**

For a smooth proper geometrically integral curve `C/k`, the identity component
`Pic⁰_{C/k}` is proper over `k` (Kleiman §5 Thm.~`th:qpp&p`; a smooth proper
curve is geometrically normal, hence the projectivity upgrade applies).

The proof (iter-194+): `Pic⁰_{C/k}` is quasi-projective (Kleiman §5
Thm.~`th:qpp&p`, first conclusion); to upgrade to projective (hence proper)
we use the Chevalley–Rosenlicht structure theorem to reduce to ruling out
non-constant `k̄`-morphisms `𝔾_m → Pic⁰_{C/k̄}`. The latter follows from
normality of `C ×_k 𝔾_m` and Hartshorne II Ex.~6.15 (invertible sheaves on
a normal integral scheme are sheaves of Cartier divisors). -/
theorem proper {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    IsProper (Pic0Scheme C).hom :=
  sorry

/-- **Geometric irreducibility of `Pic⁰_{C/k}`.**

For a smooth proper geometrically integral curve `C/k`, the identity component
`Pic⁰_{C/k}` is geometrically irreducible over `k` (Kleiman §5 Prp.~`prp:pic0`,
specialisation of the abstract identity-component substrate
`IdentityComponent.isFiniteTypeGeometricallyIrreducible` of
`Picard/IdentityComponent.lean` to `G = PicScheme C`).

The proof: apply `GroupScheme.IdentityComponent.isFiniteTypeGeometricallyIrreducible`
to `G = PicScheme C` (locally of finite type by the
`PicSchemeLocallyOfFiniteType` carrier); `IdentityComponent (PicScheme C)`
is `Pic0Scheme C` definitionally. The specialisation is complete here, and
the mathematical content (Kleiman's translate-cover argument, EGA IV₂
4.5.8/4.6.1) was closed in the sibling's
`isFiniteTypeGeometricallyIrreducible` in run 0009. -/
theorem geometricallyIrreducible {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    GeometricallyIrreducible (Pic0Scheme C).hom :=
  (GroupScheme.IdentityComponent.isFiniteTypeGeometricallyIrreducible
    (PicScheme C)).2.2

/-- **`Pic⁰_{C/k}` is an abelian variety (A.3.vii assembly).**

For a smooth proper geometrically integral curve `C/k`, the identity
component `Pic⁰_{C/k}` is an abelian variety over `k`: the underlying
`k`-scheme is smooth (`Pic0.smooth`), proper (`Pic0.proper`), and
geometrically irreducible (`Pic0.geometricallyIrreducible`), and it carries
a `k`-group-scheme structure inherited from `Pic_{C/k}` via the inclusion
`Pic⁰_{C/k} ↪ Pic_{C/k}`
(`GroupScheme.IdentityComponent.isSubgroupHomomorphism`). Commutativity is
automatic (Milne §I.1, Cor.~1.4).

Milne §I.1, p.~8: "A complete connected group variety is called an abelian
variety." This is the load-bearing A.3.vii gate of Route~A for
`thm:nonempty_jacobianWitness`.

The proof assembles the four conjuncts: `proper` (this file), `smooth`
(this file), `geometricallyIrreducible` (this file), and the
`Nonempty (GrpObj (Pic0Scheme C))` slot from `Pic0.grpObj` (this file,
via `GroupScheme.IdentityComponent.isSubgroupHomomorphism` applied to
`G = PicScheme C`). The assembly itself is sorry-free; the remaining
obligations live in the `smooth` / `proper` conjuncts and the
geometric-irreducibility substrate. -/
theorem isAbelianVariety {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    IsProper (Pic0Scheme C).hom ∧ Smooth (Pic0Scheme C).hom ∧
      GeometricallyIrreducible (Pic0Scheme C).hom ∧
      Nonempty (GrpObj (Pic0Scheme C)) :=
  ⟨proper C, smooth C, geometricallyIrreducible C, grpObj C⟩

end Pic0

namespace Pic0Scheme

/-- **`Pic⁰_{C/k}` is an abelian variety** — the `Pic0Scheme`-namespace form
pinned by the blueprint node `thm:pic_zero_is_abelian_variety`
(`Picard_IdentityComponent.tex`). Moved here (run 0008) from sibling
`Picard/IdentityComponent.lean` so it can consume the per-conjunct theorems
of this chapter; it is literally `Pic0.isAbelianVariety`. -/
theorem isAbelianVariety {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C] :
    IsProper (Pic0Scheme C).hom ∧ Smooth (Pic0Scheme C).hom ∧
      GeometricallyIrreducible (Pic0Scheme C).hom ∧
      Nonempty (GrpObj (Pic0Scheme C)) :=
  Pic0.isAbelianVariety C

end Pic0Scheme

end Scheme

end AlgebraicGeometry
