# Blueprint Writer Report

## Slug
coverage

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Task A — new lemma `lem:cech_engine_complex` (14 engine decls)
- **Added lemma** `\lemma`/`\label{lem:cech_engine_complex}` — the constant-coefficient
  {\v C}ech engine *chain* complex `C_•`, `C_p = ∐_{σ:Fin(p+1)→I₁(V)} O_X(V)` with the
  index-drop differential `cechEngineD` (chain transpose of `combDifferential`), `d²=0`,
  the prepend-`i_fix` contracting homotopy (`cechEnginePrepend{,_ι,_spec}`), positive-degree
  exactness (`cechEngineD_exact`), and the four object-half bricks
  (`le_coverInterOpen_iff`, `survivingEquiv`, `cechFreeEvalDropZeros`, `cechFreeEvalEngine_X`)
  realising the degreewise iso `(eval V)(K(𝒰)_p) ≅ C_p`.
  - `\uses{lem:free_cech_engine}` as directed.
  - `\lean{}` wired with **all 14** names (verified to exist + matched by leandag).
  - `% SOURCE:`/`% SOURCE QUOTE:` from `references/stacks-cohomology.tex` L1236–1251 (the
    `K^{ext}_p` description + differential), copied verbatim; `\textit{Source: ...}` line present.
  - One-paragraph informal proof: contracting homotopy = coproduct dual of
    `combHomotopy_spec`, proved on injections via `Limits.Sigma.hom_ext`.
  - Placed immediately BEFORE `lem:cech_free_eval_engine_iso`.

### Task B — re-pointed the two prepend-homotopy `\lean{}` hints
- **Chosen option: Option 2 (drop the standalone `\lean{}` pins; reframe as transport
  corollaries).** Rationale: `cechEnginePrepend` / `cechEnginePrepend_spec` are now pinned by
  `lem:cech_engine_complex` (Task A). Re-pointing the two blocks to the same names (Option 1)
  would double-pin a single Lean declaration in two blocks, which is dishonest in the DAG; the
  honest move is to leave the engine names pinned once (in `lem:cech_engine_complex`) and make
  the evaluated-level blocks transport remarks with no pin.
- **Revised** `lem:cech_free_eval_prepend_homotopy` — removed dead `\lean{AlgebraicGeometry.cechFreeEvalPrependHomotopy}`
  pin + the iter-022 NOTE; reframed title/body as the transport of `cechEnginePrepend` across
  `cechFreeEvalEngineIso`; `\uses{}` now adds `lem:cech_engine_complex` (already used
  `lem:cech_free_eval_engine_iso`).
- **Revised** `lem:cech_free_eval_prepend_homotopy_spec` — removed dead
  `\lean{AlgebraicGeometry.cechFreeEvalPrependHomotopy_spec}` pin + NOTE; reframed as transport of
  `cechEnginePrepend_spec`; `\uses{}` now adds `lem:cech_engine_complex, lem:cech_free_eval_engine_iso`.
- **Fixed dependencies** `lem:cech_free_eval_nonempty` — added `lem:cech_engine_complex` to `\uses{}`
  (engine exactness feeds the nonempty quasi-iso via the iso transport). The labels
  `lem:cech_free_eval_prepend_homotopy{,_spec}` still exist, so its existing `\uses` chain stays intact.

### Task C — expanded `lem:cech_free_eval_engine_iso` proof sketch
- **Revised** proof of `lem:cech_free_eval_engine_iso` — added three paragraphs:
  (1) the 3-fold composite `cechFreeEval_X` (`PreservesCoproduct.iso`) ≫ `cechFreeEvalDropZeros`
  ≫ `(Limits.Sigma.whiskerEquiv survivingEquiv (freeYonedaEval_iso_of_le …))⁻¹`;
  (2) naturality of `survivingEquiv` w.r.t. the face reindex `σ ↦ σ∘succAbove i` (surviving →
  surviving by `le_coverInterOpen_iff`), so drop-zeros + whisker commute with each face, and
  `freeYoneda.map (homOfLE …)` collapses to identity under `freeYonedaEval_iso_of_le`;
  (3) the plainly-stated chain-vs-cochain VARIANCE difficulty (faces lower Fin-arity,
  `combDifferential` raises it; reconciled on `∐=∏` by the insertion/deletion transpose).
- **Statement `\uses{}`** updated to add `lem:cech_engine_complex` (already had
  `lem:cech_free_eval_sectionwise, lem:free_cech_engine`).

### Task D — CechAcyclic tilde-bridge helper bundling (12 decls)
- **Bundled into** `def:qcoh_sections_localized` `\lean{}`: `tP, tU, phiL, phi, phi_eq_phiL,
  restr_bridge`; added a prose clause naming their roles (localised-module endpoints; per-σ
  comparison `φ_σ = IsLocalizedModule.iso` as `phiL`/`phi` with `phi_eq_phiL`; accessor-bridge
  `restr_bridge`).
- **Bundled into** `lem:section_cech_coface_match` `\lean{}`: `phiL_naturality, phi_naturality`;
  prose clause: face-naturality at bare-localisation level (`phiL_naturality`) and sheaf level
  (`phi_naturality`).
- **Bundled into** `lem:section_cech_product_equiv` `\lean{}`: `sectionProdAddEquiv`; prose clause:
  the additive-isomorphism packaging (ladder vertical map).
- **Bundled into** `lem:section_cech_ab_exact` `\lean{}`: `sectionToModuleAddEquiv,
  sectionToModuleAddEquiv_apply, sectionProdEquiv_symm_apply`; prose clause: composite vertical
  map `e_p`, its forward coordinate formula, and its inverse-direction coordinate.

## Cross-references introduced
- `\uses{lem:cech_engine_complex}` added in: `lem:cech_free_eval_engine_iso` (statement + already-present
  proof uses), `lem:cech_free_eval_prepend_homotopy`, `lem:cech_free_eval_prepend_homotopy_spec`,
  `lem:cech_free_eval_nonempty`. Target exists (newly added in this chapter).
- `\uses{lem:cech_free_eval_engine_iso}` added in `lem:cech_free_eval_prepend_homotopy_spec` —
  exists in this chapter.

## Verification
- `\begin`/`\end` balanced: lemma 37/37, proof 32/32, definition 15/15.
- `leandag build --json`: `conflicts: []`, `unknown_uses: None`, all 26 added Lean names matched
  (none in `unmatched_lean`), 0 isolated nodes in `Cohomology_CechHigherDirectImage`.
- No `\lean{}` pin in any touched block names a non-existent declaration: the two dead
  `cechFreeEvalPrependHomotopy{,_spec}` pins were removed; all 26 names added were grep-verified in
  `FreePresheafComplex.lean` (14) and `CechAcyclic.lean` (12) and confirmed matched by leandag.
- No `\leanok` added anywhere.

## References consulted
- `references/stacks-cohomology.tex` (L1224–1276) — verbatim `% SOURCE QUOTE:` for the new
  `lem:cech_engine_complex` block (the `K^{ext}_p(W)` description and its differential, L1236–1251).

## Macros needed (if any)
- None. All commands used (`\operatorname`, `\coprod`, `\simeq`, etc.) are standard / already in use
  in this chapter.

## Notes for Plan Agent
- The sole remaining bottleneck named in the directive — `cechFreeEvalEngineIso` (the differential
  variance-match) — is now fully blueprinted at `lem:cech_free_eval_engine_iso` with the 3-layer
  naturality decomposition spelled out; the engine target it lands in (`lem:cech_engine_complex`) is
  in place and axiom-clean. The prover has a complete sketch for the comm-square.
- `unmatched_lean` total is 22 (pre-existing, outside this directive's scope — not introduced here).

## Strategy-modifying findings
None.
