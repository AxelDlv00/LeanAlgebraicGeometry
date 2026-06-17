# Iter 044 — Objectives detail

## Lane 1 — QUOT `Picard/QuotScheme.lean` [mathlib-build] (gate CLEAR)
Close gap2. Build the route-1 Piece A chain (effort-breaker `piece-a` decomposition), then the 1-line close.
- Build order (bottom-up): L1 `overRestrictUnitIsoInv` (gateway; friction: `Functor.IsContinuous` non-synth
  via `haveI` + `↥V`/`↥↑V` coercion → state `R`/`K` via `V.toScheme.ringCatSheaf`'s actual space) → L2
  `overRestrictPresentationInv` ; L3 `presentationPullbackιPreimage` (via `pullbackComp`) ; L4
  `isQuasicoherent_over_preimage` (L2,L3) ; L5 `coversTop_preimage` ; L6
  `isQuasicoherent_pullback_of_isOpenImmersion` (L4,L5) → target `isQuasicoherent_pullback_fromSpec`.
- gap2 `isLocalizedModule_basicOpen` = `isLocalizedModule_basicOpen_of_hP1 M hU
  (isIso_fromTildeΓ_of_isQuasicoherent _) f` (Piece B iter-043 + gap1 + target).
- WATCH: L1 resists past pinned friction → flag precise sub-step.

## Lane 2 — FBC `Cohomology/FlatBaseChange.lean` [mathlib-build] (gate content ✓✓)
Close keystone `base_change_mate_fstar_reindex_legs_conj` @1848 via the factored route
(`analogies/fbc-composite-mate-recognition.md`).
- Build `adjL`/`adjR` as nested `Adjunction.comp` (mirror conj-2d:1667-1670, 2 layers deeper).
- Split LHS via `conjugateEquiv_symm_comp` + `Adjunction.comp_unit_app`; `(Spec φ)_*` layer via
  `conjugateEquiv_whiskerLeft/Right`; reassoc via `conjugateEquiv_associator_hom`. Then
  `apply (conjugateEquiv adjL adjR).injective` + the conjugate simp set + the 3 legs (conj-2b/2c/2d).
  Lock-prone factors as metavars (`surjective … rfl`). First edit :1815+. NOT a monolithic β.
- Resists at `adjL`/`adjR` → partial handoff (named compiling sub-lemmas), no sorry pins.

## Blueprint actions taken this iter
- Coverage-debt block `lem:isLocalizedModule_basicOpen_of_hP1` (planner-written, Piece B).
- effort-breaker: Piece A chain L1–L6 + 2 Mathlib anchors; gap2 \uses repointed.
- Wired isolated nodes: `gr_det_one_updateCol` (→ statement \uses of `gr_free_entry_eq_signed_minor`).
- blueprint-clean on the 9 new QuotScheme blocks; full blueprint-reviewer cleared the gates.
- STRATEGY: FBC route (factored keystone), QUOT gap2 (Piece A only), SNAP re-scope, Q4 RelativeSpec, de-drift.
