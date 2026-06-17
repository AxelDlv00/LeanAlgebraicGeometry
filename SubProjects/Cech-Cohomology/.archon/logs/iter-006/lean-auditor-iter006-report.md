# Lean Audit Report

## Slug
iter006

## Iteration
006

## Scope
- files audited: 3 (all project source `.lean` files under `AlgebraicJacobian/`)
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

- **outdated comments**: 1 flagged (minor)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 7 flagged (all minor — unused section vars + one `show` vs `change`)
- **excuse-comments**: none
- **notes**:
  - All four focus-area declarations (`quasiIso_τ₂`, `ofShortExact`, `ofShortExact_resolvesMiddle`,
    `rightDerivedShiftIsoOfAcyclic`) verified by `lean_verify`: axioms = `{propext, Classical.choice,
    Quot.sound}`, zero warnings. Fully axiom-clean and sorry-free.
  - **`quasiIso_τ₂` (lines 89–131)** — passes all focus checks:
    - Does NOT assume the conclusion: `QuasiIso φ.τ₂` appears nowhere in the hypotheses.
    - Boundary hypotheses `hbMono`/`hbEpi` are universally quantified over ALL boundary degrees
      of the complex shape, not degree-0-only. For `ComplexShape.up ℕ` only `hbMono` fires
      (at `i = 0`, which has no predecessor); `hbEpi` is vacuous for `ℕ` (every degree has a
      successor) and is correctly discharged by `absurd rfl (hi (i+1))` in the horseshoe
      application.
    - Four-lemma structure correct: builds epi + mono for each homologyMap via
      `composableArrows₅_exact` + `epi/mono_of_*` and combines with `isIso_of_mono_of_epi`.
    - No circularity.
  - **`ofShortExact_resolvesMiddle` (lines 629–636)** — correct `InjectiveResolution` packaging:
    injectivity from biproduct of injectives (standard), quasi-iso from `quasiIso_horseshoeι`.
  - **`rightDerivedShiftIsoOfAcyclic` (lines 661–672)** — correctly routes through
    `rightDerivedShiftIsoOfSplitResolutionSES` feeding the horseshoe middle resolution and SES
    data; return type matches `R^{k+1}G(ses.X₃) ≅ R^{k+2}G(ses.X₁)`.
  - **Code-fence false-positive check (iter-004 trap)**: CLEAN. All `/-! -/` blocks contain
    only prose; no backtick-fenced code blocks enclosing `def` or other declarations.
  - Line 537: `show` tactic changes the goal (linter warns; `change` is more accurate). Minor.
  - Lines 674–713: Large status/roadmap block embedded in source. Accurate and not misleading
    (correctly states what is complete and what remains for TARGET 3). Minor practice issue —
    forward-looking planning notes belong in `.archon/` state files, not source.
  - Lines 390, 489, 500, 504, 525, 548: Six `linter.unusedSectionVars` warnings — these
    declarations auto-include `[HasInjectiveResolutions 𝒜]` from the ambient `variable`
    declaration but do not use it; the `omit` pattern already applied to several neighbouring
    declarations (e.g. lines 187, 198, 243, 286) should be extended to cover these six.

---

### `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`

- **outdated comments**: 2 flagged (major) — stale blocks claiming `pushPullMap_comp` is unimplemented
- **suspect definitions**: none (all definitions are well-formed)
- **dead-end proofs**: none
- **bad practices**: 7 flagged (minor — line-length, maxHeartbeats without explanations, historical iter label)
- **excuse-comments**: none (the two sorry bodies have proper docstring explanations, not inline excuses)
- **sorry count**: 2 (lines 774, 811) — must-fix (see below)
- **notes**:
  - **`CechAcyclic.affine` (line 774)**: body is `sorry`. Docstring correctly explains the gap
    (prime-local contracting homotopy requires an explicit localisation description of
    `CechComplex` on affines and module-level homotopy infrastructure, currently absent from
    Mathlib for `Scheme.Modules`). Pre-existing gap, not new this iter. Load-bearing: used in
    the planned proof of `cech_computes_higherDirectImage`.
  - **`cech_computes_higherDirectImage` (line 801)**: body is `sorry`. The frozen protected
    signature theorem. Docstring explains the gap (two spectral sequences for `Scheme.Modules`
    not yet in Mathlib). Pre-existing. The top-level project goal.
  - **Stale comment block (lines 161–184)**: says "`pushPullMap_comp`'s statement is 'currently
    unfilled'". `pushPullMap_comp` is in fact fully proved at line 627 with no sorry, so this
    phrase is actively misleading. The comment was not updated after the proof was completed.
  - **Stale comment block (lines 246–449)**: a long `/-` block titled "Composition law ... —
    remaining" and containing "not yet closed (next-prover dead-ends, all hit this iter)". Both
    claims are false: `rawPushPullMap_comp` (lines 536–620) closes the proof, and
    `pushPullMap_comp` (lines 627–630) calls it. The comment appears to have been written during
    a prior proof-search session and was not removed or updated once the proof landed. This
    actively tells readers that an open problem exists when the problem is solved.
  - `maxHeartbeats` set to 1 000 000 (line 404), 4 000 000 (line 467), 1 600 000 (line 533)
    without accompanying explanatory comments — the Mathlib style linter warns on each. The
    high limits are a symptom of the `SheafOfModules` defeq-not-syntactic performance issue
    documented in the long comment block; they are not wrong, but they should carry a one-line
    comment per the style requirement.
  - Line 265: "iter-271 breakthrough" label — refers to a prior project's iteration counter
    (the file was extracted from Algebraic-Jacobian-Challenge, which had more iterations).
    Confusing in the current project at iter-006. Minor historical artefact.
  - Lines 257–259, 426, 505, 555: line-length lint warnings in block comments. Minor.
  - **Code-fence false-positive check**: CLEAN. No triple-backtick blocks with `def` inside
    `/-! -/` doc-comment blocks.

---

### `AlgebraicJacobian/Cohomology/HigherDirectImage.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Single declaration `higherDirectImage` — clean, no warnings, no sorry.

---

## Must-fix-this-iter

- `CechHigherDirectImage.lean:774` — `CechAcyclic.affine` body is `:= sorry`. Why must-fix:
  load-bearing (feeds `cech_computes_higherDirectImage`); a substantive theorem on a load-bearing
  claim qualifies even when the gap is documented. Pre-existing gap, not a regression from
  iter-006.
- `CechHigherDirectImage.lean:801` — `cech_computes_higherDirectImage` body is `:= sorry`. Why
  must-fix: the top-level project theorem (frozen protected signature); sorry on the main goal is
  the most load-bearing possible. Pre-existing gap.

> **Note on pre-existing classification**: both sorry bodies appear to have been present before
> iter-006 work (the iter-006 prover activity was confined to `AcyclicResolution.lean`). They are
> reported here because the audit rules have no grandfathering exception, not because they are
> regressions. The plan agent may wish to treat them as "tracked known gap, not blocking iter-007
> work in `AcyclicResolution.lean`" provided the project strategy explicitly names them as
> outstanding objectives.

---

## Major

- `CechHigherDirectImage.lean:184` — comment says `pushPullMap_comp`'s statement is "currently
  unfilled"; the proof is complete at line 627. Stale wording actively misleads readers about
  proof status.
- `CechHigherDirectImage.lean:246–449` — large `/-` block titled "Composition law ... —
  remaining" contains "not yet closed (next-prover dead-ends, all hit this iter)". False: the
  proof is closed in the same file. Should be removed or replaced with a completion note.

---

## Minor

- `AcyclicResolution.lean:390,489,500,504,525,548` — six `linter.unusedSectionVars` warnings:
  `f_comp_horseshoeβ₁`, `ιC0_comp_d`, `horseshoeβ_fst`, `horseshoeβ_snd`, `single₀_hom_ext`,
  `mono_horseshoeβ` auto-include `[HasInjectiveResolutions 𝒜]` without using it; add `omit`
  annotations matching the pattern already used for neighbouring declarations.
- `AcyclicResolution.lean:537` — `show` tactic changes the goal; style linter asks for `change`.
- `AcyclicResolution.lean:674–713` — planning/roadmap text (TARGET 3 description, input-type
  suggestions) embedded in `.lean` source; belongs in `.archon/` state files, not in the source
  module.
- `CechHigherDirectImage.lean:257–259,426,505,555` — line-length lint warnings (all in block
  comments, not code).
- `CechHigherDirectImage.lean:404,467,533` — three `set_option maxHeartbeats` without
  explanatory comments; Mathlib style linter warns on each.
- `CechHigherDirectImage.lean:265` — "iter-271 breakthrough" label is a historical iteration
  counter from the parent project; confusing at iter-006.

---

## Excuse-comments (always called out separately)

None found. The two `sorry` bodies in `CechHigherDirectImage.lean` are accompanied by proper
docstring explanations identifying the missing Mathlib infrastructure; they do not contain inline
`-- temporary` / `-- placeholder` / `-- will fix later` admissions. The stale comments about
`pushPullMap_comp` are inaccurate-but-stale progress notes, not admissions that the existing code
is wrong.

---

## Severity summary

- **must-fix-this-iter**: 2 — both `sorry`-body theorems in `CechHigherDirectImage.lean`;
  pre-existing gaps, not iter-006 regressions.
- **major**: 2 — stale comment blocks in `CechHigherDirectImage.lean` incorrectly claiming
  `pushPullMap_comp` is unimplemented.
- **minor**: 9 — unused section vars (6), show/change lint (1), embedded roadmap in source (1),
  line-length + maxHeartbeats lint in CechHigherDirectImage (3 grouped), historical iter label (1).
- **excuse-comments**: 0.

**Overall verdict**: `AcyclicResolution.lean` is axiom-clean and sorry-free with all 14 iter-006
declarations verified; the must-fix items are pre-existing sorry-bodies in `CechHigherDirectImage.lean`
(unrelated to this iter's prover work), and the major items are stale comment blocks in the same
file claiming `pushPullMap_comp` is unimplemented when it is fully proved.
