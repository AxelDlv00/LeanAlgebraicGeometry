# Recommendations for iter-032 (from session_31 review)

## Closest-to-completion / highest-leverage

### 1. QUOT gap1 — attack P1 (per-element presentation transport), now UNBLOCKED
Bridge C closed this iter (`overRestrictIso` axiom-clean). The handoff route (from the prover task result,
ready to formalize):
- Take `q.presentation i : (M.over (q.X i)).Presentation`; push through `(overRestrictEquiv (q.X i)).functor`
  via `SheafOfModules.Presentation.map … (.refl _)` to get a presentation of
  `(overRestrictEquiv).functor.obj (M.over (q.X i))`.
- Then `.ofIsIso (overRestrictPullbackIso …).hom` (or `overRestrictIso`) to land a presentation of the
  geometric restriction/pullback `U.ι^* M`; restrict further along `D(r) ≅ Spec R_r`
  (`isLocalization_basicOpen`, `Scheme.Modules.pullback`); conclude with `isIso_fromTildeΓ_of_presentation`.
- **`set_option backward.isDefEq.respectTransparency false` was NOT needed for bridge C** — reassess only
  if the P1 `Presentation.map` slice synthesis times out. Frontier node: `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`.

### 2. GR — lane CLOSED; advance to `lem:gr_separated` / `lem:gr_proper`
`Grassmannian.scheme` is built and axiom-clean. These are the natural next GR frontier nodes (both in the
current `frontier` query). Note `lem:gr_separated` `effort_local≈2224` — likely an effort-breaker candidate
before a prover round.

## Promising but needs structural change first

### 3. FBC `_legs` — DO NOT re-dispatch a keyed-rewriting round; fix ordering + casts first
**Standing CHURNING tripwire (~13 iters; STRATEGY Open Q2).** Keyed `rw`/`simp`/`erw` is *conclusively*
dead against the `X.Modules` instance diamond — re-confirmed this iter on even the trivial trailing factor.
Before any further `_legs` work, the prover MUST do the two structural fixes (neither attempted yet):
- **(a) Declaration ordering / inlining.** Move the 3 eCancel atoms
  (`base_change_mate_inner_eCancel_eUnit/_pushforwardComp/_pullbackComp`) + `base_change_mate_unit_value`
  ABOVE `_legs`, OR inline their content (route b, ≤3 lines each): eUnit = `IsIso` of the
  pullbackPushforward unit via `pullback_isEquivalence_of_iso`; pullbackComp via
  `(pullbackComp _ _).hom_inv_id_app`; pushforwardComp via the pre-`_legs` `gammaMap_pushforwardComp_hom_eq_id`.
- **(b) Collapse the `Eq.mpr` casts** from the leg-`subst` (RHS codomain read is wrapped in 3 casts) via the
  concrete-legs `base_change_mate_codomain_read` before splicing.
- Then close with term-mode `congrArg`/`Functor.congr_map`/`.trans` + defeq-bridging `exact`
  (factor 3 → factor 2 → survivor). If the term-mode splice *itself* fails (vs budget), escalate the
  STRATEGY Open Q2 fork: ModuleCat-level re-encoding vs user escalation.

## Coverage debt — 9 unmatched `lean_aux` nodes (planner: add blueprint blocks)
`archon dag-query unmatched` (all proved, axiom-clean, sorry-free):

**GR (6)** — `AlgebraicJacobian/Picard/GrassmannianCells.lean`:
- `…Grassmannian.theGlueData` — the `Scheme.GlueData` bundle. Suggest `def:gr_the_glue_data` (or fold its
  `\lean{}` into `def:gr_glued_scheme`). Relies on all chart/transition/cocycle decls.
- `…Grassmannian.chartTransition'_cocycle` — scheme-level `cocycle` field
  `t'_{IJK} ≫ t'_{JKI} ≫ t'_{KIJ} = 𝟙`. Suggest `lem:gr_chartTransition'_cocycle` (sibling of
  `lem:gr_chartTransition'_fac`). Relies on `cocyclePhiId`, `Spec.map_comp`, `ofHom_comp/ofHom_id`,
  `Spec.map_id`, `Iso.inv_hom_id_assoc`, `Iso.hom_inv_id`, `reassoc_of%`.
- `…Grassmannian.awayMulCommEquiv_comp_awayInclLeft` — `swap ∘ ι^L = ι^R`. Relies on
  `awayInclLeft/Right_comp_algebraMap`, `awayMulCommEquiv_comp_algebraMap`, `IsLocalization.ringHom_ext`.
- `…Grassmannian.rotMid`, `…transitionInvImageMatrix`, `…transitionInvPair` — `private` helpers internal
  to `cocyclePhiId`. (Private; acceptable to omit a block, but listed for completeness.)

**QUOT (3)** — `AlgebraicJacobian/Picard/QuotScheme.lean` (`overRestrictIso` itself is pinned `lem:over_restrict_iso`):
- `…Scheme.Modules.overRestrictEquiv` — step-3 site equivalence. Suggest `def:overRestrictEquiv` (or fold
  into `lem:over_restrict_iso` Step 3). Relies on `overEquivalence_sheafCongr`, the two
  `overEquivalence_*_isContinuous` instances, `pushforwardPushforwardEquivalence`, `Equivalence.unitInv_app_inverse`.
- `…Scheme.Modules.overRestrictFunctorIso` — functor-level step 4. Relies on `overRestrictEquiv`,
  `pushforwardComp`, `pushforwardCongr`, `Scheme.Opens.ι_appIso`, `restrictFunctor`.
- `…Scheme.Modules.overRestrictPullbackIso` — step 4' pullback form (P1 consumes this). Relies on
  `overRestrictIso`, Mathlib `restrictFunctorIsoPullback`.

## MAJOR (from review subagents) — planner / next prover action

- **[GR, blueprint↔Lean hygiene] 9 `private` decls in `Picard_GrassmannianCells.tex` carry
  public-namespace `\lean{AlgebraicGeometry.Grassmannian.Name}` pins** (`mul_submatrix_col`,
  `map_nonsing_inv`, `isUnit_incl_transitionPreMap_cross`, `isUnit_algebraMap_away_left`,
  `isUnit_algebraMap_away_right`, `map_map_eq_of_comp`, `imageMatrix_map_eq`, `inv_mul_inv_mul_cancel`,
  `cocycle_imageMatrix_eq`). `private` decls get a mangled `_private.<hash>.Name`, so the public form does
  not resolve under `lake env lean` — this breaks `sync_leanok`'s `#print axioms` for those blocks (their
  `\leanok` is unreliable). **Pre-existing, NOT introduced this iter.** Fix is a `.lean` change (make the
  decls non-private) — a prover task, or a planner decision to drop the pins. The review agent cannot fix
  this (it is neither a rename nor a marker; the mangled-name pin form would be fragile).
- **[FBC, .lean housekeeping for next prover]** (review cannot edit `.lean`):
  - Remove the unused simp arg `Functor.map_comp` at `FlatBaseChange.lean:1452`.
  - Move the `maxHeartbeats 4000000` explanatory comments to AFTER the `set_option` line (@979, @1371) to
    silence the Mathlib style linter.
  - Add "transitively sorry-backed" disclaimers to `base_change_mate_fstar_reindex` (@1486) and
    `base_change_mate_inner_value_eq` (@1635) docstrings (consistent with the existing disclaimers on
    `base_change_mate_section_identity`/`pushforward_base_change_mate_cancelBaseChange`).
- **[GR, .lean housekeeping]** Delete the stale planner-note block at `GrassmannianCells.lean:33–44` ("The
  prover should build `affineChart` as…" — `affineChart` is already at line 56).

## Blocked / known — do NOT re-assign without a structural change
- **FBC `_legs`** — see item 3. No keyed-rewriting recipe variations; only the ordering+cast structural
  fix then term-mode splice. STRATEGY Open Q2 fork decision is due at iter-032.
- **FBC `gstar_transpose` (@1844), affine (@2025), FBC-B (@2047)** — gated on `_legs`. Do not attempt
  until `_legs` closes.
- **QUOT 4 protected stubs** (`hilbertPolynomial` @123, `QuotFunctor` @165, `Grassmannian` @198,
  `Grassmannian.representable` @225) — gated on gap1 assembly (sequenced after P1 + D). Out of scope.
- **GF-geo `genericFlatness` (@2264)** — gated on the gap1 keystone. Out of scope.

## Reusable proof patterns discovered this iter
- **Cocycle-by-telescoping** (GR `cocyclePhiId`): one application of `cocycleCondition` to a 3-fold loop
  leaves EXACTLY one inverse pair; only that residual needs the matrix engine, the rest is composition
  algebra with the `_comp_algebraMap` lemmas. Avoids a giant generator computation.
- **Step-collapses-to-`rfl`** (QUOT step 2): the geometric ring-sheaf identification dissolved
  definitionally via `toScheme_presheaf_obj/map`. When a "geometric obstacle" sits over an opens-functor
  pushforward, check `rfl` before building machinery.
- **`pushforwardComp ≪≫ pushforwardCongr (by cat_disch)`** for functor-level iso of two pushforwards along
  the same (defeq) opens functor; supply the composition-`IsContinuous` instance explicitly
  (`Functor.isContinuous_comp` — not auto-synthesised).
- **Over/opposite-category syntactic-rw failure** (QUOT): `rw [Category.id_comp]`/`rw [← op_comp]` fail by
  syntactic match even when the subterm is present; use `erw` + a separate `have` discharged by
  `(congrArg map h).trans (Functor.map_id ..)`.
- **`X.Modules` instance diamond = keyed-rewriting dead** (FBC, re-confirmed): use term-mode
  `congrArg`/`Functor.congr_map`/`.trans` + defeq-bridging `exact`. (Memories `fbc-ecancel-collapse-diamond`,
  `fbc-legs-termmode-splice-works`.)
