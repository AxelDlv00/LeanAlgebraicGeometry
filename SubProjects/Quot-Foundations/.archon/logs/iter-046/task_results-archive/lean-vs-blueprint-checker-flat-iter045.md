# Lean ↔ Blueprint Check Report

## Slug
flat-iter045

## Iteration
045

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (chapter: `thm:generic_flatness_algebraic`)
- **Lean target exists**: yes (line 1982)
- **Signature matches**: yes — `(A B M : Type u) [CommRing A] [IsDomain A] [IsNoetherianRing A] [CommRing B] [Algebra A B] [Algebra.FiniteType A B] [AddCommGroup M] [Module B M] [Module.Finite B M] [Module A M] [IsScalarTower A B M] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)` — matches the single-universe blueprint pin verbatim.
- **Proof follows sketch**: yes — the Lean proof splits on `Module.Finite A M`: the primary route closes by `exists_free_localizationAway_of_finite`; the surviving residue runs `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` with the L1/L3 obligations, matching the blueprint's primary route + fallback dévissage structure.
- **notes**: `\leanok` (statement block) correct; proof block also closed (iter-022 NOTE in blueprint). Axiom-clean.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_finite}` (chapter: `lem:gf_finite_module`)
- **Lean target exists**: yes (line 106)
- **Signature matches**: yes — `(A M : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] [AddCommGroup M] [Module A M] [Module.Finite A M] : ∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)`
- **Proof follows sketch**: yes — `Module.FinitePresentation.exists_free_localizedModule_powers` at the generic point, matching the blueprint's `lem:fp_free_descent`.
- **notes**: `\leanok` correct.

### `\lean{Module.FinitePresentation.exists_free_localizedModule_powers}` (chapter: `lem:fp_free_descent`)
- **Lean target exists**: yes (Mathlib, `\mathlibok`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_torsion}` (chapter: `lem:gf_torsion_base`)
- **Lean target exists**: yes (line 169)
- **Signature matches**: yes — `A B M : Type*`, `[Subsingleton (LocalizedModule (nonZeroDivisors A) M)]` encodes `M_K = 0`, matching the blueprint.
- **Proof follows sketch**: yes — product-of-annihilators construction matching the Nitsure §4 base case.
- **notes**: `\leanok` correct.

### `\lean{IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime}` (chapter: `lem:noeth_prime_filtration`)
- **Lean target exists**: yes (Mathlib, `\mathlibok`)
- **Signature matches**: yes

### `\lean{AlgebraicGeometry.GenericFreeness.exact_localizedModule_powers_of_shortExact}` (chapter: `lem:gf_splice_shortExact_localized_exact`)
- **Lean target exists**: yes (line 221)
- **Signature matches**: yes — three-type short-exact, `f : A`, localised maps injective/surjective/exact.
- **Proof follows sketch**: yes — direct application of `LocalizedModule.map_injective`, `map_surjective`, `map_exact`.
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_free_of_eq_mul}` (chapter: `lem:gf_splice_shortExact_free_transport`)
- **Lean target exists**: yes (line 249)
- **Signature matches**: yes — `{f f' f'' : A} (hf : f = f' * f'')`, freeness of `N_{f'}` implies freeness of `N_f`.
- **Proof follows sketch**: yes — uses `IsLocalization.Away.awayToAwayLeft` + `IsBaseChange.comp`.
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.GenericFreeness.free_of_shortExact_of_free_free}` (chapter: `lem:gf_splice_shortExact_split`)
- **Lean target exists**: yes (line 337)
- **Signature matches**: yes
- **Proof follows sketch**: yes — projective lifting, `splitSurjectiveEquiv`, `Module.Free.of_equiv`.
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_shortExact}` (chapter: `lem:gf_splice_shortExact`)
- **Lean target exists**: yes (line 361)
- **Signature matches**: yes — `f := f' * f''` as per blueprint.
- **Proof follows sketch**: yes — L3a+L3b+L3c assembly.
- **notes**: `\leanok` correct.

### `\lean{exists_finite_inj_algHom_of_fg}` (chapter: `lem:noether_normalization_fg`)
- **Lean target exists**: yes (Mathlib, `\mathlibok`)

### `\lean{AlgebraicGeometry.GenericFreeness.gf_clear_one_denominator}` (chapter: `lem:gf_clear_one_denominator`)
- **Lean target exists**: yes (line 410)
- **Signature matches**: yes — uses `IsLocalization.map` encoding for `A_g → K` (documented as intended in the blueprint NOTE).
- **Proof follows sketch**: yes — `IsLocalization.exist_integer_multiples` over the support.
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (chapter: `lem:gf_noether_clear_denominators`)
- **Lean target exists**: yes (line 506)
- **Signature matches**: yes — four-existential form with compatibility conjunct as per blueprint NOTE (iter-022).
- **Proof follows sketch**: yes — Steps 1-3 of the blueprint's Noether normalisation with denominators.
- **notes**: `\leanok` correct. Large heartbeat settings (`4000000`) are justified; documented in the file.

### `\lean{AlgebraicGeometry.GenericFreeness.isLocalization_lift_injective}` (chapter: `lem:gf_isLocalization_lift_injective`)
- **Lean target exists**: yes (line 473)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `IsLocalization.lift_injective_iff`.
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_generic_rank_ses}` (chapter: `lem:gf_generic_rank_ses`)
- **Lean target exists**: yes (line 976)
- **Signature matches**: yes — `(A : Type*) [CommRing A] [IsDomain A] [IsNoetherianRing A] (d : ℕ) (N : Type*)` with `MvPolynomial (Fin d) A`-module structure.
- **Proof follows sketch**: yes — generic rank via `Module.finBasis`, denominator clearing, torsion-cokernel argument.
- **notes**: `\leanok` correct.

### `\lean{Submodule.annihilator_top_inter_nonZeroDivisors}` (chapter: `lem:annihilator_meets_nonZeroDivisors`)
- **Lean target exists**: yes (Mathlib, `\mathlibok`)

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_annihilator}` (chapter: `lem:gf_torsion_annihilator`)
- **Lean target exists**: yes (line 1083)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.GenericFreeness.T1}` (chapter: `def:gf_nagata_T1`)
- **Lean target exists**: yes (line ~1141) — but declared `private noncomputable abbrev T1`
- **Signature matches**: yes — `aeval fun i ↦ if i = 0 then X 0 else X i + c • X 0 ^ r i`
- **Proof follows sketch**: N/A (definition)
- **notes**: **MINOR** — blueprint pins with `\lean{AlgebraicGeometry.GenericFreeness.T1}` as a public name, but the Lean declaration is `private`; the name is not accessible outside the file. The `\leanok` set by `sync_leanok` (which scans within the file) is correct for its purpose, but the public `\lean{...}` pin is misleading. Same applies to `t1_comp_t1_neg`, `T`, `lt_up`, `sum_r_mul_ne`, `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`, `finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`.

### `\lean{AlgebraicGeometry.GenericFreeness.t1_comp_t1_neg}` (chapter: `lem:gf_t1_comp_t1_neg`)
- **Lean target exists**: yes (line ~1146), `private`
- **Signature matches**: yes
- **notes**: Same privacy note as `T1`.

### `\lean{AlgebraicGeometry.GenericFreeness.T}` (chapter: `def:gf_nagata_T`)
- **Lean target exists**: yes (line ~1150), `private abbrev`
- **Signature matches**: yes — `AlgEquiv.ofAlgHom (T1 f 1) (T1 f (-1)) ...`
- **notes**: Same privacy note.

### `\lean{AlgebraicGeometry.GenericFreeness.lt_up}` through `\lean{AlgebraicGeometry.GenericFreeness.finSuccEquiv_rename_succ}` (chapters: `lem:gf_lt_up`, `lem:gf_sum_r_mul_ne`, `lem:gf_degreeOf_zero_t`, `lem:gf_degreeOf_t_ne_of_ne`, `lem:gf_leadingCoeff_finSuccEquiv_t`, `lem:gf_T_leadingcoeff_eq`, `lem:gf_finSuccEquiv_map_comm`, `lem:gf_finSuccEquiv_rename_succ`)
- **Lean target exists**: yes, all present (lines 1137–1277), all `private`
- **Signature matches**: yes (verified inline with blueprint statement descriptions)
- **notes**: All `private`; same minor discrepancy with public `\lean{...}` pins.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_nagata_monic_lastVar}` (chapter: `lem:gf_nagata_monic_lastVar`)
- **Lean target exists**: yes (line 1242), **public**
- **Signature matches**: yes — `(A : Type*) [CommRing A] [IsDomain A] (m : ℕ) (F : MvPolynomial (Fin (m + 1)) A) (hF : F ≠ 0) : ∃ (g : A) (_ : g ≠ 0) (e : ...), IsUnit (...)` matching the blueprint LEAN SIGNATURE block.
- **Proof follows sketch**: yes
- **notes**: `\leanok` correct.

### `\lean{Polynomial.Monic.finite_quotient}` (chapter: `lem:polynomial_monic_quotient_finite`)
- **Lean target exists**: yes (Mathlib, `\mathlibok`)

### `\lean{AlgebraicGeometry.GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar}` (chapter: `lem:gf_mvPolynomial_quotient_finite_monic`)
- **Lean target exists**: yes (line 1299)
- **Signature matches**: yes — encoded as `RingHom.Finite` of the composite ring map, as per the blueprint NOTE (F-3a).
- **Proof follows sketch**: yes
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.GenericFreeness.gf_torsion_reindex}` (chapter: `lem:gf_torsion_reindex`)
- **Lean target exists**: yes (line 1473)
- **Signature matches**: yes — `∃ (g : A) (_ : g ≠ 0) (m' : ℕ) (_ : m' < d) (_ : Module ...) (_ : IsScalarTower ...), Module.Finite ...` with the redundant `Module A_g T_g` existential dropped as per blueprint NOTE.
- **Proof follows sketch**: yes — Annihilator → Nagata normalisation → Elimination → Localisation transport steps.
- **notes**: `\leanok` correct. Raised heartbeats (`4000000`) documented.

### `\lean{AlgebraicGeometry.GenericFreeness.pullbackModuleAddEquiv}`, `\lean{AlgebraicGeometry.GenericFreeness.finite_of_pullbackModuleAddEquiv}`, `\lean{AlgebraicGeometry.GenericFreeness.pullback_isScalarTower}` (chapter: `lem:gf_pullback_module_transport`)
- **Lean target exists**: yes (lines 1358, 1376, 1391)
- **Signature matches**: yes — three separate declarations as the blueprint specifies.
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.GenericFreeness.finite_of_quotientRingEquiv}` (chapter: `lem:gf_finite_of_quotient_ringequiv`)
- **Lean target exists**: yes (line 1408)
- **Signature matches**: yes
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.GenericFreeness.isLocalizedModule_restrictScalars}` (chapter: `lem:gf_islocalizedmodule_restrictscalars`)
- **Lean target exists**: yes (line 1426)
- **Signature matches**: yes
- **notes**: `\leanok` correct.

### `\lean{IsLocalization.Away.mul_of_associated}` (chapter: `lem:isLocalization_away_mul_of_associated`)
- **Lean target exists**: yes (Mathlib, `\mathlibok`)

### `\lean{Module.Free.of_ringEquiv}` (chapter: `lem:module_free_of_ringEquiv`)
- **Lean target exists**: yes (Mathlib, `\mathlibok`)

### `\lean{AlgebraicGeometry.GenericFreeness.free_localizationAway_of_away_tower}` (chapter: `lem:gf_away_tower_descent`)
- **Lean target exists**: yes (line 1716)
- **Signature matches**: yes — `(A T : Type u)` shared universe; `{g : A} (hg : g ≠ 0) {h : Localization.Away g} (hh : h ≠ 0)`.
- **Proof follows sketch**: yes — ring identification via `IsLocalization.Away.mul_of_associated`, module identification via `IsBaseChange.comp`, freeness transport via `Module.Free.of_basis`.
- **notes**: `\leanok` correct. Blueprint NOTE (iter-022) correctly says `IsBaseChange.comp` is used.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_polynomial}` (chapter: `lem:gf_polynomial_core`)
- **Lean target exists**: yes (line 1838)
- **Signature matches**: yes — `(A : Type u)` and `(N : Type u)` shared universe, as required by the blueprint NOTE.
- **Proof follows sketch**: yes — strong induction on `d` generalising `A` (and `N`), with the base case and five-step inductive step matching the blueprint.
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_flat_localizationAway_of_finite}` (chapter: `lem:gf_flat_finite`)
- **Lean target exists**: yes (line 121)
- **Signature matches**: yes
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.GenericFreeness.exists_free_localizationAway_of_moduleFinite}` (chapter: `lem:gf_free_moduleFinite`)
- **Lean target exists**: yes (line 136)
- **Signature matches**: yes
- **notes**: `\leanok` correct.

### `\lean{AlgebraicGeometry.gf_qcoh_fintype_finite_sections}` (chapter: `lem:gf_qcoh_fintype_finite_sections`)
- **Lean target exists**: **no** — no declaration with this name exists in the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint has no `\leanok` for this block; the absence is accurately reflected. The **locality-reduction half** of G1 was landed this iter as `gf_finite_sections_of_basicOpen_finite_cover` (see unreferenced declarations section). The **base case** (sheaf-epi ⟹ module-surjective ⟹ module finite) is still missing; see "G1 split" recommendation below.

### `\lean{AlgebraicGeometry.gf_flat_locality_assembly}` (chapter: `lem:gf_flat_locality_assembly`)
- **Lean target exists**: **no** — no declaration with this name exists in the Lean file
- **Signature matches**: N/A
- **notes**: Blueprint has no `\leanok`; correctly reflected as unformalized. G3 is explicitly deferred in the Lean file's inline comment.

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`)
- **Lean target exists**: yes (line 2280)
- **Signature matches**: yes — `{S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S] (p : X ⟶ S) [LocallyOfFiniteType p] [QuasiCompact p] (F : X.Modules) [F.IsQuasicoherent] [F.IsFiniteType] : ∃ (V : S.Opens), (V : Set S).Nonempty ∧ ∀ {U : S.Opens} (_ : IsAffineOpen U) (_ : U ≤ V) {W : X.Opens} (_ : IsAffineOpen W) (e : W ≤ p ⁻¹ᵁ U), letI : Module Γ(S, U) Γ(F, W) := ..., Module.Flat Γ(S, U) Γ(F, W)`. Matches the blueprint header precisely, including `[QuasiCompact p]` (iter-023 re-sign, documented in both Lean and blueprint).
- **Proof follows sketch**: N/A (body is `sorry`)
- **notes**: Blueprint correctly has `\leanok` on statement block; proof block has no `\leanok`. The `sorry` is expected, properly documented, and the iter-023 NOTE in the blueprint acknowledges the re-sign.

---

## Red flags

### Placeholder / suspect bodies
- `AlgebraicGeometry.genericFlatness` at line 2280: body is `sorry`. The blueprint correctly does NOT have `\leanok` on the proof block. The statement is sound; the sorry is documented and expected. **Not a must-fix**: the statement is correct and the placeholder is intentional pending G1+G3.

### Excuse-comments
None — all "gap" comments in the file are accurate technical descriptions of what is missing, not excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims
None — all present declarations are axiom-clean (per prior session notes, not re-verified here beyond reading proofs).

### Privacy mismatch with `\lean{...}` pins
The following blueprint `\lean{...}` pins reference declarations that are `private` in Lean:
- `AlgebraicGeometry.GenericFreeness.T1` (`private noncomputable abbrev T1`)
- `AlgebraicGeometry.GenericFreeness.t1_comp_t1_neg` (`private lemma`)
- `AlgebraicGeometry.GenericFreeness.T` (`private noncomputable abbrev`)
- `AlgebraicGeometry.GenericFreeness.lt_up` (`private lemma`)
- `AlgebraicGeometry.GenericFreeness.sum_r_mul_ne` (`private lemma`)
- `AlgebraicGeometry.GenericFreeness.degreeOf_zero_t` (`private lemma`)
- `AlgebraicGeometry.GenericFreeness.degreeOf_t_ne_of_ne` (`private lemma`)
- `AlgebraicGeometry.GenericFreeness.leadingCoeff_finSuccEquiv_t` (`private lemma`)
- `AlgebraicGeometry.GenericFreeness.T_leadingcoeff_eq` (`private lemma`)
- `AlgebraicGeometry.GenericFreeness.finSuccEquiv_map_comm` (`private theorem`)
- `AlgebraicGeometry.GenericFreeness.finSuccEquiv_rename_succ` (`private theorem`)

These declarations exist within the file (so `sorry_analyzer` finds them and `sync_leanok` sets `\leanok` correctly) but are inaccessible from outside. The `\lean{...}` pins in the blueprint are technically unreachable as public API, though the mathematical content is correct. **Minor severity.**

---

## Unreferenced declarations (informational)

### New iter-045 declarations with no blueprint block — **should be added** (major)

1. **`AlgebraicGeometry.finite_localizedModule_of_isLocalizedModule`** (line 2173):
   - Signature: `{R : Type*} [CommRing R] (S : Submonoid R) {M : Type*} ... (φ : M →ₗ[R] N) [IsLocalizedModule S φ] [Module.Finite Rₚ N] : Module.Finite (Localization S) (LocalizedModule S M)`
   - Role: transport helper — given a `Module.Finite Rₚ N` where `Rₚ = IsLocalization S`, transfers finiteness to the canonical `LocalizedModule S M` over `Localization S`. Used to feed the gap2 keystone's section-restriction linear map into Mathlib's `Module.Finite.of_localizationSpan_finite`, which requires the canonical `LocalizedModule`/`Localization` models.
   - **No blueprint block.** Needs a `\begin{lemma}...\end{lemma}` entry (as a helper for G1) with `\lean{AlgebraicGeometry.finite_localizedModule_of_isLocalizedModule}`.

2. **`AlgebraicGeometry.gf_finite_sections_of_basicOpen_finite_cover`** (line 2231):
   - Signature: `{X : Scheme.{u}} (F : X.Modules) [F.IsQuasicoherent] {W : X.Opens} (hW : IsAffineOpen W) (t : Finset Γ(X, W)) (ht : Ideal.span (t : Set Γ(X, W)) = ⊤) (H : ∀ g ∈ t, Module.Finite Γ(X, X.basicOpen g) Γ(F, X.basicOpen g)) : Module.Finite Γ(X, W) Γ(F, W)`
   - Role: G1 locality reduction — if `D(g)` basic opens cover `W` and each has finite section module, then `W` has finite section module. Assembled from gap2 keystone `Scheme.Modules.isLocalizedModule_basicOpen` + `finite_localizedModule_of_isLocalizedModule` + Mathlib's `Module.Finite.of_localizationSpan_finite`.
   - **No blueprint block.** This is the completed half of `lem:gf_qcoh_fintype_finite_sections`; it needs its own `\begin{lemma}...\end{lemma}` entry.

### Other unreferenced declarations (acceptable helpers)
All other unreferenced declarations are either `private` (intentional internal helpers) or auxiliary defs (`pullbackModuleAddEquiv` at line 1358 which is `@[reducible] def` — technically referenced indirectly by `finite_of_pullbackModuleAddEquiv` and already covered by the `lem:gf_pullback_module_transport` multi-pin).

---

## Blueprint adequacy for this file

**Coverage**: 43/43 `\lean{...}` blocks have corresponding Lean declarations (2 absent: `gf_qcoh_fintype_finite_sections` and `gf_flat_locality_assembly`, both without `\leanok` — correctly reflects current state) plus 2 new unreferenced substantive declarations from this iter.

**Proof-sketch depth**: **adequate for the formalized subset**. Every blueprint proof block that has a `\leanok` marker has a matching substantive Lean proof. The unformalized blocks (G1, G3, `genericFlatness` proof) are appropriately left without `\leanok`.

**Hint precision**: **loose in one area** — the Nagata machinery declarations are `private` in Lean but publicly pinned in the blueprint. The mathematical content of the hints is correct; only the accessibility claim is wrong (minor).

**Generality**: **matches need** for the formalized declarations. The single-universe constraint on `genericFlatnessAlgebraic`, `exists_free_localizationAway_polynomial`, and `free_localizationAway_of_away_tower` is documented in the blueprint NOTEs and is a load-bearing constraint, not a weakness.

**G1 split recommendation**: The blueprint should be updated to split `lem:gf_qcoh_fintype_finite_sections` into:
1. A new helper lemma `lem:finite_localizedModule_of_isLocalizedModule` (DONE in iter-045, needs blueprint block)
2. A new locality-reduction lemma (DONE in iter-045 as `gf_finite_sections_of_basicOpen_finite_cover`, needs blueprint block) — could be named `lem:gf_finite_sections_locality_reduction`
3. A base-case lemma (still open: sheaf-epi ⟹ module surjectivity ⟹ finite generation) — named e.g. `lem:gf_finite_sections_base_case`
4. `lem:gf_qcoh_fintype_finite_sections` can then cite the above three as an assembly

This split clearly separates what is done (locality reduction) from what remains (base case), which the current single monolithic `lem:gf_qcoh_fintype_finite_sections` (still un-`\leanok`'d) does not convey.

**Recommended chapter-side actions**:
1. Add a `\begin{lemma}...\begin{proof}...\end{proof}\end{lemma}` block for `finite_localizedModule_of_isLocalizedModule` — the transfer of `Module.Finite` from a concrete `IsLocalizedModule` witness to the canonical model. Cross-reference it from the G1 proof.
2. Add a `\begin{lemma}...\begin{proof}...\end{proof}\end{lemma}` block for `gf_finite_sections_of_basicOpen_finite_cover` — the locality reduction half of G1 (basic-open-cover-finite implies W-finite). Note it as the completed subgoal.
3. Consider splitting the existing `lem:gf_qcoh_fintype_finite_sections` into the three parts above, OR at minimum adding a `% NOTE: locality reduction closed as gf_finite_sections_of_basicOpen_finite_cover; base case still open.` comment.
4. Fix privacy mismatch for Nagata machinery: either make the declarations public (if they are intended for reuse) or replace `\lean{...}` pins with prose descriptions and drop the `\leanok` expectation from the `sync_leanok` scan.

---

## Severity summary

- **major** (2): `AlgebraicGeometry.finite_localizedModule_of_isLocalizedModule` and `AlgebraicGeometry.gf_finite_sections_of_basicOpen_finite_cover` are substantive completed declarations with **no blueprint blocks**. The chapter does not document what was proved this iteration for G1, making it impossible to assess progress from the blueprint alone.
- **minor** (1): 11 Nagata-machinery declarations are `private` in Lean but publicly pinned via `\lean{...}` in the blueprint. The math is correct; the accessibility claim is wrong.
- No must-fix-this-iter findings.

**Overall verdict**: The Lean file faithfully implements the blueprint for all previously-formalized declarations, and the two new iter-045 contributions are mathematically sound; the blocking issue is that the blueprint chapter has not been updated to document these contributions — two substantive declarations (the G1 transport helper and the G1 locality reduction) landed axiom-clean but are entirely absent from the blueprint chapter.
