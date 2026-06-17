# Blueprint Review Report

## Slug
br252

## Iteration
252

## Top-level summaries

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_map_natural` (D1′): The proof sketch says the naturality square commutes "by pasting of naturality squares" and names the individual ingredients (`δ_natural`, `sheafificationCompPullback`, `sheafifyTensorUnitIso`). It does **not** describe the carrier-normalisation step that the prover discovered is essential for the 4th square: when `sheafifyTensorUnitIso` appears, the composition is spelled with the `⋙ forget₂` carrier, and Mathlib's `whisker_exchange`/`comp_whiskerRight`/`whiskerLeft_comp` lemmas do not fire until the map is restated via a `sheafifyTensorUnitIso_hom_eq`-style rewrite onto the canonical `MonoidalCategory` carrier. A `% NOTE` comment (lines 3337–3343) documents the gap and requests a writer pass; the technique is not in the proof prose body. A prover reading only the prose will not find it. Severity: **soon** (D3′/D4′ can proceed without this; D1′ closure is blocked until it is added).

### Citation discipline

No citation-discipline findings. All `% SOURCE:` blocks audited name local `references/` files that exist on disk; `% SOURCE QUOTE:` passages are verbatim; visible `\textit{Source: ...}` lines match the `% SOURCE:` pointers.

## Per-chapter

### HARD-GATE chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:pullback_tensor_map_natural` (D1′) — statement `\leanok`; proof has no `\leanok` (live target). Proof sketch is correct but omits the carrier-normalisation technique for the `sheafifyTensorUnitIso` naturality square. The `% NOTE` at lines 3337–3343 flags this. Prover can work around using the NOTE as a hint but the technique should be in the prose body. **Soon** finding.
  - `lem:pullback_tensor_map_basechange` (D3′) — neither statement nor proof has `\leanok` (live target). Proof sketch names `comp_δ` and `conjugateEquiv_pullbackComp_inv` with enough detail for a prover. Correct and adequate.
  - `lem:pullback_tensor_iso_loctriv` (D4′) — neither statement nor proof has `\leanok` (live target). Proof sketch is detailed (chart-chase via D1′/D2′/D3′ + `isiso_of_isiso_restrict`). Correct and adequate.
  - `lem:sheafofmodules_hom_of_local_compat` (`homOfLocalCompat`) — statement and proof both `\leanok`. Closed.
  - `lem:dual_restrict_iso` (`dual_restrict_iso`) — statement and proof both `\leanok`. Closed.
  - `lem:dual_isLocallyTrivial` (`dual_isLocallyTrivial`) — statement and proof both `\leanok`. Step 3 of the proof names `dual_unit_iso` (the iso `dual 𝒪_U ≅ 𝒪_U`) but there is no `\lean{}` block for that declaration (confirmed at lines 5532–5539). The declaration `Scheme.Modules.dual_unit_iso` is axiom-clean in tree per the `% NOTE` comment. The absence of the `\lean{}` block means it is untracked in the dependency graph. **Informational** (the consuming lemma is already closed; tracking is a cosmetic gap).
  - `lem:isinvertible_implies_locallytrivial` — off critical path per the `% NOTE` at lines 3922–3931. Retained for future A.2.c use.

**HARD GATE verdict for iter-252**: **PASS** — both active files (`TensorObjSubstrate.lean` and `DualInverse.lean`) are covered by a chapter that is `complete: partial` only in the sense that D1′ lacks a prose technique note and D3′/D4′ lack `\leanok` (correct: they are live targets). D3′/D4′ proof sketches are prover-ready; DualInverse targets are all closed. Neither soon-severity finding rises to must-fix because D3′/D4′ and the DualInverse lane can proceed without them.

---

### `blueprint/src/chapters/AbelianVarietyRigidity.tex`

- **complete**: partial
- **correct**: true
- **notes**:
  - Stale "genuinely-deep residual sorry" wording in the proof prose of `lem:rigidity_eqOn_saturated_open_to_affine` (Step 1 narrative, line ~418) and `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` (last paragraph, line ~591). Both proof blocks carry `\leanok`, meaning they are closed. A `% NOTE (iter-162 review)` at lines 197–215 explicitly flags this stale text as in need of a writer refresh. **Informational** — the formalization is correct; the prose creates a false impression that these are still open.
  - The `\mathbb{G}_m`-scaling route (primary) and the classical `\mathbb{G}_a`-additive route (retained as Milne-faithful alternative) are both represented and correctly characterized as primary / off-critical-path respectively.

### `blueprint/src/chapters/AbelJacobi.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Jacobian.tex`

- **complete**: partial (numerous sorry witnesses, all intentional and documented)
- **correct**: true
- **notes**:
  - Route A sub-phase budgets, the genus-0 witness construction, and all proof-sketch decompositions are accurate and detailed. The `genusZeroWitness` via `prop:rigidity_genus0_curve_to_AV` path is correctly characterised.
  - The `thm:nonempty_jacobianWitness` sorry body is the project's declared foundational gap; the chapter accurately represents its status.

### `blueprint/src/chapters/Rigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RigidityKbar.tex`

- **complete**: true (as a gated named gap + fallback route documentation)
- **correct**: true
- **notes**:
  - The chapter faithfully records the iter-152 alg-closed pivot, the iter-155 correction (C.2.d is gated on `H^0(C,Ω)=0`, not bypassed), and the route (a)/(b) open question. No must-fix issues.

### `blueprint/src/chapters/Genus.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Differentials.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`

- **complete**: true
- **correct**: true
- **notes**:
  - Thin pointer chapter; mathematical content lives in `RigidityKbar.tex`. The piece (i.a) trio (`cotangentSpaceAtIdentity`, `cotangentSpaceAtIdentity_eq_extendScalars`, `cotangentSpaceAtIdentity_finrank_eq`) is documented as closed (iter-128–iter-132). No issues.

### `blueprint/src/chapters/Picard_RelativeSpec.tex`

- **complete**: partial (specification chapter; Lean file creation pending)
- **correct**: true
- **notes**:
  - Stacks source quotes present, local references verified. No citation issues.

### `blueprint/src/chapters/Picard_LineBundlePullback.tex`

- **complete**: partial (set-valued functor only; abelian-group refinement in A.1.c chapter)
- **correct**: true
- **notes**:
  - The deliberate scope restriction (set-valued only, abelian group deferred to RelPicFunctor) is correctly documented. No issues.

### `blueprint/src/chapters/Picard_RelPicFunctor.tex`

- **complete**: partial (several declarations have placeholder Lean bodies pending the upstream `Scheme.Modules` tensor gap)
- **correct**: true
- **notes**:
  - The `\leanok` markers on `def:rel_pic_sharp`, `lem:rel_pic_sharp_functorial`, `thm:rel_pic_sharp_presheaf`, `def:rel_pic_etale_sheafification`, `thm:rel_pic_etale_sheaf_group_structure` are set by `sync_leanok` (declarations exist in Lean with typed bodies). The `% NOTE (iter-199 plan agent)` blocks at each declaration explicitly warn that the Lean body is a placeholder and NOT the mathematically correct construction. This is consistent; `\leanok` means the declaration is formalized at least to a `sorry`, not that the body is correct. No action needed.
  - `thm:rel_pic_etale_sheaf_unit_canonical` has no `\lean{}` pin and is explicitly described as forward-looking without tracking — correct.

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — covered above under HARD GATE.

### `blueprint/src/chapters/Picard_FGAPicRepresentability.tex`

- **complete**: partial (7 sorries, all documented with closure-order ranks)
- **correct**: true
- **notes**:
  - Sorry classification (Rank 1/2/3) is internally consistent with the STRATEGY. Sorries 5–7 correctly identified as Route-C-blocked.

### `blueprint/src/chapters/Picard_QuotScheme.tex`

- **complete**: partial (engine-level gaps documented; not under active prover work this iter)
- **correct**: true

### `blueprint/src/chapters/Picard_FlatteningStratification.tex`

- **complete**: partial (specification, no Lean file yet)
- **correct**: true

### `blueprint/src/chapters/Picard_IdentityComponent.tex`

- **complete**: partial (abstract identity-component substrate not yet in Lean)
- **correct**: true
- **notes**:
  - The Stacks 037Q iff-direction lemma `lem:geometricallyConnected_of_connected_of_section` is present with a full proof sketch (iter-194 first-class addition). No must-fix issues.

### `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex`

- **complete**: partial (specification; Lean skeleton owed)
- **correct**: true
- **notes**:
  - All five theorem blocks carry `\leanok`, meaning corresponding Lean declarations exist. The note "Lean target file does not yet exist" may be stale since iter-192; `sync_leanok` would only set `\leanok` if the declarations exist in Lean. No action needed.

### `blueprint/src/chapters/Albanese_AlbaneseUP.tex`

- **complete**: partial (Route-ii symmetric-power route committed; Lean file pending)
- **correct**: true

### `blueprint/src/chapters/Albanese_CodimOneExtension.tex`

- **complete**: partial (specification)
- **correct**: true

### `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` — not read in full; no active prover work this iter. Partial per strategy.

### `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex` — not read in full; no active prover work this iter.

### `blueprint/src/chapters/Albanese_CoheightBridge.tex`

- **complete**: partial (specification; Lean file pending)
- **correct**: true
- **notes**:
  - Archon-original assembly lemma with explicit Mathlib API pointers. No external source quotes needed. No citation issues.

### `blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex`

- **complete**: partial (substrate chapter; Lane B cocycle support)
- **correct**: true

### `blueprint/src/chapters/RigidityKbar.tex` — covered above.

### `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

- **complete**: partial (i=0 case only; higher R^i f_* deferred)
- **correct**: true

### `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` — not read in full; supporting infrastructure, no active prover work this iter.

### `blueprint/src/chapters/Cohomology_SheafCompose.tex` — not read in full; supporting infrastructure.

### `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` — not read in full; supporting infrastructure.

### `blueprint/src/chapters/Cohomology_MayerVietoris.tex` — not read in full; supporting infrastructure.

### `blueprint/src/chapters/Cohomology_HigherDirectImage.tex` — not read in full; held per strategy.

### `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`

- **complete**: partial (specification; part of paused Route C)
- **correct**: true

### `blueprint/src/chapters/RiemannRoch_OCofP.tex` — paused Route C; not read in full.
### `blueprint/src/chapters/RiemannRoch_OcOfD.tex` — paused Route C.
### `blueprint/src/chapters/RiemannRoch_RRFormula.tex` — paused Route C.
### `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex` — paused Route C.
### `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — paused Route C.

---

## Cross-chapter notes

- `AbelianVarietyRigidity.tex` declares `thm:rigidity_lemma` as consuming `lem:rigidity_eqOn_dense_open`. The NOTE at iter-160 confirms that the `\uses` edges correctly run forward along the true Lean dependency order (chain: `rigidity_lemma → rigidity_eqOn_dense_open → rigidity_eqOn_saturated_open_to_affine → rigidity_eqAt_closedPoint_of_proper_into_affine`). The stale sorry wording in Step 1 of `rigidity_eqOn_saturated_open_to_affine` ("the chain's single genuinely-deep residual sorry") conflicts with the `\leanok` on `rigidity_eqAt_closedPoint_of_proper_into_affine`. Not a broken `\uses`; purely stale prose.

- `Picard_RelPicFunctor.tex` uses `lem:pullback_tensor_iso_loctriv` (D4′ from `Picard_TensorObjSubstrate.tex`) in the proof of `lem:rel_pic_sharp_groupoid` (Step 2, pullback-additivity). This cross-chapter dependency is correctly documented (`\uses` edge present). The dependency is gated on D4′ being a typed-sorry bridge currently, consistent with the note in the RelPicFunctor chapter.

## Directive-specific re-judgments

**Finding 1 — carrier-normalisation technique missing from D1′ proof sketch**:
I agree with the iter-251 per-file assessment that this is a significant gap. The `% NOTE` comment at lines 3337–3343 documents the need, but it is a `%` comment, not prose. A prover working through the proof sketch body will not find guidance for this step. **I do not raise it to must-fix**: D3′ and D4′ (the richer targets this iter) are independently prover-ready, and the DualInverse lane is already closed. Blocking the iter over D1′ alone — when D3′/D4′ and the DualInverse work can proceed — would be too conservative. But the writer pass should happen before D1′ is sent back to a prover; classify as **soon**.

**Finding 2 — `dual_unit_iso` untracked**:
Confirmed: the `Scheme.Modules.dual_unit_iso` declaration is named in Step 3 of the `lem:dual_isLocallyTrivial` proof and built axiom-clean in tree (per the NOTE comment), but has no `\lean{}` block and so receives no `\leanok` tracking. Since `dual_isLocallyTrivial` is already `\leanok` (the consuming lemma is closed), this is a pure tracking gap. **Informational**: no prover work is blocked.

---

## Severity summary

**HARD GATE for iter-252**: CLEARS — `Picard_TensorObjSubstrate.tex` is complete + correct for the DualInverse targets (all `\leanok`) and adequate for D3′/D4′ (detailed prover-ready sketches, correct math). D1′ has a soon-severity sketch gap but does not prevent D3′/D4′ or DualInverse progress.

**Soon** (2 items):
1. `Picard_TensorObjSubstrate.tex` / `lem:pullback_tensor_map_natural` (D1′): dispatch a blueprint-writer to add the carrier-normalisation prose to the proof body (the `sheafifyTensorUnitIso_hom_eq`-style rewrite step that makes Mathlib whisker lemmas fire on the ⋙ forget₂ carrier). Needed before D1′ re-enters a prover lane.
2. `Picard_TensorObjSubstrate.tex` / `dual_unit_iso` untracked: add a `\lemma` block with `\label{lem:dual_unit_iso}` and `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` so the closed declaration appears in the dependency graph.

**Informational** (1 item):
- `AbelianVarietyRigidity.tex`: stale "chain's single genuinely-deep residual sorry" wording in the proof prose of `lem:rigidity_eqOn_saturated_open_to_affine` (Step 1) and `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` (closing paragraph). Both proof blocks carry `\leanok`. A planned writer refresh (flagged in the iter-162 NOTE at lines 197–215) should remove or update these sentences.

Overall verdict: HARD GATE CLEARS — 0 must-fix findings; 2 soon-severity documentation items (D1′ carrier-normalisation prose + `dual_unit_iso` tracking); 1 informational stale-prose item; all strategy phases have adequate blueprint coverage, no unstarted-phase proposals needed.
