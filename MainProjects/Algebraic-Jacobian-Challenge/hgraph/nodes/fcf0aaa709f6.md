---
author: sync
content_type: definition
created: '2026-07-29T07:30:32'
decl: AlgebraicGeometry.BcSquareNaturality
docstring: '**HALF (a), the crux of the twisted leaf, as a named `Prop`.**  Naturality
  of the

  restricted-square Beck–Chevalley iso `bcv` in the SQUARE: for the intersection-open
  inclusion

  `U_{σ''} ⊆ U_{σ''∘δᵏ}` and its base change `wmap`, base-change-then-restrict equals

  restrict-then-base-change.


  This is exactly the hypothesis `hBC` of `twistedPerSigmaCompat_of_bcNaturality`,
  and by that theorem

  plus `twistedComponent_δ_square` it is the ONLY thing between this file and Stacks
  02KG/02KH.  It is

  *not* `openImmersion_bareBC_app_eq` (naturality in the module) nor `pushPullMap_comp`/`_id`
  (functor

  laws in the slice variable): nothing in the tree relates the mate across a change
  of square.

  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BcSquareNaturality
type: lean
updated: '2026-07-29T07:30:32'
---
def BcSquareNaturality (f : X ⟶ S) (g' : X' ⟶ X) (𝒰 : X.OpenCover) [IsSeparated f] [IsAffine S]
    [∀ i, IsAffine (𝒰.X i)] (F : X.Modules) (hF : F.IsQuasicoherent) : Prop :=
  ∀ (p : ℕ) (k : Fin (p + 2)) (σ' : Fin (p + 2) → 𝒰.I₀),
    (bcv f g' 𝒰 F hF (σ' ∘ (SimplexCategory.δ k).toOrderHom)).hom ≫
        pushPullMap ((Scheme.Modules.pullback g').obj F)
          (wmap g' 𝒰 (SimplexCategory.δ k).toOrderHom σ')
      = (Scheme.Modules.pullback g').map (pushPullMap F (interLegHom 𝒰 σ' k)) ≫
          (bcv f g' 𝒰 F hF σ').hom