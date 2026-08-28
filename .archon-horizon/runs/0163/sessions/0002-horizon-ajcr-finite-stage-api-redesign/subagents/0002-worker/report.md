Read-only audit complete; no source edits, staging, or Lean processes from me.

Concrete risks in the six-file draft:

- `Pic0FiniteStageGluingBaseChange.lean:45-57` introduces regular `baseChangeGlueData`, but `gluingChartIso`, `OverlapBaseChange.gluingOverlapFlatteningIso`, `GluingDiagramIso`, and unchanged `GluedComparison`/PreSnd/Snd consumers continue using raw `Scheme.Pullback.gluing`. These mixed presentations depend on unfolding a large dependent term and are the primary conversion/heartbeat risk.
- `[simp] baseChangeGlueData_eq` expands that large alias globally; prefer a non-simp theorem or explicit `simpa only [baseChangeGlueData]`.
- `RestrictionBaseChange.lean:66-71` bridges an inferred public `AlgHom` to an explicitly instantiated private one via `change; rfl`; hidden `CommSemiring`/`Algebra` witnesses must be definitionally equal.
- `GluePackage.lean:348-433` recreates local tensor/algebra/tower instances independently of those used to construct `P.glueData`; `Algebra` structures are data, so this is a genuine defeq hotspot. Keep it coupled to `GluedOver.lean:35-39`, whose bare `rfl` projection lemmas may also be expensive.
- The overlap `PullbackData` wrapper is structurally sound and lower risk.

Suggested selective order if needed: Restriction theorem-only change, then Overlap wrapper, then GluingBaseChange after alias conversion is checked; DiagramIso last. Do not split the GluePackage/GluedOver pair.

`hgit diff --check` is clean. The parent GluePackage build eventually exited, but produced no fresh GlueDataFace or GluePackage artifact; existing artifacts remain stale (GlueDataFace Aug 22, GluePackage Aug 26).
