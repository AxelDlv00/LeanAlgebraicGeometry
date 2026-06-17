# Lean ↔ Blueprint Check Report

## Slug
gf-iter023

## Iteration
023

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex`

---

## Critical Focus: `thm:generic_flatness` / `AlgebraicGeometry.genericFlatness`

This is the primary question this iter poses.

### `\lean{AlgebraicGeometry.genericFlatness}` (chapter: `thm:generic_flatness`)

- **Lean target exists**: yes — `theorem genericFlatness` at line 2173.
- **Signature matches blueprint prose**: **partial / no** — see below.
- **Proof follows sketch**: N/A for the sorry body; the proof sketch is what needs scrutiny here.
- **notes**: Three distinct sub-issues follow.

#### Issue 1 — Stale `% LEAN SIGNATURE HEADER` (MUST-FIX)

The blueprint's `% LEAN SIGNATURE HEADER` comment (lines 1480–1488 of the `.tex`) reads:

```tex
%   theorem genericFlatness {S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S]
%       (p : X ⟶ S) [LocallyOfFiniteType p] (F : X.Modules)
%       [F.IsQuasicoherent] [F.IsFiniteType] :
```

The **Lean file** (lines 2173–2174) now reads:

```lean
theorem genericFlatness {S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S]
    (p : X ⟶ S) [LocallyOfFiniteType p] [QuasiCompact p] (F : X.Modules)
```

The blueprint `% LEAN SIGNATURE HEADER` is **missing `[QuasiCompact p]`**. The Lean signature and the blueprint's recorded signature disagree on a mathematically necessary hypothesis.

The Lean file documents the fix at lines 2199–2223 with a detailed `SIGNATURE CORRECTNESS FIX` block, including a concrete counterexample (infinite disjoint union over `Spec ℤ`), and explicitly notes that the change is "reported in task_results + TO_USER for the planner/mathematician to ratify." The blueprint was not updated (correctly — provers do not write the blueprint), so the stale header remains.

**Verdict**: Blueprint `% LEAN SIGNATURE HEADER` must be updated to include `[QuasiCompact p]`. The `% NOTE (re-signed)` block covering the coherence hypothesis (lines 1466–1488) does not mention the quasi-compactness fix at all; it needs a companion `% NOTE` or an in-place correction.

#### Issue 2 — Mathematically FALSE claim in the blueprint proof body (MUST-FIX)

The blueprint's proof of `thm:generic_flatness` (lines 1519–1543) contains this sentence at the start of Step 1 (line 1521):

> "Since \(p\) is locally of finite type **it is in particular quasi-compact**, so the open subscheme \(X_{U_0} = p^{-1}(U_0)\) is quasi-compact…"

This is the **original error** that motivated the iter-023 signature fix. In Mathlib, `LocallyOfFiniteType p` does **not** imply `QuasiCompact p`. The sentence is mathematically false as written. The Lean code explicitly documents the same counterexample (an infinite disjoint union over `Spec ℤ`) that refutes this claim.

The correct reading is: quasi-compactness is now a **separate hypothesis** `[QuasiCompact p]` in the signature, not a consequence of local finite type. The proof prose must be updated to say something like: "Since `p` is quasi-compact (by hypothesis), the preimage `X_{U₀}` is quasi-compact…"

**Verdict**: The false sentence must be corrected; it encodes exactly the wrong reasoning the prover found and fixed.

#### Issue 3 — GAPs G1 and G3 are hand-waved, not blueprinted (MUST-FIX — chapter inadequate)

The Lean file flags two genuine missing-Mathlib bridges at lines 2243–2258, both blocking honest closure of the `sorry`:

- **GAP G1** — "quasicoherent + finite-type ⟹ finite section module over affine": for an affine `W : X.Opens`, the section module `Γ(F, W)` is a finite `Γ(X, W)`-module.
- **GAP G3** — "flat-locality assembly": freeness of `(M_j)_f` over `A_f` on a finite source cover implies flatness of `Γ(F, W)` over `Γ(S, U)` for arbitrary affine `U ≤ V`, `W ≤ p⁻¹U`.

The blueprint's proof of `thm:generic_flatness` refers to both at exactly the problematic steps but provides **no `\lean{...}` reference and no separate blueprint lemma** for either:

- **Step 2** (blueprint line 1526–1531): "quasi-coherence of `F` identifies `F|_{W_j}` with the associated sheaf `M̃_j`… and the finite-type hypothesis makes `M_j` a finite `B_j`-module." This hand-waves G1. No blueprint lemma, no `\lean{...}` pin.
- **Step 4** (blueprint line 1540–1543): "On each patch the localized section module is free, hence flat over `A_f`; the fibrewise flatness conclusion then follows… by the criterion that a module flat at every maximal ideal is flat." This hand-waves G3. No blueprint lemma, no `\lean{...}` pin.

A prover working from the blueprint has no guidance on how to bridge G1 or G3. The blueprint chapter is **under-specified** for closing `genericFlatness` while these two bridges remain uncharted.

---

## Per-declaration summary (all `\lean{...}` blocks)

This iter's focus is `genericFlatness`; a full scan of the remaining ~42 blueprinted declarations in the chapter is provided below at summary level. All declarations in the `GenericFreeness` namespace and `genericFlatnessAlgebraic` were checked for existence and basic signature alignment.

### `\lean{AlgebraicGeometry.genericFlatnessAlgebraic}` (`thm:generic_flatness_algebraic`)
- **Lean target exists**: yes — `theorem genericFlatnessAlgebraic` at line 1981.
- **Signature matches**: yes — `(A B M : Type u)` with the single-universe encoding matches the blueprint's `% NOTE (iter-022)` annotation.
- **Proof follows sketch**: partial — the primary route (module-finite over `A`) is closed axiom-clean; the `B/𝔭` branch of the dévissage has a `sorry` pending the L4+L5 assembly. This is consistent with the blueprint prose ("surviving residue").
- **notes**: The blueprint's `% NOTE (iter-022): CLOSED, axiom-clean` is now partially accurate (the primary route is closed; the dévissage branch is not yet closed). The Lean comments clearly document the remaining assembly steps.

### `GenericFreeness.*` sub-lemmas (L1 through L5 chain)
The following were checked for existence and basic signature alignment only (not deep proof content):
- `exists_free_localizationAway_of_finite` (`lem:gf_finite_module`) — **exists, signature matches, fully closed**.
- `exists_flat_localizationAway_of_finite` (`lem:gf_flat_finite`) — **exists, closed**.
- `exists_free_localizationAway_of_moduleFinite` (`lem:gf_free_moduleFinite`) — **exists, closed**.
- `exists_free_localizationAway_of_torsion` (`lem:gf_torsion_base`) — **exists, closed**.
- `exact_localizedModule_powers_of_shortExact` (`lem:gf_splice_shortExact_localized_exact`) — **exists, closed**.
- `free_localizationAway_of_free_of_eq_mul` (`lem:gf_splice_shortExact_free_transport`) — **exists, closed**.
- `free_of_shortExact_of_free_free` (`lem:gf_splice_shortExact_split`) — **exists, closed**.
- `exists_free_localizationAway_of_shortExact` (`lem:gf_splice_shortExact`) — **exists, closed**.
- `gf_clear_one_denominator` (`lem:gf_clear_one_denominator`) — **exists, closed**.
- `isLocalization_lift_injective` (`lem:gf_isLocalization_lift_injective`) — **exists, closed**.
- `exists_localizationAway_finite_mvPolynomial` (`lem:gf_noether_clear_denominators`) — **exists, closed** (iter-021). Blueprint `% NOTE (iter-022)` on the fourth conjunct matches the landed signature.
- `gf_generic_rank_ses` (`lem:gf_generic_rank_ses`) — **exists**; body contains a `sorry` (per blueprint note, the OreLocalization instance-alignment blocker for L5).
- `gf_torsion_annihilator` (`lem:gf_torsion_annihilator`) — **exists**.
- Nagata machinery (`T1`, `T`, `lt_up`, `sum_r_mul_ne`, `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`, `finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`) — **all exist**.
- `gf_nagata_monic_lastVar` (`lem:gf_nagata_monic_lastVar`) — **exists**.
- `mvPolynomial_quotient_finite_of_monic_lastVar` (`lem:gf_mvPolynomial_quotient_finite_monic`) — **exists**.
- `gf_torsion_reindex` (`lem:gf_torsion_reindex`) — **exists**; blueprint note documents that it is closed but emitting an OreLocalization instance-diamond that blocks the L5 assembly (this is a `sorry`-free proof with an upstream OreLocalization issue).
- `pullbackModuleAddEquiv`, `finite_of_pullbackModuleAddEquiv`, `pullback_isScalarTower` (`lem:gf_pullback_module_transport`) — **all exist**.
- `finite_of_quotientRingEquiv` (`lem:gf_finite_of_quotient_ringequiv`) — **exists**.
- `isLocalizedModule_restrictScalars` (`lem:gf_islocalizedmodule_restrictscalars`) — **exists**.
- `free_localizationAway_of_away_tower` (`lem:gf_away_tower_descent`) — **exists, closed and axiom-clean** per blueprint note.
- `exists_free_localizationAway_polynomial` (`lem:gf_polynomial_core`) — **exists**; body contains a `sorry` for the L5 OreLocalization instance-alignment blocker (documented in the blueprint `% NOTE` inside `lem:gf_polynomial_core`'s proof).

No red flags (axioms, excuse-comments, suspect bodies on non-trivial claims) were found in the `GenericFreeness` namespace beyond the `sorry` markers that the blueprint explicitly authorizes as "work remaining."

---

## Red flags

### Signature mismatch with blueprint prose

- `AlgebraicGeometry.genericFlatness` at line 2173: Lean signature includes `[QuasiCompact p]`, but the blueprint `% LEAN SIGNATURE HEADER` (lines 1480–1488) omits it. Severity: **must-fix-this-iter**.

### Wrong claim in blueprint proof body

- Blueprint `thm:generic_flatness` proof, line 1521: "it is in particular quasi-compact" as a consequence of "locally of finite type." This is mathematically false (no such implication exists in Mathlib; see the counterexample in the Lean file at lines 2207–2215). This claim was the root cause of the original false signature. Severity: **must-fix-this-iter**.

### No excuse-comments on Lean side

None found. The Lean `sorry` markers are paired with detailed explanatory comments that are accurate and do not claim correctness.

---

## Unreferenced declarations (informational)

All substantive declarations in the file have `\lean{...}` references in the blueprint, or are internal helpers (e.g. `gf_torsion_base` L1 is referenced). No suspicious unreferenced declarations were found.

---

## Blueprint adequacy for this file

- **Coverage**: ~43/43 Lean declarations have a corresponding `\lean{...}` block in the chapter. Coverage is complete.
- **Proof-sketch depth**: **under-specified** for `thm:generic_flatness`. Steps 2 and 4 of the geometric assembly hand-wave the two genuine Mathlib gaps (G1 and G3) without dedicated lemma entries or `\lean{...}` pins. All other declarations (`GenericFreeness.*`) have proof sketches that guided the prover adequately.
- **Hint precision**: **wrong** for `thm:generic_flatness` — the `% LEAN SIGNATURE HEADER` records the pre-fix signature (missing `[QuasiCompact p]`), misleading any prover who consults the blueprint for the exact type.
- **Generality**: matches need for all declarations except the above.
- **Recommended chapter-side actions**:
  1. **Update `% LEAN SIGNATURE HEADER`** in `thm:generic_flatness`: add `[QuasiCompact p]` to the recorded signature, and add a `% NOTE (iter-023): [QuasiCompact p] added; see Lean file SIGNATURE CORRECTNESS FIX block`.
  2. **Correct the proof prose** for Step 1 (line 1521): replace "it is in particular quasi-compact" with "since `p` is quasi-compact by the `[QuasiCompact p]` hypothesis".
  3. **Add a new blueprint lemma for GAP G1** (`lem:gf_qcoh_fintype_finite_sections` or similar): `\lean{...}` pin to whatever Mathlib / project declaration is found/created to establish `Module.Finite Γ(X, W) Γ(F, W)` for affine `W` given `[F.IsQuasicoherent]` and `[F.IsFiniteType]`.
  4. **Add a new blueprint lemma for GAP G3** (`lem:gf_flat_locality_assembly` or similar): `\lean{...}` pin to the flat-locality result assembling freeness on a finite affine cover into flatness on all affine opens below `V`.

---

## Severity summary

- **must-fix-this-iter** (2 blueprint items):
  1. `thm:generic_flatness` `% LEAN SIGNATURE HEADER` missing `[QuasiCompact p]` — signature mismatch between blueprint and Lean.
  2. `thm:generic_flatness` proof prose claims "locally of finite type ⟹ quasi-compact" — mathematically false claim that was the original error and is still present in the blueprint.
- **must-fix-this-iter** (1 blueprint adequacy item):
  3. Blueprint chapter is under-specified for `thm:generic_flatness`: GAPs G1 and G3 are hand-waved with no dedicated lemma entries, making the chapter inadequate to guide closing the `sorry`.
- **No Lean-side red flags**: the Lean code is honest — `sorry` markers are accurately placed, the signature fix is correct, and the explanatory comments are precise.

**Overall verdict**: The Lean file is technically honest and the iter-023 signature fix (`[QuasiCompact p]`) is mathematically correct; the chapter has three must-fix blueprint items — a stale `% LEAN SIGNATURE HEADER`, a false prose claim in the proof body (both for `thm:generic_flatness`), and missing lemma stubs for the two Mathlib bridges (G1, G3) blocking the `sorry`.
