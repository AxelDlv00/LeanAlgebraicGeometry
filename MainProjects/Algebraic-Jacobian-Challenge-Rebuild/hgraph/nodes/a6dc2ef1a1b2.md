---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.coboundary_div_congr
docstring: 'Two elements cobounding the same comparison have equal ratios:

  from `a ⋅ P = Q ⋅ b` and `a'' ⋅ P = Q ⋅ b''` conclude `a / a'' = b / b''`.'
file: AlgebraicJacobian/Picard/ComparisonUnique.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.coboundary_div_congr
type: lean
updated: '2026-07-16T21:33:28'
---
private lemma coboundary_div_congr {G : Type u} [CommGroup G] {a a' b b' P Q : G}
    (h : a * P = Q * b) (h' : a' * P = Q * b') : a / a' = b / b' := by
  rw [div_eq_div_iff_mul_eq_mul]
  refine mul_right_cancel (b := P) ?_
  calc a * b' * P = a * P * b' := mul_right_comm a b' P
    _ = Q * b * b' := by rw [h]
    _ = Q * (b * b') := mul_assoc Q b b'
    _ = b * (Q * b') := mul_left_comm Q b b'
    _ = b * (a' * P) := by rw [h']
    _ = b * a' * P := (mul_assoc b a' P).symm

variable {k : Type u} [Field k]
variable {A B : Type u} [CommRing A] [CommRing B] [Algebra k A] [Algebra k B]
  [Algebra A B] [IsScalarTower k A B]
variable (C : Over (Spec (.of k))) (σ : overSpec k A ⟶ C)

-- Spec-side objects and maps
set_option quotPrecheck false in
local notation "SB" => (overSpec k B).left
set_option quotPrecheck false in
local notation "Sq" => (overSpec k (B ⊗[A] B)).left
set_option quotPrecheck false in
local notation "q₁" => (Over.overSpecMap (tensorInl (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "q₂" => (Over.overSpecMap (tensorInr (A := A) (B := B))).left
-- product-side objects and maps
set_option quotPrecheck false in
local notation "XB" => (C ⊗ overSpec k B).left
set_option quotPrecheck false in
local notation "Xq" => (C ⊗ overSpec k (B ⊗[A] B)).left
set_option quotPrecheck false in
local notation "u₁" => (C ◁ Over.overSpecMap (tensorInl (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "u₂" => (C ◁ Over.overSpecMap (tensorInr (A := A) (B := B))).left
-- the sections of the projections attached to the base changes of `σ`
set_option quotPrecheck false in
local notation "sB" => (Over.sectionOfPoint
  (Over.overSpecMap ((Algebra.ofId A B).restrictScalars k) ≫ σ)).left
set_option quotPrecheck false in
local notation "sq" => (Over.sectionOfPoint
  (Over.overSpecMap ((Algebra.ofId A (B ⊗[A] B)).restrictScalars k) ≫ σ)).left