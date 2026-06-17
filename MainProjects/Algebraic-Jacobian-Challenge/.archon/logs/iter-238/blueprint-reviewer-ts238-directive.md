# blueprint-reviewer ts238 directive

Whole-blueprint audit (read every chapter under `blueprint/src/chapters/`). Standard per-chapter
completeness + correctness checklist + unstarted-phase proposals.

## This iter's focus for the HARD GATE

Two files are candidates for prover dispatch this iter; confirm their backing chapters are
complete + correct with no must-fix:

1. **`Picard/TensorObjSubstrate.lean`** — chapter `Picard_TensorObjSubstrate.tex`. This iter's prover
   builds the **by-hand group law**: `thm:pic_commgroup` (`\lean{...picCommGroup}`) and its dependency
   blocks `lem:tensorobj_assoc_iso_invertible`, `def:pic_carrier` (`PicGroup`), `lem:isinvertible_tensor`
   (`IsInvertible.tensorObj`), `lem:isinvertible_unit`, `lem:isinvertible_inverse_welldef`
   (`IsInvertible.inverse_unique`). Verify these blocks (sections `sec:tensorobj_invertibility` /
   `sec:tensorobj_pic_carrier`, ~L2280–2900) are complete + correct + formalizable, that the proof
   sketches give enough detail to formalize the `CommGroup` by hand (one existence-of-iso per axiom),
   and that the `\uses{}` DAG is right (associator now UNCONDITIONAL — `tensorObj_assoc_iso` no longer
   needs locally-trivial hyps).

   Known issue to confirm/flag: `lem:stalk_tensor_commutation_naturality_right` (~L2159) pins
   `\lean{PresheafOfModules.stalkTensorIso_naturality_right}`, a decl that does NOT exist (iter-237
   inlined the B-naturality inside `isLocallyInjective_whiskerLeft_of_W` instead). Report whether this
   stale pin needs a `% NOTE:` / `\lean{}` repoint (review-agent action) — it does not block the
   group-law lane but should be flagged.

2. **`Cohomology/FlatBaseChange.lean`** — chapter `Cohomology_FlatBaseChange.tex`. Possible (pending a
   progress verdict) prover dispatch on `lem:pushforward_spec_tilde_iso` route-iii. The iter-237 prover
   reduced the brick to one named `hloc` obligation and added 3 helper decls
   (`IsLocalizedModule.powers_restrictScalars`, `fromTildeΓ_app_isIso_of_isLocalizedModule`,
   `pushforward_spec_tilde_iso_of_isLocalizedModule`) that currently have NO `\lean{}` blocks. Report
   whether the chapter needs helper `\lean{}` blocks added for these (a blueprint-writer task) and
   whether the route-iii proof sketch matches the implemented decomposition.

Report per-chapter status (complete/partial/false on each axis) and any must-fix-this-iter findings.
Also surface any unstarted-phase blueprint proposals as usual.
