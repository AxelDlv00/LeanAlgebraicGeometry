# Lean Audit Report

## Slug
iter002

## Iteration
002

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Two-line root module; just re-exports the two chapter files. Clean.

---

### AlgebraicJacobian/Cohomology/HigherDirectImage.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (blanket `import Mathlib`)
- **excuse-comments**: none
- **notes**:
  - Single declaration `higherDirectImage` (line 47–49) is a clean, correct application of
    `(pushforward f).rightDerived i`. Signature, body, and docstring are consistent.
  - `import Mathlib` (line 6): blanket import; minor performance issue during development,
    not wrong. Should eventually be narrowed.

---

### AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
- **outdated comments**: 5 clusters flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 4 flagged (blanket import; three large `maxHeartbeats` overrides)
- **excuse-comments**: none
- **notes**:

  **Stale comment — section intro paragraph (lines 84–88)**
  Inside the `/-! ## Project-local Mathlib supplement …-/` header:
  > "The push-pull functor is the remaining gap: its `map_comp` requires … so `CechNerve`
  > itself is left as the single genuine hole."

  Both clauses are now false. `pushPullFunctor` is fully assembled (lines 640–644) with
  both functor laws proven. `CechNerve` is constructed axiom-clean (lines 698–701). A
  future reader of this section intro will believe neither ingredient exists.

  Side note: the same paragraph references `Picard/TensorObjSubstrate.lean` (line 87), a
  file that does not exist in this project (it was part of the parent
  Algebraic-Jacobian-Challenge repo). The cross-reference is dangling.

  **Stale comment — functor-law status block (lines 161–183)**
  The block comment listing the two functor-law obligations marks `pushPullMap_comp` as
  `-- remaining` (line 166) and ends "left for a focused follow-up pass". This law is now
  proven at line 627–630 (`exact rawPushPullMap_comp …`). The inline `-- remaining`
  annotation is directly attached to the statement in code-block form, creating a
  contradiction: a reader sees "remaining" where the proof already exists.

  **Stale comment — "not yet closed" pentagon analysis, first instance (lines 245–293)**
  The comment block placed between `pushPull_unit_comp` and `pushforwardComp_hom_app_id`
  is titled "Composition law `pushPullMap_comp` — reduced to an explicit clean pentagon,
  **not yet closed**." Lines 258–259 say it is "left for a focused follow-up pass".
  Lines 279–292 give detailed "remaining work" and dead-end inventory. All of this was
  accurate during development but is now stale: `pushPullMap_comp` IS proven.

  **Stale comment — "not yet closed" pentagon analysis, second instance (lines 410–449)**
  A second, overlapping comment block placed before `rawPushPullMap_self` repeats the
  title "not yet closed" (line 411) and contains a "Why it is not yet closed (next-prover
  dead-ends, all hit this iter):" section (lines 437–448). Same situation: the composition
  law is proven. Two copies of the same stale analysis in the file doubles the confusion.

  **Stale inline comment in `CechComplex` body (lines 739–745)**
  The inline comment inside the definition of `CechComplex` closes with:
  > "The only remaining hole is `CechNerve` itself."

  `CechNerve` is now axiom-clean (no `sorry`). A prover agent reading this definition
  will incorrectly believe `CechNerve` still has an open gap and may attempt to (re-)prove
  it or skip proofs that now depend on it cleanly.

  **Known documented `sorry`s (per directive: report, no escalation)**
  - Line 774: `CechAcyclic.affine` — intentional sorry. Blockers are genuine and
    documented (missing module-level localisation + homotopy infra in Mathlib for
    `Scheme.Modules`). Not an excuse-comment.
  - Line 811: `cech_computes_higherDirectImage` — intentional sorry. Protected signature.
    Blockers are genuine (two spectral sequences not in Mathlib for `Scheme.Modules`).

  **Module-level docstring count mismatch (line 35)**
  "The six main declarations are:" introduces a list of only four items. Post-iteration
  additions (`pushPullFunctor`, `coverCechNerveOver`, `coverCechNerveOverAug`,
  `cechNerveCosimplicial`, `relativeCechComplexOfNerve`) are absent from the module
  overview. Stale count; low severity.

  **`import Mathlib` (line 6)**: blanket import — same as HigherDirectImage.lean.

  **`set_option maxHeartbeats` overrides (lines 404, 467, 533)**: values 1 000 000,
  4 000 000, and 1 600 000 respectively. Large but not unusual for sheaf-of-modules
  coherence proofs. Flags potential proof-performance targets for a future `/golf` pass.

---

## Must-fix-this-iter

*(none)*

---

## Major

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:84–88` — Section intro says
  "The push-pull functor is the remaining gap" and "`CechNerve` itself is left as the
  single genuine hole." Both are now false: `pushPullFunctor` is assembled at line 640
  and `CechNerve` is constructed at line 698. Any agent reading this paragraph will
  receive incorrect information about the project's proof state.

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:161–183` — Comment block
  annotates `pushPullMap_comp` as `-- remaining` (line 166) and describes it as "left
  for a focused follow-up pass". The lemma is closed at lines 627–630.

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:245–293` — Comment block
  titled "not yet closed" for `pushPullMap_comp`, with a detailed dead-end inventory and
  "remaining work" section. Stale: the composition law is proven.

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:410–449` — Second copy of
  the "not yet closed" analysis for `pushPullMap_comp`, including "Why it is not yet
  closed (next-prover dead-ends, all hit this iter):" — stale and duplicative.

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:739–745` — Inline comment in
  `CechComplex` body ends "The only remaining hole is `CechNerve` itself." `CechNerve` is
  now axiom-clean.

---

## Minor

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:87` — Dangling cross-reference
  to `Picard/TensorObjSubstrate.lean`; that file is not present in this project.

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:35` — Module header says
  "six main declarations" but lists only four; post-iteration additions not reflected.

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:404,467,533` — Three
  `set_option maxHeartbeats` overrides (1 000 000 / 4 000 000 / 1 600 000). Not wrong;
  performance-audit candidates.

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:774` — `CechAcyclic.affine`
  sorry (known, per directive; genuine Mathlib blocker).

- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:811` — `cech_computes_higherDirectImage`
  sorry (known, protected, per directive; genuine Mathlib blocker).

- `AlgebraicJacobian.lean:1`, `AlgebraicJacobian/Cohomology/HigherDirectImage.lean:6`,
  `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean:6` — `import Mathlib` blanket
  imports; slow to elaborate; should be narrowed before the project matures.

---

## Excuse-comments (always called out separately)

*(none — the two documented `sorry`s are honestly blocked and do not contain excuse-phrasing)*

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 5 — five clusters of stale development-progress comments that now describe a
  false proof state (functor law "remaining", `CechNerve` "a single genuine hole"). These
  should be pruned or rewritten to reflect the current completed state before the next
  prover agent runs to avoid misdirection.
- **minor**: 8 (dangling file reference, stale module header count, three large
  `maxHeartbeats` overrides, two documented in-scope sorries, blanket Mathlib imports)
- **excuse-comments**: 0

**Overall verdict:** The codebase is mathematically sound — definitions are correct, all
non-sorry proofs are axiom-clean, and the two remaining `sorry`s are genuinely blocked with
honest documentation. The only actionable cleanup is removal of five stale comment clusters
that describe `pushPullMap_comp` and `CechNerve` as unproven when they are now complete.
