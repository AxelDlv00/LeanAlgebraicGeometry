---
author: sync
content_type: definition
created: '2026-07-30T06:31:12'
decl: AlgebraicGeometry.eqnsWindowGermSet
docstring: '**The `ε`-window germ set of a bare local-equation system.**  This is

  `divFamEpsWindowGermSet` (`Picard/DivSchemeMonoBridge.lean:346`) with the carrier
  deleted:

  that definition reads its `DivFam` argument only through `divFamEps`, which is

  `divisorWindow` of the underlying `eqns`, so nothing is lost.


  `eqnsWindowGermSet_divFam` and `eqnsWindowGermSet_eps` below record that both carriers''

  germ sets ARE this one, by `rfl` — which is the whole content of the carrier-freeness.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffFieldMono.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.eqnsWindowGermSet
type: lean
updated: '2026-07-30T15:27:56'
---
noncomputable def eqnsWindowGermSet (g : ℕ) (d : (relCurve C K).LocalEquations)
    (z : relCurve C K) : Set ((relCurve C K).presheaf.stalk z) :=
  Scheme.twistGermSet
    ((↑(Submodule.map (relThetaWindowEquiv C K π (windowM_choice π hπ g)
        (relThetaPairH1_windowM C π hπ g)).toLinearMap
        (divisorWindow d (relThetaPairH1_windowM C π hπ g))) :
      Set (relThetaSections C K π (windowM_choice π hπ g)))) z

/- MEASURED, not assumed (the failure mode of I-1241): the linter reports
`SmoothOfRelativeDimension 1 C.hom` unused here, and `omit`-ing it is REJECTED with
"cannot omit referenced section variable".  Both tools are right about different things —
it is referenced through an instance argument of a later binder, not by the statement — so
the warning cannot be silenced by omitting, and the honest record is to disable the linter
for these two `rfl`s only.  A binary search over the four candidate binders established
which binders ARE omittable: EIGHT, listed in each `omit` below and counted from the file,
against NINE the linter flags when nothing is omitted. -/
set_option linter.unusedSectionVars false in
omit [IsProper C.hom] [GeometricallyIrreducible C.hom]
  [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]
  [Module.Finite K (Sheaf.HModule ((relCurve C K).moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule ((relCurve C K).moduleKSheaf K) 1)] in
set_option maxRecDepth 8000 in