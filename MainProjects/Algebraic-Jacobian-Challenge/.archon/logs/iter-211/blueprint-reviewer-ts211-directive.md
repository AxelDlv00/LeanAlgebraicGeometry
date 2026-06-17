# Blueprint review — iter-211 (HARD GATE for the TS dispatch)

You audit the **entire** blueprint under `blueprint/src/chapters/` as usual.
Produce the per-chapter completeness/correctness table and the prioritized
must-fix list.

## Strategy context (what is being attempted this iter)

The critical path to the project's PRIMARY GOAL (Pic_{C/k} representability,
A.2.c) currently runs through the line-bundle ⊗-group law, lane "TS",
formalized in `Picard/TensorObjSubstrate.lean` and blueprinted in
`Picard_TensorObjSubstrate.tex`. After a multi-iter pivot the construction is
now the **⊗-invertibility idiom** (the Picard group = units of the commutative
monoid of ⊗-iso-classes of invertible scheme-modules), with the associator
built via the **flat-exactness whiskerLeft** realization (load-bearing lemma
`W_whiskerLeft_of_flat` / `lem:flat_whisker_localizer`), NOT local
trivialization.

This iter the plan agent intends to dispatch a prover on
`Picard/TensorObjSubstrate.lean` to scaffold + prove the buildable group-law
ingredients. Per the HARD GATE, that dispatch is authorized only if
`Picard_TensorObjSubstrate.tex` is complete + correct with no must-fix.

## Chapter of primary concern — `Picard_TensorObjSubstrate.tex`

Judge this chapter against these specific questions (in addition to your
standard checklist):

1. Is the flat-whiskerLeft associator proof sketch
   (`lem:tensorobj_assoc_iso` + `lem:flat_whisker_localizer`) rigorous enough
   to formalize? In particular: is the claim "an ⊗-invertible object is flat, so
   the flat hypothesis is free" justified, and is the reduction of
   `W_whiskerLeft_of_flat` to `Module.Flat.lTensor_preserves_injective_linearMap`
   + right-exactness sound?
2. Are the unit/braiding lemmas (`lem:tensorobj_unit_iso`,
   `lem:tensorobj_comm_iso`) and the iso-class commutative-group assembly
   (`lem:tensorobj_isoclass_commgroup`) each given enough detail to formalize
   as `Nonempty`-truncated existence-of-iso statements?
3. **Lean-vs-chapter consistency of the "Off-path declarations (retained, not
   on the critical path)" section** (currently the last section of the
   chapter). It asserts that `monoidalCategory`, `tensorObj_restrict_iso`,
   `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj` are "retained in
   the Lean file" carrying `sorry`. The current Lean file
   `Picard/TensorObjSubstrate.lean` contains ONLY `tensorObj_substrate` and
   `tensorObj` — none of those off-path decls are present. Flag whether this
   section is stale/incorrect and should be corrected (e.g. to say those
   routes are abandoned/removed, not retained).
4. Do all `\lean{...}` targets name plausible declarations, and are the
   `\uses{...}` edges present and acyclic?

## Known problem areas from prior iters

- The old δ-mate / `tensorObj_restrict_iso` route was DISPROVEN as multi-file
  Mathlib-blocked (opaque `PresheafOfModules.pullback`). Confirm the chapter no
  longer relies on it on the critical path.
- The local-trivialization associator realization was rejected as a "renamed
  wall" (it routes through the sorry'd `tensorObj_restrict_iso`). Confirm the
  chapter's associator is the flat-whiskerLeft realization, not local
  trivialization.

## Output

Write to `task_results/blueprint-reviewer-ts211.md`:
- per-chapter table (all chapters),
- prioritized must-fix-this-iter list (name `Picard_TensorObjSubstrate.tex`
  explicitly if it is not dispatch-ready, with the exact fix),
- unstarted-phase proposals,
- any writer directives.
