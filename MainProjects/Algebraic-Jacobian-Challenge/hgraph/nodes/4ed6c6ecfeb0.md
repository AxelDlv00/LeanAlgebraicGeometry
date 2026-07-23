---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.isIso_snd_app_of_isAffineOpen
docstring: '**Step A: the per-affine-open comparison is an isomorphism.**  For a proper
  geometrically

  integral curve `C/k`, an arbitrary base `T` with structure map `πT : T ⟶ Spec k`,
  and any affine

  open `V ⊆ T`, the structure-sheaf comparison `Γ(T, V) → Γ(C ×_k T, π⁻¹ V)`

  (`π = pullback.snd C.hom πT`) is an isomorphism.  This is P1 at the affine base
  `V.toScheme`

  (`bijective_snd_appTop_of_isAffine` with structure map `V.ι ≫ πT`) transported across
  the

  identification `π ⁻¹ᵁ V ≅ C ×_k V` supplied by pullback pasting (`pullbackLeftPullbackSndIso`)
  and

  the restriction-pullback isomorphism (`pullbackRestrictIsoRestrict`).'
file: AlgebraicJacobian/Picard/StructureSheafPushforward.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.isIso_snd_app_of_isAffineOpen
type: lean
updated: '2026-07-16T21:14:28'
---
theorem isIso_snd_app_of_isAffineOpen (C : Over (Spec (CommRingCat.of k)))
    [IsProper C.hom] [GeometricallyIntegral C.hom]
    {T : Scheme.{u}} (πT : T ⟶ Spec (CommRingCat.of k))
    {V : T.Opens} (hV : IsAffineOpen V) :
    IsIso ((pullback.snd C.hom πT).app V) := by
  haveI : IsAffine V.toScheme := hV
  set π := pullback.snd C.hom πT with hπ
  -- P1 at the affine base `V.toScheme`, structure map `V.ι ≫ πT`.
  haveI hbase : IsIso ((pullback.snd C.hom (V.ι ≫ πT)).appTop) :=
    (ConcreteCategory.isIso_iff_bijective _).mpr (bijective_snd_appTop_of_isAffine C (V.ι ≫ πT))
  -- Transport 1: the pasting iso `pullback π V.ι ≅ pullback C.hom (V.ι ≫ πT)`.
  haveI h1 : IsIso ((pullback.snd π V.ι).appTop) :=
    isIso_appTop_of_isoSq (b := pullback.snd C.hom (V.ι ≫ πT))
      (pullbackLeftPullbackSndIso C.hom πT V.ι) (Iso.refl _)
      (by rw [Iso.refl_hom, Category.comp_id]
          exact (pullbackLeftPullbackSndIso_hom_snd C.hom πT V.ι).symm)
  -- Transport 2: the restriction-pullback iso `(π ⁻¹ᵁ V).toScheme ≅ pullback π V.ι`.
  haveI h2 : IsIso ((π ∣_ V).appTop) :=
    isIso_appTop_of_isoSq (b := pullback.snd π V.ι)
      (pullbackRestrictIsoRestrict π V).symm (Iso.refl _) (by simp [morphismRestrict])
  -- Convert `(π ∣_ V).appTop` to `π.app V` via `morphismRestrict_appTop`.  The trailing factor is
  -- `presheaf.map` of an `eqToHom`, hence an isomorphism.
  have happ := morphismRestrict_appTop π V
  haveI hg_iso : IsIso ((pullback C.hom πT).presheaf.map
      (eqToHom (image_morphismRestrict_preimage π V ⊤)).op) := by
    rw [eqToHom_op, eqToHom_map]; infer_instance
  -- `happ : (π ∣_ V).appTop = π.app (V.ι ''ᵁ ⊤) ≫ g` with `g` the iso above; peel off `g`.
  have h2' : IsIso (π.app (V.ι ''ᵁ ⊤) ≫ (pullback C.hom πT).presheaf.map
      (eqToHom (image_morphismRestrict_preimage π V ⊤)).op) := by rw [← happ]; exact h2
  haveI happV : IsIso (π.app (V.ι ''ᵁ ⊤)) := (isIso_comp_right_iff _ _).mp h2'
  have hVeq : V.ι ''ᵁ ⊤ = V := V.ι_image_top
  exact hVeq ▸ happV

/-! ## P2: the sheaf-level H⁰ base-change brick over an arbitrary base `T`

For an arbitrary `k`-scheme `T` with structure morphism `πT : T ⟶ Spec k`, the structure-sheaf
comparison `𝒪_T ⟶ π_* 𝒪_{C×T}` (`π = pullback.snd C.hom πT`) is an isomorphism.  The proof route
(Kleiman §2; cohomology-and-base-change in degree `0`) is: for every affine open `V ⊆ T` the
restricted comparison `Γ(T, V) → Γ(C × T, π⁻¹V)` is the P1 base-change iso at `A = Γ(V, 𝒪)`
(because `π⁻¹V ≅ C ×_k V`), and these per-affine-open isos assemble to a sheaf isomorphism on the
affine-opens basis `T.isBasis_affineOpens` via stalks (mirroring
`QuotScheme.isIso_sheaf_of_isIso_app_basicOpen`).

This is now proved **unconditionally for every base** in `isIso_snd_appTop` below (Step A per
affine open + Step B stalk assembly).  The `Prop`-class `HasStructureSheafPushforwardIso` is
retained as a lightweight interface and discharged unconditionally by
`instHasStructureSheafPushforwardIso`, so every downstream consumer (`lm:aut`) fires for arbitrary
`T`. -/