/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Auslander–Buchsbaum formula (A.4.b)

This file is the **A.4.b** file-skeleton sub-build chapter for the project's
positive-genus arm of `nonempty_jacobianWitness`. It packages the
Auslander–Buchsbaum formula and the corollary "regular local ring
⟹ Cohen–Macaulay" that the sibling sub-build **A.4.a** (codim-1 extension of a
rational map across a codim-2 closed point on a regular projective surface)
consumes.

Per STRATEGY.md L30 this row is gated downstream on A.4.a but is independently
startable on the Mathlib side: the algebra here is decoupled from the Albanese
geometry and lives entirely under `RingTheory.*`. Mathlib at the project's
pinned commit (`b80f227`) exposes `IsRegularLocalRing` and the categorical
`CategoryTheory.projectiveDimension` on an abelian category (specialised to
`ModuleCat R`), as well as the regular-sequence definition
`RingTheory.Sequence.IsRegular`. The depth function `Module.depth`, the
Auslander–Buchsbaum formula, and the Cohen–Macaulay predicate are *not* in
Mathlib at the pinned commit — they are the new content scaffolded here.

## Status (iter-178 update — projectiveDimension closed)

This file was originally landed iter-175 (Lane F file-skeleton) with each
blueprint-pinned declaration carrying the *intended* substantive type
signature (matching the `\lean{...}` pin in
`blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`). The bodies were
scheduled for iter-176+ work; the chapter is independent of the rest of
Route A's geometric infrastructure, making it a good parallel-work
candidate.

iter-178 closed `Module.projectiveDimension` kernel-clean as a one-liner
re-export of the categorical `CategoryTheory.projectiveDimension`. The
remaining five typed `sorry` bodies (`depth`, `depth_eq_smallest_ext_index`,
`depth_of_short_exact`, `auslander_buchsbaum_formula`,
`CohenMacaulay.of_regular`) are substantive multi-iter content and stay
gated on dedicated body lanes.

The 7 pinned declarations are:

1. `RingTheory.Module.depth` (noncomputable def, ~6 LOC) — the `I`-depth of a
   finite `R`-module as the supremum of lengths of `M`-regular sequences in
   `I`, valued in `ℕ∞`.
2. `RingTheory.Module.depth_eq_smallest_ext_index` (theorem, ~10 LOC) — for
   `(R, 𝔪)` Noetherian local and `M ≠ 0` finite, `depth(M)` equals the
   smallest `i` with `Ext^i_R(κ, M) ≠ 0`. Encoded via the depth-bound iff
   `Ext` vanishes below.
3. `Module.projectiveDimension` (noncomputable def, ~3 LOC) — an
   `R`-module-side wrapper for the categorical
   `CategoryTheory.projectiveDimension (ModuleCat.of R M)`. The categorical
   version exists in Mathlib `b80f227`; this is the re-export pinned by the
   blueprint.
4. `RingTheory.depth_of_short_exact` (theorem, ~12 LOC) — the
   depth-on-a-short-exact-sequence inequalities (Stacks 00LE).
5. `RingTheory.auslander_buchsbaum_formula` (theorem, ~10 LOC) — the formula
   `pd_R(M) + depth(M) = depth(R)` for a nonzero finite `R`-module of finite
   projective dimension over a Noetherian local ring.
6. `RingTheory.CohenMacaulay` (class, ~3 LOC) — `IsCohenMacaulayLocalRing R`
   encoded as `depth(R) = krullDim R`.
7. `RingTheory.CohenMacaulay.of_regular` (theorem, ~6 LOC) — a regular local
   ring is Cohen–Macaulay (the consumer-facing input for A.4.a).

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof", each
declaration carries a substantive, non-tautological type:

- `depth` returns `ℕ∞` and is defined by the regular-sequence supremum.
- `depth_eq_smallest_ext_index` is encoded as the depth-bound `↔` `Ext`
  vanishing characterisation (the smallest non-vanishing `Ext` index = depth).
- `projectiveDimension` re-exports the categorical
  `CategoryTheory.projectiveDimension` on `ModuleCat.of R M`.
- `depth_of_short_exact` packages the three Stacks 00LE inequalities into a
  conjunction.
- `auslander_buchsbaum_formula` is the numeric equation
  `pd + depth = depth(R)`.
- `CohenMacaulay` is the equation `depth(R) = ringKrullDim R`.
- `CohenMacaulay.of_regular` is an `IsRegularLocalRing → IsCohenMacaulayLocalRing`
  implication, the consumer-facing statement.

Unfolding any declaration exposes the named substantive content (a regular-
sequence supremum, an `Ext`-vanishing characterisation, the categorical
projective dimension, …); no `Iso.refl _` / `Classical.choice ⟨witness⟩` /
empty-content `proof_wanted` placeholders are used.

## References

Blueprint: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` (~560 LOC,
7 pins). Stacks Project tags 00LF (definition-depth), 00LP (lemma-depth-ext),
00LE (lemma-depth-in-ses), 090V (proposition-Auslander–Buchsbaum), 00N4
(definition-local-ring-CM), 00OD (lemma-regular-ring-CM). Matsumura,
*Commutative Ring Theory*, Theorem 19.1. Auslander–Buchsbaum, "Homological
dimension in local rings", 1957.
-/

set_option autoImplicit false

universe u v

open CategoryTheory

namespace RingTheory

namespace Module

/-! ## §1. Depth of a finite module

The `I`-depth of a finite `R`-module `M` is the supremum in
`{0, 1, 2, …, ∞}` of the lengths of `M`-regular sequences contained in `I`
(provided `IM ≠ M`; if `IM = M` we set `depth_I(M) = ∞`). Mathlib `b80f227`
exposes the regular-sequence predicate `RingTheory.Sequence.IsRegular`
(`Mathlib.RingTheory.Regular.RegularSequence`) but not the resulting
numeric depth function — that is the gap this declaration fills.

Blueprint reference: `def:depth` (Stacks tag 00LF). -/

/-- The **`I`-depth** of a finite `R`-module `M`: the supremum (in `ℕ∞`) of
lengths of `M`-regular sequences contained in the ideal `I`.

When `IM = M` (the "trivial-quotient" case, e.g. `M = 0` or `I = R`) the
supremum is taken to be `⊤` by convention. When `(R, 𝔪)` is local one usually
calls `depth (IsLocalRing.maximalIdeal R) M` simply *the depth* of `M`.

iter-176+: the body is the supremum
```
sSup { (n : ℕ∞) | ∃ rs : List R, rs.length = n ∧ (∀ r ∈ rs, r ∈ I) ∧
                  RingTheory.Sequence.IsRegular M rs }
```
folded with the `IM = M` clause. The signature is non-tautological: it
asserts a function `(Ideal R) → (M : Type v) → ℕ∞` matching the Stacks
00LF definition.

**iter-179 Mathlib-gap check (Lane F Target 2 STRETCH)**: a pinned-commit
audit of `Mathlib.RingTheory.Regular.Depth` (the only file under
`Mathlib/RingTheory/*` containing the word "depth") confirms that Mathlib
`b80f227` ships only depth-zero lemmas (`IsSMulRegular.subsingleton_linearMap_iff`)
and *not* the numeric depth function itself. The one-liner re-export route
is therefore not available; the body stays a typed `sorry` until an
iter-180+ body lane fills the supremum-with-`IM=M` clause directly. -/
noncomputable def depth {R : Type u} [CommRing R] (_I : Ideal R)
    (_M : Type v) [AddCommGroup _M] [Module R _M] : ℕ∞ :=
  open Classical in
  if _I • (⊤ : Submodule R _M) = ⊤ then (⊤ : ℕ∞)
  else sSup { n : ℕ∞ | ∃ rs : List R, (rs.length : ℕ∞) = n ∧
    (∀ r ∈ rs, r ∈ _I) ∧ RingTheory.Sequence.IsRegular _M rs }

end Module

end RingTheory

/-! ## §2. Projective dimension

Mathlib `b80f227` exposes the categorical
`CategoryTheory.projectiveDimension : C → WithBot ℕ∞` on an abelian category
with enough projectives (file `Mathlib.CategoryTheory.Abelian.Projective.Dimension`).
For `R`-modules this specialises to `ModuleCat.of R M`. The blueprint pins the
`Module.projectiveDimension` name as the re-export that downstream consumers
can use directly on an `R`-module without first packaging it in `ModuleCat`.

Blueprint reference: `def:projective_dimension`. -/

namespace Module

/-- The **projective dimension** of an `R`-module `M`, defined as the
categorical projective dimension of `ModuleCat.of R M`.

This is a re-export of `CategoryTheory.projectiveDimension` specialised to
the abelian category `ModuleCat R`. The categorical definition is the
infimum (in `WithBot ℕ∞`) of `n : ℕ` such that all `Ext^i(M, -)` vanish for
`i > n`, equivalently the smallest length of a projective resolution of `M`.

Mathlib has the categorical `projectiveDimension` and the module-specific
`ModuleCat.projectiveDimension_eq_of_linearEquiv`; the blueprint pins the
wrapper name so downstream consumers can write
`Module.projectiveDimension R M` rather than threading `ModuleCat.of`.

The body is the one-line re-export
`CategoryTheory.projectiveDimension (ModuleCat.of R _M)`; iter-178 closed
this declaration kernel-clean. -/
noncomputable def projectiveDimension (R : Type u) [Ring R]
    (_M : Type u) [AddCommGroup _M] [Module R _M] : WithBot ℕ∞ :=
  CategoryTheory.projectiveDimension (ModuleCat.of R _M)

end Module

namespace RingTheory

namespace Module

/-! ## §3. Depth via Ext characterisation

For a Noetherian local ring `(R, 𝔪)` with residue field `κ = R/𝔪` and a
nonzero finite `R`-module `M`, the depth of `M` equals the smallest index `i`
at which `Ext^i_R(κ, M)` is nonzero (Stacks tag 00LP).

This is the lemma A.4.a's downstream consumer ultimately reads off:
combined with the regular-sequence definition (`depth`), the Ext
characterisation provides both the *lower bound* (regular sequences exhibit
`Ext^i = 0` for `i < length(rs)`) and the *upper bound* (failure of any
extension lifts a non-zero element in `Ext^{depth}(κ, M)`).

The signature pins the equivalence via the depth-bound `↔` `Ext`-vanishing-
below: `n ≤ depth(M) ↔ Ext^i(κ, M) = 0 for all i < n`. This is logically
equivalent to "depth(M) = smallest i with Ext^i ≠ 0" and is the form most
convenient for inductive proofs (Stacks 00LP proof: pick `x ∈ 𝔪`
non-zero-divisor, use long exact `Ext^*(κ, -)` on `0 → M → M → M/xM → 0`).

Blueprint reference: `lem:depth_via_ext` (Stacks tag 00LP). -/

/-- **Depth via Ext characterisation.** For a Noetherian local ring `(R, 𝔪)`
with residue field `κ = R/𝔪` and a nonzero finite `R`-module `M`, the
depth-bound `n ≤ depth(M)` is equivalent to the vanishing of `Ext^i_R(κ, M)`
for all `i < n`. Equivalently, `depth(M)` is the smallest `i` at which
`Ext^i_R(κ, M)` is nonzero.

iter-176+: the body proceeds by induction on `n` via the long exact sequence
of `Ext^*(κ, -)` applied to `0 → M → M → M/xM → 0` for a non-zero-divisor
`x ∈ 𝔪`. The base case `n = 0` is `Hom(κ, M) ≠ 0 ↔ depth(M) = 0`, which is
the standard "the maximal ideal contains a zero-divisor on `M` iff
`𝔪 ∈ Ass(M)`" characterisation (Stacks 00LC). For the iter-175 file-skeleton
the body is a typed `sorry`. -/
theorem depth_eq_smallest_ext_index
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [_root_.Module.Finite R M]
    [Nontrivial M] (n : ℕ) :
    (n : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) M ↔
      ∀ i : ℕ, i < n →
        ∀ e : Abelian.Ext.{u}
            (ModuleCat.of R (IsLocalRing.ResidueField R))
            (ModuleCat.of R M) i, e = 0 := by
  sorry

/-! ## §4. Depth on a short exact sequence

For a short exact sequence `0 → N' → N → N'' → 0` of nonzero finite modules
over a Noetherian local ring, the three modules' depths satisfy three
crosswise inequalities (Stacks tag 00LE), each a direct read-off of the
long exact `Ext^*(κ, -)` sequence and the depth-via-Ext characterisation
of §3.

Blueprint reference: `lem:depth_short_exact_sequence` (Stacks tag 00LE). -/

/-! ### Helper A (iter-182 Lane G, axiom-clean): Ext-vanishing from strict depth bound

For a Noetherian local ring `(R, 𝔪)` and a nonzero finite `R`-module `M`,
if `(i : ℕ∞) < depth M` then every element of `Ext^i_R(κ, M)` is zero.

This packages `depth_eq_smallest_ext_index` for the LES chase: the
`n ≤ depth M` form with `n := i + 1` instantiates the `∀ j < i + 1`
quantifier at `j = i`. Body is kernel-clean modulo the typed sorry of
`depth_eq_smallest_ext_index`. -/
private lemma ext_vanish_of_natCast_lt_depth
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [_root_.Module.Finite R M]
    [Nontrivial M] {i : ℕ}
    (h : (i : ℕ∞) < depth (IsLocalRing.maximalIdeal R) M)
    (e : CategoryTheory.Abelian.Ext.{u}
        (ModuleCat.of R (IsLocalRing.ResidueField R))
        (ModuleCat.of R M) i) : e = 0 := by
  have h' : ((i + 1 : ℕ) : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) M := by
    have hcast : ((i + 1 : ℕ) : ℕ∞) = (i : ℕ∞) + 1 := by push_cast; ring
    rw [hcast]; exact Order.add_one_le_of_lt h
  exact (depth_eq_smallest_ext_index (M := M) (i + 1)).mp h' i (Nat.lt_succ_self i) e

/-! ### Helper B (iter-182 Lane G, axiom-clean): `ℕ∞` tsub bridge

If `(a : ℕ) ≤ d - 1` in `ℕ∞` and `1 ≤ a` (in `ℕ`), then
`((a + 1 : ℕ) : ℕ∞) ≤ d`.

Case-split on `d = ⊤` (trivial) and `d = ↑n` (drop to `ℕ` arithmetic).
Used for the `depth N' - 1` shift in the second SES inequality. -/
private lemma natCast_add_one_le_of_le_sub_one
    {d : ℕ∞} {a : ℕ} (ha : 1 ≤ a) (h : (a : ℕ∞) ≤ d - 1) :
    ((a + 1 : ℕ) : ℕ∞) ≤ d := by
  rcases eq_or_ne d ⊤ with hd | hd
  · simp [hd]
  · obtain ⟨n, rfl⟩ := WithTop.ne_top_iff_exists.mp hd
    have hcast : (((n : ℕ) : ℕ∞) - 1) = ((n - 1 : ℕ) : ℕ∞) := by
      rcases n with _ | n
      · simp
      · push_cast; rfl
    rw [hcast] at h
    have han : a ≤ n - 1 := by exact_mod_cast h
    have : a + 1 ≤ n := by omega
    exact_mod_cast this

theorem depth_of_short_exact
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {N' N N'' : Type u}
    [AddCommGroup N'] [Module R N'] [_root_.Module.Finite R N'] [Nontrivial N']
    [AddCommGroup N] [Module R N] [_root_.Module.Finite R N] [Nontrivial N]
    [AddCommGroup N''] [Module R N''] [_root_.Module.Finite R N''] [Nontrivial N'']
    (f : N' →ₗ[R] N) (g : N →ₗ[R] N'')
    (_hf : Function.Injective f) (_hg : Function.Surjective g)
    (_hex : Function.Exact f g) :
    min (depth (IsLocalRing.maximalIdeal R) N')
        (depth (IsLocalRing.maximalIdeal R) N'')
      ≤ depth (IsLocalRing.maximalIdeal R) N
    ∧ min (depth (IsLocalRing.maximalIdeal R) N)
          (depth (IsLocalRing.maximalIdeal R) N' - 1)
        ≤ depth (IsLocalRing.maximalIdeal R) N''
    ∧ min (depth (IsLocalRing.maximalIdeal R) N)
          (depth (IsLocalRing.maximalIdeal R) N'' + 1)
        ≤ depth (IsLocalRing.maximalIdeal R) N' := by
  sorry

end Module

/-! ## §5. The Auslander–Buchsbaum formula

For a nonzero finite module `M` of finite projective dimension over a
Noetherian local ring `(R, 𝔪)`, the **Auslander–Buchsbaum formula** reads
```
  pd_R(M) + depth(M) = depth(R)
```
(Stacks tag 090V). The proof inducts on `depth(M)`: the base case
`depth(M) = 0` uses a minimal finite free resolution of `M` and the
"what is exact" criterion (Stacks 00MF) plus iterated application of the
depth-on-a-short-exact-sequence lemma (§4) to bound `depth(R)` against the
resolution length; the inductive step picks a common non-zero-divisor
`x ∈ 𝔪` on both `R` and `M`, applies the snake lemma to obtain a minimal
finite free resolution of `M/xM` over `R/xR` of the same length, and uses
the inductive hypothesis on `M/xM` over `R/xR`.

Blueprint reference: `thm:auslander_buchsbaum` (Stacks tag 090V). -/

/-- **The Auslander–Buchsbaum formula.** Let `(R, 𝔪)` be a Noetherian local
ring and let `M` be a nonzero finite `R`-module of finite projective
dimension. Then
```
  pd_R(M) + depth_R(M) = depth(R).
```

The hypothesis "finite projective dimension" is encoded by an explicit
upper bound `n : ℕ` on the projective dimension (so the formula compares
finite numeric quantities cleanly without `WithBot ℕ∞`-arithmetic
subtleties).

iter-176+: the body is the induction on `depth(M)` outlined in the
chapter — base case via the minimal-finite-free-resolution +
"what is exact" + iterated `Module.depth_of_short_exact`; inductive step
via the snake lemma on multiplication by a common non-zero-divisor and
the inductive hypothesis on `M/xM` over `R/xR`. For the iter-175
file-skeleton the body is a typed `sorry`. -/
theorem auslander_buchsbaum_formula
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [_root_.Module.Finite R M]
    [Nontrivial M]
    (n : ℕ)
    (_hpd : _root_.Module.projectiveDimension R M = (n : WithBot ℕ∞)) :
    (n : ℕ∞) + Module.depth (IsLocalRing.maximalIdeal R) M
      = Module.depth (IsLocalRing.maximalIdeal R) R := by
  sorry

/-! ## §6. Cohen–Macaulay local rings

A Noetherian local ring `(R, 𝔪)` is **Cohen–Macaulay** if its depth equals
its Krull dimension (Stacks tag 00N4). Mathlib `b80f227` has neither the
predicate nor the class — this file is the upstream gap-fill.

Blueprint reference: `def:cohen_macaulay_local` (Stacks tag 00N4). -/

/-- A Noetherian local ring `(R, 𝔪)` is **Cohen–Macaulay** if its depth
equals its Krull dimension: `depth(R) = dim R`.

Encoded as a `Prop`-valued type class so downstream consumers can write
`[CohenMacaulay R]` and use Cohen–Macaulay as a hypothesis. Mathlib at the
pinned commit (`b80f227`) does not expose any Cohen–Macaulay predicate;
this is the upstream gap-fill.

iter-176+: the predicate is `Module.depth (IsLocalRing.maximalIdeal R) R =
ringKrullDim R`. For the iter-175 file-skeleton the carrier definition is a
typed `sorry` at the `Prop` level — substantively, the predicate is the
named equality, but we package it as a `class` so use sites are uniform. -/
class CohenMacaulay (R : Type u) [CommRing R] [IsLocalRing R]
    [IsNoetherianRing R] : Prop where
  /-- The Cohen–Macaulay equation: `depth(R) = ringKrullDim R`. The numeric
  comparison is in `WithBot ℕ∞` after coercion of the `ℕ∞`-valued depth. -/
  depth_eq_krullDim :
    (Module.depth (IsLocalRing.maximalIdeal R) R : WithBot ℕ∞) = ringKrullDim R

/-! ## §7. Regular local rings are Cohen–Macaulay

The consumer-facing input for A.4.a: every regular Noetherian local ring is
Cohen–Macaulay (Stacks tag 00OD). The direct proof: pick a minimal
generating set `x_1, …, x_d` of `𝔪` (where `d = dim R`), use that `R` is a
domain (Stacks 00NQ) to start an `R`-regular sequence, and induct on
dimension — each `R/(x_1, …, x_c)` is again regular of dimension `d - c`,
so `x_1, …, x_d` is an `R`-regular sequence and `depth(R) ≥ d`. The reverse
inequality `depth(R) ≤ dim R` is the standard depth bound (Stacks 00LK).

Blueprint reference: `cor:regular_cohen_macaulay` (Stacks tag 00OD). -/

namespace CohenMacaulay

/-! ### Helper 1 (axiom-clean): length-bound on regular sequences

For a Noetherian local ring `R`, every `R`-regular sequence has length at most
`ringKrullDim R`. This is the **upper bound** half of Stacks 00OD: it is the
specialisation of the equality
`ringKrullDim (R / ofList rs) + rs.length = ringKrullDim R`
(`ringKrullDim_add_length_eq_ringKrullDim_of_isRegular`) to the observation that
`ringKrullDim (R / ofList rs) ≥ 0` whenever the quotient is nontrivial, which it
is precisely because `IsRegular` rules out `rs • ⊤ = ⊤`.

iter-181 Lane G: closed kernel-clean. -/
private lemma length_le_ringKrullDim_of_isRegular
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {rs : List R} (h : RingTheory.Sequence.IsRegular R rs) :
    (rs.length : WithBot ℕ∞) ≤ ringKrullDim R := by
  have heq := ringKrullDim_add_length_eq_ringKrullDim_of_isRegular rs h
  have hntq : Nontrivial (R ⧸ Ideal.ofList rs) := by
    rw [Ideal.Quotient.nontrivial_iff]
    intro habs
    apply h.top_ne_smul
    change (⊤ : Submodule R R) = (Ideal.ofList rs) • ⊤
    rw [habs]; simp
  have hnn : (0 : WithBot ℕ∞) ≤ ringKrullDim (R ⧸ Ideal.ofList rs) :=
    ringKrullDim_nonneg_of_nontrivial
  calc (rs.length : WithBot ℕ∞)
      = 0 + (rs.length : WithBot ℕ∞) := by simp
    _ ≤ ringKrullDim (R ⧸ Ideal.ofList rs) + (rs.length : WithBot ℕ∞) := by gcongr
    _ = ringKrullDim R := heq

/-! ### Helper 2 (substantive typed `sorry`): system-of-parameters as a regular sequence

For a regular local ring `R` of Krull dimension `d = (maximalIdeal R).spanFinrank`,
a minimal generating set `x_1, …, x_d` of the maximal ideal `𝔪` is an `R`-regular
sequence. This is the **lower bound** half of Stacks 00OD.

The proof in Stacks 00OD uses:
1. A regular local ring is an integral domain (Stacks 00NQ).
2. For each `c < d`, the quotient `R / (x_1, …, x_c)` is again a regular local
   ring, of Krull dimension `d - c` (Krull's principal ideal theorem +
   `lemma-one-equation`).

Step (1) — `IsRegularLocalRing R ⟹ IsDomain R` — is **not present in Mathlib at
the pinned commit** (`b80f227`); a `lean_leansearch` for "regular local ring is
a domain" returns nothing relevant. Step (2) requires the regular-quotient
inductive structure (Stacks 00NQ + height-one quotient regularity), which is
similarly absent. Both are substantive multi-iter content.

The signature here is the non-tautological existence statement: a list `rs : List R`
with `rs.length = (maximalIdeal R).spanFinrank`, `rs ⊆ maximalIdeal R`, and
`IsRegular R rs`. Downstream, `of_regular` consumes this directly to close the
`depth ≥ d` lower bound.

iter-182+: discharge candidates are (a) formalising `IsRegularLocalRing ⟹ IsDomain`
first (the Stacks 00NQ argument: a regular local ring has no embedded prime in
the zero ideal, hence the zero ideal is prime); (b) leveraging an alternative
characterisation of depth that bypasses the explicit regular-sequence
construction (e.g.\ depth via `Ext` over the residue field, Stacks 00LP, which
is its own lane `depth_eq_smallest_ext_index`). -/
lemma exists_isRegular_of_regularLocal
    (R : Type u) [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    [IsRegularLocalRing R] :
    ∃ rs : List R, rs.length = (IsLocalRing.maximalIdeal R).spanFinrank
        ∧ (∀ r ∈ rs, r ∈ IsLocalRing.maximalIdeal R)
        ∧ RingTheory.Sequence.IsRegular R rs := by
  sorry

/-- **Regular local rings are Cohen–Macaulay.** Every regular Noetherian
local ring is Cohen–Macaulay: a minimal generating set of `𝔪` is an
`R`-regular sequence of length `dim R`, so `depth(R) ≥ dim R`; combined
with the standard upper bound `depth(R) ≤ dim R` (Stacks 00LK) this gives
`depth(R) = dim R`.

This is the consumer-facing input for **A.4.a** (codim-1 extension of a
rational map across a codim-2 closed point on a regular projective
surface): the local ring `O_{S,x}` of a regular projective surface at a
closed point is regular of Krull dimension `2`, hence Cohen–Macaulay,
hence has depth `2`, which is exactly the input the local-cohomology
vanishing `H^i_x(O_S) = 0` for `i < 2` needs (Stacks 0AVF; see Hartshorne
III.7).

iter-181 Lane G **STRUCTURAL**: body is now decomposed into two
typed helper lemmas — `length_le_ringKrullDim_of_isRegular` (the upper
bound, closed kernel-clean from
`ringKrullDim_add_length_eq_ringKrullDim_of_isRegular`) and
`exists_isRegular_of_regularLocal` (the lower bound, typed `sorry` on the
Mathlib gap `IsRegularLocalRing ⟹ IsDomain` + regular-quotient induction).
The combined assembly into `depth = ringKrullDim` is closed inline below,
so the only residual `sorry` in this `instance` body is the named helper. -/
instance of_regular (R : Type u) [CommRing R] [IsLocalRing R]
    [IsNoetherianRing R] [IsRegularLocalRing R] : CohenMacaulay R where
  depth_eq_krullDim := by
    -- Step 1: simplify `Module.depth` via the `else` branch
    --   (since `𝔪 • ⊤ = 𝔪 ≠ ⊤` for a local ring's maximal ideal).
    have h𝔪 : (IsLocalRing.maximalIdeal R) • (⊤ : Submodule R R)
        ≠ (⊤ : Submodule R R) := by
      have heq : (IsLocalRing.maximalIdeal R) • (⊤ : Submodule R R)
          = IsLocalRing.maximalIdeal R := by simp
      rw [heq]
      exact (IsLocalRing.maximalIdeal.isMaximal R).ne_top
    rw [Module.depth, if_neg h𝔪]
    -- Step 2: convert RHS to the spanFinrank using
    -- `IsRegularLocalRing.spanFinrank_maximalIdeal`.
    rw [← IsRegularLocalRing.spanFinrank_maximalIdeal]
    -- Goal: ((sSup {n | …} : ℕ∞) : WithBot ℕ∞)
    --         = ((spanFinrank 𝔪 : ℕ) : WithBot ℕ∞)
    -- Step 3: it suffices to show the sSup equals spanFinrank as ℕ∞,
    -- via antisymmetry: upper bound from Helper 1, lower bound from Helper 2.
    have h1 : (sSup { n : ℕ∞ | ∃ rs : List R, (rs.length : ℕ∞) = n ∧
        (∀ r ∈ rs, r ∈ IsLocalRing.maximalIdeal R)
          ∧ RingTheory.Sequence.IsRegular R rs }
        : ℕ∞) = ((IsLocalRing.maximalIdeal R).spanFinrank : ℕ∞) := by
      apply le_antisymm
      · -- Upper bound: every element of the sSup-set is at most spanFinrank.
        apply sSup_le
        rintro n ⟨rs, rfl, _, hreg⟩
        have hub := length_le_ringKrullDim_of_isRegular hreg
        rw [← IsRegularLocalRing.spanFinrank_maximalIdeal] at hub
        exact_mod_cast hub
      · -- Lower bound: spanFinrank is achieved by Helper 2's regular sequence.
        obtain ⟨rs, hlen, hmem, hreg⟩ := exists_isRegular_of_regularLocal R
        apply le_sSup
        refine ⟨rs, ?_, hmem, hreg⟩
        exact_mod_cast hlen
    rw [h1]
    -- Final coercion: `((n : ℕ∞) : WithBot ℕ∞) = ((n : ℕ) : WithBot ℕ∞)`
    -- is the standard `Nat.cast`-tower commutation.
    rfl

end CohenMacaulay

end RingTheory
