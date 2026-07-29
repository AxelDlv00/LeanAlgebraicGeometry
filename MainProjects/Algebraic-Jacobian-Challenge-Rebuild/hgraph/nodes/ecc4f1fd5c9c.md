---
author: sync
content_type: lemma
created: '2026-07-24T17:02:47'
decl: '`divRepClassifyZar_isDivRepClassify`'
file: AlgebraicJacobian/Picard/DivRepClassifyZar.lean
generated: lean
lean_status: lean_ok
stale: true
title: '`divRepClassifyZar_isDivRepClassify`'
type: lean
updated: '2026-07-29T11:07:22'
---
  lemma `divRepClassifyZar_isDivRepClassify` and the well-definedness lemma
  `divRepClassifyZar_eq_of_isDivRepClassify` (any Over-hom whose scheme morphism
  satisfies the clause IS the classified one — Law 2's uniqueness input).
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161). -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits
open scoped TensorProduct

namespace AlgebraicGeometry

open Grassmannian

section Curve

open Scheme

variable {k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))}
variable {π : C.left ⟶ P1 k} [IsFinite π]

noncomputable local instance instOverCleftRepClassifyZar :
    C.left.Over (Spec (CommRingCat.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k))]
  [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (CommRingCat.of k))]
  [QuasiCompact (C.left ↘ Spec (CommRingCat.of k))]
  [IsDominant π]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g : ℕ)
variable (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
variable (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
variable (r₁ r₂ : ℕ)
variable (b₁ : Module.Basis (Fin r₁) k
  ↥(divisorSections k (windowM_choice π hπ g • fiberWeilDivisor π) ⊤))
variable (b₂ : Module.Basis (Fin r₂) k
  ↥(divisorSections k
    ((windowM_choice π hπ g + windowS_choice π hπ g) • fiberWeilDivisor π) ⊤))
variable {S : Type u} [CommRing S] [Algebra k S]