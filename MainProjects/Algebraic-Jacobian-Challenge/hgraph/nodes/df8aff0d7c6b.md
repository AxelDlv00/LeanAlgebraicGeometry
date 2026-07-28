---
author: sync
content_type: theorem
created: '2026-07-28T22:30:24'
decl: AlgebraicGeometry.leakEndpoint_cech_flatBaseChange_qcoh
docstring: '**THE ENDPOINT, in its hypothesis-free form.**  Expected `sorryAx`, from
  the two cosimplicial

  naturality leaves and nothing else.  Compare `leakProbe_cechTerm_isQuasicoherent`
  above, which is

  the discharge of the hypotheses this form no longer carries, and is clean.'
file: scripts/axiom-frontier.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.leakEndpoint_cech_flatBaseChange_qcoh
type: lean
updated: '2026-07-28T22:57:24'
---
theorem leakEndpoint_cech_flatBaseChange_qcoh {S S' X X' : Scheme.{u}}
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [IsSeparated f]
    [IsAffine S] [IsAffine S']
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] [∀ i, IsAffine (𝒰.X i)]
    [Finite ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).I₀]
    [∀ i, IsAffine (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) :
    Nonempty ((Scheme.Modules.pullback g).obj (cechHigherDirectImage f 𝒰 F i) ≅
      cechHigherDirectImage f'
        ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom)
        ((Scheme.Modules.pullback g').obj F) i) :=
  cech_flatBaseChange_qcoh f g f' g' h 𝒰 F hF i

#print axioms leakProbe_cechTerm_isQuasicoherent
#print axioms leakProbe_whiskeredBC_natIso
#print axioms leakProbe_isIso_app_pi
#print axioms leakEndpoint_cech_flatBaseChange_qcoh
#print axioms cech_flatBaseChange
#print axioms cechComplex_baseChange_iso