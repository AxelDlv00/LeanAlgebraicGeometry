# Blueprint-writer ts-offpath211 — report

## Outcome: NO EDIT MADE (directive premise is stale)

The directive asked me to rewrite the chapter's final section "Off-path
declarations (retained, not on the critical path)" in
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, which it says
currently asserts that `monoidalCategory`, `tensorObj_restrict_iso`,
`exists_tensorObj_inverse`, and `addCommGroup_via_tensorObj` are "retained in
the Lean file" and "carry `sorry`".

After fully reading the chapter (all 1373 lines) and the Lean file
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (488 lines), **the section
described in the directive does not exist**, and the chapter is already
consistent with the Lean file. I made no edits — there is nothing matching to
rewrite, and forcing the directive's framing would introduce a *new* factual
error.

## Evidence

### 1. The target section is absent
- No section titled "Off-path declarations (retained, not on the critical
  path)" exists. The chapter's final two sections are
  `\section{Out of scope}` (`sec:tensorobj_out_of_scope`) and
  `\section{Internal-consistency check}` (`sec:tensorobj_consistency_check`).
- Grep over the chapter for `Off-path declarations`,
  `retained, not on the critical`, `monoidalCategory`, `carry.*sorry`,
  `abandoned`, `removed`, `δ-mate`, `MonoidalClosed wall` → **no matches**.
- No prose anywhere claims those four declarations are "retained in the Lean
  file" and "carry `sorry`".

### 2. The directive's description of the Lean file is also incorrect
The directive states the Lean file "contains ONLY `tensorObj_substrate` and
`tensorObj`." In fact:
- There is **no** `tensorObj_substrate` declaration in the file.
- The file contains ten declarations: `tensorObj`, `tensorObj_functoriality`,
  `tensorObjIsoOfIso`, `tensorObj_unit_iso`, `restrictIsoUnitOfLE`,
  `tensorObj_restrict_iso` (body `sorry`), `tensorObj_isLocallyTrivial`,
  `exists_tensorObj_inverse` (body `sorry`), `tensorObjOnProduct`, and
  `PicSharp.addCommGroup_via_tensorObj` (body `sorry`).
- Only `monoidalCategory` is genuinely absent — removed in the iter-206 pivot,
  as documented in the file's §2 comment (`TensorObjSubstrate.lean:221–233`).

So three of the four named "off-path" declarations ARE present in the Lean
file and DO carry `sorry`. Adopting the directive's premise ("none are
present; none carry `sorry`") would have written a false statement into the
blueprint.

### 3. The chapter is already consistent with the current Lean file
- `rem:scheme_modules_monoidal_off_path` already records the global
  `MonoidalCategory` as explicitly off the critical path and *not built* —
  matching the Lean file (no `monoidalCategory` instance).
- `lem:tensorobj_restrict_iso` already says it "is retained only as an optional
  supplement; its full proof is deferred" — matching the `sorry` body in the
  Lean file.
- `exists_tensorObj_inverse` and `addCommGroup_via_tensorObj` appear as
  `\lean{...}` pins of live blueprint statements
  (`lem:tensorobj_inverse_invertible`,
  `thm:rel_pic_addcommgroup_via_tensorobj`), not inside any false
  "retained, carry `sorry`" list.

## Conclusion
The consistency correction the directive targets appears to have already been
applied (or the chapter restructured) in a prior iteration. The current chapter
prose is already accurate with respect to the Lean file. I therefore left the
file untouched. No `\leanok`/`\mathlibok` markers were changed, and no other
chapter was touched.

If the iter-211 review still flags a specific stale sentence, please point to
the exact line — I could not locate any claim matching the directive's
description in the on-disk chapter.
