# blueprint-reviewer directive — ts228

Whole-blueprint audit (read every chapter — the cross-chapter view is the point). Produce your
standard per-chapter checklist (complete? correct? Lean targets well-formed? proofs detailed
enough? broken `\uses{}`?) plus the unstarted-phase proposals section.

## Gate focus

The only `.lean` file under active prover work this iter is
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, blueprinted by
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. The plan needs a fresh
**complete + correct + no-must-fix** verdict on THIS chapter to clear the HARD GATE for the
prover dispatch (same-iter fast path: last full audit was iter-225; the chapter was edited
iters 227–228). Give that chapter's verdict explicitly and prominently.

## What changed in `Picard_TensorObjSubstrate.tex` this iter (iter-228 writer round)

Five edits, all aligning the chapter with the current Lean state for the d.2-FREE descent re-route
that will close `exists_tensorObj_inverse`:
1. NEW `lem:restrictscalars_ringiso_dualequiv` (`\lean{restrictScalarsRingIsoDualEquiv}`) in
   `sec:tensorobj_dual_infra` — dual analogue of `lem:restrictscalars_ringiso_tensorequiv`; the H2′
   ingredient of the C-bridge restrict-iso.
2. NEW `def:scheme_modules_homMk` (`\lean{AlgebraicGeometry.Scheme.Modules.homMk}`) — A-bridge step
   (ii) wrapper.
3. EXPANDED proof of `lem:dual_isLocallyTrivial` (the C-bridge) — names the verbatim-mirror route of
   the closed `lem:tensorobj_restrict_iso` (steps reused + H1 + H2′), with the "no tensor stalk /
   no whiskering" justification. This is THIS iter's PRIMARY prover target.
4. EXPANDED proof of `lem:sheafofmodules_hom_of_local_compat` (the A-bridge) — names the
   `existsUnique_gluing`-on-`presheafHom` route, the load-bearing `localSection`-with-naturality
   sub-piece, the four mechanical sub-steps, and a ~120–190 LOC size estimate.
5. CORRECTED `rem:dual_discharges_inverse` — re-routed the `⊗`-inverse discharge AWAY from the
   confirmed dead-end "sheafify the presheaf evaluation" route (which re-hits the abandoned d.2
   tensor-stalk/whiskering) TO the descent re-route: glue canonical local contractions via the
   A-bridge `lem:sheafofmodules_hom_of_local_compat`, then conclude global iso via the B-connector
   `lem:isiso_of_isiso_restrict`. `\uses{}` updated accordingly (dropped `lem:internal_hom_eval`).

## Specific checks requested

- Confirm `lem:dual_isLocallyTrivial`'s expanded proof sketch is now detailed enough to formalize
  as a mirror of `lem:tensorobj_restrict_iso` (the primary target this iter) — flag any gap.
- Confirm the corrected `rem:dual_discharges_inverse` is mathematically sound (gluing canonical
  local contractions that agree on overlaps → global morphism → locally-iso ⇒ global iso) and no
  longer depends on the forbidden eval route.
- Confirm the new `lem:restrictscalars_ringiso_dualequiv` and `def:scheme_modules_homMk` statements
  match their pinned Lean declarations (both already exist in the Lean file, axiom-clean).
- Note (informational, not a gate-blocker for this iter): the writer flagged that
  `lem:internal_hom_eval` is now off the inverse-discharge path but still `\uses`-referenced by
  earlier blocks (`sec:tensorobj_onproduct_lift`, ~L1617/L1638); say whether those references are
  still mathematically warranted or are now vestigial.

Report any must-fix-this-iter findings prominently so the plan can decide whether the prover
dispatch proceeds this iter or the chapter needs another writer pass first.
