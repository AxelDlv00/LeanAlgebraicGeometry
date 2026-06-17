# AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean

Lane G iter-195 — OFF-CRITICAL-PATH minimal dispatch (helper budget = 1).

## Summary

- **Directive interpretation:** Option (b) — propagate the lane to a
  clean state with precise n=k+1 sub-task carving + concrete iter-196
  re-engagement timeline. HARD BAR: any substantive structural commit.
- **Action taken:** carved the entire `pd = k + 1` inductive step of
  `auslander_buchsbaum_formula` into a single new private helper
  `auslander_buchsbaum_formula_succ_pd` with a precisely-typed
  substrate-gap signature and a 4-piece iter-196+ re-engagement plan
  documented inline.
- **Sorry count:** 1 → 1 (unchanged; inline `sorry` at the n=k+1
  case-split site replaced by `exact auslander_buchsbaum_formula_succ_pd k _hpd`,
  with the typed `sorry` now living inside the helper at L1115).
- **Helper budget:** 1 / 1 used.
- **Axioms:** none introduced (`sorryAx` propagates through the
  carving — net axiom usage unchanged).
- **Build:** GREEN. `lake env lean` returns only the expected
  "declaration uses 'sorry'" warning on the new helper at L1115.

## auslander_buchsbaum_formula_succ_pd (NEW, L1106-1124)

### Attempt 1
- **Approach:** Carve the n=k+1 inductive-step substrate into a single
  typed helper whose docstring documents the blueprint proof shape +
  the 4 Mathlib-absent substrate pieces + a concrete iter-196+ ordering.
- **Result:** RESOLVED as structural commit (Option (b)). The helper
  signature
  ```
  private lemma auslander_buchsbaum_formula_succ_pd
      {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
      {M : Type u} [AddCommGroup M] [Module R M] [_root_.Module.Finite R M]
      [Nontrivial M] (k : ℕ)
      (_hpd : _root_.Module.projectiveDimension R M
          = ((k + 1 : ℕ) : WithBot ℕ∞)) :
      ((k + 1 : ℕ) : ℕ∞) + Module.depth (IsLocalRing.maximalIdeal R) M
        = Module.depth (IsLocalRing.maximalIdeal R) R
  ```
  exactly matches the inductive-step type after the
  `Nat.exists_eq_succ_of_ne_zero` substitution. The helper body is
  `sorry` with iter-196+ TODOs in the inline comment.
- **iter-196+ re-engagement plan** (in the helper's docstring):
  1. **iter-196 first slice:** piece (4) **depth-drops-by-one**
     (Stacks `lemma-depth-drops-by-one`). ~40-60 LOC. Routes through
     the existing `depth_eq_smallest_ext_index` infrastructure +
     `IsSMulRegular.smulShortComplex_shortExact` (both already in
     this file).
  2. **iter-197:** piece (1) **minimal-resolution carving**
     (Stacks `lemma-add-trivial-complex`). ~80-120 LOC, independent.
  3. **iter-198-199:** piece (3) **snake-lemma-on-resolution**.
     ~80-120 LOC; depends on (1).
  4. **iter-200+:** piece (2) **"what is exact" criterion**
     (Stacks 00MF). ~150-200 LOC; candidate for Mathlib upstream PR.

## auslander_buchsbaum_formula (L1133+)

### Attempt 1
- **Approach:** Replace the inline `sorry` at the n=k+1 branch with
  a one-line `exact auslander_buchsbaum_formula_succ_pd k _hpd`
  call. Introduce `obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero
  (Nat.pos_iff_ne_zero.mp hn_pos)` to substitute `n = k + 1` so
  `_hpd` lines up with the helper's signature.
- **Result:** RESOLVED. The n=k+1 branch of the main theorem now
  has no inline `sorry` — the substrate gap is precisely scoped to
  the helper and the main theorem reads cleanly as
  *base case (closed) / inductive step (helper call)*.

## Why I stopped

**Partial progress.** Closed: 0 inline sorries in main theorem; the
n=k+1 substrate `sorry` is now in a precisely-typed helper. Net
sorry count unchanged (1 → 1) but the structural cleanliness is
substantively improved:

- Before: inline `sorry` at L1125 with 25 lines of free-form
  substrate comments inside the proof body.
- After: precisely-typed helper `auslander_buchsbaum_formula_succ_pd`
  with a 4-piece substrate-gap table and concrete iter-196+ slice
  ordering in its docstring; the main theorem dispatches via a
  one-line `exact` call.

**Decision rationale.** The directive explicitly allows Option (b)
(carving) as a valid HARD-BAR outcome, with no closure required.
Helper budget = 1 was used for the carving helper. Attempting
further structural sub-steps (e.g. interior case-split on
`depth(M) = 0` vs `depth(M) > 0` within the helper) would have
added a second `sorry` without substrate progress; the current
state preserves the net sorry count and produces the cleanest
substrate-gap surface for iter-196 re-engagement.

**PUSH-BEYOND not attempted.** The minimal-finite-free-resolution
carving sub-lemma (piece (1) in the re-engagement plan) is
estimated at ~80-120 LOC and depends on the Mathlib
projective-resolution API plus Stacks `lemma-add-trivial-complex`
infrastructure that is not present at the pinned commit; attempting
it here would exceed helper budget and is the natural target for
the iter-197 slice per the documented plan.

**Lane G remains OFF-CRITICAL-PATH** per session-194 R7 +
progress-critic CONVERGING + iter-195 plan directive. The gating
consumer for A.4.a (the surface-extension proof) is
`CohenMacaulay.of_regular` (§7 of this file), whose substrate gap
is the iter-189-194-structurally-narrowed Stacks 00NQ implication
— NOT the AB formula proper. This carving documents the AB
formula's substrate cost for resumption when the critical path
frees up; it does not delay any downstream consumer in the
positive-genus arm of `nonempty_jacobianWitness`.

## Blueprint marker recommendation

`thm:auslander_buchsbaum` (`\lean{RingTheory.auslander_buchsbaum_formula}`)
remains `\leanok` on the **statement block** (declaration is
formalized with substantive type signature). The **proof block**
should remain UNmarked (the inductive step still carries a
typed-sorry via the carving helper). The deterministic `sync_leanok`
phase will handle marker placement automatically.
