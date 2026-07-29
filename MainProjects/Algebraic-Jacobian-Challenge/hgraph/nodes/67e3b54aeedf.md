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
updated: '2026-07-29T11:05:39'
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
half (b) costs nothing: both composites are morphisms of `Over X'` into an object whose
structure map is an open immersion, hence a **mono**, so they agree by `ext` + `cancel_mono`
with no geometry, no cover base change and no transport (`slice_compat`).  Anything priced
against that sentence is mispriced; the real content is half (a).

**HALF (a) IS THE CRUX, and it is naturality in the SQUARE, not in the module.**
`bc_square_naturality` states it: for affine opens `V₀ ≤ W₀` and their base changes along `g'`, the
two restricted-square Beck–Chevalley isos commute with restriction along the inclusion.  It is *not*
`openImmersion_bareBC_app_eq` (that is naturality in the module) nor `pushPullMap_comp`/`_id` (those
are functor laws in the slice variable) — nothing in the tree relates the mate across a *change of
square*.

Two facts make it actionable, both machine-checked here and neither previously recorded:

* `openImmersion_bareBC` **never uses cartesianness** — `bareBC_eq_of_w` says it is `bareBC_of_w` at
  `hsq.w`, by `rfl`.  So the mate exists for *any* commuting square, including the degenerate one
  with right edge `𝟙 X`, which is the shape `pushPullMap` has.  The `IsPullback` binder is
  decoration on this leaf; only the invertibility node consumes it.
* the two restricted squares **paste vertically**: `inclusion_square_comm` gives
  `gV ≫ homOfLE hle = w.left ≫ gW` by cancelling the mono `W₀.ι`.  So `mateEquiv_vcomp` is the
  applicable glue.

MEASURED NEGATIVE, recorded so it is not re-attempted as a triviality: "`pushPullMap F u` is the
degenerate-square mate" — the composite of `(pullbackId X).inv`, `bareBC_of_w (𝟙 X) …` and the two
telescope corrections — **typechecks but is not `rfl`**, and `simp` with `bareBC_of_w`,
`pushPullMap`, `rawPushPullMap`, `mateEquiv_apply` does not close it (`aesop_cat` times out in
`whnf`).  It is a genuine lemma, and it is the brick half (a) needs.

`TwistedPerSigmaDeltaCompat` follows from half (a) alone: `twistedPerSigmaCompat_of_bcNaturality`.
Everything else in this section is `sorry`-free.

**ITEM (i), THE WIRING, IS NOW WRITTEN (run 0068 r5) — ONE ITEM REMAINS, NOT TWO.**
`sigmaAssembled_δ_square` and `twistedNerve_δ_square_concrete` prove the coface square in the
**σ-decomposed** form: their target is a `Pi` product, and the target-side coface appears as a
`Pi.lift`.  Feeding that to `alternatingCofaceComplexIsoOfDelta` at `twisted_cech_nerve_iso`'s *own*
spelling — where the target is the base-changed nerve's degree object — was named here as unwritten
bookkeeping.  It is `twistedComponent_δ_square` below, and the bridge is that the **same**
σ-coordinate coface formula applies to the base-changed cover: `cechNerve_backbone_δ_sigma` at `𝒰'`
says its nerve's coface, read through `pushPull_sigma_iso 𝒰'`, is reindex-then-restrict — exactly
the `Pi.lift` shape.  No transport: the index types agree on the nose (`baseChangedCover_I₀`).

So the honest state is one item:

  (ii) half (a) — mate-naturality in the SQUARE, now named `BcSquareNaturality` and shown
       equivalent to a pushforward-free form `BcSquarePullbackSide`.

Neither is a `sorry` in this file; `twisted_cech_nerve_iso`'s own square is still the only one. -/

/-! ### (i) THE WIRING — the σ-decomposed square, at `twisted_cech_nerve_iso`'s own spelling

`sigmaAssembled_δ_square` proves the coface square with the *target* a `Pi` product and the
target-side coface a `Pi.lift`.  `alternatingCofaceComplexIsoOfDelta` wants it at the spelling
`twisted_cech_nerve_iso` uses: source `(g'^* ∘ drop(nerve 𝒰 F))`, target `drop(nerve 𝒰' (g'^*F))`,
whose degree object is `pushPullObj (g'^*F) ((coverCechNerveOver 𝒰').obj (op ⦋n⦌))`.

The bridge is `cechNerve_drop_δ_sigma` **for the base-changed cover** — the same lemma, instantiated
at `𝒰'` instead of `𝒰`.  It says the target nerve's coface, read through `pushPull_sigma_iso 𝒰'`,
is reindex-then-restrict, which is exactly the `Pi.lift` shape.  Nothing new is needed: the index
type of `𝒰'` is `𝒰.I₀` on the nose (`baseChangedCover_I₀`), so the two σ-families are the same
family and no transport appears.  This is what r4 left unwritten. -/