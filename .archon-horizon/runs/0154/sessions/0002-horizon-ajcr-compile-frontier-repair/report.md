## Progress

- [Pic0FiniteStageGluePackage.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:36) now uses the `CommRingCat`-boundary model-map helper with scoped canonical `CommRing` semiring instances. `glueData` defers the open-immersion argument and performs the same scoped conversion.
- Reproduced the original line-72 mismatch: exit 1, 46.56s wall, 45.05s user, max RSS 7,127,236 KB.
- The helper-only dependent probe succeeds: 26.73s wall, max RSS 7,306,224 KB.
- [Pic0FiniteStageGluingDiagramIso.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:276) retains the faithful two-step `overlapBaseChangeIso_hom_ι` proof. An isolated lower-cone probe succeeded in 33.84s with max RSS 7,198,884 KB.
- Temporary `sorry` probes were restored; source scans are clean. Forbidden files and roadmap strategy were untouched. No full build was run.

## Issues

- The corrected GluePackage check timed out at 10:00.12 (exit 124); the Lean child used roughly 7.6 GB RSS and 104–107% CPU under the existing 400k/12.8M structure budgets.
- Replacing only `exists_pic0FiniteStageGluePackage` with `sorry` still timed out at 6:00.09, so the smallest remaining blocker is the dependent package/`glueData` elaboration cone before the constructor proof.
- No `Pic0FiniteStageGluePackage.olean` or `Pic0FiniteStageGluingDiagramIso.olean` was produced. DiagramIso checks therefore stop after 1.10s on the missing GluePackage artifact.
- LSP checks before and after edits returned no diagnostics, but remained partial while elaboration was running.

## Why I stopped

The objective is partly advanced, not complete: the source/cache RingHom mismatch is repaired and the overlap helper is independently isolated, but the upstream dependent elaboration remains resource-bound. The Horizon task remains `running`, rather than being marked complete or blocked.

## Next

Bind explicitly typed `hOpen'` and `hthetaN'` helpers before the package record literal; if that remains above budget, isolate the triple-transition existential producer in a named declaration, then remove stale trace-without-olean files before retrying the narrow artifact check.

Commits: `a1280ee054`, `9b1f195905`, and `9e6918ae83`. Generated/shared Horizon event, search, advisory-read, and run-0156 paths were intentionally left to their other writers.
