---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Scheme.twoCoverH1LinearEquiv
docstring: '**The two-cover H¹ computation, general coefficients.** For a sheaf `F`
  of

  `k`-modules on the small Zariski site of `X`, two opens with `U₀ ⊔ U₁ = ⊤` and

  vanishing `H¹''(U₀, F)`, `H¹''(U₁, F)`, the degree-one cohomology of the site is
  the

  cokernel of the restriction-difference map `F(U₀) × F(U₁) → F(U₀ ⊓ U₁)`.'
file: AlgebraicJacobian/Cohomology/TwoCover.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.twoCoverH1LinearEquiv
type: lean
updated: '2026-07-29T15:26:08'
---
noncomputable def Scheme.twoCoverH1LinearEquiv
    (F : Sheaf (Opens.grothendieckTopology (X : TopCat)) (ModuleCat.{u} k))
    (hcov : U₀ ⊔ U₁ = ⊤)
    [Subsingleton (Sheaf.HModule' F U₀ 1)] [Subsingleton (Sheaf.HModule' F U₁ 1)] :
    Sheaf.HModule F 1 ≃ₗ[k]
      (F.obj.obj (op (U₀ ⊓ U₁)) ⧸
        LinearMap.range ((X.twoCoverSquare U₀ U₁ hcov).moduleDiff F)) :=
  letI : Subsingleton (Sheaf.HModule' F (X.twoCoverSquare U₀ U₁ hcov).X₂ 1) :=
    inferInstanceAs (Subsingleton (Sheaf.HModule' F U₀ 1))
  letI : Subsingleton (Sheaf.HModule' F (X.twoCoverSquare U₀ U₁ hcov).X₃ 1) :=
    inferInstanceAs (Subsingleton (Sheaf.HModule' F U₁ 1))
  (Sheaf.HModule.linearEquivHModule' (isTerminalTop : IsTerminal (⊤ : X.Opens)) F 1).trans
    ((X.twoCoverSquare U₀ U₁ hcov).h1LinearEquiv F).symm

end GeneralCoefficients

namespace TwoCover

variable (k : Type u) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))]
variable (U₀ U₁ : X.Opens)

attribute [local instance] Scheme.overModule