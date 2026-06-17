# Lean ↔ Blueprint Check Report

## Slug
flat-iter055

## Iteration
055

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean` (3195 lines)
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex` (2363 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (lem:gf_base_case_finite)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — induction on Noether normalisation chain
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (lem:gf_base_case_torsion)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}` (lem:gf_exact_localization)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}` (lem:gf_free_mul)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}` (lem:gf_free_extension)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — ses / dévissage
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (lem:gf_ses_induction)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.GenericFreeness.gf_clear_one_denominator}` (lem:gf_clear_one_denominator)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (lem:gf_noether_normalization_step)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — Noether normalisation via MvPolynomial
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.GenericFreeness.isLocalization_lift_injective}` (lem:gf_isLocalization_lift_injective)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}` (lem:gf_generic_rank_ses)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — uses SES + rank argument
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_annihilator}` (lem:gf_torsion_annihilator)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.GenericFreeness.T1}` (lem:gf_nagata_T1 / blueprint §Nagata)
- **Lean target exists**: yes — declared `private noncomputable abbrev T1` (line 1141)
- **Signature matches**: yes — triangular automorphism of MvPolynomial
- **Proof follows sketch**: yes
- **notes**: `\leanok` present. Declaration is `private` in Lean 4; the qualified name `AlgebraicGeometry.GenericFreeness.T1` is the user-facing name but `private` declarations receive mangled internal names in Lean 4. See **Minor Finding #3** below.

### `\lean{AlgebraicGeometry.GenericFreeness.t1_comp_t1_neg}` (lem:gf_nagata_t1_comp_t1_neg)
- **Lean target exists**: yes — `private lemma t1_comp_t1_neg` (line 1146)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `private` declaration; same naming caveat as T1

### `\lean{AlgebraicGeometry.GenericFreeness.T}` (lem:gf_nagata_T)
- **Lean target exists**: yes — `private noncomputable abbrev T` (line 1150)
- **Signature matches**: yes — AlgEquiv from T1 ± 1
- **Proof follows sketch**: N/A (abbrev)
- **notes**: `\leanok` present; `private` naming caveat applies

### `\lean{AlgebraicGeometry.GenericFreeness.lt_up}` (lem:gf_nagata_lt_up)
- **Lean target exists**: yes — `private lemma lt_up` (line 1137)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present; `private` naming caveat applies

### `\lean{AlgebraicGeometry.GenericFreeness.sum_r_mul_ne}` (lem:gf_nagata_sum_r_mul_ne)
- **Lean target exists**: yes — `private lemma sum_r_mul_ne` (line 1154)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present; `private` naming caveat applies

### `\lean{AlgebraicGeometry.GenericFreeness.degreeOf_zero_t}` (lem:gf_nagata_degreeOf_zero_t)
- **Lean target exists**: yes — `private lemma degreeOf_zero_t` (line 1163)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present; `private` naming caveat applies

### `\lean{AlgebraicGeometry.GenericFreeness.degreeOf_t_ne_of_ne}` (lem:gf_nagata_degreeOf_t_ne_of_ne)
- **Lean target exists**: yes — `private lemma degreeOf_t_ne_of_ne` (line 1179)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present; `private` naming caveat applies

### `\lean{AlgebraicGeometry.GenericFreeness.leadingCoeff_finSuccEquiv_t}` (lem:gf_nagata_leadingCoeff_finSuccEquiv_t)
- **Lean target exists**: yes — `private lemma leadingCoeff_finSuccEquiv_t` (line 1186)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present; `private` naming caveat applies

### `\lean{AlgebraicGeometry.GenericFreeness.T_leadingcoeff_eq}` (lem:gf_nagata_T_leadingcoeff_eq)
- **Lean target exists**: yes — `private lemma T_leadingcoeff_eq` (line 1207)
- **Signature matches**: yes
- **Proof follows sketch**: yes — leading-coefficient identity for Nagata normalisation
- **notes**: `\leanok` present; `private` naming caveat applies

### `\lean{AlgebraicGeometry.GenericFreeness.genericFlatnessAlgebraic}` (thm:generic_flatness_algebraic)
- **Lean target exists**: yes
- **Signature matches**: yes — `∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)` matches prose
- **Proof follows sketch**: yes — full dévissage (prime filtration + Noether normalisation) assembled axiom-clean
- **notes**: `\leanok` present and correct. The `[QuasiCompact p]` signature correction from iter-023 is documented inline.

### `\lean{AlgebraicGeometry.gf_affine_finite_standard_subcover}` (lem:gf_affine_finite_standard_subcover)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.gf_finite_sections_of_basicOpen_finite_cover}` (lem:gf_finite_sections_of_basicOpen_finite_cover)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.gf_qcoh_finite_sections_of_free_epi}` (lem:gf_qcoh_finite_sections_of_free_epi)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — free epi on Spec R gives finite sections
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.gf_localGenerators_restrict}` (lem:gf_localGenerators_restrict)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — GeneratingSections.map engine (seam-1a)
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.gf_finiteType_affine_finite_cover_generated}` (lem:gf_finiteType_affine_finite_cover_generated)
- **Lean target exists**: yes (line 2525)
- **Signature matches**: yes — finset t spanning Ideal, each basicOpen affine with finite GeneratingSections
- **Proof follows sketch**: yes — seam-1 assembly
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.module_finite_of_ringEquiv_semilinear}` (lem:module_finite_of_ringEquiv_semilinear)
- **Lean target exists**: yes (line 2573)
- **Signature matches**: yes — semilinear finiteness transport across ring iso
- **Proof follows sketch**: yes — span_induction with explicit smul step
- **notes**: `\leanok` present and correct. Project-local Mathlib supplement as documented.

### `\lean{AlgebraicGeometry.gf_qcoh_finite_sections_of_genSections}` (lem:gf_qcoh_finite_sections_of_genSections)
- **Lean target exists**: yes (line 2612)
- **Signature matches**: yes — `Module.Finite Γ(X, D) Γ(F, D)` from a finite GeneratingSections on the pullback
- **Proof follows sketch**: yes — three-step Spec transport (isQuasicoherent_pullback_fromSpec + GeneratingSections.map + gammaPullbackImageIso semilinear transport)
- **notes**: `\leanok` present. `set_option maxHeartbeats 1600000` needed; flagged in blueprint.

### `\lean{AlgebraicGeometry.gf_qcoh_fintype_finite_sections}` (lem:gf_qcoh_fintype_finite_sections)
- **Lean target exists**: yes (line 2674)
- **Signature matches**: yes — G1 assembly: `Module.Finite Γ(X, W) Γ(F, W)` for any affine W
- **Proof follows sketch**: yes — cover extraction + G1 base case + locality reduction
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.gf_patch_free_imp_flat}` (lem:gf_patch_free_imp_flat)
- **Lean target exists**: yes (line 2719)
- **Signature matches**: yes — `Module.Flat R M` from `Module.Free R M`
- **Proof follows sketch**: yes — one-liner via `Module.Flat.of_free`
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.gf_stalk_flat_over_base}` (lem:gf_stalk_flat_over_base)
- **Lean target exists**: **no** — declaration `AlgebraicGeometry.gf_stalk_flat_over_base` does NOT exist in the Lean file
- **Signature matches**: N/A — the Lean docstring at lines 2701–2712 explicitly documents the stalk API gap: "Mathlib's `SheafOfModules` API does not yet provide `SheafOfModules.stalk` / `Scheme.Modules.stalk`"
- **Proof follows sketch**: N/A
- **notes**: Blueprint block has no `\leanok` (correct). The `\lean{...}` hint names a non-existent declaration. See **Major Finding #4** below.

### `\lean{AlgebraicGeometry.gf_flat_base_local_on_source}` (lem:gf_flat_base_local_on_source)
- **Lean target exists**: yes (line 2732)
- **Signature matches**: yes — `Module.Flat R N` from per-maximal-ideal hypothesis on source localizations
- **Proof follows sketch**: yes — `Module.flat_of_isLocalized_maximal` instantiation
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.gf_stalk_flat_localBase}` (lem:gf_stalk_flat_localBase)
- **Lean target exists**: yes (line 2746)
- **Signature matches**: yes — `Module.Flat R N` via localization R→R' flat + R'-flatness; transitivity
- **Proof follows sketch**: yes — `IsLocalization.flat` + `Module.Flat.trans`
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.gf_localizedModule_baseChange_tensor_comm}` (lem:gf_localizedModule_baseChange_tensor_comm)
- **Lean target exists**: yes (line 2766)
- **Signature matches**: yes — `LocalizedModule T (N ⊗[R] K) ≃ₗ[R] (LocalizedModule T N) ⊗[R] K`
- **Proof follows sketch**: yes — `IsLocalizedModule.iso` + `rTensor`
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.gf_flat_localizedModule_sameBase}` (lem:gf_flat_localizedModule_sameBase)
- **Lean target exists**: yes (line 2791)
- **Signature matches**: yes — source-ring localization preserves flatness over base
- **Proof follows sketch**: yes — `Module.Flat.iff_lTensor_injectiveₛ` + `IsLocalizedModule.map_lTensor` + exactness
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.gf_crossChart_basicOpen_eq}` (lem:gf_crossChart_basicOpen_eq)
- **Lean target exists**: yes (line 2819)
- **Signature matches**: yes — `X.basicOpen g = X.basicOpen gbar` from restriction-match + containment hypotheses
- **Proof follows sketch**: yes — `X.basicOpen_res` bookkeeping
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.gf_section_localization_twoleg}` (lem:gf_section_localization_twoleg)
- **Lean target exists**: yes (line 2840)
- **Signature matches**: yes — two-leg `IsLocalizedModule` conjunction
- **Proof follows sketch**: yes — two applications of `isLocalizedModule_basicOpen`
- **notes**: `\leanok` present and correct

### `\lean{AlgebraicGeometry.gf_base_localization_comparison}` (lem:gf_base_localization_comparison)
- **Lean target exists**: yes (line 2861)
- **Signature matches**: **partial** — blueprint prose claims `IsLocalization` (R = localization of A_f inside Frac(A)); Lean proves `Module.Flat Γ(S,V) Γ(S,U)` only. See **Major Finding #1**.
- **Proof follows sketch**: no — blueprint sketch argues via "both are rings of fractions of domain A inside its fraction field"; Lean proves flatness via `Flat.flat_appLE (𝟙 S)`, a completely different route
- **notes**: `\leanok` present. Existing iter-054 `% NOTE:` in blueprint documents this discrepancy and recommends action.

### `\lean{AlgebraicGeometry.gf_section_localization_flat_descent}` (lem:gf_section_localization_flat_descent)
- **Lean target exists**: **no** — `AlgebraicGeometry.gf_section_localization_flat_descent` does NOT exist in the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint block has no `\leanok`. The mathematical content of this blueprint block (chart-independent section-localization B2 combination) has been decomposed in the Lean file: the two-leg part lives in `gf_section_localization_twoleg` (B2.2, separately blueprinted) and the span-descent part lives in `gf_section_span_flat_descent` (new in iter-055, not blueprinted). The `\lean{...}` pin is stale. See **Major Finding #2**.

### `\lean{AlgebraicGeometry.gf_common_basicOpen_basis}` (lem:gf_common_basicOpen_basis)
- **Lean target exists**: yes (line 2895) — **new in iter-055**
- **Signature matches**: yes — `∃ (g : Γ(X, W)) (gbar : Γ(X, Wi)), x ∈ X.basicOpen g ∧ X.basicOpen g ≤ W ⊓ Wi ∧ X.basicOpen gbar ≤ W ⊓ Wi ∧ X.basicOpen g = X.basicOpen gbar`
- **Proof follows sketch**: yes — `exists_basicOpen_le_affine_inter` Mathlib lemma packages the recipe; proof matches blueprint sketch
- **notes**: `\leanok` present. Blueprint NOTE (iter-054) correctly notes only basic-open equality (not restriction-matched pair) is achievable; Lean signature agrees.

### `\lean{AlgebraicGeometry.gf_crossChart_spanning_cover}` (lem:gf_crossChart_spanning_cover)
- **Lean target exists**: yes (line 2923)
- **Signature matches**: yes — finite spanning family with per-element chart index + partner section + `D(g) = D(ḡ)` basic-open equality
- **Proof follows sketch**: yes — per-point basis construction + affine quasi-compact finite subcover
- **notes**: `\leanok` present. Blueprint NOTE (iter-054) flags the "restriction-matched pair" over-specification; the blueprint statement body now correctly states only `D(g) = D(ḡ)`. Lean signature matches corrected form.

### `\lean{AlgebraicGeometry.gf_flat_locality_assembly}` (lem:gf_flat_locality_assembly)
- **Lean target exists**: **no** — `AlgebraicGeometry.gf_flat_locality_assembly` does NOT exist in the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint block has no `\leanok`. The assembly's mathematical content is encoded directly in the `genericFlatness` proof body (lines 3127–3192) via `gf_section_span_flat_descent` + `gf_crossChart_spanning_cover`. The `\lean{...}` pin names a non-existent declaration. See **Major Finding #3**.

### `\lean{AlgebraicGeometry.genericFlatness}` (thm:generic_flatness)
- **Lean target exists**: yes (line 3036)
- **Signature matches**: yes — `∃ (V : S.Opens), (V : Set S).Nonempty ∧ ∀ {U} (hU : IsAffineOpen U) (hUV : U ≤ V) {W} (hW : IsAffineOpen W) (e : W ≤ p ⁻¹ᵁ U), Module.Flat Γ(S, U) Γ(F, W)` — matches blueprint statement (with `letI` for the algebra structure)
- **Proof follows sketch**: partial — the witness construction (steps 1–3) and the reduction scaffolding are complete and axiom-clean. The final per-piece flatness (step 4, line 3192) is one `sorry` for the genuinely missing Mathlib ingredient (`IsBaseChange` for open-immersion flat epimorphism). Blueprint does NOT have `\leanok` on the proof block (only on the statement block), which is correct.
- **notes**: Blueprint statement `\leanok` is correctly placed on the statement block (declaration formalized, at least a sorry present). The `[QuasiCompact p]` signature extension from iter-023 is present in the Lean signature and reflected in the blueprint proof (Step 1 mentions `[QuasiCompact p]`).

---

## Red flags

### Placeholder / suspect bodies
None. The single `sorry` at line 3192 is inside `genericFlatness`, documenting the genuinely absent Mathlib piece (`IsBaseChange Γ(S,U) (id : · →ₗ[A_f] ·)` for the open-immersion flat epimorphism). The blueprint does NOT have `\leanok` on the proof block of `thm:generic_flatness`, so the sorry does not contradict any marker. The formal statement exists and is the correct one.

No `:= sorry`, `:= True`, or trivial-tautology bodies on any blueprint-claimed substantive statement.

### Excuse-comments
None. The inline comments in the `genericFlatness` proof body (lines 3062–3126) explain a signature correctness fix (iter-023 `[QuasiCompact p]` addition) and a detailed status report of what's done vs. what's missing — these are informational, not excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims
None detected. All declarations are `noncomputable` where appropriate (constructive use of `Classical.choice` in `gf_qcoh_finite_sections_of_genSections` and `genericFlatness` via `classical` tactic is expected given the non-constructive existence statements).

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` reference in the blueprint:

1. **`gf_section_span_flat_descent`** (line 2962) — proved axiom-clean. Source-span flatness descent: if each `Γ(F, D(g))` for `g ∈ t` is flat over `Γ(S, U)` and `t` spans the unit ideal of `Γ(X, W)`, then `Γ(F, W)` is flat over `Γ(S, U)`. This is the span-descent core that `genericFlatness` consumes. The docstring says it corresponds to blueprint `lem:gf_flat_locality_assembly`; the content is close to `lem:gf_section_localization_flat_descent` (B2 combo) but is the span-descent piece, not the two-leg piece. **Should receive a dedicated `\lean{...}` blueprint entry.**

2. **`gf_flat_of_isBaseChange_id`** (line 3014) — proved axiom-clean. Per-piece base descent: `Module.Flat R M` from `IsBaseChange R (id : M →ₗ[A] M)`. New in iter-055. The blueprint proof sketch for `genericFlatness` implicitly relies on this at Step 4, but no `\lean{...}` pin exists. **Should receive a dedicated blueprint entry (or be folded into `lem:gf_flat_locality_assembly` with a corrected `\lean{...}`).**

3. **`private theorem finSuccEquiv_map_comm`** (line 1115) and **`private theorem finSuccEquiv_rename_succ`** (line 1275) — `private` helper lemmas for the Nagata/MvPolynomial section; not expected to be separately blueprinted.

---

## Blueprint adequacy for this file

- **Coverage**: 30/32 substantive Lean declarations have a corresponding `\lean{...}` block. Unreferenced: 2 substantive (`gf_section_span_flat_descent`, `gf_flat_of_isBaseChange_id`); ~2 pure helpers (`finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`).
- **Proof-sketch depth**: **adequate** for all proved declarations. G1 (seam-1a/seam-1b/G1 base case/assembly), G3 (G3.1/G3.3/G3.4/B1.0/B1/B2.1/B2.2/B2.3/B2.4), and `genericFlatnessAlgebraic` all have proof sketches that are detailed enough to have guided the formalization. The `gf_section_span_flat_descent` is absent from the blueprint (under-specified gap); the `genericFlatness` proof body sketch is adequate for the portion that has been formalized.
- **Hint precision**: **loose on three blocks** — `lem:gf_stalk_flat_over_base`, `lem:gf_section_localization_flat_descent`, `lem:gf_flat_locality_assembly` all carry `\lean{...}` hints that name non-existent Lean declarations. These hints are therefore not just imprecise but **stale/wrong**.
- **Generality**: matches need overall.
- **Recommended chapter-side actions**:
  - Update `\lean{AlgebraicGeometry.gf_section_localization_flat_descent}` → split into `\lean{AlgebraicGeometry.gf_section_localization_twoleg}` (already separately blueprinted) and add a new block `lem:gf_section_span_flat_descent` with `\lean{AlgebraicGeometry.gf_section_span_flat_descent}`.
  - Update `\lean{AlgebraicGeometry.gf_flat_locality_assembly}` → either (a) drop the block and incorporate its content into `lem:gf_section_span_flat_descent` + the `genericFlatness` proof sketch, or (b) keep as an aspirational placeholder and add a `% NOTE:` documenting the route change.
  - `lem:gf_stalk_flat_over_base` → add `% NOTE:` documenting that the stalk API is absent from Mathlib; the flatness at stalks is now approached via the source-span route in `genericFlatness` rather than the stalk-pointwise route.
  - `lem:gf_base_localization_comparison` — downgrade prose from `IsLocalization` to `Module.Flat` (already noted by iter-054 NOTE; the NOTE recommends this action).
  - Add `lem:gf_flat_of_isBaseChange_id` block with `\lean{AlgebraicGeometry.gf_flat_of_isBaseChange_id}` and a one-line proof sketch.

---

## Severity summary

### Must-fix-this-iter
None.

### Major

**#1 — `gf_base_localization_comparison` prose/code signature mismatch (pre-existing iter-054)**
Blueprint `lem:gf_base_localization_comparison` prose: "`R` is a localization of `A_f`" (`IsLocalization`).
Lean: `Module.Flat Γ(S,V) Γ(S,U)` only.
The existing iter-054 `% NOTE:` in the blueprint documents this and recommends action (downgrade prose or strengthen Lean). Not must-fix because: (a) the NOTE is in place, (b) the weaker flatness is all the assembly consumes, (c) the `\leanok` marker is on the statement block not the proof body. However, the mismatch has persisted since iter-054 and should be resolved.

**#2 — `lem:gf_section_localization_flat_descent` carries a stale `\lean{...}` pin**
Blueprint pins `\lean{AlgebraicGeometry.gf_section_localization_flat_descent}` (no `\leanok`). This declaration does NOT exist in the Lean file. The mathematical content has been split: the two-leg piece is `gf_section_localization_twoleg` (separately blueprinted, `\leanok`); the span-descent piece is `gf_section_span_flat_descent` (proved but not blueprinted). The blueprint block is both unreachable (wrong name) and under-covers what Lean actually does.

**#3 — `lem:gf_flat_locality_assembly` carries a stale `\lean{...}` pin**
Blueprint pins `\lean{AlgebraicGeometry.gf_flat_locality_assembly}` (no `\leanok`). This declaration does NOT exist in the Lean file. The assembly has been dissolved into `gf_section_span_flat_descent` + the `genericFlatness` proof body. The blueprint block describes an aspirational lemma whose route was superseded.

**#4 — `lem:gf_stalk_flat_over_base` carries a stale `\lean{...}` pin**
Blueprint pins `\lean{AlgebraicGeometry.gf_stalk_flat_over_base}` (no `\leanok`). This declaration does NOT exist in the Lean file, blocked by the missing `SheafOfModules.stalk` API. The Lean file explicitly documents this at lines 2701–2712. The blueprint block should either be marked as blocked-by-Mathlib or given a `% NOTE:` explaining the route change.

### Minor

**#M1 — `private` Nagata declarations referenced by unmangled public names**
The blueprint references `T1`, `T`, `lt_up`, `sum_r_mul_ne`, `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq` by their user-facing qualified names (e.g. `\lean{AlgebraicGeometry.GenericFreeness.T1}`). In Lean 4, `private` declarations receive mangled internal names. `sync_leanok` relies on `lake env lean` to resolve `\lean{...}` declarations; the `\leanok` markers on these blocks may have been set correctly (if the sync uses a file-grep path) or may not survive a fresh `sync_leanok` run on a clean environment. Low risk if the sync works empirically, but the blueprint and Lean are slightly inconsistent in naming convention.

**#M2 — `gf_section_span_flat_descent` and `gf_flat_of_isBaseChange_id` have no `\lean{...}` blueprint entries**
Both are proved axiom-clean in iter-055 but are invisible to the blueprint. The blueprint cannot track their proof status or dependencies. Should be added as blueprint blocks (or consolidated under existing blocks).

**#M3 — `gf_crossChart_spanning_cover` blueprint prose over-specification (pre-existing iter-054)**
Blueprint NOTE (iter-054) already flags this: the prose "matched pair that agree over the overlap" is over-specified. The current `lem:gf_crossChart_spanning_cover` statement body appears corrected (delivers only `D(g) = D(ḡ)`), so this NOTE is partially addressed at the blueprint level. The `\begin{proof}` body still mentions the old recipe using restriction equality; the minor residue is the proof sketch not being updated to match the simplified statement.

---

**Overall verdict**: No must-fix-this-iter issues. Three major stale `\lean{...}` pins (`gf_section_localization_flat_descent`, `gf_flat_locality_assembly`, `gf_stalk_flat_over_base`) pointing to non-existent declarations need blueprint updates in the next plan phase; one pre-existing major prose/code mismatch (`gf_base_localization_comparison` IsLocalization vs. Module.Flat) documented since iter-054 requires resolution. Two new proved declarations (`gf_section_span_flat_descent`, `gf_flat_of_isBaseChange_id`) need blueprint entries.
