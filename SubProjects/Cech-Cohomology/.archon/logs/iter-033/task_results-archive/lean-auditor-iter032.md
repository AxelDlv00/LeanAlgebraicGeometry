# Lean Audit Report

## Slug
iter032

## Iteration
032

## Scope
- files audited: 2
- files skipped (per directive): all other project .lean files — directive narrowed scope to the two files receiving prover work this iteration

## Per-file checklist

### AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`toSheaf_preservesEpimorphisms` doc block (lines 87–121)**: this is a `/-!` section comment, not a Lean declaration. There is no named `toSheaf_preservesEpimorphisms` theorem or def anywhere in the file. The comment accurately describes a genuine Mathlib gap and explicitly says the step is "deferred." Does not masquerade as proved. ✓
  - **No `sorry`**: confirmed by grep. ✓
  - **`affine_faces_mem` (line 37–41)**: clean one-liner using `basicOpen_sprod`. ✓
  - **`coverOpen_affineOpenCoverOfSpan` (lines 53–62)**: proof via `Opens.ext` + `Spec.map_base` + `PrimeSpectrum.localization_away_comap_range`. Correct and standard. ✓
  - **`affine_injective_acyclic` (lines 74–85)**: bridges `cechCohomology` (raw-family form) to the `X.OpenCover` form via `coverOpen_affineOpenCoverOfSpan`, then delegates to `injective_cech_acyclic`. Clean and correct. ✓
  - **`standard_cover_cofinal` (lines 131–180) — FOCUS**:
    - *Statement*: `∃ (n : ℕ) (g : Fin n → R) (φ : Fin n → α), (D(f) = ⨆ i, D(g i)) ∧ ∀ i, D(g i) ≤ W(φ i)`. This is the genuine cofinality/refinement claim: a finite standard subcover of D(f) that refines the given open cover W. Non-vacuous: the hypothesis `hcov : D(f) ≤ ⨆ a, W a` is a real covering condition.
    - *Hypotheses*: nothing weakened or smuggled. The hypothesis is exactly that W covers D(f) as an open cover; no finiteness on W is assumed; α is existentially quantified.
    - *Proof structure*: uses `PrimeSpectrum.isCompact_basicOpen`, `PrimeSpectrum.isTopologicalBasis_basic_opens`, and `IsCompact.elim_finite_subcover` (quasi-compactness argument). The index type `I = {p : R × α // D(p.1) ≤ D(f) ⊓ W(p.2)}` encodes the constraint that each cover element is inside both D(f) and some W a; the proof then extracts a finite subcover. Two bullets match the two conjuncts of the conclusion.
    - *No sorry*. ✓
  - **MINOR (line 134–135)**: `∧` at end of line 135 appears between `PrimeSpectrum.basicOpen (g i)` and `∀ i, ...`, superficially suggesting the `∧` could be the body of the `⨆ i, ...` scope. The only valid Lean parse is `(D(f) = ⨆ i, D(g i)) ∧ (∀ i, ...)` because `Opens ∧ Prop` is ill-typed in the body of `⨆`. The proof confirms the intended parse via two separate bullets. But the layout is a readability trap; adding explicit parentheses or moving `∧` to the start of the next line would eliminate ambiguity.

### AlgebraicJacobian/Cohomology/QcohTildeSections.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **No `sorry`**: confirmed by grep. ✓
  - **`qcoh_iso_tilde_sections` (line 63–65)**: trivial one-liner `(asIso F.fromTildeΓ).symm` under `[IsIso F.fromTildeΓ]`. The conditional form is correctly stated and not mislabelled as unconditional. ✓
  - **`qcoh_iso_tilde_sections_of_presentation` (lines 72–75)**: discharges `[IsIso F.fromTildeΓ]` via `isIso_fromTildeΓ_of_presentation F P`. Correct delegation. ✓
  - **`qcoh_iso_tilde_sections_hom/inv` (lines 78–87)**: both are `rfl` lemmas on the iso hom/inv. Appropriate for `@[simp]`-tagged definitional equalities. ✓
  - **`free_isQuasicoherent` instance (lines 103–106)**: asserts the free sheaf of modules is quasi-coherent via iso to `tildeFinsupp`. Uses `SheafOfModules.isQuasicoherent.{u}.prop_of_iso`. No issue; axiom-clean per prover report. ✓
  - **`isIso_fromTildeΓ_of_genSections` (lines 117–121)**: wraps `F.Presentation` construction and calls `isIso_fromTildeΓ_of_presentation`. Two-line proof, correct. ✓
  - **`qcoh_iso_tilde_sections_of_genSections` (lines 130–134)**: similarly wraps `isIso_fromTildeΓ_of_genSections`. ✓
  - **`exists_finite_basicOpen_subcover` (lines 150–186)**: uses pointwise basic-open extraction + `isCompact_univ.elim_finite_subcover` + `PrimeSpectrum.iSup_basicOpen_eq_top_iff`. Clean proof structure; the Finset-to-Fin reindexing via `equivFin` is standard. ✓
  - **Private helpers (lines 207–321)** — dependency order: `exists_sum_pow_eq_one` → `mem_range_of_span_pow`, `eq_zero_of_span_pow`; `map_smul_endFun`, `bump_eq` → `per_j_surj`, `per_j_eq`. No circular dependencies. Each helper:
    - `exists_sum_pow_eq_one`: uses `Ideal.span_pow_eq_top` and `Ideal.mem_span_range_iff_exists_fun`. Real Mathlib lemmas. ✓
    - `mem_range_of_span_pow`: partition-of-unity surjection descent. Correct `calc` chain. ✓
    - `eq_zero_of_span_pow`: partition-of-unity vanishing descent. Correct `calc` chain. ✓
    - `map_smul_endFun`: `LocalizedModule.induction_on` + `simp`; verifies the commutativity of `LocalizedModule.map` with `algebraMap`. ✓
    - `bump_eq`: pure algebra; `pow_add`/`Nat.sub_add_cancel`/`ring`. ✓
    - `per_j_surj`: uses `IsLocalizedModule.surj` and `IsLocalizedModule.map_LocalizedModules`. Non-trivial unwrapping of the localized module data; proof looks correct. ✓
    - `per_j_eq`: uses `IsLocalizedModule.exists_of_eq` and `LocalizedModule.mk_eq`. Correct. ✓
  - **`isLocalizedModule_of_span_cover` (lines 330–378) — FOCUS**:
    - *Statement*: if `g : M →ₗ[R] N` becomes a localization at powers of `f` after base-changing to each `(s j)`-localization (for a finite unit-ideal-spanning family `s`), then `g` is itself a localization at powers of `f`. This is the genuine P1b descent claim.
    - *Hypotheses non-vacuous*: `hs : Ideal.span (Set.range s) = ⊤` is false for n = 0 in a non-trivial ring (empty span = ⊥), so vacuous inputs are excluded in any non-trivial ring. The hypothesis `h` is substantive (IsLocalizedModule data after each base-change). No weakening detected. ✓
    - *Three IsLocalizedModule clauses discharged* (line 338 `refine ⟨?_, ?_, ?_⟩`):
      1. **map_units** (line 339–350): `f` acts invertibly on N. Reduces to bijectivity via `bijective_of_localized_span (Set.range s) hs`, with per-component bijectivity from `(h j).map_units` using `map_smul_endFun` to transport the endomorphism. ✓
      2. **surj** (line 351–363): every `y : N` hit up to a power of `f`. Uses `per_j_surj` per j, bumps exponents to uniform `(A, K)` via `bump_eq`, then `mem_range_of_span_pow` to descend surjectivity. ✓
      3. **exists_of_eq** (line 364–378): g-equal elements agree up to a power of `f`. Uses `per_j_eq` per j, bumps exponents, `eq_zero_of_span_pow` to get `f^K • (x₁ - x₂) = 0`, concludes with `⟨f^K, K, rfl⟩`. ✓
    - *No sorry*. ✓
  - **Handoff section (lines 382–427)**: `/-!` section doc comment containing code blocks (fenced). These show the planned unconditional upgrade as prose — they are NOT Lean declarations. The comment accurately states which steps are now formalised and what the single remaining gap is (affine global-generation, step 1). Does not masquerade as proved. ✓

## Must-fix-this-iter

None.

## Major

None.

## Minor

- `AffineSerreVanishing.lean:134–135` — `∧` placement at end of line 135 immediately after `PrimeSpectrum.basicOpen (g i)` creates visual ambiguity: a reader might first parse it as `⨆ i, (PrimeSpectrum.basicOpen (g i) ∧ ∀ i, ...)`, which is type-incorrect and therefore rejected by Lean, leaving the intended parse `(D(f) = ⨆ i, D(g i)) ∧ (∀ i, ...)`. The code is correct but the layout is a readability trap. Adding explicit parentheses around the equality or moving `∧` to the start of the next line would remove the ambiguity.

## Excuse-comments (always called out separately)

None.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 1
- **excuse-comments**: 0

Overall verdict: both files are axiom-clean and mathematically correct; `standard_cover_cofinal` is the genuine cofinality claim proved by quasi-compactness; `isLocalizedModule_of_span_cover` genuinely closes all three `IsLocalizedModule` clauses by partition-of-unity descent; the `toSheaf_preservesEpimorphisms` section comment does not masquerade as a proved declaration; the sole finding is a minor layout ambiguity in the `∧` placement of `standard_cover_cofinal`'s conclusion.
