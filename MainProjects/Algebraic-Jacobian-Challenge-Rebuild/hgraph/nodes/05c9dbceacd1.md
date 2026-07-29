---
author: sync
content_type: definition
created: '2026-07-30T06:31:12'
decl: AlgebraicGeometry.eqnsWindowGermSet
docstring: 'The carrier-free germ set: what `divFamEpsWindowGermSet` is, read off
  `d` alone.'
file: scratch_p3r6/probe2.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.eqnsWindowGermSet
type: lean
updated: '2026-07-30T07:41:06'
---
noncomputable def eqnsWindowGermSet (g : ℕ) (d : (relCurve C K).LocalEquations)
    (z : relCurve C K) : Set ((relCurve C K).presheaf.stalk z) :=
  Scheme.twistGermSet
    ((↑(Submodule.map (relThetaWindowEquiv C K π (windowM_choice π hπ g)
        (relThetaPairH1_windowM C π hπ g)).toLinearMap
        (divisorWindow d (relThetaPairH1_windowM C π hπ g))) :
      Set (relThetaSections C K π (windowM_choice π hπ g)))) z

/- Does the germ set of a chart-typed family agree with the carrier-free one? -/
example (g : ℕ) (G : CertifiedDivisorFamily C K π g) (z : relCurve C K) :
    divFamEpsWindowGermSet hπ g (DivFam.mk G) z = eqnsWindowGermSet hπ g G.eqns z := rfl

/- And for the widened one? -/
example (g : ℕ) (F : CertifiedDivisorFamilyAff C K g) (z : relCurve C K) :
    eqnsWindowGermSet hπ g F.eqns z
      = Scheme.twistGermSet
        ((↑(Submodule.map (relThetaWindowEquiv C K π (windowM_choice π hπ g)
            (relThetaPairH1_windowM C π hπ g)).toLinearMap (F.eps hπ g).1) :
          Set (relThetaSections C K π (windowM_choice π hπ g)))) z := rfl