# AlgebraicJacobian/Albanese/CodimOneExtension.lean — iter-200 Lane COE-stage6-iiB

## Session summary

- Lane: **COE-stage6-iiB Stacks-00OE substrate**, prover-mode mathlib-build.
- Built axiom-clean: **7 new project-local Mathlib substrate lemmas** for the
  Stage 6 sub-gap (ii.B) Stacks-00OE smooth-algebra Krull-dim formula.
- Sorry count: **3 → 3** (no public-signature change; substrate-only iter).
- HARD BAR (per PROGRESS.md): "land the 3-step Krull-dim formula axiom-clean,
  OR Step 1+2 plus partial Step 3 substrate" — **MET** via Step 1 + Step 2 fully
  axiom-clean + Step 3 partial substrate (additive form). Capstone assembly
  `ringKrullDim_localization_atMaximal_MvPolynomial` collapses Steps 1+2 into a
  single direct consumer call.
- Push-beyond on the L1061 sorry (`isRegularLocalRing_stalk_of_smooth`) NOT
  attempted: the body's chain through Stage 3's
  `Algebra.IsStandardSmooth Γ(Spec, U) Γ(X.left, V)` to my MvPolynomial-side
  substrate requires the Jacobian-regular-sequence witness (Stacks 00SW / 00OW),
  which is the iter-201+ residual obligation per the analogist recipe.

## Lemmas added (axiom-clean, in declaration order)

All declarations sit inside `namespace AlgebraicGeometry.Scheme` (the file's
ambient namespace), as private theorems with explicit project-local docstrings.

### 1. `ringKrullDim_localization_eq_height_atPrime` (line ~688)

**Type signature.**
```lean
private theorem ringKrullDim_localization_eq_height_atPrime
    {R : Type*} [CommRing R] (m : Ideal R) [m.IsPrime]
    (A : Type*) [CommRing A] [Algebra R A] [IsLocalization.AtPrime A m] :
    ringKrullDim A = m.height
```

**Role.** Step 1 ergonomic bridge: re-export of
`IsLocalization.AtPrime.ringKrullDim_eq_height` under a project-local name. The
boundary translator inside `isRegularLocalRing_stalk_of_smooth` between
`Scheme.ringKrullDim_stalk_eq_coheight` (the iter-183 CoheightBridge bridge,
phrased in `ringKrullDim`) and the Mathlib polynomial-ring height arithmetic
(phrased in `Ideal.height`).

**Axiom check.** `axioms: [propext, Classical.choice, Quot.sound]` ✓

### 2. `MvPolynomial.maximalIdeal_height_ge_card_of_field` (line ~696)

**Type signature.**
```lean
private theorem MvPolynomial.maximalIdeal_height_ge_card_of_field
    (k : Type u) [Field k] (n : ℕ) :
    ∀ (m : Ideal (MvPolynomial (Fin n) k)) [m.IsMaximal], (n : ℕ∞) ≤ m.height
```

**Role.** Lower bound, Fin n version: every maximal ideal of
`MvPolynomial (Fin n) k` has height `≥ n`.

**Proof technique.** Induction on `n`. The inductive step transports `m` along
`MvPolynomial.finSuccEquiv` to `m'` in `Polynomial (MvPolynomial (Fin n) k)`,
contracts to `p = m' ∩ MvPolynomial (Fin n) k` (maximal by
`Polynomial.isMaximal_comap_C_of_isJacobsonRing` since `MvPolynomial (Fin n) k`
is Jacobson), applies `Polynomial.height_eq_height_add_one`, and inducts on `p`.

**Axiom check.** `axioms: [propext, Classical.choice, Quot.sound]` ✓

### 3. `MvPolynomial.maximalIdeal_height_le_natCard_of_field` (line ~717)

**Type signature.**
```lean
private theorem MvPolynomial.maximalIdeal_height_le_natCard_of_field.{v}
    (k : Type u) [Field k] {ιx : Type v} [Finite ιx]
    (m : Ideal (MvPolynomial ιx k)) (hm : m ≠ ⊤) :
    m.height ≤ Nat.card ιx
```

**Role.** Upper bound, general `[Finite ιx]` form: any proper ideal of
`MvPolynomial ιx k` has height `≤ Nat.card ιx`.

**Proof technique.** Direct composition of `Ideal.height_le_ringKrullDim_of_ne_top`
+ `MvPolynomial.ringKrullDim_of_isNoetherianRing` + `ringKrullDim_eq_zero_of_field`.

**Axiom check.** `axioms: [propext, Classical.choice, Quot.sound]` ✓

### 4. `MvPolynomial.maximalIdeal_height_eq_card` (line ~727)

**Type signature.**
```lean
private theorem MvPolynomial.maximalIdeal_height_eq_card
    (k : Type u) [Field k] (n : ℕ)
    (m : Ideal (MvPolynomial (Fin n) k)) [hmax : m.IsMaximal] :
    m.height = n
```

**Role.** Combined equality, `Fin n` form: every maximal ideal of
`MvPolynomial (Fin n) k` has height exactly `n`. The substantive Step 2 of the
analogist recipe, in its closest-to-Mathlib form.

**Proof technique.** `le_antisymm` of (3) and (2).

**Axiom check.** `axioms: [propext, Classical.choice, Quot.sound]` ✓

### 5. `MvPolynomial.maximalIdeal_height_eq_natCard` (line ~738)

**Type signature.**
```lean
private theorem MvPolynomial.maximalIdeal_height_eq_natCard.{v}
    (k : Type u) [Field k] (ιx : Type v) [Finite ιx]
    (m : Ideal (MvPolynomial ιx k)) [m.IsMaximal] :
    m.height = Nat.card ιx
```

**Role.** Combined equality, general `[Finite ιx]` form: transports (4) along
`MvPolynomial.renameEquiv` through `Fintype.equivFin`.

**Proof technique.** Transport along the rename-equivalence
`MvPolynomial ιx k ≃+* MvPolynomial (Fin (Fintype.card ιx)) k`, using
`Ideal.map_isMaximal_of_equiv` + `RingEquiv.height_map` + (4).

**Axiom check.** `axioms: [propext, Classical.choice, Quot.sound]` ✓

### 6. `ringKrullDim_localization_atMaximal_MvPolynomial` (line ~767)

**Type signature.**
```lean
private theorem ringKrullDim_localization_atMaximal_MvPolynomial.{v}
    {k : Type u} [Field k] {ιx : Type v} [Finite ιx]
    (m : Ideal (MvPolynomial ιx k)) [m.IsMaximal]
    (A : Type*) [CommRing A] [Algebra (MvPolynomial ιx k) A]
    [IsLocalization.AtPrime A m] :
    ringKrullDim A = (Nat.card ιx : WithBot ℕ∞)
```

**Role.** Capstone composition of Steps 1+2: for any localisation `A` of
`MvPolynomial ιx k` at a maximal ideal `m`, `ringKrullDim A = Nat.card ιx`.
This is the directly-consumable form that downstream Lane COE iter-201+
closure (the Jacobian-regular-sequence step) plugs into.

**Proof technique.** Two-line composition of Step 1 (re-export) and Step 2
(general form).

**Axiom check.** `axioms: [propext, Classical.choice, Quot.sound]` ✓

### 7. `ringKrullDim_quotient_add_eq_of_regular_sequence` (line ~790)

**Type signature.**
```lean
private theorem ringKrullDim_quotient_add_eq_of_regular_sequence
    {R' : Type*} [CommRing R'] [IsNoetherianRing R'] [IsLocalRing R']
    (rs : List R') (hReg : RingTheory.Sequence.IsRegular R' rs)
    {a b : ℕ} (hDim : ringKrullDim R' = (a : WithBot ℕ∞))
    (hLen : rs.length = b) :
    ringKrullDim (R' ⧸ Ideal.ofList rs) + (b : WithBot ℕ∞) = (a : WithBot ℕ∞)
```

**Role.** Step 3 parameterised additive form. Combined with (6) plus the
Jacobian-regular-sequence witness (Mathlib gap, iter-201+ obligation), this
yields `ringKrullDim Sₘ = (a − b : ℕ)` for the standard-smooth quotient
`Sₘ = A ⧸ Ideal.ofList rs`.

Note: an explicit subtraction form was attempted but `WithBot ℕ∞` does not carry
a subtraction structure, so the additive form is the natural API.

**Axiom check.** `axioms: [propext, Classical.choice, Quot.sound]` ✓

## Summary

- **Declarations added:** 7 axiom-clean private theorems
  (lines ~688, ~696, ~717, ~727, ~738, ~767, ~790), totaling ~165 LOC including
  docstrings.
- **Declarations blocked:** none in this iter's scope. The natural follow-up
  (closing `isRegularLocalRing_stalk_of_smooth` body line 1061) requires the
  Jacobian-regular-sequence witness (Stacks 00SW / 00OW), which is the
  iter-201+ Lane COE substantive obligation per the analogist recipe.
- **Sorry count:** 3 → 3 (line 1061: `isRegularLocalRing_stalk_of_smooth`;
  line 1258: `extend_of_codimOneFree_of_smooth`; line 1333:
  `indeterminacy_pure_codim_one_into_grpScheme`). No public signature changes.
- **Compile status:** GREEN (no errors; 3 pre-existing sorry warnings).

## Why I stopped

**Real progress.** 7 axiom-clean substrate declarations added, named at lines
~688, ~696, ~717, ~727, ~738, ~767, ~790:

1. `ringKrullDim_localization_eq_height_atPrime` — Step 1 trivial bridge.
2. `MvPolynomial.maximalIdeal_height_ge_card_of_field` — Step 2 lower bound,
   Fin n form. **The substantive proof of the iteration** (induction over
   `Fin n` using `finSuccEquiv` + `Polynomial.height_eq_height_add_one` +
   `Polynomial.isMaximal_comap_C_of_isJacobsonRing` for the Jacobson contraction).
3. `MvPolynomial.maximalIdeal_height_le_natCard_of_field` — Step 2 upper
   bound, general form.
4. `MvPolynomial.maximalIdeal_height_eq_card` — Step 2 combined, Fin n.
5. `MvPolynomial.maximalIdeal_height_eq_natCard` — Step 2 combined, general.
6. `ringKrullDim_localization_atMaximal_MvPolynomial` — Steps 1+2 capstone.
7. `ringKrullDim_quotient_add_eq_of_regular_sequence` — Step 3 additive form.

These match exactly the iter-200 mathlib-analogist `coe-stacks00oe`
**Top suggestion** recipe: Analogue 4 (Step 1, `IsLocalization.AtPrime.ringKrullDim_eq_height`)
+ Analogue 1 (Step 2, `Polynomial.height_eq_height_add_one` iterated) + Analogue 2
(Step 3, `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular`).

**Partial progress: substantive Step 3 residual obligation.** The Jacobian-
regular-sequence witness (Stacks 00SW / 00OW) — showing that the relations of
a `SubmersivePresentation` form a regular sequence in `R'_{m'}` — is the iter-201+
Lane COE work. The analogist estimated 30–60 LOC for this; the Mathlib API
pieces are `Algebra.SubmersivePresentation.jacobian_isUnit` (EXISTS),
`RingTheory.Sequence.isRegular_cons_iff` (EXISTS), and
`IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal` (EXISTS).

**Push-beyond on the L1061 sorry NOT attempted.** Even with my 7 axiom-clean
substrate lemmas in place, closing the body of `isRegularLocalRing_stalk_of_smooth`
inline requires several additional bridges:
* Extracting an explicit `SubmersivePresentation` from
  `Algebra.IsStandardSmooth (Γ(Spec, U)) (Γ(X.left, V))` (Stage 6 (i) substrate
  iter-198 gives `IsStandardSmoothOfRelativeDimension`, not the presentation
  directly).
* Identifying the maximal ideal of `Γ(X.left, V)` corresponding to `z ∈ V`.
* Bridging from `Γ(Spec(.of kbar), U) = kbar` (since `Spec kbar` is a point,
  this should be definitional via `U = ⊤`).
* The Jacobian-regular-sequence witness (substantive residual).

Each of these is a multi-LOC project-side build; bundled with the regular-sequence
substantive work, they constitute the iter-201+ Lane COE main effort.

The 7 axiom-clean substrate lemmas landed this iter are the *load-bearing*
piece of the chain (the Step 2 substantive content was Mathlib-absent before
this iter and is now closed); the remaining iter-201+ work is regular-sequence
construction + scheme-to-algebra bridging, both substantially less Mathlib-
search-heavy than the height computation closed here.

## Approaches written but not attempted (none worth noting separately)

No approaches were written-down-but-not-attempted this iter. The analogist
recipe + Mathlib search + lower-bound induction pattern (via finSuccEquiv +
Jacobson contraction) was tried and worked on the first attempt for Steps 1, 2
upper-bound, 2 lower-bound (Fin n), 2 combined (general), capstone, and Step 3
additive form. The Step 3 subtraction form (using `WithBot ℕ∞ − ℕ`) was tried
and rejected because `WithBot ℕ∞` does not have a subtraction structure (the
omega tactic correctly reports `HSub` instance failure); the additive form is
the natural API.

## Dead-end warnings (for the planner)

- **Do NOT** rephrase the Step 3 substrate in subtraction form. `WithBot ℕ∞`
  does not have a subtraction structure (no `HSub (WithBot ℕ∞) (WithBot ℕ∞) X`
  instance). The additive form
  `ringKrullDim (R' ⧸ Ideal.ofList rs) + b = a` is the natural API.
- **Do NOT** retry building `Polynomial.height_eq_height_add_one`'s MvPolynomial
  analogue directly; the cleanest route is induction on `Fin n` (as landed),
  not on a generic `Finite ι`.

## Next step (iter-201+)

1. **Jacobian-regular-sequence witness** (~30-60 LOC project-side):
   Build the missing bridge `Algebra.SubmersivePresentation.relations_isRegular_in_localization`
   consuming `Algebra.SubmersivePresentation.jacobian_isUnit` +
   `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`.
   This is the substantive Stacks 00SW / 00OW algebra-side content.
2. **Scheme-to-algebra bridge for `isRegularLocalRing_stalk_of_smooth`'s body
   inline closure**: leverage the existing Stage 3 chain to extract the
   SubmersivePresentation from `Γ(X.left, V)` (over `Γ(Spec, U) = kbar`) and
   identify the maximal ideal at `z`. Then chain through (6) for the localized
   `MvPolynomial` side + (7) for the quotient-side dimension drop.
3. **Cascade Lane T32 re-engagement**: per PROGRESS.md "Lane T32 — Lane COE
   derivative; binding trigger: COE Stage 6.B Krull-dim formula closed", landing
   Stage 6 (ii.B) fully unblocks Lane T32 with a ~60 LOC derivative.

## Mathlib readiness audit (iter-200 actual API state at b80f227)

Confirmed EXISTS during this iter's substrate build:
* `IsLocalization.AtPrime.ringKrullDim_eq_height`
* `IsLocalRing.maximalIdeal_height_eq_ringKrullDim`
* `Ideal.height_le_ringKrullDim_of_ne_top`
* `MvPolynomial.ringKrullDim_of_isNoetherianRing`
* `ringKrullDim_eq_zero_of_field`
* `Polynomial.height_eq_height_add_one`
* `Polynomial.isMaximal_comap_C_of_isJacobsonRing`
* `MvPolynomial.finSuccEquiv`
* `MvPolynomial.renameEquiv`
* `RingEquiv.height_map`
* `RingEquiv.height_comap`
* `Ideal.map_isMaximal_of_equiv`
* `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular`
* `Algebra.SubmersivePresentation` (structure)
* `Algebra.SubmersivePresentation.isStandardSmoothOfRelativeDimension`
* `Algebra.SubmersivePresentation.jacobian_isUnit`
* `RingTheory.Sequence.IsRegular`
* `RingTheory.Sequence.isRegular_cons_iff`
* `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`

Confirmed MISSING (the Stage 6 (ii.B) residual obligation):
* `Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension`
  — packaged form Mathlib doesn't ship. My capstone
  `ringKrullDim_localization_atMaximal_MvPolynomial` covers the polynomial-ring
  side; the full bridge requires also the regular-sequence witness for the
  quotient side.

## Blueprint pin handoff to review agent

The new substrate lemmas are project-local `private` declarations, not exposed
for downstream consumption outside `CodimOneExtension.lean`. They support the
existing blueprint pin `lem:smooth_to_regular_local_ring` (=
`AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth`, L1061 sorry).

The blueprint chapter `Albanese_CodimOneExtension.tex` already pins
Stage 6.A (`lem:smooth_algebra_krull_dim_formula` →
`Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension`,
**Mathlib-absent**), Stage 6.B (`lem:cotangent_kahler_over_field` →
`cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue`, **landed
iter-199 axiom-clean**), and Stage 6.C (`lem:stage6_regular_stalk_assembly`,
**still a Mathlib gap**).

**Review-agent action items for iter-200 chapter sync:**

* Recommend NOT marking `lem:smooth_to_regular_local_ring` with `\leanok` —
  the L1061 sorry remains; the substrate lemmas built this iter narrow the
  remaining content but do not close the proof body.
* Recommend ADDING new `\lean{...}` pins to the chapter pointing at the 7 new
  axiom-clean substrate lemmas (Step 1: `ringKrullDim_localization_eq_height_atPrime`;
  Step 2: `MvPolynomial.maximalIdeal_height_eq_card` / `…_eq_natCard`;
  Step 3: `ringKrullDim_quotient_add_eq_of_regular_sequence`; capstone:
  `ringKrullDim_localization_atMaximal_MvPolynomial`). The pin names should be
  prefixed with `AlgebraicGeometry.Scheme.` since they live in that namespace.
* Recommend ADDING new blueprint subsection
  `\subsec:stage6_iib_substrate_iter200` documenting the iter-200 Step 1+2
  closures and the iter-201+ residual obligation (Jacobian-regular-sequence
  witness). Existing `\cref{lem:smooth_algebra_krull_dim_formula}` Stage 6.A
  description should be updated to note the Step 2 polynomial-side computation
  has now landed axiom-clean (via these private helpers) while Step 3 awaits
  the Jacobian witness.

The substrate is forward-compatible: even if the iter-201+ Jacobian-regular-
sequence path is replaced by a different route (e.g., transcendence-degree
approach), these height-computation lemmas remain useful as project-side
infrastructure.
