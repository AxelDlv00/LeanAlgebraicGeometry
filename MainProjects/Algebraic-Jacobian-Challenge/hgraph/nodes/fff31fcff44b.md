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
  \ generation — see the module\ndocstring.\n\nThis is the universal-ledger form,\
  \ kept for existing consumers; the ledger is actually needed\nonly at the residuals\
  \ `D − D₀`, which is\n`exists_bound_subsingleton_h1Mod_of_residualLedger` above."
file: AlgebraicJacobian/RiemannRoch/Adelic/BoundedVanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.exists_bound_subsingleton_h1Mod
type: lean
updated: '2026-07-27T22:48:27'
---
theorem exists_bound_subsingleton_h1Mod
    (hledger : ∀ D : X.WeilDivisor, chi k U₀ U₁ D = chi k U₀ U₁ 0 + degK k D)
    (D₀ : X.WeilDivisor) (hbase : Subsingleton (H1Mod k U₀ U₁ D₀))
    (hpeel : ∀ D' : X.WeilDivisor,
      (∀ P : X.PrimeDivisor, (show X.PrimeDivisor →₀ ℤ from D₀) P ≤
        (show X.PrimeDivisor →₀ ℤ from D') P) →
      Peel k U₀ U₁ D₀ D') :
    ∃ b : ℤ, ∀ D : X.WeilDivisor, b ≤ degK k D →
      Subsingleton (H1Mod k U₀ U₁ D) :=
  exists_bound_subsingleton_h1Mod_of_residualLedger k U₀ U₁
    (fun D _ => hledger D) D₀ hbase hpeel

omit [IsIntegral X] [IsNoetherian X] [X.IsRegularInCodimensionOne] in