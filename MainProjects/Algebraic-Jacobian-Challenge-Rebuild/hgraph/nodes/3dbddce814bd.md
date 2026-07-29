---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.whiskerLeft_inl_ofId
docstring: '**Diagonal coincidence on the curve product**: composed with the base
  inclusion

  `Spec` of `ofId A B`, the two lifted coprojections agree — the `C ◁ –` lift of

  `tensorInl_comp_ofId`. This is what cancels the `L`-terms in the ζ2·i comparison.'
file: AlgebraicJacobian/Picard/CoherentWitness.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.whiskerLeft_inl_ofId
type: lean
updated: '2026-07-29T15:26:17'
---
lemma whiskerLeft_inl_ofId :
    (C ◁ Over.overSpecMap (tensorInl (A := A) (B := B))).left
        ≫ (C ◁ Over.overSpecMap ((Algebra.ofId A B).restrictScalars k)).left
      = (C ◁ Over.overSpecMap (tensorInr (A := A) (B := B))).left
        ≫ (C ◁ Over.overSpecMap ((Algebra.ofId A B).restrictScalars k)).left := by
  rw [← Over.comp_left, ← Over.comp_left, ← MonoidalCategory.whiskerLeft_comp,
    ← MonoidalCategory.whiskerLeft_comp, ← Over.overSpecMap_comp, ← Over.overSpecMap_comp,
    tensorInl_comp_ofId]

end Over

/-! ## The packaging -/

set_option quotPrecheck false in
local notation "q₁" => (Over.overSpecMap (tensorInl (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "q₂" => (Over.overSpecMap (tensorInr (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "f₁₂" => (Over.overSpecMap (tensorFace₁₂ (k := k) (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "f₁₃" => (Over.overSpecMap (tensorFace₁₃ (k := k) (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "f₂₃" => (Over.overSpecMap (tensorFace₂₃ (k := k) (A := A) (B := B))).left