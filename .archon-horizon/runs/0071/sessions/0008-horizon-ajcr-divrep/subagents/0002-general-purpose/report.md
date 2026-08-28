# AJC-Rebuild fibrewise-Abel-lift audit — compact report

All claims VERIFIED by reading source unless marked otherwise. Paths relative to `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`.

## Headline

The fibrewise construction is **already landed, both halves, in one file**: `AlgebraicJacobian/Picard/DivisorFamilyFieldSurj.lean`. It has **zero consumers anywhere in the tree** (VERIFIED by grep for `effectiveDivisorClassifyZar` / `exists_divFam_divFamDivisor_eq`).

## 1. Producers of `CertifiedDivisorFamily` and `DivFamZar` — VERIFIED, exhaustive

`CertifiedDivisorFamily` (grep on `: CertifiedDivisorFamily … where`) — exactly two:
- `ThetaGeneratorSeed.certifiedFamily`, `AlgebraicJacobian/Picard/DivSchemeEps.lean:237`. Hypotheses: a `ThetaGeneratorSeed C R pi a K`, `hD : D.IsGenerator`, `hc : (D.divisorAdaptation hD).IsCertified g`. Base arbitrary + `[IsNoetherianRing R]`.
- `CertifiedDivisorFamily.mapAlg`, `AlgebraicJacobian/Picard/DivisorFamilyMapAlg.lean:266`. Base change of an existing one.

`DivFamZar` (grep on `DivFamZar.mk`) — exactly three:
- `ThetaGeneratorSeed.divFamZar_of_forall_away_certified`, `AlgebraicJacobian/Picard/DivSchemeCertZarSeed.lean:132`. Needs span-⊤ `g : Fin m → R` plus a certified family over each `Localization.Away (g i)` that is `DivEq` to the pulled system.
- `ThetaGeneratorSeed.divFamZar_of_forall_prime_away_certified`, `AlgebraicJacobian/Picard/DivSchemeCertZarPointwise.lean:181`. Same, pointwise: `∀ p : PrimeSpectrum R, ∃ r ∉ p.asIdeal, …`.
- `DivFam.toZar`, `AlgebraicJacobian/Picard/DivisorFamilyZar.lean:272`, from a globally certified family.

**Field-specialised producer — YES.** Over a field the certificate is obtained from a bare degree equation, `AlgebraicJacobian/Picard/DivisorFamilyFieldSurj.lean:104`:

```lean
theorem isCertified_of_deg {n : ℕ}
    (hdeg : Scheme.CurveDivisor.deg K
      (Scheme.presentationDivisor K d.presentation) = (n : ℤ)) :
    A.IsCertified n
```
for **any** `A : DivisorAdaptation C K π d`, `[Field K] [Algebra k K]`. The full field chain then runs with no gaps, all landed:

- effective divisor → `LocalEquations`: `Scheme.LocalEquations.exists_localEquations_presentationDivisor_eq`, `AlgebraicJacobian/Picard/DivisorFamilyBackward.lean:120`
- `LocalEquations` → adaptation, unconditional over any base: `exists_divisorAdaptation`, `AlgebraicJacobian/Picard/DivisorFamilyExtraction.lean:54`
- → `DivFam`: `exists_divFam_divFamDivisor_eq`, `.../DivisorFamilyFieldSurj.lean:147`
- → the (b) morphism: `effectiveDivisorClassifyZar`, `.../DivisorFamilyFieldSurj.lean:217`, returning `overSpec k K ⟶ divSchemeOver k … g r₁ r₂ b₁ (b₂.map …)` via `divRepClassifyZar`. Spec at `:231`.

Reverse field collapse also landed: `DivFam.exists_toZar_eq`, `AlgebraicJacobian/Picard/DivSchemeAbel.lean:77` — over a field every `DivFamZar` class is globally certified.

## 2. Does the certificate simplify over a field? — YES, five of seven clauses become instances

`CertifiedDivisorFamily`, `AlgebraicJacobian/Picard/DivisorFamily.lean:452`: fields `eqns : (relCurve C R).LocalEquations`, `adaptation : DivisorAdaptation C R π eqns`, `certified : adaptation.IsCertified n`.

`IsCertified`, `AlgebraicJacobian/Picard/DivisorFamily.lean:426`, seven fields: `finite_colength`, `projective_colength` (c1); `finite_glued`, `projective_glued`, `rankAtStalk_glued : ∀ p, Module.rankAtStalk A.Glued p = n` (c2); `flat_coker_incl`, `flat_coker_diff` (c3/c4).

`IsLocallyCertified`, `AlgebraicJacobian/Picard/DivisorFamilyZar.lean:71`: `∃ m (g : Fin m → R), Ideal.span (Set.range g) = ⊤ ∧ ∀ i, ∃ G : CertifiedDivisorFamily C (Localization.Away (g i)) π n, DivEq G.eqns (d.pullback …)`.

Over `[Field K]`, from the proof at `.../DivisorFamilyFieldSurj.lean:107–133`: `projective_colength`, `projective_glued`, `flat_coker_incl`, `flat_coker_diff` all discharge by `Module.Free.of_divisionRing`; `finite_colength` is `moduleFinite_colength` (`:84`, empty pieces subsingleton, nonempty via `moduleFinite_quotient_span_section`); the `rankAtStalk` clause is the unconditional CRT identity `DivisorAdaptation.deg_presentationDivisor` read against `hdeg`. The docstring records this as a deviation of record superseding the worksheet's support-separated route, noting full support-separation is *unachievable* when a support point lies in the two charts' overlap.

Other landed `[Field]` specialisations in the cert layer: `IsCertified.finrank_glued` (`AlgebraicJacobian/Picard/DivisorFamilyField.lean:154`), `deg_divFamDivisor` (`AlgebraicJacobian/Picard/DivisorFamilyFieldCRT.lean:376`), `CertifiedDivisorFamily.windowGen_of_field` and `divFam_divEq_of_eps_eq_of_field` (`AlgebraicJacobian/Picard/DivSchemeMonoBridgeField.lean:451`, `:475`).

## 5. The exact Abel-lift proposition — VERIFIED, identical in all four sites

`AlgebraicJacobian/Picard/JacobianDataFromPicRepDatum.lean:132`:

```lean
noncomputable def toJacobianDataOfAbelLifts (d : PicRepDatum k k C)
    (abel : DivScheme k A B g r₁ r₂ b₁ b₂ ⟶ d.J.left)
    (hlift : ∀ y : d.J.left, ∃ q : Spec (d.J.left.residueField y) ⟶
      DivScheme k A B g r₁ r₂ b₁ b₂,
      q ≫ abel = d.J.left.fromSpecResidueField y) :
    JacobianData C
```

The obligation, verbatim:

> `∀ y : J.left, ∃ q : Spec (J.left.residueField y) ⟶ DivScheme k A B g r₁ r₂ b₁ b₂, q ≫ abel = J.left.fromSpecResidueField y`

Same in `JacobianData.ofAbelLifts` (`AlgebraicJacobian/Picard/JacobianDataAbelSurj.lean:149`), `JacobianData.ofChartsOfAbelLifts` (`:193`), `quasiCompact_of_forall_residueField_lift_from_divScheme` (`:118`).

**Two mismatches against `effectiveDivisorClassifyZar`, one trivial and one real:**
1. Trivial: `hlift` wants a bare `Spec κ(y) ⟶ DivScheme`; `effectiveDivisorClassifyZar` gives an `Over` morphism into `divSchemeOver` (= `Over.mk (divSchemeι ≫ grPairStructMap)`, `AlgebraicJacobian/Picard/DivScheme.lean:156`). Take `.left`.
2. Real: `hlift` demands the triangle `q ≫ abel = fromSpecResidueField y`, i.e. that the point *hits* `y`. `effectiveDivisorClassifyZar_spec` (`:231`) never mentions `abel` — it only says the morphism is `divRepClassifyZar` of a family presenting `D`. Joining them needs the Abel-morphism compatibility square. That is the genuine residue, and it is your recorded "groups agree ≠ maps agree" shape.

Supporting instances all landed: `Over.testPointField` with `Field` and `Algebra k` instances at `AlgebraicJacobian/Picard/Pic0ChartTestPoint.lean:87/90/96`; the `relCurve`-side stack (`IsIntegral`, smooth, `QuasiCompact`, both cohomology `Module.Finite`) fires for any field with `[Algebra k K]` via `AlgebraicJacobian/Curve/BaseChangeInstances.lean:125–182` — but keyed to the product spelling `(C ⊗ overSpec k K).left`, not the `relCurve` alias, so consumers re-key by `haveI` (pattern at `AlgebraicJacobian/Picard/DivisorFamilyH1Locus.lean:130–134`).

## 3. `exists_effective_of_picClass` / `riemann_inequality` — VERIFIED, different files

`AlgebraicJacobian/RiemannRoch/FLVClass.lean:208` (not :205 for the other one):
```lean
lemma exists_effective_of_picClass (W : X.CurveDivisor)
    (hW : 1 ≤ CurveDivisor.deg K W + Sheaf.chi (X.moduleKSheaf K)) :
    ∃ E : X.CurveDivisor, 0 ≤ E ∧ CurveDivisor.picClass K E = CurveDivisor.picClass K W
```
Binders: `{K} [Field K] {X : Scheme.{u}} [X.Over (Spec (.of K))] [SmoothOfRelativeDimension 1 (X ↘ Spec (.of K))] [IsIntegral X] [QuasiCompact (X ↘ Spec (.of K))] [Module.Finite K (HModule (X.moduleKSheaf K) 0)] [… 1]`. Produces a **Weil `CurveDivisor`** over the field `K`. Note the input is a *divisor* `W`, not a class.

`riemann_inequality`, `AlgebraicJacobian/RiemannRoch/ChiLedger.lean:137`:
```lean
theorem riemann_inequality (D : X.CurveDivisor) :
    CurveDivisor.deg K D + Sheaf.chi (X.moduleKSheaf K) ≤ (Sheaf.h0 (X.divisorSheaf K D) : ℤ)
```
Also useful: `exists_effective_of_h0_pos`, `AlgebraicJacobian/RiemannRoch/SectionBound.lean:175`, same conclusion from `0 < h⁰`.

## 4. Divisor → `LocalEquations` on `relCurve C κ` — landed (detail in §1)

`exists_localEquations_presentationDivisor_eq` (`AlgebraicJacobian/Picard/DivisorFamilyBackward.lean:120`) plus `exists_divisorAdaptation` (`AlgebraicJacobian/Picard/DivisorFamilyExtraction.lean:54`). Other producers: `ThetaGeneratorSeed.localEquations` (`AlgebraicJacobian/Picard/DivSchemeFamily.lean:349`), `ThetaGeneratorSeed.residueFibreLocalEquations` (`AlgebraicJacobian/Picard/DivSchemeSeedUnivPulledDegree.lean:49`, lands on `relCurve C p.asIdeal.ResidueField`), `thetaFiberPullback` (`AlgebraicJacobian/Cohomology/RelCurveCollapse.lean:490`).

## 6. fiberTwist / degree-0-plus-g-fibre

`fiberTwist` landed: `AlgebraicJacobian/RiemannRoch/FiberTwist.lean:301`, with `classDeg_fiberTwist` (`:393`) and `one_le_classDeg_fiberTwist_one` (`AlgebraicJacobian/RiemannRoch/ThetaDegree.lean:158`).

`fiberTwistShift` or anything of that form: **NO SUCH DECLARATION** (grep, whole tree).

"A degree-0 class over a field becomes effective after adding g times the fibre class": **NO SUCH DECLARATION**. Nearest, none of which is it: `degAt_chartTwist` (`AlgebraicJacobian/Picard/Pic0ChartLocus.lean:202`, degree ledger only); `exists_isSplitWitness_of_drop` (`AlgebraicJacobian/Picard/Pic0ChartCoverageFibre.lean:98`, takes the effective `W₀` and its class equation as *hypotheses*); `DivFamZar.exists_effective_witness` (`AlgebraicJacobian/Picard/DivisorFamilyH1Locus.lean:123`, runs the wrong way).

## NOT MEASURED

- **Kernel axiom confirmation.** `#print axioms` over the `DivScheme` import cone did not finish after ~11 min; I killed it. Sorry-freeness of `effectiveDivisorClassifyZar`, `divRepClassifyZar`, `isCertified_of_deg` etc. is a **text-grep + existing-`.olean`** claim only. Given your own recorded lessons (docstring lists unchecked; sorried instances leak only at synthesis sites), re-run with a longer budget before pricing on it. Text-level census: the only `sorry` outside `Challenge.lean` in `AlgebraicJacobian/` is `AlgebraicJacobian/Picard/Pic0ThetaCocycle.lean:268`, off this path.
- Whether `exists_divFam_divFamDivisor_eq`'s instance block actually synthesises at a `testPointField κ(y)` — I read that the constituent instances exist and are field-generic, but did not elaborate a probe term. Per your "measure absence at the root" note, that is the check that would settle it.
