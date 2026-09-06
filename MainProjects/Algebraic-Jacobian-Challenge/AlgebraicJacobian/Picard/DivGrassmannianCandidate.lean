/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivGrassmannianBaseChange
import AlgebraicJacobian.Picard.DivGrassmannianH1
import AlgebraicJacobian.Picard.DivLocallyClosed

/-!
# The universal Grassmannian candidate for a divisor

This file connects the D2 divisor-to-Grassmannian class to the D3
curve-side candidate quotient.  It is kept downstream of both constructions
so changes to this bridge do not force the large D2 development to recompile.

Reconstruction from a relatively generated twisted ideal specializes Nitsure,
*Construction of Hilbert and Quot Schemes*, Section 5, "Embedding Quot into
Grassmannian", to divisor families in the campaign's D2 construction.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory

namespace AlgebraicGeometry

namespace Scheme

namespace DivFamily

variable {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S}

/-- The reconstructed Grassmannian evaluation kills the relations of an
actual divisor family.  The proof is the adjunction transpose of
`kernel.ι (grassmannianEval L x) ≫ grassmannianEval L x = 0`; it uses no
additional hypothesis beyond the data already needed to form that quotient. -/
theorem grassmannianKernelEvaluation_comp_twistQuotientMap
    (L : X.Modules) (x : DivFamily π T) [IsLocallyNoetherian S] {d : ℕ}
    (hEpi : Epi (x.grassmannianEval L))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    LocallyFreeQuotient.kernelEvaluation L
        (x.grassmannianQuotient L hEpi hLocFree) ≫
      x.twistQuotientMap L = 0 := by
  let q := x.grassmannianQuotient L hEpi hLocFree
  change LocallyFreeQuotient.kernelEvaluation L q ≫
    x.twistQuotientMap L = 0
  apply ((Modules.pullbackPushforwardAdjunction
    (pullback.snd π T.hom)).homEquiv _ _).injective
  rw [Adjunction.homEquiv_naturality_right]
  simp only [LocallyFreeQuotient.kernelEvaluation, Equiv.apply_symm_apply]
  change (kernel.ι q.q ≫
      (canonicalBaseChangeMap (IsPullback.of_hasPullback π T.hom)).app L) ≫
      (Modules.pushforward (pullback.snd π T.hom)).map
        (x.twistQuotientMap L) = _
  rw [Category.assoc]
  change kernel.ι q.q ≫ q.q = _
  rw [kernel.condition, Adjunction.homAddEquiv_zero]
  rfl

/-- The canonical comparison from the Grassmannian candidate cokernel to the
twisted sheaf of an actual divisor family. -/
noncomputable def grassmannianCandidateToTwist
    (L : X.Modules) (x : DivFamily π T) [IsLocallyNoetherian S] {d : ℕ}
    (hEpi : Epi (x.grassmannianEval L))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    cokernel (LocallyFreeQuotient.kernelEvaluation L
      (x.grassmannianQuotient L hEpi hLocFree)) ⟶ x.twist L :=
  cokernel.desc _ (x.twistQuotientMap L)
    (grassmannianKernelEvaluation_comp_twistQuotientMap
      L x hEpi hLocFree)

/-- The candidate quotient followed by its comparison is the original
twisted divisor quotient. -/
theorem grassmannianCandidateQuotient_comp_candidateToTwist
    (L : X.Modules) (x : DivFamily π T) [IsLocallyNoetherian S] {d : ℕ}
    (hEpi : Epi (x.grassmannianEval L))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    LocallyFreeQuotient.candidateQuotient L
        (x.grassmannianQuotient L hEpi hLocFree) ≫
      grassmannianCandidateToTwist L x hEpi hLocFree =
        x.twistQuotientMap L :=
  cokernel.π_desc _ _ _

/-! The comparison is not merely a map out of the Grassmannian candidate: it
is an epimorphism onto the actual twisted divisor module.  This is the
categorical cancellation step used when the candidate is later identified
with the Cartier quotient. -/

/-- **The Grassmannian candidate comparison is epimorphic.**

The candidate quotient is epi by construction, and its composite with the
comparison is the original twisted divisor quotient, which is epi.  Cancelling
the first epi factor therefore proves that the comparison itself is epi. -/
theorem grassmannianCandidateToTwist_epi
    (L : X.Modules) (x : DivFamily π T) [IsLocallyNoetherian S] {d : ℕ}
    (hEpi : Epi (x.grassmannianEval L))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    Epi (grassmannianCandidateToTwist L x hEpi hLocFree) := by
  let q := x.grassmannianQuotient L hEpi hLocFree
  let c := grassmannianCandidateToTwist L x hEpi hLocFree
  have hq : Epi (LocallyFreeQuotient.candidateQuotient L q) :=
    LocallyFreeQuotient.candidateQuotient_epi L q
  have hcomp : Epi (LocallyFreeQuotient.candidateQuotient L q ≫ c) := by
    rw [grassmannianCandidateQuotient_comp_candidateToTwist L x hEpi hLocFree]
    exact twistQuotientMap_epi_core L x
  exact (epi_comp_iff_of_epi (LocallyFreeQuotient.candidateQuotient L q) c).mp hcomp

set_option backward.isDefEq.respectTransparency false in
/-- Relative generation of the actual twisted divisor ideal reconstructs the
divisor quotient from its Grassmannian image.  The generation hypothesis is
epimorphy of the adjunction counit on the kernel of the twisted quotient.
The canonical base-change isomorphism identifies relative sections of the
twist with the source of the Grassmannian quotient.

This is the reconstruction step in the divisor-to-Grassmannian immersion;
uniform generation of the twisted ideals remains a separate geometric input. -/
theorem grassmannianCandidateToTwist_isIso_of_kernel_counit_epi
    (L : X.Modules) (x : DivFamily π T) [IsLocallyNoetherian S] {d : ℕ}
    (hEpi : Epi (x.grassmannianEval L))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d)
    [IsIso ((canonicalBaseChangeMap (IsPullback.of_hasPullback π T.hom)).app L)]
    (hgen : Epi ((Modules.pullbackPushforwardAdjunction
      (pullback.snd π T.hom)).counit.app (kernel (x.twistQuotientMap L)))) :
    IsIso (grassmannianCandidateToTwist L x hEpi hLocFree) := by
  let p := x.twistQuotientMap L
  let q := x.grassmannianQuotient L hEpi hLocFree
  let b : (Modules.pullback T.hom).obj ((Modules.pushforward π).obj L) ⟶
      (Modules.pushforward (pullback.snd π T.hom)).obj
        ((Modules.pullback (pullback.fst π T.hom)).obj L) :=
    (canonicalBaseChangeMap (IsPullback.of_hasPullback π T.hom)).app L
  let adj := Modules.pullbackPushforwardAdjunction (pullback.snd π T.hom)
  let e := LocallyFreeQuotient.kernelEvaluation L q
  let R := Modules.pushforward (pullback.snd π T.hom)
  let F := Modules.pullback (pullback.snd π T.hom)
  haveI : IsIso b := inferInstance
  haveI : Epi p := twistQuotientMap_epi_core L x
  haveI : Epi (adj.counit.app (kernel p)) := hgen
  have hq : q.q = b ≫ R.map p := rfl
  let k : R.obj (kernel p) ⟶ kernel q.q :=
    kernel.lift q.q (R.map (kernel.ι p) ≫ inv b) (by
      rw [hq]
      simp only [Category.assoc, IsIso.inv_hom_id_assoc, ← R.map_comp,
        kernel.condition, Functor.map_zero])
  have hk : k ≫ kernel.ι q.q ≫ b = R.map (kernel.ι p) := by
    simp only [k, kernel.lift_ι_assoc, Category.assoc, IsIso.inv_hom_id,
      Category.comp_id]
  have he : F.map k ≫ e = adj.counit.app (kernel p) ≫ kernel.ι p := by
    dsimp only [e, LocallyFreeQuotient.kernelEvaluation]
    rw [← Adjunction.homEquiv_naturality_left_symm]
    change (adj.homEquiv _ _).symm (k ≫ kernel.ι q.q ≫ b) = _
    rw [hk, Adjunction.homEquiv_counit]
    exact adj.counit.naturality (kernel.ι p)
  have hz : kernel.ι p ≫ cokernel.π e = 0 := by
    apply (cancel_epi (adj.counit.app (kernel p))).mp
    rw [← Category.assoc, ← he, Category.assoc, cokernel.condition, comp_zero,
      comp_zero]
  let c := grassmannianCandidateToTwist L x hEpi hLocFree
  have hc : cokernel.π e ≫ c = p :=
    grassmannianCandidateQuotient_comp_candidateToTwist L x hEpi hLocFree
  let v := Abelian.epiDesc p (cokernel.π e) hz
  have hv : p ≫ v = cokernel.π e := Abelian.comp_epiDesc p _ hz
  change IsIso c
  refine ⟨⟨v, ?_, ?_⟩⟩
  · apply (cancel_epi (cokernel.π e)).mp
    rw [← Category.assoc, hc, hv, Category.comp_id]
  · apply (cancel_epi p).mp
    rw [← Category.assoc, hv, hc, Category.comp_id]

/-- The reconstruction isomorphism for a relatively generated twisted ideal. -/
noncomputable def grassmannianCandidateIsoTwistOfKernelCounitEpi
    (L : X.Modules) (x : DivFamily π T) [IsLocallyNoetherian S] {d : ℕ}
    (hEpi : Epi (x.grassmannianEval L))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d)
    [IsIso ((canonicalBaseChangeMap (IsPullback.of_hasPullback π T.hom)).app L)]
    (hgen : Epi ((Modules.pullbackPushforwardAdjunction
      (pullback.snd π T.hom)).counit.app (kernel (x.twistQuotientMap L)))) :
    cokernel (LocallyFreeQuotient.kernelEvaluation L
      (x.grassmannianQuotient L hEpi hLocFree)) ≅ x.twist L := by
  letI := grassmannianCandidateToTwist_isIso_of_kernel_counit_epi
    L x hEpi hLocFree hgen
  exact asIso (grassmannianCandidateToTwist L x hEpi hLocFree)

/-- The reconstructed isomorphism identifies the quotient maps, not just the
underlying modules. -/
theorem grassmannianCandidateQuotient_comp_isoTwist_hom
    (L : X.Modules) (x : DivFamily π T) [IsLocallyNoetherian S] {d : ℕ}
    (hEpi : Epi (x.grassmannianEval L))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d)
    [IsIso ((canonicalBaseChangeMap (IsPullback.of_hasPullback π T.hom)).app L)]
    (hgen : Epi ((Modules.pullbackPushforwardAdjunction
      (pullback.snd π T.hom)).counit.app (kernel (x.twistQuotientMap L)))) :
    LocallyFreeQuotient.candidateQuotient L
        (x.grassmannianQuotient L hEpi hLocFree) ≫
      (grassmannianCandidateIsoTwistOfKernelCounitEpi
        L x hEpi hLocFree hgen).hom = x.twistQuotientMap L :=
  grassmannianCandidateQuotient_comp_candidateToTwist L x hEpi hLocFree

end DivFamily

namespace Grassmannian

variable {S X : Scheme.{0}} {π : X ⟶ S} [IsLocallyNoetherian S]

/-- The curve-side evaluation map attached to the universal quotient on the
chosen scheme representing `Grassmannian (π_* L) d`. -/
noncomputable def universalKernelEvaluation (L : X.Modules) {r d : ℕ}
    (hV : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward π).obj L) r)
    (hd : 1 ≤ d) (hdr : d ≤ r) :=
  LocallyFreeQuotient.kernelEvaluation L
    (universalQuotient hV hd hdr)

/-- The universal candidate quotient on
`X ×_S representingScheme (Grassmannian (π_*L) d)`. -/
noncomputable def universalCandidateQuotient (L : X.Modules) {r d : ℕ}
    (hV : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward π).obj L) r)
    (hd : 1 ≤ d) (hdr : d ≤ r) :=
  LocallyFreeQuotient.candidateQuotient L
    (universalQuotient hV hd hdr)

/-- The kernel of the universal candidate quotient.  This is the actual
curve-side module whose invertible locus D3 must carve out; the kernel of the
Grassmannian quotient itself lives on the base and has the wrong rank.  Its
ordinary `lineBundleLocus` lies in the total space `X_G`; D3 must still descend
the whole-fibre condition to a locus in the Grassmannian base `G`. -/
noncomputable def universalCandidateIdeal (L : X.Modules) {r d : ℕ}
    (hV : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward π).obj L) r)
    (hd : 1 ≤ d) (hdr : d ≤ r) :=
  LocallyFreeQuotient.candidateIdeal L
    (universalQuotient hV hd hdr)

/-- The universal candidate quotient is epimorphic by its cokernel
construction. -/
theorem universalCandidateQuotient_epi (L : X.Modules) {r d : ℕ}
    (hV : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward π).obj L) r)
    (hd : 1 ≤ d) (hdr : d ≤ r) :
    Epi (universalCandidateQuotient L hV hd hdr) :=
  LocallyFreeQuotient.candidateQuotient_epi L
    (universalQuotient hV hd hdr)

end Grassmannian

end Scheme

end AlgebraicGeometry
