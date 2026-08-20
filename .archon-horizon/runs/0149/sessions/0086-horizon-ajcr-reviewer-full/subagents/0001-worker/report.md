The finite-stage `gluingOverlapIso_pre_snd` wrapper remains blocked.

- The explicit `pullback.hom_ext (f := ...)` form fails immediately because Lean cannot synthesize the dependent `CommRing`/`Algebra` instances for the chart base-change ring.
- Removing explicit `f/g` arguments avoids that immediate error, but both LSP and a bounded `lake env lean` run still elaborated indefinitely; the 240-second kernel run exited with timeout and no diagnostics.
- No downstream files were changed. The inference-only candidate is recorded in commit `95d4dc6` (fresh index); because the parent worktree has staged restructuring, treat it as a reference rather than cherry-picking blindly.
