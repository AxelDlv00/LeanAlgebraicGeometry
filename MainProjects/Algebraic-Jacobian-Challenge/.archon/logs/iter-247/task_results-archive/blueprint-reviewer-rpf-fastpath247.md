# Blueprint Review Report

## Slug
rpf-fastpath247

## Iteration
247

## Scope
Fast-path re-review scoped to `blueprint/src/chapters/Picard_RelPicFunctor.tex` only (per directive).

## Per-chapter

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no findings.

**complete**: true
**correct**: true

**Fix verification (directive items):**

1. **Stray `\leanok` inside `\uses{}`** — REMOVED. The `lem:rel_pic_sharp_groupoid` statement block (line 77–79) now reads cleanly:
   ```
   \uses{def:line_bundle_on_product, def:pullback_along_projection,
     thm:relative_pic_quotient_well_defined}
   ```
   No `\leanok` token present. All other `\uses{}` blocks in the chapter are also clean.

2. **`% NOTE` rewrite (import cycle)** — ACCURATE AND NOT MISLEADING. The iter-247 NOTE at lines 119–136 correctly states:
   - The dependency now flows LineBundlePullback → TensorObjSubstrate → RelPicFunctor.
   - The specific upstream decls now directly citable: `tensorObj`, `tensorObj_assoc_iso`, `tensorObj_comm/unit/left/right isos`, `tensorObj_isLocallyTrivial`, `exists_tensorObj_inverse`, `pullbackUnitIso`, and (conditionally) `pullback_tensor_iso_loctriv`.
   - The four local pure-Mathlib bridge copies from iter-246 (`pTensor_isLocallyTrivial`, `pAssoc`, `isLocallyTrivial_unit`, `exists_pTensor_inverse`) should now be rewired, collapsing to a real `AddCommGroup` modulo the genuine project-deferred sorry `exists_tensorObj_inverse`.
   - The carrier caveat is preserved verbatim: the carrier setoid is the iso-class relation `Nonempty(L ≅ L')`, so the realized group is the tensor-product Picard group on loc-triv iso-classes (additive mirror of `picCommGroup`).
   - Memory references are correctly cited (rpf-import-cycle-blocks-tensorobj as now resolved, rpf-addcommgroup-real-skeleton).
   - The NOTE provides clear, actionable guidance to the prover: which upstream decls to cite, which local bridges to collapse, what remains deferred, and why.

3. **Source quotes** — INTACT AND VERBATIM. The Kleiman §2 df:aPf/df:Pfs quotes appear in four declaration blocks (`lem:rel_pic_sharp_groupoid`, `def:rel_pic_sharp`, `lem:rel_pic_sharp_functorial`, `thm:rel_pic_sharp_presheaf`, `def:rel_pic_etale_sheafification`, `thm:rel_pic_etale_sheaf_group_structure`) and are consistent throughout. Each block carries:
   - `% SOURCE: [Kleiman], ... (read from references/kleiman-picard-src/kleiman-picard.tex, L...)` ✓
   - `% SOURCE QUOTE:` with verbatim text from the original ✓
   - Visible `\textit{Source: [Kleiman], ...}` as first prose line ✓
   The `% SOURCE QUOTE PROOF:` annotations correctly explain why Kleiman §2 does not supply separate proof bodies (the abelian-group structure is definitional in df:aPf/df:Pfs), so no fabrication risk.

4. **Mathematical soundness** — confirmed. The `lem:rel_pic_sharp_groupoid` statement is precise: Pic(C×_k T) abelian under tensor, π_T* is a homomorphism, H_T := im(π_T*) is a subgroup, quotient inherits canonical abelian-group structure with the stated surjection-and-kernel property. The 4-step proof sketch (Step 1: abelian group on carrier via tensor; Step 2: π_T* is additive; Step 3: setoid reconciliation; Step 4: transport) is detailed enough for a prover. The parallel-build callout (lem:pullback_tensor_iso_loctriv for Step 2, lem:tensorobj_inverse_invertible for Step 1) is honest about the concurrent deferred inputs.

5. **`\leanok` placement audit** — all present `\leanok` markers sit on statement-block `\begin{...}` lines or inside `\begin{proof}` environments, never inside `\uses{}` lists. `thm:rel_pic_etale_sheaf_unit_canonical` correctly carries no `\leanok` and no `\lean{...}` pin.

6. **`\uses{}` cross-refs** — no broken references within the chapter itself. The tensor-substrate labels (`lem:tensorobj_*`) and pullback labels (`def:line_bundle_on_product`, `def:pullback_along_projection`, etc.) all pointed to upstream chapters that cleared the prior full audit (iter-246). The internal-consistency section at the chapter's end accurately maps each block's `\uses` dependencies. No reference points to a chapter that does not exist on disk.

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

Both directive-flagged issues (stray `\leanok` in `\uses{}`, stale import-cycle NOTE) are correctly resolved. No new issues introduced. The chapter is complete and correct; the RPF prover may be dispatched this iter.
