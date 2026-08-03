/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.RigidPushforwardInstance
import AlgebraicJacobian.Picard.RigidPushforwardTransfer
import AlgebraicJacobian.Picard.SchemeEulerIndex

/-!
# A finite replacement for a family line bundle on a curve

For a smooth proper geometrically integral curve `C/k`, a finite type affine
test `Spec A`, and a line bundle `L` on `C_A`, this file constructs the finite
two-term replacement of the standard Cech complex after pushing `L` forward
along the finite map `C_A -> P^1_A`.

Unlike the abstract existence theorem, the result below discharges every input
for the campaign object: noetherianity of the affine base, flatness of the three
chart-section modules, and finiteness of both Cech cohomology modules.  It is the
reusable finite-complex input for the fibre Euler and Picard degree-piece route.

Nothing here constructs a Picard representer or assumes a rational point on
`C`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Module TensorProduct

namespace AlgebraicGeometry

noncomputable section

namespace Adelic

open Scheme

variable {k : Type u} [Field k]

/-- The standard two-chart Cech complex of the finite pushforward of a family
line bundle admits a finite replacement.

The hypotheses are exactly those of the challenge curve and a finite type
affine test.  In particular, the resulting `TwoTermFiniteReplacement` is
available without a rational point on `C` and without an extra representability
hypothesis. -/
theorem exists_twoTermFiniteReplacement_finiteMapToP1BaseChange
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom]
    (A : Type u) [CommRing A] [Algebra k A] [Algebra.FiniteType k A]
    (L : (Limits.pullback C.hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules)
    (hL : LineBundle.IsLocallyTrivial L) :
    let M := (Modules.pushforward (finiteMapToP1BaseChange A C)).obj L
    let p := pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))
    let U := p1BaseChangeCoverSquare (k := k) A
    letI := p.baseSectionsModule M U.U₁
    letI := p.baseSectionsModule M U.U₂
    letI := p.baseSectionsModule M (U.U₁ ⊓ U.U₂)
    Nonempty (AlgebraicJacobian.TwoTermFiniteReplacement
      (U.moduleSectionDiffBase p M)) := by
  haveI : HasFiniteMapToP1 C := inferInstance
  haveI : IsNoetherianRing A := Algebra.FiniteType.isNoetherianRing k A
  haveI : IsNoetherianRing Γ(Spec (CommRingCat.of A), ⊤) :=
    isNoetherianRing_of_ringEquiv A
      (Scheme.ΓSpecIso (CommRingCat.of A)).commRingCatIsoToRingEquiv.symm
  haveI := hL.isFinitePresentation
  let M := (Modules.pushforward (finiteMapToP1BaseChange A C)).obj L
  haveI : M.IsFinitePresentation :=
    pushforward_finiteMapToP1BaseChange_isFinitePresentation A C L hL
  haveI : M.IsQuasicoherent := by
    haveI : IsFinite (finiteMapToP1BaseChange A C) :=
      isFinite_finiteMapToP1BaseChange A C
    exact Modules.pushforward_isQuasicoherent (finiteMapToP1BaseChange A C) L
  let p := pullback.snd (p1Over k).hom
    (Spec.map (CommRingCat.ofHom (algebraMap k A)))
  let U := p1BaseChangeCoverSquare (k := k) A
  letI := p.baseSectionsModule M U.U₁
  letI := p.baseSectionsModule M U.U₂
  letI := p.baseSectionsModule M (U.U₁ ⊓ U.U₂)
  have hflat : CoherentSheafFlat p M :=
    pushforward_finiteMapToP1BaseChange_coherentSheafFlat A C L hL
  haveI : Module.Flat Γ(Spec (CommRingCat.of A), ⊤) Γ(M, U.U₁) :=
    flat_baseSections_of_coherentSheafFlat p M hflat U.isAffineOpen_U₁
  haveI : Module.Flat Γ(Spec (CommRingCat.of A), ⊤) Γ(M, U.U₂) :=
    flat_baseSections_of_coherentSheafFlat p M hflat U.isAffineOpen_U₂
  haveI : Module.Flat Γ(Spec (CommRingCat.of A), ⊤)
      (Γ(M, U.U₁) × Γ(M, U.U₂)) :=
    AlgebraicJacobian.TwoTerm.flat_prod
  haveI : Module.Flat Γ(Spec (CommRingCat.of A), ⊤) Γ(M, U.U₁ ⊓ U.U₂) :=
    flat_baseSections_of_coherentSheafFlat p M hflat U.isAffineOpen_inf
  haveI : IsIntegral (p1Over k).left := inferInstance
  have hH₀ : (LinearMap.ker (U.moduleSectionDiffBase p M)).FG :=
    p1Cech_h0_fg_of_isIntegral A M
  haveI : Module.Finite Γ(Spec (CommRingCat.of A), ⊤)
      (Γ(M, U.U₁ ⊓ U.U₂) ⧸ LinearMap.range (U.moduleSectionDiffBase p M)) :=
    module_finite_h1_p1BaseChange A M
  exact AlgebraicJacobian.exists_twoTermFiniteReplacement
    (U.moduleSectionDiffBase p M) hH₀

end Adelic

end

end AlgebraicGeometry
