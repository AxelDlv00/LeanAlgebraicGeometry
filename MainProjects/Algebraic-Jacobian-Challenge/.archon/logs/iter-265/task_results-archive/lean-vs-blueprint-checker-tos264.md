# Lean ↔ Blueprint Check Report

## Slug
tos264

## Iteration
264

## Files audited
- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` (chapter: `lem:pullback_tensor_map_basechange`)

- **Lean target exists**: yes
- **Signature matches**: yes — Lean L2711–2719 declares `pullbackTensorMap_restrict {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X) (M N : X.Modules)` with exactly the four-term RHS the blueprint displays.
- **Proof follows sketch**: partial — body is `:= sorry` (L2806) after `simp only [pullbackTensorMap, tensorObjIsoOfIso]; rw [Functor.map_comp, Functor.map_comp, Functor.map_comp]; simp only [Category.assoc]`. The partial scaffold matches the blueprint's "4-fold composite S1 ≫ a.map δ ≫ S3 ≫ S4" analysis; the four squares (Sq1–Sq4) are identified in the inline comment exactly as the blueprint describes. The sorry is an **authorized open obligation**, not a placeholder for a trivial claim.
- **notes**: D3' outer sorry; expected state for iter-264. The inline comment is a detailed, honest roadmap, not an excuse comment.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.leftAdjointUniqUnitEta}` (chapter: `lem:leftadjointuniq_app_unit_eta`)

- **Lean target exists**: yes — L1623–1658
- **Signature matches**: yes — the `𝟙_`-specialization (unit-pair component) pinned by the blueprint
- **Proof follows sketch**: yes — `homEquiv_leftAdjointUniq_hom_app A B` + `Adjunction.comp_unit_app` + `rfl`, exactly as described in the blueprint proof
- **notes**: axiom-clean, no sorry. The blueprint pin refers to this `𝟙_`-specialized version only; the generalized `_app` form is a separate declaration (see Unreferenced below).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_eq_leftAdjointUniq}` (chapter: `lem:sheafification_comp_pullback_eq_leftadjointuniq`)

- **Lean target exists**: yes — L1603–1614
- **Signature matches**: yes — definitional equality `sheafificationCompPullback φ = Adjunction.leftAdjointUniq A B`
- **Proof follows sketch**: yes — proven by `rfl`; blueprint claims this is on the nose (definitional)
- **notes**: axiom-clean, no sorry.

---

### Other `\lean{...}`-pinned declarations checked (brief)

All the following are confirmed present, signature-matched, and sorry-free:
`pullbackTensorMap`, `isIso_pullbackTensorMap_of_isIso_sheafifyDelta`, `unitToPushforwardObjUnit_comp`, `pullbackObjUnitToUnit_comp`, `pullbackUnitIso`, `pullbackTensorMap_natural`, `sheafifyTensorUnitIso_hom_natural`, `pullbackValIso_hom_natural`, `pullbackTensorMap_unit_isIso`, `presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`, `pullbackEtaUnitSquare`, `compHomEquivFactor`, `epsilonPresheafToSheafUnit`, `presheafPushforwardLaxMonoidal`, `presheafPullbackOplaxMonoidal`, `picCommGroup`, `IsInvertible`, `isInvertible_unit`, `IsInvertible.tensorObj`, `IsInvertible.inverse_unique`, `tensorObj`, `tensorObj_functoriality`, `tensorObj_isLocallyTrivial`.

`exists_tensorObj_inverse` (L698): `:= sorry` — this is the other authorized open sorry, not related to D3'.

---

## Red flags

### Placeholder / suspect bodies

- `pullbackTensorMap_restrict` at L2806: `:= sorry` but blueprint claims this is substantive (the outer D3' obligation). **This sorry is authorized and expected**; it is not a placeholder for something trivially proved. The partial scaffold is mathematically faithful. NOT a must-fix from a correctness standpoint — rather an open proof obligation.

- `sheafificationCompPullback_comp_tail` at L2578: `:= sorry` after two structural `rw` steps. Private sub-lemma, not blueprint-pinned. The inline comment precisely identifies the remaining steps (recover R1/R5 via `leftAdjointUniqUnitEta_app`, `pushforwardComp.hom.naturality`, `comp_unit_app` + `unit_naturality`). Again an authorized open obligation, but this is the **proximate open target** blocking D3'.

- `sheafificationCompPullback_comp` at L2591: delegates to `sheafificationCompPullback_comp_tail`, which is sorry. The delegation itself is correct (all surrounding steps are proved; the sorry propagates from the tail). The comment explicitly flags the circular approach as DO-NOT and explains why (verified iter-264).

- `exists_tensorObj_inverse` at L720: `:= sorry` — long-standing authorized open, unrelated to D3', gated on the dual chain.

### Excuse-comments

None. The inline comments in sorry-carrying declarations are accurate diagnostic logs, not "wrong but works for now" rationalizations. The comments flag verified circularities and state the remaining steps precisely.

### Axioms / Classical.choice on non-trivial claims

None beyond what the blueprint authorizes. `picCommGroup` uses `Classical.choice` in `picInv` — this is the Lean idiomatic choice for the inverse witness and matches the blueprint's existential treatment.

---

## Unreferenced declarations (informational)

The following substantive declarations appear in the Lean file with **no `\lean{...}` reference** in the blueprint chapter:

| Declaration | Line | Status | Severity |
|---|---|---|---|
| `leftAdjointUniqUnitEta_app` | ~1668 | **NEW this iter, axiom-clean, no sorry** | **major** — This is the P-general recovery brick landed in iter-264 (the "ma-d3264 step 1" described in the inline comment). The blueprint pins only `leftAdjointUniqUnitEta` (the `𝟙_`-specialization). The `_app` variant is a **distinct substantive lemma** (same proof structure, P-general hypothesis) not mentioned anywhere in the blueprint. It is consumed by `sheafificationCompPullback_comp_tail`. A blueprint-writing subagent should add a `\lean{...}` pin for it. |
| `sheafificationCompPullback_comp` | ~2591 | private, sorry-delegating | minor — private sub-lemma for Sq1; blueprint describes it by name in prose but does not pin it. Acceptable for a private lemma. |
| `sheafificationCompPullback_comp_tail` | ~2514 | private, `:= sorry` | minor — private sub-lemma; blueprint describes it by name in the Sq1 proof narrative but no pin. Acceptable for a private lemma. |
| `pullbackComp_δ` | ~2351 | private, axiom-clean | minor — named Sq2b sub-lemma; not blueprint-pinned but private. |
| `pushforwardComp_lax_μ` | ~2290 | private, axiom-clean | minor — named Sq2b residual; not blueprint-pinned but private. |
| `sheaf_unit_comp_pushforward_pullbackComp_inv` | ~2482 | private, axiom-clean | minor — private R0-peel building block; acceptable. |
| `restrictScalarsId_map`, `restrictScalars_μ_app`, `forget₂_restrictScalars_μ_hom_tmul`, `restrictScalars_μ_app_tmul`, `pushforward_map_restrictScalars_μ_app_tmul`, `pushforward_μ_eq` | various | private helpers | minor — helpers for closed sub-lemmas; not blueprint-pinned. Acceptable. |
| `pullback0`, `extendScalars`, `pullbackLanDecomposition`, etc. (off-path D1 section) | ~1280–1317 | axiom-clean | minor — explicitly flagged OFF-PATH in both the Lean file and blueprint; acceptable. |
| `isIso_pbu_of_final`, `pullbackObjUnitToUnitIso`, `pullbackObjUnitToUnitIso_hom` | ~1033–1051 | no sorry | minor — helpers for `pullbackUnitIso`; could be blueprint-referenced but not critical. |
| `restrictIsoUnitOfLE`, `isIso_of_isIso_restrict`, `homMk`, `toPresheaf_map_homMk` | various | no sorry | minor — supporting lemmas described in prose but not separately pinned. |
| `dualIsoOfIso` | ~233 | no sorry | minor — dual analogue of `tensorObjIsoOfIso`; prose-described but not separately pinned. |

---

## Blueprint adequacy for this file

**Coverage**: 23/23 blueprint-pinned `\lean{...}` declarations are present and signature-matched. However, `leftAdjointUniqUnitEta_app` — a substantive new declaration added this iter that is the direct precursor to the open tail goal — has no `\lean{...}` reference.

**Proof-sketch depth for the Sq1 tail: under-specified.**

The blueprint (lines 4044–4113) describes the Sq1 proof strategy at two levels:
1. **Macro level** (adequate): names the sub-lemmas `sheafificationCompPullback_comp` and `sheafificationCompPullback_comp_tail`, points to `leftAdjointUniqUnitEta` as the tool for recovering B-units from `sheafCompPb.app.hom`, says to use `homEquiv_leftAdjointUniq_hom_app` + `comp_unit_app` + `unit_naturality` + `pushforwardComp.hom.naturality`.
2. **Micro level** (inadequate): the blueprint does NOT specify the order/structure of the `hinner`/`hcomp'` assembly — the specific 4–5 goal transformations that mirror `pullbackObjUnitToUnit_comp`'s L969–1001 chain. The blueprint refers to that chain abstractly ("the `hinner`/`hcomp'` twin" — but that language appears only in the *Lean source*, not in the blueprint), and says "the sheafification-laden analog of `lem:pullbackObjUnitToUnit_comp`; unlike that lemma it is not definitional sectionwise." This is informative but not actionable without already having the analog's proof in front of you.

**Critical gap**: `leftAdjointUniqUnitEta_app` — the exact P-general brick the prover landed this iter as "step 1" of the tail recovery — is not mentioned anywhere in the blueprint chapter. The blueprint only pins `leftAdjointUniqUnitEta` (the `𝟙_`-specialization). A prover guided solely by the blueprint would not know to generalize this to P-general form before attempting the tail.

**Hint precision**: loose for the tail. The blueprint says "recover the individual f- and h-sub-comparison units via `homEquiv_leftAdjointUniq_hom_app`" but does not state at which argument (P vs `𝟙_`) this is applied, or that a separate P-general lemma is needed before the tail closes.

**Generality**: matches need for all pinned declarations. The P-general `_app` form was a gap the prover had to discover independently.

**Recommended chapter-side actions** (for a blueprint-writing subagent):
1. **Add a `\lean{...}` pin** for `AlgebraicGeometry.Scheme.Modules.leftAdjointUniqUnitEta_app` — state it as the P-general version of `lem:leftadjointuniq_app_unit_eta` and note it is the key step-1 brick of `sheafificationCompPullback_comp_tail`.
2. **Expand the Sq1 tail proof sketch** in `lem:pullback_tensor_map_basechange` to spell out the `sheafificationCompPullback_comp_tail` assembly: (a) strip `restrictScalars (𝟙)` wrapper; (b) `conv_rhs => rw [Functor.map_comp]` to expose R1/R5 without contaminating LHS; (c) apply `leftAdjointUniqUnitEta_app` to recover R1 as `B_f.unit.app P` and R5 as `B_h.unit.app (PrPb_f P)`; (d) slide `pushforwardComp.hom` past them via naturality; (e) reassemble via `comp_unit_app` + `unit_naturality`. This mirrors the closed `pullbackObjUnitToUnit_comp`'s `hinner`/`hcomp'` chain and would give the prover the exact 5-step sequence.
3. Optionally add a named lemma block for `sheafificationCompPullback_comp` (the Sq1 private sub-lemma) so its statement is visible in the blueprint's dependency graph, even if it stays private in Lean.

---

## Severity summary

- **must-fix-this-iter**: none — no wrong signatures, no fake statements, no unauthorized axioms.
- **major**:
  1. `leftAdjointUniqUnitEta_app` is a substantive new declaration (proved this iter, the recovery brick for D3' Sq1 tail, step 1) with no `\lean{...}` reference in the blueprint. The blueprint should be updated to add this pin.
  2. The blueprint's Sq1 proof sketch for `sheafificationCompPullback_comp_tail` is under-specified at the level the Lean code now requires: it names the conceptual route but omits the specific 5-step assembly (the `hinner`/`hcomp'` ordering, the `conv_rhs`-confined distribution, the exact role of `leftAdjointUniqUnitEta_app`). For a 4th-consecutive-PARTIAL, this under-specification is a meaningful contributor to the stall.
- **minor**:
  - Several private helper sub-lemmas (R0-peel, μ-app helpers, `pullbackComp_δ`, etc.) are present without blueprint pins, which is acceptable for private lemmas.
  - The blueprint names `sheafificationCompPullback_comp_tail` in prose but doesn't give it a standalone lemma block (statement or `\lean{}` pin). Acceptable for a private sub-lemma but would help navigation.

**Overall verdict**: The Lean file faithfully implements the blueprint's pinned declarations, with `pullbackTensorMap_restrict` and its Sq1 sub-lemma remaining open sorries as expected. The blueprint chapter is adequately specified for all closed declarations but is **under-specified for the D3' Sq1 tail at the granularity the Lean code now requires** — specifically, `leftAdjointUniqUnitEta_app` (the P-general recovery brick landed this iter) is blueprint-invisible, and the tail assembly steps are described too conceptually to guide the prover past the 4th-consecutive PARTIAL without consulting the closed analog directly.
