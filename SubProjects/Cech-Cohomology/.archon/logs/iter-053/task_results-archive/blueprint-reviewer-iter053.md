# Blueprint Review Report

## Slug
iter053

## Iteration
053

## Top-level summaries

### Lean target quality

- `Cohomology_CechHigherDirectImage.tex` / `lem:open_immersion_pushforward_comp`:
  `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` names only ONE of the two prover
  targets for `OpenImmersionPushforward.lean`. The declaration
  `AlgebraicGeometry.higherDirectImage_openImmersion_acyclic` (part 1 of the lemma, in
  `OpenImmersionPushforward.lean`) appears as an isolated `lean_aux` node in the DAG — it is an
  active sorry with no blueprint coverage. A prover dispatched on that file has no `\lean{}`
  pointer to its part-1 target. **Must add** `AlgebraicGeometry.higherDirectImage_openImmersion_acyclic`
  to the `\lean{}` hint of `lem:open_immersion_pushforward_comp`.

### Dependency & isolation findings

*leandag build — no `unknown_uses` (broken `\uses{}`). Blueprint-doctor — no `broken_refs`,
`malformed_refs`, `axiom_decls`, or `covers_problems`. Isolated nodes: 2, both `lean_aux`.*

- `Cohomology_CechHigherDirectImage.tex` / `lean:AlgebraicGeometry.higherDirectImage_openImmersion_acyclic`:
  isolated `lean_aux` in `OpenImmersionPushforward.lean`, no `\lean{}` in any blueprint block.
  Corresponds to part (1) of `lem:open_immersion_pushforward_comp`. **wire-up** — add
  `AlgebraicGeometry.higherDirectImage_openImmersion_acyclic` to the `\lean{}` of
  `lem:open_immersion_pushforward_comp` (active dispatch target this iter, so **must-fix-this-iter**).

- `Cohomology_CechHigherDirectImage.tex` / `lean:AlgebraicGeometry.CechAcyclic.affine`:
  isolated `lean_aux` in `CechAcyclic.lean`. Signature is the relative affine Čech vanishing
  (`IsZero (CechComplex f cover F).homology p` for affine f, spanning s, qcoh F, p≥1). This is
  likely a companion helper to `lem:cech_acyclic_affine` or `lem:affine_cech_vanishing_qcoh`.
  **wire-up** — add `AlgebraicGeometry.CechAcyclic.affine` to the `\lean{}` of whichever
  blueprint block (most plausibly `lem:affine_cech_vanishing_qcoh`) covers it. CechAcyclic.lean
  is not dispatched this iter → **soon**.

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **MUST-FIX (Lean target quality / gate-fail for `OpenImmersionPushforward.lean`)** —
    `lem:open_immersion_pushforward_comp` declares
    `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` but the companion declaration
    `AlgebraicGeometry.higherDirectImage_openImmersion_acyclic` (part 1: `R^q j_*H = 0` for q≥1)
    is in `OpenImmersionPushforward.lean` with a sorry, confirmed isolated in the DAG, and has no
    blueprint coverage. The prover dispatched on that file this iter has no `\lean{}` hook to
    part-1. Fix: add `AlgebraicGeometry.higherDirectImage_openImmersion_acyclic` as a second name
    in the `\lean{}` field of `lem:open_immersion_pushforward_comp`.
  - **SOON (isolated lean_aux wire-up)** — `AlgebraicGeometry.CechAcyclic.affine` needs its
    `\lean{}` wire-up (see Dependency & isolation findings above).
  - **Informational** — `lem:open_immersion_pushforward_comp` proof (part 2): the step
    "`j_*I• is a resolution of j_*H`" implicitly uses that `j_*` is exact when `j` is affine
    (which follows from `R^q j_* = 0` for q≥1 and the acyclic-resolution theorem for `j_*`).
    A single sentence spelling this out would help a prover, but the surrounding arguments are
    clear enough that this should not block formalization.
  - **Confirmation (directive items)** — all three directive checks pass:
    1. `lem:sheafify_kills_locally_zero` is well-formed: three items stated and proved, no `\uses{}`
       needed (pure Mathlib site theory), `\lean{}` names three declarations.
    2. `lem:cech_augmented_resolution` proof (rewritten Steps 3–4) is correct and complete:
       the cofinal-basis claim (`{V ⊆ some Uᵢ}` covers X because the Uᵢ do) is sound; the
       prepend-ifix contracting homotopy is cover-agnostic and handles the augmentation node;
       the sheafification-square transport to abelian sheaves is standard; `\uses{}` (both statement
       and proof) are accurate.
    3. No broken `\uses{}` / dangling labels introduced (`unknown_uses: []` confirmed by leandag).

## Severity summary

- **must-fix-this-iter**:
  - `Cohomology_CechHigherDirectImage.tex` / `lem:open_immersion_pushforward_comp`: `\lean{}` hint
    missing `AlgebraicGeometry.higherDirectImage_openImmersion_acyclic` — active prover target for
    `OpenImmersionPushforward.lean` this iter. Dispatch a blueprint-writer to add the missing name to
    the `\lean{}` field, or apply the fast-path re-review after the writer returns.
    **HARD GATE: `OpenImmersionPushforward.lean` is BLOCKED until this is fixed.**
    **HARD GATE: `CechAugmentedResolution.lean` CLEARS** — `lem:cech_augmented_resolution` is
    complete, correct, and `\uses{}` are clean; no must-fix finding touches it.

- **soon**:
  - `Cohomology_CechHigherDirectImage.tex` / `lean:AlgebraicGeometry.CechAcyclic.affine`:
    wire-up `\lean{}` in the chapter (probably `lem:affine_cech_vanishing_qcoh`). Not dispatched this iter.

- **informational**:
  - `lem:open_immersion_pushforward_comp` proof: one sentence on "j_* is exact because Rq j_*=0 for q≥1"
    would sharpen the "j_*I• is a resolution" step.

Overall verdict: `CechAugmentedResolution.lean` CLEARS the hard gate (all chapter verdicts `complete+correct`,
no must-fix on `lem:cech_augmented_resolution`); `OpenImmersionPushforward.lean` is BLOCKED by one must-fix
(missing `\lean{}` name for `higherDirectImage_openImmersion_acyclic` in `lem:open_immersion_pushforward_comp`)
— dispatch a blueprint-writer to add it, then fast-path re-review to unblock this iter.
3 chapters audited, 1 must-fix finding, 0 unstarted-phase proposals.
