/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib
import AlgebraicJacobian.Picard.Pic0Et
import AlgebraicJacobian.Picard.Pic0AbelianVariety
import AlgebraicJacobian.RiemannRoch.Adelic.GenusUnconditional
import AlgebraicJacobian.Genus

/-!
# The tangent space of `Pic⁰_{C/k}` in its étale formulation

The Kleiman §5 Thm. `thm:tgtsp` dimension development for `Scheme.Pic0SchemeEt C`
— the identity component of the scheme representing the **étale-sheafified**
relative Picard functor, which is the object the Jacobian headline binds
(`picardJacobianWitness`, `AlgebraicJacobian/Jacobian.lean`).

## Why this file exists

`Picard/Pic0AbelianVariety.lean` develops the same chain for `Pic0Scheme C`, the
identity component of the scheme representing the *unsheafified* `picSharp C`.
That development carries `[HasPicScheme C]`, a class with no instance whose only
producer is the conditional `picSchemeOfHasRationalPoint` — so it is a statement
about a *pointed* curve, and the headline's dimension leaf
`smoothOfRelativeDimension_genus_pic0Et` cannot consume it.

## What this file corrects

`Jacobian.lean` priced the étale dimension leaf as needing "the comparison of the
two Picard schemes, which is available only under a section" — i.e. exactly the
hypothesis the owner decision `I-0491` forbids the headline to carry. **That
pricing is wrong, and this file is the refutation.** Every engine of the
dual-number leg is quantified over an arbitrary functor and an arbitrary
`RepresentableBy`:

* `Pic0.pointedDualNumberPointsEquivRepresentableFiber` and
  `pointedDualNumberPointsEquivAddKernel`
  (`Picard/Pic0DualNumberCocycle.lean`) take `(G, rep)` as arguments;
* `pointedDualNumberPointsEquivOfOpenImmersion` (`Picard/Pic0TangentSpace.lean`)
  takes an arbitrary morphism with open-immersion underlying map;
* `overDualNumberSectionEquivCotangentSpaceDual`
  (`Picard/TangentSpaceIdentitySection.lean`) takes an arbitrary `X` and section.

`picSharp` entered only at the two *application* sites of
`Pic0AbelianVariety.lean`. Here the same engines are applied to
`(PicSharp.etaleSheaf C).obj` with `representableEt` — which is precisely the
`(G, rep)` pair they ask for, and which needs no rational point.

## What is proved and what remains

Proved outright, with no rational point and no `[HasPicScheme C]`:
`identitySection`, `pointedDualNumberPoints_equiv_cotangentSpaceDual`,
`pointedDualNumberPoints_equiv_relPicEtKernel` (the representability leg **against
`picEt`**), `cotangentSpaceDual_equiv_relPicEtKernel`, and
`finiteDimensional_cotangentSpace`.

The dimension identity itself is stated as an **implication**. Its single
antecedent is `SemilinearCotangentComparisonEt`, the étale restatement of the
`picSharp` side's own open residue `Pic0.semilinearComparison_cotangentSpaceDual_h1Cok`
(`Pic0AbelianVariety.lean`, a bare `sorry`). So the étale formulation owes the
**same one statement** the pointed formulation owes, and no more — which is the
point of the file. This file adds **no `sorry` of its own**; the antecedent is a
named hypothesis, not a discharged obligation.

What this file does **not** do, stated plainly because it is easy to overread:
it does not close the headline leaf `smoothOfRelativeDimension_genus_pic0Et`.
That leaf needs, over and above the dimension count, the passage from a
tangent-space dimension to Mathlib's presentation-based
`SmoothOfRelativeDimension` (characterised by `Module.rank S Ω[S⁄R]`), plus
`Pic0Et.smooth` itself. Those are recorded on the leaf and are untouched here.

## References

Kleiman, "The Picard scheme" (arXiv:math/0504020), §5 Thm. `thm:tgtsp`.
Mumford, "Abelian varieties", §II.4 (the tangent-vector scaling).
-/

set_option autoImplicit false

universe u

open CategoryTheory IsLocalRing

namespace AlgebraicGeometry

namespace Scheme

namespace Pic0Et

variable {k : Type u} [Field k]

/-! ## §1. The identity section of `Pic⁰_{C/k}` -/

/-- **The `k`-rational identity-section point of `Pic⁰_{C/k}`**, étale
formulation: the lift of the identity section of `PicSchemeEt C` through the
clopen immersion `Pic⁰_{C/k} ↪ Pic_{C/k}`.

`GroupScheme.identityComponentSection` needs `[GrpObj G]` and
`[LocallyOfFiniteType G.hom]` on `G = PicSchemeEt C`; both are available with no
hypothesis on `C(k)` — the first from `groupSchemeStructureEt` (Yoneda transport
of the étale sheaf's abelian-group structure) and the second from
`instPicSchemeEtLocallyOfFiniteType`. This is the étale counterpart of
`Pic0.identitySection`, which carries `[HasPicScheme C]`. -/
noncomputable def identitySection (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicSchemeEt C] :
    Spec (.of k) ⟶ (Pic0SchemeEt C).left :=
  GroupScheme.identityComponentSection (PicSchemeEt C)

/-- The identity-section point is a genuine section of the structural morphism.
Transport of `GroupScheme.identityComponentSection_isSection`. -/
theorem identitySection_isSection (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicSchemeEt C] :
    identitySection C ≫ (Pic0SchemeEt C).hom = 𝟙 (Spec (.of k)) :=
  GroupScheme.identityComponentSection_isSection (PicSchemeEt C)

/-- The residue field of the local ring at the identity of `Pic⁰_{C/k}`. -/
noncomputable abbrev identityResidueField (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicSchemeEt C] :=
  ResidueField ((Pic0SchemeEt C).left.presheaf.stalk ((identitySection C).base default))

/-- The Zariski cotangent space `m_e/m_e²` at the identity of `Pic⁰_{C/k}`. -/
noncomputable abbrev identityCotangentSpace (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicSchemeEt C] :=
  CotangentSpace ((Pic0SchemeEt C).left.presheaf.stalk ((identitySection C).base default))

/-! ## §2. The two legs of Kleiman §5 Thm. `thm:tgtsp`, étale formulation -/

/-- **The Stacks 0B28 dictionary at the identity**, étale formulation: pointed
dual-number points of `Pic⁰_{C/k}` at the identity biject with `κ(e)`-linear
functionals on the cotangent space `m_e/m_e²`.

Direct specialisation of `overDualNumberSectionEquivCotangentSpaceDual`
(`Picard/TangentSpaceIdentitySection.lean`) to `e = identitySection C`; that
engine is generic in the scheme and the section, so this needs nothing about
`picEt` beyond the section being a section. Étale counterpart of
`Pic0.pointedDualNumberPoints_equiv_cotangentSpaceDual`. -/
theorem pointedDualNumberPoints_equiv_cotangentSpaceDual (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicSchemeEt C] :
    Nonempty (Pic0.pointedDualNumberPoints (Pic0SchemeEt C) (identitySection C) ≃
      Module.Dual (identityResidueField C) (identityCotangentSpace C)) := by
  haveI : Subsingleton ↥(Spec (CommRingCat.of k)) :=
    inferInstanceAs (Subsingleton (PrimeSpectrum k))
  exact ⟨overDualNumberSectionEquivCotangentSpaceDual (Pic0SchemeEt C)
    (identitySection_isSection C) (congrArg _ (Subsingleton.elim _ _))⟩

/-- **The representability leg, against `picEt` and with no rational point** —
the declaration whose absence `Jacobian.lean` priced as a section-gated
transport.

`T_e Pic⁰_{C/k}` biject with the kernel of the restriction homomorphism
`Pic_{(C/k)ét}(Spec k[ε]) →+ Pic_{(C/k)ét}(Spec k)`. Composite of

1. the open-immersion transport `T_e Pic⁰ ≃ T_e Pic` along the clopen inclusion
   (`pointedDualNumberPointsEquivOfOpenImmersion`), and
2. the represented-functor kernel description
   (`pointedDualNumberPointsEquivAddKernel`) applied at
   `G = (PicSharp.etaleSheaf C).obj` — the `AddCommGrpCat`-valued étale Picard
   sheaf — with `rep = representableEt C`.

Step 2 is the whole point: that engine takes an arbitrary `AddCommGrpCat`-valued
`G` together with a `RepresentableBy` for `G ⋙ forget`, and by definition
`picEt C = (PicSharp.etaleSheaf C).obj ⋙ forget AddCommGrpCat`
(`Picard/PicEtSheaf.lean`), so `representableEt C` **is** that datum. No
comparison between the two Picard schemes occurs anywhere in the proof, and the
étale-sheafified functor is the one whose kernel is described.

Étale counterpart of `Pic0.pointedDualNumberPoints_equiv_relPicKernel`. Like it,
this is a bijection of **sets**: transporting `finrank` needs the `k`-linearity
bookkeeping, which stays with the dimension identity below. -/
theorem pointedDualNumberPoints_equiv_relPicEtKernel (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicSchemeEt C] :
    Nonempty (Pic0.pointedDualNumberPoints (Pic0SchemeEt C) (identitySection C) ≃
      {a : ((PicSharp.etaleSheaf C).obj).obj (Opposite.op (overDualNumber k)) //
        (((PicSharp.etaleSheaf C).obj).map (overDualNumberZero k).op).hom a = 0}) := by
  obtain ⟨f, hopen, -⟩ :=
    GroupScheme.IdentityComponent.isOpenSubgroupScheme (PicSchemeEt C)
  haveI := hopen
  have he' : (identitySection C ≫ f.left) ≫ (PicSchemeEt C).hom = 𝟙 (Spec (.of k)) :=
    (Category.assoc _ _ _).trans
      ((congrArg (fun t => identitySection C ≫ t) (Over.w f)).trans
        (identitySection_isSection C))
  exact ⟨(pointedDualNumberPointsEquivOfOpenImmersion f (identitySection C)).trans
    (pointedDualNumberPointsEquivAddKernel (PicSchemeEt C)
      ((PicSharp.etaleSheaf C).obj) (representableEt C) he')⟩

/-- **The two legs composed**, étale formulation: the `κ(e)`-linear dual of the
cotangent space at the identity of `Pic⁰_{C/k}` bijects with the dual-number
kernel of `Pic_{(C/k)ét}`. Étale counterpart of
`Pic0.cotangentSpaceDual_equiv_relPicKernel`, and a bijection of sets for the
same reason. -/
theorem cotangentSpaceDual_equiv_relPicEtKernel (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicSchemeEt C] :
    Nonempty (Module.Dual (identityResidueField C) (identityCotangentSpace C) ≃
      {a : ((PicSharp.etaleSheaf C).obj).obj (Opposite.op (overDualNumber k)) //
        (((PicSharp.etaleSheaf C).obj).map (overDualNumberZero k).op).hom a = 0}) := by
  obtain ⟨φ⟩ := pointedDualNumberPoints_equiv_cotangentSpaceDual C
  obtain ⟨ψ⟩ := pointedDualNumberPoints_equiv_relPicEtKernel C
  exact ⟨φ.symm.trans ψ⟩

/-- Finite-dimensionality of the cotangent space at the identity, from the
unconditional `Pic0Et.locallyOfFiniteType`. Needed for the duality step of the
dimension chain. -/
theorem finiteDimensional_cotangentSpace (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicSchemeEt C] :
    FiniteDimensional (identityResidueField C) (identityCotangentSpace C) := by
  haveI : LocallyOfFiniteType (Pic0SchemeEt C).hom := locallyOfFiniteType C
  exact Pic0.finiteDimensional_cotangentSpace_of_locallyOfFiniteType (Pic0SchemeEt C) _

/-! ## §3. The dimension identity, as an implication with one named antecedent -/

/-- **The one open input of the étale dimension count**, named so that the
implication below has an auditable antecedent rather than a `sorry`.

This is the étale restatement of `Pic0.semilinearComparison_cotangentSpaceDual_h1Cok`
(`Picard/Pic0AbelianVariety.lean`, a bare `sorry`): for every 2-affine cover `S`
of `C`, an additive equivalence between the dual of the cotangent space at the
identity of `Pic⁰_{C/k}` and the concrete two-chart Čech cokernel
`S.H1Cok (toModuleKSheaf C)`, together with a bijection `i` of the two scalar
rings intertwining the actions — exactly the data
`Pic0.finrank_eq_of_addEquiv_of_bijective_smul` consumes, and no more.

`i` need only be a bijection of the underlying types, not a ring map: the
`κ(e)`-dimension of the left side is compared with the `k`-dimension of the right
side across the residue-field identification, so neither
`LinearEquiv.finrank_eq` nor `restrictScalars` applies.

**Non-vacuity, and the honest state.** This is a hypothesis, not a theorem: it is
the same single statement the pointed development owes, restated at the étale
object. The mathematics still missing is what `Pic0AbelianVariety.lean` records
at its own residue — exhibiting the map that sends a dual-number kernel class to
its transition unit, i.e. a Čech-to-invertible-sheaves comparison at a
*non-affine* scheme. Nothing here reduces that; what is established is that the
étale side needs it once rather than twice, and needs nothing about a section. -/
def SemilinearCotangentComparisonEt (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicSchemeEt C] : Prop :=
  ∀ S : C.left.AffineCoverMVSquare,
    ∃ (i : identityResidueField C → k)
      (j : Module.Dual (identityResidueField C) (identityCotangentSpace C)
            ≃+ S.H1Cok (Scheme.toModuleKSheaf C)),
      Function.Bijective i ∧ ∀ r x, j (r • x) = i r • j x

/-- **The Kleiman §5 Thm. `thm:tgtsp` dimension identity for `Pic⁰_{C/k}`, étale
formulation**: `dim_{κ(e)} m_e/m_e² = dim_k H¹(C, 𝒪_C)` at the identity, with
**no rational point and no `[HasPicScheme C]`**.

Stated as an implication from `SemilinearCotangentComparisonEt`, which is the
whole open content. The other two legs of the chain are discharged here:

* `dim_{κ(e)} m_e/m_e² = dim_{κ(e)} Dual(m_e/m_e²)` — reflexivity of
  finite-dimensional duality (`Subspace.dual_finrank_eq`, finite-dimensionality
  from `finiteDimensional_cotangentSpace` above, i.e. from the unconditional
  `Pic0Et.locallyOfFiniteType`);
* `dim_k Ȟ¹(S, 𝒪_C) = dim_k H¹(C, 𝒪_C)` — the gate-free Mayer–Vietoris
  comparison `AffineCoverMVSquare.hModuleOneEquivH1Cok_curve`, at the 2-affine
  cover supplied unconditionally by
  `Adelic.exists_affineCoverMVSquare_module_finite_H1Cok`.

Both of those legs are the *same* lemmas the pointed side uses, applied at
`Pic0SchemeEt`: they are generic in the scheme. Étale counterpart of
`Pic0.finrank_cotangentSpace_eq_finrank_hModuleOne`, which reports `sorryAx`
through its own residue. -/
theorem finrank_cotangentSpace_eq_finrank_hModuleOne (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicSchemeEt C]
    (hcomp : SemilinearCotangentComparisonEt C) :
    Module.finrank (identityResidueField C) (identityCotangentSpace C)
      = Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1) := by
  haveI := finiteDimensional_cotangentSpace C
  obtain ⟨S, -⟩ := Adelic.exists_affineCoverMVSquare_module_finite_H1Cok C
  obtain ⟨i, j, hi, hc⟩ := hcomp S
  calc Module.finrank (identityResidueField C) (identityCotangentSpace C)
      = Module.finrank (identityResidueField C)
          (Module.Dual (identityResidueField C) (identityCotangentSpace C)) :=
        Subspace.dual_finrank_eq.symm
    _ = Module.finrank k (S.H1Cok (Scheme.toModuleKSheaf C)) :=
        Pic0.finrank_eq_of_addEquiv_of_bijective_smul i j hi hc
    _ = Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1) :=
        (LinearEquiv.finrank_eq S.hModuleOneEquivH1Cok_curve).symm

/-- **The dimension count in the form the headline leaf needs**: the tangent
space at the identity of `Pic⁰_{C/k}` has dimension `genus C`.

Immediate from the identity above, since `genus C` is *by definition*
`dim_k H¹(C, 𝒪_C)` (`AlgebraicJacobian/Genus.lean`) — the two sides match with no
transport, exactly as on the pointed side.

This is the number `smoothOfRelativeDimension_genus_pic0Et` (`Jacobian.lean`)
needs. It is **not** that leaf: the leaf additionally needs `Pic0Et.smooth` and
the passage from a tangent-space dimension to Mathlib's presentation-based
`SmoothOfRelativeDimension` (characterised by `Module.rank S Ω[S⁄R]`), neither of
which is touched here. What this removes from the leaf's cost is the transport
along a section that its docstring claimed to require. -/
theorem finrank_cotangentSpace_eq_genus (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] [GeometricallyIntegral C.hom] [HasPicSchemeEt C]
    (hcomp : SemilinearCotangentComparisonEt C) :
    Module.finrank (identityResidueField C) (identityCotangentSpace C) = genus C :=
  finrank_cotangentSpace_eq_finrank_hModuleOne C hcomp

end Pic0Et

end Scheme

end AlgebraicGeometry
