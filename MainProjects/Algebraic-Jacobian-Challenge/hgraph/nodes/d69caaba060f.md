---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.overRestrictUnitIso
docstring: '**The slice-to-geometric equivalence functor sends `unit` to `unit`**
  (gap1, P1).


  For an open `U ⊆ X`, the functor of the slice-to-geometric equivalence `overRestrictEquiv
  U`

  (definitionally `SheafOfModules.pushforward` along `(Opens.overEquivalence U).inverse`
  with the

  identity ring comparison) carries the sliced structure-sheaf module `unit (O_X.over
  U)` to the

  structure-sheaf module `unit (U.toScheme.ringCatSheaf)` of the open subscheme. This
  is the

  `F.obj (unit R) ≅ unit S` datum consumed by `SheafOfModules.Presentation.map` in

  `overRestrictPresentation`. Project-local.'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.overRestrictUnitIso
type: lean
updated: '2026-07-16T21:14:27'
---
noncomputable def overRestrictUnitIso (U : X.Opens) :
    (overRestrictEquiv U).functor.obj (SheafOfModules.unit (X.ringCatSheaf.over U)) ≅
      SheafOfModules.unit U.toScheme.ringCatSheaf := by
  unfold overRestrictEquiv
  try dsimp only [Equivalence.symm_functor]
  refine (@asIso _ _ _ _ (SheafOfModules.unitToPushforwardObjUnit
      (F := (Opens.overEquivalence U).inverse) (J := Opens.grothendieckTopology ↥U)
      (S := U.toScheme.ringCatSheaf) (R := X.ringCatSheaf.over U)
      (ObjectProperty.homMk (𝟙 _)))
    (isIso_unitToPushforwardObjUnit_of_isIso' _ ?hpsi)).symm
  exact inferInstanceAs (IsIso (𝟙 U.toScheme.ringCatSheaf))