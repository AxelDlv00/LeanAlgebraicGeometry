Target: blueprint/src/chapters/Picard_SectionGradedRing.tex
Action: Re-route the associator infrastructure for `lem:sheafTensorPow_add` to the
  analogist's Analogue 1 (recipe: analogies/snap-route.md). The prior Analogue-4
  "local-freeness avoids the associator" route is INSUFFICIENT — remove/supersede that claim.

Add ONE new lemma block (project-bespoke, no external source) for the crux:
  \label{lem:isIso_sheafification_whiskerRight_unit}
  \lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_whiskerRight_unit}
  Statement: for presheaves of modules P, Q on X, the morphism
  `sheafification.map (η_P ▷ Q)` is an isomorphism, where η is the
  sheafification-adjunction unit and ▷ the presheaf monoidal whiskering.
  Informal proof (from analogies/snap-route.md Analogue 1): reduce via
  `GrothendieckTopology.W_iff_isIso_map_of_adjunction` (W = J.W.inverseImage toPresheaf,
  ModuleCat/Sheaf/Localization.lean:48) to showing the underlying abelian morphism lies in
  J.W; present the relative-tensor as the coequalizer coeq(P⊗_ℤR₀⊗_ℤQ ⇉ P⊗_ℤQ); abelian
  sheafification is a left adjoint (preserves coequalizers); the abelian crux
  `GrothendieckTopology.W.monoidal` (Sites/Monoidal.lean, via isSheaf_functorEnrichedHom)
  gives W of η⊗_ℤ–, hence the induced map on the coequalizer is iso.

Then add a short corollary block deriving the sheaf-level associator
  `tensorObj (tensorObj A B) C ≅ tensorObj A (tensorObj B C)` on X.Modules
  (\lean{AlgebraicGeometry.Scheme.Modules.tensorObjAssoc}) FROM that crux + the presheaf
  associator, and wire `lem:sheafTensorPow_add`'s inductive step to \uses it (assoc ;
  tensorBraiding ; assoc⁻¹ ; whiskerRight IH, transported along Nat.succ_add).

Constraints: NO Lean tactic code. NO \leanok / \notready markers. Mathematical prose only.
  Update \uses{} accurately. Keep existing `def:sectionMul`/`sectionsMul` blocks intact.
  Out of scope: do NOT attempt full `MonoidalCategory (SheafOfModules)`; the crux iso + the
  one associator corollary is all `tensorPowAdd` needs.
