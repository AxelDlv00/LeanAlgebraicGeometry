# Lean ↔ Blueprint Check Report

## Slug
cechacyclic

## Iteration
019

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechAcyclic.lean` (1108 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (consolidated chapter)

---

## Per-declaration

Only blocks whose `\lean{...}` targets reside in `CechAcyclic.lean` are audited below.

### `\lean{AlgebraicGeometry.CechAcyclic.affine}` (chapter: `\lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 74)
- **Signature matches**: yes — `{R : CommRingCat}`, `f : Spec R ⟶ S`, `[IsAffineHom f]`, `s : ι → R`, `hs : Ideal.span (Set.range s) = ⊤`, `F`, `hF`, `p`, `hp : 1 ≤ p`, concludes `IsZero (CechComplex f … F).homology p)`.
- **Proof follows sketch**: N/A — body is `:= sorry` (superseded old relative-form target, per known-issues directive; not a defect)
- **Notes**: The docstring explicitly documents the superseded status and the L1/L2/L3 route. The blueprint's `% NOTE:` comment in `\lem:cech_acyclic_affine` acknowledges the re-sign to `sectionCech_affine_vanishing`; keeping `CechAcyclic.affine` in the `\lean{}` list for coverage continuity is correct.

### `\lean{AlgebraicGeometry.sectionCech_affine_vanishing}` (chapter: `\lem:cech_acyclic_affine`)
- **Lean target exists**: no — not present in `CechAcyclic.lean` (re-signed target, expected to land in a different file)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: The blueprint's `% NOTE:` documents the pending re-sign. Not a defect for this file.

### `\lean{AlgebraicGeometry.CombinatorialCech.*}` — 19 declarations (chapter: `\lem:cech_acyclic_affine`)

All 19 `CombinatorialCech.*` declarations named in the `\lean{}` list are present in CechAcyclic.lean:

| Declaration | Line | Status |
|---|---|---|
| `combDifferential` | 143 | exists, complete |
| `combHomotopy` | 149 | exists, complete |
| `combHomotopy_zero` | 152 | exists, complete |
| `cons_comp_succAbove_succ` | 158 | exists, complete |
| `combHomotopy_spec` | 171 | exists, complete |
| `combDifferential_eq_of_cocycle` | 188 | exists, complete |
| `combSign_flip` | 196 | exists, complete |
| `combDifferential_comp` | 216 | exists, complete |
| `combDifferential_exact` | 247 | exists, complete |
| `depTransport` | 301 | exists, complete |
| `cons_comp_zero_succAbove` | 307 | exists, complete |
| `depDiff` | 313 | exists, complete |
| `depHomotopy` | 319 | exists, complete |
| `depHomotopy_spec` | 328 | exists, complete |
| `depDiff_eq_of_cocycle` | 360 | exists, complete |
| `comp_succAbove_swap` | 382 | exists, complete |
| `depDiff_comp` | 396 | exists, complete |
| `depDiff_exact` | 431 | exists, complete |

- **Signature matches**: yes (all) — each matches its blueprint description precisely (constant/dependent coefficient alternating Čech differential, homotopy identity, d²=0, positive-degree exactness in `Function.Exact` form)
- **Proof follows sketch**: yes — `combHomotopy_spec` uses the `j=0` collapse + alternating-sum cancellation; `combDifferential_comp` uses the sign-reversing involution; `depHomotopy_spec` threads `hu`/`hsh`; `combDifferential_exact` and `depDiff_exact` assemble the two halves. All match the blueprint's prose.
- **Notes**: All are `private` in Lean (scope-internal to the file). The blueprint's `\lean{}` list references them with full namespace; this is a documentation-only discoverability mismatch, not a mathematical defect.

### `\lean{AlgebraicGeometry.AwayComparison.*}` — 12 declarations (chapter: `\lem:section_cech_homology_exact`)

All 12 `AwayComparison.*` declarations named in the `\lean{}` list are present:

| Declaration | Line | Status |
|---|---|---|
| `Inverts` | 486 | exists, complete |
| `Inverts.of_dvd` | 492 | exists, complete |
| `Inverts.mul` | 507 | exists, complete |
| `Inverts.isUnit_powers` | 514 | exists, complete |
| `comparison` | 525 | exists, complete |
| `comparison_apply` | 532 | exists, complete |
| `comparison_comp_structure` | 539 | exists, complete |
| `comparison_unique` | 547 | exists, complete |
| `comparison_self` | 557 | exists, complete |
| `comparison_comp` | 567 | exists, complete |
| `comparison_comp_apply` | 580 | exists, complete |

- **Signature matches**: yes (all) — `Inverts a Mb := IsUnit (algebraMap R (Module.End R Mb) a)`, `comparison` via `IsLocalizedModule.lift`, composition/uniqueness laws all match blueprint prose.
- **Proof follows sketch**: yes — all proofs use the `IsLocalizedModule.lift_unique` uniqueness approach described in the chapter.
- **Notes**: `AwayComparison.Inverts.smul_pow_cancel` (line 592) and `AwayComparison.comparison_isLocalizedModule` (line 607) exist in the file but are **not listed** in the `\lean{}` bundle for `lem:section_cech_homology_exact`. See Red Flags and Blueprint Adequacy sections.

### `\lean{AlgebraicGeometry.CechLocalized.*}` — 11 declarations (chapter: `\lem:section_cech_homology_exact`)

All 11 `CechLocalized.*` declarations named in the `\lean{}` list are present:

| Declaration | Line | Status |
|---|---|---|
| `sprod` | 683 | exists, complete |
| `sprod_cons` | 685 | exists, complete |
| `sprod_succAbove_dvd` | 692 | exists, complete |
| `cechCoeff` | 712 | exists, complete |
| `cechCoface` | 717 | exists, complete |
| `cechPrepend` | 728 | exists, complete |
| `cechCoeff_transport_eq_comparison` | 750 | exists, complete |
| `cech_hu` | 764 | exists, complete |
| `cech_hsh` | 783 | exists, complete |
| `cech_hcomm` | 814 | exists, complete |
| `cechLocalized_exact` | 848 | exists, complete |

- **Signature matches**: yes (all) — `sprod s σ = ∏ k, s (σ k)`, coface/prepend as `AwayComparison.comparison` instances, `cechLocalized_exact` as `CombinatorialCech.depDiff_exact` fed the concrete maps — all match the blueprint description.
- **Proof follows sketch**: yes — `cech_hu`, `cech_hsh`, `cech_hcomm` all use `comparison_comp_apply` and `cechCoeff_transport_eq_comparison` per the blueprint's "both composites are away-comparison maps" argument; `cechLocalized_exact` directly applies `depDiff_exact`.

### `\lean{AlgebraicGeometry.sectionCech_homology_exact}` (chapter: `\lem:section_cech_homology_exact`)
- **Lean target exists**: no — not present in `CechAcyclic.lean` (top-level bridge lemma, expected in `CechBridge.lean` or similar)
- **Notes**: The named block's supporting decls (`AwayComparison.*`, `CechLocalized.*`) are all present and complete; the top-level lemma is elsewhere.

---

## Red flags

### Missing `\lean{}` references to substantive declarations in this file

Two `AwayComparison` declarations in `CechAcyclic.lean` are not referenced in any `\lean{}` block of the chapter:

- **`AwayComparison.Inverts.smul_pow_cancel`** (line 592): Scalar-cancellation lemma used in the proof of `comparison_isLocalizedModule`. Not a trivial simp lemma — it is the injectivity device enabling the surjectivity and `exists_of_eq` cases of the localisation-transitivity proof.
- **`AwayComparison.comparison_isLocalizedModule`** (line 607): Localisation-transitivity lemma (`M_{ab}` is the localisation of `M_a` away from `b`). This is the **keystone** lemma feeding `exact_of_isLocalized_span` in the `SectionCechModule.dDiff_exact` proof (via `dToCech_isLocalizedModule`). It should appear in the `\lean{}` list of `lem:section_cech_homology_exact`.

Classification: **major** — these are substantive declarations the chapter should reference.

### Superseded sorry (noted, not a defect)
- `CechAcyclic.affine` at line 109: `:= sorry` on the old relative-form target. The file's docstring and planner comments document this as intentionally superseded. Per directive: not treated as a blueprint-violation defect.

---

## Unreferenced declarations (informational)

The entire `SectionCechModule` namespace (lines 873–1104, ~23 declarations) is not referenced by any `\lean{}` block in the chapter. Per the directive, this is known and tracked. For completeness, the full list of unreferenced substantive declarations:

- `SectionCechModule.dCoeff` (abbrev, line 881) — the un-localised coefficient `M_{s_σ}`
- `SectionCechModule.dCoface` (def, line 886) — un-localised coface comparison
- `SectionCechModule.dDiff` (def, line 896) — differential of `D•`
- `SectionCechModule.dDiff_apply` (lemma, line 902)
- `SectionCechModule.dToCech` (def, line 912) — per-index localisation `M_{s_σ} → M_{s_r·s_σ}`
- `SectionCechModule.dToCech_isLocalizedModule` (lemma, line 925) — transitivity instance
- `SectionCechModule.cechCoface_dToCech` (lemma, line 940) — per-coface naturality square
- `SectionCechModule.dToCech_comm` (lemma, line 957) — differential-naturality square
- `SectionCechModule.cechCofaceLin` (def, line 976) — R-linear form of `cechCoface`
- `SectionCechModule.cechCoface_apply` (lemma, line 984)
- `SectionCechModule.locDiff` (def, line 990) — bundled localised differential
- `SectionCechModule.locDiff_apply` (lemma, line 995)
- `SectionCechModule.locDiff_eq_depDiff` (lemma, line 1005) — identification with `depDiff`
- `SectionCechModule.locDiff_exact` (lemma, line 1016) — localised exactness
- `SectionCechModule.fLoc` (def, line 1022) — product localisation map `D^m → ∏_σ cechCoeff`
- `SectionCechModule.fLoc_apply` (lemma, line 1026)
- `SectionCechModule.fLoc_isLocalizedModule` (instance, line 1032) — the `IsLocalizedModule.pi` instance
- `SectionCechModule.locDiff_fLoc` (lemma, line 1040) — commutation square for `IsLocalizedModule.ext`
- `SectionCechModule.map_dDiff_eq_locDiff` (lemma, line 1055) — identification via `IsLocalizedModule.ext`
- `SectionCechModule.spanIdx` (private def, line 1068) — auxiliary for type-correct motive
- `SectionCechModule.spanIdx_spec` (private lemma, line 1071)
- **`SectionCechModule.dDiff_exact`** (lemma, line 1081) — **the new primary target** (see below)

---

## Focus-question assessment

### (a) Does `dDiff_exact` faithfully realize step (a) of `lem:cech_acyclic_affine` / `lem:section_cech_homology_exact`?

**YES — faithful realization.**

The blueprint's proof sketch for `lem:cech_acyclic_affine` (§"Node-by-node exactness via local-to-global and the dependent port") prescribes:

> "The local-to-global exactness criterion `exact_of_isLocalized_span(Set.range s) hs` reduces `Function.Exact(d^{p-1}, d^p)` to exactness after localising at each spanning element `r` ... The node is then closed by `depDiff_exact` of the dependent combinatorial port."

`SectionCechModule.dDiff_exact` (line 1081) has signature:
```lean
lemma dDiff_exact [Finite ι] (hs : Ideal.span (Set.range s) = ⊤) (m : ℕ) :
    Function.Exact (dDiff s M (m + 1)) (dDiff s M (m + 2))
```

This is exactly positive-degree `Function.Exact` of the `D•` complex differentials. The proof (lines 1083–1103):
1. Instantiates `IsLocalizedModule.Away (↑ρ) (fLoc s M (spanIdx s ρ) …)` for each spanning element `ρ` (lines 1084–1092)
2. Calls `exact_of_isLocalized_span (Set.range s) hs` (line 1093)
3. Rewrites the localised map via `map_dDiff_eq_locDiff` to `locDiff` (lines 1101–1102)
4. Closes by `locDiff_exact` ← `CechLocalized.cechLocalized_exact` ← `CombinatorialCech.depDiff_exact` (line 1103)

This is a verbatim implementation of the blueprint's route. The statement type (`Function.Exact` of the un-localised `dDiff` pair) is exactly the form that `lem:section_cech_homology_exact` says is equivalent to vanishing of the abstract homology. The mathematical content matches.

### (b) Is the chapter's proof sketch adequate to have guided this build?

**PARTIALLY — named ingredients are correct but infrastructure is under-specified.**

The blueprint correctly names `exact_of_isLocalized_span` and `depDiff_exact` as the key ingredients. However, the proof of `dDiff_exact` required constructing ~20 intermediate declarations that the blueprint's proof sketch does not preview:

| What the blueprint says | What was needed but not sketched |
|---|---|
| "apply `exact_of_isLocalized_span`" | Must build `D•` as an explicit R-linear complex: `dCoeff`, `dDiff`, `dCoface` |
| | Must build localisation maps `dToCech`, `fLoc` and prove them `IsLocalizedModule` instances |
| | Must prove the differential-naturality square `dToCech_comm` / `locDiff_fLoc` |
| | Must bundle `cechCofaceLin` / `locDiff` as R-linear maps (since `exact_of_isLocalized_span` requires linear maps, not just set-functions) |
| | Must use `IsLocalizedModule.ext` (via `map_dDiff_eq_locDiff`) to identify `IsLocalizedModule.map (dDiff)` with `locDiff` |
| | Must use `IsLocalizedModule.pi` to promote per-σ `IsLocalizedModule` instances to the product |
| | Must use `spanIdx` to avoid `↑ρ` appearing in the motive type |

These are not routine bookkeeping steps; each required a specific Mathlib lemma (`IsLocalizedModule.pi`, `IsLocalizedModule.ext`, `comparison_isLocalizedModule`) that a prover would not find just from the prose. The `comparison_isLocalizedModule` lemma in particular (localisation transitivity) is the *linchpin* of the `fLoc_isLocalizedModule` instance but is completely unmentioned in the proof sketch.

The blueprint proof sketch is **adequate for the main line** (correct high-level route) but **insufficient to independently guide construction of the `SectionCechModule.*` infrastructure**. A prover would need to discover the intermediate definition layer from scratch.

---

## Blueprint adequacy for this file

- **Coverage**: ~33 of 65 Lean declarations in this file have a corresponding `\lean{}` block entry. Of the 32 unreferenced:
  - 20 are `SectionCechModule.*` infrastructure helpers (known debt, tracked for planner)
  - 2 are substantive `AwayComparison.*` lemmas that should be referenced (flagged above as major)
  - 10 are minor helper lemmas internal to the proofs

- **Proof-sketch depth**: **under-specified** for `SectionCechModule.*`. The proof sketch for `lem:cech_acyclic_affine` is adequate for the combinatorial L3 core and names the correct Mathlib ingredient (`exact_of_isLocalized_span`), but does not sketch the intermediate definitions (`D•` complex, `dToCech`, `fLoc`, `locDiff`, the `IsLocalizedModule` instance chain, and the `IsLocalizedModule.ext`-based identification) that constitute the bulk of the iter-019 build.

- **Hint precision**: **precise** for declarations that are referenced. The `\lean{}` lists pin specific Lean names; the informal statements match the Lean signatures.

- **Generality**: matches need — `AwayComparison.comparison` is stated at the right generality (any `IsLocalizedModule`, not just `LocalizedModule`) for reuse by both `CechLocalized.*` and `SectionCechModule.*`.

- **Recommended chapter-side actions** (for blueprint-writing subagent):
  1. Add `AlgebraicGeometry.AwayComparison.Inverts.smul_pow_cancel` and `AlgebraicGeometry.AwayComparison.comparison_isLocalizedModule` to the `\lean{}` list of `lem:section_cech_homology_exact`.
  2. Expand the proof sketch of `lem:cech_acyclic_affine` (or add a new `lem:section_cech_D_exact` sub-lemma) to preview the `D•` complex construction, the `fLoc` localisation map + `IsLocalizedModule.pi` instance, the differential-naturality square, and the `IsLocalizedModule.ext` uniqueness identification. This is the infrastructure that `dDiff_exact` lives in.
  3. Add `SectionCechModule.dDiff_exact` (and its 10–15 closest supporting declarations) to the `\lean{}` list once the planner decides the naming is stable.

---

## Severity summary

| Finding | Severity |
|---|---|
| `AwayComparison.Inverts.smul_pow_cancel` not in `\lean{}` (substantive, used by `comparison_isLocalizedModule`) | **major** |
| `AwayComparison.comparison_isLocalizedModule` not in `\lean{}` (linchpin of `fLoc_isLocalizedModule`; unlocks `dDiff_exact`) | **major** |
| Blueprint proof sketch under-specified for `SectionCechModule.*` infrastructure (cannot independently guide construction of ~20 declarations) | **major** |
| `SectionCechModule.*` under-coverage (all 23 decls unreferenced) | informational (known tracked debt) |
| `CechAcyclic.affine` sorry | noted (superseded, not a defect) |
| `sectionCech_affine_vanishing` / `sectionCech_homology_exact` absent from CechAcyclic.lean | noted (expected in another file) |
| All other checked declarations: exist, signatures match, proofs complete | pass |

**Overall verdict**: All `CombinatorialCech.*`, `AwayComparison.*`, and `CechLocalized.*` declarations that the blueprint references are present, correctly signed, and proof-complete; `dDiff_exact` faithfully realizes step (a) of the section-form proof sketch via the prescribed `exact_of_isLocalized_span` route; two substantive `AwayComparison` declarations are missing from the chapter's `\lean{}` lists (major), and the proof sketch is under-specified for the `SectionCechModule.*` infrastructure layer (major, blueprint-side action needed).
