# Recommendations for iter-002 (plan agent)

## Context: iter-001 was a no-prover repair iter

No prover ran (mechanical HARD GATE). Strategy + three blueprint chapters were
rewritten. The blueprint is now in much better shape (0 ∞-holes, doctor clean),
but the **Lean side has not caught up to it**: the three frontier objectives are
still `AlgebraicGeometry.TODO.*` placeholders and `genericFlatness` is false-as-signed.

## Highest-priority actions (gating prover dispatch)

1. **Scaffold the 3 frontier TODO signatures.** Run `lean-scaffolder` to replace the
   placeholder `AlgebraicGeometry.TODO.*` decls with real signatures + `sorry` bodies,
   consuming the `% INTENDED LEAN SIGNATURE:` scaffold notes the writers left:
   - `lem:base_change_map_affine_local` — FBC affine lemma. Note the orientation
     subtlety the plan flagged: state the helper as `Γ(α) = cancelBaseChange⁻¹`
     (the provable orientation), not the reverse.
   - `lem:pushforward_base_change_mate_cancelBaseChange` — highest effort (5160);
     consider `effort-breaker` before assigning a prover.
   - `thm:generic_flatness_algebraic` — `genericFlatnessAlgebraic`.
   Re-sign `genericFlatness` with `[IsQuasicoherent]` + `[IsFiniteType]` (the
   coherence encoding; Mathlib has no `IsCoherent` predicate at the pin).

2. **Run `blueprint-clean`** AFTER the scaffold has consumed the `% INTENDED LEAN
   SIGNATURE:` notes and BEFORE dispatching provers (the plan queued this for iter-002;
   running it earlier would strip scaffold guidance the scaffolder still needs).

3. **Re-run the mandatory `blueprint-reviewer`** to re-confirm complete+correct on the
   rewritten chapters. Only chapters that clear the HARD GATE may feed a prover. The
   same-iter fast path is available once the build is green.

## Coverage debt — unmatched `lean_aux` nodes (Step 6, for planner to blueprint)

`dag-query unmatched` reports 4 Lean declarations with **no blueprint entry** (carried
in from extraction; not created this session). Author informal-prose blueprint entries
so the dependency graph regains 1:1 correspondence:

- `AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite`
  — in `AlgebraicJacobian/Picard/FlatteningStratification.lean` (chapter:
  `Picard_FlatteningStratification.tex`). Generic-freeness localization helper.
- `AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite`
  — same file/chapter.
- `AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite`
  — same file/chapter.
- `AlgebraicGeometry.gammaPushforwardNatIso`
  — in `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (chapter:
  `Cohomology_FlatBaseChange.tex`). The Γ∘pushforward natural-iso dictionary the FBC
  route relies on.

These are all `proved: true, has_sorry: false` — proven helpers. The doctrine "when there
is Lean there must be tex" applies: add thin blueprint stubs (statement + `\lean{...}` +
one-line proof pointer) so they stop being graph-invisible.

## Blocked / do-not-retry

- None. No prover attempts were made, so there are no failed approaches to blacklist.

## Strategy follow-through (from plan sidecar, for awareness)

- The strategy-critic CHALLENGE was accepted in full (no rebuttals); its re-confirmation
  is deferred to iter-002's mandatory strategy-critic dispatch. The FBC route pivot
  (direct-on-sections + H⁰-equalizer, Čech-free) is low-risk but unproven — the cheapest
  reversing signal is the affine-lemma attempt discovering an irreducible mate computation
  still hides under the section-level identification. Watch for that when prover work begins.
- QUOT re-sign remains blocked on two absent-at-pin predicates (schematic/proper-support
  closed subscheme; rank-`r` local-freeness) — project-side sub-builds before the QUOT stubs
  can be re-signed honestly. Not an iter-002 prover target.
