# Mathlib Analogist Directive

## Mode
cross-domain-inspiration

## Slug
ftthree-kernel

## Structural problem

For a field extension `K / k` that is **separably generated** (in
characteristic 0 this is automatic for any finitely generated extension),
the kernel of the **universal Kähler derivation**
`d : K → Ω_{K/k}` (Mathlib `KaehlerDifferential.D k K`) equals the
**relative algebraic closure of `k` in `K`** — the "field of constants".
Concretely we need the implication:

> if `d x = 0` in `Ω_{K/k}` then `x` is algebraic over `k`.

Combined with the standing fact "`k` is algebraically closed in `K`"
(supplied separately: `K = Frac(B)` with `B` a domain finite-type over an
algebraically closed `k`, characteristic 0), this collapses to
`ker d = k`, i.e. `x ∈ k`.

Abstractly: **the kernel of a universal derivation valued in the module of
relative differentials equals the maximal subfield on which the derivation
is forced to vanish (the algebraically-closed-in / constant subfield).**
This is the field-theoretic core; `K` has positive transcendence degree
over `k`, so `Ω_{K/k} ≠ 0` — the content lives in the transcendental layer,
not the algebraic one.

The concrete classical assembly we believe works (please verify each step
against Mathlib and tell us which Mathlib pieces exist vs. must be built):

1. Pick a **separating transcendence basis** `{t_1,…,t_r}` of `K/k`; then
   `K / k(t_1,…,t_r)` is finite separable (algebraic).
2. `Ω_{K/k}` is **free** on `{d t_1,…,d t_r}` (separating transcendence
   basis ⇒ free cotangent module).
3. The conormal/cotangent exact sequence for the tower
   `k → k(t) → K`: since `K/k(t)` is finite separable,
   `Ω_{K/k(t)} = 0`, and the sequence
   `Ω_{k(t)/k} ⊗_{k(t)} K → Ω_{K/k} → Ω_{K/k(t)} = 0` is also injective
   on the left (separability), giving `Ω_{K/k} ≅ Ω_{k(t)/k} ⊗ K`.
4. `d x = 0` ⇒ all "partials" `∂x/∂t_i = 0` ⇒ `x` is algebraic over
   `k(t)` (a transcendental-dependence argument), then (char 0 / `k` alg
   closed in `K`) ⇒ `x ∈ k`.

## Failed approaches

- `Differential.ContainConstants` / `mem_range_of_deriv_eq_zero`
  (`Mathlib.RingTheory.Derivation.DifferentialRing`): stated for an
  ABSTRACT single derivation `B → B` carried by a `[Differential B]`
  instance, NOT the universal Kähler derivation `K → Ω_{K/k}`. The only
  shipped `ContainConstants` instance is the trivial `ContainConstants A A`;
  installing it for our case would itself require the very fact we want.
- `Algebra.FormallyUnramified.iff_isSeparable` + `Subsingleton Ω[L/K]`
  (`Mathlib.RingTheory.Unramified.Field`): only handles the ALGEBRAIC
  (`EssFiniteType`) case where `Ω = 0`. Our `K` has positive transcendence
  degree, so this applies only to the *top* layer `K/k(t)`, not to the
  whole extension where the content lives.
- `Mathlib.RingTheory.Smooth.Field`
  (`FormallySmooth.of_algebraicIndependent_of_isSeparable`): gives formal
  smoothness of separably-generated extensions but exposes NO basis of
  `Ω_{K/k}` from a separating transcendence basis and NO kernel description.
- `lean_loogle "KaehlerDifferential.D _ _ ?x = 0"` → ∅: no off-the-shelf
  kernel-of-`D` description lemma.

## Search radius
narrow

(Stay within commutative algebra / field theory / differential algebra /
algebraic geometry — but cross sub-areas aggressively. The analogue is
likely "one shelf over": differential-field / Liouville theory, the
polynomial-derivative kernel, the Kähler-cotangent exact-sequence API, the
transcendence-basis API, the smooth/unramified-field API.)

## Hints (use sparingly; your value is finding what we couldn't)

The questions we most need answered, each with a Mathlib citation
(path + line) for what EXISTS and an explicit "ABSENT" when it doesn't:

- **Separating transcendence basis API.** Does Mathlib have
  `IsSeparable`/`IsSeparating` transcendence-basis machinery, and a lemma
  giving `Ω_{K/k}` free on a separating transcendence basis? Look at
  `Mathlib.FieldTheory.{IntermediateField,SeparableDegree,PurelyInseparable}`,
  `Mathlib.RingTheory.AlgebraicIndependent.*`,
  `Mathlib.RingTheory.Kaehler.*`. Is there a `IsTranscendenceBasis`-keyed
  freeness-of-`Ω` result anywhere?
- **Cotangent exact sequence for a tower.** Mathlib has
  `KaehlerDifferential.exact_mapBaseChange_map` (already used in this
  project at `Differentials.lean:86`). Is there the LEFT-exactness
  (injectivity of `Ω_{k(t)/k} ⊗ K → Ω_{K/k}`) for a SEPARABLE top layer —
  e.g. via `Algebra.H1Cotangent` vanishing
  (`Mathlib.RingTheory.Kaehler.CotangentComplex` /
  `Mathlib.RingTheory.Smooth.Kaehler`)? The Jacobi–Zariski / cotangent
  complex `H1Cotangent` API is the likely home.
- **Differential-field kernel precedent.** How does
  `Mathlib.FieldTheory.Differential.{Basic,Liouville}` characterise the
  constants of a differential field, and is any of that technique portable
  to the universal Kähler derivation (even though those instances are
  Liouville-flavoured single derivations)?
- **The polynomial / rational-function base case.** Mathlib has
  `KaehlerDifferential.polynomialEquiv` + `polynomialEquiv_D`
  (`Mathlib.RingTheory.Kaehler.Polynomial`) and
  `Polynomial.eq_C_of_derivative_eq_zero` (with `IsAddTorsionFree` /
  char-0). Is there an analogue for `Ω_{k(t)/k}` (rational function field
  / `FractionRing (MvPolynomial)`), so that `d x = 0 ⇒ x ∈ k` is reachable
  on the purely-transcendental layer `k(t)/k` directly?

Deliverables we need from you, concretely:
1. A **ranked assembly route** for FT.3 built from EXISTING Mathlib lemmas
   (each cited path+line, `[verified]` via the LSP), with the porting cost
   per step, OR a clear statement that a specific step is genuinely ABSENT
   and must be built as project material (with the suggested Lean target
   name + signature shape).
2. If a cleaner route than the 4-step transcendence-basis assembly above
   exists in Mathlib (e.g. a direct `H1Cotangent`/separable route, or a
   way to avoid choosing a separating transcendence basis), surface it as
   the top suggestion.
3. Write the persistent `analogies/ftthree-kernel-iter154.md`.
