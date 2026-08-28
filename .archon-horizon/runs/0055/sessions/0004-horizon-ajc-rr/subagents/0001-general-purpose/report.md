All names verified by compilation. Report:

## (A) DVR / height-one-spectrum valuation

**(A1)** `IsDedekindDomain.HeightOneSpectrum.valuation_le_one` — compiled.
```
(v : IsDedekindDomain.HeightOneSpectrum R) (r : R) :
    (IsDedekindDomain.HeightOneSpectrum.valuation K v) ↑r ≤ 1
-- [CommRing R] [IsDedekindDomain R] [Field K] [Algebra R K] [IsFractionRing R K]
```
The `↑r` is `algebraMap R K r` (I checked it unifies with an explicit `algebraMap A K a` term). Related, also compiled: `IsDedekindDomain.HeightOneSpectrum.valuation_of_algebraMap : valuation K v ↑r = v.intValuation r`, `IsDedekindDomain.HeightOneSpectrum.intValuation_le_one (v) (x : R) : v.intValuation x ≤ 1`, `IsDedekindDomain.HeightOneSpectrum.mem_integers_of_valuation_le_one`.

**(A2)** `IsDedekindDomain.HeightOneSpectrum.valuation_lt_one_iff_mem` — compiled.
```
(v : IsDedekindDomain.HeightOneSpectrum R) (r : R) :
    (IsDedekindDomain.HeightOneSpectrum.valuation K v) ↑r < 1 ↔ r ∈ v.asIdeal
```
Also compiled: `IsDedekindDomain.HeightOneSpectrum.intValuation_lt_one_iff_dvd (v) (r) : v.intValuation r < 1 ↔ v.asIdeal ∣ Ideal.span {r}`.
Key defeq I verified: for a DVR `A`, `(IsDiscreteValuationRing.maximalIdeal A).asIdeal = IsLocalRing.maximalIdeal A` holds **by `rfl`**. Combined with `IsLocalRing.mem_maximalIdeal (x) : x ∈ maximalIdeal R ↔ x ∈ nonunits R`, this gives (both compiled):
- `v (algebraMap A K a) < 1 ↔ ¬ IsUnit a` := `(valuation_lt_one_iff_mem _ a).trans (IsLocalRing.mem_maximalIdeal a)`
- `v (algebraMap A K a) = 1 ↔ IsUnit a` (no single Mathlib lemma found; 5-line proof from `valuation_le_one` + the above, compiled).

**(A3)** `IsDiscreteValuationRing.exists_lift_of_le_one` — compiled.
```
{A K} [CommRing A] [IsDomain A] [IsDiscreteValuationRing A] [Field K] [Algebra A K]
  [IsFractionRing A K] {x : K} :
    (IsDedekindDomain.HeightOneSpectrum.valuation K (IsDiscreteValuationRing.maximalIdeal A)) x ≤ 1
      → ∃ a, (algebraMap A K) a = x
```
`IsDiscreteValuationRing.maximalIdeal (A) : IsDedekindDomain.HeightOneSpectrum A` (a bundled height-one prime, not an `Ideal`).

## (B) Residue field API (all compiled)
- `IsLocalRing.ResidueField (R) [CommRing R] [IsLocalRing R] : Type _`; `IsLocalRing.ResidueField R = (R ⧸ IsLocalRing.maximalIdeal R)` by `rfl`; `Field` instance is `IsLocalRing.ResidueField.field` (noncomputable).
- `IsLocalRing.residue (R) : R →+* IsLocalRing.ResidueField R`, and `IsLocalRing.residue R = Ideal.Quotient.mk (IsLocalRing.maximalIdeal R)` by `rfl`.
- `IsLocalRing.residue_surjective : Function.Surjective ⇑(IsLocalRing.residue R)`
- `IsLocalRing.ker_residue : RingHom.ker (IsLocalRing.residue R) = IsLocalRing.maximalIdeal R`
- `IsLocalRing.residue_eq_zero_iff (x) : residue R x = 0 ↔ x ∈ IsLocalRing.maximalIdeal R`
- Algebra transfer: instance `IsLocalRing.ResidueField.algebra (R) [CommRing R] [IsLocalRing R] {R₀} [CommRing R₀] [Algebra R₀ R] : Algebra R₀ (IsLocalRing.ResidueField R)`. Found by `infer_instance` from `[Algebra k R]`, and `algebraMap k (ResidueField R) a = residue R (algebraMap k R a)` holds by `rfl`.

## (C) Payoff lemma — compiled
`IsAlgClosed.algebraMap_surjective_of_isIntegral` does **not** exist. The working chain is `Algebra.IsIntegral.of_finite` + `IsAlgClosed.algebraMap_bijective_of_isIntegral` + `Module.finrank_of_bijective_algebraMap`:
```lean
example (k κ : Type) [Field k] [Field κ] [IsAlgClosed k] [Algebra k κ] [Module.Finite k κ] :
    Module.finrank k κ = 1 :=
  haveI : Algebra.IsIntegral k κ := Algebra.IsIntegral.of_finite k κ
  Module.finrank_of_bijective_algebraMap IsAlgClosed.algebraMap_bijective_of_isIntegral
```
Signatures (compiled): `IsAlgClosed.algebraMap_bijective_of_isIntegral : ∀ {k K} [Field k] [Ring K] [IsDomain K] [IsAlgClosed k] [Algebra k K] [Algebra.IsIntegral k K], Function.Bijective ⇑(algebraMap k K)` — note it only needs `Ring K` + `IsDomain K`, so the same 3-line proof works verbatim with `κ` replaced by any finite `k`-algebra domain (compiled that variant too). `Module.finrank_of_bijective_algebraMap : Function.Bijective ⇑(algebraMap R S) → Module.finrank R S = 1` ([CommSemiring R] [Semiring S] [Algebra R S] [StrongRankCondition R]). `Algebra.IsIntegral.of_finite (R B) [Module.Finite R B] : Algebra.IsIntegral R B`.
An alternative that also compiled but needs separability: `IsSepClosed.algebraMap_surjective k κ` / `IsSepClosed.algebraMap_bijective k κ` (`IsAlgClosed k → IsSepClosed k` and `Algebra.IsSeparable k κ` were both found by `infer_instance` here, but prefer the isIntegral route — no char-0/perfect side conditions).

## (D) finrank = 1 ↔ surjective
`Algebra.finrank_eq_one_iff` and `Module.finrank_eq_one_iff_of_surjective` do **not** exist. What exists (compiled):
- `Algebra.finrank_eq_one_iff_bijective_algebraMap : Module.finrank F E = 1 ↔ Function.Bijective ⇑(algebraMap F E)` — `[CommRing F] [StrongRankCondition F] [Ring E] [Algebra F E] [Module.Free F E]`.
- `Subalgebra.bot_eq_top_iff_finrank_eq_one : ⊥ = ⊤ ↔ Module.finrank F E = 1` — `[Nontrivial E] [Module.Free F E]`; also `Subalgebra.eq_bot_of_finrank_one`, `Subalgebra.finrank_bot`.
- The surjective-only iff is not in Mathlib but is a 2-line consequence over a field (injectivity is free); compiled:
```lean
example (k E : Type) [Field k] [Ring E] [Nontrivial E] [Algebra k E] :
    Module.finrank k E = 1 ↔ Function.Surjective (algebraMap k E) := by
  rw [Algebra.finrank_eq_one_iff_bijective_algebraMap]
  exact ⟨fun h => h.2, fun h => ⟨(algebraMap k E).injective, h⟩⟩
```

Not found (checked, unknown constants): `IsAlgClosed.algebraMap_surjective`, `IsAlgClosed.algebraMap_surjective_of_isIntegral`, `IsAlgClosed.algebraMap_surjective_of_isAlgebraic`, `IsAlgClosed.algebraMap_bijective_of_isAlgebraic`, `Module.finrank_eq_one_iff_of_surjective`, `Algebra.finrank_eq_one_iff`, `IsDedekindDomain.HeightOneSpectrum.valuation_eq_one_iff_isUnit`, `Valuation.one_le_iff_of_isUnit`.

No files were modified.
