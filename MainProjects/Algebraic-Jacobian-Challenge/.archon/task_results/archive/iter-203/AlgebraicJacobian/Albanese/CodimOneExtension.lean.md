# AlgebraicJacobian/Albanese/CodimOneExtension.lean

## Summary

- **Declarations added: 4, all axiom-clean** (`#print axioms` = `{propext, Classical.choice, Quot.sound}`):
  1. `quotSMulTop_quotientRing_linearEquiv` (def, ~line 1071)
  2. `isRegular_cons_of_quotient_ring` (~line 1083)
  3. `matsumura_descent_cotangent` (~line 1118)
  4. `matsumura_isRegular_of_linearIndependent_cotangent` (~line 1260) — **the HARD BAR target (Step A1)**
- **Declarations blocked: 0 attempted-but-failed.** The PUSH-BEYOND (Stage 6.A capstone / L1401 closure) is gated on a *separate* Mathlib gap (Step A2, see below), not attempted this iter by design.
- **Sorry count across file: 3 → 3** (unchanged). The 3 remaining sorries (build-reported lines 1401, 1683, 1751 = the historical L1262/L1459/L1534) are untouched and scope-fenced.
- **1 import added**: `import AlgebraicJacobian.Albanese.AuslanderBuchsbaum` (PROGRESS L113 claimed it was "already present" — it was NOT; the two `RingTheory.CohenMacaulay.*` promotions are unreachable without it). Module rebuilds GREEN in 7.5s.

## HARD BAR: MET

`matsumura_isRegular_of_linearIndependent_cotangent` is landed **axiom-clean** (verified via `lean_verify` → kernel triple). This is the iter-203 Lane COE HARD BAR. The 26-iter-stalled Step A1 substrate is now in hand.

Statement (final, slightly cleaner than the blueprint sketch — no `ringKrullDim` hypothesis needed; the dimension is read off `spanFinrank` internally):
```lean
private theorem matsumura_isRegular_of_linearIndependent_cotangent
    {A : Type u} [CommRing A] [IsLocalRing A] [IsNoetherianRing A] [IsRegularLocalRing A]
    (n : ℕ) (rs : Fin n → A) (hrs_mem : ∀ i, rs i ∈ IsLocalRing.maximalIdeal A)
    (h_lin : LinearIndependent (IsLocalRing.ResidueField A)
               (fun i => (IsLocalRing.maximalIdeal A).toCotangent ⟨rs i, hrs_mem i⟩)) :
    RingTheory.Sequence.IsRegular A (List.ofFn rs)
```

## matsumura_isRegular_of_linearIndependent_cotangent (Step A1)
- **Approach:** Induction on the length `n`, peeling the head `rs 0` via the new
  `isRegular_cons_of_quotient_ring`. Per-step: `rs 0 ∉ 𝔪²` (from `LinearIndependent.ne_zero` +
  `Ideal.toCotangent_eq_zero`); `spanFinrank 𝔪 = k+1` for some `k` (since `𝔪 ≠ ⊥`); apply
  `RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq` to make
  `A ⧸ span{rs 0}` regular local; descend the cotangent independence via
  `matsumura_descent_cotangent`; apply IH; head is a NZD via
  `RingTheory.CohenMacaulay.isDomain_of_regularLocal` + `IsSMulRegular.of_ne_zero`.
- **Result:** RESOLVED — axiom-clean. **Note the two AB inputs are the iter-202 public promotions
  (namespace `RingTheory.CohenMacaulay`).**

## matsumura_descent_cotangent (the genuine descent — the part that was hard)
- **Approach:** The blueprint flagged the lin-indep descent as a "straightforward `LinearIndependent.map`"
  but it is the substantive piece (semilinear over the κ(A)→κ(A') residue switch). Route that worked:
  build the `A`-linear cotangent map `π = Ideal.mapCotangent` for `A → A ⧸ span{rs 0}`, prove
  `ker π = A ∙ (toCotangent (rs 0))` via `Ideal.mapCotangent_ker_of_surjective` +
  `span{rs 0} ⊓ 𝔪 = span{rs 0}` + `comap subtype (span{rs 0}) = A ∙ ⟨rs 0,_⟩`, then run the
  argument **directly through `Fintype.linearIndependent_iff`** (avoids constructing quotient
  κ-modules / explicit residue-field isos): a κ(A')-relation on the tail lifts to an `A`-relation
  `∑ aᵢ • π(vᵢ₊₁) = 0` (using `IsScalarTower A B (CotangentSpace B)` and `B κ' …` to relate
  `aᵢ • _` and `residue(...) • _`), hence `∑ aᵢ • vᵢ₊₁ ∈ ker π = A ∙ v₀`; reduce mod 𝔪 (via
  `IsScalarTower A κ(A) (CotangentSpace A)`) and apply the full κ(A)-independence (`Fin.cons`
  coefficients + `Fin.sum_univ_succ`) to force every `residue(aᵢ) = 0`, whence each κ(A')-coeff
  `= residue_{A'}(mk aᵢ) = 0` (because `aᵢ ∈ 𝔪 ⟹ mk aᵢ ∈ 𝔪'`).
- **Result:** RESOLVED — axiom-clean. Needs `set_option maxHeartbeats 1600000`.
- **Reusable substrate** for any future "lin-indep cotangent classes descend to the quotient" need.

## quotSMulTop_quotientRing_linearEquiv + isRegular_cons_of_quotient_ring (bridges)
- **Approach:** Mathlib's `RingTheory.Sequence.IsRegular.cons'` phrases the tail over the *module*
  quotient `QuotSMulTop r A = A ⧸ (r • ⊤)`, not the *ring* quotient `A ⧸ span{r}`. The bridge is the
  `(A⧸span{r})`-linear equivalence `QuotSMulTop r A ≃ₗ A⧸span{r}` built from
  `QuotSMulTop.equivQuotTensor` + `TensorProduct.rid` + `LinearEquiv.extendScalarsOfSurjective`
  (along the surjective `mk`); transport `IsRegular` across it with `LinearEquiv.isRegular_congr`.
- **Result:** RESOLVED — axiom-clean. These make any ring-quotient regular-sequence induction ergonomic.

## Blueprint markers
Ready for `\leanok` (sync_leanok will confirm): there is no existing `\lean{...}` pin for Step A1 in
`Albanese_CodimOneExtension.tex` — the recipe lives in prose at
`\subsec:stage6_iib_substrate_iter200`. **Plan agent: add `\lean{...}`-pinned lemma blocks** for
`AlgebraicGeometry.Scheme.matsumura_isRegular_of_linearIndependent_cotangent` and
`...matsumura_descent_cotangent` so sync_leanok can mark them, and update the prose (the "A1 — Matsumura
helper" bullet) from "iter-203 prover recipe" to "landed axiom-clean iter-203".

## Why I stopped — `Real progress`
**4 axiom-clean declarations added** (HARD BAR met); names + lines above. The escalation
pre-commitment (PROGRESS L202-218) technically fires (no *sorry* closed), but that is structural,
not a route failure: **closing L1401 (`isRegularLocalRing_stalk_of_smooth`) is impossible this iter**
regardless of Step A1, because the chain L1401 ← Stage 6.A (00OE) ← `ringKrullDim_quotient_localization_MvPolynomial_of_regular` (L924, already landed) ← an `IsRegular` witness for the
SubmersivePresentation relations still needs **Step A2**, an explicit Mathlib gap:

> the conormal-localisation iso `LocalizedModule p.primeCompl P.toExtension.Cotangent ≃ (I·A)/(I·A)²`
> for `IsLocalization.AtPrime` (Mathlib's `Algebra.Generators.cotangentCompLocalizationAwayEquiv`
> only covers `Localization.Away`). Blueprint `\subsec:stage6_iib_substrate_iter200`, "A2 — Cotangent-
> localisation transport", est. ~50-100 LOC.

Step A1 is precisely the foundational input that A2/A3 feed into the consumer; it is the part that was
buildable now. Step A2 is a distinct, large Mathlib-gap construction and is the correct **next prover
lane** for Lane COE.

The other two sorries (L1683/L1751) are SCOPE-FENCED (PROGRESS L128).

Informal agent: **unavailable** — `MOONSHOT_API_KEY` is set but returns HTTP 401 (invalid auth);
proceeded without it.

## Next step (for plan agent)
1. **Lane COE next**: build **Step A2** — the AtPrime conormal-localisation iso (the sole remaining gap
   between the now-landed Step A1 and `ringKrullDim_quotient_localization_MvPolynomial_of_regular`).
   Then A3 assembly (`Algebra.SubmersivePresentation.relations_isRegular_in_localization`, ~10-15 LOC,
   consuming Step A1 + A2) + the scheme-to-algebra bridging (B.a–B.c already landed iter-202) closes the
   Stage 6.A capstone and thence L1401.
2. Add the `\lean{...}` pins noted under "Blueprint markers".
3. The MOONSHOT API key is invalid (401) — flag to USER if the informal agent is meant to be available.
