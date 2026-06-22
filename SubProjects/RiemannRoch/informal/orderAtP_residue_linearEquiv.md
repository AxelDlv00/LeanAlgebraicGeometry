# `sheafOf.orderAtP_residue_linearEquiv` (OcOfD.lean, ~L1598)

## Statement (Lean)

```
(↥(orderAtPSubmodule (Finsupp.single P 1 + D) P) ⧸
    (ModuleCat.Hom.hom (ModuleCat.ofHom (Submodule.inclusion
      (orderAtPSubmodule_le_single_add D P)))).range)
  ≃ₗ[kbar] kbar
```

i.e. the DVR residue equivalence
`π_P^{-(n+1)}𝒪_{C,P} / π_P^{-n}𝒪_{C,P} ≅ 𝒪_{C,P}/𝔪_P = k̄` with `n = D P`.

## Context — this is the SOLE remaining leaf of G2

As of iter-019 the cokernel-stalk iso `sheafOf.cokernel_stalk_at_iso_kbar` is
otherwise `sorry`-free. The whole categorical reduction is closed:

- germ-action lemmas `carrierSheaf_stalk_iso_iSup_germ_coe`,
  `carrierSheaf_stalk_eq_hom_germ_coe` (+ helper `coe_eqToHom_of_submodule_eq`);
- the naturality square `cokernel_stalk_at_naturality` (stalk map = submodule
  inclusion `orderAtP D P ⊆ orderAtP ([P]+D) P`, identity on `K(C)`);
- `cokernel.mapIso` transport + `ModuleCat.cokernelIsoRangeQuotient` assembly in
  `orderAtP_quotient_iso_kbar`.

Closing `orderAtP_residue_linearEquiv` makes `cokernel_stalk_at_iso_kbar` and
hence `cokernel_carrierSheafHom_iso_skyscraper` fully axiom-clean.

## The concrete map

`R := C.left.presheaf.stalk P.point` is a DVR (`isDiscreteValuationRing_stalk_of_smooth`)
with fraction field `K = K(C)`, valuation `Ring.ordFrac R : K →*₀ ℤᵐ⁰`,
`Scheme.RationalMap.order P g = (Ring.ordFrac R g).log`.

Pick a uniformiser `π ∈ K` with `ord_P π = 1`
(`IsDiscreteValuationRing.exists_irreducible` on `R`, then its image in `K`).
The map sends the class of `g ∈ orderAtP ([P]+D) P` (so `ord_P g ≥ -(n+1)`) to

  `ρ(g) = (π^{n+1} · g) mod 𝔪_P  ∈  R/𝔪_P ≅ k̄`.

- `π^{n+1} g` has `ord ≥ 0`, hence lies in `R ⊆ K`.
- `ρ(g) = 0 ⟺ ord(π^{n+1} g) ≥ 1 ⟺ ord g ≥ -n ⟺ g ∈ orderAtP D P`, so
  `ker ρ` is exactly the range of the inclusion ⇒ `ρ` descends to the quotient.
- `ρ` is surjective: for `a ∈ k̄` lift to `r ∈ R` (`residueField` surjective),
  then `g = π^{-(n+1)} · r ∈ orderAtP ([P]+D) P` has `ρ(g) = a`.
- `k̄`-linearity: constants `c ∈ k̄ ↪ R` commute with `π^{n+1}·` and project to
  `c` in `R/𝔪_P = k̄` (identity on `k̄` via `residueField_eq_of_coheight_eq_one`).

## Missing Mathlib ingredient (the blocker)

The forward map cannot even be *defined* without the valuation-ring membership
characterisation

  **`ord_P x ≥ 0  ↔  x ∈ (algebraMap R K).range`**  (i.e. the integers of `K`).

This is the same gap flagged for the bridge `carrierSheaf_zero_iso_toModuleKSheaf`
(OcOfD ~L1884): `IsDedekindDomain.HeightOneSpectrum.mem_integers_of_valuation_le_one`
specialised to the single DVR stalk, or a direct
`Ring.ordFrac`-based `mem_integers_of_ordFrac_le` for the local stalk. No informal
agent was available this session (no `DEEPSEEK/MOONSHOT/OPENROUTER/OPENAI/GEMINI`
key in env).

## Recommended dispatch

`mathlib-build` lane: provide
`x ∈ (algebraMap R (FractionRing R)).range ↔ 1 ≤ Ring.ordFrac R x` (or `0 ≤
order`) for a DVR `R`, plus the uniformiser `ord = 1` fact, then `prove` lane for
`orderAtP_residue_linearEquiv`. This single ingredient unblocks BOTH this leaf and
the bridge section-lemma inverse.
