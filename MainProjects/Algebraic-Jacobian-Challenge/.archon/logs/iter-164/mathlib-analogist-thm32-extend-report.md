# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
thm32-extend

## Iteration
164

## Structural problem
Extend a rational map `α : V ⇢ A` (a morphism on a dense open `U ⊆ V`) from a smooth
projective surface `V` (the case needed: `V = ℙ¹×ℙ¹`) into an abelian variety `A`
(a smooth proper `GrpObj` over `Spec k̄`) to an everywhere-defined morphism, **without
building Weil-divisor theory**. The riskiest piece is Milne *Abelian Varieties* Thm 3.2 +
Lemma 3.3. Open question: is there a pointwise valuative side-step — extend
`Spec K(V) → A` over each DVR `O_{V,Z}` using only properness + group — that empties the
indeterminacy locus *without* constructing `div(f)`?

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `ValuativeCriterion.Existence` + `Scheme.PartialMap.ofFromSpecStalk` (Thm 3.1, codim ≥ 2) | AG: valuative / spreading-out shelf | medium | ANALOGUE_FOUND |
| ruling + `rigidity_over_kbar` reduction (avoids Lemma 3.3 on `ℙ¹×ℙ¹`) | AG: in-repo rigidity | low–medium* | ANALOGUE_FOUND |
| `RingTheory.OrderOfVanishing.ord` (divisor-free local multiplicity) | commutative algebra | high | PARTIAL_ANALOGUE |

\* conditional on a circularity check (see Analogue 2).

## Direct answer to the open question
**No pure-valuative side-step empties the locus.** The valuative criterion at height-1
primes yields exactly "defined at every codim-1 point" = complement codim ≥ 2
(= Theorem 3.1), and this is free from properness — **no group, no divisors**. It cannot
reach codim 0: a DVR *is* a codim-1 local ring, so the criterion is structurally blind to
codim-≥2 points, and for a general proper target those points genuinely obstruct
extension (`ℙ²⇢ℙ¹` at `[0:0:1]`). The emptiness step (Lemma 3.3) needs the group law;
Milne's proof of it needs "codim-1 = locally principal" = regular local rings are UFDs
(Auslander–Buchsbaum), which **Mathlib lacks**. So either gap-fill Auslander–Buchsbaum, or
**avoid Lemma 3.3** via the ruling/rigidity reduction (Analogue 2).

## What Mathlib already ships (verified, with citations)
The whole codim-1 half lives in a Mathlib sub-area the project is **not importing** (only
two incidental `Scheme.PartialMap.Opens.isDominant_ι` uses, `AbelianVarietyRigidity.lean:700`,
`Rigidity.lean:113`):

- `AlgebraicGeometry.ValuativeCommSq {X Y} (f : X ⟶ Y)` — `Mathlib/AlgebraicGeometry/ValuativeCriterion.lean:53`. Bundles a `ValuationRing R`, `K = Frac R`, `i₁ : Spec K ⟶ X`, `i₂ : Spec R ⟶ Y`, commuting square. This is the "lift over a DVR" obligation.
- `AlgebraicGeometry.ValuativeCriterion.Existence` — `ValuativeCriterion.lean:78`, `= fun f ↦ ∀ S : ValuativeCommSq f, S.commSq.HasLift`. The per-DVR lift extractor the directive asked about.
- `AlgebraicGeometry.IsProper.eq_valuativeCriterion` — `ValuativeCriterion.lean:328`: `@IsProper = ValuativeCriterion ⊓ QuasiCompact ⊓ QuasiSeparated ⊓ LocallyOfFiniteType`. `rw` gives `IsProper A.hom → Existence A.hom`. (Reverse `of_valuativeCriterion` at `:339`.)
- `Scheme.PartialMap` / `Scheme.RationalMap` (`⤏`) — `Mathlib/AlgebraicGeometry/RationalMap.lean:47` / `:320`; maximal `RationalMap.domain` (`sSup` of representatives) `:485`; glued `RationalMap.toPartialMap` (uses `Y` separated) `:517`.
- `Scheme.PartialMap.fromFunctionField : Spec K(X) ⟶ Y` `:145`; `Scheme.PartialMap.ofFromSpecStalk` (spreads a `Spec O_x ⟶ Y` to a neighbourhood) `:179`, on `spread_out_of_isGermInjective'` (`SpreadingOut.lean:367`).
- `IsIntegral X → X.IsGermInjective` — `SpreadingOut.lean:158` (the `ofFromSpecStalk` prerequisite, free for integral `V`).
- `Scheme.functionField` `FunctionField.lean:38`; `IsFractionRing (X.presheaf.stalk x) X.functionField` for integral `X` `:151`; `IsDomain (X.presheaf.stalk x)` `:166`. Supplies `K = K(V)`, `R = O_{V,Z}` directly.
- DVR at a height-1 point **with no global Dedekind hypothesis**: `IsDiscreteValuationRing.tfae_of_isNoetherianRing_of_isLocalRing_of_isDomain` — `Mathlib/RingTheory/DiscreteValuationRing/TFAE.lean:168`, where `tfae_have 6 ↔ 5 := finrank_cotangentSpace_le_one_iff` (`Mathlib/RingTheory/Ideal/Cotangent.lean:349`). Regular local of dim 1 + `¬IsField` ⟹ DVR ⟹ `ValuationRing` (`DiscreteValuationRing/Basic.lean:512` / `of_isDiscreteValuationRing`). ⚠ The Dedekind extractor `IsLocalization.AtPrime.isDiscreteValuationRing_of_dedekind_domain` (`DedekindDomain/Dvr.lean:131`) is the **wrong generality** — it needs the *global* ring dim ≤ 1, which fails on a surface.

## What Mathlib does NOT have (confirmed absent)
- No scheme-level Weil/Cartier divisor API (`div(f)`, prime divisors, divisor group).
- No Auslander–Buchsbaum (`IsRegularLocalRing → UniqueFactorizationMonoid`), the algebra
  fact Lemma 3.3 rests on. The only divisor-free local substitute is
  `RingTheory.OrderOfVanishing.ord := Module.length R (R⧸span{x})`
  (`Mathlib/RingTheory/OrderOfVanishing/Basic.lean:35`), insufficient alone.
- No `Scheme` codimension / `height` API — the "complement has no codim-1 point ⟹ codim ≥ 2"
  bookkeeping must be hand-rolled.

## Top suggestion
Adopt the `RationalMap` + `ValuativeCriterion` + `SpreadingOut` stack for the codim-1
half now. Phrase `rationalMap_to_av_extends` against `Scheme.RationalMap` /
`RationalMap.domain`; obtain codim-≥2 from `ValuativeCriterion.Existence (A.hom)`
(via `IsProper.eq_valuativeCriterion`) + `ofFromSpecStalk`, making `O_{V,Z}` a DVR through
`tfae_of_isNoetherianRing_of_isLocalRing_of_isDomain` + `finrank_cotangentSpace_le_one_iff`.
For the final emptiness, prefer the ruling + `rigidity_over_kbar`
(`AlgebraicJacobian/RigidityKbar.lean:75`) reduction for the `ℙ¹×ℙ¹` case — **after**
clearing the circularity check (the blueprint currently derives "`ℙ¹→A` constant" through
Thm 3.2 itself, `AbelianVarietyRigidity.tex:43`; the reduction needs an upstream proof,
e.g. the `H⁰(ℙ¹,Ω)=0` differential argument at `AbelianVarietyRigidity.tex:26` or
`rigidity_lemma` directly). This beats building Weil divisors or Auslander–Buchsbaum.
First file to touch: a new `AlgebraicJacobian/RationalMapExtend.lean` importing
`Mathlib.AlgebraicGeometry.RationalMap` and `Mathlib.AlgebraicGeometry.ValuativeCriterion`.

## Discarded
- "Pointwise valuative side-step to emptiness": impossible — valuative criterion is blind
  to codim ≥ 2 (`ℙ²⇢ℙ¹` counterexample); maps to the directive's own open question, answer No.
- Milne's literal Lemma 3.3 difference-map proof via `OrderOfVanishing.ord`: still needs
  Auslander–Buchsbaum (absent) + a divisor-of-poles construction — high cost, not portable.

## Persistent file
- `analogies/thm32-extend.md` — full analogue list + decl citations + circularity caveat for future iters.

Overall verdict: the codim-1 half (Thm 3.1) is shipped Mathlib via the
`ValuativeCriterion`/`RationalMap`/`SpreadingOut` stack and needs no divisors; the
emptiness half is not a valuative trick — empty it via the ruling + genus-0-rigidity
reduction on `ℙ¹×ℙ¹`, not by building Weil divisors.
