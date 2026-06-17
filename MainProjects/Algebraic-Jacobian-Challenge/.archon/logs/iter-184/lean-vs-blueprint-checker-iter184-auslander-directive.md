## File to check

- Lean file: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- Blueprint chapter: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`

## iter-184 change

Lane G closed both inductive-step residuals of `depth_eq_smallest_ext_index` (file's central Stacks 00LP theorem) — Tier-1 axiom-clean (`{propext, Classical.choice, Quot.sound}` only). Helpers used: existing axiom-clean `ext_smul_eq_zero_of_mem_annihilator`, `ext_vanish_of_natCast_lt_depth`, `natCast_add_one_le_of_le_sub_one`. Helper budget unused (0 new helpers).

Propagation effect: `depth_of_short_exact` (transitively dependent via `ext_vanish_of_natCast_lt_depth`) is now also kernel-clean.

`auslander_buchsbaum_formula` (L835) NOT attempted this iter — task_result documents substrate gaps (minimal-finite-free-resolution + "what is exact" + snake-lemma + depth-drops-by-one — all missing from Mathlib `b80f227`).

## What I expect

- Does the chapter prose for `depth_eq_smallest_ext_index` (Stacks 00LP) match the LES-of-Ext + Nakayama-extracted regular sequence proof that landed?
- Does the chapter under-specify `auslander_buchsbaum_formula`'s proof in a way that misled the planner into a "30-60 LOC" estimate when actual substrate is 4-8 iters? If so, flag the chapter as needing expansion.
- Is the chapter explicit about which of A.4.a's downstream consumers actually need AB (vs only needing `CohenMacaulay.of_regular`)?

## Out of scope

- Other files / chapters.

## Report length

Under ~200 lines.
