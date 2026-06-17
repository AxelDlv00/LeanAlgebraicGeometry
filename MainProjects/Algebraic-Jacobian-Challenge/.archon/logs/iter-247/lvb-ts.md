# lean-vs-blueprint-checker directive — iter-247 — TensorObjSubstrate

Bidirectionally verify ONE Lean file against its blueprint chapter.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## What changed this iter (context only — verify independently)
Two new axiom-clean declarations were added (~L1495–1530): `presheafUnit_comp_map_eta` (presheaf-side mate
identity) and `isIso_sheafifyEta_of_unitSquare` (IsIso reduction of the η-bridge to a single unit-comparison
square equation). These are project-local supplements toward D2' (`lem:pullback_tensor_iso_unit`); the
unconditional η-bridge / the square equation itself was NOT closed (left unpinned, no sorry). The file's only
remaining sorry is the pre-existing `exists_tensorObj_inverse` (L692).

## Report
- Lean → blueprint: are the chapter's `\lean{...}` pins valid? Are the D2'/D3'/D4' forward targets
  represented honestly (as not-yet-closed), or does the chapter overclaim closure?
- Blueprint → Lean: is the chapter detailed enough to guide the remaining η-bridge square equation?
- The blueprint-doctor flagged 3 broken `\uses{\leanok ...}` in this chapter, targets undefined:
  `lem:islocallyinjective_whiskerleft_via_stalk`, `lem:tensorobj_assoc_iso_invertible`,
  `lem:tensorobj_comm_iso` (each with a `\leanok` apparently stuck inside the `\uses{}` braces). Confirm,
  and report whether each intended target exists under another label.
