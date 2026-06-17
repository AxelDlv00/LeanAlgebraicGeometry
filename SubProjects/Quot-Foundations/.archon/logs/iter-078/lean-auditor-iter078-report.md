# Lean Audit Report

## Slug
iter078

## Iteration
078

## Scope
- files audited: 3
- files skipped (per directive): 0

Files:
- `AlgebraicJacobian/Picard/GlueDescent.lean` (2021 lines, read in full)
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean` (3941 lines, read in full)
- `AlgebraicJacobian/Picard/SectionGradedRing.lean` (1802 lines, read in full)

---

## Per-file checklist

### AlgebraicJacobian/Picard/GlueDescent.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (see notes)
- **excuse-comments**: none
- **notes**:
  - **L1431 — `glueChartFamily_equalizes` directly sorry.** Confirmed open. The surrounding comment (lines 1409–1430) documents the triple-overlap infrastructure gap concretely; this is not an excuse-comment but a genuine proof debt. The sorry is structurally sound (the surrounding `glueChartFamily` definition is correct; only the equalizing condition is missing).
  - **L1679 — `glueOverlapFactor_transpose` directly sorry.** Confirmed open. The proof reduces to a "site-level core" calculation (lines 1672–1678) that is a remaining step. The RHS unfolding (`hRHS`, lines 1630–1650), LHS bridge (`h_a`, lines 1655–1665), and naturality witnesses (`n₁`–`n₃`, lines 1666–1671) are all filled in without sorry; only the final assembly is open. The sorry is correctly placed.
  - **Transitive sorry chain from `glueOverlapFactor_transpose`:** the following 5 declarations are transitively sorry-backed:
    - `glueOverlapFactor_mate` (L1688): calls `glueOverlapFactor_transpose` as its terminal step (L1786)
    - `glueRestriction_overlap_compat` (L1792): calls `glueOverlapFactor_mate` (L1885)
    - `glueRestrictionHom_glueChartComponent` (L1872): calls `glueRestriction_overlap_compat` (L1884)
    - `isIso_glueRestrictionHom` (L1959): calls `glueRestrictionHom_glueChartComponent` (L1986) and `glueRestrictionInv_pullback_map_glueProj` (itself sorry-backed via `glueRestrictionInv` → `glueChartFamily_equalizes`)
    - `glueRestrictionIso` (L2000): wraps `isIso_glueRestrictionHom`
  - **Transitive sorry chain from `glueChartFamily_equalizes`:** `glueRestrictionInv` (L1436) directly depends on it; subsequent helpers that consume `glueRestrictionInv` inherit the debt.
  - **`Subsingleton.elim` usage at L236 and L1133:** both are for opens preorder morphisms where the subsingleton instance is mathematically correct (there is at most one morphism between opens in a site). Not suspect.
  - **`opensMap_final` at L236:** uses `Subsingleton.elim _ _` for `le_top` witnesses to establish the `Final` instance for the site functor of an open immersion. This is the intended proof strategy; no sheaf-axiom bypass.
  - **`congrArg`/`whisker_eq`/`eq_whisker` chains:** used pervasively as a workaround for `rw` failures under the `X.Modules` universe diamond. Legitimate; comments explain the reason each time. Not a bad practice per se.
  - **`glueChartComponent_self_counit` (L1510):** proved without sorry through a detailed calc chain. Non-trivial and correct (C1 + counit triangle). The proof of `isIso_glueRestrictionHom`'s `σ_i ≫ r_i = 𝟙` side at L1991–1993 depends on this and on `glueChartFamily_equalizes`-blocked helpers; only the first leg is unblocked.

---

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (see notes)
- **excuse-comments**: none
- **notes**:
  - **L2469 — `tautologicalQuotient_epi` directly sorry.** Confirmed open. The surrounding comment (lines 2456–2468) documents the proof route precisely: epi-ness is chart-local; the chart restrictions of the tautological quotient factor through `chartQuotientMap_epi`; the missing ingredient is a joint-reflection lemma (which shares its skeleton with `isIso_glueRestrictionHom` in GlueDescent). Genuine open problem, not a fake sorry body.
  - **L3217 — overlap compatibility in `grPointOfRankQuotient` directly sorry.** Confirmed open. The surrounding comment (lines 3201–3216) itemizes four remaining steps (toSpecΓ naturality, localization factoring, ring-hom comparison, and glue condition conclusion). The matrix heart `presentedMatrix_changeOfBasis` (proved, L3086) and `isUnit_of_isIso_matrixEndRect` (proved, L3165) are already in place. Genuine open problem.
  - **L3928 — `represents.left_inv` directly sorry.** Confirmed open. The comment (lines 3924–3927) describes the proof route (pullback matrix = ψ-image of universal matrix → glued morphism = ψ by uniqueness). Genuine open problem.
  - **L3931 — `represents.right_inv` directly sorry.** Confirmed open. The comment (lines 3929–3932) describes the proof route (chart restriction isos identify pullback with x chart-by-chart; overlap agreement → glue). Genuine open problem.
  - **Transitive sorry chain from `tautologicalQuotient_epi`:** `tautologicalRankQuotient` (L2475) depends on it via `epi := tautologicalQuotient_epi d r`. Further, `universalQuotient_isLocallyFreeOfRank` (L2434) depends on `universalQuotient_restrictionIso` (L2419) which calls `glueRestrictionIso` (from GlueDescent, transitively sorry). Both the `epi` and `locFree` fields of `tautologicalRankQuotient` are sorry-backed.
  - **`grPointOfRankQuotient_rel` (L3882): PROVED** — it correctly carries the overlap sorry through `chartMorphism_rel`. The proof of `grPointOfRankQuotient_rel` itself is complete and correct (modulo the sorry in `grPointOfRankQuotient`'s gluing step); it is not falsely clean.
  - **`represents.homEquiv_comp` (L3934–3939): PROVED** — the pseudofunctoriality law is fully discharged through `(functor d r).map_comp`. No sorry.
  - **Private lemma replication at L503–706:** seven GrassmannianCells private lemmas are reproduced with a prime suffix (`mul_submatrix_col'`, `map_nonsing_inv'`, `map_map_eq_of_comp'`, `isUnit_algebraMap_away_left'`, `inv_mul_inv_mul_cancel'`, `imageMatrix_map_eq'`, `cocycle_imageMatrix_eq'`). The comment explains these exist because the originals in GrassmannianCells.lean are private. This is a **code smell** (parallel private API) but structurally necessary given the current file boundary. The duplicates are literal copies, so they cannot introduce correctness divergence. Major issue; should be resolved by making originals non-private or by moving them to a shared module.
  - **`set_option maxHeartbeats 800000` / `1600000`** appears 11 times. These are performance annotations on complex proofs under the `X.Modules` diamond. Not a correctness issue; performance brittleness under future Mathlib updates is a minor concern.
  - **`bundleTransition_cocycle_transport` (L1643) and `bundleTransition_cocycle` (L1805):** both proved without sorry in this iter. The matrix cocycle chain (L1 in `bundleTransition_cocycle_matrix` → transport via `pullbackBaseChangeTransport_matrixToFreeIso` → endpoint alignment → Iso.ext) is complete. These are new iter-078 completions.
  - **`tautologicalQuotient_overlap` (L1872):** proved without sorry. Large proof, but all steps reduce to `matrixEndRect_pullback`, `universalMinorInv_mul_cancel`, and `Matrix.mul_assoc`. Correct.
  - **`chartLocus_isOpenCover` (L2632):** proved without sorry. Careful Nakayama argument: residue-field linear algebra (`exists_isUnit_submatrix`), basic-open construction, transport along `isoOpensRange`. Non-trivial, looks correct.
  - **`isIso_pullback_isoLocus_map` (L2866):** proved without sorry. Stalk-local argument using `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso` + `restrictStalkNatIso`. Correct proof structure.
  - **`presentedMatrix_changeOfBasis` (L3086):** proved without sorry. Matrix-algebra cancellation (8-factor chain). The associativity shuffle in term-mode (with comment explaining why positional `rw` fails) is legitimate.

---

### AlgebraicJacobian/Picard/SectionGradedRing.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`tensorObjAssoc` (L1609) and `tensorPowAdd` (L1785):** new iter-078 completions, both proved without sorry. `tensorObjAssoc` uses `isIso_sheafification_whiskerRight_unit` twice to compose the three-segment associator. `tensorPowAdd` uses `tensorObjAssoc` inductively. Both proofs are clean.
  - **`ztensor_whisker_localIso` (L1415):** proved without sorry. Large proof but well-structured (ULift ℤ bridging + `W.whiskerRight` closure).
  - **`ZTensorWhisker` private section (L993–1397):** the ULift ℤ machinery is all private. This is intentional (implementation detail for `ztensor_whisker_localIso`). No concern.
  - **Large handoff comment blocks (L685–970):** these document the boundary between what is built and what is left. Not excuse-comments — they document absence of declarations, not presence of wrong ones.
  - **Selective imports (not `import Mathlib`):** intentional; the file imports only specific Mathlib modules. This is good practice for compilation speed.
  - **`RelativeTensorCoequalizer` namespace (L287–430):** 22 declarations, all proved without sorry. The coequalizer presentation of the relative tensor product in AbGrp is complete.

---

## Verification of Named Sorries

Per the audit directive, verification that the 5 named sorries are genuinely open and not silently closed by unsound lemmas:

| Sorry | Location | Status | Notes |
|---|---|---|---|
| `glueChartFamily_equalizes` | GlueDescent.lean:1431 | **GENUINELY OPEN** | The proof ends with `sorry`; the surrounding `glueChartFamily` definition and `glueRestrictionInv` that consumes it are structurally sound but no lemma closes the gap. |
| `glueOverlapFactor_transpose` | GlueDescent.lean:1679 | **GENUINELY OPEN** | The proof of the mate core is partially filled; the terminal assembly step is `sorry`. No unsound lemma claims to close it. |
| `tautologicalQuotient_epi` | GrassmannianQuot.lean:2469 | **GENUINELY OPEN** | The declaration body is `sorry`. The joint-reflection lemma it needs does not appear anywhere in the three audited files. |
| `grPointOfRankQuotient` overlap | GrassmannianQuot.lean:3217 | **GENUINELY OPEN** | The overlap compatibility lambda body is `sorry`. `presentedMatrix_changeOfBasis` proves the matrix identity but the morphism-level gluing step is absent. |
| `represents.left_inv` / `right_inv` | GrassmannianQuot.lean:3928,3931 | **GENUINELY OPEN** | Both `left_inv` and `right_inv` are `sorry`. No circular use of these sorries was found (the homEquiv_comp proof does not depend on them). |

No sorry is silently closed by an unsound helper. All five are confirmed to require genuine mathematical work.

---

## Must-fix-this-iter

None. The audit found no:
- Excuse-comments
- Weakened or wrong definitions
- Parallel copies of Mathlib APIs with altered signatures
- Axioms on non-trivial claims not authorized in the strategy
- `sorry` bodies on declarations whose proof is falsely presented as complete

---

## Major

- `GrassmannianQuot.lean:503–706` — seven private lemmas replicated from `GrassmannianCells.lean` with prime-suffix names (`mul_submatrix_col'` etc.). This is structurally necessary given private access but creates maintenance risk: if the originals change, the copies drift silently. Resolution: make originals `internal` or non-private, or relocate them to a shared helper file.
- `GlueDescent.lean:1688–2017` — five lemmas (`glueOverlapFactor_mate`, `glueRestriction_overlap_compat`, `glueRestrictionHom_glueChartComponent`, `isIso_glueRestrictionHom`, `glueRestrictionIso`) are in a 5-level sorry chain from a single `sorry` (`glueOverlapFactor_transpose`). The chain length means `isIso_glueRestrictionHom` — the key effective-descent theorem — is inaccessible until the terminal step is proved. No structural error; but the depth should be flagged for the planner.
- `GrassmannianQuot.lean:2419–2480` — `universalQuotient_isLocallyFreeOfRank` and `tautologicalRankQuotient` both carry silent sorry chains (from GlueDescent's `glueRestrictionIso` and from `tautologicalQuotient_epi` respectively). They compile because the sorries are inside the evidence of `RankQuotient`, not the type. The plan agent should be aware the `represents` structure's forward direction (`toFun`) uses a sorry-backed `tautologicalRankQuotient`.

---

## Minor

- Multiple `set_option maxHeartbeats 800000`/`1600000` annotations in GrassmannianQuot.lean. Future Mathlib updates to `SheafOfModules` may shift these thresholds. Consider profiling periodically.
- The large term-mode proofs in GrassmannianQuot.lean (e.g., `tautologicalQuotient_overlap` at ~250 lines, `conjPullback_comp` at ~90 lines) are correct but hard to review and maintain. Not a priority issue.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: The three audited files are axiom-clean and sorry-honest. All 5 named sorries are genuinely open (none silently closed by unsound lemmas). The major findings are a 5-deep transitive sorry chain behind `isIso_glueRestrictionHom` (blocking effective descent), 4 direct sorries in GrassmannianQuot (the epi, overlap, and two inverse laws of `represents`), and a private-lemma replication anti-pattern. SectionGradedRing.lean is completely sorry-free and the iter-078 completions (`tensorObjAssoc`, `tensorPowAdd`, `bundleTransition_cocycle`, `tautologicalQuotient_overlap`, `chartLocus_isOpenCover`, `isIso_pullback_isoLocus_map`, `presentedMatrix_changeOfBasis`) are all structurally sound.
