## Mode: cross-domain-inspiration

## Structural problem

We must extend a **rational map from a smooth projective surface to a proper group
scheme** to an everywhere-defined morphism, WITHOUT building Weil-divisor theory.

Concretely (the route's riskiest piece, Milne *Abelian Varieties* Thm 3.2 + Lemma 3.3):
- `V` is a smooth (= regular) projective variety over an algebraically closed field;
  the case we actually need is the surface `V = ℙ¹ × ℙ¹`.
- `A` is an abelian variety: a smooth, proper, geometrically irreducible **group
  object** (`[GrpObj A] [IsProper A.hom] [Smooth A.hom]`) in `Over (Spec k̄)`.
- We have a rational map `α : V ⇢ A` (a morphism defined on a dense open `U ⊆ V`).
- GOAL: prove `α` extends to a morphism on all of `V`.

The classical proof has two layers:
1. **Thm 3.1 (codim ≥ 2 extension):** any rational map from a *normal* variety to a
   *proper/complete* target is defined outside a closed set of codimension ≥ 2. The
   classical proof applies the valuative criterion of properness at the DVR
   `O_{V,Z}` of each codimension-1 point `Z` (the morphism `Spec K(V) → A` from the
   function field extends over `Spec O_{V,Z}`).
2. **Lemma 3.3 (no codim-1 indeterminacy into a group):** for a map into a *group*
   variety, the indeterminacy locus is either empty or *pure codimension 1*; combined
   with (1) it must be empty. Milne proves this with the difference map
   `Φ(x,y) = α(x)·α(y)⁻¹ : V×V ⇢ A` and Weil-divisor theory (`div(f)`, prime divisors).

**Mathlib has NO usable Weil-divisor API at this generality**, so the divisor proof of
Lemma 3.3 is the blocker. The OPEN question: is there a **pointwise valuative**
side-step — show at each codim-1 point `Z` directly that `Spec K(V) → A` extends over
`Spec O_{V,Z}` using only that `A` is proper + a group — that makes the whole
indeterminacy locus empty WITHOUT globally constructing `div(f)`? I.e. can we get
"defined in codim 1" (not just codim ≥ 2) purely from the valuative criterion at each
height-1 prime, given the target is proper?

## What I want from you

A ranked list of Mathlib structural analogues + a concrete porting suggestion for EACH:

1. **Valuative-criterion globalization / removable-singularity / Hartogs-type results
   in Mathlib.** Does Mathlib have any lemma of the shape "a morphism defined on the
   complement of a codim-≥2 (or codim-≥1) closed subset of a normal/regular scheme
   into a proper/separated target extends"? Search: `IsProper`, `ValuativeCriterion`,
   `IsProper.of_valuativeCriterion`, normal scheme `S2`/`R1`/Serre conditions,
   `IsIntegrallyClosed`, extension of sections across small closed sets,
   `Scheme.Hom` extension lemmas. Cite exact decl names + namespaces that EXIST today.
2. **The valuative criterion of properness in Mathlib as it actually ships** — exact
   statement/signature of `ValuativeCriterion` / `IsProper.of_valuativeCriterion` /
   `Scheme.Hom.liftValuative` (or whatever the real names are), so we know what a
   "lift over a DVR" obligation looks like in Lean. Is there a per-DVR `valuative`
   lift extractor going the other way (FROM `IsProper` TO the unique lift)?
3. **Function field / local ring of a codim-1 point** — does Mathlib have
   `Scheme.functionField`, the DVR `O_{V,Z}` at a height-1 point of a regular/normal
   scheme, `Spec K(V) → V` the generic point, and the maps needed to phrase
   "extends over `Spec O_{V,Z}`"? Cite decls.
4. **Any cross-domain precedent** for "a map defined in codimension 1 on a regular
   scheme extends" — e.g. reflexive-sheaf extension, normal extension theorems,
   `algebraicization`, the second-Serre-condition (`S2`) extension of sections — in
   ANY Mathlib area (commutative algebra, AG, even analytic if instructive). The point
   is to find the technique that lets us avoid hand-building Weil divisors.

## Search radius

wide (any Mathlib domain)

## Out of scope

Do NOT try to prove anything. Do NOT propose building a full Weil-divisor library
unless you find Mathlib already has one usable here (in which case cite it). I want
existing-API citations + a recommended porting path, ranked by how close they are.
