---
author: sync
content_type: theorem
created: '2026-07-29T01:14:28'
decl: AlgebraicGeometry.isQuasicoherent_pushPullObj_coverInter
docstring: '**The single-intersection-open push–pull object is quasi-coherent.**  For
  `U_σ = coverInterOpen

  𝒰 σ` with `f` separated and `S` affine, the open `U_σ` is affine (`coverInterOpen_isAffine`),
  hence

  its inclusion `j_σ` is an affine morphism into the separated `X` — so

  `pushPullObj F (Over.mk j_σ) = (j_σ)_*((j_σ)^* F)` is quasi-coherent by Stacks 01BG
  for the

  restriction and Stacks 01XJ for the pushforward.


  This is the input that turns the per-σ mate obligation of

  `cech_pushforward_baseChange_natIso_of_isIso` into an application of `canonicalBaseChangeMap_isIso`.

  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isQuasicoherent_pushPullObj_coverInter
type: lean
updated: '2026-07-29T01:14:28'
---
theorem isQuasicoherent_pushPullObj_coverInter (f : X ⟶ S) [IsSeparated f] [IsAffine S]
    (𝒰 : X.OpenCover) [∀ i, IsAffine (𝒰.X i)]
    {κ : Type} [Finite κ] [Nonempty κ] (σ : κ → 𝒰.I₀)
    (F : X.Modules) (hF : F.IsQuasicoherent) :
    (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))).IsQuasicoherent := by
  haveI hsepX : X.IsSeparated := by
    constructor
    rw [← terminal.comp_from f]
    exact IsSeparated.comp_iff.mpr ‹IsSeparated f›
  haveI : IsAffine (↑(coverInterOpen 𝒰 σ) : Scheme.{u}) := coverInterOpen_isAffine f 𝒰 σ
  haveI haff : IsAffineHom (Scheme.Opens.ι (coverInterOpen 𝒰 σ)) :=
    isAffineHom_of_isAffine_of_isSeparated _
  haveI haff' : IsAffineHom (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).hom := haff
  haveI : QuasiCompact (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).hom := inferInstance
  haveI : QuasiSeparated (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).hom := inferInstance
  haveI : ((Scheme.Modules.pullback (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).hom).obj
      F).IsQuasicoherent :=
    isQuasicoherent_pullback_opens (coverInterOpen 𝒰 σ) F hF
  exact Scheme.Modules.pushforward_isQuasicoherent
    (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))).hom _