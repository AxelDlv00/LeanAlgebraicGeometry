## QUESTION 1 — Yes. AJCR already has the theorem, with the identical bound.

**`AlgebraicGeometry.subsingleton_hModule_one_of_witness`**
`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/WindowFieldTransport.lean:87-107`

```lean
theorem subsingleton_hModule_one_of_witness (W₀ D : Y.CurveDivisor)
    (hW₀ : Subsingleton (Sheaf.HModule (Y.divisorSheaf K W₀) 1))
    (hdeg : CurveDivisor.deg K W₀ + 1 - Sheaf.chi (Y.moduleKSheaf K)
      ≤ CurveDivisor.deg K D) :
    Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1)
```

Context (lines 72-80): `{Y} [IsIntegral Y] [Y.Over (Spec K)] [SmoothOfRelativeDimension 1] [QuasiCompact]` plus `[Module.Finite K (HModule (moduleKSheaf K) 0)]`, `[Module.Finite K (… 1)]`; `LocallyOfFiniteType` is explicitly `omit`ed, so AJCR's hypothesis set is *weaker* than the AJC statement's (AJC's `DegreeVanishing.lean` carries `LocallyOfFiniteType` in its section variables). Its docstring even calls it "**the π-free peeling** (the abstract-witness form of DAT-0a)".

This is the AJC target statement `subsingleton_hModule_one_of_deg_ge` with `D₀` renamed `W₀` — same base-vanishing hypothesis, same bound `deg D₀ + 1 − χ(𝒪) ≤ deg D`, same conclusion. Not a cousin, not a weaker form: the same theorem. AJCR proves it by the Picard route (residual class `[D]·[W₀]⁻¹` → `exists_effective_of_picClass` → `peel_effective` → `subsingleton_hModule_one_of_picClass_eq`), never through order-domination; AJC's proof goes through a translate `D₀ − div g` and an order-cone peel. Different proofs, one statement.

**The stronger unconditional version also exists**, for curves with a finite dominant map to ℙ¹:

- `exists_bound_subsingleton_hModule_one_of_isFinite_toP1` — `AlgebraicJacobian/RiemannRoch/UniformVanishing.lean:71-112`: `∃ b : ℤ, ∀ D, b ≤ deg K D → Subsingleton (HModule (Y.divisorSheaf K D) 1)`, with `b = n₁·deg F + 1 − χ(𝒪_Y)`, hypotheses `(π : Y ⟶ P1 K) [IsFinite π] [IsDominant π] (hπ : π ≫ P1.structureMap K = Y ↘ Spec K)` plus the two `Module.Finite`. No base-vanishing hypothesis — it manufactures `D₀ = n₁•F` itself from FLV-fiber.
- `windowBound` / `windowBound_spec` — `AlgebraicJacobian/RiemannRoch/WindowLedger.lean:109` and `:114-117`: the `Classical.choose` of that bound and its defining property `windowBound π hπ ≤ deg K D → Subsingleton H¹(𝒪(D))`, used ~20 times across `Picard/`.
- Class-indexed predecessor: `exists_subsingleton_hModule_one_of_one_le_classDeg_of_isFinite_toP1` — `AlgebraicJacobian/RiemannRoch/FLVClass.lean:360-405`.
- Base-vanishing source: `subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1` — `AlgebraicJacobian/RiemannRoch/FLVVanishing.lean:302-311`.

Verdict on Q1: AJCR contains the content of `subsingleton_hModule_one_of_deg_ge` verbatim at `WindowFieldTransport.lean:87`, and contains a strictly stronger unconditional version at `UniformVanishing.lean:71`. The AJC `DegreeVanishing.lean` docstring's framing ("the only thing between AJC and unconditional bounded vanishing … is a port of `FLVVanishing`") names the wrong port target: the theorem it says it is proving is already an AJCR theorem, and the AJCR conditional form has a *smaller* import surface than the FLVVanishing route it cites (it needs `exists_effective_of_picClass` + `peel_effective` + `subsingleton_hModule_one_of_picClass_eq`, all in `FLVClass`/`ClassCohomology`, not the `FLVLattice`/`FLVQcoh` fiber machinery).

## QUESTION 2 — Statement is via picClass; a closer non-Picard sub-lemma does exist, so the AJC file understates the borrowing.

`AlgebraicGeometry.exists_effective_of_h0_pos` — `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/SectionBound.lean:175-206`. Statement is `∃ E, 0 ≤ E ∧ CurveDivisor.picClass K E = CurveDivisor.picClass K A` — yes, Picard-flavored, though note the witness it actually supplies is `A + divOf … u`, and `picClass_divOf` (`Picard/DivisorClassMeromorphic.lean:160`) is only used in the last line.

Proof body (SectionBound.lean:178-206):

```lean
  haveI : Nontrivial (Sheaf.HModule (X.divisorSheaf K A) 0) :=
    Module.nontrivial_of_finrank_pos hA
  obtain ⟨t, ht⟩ := exists_ne (0 : Sheaf.HModule (X.divisorSheaf K A) 0)
  set s := (Sheaf.HModule.linearEquiv₀ (Opens.grothendieckTopology (X : TopCat))
    (isTerminalTop : IsTerminal (⊤ : X.Opens)) (X.divisorSheaf K A)) t with hs
  have hsne : s ≠ 0 := by rw [hs]; exact (LinearEquiv.map_ne_zero_iff _).mpr ht
  set g : X.functionField := divisorVal K s with hg
  have hgmem : g ∈ divisorSections K A ⊤ := divisorVal_mem K s
  have hgne : g ≠ 0 := by
    intro h
    exact hsne (divisorSection_ext K
      (show divisorVal K s = divisorVal K (0 : _) from by rw [← hg, h]; rfl))
  set u : X.functionFieldˣ := Units.mk0 g hgne with hu
  have huval : (u : X.functionField) = g := rfl
  refine ⟨A + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) u, ?_, ?_⟩
  · refine Finsupp.le_def.mpr (fun p => ?_)
    change (0 : ℤ) ≤ coeffAt p.2 (A + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) u)
    have htop : ((⊤ : X.Opens) : Set X).Nonempty := ⟨genericPoint X, trivial⟩
    have hb := (mem_divisorSections_of_nonempty K htop).mp hgmem p.1 p.2 trivial
    rw [← huval, Scheme.ord_val_eq K u p.2, divisorBound_le_iff p.2,
      CurveDivisor.coeffAt_neg] at hb
    rw [CurveDivisor.coeffAt_add]
    omega
  · rw [CurveDivisor.picClass_add, CurveDivisor.picClass_divOf, mul_one]
```

Step-by-step comparison with AJC's `exists_unit_nonneg_of_h0_pos` (`.../Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/DegreeVanishing.lean:124-166`): lines 128-142 of the AJC proof are token-identical to AJCR's 178-195 (`Module.nontrivial_of_finrank_pos`, `exists_ne`, the same `linearEquiv₀`+`isTerminalTop` invocation, `divisorVal`, `divisorVal_mem`, the same `divisorSection_ext` trick, `Units.mk0`). The effectivity bullet differs only in bookkeeping: AJCR calls the private `divisorBound_le_iff` + `CurveDivisor.coeffAt_neg` and closes with `omega`; AJC inlines the same rewrite as `Scheme.ord_val_eq` → `simp only [divisorBound, WithZero.coe_le_coe, Multiplicative.ofAdd_le]` → `omega` because it does not import the FLV-lane private lemma. So the AJC docstring's claim — "the three steps are AJCR's" — is accurate and, if anything, understated: it is AJCR's proof text, not merely AJCR's three steps.

Where the AJC file *does* understate: it says AJCR states the fact only "through `CurveDivisor.picClass` — Picard vocabulary that AJC's Ledger tree does not import". But AJCR has the Picard-free statement, in a file with no Picard cohomology in its way:

- `AlgebraicGeometry.mem_divisorSections_top_iff` — `AlgebraicJacobian/RiemannRoch/SectionSpaces.lean:230-256`:
  ```lean
  theorem mem_divisorSections_top_iff {A : X.CurveDivisor} {f : X.functionField} (hf : f ≠ 0) :
      f ∈ divisorSections K A ⊤ ↔
        0 ≤ A + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) (Units.mk0 f hf)
  ```
  This is exactly AJC's conclusion `0 ≤ A + div g`, as an iff, with *no* `picClass` and no finiteness hypotheses (only `[X.Over] [Smooth 1] [IsIntegral] [LocallyOfFiniteType] [QuasiCompact]`). Its forward direction is AJC's step 3 verbatim (same `ord_val_eq` / `divisorBound_le_divisorBound_iff` / `coeffAt_neg` / `omega` chain, `SectionSpaces.lean:237-246`).
- `AlgebraicGeometry.finrank_divisorSections_top` — `SectionSpaces.lean:386-388` — plus `Submodule.exists_mem_ne_zero_of_ne_bot` turns `0 < Sheaf.h0` into a nonzero `f ∈ divisorSections K A ⊤` without touching `H⁰` as an `HModule` at all. AJCR itself uses precisely this two-line idiom at `AlgebraicJacobian/RiemannRoch/CoverageDrop.lean:96-101`.

Composing those two gives `exists_unit_nonneg_of_h0_pos` in about four lines with zero Picard vocabulary. So the honest provenance note is: AJCR has the statement in the shape AJC wanted (`mem_divisorSections_top_iff`), plus the `h0`→nonzero-section bridge (`finrank_divisorSections_top`), and AJC re-derived from `SectionBound`'s Picard-wrapped version instead of citing them. The claim "the same fact stated without Picard vocabulary" is fair; the claim that AJCR only has it *with* Picard vocabulary is not.

## QUESTION 3 — Linear-equivalence invariance: yes, in class form. Cofinality: no.

Linear-equivalence invariance of H¹ vanishing:

- `AlgebraicGeometry.subsingleton_hModule_one_of_picClass_eq` — `AlgebraicJacobian/RiemannRoch/ClassCohomology.lean:111-115`: `picClass K D = picClass K D' → Subsingleton (HModule (divisorSheaf K D) 1) → Subsingleton (HModule (divisorSheaf K D') 1)`. No finiteness hypotheses; proved by `HModule.mapEquiv` on the private `picClassDivisorSheafIso` (built from `mulEquivDivisorSheaf`, `ClassCohomology.lean:75-82`).
- Combined with `CurveDivisor.picClass_eq_iff` (`AlgebraicJacobian/Picard/DivisorClassMeromorphic.lean:169-177`, `picClass D = picClass D' ↔ ∃ g, D - D' = divOf g`) and `picClass_divOf` (`:160`), this is logically the same content as AJC's `subsingleton_hModule_one_sub_divOf`. AJCR has no literal `A - Scheme.divOf … g` spelling of it — the only `divisorSheaf K (… - Scheme.divOf …)` occurrences in AJCR are `MulEquiv.lean:269` (the iso itself) and `ChiLedger.lean:130`. Companions: `h1_divisorSheaf_eq_of_picClass_eq` (`ClassCohomology.lean:98`), `h0_divisorSheaf_eq_of_picClass_eq` (`:89`).

Cofinality ("every divisor of large degree dominates a divisor where H¹ vanishes"): **absent from AJCR.** No statement of the form `∃ D₁, D₁ ≤ D ∧ Subsingleton (HModule (divisorSheaf K D₁) 1)` exists anywhere in AJCR — greps for `∃ … CurveDivisor, … ≤ D ∧`, for `_of_le` on `Subsingleton`/`hModule`, and for order-cone peel hypotheses return nothing. AJCR never needs it: it bypasses the divisor order entirely via the Picard class, so `subsingleton_hModule_one_of_witness` reaches the degree half-space in one step. AJCR also has no order-cone monotone peel (`subsingleton_hModule_one_of_le`) at all — its peel lemmas are the additive-effective forms `peel_effective` (`FLVClass.lean:292`), `peel_single` (`:260`), `peel_nsmul_single` (`:277`), and the `h¹`-numeric companions in `SectionBound.lean:67-163` (`h1_le_h1_sub_single`, `h1_add_single_le`, `h1_add_nsmul_single_le`, `h1_add_effective_le`, `h1_le_of_effective`). Those two AJC-only statements — the order-cone peel `subsingleton_hModule_one_of_le` (`Ledger/SectionDrop.lean:379`) and the cofinality bridge (`Ledger/SectionDrop.lean:502`, `:516`) — are genuine AJC-side material; they are just not on the shortest path to the theorem they were built for.
