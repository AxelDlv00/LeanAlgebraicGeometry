# Lean ↔ Blueprint Check Report

## Slug
ab-iter202

## Iteration
202

## Files audited
- Lean: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (3434 lines)
- Blueprint: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` (1218 lines)

---

## Per-declaration

### `\lean{RingTheory.Module.depth}` (chapter: `def:depth`)
- **Lean target exists**: yes — `noncomputable def depth` at L146
- **Signature matches**: yes — `(Ideal R) → (M : Type v) → ℕ∞`; body is the substantive sSup with `IM=M` convention
- **Proof follows sketch**: N/A (definition)
- **notes**: Body matches blueprint 00LF definition verbatim. Not a sorry.

### `\lean{RingTheory.Module.depth_eq_smallest_ext_index}` (chapter: `lem:depth_via_ext`)
- **Lean target exists**: yes — `theorem depth_eq_smallest_ext_index` at L295
- **Signature matches**: yes — `(n : ℕ∞) ≤ depth 𝔪 M ↔ ∀ i < n, ∀ e : Ext^i_R(κ, M), e = 0`
- **Proof follows sketch**: yes — induction on `n` with LES-of-Ext chase, matching blueprint proof; forward and backward directions closed without sorry
- **notes**: Both directions axiom-clean at iter-202. Blueprint `\leanok` on proof. ✓

### `\lean{Module.projectiveDimension}` (chapter: `def:projective_dimension`)
- **Lean target exists**: yes — `noncomputable def projectiveDimension` at L186, inside `namespace Module` (NOT `RingTheory.Module`)
- **Signature matches**: yes — one-liner re-export of `CategoryTheory.projectiveDimension (ModuleCat.of R M) : WithBot ℕ∞`
- **Proof follows sketch**: N/A (definition)
- **notes**: Full name is `Module.projectiveDimension`, not `RingTheory.Module.projectiveDimension`. Blueprint `\lean{Module.projectiveDimension}` is correct. ✓

### `\lean{RingTheory.Module.depth_of_short_exact}` (chapter: `lem:depth_short_exact_sequence`)
- **Lean target exists**: yes — `theorem depth_of_short_exact` at L676
- **Signature matches**: yes — three-part conjunction matching Stacks 00LE inequalities
- **Proof follows sketch**: yes — LES of Ext + `depth_eq_smallest_ext_index` + `ext_vanish_of_natCast_lt_depth`; no sorry
- **notes**: Axiom-clean. Blueprint `\leanok` on proof. ✓

### `\lean{RingTheory.auslander_buchsbaum_formula}` (chapter: `thm:auslander_buchsbaum`)
- **Lean target exists**: yes — `theorem auslander_buchsbaum_formula` at L2049
- **Signature matches**: yes — `pd_R(M) + depth_R(M) = depth(R)` for Noetherian local, nontrivial finite `M` with explicit pd bound `n : ℕ`
- **Proof follows sketch**: yes — splits on `n = 0` (finite free route via `depth_pi_const_eq_depth_of_nonempty`) and `n = k+1` (delegates to `auslander_buchsbaum_formula_succ_pd`); no sorry in main body
- **notes**: Axiom-clean per iter-202 directive. Blueprint `\leanok` on proof. The proof of the `n = 0` case routes through `Module.free_of_flat_of_isLocalRing` (Mathlib). ✓

### `\lean{RingTheory.auslander_buchsbaum_formula_succ_pd}` (chapter: `lem:auslander_buchsbaum_formula_succ_pd`)
- **Lean target exists**: yes — `lemma auslander_buchsbaum_formula_succ_pd` at L1801, now **public** (no `private`)
- **Signature matches**: yes — takes `k : ℕ`, `pd_R M = (k+1 : WithBot ℕ∞)`, concludes `(k+1 : ℕ∞) + depth M = depth R`; matches blueprint statement
- **Proof follows sketch**: yes — `induction k generalizing M` with:
  - **Base `k = 0` (pd=1)**: matrix-collapse route via `ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator` + LES at `i = depth R − 1`; no sorry
  - **Inductive step `k ≥ 1` (pd=k+2)**: `projectiveDimension_ker_eq_of_surjection` + `depth_ses_ineqs_of_surjection_finite_localRing` + `enat_ab_inductive_combine`; no sorry
- **notes**: Fully closed, axiom-clean. Blueprint NOTE at blueprint L424–427 correctly reflects closure ("RESOLVED. `private` keyword dropped and body closed axiom-clean iter-202 Lane AB Path B"). Blueprint `\leanok` in both statement and proof blocks. ✓

### `\lean{RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular}` (chapter: `lem:depth_drops_by_one`)
- **Lean target exists**: yes — `lemma depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` at L1020
- **Signature matches**: yes — `depth (M/xM) + 1 = depth M` for `x ∈ 𝔪` and `IsSMulRegular M x`
- **Proof follows sketch**: yes — LES route via `covariant_sequence_exact₁/₃` with `ext_smul_eq_zero_of_mem_annihilator` on the `[x]`-action; no sorry
- **notes**: ✓

### `\lean{RingTheory.Module.exists_minimalSurjection_finite_localRing}` (chapter: `lem:exists_minimalSurjection_finite_localRing`)
- **Lean target exists**: yes — `lemma exists_minimalSurjection_finite_localRing` at L1198
- **Signature matches**: yes — returns `n : ℕ`, `f : (Fin n → R) →ₗ[R] M` surjective with `ker f ≤ 𝔪 • ⊤` and `n = finrank κ (κ ⊗ M)`
- **Proof follows sketch**: yes — Nakayama lift via `Module.finBasis`; no sorry
- **notes**: ✓

### `\lean{RingTheory.Module.hasProjectiveDimensionLT_succ_of_projectiveDimension_eq}` (chapter: `lem:hasProjectiveDimensionLT_succ_of_projectiveDimension_eq`)
- **Lean target exists**: yes — L1290
- **Signature matches**: yes
- **Proof follows sketch**: yes — single rewrite via `projectiveDimension_lt_iff`; no sorry
- **notes**: ✓

### `\lean{RingTheory.Module.hasProjectiveDimensionLT_ker_of_surjection}` (chapter: `lem:hasProjectiveDimensionLT_ker_of_surjection`)
- **Lean target exists**: yes — L1309
- **Signature matches**: yes
- **Proof follows sketch**: yes — SES descent via `ShortExact.hasProjectiveDimensionLT_X₁`; no sorry
- **notes**: ✓

### `\lean{RingTheory.Module.hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker}` (chapter: `lem:hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`)
- **Lean target exists**: yes — L1335
- **Signature matches**: yes
- **Proof follows sketch**: yes; no sorry
- **notes**: ✓

### `\lean{RingTheory.Module.depth_ker_ge_min_of_surjection_finite_localRing}` (chapter: `lem:depth_ker_ge_min_of_surjection_finite_localRing`)
- **Lean target exists**: yes — L1369
- **Signature matches**: yes — `min(depth R, depth M + 1) ≤ depth (ker f)` for surjection `f : R^n ↠ M`, `n ≥ 1`, `ker f` nontrivial
- **Proof follows sketch**: yes — applies `depth_of_short_exact` part (3) after `depth_pi_const_eq_depth_of_nonempty`; no sorry
- **notes**: ✓

### `\lean{RingTheory.CohenMacaulay}` (chapter: `def:cohen_macaulay_local`)
- **Lean target exists**: yes — `class CohenMacaulay` at L2135 inside `namespace RingTheory` (before `namespace CohenMacaulay` opens at L2154)
- **Signature matches**: yes — `depth_eq_krullDim : (depth 𝔪 R : WithBot ℕ∞) = ringKrullDim R`
- **Proof follows sketch**: N/A (class definition)
- **notes**: ✓

### `\lean{RingTheory.CohenMacaulay.of_regular}` (chapter: `cor:regular_cohen_macaulay`)
- **Lean target exists**: yes — `instance of_regular` at L3391 inside `namespace RingTheory.CohenMacaulay`
- **Signature matches**: yes — `[IsRegularLocalRing R] → CohenMacaulay R`
- **Proof follows sketch**: yes — upper bound via `length_le_ringKrullDim_of_isRegular`, lower bound via `exists_isRegular_of_regularLocal`; inline assembly closed
- **notes**: The proof chain traces through `isDomain_of_regularLocal` → `notMem_minimalPrimes_of_regularLocal_succ` → prime-avoidance + Nakayama. All appear axiom-clean from code inspection. The blueprint `\leanok` on proof is consistent. ✓

---

## Red flags

### Placeholder / suspect bodies
None found. `auslander_buchsbaum_formula_succ_pd`, all 4 new helpers, and the two promoted helpers (`isDomain_of_regularLocal`, `regularLocal_quotient_isRegularLocal_of_notMemSq`) all have complete proofs without `:= sorry` or suspect bodies.

### Excuse-comments
None blocking. The Lean file contains many historical iteration-labeled docstring comments (e.g., "iter-183 Lane G structural progress") that are informational, not excuses for wrong/incomplete code.

### Axioms / Classical.choice on non-trivial claims
None introduced. The file uses `Classical.choice` only in definitionally-appropriate places (the `open Classical in` in the `depth` definition is the documented convention). No `axiom` declarations observed.

---

## Unreferenced declarations (informational)

The following **public** declarations have no `\lean{...}` pin in the blueprint:

| Declaration | Line | Status | Concern |
|-------------|------|--------|---------|
| `RingTheory.Module.depth_eq_of_linearEquiv` | L814 | axiom-clean | helper for `n=0` AB case; fine without pin |
| `RingTheory.Module.depth_pi_const_eq_depth_of_nonempty` | L988 | axiom-clean | helper substrate; fine without pin |
| `RingTheory.Module.exists_isSMulRegular_of_one_le_depth` | L1136 | axiom-clean | helper substrate; fine without pin |
| **`RingTheory.Module.depth_ses_ineqs_of_surjection_finite_localRing`** | L1406 | axiom-clean | **directly consumed by `auslander_buchsbaum_formula_succ_pd` inductive step** — major gap |
| **`RingTheory.Module.exists_ne_zero_ext_of_depth_eq`** | L1444 | axiom-clean | **directly consumed by `auslander_buchsbaum_formula_succ_pd` base case** — major gap |
| `RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` | L1020 | pinned ✓ | — |
| `RingTheory.CohenMacaulay.isDomain_of_regularLocal` | L2990 | axiom-clean | **promoted from private; no blueprint pin; namespace mismatch in blueprint prose** |
| `RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq` | L2626 | axiom-clean | **promoted from private; no blueprint pin; namespace mismatch in blueprint prose** |
| `RingTheory.CohenMacaulay.exists_isRegular_of_regularLocal` | L3339 | axiom-clean | cross-file consumer entry; no pin but referenced in blueprint NOTE |

All 4 new iter-202 helpers:
- `RingTheory.enat_ab_inductive_combine` (L1620): **private** — no pin needed ✓
- `RingTheory.projectiveDimension_ker_eq_of_surjection` (L1668): **private** — no pin needed ✓
- `RingTheory.Module.depth_ses_ineqs_of_surjection_finite_localRing` (L1406): **public** — blueprint pin missing (see above)
- `RingTheory.Module.exists_ne_zero_ext_of_depth_eq` (L1444): **public** — blueprint pin missing (see above)

---

## Blueprint adequacy for this file

**Coverage**: 14 `\lean{...}` blocks in the chapter. Unreferenced: ~25 helpers (acceptable as substrate) + **2 substantive public helpers** without pins (flagged above).

**Proof-sketch depth**: **adequate for closed declarations**; the blueprint sketch for `auslander_buchsbaum_formula_succ_pd` is detailed enough (Path B route is fully documented in `subsec:ab_gap1_haspdlt_pivot`, including the matrix-collapse argument and the inductive step). The Lean proof faithfully follows the blueprint's iter-202 dispatch plan.

**Hint precision**: **partial**. Most `\lean{...}` pins are precise. Issues:
1. Blueprint paragraph "iter-202 Lane AB dispatch" (blueprint L1001–1012) refers to `isDomain_of_regularLocal` and `regularLocal_quotient_isRegularLocal_of_notMemSq` **without the `.CohenMacaulay` namespace segment**. Their actual Lean names are `RingTheory.CohenMacaulay.isDomain_of_regularLocal` and `RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq`. Cross-file consumers (CodimOneExtension.lean) need the exact qualified name.

**Generality**: matches need.

**Recommended chapter-side actions**:
1. Add `\lean{...}` pin block for `RingTheory.Module.depth_ses_ineqs_of_surjection_finite_localRing` (new public helper packaging SES inequalities (2)+(3), directly consumed by `auslander_buchsbaum_formula_succ_pd`).
2. Add `\lean{...}` pin block for `RingTheory.Module.exists_ne_zero_ext_of_depth_eq` (new public helper providing nonzero Ext witness at depth, directly consumed by the pd=1 base case).
3. Add qualified namespace in the "iter-202 Lane AB dispatch" paragraph (blueprint L1001–1012): write `\texttt{RingTheory.CohenMacaulay.isDomain\_of\_regularLocal}` and `\texttt{RingTheory.CohenMacaulay.regularLocal\_quotient\_isRegularLocal\_of\_notMemSq}`, not the bare names.
4. Update the "currently private" text in blueprint L1001–1012: both helpers are now **public**.
5. Update the gap table at blueprint L569–585: Gap (2) (Stacks 00MF, "what is exact") should be marked **OBVIATED (Path B, iter-202)** — the formula was closed via the matrix-collapse route that sidesteps gap (2) entirely, analogous to how gap (3) was marked OBVIATED at iter-200.
6. Update or annotate the "Iter budget refinement" paragraph at blueprint L661–678: `lem:auslander_buchsbaum_formula_succ_pd` is now **closed**; the 5–8 iter estimate is no longer applicable.
7. *(Optional/minor)*: The "Iter-201 status update" paragraph (blueprint L981–999) title reads "closure body deferred to iter-202" — historically correct but the subsequent iter-202 NOTE (L1001–1012) completes the story. Consider retitling or merging.

---

## Severity summary

### must-fix-this-iter
**(None.)** No placeholder bodies, no signature mismatches with blueprint prose, no excuse-comments on substantive declarations, no unauthorized axioms.

### major

1. **Missing `\lean{...}` pin for `RingTheory.Module.depth_ses_ineqs_of_surjection_finite_localRing`** — public helper at L1406 directly consumed by the inductive step of `auslander_buchsbaum_formula_succ_pd`. The blueprint describes only the weaker `depth_ker_ge_min_of_surjection_finite_localRing` (part 3 only); the new helper packages parts (2)+(3) and is the actual call-site in the closed proof. Blueprint chapter inadequacy: a prover reviewing the chapter would not find the correct call-site name.

2. **Missing `\lean{...}` pin for `RingTheory.Module.exists_ne_zero_ext_of_depth_eq`** — public helper at L1444 directly consumed by the pd=1 base case of `auslander_buchsbaum_formula_succ_pd`. Blueprint describes its mathematical role but provides no Lean name.

3. **Namespace discrepancy for `isDomain_of_regularLocal` and `regularLocal_quotient_isRegularLocal_of_notMemSq`** — blueprint paragraph at L1001–1012 names them WITHOUT the `.CohenMacaulay` segment. Their actual Lean identifiers (`RingTheory.CohenMacaulay.*`) are what CodimOneExtension.lean must import. Bare names in blueprint prose will cause import errors for any prover acting on the blueprint pin.

4. **Blueprint L1001–1012 says these helpers are "currently private"** — they are now **public** (private removed, per the iter-202 lane execution). The blueprint text is factually wrong after iter-202.

5. **Gap table (blueprint L569–585) still lists gap (2) as "absent" / needed** — the iter-202 Path B closure of `auslander_buchsbaum_formula_succ_pd` used the matrix-collapse route, which does NOT require gap (2) (Stacks 00MF). Gap (2) is now OBVIATED for the formula closure (though it remains of independent mathematical interest as a Mathlib PR candidate). The table's current state misleads future planning about what gap remains.

6. **"Iter budget refinement" paragraph (blueprint L661–678) estimates 5–8 more iters** — `lem:auslander_buchsbaum_formula_succ_pd` is now closed. This forward-looking budget statement is stale and actively misleading for plan-agent scheduling.

### minor

7. **"Iter-201 status update" paragraph (blueprint L981–999)**: Reads as a prospective description of iter-202 work ("What remains (iter-202 dispatch) is the body…"). Now that iter-202 is complete, this paragraph is obsolete. The subsequent iter-202 NOTE partially compensates but the title creates confusion.

8. **NOTE at blueprint L1035–1052 (iter-185 review)**: Describes `exists_isSMulRegular_quotient_isRegularLocal_succ` as carrying a "load-bearing sorry" and the `regularLocal_inductive_step` bridge as a "typed sorry". Both are now closed (Lean L3130–3201 and L3320–3337 respectively show complete proofs). The NOTE is stale but not actively misleading since it is clearly labeled as iter-185 context.

---

**Overall verdict**: `auslander_buchsbaum_formula_succ_pd` is faithfully closed and axiom-clean, no must-fix findings; 6 major blueprint staleness issues require chapter updates — primarily the gap table, iter budget text, "currently private" prose, namespace discrepancy on promoted helpers, and two missing `\lean{...}` pins for iter-202 public helpers consumed by the closed proof.
