# Iter-023 objectives (per-lane detail)

Two parallel `mathlib-build` lanes, both frontier-ready, both HARD-GATE-cleared (blueprint-reviewer
`iter023`), both scaffold+build (target decls do not exist yet; noop-trap keyword on the path line).

## Lane 1 — `FreePresheafComplex.lean` — `cechFreeEvalEngineIso` → `cechFreeComplex_quasiIso`
- **Status entering:** engine complex `cechEngineComplex` (d²=0 + contracting homotopy + positive-degree
  exactness) + object-half iso `cechFreeEvalEngine_X` all built iter-022, axiom-clean. The ONE missing
  fact is `comm` (the differential comm-square / chain-vs-cochain variance match).
- **Targets:** (1) `cechFreeEvalEngineIso` (`lem:cech_free_eval_engine_iso`) — `isoOfComponents` with the
  `comm` square on `Sigma.ι`; (2) `cechFreeEval_quasiIso_of_nonempty` (`lem:cech_free_eval_nonempty`) —
  Route B (engine exactness → `IsZero` homology + `toSingle₀Equiv` deg-0, transfer by
  `quasiIso_of_arrow_mk_iso`); (3) `cechFreeComplex_quasiIso` (`lem:cech_free_complex_quasi_iso`, named) —
  glue via `quasiIso_of_evaluation`.
- **Recipe:** `analogies/free-eval-engine-iso.md` + `task_results/FreePresheafComplex.md`
  §cechFreeEvalEngineIso (the 60–120-line `comm` route). Blueprint `lem:cech_free_eval_engine_iso` now
  carries the 3-layer naturality/variance sketch.
- **Reversal signal:** 4th substantive iter with the comm-square not advanced ⇒ structural refactor of the
  combinatorial differential derivation (next-iter item 3).

## Lane 2 — `CechBridge.lean` — `ses_cech_h1` (NEW, independent)
- **Status entering:** decl does not exist (planned). Independent of Lane 1 (`\uses{def:cech_complex}`
  only; takes Ȟ¹ vanishing as hypothesis).
- **Target:** `ses_cech_h1` (`lem:ses_cech_h1`, Stacks `lemma-ses-cech-h1`) — SES of `O_X`-modules +
  cofinal Ȟ¹-vanishing covers ⇒ `G(U)→H(U)` surjective on sections.
- **Recipe:** the blueprint `lem:ses_cech_h1` block (verbatim Stacks source quote + the gluing proof:
  local lift → 1-cocycle in `F` → coboundary by Ȟ¹=0 → corrected sections glue). Locate Mathlib
  local-surjectivity / Čech-`H¹` coboundary / sheaf-gluing infra first (LSP); build project-side if absent.
- **Accept partial:** if the sheaf-epi local-surjectivity or gluing infra needs project-side construction,
  hand off a precise decomposition (mathlib-build, no sorry pin).
