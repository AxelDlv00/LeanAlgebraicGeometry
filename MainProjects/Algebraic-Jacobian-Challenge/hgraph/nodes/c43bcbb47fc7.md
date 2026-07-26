---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.Modules.ChartsCover.exists_finite_charts
docstring: 'Under `ChartsCover`, every affine open of `X` is covered by finitely

  many `e`-presentation charts contained in it.'
file: AlgebraicJacobian/Picard/EntryIdealStratum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.ChartsCover.exists_finite_charts
type: lean
updated: '2026-07-27T01:04:43'
---
theorem ChartsCover.exists_finite_charts (hcov : ChartsCover G e)
    (U : X.affineOpens) :
    ∃ (n : ℕ) (Vc : Fin n → X.affineOpens) (mmc : Fin n → ℕ)
      (_Pc : ∀ i, MatrixPresentation Γ(X, (Vc i).1) Γ(G, (Vc i).1) e (mmc i)),
      (∀ i, (Vc i).1 ≤ U.1) ∧ ∀ x ∈ U.1, ∃ i, x ∈ (Vc i).1 := by
  classical
  -- the subtype of presentation charts contained in `U`
  set J := {V : X.affineOpens // V.1 ≤ U.1 ∧ IsPresentationChart G e V}
  -- they cover `U`: shrink a global chart through a simultaneous basic open
  have hJcov : (U.1 : Set X) ⊆ ⋃ j : J, ((j.1.1 : TopologicalSpace.Opens X) : Set X) := by
    intro x hx
    obtain ⟨V, hxV, hVchart⟩ := hcov x
    obtain ⟨f, g, hfg, hxf⟩ :=
      exists_basicOpen_le_affine_inter U.2 V.2 x ⟨hx, hxV⟩
    have hle : (X.affineBasicOpen g).1 ≤ U.1 := by
      change X.basicOpen g ≤ U.1
      rw [← hfg]; exact X.basicOpen_le f
    refine Set.mem_iUnion.mpr
      ⟨⟨X.affineBasicOpen g, hle, hVchart.basicOpen G g⟩, ?_⟩
    change x ∈ X.basicOpen g
    rw [← hfg]; exact hxf
  -- extract a finite subcover by quasi-compactness of the affine open
  obtain ⟨T, hT⟩ := U.2.isCompact.elim_finite_subcover
    (fun j : J => ((j.1.1 : TopologicalSpace.Opens X) : Set X))
    (fun j => j.1.1.2) hJcov
  -- enumerate and choose presentations
  obtain ⟨n, eT⟩ : ∃ n, Nonempty (T ≃ Fin n) := ⟨T.card, ⟨T.equivFin⟩⟩
  obtain ⟨eT⟩ := eT
  choose mmc Pc using fun j : T => (j.1.2.2 : IsPresentationChart G e j.1.1)
  refine ⟨n, fun i => (eT.symm i).1.1, fun i => mmc (eT.symm i),
    fun i => (Pc (eT.symm i)).some, fun i => (eT.symm i).1.2.1,
    fun x hx => ?_⟩
  obtain ⟨j, hjT, hxj⟩ := Set.mem_iUnion₂.mp (hT hx)
  exact ⟨eT ⟨j, hjT⟩, by simpa using hxj⟩