# Lean ↔ Blueprint Check Report

## Slug
gr

## Iteration
035

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianCells.tex`

---

## Per-declaration

All ~68 `\lean{...}` blocks in the chapter were checked against the Lean file. The findings below cover every block with a notable result; blocks that match cleanly are not listed individually.

### `\lean{AlgebraicGeometry.Grassmannian.isProper}` (chapter: `lem:gr_proper`)
- **Lean target exists**: no — the declaration `AlgebraicGeometry.Grassmannian.isProper` does not appear anywhere in the Lean file. The closest landed declarations are `isProper_of_valuativeExistence` (a conditional reduction theorem, L1531) and the properness-ingredient helpers (L1443–1537).
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A
- **notes**: The `lem:gr_proper` block in the blueprint has NO `\leanok` on either the statement or proof block — this correctly signals the declaration is not yet formalized. There is no false `\leanok` claim. The blueprint proof body contains the full Nitsure existence argument (chart selection → E2 minimal valuation, E1 chart factorization via `g(X^J) = f((X^I_J)^{-1} X^I)`, E3 minor-ratio bound, E4 entry-valuation → factors through R). The existence decomposition is present in the blueprint prose. **This is the expected in-progress state; no correctness violation.**

### `\lean{AlgebraicGeometry.Grassmannian.mul_submatrix_col}` (chapter: `lem:gr_mul_submatrix_col`)
- **Lean target exists**: technically no under the public qualified name — the Lean declaration at L165 is `private lemma mul_submatrix_col`. Private declarations in Lean 4 receive mangled internal names; `#check AlgebraicGeometry.Grassmannian.mul_submatrix_col` fails from outside the file.
- **Signature matches**: yes (mathematical content matches the blueprint prose exactly)
- **Proof follows sketch**: yes
- **notes**: `\leanok` is present on both statement and proof blocks — sync_leanok must resolve these via internal lookup. This private-vs-public mismatch pattern appears on 9 blueprint blocks (see Red flags below). Minor naming issue only; mathematical content is correct.

(The same private/public mismatch applies to the following 8 `\lean{}` pins. All are confirmed to have matching private declarations in the Lean file with genuine proofs.)

| Blueprint label | `\lean{}` target | Lean declaration | Visibility |
|---|---|---|---|
| `lem:gr_mul_submatrix_col` | `...mul_submatrix_col` | L165 | `private` |
| `lem:gr_map_nonsing_inv` | `...map_nonsing_inv` | L300 | `private` |
| `lem:gr_map_map_eq_of_comp` | `...map_map_eq_of_comp` | L479 | `private` |
| `lem:gr_inv_mul_inv_mul_cancel` | `...inv_mul_inv_mul_cancel` | L514 | `private` |
| `lem:gr_isUnit_algebraMap_away_left` | `...isUnit_algebraMap_away_left` | L402 | `private` |
| `lem:gr_isUnit_algebraMap_away_right` | `...isUnit_algebraMap_away_right` | L412 | `private` |
| `lem:gr_isUnit_incl_transitionPreMap_cross` | `...isUnit_incl_transitionPreMap_cross` | L366 | `private` |
| `lem:gr_imageMatrix_map_eq` | `...imageMatrix_map_eq` | L487 | `private` |
| `lem:gr_cocycle_imageMatrix_eq` | `...cocycle_imageMatrix_eq` | L524 | `private` |

All remaining `\lean{}` blocks (approximately 58) have matching public Lean declarations with correct signatures and no sorries. All are omitted from per-declaration listing as they pass cleanly.

---

## Red flags

### Placeholder / suspect bodies
None. No `:= sorry`, `:= True`, `:= Classical.choice _`, or vacuous bodies found anywhere in the 1540-line file.

### Excuse-comments
None. No `-- TODO replace with real def`, `-- temporary`, `-- placeholder`, `-- wrong but works for now` comments found.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations found. All classical reasoning passes through Mathlib's standard `Classical.choice` (propext, Quot.sound), which the blueprint does not forbid.

### Private declaration / `\lean{}` pin mismatch
Nine blueprint blocks carry `\lean{AlgebraicGeometry.Grassmannian.<name>}` pins pointing to Lean declarations that are `private`. The external qualified name is inaccessible via `#check` outside the file. Since all `\leanok` markers appear to have been placed by `sync_leanok` (and the private declarations do have genuine non-sorry proofs), this is a naming discipline issue rather than a mathematical correctness failure.

**Severity: minor** — no incorrect mathematics; affects external discoverability only.

---

## Unreferenced declarations (informational)

The following 7 declarations in the Lean file have no corresponding `\lean{...}` blueprint block:

| Declaration | Line | Type | Nature |
|---|---|---|---|
| `compactSpace_scheme` | L1443 | `instance` | Properness ingredient: `CompactSpace (scheme d r)` |
| `quasiCompact_toSpecZ` | L1454 | `theorem` | Properness ingredient: `QuasiCompact (toSpecZ d r)` |
| `locallyOfFiniteType_toSpecZ` | L1462 | `theorem` | Properness ingredient: `LocallyOfFiniteType (toSpecZ d r)` |
| `quasiSeparated_toSpecZ` | L1474 | `theorem` | Properness ingredient: `QuasiSeparated (toSpecZ d r)` |
| `valuativeUniqueness_toSpecZ` | L1482 | `theorem` | Properness ingredient: `ValuativeCriterion.Uniqueness (toSpecZ d r)` |
| `transitionPreMap_minorDet_mul` | L1495 | `theorem` | Algebraic core of the valuative existence: minor-ratio identity `θ̃(P^J_{K'}) · P^I_J = P^I_{K'}` |
| `isProper_of_valuativeExistence` | L1531 | `theorem` | Keystone reduction: `ValuativeCriterion.Existence → IsProper (toSpecZ d r)` |

Additionally, several private helpers (`rotMid` L944, `transitionInvImageMatrix` L961, `transitionInvPair` L1026) are architectural intermediates with no blueprint blocks — these are explicitly internal and acceptable as unlisted helpers.

The 7 substantive entries above all live in the properness scaffold section (L1422–1539) under the `sec:gr_proper` section header of the blueprint. That section currently contains only `lem:gr_proper` with no supporting blocks for any of these 7 helpers.

**All 7 need blueprint blocks under `sec:gr_proper`.**

---

## Blueprint adequacy for this file

- **Coverage**: 68/75 public Lean declarations have a corresponding `\lean{...}` block (7 missing, all in the properness scaffold; the 9 private-decl mismatches are present but technically broken as external names). The 7 missing declarations are substantive, not helpers.

- **Proof-sketch depth**: **under-specified** for `sec:gr_proper`. The section currently provides:
  - `lem:gr_proper` with a complete informal proof of properness including the full Nitsure existence argument — adequate for a future prover who works on `isProper` itself.
  - Zero blueprint guidance for the 7 intermediate declarations that were already formalized this iteration.
  The complete absence of blocks for the 7 properness helpers means the chapter cannot be used to guide or verify those specific proofs from the blueprint alone.

- **Hint precision**: **precise** for all `\lean{...}`-pinned blocks that point to public declarations. The 9 private-declaration pins are loose in the sense that the names are inaccessible externally.

- **Generality**: **matches need** — no evidence of under-generalisation.

- **Recommended chapter-side actions for `sec:gr_proper`**:
  1. Add a blueprint block for `compactSpace_scheme` (instance that compactness follows from finite open cover).
  2. Add a blueprint block for `quasiCompact_toSpecZ` (quasi-compactness from `CompactSpace` + affine target).
  3. Add a blueprint block for `locallyOfFiniteType_toSpecZ` (locally of finite type on each chart, since `ℤ → R^I` is of finite type).
  4. Add a blueprint block for `quasiSeparated_toSpecZ` (free from `isSeparatedToSpecZ` via `IsSeparated → QuasiSeparated`).
  5. Add a blueprint block for `valuativeUniqueness_toSpecZ` (uniqueness half of valuative criterion is free from separatedness via `IsSeparated.valuativeCriterion`).
  6. Add a blueprint block for `transitionPreMap_minorDet_mul` (the minor-ratio algebraic identity `θ̃_{I,J}(P^J_{K'}) · P^I_J = P^I_{K'}`; this is the algebraic core of the E2/E3 valuative-existence argument).
  7. Add a blueprint block for `isProper_of_valuativeExistence` (the properness reduction theorem: three cheap ingredients + uniqueness already discharged → properness iff existence holds).
  8. For all 9 private-declaration pins, consider either making the declarations non-private (preferred) or adding a `% NOTE: private` annotation in the blueprint to signal the naming limitation.

---

## Severity summary

| Finding | Severity |
|---|---|
| 7 properness declarations entirely absent from blueprint (`sec:gr_proper`) | **major** |
| `lem:gr_proper` pins `\lean{AlgebraicGeometry.Grassmannian.isProper}` (non-existent) | **informational** — no false `\leanok`, correctly marks unformalized future target |
| 9 blueprint `\lean{}` pins target `private` declarations (inaccessible external name) | **minor** |
| No sorries, no fake proofs, no axioms, no excuse-comments | — |

**Overall verdict**: The Lean file is axiom-clean and mathematically faithful; the primary gap is blueprint coverage debt — the 7 properness scaffold declarations newly landed this iteration have no blueprint blocks, leaving `sec:gr_proper` with only the keystone `lem:gr_proper` block and no supporting material.
