# Lean ↔ Blueprint Check Report

## Slug
cechhdi

## Iteration
051

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration (blueprint `\lean{}` blocks)

### `\lean{AlgebraicGeometry.cechAugmented_exact}` (chapter: `lem:cech_augmented_resolution`, line 6980)
- **Lean target exists**: **NO** — `cechAugmented_exact` is absent from the Lean file. The object layer (`cechAugmentedComplex` and its five companions) has been built axiom-clean this iter; the exactness theorem has not, because no stalkwise-exactness reflection criterion for `X.Modules` complexes exists in Mathlib.
- **Signature matches**: N/A (declaration does not yet exist)
- **Proof follows sketch**: N/A
- **notes**: Aspirational `\lean{}` pin. The pin name (`cechAugmented_exact`) correctly anticipates the intended future theorem. The statement block has no `\leanok`, which is correct. The proof block (lines 7029–7066) likewise has no `\leanok`. The issue is structural: the single blueprint block mixes "object layer now built" with "exactness still pending", conflating two distinct formalization obligations under one `\lean{}` pointer that points only at the pending theorem.

---

### `\lean{AlgebraicGeometry.cech_computes_higherDirectImage}` (chapter: `lem:cech_computes_cohomology`, lines 7353–7354)
- **Lean target exists**: **YES** — `theorem cech_computes_higherDirectImage` at line 773.
- **Signature matches**: **YES** — the Lean signature `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` matches the blueprint prose exactly, including the `Nonempty`-existence form and the `HasInjectiveResolutions` hypothesis.
- **Proof follows sketch**: **NO** — proof body is `:= sorry`. The blueprint statement block carries `\leanok` (line 7351, correct: declaration exists with sorry). The proof block has no `\leanok` (correct: proof not closed). The theorem is downstream-blocked on `cechAugmented_exact`.
- **notes**: Properly tracked placeholder. Not a hidden sorry — both Lean and blueprint consistently acknowledge the pending state.

---

### All other `\lean{}` blocks (pre-iter-051 declarations)

All previously-blueprinted declarations (`CechNerve`, `CechComplex`, `coverArrow`, `coverCechNerve`, `coverCechNerveOver`, `coverCechNerveOverAug`, `pushPullObj`, `pushPullMap`, `rawPushPullMap`, `pushPullMap_eq_raw`, `rawPushPullMap_self`, `rawPushPullMap_self_gen`, `pushforwardComp_hom_app_id`, `pushPull_unit_comp`, `pushPullMap_id`, `pushPullMap_comp`, `rawPushPullMap_comp`, `pushPull_pentagon`, `pushPull_unit_mate`, `pushPull_transport_cancel`, `pushPullFunctor`, `cechNerveCosimplicial`, `relativeCechComplexOfNerve`) are present in the Lean file with signatures that match the blueprint. No anomalies found on the pre-iter-051 side.

---

## Red flags

### Placeholder / suspect bodies

- `cech_computes_higherDirectImage` at line 773: body is `:= sorry`. The blueprint claims this is a substantive isomorphism theorem. Properly tracked (statement `\leanok`, no proof `\leanok`), but the severity rules require flagging all `sorry`-bodied substantive declarations regardless.

---

## Unreferenced declarations (informational)

The following **six declarations added this iteration** have no `\lean{}` pin anywhere in the blueprint. The first five are substantive (named, publicly visible, non-trivial Lean definitions or lemmas that form the object-layer infrastructure for `lem:cech_augmented_resolution`); they should appear in the blueprint:

| Declaration | Kind | What it is |
|---|---|---|
| `cechComplexOnX` | `def` | The un-augmented Čech cochain complex `C⁰→C¹→⋯` on `X` (the identity-pushforward analogue of `relativeCechComplexOfNerve`); the object whose exactness—after prepending `ε`—is `cechAugmented_exact`. |
| `cechNervePointIso` | `def` | Canonical iso `(CechNerve 𝒰 F).left ≅ F` (augmentation point `(𝟙 X)_*(𝟙 X)^*F ≅ F` via the pushforward/pullback unitors); prerequisite for constructing the augmentation map. |
| `cechAugmentation` | `def` | The augmentation map `ε : F ⟶ (cechComplexOnX 𝒰 F).X 0`, built from `cechNervePointIso` and the nerve's augmentation NatTrans; the map prepended to form the augmented complex. |
| `cechAugmentation_comp_d` | `lemma` | Proof that `ε ≫ d⁰ = 0` (the cochain complex condition needed to call `CochainComplex.augment`); proved from the abstract `augmentation_comp_alternatingCofaceMap_objD_zero`. |
| `cechAugmentedComplex` | `def` | The augmented Čech complex `0→F→C⁰→C¹→⋯` in `CochainComplex X.Modules ℕ`, built by `cechComplexOnX.augment`. This is the central **object** that `lem:cech_augmented_resolution` (`cechAugmented_exact`) is about. |
| `augmentation_comp_alternatingCofaceMap_objD_zero` | `private lemma` | Abstract reusable lemma: for any augmented cosimplicial object in a preadditive category, `aug.hom.app [0] ≫ objD (drop aug) 0 = 0`. Private; acceptable to omit from blueprint. |

---

## Blueprint adequacy for this file

### Coverage
14 pre-existing public declarations are pinned. **5 new substantive public declarations** (`cechComplexOnX`, `cechNervePointIso`, `cechAugmentation`, `cechAugmentation_comp_d`, `cechAugmentedComplex`) have no `\lean{}` pin. The 1 private lemma (`augmentation_comp_alternatingCofaceMap_objD_zero`) is acceptable to leave unreferenced.

### Structural problem: `lem:cech_augmented_resolution` mixes built and pending

The current blueprint block conflates two separate formalization obligations:

1. **The augmented-complex object layer** — `cechAugmentedComplex` and its four companions — is now **built** axiom-clean. These have no blueprint home at all.
2. **The exactness theorem** `cechAugmented_exact` — is pending, blocked on a genuine Mathlib gap.

The block should be split into:
- A **definition block** (or set of blocks) for `cechComplexOnX` / `cechNervePointIso` / `cechAugmentation` / `cechAugmentation_comp_d` / `cechAugmentedComplex` (all built, `\leanok`-ready after this iter's `sync_leanok`).
- The current `lem:cech_augmented_resolution` lemma block, with the `\lean{AlgebraicGeometry.cechAugmented_exact}` pin retained but the statement noting the pending state explicitly.

### Proof-sketch depth: **under-specified for the pending exactness step**

The proof sketch for `lem:cech_augmented_resolution` (lines 7029–7066) correctly describes the mathematical argument:
- Exactness is a local/stalkwise question.
- Fix a prime `𝔭`; some `fᵢ` is a unit in `A_𝔭`.
- The standard contracting homotopy `h(s)_{i₀…iₚ} = s_{ifix i₀…iₚ}` witnesses nullhomotopy of the localized complex.

However, this sketch **omits** the primary Lean-level obstacle: there is no "a complex of `X.Modules` is exact ↔ it is stalkwise exact" criterion available in Mathlib for the `X.Modules` category (as opposed to `Ab` or `R-Mod`). The stalkwise-exactness reflection step — converting the algebraic nullhomotopy-at-stalks argument back to exactness of the sheaf complex — is the genuine bottleneck the blueprint does not address. A future prover working from this sketch would know *what* to prove but would not know that they first need to either:
  - locate/prove a `stalkwiseExact` reflection lemma for `X.Modules` complexes in Mathlib, or
  - find an alternative route (e.g. reducing to sections-on-affines using the tilde isomorphism machinery already in scope).

### Proof-sketch depth for remaining existing blocks: **adequate**
All other proof sketches in the chapter are consistent with the existing Lean proofs.

### Hint precision: **precise** (for existing blocks)
All `\lean{}` hints name exact Lean declarations whose signatures match the prose.

### Generality: **matches need**

### Recommended chapter-side actions
1. **[major]** Add `\lean{}` definition blocks for `cechComplexOnX`, `cechNervePointIso`, `cechAugmentation`, `cechAugmentation_comp_d`, and `cechAugmentedComplex` — either as a new "Object layer for the augmented Čech complex" subsection between the `relativeCechComplexOfNerve` block and `lem:cech_augmented_resolution`, or as a single multi-decl block.
2. **[major]** Split `lem:cech_augmented_resolution` to separate the "object built" tier from the "exactness pending" tier: give `cechAugmentedComplex` its own definition block (can carry `\leanok` after this iter), and keep the `lem:cech_augmented_resolution` block pointing at the pending `cechAugmented_exact`.
3. **[major]** Augment the proof sketch of `lem:cech_augmented_resolution` to acknowledge the missing Lean infrastructure: note that the stalkwise-exactness reflection for `X.Modules` complexes is not in Mathlib, and sketch which route (stalkwise criterion vs. sections-on-affines detour) the prover should pursue to close the gap.

---

## Severity summary

| Finding | Severity |
|---|---|
| `:= sorry` on `cech_computes_higherDirectImage` (blueprinted substantive theorem) | **must-fix-this-iter** |
| `\lean{AlgebraicGeometry.cechAugmented_exact}` points to a non-existent declaration (aspirational pin, no statement `\leanok`, properly tracked — but the block conflates two obligations) | **major** |
| 5 substantive new declarations (`cechComplexOnX`, `cechNervePointIso`, `cechAugmentation`, `cechAugmentation_comp_d`, `cechAugmentedComplex`) have no `\lean{}` blueprint blocks | **major** |
| `lem:cech_augmented_resolution` proof sketch omits the missing stalkwise-exactness Lean infrastructure (primary blocker for `cechAugmented_exact`) | **major** |
| `lem:cech_augmented_resolution` block should be structurally split to separate the built object layer from the pending exactness theorem | **major** |

**Overall verdict**: The Lean file is consistent with the blueprint on all pre-existing declarations; the new iter-051 object layer (`cechAugmentedComplex` and companions, 5 public + 1 private declaration) is axiom-clean and correctly constructed but entirely absent from the blueprint, constituting a coverage debt of 5 major items plus one must-fix (the `sorry` on `cech_computes_higherDirectImage`). The `\lean{AlgebraicGeometry.cechAugmented_exact}` pin is correctly aspirational and unformalized, but the surrounding block structure needs to be split and the proof sketch extended to document the missing Lean infrastructure.
