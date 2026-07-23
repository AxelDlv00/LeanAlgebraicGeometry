---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.Modules.chartFiberRank_basicOpen
docstring: 'The chart fiber rank is unchanged by passing to a basic open of the

  chart.'
file: AlgebraicJacobian/Picard/EntryIdealStratum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.chartFiberRank_basicOpen
type: lean
updated: '2026-07-24T03:02:10'
---
theorem chartFiberRank_basicOpen {V : X.affineOpens} (f : Γ(X, V.1))
    (x : X) (hx : x ∈ X.basicOpen f) :
    chartFiberRank G (V := V) x (X.basicOpen_le f hx) =
      chartFiberRank G (V := X.affineBasicOpen f) x hx := by
  haveI := V.2.isLocalization_basicOpen f
  haveI := Scheme.Modules.isLocalizedModule_basicOpen G V.2 f
  have hloc := Ideal.fiberRank_of_isLocalizedModule (Submonoid.powers f)
    (restrictBasicOpenₗ G f)
    (((V.2.basicOpen f).primeIdealOf ⟨x, hx⟩).asIdeal)
  have hle : X.basicOpen f ≤ (𝟙 X : X ⟶ X) ⁻¹ᵁ V.1 := X.basicOpen_le f
  have h1 := IsAffineOpen.comap_primeIdealOf_appLE (f := (𝟙 X : X ⟶ X))
    V.1 V.2 (X.basicOpen f) (V.2.basicOpen f) hle hx
  rw [Scheme.id_appLE] at h1
  have hpt : V.2.primeIdealOf ⟨(𝟙 X : X ⟶ X) x, hle hx⟩ =
      V.2.primeIdealOf ⟨x, X.basicOpen_le f hx⟩ := by
    congr 1
  have hcomap :
      (((V.2.basicOpen f).primeIdealOf ⟨x, hx⟩).asIdeal).comap
          (algebraMap Γ(X, V.1) Γ(X, X.basicOpen f)) =
        (V.2.primeIdealOf ⟨x, X.basicOpen_le f hx⟩).asIdeal := by
    have h2 : algebraMap Γ(X, V.1) Γ(X, X.basicOpen f) =
        (X.presheaf.map (homOfLE (X.basicOpen_le f)).op).hom := rfl
    rw [h2, ← hpt]
    exact congrArg PrimeSpectrum.asIdeal h1
  calc chartFiberRank G (V := V) x (X.basicOpen_le f hx)
      = ((((V.2.basicOpen f).primeIdealOf ⟨x, hx⟩).asIdeal).comap
          (algebraMap Γ(X, V.1) Γ(X, X.basicOpen f))).fiberRank Γ(G, V.1) :=
        Ideal.fiberRank_congr_ideal hcomap.symm
    _ = (((V.2.basicOpen f).primeIdealOf ⟨x, hx⟩).asIdeal).fiberRank
          Γ(G, X.basicOpen f) := hloc.symm
    _ = chartFiberRank G (V := X.affineBasicOpen f) x hx := rfl