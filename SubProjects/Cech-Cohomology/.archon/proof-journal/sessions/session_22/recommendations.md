# Recommendations for iter-023 (plan agent)

## HIGH — Route 2 (`FreePresheafComplex.lean`) is at its decision point
`cechFreeEvalEngineIso` (the named target `lem:cech_free_eval_engine_iso`) has now been **absent
for 4 consecutive iters** (iter-020 engine-empty, iter-021 noop-dropped, iter-022 engine built
but comm-square not attempted). This iter was NOT churn — the prover built the entire engine
complex + contraction + exactness (14 axiom-clean decls) and the residual is a **single
comm-square lemma** with all inputs in-file. So the next round is genuinely set up to close it.

**BEFORE dispatching the prover**, do BOTH:
1. **Expand the blueprint** (`lem:cech_free_eval_engine_iso`). lean-vs-blueprint-checker
   (`task_results/lean-vs-blueprint-checker-freepresheafcomplex.md`) reports the proof sketch is
   under-specified: it does not cover the **`survivingEquiv`-naturality** step (that a surviving
   `σ` maps to a surviving `σ∘succAbove i`, so the drop-zeros / `whiskerEquiv` layers commute with
   the reindex). Dispatch a blueprint-writer to add this to the sketch, drawing on the precise
   route documented in `task_results/FreePresheafComplex.md` (push the 3-fold composite through
   `PreservesCoproduct.iso` naturality `ι_comp_map`/`map_desc` + eval of `freeYoneda.map`).
2. **Dispatch the prover scoped to the comm-square ONLY.** Inputs in-file: `cechFreeEvalEngine_X`,
   `cechEngineComplex`, `cechEngineD_comp`, `cechEnginePrepend_spec`, `cechEngineD_exact`. Use
   `HomologicalComplex.Hom.isoOfComponents (fun p => cechFreeEvalEngine_X 𝒰 V p) comm`; the only
   work is `comm`. Pattern for `.d` unfolding already in-file at `cechFree_d_comp_aug` (~line 305)
   via `alternatingFaceMapComplex_obj_d`.

**Escalation (planner's stated reversal signal)**: if iter-023 still does NOT land the comm-square
(a 3rd substantive failure of the named target), STOP re-dispatching the same lane and escalate to
a **structural refactor** of the combinatorial differential derivation (or a mathlib-analogist
cross-domain consult on `PreservesCoproduct.iso` naturality idioms). Do not assign a 5th plain
helper round.

## HIGH — Blueprint re-leveling for the prepend homotopy (`\lean{}` + prose)
Confirmed by lean-vs-blueprint-checker and the review's `% NOTE`s:
- `lem:cech_free_eval_prepend_homotopy` pins `\lean{AlgebraicGeometry.cechFreeEvalPrependHomotopy}`
  (non-existent). Prover built `AlgebraicGeometry.cechEnginePrepend` (+`cechEnginePrepend_ι`) at
  the **engine-complex** level.
- `lem:cech_free_eval_prepend_homotopy_spec` pins `cechFreeEvalPrependHomotopy_spec` (non-existent);
  built as `cechEnginePrepend_spec` (+ positive-degree exactness `cechEngineD_exact`).

Dispatch a blueprint-writer to **re-point the `\lean{}` lists to the engine-level names AND
re-level the prose** to describe the contraction on `cechEngineComplex` (constant coefficient
`O_X(V)`), noting the evaluated-complex form follows by transport once `cechFreeEvalEngineIso`
lands. (I did NOT re-point the `\lean{}` myself: re-pointing without the prose change would let
sync_leanok stamp a false correspondence. `% NOTE`s are in place pointing the writer at this.)

## HIGH — Coverage debt: 26 unmatched `lean_aux` nodes (restore 1-to-1 Lean↔blueprint)
`archon dag-query unmatched` = 26. Author blueprint blocks / bundle into `\lean{}` lists:

**FreePresheafComplex (new block, suggest `lem:cech_engine_complex`, `\uses{lem:free_cech_engine}`):**
`cechEngineX`, `cechEngineD`, `cechEngineD_ι`, `cechEngineD_comp`, `cechEngineComplex`,
`cechEngineD_exact`, `coverSectionModule`, `cechEnginePrepend`, `cechEnginePrepend_ι`,
`cechEnginePrepend_spec` (the last 3 fold into the re-leveled prepend-homotopy blocks above).
Bundle into `lem:cech_free_eval_sectionwise` (object half): `le_coverInterOpen_iff`,
`survivingEquiv`, `cechFreeEvalDropZeros`, `cechFreeEvalEngine_X`.

**CechAcyclic — bundle the 12 tilde-bridge helpers** (all `private`, resolve by qualified
`AlgebraicGeometry.<name>`):
- Into `def:qcoh_sections_localized` (or a new `def:section_tilde_bridge`): `tP`, `tU`, `phiL`,
  `phi`, `phi_eq_phiL`, `restr_bridge`, `phiL_naturality`, `phi_naturality`.
- Into `lem:section_cech_product_equiv`: `sectionProdAddEquiv`, `sectionToModuleAddEquiv`,
  `sectionToModuleAddEquiv_apply`, `sectionProdEquiv_symm_apply`.

## MEDIUM — lean-auditor major (FreePresheafComplex module header)
`task_results/lean-auditor-iter022.md`: the file header lists `cechFreeComplex_quasiIso` as a
declaration the file owns, but it is not defined; the honest "not built" note is only at the end →
header misleads a reader. Have the next FreePresheafComplex prover (or a refactor) fix the header
docstring to state plainly which named targets are still pending. (Not blocking.)

## MEDIUM — minor code-hygiene (do opportunistically, not gating)
- CechAcyclic stale module docstring (predates the file's growth); `sectionCech_affine_vanishing`
  is a redundant alias for `sectionCech_homology_exact` (harmless, but the blueprint should note
  they are defeq-equal so the two `\lean{}` pins are not mistaken for distinct content).
- `FreeCechEngine`/`CombinatorialCech` are verbatim duplicates forced by `private` visibility
  (known debt). A structural de-privatize/share is still open; low priority while Route 2 churns.

## P3 L1 — what remains after this iter's closure
The tilde-case affine Čech vanishing is **closed**. The only remaining piece to reach arbitrary
quasi-coherent `F` is the reduction `F ≅ ~(ΓF)` (**Stacks 01I8**), explicitly deferred and
correctly scoped in the blueprint. When the planner wants to upgrade `lem:cech_acyclic_affine`
from the tilde case to general qcoh, this is the single new obligation; it is independent of the
P3b free-complex lane.

## DO NOT retry without a change
- Do NOT run `IsLocalizedModule.ext` directly over a concrete `modulesSpecToSheaf` section
  restriction — `whnf` timeout even at 2,000,000 heartbeats. Abstract the map (`set … ; clear_value`)
  first (now captured in PROJECT_STATUS Knowledge Base).
- Do NOT `rw [LinearMap.comp_apply / coe_comp / comp_assoc]` against a `↑(LinearEquiv).symm ∘ₗ _`
  composition — semilinear `RingHomCompTriple` mismatch makes them silently not match. Use
  `change`/`DFunLike.congr_fun`.
- Do NOT rebuild the section Čech complex on `ModuleCat` (analogist twice-confirmed: the `Ab` choice
  is the aligned one; rebuilding is pure churn).
- Do NOT pin `cechFreeEvalEngineIso` with a `sorry` (all-or-nothing `def`); attack `comm` directly.
