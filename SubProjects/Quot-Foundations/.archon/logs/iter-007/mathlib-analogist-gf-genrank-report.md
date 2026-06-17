# Mathlib Analogist Report

## Mode
api-alignment

## Slug
gf-genrank

## Iteration
007

## Question
Pin the Mathlib-idiomatic Lean encoding for the non-torsion inductive step of
`GenericFreeness.exists_free_localizationAway_polynomial` (Nitsure §4): (1) generic rank of a finite
module `N` over `P_d := MvPolynomial (Fin d) A`; (2) the generic-rank SES `0 → P_d^{⊕m} → N → T → 0`;
(3) the support-dimension-drop reindex of `T` over `MvPolynomial (Fin m') A`, `m' < d`. Recommend
concrete signatures for `gf_generic_rank_ses` and `gf_torsion_reindex`. Re-confirm
`induction_on_isQuotientEquivQuotientPrime`.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Generic-rank number (`Module.finrank (FractionRing P_d) (LocalizedModule (nonZeroDivisors P_d) N)`) | ALIGN_WITH_MATHLIB | informational (in-proposal) |
| 1b. Lift `m` elements to a basis of the localization | NEEDS_MATHLIB_GAP_FILL | informational |
| 2. Generic-rank SES `gf_generic_rank_ses` | NEEDS_MATHLIB_GAP_FILL | informational |
| 3. Torsion reindex `gf_torsion_reindex` (variable drop + base-`A` generalization) | NEEDS_MATHLIB_GAP_FILL | major |
| Name check: `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` | CONFIRMED | informational |

## Major

**The induction must generalize the base domain `A`.** The reindex (Decision 3) inverts `g ∈ A`, so the
torsion quotient `T` becomes finite over `MvPolynomial (Fin m') (Localization.Away g)` — base ring `A_g`,
not `A`. The IH of `exists_free_localizationAway_polynomial` currently fixes `A`, so `IH m' _ T_g` will
**not typecheck**. This is the actual cause of the iter-006 "signatures depend on the generic-rank API"
stall — it is the *base ring changing under recursion*, not the rank encoding. Fix without weakening any
pinned type: prove the helper `∀ d, ∀ (A) [CommRing A] [IsDomain A] [IsNoetherianRing A] (N) […], ∃ f : A,
f ≠ 0 ∧ Free A_f N_f` by `Nat.strong_induction_on d` with `A` (and its instances, and `N`'s
`d`-dependent instances) reverted into the motive; `exists_free_localizationAway_polynomial` is its
specialization. `A` is already an explicit argument, so the public signature is unchanged. `A_g` stays a
noetherian domain, so the IH is legal there; descend the `A_g`-witness `h` back to `f'' = g·a ∈ A` via the
same tower transport as the already-proved L3b `free_localizationAway_of_free_of_eq_mul`.

## Informational

**Name check.** `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime` — CONFIRMED, path
`Mathlib.RingTheory.Ideal.AssociatedPrime.Finiteness`. Its trichotomy (subsingleton / `N ≃ₗ A⧸p` /
short-exact) matches L1+L3+the `B/𝔭` leaf in `genericFlatnessAlgebraic` exactly. Sibling
`…exists_relSeries_isQuotientEquivQuotientPrime` also exists. (`exists_finite_inj_algHom_of_fg` likewise
confirmed, `Mathlib.RingTheory.NoetherNormalization`.)

**Decision 1 — generic rank.** Use `m := Module.finrank (FractionRing P_d) (LocalizedModule (nonZeroDivisors P_d) N)`.
`P_d` is a noetherian domain, so the localization at `nonZeroDivisors P_d` is a finite-dim vector space
over `FractionRing P_d`; `Module.finrank` (ℕ-valued) is the right invariant, not `Module.rank` (Cardinal)
nor a `TensorProduct` base-change (more plumbing, same content). Lift `m` elements of `N` whose images
form a basis from verified atoms — `Module.finBasis` (basis indexed by `Fin (finrank)`),
`IsLocalizedModule.surj` (clear denominators: a basis vector `(1/s)•mk n` ⇒ image `mk n` still a basis),
`LinearIndependent.restrict_scalars` (descend independence `FractionRing P_d → P_d`). No single packaged
"lift to basis" lemma exists, but the glue is short. Helpful neighbours in `Mathlib.RingTheory.Localization.Module`:
`Module.Basis.ofIsLocalizedModule`, `LinearIndependent.localization`.

**Decision 2 — the SES.** `φ := Fintype.linearCombination P_d v` (`v : Fin m → N` the lifts); its domain
`(Fin m → P_d)` is the concrete `P_d^{⊕m}` and matches L3's `M'` slot. `φ` injective ⟺ `LinearIndependent P_d v`;
`T := N ⧸ LinearMap.range φ` with surjection `Submodule.mkQ`, `Function.Exact φ (mkQ …)`. Torsion as
`Module.IsTorsion (MvPolynomial (Fin d) A) T` (the literal input of Decision 3's annihilator anchor).
**Key simplification:** the SES needs **no inversion of `g`** — `φ` is injective and `T` is torsion over
`P_d` directly (`ker φ` torsion in torsion-free `P_d^{⊕m}` ⇒ `0`; images span the localization ⇒
`T ⊗ FractionRing P_d = 0`). The "denominator-clearing exactness after inverting one element" API the
directive asked about is thus not needed for the SES. Atoms: `Fintype.linearCombination(_apply)`,
`Fintype.range_linearCombination` (`Mathlib.LinearAlgebra.Finsupp.LinearCombination`).

**Decision 3 — reindex.** Nonzero annihilator is Mathlib (`Submodule.annihilator_top_inter_nonZeroDivisors`,
`Mathlib.Algebra.Module.Torsion.Basic`): `0 ≠ F ∈ Ann_{P_d}(T)`. The variable drop is **Mathlib-absent**:
a Nagata change of variables makes `F` monic in `X_d` up to leading coeff `g ∈ A`; inverting `g`,
`A_g[X_1..X_d]/(F)` is module-finite over `A_g[X_1..X_{d-1}] = MvPolynomial (Fin (d-1)) A_g` (division
algorithm), and `T` is finite over that by `Module.Finite.trans`. Taking `m' = d-1` **avoids Krull-dimension
theory entirely** (no need to pin `exists_finite_inj_algHom_of_fg`'s variable count to a dimension; Mathlib
has `ringKrullDim` theory but no Noether-normalization-equals-dimension lemma, and no domain-level
elimination). This denominator-clearing engine is the **same residue** the already-stubbed L4
`exists_localizationAway_finite_mvPolynomial` needs — build once, reuse; its existential style is the
template for `gf_torsion_reindex`. The `P_d^{⊕m}` end is free over `A_f` for any `f ≠ 0` via
`MvPolynomial.instFree` (free, though not module-finite over `A` — the file comment at L504 mildly
overstates "coordinatewise via the d=0 leaf", but L3 only needs freeness).

**Recommended signatures.** Both `gf_generic_rank_ses` (no `g`) and `gf_torsion_reindex` (L4-style
existential producing a module over `MvPolynomial (Fin m') (Localization.Away g)`) are written out in full,
with witnesses, in `analogies/gf-generic-rank-ses.md`. Neither requires weakening a pinned type.

## Persistent file
- `analogies/gf-generic-rank-ses.md` — full design rationale, verified citations, and the two pinned
  signatures + the base-`A` generalization helper.

Overall verdict: generic rank aligns with Mathlib (`Module.finrank` over `FractionRing P_d`); the SES and
reindex are NEEDS_MATHLIB_GAP_FILL with every atom verified to exist, and the load-bearing fix is
structural — generalize the base domain `A` in the strong induction because the reindex changes the base
ring to `A_g`.
