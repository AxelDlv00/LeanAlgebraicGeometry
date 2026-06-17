# Lean ↔ Blueprint Check Report

## Slug
grquot-iter061

## Iteration
061

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex`

---

## Per-declaration (iter-061 focused items)

### `\lean{Grassmannian.matrixToFreeIso_mul}` (lem:gr_matrixToFreeIso_mul) — **L2, newly closed**
- **Lean target exists**: yes (`AlgebraicGeometry.Grassmannian.matrixToFreeIso_mul`, line 219)
- **Signature matches**: yes. Blueprint: "forward maps of matrixToFreeIso(A,A') and matrixToFreeIso(B,B') compose to matrixEnd(B·A)." Lean: `(matrixToFreeIso A A' _ _).hom ≫ (matrixToFreeIso B B' _ _).hom = matrixEnd (B * A)`. Faithful.
- **Proof follows sketch**: yes. Blueprint: "by lem:gr_matrixToFreeIso_hom the maps are matrixEnd(A), matrixEnd(B); their composite is matrixEnd(B·A) by lem:gr_matrixEnd_comp." Lean: `rw [matrixToFreeIso_hom, matrixToFreeIso_hom, matrixEnd_comp]` — exact one-liner match.
- **notes**: axiom-clean, no sorry.

### `\lean{Grassmannian.bundleTransition_cocycle_matrix}` (lem:gr_bundleCocycle_matrix) — **L1, newly closed**
- **Lean target exists**: yes (`AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_matrix`, line 816)
- **Signature matches**: yes. Blueprint: "$(X^J_K)^{-1}(X^I_J)^{-1} = (X^I_K)^{-1}$ over the triple-overlap ring $S_I$". Lean: product of `universalMinorInv J K` (base-changed via `cocycleΘIJ ∘ awayInclRight`) times `universalMinorInv I J` (via `awayInclLeft`) equals `universalMinorInv I K` (via `awayInclRight`) — faithful matrix-algebra encoding of the blueprint statement.
- **Proof follows sketch**: yes. Blueprint: "take the I-minor of the image-matrix cocycle; split off the inverse factor via mul_submatrix_col; apply inv_mul_inv_mul_cancel." Lean: applies `cocycle_imageMatrix_eq'` (port of the GrassmannianCells cocycle), then `imageMatrix_submatrix_I` and `hsplit` to match the blueprint's rewriting chain exactly.
- **notes**: axiom-clean, no sorry. The proof privately re-ports 7 GrassmannianCells helpers (see §Unreferenced declarations).

### `\lean{Grassmannian.bundleTransition_cocycle_transport}` (lem:gr_bundleCocycle_transport) — **L3, blueprint-only**
- **Lean target exists**: **no** — `bundleTransition_cocycle_transport` is absent from the Lean file.
- **Signature matches**: N/A (decl absent).
- **Proof follows sketch**: N/A.
- **notes**: Blueprint correctly has **no `\leanok`** on this block; it is a forward-planning declaration. The `\lean{...}` pin is an acknowledged placeholder for iter-062 work (matrixEnd-under-pullback naturality step). Not a false claim, but a pin pointing at an absent decl.

### `\lean{Grassmannian.bundleTransition_cocycle}` (lem:gr_bundleCocycle_mul) — **C2, still sorry**
- **Lean target exists**: yes (`AlgebraicGeometry.Grassmannian.bundleTransition_cocycle`, line 891)
- **Signature matches**: yes. The Lean signature is exactly the `_hC2` hypothesis of `Scheme.Modules.glue` instantiated at `theGlueData d r` and `bundleTransitionData`.
- **Proof follows sketch**: **no** — proof body is `sorry` (line 945). The comment in the Lean file describes the missing L3 step (matrixEnd-under-pullback naturality + base-change bridge), but no proof is given.
- **notes**: **MUST-FIX** — blueprint `lem:gr_bundleCocycle_mul` carries `\leanok` but the Lean body is `:= sorry`. Blueprint is making a false claim about proof status.

---

## Per-declaration (other blueprint-referenced items)

### Declarations correctly marked as proved (spot-check)
- `bundleTransition_self` (C1): proved ✅
- `bundleTransition`, `bundleTransitionData`: proved ✅
- `glue` (equalizer construction): proved ✅
- `pullbackFreeIso`, `pullbackFreeIso_eqToHom`, `pullbackFreeIso_trans_symm_eqToIso`: proved ✅
- `pullback_isLocallyFreeOfRank`: proved ✅
- `pullbackBaseChangeTransport`, `glueData_bridge_src/mid/tgt`: proved ✅
- `matrixEnd`, `matrixEnd_comp`, `matrixEnd_one`, `matrixToFreeIso`, `matrixToFreeIso_hom`: proved ✅
- `chartQuotientMap`, `chartQuotientMap_epi`: proved ✅
- All scalarEnd-family decls: proved ✅
- `pullbackObjUnitToUnit_id/comp`, `pullbackFreeIso_id/comp`, `homEquiv_conjugateEquiv_app`: proved ✅
- `functor` (map_id, map_comp): proved ✅
- `RankQuotient`, `Rel`, `rel_refl/symm/trans`, `rqSetoid`, `rqPullback`, `rqPullback_rel`: proved ✅

### Declarations with `\leanok` in blueprint but `:= sorry` in Lean (pre-existing gaps, downstream of C2)
- **`universalQuotient`** (def:gr_universal_quotient_sheaf, blueprint has `\leanok`, Lean line 964: `sorry`): **MUST-FIX** (pre-existing; gated on C2).
- **`tautologicalQuotient`** (def:tautological_quotient, blueprint has `\leanok`, Lean line 974: `sorry`): **MUST-FIX** (pre-existing; gated on C2 via universalQuotient).
- **`represents`** (thm:grassmannian_universal_property, blueprint has `\leanok`, Lean line 1468: `sorry`): **MUST-FIX** (pre-existing; gated on tautologicalQuotient).

Note: all three have NOTE-comments in the Lean file accurately describing the sorry as pending the bundle cocycle; per the checker rules these are excuse-comments, making the must-fix classification mandatory. All three will be resolved once C2 is closed.

### Blueprint decls with no `\leanok` whose Lean targets are fully proved
- `def:gr_rankQuotient` (covering `RankQuotient`, `Rel`, `rel_refl/symm/trans`, `rqSetoid`, `rqPullback`, `rqPullback_rel`): all 8 Lean targets are proved but the blueprint block has no `\leanok` — **minor** blueprint adequacy issue (stale non-acknowledgement).

### Forward-declared blueprint targets with no `\leanok` and no Lean decl (correctly pending)
- `glueRestrictionIso`, `glue_unique`, `glueHom`: blueprint blocks explicitly note "forward declaration (planned work); the `\lean{}` target is not yet realised." All correctly lack `\leanok`. Informational only.

---

## Red flags

### Placeholder / suspect bodies
- `bundleTransition_cocycle` (line 945): `:= sorry`. Blueprint `lem:gr_bundleCocycle_mul` claims `\leanok`. **MUST-FIX.**
- `universalQuotient` (line 965): `:= sorry`. Blueprint `def:gr_universal_quotient_sheaf` claims `\leanok`. **MUST-FIX** (pre-existing, gated on C2).
- `tautologicalQuotient` (line 976): `:= sorry`. Blueprint `def:tautological_quotient` claims `\leanok`. **MUST-FIX** (pre-existing, gated on C2).
- `represents` (line 1470): `:= sorry`. Blueprint `thm:grassmannian_universal_property` claims `\leanok`. **MUST-FIX** (pre-existing, gated on C2).

### Excuse-comments
- `GrassmannianQuot.lean:949–945`: comment `NOTE (scaffold): the body is the remaining hard step...` on `bundleTransition_cocycle` — describes and excuses the sorry; blueprint claims `\leanok`.
- `GrassmannianQuot.lean:953–963`: comment `NOTE: Scheme.Modules.glue has landed... The remaining obligation is the GL_d bundle transition cocycle...` on `universalQuotient` — excuse-comment for sorry; blueprint claims `\leanok`.
- `GrassmannianQuot.lean:967–976`: comment `NOTE: rides on universalQuotient (hence on the bundle cocycle, the only remaining gap...)` on `tautologicalQuotient` — excuse-comment; blueprint claims `\leanok`.
- `GrassmannianQuot.lean:1459–1470`: comment `NOTE: functor and Scheme.Modules.glue have landed; this rides on tautologicalQuotient...` on `represents` — excuse-comment; blueprint claims `\leanok`.

### Axioms / Classical.choice on non-trivial claims
None detected. All proved declarations appear axiom-clean (consistent with the iter-061 prover report).

---

## Unreferenced declarations (informational)

The following Lean declarations have no `\lean{...}` reference in the blueprint chapter. All are helpers or infrastructure; none suggests a missing blueprint block.

**Private helpers (expected, no coverage needed):**
- `biproduct_matrix_comp` (line 156): private helper for `matrixEnd_comp`
- `bundleMatrix_cancel` (line 566): private helper providing the GL_d invertibility hypotheses for `bundleTransition`

**7 private ports of GrassmannianCells helpers (coverage debt — see below):**
- `mul_submatrix_col'` (line 675)
- `map_nonsing_inv'` (line 681)
- `map_map_eq_of_comp'` (line 688)
- `isUnit_algebraMap_away_left'` (line 695)
- `inv_mul_inv_mul_cancel'` (line 703)
- `imageMatrix_map_eq'` (line 711)
- `cocycle_imageMatrix_eq'` (line 739)

**Non-private helpers without blueprint blocks (acceptable):**
- `scalarEnd_val_app` (line 80): computational evaluation lemma, used internally
- `unitHomEquiv_scalarEnd` (line 86): adjunction round-trip lemma
- `scalarEnd_val_app_one` (line 91): unit-section specialisation
- `hasFiniteBiproducts_modules` instance (line 141): typeclass instance
- `pullbackFreeIso_eqToHom` is referenced ✅; `pullbackFreeIso_trans_symm_eqToIso` is referenced ✅

**Note on `chartQuotientMap_ιFree`**: this is `private` in Lean (line 252) but the blueprint does reference it via `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` in `lem:gr_chartQuotientMap_iFree`. Minor inconsistency (`private` decl referenced from blueprint), but not harmful — the declaration is proved.

---

## Blueprint adequacy for this file

- **Coverage**: 37 of approximately 44 non-private Lean declarations have a corresponding `\lean{...}` block. The 7 unreferenced non-private items are all internal helpers acceptably outside the blueprint's scope. The 7 `'`-private port helpers (introduced this iter for L1) are the only substantive coverage gap.
- **Proof-sketch depth**: **adequate** for L1/L2 items proved this iter. Both `lem:gr_bundleCocycle_matrix` and `lem:gr_matrixToFreeIso_mul` have detailed enough proof sketches that the Lean proofs are a faithful formalization. The L3 (`lem:gr_bundleCocycle_transport`) sketch is detailed and correct as a blueprint for the pending step.
- **Hint precision**: **precise** for L1/L2. Signatures and Lean names align exactly.
- **Generality**: **matches need** for proved items.
- **Stale `\leanok` markings (must-fix)**: `lem:gr_bundleCocycle_mul`, `def:gr_universal_quotient_sheaf`, `def:tautological_quotient`, `thm:grassmannian_universal_property` all have `\leanok` but their Lean targets carry `sorry`. These four blueprint blocks must have `\leanok` removed (or the sorry closed) before the chapter's proof-status tracking is accurate.
- **Missing `\leanok` on proved items (minor)**: `def:gr_rankQuotient` block covers 8 fully-proved Lean declarations but has no `\leanok`.

**Recommended chapter-side actions:**
1. Remove `\leanok` from `lem:gr_bundleCocycle_mul` until `bundleTransition_cocycle` is closed (OR close C2 this iter and keep `\leanok`).
2. Remove `\leanok` from `def:gr_universal_quotient_sheaf`, `def:tautological_quotient`, `thm:grassmannian_universal_property` until their sorries are resolved (they will be resolved automatically once C2 is closed and these are filled in).
3. Add `\leanok` to `def:gr_rankQuotient` (all 8 referenced declarations are proved).
4. Add a brief `\lean{...}` note (or expand the comment at the proof of `lem:gr_bundleCocycle_matrix`) acknowledging the 7 private ports; alternatively add an editorial note in the L1 proof paragraph that the image-matrix lemmas are re-ported locally from GrassmannianCells.

---

## Severity summary

| Finding | Severity |
|---|---|
| `bundleTransition_cocycle` has `:= sorry` but blueprint `lem:gr_bundleCocycle_mul` has `\leanok` | **must-fix-this-iter** |
| `universalQuotient` has `:= sorry` but blueprint `def:gr_universal_quotient_sheaf` has `\leanok` | **must-fix-this-iter** (pre-existing; gated on C2) |
| `tautologicalQuotient` has `:= sorry` but blueprint `def:tautological_quotient` has `\leanok` | **must-fix-this-iter** (pre-existing; gated on C2) |
| `represents` has `:= sorry` but blueprint `thm:grassmannian_universal_property` has `\leanok` | **must-fix-this-iter** (pre-existing; gated on C2) |
| `lem:gr_bundleCocycle_transport` `\lean{...}` pin points at absent decl `bundleTransition_cocycle_transport` | **minor** (correctly has no `\leanok`; expected forward planning) |
| 7 private `'`-suffix port helpers absent from blueprint | **minor** (all private; coverage debt) |
| `def:gr_rankQuotient` block missing `\leanok` despite 8 proved Lean targets | **minor** (stale non-acknowledgement) |

**Overall verdict**: L1 (`bundleTransition_cocycle_matrix`) and L2 (`matrixToFreeIso_mul`) are axiom-clean and faithfully match their blueprint blocks; the primary gate-blocking finding is the `\leanok`/sorry mismatch on C2 (`bundleTransition_cocycle`) and its three downstream declarations, all of which carry pre-existing excuse-commented sorries that will resolve once C2 is closed — the blueprint must remove `\leanok` from those four blocks until closure.
