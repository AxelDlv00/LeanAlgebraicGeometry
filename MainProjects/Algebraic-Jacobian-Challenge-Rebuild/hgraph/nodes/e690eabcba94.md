---
author: sync
content_type: theorem
created: '2026-07-22T10:02:16'
decl: AlgebraicGeometry.exists_divisorSections_pair_decomposition
docstring: 'Two arbitrary nonzero rational sections span a divisor window when their

  translated source divisors have the required supremum.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowPencilDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_divisorSections_pair_decomposition
type: lean
updated: '2026-07-22T10:02:16'
---
theorem exists_divisorSections_pair_decomposition
    (A B : X.CurveDivisor) (v0 v1 : X.functionFieldˣ)
    (hsup : (B - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) v0) ⊔
        (B - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) v1) = A)
    (h0 : Subsingleton (Sheaf.HModule (X.divisorSheaf K
      (B - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) v0)) 1))
    (h1 : Subsingleton (Sheaf.HModule (X.divisorSheaf K
      (B - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) v1)) 1))
    (hinf : Subsingleton (Sheaf.HModule (X.divisorSheaf K
      ((B - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) v0) ⊓
        (B - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) v1))) 1))
    (hsupH : Subsingleton (Sheaf.HModule (X.divisorSheaf K
      ((B - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) v0) ⊔
        (B - Scheme.divOf (X ↘ Spec (CommRingCat.of K)) v1))) 1))
    (x : divisorSections K A ⊤) :
    ∃ z : Fin 2 → divisorSections K B ⊤,
      (x : X.functionField) =
        (v0 : X.functionField) * (z 0 : X.functionField) +
          (v1 : X.functionField) * (z 1 : X.functionField) := by
  let D0 := Scheme.divOf (X ↘ Spec (CommRingCat.of K)) v0
  let D1 := Scheme.divOf (X ↘ Spec (CommRingCat.of K)) v1
  have hmap0 : Submodule.map (Scheme.mulLinear K (v0 : X.functionField))
      (divisorSections K B ⊤) = divisorSections K (B - D0) ⊤ := by
    rw [map_mulLinear_divisorSections_top K (Units.ne_zero v0) B]
    have hmk : Units.mk0 (v0 : X.functionField) (Units.ne_zero v0) = v0 := Units.ext rfl
    rw [hmk]
  have hmap1 : Submodule.map (Scheme.mulLinear K (v1 : X.functionField))
      (divisorSections K B ⊤) = divisorSections K (B - D1) ⊤ := by
    rw [map_mulLinear_divisorSections_top K (Units.ne_zero v1) B]
    have hmk : Units.mk0 (v1 : X.functionField) (Units.ne_zero v1) = v1 := Units.ext rfl
    rw [hmk]
  have hsections :
      Submodule.map (Scheme.mulLinear K (v0 : X.functionField))
          (divisorSections K B ⊤) ⊔
        Submodule.map (Scheme.mulLinear K (v1 : X.functionField))
          (divisorSections K B ⊤) = divisorSections K A ⊤ := by
    rw [hmap0, hmap1, divisorSections_sup K (B - D0) (B - D1) h0 h1 hinf hsupH,
      hsup]
  have hx : (x : X.functionField) ∈
      Submodule.map (Scheme.mulLinear K (v0 : X.functionField))
          (divisorSections K B ⊤) ⊔
        Submodule.map (Scheme.mulLinear K (v1 : X.functionField))
          (divisorSections K B ⊤) := by
    rw [hsections]
    exact x.property
  obtain ⟨a, ha, b, hb, hab⟩ := Submodule.mem_sup.mp hx
  obtain ⟨z0, hz0, rfl⟩ := ha
  obtain ⟨z1, hz1, rfl⟩ := hb
  let z : Fin 2 → divisorSections K B ⊤ := fun q =>
    if q = 0 then ⟨z0, hz0⟩ else ⟨z1, hz1⟩
  refine ⟨z, ?_⟩
  simpa [z, Scheme.mulLinear_apply] using hab.symm

omit [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)] in