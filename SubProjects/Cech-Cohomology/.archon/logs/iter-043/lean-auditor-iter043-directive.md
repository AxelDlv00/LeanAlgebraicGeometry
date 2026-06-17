# lean-auditor directive — iter-043

## Files to audit (read in full)
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

This is the only `.lean` file modified this iteration.

## Focus areas
1. **Two new `rfl`-bodied lemmas** near lines ~730 and ~740:
   `AlgebraicGeometry.modulesSpecToSheaf_smul_eq` and
   `AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq`. Each is closed by a bare `rfl`
   asserting a scalar-action identity. Judge whether each `rfl` is a genuine definitional
   equality or a spurious/fragile one. The second lemma crosses two open-immersion `appIso`
   ring maps and an iterated restriction; scrutinize whether the asserted carrier coincidence
   (`(modulesRestrictBasicOpen g F).val.obj (op ⊤)` vs `F.val.obj (op W)`, W the iterated image
   open) is real or a `show`-coercion that hides a type mismatch.
2. Any in-file comment block in the `TileSectionLocalization` section documenting a "proven
   tactic prefix" for a not-yet-added lemma — verify the comment does not over-claim what is
   actually compiled (the lemmas `tile_scalar_compat` / `tile_section_comparison` /
   `tile_section_localization` are NOT defined; only a comment describes them).
3. Outdated comments / docstrings that contradict the current code.
4. Any other dead-end proofs, suspect definitions, or bad Lean practices.

## Verification note
A fresh `lake env lean` on this file returns EXIT 0; both new lemmas report axioms
`{propext, Classical.choice, Quot.sound}`. Confirm independently if you can, but the
build is green.

## Output
Per-file checklist + flagged-issues block to `task_results/lean-auditor-iter043.md`.
