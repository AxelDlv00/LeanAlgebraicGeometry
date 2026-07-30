---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.finrank_le_finrank_annKernel_add
docstring: '**The codimension bound** (★, probe 3a): if `Λ` kills every product `U
  · T` for a

  subspace `T ≤ V` of codimension `c` (`dim T + c = dim V`), then

  `dim U ≤ dim N_Λ + c`. The map `Φ : U → Dual(V)`, `h ↦ Λ(h · –)`, has kernel `N_Λ`
  and

  range inside the annihilator of `T` in `Dual(V)`, of dimension `c`.'
file: AlgebraicJacobian/RiemannRoch/AnnihilatorKernel.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.finrank_le_finrank_annKernel_add
type: lean
updated: '2026-07-30T15:28:03'
---
theorem finrank_le_finrank_annKernel_add {U V T : Submodule K X.functionField}
    [Module.Finite K ↥U] [Module.Finite K ↥V]
    {Λ : Module.Dual K X.functionField} {c : ℕ}
    (hTV : T ≤ V) (hc : Module.finrank K ↥T + c = Module.finrank K ↥V)
    (hkill : ∀ h ∈ U, ∀ f ∈ T, Λ (h * f) = 0) :
    Module.finrank K ↥U ≤ Module.finrank K ↥(Scheme.annKernel K U V Λ) + c := by
  classical
  -- the bilinear evaluation `Φ : U →ₗ Dual(V)`, `h ↦ Λ(h · –)`
  set Φ : ↥U →ₗ[K] Module.Dual K ↥V :=
    { toFun := fun h => (Λ.comp (Scheme.mulLinear K (h : X.functionField))).domRestrict V
      map_add' := fun a b => by
        refine LinearMap.ext (fun f => ?_)
        simp only [LinearMap.domRestrict_apply, LinearMap.comp_apply,
          Scheme.mulLinear_apply, LinearMap.add_apply, Submodule.coe_add]
        rw [add_mul, map_add]
      map_smul' := fun r a => by
        refine LinearMap.ext (fun f => ?_)
        simp only [LinearMap.domRestrict_apply, LinearMap.comp_apply,
          Scheme.mulLinear_apply, RingHom.id_apply, LinearMap.smul_apply,
          Submodule.coe_smul]
        rw [Scheme.functionFieldOverModule_smul_def, mul_assoc,
          ← Scheme.functionFieldOverModule_smul_def, map_smul] } with hΦ
  -- the kernel of `Φ` is the annihilator kernel
  have hker : Submodule.map U.subtype (LinearMap.ker Φ) = Scheme.annKernel K U V Λ := by
    apply le_antisymm
    · rintro _ ⟨h, hh, rfl⟩
      have hval : ∀ f : ↥V, Λ ((h : X.functionField) * f) = 0 := fun f =>
        DFunLike.congr_fun (LinearMap.mem_ker.mp hh) f
      exact ⟨h.2, fun f hf => hval ⟨f, hf⟩⟩
    · rintro h ⟨hhU, hann⟩
      refine Submodule.mem_map.mpr ⟨⟨h, hhU⟩, ?_, rfl⟩
      rw [LinearMap.mem_ker]
      refine LinearMap.ext (fun f => ?_)
      exact hann f f.2
  -- the range of `Φ` lies in the annihilator of `T` inside `Dual(V)`
  set T' : Submodule K ↥V := T.comap V.subtype with hT'
  have hrange : LinearMap.range Φ ≤ T'.dualAnnihilator := by
    rintro _ ⟨h, rfl⟩
    rw [Submodule.mem_dualAnnihilator]
    intro w hw
    simp only [hΦ, LinearMap.coe_mk, AddHom.coe_mk, LinearMap.domRestrict_apply,
      LinearMap.comp_apply, Scheme.mulLinear_apply]
    exact hkill h h.2 w hw
  -- dimension of the annihilator of `T'`: `c`
  have hT'rank : Module.finrank K ↥T' = Module.finrank K ↥T :=
    (Submodule.comapSubtypeEquivOfLe hTV).finrank_eq
  have hannrank := Subspace.finrank_add_finrank_dualAnnihilator_eq T'
  -- rank–nullity
  have hrn := LinearMap.finrank_range_add_finrank_ker Φ
  have hkerrank : Module.finrank K ↥(LinearMap.ker Φ)
      = Module.finrank K ↥(Scheme.annKernel K U V Λ) := by
    rw [← hker]
    exact (Submodule.equivSubtypeMap U (LinearMap.ker Φ)).finrank_eq
  have hrle : Module.finrank K ↥(LinearMap.range Φ)
      ≤ Module.finrank K ↥T'.dualAnnihilator :=
    Submodule.finrank_mono hrange
  have hdual : Module.finrank K (Module.Dual K ↥V) = Module.finrank K ↥V :=
    Subspace.dual_finrank_eq
  omega