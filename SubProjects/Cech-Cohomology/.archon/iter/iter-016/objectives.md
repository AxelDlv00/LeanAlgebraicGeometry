# Iter-016 objectives — 3 parallel prover lanes (all gate-cleared by blueprint-reviewer iter016)

| # | File | Mode | Target | Blueprint | Status entering |
|---|------|------|--------|-----------|-----------------|
| 1 | `CechAcyclic.lean` | prove | close `CechAcyclic.affine` (L93) via L1↔L2↔L3 | `lem:cech_acyclic_affine` (+L1 paragraph added iter-016) | 1 sorry; L3 done, L1 now blueprinted |
| 2 | `PresheafCech.lean` | mathlib-build | build `sectionCechComplex` (cosimplicial→`alternatingCofaceMapComplex`); start `cechComplex_hom_identification` if budget | `def:section_cech_complex`, `lem:cech_complex_hom_identification` | 2 decls done; section complex pending |
| 3 | `FreePresheafComplex.lean` (new) | mathlib-build | build `cechFreePresheafComplex` (simplicial→`AlternatingFaceMapComplex`) → `cechFreeComplex_quasiIso` | `def:cech_free_presheaf_complex`, `lem:cech_free_complex_quasi_iso` | new skeleton, 0 decls |

## Key recipes / dead ends (carried into the lanes)
- L3 `d²=0` and the contracting homotopy come FREE from `alternating*MapComplex` — do NOT hand-roll the
  alternating-sum identity in lanes 2/3.
- Lane 1 dependent-coefficient L3 port: per-tuple family + prepend-iso `A(cons r τ)≅A τ` (`s_r` is a
  unit after localising at `s_r`); reuse the constant-`M` `combDifferential_exact` cancellation skeleton.
- DEAD END (all lanes): `SimplicialObject.Augmented.ExtraDegeneracy` (wrong variance, no cosimplicial
  dual in Mathlib).
- Lane 2 DEAD END: do NOT derive the cosimplicial object from the Čech nerve in `Opens X` (poset ⇒
  intersections degenerate, index data lost); the indexed product over `Fin(p+1)→ι` must be explicit.

## Subagents dispatched this iter
- blueprint-writer `l1bridge` (L1 gap) — COMPLETE; Stacks 01HV sourced, retriever fetched stacks-schemes.tex.
- refactor `split-freecomplex` (new file + import) — COMPLETE; build green 8324 jobs.
- progress-critic `iter016` — UNCLEAR/UNCLEAR, no must-fix.
- blueprint-reviewer `iter016` — HARD GATE clears all 3 files (1 must-fix = covers line, fixed).
