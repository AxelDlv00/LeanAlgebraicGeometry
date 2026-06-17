# Blueprint Review: fastpath-csi-iter075
**Iter:** 075

## Focus verdict — `lem:pushPull_interLegHom_sections` gate

**GATE SATISFIED.** `CechSectionIdentificationLeg.lean` may enter this iter's prover objectives.

### Confirmation of directive Q1–Q3

**Q1. `lem:pushPull_interLegHom_sections` adequate for prover?**
- Statement (L8845–8869): complete. The equation is written out in full with all terms named.
- Proof sketch (L8871–8907): 4 steps, each grounded:
  - (a) cites `lem:pushPull_leg_coherence` to factor `pushPullMap F (interLegHom)` through the leg iso + restriction unit → actionable
  - (b) restriction unit → pullback-adjunction unit via `restrictFunctorIsoPullback` → correctly identifies the mate-calculus step
  - (c) composition law along `c ≫ q` via `pullbackComp` comparison → adequate
  - (d) thin-category collapse: "lattice of opens is a thin category → reindexing morphisms uniquely determined → collapses to single F-restriction" → correctly identifies the subsingletonness argument
- The private helper `map_op_eqToHom_swap` (Lean L1017) handles the thin-category fusion; the blueprint description is correct, prover has the right signpost.
- **Adequate for prover. No under-specification.**

**Q2. Four new supporting blocks complete + correct?**

| Block | L# | Statement | Proof | Lean target | Verdict |
|---|---|---|---|---|---|
| `lem:pushPull_leg_coherence` | 8806 | Complete: full factorization formula | Complete: mate-calc uniqueness | `private lemma pushPull_leg_coherence` (proven, no sorry) | ✓ Complete + Correct |
| `lem:backboneIncl_proj` | 8909 | Complete: backboneIncl ≫ backboneProj = interProj | Complete: wide-pullback ext + mono rigidity | Public, proven | ✓ Complete + Correct |
| `lem:backboneIncl_nerveδ` | 8943 | Complete: intertwines nerve δ with interLegHom | Complete: backbone_hom_ext + nerveδ_backboneProj + interLegHom_interProj | Public, proven | ✓ Complete + Correct |
| `lem:coreIso_objIso_π` | 8974 | Complete: coordinate formula for objIso ∘ π_τ | Complete: unfold via pushPull_sigma_iso + pls | Public, proven | ✓ Complete + Correct |

**Q3. No remaining must-fix for Leg file / this chapter?**
- `abHom_finsetSum_apply` private pin: **confirmed absent** from `lem:coreIso_comm_sum` `\uses{}` (grep clean).
- `lem:coreIso_comm_leg` `\uses{}` now includes all 4 new lemmas (L9039–9040): ✓
- `leandag build --json`: `unknown_uses: []` — zero broken `\uses{}` edges
- `blueprint-doctor --json`: `malformed_refs: []`, `broken_refs: []`, `axiom_decls: []`, `covers_problems: []`
- Isolated nodes: 34 total, **0 blueprint nodes** (all `lean_aux`) — no wire-up needed
- **No remaining must-fix for this chapter.**

---

## Top-level summaries

- **Deps/Isolated**: 0 blueprint isolated nodes. `lean_aux` isolated (34) = uncovered Lean helpers, expected, no action.

## Per-chapter

### `Cohomology_CechHigherDirectImage.tex`
- **Complete**: true
- **Correct**: true
- **Notes**: Minor cosmetic finding: `lem:pushPull_leg_coherence` has `\lean{AlgebraicGeometry.pushPull_leg_coherence}` but the Lean declaration is `private lemma pushPull_leg_coherence` (L974 of `CechSectionIdentificationLeg.lean`); the public mangled name won't resolve for `sync_leanok`. Not a prover blocker (lemma already proven, prover calls it from same file). Recommend: either remove the `\lean{}` hint or add a `% NOTE: private — sync_leanok will not mark` comment. This is a **soon** finding, not must-fix.

### `Cohomology_AcyclicResolution.tex`
- **Complete**: true
- **Correct**: true
- All major declarations carry `\leanok`. Chapter is proven (0 sorries per header comment).

### `Cohomology_HigherDirectImage.tex`
- **Complete**: true (thin pointer chapter, 57 lines, as designed)
- **Correct**: true

---

## Unstarted-phase proposals

P5b comparison assembly (BLOCKED): no new blueprint chapter needed — the existing chapter already covers this phase's required declarations. P5b is gated on P5a resolution, not on missing blueprint.

**No unstarted-phase proposals.**

---

## Severity summary

- **must-fix**: none
- **soon**: `lem:pushPull_leg_coherence` `\lean{}` hint names a private lemma; `sync_leanok` won't resolve it. Fix: remove `\lean{}` or add `% NOTE: private`.

---

## Route check (single route)

Route A (acyclic-resolution): fully blueprinted through P5a residual leaves and P5b assembly. Route SS: REJECTED (documented). No missing-coverage route.
