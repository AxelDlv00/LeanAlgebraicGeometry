# Blueprint Review: fastpath
**Iter:** 077
**Scope:** Fast-path re-review of two chapters only (sanctioned).

---

## `Picard_GlueDescent.tex`

**Complete:** true
**Correct:** true
**Must-fix-this-iter:** none

### Findings

All 5 mandated blocks present with correct labels and `\lean{}` pins:

| Label | `\lean{}` target | Covers sorry |
|-------|-----------------|--------------|
| `def:gr_glue_equalizer` | `Scheme.Modules.glueProd` | infrastructure (no sorry) |
| `lem:glueOverlapBaseChangeIso` | `Scheme.Modules.glueOverlapBaseChangeIso` | GlueDescent.lean L1170 |
| `lem:glueRestrictionHom` | `Scheme.Modules.glueRestrictionHom` | infrastructure |
| `thm:isIso_glueRestrictionHom` | `Scheme.Modules.isIso_glueRestrictionHom` | GlueDescent.lean L1207 |
| `def:glueRestrictionIso` | `Scheme.Modules.glueRestrictionIso` | packages iso |

**Sorry coverage:**
- L1170 (inside `glueOverlapBaseChangeIso`): the `pushforwardCongr` component — covered by `lem:glueOverlapBaseChangeIso` proof sketch (cartesian square, object-level opens equality via `glueData_preimage_image_eq`, naturality is proof-irrelevant in the opens poset).
- L1207 (`isIso_glueRestrictionHom` body): covered by `thm:isIso_glueRestrictionHom` proof sketch (constructs explicit inverse s_i via η_{f_ij} ≫ (f_ij)_* g_ij ≫ β_ij^{-1}, verifies (C1)/(C2) triangles, invokes `lem:isLimitPullbackCone_mathlib` and `lem:eq_of_locally_eq_mathlib`).

**`\uses` validity:** All referenced labels exist:
- `def:scheme_modules_glue` — GrassmannianQuot.tex ✓
- `lem:modules_restrictFunctorIsoPullback_mathlib` — Picard_QuotScheme.tex ✓
- `lem:isLimitPullbackCone_mathlib` — Picard_QuotScheme.tex ✓
- `lem:eq_of_locally_eq_mathlib` — Picard_QuotScheme.tex ✓

**Proof sketch quality:** Both sorry-covering proofs are detailed enough for a prover (step-by-step structure, concrete Lean combinator names given).

---

## `Picard_GrassmannianQuot.tex`

**Complete:** true
**Correct:** true
**Must-fix-this-iter:** none

### Findings

All 6 mandated Nitsure §5 inverse blocks present:

| Label | `\lean{}` target | Covers sorry |
|-------|-----------------|--------------|
| `lem:tautologicalQuotient_epi` | `Grassmannian.tautologicalQuotient_epi` | L2066 (`tautologicalQuotient_epi`) |
| `def:isoLocus` | `Grassmannian.isoLocus` | infrastructure |
| `lem:isIso_pullback_isoLocus_map` | `Grassmannian.isIso_pullback_isoLocus_map` | L2160 (`isIso_pullback_isoLocus_map`) |
| `def:chartLocus` | `Grassmannian.chartLocus` | infrastructure |
| `lem:chartLocus_isOpenCover` | `Grassmannian.chartLocus_isOpenCover` | L2147 (`chartLocus_isOpenCover`) |
| `def:grPointOfRankQuotient` | `Grassmannian.grPointOfRankQuotient` | L2249 (overlap gluing in definition) |

**Sorry coverage:**
- L2066 (`tautologicalQuotient_epi`): covered by `lem:tautologicalQuotient_epi` — epi is chart-local, each u^I is split epi by I-minor identity, covered via `lem:gr_chartQuotientMap_epi`. Clear.
- L2147 (`chartLocus_isOpenCover`): covered by `lem:chartLocus_isOpenCover` — Nakayama step: trivialise F locally, fibre surjectivity gives non-vanishing minor, basic open gives invertibility. Adequate detail.
- L2160 (`isIso_pullback_isoLocus_map`): covered by `lem:isIso_pullback_isoLocus_map` — stalk-wise criterion `lem:isIso_of_stalkFunctor_map_iso_mathlib`, each stalk has a local iso neighbourhood inside the iso-locus. Clean.
- L2249 (overlap gluing inside `grPointOfRankQuotient`): covered by `def:grPointOfRankQuotient`'s construction description — M^J = (M^I_J)^{-1} M^I = φ_I^* θ_{IJ}(X^J), so chart morphisms agree on overlaps after the transition; cocycle `lem:gr_cocycle` then glues them. Formalizable.

**Duplicate `glueRestrictionIso` pin — RESOLVED:**
- `def:gr_modules_glueRestrictionIso` in this file carries **NO** `\lean{}` pin (confirmed: comment says "carries no \lean{} pin to avoid a duplicate") ✓
- It carries `\uses{def:glueRestrictionIso, ...}` pointing to the canonical pin in `Picard_GlueDescent.tex` ✓
- Canonical pin `def:glueRestrictionIso` in `Picard_GlueDescent.tex` carries `\lean{AlgebraicGeometry.Scheme.Modules.glueRestrictionIso}` ✓

**`\uses` validity of new blocks (spot-check):**
- `lem:isIso_of_stalkFunctor_map_iso_mathlib` — present in this file (L1920, `\mathlibok`) ✓
- `lem:gr_chartQuotientMap_epi` — present in this file ✓
- `def:tautological_quotient` — present in this file ✓
- `def:chartLocus` → `def:isoLocus` → `lem:isIso_of_stalkFunctor_map_iso_mathlib` chain intact ✓

---

## Summary

| Chapter | Complete | Correct | Must-fix |
|---------|----------|---------|----------|
| `Picard_GlueDescent.tex` | true | true | none |
| `Picard_GrassmannianQuot.tex` | true | true | none |

**Gate status:** Both chapters pass `complete: true` AND `correct: true` with no must-fix finding. The hard gate is satisfied for:
- `AlgebraicJacobian/Picard/GlueDescent.lean` (via `Picard_GlueDescent.tex`)
- The §5 inverse declarations in `AlgebraicJacobian/Picard/GrassmannianQuot.lean` (via `Picard_GrassmannianQuot.tex`)
