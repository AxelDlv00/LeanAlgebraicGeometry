Cutting scope as instructed. Here is what I have on the ring case.

## Direct answer: two project files name your exact question as the open residue, and one of them names a hard obstruction to the obvious route

Both were written *by other lanes* to record precisely this gap, and both are at HEAD.

**`AlgebraicJacobian/Curve/P1DegreeZeroTrivial.lean:41-52`** — its "What this does NOT do" section is your question verbatim:

> It does **not** discharge `∀ T : Over (Spec k), Subsingleton (pic0Subgroup (P1.asOver k) T)`, and the gap is not a quantifier shuffle. […] this file says each of those restrictions is trivial, which is **fibrewise triviality**, not triviality. Concluding the class itself is trivial is the descent step — for `T = overSpec k A` it is `Pic(ℙ¹_A) ≅ Pic(A) × ℤ`, cohomology and base change — and it is untouched here.

And then the load-bearing warning:

> the chart route **cannot** be extended: chart triviality over a general `k`-algebra `A` would need `Pic(A[t]) = Pic(A)`, which is **Traverso's theorem and holds exactly for seminormal `A`** — false in general, and mathlib has no seminormality at all.

I verified that last clause: `grep -rn "Traverso\|[Ss]eminormal"` over both `AlgebraicJacobian/` and `../../.lake-packages/mathlib/Mathlib` returns **only these two comment lines** — no mathlib seminormality, anywhere. So the two-chart route is not merely unbuilt over a ring, it is **false as stated** for general `A`. That is worth knowing before anyone tries to extend the chart computation.

**`AlgebraicJacobian/Picard/Pic0VanishingFieldTest.lean:44-52`** — independently states the same residue as what remains after its own field result:

> `∀ (A : Type u) [CommRing A] [Algebra k A], Subsingleton (pic0Subgroup C (overSpec k A))` for `A` **not** a field. That is fibrewise-degree-zero implies globally trivial over a base ring, i.e. cohomology and base change; **nothing in this tree proves it**, and it is the whole remaining distance from here to a `JacobianData` at a genus-`0` curve via `jacobianData_of_overSpec_subsingleton`.

Its `P1.subsingleton_pic0Subgroup_overSpec_field` (:167) is the field-test vanishing at P¹ with no hypothesis, and `Pic0VanishingAffineReduction.lean:190` `subsingleton_pic0Subgroup_forall_iff_overSpec` is the **iff** reducing `∀ T` to `∀` affine test rings — so the ring case is exactly, and only, what is left.

## The one real asset I found: ring-level cohomology base change exists, for glued datum sheaves

`AlgebraicJacobian/Cohomology/GluedSheafH0BaseChange.lean`. Binders (lines 46-53): `{k : Type u} [Field k] {C : Over (Spec (.of k))} {B : Type u} [CommRing B] [Algebra k B] (B' : Type u) [CommRing B'] [Algebra k B'] [Algebra B B'] [IsScalarTower k B B'] {π : C.left ⟶ P1 k} [IsFinite π] (D : BasicOpenCocycleDatum C B π)`.

```lean
noncomputable def datumH0BaseChange (hH1 : Subsingleton (datumPair D).H1) :    -- :229
    B' ⊗[B] (Sheaf.HModule D.sheaf 0) ≃ₗ[B']
      Sheaf.HModule (D.baseChange B').sheaf 0

theorem datum_subsingleton_h1_baseChange (hH1 : Subsingleton (datumPair D).H1) : -- :245
    Subsingleton (Sheaf.HModule (D.baseChange B').sheaf 1)
```

This is **genuine cohomology-and-base-change over an arbitrary commutative ring pair `B → B'`** — H⁰ on the nose, plus H¹ vanishing propagating forward. Related: `Cohomology/GluedSheafDatumFibre.lean:107` takes the same `Subsingleton (HModule (D.baseChange B').sheaf 1)` as a hypothesis.

Three caveats that decide whether it is usable:
- It is stated for `BasicOpenCocycleDatum`, i.e. **explicit two-chart glued cocycle data over the `fiberTwoCover` of a finite `π : C.left ⟶ P1 k`** — not for a `CechPic` class. Getting from a class to such a datum is the divisor-representability carrier, which is the gated part of the tree.
- Both are gated on `hH1 : Subsingleton (datumPair D).H1` — a vanishing hypothesis on the *source* pair, i.e. it propagates vanishing rather than establishing it.
- The direction is H⁰/H¹ base change, **not** "fibrewise trivial ⟹ pulled back from the base". It does not by itself give you the descent conclusion.

## Not found (with the queries)

- **No projection formula, no pushforward/direct-image of a class, no `Pic(ℙ¹_A) ≅ Pic(A) × ℤ`.** Queries: `cohomologyAndBaseChange|projectionFormula|pushforward|directImage`; `Pic.*Polynomial|Pic.*× ℤ`. The `Pic(ℙ¹_T) ≅ Pic(T) × ℤ` string occurs only as prose naming the missing statement, in four places: `P1DegreeZeroTrivial.lean:46`, `P1H1Vanishing.lean:65`, `Albanese/Genus0VanishingDatum.lean:56`, and `Pic0VanishingFieldTest.lean`. All four are the same admission, not a theorem.
- **No "fibrewise trivial + flat ⟹ pulled back from the base".** Queries: `fibrewise.*trivial|fibreTrivial|trivial.*fibre.*pull|pulled back from`; `mem_picFromBase|∈ picFromBase`. Every `picFromBase` *producer* I found is structural, not a descent theorem: `RelPicCurveMap.lean:105` `cechPicMap_toUnit_whiskerRight_mem_picFromBase` (classes pulled back along `toUnit D ▷ T` — a degenerate curve factor), `Tangent/RelPicPointTest.lean:77` `picFromBase_eq_bot_of_subsingleton` (at a **one-point** test, so the subgroup is `⊥`), and `EtaleSeparatednessClose.lean:228` (an étale-cover kernel statement, hypothesis-gated on ζ1's `p_B^* N₀ = cg^* L`). `RiemannRoch/RelPicDegree.lean:46` `classDeg_eq_zero_of_mem_picFromBase` runs the *wrong way* for you — pulled-back ⟹ degree zero, the converse of the descent step.
- `Module.Flat` machinery is abundant (`Picard/SlicingFlat*.lean`, `FibrewiseRegular.lean`, `DivSchemeRedesignFreeFlat.lean`) but it is all **module-level** rTensor-residue-field regularity for the divisor-family certificates — no flatness-to-Picard-descent statement.

## Practical read

The ring case has one real asset (`datumH0BaseChange`, over arbitrary `B → B'`) and one closed door (the chart route, killed by Traverso/seminormality — don't send a lane at it). The reduction `subsingleton_pic0Subgroup_forall_iff_overSpec` means a single ring-level theorem finishes `hvan`. I did not attempt to price the distance from `datumH0BaseChange` to the descent conclusion — that needs the class-to-datum step, which lives in the divisor-representability carrier, and pricing it honestly is more than a few tool calls.

One flag on my earlier report, since it changes what you'd act on: I recommended relaying to pic-g that the RR route beats their two-chart plan. Given the field case is now closed at HEAD, that recommendation is stale in the direction that matters — the Laurent unit classification pic-g proposed to build is not just optional for the field case, it is on the branch that Traverso forecloses over rings. If pic-g is still holding `p1-witness`, the useful message is: field case done, don't build Laurent for the ring case.
