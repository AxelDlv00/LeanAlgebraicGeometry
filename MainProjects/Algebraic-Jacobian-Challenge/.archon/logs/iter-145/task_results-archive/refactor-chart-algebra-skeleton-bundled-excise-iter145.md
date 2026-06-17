# Refactor Report

## Slug

chart-algebra-skeleton-bundled-excise-iter145

## Status

COMPLETE

Both parts of the directive landed in a single coordinated pass and the
project builds clean (no errors). Final project sorry inventory exactly
matches the directive prediction: **8 declarations using `sorry` /
8 inline `sorry`s** (5 in the new `ChartAlgebra.lean`, 2 in
`Jacobian.lean`, 1 in `RigidityKbar.lean`).

## Directive (excerpt)

Two-part refactor:
1. Excise three bundled-route sorry-bodied declarations from
   `AlgebraicJacobian/Cotangent/GrpObj.lean`
   (`basechange_along_proj_two_inv_derivation`,
   `basechange_along_proj_two_inv_app_isIso`,
   `mulRight_globalises_cotangent`); chase up dependency cascades when
   excise breaks a downstream consumer.
2. Create the 5-piece chart-algebra skeleton
   `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (`: True := sorry`
   placeholders per the directive's pre-committed names) and wire it
   into `AlgebraicJacobian.lean`.

Preserve the piece (i.a) trio `cotangentSpaceAtIdentity*`; do not
auto-delete orphans; do not touch blueprint / `STRATEGY.md` /
`archon-protected.yaml`.

## Changes Made

### File: `AlgebraicJacobian/Cotangent/GrpObj.lean`

**Excised declarations (5 total: 3 directly named + 2 cascade-chained):**

| # | Decl | Approx LOC before | Excise reason |
|---|------|-------------------|---------------|
| 1 | `basechange_along_proj_two_inv_derivation` | ~149 LOC (L552–L700 inclusive of doc) | Directive target #1 — internal `d_app` sub-sorry at the body's tail. |
| 2 | `basechange_along_proj_two_inv` | ~24 LOC (L702–L725) | Cascade — body references the excised `_inv_derivation`; would not compile. |
| 3 | `basechange_along_proj_two_inv_app_isIso` | ~25 LOC (L727–L751) | Directive target #2 — sorry body. |
| 4 | `relativeDifferentialsPresheaf_basechange_along_proj_two` | ~22 LOC (L753–L774) | Cascade — body references the excised `_inv` + `_app_isIso`; would not compile. |
| 5 | `mulRight_globalises_cotangent` | ~63 LOC (L839–L901) | Directive target #3 — sorry body. |

Two short iter-145 EXCISE breadcrumb comments are left in-source where
each block was removed, recording the cause (chart-algebra pivot
descope; strategy-critic Q7 sunk-cost ruling) and pointing readers to
`AlgebraicJacobian/Cotangent/ChartAlgebra.lean`.

**File size**: 903 lines → 631 lines (-272 LOC).

**Live sorries in this file post-excise**: 0 (down from 3).

### File: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (NEW)

Skeleton file with 5 sorry-bodied placeholder declarations matching the
directive's pre-committed names (the blueprint-writer dispatched in
parallel this iter is committing identical names):

1. `AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product` (α)
2. `AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart` (β-core)
3. `AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (algebra-level core)
4. `AlgebraicGeometry.constants_integral_over_base_field` (integrally-closed helper)
5. `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` (scheme-level lift)

Each is `: True := sorry` (placeholder shape per the directive's
explicit "safer than committing wrong signatures" guidance, with the
iter-128–iter-131 cotangent body-shape refactors as the cautionary
tale). Each carries a `TODO iter-146: real signature; placeholder is
`: True`.` line in the docstring.

**Import policy deviation from directive (documented in-file)**: the
directive named `Mathlib.RingTheory.IsPushout`, but no such file
exists upstream — the closest canonical anchor is
`Mathlib.RingTheory.IsTensorProduct` (which exposes the
`Algebra.IsPushout` square API). Substituted. The directive also
named `Mathlib.Algebra.CharP.Frobenius`; it exists but is not
required for the `: True := sorry` placeholders, so it is
intentionally omitted (iter-146 may reintroduce it when the real
signatures land). The in-file note at the top of `ChartAlgebra.lean`
documents both decisions.

### File: `AlgebraicJacobian.lean`

Added `import AlgebraicJacobian.Cotangent.ChartAlgebra` immediately
after the existing `import AlgebraicJacobian.Cotangent.GrpObj` line.

## Orphan helpers (identified, NOT deleted — per directive)

These declarations are now consumed by zero **code** sites in the
project Lean tree (some still appear in surviving section-header
prose / docstrings, which counts as "lexical reference" but not
"compilation dependency"):

| Decl | Line in current GrpObj.lean | Status | Notes |
|------|----------------------------|--------|-------|
| `shearMulRight` | L350 | **orphan** | iter-134 piece (i.b) Step 1; only consumed by its own `_hom_fst`/`_hom_snd` plus deleted main lemma's docstring. |
| `shearMulRight_hom_fst` | L387 | **orphan** | Same as above. |
| `shearMulRight_hom_snd` | L392 | **orphan** | Same as above. |
| `schemeHomRingCompatibility` | L424 | **orphan** | iter-135 packaging helper; no code consumer. |
| `isIso_of_app_iso_module` | L544 | **orphan** | iter-140 Route (b'2) bridge; was consumed only by the excised `relativeDifferentialsPresheaf_basechange_along_proj_two`. |
| `relativeDifferentialsPresheaf_restrict_along_identity_section` | L579 | **orphan** | iter-136 piece (i.b) Step 3; was consumed only by the excised `mulRight_globalises_cotangent` (now only via deleted-decl's docstring). |
| `section_snd_eq_identity_struct` | L458 | **NOT orphan** | Still consumed at the body of `_restrict_along_identity_section` above. If the latter is later excised as orphan, this will become orphan too. |

Cross-verification: `Grep` for each name across `**/*.lean` shows
zero remaining **code** references for the orphan entries above
(matches are limited to docstring / comment text in surviving
declarations).

### Section-header `/-! ... -/` prose

Two section-header docstrings inside `GrpObj.lean` survived and now
reference excised declarations (mostly innocuous, but worth flagging):

* L297–327: "Piece (i.b) — shear-iso globalisation of the cotangent"
  enumerates Step 1 / Step 2 / Step 3 and the main lemma. Step 2 +
  Main lemma are now excised; the prose references them.
* L428–525: Piece (i.b) Step 2 scaffolding prose (iter-135 / iter-137
  / iter-138 status banners). Referenced declarations are now gone.

These are **not** declarations and were not auto-deleted per the
directive ("only the THREE explicitly-named sorry-bodied
declarations"). If the iter-146 plan agent prefers, a follow-up
cosmetic refactor can prune them.

## New `sorry` sites introduced

Five in `ChartAlgebra.lean` (all sorry-bodied skeletons by design):

* `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:50` — `algebra_isPushout_of_affine_product`
* `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:59` — `df_zero_factors_through_constant_on_chart`
* `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:69` — `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
* `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:77` — `constants_integral_over_base_field`
* `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:89` — `Scheme.Over.ext_of_diff_zero`

## `lake build` status

**Final**: clean build, exit 0, 8331/8331 jobs succeeded.

```
✔ [8324/8331] Built AlgebraicJacobian.Cotangent.GrpObj (3.5s)
⚠ [8325/8331] Built AlgebraicJacobian.Jacobian (4.1s)
⚠ [8326/8331] Built AlgebraicJacobian.Cotangent.ChartAlgebra (2.1s)
✔ [8327/8331] Built AlgebraicJacobian.Rigidity (4.1s)
⚠ [8328/8331] Built AlgebraicJacobian.AbelJacobi (4.1s)
⚠ [8329/8331] Built AlgebraicJacobian.RigidityKbar (3.9s)
✔ [8330/8331] Built AlgebraicJacobian (3.6s)
Build completed successfully (8331 jobs).
```

**Sorry warnings (8 total, matches directive prediction exactly)**:

* `ChartAlgebra.lean:50,59,69,77,89` (5 — the new skeleton)
* `Jacobian.lean:193,219` (2 — pre-existing genus-arm scaffolds)
* `RigidityKbar.lean:75` (1 — pre-existing `rigidity_over_kbar`)

**Non-sorry warnings (pre-existing, untouched)**:

* `Jacobian.lean:275:100` line length
* `AbelJacobi.lean:22:100` line length

## Sorry count delta

### Per file (declarations using `sorry`)

| File | Before iter-145 | After iter-145 | Delta |
|------|-----------------|----------------|-------|
| `AlgebraicJacobian/Cotangent/GrpObj.lean` | 3 (`_inv_derivation` inner `sorry`; `_app_isIso` body; `mulRight_globalises_cotangent` body) | 0 | -3 |
| `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` | 0 (file did not exist) | 5 | +5 |
| `AlgebraicJacobian/Jacobian.lean` | 2 | 2 | 0 |
| `AlgebraicJacobian/RigidityKbar.lean` | 1 | 1 | 0 |

### Project total

* Before iter-145 close: 6 declarations using `sorry`
* After iter-145 close: **8 declarations using `sorry`**
* Net: **+2** (chart-algebra DECOMPOSITION cost: 3 bundled-route sorries
  excised, replaced by 5 narrower chart-algebra sub-piece sorries; the
  +2 reflects the iter-144 commitment-to-decompose).

This exactly matches the directive's predicted post-state:

> After this refactor lands, project sorry inventory becomes: 5 (new
> ChartAlgebra.lean) + 2 (Jacobian.lean genus-arm scaffolds) + 1
> (RigidityKbar.lean rigidity_over_kbar) = **8 declarations using
> sorry / 8 inline sorries**.

## Notes for Plan Agent

1. **All five candidate orphans listed in the directive are now in
   fact orphan post-excise** (verified by `Grep` cross-reference). They
   were **not** auto-deleted per the directive's explicit
   instruction. The iter-146 plan agent has full freedom to schedule
   a follow-up orphan-prune refactor; the list above is precisely
   the candidate set.

2. **One cascade-extension beyond the directive's named targets**: the
   directive enumerated 3 named excise targets. Two further cascade
   targets (`basechange_along_proj_two_inv` and
   `relativeDifferentialsPresheaf_basechange_along_proj_two`) were
   **also excised** because their bodies directly reference the
   excised target declarations and would otherwise have failed to
   compile. The directive explicitly permits this case ("chase it up
   the dependency tree to the next non-target declaration and decide
   whether to excise it too as orphan"); the alternative — keeping
   them and rolling back the targeted excise — was clearly worse.

3. **In-file breadcrumb comments**: two iter-145 EXCISE comment
   blocks remain in-source where the deleted chunks lived, recording
   the iteration + reason + pointer to `ChartAlgebra.lean`. These are
   ~6 lines each and may be removed by a cosmetic-cleanup refactor
   later; leaving them now eases the iter-146 plan agent's audit.

4. **Stale section-header prose**: two `/-! ... -/` section banners
   inside `GrpObj.lean` (around L297 and L428–L525) now reference
   declarations that no longer exist. Not auto-deleted (these are
   comment blocks, not declarations); flagged for the iter-146
   cosmetic pass.

5. **Signature-shape decision on `ChartAlgebra.lean`**: all 5 new
   declarations carry `: True := sorry` placeholder signatures, per
   the directive's "safer than committing wrong signatures"
   guidance (citing the iter-128 → iter-131 cotangent body-shape
   refactor cautionary tale). The iter-146 prover lane is expected
   to refine each signature against the blueprint sketch; each
   declaration's docstring carries an explicit
   `TODO iter-146: real signature; placeholder is`: True`.` marker.

6. **Import deviation**: the directive named
   `Mathlib.RingTheory.IsPushout` (does not exist upstream — closest
   canonical anchor is `Mathlib.RingTheory.IsTensorProduct`) and
   `Mathlib.Algebra.CharP.Frobenius` (exists but unused by the `True`
   placeholders). The substitution / omission is documented in-file
   with a 7-line `iter-145 NOTE` comment block at the top of
   `ChartAlgebra.lean`.

7. **`archon-protected.yaml` untouched** (none of the excised
   declarations were on the protected list). The piece (i.a) trio
   (`cotangentSpaceAtIdentity` + `_eq_extendScalars` +
   `_finrank_eq`) is intact and unchanged.

8. **Blueprint untouched** (per the directive's boundaries; the
   blueprint-writer subagent dispatched in parallel handles
   informal-content updates).

9. **No `STRATEGY.md` or `archon-protected.yaml` mutations** (per
   the directive's boundaries).

10. **Iter-145+ prover lane parallelism**: the five new
    `ChartAlgebra.lean` declarations are naturally independent (no
    cross-references between them); they can be assigned to
    five prover slots in parallel iter-146+ if the loop budget
    permits.
