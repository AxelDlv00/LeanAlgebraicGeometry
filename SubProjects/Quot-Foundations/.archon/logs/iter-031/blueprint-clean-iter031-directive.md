# blueprint-clean directive — iter-031

Post-write purity gate. Three chapters were edited this iter:
- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — the five `_legs` link blocks were reconciled
  (L1+L2 merged into one `..._link_distributeCollapse` block pinning the existing Lean decl; L3/L4/L5
  sharpened to term-mode wrapper recipes; all old `_link_distribute`/`_link_collapseComp` refs repointed).
- `blueprint/src/chapters/Picard_QuotScheme.tex` — added a 6-block "over-site/open-subspace sheaf
  equivalence" sub-section (bridge C topological layer) + expanded `lem:over_restrict_iso` into a 4-step
  decomposition; added Mathlib anchors.
- `blueprint/src/chapters/Picard_GrassmannianCells.tex` — added one standalone block
  `lem:gr_cocycle_phi_id` (the rotated triple-overlap ring cocycle identity Φ=id) and wired it into
  `def:gr_glued_scheme`'s `\uses{}`.

Tasks:
- Strip any Lean tactic syntax, project/iteration history ("iter-NNN", "this iter", churn narrative), or
  prover-implementation leakage that crept into prose. Mathematical content + `% SOURCE`/`% NOTE` comments
  + `\lean{}`/`\uses{}` only.
- Verify every `\uses{}`/`\ref{}`/`\cref{}` resolves to a real `\label{}` in some chapter (no broken refs).
  In particular confirm no `_link_distribute`/`_link_collapseComp` (old names) survive in FlatBaseChange.
- Verify `% SOURCE` blocks have their verbatim `% SOURCE QUOTE` and that any newly-cited source was
  actually read; if a block needs a source quote it lacks, spawn a reference-retriever (you have
  `references/**`) — do NOT fabricate quotes. The 6 QUOT infra blocks and the GR Φ=id block are
  project-bespoke (no external source line required); leave them source-free, standing on their proof
  sketch.
- Do NOT add or remove `\leanok`. Do NOT alter the mathematical statements; this is a cleanliness pass.
