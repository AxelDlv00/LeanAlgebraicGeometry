---
author: sync
content_type: lemma
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.Scheme.IsGluingCoboundary.inv
docstring: '**Inversion of the coboundary**: if `g''` is cohomologous to `g` through
  `c`, then

  `g` is cohomologous to `g''` through the inverse cochain `c⁻¹`.'
file: AlgebraicJacobian/Cohomology/GluedSheafCongr.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.IsGluingCoboundary.inv
type: lean
updated: '2026-07-17T08:41:24'
---
lemma inv (hc : Scheme.IsGluingCoboundary U g g' c) :
    Scheme.IsGluingCoboundary U g' g (fun j => (c j)⁻¹) := by
  intro i j
  set a := X.resHom (inf_le_left : U i ⊓ U j ≤ U i) (c i : Γ(X, U i)) with ha
  set a' := X.resHom (inf_le_left : U i ⊓ U j ≤ U i)
    (((c i)⁻¹ : Γ(X, U i)ˣ) : Γ(X, U i)) with ha'
  set b := X.resHom (inf_le_right : U i ⊓ U j ≤ U j) (c j : Γ(X, U j)) with hb
  set b' := X.resHom (inf_le_right : U i ⊓ U j ≤ U j)
    (((c j)⁻¹ : Γ(X, U j)ˣ) : Γ(X, U j)) with hb'
  have haa : a' * a = 1 := by rw [ha, ha', ← map_mul, Units.inv_mul, map_one]
  have hbb : b * b' = 1 := by rw [hb, hb', ← map_mul, Units.mul_inv, map_one]
  have key : a * (g i j : Γ(X, U i ⊓ U j)) = (g' i j : Γ(X, U i ⊓ U j)) * b := hc i j
  calc a' * (g' i j : Γ(X, U i ⊓ U j))
      = a' * (g' i j : Γ(X, U i ⊓ U j)) * (b * b') := by rw [hbb, mul_one]
    _ = a' * ((g' i j : Γ(X, U i ⊓ U j)) * b) * b' := by ring
    _ = a' * (a * (g i j : Γ(X, U i ⊓ U j))) * b' := by rw [key]
    _ = (a' * a) * (g i j : Γ(X, U i ⊓ U j)) * b' := by ring
    _ = (g i j : Γ(X, U i ⊓ U j)) * b' := by rw [haa, one_mul]

end Scheme.IsGluingCoboundary

section Congr

variable (k : Type u) [CommRing k] {X : Scheme.{u}} [X.Over (Spec (.of k))]

attribute [local instance] Scheme.overModule

variable {J : Type u} {U : J → X.Opens} {g g' : ∀ i j : J, Γ(X, U i ⊓ U j)ˣ}
variable (c : ∀ j : J, Γ(X, U j)ˣ)