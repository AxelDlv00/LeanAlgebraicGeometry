---
author: sync
content_type: definition
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.skyModuleGammaEquiv
docstring: '**Degree-zero cohomology of a skyscraper sheaf is its value**, `K`-linearly:
  `H⁰ ≃ₗ[K] M`.

  Global sections (`H⁰`) live over the terminal open `⊤`, which contains `x`, so the
  value is `M`.'
file: AlgebraicJacobian/RiemannRoch/Skyscraper.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.skyModuleGammaEquiv
type: lean
updated: '2026-08-01T09:44:18'
---
def skyModuleGammaEquiv (x : X) (M : ModuleCat.{u} K) :
    Sheaf.HModule (skyModule x M) 0 ≃ₗ[K] M :=
  (Sheaf.HModule.linearEquiv₀ (Opens.grothendieckTopology (X : TopCat))
      (isTerminalTop : IsTerminal (⊤ : X.Opens)) (skyModule x M)).trans
    (eqToIso (skyModule_obj_of_mem x M (Opens.mem_top x))).toLinearEquiv