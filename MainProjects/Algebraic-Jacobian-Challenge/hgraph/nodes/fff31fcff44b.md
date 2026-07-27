---
author: sync
content_type: theorem
created: '2026-07-27T15:50:35'
decl: AlgebraicGeometry.Adelic.exists_bound_subsingleton_h1Mod
docstring: "**Single-field bounded `H¹` vanishing** (campaign P5, primary clause;\
  \ the\nstrongest form reachable in AJC today).\n\nGiven\n* a base divisor `D₀` with\
  \ `Ȟ¹(D₀) = 0`,\n* the **peel input** at `D₀`: for every `D' ≥ D₀`, each overlap\
  \ section of\n  `\U0001D4AA(D')` agrees modulo `B(D')` with an overlap section of\
  \ `\U0001D4AA(D₀)` — i.e. the\n  twist `Ȟ¹(D₀) → Ȟ¹(D')` is surjective (the ledger's\
  \ `htwist` datum, unwound),\n* the closed ledger,\n\nthere is a single threshold\
  \ `b = deg_k D₀ + 1 − χ(0)` past which `Ȟ¹(D)` vanishes\nfor **every** Weil divisor\
  \ `D` of weighted degree `≥ b`.\n\nThe bound depends only on `(k, U₀, U₁, D₀)`.\
  \  It is **not** uniform over field\nextensions and says **nothing** about global\
  \ generation — see the module\ndocstring."
file: AlgebraicJacobian/RiemannRoch/Adelic/BoundedVanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.exists_bound_subsingleton_h1Mod
type: lean
updated: '2026-07-27T16:23:54'
---
theorem exists_bound_subsingleton_h1Mod
    (hledger : ∀ D : X.WeilDivisor, chi k U₀ U₁ D = chi k U₀ U₁ 0 + degK k D)
    (D₀ : X.WeilDivisor) (hbase : Subsingleton (H1Mod k U₀ U₁ D₀))
    (hpeel : ∀ D' : X.WeilDivisor,
      (∀ P : X.PrimeDivisor, (show X.PrimeDivisor →₀ ℤ from D₀) P ≤
        (show X.PrimeDivisor →₀ ℤ from D') P) →
      Peel k U₀ U₁ D₀ D') :
    ∃ b : ℤ, ∀ D : X.WeilDivisor, b ≤ degK k D →
      Subsingleton (H1Mod k U₀ U₁ D) := by
  refine ⟨degK k D₀ + 1 - chi k U₀ U₁ 0, fun D hD => ?_⟩
  -- the residual class `D - D₀` has weighted degree ≥ 1 - χ(0), so it is effective
  obtain ⟨E, hEnonneg, hEclass⟩ :=
    exists_effective_linearEquiv_of_le_degK k U₀ U₁ hledger
      (D := D - D₀) (by rw [degK_sub]; omega)
  -- `D₀ + E ≥ D₀`, so peeling `E` off the base vanishing kills `Ȟ¹(D₀ + E)`
  have hmono : ∀ P : X.PrimeDivisor, (show X.PrimeDivisor →₀ ℤ from D₀) P ≤
      (show X.PrimeDivisor →₀ ℤ from D₀ + E) P := by
    intro P
    rw [show (show X.PrimeDivisor →₀ ℤ from D₀ + E) P =
          (show X.PrimeDivisor →₀ ℤ from D₀) P +
            (show X.PrimeDivisor →₀ ℤ from E) P from Finsupp.add_apply _ _ _]
    have := hEnonneg P
    linarith
  have hpeeled : Subsingleton (H1Mod k U₀ U₁ (D₀ + E)) :=
    subsingleton_h1Mod_peel k U₀ U₁ hbase (hpeel (D₀ + E) hmono) hmono
  -- `D₀ + E ~ D₀ + (D - D₀) = D`, so transport along the class
  obtain ⟨g, hg, hgE⟩ := hEclass
  have hshift : ∀ P : X.PrimeDivisor, (show X.PrimeDivisor →₀ ℤ from D) P =
      (show X.PrimeDivisor →₀ ℤ from D₀ + E) P - Scheme.RationalMap.order P g := by
    intro P
    have hDsub : D = (D₀ + E) - Scheme.WeilDivisor.principal g hg := by
      have : E = (D - D₀) + Scheme.WeilDivisor.principal g hg := by
        rw [← hgE]; abel
      rw [this]; abel
    rw [hDsub]
    exact sub_principal_apply hg P
  exact subsingleton_h1Mod_of_shift k U₀ U₁ hg hshift hpeeled

omit [IsIntegral X] [IsNoetherian X] [X.IsRegularInCodimensionOne] in