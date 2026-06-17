# Blueprint Reviewer Directive (scoped fast-path)

## Slug
tsgate206

## Scope
This is a SAME-ITER FAST-PATH re-review scoped to ONE chapter:
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
(Lean file `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, A.1.c.SubT).

The chapter was rewritten this iter (blueprint-writer ts-pivot206) and
cleaned (blueprint-clean ts-pivot206, PASS) to move the relative Picard
group law off the over-built all-modules `MonoidalCategory`/`MonoidalClosed`
route onto the flat/line-bundle idiom: the group law is the group of
iso-classes of line bundles under tensor (four existence-of-iso lemmas —
assoc/unit/comm/inverse — plus a flat-scoped restriction iso
`tensorObj_restrict_iso`, elementary flat-exactness), mirroring Mathlib's
`CommRing.Pic = Units (Skeleton …)` / `Module.Invertible`. The full
`MonoidalCategory` theorem was demoted to an off-critical-path remark
(`rem:scheme_modules_monoidal_off_path`).

## What to assess (HARD GATE verdict for the prover dispatch)
Render the per-chapter checklist verdict (`complete: true|partial|false`,
`correct: true|partial|false`) for THIS chapter, plus any
must-fix-this-iter findings. Specifically:

1. **Completeness**: are the new lemmas (`lem:tensorobj_restrict_iso`,
   `lem:tensorobj_assoc_iso`, `lem:tensorobj_unit_iso`,
   `lem:tensorobj_comm_iso`) and the rewritten
   `thm:rel_pic_addcommgroup_via_tensorobj` proof specified in enough
   mathematical detail for a prover to formalize? Is the group-law
   assembly from the four iso lemmas + `QuotientAddGroup` complete?
2. **Correctness**: is the flat-exactness justification of
   `tensorObj_restrict_iso` (flat ⇒ `lTensor` preserves injectivity;
   `⊗` right-exact) mathematically sound for line bundles? Is the claim
   that the group axioms on iso-classes are propositions needing no
   monoidal coherence correct? Does the `Pic⁰`-as-line-bundle-group law
   match Kleiman §2 (df:aPf/df:Pfs) and Stacks 01CR?
3. **Well-formed Lean targets**: the new iso lemmas are intentionally
   unpinned (`\lean{}` to be assigned at scaffold time); is that acceptable,
   or does the chapter need pins before a prover runs? The pre-existing pins
   (`def:scheme_modules_tensorobj`, `lem:..._functoriality`,
   `lem:tensorobj_preserves_locally_trivial`,
   `lem:tensorobj_inverse_invertible`, `lem:tensorobj_lift_onproduct`,
   `thm:rel_pic_addcommgroup_via_tensorobj`) — still well-formed?
4. **No dangling refs** to the removed `thm:scheme_modules_monoidal`.

Report whether this chapter clears the HARD GATE (complete + correct + no
must-fix) so a prover may be dispatched on `TensorObjSubstrate.lean` THIS
iter. You MAY read the rest of the blueprint for cross-chapter consistency
if useful, but the verdict needed is for this one chapter.
