# Blueprint-clean directive — iter-034 P1a decomposition

## Scope
The consolidated chapter `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` was just
edited by an effort-breaker that split `lem:isQuasicoherent_restrict_basicOpen` (P1a) into a
3-lemma `\uses`-linked chain. Clean and verify ONLY the affected region — the P1a blocks:
- `lem:modules_restrict_basicOpen` (new L1 — `AlgebraicGeometry.modulesRestrictBasicOpen`)
- `lem:tilde_restrict_basicOpen` (new L2 — `AlgebraicGeometry.tilde_restrict_basicOpen`)
- `lem:presentation_restrict_basicOpen` (new L3 — `AlgebraicGeometry.presentation_restrict_basicOpen`)
- `lem:isQuasicoherent_restrict_basicOpen` (top, proof rewritten to a short composition)

## Tasks
1. Strip any Lean syntax / tactic leakage / project-history verbosity from these four blocks
   (math-only prose).
2. Verify every `% SOURCE:` / `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` on the new blocks is
   present and matches `references/stacks-schemes.tex` verbatim (the effort-breaker quoted from
   L1241–1276 and L1287–1303 — Tag 01I8 `lemma-widetilde-pullback` / `lemma-quasi-coherent-affine`).
   If a quote is missing or paraphrased, insert the verbatim text from the source file.
3. Do NOT touch the out-of-scope blocks feeding this iter's live prover lanes
   (`lem:toSheaf_preservesFiniteColimits`, `lem:to_sheaf_preserves_epi`,
   `lem:affine_surj_of_vanishing`, `def:affine_cover_system`, `lem:tilde_preserves_kernels`).
4. Do NOT add or remove `\leanok` (sync_leanok's job). Leave `\mathlibok` decisions to review —
   the only candidate anchor (`D(f) ≅ Spec R_f`) is unconfirmed and intentionally left unmarked.

Report what you changed (or "no changes needed — blocks already pure").
