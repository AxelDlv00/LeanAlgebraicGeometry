Target: blueprint/src/chapters/Picard_FlatteningStratification.tex
Action: three edits — (1) add G1 base-case sub-lemma block, (2) add the GeneratingSections transport-engine blocks, (3) remove a spurious hypothesis. Read the chapter + the Lean file `AlgebraicJacobian/Picard/FlatteningStratification.lean` for exact signatures.

## Edit 1 — new G1 base-case sub-lemma (decomposes `lem:gf_qcoh_fintype_finite_sections`, ~line 1621)
Add a new lemma block `\label{lem:gf_qcoh_finite_sections_of_genSections}` with
`\lean{AlgebraicGeometry.gf_qcoh_finite_sections_of_genSections}` placed just BEFORE `lem:gf_qcoh_fintype_finite_sections`, and add this label to that lemma's `\uses{}`.
Statement (project notation): for an affine open `D ⊆ X`, a quasi-coherent `F` of finite type, and a finite generating family `σ` of `(pullback D.ι).obj F`, the section module `Γ(F,D)` is finite over `Γ(X,D)`.
Informal proof — the gap1-hard `X.Modules ↔ Spec` transport, three sub-steps (each is itself a sub-claim worth its own \uses to existing gap1/gap2 lemmas; cite `lem:isIso_fromTildeΓ`-family and `isLocalizedModule_basicOpen` from chapters/Picard_QuotScheme.tex):
(a) transport `(pullback D.ι).obj F` to `(Spec Γ(X,D)).Modules` via `hD.isoSpec.inv` and show `IsIso fromTildeΓ` (qcoh on Spec);
(b) transport the free epi `σ.π` to a `(tilde N) ⟶ F'` epi with `N = R^{σ.I}` finite — needs `(pullback isoSpec.inv).obj (free σ.I) ≅ free σ.I` (iso-pullback finality) and `free σ.I ≅ (tilde R).obj (R^{σ.I})` (tilde preserves coproducts + `tilde R ≅ unit`);
(c) identify `moduleSpecΓFunctor.obj F' ≅ Γ(F,D)` as `Γ(X,D)`-modules.
Conclude via the existing Spec base case `gf_qcoh_finite_sections_of_free_epi` (`lem:gf_qcoh_finite_sections_of_free_epi`, ~line 1583). This is Archon-original plumbing (Nitsure §4 reduction context) — no external verbatim source quote required; mark it as project-bespoke.

## Edit 2 — GeneratingSections transport-engine blocks (coverage debt; 3 unmatched Lean decls)
Add a short subsection "Transport engine for generating sections" with three blocks (one-line informal statements; project-bespoke, no source quote):
- `\lean{AlgebraicGeometry.SheafOfModules.GeneratingSections.map}` — a finite generating family of `M` transports along a colimit-preserving, unit-iso functor `F` (generator map `(mapFree …).inv ≫ F.map σ.π`, epi since `F` preserves epis); note the colimit-preservation witness `hF` is an EXPLICIT argument (instance search fails through the `Scheme.Modules` abbreviation). \uses the Mathlib `mapFree`/`freeHomEquiv` anchors if you add anchors; otherwise leave \uses minimal.
- `\lean{AlgebraicGeometry.SheafOfModules.GeneratingSections.map_I}` — `(map …).I = σ.I` (rfl).
- `\lean{AlgebraicGeometry.SheafOfModules.GeneratingSections.map_isFiniteType}` — finiteness survives `map` (index type unchanged).
Wire `lem:gf_localGenerators_restrict` (~line 1351) to `\uses` these three.

## Edit 3 — remove spurious hypothesis
In `lem:gf_finiteType_affine_finite_cover_generated`, the prose currently says "F a quasi-coherent sheaf … of finite type". The Lean dropped `[F.IsQuasicoherent]` (genuinely unused; confirmed by lean-vs-blueprint-checker + auditor). Remove "quasi-coherent" from the hypotheses — the lemma needs only finite type. Also in `lem:gf_localGenerators_restrict`, replace "open immersion D(g) ↪ Y" with "any open V ≤ Y" to match Lean generality.

Constraints: math prose only, no Lean tactics. Do NOT add `\leanok` (sync_leanok owns it). You MAY add `\mathlibok` ONLY on genuine Mathlib dependency anchors if you create any. Keep blocks concise.
