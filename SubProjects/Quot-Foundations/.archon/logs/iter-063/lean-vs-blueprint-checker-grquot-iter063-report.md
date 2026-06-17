# Lean ↔ Blueprint Check Report

## Slug
grquot-iter063

## Iteration
063

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean` (1682 lines)
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (1627 lines)

---

## Per-declaration (iter-063 directive items)

### `\lean{AlgebraicGeometry.Grassmannian.matrixEnd_pullback}` (lem:gr_matrixEnd_pullback)
- **Lean target exists**: yes (line 983)
- **Signature matches**: yes — blueprint says `p*(matrixEnd M) = Q⁻¹ ∘ matrixEnd(p♯M) ∘ Q`; Lean states `(pullback p).map (matrixEnd M) = pullbackFreeIso.hom ≫ matrixEnd (appTop.mapMatrix M) ≫ pullbackFreeIso.inv`, matching exactly
- **Proof follows sketch**: yes — blueprint says "on each (k,ℓ)-component the pulled-back scalar endomorphism is, by scalarEnd_pullback, the comparison-conjugate; reassembling over the biproduct combines the one-element comparisons into Q". Lean proof uses `ιFree_matrixEnd` to expand components, applies `scalarEnd_pullback` per entry, and reassembles — faithful to the sketch (the helper `ιFree_matrixEnd` is an internal step the blueprint left implicit)
- **`\leanok` honest**: yes — fully proved, no sorry
- **notes**: Closed this iter as announced. Clean.

### `ιFree_matrixEnd` (no blueprint label — coverage debt)
- **Lean target exists**: yes (line 966) — `lemma ιFree_matrixEnd`
- **Signature matches**: N/A — no blueprint entry
- **Proof follows sketch**: N/A
- **notes**: Fully proved row-expansion identity `ιFree j ≫ matrixEnd M = ∑ k, scalarEnd (M k j) ≫ ιFree k`. Used twice inside `matrixEnd_pullback`. No `\lean{}` reference anywhere in the blueprint chapter. **Coverage debt** — substantive helper that a prover writing `matrixEnd_pullback` clearly needed; deserves its own `\begin{lemma}...\end{lemma}` block under `def:gr_matrixEnd` in the blueprint.

### `pullbackBaseChangeTransport_matrixToFreeIso` (no blueprint label — coverage debt)
- **Lean target exists**: yes (line 1543) — `lemma pullbackBaseChangeTransport_matrixToFreeIso`
- **Signature matches**: N/A — no blueprint entry
- **Proof follows sketch**: N/A
- **notes**: Fully proved intermediate lemma: a `pullbackFreeIso a ≪≫ matrixToFreeIso M N ≪≫ (pullbackFreeIso b).symm`-shaped transition transports through `pullbackBaseChangeTransport` to `pullbackFreeIso(p≫a).hom ≫ matrixEnd(p♯M) ≫ pullbackFreeIso(p≫b).inv`. The docstring labels it `lem:gr_matrixToFreeIso_transport`, but that label does not appear anywhere in the blueprint chapter. Used inside `bundleTransition_cocycle` (sorry body). **Coverage debt** — this is the reusable (a)→(c) core of the C2 transport; `lem:gr_bundleCocycle_transport` in the blueprint currently plans for `bundleTransition_cocycle_transport` (see phantom-entry finding below) and relies on this step in its proof sketch, but never pins it.

---

## Per-declaration (other `\lean{}` blocks verified)

All remaining `\lean{}` blocks were spot-checked; full list follows.

| Blueprint label | Lean decl | Exists | Sorry-free | `\leanok` honest |
|---|---|---|---|---|
| def:modules_pullbackComp | Scheme.Modules.pullbackComp | yes (Mathlib) | yes | mathlibok |
| lem:modules_pullback_basechange_transport | pullbackBaseChangeTransport | yes | yes | yes |
| lem:gr_glueData_bridges | glueData_bridge_src/mid/tgt | yes | yes | **no** (see minor §) |
| def:scheme_modules_glue | glue | yes | yes | yes |
| def:gr_modules_glueRestrictionIso | glueRestrictionIso | **no** | — | n/a (% NOTE: fwd decl) |
| lem:gr_modules_glue_unique | glue_unique | **no** | — | n/a (% NOTE: fwd decl) |
| def:gr_modules_glueHom | glueHom | **no** | — | n/a (% NOTE: fwd decl) |
| lem:gr_opensMap_final | opensMap_final | yes | yes | yes |
| lem:gr_pullbackFreeIso | pullbackFreeIso | yes | yes | yes |
| lem:gr_pullbackFreeIso_eqToHom | pullbackFreeIso_eqToHom | yes | yes | yes |
| lem:gr_pullbackFreeIso_trans_symm_eqToIso | pullbackFreeIso_trans_symm_eqToIso | yes | yes | yes |
| lem:gr_pullback_isLocallyFreeOfRank | pullback_isLocallyFreeOfRank | yes | yes | yes |
| def:gr_globalUnitSection | globalUnitSection | yes | yes | yes |
| def:gr_scalarEnd | scalarEnd | yes | yes | yes |
| lem:gr_scalarEnd_one | scalarEnd_one | yes | yes | yes |
| lem:gr_scalarEnd_zero | scalarEnd_zero | yes | yes | yes |
| lem:gr_scalarEnd_comp | scalarEnd_comp | yes | yes | yes |
| lem:gr_scalarEnd_add | scalarEnd_add | yes | yes | yes |
| lem:gr_scalarEnd_sum | scalarEnd_sum | yes | yes | yes |
| def:gr_matrixEnd | matrixEnd | yes | yes | yes |
| lem:gr_matrixEnd_comp | matrixEnd_comp | yes | yes | yes |
| lem:gr_matrixEnd_one | matrixEnd_one | yes | yes | yes |
| def:gr_matrixToFreeIso | matrixToFreeIso | yes | yes | yes |
| lem:gr_matrixToFreeIso_hom | matrixToFreeIso_hom | yes | yes | yes |
| lem:gr_matrixToFreeIso_mul | matrixToFreeIso_mul | yes | yes | yes |
| def:gr_chart_quotient | chartQuotientMap | yes | yes | yes |
| lem:gr_chartQuotientMap_iFree | chartQuotientMap_ιFree | yes | yes | yes (private) |
| lem:gr_chartQuotientMap_epi | chartQuotientMap_epi | yes | yes | yes |
| lem:gr_universalMinorInv_self | universalMinorInv_self | yes | yes | yes |
| def:gr_bundleTransition | bundleTransition | yes | yes | yes |
| lem:gr_bundleCocycle_id | bundleTransition_self | yes | yes | yes |
| def:gr_bundleTransitionData | bundleTransitionData | yes | yes | yes |
| lem:gr_bundleCocycle_matrix | bundleTransition_cocycle_matrix | yes | yes | yes |
| lem:gr_scalarEnd_pullback | scalarEnd_pullback | yes | yes | yes |
| lem:gr_matrixEnd_pullback | matrixEnd_pullback | yes | yes | yes |
| **lem:gr_baseChange_bridge** | **baseChange_bridge** | **NO** | — | n/a (no % NOTE) |
| **lem:gr_bundleCocycle_transport** | **bundleTransition_cocycle_transport** | **NO** | — | n/a (no % NOTE) |
| lem:gr_bundleCocycle_mul | bundleTransition_cocycle | yes | **sorry** | yes (stmt-only) |
| def:gr_universal_quotient_sheaf | universalQuotient | yes | **sorry** | yes (stmt-only) |
| def:tautological_quotient | tautologicalQuotient | yes | **sorry** | yes (stmt-only) |
| def:gr_rankQuotient | RankQuotient/Rel/rel_*/rqSetoid/rqPullback/rqPullback_rel | yes | yes | yes |
| lem:gr_pullbackObjUnitToUnit_id | pullbackObjUnitToUnit_id | yes | yes | yes |
| lem:gr_pullbackFreeIso_id | pullbackFreeIso_id | yes | yes | yes |
| lem:gr_pullbackObjUnitToUnit_comp | pullbackObjUnitToUnit_comp | yes | yes | yes |
| lem:gr_homEquiv_conjugateEquiv_app | homEquiv_conjugateEquiv_app | yes | yes | yes |
| lem:gr_pullbackFreeIso_comp | pullbackFreeIso_comp | yes | yes | yes |
| def:grassmannian_functor | functor | yes | yes | yes |
| thm:grassmannian_universal_property | represents | yes | **sorry** | yes (stmt-only) |

---

## Red flags

### Placeholder / suspect bodies

The following declarations have `sorry` bodies; each is documented as intentional ("statement-only \leanok" semantics per AGENTS.md — declaration is formalized, proof still open):

- `bundleTransition_cocycle` (line 1099): comment inside body describes remaining steps (a)+(b); body is `sorry`. Blueprint `\leanok` on statement block. **Honest.**
- `universalQuotient` (line 1119): body `sorry`, rides on `bundleTransition_cocycle`. Blueprint `\leanok` on statement block. **Honest.**
- `tautologicalQuotient` (line 1130): body `sorry`, rides on `universalQuotient`. Blueprint `\leanok` on statement block. **Honest.**
- `represents` (line 1679): body `sorry`, rides on `tautologicalQuotient`. Blueprint `\leanok` on statement block. **Honest.**

No excuse-comments ("wrong but works", "placeholder until…", etc.). The sorry comments are architectural notes describing what remains.

### Axioms / Classical.choice on non-trivial claims
None found.

---

## Unreferenced declarations (informational)

Declarations in the Lean file with no blueprint `\lean{}` reference:

**Substantive (coverage debt — should be blueprinted):**
- `ιFree_matrixEnd` (line 966): row-expansion identity for `matrixEnd`; used twice in `matrixEnd_pullback`
- `pullbackBaseChangeTransport_matrixToFreeIso` (line 1543): the packaged (a)→(c) transport bridge for C2; docstring labels it `lem:gr_matrixToFreeIso_transport` but that label is absent from the chapter

**Helpers (acceptable; private or internal):**
- `scalarEnd_val_app`, `unitHomEquiv_scalarEnd`, `scalarEnd_val_app_one` — computational helpers for `scalarEnd`
- `hasFiniteBiproducts_modules` — instance declaration
- `biproduct_matrix_comp` (private) — helper for `matrixEnd_comp`
- `bundleMatrix_cancel` (private) — helper for `bundleTransition`
- `mul_submatrix_col'`, `map_nonsing_inv'`, `map_map_eq_of_comp'`, `isUnit_algebraMap_away_left'`, `inv_mul_inv_mul_cancel'`, `imageMatrix_map_eq'`, `cocycle_imageMatrix_eq'` (all private) — ports of private `GrassmannianCells` helpers for the matrix cocycle
- `unitToPushforward_scalarEnd_comm` — internal helper for `scalarEnd_pullback`

**Blueprinted but private in Lean:**
- `chartQuotientMap_ιFree` is `private lemma` in Lean but has its own `\lean{...}` and `\leanok` block in the blueprint (`lem:gr_chartQuotientMap_iFree`). Minor inconsistency; the blueprint can still reference a qualified private name.

---

## Blueprint adequacy for this file

- **Coverage**: 44/46 public Lean declarations (excluding purely private helpers and instance) have a corresponding `\lean{...}` block. The 2 uncovered substantive declarations are `ιFree_matrixEnd` and `pullbackBaseChangeTransport_matrixToFreeIso` (both new this iter, both fully proved).
- **Proof-sketch depth**: **adequate** for all proved declarations. The `lem:gr_matrixEnd_pullback` sketch correctly predicts the component-wise scalarEnd_pullback reduction. The `lem:gr_bundleCocycle_transport` and `lem:gr_baseChange_bridge` sketches are detailed and accurate but their Lean targets do not yet exist.
- **Hint precision**: **loose** in two places:
  - `lem:gr_baseChange_bridge` → `\lean{AlgebraicGeometry.Grassmannian.baseChange_bridge}` — the `\lean{}` pin is **wrong/phantom** (declaration does not exist; the planned decl may end up with a different name)
  - `lem:gr_bundleCocycle_transport` → `\lean{AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_transport}` — same issue
  These two are missing the `% NOTE: forward declaration (planned work); the \lean{} target is not yet realised.` annotation that the three `glueHom`/`glueRestrictionIso`/`glue_unique` entries correctly carry. Without the annotation a checker (human or automated) reading the blueprint expects the declarations to exist.
- **Generality**: matches need — no parallel API written to fill a generality gap
- **Recommended chapter-side actions**:
  - Add `\begin{lemma}\leanok [Row expansion of matrixEnd] \label{lem:gr_iFree_matrixEnd} \lean{AlgebraicGeometry.Grassmannian.ιFree_matrixEnd}...` (or promote to the prose of `lem:gr_matrixEnd_pullback`)
  - Add `\begin{lemma}\leanok [Transport of a matrix-automorphism transition through pullbackBaseChangeTransport] \label{lem:gr_matrixToFreeIso_transport} \lean{AlgebraicGeometry.Grassmannian.pullbackBaseChangeTransport_matrixToFreeIso}...`
  - Add `% NOTE: forward declaration (planned work); the \lean{} target is not yet realised.` to both `lem:gr_baseChange_bridge` (line 1095) and `lem:gr_bundleCocycle_transport` (line 1134)
  - Add `\leanok` to `\begin{lemma}[Triple-overlap endpoint bridges]` (`lem:gr_glueData_bridges`, blueprint line 151) — all three Lean targets are fully proved; `sync_leanok` appears to have missed this block (possibly because of the multi-name `\lean{..., ..., ...}` format)

---

## Severity summary

### Major

1. **Phantom blueprint entry — `lem:gr_baseChange_bridge`**: `\lean{AlgebraicGeometry.Grassmannian.baseChange_bridge}` pins a declaration that does not exist in the Lean file. No `% NOTE: forward declaration` annotation. Blueprint readers/tooling will expect the declaration to be real. *(blueprint side)*

2. **Phantom blueprint entry — `lem:gr_bundleCocycle_transport`**: `\lean{AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_transport}` pins a declaration that does not exist. No `% NOTE: forward declaration` annotation. Same issue. *(blueprint side)*

3. **Coverage debt — `ιFree_matrixEnd`**: Fully proved lemma (no sorry), used twice in the proof of `matrixEnd_pullback`, with no corresponding blueprint block. Substantive enough to warrant a blueprint entry. *(blueprint side)*

4. **Coverage debt — `pullbackBaseChangeTransport_matrixToFreeIso`**: Fully proved lemma (no sorry), the reusable (a)→(c) bridge for the C2 transport, with no corresponding blueprint block. The docstring labels it `lem:gr_matrixToFreeIso_transport` but that label is absent from the chapter. *(blueprint side)*

### Minor

5. Missing `\leanok` on `lem:gr_glueData_bridges` (blueprint line 151–188): all three Lean targets (`glueData_bridge_src`, `glueData_bridge_mid`, `glueData_bridge_tgt`) are fully proved; `sync_leanok` appears to have missed the multi-name block. *(blueprint side, sync_leanok oversight)*

6. `chartQuotientMap_ιFree` is declared `private` in Lean but has a public `\lean{}` + `\leanok` entry in the blueprint (`lem:gr_chartQuotientMap_iFree`). No correctness impact; minor convention mismatch.

---

**Overall verdict**: Lean-side is clean for all iter-063 deliverables — `matrixEnd_pullback` fully proved with matching signature and honest `\leanok`, the 4 sorry-bodies carry honest statement-only markers; the 2 coverage-debt items (`ιFree_matrixEnd`, `pullbackBaseChangeTransport_matrixToFreeIso`) and 2 phantom blueprint entries (`baseChange_bridge`, `bundleTransition_cocycle_transport`) are blueprint-side gaps requiring annotation fixes and new prose blocks.
