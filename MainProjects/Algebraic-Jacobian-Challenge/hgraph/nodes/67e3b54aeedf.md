---
author: sync
content_type: theorem
created: '2026-07-29T01:14:28'
decl: AlgebraicGeometry.cech_flatBaseChange_oneLeaf
docstring: "**Flat base change for the Čech higher direct images — ONE OPEN LEAF LEFT**\
  \ (Stacks 02KH; run\n0068 r3, the form to consume).\n\nHypotheses and conclusion\
  \ are **exactly** those of `cech_flatBaseChange` and\n`cech_flatBaseChange_qcoh`:\
  \ no extra binder of any kind.  What changed is the proof term, and it\nchanged\
  \ twice over:\n\n* the *flat-exactness* leaf `pullback_preservesMonomorphisms` is\
  \ absent (inherited from\n  `cech_flatBaseChange_qcoh`'s route through `pullback_mapHC_homologyIso_of_isQuasicoherent`);\n\
  * the *S-level cosimplicial* leaf `cech_pushforward_baseChange_natIso` is absent\
  \ too, because the\n  tensorial half now runs through `cechComplex_baseChange_iso_flat`.\n\
  \nSo the **only** remaining reason this theorem is not axiom-clean is the naturality\
  \ square of\n`twisted_cech_nerve_iso` — the compatibility of the cover base-change\
  \ identification\n`coverInterOpen_baseChange_eq` with the index-omission maps. \
  \ Everything else in Stacks 02KG/02KH is\nproved here: the per-σ mate is `canonicalBaseChangeMap_isIso`\
  \ (see `isIso_cechOuterBC_coverInter`),\nthe per-σ X-level Beck–Chevalley is `twisted_cech_nerve_per_sigma`,\
  \ and the homology half is the\nquasi-coherent kernel route.\n\nMeasure at `scripts/axiom-frontier.lean`\
  \ §6e."
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.cech_flatBaseChange_oneLeaf
type: lean
updated: '2026-07-29T05:40:30'
---
theorem cech_flatBaseChange_oneLeaf
    (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) [Flat g] [QuasiCompact f] [IsSeparated f]
    [IsAffine S] [IsAffine S']
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀] [h𝒰 : ∀ i, IsAffine (𝒰.X i)]
    [Finite ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).I₀]
    [∀ i, IsAffine (((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso
      h.isoPullback.symm.hom).X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) :
    Nonempty ((Scheme.Modules.pullback g).obj (cechHigherDirectImage f 𝒰 F i) ≅
      cechHigherDirectImage f'
        ((Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom)
        ((Scheme.Modules.pullback g').obj F) i) :=
  ⟨(pullback_mapHC_homologyIso_of_isQuasicoherent g (CechComplex f 𝒰 F) i
      (isQuasicoherent_cechComplex_X f 𝒰 (fun σ => coverInterOpen_isAffine f 𝒰 σ) F hF i)
      (isQuasicoherent_cechComplex_X f 𝒰 (fun σ => coverInterOpen_isAffine f 𝒰 σ) F hF
        ((ComplexShape.up ℕ).next i))).symm ≪≫
    HomologicalComplex.homologyMapIso
      (cechComplex_baseChange_iso_flat f g f' g' h 𝒰 F hF) i⟩

/-! ## `TwistedPerSigmaDeltaCompat` SPLIT IN TWO — one half free, the other named (run 0068 r4)

`twisted_cech_nerve_per_sigma` is, **by `rfl`** (`tcnps_eq`), a two-layer composite:

* the Beck–Chevalley iso `bcv` for the square restricted over `U_σ`, and
* a slice transport `pushPullObjCongr _ eIso` along the `isoOfRangeEq` identification of
  `pullback.fst g' (ι U_σ)` with `ι (coverInterOpen 𝒰' σ)`.

So the per-σ compatibility splits along that seam, and the two halves are not comparable in cost.

**HALF (b) IS FREE, AND THIS RETRACTS THIS FILE'S OWN PRICING OF THE RESIDUE.**  The
`twisted_cech_nerve_iso` docstring names the residue in prose as "the `isoOfRangeEq` slice
identifications commute with the inclusions `U_τ ⊆ U_σ`".  That sentence describes half (b), and
half (b) costs nothing: both composites are morphisms of `Over X'` into an object whose structure map
is an open immersion, hence a **mono**, so they agree by `ext` + `cancel_mono` with no geometry, no
cover base change and no transport (`slice_compat`).  Anything priced against that sentence is
mispriced; the real content is half (a).

**HALF (a) IS THE CRUX, and it is naturality in the SQUARE, not in the module.**
`bc_square_naturality` states it: for affine opens `V₀ ≤ W₀` and their base changes along `g'`, the
two restricted-square Beck–Chevalley isos commute with restriction along the inclusion.  It is *not*
`openImmersion_bareBC_app_eq` (that is naturality in the module) nor `pushPullMap_comp`/`_id` (those
are functor laws in the slice variable) — nothing in the tree relates the mate across a *change of
square*.

Two facts make it actionable, both machine-checked here and neither previously recorded:

* `openImmersion_bareBC` **never uses cartesianness** — `bareBC_eq_of_w` says it is `bareBC_of_w` at
  `hsq.w`, by `rfl`.  So the mate exists for *any* commuting square, including the degenerate one
  with right edge `𝟙 X`, which is the shape `pushPullMap` has.  The `IsPullback` binder is decoration
  on this leaf; only the invertibility node consumes it.
* the two restricted squares **paste vertically**: `inclusion_square_comm` gives
  `gV ≫ homOfLE hle = w.left ≫ gW` by cancelling the mono `W₀.ι`.  So `mateEquiv_vcomp` is the
  applicable glue.

MEASURED NEGATIVE, recorded so it is not re-attempted as a triviality: "`pushPullMap F u` is the
degenerate-square mate" — the composite of `(pullbackId X).inv`, `bareBC_of_w (𝟙 X) …` and the two
telescope corrections — **typechecks but is not `rfl`**, and `simp` with `bareBC_of_w`, `pushPullMap`,
`rawPushPullMap`, `mateEquiv_apply` does not close it (`aesop_cat` times out in `whnf`).  It is a
genuine lemma, and it is the brick half (a) needs.

`TwistedPerSigmaDeltaCompat` follows from half (a) alone: `twistedPerSigmaCompat_of_bcNaturality`.
Everything else in this section is `sorry`-free. -/