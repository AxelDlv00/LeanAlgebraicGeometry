## 1. `ChartFibrePresented` — verbatim

`AlgebraicJacobian/Picard/Pic0ChartOpenImmersionCriterion.lean:129-141`

```lean
structure ChartFibrePresented {X T : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1)
    where
  W : T.Opens
  r : (W : Scheme.{u}) ⟶ X
  sq : yoneda.map r ≫ f = yoneda.map W.ι ≫ g
  exists_factor : ∀ (S : Scheme.{u}) (v : S ⟶ X) (w : S ⟶ T),
    f.app (op S) v = g.app (op S) w → ∃ u : S ⟶ (W : Scheme.{u}), u ≫ r = v ∧ u ≫ W.ι = w
```

`exists_factor` says: for **every** test scheme `S` and every pair `(v : S ⟶ X, w : S ⟶ T)` whose classes agree in `pic0SigmaSheaf C` at `S`, there is `u : S ⟶ W` with `u ≫ r = v` and `u ≫ W.ι = w`. Two contents are fused: (a) `w` factors through `W` (coverage/locus), and (b) `u ≫ r = v`, i.e. the divisor family `v` is *recovered* from its class — the relative uniqueness statement. Note there is no constraint that `W` be nonempty, nor any relation to `chartLocus`.

## 2. The criterion

`Pic0ChartOpenImmersionCriterion.lean:195-199` — no side hypotheses beyond the ambient `variable` block (`[Field k]`, `[SmoothOfRelativeDimension 1 C.hom]`, `[IsProper C.hom]`, `[GeometricallyIrreducible C.hom]`):

```lean
theorem isOpenImmersion_presheaf_of_chartFibrePresented {X : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (D : ∀ (T : Scheme.{u}) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1),
      ChartFibrePresented C f g) :
    IsOpenImmersion.presheaf f
```

## 3. The ∀-over-all-`g` question — the antecedent is refuted, not merely strong

`IsChartLocusFibre` (`Pic0ChartUnivReduce.lean:152-157`) verbatim:

```lean
def IsChartLocusFibre {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ)) : Prop :=
  ∀ (T : Scheme.{u}) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1),
    Nonempty (ChartFibrePresented C (abelSigmaChart C π n rep m Z hdeg) g)
```

Three hard facts:

- **`chartLocus` does not appear in it.** The definition names no locus; `W` is existentially quantified inside `ChartFibrePresented`. `chartLocusOpens` is defined in the same file (`:115`) but is never used by `IsChartLocusFibre` or by the reduction. The docstring's claim (`:138`) that "this is `ChartFibrePresented` with its `W` field already discharged — it is `chartLocus`" is not what the Lean says.

- **The reduction proves the *unrestricted* statement.** I put the cursor inside the proof term at `Pic0ChartUnivReduce.lean:178`; the expected type of the inner argument is, verbatim from the LSP:
  `⊢ IsOpenImmersion.presheaf (abelSigmaChart C π n rep m Z hdeg)`
  So `isChartUniv_of_isChartLocusFibre` derives `IsOpenImmersion.presheaf` for the **whole divisor scheme** and only then applies `isOpenImmersion_presheaf_restrictChart V`. The restriction to `V` is dead weight; `V` is arbitrary because the antecedent already gives the strictly stronger claim.

- **That unrestricted claim is exactly what the project asserts is false.** `Pic0AtlasFromDivRep.lean:54-58`: "`IsOpenImmersion.presheaf (abelSigmaChart …)` is **false as stated for the whole divisor scheme** — the Abel map … has projective spaces `|D|` as its fibres, so it is not a monomorphism". Composing `mono_of_isOpenImmersion_presheaf` (`:90-93`) gives `Mono (abelSigmaChart …)` from `IsChartLocusFibre`.

The named non-vacuity lemma, `Pic0ChartOpenImmersionCriterion.lean:219-225`:

```lean
theorem isEmpty_forall_chartFibrePresented_of_not_injective {X : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) (T : Scheme.{u}ᵒᵖ)
    (hT : ¬ Function.Injective (f.app T)) :
    IsEmpty (∀ (T' : Scheme.{u}) (g : yoneda.obj T' ⟶ (pic0SigmaSheaf C).1),
        ChartFibrePresented C f g)
```

Since `∀ T g, Nonempty (CFP …)` gives `Nonempty (∀ T g, CFP …)` by choice — which is precisely the `.some` step the reduction performs — this lemma **refutes `IsChartLocusFibre`** from non-injectivity at a *single* test. So the answer to your question: the ∀ over arbitrary `g` is not vacuous and not unsatisfiable-for-formal-reasons, but it is unsatisfiable under the project's own stated mathematics. `IsChartUniv` was reduced to a proposition the project elsewhere asserts is false.

Two sub-answers you asked for specifically:
- **Trivially inhabited for some `g`:** yes, for any `g` whose class is nowhere a chart value, take `W = ⊥`; `Hom(∅, X)` is a singleton so `sq` is automatic and `exists_factor` holds because no nonempty `S` admits a matching pair. So individual instances are cheap; the ∀ is not.
- **Provably empty for some `g`:** yes, via the lemma above, at any `T` where `(abelSigmaChart …).app T` is non-injective. Caveat: **no Lean proof of `¬ Function.Injective ((abelSigmaChart …).app T)` exists in the project** (grep for `¬ Function.Injective` / `not_injective` returns only the two sites above). The falsity is asserted in prose at `Pic0AtlasFromDivRep.lean:54`, not machine-checked.

## 4. Producers — there are none

Exhaustive grep for `ChartFibrePresented` and `IsChartLocusFibre` over all `.lean` files. Every occurrence is a docstring mention, the definition, or a *consumer*:

- `ChartFibrePresented`: def (`:129`), `isPullback` (`:156`, consumer), the criterion (`:195`, consumer), `isEmpty_forall_…` (`:219`, refuter), `injective_of_chartFibrePresented` (`:231`, consumer), and `IsChartLocusFibre`'s own body (`Pic0ChartUnivReduce.lean:157`).
- `IsChartLocusFibre`: def (`:152`) and `isChartUniv_of_isChartLocusFibre` (`:175`, consumer). Nothing else.

**Zero producers, not even conditional ones.** No lemma anywhere constructs a `ChartFibrePresented` or discharges `IsChartLocusFibre` under any hypothesis. The nearest neighbours (`Pic0ChartLocusPlusFibre.lean`, `Pic0ChartPlusFibreProducer.lean`) produce only the `W`-shape ingredient `chartLocusOpens'`/`chartLocusOpensOfPlusFibre` — a `T.left.Opens` — and `Pic0ChartLocusPlusFibre.lean:69` states outright that clause (ii) "remains CERT-Σ/divRep-gated through `IsChartLocusFibre`'s `exists_factor`; nothing in this file touches it."

## 5. `divRepClassifyZar` — does not produce `r`

`AlgebraicJacobian/Picard/DivRepClassifyZar.lean:244-249`:

```lean
noncomputable def divRepClassifyZar (F₀ : DivFamZar C S π g) :
    overSpec k S ⟶
      divSchemeOver k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁
        (b₂.map (windowShiftEquiv hπ g).symm) :=
  (exists_overHom_isDivRepClassify hπ g hO hχ r₁ r₂ b₁ b₂ F₀).choose
```

Hypotheses (section variables, `DivRepClassifyZar.lean:58-80`): `{k} [Field k] {C}`, `{π : C.left ⟶ P1 k} [IsFinite π]`, `[SmoothOfRelativeDimension 1 (C.left ↘ Spec …)]`, `[IsIntegral C.left]`, `[LocallyOfFiniteType …]`, `[QuasiCompact …]`, `[IsDominant π]`, `[SmoothOfRelativeDimension 1 C.hom]`, `[IsProper C.hom]`, `[GeometricallyIrreducible C.hom]`, `[Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]`, same at `1`, plus explicit `hπ : π ≫ P1.structureMap k = C.left ↘ Spec …`, `g : ℕ`, `hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1`, `hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ)`, `r₁ r₂ : ℕ`, and bases `b₁`, `b₂` of the window section spaces. Characterised by `divRepClassifyZar_isDivRepClassify` (`:256`), unique by `divRepClassifyZar_eq_of_isDivRepClassify` (`:265`).

**It cannot supply `r`.** Three concrete mismatches:
1. **Wrong domain.** It takes `S : Type u` with `[CommRing S] [Algebra k S]` — an *affine* test. The `r` field needs `(W : Scheme) ⟶ X` for `W` an arbitrary open of an arbitrary test scheme. The general-test version exists (`DivRepGlobalClassify.classifyGlobal`, `:204`, giving `T ⟶ DivOver`) but requires a `DivRepAffinePullback` package as input.
2. **Wrong codomain.** Target is `divSchemeOver k …` (locally notated `DivOver`), not `D.left` where `D` is the representing object of the abstract `rep : (divFunctor C π n).RepresentableBy D` that `IsChartLocusFibre` binds. Bridging needs the representability comparison, not the classifier.
3. **Instance mismatch with the consumer.** `Pic0ChartUnivReduce.lean:81` has `[IsAffineHom π]`; `divRepClassifyZar` needs `[IsFinite π]` plus `[IsDominant π]`, `hπ`, `hO`, `hχ` and the two window bases — none of which are in scope at the reduction site.

Separately: given `rep`, the `r` field is obtainable from `rep.homEquiv.symm` applied to a divisor family over `W`; the classifier is not the bottleneck. The bottleneck is producing that family with the prescribed class, plus `exists_factor`.

## 6. `eq_of_picClass_eq_of_h0_one` vs `exists_factor`

`AlgebraicJacobian/RiemannRoch/EffectiveUniqueness.lean:144-150`:

```lean
theorem CurveDivisor.eq_of_picClass_eq_of_h0_one {D D' : X.CurveDivisor}
    (hD : 0 ≤ D) (hD' : 0 ≤ D')
    (hcl : CurveDivisor.picClass K D = CurveDivisor.picClass K D')
    (hone : Sheaf.h0 (X.divisorSheaf K D) = 1) :
    D' = D
```

Context (`:48-49`, `:77-78`): `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec …)] [IsIntegral X] [LocallyOfFiniteType …] [QuasiCompact …]`. Sorry-free (grep confirms no `sorry`/`admit` in the file).

Honest distance to `exists_factor` — it is large, and in a direction the docstrings understate:

- **Absolute vs relative.** The lemma lives over a single base *field* `K` with `X` integral. `exists_factor` quantifies over an arbitrary test scheme `S`; the statement needed is uniqueness of divisor *families* over `S`, with no integrality or field hypothesis on `S`. `Pic0ChartUnivReduce.lean:147` itself calls this "`eq_of_picClass_eq_of_h0_one` in families". The families version does not exist in the project.
- **Wrong object level.** The lemma concludes an equality of `X.CurveDivisor` (a Weil-divisor object over a field). `exists_factor` needs an equality of *morphisms of schemes*, `u ≫ r = v` in `Hom(S, X)`. Transporting the former to the latter needs the representability comparison for `divFunctor` plus the twist bookkeeping — neither of which the lemma touches.
- **It addresses the uniqueness half only; the existence half is unaddressed.** `exists_factor` must first *produce* `u`, i.e. show `w` lands in `W`. That is coverage, and `eq_of_picClass_eq_of_h0_one` says nothing about it. (The structure's docstring at `:124-125` says "the uniqueness half is *not* a field here, because it is free: `W.ι` is a monomorphism" — that is true only of the uniqueness of `u` given both equations; the equation `u ≫ r = v` is itself the GAP-2 content, so the field is not purely existence-shaped.)
- **`hone` is not available where needed.** `Sheaf.h0 (X.divisorSheaf K D) = 1` is the `h⁰ = 1` condition that *defines* the chart locus informally, but `chartLocus` (`Pic0ChartLocus.lean:244`) is defined by `IsSplitWitness` on a twisted class, not by `h⁰ = 1`. No lemma connects the two, and since `IsChartLocusFibre` never mentions `chartLocus` at all (point 3), there is no hypothesis in the target from which `hone` could be extracted.

## Bottom line

The reduction chain `pic0RepresentableByOfCharts` ← `IsChartUniv` ← `IsChartLocusFibre` type-checks, but `IsChartLocusFibre` dropped the chart-locus restriction that was the entire reason the statement was expected to be true: its proof obligation is provably equivalent to `IsOpenImmersion.presheaf` of the **unrestricted** `abelSigmaChart`, which forces that map to be a monomorphism, which `Pic0AtlasFromDivRep.lean:54` states is false. The refuting lemma is already in the tree (`isEmpty_forall_chartFibrePresented_of_not_injective`) and applies directly to the antecedent. This is consistent with there being zero producers, conditional or otherwise. A usable residue would have to pin `W := chartLocusOpens …` and restrict the ∀ to `g` factoring through the locus; `chartLocusOpens` is defined in the same file for exactly that purpose and is left unused.
