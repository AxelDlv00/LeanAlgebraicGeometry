# Refactor Report

## Slug

lane-e-iotagm-packaging

## Status

COMPLETE

The iter-189 mathlib-analogist verdict-A structural refactor of
`iotaGm_onePt_chart1_factor` is landed: the existential `∃ r_1, ...`
packaging is replaced by a named `noncomputable def iotaGm_r_1` plus
paired lemmas `iotaGm_r_1_range_subset` and `iotaGm_r_1_fac`. The
backward-compat wrapper is REMOVED (single call site migrated cleanly,
per directive guidance). The file compiles end-to-end (only the new
range-subset `sorry` and the two pre-existing `sorry`s remain).

## Directive (Problem and Changes recap)

**Problem.** Iter-189 `mathlib-analogist lane-e-projappiso` (verdict A,
PROCEED-with-refactor) flagged that the `∃`-packaging of `r_1` in
`iotaGm_onePt_chart1_factor` forces the downstream consumer
`iotaGm_chart1_composition_isOpenImmersion` to re-derive the
range-containment witness via `cancel_mono` to recover the
`IsOpenImmersion.lift` identity needed by `IsOpenImmersion.lift_app`.
Refactoring to a named `noncomputable def` exposes `r_1` directly and
collapses the re-derivation step.

**Changes requested.** In
`AlgebraicJacobian/AbelianVarietyRigidity.lean` (current L106-L163 of
the pre-refactor file), split `iotaGm_onePt_chart1_factor` into:
- `iotaGm_r_1_range_subset` — extracted range-containment witness
- `iotaGm_r_1` — `noncomputable def` via `IsOpenImmersion.lift`
- `iotaGm_r_1_fac` — `iotaGm_r_1 ≫ awayι = onePt.left` via
  `IsOpenImmersion.lift_fac`

Keep the wrapper for backward compat UNLESS every call site migrates
cleanly. Do NOT modify the downstream consumer's proof body.

## Changes Made

### File: `AlgebraicJacobian/AbelianVarietyRigidity.lean`

- **What:** Replaced the existential lemma `iotaGm_onePt_chart1_factor`
  (pre-refactor L106-L163) with three new private declarations:
  - `iotaGm_r_1_range_subset` (decl L104, doc L79-L103, body L110-L160)
    — the range-containment
    `Set.range ⇑onePt.left ⊆ Set.range ⇑(Proj.awayι ...)`, the third
    argument of `IsOpenImmersion.lift`. **Proof body sorried** — see
    "New Sorries Introduced" below.
  - `iotaGm_r_1` (decl L163, doc L152-L162, body L168-L176) — the
    `noncomputable def`: `IsOpenImmersion.lift (Proj.awayι ...)
    onePt.left (iotaGm_r_1_range_subset kbar)`.
  - `iotaGm_r_1_fac` (decl L181, body L188) — the factorisation
    `iotaGm_r_1 kbar ≫ Proj.awayι ... = onePt.left`, closed by
    `IsOpenImmersion.lift_fac _ _ _`.
- **Why:** Iter-189 verdict-A says `IsOpenImmersion.lift_app` is the
  Mathlib idiom for evaluating `r_1.app` at the downstream consumer,
  but it needs `r_1` exposed as a `def` (not packed in `∃`).
- **Cascading:** Single call site migrated in `iotaGm_isOpenImmersion`
  (decl L492; migrated `have`/`hfact` block at L502-L529):
  - Replaced `obtain ⟨r_1, h_r_1⟩ := iotaGm_onePt_chart1_factor kbar`
    with `have h_r_1 := iotaGm_r_1_fac kbar`.
  - Updated the two `iotaGm_chart1_section kbar r_1 h_r_1` and
    `iotaGm_chart1_composition_isOpenImmersion r_1 h_r_1` to use
    `iotaGm_r_1 kbar` directly in place of the destructured `r_1`.
- **Wrapper removal:** The directive permitted removing the
  `iotaGm_onePt_chart1_factor` backward-compat wrapper if every call
  site migrates cleanly. The single call site (in
  `iotaGm_isOpenImmersion`) migrated cleanly, so the wrapper is gone.
- **Consumer (`iotaGm_chart1_composition_isOpenImmersion`):** NOT
  modified. Its signature still takes `r_1` and `h_r_1` as parameters;
  callers now pass `iotaGm_r_1 kbar` and `iotaGm_r_1_fac kbar`. Its
  iter-188 body sorry (now at L464) is preserved verbatim. The
  iter-190 prover phase will land the `r_1_appTop_isLocElem_eq_one`
  helper that consumes the new packaging.

## New Sorries Introduced

- `AlgebraicJacobian/AbelianVarietyRigidity.lean:150` (in
  `iotaGm_r_1_range_subset`) — the range-containment proof body. The
  original iter-184 closed proof body from `iotaGm_onePt_chart1_factor`
  does **not transplant** to the standalone signature: the iter-184
  body executed inside `refine ⟨IsOpenImmersion.lift _ _ ?_, ?_⟩` and
  relied on `lift`'s elaboration to pin the common codomain `Z` to
  `Proj 𝒜` (its `f := Proj.awayι ...` arg is processed before
  `g := onePt.left`, fixing `Z` from `f`). In the standalone signature,
  the LHS-first elaboration defaults to
  `Z = (ProjectiveLineBar kbar).left` (codomain of `onePt.left`), and:
  1. `rw [← Scheme.Hom.coe_opensRange (Proj.awayι _ _ _ _)]` fails to
     unify the `Set.range ⇑(Proj.awayι ...)` pattern (typed at
     `Set ↥(Proj 𝒜)`) against the goal subterm (typed at
     `Set ↥(ProjectiveLineBar kbar).left`) — `rw` does not unfold the
     `.left` projection on `ProjectiveLineBar`.
  2. A `: Set ↥(Proj (projectiveLineBarGrading kbar))` ascription on
     the RHS of the signature gets past (1) but moves the problem to
     the subsequent `rw [SetLike.mem_coe, ← Scheme.Hom.mem_preimage]`
     step — the element `(onePt.left) x` retains type
     `↥(ProjectiveLineBar kbar).left`, and `Membership.mem`'s carrier
     type doesn't bridge `↥(ProjectiveLineBar kbar).left ≡ ↥(Proj 𝒜)`.

  The full pre-refactor closed proof body is preserved inline as a
  block comment for the prover phase to adapt. Closure likely requires
  either (a) marking `ProjectiveLineBarScheme`/`ProjectiveLineBar` as
  `@[reducible]` upstream, (b) a point-witness construction that
  builds the `awayι`-preimage directly, or (c) using
  `Proj.fromOfGlobalSections_morphismRestrict` (per iter-189
  analogist Decision 3 — `morphismRestrict` alternative path).

## Compilation Status

- `AlgebraicJacobian/AbelianVarietyRigidity.lean`: **compiles cleanly**
  (3 `sorry` warnings, all expected: see below).
- `AlgebraicJacobian.lean` (the only Lean importer): compiles cleanly.

Sorries (`lean_diagnostic_messages` reports):
- L104 (decl line) / L150 (sorry line): `iotaGm_r_1_range_subset` —
  **NEW iter-190 sorry from this refactor** (see above).
- L277 (decl line) / L464 (sorry line): `iotaGm_chart1_composition_isOpenImmersion`
  — pre-existing iter-188 sorry (the `r_1_appTop_isLocElem_eq_one`
  residual). Preserved verbatim per directive.
- L782 (decl line) / L788 (sorry line): `genusZero_curve_iso_P1` —
  pre-existing Riemann-Roch bridge sorry. Untouched.

## Notes for Plan Agent

- **The refactor structurally succeeded** — the iter-190 prover can now
  invoke `IsOpenImmersion.lift_app` directly on `iotaGm_r_1` (a named
  `noncomputable def`) instead of re-deriving the lift identity through
  `cancel_mono`. The 6-step recipe documented in the
  `iotaGm_chart1_composition_isOpenImmersion` body comments (currently
  L302-L450) telescopes to evaluating `iotaGm_r_1.appTop isLocElem = 1`
  via `IsOpenImmersion.lift_app` applied to `iotaGm_r_1`.

- **New sorry caveat.** The range_subset proof body did not transplant
  cleanly because of a `rw`/`change` defeq gap between
  `↥(ProjectiveLineBar kbar).left` and `↥(Proj 𝒜)`. The original proof
  body relied on the `refine ⟨lift _ _ ?_, ?_⟩` elaboration context
  for codomain pinning. Three remediation paths are listed inline in
  the lemma body; the simplest (a) is to mark `ProjectiveLineBar` /
  `ProjectiveLineBarScheme` `@[reducible]` upstream — but that's a
  Lane-A change and out of scope for this refactor.

- **Recommended iter-190 prover dispatch:** an `iotaGm_r_1_range_subset`
  prover task with the existing pre-refactor closed proof body in the
  inline comment as the starting recipe. Suggest the prover try (b) —
  the point-witness construction — first: build a witness
  `y : Spec (Away 𝒜 (X 1))` such that `awayι y = onePt.left x` by
  composing `Spec.map (homogeneousLocalizationAwayIso kbar 1).symm`
  with the chart-1 evaluation map; the `Proj.basicOpen` membership is
  then a one-shot calc.

- **No suggested follow-up refactors** — the structural change is
  self-contained.

## Developer Feedback

Skipped — nothing concrete to flag this iteration beyond the inline
remediation paths.
