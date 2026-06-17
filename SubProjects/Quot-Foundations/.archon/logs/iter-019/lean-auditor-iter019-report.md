# Lean Audit Report

## Slug
iter019

## Iteration
019

## Scope
- files audited: 3
- files skipped: 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor heartbeat bump concern)
- **excuse-comments**: none
- **notes**:
  - **Sorry sites (4 total, all honest):**
    - Line 1421: `sorry` in `base_change_mate_fstar_reindex_legs` — the "REMAINING CRUX (step iii)" telescope cancellation. The immediately preceding comment (lines 1383–1420) accurately describes the obstruction: after `subst hfst/hsnd`, the leg `g'` is locked in literal form and `rw [unitExpand]` cannot match the pattern `pullbackPushforwardAdjunction (?a ≫ ?b)`. The sorry is the genuine remaining piece; the scaffold (step i via `subst`, step ii via `gammaMap_pushforwardComp_*`/`gammaMap_pushforwardCongr_hom`, step iii setup via `pullbackPushforward_unit_comp`) is in place. Honest.
    - Line 1525: `sorry` in `base_change_mate_gstar_transpose` — the "REMAINING (the genuine crux)" pullback-dictionary coherence identifying `g^*`-leg with `extendScalars ψ ∘ ρ`. Comment is accurate. Honest.
    - Line 1698: `sorry` in `affineBaseChange_pushforward_iso` — the "AFFINE REDUCTION, obligation 1": restriction-compatibility of `pushforwardBaseChangeMap` over affine charts. Comment is accurate and detailed. Honest.
    - Line 1720: `sorry` in `flatBaseChange_pushforward_isIso` — deferred Čech/flatness assembly. Honest.
  - **Sorry chaining is transparent:** `base_change_mate_section_identity` (lines 1550–1567) chains through `base_change_mate_gstar_transpose` (sorry) via a one-line `exact`. `base_change_mate_generator_trace` chains through `section_identity`. `pushforward_base_change_mate_cancelBaseChange` chains through `generator_trace`. `affineBaseChange_pushforward_iso` is independently sorry. All intermediate wrappers are structurally complete.
  - **New `_unitExpand`/`_gammaDistribute` lemmas (iter-019):**
    - `base_change_mate_fstar_reindex_legs_unitExpand` (lines 1273–1297): Sound. After `rw [pullbackPushforward_unit_comp]`, the proof assembles `(A ≫ B) ≫ C = A ≫ B ≫ C ≫ id → A` via `hI : (a≫b)_*(pullbackComp.inv ≫ pullbackComp.hom) = 𝟙` + `congrArg`/`Category.assoc` in term mode. The `congrArg`/`.trans` term-mode workaround is a legitimate response to the `X.Modules` instance diamond that defeats tactic-mode rewrites.
    - `base_change_mate_fstar_reindex_legs_gammaDistribute` (lines 1304–1321): Sound. After `unitExpand`, the goal is pure functor distributivity; the `(F.map_comp _ _).trans (congrArg ...)` chain correctly threads three `map_comp` applications in term mode to avoid the same diamond.
    - Neither lemma hides a mathematical gap.
  - **Heartbeat bumps:**
    - Line 979 (`set_option maxHeartbeats 4000000` before `base_change_mate_unit_value`): Legitimate. The proof is ~100 lines of `erw`/`simp`/`rw` over heavy `restrictScalars`/tilde–Γ round trips. No sorry in the body.
    - Line 1323 (`set_option maxHeartbeats 1600000` before `base_change_mate_fstar_reindex_legs`): Mildly inflated — the theorem has a `sorry` at line 1421 with ~88 lines of pre-sorry proof. The tactics before the sorry (`subst`/`simp [gammaMap_*]`/`rw [he, hinclA] at key`) involve scheme-morphism elaboration and can plausibly consume 1.6M, but the bump is certifying work that ends in an unfinished proof. No loop masking detected.
    - Line 1425 (`set_option maxHeartbeats 1600000` before `base_change_mate_fstar_reindex`): Legitimate. The proof closes with `exact base_change_mate_fstar_reindex_legs ...` which checks a large defeq between two codomain-read variants (two change-of-rings dictionaries with proof-irrelevant leg-equality arguments).
  - **Outdated comments:** Lines 184–247 (section docstring `STATUS (iter-234)`/`UPDATE (iter-236)`/`iter-240 PIVOT`/`iter-241`): These use an internal iteration numbering scheme (234, 236, 240, 241) that differs from the project's external `iter-NNN` numbering. The content is accurate (route (b) is what's implemented, routes (a) / (b) are correctly described), but the iter references are stale relative to the project's external tracking. Very minor.
  - **No `axiom` declarations. No weakened or fake statements.**

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none (heartbeat bumps all legitimate)
- **excuse-comments**: none
- **notes**:
  - **Sorry sites (3 total, all honest):**
    - Line 754: `sorry` in `exists_localizationAway_finite_mvPolynomial` (L4), filling the `hfin : Module.Finite` witness. The injectivity of `φ` is fully proved above it (lines 719–738). The roadmap comment (lines 739–755) accurately describes the remaining step: choose `g1 ≠ 0` clearing integral-dependence-equation coefficients over `K[X]`, set `g := g0 * g1`, prove `Algebra.finite_adjoin_of_finite_of_isIntegral`. The note that the witness `g0` is provisional (will change to `g0 * g1` when the sorry is filled) is an accurate technical observation, not an excuse-comment.
    - Line 1797: `sorry` in `genericFlatnessAlgebraic` — the finite-type-`B`-module residue requiring the prime-filtration dévissage. The primary route (module-finite over `A`) is fully closed at line 1776–1777. The assembly roadmap comment (lines 1779–1796) is accurate and detailed. Honest.
    - Line 1864: `sorry` in `genericFlatness` — geometric assembly of `genericFlatnessAlgebraic`. The non-empty affine open extraction is done (lines 1843–1845). Honest.
  - **`exists_free_localizationAway_polynomial` (L5, lines 1630–1730): Fully proved, no sorry.** The `Nat.strong_induction_on generalizing A N` induction correctly quantifies over the base ring in the IH (iter-019 structural fix). The IH application at lines 1714–1716 at base `Localization.Away g` is typechecked with `hdomg`/`hnoethg` supplied at lines 1699–1702.
  - **Heartbeat bumps (all legitimate):**
    - Lines 482–484 (`synthInstance.maxHeartbeats 1000000` + `maxHeartbeats 4000000`, `exists_localizationAway_finite_mvPolynomial`): Deep stacked `IsLocalization`/`LocalizedModule` instance search over doubly-indexed polynomial rings. Legitimate.
    - Lines 1254–1257 (`synthInstance.maxHeartbeats 1000000` + `maxHeartbeats 4000000`, `gf_torsion_reindex`): Same — doubly-indexed polynomial ring plus quotient-ring assembly. Legitimate.
    - Line 1492–1493 (`synthInstance.maxHeartbeats 1000000`, `free_localizationAway_of_away_tower`): Iterated `OreLocalization`/`LocalizedModule` carrier structure. Legitimate.
    - Line 1613 (`synthInstance.maxHeartbeats 1000000`, `exists_free_localizationAway_polynomial`): Stacked `OreLocalization`/`MvPolynomial` module structures. Legitimate.
  - **No `axiom` declarations. No weakened or fake statements.**

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Sorry sites (5 total, all honest):**
    - Line 126 (`hilbertPolynomial`), Line 165 (`QuotFunctor`), Line 202 (`Grassmannian`), Line 228 (`Grassmannian.representable`): All are typed-hole file-skeleton declarations with non-trivial, non-weakened type signatures. Each docstring says "iter-177+: the body [will unfold to] …; For the iter-176 file-skeleton the body is a typed `sorry`." Honest scaffolding. The types are substantive (the signatures match the blueprint declarations).
    - Line 1494: `sorry` for `hindep : iSupIndep (fun n => LinearMap.range (ψ n))` inside `subquotient_base_eventuallyZero`. See below.
  - **`iSupIndep` sorry analysis (line 1494):**
    - The surrounding comment (lines 1483–1491) accurately identifies the obstruction: constructing the κ-linear detection map `Φ : Q →ₗ[κ] M ⧸ N'` (sending `[m] ↦ [πₙ m]`) via `Submodule.liftQ` requires the quotient `Q` to carry a `κ`-module structure, but `Q` is a `MvPolynomial (Fin 0) κ`-quotient and the scalar-ring mismatch blocks the `liftQ` call. The math (detect via the degree-`n` projection `decompose_of_mem_same`/`decompose_of_mem_ne` + `D.hN'` homogeneity to confirm well-definedness) is described completely. Honest.
    - The rest of `subquotient_base_eventuallyZero` (lines 1495–1516) is **fully proved** conditioned on `hindep`: it applies `Submodule.finite_ne_bot_of_iSupIndep` to get finite support above `K`, then derives `N ⊓ ℳ n ≤ N'` from `range(ψ n) = ⊥`, then computes `subquotientHilb = 0`.
  - **`gradedModule_hilbertSeries_rational` chain — confirmed:**
    - `subquotient_finite_transfer` (lines 1206–1260): **Fully proved.** The σ-semilinear map `g`, its surjectivity, the `liftQ` denominator-killing, and `Module.Finite.of_surjective` are all non-sorry. The `map_smul'` obligation correctly delegates to `polyEndHom_lastVar_sub_mem`.
    - `SubquotientDatum.ker` and `.coker` constructors (lines 1400–1436): Both fully proved. The `hfin` fields correctly invoke `subquotient_finite_transfer` with the right arguments.
    - `subquotient_hilbertSeries_rational` (lines 1523–1541): Fully proved. The base case calls `subquotient_base_eventuallyZero ℳ D` (sorry via `hindep`); the inductive step calls `subquotient_degreewise_diff` (no sorry).
    - `gradedModule_hilbertSeries_rational` (lines 1556–1598): Fully proved conditioned on `hindep`. The top datum `(⊤, ⊥)` is correctly assembled with `hfintop` (finitude via explicit surjective linear map).
    - **The only residual hole in the entire chain is `hindep` (line 1494). Confirmed.**
  - **`annihilator_isLocalizedModule_eq_map` (lines 362–422):** Sound. The `≤` direction uses `IsLocalization.mk'_surjective` + finite generating-set annihilator product + `IsLocalizedModule.mk'_smul_mk'`; the `≥` direction is straightforward ideal-map membership. No gaps.
  - **`IsRatHilb` closure lemmas (lines 534–610):** All tight. Each uses the correct Mathlib power-series identity.
  - **`rationalHilbert_antidiff` (lines 450–527):** Sound. The antidifference step correctly computes the polynomial numerator `C0 * (1-X)^e + q` and verifies the telescoping identity at every `n > N`.
  - **No `axiom` declarations. No weakened or fake statements.**

---

## Must-fix-this-iter

*(none)*

---

## Major

*(none)*

---

## Minor

- `FlatBaseChange.lean:1323` — `set_option maxHeartbeats 1600000` on `base_change_mate_fstar_reindex_legs`, a theorem whose proof ends in `sorry` at line 1421. The ~88 lines of pre-sorry tactic work (`subst`/`simp`/`rw` on scheme-modules types) may legitimately require a bump, but 1.6M heartbeats for pre-sorry scaffold is somewhat inflated. No loop evidence; not certifying a bad defeq. Recommend verifying that removing the bump causes a heartbeat timeout on the pre-sorry prefix.
- `FlatBaseChange.lean:184–247` — Section docstring references internal iter numbers (234, 236, 240, 241) that do not correspond to the project's external `iter-NNN` format. Content is accurate (route (b) is what's implemented). Minor cosmetic staleness.
- `FlatBaseChange.lean:1369–1421` — `IMPORTANT (iter-018 finding)` / `iter-019 UPDATE` labels inside the sorry body. Accurate technical documentation but references to previous iterations accumulate; should be pruned when the sorry is closed.
- `QuotScheme.lean:119–124` — The `hilbertPolynomial` docstring says "iter-177+: the body unfolds to...". This iter numbering (177) is internal and inconsistent with the external `iter-NNN` scheme. Very minor.

---

## Excuse-comments (always called out separately)

*(none found)*

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: All three files are clean — no axioms, no weakened definitions, no fake statements, no excuse-comments; sorry sites are all honest scaffolding with accurate roadmap comments; the `_unitExpand`/`_gammaDistribute` new lemmas in FlatBaseChange.lean are sound; the `gradedModule_hilbertSeries_rational` chain has exactly one residual hole (the `iSupIndep` base case in `subquotient_base_eventuallyZero`, line 1494), as expected.
