# lean-vs-blueprint-checker — AuslanderBuchsbaum (slug ab-iter198)

## File

`AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`

## Blueprint chapter

`blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`

## Context (minimal)

iter-198 added 2 new axiom-clean substrate helpers:
- `RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`
  at L1023–L1124 (~100 LOC body).
- `RingTheory.Module.exists_isSMulRegular_of_one_le_depth`
  at L1138–L1166 (~30 LOC body).

These close the iter-194 "gap (4) depth-drops-by-one" substrate
piece. The parent target `auslander_buchsbaum_formula_succ_pd`
(L1299) sorry was NOT closed (gaps 1–3 still absent: minimal-
resolution carving, "what is exact" Stacks 00MF, snake-lemma on
minimal resolution). Existing docstring at L562–L574 said
"FOUR core ingredients ALL absent at Mathlib b80f227" — iter-198
landed (4), so that summary is now stale.

## Questions

- **Lean → blueprint**: does the chapter's "5 ingredients"
  enumeration (or whatever the chapter calls it) accurately reflect
  the iter-198 landing? Is depth-drops-by-one pinned with a
  `\lean{...}` to the new declaration?
- **Blueprint → Lean**: is the inductive step (Matsumura §19 /
  Stacks 090V) explained at enough detail for the prover to land
  the remaining 3 gaps in iter-199+? Does the chapter's "iters left"
  estimate reflect the 6–12 band the strategy now uses?
- Was an in-file docstring (L562–L574, L1106–L1114) updated to
  reflect "gap (4) closed iter-198"? If still says "FOUR absent",
  flag as must-fix-major.

## What to flag

- Missing `\lean{...}` pins for the 2 new helpers (if the chapter
  refers to them informally).
- Stale "off-critical-path" framing in the file (the iter-198
  USER directive elevated this to priority-1; a stale in-file
  "OFF-CRITICAL-PATH" comment would be misleading).
- `\leanok` mismatches.
