# Progress-critic directive — iter-024

Assess convergence per active route. Two active prover routes this iter.

## Route 1 — `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean` (P3b free side)

Target: `cechFreeComplex_quasiIso` (the free-presheaf complex resolves the cover structure presheaf, evaluation-wise QuasiIso). This is an all-or-nothing `def`/`lemma` chain in `mathlib-build` mode — sorry count stays 0→0 every iter (no sorry pins allowed); progress is measured in axiom-clean declarations landed and whether the NAMED target exists.

Last-5-iter signals:
- iter-019: backbone built (`cechFreePresheafComplex`, `cechFreeSimplicial`). Status PARTIAL. Named target absent.
- iter-020: +18 decls (combinatorial engine; `cechFreeEval_X`, `cechFreeEval_quasiIso_of_isEmpty`). Status PARTIAL. Named target absent.
- iter-021: lane NOOP-DROPPED (plan-validate keyword bug) — no prover ran. No new data.
- iter-022: +14 decls (entire engine complex `cechEngineComplex` + d²=0 + contracting homotopy + positive-degree exactness + object-half of engine iso). Status PARTIAL. Named comm-square `cechFreeEvalEngineIso` absent. Blocker phrase: "differential comm-square / chain-vs-cochain variance match".
- iter-023: +14 decls. **`cechFreeEvalEngineIso` LANDED axiom-clean — the 3-iter bottleneck broke.** Plus bonus `cechEngineComplex_exactAt` + engine-augmentation cluster (`cechEngineAug0`, `cechEngineComplexAug`, etc.). Status PARTIAL. Named end-target `cechFreeComplex_quasiIso` still absent, but its two remaining inputs (`cechFreeEval_quasiIso_of_nonempty` (2) + the glue (3)) now have ALL prerequisites in-file and a precise recipe in `task_results/FreePresheafComplex.md` + `analogies/free-eval-engine-iso.md`.

Strategy: P3b phase Status ACTIVE, `Iters left` ~3–6. Phase has been active since ~iter-016.

## Route 2 — `AlgebraicJacobian/Cohomology/CechBridge.lean` (P3b bridge — `ses_cech_h1`)

Target: `ses_cech_h1` (for a SES of O_X-modules with Ȟ¹(𝒰,F)=0 on a cofinal cover system, sections G(U)→H(U) surjective). mathlib-build mode, all-or-nothing, sorry 0→0.

Last signals:
- iter-019: `cechComplex_hom_identification` done.
- iter-020: bridge infra (`homCechComplexMapOpIso`, `sectionCechComplexMapOpIso`, `quasiIso_map_preadditiveYoneda_of_injective`).
- iter-023 (lane opened fresh as independent frontier): +2 decls — the Čech-algebra core (`sectionCech_objD_exact_of_isZero_homology`, `sectionCech_one_coboundary_of_isZero_homology` = "Ȟ¹=0 ⟹ 1-cocycle is coboundary" in section coordinates). Status PARTIAL. Named `ses_cech_h1` absent. Blocker phrase: "residual is pure sheaf theory — local-surjectivity extraction (epi-on-sheaves ⟹ local lifts) + Grothendieck-topology gluing for SheafOfModules over a scheme; neither a one-liner, both absent in directly-usable form".

Strategy: same P3b ACTIVE phase, `Iters left` ~3–6.

## This iter's proposed objectives (PROGRESS.md `## Current Objectives`)

2 files, one prover each:
1. `FreePresheafComplex.lean` — build (2) `cechFreeEval_quasiIso_of_nonempty` + (3) `cechFreeComplex_quasiIso` (the named target) from the in-file prerequisites + recipe. mathlib-build.
2. `CechBridge.lean` — build `ses_cech_h1`, after this iter's blueprint expansion adds the located Mathlib local-surjectivity + gluing API hints (a mathlib-analogist consult runs first). mathlib-build.

## What I need from you
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and, for any CHURNING/STUCK, the named corrective TYPE. Specifically assess whether Route 1 is now CONVERGING (bottleneck broke, residual has precise recipe + in-file prereqs) and whether Route 2 is a sound fresh lane or at risk of churn given the sheaf-theory residual.
