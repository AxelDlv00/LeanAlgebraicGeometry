---
author: sync
content_type: definition
created: '2026-07-31T03:02:21'
decl: AlgebraicGeometry.probeBaseChangeIdIso
file: ExplicitIdIsoProbe.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.probeBaseChangeIdIso
type: lean
updated: '2026-08-01T11:45:17'
---
noncomputable def probeBaseChangeIdIso (k : Type u) [Field k] :
    baseChange k k ≅ 𝟭 (Over (Spec (.of k))) := by
  let σ := Spec.map (CommRingCat.ofHom (algebraMap k k))
  have hσ : σ = 𝟙 (Spec (.of k)) := by
    dsimp [σ]
    simp
  letI : IsIso σ := by
    rw [hσ]
    infer_instance
  refine NatIso.ofComponents (fun C => ?_) ?_
  · letI : IsIso (pullback.fst C.hom σ) :=
      Limits.pullback_fst_iso_of_right_iso C.hom σ
    exact Over.isoMk (asIso (pullback.fst C.hom σ)) (by
      rw [pullback.condition]
      simp only [hσ, Category.comp_id])
  · intro C D f
    apply Over.OverMorphism.ext
    simp only [Functor.comp_obj, Functor.id_obj, Functor.comp_map, Functor.id_map,
      Over.comp_left, Over.isoMk_hom_left, Over.pullback_map_left]
    simp