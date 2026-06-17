# Iter-015 objectives

Two parallel `mathlib-build` prover lanes (re-dispatch of the limit-aborted iter-011 plan).

| # | File | Phase | Goal | Mode | Recipe | Gate |
|---|------|-------|------|------|--------|------|
| 1 | `CechAcyclic.lean` | P3 | Close `CechAcyclic.affine` sorry (L1 Γ↔localisation, L2 `exact_of_isLocalized_span`, L3 explicit module homotopy; **avoid `ExtraDegeneracy`**) | mathlib-build | `analogies/p3-localisation.md` | clear (iter-013 reviewer) |
| 2 | `PresheafCech.lean` | P3b | Scaffold+build the presheaf-Čech chain bottom-up (`sectionCechComplex` → `cechFreePresheafComplex` → `cechComplex_hom_identification` → `cechFreeComplex_quasiIso` → `injective_cech_acyclic`); go as far as possible | mathlib-build | `analogies/p3b-presheafcech.md` | clear (iter-013 reviewer) |

Deferred: P5a (off shortest path until `affine_serre_vanishing` lands). See `plan.md` §D1.

No subagents dispatched — three mandatory critics skipped with rationale (`plan.md` §Subagent skips):
blueprint gate standing-clear, STRATEGY unchanged+SOUND, no real prover trajectory to assess
(iter-011 prover phase was weekly-limit-aborted).
