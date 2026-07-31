---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.TwoCover.h1AddEquivTruncExpCechKernel
docstring: '**The truncated-exponential Čech kernel computation of `H¹`** (Kleiman
  §5

  Thm 5.11, cocycle leg, carrier form — W5-T2 keystone): for a scheme `X` over `Spec
  k`

  and two affine opens `U₀ ⊔ U₁ = ⊤`, the degree-one cohomology of the structure sheaf

  is additively the kernel of the dual-number Čech-units reduction of the cover:


  ```

  H¹ₖ(X, 𝒪)  ≃+  ker( Ȟ¹ˣ(Γ(U₀ ⊓ U₁)[ε]) →* Ȟ¹ˣ(Γ(U₀ ⊓ U₁)) )

  ```


  — the two-cover Čech form of `H¹(C, 𝒪_C) ≅ ker(Pic(C_ε) → Pic(C))`. Composite of
  the

  landed `h1CokEquiv`, the carrier translation `h1CokAddEquivCechQuot`, and the engine

  `TruncExpCech.truncExpCechKernelAddEquiv`. On generators: `delta s ↦ truncExpClass
  s`

  (`h1AddEquivTruncExpCechKernel_delta`). Additive only, BY DESIGN — see the module

  docstring for the `k`-action interface (`mumfordScaling` equivariance).'
file: AlgebraicJacobian/Tangent/TruncExpCechH1.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.TwoCover.h1AddEquivTruncExpCechKernel
type: lean
updated: '2026-07-31T20:14:51'
---
noncomputable def h1AddEquivTruncExpCechKernel (hcov : U₀ ⊔ U₁ = ⊤)
    (hU₀ : IsAffineOpen U₀) (hU₁ : IsAffineOpen U₁) :
    Sheaf.HModule (X.moduleKSheaf k) 1 ≃+ Additive (unitsReduction X U₀ U₁).ker :=
  (h1CokEquiv k X U₀ U₁ hcov hU₀ hU₁).toAddEquiv.trans
    ((h1CokAddEquivCechQuot k X U₀ U₁).trans
      (truncExpCechKernelAddEquiv (X.resHom (inf_le_left : U₀ ⊓ U₁ ≤ U₀))
        (X.resHom (inf_le_right : U₀ ⊓ U₁ ≤ U₁))))

variable (hcov : U₀ ⊔ U₁ = ⊤) (hU₀ : IsAffineOpen U₀) (hU₁ : IsAffineOpen U₁)