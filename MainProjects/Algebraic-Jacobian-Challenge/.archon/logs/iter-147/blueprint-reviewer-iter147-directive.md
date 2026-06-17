# Directive — blueprint-reviewer (iter-147)

## Context

Iter-147 plan phase. Mandatory blueprint-review pass.

## Strategy snapshot

- M2.body-pile is under the **iter-144 chart-algebra pivot**, committed
  iter-144. Five sub-pieces live in
  `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` with informal content
  hosted as a subsection of `RigidityKbar.tex` § "Chart-algebra piece (ii)
  first-class decomposition" (L1773–L1956 pre-iter-146; expanded by
  `blueprint-writer-rigiditykbar-iter146` to ~L1828–L2072).
- M3 (positive-genus) is **COMMITTED to Route A — Picard scheme via FGA**
  per iter-144 user-hint. Route B (Symⁿ + Stein) is dropped as historical
  alternative. Audit AUDIT_STABLE per iter-145 refresh: midpoint
  ~6070 LOC.
- M2.a body closure gated on chart-algebra piece (ii); iter-149+.
- M2.b body closure iter-151+; M2 closure iter-155+.

## Iter-146 prover-lane outcome (for context)

`AlgebraicJacobian/Cotangent/ChartAlgebra.lean`: 5 → 3 sorries.
- (α) `algebra_isPushout_of_affine_product` — CLOSED.
- `Scheme.Over.ext_of_diff_zero` — CLOSED by signature reduction (drops
  the `df = dg` hypothesis; the iter-146 prover reports this as a
  deliberate sorry-free closure delegated to `ext_of_eqOnOpen`).
- `constants_integral_over_base_field` — PARTIAL (substeps 1–2 closed;
  substep 3 deferred as structured `sorry` at L177 with iter-147+
  closure path documented inline).
- (β-core) `df_zero_factors_through_constant_on_chart` at L97 — still
  `: True := sorry` (OFF-LIMITS iter-146 per planner directive).
- (KDM) `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` at L107
  — still `: True := sorry` (OFF-LIMITS iter-146 per planner directive).

## Iter-146 blueprint-writer pass

`blueprint-writer-rigiditykbar-iter146` returned COMPLETE with 5 edits:
- KDM step (p1) 4-substep recipe expansion per Stacks Tag 07F4.
- NEW first-class lemma block
  `lem:KaehlerDifferential_constants_in_chart_of_proper_curve`
  (the hidden-hypothesis fix for KDM step (p3)).
- β-core Step 3 rewritten with 2-chart Čech + Step 3.aux paragraphs
  (cites Stacks Tag 0F8L for 2-chart-cover existence on a smooth
  proper curve).
- 8 broken `\lean{...}` hints stripped (the 5 EXCISED-iter-145 +
  3 never-existed-in-tree names from `Cotangent/GrpObj.lean`).
- (α) cleanups: stray `\uses{def:relative_kaehler_presheaf}` stripped,
  `Mathlib.RingTheory.IsTensorProduct` filename fix.

`blueprint-writer-pointer-iter146` returned COMPLETE with the
`AlgebraicJacobian_Cotangent_GrpObj.tex` 136 → 87 LOC rewrite:
disposition paragraph + 5 stale `\item` bullets DELETED outright;
3 surviving orphan-helper bullets gained orphan-status sentences.

## Iter-147 plan-agent edits to the blueprint (this iter)

Iter-147 plan-agent fixed **5 empty `\uses{}` annotations** in
`Cohomology_MayerVietoris.tex` flagged by the deterministic
blueprint-doctor (L136, L141, L186, L191, L634; root cause of the
iter-146 `leanblueprint web` build failure). All five removed
this iter. (Pre-injected blueprint-doctor findings should now show zero
malformed annotations after the next doctor pass.)

## What I'm asking

1. Whole-blueprint audit per your descriptor (all 11 chapters).
2. Specifically RE-CONFIRM that the two iter-146 must-fix chapters
   (`RigidityKbar.tex` + `AlgebraicJacobian_Cotangent_GrpObj.tex`) are
   now **`complete: true / correct: true`** post the iter-146 Wave 2
   writer rounds + iter-147 plan-agent's MV empty-uses fix. This is
   the iter-147 watch criterion #1 from the iter-146 sidecar.
3. Per-chapter checklist as usual (your standard JSON-like output).
4. Multi-route coverage check on Route C (chart-algebra) + Route A
   (Picard FGA / M3 positive-genus arm).
5. Flag any new findings against either iter-146 writer round.

## Focus areas

1. (a) `RigidityKbar.tex` § "Chart-algebra piece (ii)" — does the new
   KDM (p1) 4-substep recipe + the new
   `lem:KaehlerDifferential_constants_in_chart_of_proper_curve` helper
   + the β-core Step 3 2-chart rewrite resolve the iter-146 must-fix
   items (p1) under-spec + (p3) hidden hypothesis + Step 3 "Genus.lean
   H¹=0 phantom precedent"? If anything is still missing detail
   sufficient for the iter-147+ β-core / KDM prover lane to land bodies,
   flag it precisely.
2. (b) `AlgebraicJacobian_Cotangent_GrpObj.tex` — is the disposition
   paragraph + remaining 3 orphan-helper bullets now accurate /
   non-misleading? Does anything still drift from current Lean state
   (zero sorry-bodied declarations in `Cotangent/GrpObj.lean`; 5
   orphan helpers as named in the pointer chapter)?
3. (c) `Cohomology_MayerVietoris.tex` — sanity check after the iter-147
   plan-agent's empty-`\uses{}` removal. Both `def:Scheme_ModuleCat_free_isLeftAdjoint`,
   `def:Scheme_ModuleCat_free_preservesMonomorphisms`, and
   `def:Abelian_Ext_chgUnivLinearEquiv` had a `\uses{}` line removed
   (these are foundational definitions with no upstream blueprint
   dependencies; removing the empty annotation is the correct fix per
   plastex requirements).

## Files

Blueprint chapters at `blueprint/src/chapters/*.tex` (11 chapters
present per the iter-146 blueprint-doctor JSON). `Cohomology_MayerVietoris.tex`
edited iter-147 plan phase (5 empty `\uses{}` removed); `RigidityKbar.tex`
edited iter-146 Wave 2; `AlgebraicJacobian_Cotangent_GrpObj.tex` edited
iter-146 Wave 2.

Read the WHOLE blueprint, not just the focus areas — your cross-chapter
view is the value.

## Output

Standard report format per your descriptor. Plan agent will absorb
must-fix items into the iter-147 close per HARD GATE rule.
