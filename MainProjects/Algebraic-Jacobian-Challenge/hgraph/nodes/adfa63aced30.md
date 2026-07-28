---
author: sync
content_type: definition
created: '2026-07-29T05:40:30'
decl: AlgebraicGeometry.bcv
docstring: The Beck-Chevalley iso for the square restricted over `U_σ`, before the
  slice transport.
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.bcv
type: lean
updated: '2026-07-29T05:40:30'
---
noncomputable def bcv (f : X ⟶ S) (g' : X' ⟶ X) (𝒰 : X.OpenCover) [IsSeparated f] [IsAffine S]
    [∀ i, IsAffine (𝒰.X i)] (F : X.Modules) (hF : F.IsQuasicoherent)
    {κ : Type} [Finite κ] [Nonempty κ] (σ : κ → 𝒰.I₀) :
    (Scheme.Modules.pullback g').obj
        (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) ≅
      pushPullObj ((Scheme.Modules.pullback g').obj F)
        (Over.mk (pullback.fst g' (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))) :=
  haveI := hsepX_of f
  openImmersion_beckChevalley g' (coverInterOpen_isAffine f 𝒰 σ)
    (pullback.fst g' (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))
    (pullback.snd g' (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))
    (restrictedCartesianAffinePushout g' 𝒰 σ) F hF

set_option maxHeartbeats 1600000 in
-- The `rfl` compares two four-factor Beck-Chevalley composites over an intersection open, so
-- whnf must unfold `openImmersion_beckChevalley` and both `isoOfRangeEq` transports.
set_option synthInstance.maxHeartbeats 800000 in