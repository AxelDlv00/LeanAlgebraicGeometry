# Lean Auditor Report — Iteration 042

**Date:** 2026-06-08  
**Scope:** all (15 `.lean` files)  
**Focus:** `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`  
**Auditor:** lean-auditor subagent

---

## Per-File Checklist

### `AlgebraicJacobian.lean` (root, 15 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | None |
| Dead-end proofs | N/A (import-only) |
| Excuse-comments | None |
| Outdated comments | None |
| Suspect definitions | None |

**Verdict:** Clean. Import-only file listing all 14 submodule imports.

---

### `AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean` (171 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | None |
| Dead-end proofs | None |
| Excuse-comments | None |
| Outdated comments | None |
| Suspect definitions | None |

**Verdict:** Entirely axiom-clean. Delivers Form-B absolute cohomology `H^p(U,F) := Ext^p(jShriek𝒪_U, F)` and naturality lemmas. All proofs complete.

---

### `AlgebraicJacobian/Cohomology/AcyclicResolution.lean` (926 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | None |
| Dead-end proofs | None |
| Excuse-comments | None |
| Outdated comments | None |
| Suspect definitions | None |

**Verdict:** Entirely axiom-clean. Key contributions: `Functor.IsRightAcyclic`, `rightDerivedShiftIsoOfSplitResolutionSES` (Dual Horseshoe), `twistedBiprod`, `InjectiveResolution.ofShortExact`, `rightDerivedIsoOfAcyclicResolution`. All proofs complete. `set_option maxHeartbeats` adjustments are expected for derived-category computations.

---

### `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean` (389 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | None |
| Dead-end proofs | None |
| Excuse-comments | None |
| Outdated comments | None |
| Suspect definitions | None |

**Verdict:** Entirely axiom-clean. Delivers `affineCoverSystem`, `affine_injective_acyclic` (acyclicity on affine opens), `toSheaf_preservesFiniteColimits`, `toSheaf_preservesEpimorphisms`, `standard_cover_cofinal`. All proofs complete.

---

### `AlgebraicJacobian/Cohomology/CechAcyclic.lean` (1608 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | 1 — `CechAcyclic.affine` (line 75) — **pre-authorized** |
| Dead-end proofs | None |
| Excuse-comments | None |
| Outdated comments | None |
| Suspect definitions | None |

**Verdict:** `CechAcyclic.affine` carries a `sorry` body — pre-authorized by directive (deferred to P5b rework). All other declarations axiom-clean across four namespaces:
- `CombinatorialCech` / `CombinatorialCech.Dependent` — AwayComparison maps, localized-module structures
- `AwayComparison`, `CechLocalized` — localization compatibility
- `SectionCechModule` — `dDiff_exact` (positive-degree exactness of un-localised Čech complex, the key theorem)
- `SectionCechBridge` / `SectionCechTilde` — `sectionCechAbExact`, `sectionCech_homology_exact`, `sectionCech_affine_vanishing`

Large `set_option maxHeartbeats` values on `phiL_naturality` (800000) and `phi_naturality` (1000000) are legitimate for universe-polymorphic naturality proofs.

---

### `AlgebraicJacobian/Cohomology/CechBridge.lean` (1116 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | None |
| Dead-end proofs | None |
| Excuse-comments | None |
| Outdated comments | None |
| Suspect definitions | None |

**Verdict:** Entirely axiom-clean across both the base section and the `FamilyParameterizedBridge` section. Key theorems: `injective_cech_acyclic` and `injective_cech_acyclicFam` (Čech acyclicity of injective sheaves, both cover-specific and cover-agnostic variants). `set_option maxHeartbeats 2000000` on `injective_cech_acyclicFam` is expected for parameterized functor equality.

---

### `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` (681 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | 1 — `cech_computes_higherDirectImage` (line 672) — **pre-authorized** |
| Dead-end proofs | None |
| Excuse-comments | None |
| Outdated comments | None |
| Suspect definitions | None |

**Verdict:** `cech_computes_higherDirectImage` carries a `sorry` body — pre-authorized by directive (frozen P5b material). All other declarations axiom-clean: `coverArrow`, `coverCechNerve`, `pushPullObj`, `pushPullMap` family, `CechNerve`, `relativeCechComplexOfNerve`, `CechComplex`. The machinery supporting P5b is complete and honest; only the top-level assembly theorem is deferred.

---

### `AlgebraicJacobian/Cohomology/CechToCohomology.lean` (434 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | None |
| Dead-end proofs | None |
| Excuse-comments | None |
| Outdated comments | None |
| Suspect definitions | None |

**Verdict:** Entirely axiom-clean. Delivers `cech_eq_cohomology_of_basis` (Stacks 01EO target), `absoluteCohomology_eq_zero_of_basis`, `BasisCovSystem`, `HasVanishingHigherCech`. The explicit hypothesis `[EnoughInjectives X.Modules]` on top-level theorems is correct and necessary — this instance is not in Mathlib. The hypothesis is honest, not a workaround.

---

### `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean` (2358 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | None |
| Dead-end proofs | None |
| Excuse-comments | None |
| Outdated comments | Minor (see below) |
| Suspect definitions | None |

**Verdict:** Entirely axiom-clean. Key theorems: `cechFreeComplex_quasiIso` and `cechFreeComplex_quasiIsoFam` (free Čech complex is quasi-isomorphic to the constant, via the `FreeCechEngine` contracting homotopy). All proofs complete. A strategy block comment (~55 lines) at the top of the file is a planning artifact from development; it is informational and does not mask incorrect code.

**Minor:** Strategy/planning block comment retained in production code (lines ~45–100). Low priority — informational only.

---

### `AlgebraicJacobian/Cohomology/HigherDirectImage.lean` (52 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | None |
| Dead-end proofs | None |
| Excuse-comments | None |
| Outdated comments | None |
| Suspect definitions | None |

**Verdict:** Entirely axiom-clean. Single declaration `higherDirectImage := ((pushforward f).rightDerived i).obj F`. Minimal wrapper file, correct.

---

### `AlgebraicJacobian/Cohomology/HigherDirectImagePresheaf.lean` (170 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | None |
| Dead-end proofs | None |
| Excuse-comments | None |
| Outdated comments | None |
| Suspect definitions | None |

**Verdict:** Entirely axiom-clean. Delivers `homologyIsoSheafify` (engine for Stacks 01XJ) and `higherDirectImage_iso_sheafify_presheafHomology`. The file docstring explicitly marks "remaining step to blueprint statement" as a handoff to the presheaf-cohomology identification — no sorry, no wrong code. This is a legitimate open-task note.

---

### `AlgebraicJacobian/Cohomology/PresheafCech.lean` (339 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | None |
| Dead-end proofs | None |
| Excuse-comments | None |
| Outdated comments | Minor (see below) |
| Suspect definitions | None |

**Verdict:** Entirely axiom-clean. Delivers `injective_toPresheafOfModules`, `freeYonedaHomEquiv`, `sectionCechCosimplicial`, `sectionCechComplex`. A strategy block comment (~160 lines, lines 34–196) is a planning artifact from development; it does not mask incorrect code.

**Minor:** Large planning/strategy block comment retained in production code (lines ~34–196). Low priority — informational only.

---

### `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` (319 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | None |
| Dead-end proofs | None |
| Excuse-comments | None |
| Outdated comments | None |
| Suspect definitions | None |

**Verdict:** Entirely axiom-clean. Delivers Route B steps B2–B4:
- `presentationOverBasicOpen` (B2)
- `modulesOverBasicOpenEquivalence` (B3 engine) via `pushforwardPushforwardEquivalence`
- `presentationModulesRestrictBasicOpen` (B4)

The `set_option backward.isDefEq.respectTransparency false` on `modulesOverBasicOpenEquivalence` and related declarations is a legitimate workaround for a known defeq-transparency issue in typeclass synthesis for `Opens.overEquivalence`; it does not suppress a real type error. The `set_option synthInstance.maxHeartbeats 400000` on `presentationModulesRestrictBasicOpen` is appropriate given the depth of the instance search.

---

### `AlgebraicJacobian/Cohomology/TildeExactness.lean` (231 lines)

| Check | Result |
|-------|--------|
| Unexpected `sorry` | None |
| Dead-end proofs | None |
| Excuse-comments | None |
| Outdated comments | None |
| Suspect definitions | None |

**Verdict:** Entirely axiom-clean, with an acknowledged open item. The file delivers preparatory infrastructure for `tildePreservesFiniteLimits`:
- `tilde_preservesFiniteColimits` (left adjoint, trivial)
- `tilde_toStalk_map_injective` (flatness core via `IsLocalizedModule.map_injective`)
- `tilde_preservesFiniteLimits_of_preservesKernels` (honest reduction to kernel preservation hypothesis)
- `tilde_stalkFunctor_map_toStalk`, `tildePreservesFiniteLimits_of_toPresheaf`, `tilde_germ_algebraMap_smul`, `stalkMapₗ`, `stalkMapₗ_eq`, `stalkMapₗ_injective`

The declaration `tildePreservesFiniteLimits` itself is **absent from the file** (not declared with `sorry`). The file docstring explicitly states this and describes the remaining ~100–150 LOC gap (the stalkwise localisation upgrade from `tilde_preservesFiniteLimits_of_preservesKernels`). This is an **honest open-task note**, not an excuse-comment — no incorrect code is being masked.

**Note for future iteration:** `tildePreservesFiniteLimits` itself is a missing deliverable; the infrastructure is ready and the path is well-documented.

---

### `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` (845 lines) — **FOCUS FILE**

| Check | Result |
|-------|--------|
| Unexpected `sorry` | None |
| Dead-end proofs | None |
| Excuse-comments | None — see detailed assessment below |
| Outdated comments | None |
| Suspect definitions | None |

#### Focus area 1: `tile_image_opens_identities` (lines 733–768)

**Assessment: Proof is honest and axiom-clean.**

The proof uses:
- `constructor` to split the two-sided opens identity
- `rw` with `Scheme.Hom.comp_image` and `PrimeSpectrum.basicOpen_mul` for the forward direction
- `apply Opens.ext` followed by proper set membership reasoning for the backward direction

No dead-end tactics. No `native_decide` or `decide` on non-finite types. No `simp only []` with empty lists. No suspicious `rfl` on non-definitionally-equal terms. The proof compiles on the current declaration machinery and is mathematically honest.

#### Focus area 2: `tile_section_localization` block comment (lines 770–793)

**Assessment: Legitimate handoff note. NOT an excuse-comment.**

**Verdict: PASS.**

The comment records that `tile_section_localization` is **absent** (no declaration, no `sorry` placeholder). It diagnoses a genuine type mismatch: `modulesSpecToSheaf` applied to `Spec R_g` produces `R_g`-modules (with the local ring `R_g` as `AlgebraicGeometry.StructureSheaf.localRing`), while the restriction functor's `Γ(M,–)` side produces `R`-modules via `restrictScalars (algebraMap R R_g)`. The two sides differ as module categories, not just as sheaf categories — this is a real mathematical obstacle requiring a `section-comparison` lemma (Sub-lemma B, estimated ~100–150 LOC) rather than definitional wiring.

Criteria for excuse-comment detection:
- Does it mask wrong code? **No** — there is no code to mask; the declaration is simply absent.
- Does it falsely claim something is proved? **No** — it explicitly says the declaration is deferred.
- Does it describe an imaginary obstacle? **No** — the R_g vs R module-category mismatch is a real and well-understood type-theoretic obstacle in Lean 4's `ModuleCat` formalism.
- Does the estimated effort seem realistic? **Yes** — ~100–150 LOC for a section comparison lemma over a basic open is consistent with the complexity of `presentationModulesRestrictBasicOpen` (B4) already in the file.

#### All other declarations in `QcohTildeSections.lean`

All axiom-clean: `qcoh_iso_tilde_sections`, `qcoh_iso_tilde_sections_of_presentation`, simp lemmas, `free_isQuasicoherent`, `isIso_fromTildeΓ_of_genSections`, `qcoh_iso_tilde_sections_of_genSections`, `exists_finite_basicOpen_subcover`, `isLocalizedModule_of_span_cover`, `tilde_section_isLocalizedModule`, `section_isLocalizedModule_of_isIso_fromTildeΓ`, `section_isLocalizedModule_of_presentation`, `qcoh_finite_presentation_cover`, `qcoh_section_equalizer`, `isLocalizedModule_powers_restrictScalars_of_algebraMap`.

The handoff section (lines 797–844) is informal prose only — no code.

---

## Issues by Severity

### Must-Fix-This-Iteration

**None.** All known unauthorized `sorry`s are pre-authorized. No dead-end proofs, no masking excuse-comments.

---

### Major

**None.** Both `sorry` instances are pre-authorized by directive:

1. `CechAcyclic.affine` (line 75 of `CechAcyclic.lean`) — pre-authorized, deferred to P5b rework.
2. `cech_computes_higherDirectImage` (line 672 of `CechHigherDirectImage.lean`) — pre-authorized, frozen P5b material.

---

### Minor

1. **`FreePresheafComplex.lean` lines ~45–100**: Large strategy/planning block comment retained from development. Informational only; no incorrect code masked. Low priority cleanup.

2. **`PresheafCech.lean` lines ~34–196**: Large planning block comment (~160 lines) retained from development. Same classification as above.

---

### Excuse-Comments

**None found.** All handoff notes and planning comments examined correctly identify genuine obstacles and make no false claims:

- `QcohTildeSections.lean` `tile_section_localization` block (lines 770–793): Legitimate handoff. Real R_g vs R module-category obstacle. No sorry masking.
- `TildeExactness.lean` docstring: Legitimate open-task note. `tildePreservesFiniteLimits` is absent, not sorry'd. Correct diagnosis of remaining gap.
- `HigherDirectImagePresheaf.lean` handoff note: Legitimate. Names the exact missing step (presheaf-cohomology identification).

---

## Severity Summary

| Category | Count | Items |
|----------|-------|-------|
| Must-fix-this-iter | 0 | — |
| Major (pre-authorized `sorry`) | 2 | `CechAcyclic.affine`, `cech_computes_higherDirectImage` |
| Minor | 2 | Planning block comments in `FreePresheafComplex.lean`, `PresheafCech.lean` |
| Excuse-comments | 0 | — |
| Unauthorized `sorry` | 0 | — |
| Dead-end proofs | 0 | — |

---

## Focus-File Verdict Summary

| Item | Verdict |
|------|---------|
| `tile_image_opens_identities` proof (lines 733–768) | **PASS** — Honest, axiom-clean, complete proof. Not a dead-end. |
| `tile_section_localization` block comment (lines 770–793) | **PASS** — Legitimate handoff note. Correct diagnosis of R_g/R module-category mismatch. Not an excuse-comment. |

---

## Open Items for Future Iterations (not must-fix)

1. **`tildePreservesFiniteLimits`** (`TildeExactness.lean`): Infrastructure complete, declaration absent. ~100–150 LOC stalkwise localisation upgrade needed. Path well-documented.
2. **`tile_section_localization`** (`QcohTildeSections.lean`): Sub-lemma B. ~100–150 LOC section-comparison lemma needed to close the R_g/R type mismatch. Path well-documented.
3. **`higherDirectImage_iso_sheafify_presheafHomology` identification** (`HigherDirectImagePresheaf.lean`): Remaining step to Stacks 01XJ blueprint statement.
4. **`cech_computes_higherDirectImage`** (`CechHigherDirectImage.lean`): P5b assembly, pre-authorized frozen.
5. **`EnoughInjectives X.Modules`** (`CechToCohomology.lean`): Instance not in Mathlib. Theorems correctly carry it as an explicit hypothesis; would become automatic if Mathlib gains the instance.
