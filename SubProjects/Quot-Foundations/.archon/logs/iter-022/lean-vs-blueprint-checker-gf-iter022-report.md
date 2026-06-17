# Lean ↔ Blueprint Check Report

## Slug
gf-iter022

## Iteration
022

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Per-declaration (this-iter focus)

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (chapter: `\thm:generic_flatness_algebraic`)

- **Lean target exists**: yes — `AlgebraicGeometry.genericFlatnessAlgebraic`, lines 1981–2141
- **Signature matches**: yes
  - Universe: `(A B M : Type u)` as recorded in the blueprint's `% NOTE (iter-022)`.
  - Conclusion: `∃ f : A, f ≠ 0 ∧ Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)` — matches the informal statement exactly.
  - Hypothesis classes: `[CommRing A] [IsDomain A] [IsNoetherianRing A] [CommRing B] [Algebra A B] [Algebra.FiniteType A B] [AddCommGroup M] [Module B M] [Module.Finite B M] [Module A M] [IsScalarTower A B M]` — match.
- **Proof follows sketch**: yes
  The blueprint's proof sketch (lines 96–128) prescribes:
  1. **Primary route** (module-finite `A`): `lem:gf_finite_module`. The Lean `by_cases hAM : Module.Finite A M` splits here and closes with `GenericFreeness.exists_free_localizationAway_of_finite`. ✓
  2. **Fallback §4 dévissage** via `lem:noeth_prime_filtration`: The Lean uses `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime`. ✓
     - Subsingleton obligation → L1 (`exists_free_localizationAway_of_torsion`). ✓
     - Domain-quotient obligation (`N ≅ B/𝔭`): Steps 1–4 assemble L4 (`exists_localizationAway_finite_mvPolynomial`) + L5 (`exists_free_localizationAway_polynomial`) + ring↔module bridge + tower descent (`free_localizationAway_of_away_tower`). ✓
     - SES closure → L3 (`exists_free_localizationAway_of_shortExact`). ✓
  The mathematical content and step order match the blueprint exactly.
- **Sorries**: none found in the proof body. All called sub-lemmas are independently proved in this file.
- **notes**: The Lean proof is axiom-clean (consistent with the blueprint's `% NOTE (iter-022): CLOSED, axiom-clean {propext, Classical.choice, Quot.sound}`).

---

### `\lean{AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial}` (chapter: `\lem:gf_noether_clear_denominators`)

- **Lean target exists**: yes — lines 505–963
- **Signature matches**: yes (with one naming note — see below)
  
  The blueprint's `% LEAN SIGNATURE` block (added/updated in iter-022) records:
  ```
  ∃ (n : ℕ) (g : A) (_ : g ≠ 0)
    (_ : Algebra (Localization.Away g) (Localization.Away (algebraMap A B g)))
    (φ : MvPolynomial (Fin n) (Localization.Away g) →ₐ[…] Localization.Away (algebraMap A B g)),
    Function.Injective φ ∧
    (letI := φ.toAlgebra; Module.Finite …) ∧
    (∀ a, algebraMap A_g B_g (algebraMap A A_g a) = algebraMap B B_g (algebraMap A B a))
  ```
  
  The Lean (lines 509–524) has:
  ```lean
  ∃ (n : ℕ) (g : A) (_ : g ≠ 0)
    (algBg : Algebra (Localization.Away g) (Localization.Away (algebraMap A B g)))
    (φ : MvPolynomial (Fin n) (Localization.Away g) →ₐ[…] Localization.Away (algebraMap A B g)),
    Function.Injective φ ∧
    (letI := φ.toAlgebra; Module.Finite … ) ∧
    (letI := algBg; ∀ a : A,
      algebraMap (Localization.Away g) (Localization.Away (algebraMap A B g))
          (algebraMap A (Localization.Away g) a)
        = algebraMap B (Localization.Away (algebraMap A B g)) (algebraMap A B a))
  ```
  
  The difference is that the blueprint uses an anonymous binder `(_ : Algebra …)` while the Lean uses a named binder `(algBg : Algebra …)` — required to allow `letI := algBg` in the 4th conjunct. The blueprint's `% NOTE (iter-022)` correctly explains this: "a FOURTH existential conjunct was added — the chosen `algBg : Algebra A_g B_g` is COMPATIBLE with the canonical `A → B → B_g` tower."
  
  **4th conjunct verified**: present in both blueprint (as the `∀ a` clause) and Lean. The proof closes it at lines 956–962 by `change`-ing to the `Localization.awayMap` form and discharging via `IsLocalization.Away.map` + `IsLocalization.map_eq`.

- **Proof follows sketch**: yes — Steps 1–3 in the blueprint (Noether normalisation over K, clearing denominators via `IsIntegral.exists_multiple_integral_of_isLocalization`, AlgHom assembly including the `ν`/`ψ` comparison maps and injectivity + finiteness proofs) all appear in the Lean body.
- **Sorries**: none found.
- **notes**: The blueprint's `% NOTE` (shared-engine remark) about `gf_clear_one_denominator` being reusable is documented accurately. The landed proof uses `IsIntegral.exists_multiple_integral_of_isLocalization` (clearing a whole generator) rather than folding `gf_clear_one_denominator` coefficient-by-coefficient — the blueprint's proof-of-proof comment at lines 462–466 correctly notes this choice.

---

## Red flags

### Stale excuse-comment in module doc block

**Location**: `AlgebraicJacobian/Picard/FlatteningStratification.lean`, lines 1956–1963 — the `/-!` section header for `## Generic flatness, algebraic form`:

```lean
* **Surviving residue** (`sorry` this iter): when `M` is finite over the
  *finite-type* algebra `B` but not module-finite over `A`, the genuine §4
  dévissage is required — a prime filtration of `M` as a finite `B`-module
  reduces to `M = B/𝔭`, Noether normalisation makes `B_g` finite over the
  polynomial ring `A_g[b₁,…,b_n]`, and induction on the support dimension
  bottoms out at the polynomial-ring core of generic freeness. That core
  (a finite module over `A[X₁,…,X_d]` is generically free) is the precise
  piece Mathlib does not yet supply.
```

The text "sorry this iter" appears in a module-level doc block. The proof of `genericFlatnessAlgebraic` is now **closed and sorry-free** (the blueprint confirms "CLOSED, axiom-clean"). This comment creates a false impression of proof state for readers of the Lean file. It is stale documentation, not an inline excuse-comment for wrong code — but it is actively misleading about the proof status.

**Classification**: `major` — not `must-fix-this-iter` because the proof body itself is correct and complete, but the stale `sorry this iter` text should be removed/updated promptly to prevent confusion.

### Stale `INTENDED LEAN SIGNATURE` in the blueprint

**Location**: `blueprint/src/chapters/Picard_FlatteningStratification.tex`, lines 72–79 — the `% INTENDED LEAN SIGNATURE` block for `thm:generic_flatness_algebraic`:

```tex
% INTENDED LEAN SIGNATURE (the scaffold pass creates the decl pinned above with
% exactly this signature):
%   (A B M : Type*) [CommRing A] ...
```

The block still says `Type*` while the actual landed decl uses `(A B M : Type u)`. The `% NOTE (iter-022)` immediately above (lines 51–54) correctly records the universe change, so the NOTE is authoritative — but the `INTENDED LEAN SIGNATURE` below it is now inconsistent with reality.

**Classification**: `minor` — the NOTE is correct and takes precedence; this is a documentation consistency issue only.

---

## Unreferenced declarations (informational)

The following substantive declarations in the Lean file have no direct `\lean{...}` reference in the blueprint (though they are mentioned by name in proof comments):

- `AlgebraicGeometry.GenericFreeness.isLocalization_lift_injective` — referenced by `\lem:gf_isLocalization_lift_injective` with `\lean{AlgebraicGeometry.GenericFreeness.isLocalization_lift_injective}` at blueprint line 559. **Present and matching.** ✓
- `AlgebraicGeometry.genericFlatness` — still a `sorry`; referenced by `\thm:generic_flatness` with `\lean{AlgebraicGeometry.genericFlatness}`. This is a known open obligation, not a new issue.

**Private declarations**: Several Nagata-section lemmas (`T1`, `T`, `lt_up`, `sum_r_mul_ne`, `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`, `finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`) are marked `private` in the Lean but referenced with `\lean{AlgebraicGeometry.GenericFreeness.X}` in the blueprint. The `sync_leanok` tool cannot resolve private names; this is a pre-existing issue not introduced this iter.

---

## Blueprint adequacy for this file

- **Coverage**: The major blueprint-pinned declarations all have corresponding `\lean{...}` references. The iter-022 scope (`genericFlatnessAlgebraic` and the L4 signature update) is adequately covered and the blueprint notes are accurate.
- **Proof-sketch depth**: **adequate** for the two this-iter declarations. The proof sketches in §4 are detailed enough that a prover following them would produce exactly the Lean proof that was landed.
- **Hint precision**: **precise** for the two this-iter declarations. The `% LEAN SIGNATURE` and `% NOTE` blocks for `lem:gf_noether_clear_denominators` and `thm:generic_flatness_algebraic` correctly pin the universe, the 4-conjunct structure, and the `letI := algBg` encoding.
- **Generality**: **matches need** — the single-universe `Type u` choice for `genericFlatnessAlgebraic` and `free_localizationAway_of_away_tower` / `exists_free_localizationAway_polynomial` is correctly justified in the blueprint's NOTE.
- **Recommended chapter-side actions**:
  - Update the `% INTENDED LEAN SIGNATURE` block for `thm:generic_flatness_algebraic` (lines 71–79) to say `(A B M : Type u)` instead of `(A B M : Type*)`.

---

## Severity summary

| Finding | Location | Severity |
|---------|----------|----------|
| Stale "sorry this iter" in `/-!` section header for `genericFlatnessAlgebraic` | Lean file, lines 1956–1963 | **major** |
| `INTENDED LEAN SIGNATURE` block still says `Type*` for `thm:generic_flatness_algebraic` | Blueprint, lines 72–79 | **minor** |
| Private `\lean{...}` pins for Nagata lemmas (pre-existing) | Blueprint + Lean | **minor** |

No `must-fix-this-iter` findings. The two this-iter declarations (`genericFlatnessAlgebraic` and `exists_localizationAway_finite_mvPolynomial`) are correctly formalized, their signatures match the blueprint, and their proofs follow the prescribed routes.

**Overall verdict**: Both this-iter targets are faithfully formalized with no fake statements, correct signatures, and proofs that match the blueprint routes; the only issues are a stale "sorry this iter" doc comment in the Lean file (major) and a minor inconsistency between a blueprint NOTE and its accompanying INTENDED LEAN SIGNATURE block.
