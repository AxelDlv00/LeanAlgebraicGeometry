# Lean ↔ Blueprint Check Report

## Slug
grquot-iter062

## Iteration
062

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean` (1576 lines)
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (1627 lines)

---

## Per-declaration (iter-062 focus)

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_pullback}` (lem:gr_scalarEnd_pullback)

- **Lean target exists**: yes (line 933)
- **Signature matches**: yes
  - Blueprint: `q ∘ p*(scalarEnd(a)) = scalarEnd(p♯ a) ∘ q`, equivalently `(pullback p).map (scalarEnd a) ≫ q = q ≫ scalarEnd (p.appTop a)`.
  - Lean: exactly that, with `q = SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom p)`.
- **Proof follows sketch**: partial — blueprint says "conjugating back along `q` yields the identity via commutativity of the comorphism `p♯`"; Lean goes via adjunction-transposition (`homEquiv_naturality_left/right` + helper `unitToPushforward_scalarEnd_comm`) then `hnat` naturality. Mathematical content matches; the adjunction-transposition route is not reflected in the blueprint sketch.
- **notes**: CLOSED (no sorry). Statement-block `\leanok` present ✓. Proof-block `\leanok` absent — see minor flag below.

---

### `\lean{AlgebraicGeometry.Grassmannian.matrixEnd_pullback}` (lem:gr_matrixEnd_pullback)

- **Lean target exists**: yes (line 965)
- **Signature matches**: yes
  - Blueprint: `p*(matrixEnd(M)) = Q⁻¹ ∘ matrixEnd(p♯M) ∘ Q` (i.e., `Q.hom ≫ matrixEnd(p♯.mapMatrix M) ≫ Q.inv` in Lean left-to-right notation, where `Q = pullbackFreeIso p (Fin d)`).
  - Lean: exactly `(pullback p).map (matrixEnd M) = (pullbackFreeIso p (Fin d)).hom ≫ matrixEnd ((CommRingCat.Hom.hom (Scheme.Hom.appTop p)).mapMatrix M) ≫ (pullbackFreeIso p (Fin d)).inv`.
- **Proof follows sketch**: N/A — proof is `sorry` (body not yet closed).
- **notes**: Still `sorry` at line 981. Statement-block `\leanok` present ✓ (correct per sync semantics: declaration formalized with at least a sorry). No proof-block `\leanok` ✓ (correct — body is open). The sorry comment (lines 972–981) documents exactly the remaining work: distribute `(pullback p)` over the biproduct, apply `scalarEnd_pullback` entry-by-entry, use cofan extensionality. Not laundering.

---

### Helper: `unitToPushforward_scalarEnd_comm` (no blueprint entry)

- **Lean target exists**: yes (line 892)
- **Blueprint pin**: none — this is a project-local helper introduced to factor the proof of `scalarEnd_pullback`.
- **Signature**: `scalarEnd a ≫ unitToPushforwardObjUnit φ = unitToPushforwardObjUnit φ ≫ (pushforward p).map (scalarEnd (p.appTop a))` — the pushforward side of the naturality square, used via adjunction transposition in `scalarEnd_pullback`.
- **Proof follows sketch**: N/A — no blueprint entry.
- **notes**: CLOSED (no sorry). Acceptable helper with no blueprint obligation. Blueprint section `lem:gr_scalarEnd_pullback` covers this implicitly ("the verification is a single computation on the unit module"). Could optionally be promoted to a `% NOTE:` annotation in the blueprint proof.

---

## Earlier closed declarations (spot-check for completeness)

All previously-closed `\lean{...}` entries remain intact and unmodified this iter. Spot-checked 10 representative pins:

| Blueprint label | Lean declaration | Status |
|---|---|---|
| `lem:gr_bundleCocycle_matrix` | `bundleTransition_cocycle_matrix` | ✓ closed, `\leanok` stmt ✓ |
| `lem:gr_matrixToFreeIso_mul` | `matrixToFreeIso_mul` | ✓ closed |
| `def:scheme_modules_glue` | `Scheme.Modules.glue` | ✓ closed, `\leanok` stmt ✓ |
| `lem:gr_bundleCocycle_id` | `bundleTransition_self` | ✓ closed, `\leanok` stmt ✓ |
| `lem:gr_pullbackFreeIso_comp` | `pullbackFreeIso_comp` | ✓ closed |
| `def:grassmannian_functor` | `functor` | ✓ closed (map_id/map_comp proven) |
| `lem:gr_bundleCocycle_mul` | `bundleTransition_cocycle` | sorry body, stmt `\leanok` ✓, no proof `\leanok` ✓ |
| `def:gr_universal_quotient_sheaf` | `universalQuotient` | sorry body, stmt `\leanok` ✓ |
| `def:tautological_quotient` | `tautologicalQuotient` | sorry body, stmt `\leanok` ✓ |
| `thm:grassmannian_universal_property` | `represents` | sorry body, stmt `\leanok` ✓ |

---

## Forward-declaration pins (no Lean realization yet)

Two blueprint blocks carry `\lean{...}` pins but no corresponding Lean declaration exists yet. Neither block has `\leanok`, so they are correctly marked unformalized:

| Blueprint label | Pinned Lean decl | `\leanok`? |
|---|---|---|
| `lem:gr_baseChange_bridge` | `baseChange_bridge` | none — correctly unformalized |
| `lem:gr_bundleCocycle_transport` | `bundleTransition_cocycle_transport` | none — correctly unformalized |

These are forward work items for the C2 chain (needed upstream of `bundleTransition_cocycle`). The `\lean{...}` pins are dangling but harmless since both blocks lack `\leanok`.

Similarly, `def:gr_modules_glueRestrictionIso`, `lem:gr_modules_glue_unique`, `def:gr_modules_glueHom` also have dangling `\lean{...}` pins with `% NOTE: forward declaration` comments — consistent, acceptable.

---

## Red flags

### Placeholder / suspect bodies
None. All `sorry`-bodied declarations carry only statement-block `\leanok` (managed by `sync_leanok`), not proof-block `\leanok`. No laundering.

### Excuse-comments
None. The `sorry` comment blocks in `matrixEnd_pullback` (lines 972–981) and `bundleTransition_cocycle` (lines 1015–1048) are legitimate engineering roadmaps (documenting the remaining work in detail), not excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims
None found.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` blueprint entry. All are low-level helpers or private lemmas; none represent substantive omissions:

- `scalarEnd_val_app` (line 80), `unitHomEquiv_scalarEnd` (86), `scalarEnd_val_app_one` (91): computational lemmas for `scalarEnd`; the blueprint covers the ring-hom identities at the `def:gr_scalarEnd` level.
- `hasFiniteBiproducts_modules` (141): instance, infrastructure.
- `biproduct_matrix_comp` (156): private helper for `matrixEnd_comp`.
- `bundleMatrix_cancel` (566): private helper for `bundleTransition`.
- `mul_submatrix_col'`, `map_nonsing_inv'`, `map_map_eq_of_comp'`, `isUnit_algebraMap_away_left'`, `inv_mul_inv_mul_cancel'`, `imageMatrix_map_eq'`, `cocycle_imageMatrix_eq'` (lines 675–808): private ports of private GrassmannianCells lemmas; the blueprint references the public `lem:gr_cocycle_imageMatrix_eq` (the originals).
- **`unitToPushforward_scalarEnd_comm`** (892): new this iter; helper for `scalarEnd_pullback`. No blueprint entry expected for a proof-internal helper.
- `chartQuotientMap_ιFree` (252): private lemma, but IS pinned via `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` at `lem:gr_chartQuotientMap_iFree` ✓.

---

## Blueprint adequacy for this file

- **Coverage**: ~48 distinct Lean declarations pinned by `\lean{...}` entries. Unreferenced: ~19 declarations (all helpers/private/ports — see above). 0 substantive unreferenced declarations.

- **Proof-sketch depth**: **adequate** for `scalarEnd_pullback` (the sketch correctly identifies the mathematical content — commutativity of `scalarEnd` with the pullback comparison via the comorphism); **adequate** for `matrixEnd_pullback` (the sketch correctly identifies the entry-by-entry reduction to `scalarEnd_pullback` and the biproduct reassembly). Both sketches omit the Lean-specific adjunction-transposition route and the `X.Modules` diamond engineering, which is acceptable — those are implementation choices, not mathematical content gaps. No sketch is so thin it could not have guided the formalization.

- **Hint precision**: **precise** for all new iter-062 decls. The pin `AlgebraicGeometry.Grassmannian.scalarEnd_pullback` resolves correctly. Minor note: `lem:gr_scalarEnd_pullback` describes `q` as "the unit-pullback comparison (`lem:gr_pullbackFreeIso` at a one-element index)" and lists `\uses{..., lem:gr_pullbackFreeIso, ...}`; the Lean proof uses the more primitive `pullbackObjUnitToUnit` directly (not via `pullbackFreeIso`). These are equivalent but the `\uses` credit is slightly imprecise — harmless, not misleading.

- **Generality**: matches need — universe `{0}` constraint on `scalarEnd_pullback` / `matrixEnd_pullback` is consistent with the rest of the Grassmannian constructions in the file.

- **Recommended chapter-side actions**:
  1. (Minor) Add a `% NOTE:` annotation in `lem:gr_scalarEnd_pullback`'s proof sketch that the Lean proof factors through `unitToPushforward_scalarEnd_comm` (the pushforward transpose) and adjunction hom-equivalence naturality — this would help a future prover close `matrixEnd_pullback` using the same pattern.
  2. (Informational) The two dangling pins `baseChange_bridge` and `bundleTransition_cocycle_transport` are legitimate future work items; no blueprint change needed for them.

---

## Severity summary

- **must-fix-this-iter**: 0

- **major**: 0 (the dangling `\lean{}` pins for `baseChange_bridge` / `bundleTransition_cocycle_transport` are correctly unformalized with no `\leanok`; not blocking)

- **minor** (2):
  1. **Proof-block `\leanok` absent for `scalarEnd_pullback`**: `scalarEnd_pullback` is fully closed (no sorry), but the blueprint proof block for `lem:gr_scalarEnd_pullback` does not yet carry `\leanok`. This is a sync gap — `sync_leanok` should add it on the next run.
  2. **Blueprint `\uses` imprecision**: `lem:gr_scalarEnd_pullback` credits `lem:gr_pullbackFreeIso` in `\uses` but the Lean proof relies on the lower-level `pullbackObjUnitToUnit` directly. Harmless but the `\uses` DAG slightly overstates the dependency.

**Overall verdict**: All iter-062 work is correctly reflected. `scalarEnd_pullback` is closed and properly marked; `matrixEnd_pullback` has a sorry and is NOT laundering (statement-only `\leanok`, no proof-block `\leanok`). No red flags, no must-fix items.
