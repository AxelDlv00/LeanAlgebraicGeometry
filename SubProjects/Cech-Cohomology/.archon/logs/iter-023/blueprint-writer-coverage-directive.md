# Blueprint-writer directive — iter-023 — chapter `Cohomology_CechHigherDirectImage.tex`

You own ONE consolidated chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(it carries `% archon:covers` for several Lean files including `FreePresheafComplex.lean` and
`CechAcyclic.lean`). Do NOT touch any other chapter.

This is an alignment + coverage pass after iter-022's prover landed +30 axiom-clean declarations at a
slightly different abstraction level than the chapter anticipated. The lean-vs-blueprint-checker
flagged 6 MAJOR findings (all blueprint-side). Fix exactly the items below. Do NOT add `\leanok`
(the deterministic sync phase owns it). Do NOT speculate beyond this list.

## Strategy slice (context)

The P3b free side proves `cechFreeComplex_quasiIso` (the free-presheaf Čech complex resolves
`O_𝒰`) via a per-open-`V` evaluation argument. iter-022 built the *engine complex* — a
constant-coefficient chain complex `C_• , C_p = ∐_{σ:Fin(p+1)→I₁(V)} O_X(V)` with the
index-insertion differential — together with its `d²=0`, a prepend-`i_fix` contracting homotopy, and
positive-degree exactness. The single remaining bottleneck is the degreewise chain-iso
`cechFreeEvalEngineIso` between the evaluated free complex and this engine complex (the differential
"variance match"). The blueprint must now (a) give the 14 engine-complex declarations a home, (b)
re-point two `\lean{}` hints that pin non-existent evaluated-level names to the engine-level names that
were actually built, and (c) expand the `lem:cech_free_eval_engine_iso` proof sketch with the
naturality step the prover still has to discharge.

## Task A — NEW lemma block `lem:cech_engine_complex` (covers 14 engine decls)

Add a new `\begin{lemma}...\end{lemma}` block (place it immediately BEFORE
`lem:cech_free_eval_engine_iso`, since the iso targets this complex). Label `lem:cech_engine_complex`.

`\uses{lem:free_cech_engine}` (it is the coproduct/chain dual of the constant-coefficient
`FreeCechEngine` core).

`\lean{...}` list — ALL 14 of these (they exist, axiom-clean, in `FreePresheafComplex.lean`):
`AlgebraicGeometry.le_coverInterOpen_iff`, `AlgebraicGeometry.survivingEquiv`,
`AlgebraicGeometry.cechFreeEvalDropZeros`, `AlgebraicGeometry.cechFreeEvalEngine_X`,
`AlgebraicGeometry.coverSectionModule`, `AlgebraicGeometry.cechEngineX`,
`AlgebraicGeometry.cechEngineD`, `AlgebraicGeometry.cechEngineD_ι`,
`AlgebraicGeometry.cechEngineD_comp`, `AlgebraicGeometry.cechEngineComplex`,
`AlgebraicGeometry.cechEnginePrepend`, `AlgebraicGeometry.cechEnginePrepend_ι`,
`AlgebraicGeometry.cechEnginePrepend_spec`, `AlgebraicGeometry.cechEngineD_exact`.

Statement to formalize (project notation): Fix an open `V` with `I₁(V) = { i : V ≤ U_i } ≠ ∅`. Let
`C_• = cechEngineComplex 𝒰 V` be the chain complex of `O_X(V)`-modules with
`C_p = ∐_{σ : Fin(p+1) → I₁(V)} O_X(V)` and differential `cechEngineD` given on the injection of
index `σ` by the alternating sum `∑_i (-1)^i · ι_{σ ∘ Fin.succAbove i}` (the index-DROP / chain
transpose of `FreeCechEngine.combDifferential`, which index-RAISES). Then: `d² = 0`
(`cechEngineD_comp`); `C_•` is the assembled `ChainComplex.of`; the prepend-`i_fix` map
`s ↦ ι_{Fin.cons i_fix σ}` is a contracting homotopy in positive degree (`cechEnginePrepend_spec`:
`s ≫ d + d ≫ s = 𝟙`); hence `C_•` is exact in positive degree (`cechEngineD_exact`,
`Function.Exact (cechEngineD (n+1)) (cechEngineD n)`). The four object-half bricks
(`le_coverInterOpen_iff`, `survivingEquiv`, `cechFreeEvalDropZeros`, `cechFreeEvalEngine_X`) realize
the degreewise iso `(eval V)(K(𝒰)_p) ≅ C_p`: evaluation commutes with the coproduct, the
non-surviving summands (`V ≰ U_σ`) drop to zero, and the surviving index type is reindexed by
`survivingEquiv : (Fin(p+1)→I₁(V)) ≃ {σ // V ≤ coverInterOpen 𝒰 σ}`.

Source: this is the Lean realization of the evaluated complex `K^{ext}_•(W)` and its differential from
Stacks `lemma-homology-complex` (already quoted in `lem:cech_free_eval_engine_iso`). Reuse that source
pointer; you may add a `% SOURCE:`/`% SOURCE QUOTE:` referencing
`references/stacks-cohomology.tex` L1228–1251 (the `K^{ext}_•` description and its differential),
matching the existing engine-iso block. A one-paragraph informal proof sketch suffices: cite the
contracting homotopy = the chain/coproduct dual of `FreeCechEngine.combHomotopy_spec`, proved on
coproduct injections by `Limits.Sigma.hom_ext`.

## Task B — re-point two `\lean{}` hints (wrong abstraction level)

The blocks `lem:cech_free_eval_prepend_homotopy` and `lem:cech_free_eval_prepend_homotopy_spec`
currently `\lean{}`-pin `AlgebraicGeometry.cechFreeEvalPrependHomotopy` and
`...cechFreeEvalPrependHomotopy_spec` — names that DO NOT EXIST and are unreachable until
`cechFreeEvalEngineIso` is built (they live at the evaluated-complex level). What was actually built
is the contracting homotopy at the *engine-complex* level: `cechEnginePrepend` and
`cechEnginePrepend_spec` (now covered by `lem:cech_engine_complex`, Task A).

Fix:
- In `lem:cech_free_eval_prepend_homotopy` and `..._spec`: REPLACE their `\lean{}` pins with the
  engine-level names — OR, cleaner: drop the standalone `\lean{}` pins (since `cechEnginePrepend{,_spec}`
  are now pinned by `lem:cech_engine_complex`) and convert these two blocks into short corollary-style
  remarks stating that the evaluated-complex contracting homotopy follows by transporting
  `cechEnginePrepend{,_spec}` across `cechFreeEvalEngineIso` once that iso is built. Add
  `lem:cech_engine_complex` and `lem:cech_free_eval_engine_iso` to their `\uses{}`.
- Make sure `lem:cech_free_eval_nonempty`'s `\uses{}` still resolves: it currently uses
  `lem:cech_free_eval_prepend_homotopy{,_spec}`. After your edit those labels still exist (as the
  re-leveled corollary remarks), so the `\uses` chain stays intact — but ALSO add
  `lem:cech_engine_complex` to `lem:cech_free_eval_nonempty`'s `\uses{}` since the engine exactness is
  what actually feeds the nonempty quasi-iso (via `cechFreeEvalEngineIso` transport).

Choose whichever of the two options keeps the dependency graph honest and acyclic; document which you
chose in your report. The hard constraint: after your edit, NO blueprint `\lean{}` pin may name a
declaration that does not exist in the Lean source, and every `\uses{}` label must resolve.

## Task C — expand the `lem:cech_free_eval_engine_iso` proof sketch (the under-specified step)

The current proof sketch (the "Differential match" paragraph) mentions `Limits.Sigma.hom_ext` +
`PreservesCoproduct.iso` naturality but does NOT describe the three intermediate layers the prover
must commute the differential past. Add a paragraph covering:

1. The degreewise iso is the 3-fold composite
   `cechFreeEval_X` (= `PreservesCoproduct.iso`, evaluation commutes with `∐`) `≫`
   `cechFreeEvalDropZeros` (kills the `V ≰ U_σ` summands as zero objects) `≫`
   `(Limits.Sigma.whiskerEquiv survivingEquiv (freeYonedaEval_iso_of_le ...)).symm`
   (reindex surviving summands by `survivingEquiv` and identify each with `O_X(V)`).
2. The naturality that makes the differential commute past these layers: `survivingEquiv` is natural
   with respect to the face reindex `σ ↦ σ ∘ Fin.succAbove i` — a surviving `σ` (with `V ≤ U_σ`) maps
   to a surviving `σ ∘ succAbove i` (`V ≤ U_{σ∘succAbove i}`, by `le_coverInterOpen_iff`), so the
   drop-zeros and whisker layers commute with each face.
3. On surviving summands the evaluated `freeYoneda.map (homOfLE …)` collapses to the identity under
   `freeYonedaEval_iso_of_le`, so each face `δ_i` matches the engine reindexing `σ ↦ σ∘succAbove i`
   summand-for-summand, and summing with the `objD` signs `(-1)^i` identifies the evaluated
   alternating-face differential with `cechEngineD` (= the chain transpose of `combDifferential`).
4. State plainly that the genuine difficulty is the chain-vs-cochain VARIANCE: the free chain
   differential lowers Fin-arity (`σ↦σ∘δ_i`, faces) while `combDifferential` raises it; the two are
   reconciled because on the finite biproduct `∐ = ∏` the insertion/deletion adjunction makes the
   index-drop chain differential the transpose of the index-raise cochain differential.

Keep this mathematical (no Lean tactic strings beyond naming the Mathlib lemmas as the existing block
already does — the chapter already cites `Limits.Sigma.hom_ext` etc., so naming
`Limits.Sigma.whiskerEquiv`, `freeYonedaEval_iso_of_le`, `le_coverInterOpen_iff` is consistent with
chapter style). Update `lem:cech_free_eval_engine_iso`'s `\uses{}` to add `lem:cech_engine_complex`.

## Task D — clear the CechAcyclic tilde-bridge coverage debt (12 helper decls)

iter-022's CechAcyclic prover added 12 private helper declarations with no `\lean{}` reference. Bundle
each into the EXISTING block indicated (do NOT create new blocks for these; they are helpers of
already-blueprinted lemmas). All resolve by qualified name `AlgebraicGeometry.<name>` (verified — like
the existing private `CombinatorialCech.*`).

- Into `def:qcoh_sections_localized` `\lean{}` list: `AlgebraicGeometry.tP`, `AlgebraicGeometry.tU`,
  `AlgebraicGeometry.phiL`, `AlgebraicGeometry.phi`, `AlgebraicGeometry.phi_eq_phiL`,
  `AlgebraicGeometry.restr_bridge`.
- Into `lem:section_cech_coface_match` `\lean{}` list: `AlgebraicGeometry.phiL_naturality`,
  `AlgebraicGeometry.phi_naturality`.
- Into `lem:section_cech_product_equiv` `\lean{}` list: `AlgebraicGeometry.sectionProdAddEquiv`.
- Into `lem:section_cech_ab_exact` `\lean{}` list: `AlgebraicGeometry.sectionToModuleAddEquiv`,
  `AlgebraicGeometry.sectionToModuleAddEquiv_apply`, `AlgebraicGeometry.sectionProdEquiv_symm_apply`.

These are pure helper-bundling additions (append the names to the existing `\lean{}` lists). Add a
short clause to each host block's prose naming the helper's role (one phrase each, e.g. "the per-σ
comparison `φ_σ = IsLocalizedModule.iso` (`phiL`/`phi`) and its accessor-bridge `restr_bridge`").

## Out of scope (do NOT touch)

- The `F ≅ ~(ΓF)` (Stacks 01I8) globalisation gap — leave it as the named deferred gap it already is
  in `def:qcoh_sections_localized`.
- `ses_cech_h1`, `cech_vanish_basis`, `affine_serre_vanishing`, `injective_cech_acyclic`,
  `cech_acyclic_affine` — do NOT edit these blocks (they are correct as-is per the iter-022 review).
- Do NOT add `\leanok` anywhere.

## Report

Note which Task-B option you chose, confirm `lem:cech_engine_complex` is wired with the 14 names, and
confirm every `\lean{}` pin in the touched blocks names an existing declaration.
