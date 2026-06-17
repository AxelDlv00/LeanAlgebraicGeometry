# Blueprint-reviewer directive — iter-232

Whole-blueprint audit (read every chapter under `blueprint/src/chapters/`). Standard
per-chapter completeness + correctness checklist + cross-chapter view.

## Priority focus this iter
1. **`Picard_TensorObjSubstrate.tex`** — the chapter backing the sole active prover lane.
   This iter the Lean file `Picard/TensorObjSubstrate.lean` is being file-split into
   `TensorObjSubstrate/{PresheafInternalHom, Vestigial}.lean` + the remaining main file.
   The chapter's `\lean{}` pins still point at the (unchanged-name) declarations — verify
   the chapter is complete + correct for the C-bridge build, in particular:
   - `lem:dual_restrict_iso` — is it a properly NAMED lemma with a `\lean{}` pin and a
     correct objectwise base-change recipe (`f^*ℋom(A,𝒪)≅ℋom(f^*A,f^*𝒪)`, presheaf level
     over the varying ring `𝒪(V)`, via `restrictScalarsRingIsoDualEquiv`)? Does it
     correctly AVOID the dead `overSliceSheafEquiv` route (iter-230 settled it does not
     transport the C-bridge)?
   - Is there a block for the first incremental sub-deliverable, the per-`V` slice
     equivalence `Over_Y V ≌ Over_X (f.opensFunctor V)`? If absent, flag it as a
     must-add (the prover needs it as a named target).
   - `lem:dual_isLocallyTrivial`, `lem:dual_unit_iso` (currently prose-only?),
     `exists_tensorObj_inverse` assembly.
2. **`Cohomology_FlatBaseChange.tex`** — newly wired into `content.tex` this iter (was an
   orphan). Assess whether it is complete + correct enough to back a parallel engine
   prover lane (i=0 flat base change, Stacks 02KH): are the statements well-formed, the
   `\lean{}` pins present, the proof detailed enough to formalize?

## Standard duties
- Per-chapter `complete: true/partial/false` × `correct: true/partial/false`.
- `## Unstarted-phase blueprint proposals`: name every strategy phase with no blueprint
  coverage and give a concrete chapter outline. In particular the A.2.c representability
  ENGINE (`R^i f_*` for i≥1, Relative Proj, CM-regularity, semicontinuity, Quot
  representability, relative Cartier) is largely un-blueprinted — propose the next 2–3
  engine chapters to seed for the USER parallelism directive.
- Broken `\uses{}` / missing `\lean{}` pins on any chapter feeding an active or
  about-to-activate lane.

Do not limit scope — the cross-chapter view is the point.
