# blueprint-reviewer — iter-031

**Slug:** iter031  
**Date:** 2026-06-07  
**Verdict scope:** whole-blueprint audit, all six chapters

---

## Tools run

| Tool | Result |
|------|--------|
| `leandag show isolated` | 1 isolated node (`lem:annihilator_localization_eq_map`) |
| `archon blueprint-doctor --json` | 1 malformed ref (`\minordet` undefined macro) |

---

## Chapter verdicts

### 1. Cohomology_FlatBaseChange.tex — HARD GATE ✓

**complete: true | correct: true**

**HARD GATE checks (the five `_legs` link blocks):**

1. **No dangling old names.** grep confirms zero occurrences of `_link_distribute` and `_link_collapseComp` (the predecessor two-block names). Clean. ✓

2. **L1+L2 merged block — `lem:base_change_mate_fstar_reindex_legs_link_distributeCollapse`** (lines 1688–1735):
   - `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distributeCollapse}` present ✓
   - `\uses{..._legs_unitExpand, ..._gammaDistribute, ..._inner_eCancel_pushforwardComp, lem:gammaMap_pushforwardComp_hom_eq_id}` ✓
   - **`\leanok` missing.** The Lean declaration is sorry-free (verified: no `sorry` in lines 1333–1380 of FlatBaseChange.lean). This decl was shipped iter-030; `sync_leanok` should have added `\leanok` after iter-030. The plan agent revised the block (merging L1+L2) and dropped the marker. `sync_leanok` will restore it automatically after this iter's prover phase. *Note: review agent must not add it — sync_leanok owns it.*
   - Proof sketch: "distribute at the single composite functor F := (Spec φ)_* ∘ Γ_R, collapse the pushforwardComp factor via lem:gammaMap_pushforwardComp_hom_eq_id." Precise and formalizable. ✓

3. **L3 — `lem:base_change_mate_fstar_reindex_legs_link_cancelEUnit`** (lines 1737–1773):
   - `\lean{...}` pin present; no `\leanok` (correct — prover target) ✓
   - `\uses{..._link_distributeCollapse, ..._inner_eCancel_eUnit, ..._codomain_read_legs}` ✓
   - Proof sketch: "locate the inverse (η^e)^{-1} baked into Θ_tgt (lem:base_change_mate_codomain_read_legs), graft lem:base_change_mate_inner_eCancel_eUnit via whiskering (congruence on left/right neighbours, transitivity, definitional identification across transport layer), unit law collapses to the two-factor reduced form." Precise term-mode recipe. ✓

4. **L4 — `lem:base_change_mate_fstar_reindex_legs_link_cancelPullbackComp`** (lines 1775–1807):
   - `\lean{...}` pin present; no `\leanok` (correct) ✓
   - `\uses{..._link_cancelEUnit, ..._inner_eCancel_pullbackComp, ..._codomain_read_legs}` ✓
   - Proof sketch: same whiskering template — adjacent hom/inverse for pullbackComp_{e,Spec ιA}, graft by congruence/transitivity across gammaPushforwardIso transport layer, unit law. Precise. ✓

5. **L5 — `lem:base_change_mate_fstar_reindex_legs_link_survivor`** (lines 1809–1842):
   - `\lean{...}` pin present; no `\leanok` (correct) ✓
   - `\uses{..._link_cancelPullbackComp, lem:base_change_mate_unit_value, lem:pushforward_spec_tilde_iso, def:base_change_mate_inner_value}` ✓
   - Proof sketch: "read the lone affine (Spec ιA)-unit through tilde/Γ dictionaries (lem:pushforward_spec_tilde_iso), identifies with restriction of scalars of η_M, transport over Spec R via ring equation ιA ∘ φ = ιR' ∘ ψ, yields ρ of def:base_change_mate_inner_value." Precise and cites all needed lemmas. ✓

6. **Assembly `lem:base_change_mate_fstar_reindex_legs`** (lines 1844–1925):
   - Has `\leanok` (statement: sorry-backed assembly — correct, 1 sorry at line 1461 of FlatBaseChange.lean) ✓
   - `\uses{}` correctly lists all four link blocks plus upstream lemmas ✓
   - The L1–L4 numbering in the assembly proof body (lines 1909–1919) matches the L1+L2/L3/L4/L5 chain in the text: distributeCollapse→cancelEUnit→cancelPullbackComp→survivor. ✓

**Must-fix this iter:** none on the math side. Sync_leanok should restore `\leanok` on `_link_distributeCollapse` automatically.

---

### 2. Picard_QuotScheme.tex — HARD GATE ✓

**complete: true | correct: true**

**HARD GATE checks (6-block over-site sub-section + `lem:over_restrict_iso`):**

**6-block over-site/open-subspace sheaf equivalence (lines 2884–3007):**

All six project-local declarations are present and have `\lean{}` pins. All are sorry-free in QuotScheme.lean (verified: lines 786–900 of QuotScheme.lean contain all six instances and no `sorry`). All six `\leanok` markers are absent from the blueprint (same plan-agent revision pattern as FBC; sync_leanok will restore).

| Label | `\lean{}` | `\uses{}` | `\leanok` |
|-------|-----------|-----------|-----------|
| `lem:overEquivalence_functor_isCocontinuous` | `AlgebraicGeometry.overEquivalence_functor_isCocontinuous` | `{lem:opens_overEquivalence_mathlib}` ✓ | missing (sync_leanok) |
| `lem:overEquivalence_inverse_isCocontinuous` | `AlgebraicGeometry.overEquivalence_inverse_isCocontinuous` | `{lem:opens_overEquivalence_mathlib}` ✓ | missing |
| `lem:overEquivalence_inverse_isDenseSubsite` | `AlgebraicGeometry.overEquivalence_inverse_isDenseSubsite` | `{lem:overEquivalence_functor_isCocontinuous, lem:overEquivalence_inverse_isCocontinuous}` ✓ | missing |
| `lem:overEquivalence_functor_isContinuous` | `AlgebraicGeometry.overEquivalence_functor_isContinuous` | `{lem:overEquivalence_inverse_isCocontinuous}` ✓ | missing |
| `lem:overEquivalence_inverse_isContinuous` | `AlgebraicGeometry.overEquivalence_inverse_isContinuous` | `{lem:overEquivalence_functor_isCocontinuous}` ✓ | missing |
| `def:overEquivalence_sheafCongr` | `AlgebraicGeometry.overEquivalence_sheafCongr` | `{lem:opens_overEquivalence_mathlib, lem:equivalence_sheafCongr_mathlib, lem:overEquivalence_inverse_isDenseSubsite}` ✓ | missing |

**`lem:over_restrict_iso` 4-step decomposition (lines 3011–3096):**

- `\uses{}` (statement): lists all 8 dependencies — `lem:modules_restrictFunctor_mathlib`, `lem:modules_restrictFunctorIsoPullback_mathlib`, `lem:isLocalization_basicOpen_mathlib`, `def:overEquivalence_sheafCongr`, `lem:overEquivalence_functor_isContinuous`, `lem:overEquivalence_inverse_isContinuous`, `lem:opens_overEquivalence_mathlib`, `lem:pushforwardPushforwardEquivalence_mathlib`. ✓
- **Step 1** (topological layer, done): references `def:overEquivalence_sheafCongr`. Marked as done in NOTE. ✓
- **Step 2** (geometric ring-sheaf identification, current obstacle): sketch names the key factorization `U.ι.opensFunctor = (Opens.overEquivalence U).inverse ∘ Over.forget U` as the bridge for identifying the sliced structure sheaf O_X.over U with O_U, then "structure-sheaf comparison reduces to standard open-immersion structure-sheaf identifications." This is more detailed than the iter-030 sketch (which the iter-030 checker flagged as too thin). The new sketch names the exact functor factorization and the reduction target. **Sufficient to guide the prover for iter-031.** ✓
- **Step 3** (lift to modules via `pushforwardPushforwardEquivalence`): cites `lem:pushforwardPushforwardEquivalence_mathlib` and both continuity instances. ✓
- **Step 4** (compose with `restrictFunctorIsoPullback`): cites `lem:modules_restrictFunctorIsoPullback_mathlib`. ✓
- NOTE retained: "the literal Lean form of overRestrictIso may need to be sharpened: the two sides live in different module categories, so statement must be routed THROUGH the step-3 equivalence functor." This is a correct prover-facing warning. ✓

**Must-fix this iter:** none. Step 2 sketch is adequate for dispatch. Sync_leanok handles the six missing `\leanok` markers.

---

### 3. Picard_GrassmannianCells.tex — HARD GATE ✓ (modulo rendering MUST-FIX)

**complete: true | correct: true**

**HARD GATE checks:**

1. **`lem:gr_cocycle_phi_id`** (lines 1457–1487):
   - Block present ✓
   - Statement: "the composite ring endomorphism Φ := Θ_{I,J,K} ∘ swap_J ∘ Θ_{J,K,I} ∘ swap_K ∘ Θ_{K,I,J} ∘ swap_I equals RingHom.id R_{IJK}" ✓
   - `\uses{def:gr_cocycle_theta_ij, def:gr_away_mul_comm_equiv, lem:gr_cocycle_imageMatrix_eq, lem:gr_cocycle}` ✓
   - Proof sketch: "by IsLocalization.ringHom_ext for the submonoid generated by minordet_{I,J}·minordet_{I,K} it suffices to check on generators; Φ unwinds via order-swaps and Θ definitions to the rotated analogue of the matrix cocycle collapse (Y_K)^{-1}Y already proved in lem:gr_cocycle_imageMatrix_eq." Mechanically sound — reuses the established imageMatrix collapse machinery. ✓
   - No `\leanok` (correct — prover target, not yet formalized) ✓

2. **`def:gr_glued_scheme`** (lines 1492–1624):
   - `\uses{..., lem:gr_cocycle_phi_id}` correctly wired ✓
   - No `\leanok` (correct — prover target) ✓
   - NOTE confirms "NOT yet formalized: the `cocycle` field, the `Scheme.GlueData` bundle, and `Grassmannian.scheme`." ✓

3. **`lem:gr_separated`** and **`lem:gr_proper`** (lines 1629–1818): both present with detailed proof sketches; correctly lack `\leanok` (downstream targets). ✓

**MUST-FIX THIS ITER:** `\minordet` undefined macro (blueprint-doctor finding). Used at lines 1464, 1478, 1480 in `lem:gr_cocycle_phi_id` but defined nowhere in `blueprint/src/macros/common.tex` or any chapter. Blueprint rendering will fail with this macro. The plan agent must add to `common.tex`:

```latex
\newcommand{\minordet}[1]{\det_{#1}}
```

(or whatever convention the rest of the chapter uses for `\det_{IJ}` — check `lem:gr_cocycle` for the notation pattern and match it).

---

### 4. Cohomology_RegroupHelper.tex

**complete: true | correct: true**

One block (`lem:base_change_regroup_linearEquiv`), `\leanok` present, `\uses{lem:isPushout_cancelBaseChange_mathlib}` correct. No issues.

---

### 5. Picard_RelativeSpec.tex

**complete: true | correct: true**

Five blocks (`def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `def:relspec_structure_morphism`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base`), all `\leanok`. The "IsAffineHom-only" encoding of `thm:relative_spec_univ` is an acknowledged iter-174+ commitment (noted in the file). No issues for current objectives.

---

### 6. Picard_FlatteningStratification.tex

**complete: true | correct: true**

**Coverage:** All GF-alg blocks (L1–L5, `thm:generic_flatness_algebraic`), Nagata machinery, L5b sub-blocks, reindex transport helpers, polynomial core, and GF-geo bridge stubs (`lem:gf_qcoh_fintype_finite_sections` G1, `lem:gf_flat_locality_assembly` G3, `thm:generic_flatness`) are present. Sources correctly attributed to Nitsure §4 and Stacks throughout.

**`\leanok` anomaly (whole-chapter strip):** Zero `\leanok` markers on any project-local declaration in the file. FlatteningStratification.lean has exactly 1 `sorry` (in `genericFlatness` at line 2264); all other declarations including `genericFlatnessAlgebraic` are sorry-free. The `\leanok` markers should be present on ~25 declaration blocks (GF-alg done@022). The plan agent for iter-031 appears to have edited the chapter and stripped all markers — a violation of the "agents must NOT remove `\leanok`" rule. `sync_leanok` will restore all markers after the prover phase. *This is not a prover blocker but the plan agent should be notified.*

**GF-geo stubs correct:** `lem:gf_qcoh_fintype_finite_sections` and `lem:gf_flat_locality_assembly` correctly lack `\leanok` (active ACTIVE-phase targets, gated on gap1). `thm:generic_flatness` has the single `sorry` at line 2264 of the Lean file and correctly lacks proof-block `\leanok`.

---

## Cross-cutting findings

### leandag: 1 isolated node

**`lem:annihilator_localization_eq_map`** (Picard_QuotScheme.tex, line 2415): 0 deps, 0 impact. The block has `\leanok` + `\lean{Module.annihilator_isLocalizedModule_eq_map}`. It is referenced in `def:modules_annihilator` prose via `\cref{}` but the `def:modules_annihilator` statement `\uses{}` does not include it. Since `def:modules_annihilator` is the consumer of this algebra engine fact, add `lem:annihilator_localization_eq_map` to the statement `\uses{}` of `def:modules_annihilator` (or to whichever downstream block uses it first), then run `leandag build` to refresh the cache.

**Disposition:** SHOULD-FIX (not blocking prover dispatch; leandag edge is a blueprint-correctness issue, not a math error).

### blueprint-doctor: 1 must-fix

**`\minordet` undefined macro** in `Picard_GrassmannianCells.tex` (blueprint-doctor finding). Used in `lem:gr_cocycle_phi_id` (lines 1464, 1478, 1480). Not defined anywhere. Must add definition to `blueprint/src/macros/common.tex` before the prover reads the chapter. **MUST-FIX before GR-glue prover dispatch.**

### `\leanok` strip pattern

The plan agent for iter-031 edited both `Cohomology_FlatBaseChange.tex` and `Picard_FlatteningStratification.tex` and dropped `\leanok` markers from blocks that were previously synced as sorry-free. Markers dropped in FBC: at minimum `_link_distributeCollapse` (1 marker). Markers dropped in FlatteningStratification: all project-local markers (~25). The review agent should not re-add these (sync_leanok owns `\leanok`), but the plan agent should be reminded of the rule. `sync_leanok` will automatically restore all dropped markers after this iter's prover phase.

---

## Must-fix summary

| Priority | Finding | Chapter | Action |
|----------|---------|---------|--------|
| MUST-FIX before GR-glue dispatch | `\minordet` undefined macro | GrassmannianCells | Add `\newcommand{\minordet}{...}` to `common.tex` matching existing notation |
| SHOULD-FIX | `lem:annihilator_localization_eq_map` isolated in leandag | QuotScheme | Add to `\uses{}` of `def:modules_annihilator` statement |
| WILL BE AUTO-FIXED by sync_leanok | `\leanok` missing on `_link_distributeCollapse`, all FlatteningStratification project decls, all 6 over-site decls in QuotScheme | FBC, FlatStrat, QuotScheme | No agent action needed; sync_leanok restores after prover phase |

---

## HARD GATE summary

| Chapter | complete | correct | Clears gate? |
|---------|----------|---------|--------------|
| Cohomology_FlatBaseChange.tex | true | true | **YES** |
| Picard_QuotScheme.tex | true | true | **YES** |
| Picard_GrassmannianCells.tex | true | true | **YES** (after `\minordet` fix) |

All three HARD GATE chapters clear. Recommended action before dispatch: fix `\minordet` macro in `common.tex`, then dispatch prover for GR-glue (`def:gr_glued_scheme`), FBC-A (`_link_cancelEUnit`/`_link_cancelPullbackComp`/`_link_survivor`), and QUOT-gap1 step 2 (`lem:over_restrict_iso` step 2 — ring-sheaf identification).
