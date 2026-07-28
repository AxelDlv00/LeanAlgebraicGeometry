---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.twisted_cech_nerve_iso
docstring: "**The base-changed nerve is the nerve of the base-changed data** (Stacks\
  \ 02KG, the\nmechanical half). Applying `(g')^*` (at the `X`-level) to the dropped\
  \ Čech nerve of\n`(\U0001D4B0, F)` yields the dropped Čech nerve of the base-changed\
  \ data `(\U0001D4B0', (g')^* F)`, where\n`\U0001D4B0' = (openCoverOfLeft \U0001D4B0\
  \ f g).pushforwardIso h.isoPullback.symm.hom` is the base change of\n`\U0001D4B0\
  ` along `g'`:\n```\n  g'^* ∘ drop(nerve \U0001D4B0 F)  ≅  drop(nerve \U0001D4B0\
  ' (g'^* F)).\n```\nThe geometric backbone `coverCechNerve` of `\U0001D4B0` base-changes\
  \ to that of `\U0001D4B0'`: the fibre\npowers `U_{i₀} ×_X ⋯ ×_X U_{iₚ}` commute\
  \ with the base change `g'` (pullback preserves fibre\nproducts), so the preimages\
  \ `(g')⁻¹(U_{i₀…iₚ})` are exactly the corresponding intersections\nof `\U0001D4B0\
  '`. The pullback then commutes with the push–pull functor `pushPullFunctor` termwise\
  \ —\nitself a Beck–Chevalley identification `g'^* (p_* p^* F) ≅ p'_* p'^* (g'^*\
  \ F)` for the\nrestricted cartesian square — and the identifications are compatible\
  \ with the cosimplicial\nstructure maps because both are induced by the same inclusions\
  \ of intersections.\n\n*(STUB — the residual `sorry` is the termwise commuting of\
  \ `g'^*` with `pushPullFunctor`\nalong the base-changed fibre powers; structurally\
  \ lighter than\n`cech_pushforward_baseChange_natIso` but still a Beck–Chevalley\
  \ identification.)*\nProject-local."
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.twisted_cech_nerve_iso
type: lean
updated: '2026-07-28T13:22:16'
---
noncomputable def twisted_cech_nerve_iso
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    [IsSeparated f] [IsAffine S] [∀ i, IsAffine (𝒰.X i)]
    [Finite ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).I₀]
    [∀ i, IsAffine (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) :
    ((CosimplicialObject.whiskering X.Modules X'.Modules).obj
        (Scheme.Modules.pullback g')).obj
      (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F))
      ≅ CosimplicialObject.Augmented.drop.obj
          (CechNerve ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
            h.isoPullback.symm.hom) ((Scheme.Modules.pullback g').obj F)) :=
  -- LHS COPRODUCT/PRODUCT LAYER — NOW CLOSED (compiling).  The degree-`n` `app` obligation is the
  -- X-level Beck–Chevalley iso
  --     `(pullback g').obj (pushPullObj F Yₙ) ≅ pushPullObj (g'^* F) Y'ₙ`
  -- (`g'^*(p_* p^* F) ≅ p'_* p'^*(g'^* F)`), where `Yₙ = (coverCechNerveOver 𝒰).obj (op n)` and
  -- `Y'ₙ = (coverCechNerveOver 𝒰').obj (op n)` for the base-changed cover `𝒰'`.  The LHS
  -- decomposes as a product over the index tuples `σ` via the sorry-free `pushPull_sigma_iso` and
  -- preservation of finite products by `pullback g'` (`PreservesProduct.iso`):
  --     LHS ≅ ∏_σ (pullback g').obj (pushPullObj F (Over.mk j_σ)).
  --
  -- RESIDUAL (the genuine open content + the RHS-matching obstruction): the remaining goal is
  --     `∏_σ (pullback g').obj (pushPullObj F (Over.mk j_σ)) ≅ pushPullObj (g'^* F) Y'ₙ`.
  -- The per-σ X-level Beck–Chevalley iso `(pullback g').obj (pushPullObj F (Over.mk j_σ)) ≅
  -- pushPullObj (g'^* F) (Over.mk j'_σ)` (base change of push–pull along the open immersion j_σ,
  -- for the restricted cartesian square over `U_σ`) is the per-σ content; reassembling
  -- the σ-product on the RHS would use `(pushPull_sigma_iso 𝒰' (g'^* F) n.len).symm`, but
  -- that needs
  -- `[Finite 𝒰'.I₀]` and `[∀ i, IsAffine (𝒰'.X i)]` for the base-changed cover `𝒰'`, which are NOT
  -- available in this signature (the X-level leaf carries no `[IsAffine S']`; the
  -- base-changed cover members' affineness is the geometric cover-base-change route
  -- `coverInterOpen 𝒰' σ = g'⁻¹(U_σ)`).
  -- That cover-base-change identification is the residual Beck–Chevalley heart of this leaf.
  -- STEP-1 sig extension landed `[Finite 𝒰'.I₀]`/`[∀ i, IsAffine (𝒰'.X i)]` for the base-changed
  -- cover `𝒰'`, so the σ-product on the RHS *can now* be reassembled by
  -- `(pushPull_sigma_iso 𝒰' (g'^* F) n.len).symm`.  The residual per-σ content is isolated into the
  -- named leaf `twisted_cech_nerve_per_sigma` (the open-immersion Beck–Chevalley and
  -- cover-base-change identification). Only the cosimplicial `naturality` remains beyond
  -- that leaf.
  NatIso.ofComponents
    (fun n =>
      (Scheme.Modules.pullback g').mapIso (pushPull_sigma_iso 𝒰 F n.len) ≪≫
        Limits.PreservesProduct.iso (Scheme.Modules.pullback g') _ ≪≫
        Limits.Pi.mapIso (fun σ => twisted_cech_nerve_per_sigma f g f' g' h 𝒰 F hF σ) ≪≫
        (pushPull_sigma_iso ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
          h.isoPullback.symm.hom) ((Scheme.Modules.pullback g').obj F) n.len).symm)
    (fun {n m} φ => sorry)