# AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean

## Session summary (iter-202, Lane AB-Path-B-Close)

**HARD BAR MET.** `auslander_buchsbaum_formula_succ_pd` body is **fully
closed axiom-clean** (no `sorry`), and the 3 requested `private` removals
landed. The main theorem `RingTheory.auslander_buchsbaum_formula` is now
axiom-clean (`{propext, Classical.choice, Quot.sound}`). This closes the
16+-iter Lane AB gap.

- **Sorry count (file): 1 → 0.**
- Built axiom-clean: 4 new helper declarations + closed `_succ_pd` body.
- 3 `private` removals (Step 3) done.

## Declarations added (4, all axiom-clean)

1. `RingTheory.enat_ab_inductive_combine` (private lemma, ~line 1551) —
   pure `ℕ∞` arithmetic: from IH `j + depth K = depth R`, `depth_of_short_exact`
   parts (2),(3), and `j ≥ 1`, derives `(j+1) + depth M = depth R`. Casework
   on `WithTop ℕ` + `min_le_iff` + `omega`. **RESOLVED.**
2. `RingTheory.projectiveDimension_ker_eq_of_surjection` (private lemma,
   ~line 1611) — for `f : R^n ↠ M` with `pd M = k+2`, `pd (ker f) = k+1`
   exactly. Squeeze via `projectiveDimension_le_iff` (upper) +
   `projectiveDimension_ge_iff` (lower, contrapositive of the ascent helper).
   **RESOLVED.**
3. `RingTheory.Module.depth_ses_ineqs_of_surjection_finite_localRing`
   (lemma, ~line 1411) — both `depth_of_short_exact` parts (2),(3) on the
   kernel SES `0 → ker f → R^n → M → 0`, with `depth(R^n)=depth(R)`
   identified via `depth_pi_const_eq_depth_of_nonempty`. **RESOLVED.**
4. `RingTheory.Module.exists_ne_zero_ext_of_depth_eq` (lemma, ~line 1450) —
   converse read-off of `depth_eq_smallest_ext_index`: depth `= ↑D` (finite)
   ⟹ `∃ nonzero e : Ext^D(κ, M)`. **RESOLVED.**

## auslander_buchsbaum_formula_succ_pd (now ~line 1801) — RESOLVED, axiom-clean

- **Approach:** Restructured as `induction k generalizing M` per the
  iter-201 handoff recipe.
  - **Inductive step `pd M = k+2`** (no matrix-collapse): minimal surjection
    `f : R^n ↠ M`; `projectiveDimension_ker_eq_of_surjection` gives
    `pd (ker f) = k+1` exactly; `Nontrivial (ker f)` from `pd ≠ ⊥`; IH on
    `ker f`; `depth_ses_ineqs_…`; combine via `enat_ab_inductive_combine`.
  - **Base case `pd M = 1`** (Path B matrix-collapse): `ker f` is projective
    (pd < 1) → free (`free_of_flat_of_isLocalRing`); pick `φ : R^k ≃ₗ ker f`
    (`k ≥ 1` via `φ` + subsingleton argument); build SES
    `0 → R^k →[A] R^n →[f] M → 0` where `A`'s entries lie in `𝔪 = Ann κ`
    (minimality `ker f ≤ 𝔪•⊤` + `ideal_smul_top_pi_const`). Direction (A)
    `depth R ≤ 1 + depth M` from `depth_of_short_exact (2)`. Direction (B)
    `1 + depth M ≤ depth R`: case `depth R = ⊤` trivial; case `↑D` uses
    `exists_ne_zero_ext_of_depth_eq` to get nonzero `α : Ext^D(κ, R^k)`,
    matrix-collapse (`ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator`)
    kills `α.comp (mk₀ (ofHom A))`; sub-case `D=0` contradiction via
    `postcomp_mk₀_injective_of_mono`; sub-case `D=D'+1` uses
    `covariant_sequence_exact₁` to transport `α` to a nonzero
    `Ext^{D'}(κ, M)`, contradicting `↑D ≤ depth M`, hence
    `depth M + 1 ≤ depth R` via `Order.add_one_le_of_lt`.
- **Result:** RESOLVED — `#print axioms` on the main theorem = kernel triple.

## Step 3 — `private` removals (DONE)

Promoted to public (all axiom-clean, proofs unchanged):
- `RingTheory.auslander_buchsbaum_formula_succ_pd`
- `RingTheory.CohenMacaulay.isDomain_of_regularLocal`  ← **NOTE namespace**
- `RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq`
  ← **NOTE namespace**

**Important for Lane COE (iter-203):** the PROGRESS.md plan referred to these
as `RingTheory.isDomain_of_regularLocal` and
`RingTheory.regularLocal_quotient_isRegularLocal_of_notMemSq`, but they live
in the **`RingTheory.CohenMacaulay`** namespace. The cross-file imports must
use the fully-qualified names above. (They were not moved/renamed — only the
`private` keyword was dropped — so the namespace is preserved.)

## Summary

- **Declarations added (4):** `enat_ab_inductive_combine`,
  `projectiveDimension_ker_eq_of_surjection`,
  `Module.depth_ses_ineqs_of_surjection_finite_localRing`,
  `Module.exists_ne_zero_ext_of_depth_eq`.
- **Declarations closed (1):** `auslander_buchsbaum_formula_succ_pd` body
  (was `sorry`; now complete, axiom-clean).
- **Private removals (3):** as listed in Step 3.
- **Sorry count (file): 1 → 0.**
- **Axiom verification:** `RingTheory.auslander_buchsbaum_formula`,
  `auslander_buchsbaum_formula_succ_pd`, all 4 new helpers, and both promoted
  CohenMacaulay helpers each return `{propext, Classical.choice, Quot.sound}`.

## Why I stopped

**Real progress / objective complete.** The Lane AB HARD BAR is met:
`_succ_pd` body closed axiom-clean (4 new helper lemmas + induction
restructuring), and the 3 `private` removals landed. The main
Auslander–Buchsbaum theorem is now fully axiom-clean. The iter-202
`progress-critic route202` user-escalation pre-commitment is **satisfied
and discharged** (Lane AB did NOT return PARTIAL).

PUSH-BEYOND (main `auslander_buchsbaum_formula` inductive step) was already
discharged: the main theorem delegates its `n>0` branch to `_succ_pd`, which
is now fully closed, so the main theorem is complete with no further work.

## Blueprint markers (for review agent / sync_leanok)

The following should now resolve to `\leanok` (proofs closed, axiom-clean):
- `lem:auslander_buchsbaum_formula_succ_pd`
  (`RingTheory.auslander_buchsbaum_formula_succ_pd`)
- `thm:auslander_buchsbaum` (`RingTheory.auslander_buchsbaum_formula`)

The blueprint NOTE on `lem:auslander_buchsbaum_formula_succ_pd` requesting
option (1) (remove `private`) is now **fully resolved** — the `private` was
removed and the body closed. The review agent may drop that NOTE block.

The gap-table in `\subsec:succ_pd_gap_sequence` can be updated: **all gaps
CLOSED** (gap (2) Stacks 00MF was OBVIATED by the Path B matrix-collapse +
LES route; no "what is exact" criterion was needed).
