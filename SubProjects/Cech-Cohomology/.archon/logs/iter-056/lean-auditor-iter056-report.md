# Lean Audit Report

## Slug
iter056

## Iteration
056

## Scope
- files audited: 2 (directive narrows scope to modified files this iteration)
- files skipped per directive: 15 other `.lean` files under `AlgebraicJacobian/Cohomology/`

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged (style: `show` used where linter demands `change`; 2 `maxHeartbeats` bumps missing bare `--` comment per linter)
- **excuse-comments**: none

**Notes — new declarations (lines 544–852):**

- **`isAffineOpen_specBasicOpen` (line 545-547).**
  Body: `IsAffine.of_isIso (basicOpenIsoSpecAway r).hom`. Axiom-clean (only `propext`, `Classical.choice`, `Quot.sound`). Mathematically correct: `D(r) ≅ Spec R[1/r]` via `basicOpenIsoSpecAway`. No concerns.

- **`standard_cover_cofinal_affine` (lines 556-600).**
  No `sorry`. Axiom-clean. Structurally identical to `standard_cover_cofinal` with `PrimeSpectrum.isCompact_basicOpen f` replaced by `hV.isCompact` (`IsAffineOpen.isCompact`). The derivation is correct. No concerns.

- **`affine_surj_of_vanishing_affine` (lines 615-739).**
  `set_option maxHeartbeats 1600000` at line 602 is accompanied by a bare `--` comment at line 603 (so the linter is satisfied — no warning fired for that option). Axiom-clean. The `haff` witness at line 666 (`hUsup ▸ hV₀`) correctly transports affineness of `V₀` along the equality `⨆ i, U i = V₀`. The hypothesis `hvanish` is genuinely required (it is the quantified Čech-vanishing input — not vacuous). The proof is essentially a copy of `affine_surj_of_vanishing` with `standard_cover_cofinal_affine` in place of `standard_cover_cofinal`; this duplication is intentional. Two `show` tactics at lines 716 and 735 that change the goal (linter warns to use `change` instead) — minor style issue.

- **`affineCoverSystemGeneral` (lines 755-776).**
  `set_option maxHeartbeats 2000000` at line 743 has a bare `--` comment at line 744-745 (linter satisfied). Axiom-clean.
  - `B := { U | IsAffineOpen U }` — all affine opens. Correct.
  - `Cov` — standard covers `{D(gᵢ)}` whose union is affine. The condition is `IsAffineOpen (⨆ i, D(gᵢ))`, NOT "covers some specific `V`"; rather, covers of any affine `V₀` are found by `standard_cover_cofinal_affine` and then witnessed as lying in `Cov` via `haff`. This is sound.
  - `faces_mem`: uses `basicOpen_sprod` to rewrite `⨅ₖ D(g_{σk}) = D(∏ₖ g_{σk})`, then `isAffineOpen_specBasicOpen`. Correct.
  - `surj_of_vanishing`: routes through `affine_surj_of_vanishing_affine`; the cover found by `standard_cover_cofinal_affine` is passed back to `hvanish` with `haff` witnessing `Cov` membership. Sound.
  - `injective_acyclic`: reuses `injective_cech_acyclicFam` (cover-agnostic); no structural change from `affineCoverSystem`. Sound.

- **`affine_cech_vanishing_qcoh_general_of_tildeVanishing` (lines 799-815).**
  `htilde` is genuine: it requires tilde-section Čech vanishing over standard covers with affine union, which is the change-of-base-to-`Γ(V)` leaf. Cannot be discharged vacuously (e.g., `n=1`, `g = const f` gives a non-trivial instance). Axiom-clean. Reduction via `cechCohomology_isZero_of_iso` + `qcoh_iso_tilde_sections F` is correct.

- **`affine_serre_vanishing_general_of_seed` (lines 824-829).**
  `hseed` is genuine: asserts `HasVanishingHigherCech (affineCoverSystemGeneral R) F`, which is the quantified positivity statement for `F` over all covers in `Cov`. Not satisfiable by vacuity. Axiom-clean. One-line application of `cech_eq_cohomology_of_basis`. Sound.

- **`affine_serre_vanishing_general_of_tildeVanishing` (lines 837-850).**
  Composes the two preceding declarations. `htilde` is identical to the previous; `hV : IsAffineOpen V` is necessary for `affineCoverSystemGeneral`'s basis. Axiom-clean. Sound.

**Pre-existing declaration warnings (not new this iter):**
- Line 220: `set_option maxHeartbeats 1600000` on `affine_surj_of_vanishing` — linter fires because there is a `/--` docstring immediately after instead of a bare `--` comment. The docstring explains the reason but does not satisfy the linter's pattern. Minor style issue.
- Line 363: same situation for `affineCoverSystem`.
- Lines 336, 355: `show` used where `change` is required (linter style). These are in `affine_surj_of_vanishing` (pre-existing).

---

### AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

- **outdated comments**: none
- **suspect definitions**: 2 flagged (Stubs 5 and 6 — provably wrong specifications)
- **dead-end proofs**: 5 flagged (Stubs 1, 2, 4, 5, 6 — all `sorry`)
- **bad practices**: 1 flagged (`set_option synthInstance.maxHeartbeats 800000` on a `sorry`'d stub with no comment)
- **excuse-comments**: none in the strict sense (see analysis below)

**Notes — `pushPull_leg_sections` (Stub 3, lines 163-183) — newly proved:**

Body is term-mode, no `sorry`. Axiom-clean (`propext`, `Classical.choice`, `Quot.sound` only).
Chain:
1. `restrictFunctorIsoPullback j` applied at `j⁻¹V` gives `(j^*F)(j⁻¹V) ≅ (F.restrict j)(j⁻¹V)`.
2. `eqToIso` rewrites the open via `image_preimage_eq_opensRange_inf` + `opensRange_ι` to reach `F(coverInterOpen 𝒰 σ ⊓ V)`.
The `change` step inside `eqToIso` relies on `restrict_obj` being definitionally `rfl` (Lean accepted it — no error). Proof is sound.

**Notes — remaining `sorry` stubs:**

- **Stub 1 (`cechBackbone_left_sigma`, line 76-80):** `sorry`. Pre-existing. Load-bearing (consumed by Stub 2 and the augmented resolution chain).
- **Stub 2 (`pushPull_sigma_iso`, line 125-130):** `sorry`. Pre-existing. Load-bearing. The `set_option synthInstance.maxHeartbeats 800000` at line 124 is on this sorry-stubbed declaration with no explanatory `--` comment — the linter warns at line 124. Minor bad practice: heightbeats options on a sorry stub are meaningless (the sorry compiles instantly) and suggest a leftover from a failed attempt.
- **Stub 4 (`pushPull_eval_prod_iso`, line 212-221):** `sorry`. Pre-existing. Load-bearing.
- **Stub 5 (`cechSection_complex_iso`, line 301-315):** `sorry`. Pre-existing. **Specification is provably wrong** (see analysis below).
- **Stub 6 (`cechSection_contractible`, line 366-372):** `sorry`. Pre-existing. **Specification is provably wrong** (see analysis below).

**Analysis of the `⚠ PROVER FINDING` block (lines 223-258):**

The note claims Stubs 5 and 6 are "mis-specified (provably false as written)". Scrutiny:

*Stub 5 claim assessment — UPHELD.* The consumer in `CechAugmentedResolution.lean` uses `D = (GV.mapHomologicalComplex cc).obj Kp` where `K = cechAugmentedComplex 𝒰 F`. The augmented complex has `K.X 0 = F`, so `D.X 0 = Γ(V,F)`. But `D' = sectionCechComplex (fun i => coverOpen 𝒰 i ⊓ V) Fp` has `D'.X 0 = ∏ᵢ Fp(Uᵢ ∩ V)`. These are structurally different: `Γ(V,F)` vs `∏ᵢ Γ(Uᵢ ∩ V, F)`. A literal isomorphism `D ≅ D'` would require `Γ(V,F) ≅ ∏ᵢ Γ(Uᵢ ∩ V, F)`, which fails for any sheaf with non-trivial multi-open behaviour. The correct target is `D ≅ D'.augment ε hε` (the AUGMENTED version of `D'`). The finding is mathematically airtight.

*Stub 6 claim assessment — UPHELD.* The proposed `Homotopy (𝟙 D') 0` for the non-augmented complex `D'` would force `H*(D') = 0`. The counterexample given: take a one-element cover `𝒰.I₀ = {i_fix}` with `U'_{i_fix} = V ≤ coverOpen 𝒰 i_fix`. Then `D'.X 0 = Fp(V)`, `d⁰: D'.X 0 → D'.X 1` where `D'.X 1 = Fp(V ∩ V) = Fp(V)` and `d⁰ = δ₀ - δ₁ = id - id = 0`. So `H⁰(D') = Fp(V)`. For any non-zero sheaf `F`, this is non-zero — contradicting contractibility. The finding is airtight. Only the AUGMENTED complex `D'_aug` is contractible.

*Is this an excuse-comment?* No. The `⚠ PROVER FINDING` block does not say "temporary wrong definition; will fix later." It provides a mathematically correct analysis that the specs cannot be closed as stated and gives the corrected decomposition for the planner to act on. The comment is a diagnostic, not a placeholder rationalization. However, line 256 — "The original Stub 5/6 `sorry`s below are left untouched (they cannot be closed as stated)" — accurately describes why the stubs remain, and does not claim they are correct. This is appropriate documentation of a re-specification requirement. Not classified as an excuse-comment under the auditor's definition.

---

## Must-fix-this-iter

- `CechSectionIdentification.lean:76` — `cechBackbone_left_sigma` is `:= sorry` on a load-bearing declaration (the Čech backbone identification; consumed by Stub 2 and the augmented resolution chain). Why must-fix: sorry on load-bearing claim.
- `CechSectionIdentification.lean:125` — `pushPull_sigma_iso` is `:= sorry` on a load-bearing declaration (push-pull product decomposition; consumed by Stub 4). Why must-fix: sorry on load-bearing claim.
- `CechSectionIdentification.lean:212` — `pushPull_eval_prod_iso` is `:= sorry` on a load-bearing declaration (degreewise section isomorphism; consumed by Stub 5). Why must-fix: sorry on load-bearing claim.
- `CechSectionIdentification.lean:301` — `cechSection_complex_iso` is `:= sorry` AND its specification is provably wrong: it asserts `D ≅ D'` where `D` is the evaluated augmented complex (degree-0 object = `Γ(V,F)`) and `D'` is the non-augmented section Čech complex (degree-0 object = `∏ᵢ Fp(Uᵢ∩V)`). These objects differ at degree 0 for any non-trivial sheaf; the sorry cannot be closed without re-specification. Why must-fix: sorry on load-bearing claim with demonstrably wrong specification.
- `CechSectionIdentification.lean:366` — `cechSection_contractible` is `:= sorry` AND its specification is provably wrong: a non-augmented section Čech complex is not contractible (explicit counterexample: one-member cover yields `H⁰ = Fp(V) ≠ 0`). The sorry cannot be closed without re-specification to the augmented complex. Why must-fix: sorry on load-bearing claim with demonstrably wrong specification.

---

## Major

- `AffineSerreVanishing.lean:336` — `show` tactic changes the goal; linter demands `change` instead. (In `affine_surj_of_vanishing`, pre-existing.)
- `AffineSerreVanishing.lean:355` — same issue.
- `AffineSerreVanishing.lean:716` — same issue, in `affine_surj_of_vanishing_affine` (new this iteration).
- `AffineSerreVanishing.lean:735` — same issue.
- `AffineSerreVanishing.lean:220` — `set_option maxHeartbeats 1600000` without a bare `--` comment (linter warning; the docstring explains it but does not satisfy the linter pattern). Pre-existing.
- `AffineSerreVanishing.lean:363` — same for `affineCoverSystem`. Pre-existing.
- `CechSectionIdentification.lean:124` — `set_option synthInstance.maxHeartbeats 800000` on `pushPull_sigma_iso` (a `sorry`-stubbed declaration) with no explanatory `--` comment. The heartbeat option has no effect on a sorry stub; suggests a leftover from a failed proof attempt that was not cleaned up.

---

## Minor

- `AffineSerreVanishing.lean` — multiple long lines (linter: lines 225, 369, 370, 372, 463, 464).
- `CechSectionIdentification.lean` — long lines at 48, 85, 113.
- `AffineSerreVanishing.lean` (overall) — `affine_surj_of_vanishing_affine` is a near-verbatim copy of `affine_surj_of_vanishing`, differing only in the source of quasi-compactness (`IsAffineOpen.isCompact` vs `PrimeSpectrum.isCompact_basicOpen`). The duplication is intentional and justified (different `Cov` witnesses needed), but a future refactor to a common helper parameterized by the compactness proof would reduce maintenance surface.

---

## Excuse-comments (always called out separately)

None. The `⚠ PROVER FINDING` block at `CechSectionIdentification.lean:223-258` is a mathematical diagnostic that correctly identifies a specification error, not a placeholder rationalizing wrong-but-used code.

---

## Severity summary

- **must-fix-this-iter**: 5 — these block downstream work (Stubs 1/2/4 cannot feed Stubs 5/6; Stubs 5/6 cannot be proved without re-specification; `CechAugmentedResolution.lean` therefore cannot close its `hSec` residual).
- **major**: 7
- **minor**: 4
- **excuse-comments**: 0

**Overall verdict.** `AffineSerreVanishing.lean` is clean — all 7 new declarations are axiom-clean, their residual hypotheses (`hseed`/`htilde`) are genuine and non-vacuous, and the `BasisCovSystem` structure fields are mathematically sound. `CechSectionIdentification.lean` has one clean new proof (`pushPull_leg_sections`) and a correctly-diagnosed mis-specification of Stubs 5 and 6 that blocks the entire chain; the 5 remaining sorry stubs are all load-bearing and must be addressed, with Stubs 5 and 6 requiring planner re-specification before any proof attempt.
