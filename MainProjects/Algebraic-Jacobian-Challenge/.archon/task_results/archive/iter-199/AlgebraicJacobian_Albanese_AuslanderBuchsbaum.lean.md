# AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean — iter-199 Lane AB-gap1

## Summary

- **Declarations added (1, axiom-clean):**
  - `RingTheory.Module.exists_minimalSurjection_finite_localRing`
    (L1198–L1296). For a finite `R`-module `M` over a local ring
    `(R, 𝔪)` (Noetherian-ness NOT required), there exist `n : ℕ` and a
    surjective `R`-linear map `f : (Fin n → R) →ₗ[R] M` such that
    `n = dim_κ (κ ⊗_R M)` (the minimal generator count, where
    `κ = R/𝔪`) **and** `LinearMap.ker f ≤ 𝔪 • ⊤`. This is the
    per-syzygy substrate piece of gap (1) (Stacks
    `lemma-add-trivial-complex`): iterating on syzygies (each of which
    is finite under `[IsNoetherianRing R]`) extends to a full minimal
    finite-free resolution.
- **Docstring fixes applied** to `auslander_buchsbaum_formula_succ_pd`
  (L1330–1396):
  - Stale "All four pieces are absent:" header replaced with explicit
    "Gap (4) closed iter-198; gap (1) first-step substrate landed
    iter-199; gaps (2)-(3) remain" structure.
  - Stale "iter-196 first slice: piece (4)" re-engagement plan replaced
    with "iter-198 closed piece (4); iter-199 begins piece (1)"
    chronology and updated iter-200+ scoping.
  - Inline body comment (L1404–1432) updated to reflect that gap (1)
    is no longer "GAP" — it is "PARTIAL iter-199" with the per-step
    substrate axiom-clean.
- **Sorry count across file:** 1 → 1 (no closure; substrate-only land
  per the iter-199 PROGRESS.md target).
- **PUSH-BEYOND:** snake-lemma (gap 3) work not attempted because gap
  (1) is only at first-step substrate, not the full iterated resolution;
  the snake-lemma argument requires the full resolution as input. The
  iterated resolution is the natural iter-200 follow-on.

## `RingTheory.Module.exists_minimalSurjection_finite_localRing` (L1198)

- **Statement:**
  ```lean
  lemma exists_minimalSurjection_finite_localRing
      (R : Type u) [CommRing R] [IsLocalRing R]
      (M : Type u) [AddCommGroup M] [Module R M] [Module.Finite R M] :
      ∃ (n : ℕ) (f : (Fin n → R) →ₗ[R] M),
        Function.Surjective f ∧
        n = Module.finrank (IsLocalRing.ResidueField R)
              (TensorProduct R (IsLocalRing.ResidueField R) M) ∧
        LinearMap.ker f ≤ (IsLocalRing.maximalIdeal R) • ⊤
  ```
- **Approach:**
  1. Pick `b : Module.Basis (Fin n) κ (κ ⊗_R M)` via
     `Module.finBasis`, with `n = finrank κ (κ ⊗ M)`.
  2. Surjectivity of `(TensorProduct.mk R κ M) 1`
     (`TensorProduct.mk_surjective` + `Ideal.Quotient.mk_surjective`)
     allows choosing `m_i ∈ M` with `1 ⊗ m_i = b i`.
  3. Define `f : R^n → M` by `(Pi.basisFun R (Fin n)).constr R m`.
     Evaluation: `f x = ∑_i x_i • m_i`.
  4. Surjectivity: `LinearMap.range f = span_R(m_i)`
     (`Module.Basis.constr_range`), and Nakayama via
     `IsLocalRing.span_eq_top_of_tmul_eq_basis` gives `span_R(m_i) = ⊤`.
  5. Kernel containment: for `x ∈ ker f`, applying `1 ⊗_R -` to
     `∑ x_i • m_i = 0` and using `TensorProduct.tmul_smul` plus
     `Module.Basis.linearIndependent` of `b` forces each
     `residue R (x_i) = 0`, i.e. each `x_i ∈ 𝔪`. Sum-decomposing `x`
     via `Pi.single` then yields `x ∈ 𝔪 • ⊤`.
- **Mathlib pieces used (all axiom-clean):**
  - `IsLocalRing.span_eq_top_of_tmul_eq_basis` (Nakayama-lift core)
  - `TensorProduct.mk_surjective` + `Ideal.Quotient.mk_surjective`
  - `Module.finBasis`, `Module.Basis.constr_apply`,
    `Module.Basis.constr_range`, `Module.Basis.linearIndependent`
  - `Pi.basisFun`, `Pi.basisFun_repr`
  - `TensorProduct.tmul_smul`, `TensorProduct.tmul_sum`,
    `TensorProduct.tmul_zero`
  - `Finsupp.equivFunOnFinite`, `Finsupp.sum_fintype`,
    `Finset.univ_sum_single`
  - `IsLocalRing.residue_eq_zero_iff`
  - `Submodule.smul_mem_smul`, `Submodule.sum_mem`,
    `Fintype.linearIndependent_iff`
- **Verification:** `#print axioms` reports
  `[propext, Classical.choice, Quot.sound]` (kernel-only).
- **Result:** RESOLVED — axiom-clean.
- **Downstream consumption check:** verified that
  `obtain ⟨n, f, hsurj, hn, hker⟩ :=
   RingTheory.Module.exists_minimalSurjection_finite_localRing R M`
  in a Noetherian-local-ring + finite-module context yields a usable
  surjection + kernel-containment + (via `inferInstance` on the
  Noetherian ring) `Module.Finite R (LinearMap.ker f)`. The natural
  iter-200 iteration recurses by re-applying the substrate to the
  kernel (= first syzygy).

## `auslander_buchsbaum_formula_succ_pd` (L1398, NOT closed)

- **Status:** NOT ADDED to closure target. Single sorry retained at
  this declaration; docstring updated to reflect iter-199 progress.
- **What changed iter-199:** Gap (1) status moved from absent to PARTIAL
  (first-step substrate `exists_minimalSurjection_finite_localRing`
  landed axiom-clean). Gaps (2) and (3) unchanged from iter-198.
- **iter-200+ closure path:**
  1. Iterate `exists_minimalSurjection_finite_localRing` to build a
     full `Nat`-indexed minimal finite-free resolution of length
     `pd_R(M)` (gap (1) full assembly; depends on Nat-recursion +
     `Module.Finite` on each syzygy).
  2. Snake lemma on the minimal resolution under quotient by `R/(x)`
     (gap (3); requires (1) full assembly).
  3. "What is exact" criterion (Stacks 00MF) for the depth-of-r-minors
     bound (gap (2); upstream-PR candidate per chapter L554-560).
  4. Final assembly: ~50-80 LOC strong-induction on `depth M` using
     gap (4) `depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` plus
     `exists_isSMulRegular_of_one_le_depth` to extract the common NZD
     in the inductive step.

## Push-beyond: gap (3) snake-lemma NOT attempted

- **Rationale:** snake-lemma-on-minimal-resolution requires the **full
  iterated minimal resolution** as input, not just the first-step
  surjection. The iterated resolution construction (gap (1) full
  assembly) is itself ~40-80 LOC of `Nat`-recursion on the syzygy
  pattern — a natural iter-200 follow-on. Starting snake-lemma work
  before that lands would produce typed-`sorry` substrate against a
  not-yet-constructed object, violating the substrate-first principle.
- **Alternative push-beyond options I considered but skipped:**
  1. Iterated `n₀, n₁`-term wrapper `exists_twoTermMinimal`: just
     two-fold application of the substrate; the right shape but not
     a meaningfully new substrate piece. Would inflate file LOC
     without new mathematical content.
  2. Named `Module.Syzygy R M` wrapper: just `LinearMap.ker f`; the
     finiteness is already `inferInstance` under Noetherian. Naming
     it does not add closure power.
  3. Iter-200's full `ChainComplex ℕ (ModuleCat R)` construction:
     genuine ~80-120 LOC, beyond iter-199 budget per directive
     ("Helper budget = 2"; this iter spent ~110 LOC on the per-step
     substrate).

## Blueprint update

- The blueprint chapter (`Albanese_AuslanderBuchsbaum.tex`) is
  unchanged. The new helper does NOT correspond to a chapter-pinned
  declaration (it is internal substrate for gap (1)). No `\leanok` to
  toggle; sync_leanok handles markers deterministically.
- The chapter NOTE at L562-574 about "FOUR core ingredients ALL absent"
  was already partially updated by iter-198 (re: gap (4) closure). The
  iter-199 first-step substrate for gap (1) merits a similar parallel
  NOTE update by a future plan-agent or blueprint-writer cycle (prover
  does NOT touch the blueprint per role-permission table).

## Why I stopped

- **Real progress (1 axiom-clean declaration added):**
  - `RingTheory.Module.exists_minimalSurjection_finite_localRing`
    (L1198–L1296, ~99 LOC body + ~28 LOC docstring, axiom-clean).
- **HARD BAR met:** the minimal-surjection per-step substrate is the
  semantic content of "first step of Stacks `lemma-add-trivial-complex`"
  — it produces a free-rank-minimal surjection whose kernel sits in
  `𝔪 • ⊤`, which is exactly the property `lemma-add-trivial-complex`
  produces at each step of the resolution.
- **Partial progress on closure of L1398 `auslander_buchsbaum_formula_succ_pd`:**
  body unchanged. Closing the full AB succ_pd requires (i) the full
  iterated resolution (extending iter-199 substrate to all `Nat` steps),
  (ii) gap (2) "what is exact" criterion, (iii) gap (3) snake-lemma on
  the iterated minimal resolution. Each is multi-iter work.
- **Approaches written but not attempted:** none of substance — I
  considered the three push-beyond options above and explicitly rejected
  each with stated reasons. Snake-lemma (gap 3) explicitly cannot start
  before gap (1) iteration lands.
- **Informal agent:** not consulted; the closure path was already
  precisely specified by the directive (Stacks `lemma-add-trivial-complex`
  + Bruns-Herzog §1.5 + Matsumura §19) and Mathlib's
  `IsLocalRing.span_eq_top_of_tmul_eq_basis` was the obvious entry
  point. `MOONSHOT_API_KEY` is set but the substrate gap was tightly
  constrained.
- **Infrastructure that exists:** Mathlib at `b80f227` has
  `IsLocalRing.span_eq_top_of_tmul_eq_basis` (the Nakayama-lift
  primitive), `Module.finBasis` (basis of a finite κ-vector space),
  `Module.Basis.constr` / `Basis.constr_range` (universal property of
  basis-extension), `TensorProduct.mk_surjective` (residue-tensor
  surjectivity), and `TensorProduct.tmul_smul` /
  `Module.Basis.linearIndependent` (the linear-independence kernel
  argument primitive). None of these compose automatically into the
  per-step minimal surjection; the project-local
  `exists_minimalSurjection_finite_localRing` is the named
  composition.

## Next-step handoff for plan agent

The per-step minimal-surjection substrate is now in place. Next priority
for AB succ_pd closure:

1. **Iter-200 gap (1) iteration:** wrap
   `exists_minimalSurjection_finite_localRing` in a `Nat`-indexed
   recursive construction producing a `ChainComplex ℕ (ModuleCat R)`
   (or similar) of finite-free modules of length `pd_R(M)`, with each
   differential's image in `𝔪 • ⊤`. ~40-80 LOC; depends only on the
   iter-199 substrate + `Module.Finite` on syzygies (automatic under
   Noetherian).
2. **Iter-200+ gap (3) snake-lemma:** depends on (1) iter-200 closure.
3. **Iter-200+ gap (2) "what is exact":** independent of (1)/(3);
   largest gap (~150-200 LOC); candidate for upstream Mathlib PR.

After all three remaining pieces land, `auslander_buchsbaum_formula_succ_pd`
closes in ~80-120 LOC of assembly using the iter-198 + iter-199 + future
substrates.
