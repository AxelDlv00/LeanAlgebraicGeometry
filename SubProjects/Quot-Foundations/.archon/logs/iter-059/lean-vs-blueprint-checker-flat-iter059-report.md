# Lean ↔ Blueprint Check Report

## Slug
flat-iter059

## Iteration
059

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean` (3626 lines, fully read)
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex` (2672 lines, fully read)

---

## Summary

`genericFlatness` and all its supporting infrastructure are **axiom-clean** (verified via
`lean_verify`: only `propext`, `Classical.choice`, `Quot.sound`). The `flatV` STEP-3
transport-semilinearity sorry that was the last open gap has been fully closed; the proof
at lines 3433–3621 follows the blueprint sketch step-for-step with no remaining `sorry` in
any declaration in the file.

Blueprint coverage is high and detailed. Two **major** structural findings and three
**minor** findings are reported below. No must-fix-this-iter findings.

---

## Per-declaration (key `\lean{...}` blocks)

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`)
- **Lean target exists**: yes — line 3249
- **Signature matches**: yes
  - Hypotheses: `[IsIntegral S]`, `[IsLocallyNoetherian S]`, `[LocallyOfFiniteType p]`,
    `[QuasiCompact p]`, `[F.IsQuasicoherent]`, `[F.IsFiniteType]`
  - Conclusion: `∃ V : S.Opens, V.Nonempty ∧ ∀ affine U ≤ V, affine W ≤ p⁻¹U, Module.Flat Γ(S,U) Γ(F,W)`
  - Blueprint: "noetherian integral scheme, finite-type morphism, coherent sheaf, non-empty open V with F|_{X_V} flat" — matches
  - Note: `[QuasiCompact p]` is present in the Lean (added to fix a counterexample
    documented in an extensive iter-023 comment, lines 3274–3298); the blueprint prose
    says "finite-type morphism" (= locally finite type + quasi-compact), consistent.
- **Proof follows sketch**: yes — Steps 1–4 of the blueprint proof map exactly to the Lean
  structure (finite affine cover, finite sections on each patch, product element f,
  span-descent via `gf_section_span_flat_descent` + `gf_crossChart_spanning_cover`,
  base descent via `gf_isEpi_restrict_of_affine_le` + `gf_flat_of_isEpi`).
- **`flatV` STEP-3**: fully closed at lines 3433–3621 using:
  - STEP 1: `flat_localization_models` (canonical-model → geometric-model bridge)
  - STEP 2: `gf_flat_isLocalizedModule_sameBase` (source-localize at ḡ)
  - STEP 3: `flat_of_ringEquiv_semilinear (RingEquiv.refl _) … ` (transport along `hbg`)
  - All three sub-steps are exactly as named in the blueprint Step 4 prose (lines 2651–2670).
- **Axiom check**: clean — `{propext, Classical.choice, Quot.sound}` only.

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (chapter: `thm:generic_flatness_algebraic`)
- **Lean target exists**: yes — line 1980
- **Signature matches**: yes — `(A B M : Type*)`, noetherian domain hypotheses, finite
  module and finite-type algebra, conclusion: `∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (powers f) M)`
- **Proof follows sketch**: yes — dévissage via strong induction on `d = #variables`
- **Axiom check**: clean (same standard axioms)

### `\lean{AlgebraicGeometry.flat_of_ringEquiv_semilinear}` (chapter: `lem:flat_of_ringEquiv_semilinear`)
- **Lean target exists**: yes — line 2825
- **Signature matches**: yes — `(e : R ≃+* R') (l : M ≃+ M') (hl : ∀ r x, l (r • x) = e r • l x) [Module.Flat R M] : Module.Flat R' M'`
- **Proof follows sketch**: yes — presents M' as base change R' ⊗[R] M via `IsBaseChange.of_equiv`, then applies `Module.Flat.isBaseChange`.
- **notes**: This is the key STEP-3 helper. The blueprint proof sketch (lines 2106–2116) accurately previews the base-change route.

### `\lean{AlgebraicGeometry.flat_localization_models}` (chapter: `lem:flat_localization_models`)
- **Lean target exists**: yes — line 2884
- **Signature matches**: yes — two localization models `(g, g')` of `M` at `S`, flat over respective localization rings, conclusion transfers flatness from one model to the other.
- **Proof follows sketch**: yes — uses `IsLocalization.algEquiv` + `IsLocalizedModule.linearEquiv` and discharges semilinearity by denominator-clearing.

### `\lean{AlgebraicGeometry.gf_flat_isLocalizedModule_sameBase}` (chapter: `lem:gf_flat_isLocalizedModule_sameBase`)
- **Lean target exists**: yes — line 2808
- **Signature matches**: yes
- **Proof follows sketch**: yes — canonical model, then `IsLocalizedModule.iso` comparison, `Module.Flat.of_linearEquiv`.

### `\lean{AlgebraicGeometry.isLocalizedModule_powers_restrictScalars}` (chapter: `lem:isLocalizedModule_powers_restrictScalars`)
- **Lean target exists**: yes — line 2926
- **Signature matches**: yes — `(f : A) (φ : M →ₗ[B] N) [IsLocalizedModule (powers (algebraMap A B f)) φ] : IsLocalizedModule (powers f) (φ.restrictScalars A)`
- **Proof follows sketch**: yes — three conditions (units, surj, eq_of) checked termmode.

### `\lean{AlgebraicGeometry.gf_isEpi_restrict_of_affine_le}` (chapter: `lem:gf_openImmersion_isEpi`)
- **Lean target exists**: yes — line 3206
- **Signature matches**: yes — `Algebra.IsEpi Γ(S,V) Γ(S,U)` for affine `U ≤ V`
- **Proof follows sketch**: yes — open immersion → mono → `Spec.fullyFaithful` reflects → epi.

### `\lean{AlgebraicGeometry.gf_flat_of_isEpi}` (chapter: `lem:gf_flat_descend_isEpi`)
- **Lean target exists**: yes — line 3191
- **Signature matches**: yes — `[Algebra.IsEpi A R] [Module.Flat A M] : Module.Flat R M`
- **Proof follows sketch**: yes — `TensorProduct.lid'` → `IsBaseChange.of_equiv` → `Module.Flat.isBaseChange`.

### `\lean{AlgebraicGeometry.gf_base_localization_comparison}` (chapter: `lem:gf_base_localization_comparison`)
- **Lean target exists**: yes — line 3026
- **Signature matches**: **partial** — see Major Finding #2 below.
- **Proof follows sketch**: partial — Lean proves flatness via `Flat.flat_appLE (𝟙 S)`, not the
  localization argument in the blueprint prose. The blueprint has a `% NOTE` at lines 2261–2263
  acknowledging this, but the formal statement body and proof sketch still describe an
  `IsLocalization` result.

### `\lean{AlgebraicGeometry.gf_crossChart_spanning_cover}` (chapter: `lem:gf_crossChart_spanning_cover`)
- **Lean target exists**: yes — line 3088
- **Signature matches**: **partial** — see Minor Finding #3 below.
- **Proof follows sketch**: yes (for the actual weaker statement)

### `\lean{AlgebraicGeometry.gf_qcoh_fintype_finite_sections}` (chapter: `lem:gf_qcoh_fintype_finite_sections`)
- **Lean target exists**: yes — line 2672
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.gf_qcoh_finite_sections_of_genSections}` (chapter: `lem:gf_qcoh_finite_sections_of_genSections`)
- **Lean target exists**: yes — line 2610
- **Signature matches**: yes
- **Proof follows sketch**: yes — three-step structure (QC, transport gens, semilinear transport) matches blueprint exactly.

### `\lean{AlgebraicGeometry.module_finite_of_ringEquiv_semilinear}` (chapter: `lem:module_finite_of_ringEquiv_semilinear`)
- **Lean target exists**: yes — line 2571
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.gf_stalk_flat_localBase}` (chapter: `lem:gf_stalk_flat_localBase`)
- **Lean target exists**: yes — line 2744
- **Signature matches**: yes — `(S : Submonoid R) [IsLocalization S R'] ... [Module.Flat R' N] : Module.Flat R N`
- **Proof follows sketch**: yes — two lines, `IsLocalization.flat` + `Module.Flat.trans`
- **notes**: This lemma has `\leanok` in the blueprint and is axiom-clean. However, it is
  **not referenced in the `\uses` block of `thm:generic_flatness` proof** — the final proof
  uses the epi-descent route rather than the stalk-tower route. This is informational;
  see Unreferenced section.

### All remaining `\lean{...}` project blocks
All project-local blocks with `\leanok` in the blueprint (`gf_patch_free_imp_flat`,
`gf_flat_base_local_on_source`, `gf_flat_localizedModule_sameBase`,
`gf_localizedModule_baseChange_tensor_comm`, `gf_crossChart_basicOpen_eq`,
`gf_section_localization_twoleg`, `gf_flat_of_isBaseChange_id`,
`gf_section_span_flat_descent`, `gf_common_basicOpen_basis`,
`gf_localGenerators_restrict`, `gf_finiteType_affine_finite_cover_generated`,
`gf_affine_finite_standard_subcover`, `gf_finite_sections_of_basicOpen_finite_cover`)
were verified present with matching signatures. No discrepancies found.

### All `\mathlibok` blocks
All Mathlib anchor blocks (`Module.Flat.of_free`, `IsLocalization.flat`,
`Module.flat_of_isLocalized_maximal`, `Module.flat_of_isLocalized_span`,
`Module.Flat.trans`, `Module.Flat.isBaseChange`, `Module.Flat.of_linearEquiv`,
`Module.Flat.baseChange`, `Algebra.IsEpi`, `TensorProduct.lid'`,
`CommRingCat.epi_iff_epi`, `Spec.fullyFaithful`, `IsOpenImmersion.mono`,
`IsAffineOpen.isoSpec`, `Module.free_of_isLocalizedModule`,
`Scheme.basicOpen_res`, `Module.Flat.of_isLocalizedModule`) were verified to name
genuine Mathlib declarations via the blueprint's `\mathlibok` marker. No broken pins.

---

## Red flags

No placeholder (`:= sorry`) bodies found in any declaration in the file.
`grep` for actual sorry proof bodies returned empty; `lean_verify` confirms
`genericFlatness` and `genericFlatnessAlgebraic` are axiom-clean.

### Axioms
- `genericFlatness` axioms: `{propext, Classical.choice, Quot.sound}` — standard, no `sorry`.
- `genericFlatnessAlgebraic` axioms: same set — clean.

No `axiom` declarations or `Classical.choice _` on non-trivial claims found. The two
`local instance` warnings from `lean_verify` (lines 1912, 3414) are harmless style warnings,
not red flags.

---

## Major findings

### Major #1 — Private Lean declarations with blueprint `\lean{...}` pins (unreachable)

**Location**: Lean lines ~1108–1269 (`NagataNormalization` section); blueprint
`def:gf_nagata_T1` and associated definition/lemma blocks in the chapter.

The Nagata normalization section declares ~11 symbols as `private`:
`T1`, `T`, `t1_comp_t1_neg`, `lt_up`, `sum_r_mul_ne`, `degreeOf_zero_t`,
`degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`,
`finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`.

The blueprint assigns these `\lean{AlgebraicGeometry.GenericFreeness.T1}`,
`\lean{AlgebraicGeometry.GenericFreeness.T}`, etc.

**Problem**: In Lean 4, `private` declarations receive a name-mangled internal identifier
(the compiler prefixes the declared name with the file path or a hash). The qualified name
`AlgebraicGeometry.GenericFreeness.T1` does not exist in the Lean environment — the pin is
unreachable by any external tool, including `lean_verify`, `#check`, and blueprint tooling.
The `sync_leanok` phase likely cannot locate these declarations, which means their
`\leanok` markers are stale.

**Severity**: **major** — the blueprint markers are unreachable; the declarations exist and
are correct, but the pins are broken. Fixable in-place: either remove `private` from these
declarations (making them accessible as `protected` or package-local), or strip the
`\lean{...}` pins from the blueprint blocks for these internal helpers.

**Recommendation**: Make the Nagata section declarations `protected` (non-private) so the
qualified names match the blueprint pins, OR drop the `\lean{...}` pins from all 11 blocks
and annotate them as internal helpers with a `% NOTE: internal helper, no Lean pin`.

---

### Major #2 — `gf_base_localization_comparison` prose/signature mismatch

**Location**: blueprint `lem:gf_base_localization_comparison` lines 2255–2283; Lean
`gf_base_localization_comparison` lines 3026–3040.

**Blueprint prose (formal statement)**: "the restriction `A_f → R := Γ(S,U)` realises `R`
as a localization of `A_f`" — this is an `IsLocalization`-type claim.

**Lean declaration**: proves `Module.Flat Γ(S,V) Γ(S,U)` (flatness of the restriction
algebra), not `IsLocalization`.

The blueprint has a `% NOTE` comment at lines 2261–2263 acknowledging this:
> *"Planner: downgrade the prose claim to flatness, or strengthen the Lean to `IsLocalization`"*

However, the formal statement body (the `\begin{lemma}...\end{lemma}` text) and its proof
sketch still describe the `IsLocalization` result, so readers of the blueprint will find the
formal lemma statement inconsistent with what the Lean actually proves. The `% NOTE` is in
the `\lean{...}` line comment region, not in the proof block itself.

**Severity**: **major** — the formal statement in the blueprint and the Lean signature say
different things. The `% NOTE` is a recommendation not yet acted upon.

**Recommendation**: The plan agent should update the blueprint's
`lem:gf_base_localization_comparison` formal statement text to say flatness (matching the
Lean), or dispatch a blueprint-writing subagent to do so. Strengthening the Lean to
`IsLocalization` is also acceptable but harder.

---

## Minor findings

### Minor #3 — `gf_crossChart_spanning_cover` over-specified prose (documented gap)

**Location**: blueprint `lem:gf_crossChart_spanning_cover` lines 2527–2566; Lean line 3088.

The blueprint statement and proof sketch speak of a "matched pair … that agree over the
overlap" (restriction-matched pair `g|_O = ḡ|_O`). The Lean delivers only
`X.basicOpen g = X.basicOpen ḡ` (basic-open equality). The blueprint has a `% NOTE` at
lines 2531–2538 acknowledging this ("OVER-SPECIFIED"), but the formal statement text still
uses the stronger language.

**Severity**: **minor** — documented gap; the weaker (achievable) form is what the assembly
consumes, and the blueprint itself calls it out. Should be reconciled to avoid reader confusion.

---

### Minor #4 — `SheafOfModules.GeneratingSections.map` engine without blueprint block

**Location**: Lean lines 2436–2465; no matching `\lean{...}` pin found in the blueprint.

This is the "transport engine" (`GeneratingSections.map`) central to seams 1a and the G1
base case. It takes a generating family and a functor with a colimit-preservation witness
and unit iso, and produces a transported generating family. Multiple Lean docstrings refer to
it as the load-bearing engine of the seam 1a assembly.

`SheafOfModules.GeneratingSections.map_I` and `map_isFiniteType` are also in the Lean without
blueprint coverage.

**Severity**: **minor** — these are project-local infrastructure; their absence from the
blueprint means the chapter provides no guidance for a prover who needs to discover or
re-derive this engine. Worth adding a `\begin{definition}...\end{definition}` block with
`\lean{AlgebraicGeometry.SheafOfModules.GeneratingSections.map}`.

---

### Minor #5 — `gf_stalk_flat_localBase` not used in `genericFlatness` final proof

**Location**: Lean line 2744; blueprint `lem:gf_stalk_flat_localBase`.

The declaration `gf_stalk_flat_localBase` (G3.4) is fully proved and has `\leanok` in the
blueprint. However, the final `genericFlatness` proof uses the ring-epimorphism descent route
(`gf_isEpi_restrict_of_affine_le` + `gf_flat_of_isEpi`) rather than the stalk-tower route.
The `\uses{...}` block in `thm:generic_flatness` proof does not include
`lem:gf_stalk_flat_localBase`.

This is not an error (the theorem is correct and clean), but:
- The blueprint's narrative for the flat-locality assembly (lines 2699–2710) mentions G3.2
  and G3.4 as feeding the assembly; the stalk-based G3.2 (`lem:gf_stalk_flat_over_base`) is
  explicitly noted as absent from Mathlib, which is why the epi route was taken instead.
- The `gf_stalk_flat_localBase` lemma is a free-standing algebraic fact; it may be useful
  in future work.

**Severity**: **minor** — informational. The blueprint narrative should note that the final
proof uses the epi route and that `gf_stalk_flat_localBase` is a standalone lemma no longer
invoked by `genericFlatness`.

---

## Unreferenced declarations (informational)

The following Lean declarations have no `\lean{...}` blueprint pin. Most are helpers; the
notable ones are flagged.

| Declaration | Line | Type | Notes |
|-------------|------|------|-------|
| `isLocalization_lift_injective` | 473 | helper | Internal to L4 proof; OK |
| `pullbackModuleAddEquiv` | 1358 | helper | Torsion-reindex infrastructure; OK |
| `finite_of_pullbackModuleAddEquiv` | 1376 | helper | Same |
| `pullback_isScalarTower` | 1391 | helper | Same |
| `finite_of_quotientRingEquiv` | 1408 | helper | Same |
| `isLocalizedModule_restrictScalars` | 1426 | helper | Same |
| `finite_localizedModule_of_isLocalizedModule` | 2171 | **substantive** | Model-transfer lemma; feeds G1 base case but not pinned |
| `gf_affine_qcoh_Gamma_epi` | 2271 | seam helper | Seam 2; no blueprint block |
| `gf_qcoh_finite_sections_globally_generated` | 2297 | seam helper | Seam 2+3 bridge; no blueprint block |
| `gf_finite_gen_iff_free_epi` | 2388 | seam helper | Seam 1c equiv; no blueprint block |
| `SheafOfModules.GeneratingSections.map` | 2436 | **substantive engine** | See Minor #4 |
| `SheafOfModules.GeneratingSections.map_I` | 2451 | helper | Index-preservation property |
| `SheafOfModules.GeneratingSections.map_isFiniteType` | 2460 | helper | Finiteness-preservation |

The most notable unpin is `finite_localizedModule_of_isLocalizedModule` — it is the
finiteness-transfer across localization models used in the G1 chain. A blueprint block for it
would improve traceability.

---

## Blueprint adequacy for this file

### `flatV` STEP-3 / `genericFlatness` proof sketch adequacy (iter-059 focus)

The blueprint proof of `thm:generic_flatness` (lines 2605–2671) now provides an accurate
and detailed proof sketch for `genericFlatness`. In particular, Step 4 (the `flatV`
transport) names all three key sub-steps:
- **STEP 1**: flat over `A_f` via `lem:gf_flat_localizedModule_sameBase` and `lem:flat_localization_models`
- **STEP 2**: source-localize at ḡ via `lem:gf_flat_isLocalizedModule_sameBase`
- **STEP 3**: transport via `lem:flat_of_ringEquiv_semilinear`

The Lean proof (lines 3433–3621) follows this structure exactly, including the
`ρ`-agreement step (`hsquare`/`morLHS`/`morRHS`) needed for the semilinearity discharge.
The blueprint adequately guided this proof.

### Coverage summary
- **Coverage**: ~44 project-local `\lean{...}` blocks, all with matching Lean declarations.
  ~13 Lean declarations are unreferenced (mostly helpers; see table above).
- **Proof-sketch depth**: **adequate** for all major theorems. The Lean proofs are faithful
  formalizations of the corresponding blueprint sketches.
- **Hint precision**: **mostly precise** — see Major #2 (`gf_base_localization_comparison`
  prose/type mismatch) and Minor #3 (`gf_crossChart_spanning_cover` over-specification).
- **Generality**: **matches need** — no cases where the blueprint defined something too
  narrow and the Lean had to work around it.
- **Recommended chapter-side actions**:
  1. Either remove `\lean{...}` pins from the 11 private Nagata declarations, or make those
     declarations non-private to re-enable the pins (Major #1).
  2. Update `lem:gf_base_localization_comparison` formal statement to match the Lean: state
     flatness of `Γ(S,U)` over `Γ(S,V)`, not IsLocalization (Major #2).
  3. Add a `\begin{lemma}` block for `SheafOfModules.GeneratingSections.map` (Minor #4).
  4. Add a note to the `thm:generic_flatness` proof sketch saying `gf_stalk_flat_localBase`
     is a standalone lemma not used in the final epi-descent route (Minor #5).

---

## Severity summary

| # | Finding | Severity |
|---|---------|----------|
| 1 | 11 private Nagata declarations with broken blueprint `\lean{...}` pins | **major** |
| 2 | `gf_base_localization_comparison` blueprint prose claims `IsLocalization`, Lean proves `Module.Flat` | **major** |
| 3 | `gf_crossChart_spanning_cover` blueprint over-specifies restriction-match (documented) | minor |
| 4 | `SheafOfModules.GeneratingSections.map` engine has no blueprint block | minor |
| 5 | `gf_stalk_flat_localBase` proved but unused by final `genericFlatness` proof | minor |

**Overall verdict**: `genericFlatness` and its full support infrastructure are axiom-clean
and faithful to the blueprint; 2 major structural issues (broken private pins, one
prose/type divergence) and 3 minor issues require cleanup but do not block downstream work.
