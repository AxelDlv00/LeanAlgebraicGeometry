---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.relPicDeg_relPicAlgMap_congr
docstring: '**Leg (i) of the zigzag (WD)**: a descent class on an étale cover of `Spec
  K`, read

  through any two `K`-algebra maps of the cover carrier into finite separable field

  extensions of `K`, has one relative degree.  The two readings are compared inside
  a

  finite separable field refinement of the product of the two field covers: the transport

  choice is immaterial by the descent keystone `relPicAlgMap_congr`, and the value
  along

  each comparison leg is invariant by `relPicDeg_relPicAlgMap` (E-iv-alg descended).'
file: AlgebraicJacobian/Picard/DegreeZero.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relPicDeg_relPicAlgMap_congr
type: lean
updated: '2026-08-01T09:44:11'
---
theorem relPicDeg_relPicAlgMap_congr {E : Algebra.EtaleCover K}
    {x : relPic C (overSpec k E.Carrier)} (hx : x ∈ descentClasses C E)
    {L₁ : Type u} [Field L₁] [Algebra k L₁] [Algebra K L₁] [IsScalarTower k K L₁]
    [Module.Finite K L₁] [Algebra.IsSeparable K L₁]
    {L₂ : Type u} [Field L₂] [Algebra k L₂] [Algebra K L₂] [IsScalarTower k K L₂]
    [Module.Finite K L₂] [Algebra.IsSeparable K L₂]
    (j₁ : E.Carrier →ₐ[K] L₁) (j₂ : E.Carrier →ₐ[K] L₂) :
    relPicDeg L₁ (relPicAlgMap C (j₁.restrictScalars k) x)
      = relPicDeg L₂ (relPicAlgMap C (j₂.restrictScalars k) x) := by
  obtain ⟨M, _, _, _, _, ⟨ℓ⟩⟩ :=
    ((Algebra.EtaleCover.ofField (K := K) L₁).prod
      (Algebra.EtaleCover.ofField (K := K) L₂)).exists_finiteSeparableField_algHom
  letI : Algebra k M := ((algebraMap K M).comp (algebraMap k K)).toAlgebra
  haveI : IsScalarTower k K M := .of_algebraMap_eq fun _ => rfl
  set θ₁ : L₁ →ₐ[K] M :=
    (ℓ.comp ((Algebra.EtaleCover.ofField (K := K) L₁).prodInl
        (Algebra.EtaleCover.ofField (K := K) L₂))).comp
      (Algebra.EtaleCover.ofFieldEquiv (K := K) L₁).symm.toAlgHom with hθ₁
  set θ₂ : L₂ →ₐ[K] M :=
    (ℓ.comp ((Algebra.EtaleCover.ofField (K := K) L₁).prodInr
        (Algebra.EtaleCover.ofField (K := K) L₂))).comp
      (Algebra.EtaleCover.ofFieldEquiv (K := K) L₂).symm.toAlgHom with hθ₂
  calc relPicDeg L₁ (relPicAlgMap C (j₁.restrictScalars k) x)
      = relPicDeg M (relPicAlgMap C (θ₁.restrictScalars k)
          (relPicAlgMap C (j₁.restrictScalars k) x)) :=
        (relPicDeg_relPicAlgMap (θ₁.restrictScalars k) _).symm
    _ = relPicDeg M (relPicAlgMap C ((θ₁.comp j₁).restrictScalars k) x) := by
        rw [show (θ₁.comp j₁).restrictScalars k
            = (θ₁.restrictScalars k).comp (j₁.restrictScalars k) from rfl,
          relPicAlgMap_comp]
    _ = relPicDeg M (relPicAlgMap C ((θ₂.comp j₂).restrictScalars k) x) := by
        rw [relPicAlgMap_congr C (θ₁.comp j₁) (θ₂.comp j₂) hx]
    _ = relPicDeg M (relPicAlgMap C (θ₂.restrictScalars k)
          (relPicAlgMap C (j₂.restrictScalars k) x)) := by
        rw [show (θ₂.comp j₂).restrictScalars k
            = (θ₂.restrictScalars k).comp (j₂.restrictScalars k) from rfl,
          relPicAlgMap_comp]
    _ = relPicDeg L₂ (relPicAlgMap C (j₂.restrictScalars k) x) :=
        relPicDeg_relPicAlgMap (θ₂.restrictScalars k) _