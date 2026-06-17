# AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean

## Session summary
- Built axiom-clean: 4 new declarations (matrix-collapse substrate)
  - `Module.elemMap` (line ~1416, private def)
  - `Module.elemMap_apply` (line ~1423, private lemma)
  - `Module.linearMap_finFunR_matrix_decomp` (line ~1440, private lemma)
  - `Module.ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator` (line ~1479, private lemma)
- Blocked on: full closure of `auslander_buchsbaum_formula_succ_pd` body
  (now at L1639; sorry at L1696). The matrix-collapse helper is the binding
  new substrate (per analogist `ab-stacks00mf` Path B verdict); the residual
  is LES-injectivity assembly + linear-equivalence transport of matrix-collapse
  to the subtype inclusion `K ↪ R^n`. Estimated 80-120 LOC for full closure
  (base case + inductive step).
- Sorry count: file 1 sorry (was L1574 pre-iter-201, now L1696 post-line-shift)
  → 1 sorry. Net zero change at file level; substrate progress: +4 axiom-clean
  decls.

## Module.elemMap (line ~1418)
- **Approach:** Defined `elemMap n m i j : R^m →ₗ R^n` as
  `(toSpanSingleton R (Fin n → R) (Pi.single i 1)) ∘ₗ (LinearMap.proj j)`.
  This is the "elementary matrix" linear map sending `Pi.single j 1 ↦ Pi.single i 1`
  and other basis vectors to 0.
- **Result:** RESOLVED — axiom-clean.

## Module.elemMap_apply (line ~1425)
- **Approach:** Direct calculation via `LinearMap.toSpanSingleton_apply` +
  `Pi.single_eq_same` / `Pi.single_eq_of_ne` case-split.
- **Result:** RESOLVED — axiom-clean.

## Module.linearMap_finFunR_matrix_decomp (line ~1442)
- **Approach:** Show A = ∑_{(i,j)} A(Pi.single j 1) i • elemMap n m i j by
  (a) decomposing the input `x = ∑_j (x j) • Pi.single j 1`,
  (b) pushing through `A` via `map_sum + map_smul`,
  (c) expressing each row `A(Pi.single j 1) = ∑_i (A(Pi.single j 1) i) • Pi.single i 1`,
  (d) reshuffling the double sum via `Finset.sum_product_right`,
  (e) closing via `LinearMap.smul_apply + elemMap_apply`.
- **Result:** RESOLVED — axiom-clean.

## Module.ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator (line ~1481)
- **Approach:** The matrix-collapse on Ext per the iter-201 analogist
  `ab-stacks00mf` Path B recipe. Given `A : R^m →ₗ R^n` with all entries
  `A (Pi.single j 1) i ∈ Ann_R N`, the postcomposition
  `e.comp (mk₀ (ofHom A)) (add_zero p)` is zero in `Ext^p(N, R^n)`. Proof
  chain: matrix decomposition `A = ∑ A_ij • E_ij`, then push through
  `ofHom`, `mk₀`, and `Ext.comp` using
  `ModuleCat.hom_sum + mk₀_sum + comp_sum` and
  `ModuleCat.hom_smul + Ext.mk₀_smul + Ext.comp_smul`. Each summand reduces
  to `A_ij • (e.comp (mk₀ (ofHom (elemMap _ _ i j))))`, where the scalar
  `A_ij ∈ Ann_R N` makes the summand zero via the existing
  `ext_smul_eq_zero_of_mem_annihilator` helper (line 229).
- **Result:** RESOLVED — axiom-clean.
- **Mathlib API used (all verified):**
  - `LinearMap.toSpanSingleton`, `LinearMap.proj`, `LinearMap.single`
  - `LinearMap.smul_apply`, `LinearMap.sum_apply`, `LinearMap.ext`
  - `Pi.single_eq_same`, `Pi.single_eq_of_ne`, `Pi.smul_apply`
  - `Finset.sum_product_right`, `Finset.univ_product_univ`
  - `ModuleCat.hom_sum`, `ModuleCat.hom_ext`
  - `CategoryTheory.Abelian.Ext.mk₀_sum`, `Ext.comp_sum`
  - `CategoryTheory.Abelian.Ext.mk₀_smul`, `Ext.comp_smul`
- **Verification:** `#print axioms` shows only the kernel triple
  `{propext, Classical.choice, Quot.sound}`.

## auslander_buchsbaum_formula_succ_pd (line 1517, body NOT CLOSED)
- **Approach attempted (Path B from analogist):** With the matrix-collapse
  helper now in hand, the closure plan is:

  **Base case `k = 0` (pd M = 1)** — ~50-80 LOC residual:
  1. From `_hpd : projectiveDimension R M = 1`, derive
     `HasProjectiveDimensionLT (ker f) 1` for a minimal surjection
     `f : R^n →ₗ M` (using iter-200 helpers
     `hasProjectiveDimensionLT_succ_of_projectiveDimension_eq` +
     `hasProjectiveDimensionLT_ker_of_surjection`).
  2. `K := ker f` is finite projective over local Noetherian R, hence free:
     `Module.Flat.of_projective` + `Module.free_of_flat_of_isLocalRing`.
     Pick a basis to get an iso `φ : (Fin k → R) ≃ₗ[R] K`.
  3. Compose `A := K.subtype ∘ₗ φ.toLinearMap : (Fin k → R) →ₗ R^n`.
     Its image equals `K = LinearMap.ker f ⊆ 𝔪 • ⊤` (from minimality
     clause `_hf_min` of `exists_minimalSurjection_finite_localRing`).
  4. Show every entry `A (Pi.single j 1) i ∈ 𝔪 = Ann_R κ`:
     - Use `ideal_smul_top_pi_const` (line 863) to identify
       `𝔪 • ⊤_{Fin n → R}` with the pointwise condition `∀ i, x i ∈ 𝔪`.
     - Apply at the column `A (Pi.single j 1) ∈ K ⊆ 𝔪 • ⊤`.
     - `Ideal.annihilator_quotient` then identifies `𝔪 = Ann_R κ`.
  5. Apply `ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator` (NEW)
     with `A` to get `e.comp (mk₀ (ofHom A)) = 0` for all
     `e : Ext^p(κ, R^k)`.
  6. Transport to the subtype: `subtype = A ∘ₗ φ.symm.toLinearMap`, so via
     `ofHom_comp` and `Ext.comp` associativity, the postcomposition map
     `Ext^p(κ, K) → Ext^p(κ, R^n)` (via the SES first morphism) is also zero.
  7. LES of `Ext^*(κ, -)` on the SES `0 → K → R^n → M → 0`:
     `covariant_sequence_exact₂` at `i = depth R`: the map
     `Ext^{depth R - 1}(κ, M) →^δ Ext^{depth R}(κ, K)` has image equal to
     `ker(Ext^{depth R}(κ, K) → Ext^{depth R}(κ, R^n)) = Ext^{depth R}(κ, K)`
     (since the next map is zero). Together with `Ext^{depth R - 1}(κ, R^n) = 0`
     (depth `R^n = depth R > depth R - 1`), we get `δ` is an iso. Since
     `Ext^{depth R}(κ, K) = Ext^{depth R}(κ, R^k) ≠ 0` (K is free of rank k ≥ 1,
     depth K = depth R, so this Ext index doesn't vanish), we conclude
     `Ext^{depth R - 1}(κ, M) ≠ 0`, i.e., `depth M ≤ depth R - 1`,
     i.e., `depth M + 1 ≤ depth R`.
  8. The matching `depth M + 1 ≥ depth R` from `depth_of_short_exact`
     part (2): `min(depth R^n, depth K - 1) ≤ depth M`, i.e.,
     `min(depth R, depth R - 1) = depth R - 1 ≤ depth M` (when depth R ≥ 1).
  9. Combine for `depth M + 1 = depth R`. Edge case `depth R = 0`:
     the LES at `i = 0` gives `Ext^0(κ, K) = 0` (LHS is 0, RHS is 0 by matrix-collapse),
     but `Ext^0(κ, K) ≠ 0` since `depth K = 0`. Contradiction shows we cannot
     have `pd M = 1` and `depth R = 0` simultaneously.
  10. Also need to rule out `k = 0` (i.e., K = 0): if K = 0, then `f` is iso, so
      M is projective, so `pd M = 0`, contradicting `pd M = 1`.

  **Inductive step `k + 1, k ≥ 1`** — ~30-50 LOC residual:
  1. Same setup: minimal surjection f, get `HasProjectiveDimensionLT K (k+1)`.
  2. From `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`
     (contrapositive): `pd K = k` exactly.
  3. Apply main theorem `auslander_buchsbaum_formula` at `n = k` on K (NOT
     via `_succ_pd` k itself, but via the main theorem dispatching to
     `_succ_pd (k-1)` when k ≥ 1). [Needs `_succ_pd` to be structured as
     induction on k, generalizing M, for the IH to be available.]
  4. IH gives `k + depth K = depth R`, hence `depth K = depth R - k`.
  5. From step 4 + LES at `i = depth K` (using matrix-collapse on
     A : R^? → R^n where R^? is the iso of K = free of rank `R^?_rank`...
     wait — in this case K has pd k ≥ 1, K is NOT free. So matrix-collapse
     doesn't apply directly).
  6. **The inductive-step problem:** for k ≥ 1, K = ker f has pd k ≥ 1, so K
     is NOT projective. Matrix-collapse needs K to be free. So the inductive
     step needs a different argument.
  
  **Inductive step alternative (LES + IH only):**
  - The SES `0 → K → R^n → M → 0` plus IH `k + depth K = depth R`.
  - `depth_of_short_exact (2)`: `min(depth R^n, depth K - 1) ≤ depth M`,
    i.e., `min(depth R, depth R - k - 1) = depth R - k - 1 ≤ depth M`
    (when `depth R ≥ k + 1`).
    So `depth M ≥ depth R - k - 1`, i.e., `depth M + k + 1 ≥ depth R`.
  - For the matching ≤: use `depth_of_short_exact (3)`:
    `min(depth R^n, depth M + 1) ≤ depth K = depth R - k`. So either
    `depth R ≤ depth R - k` (impossible for k ≥ 1) or
    `depth M + 1 ≤ depth R - k`, i.e., `depth M + k + 1 ≤ depth R`.
  - Combined: `depth M + k + 1 = depth R`, i.e., `(k+1) + depth M = depth R`.

  **So the inductive step k ≥ 1 closes via IH + `depth_of_short_exact`
  parts (2) and (3) alone — NO matrix-collapse needed.** The matrix-collapse
  is only used for the base case k = 0.

- **Result:** NOT ADDED (residual `sorry` at L1574 unchanged).
- **Why not landed this iter:** The base case requires ~50-80 LOC of LES
  bookkeeping + linear-equivalence transport on top of the matrix-collapse
  substrate. The inductive step requires restructuring `_succ_pd` to do
  Nat-induction on `k` (generalizing M) so the IH can be invoked at smaller k.
  Both pieces are doable in a follow-on iter with the matrix-collapse
  substrate in hand.
- **Next step:**
  - **iter-202 dispatch:** Close `_succ_pd` body. Restructure as
    `induction k generalizing M`; base case uses matrix-collapse + LES;
    inductive step uses IH + `depth_of_short_exact` parts (2) & (3).
  - Remove `private` per the iter-201 plan agent's option (1) commitment
    (blueprint NOTE resolution).

## Summary
- **Declarations added (4):**
  - `RingTheory.Module.elemMap` (private def)
  - `RingTheory.Module.elemMap_apply` (private lemma)
  - `RingTheory.Module.linearMap_finFunR_matrix_decomp` (private lemma)
  - `RingTheory.Module.ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator`
    (private lemma) — **the matrix-collapse substrate identified as the
    binding new helper in the iter-201 analogist `ab-stacks00mf` Path B
    verdict.**
- **Declarations blocked (1):** `auslander_buchsbaum_formula_succ_pd` body
  (L1574 sorry unchanged). Blocker: ~80-120 LOC of LES bookkeeping +
  Nat-induction restructuring on top of the matrix-collapse substrate.
- **Sorry count:** 1 → 1 (no change at file level, but the binding new
  substrate is now in place — full closure path is ~3× closer).
- **Axiom verification:** all 4 new declarations have
  `#print axioms` returning `{propext, Classical.choice, Quot.sound}`
  (verified via `lean_verify` on
  `ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator`).

## Why I stopped
- **Real progress:** 4 axiom-clean declarations added, named above. The
  binding new substrate `ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator`
  (Path B's "matrix-collapse helper") is in place per the iter-201
  analogist verdict. This is a substantial step of the ~130-200 LOC Path B
  budget (~40 LOC of new substrate landed).
- **Partial progress on closure:** The base case requires ~50-80 LOC of
  LES bookkeeping + linear-equiv transport; the inductive step requires
  ~30-50 LOC of `depth_of_short_exact`-based assembly. Neither is purely
  Mathlib-substrate-blocked; both are doable in iter-202 with the
  matrix-collapse substrate landed this iter.
- **Approaches written but not attempted:** Inductive step assembly via
  `depth_of_short_exact` parts (2) and (3) alone (no matrix-collapse).
  This is a viable simplification — recorded in detail above. Iter-202
  prover should attempt this directly.
- **HARD BAR met for matrix-collapse substrate:** the binding new helper
  per the iter-201 analogist verdict is axiom-clean.
- **HARD BAR NOT MET for `_succ_pd` closure:** the L1574 sorry remains.
  Iter-202 dispatch should restructure `_succ_pd` to do `induction k
  generalizing M` and use the matrix-collapse helper in the base case.

## Blueprint updates suggested for iter-202 plan agent

The blueprint NOTE on private/public mismatch (iter-201 plan agent
selected option (1) — remove `private`) is still pending the actual
removal of `private` from `auslander_buchsbaum_formula_succ_pd`. This
should land as part of the iter-202 closure work.

The blueprint's `\subsec:succ_pd_gap_sequence` gap-table can be updated
to reflect: **matrix-collapse substrate CLOSED iter-201** (the analogist
Path B's binding new helper). Gap (2) (Stacks 00MF) is now genuinely
OBVIATED by Path B (per the analogist verdict); the only residual binding
is the LES/Nat-induction assembly, no longer a Mathlib substrate gap.
