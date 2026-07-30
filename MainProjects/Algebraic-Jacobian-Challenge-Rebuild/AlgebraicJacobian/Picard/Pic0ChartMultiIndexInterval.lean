/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartCoverForcesNonInj

/-!
# The `V`-interval at a MULTI-INDEX atlas: the hypothesis the one-chart no-go was hiding

`Picard/Pic0ChartCoverForcesNonInj.lean` proves that coverage at a proper open `V ≠ ⊤` forces
the chart map to be non-injective on some test, and `Picard/Pic0ChartRestrictedFibreSat.lean`
refutes both endpoints of the `V`-interval.  **Every one of those statements is about a
one-chart atlas** (`ι := PUnit`), and the first file says so twice in its own limits section:

> the dichotomy above is for a one-chart atlas … and **not** for `mixedParamChart` at
> arbitrary `ι`.  The multi-index case is open and is *not* claimed here.

The reason it gives is correct: coverage returns *some* index `i`, not the index `i₀` whose
tautological section was tested, and if `i ≠ i₀` the two chart values live on different sources,
so no non-injectivity of a single map follows.

But the seam consumes `mixedParamChart` at arbitrary `ι`
(`pic0RepresentableBy_of_restrictedChartFibre`, `Pic0ChartRestrictedFibre.lean:259`).  So as the
tree stands, every "this `V` is dead" fact is about an atlas the assembly does not use, and
nothing says whether the interval is constrained at all for the real one.  **This file settles
that**, and the answer is that the no-go does *not* propagate — with the obstruction isolated as
a named hypothesis rather than left as a caveat.

## What the multi-index argument actually proves

Run the one-chart proof at a general family.  Coverage at the test `X i₀`, the tautological
section of `f i₀`, and a point `t ∉ V i₀` returns `W ∋ t`, an index `i`, and
`x : ↥W ⟶ ↥(V i)` with

```
(f i).app (op ↥W) (x ≫ (V i).ι)  =  (f i₀).app (op ↥W) (W.ι)
```

Two *different* points of the disjoint union of the chart sources therefore carry the same
value.  That is `¬ JointlyInjective f`, and it is all the argument gives: joint injectivity is
the conjunction of index separation and per-chart injectivity
(`jointlyInjective_iff`), and only the second half is what the one-chart theorem concluded.

## Why that is a negative answer, proved rather than asserted

`IndexSeparated` — distinct indices never share a value — is **free when `ι` is a subsingleton**
(`indexSeparated_of_subsingleton`), which is exactly why the one-chart theorem needed no such
hypothesis, and it is **refuted by any atlas with two charts sharing a value**
(`not_indexSeparated_duplicated`, at a family whose every member is injective).  A glueing
atlas has overlapping charts by construction, so index separation is the wrong thing to hope
for and the one-chart refutation has no multi-index analogue.

The sharp positive form is `not_injective_of_pointwiseCoverage_of_indexSeparated_of_ne_top`:
coverage at a proper `V i₀` *plus index separation* refutes injectivity of that chart.  So the
escape from the one-chart no-go is precisely index crossing — the "index slack" that
`Pic0ChartCoverageIndexSlack.lean` says the atlas is indexed *for*.  That slack is now
load-bearing rather than decorative.

## The honest limits

* **Nothing here discharges an antecedent.**  `PointwiseCoverage` at a proper `V` has no
  producer, and neither does its negation; every theorem below is an implication between open
  propositions, or a statement about a concrete witness family.  What changes is that the
  `V`-interval no-go is now known **not** to close the multi-index route, so a lane may
  legitimately aim antecedent 1 at `mixedParamChart` with `ι` genuinely large.
* **This is not a claim that the multi-index seam is satisfiable.**  Refuting a refutation is
  not an inhabitation.  `(huniv V, hcov V)` remains unmeasured at every `V`, at every `ι`.
* **Everything is stated for an arbitrary family of big-site presheaf maps.**  No divisor
  scheme, chart index, twist, `rep` or `pic⁰` fact enters any statement or proof, exactly as in
  the one-chart file — so nothing here depends on which atlas a producer eventually builds.

## Main declarations

* `AlgebraicGeometry.JointlyInjective` — the multi-index strengthening of per-test injectivity:
  the chart sources inject *jointly* into the Σ-sheaf.
* `AlgebraicGeometry.IndexSeparated` — distinct indices never share a value.
* `AlgebraicGeometry.jointlyInjective_iff` — joint injectivity **is** index separation plus
  per-chart injectivity.  This is the decomposition that shows what the one-chart conclusion was.
* `AlgebraicGeometry.not_jointlyInjective_of_pointwiseCoverage_of_ne_top` — **the multi-index
  step**: coverage at a proper `V i₀` refutes joint injectivity, at arbitrary `ι`.
* `AlgebraicGeometry.not_injective_of_pointwiseCoverage_of_indexSeparated_of_ne_top` — the
  one-chart conclusion recovered at arbitrary `ι`, with the missing hypothesis explicit.
* `AlgebraicGeometry.indexSeparated_of_subsingleton` — why the one-chart theorem needed none.
* `AlgebraicGeometry.not_indexSeparated_duplicated` and
  `AlgebraicGeometry.injective_duplicated` — the negative answer: an all-injective family that
  is not index separated, so the added hypothesis is not free and the no-go does not propagate.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

noncomputable section

/-! ## The two multi-index injectivity notions -/

variable (C) in
/-- **Joint injectivity of a chart family**: over every test, the disjoint union of the chart
sources injects into the Σ-sheaf.

For a one-element family this is per-test injectivity of the single chart map; for a general
family it is strictly stronger (`jointlyInjective_iff`, `not_indexSeparated_duplicated`), and it
is exactly the statement the multi-index coverage argument refutes. -/
def JointlyInjective {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) : Prop :=
  ∀ (S : Scheme.{u}ᵒᵖ) (i j : ι) (x : (yoneda.obj (X i)).obj S)
    (y : (yoneda.obj (X j)).obj S),
    (f i).app S x = (f j).app S y →
      (⟨i, x⟩ : Σ i, (yoneda.obj (X i)).obj S) = ⟨j, y⟩

variable (C) in
/-- **Index separation**: two charts with different indices never take the same value on a
common test.

This is the half of joint injectivity that has no one-chart counterpart, and the whole content
of the gap between the one-chart no-go and the multi-index case. -/
def IndexSeparated {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) : Prop :=
  ∀ (S : Scheme.{u}ᵒᵖ) (i j : ι) (x : (yoneda.obj (X i)).obj S)
    (y : (yoneda.obj (X j)).obj S), (f i).app S x = (f j).app S y → i = j

/-- **Joint injectivity decomposes**: it is index separation together with per-chart
injectivity on every test.

Read left to right this says what the multi-index coverage argument's conclusion contains; read
right to left it says the one-chart theorem's conclusion (per-chart injectivity) is only *half*
of what would be needed to run the refutation at a general `ι`. -/
theorem jointlyInjective_iff {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) :
    JointlyInjective C f ↔
      IndexSeparated C f ∧ ∀ (i : ι) (S : Scheme.{u}ᵒᵖ), Function.Injective ((f i).app S) := by
  constructor
  · intro h
    refine ⟨fun S i j x y hxy => ?_, fun i S x y hxy => ?_⟩
    · exact congrArg Sigma.fst (h S i j x y hxy)
    · exact eq_of_heq (Sigma.mk.injEq .. ▸ h S i i x y hxy).2
  · rintro ⟨hsep, hinj⟩ S i j x y hxy
    obtain rfl : i = j := hsep S i j x y hxy
    exact congrArg (fun z => (⟨i, z⟩ : Σ i, (yoneda.obj (X i)).obj S)) (hinj i S hxy)

/-- Joint injectivity implies per-chart injectivity — the direction a lane will reach for. -/
theorem injective_of_jointlyInjective {ι : Type u} {X : ι → Scheme.{u}}
    {f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1} (h : JointlyInjective C f)
    (i : ι) (S : Scheme.{u}ᵒᵖ) : Function.Injective ((f i).app S) :=
  ((jointlyInjective_iff f).mp h).2 i S

/-- **Index separation is free for a one-chart atlas** — the reason
`not_injective_of_pointwiseCoverage_of_ne_top` needed no such hypothesis, and the reason its
proof cannot be read as covering the general case. -/
theorem indexSeparated_of_subsingleton {ι : Type u} [Subsingleton ι] {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) :
    IndexSeparated C f :=
  fun _ _ _ _ _ _ => Subsingleton.elim _ _

/-! ## The multi-index step -/

variable (C) in
/-- **COVERAGE AT A PROPER `V i₀` REFUTES JOINT INJECTIVITY, AT ARBITRARY `ι`.**

The one-chart argument of `not_injective_of_pointwiseCoverage_of_ne_top`, run at a general
family: the tautological section of `f i₀`, tested at `X i₀` and read at a point outside
`V i₀`, is matched by a coverage witness that factors through `V i` for *some* index `i`.  Those
are two different points of the disjoint union of the chart sources with the same value.

The conclusion is about the family, not about `f i₀`: that is exactly the loss the one-chart
file predicted, made precise.  Nothing beyond the equation is used — no divisor, chart index,
twist, `rep`, or `pic⁰` fact. -/
theorem not_jointlyInjective_of_pointwiseCoverage_of_ne_top {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) (V : ∀ i, (X i).Opens)
    (i₀ : ι) (hV : V i₀ ≠ ⊤)
    (hcov : PointwiseCoverage C (fun i => restrictChart (f i) (V i))) :
    ¬ JointlyInjective C f := by
  intro h
  obtain ⟨hsep, hinj⟩ := (jointlyInjective_iff f).mp h
  -- `V i₀ ≠ ⊤` gives a point of `X i₀` outside `V i₀`
  obtain ⟨t, htV⟩ : ∃ t : X i₀, t ∉ V i₀ := by
    by_contra hc
    exact hV (top_le_iff.mp fun t _ => not_not.mp fun ht => hc ⟨t, ht⟩)
  obtain ⟨W, htW, i, x, hx⟩ := hcov (X i₀) ((f i₀).app (op (X i₀)) (𝟙 (X i₀))) t
  -- the coverage witness at index `i` and the identity at index `i₀` agree over `W`
  have hxv : (f i).app (op (W : Scheme.{u})) (x ≫ (V i).ι)
      = (f i₀).app (op (W : Scheme.{u})) (W.ι ≫ 𝟙 (X i₀)) := by
    rw [← chart_map_ι_apply (f i₀) W (𝟙 (X i₀))]
    exact hx
  -- index separation collapses the two indices, and then per-chart injectivity the two points
  obtain rfl : i = i₀ := hsep _ i i₀ _ _ hxv
  have heq := hinj i _ hxv
  -- but they disagree at `t`: the witness lands in `V i` and `t` does not
  have hpt : ((x ≫ (V i).ι).base ⟨t, htW⟩ : X i)
      = ((W.ι ≫ 𝟙 (X i)).base ⟨t, htW⟩ : X i) := by rw [heq]
  have hmem : ((x ≫ (V i).ι).base ⟨t, htW⟩ : X i) ∈ V i := (x.base ⟨t, htW⟩).2
  rw [hpt] at hmem
  exact htV (by simpa using hmem)

variable (C) in
/-- **The one-chart conclusion, recovered at arbitrary `ι` with the missing hypothesis
explicit**: coverage at a proper `V i₀` together with index separation refutes injectivity of
the tested chart on some test.

At `ι := PUnit` the index-separation hypothesis is free (`indexSeparated_of_subsingleton`), so
this contains `not_injective_of_pointwiseCoverage_of_ne_top`; at a general `ι` it is a genuine
extra premise, and `not_indexSeparated_duplicated` shows it is not one an overlapping atlas
supplies. -/
theorem not_injective_of_pointwiseCoverage_of_indexSeparated_of_ne_top
    {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) (V : ∀ i, (X i).Opens)
    (i₀ : ι) (hV : V i₀ ≠ ⊤) (hsep : IndexSeparated C f)
    (hcov : PointwiseCoverage C (fun i => restrictChart (f i) (V i))) :
    ∃ (i : ι) (S : Scheme.{u}ᵒᵖ), ¬ Function.Injective ((f i).app S) := by
  by_contra hall
  simp only [not_exists, not_not] at hall
  exact not_jointlyInjective_of_pointwiseCoverage_of_ne_top C f V i₀ hV hcov
    ((jointlyInjective_iff f).mpr ⟨hsep, fun i S => hall i S⟩)

/-- **The contrapositive, in the form the fork's positive branch reads**: an index-separated
family all of whose charts are injective admits coverage at no proper `V`. -/
theorem not_pointwiseCoverage_of_jointlyInjective_of_ne_top {ι : Type u} {X : ι → Scheme.{u}}
    {f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1} (V : ∀ i, (X i).Opens)
    (i₀ : ι) (hV : V i₀ ≠ ⊤) (hinj : JointlyInjective C f) :
    ¬ PointwiseCoverage C (fun i => restrictChart (f i) (V i)) :=
  fun hcov => not_jointlyInjective_of_pointwiseCoverage_of_ne_top C f V i₀ hV hcov hinj

/-! ## The negative answer: index separation is not free, so the no-go does not propagate -/

variable (C) in
/-- The two-element duplicated family: two copies of the map named by the tautological section
of `Spec k`, indexed by `ULift Bool`.

This is the witness that separates the two notions.  Its sources and its maps are the ones
`Pic0ChartCoverForcesNonInj.specSecMap_injective` already certifies, so no new geometry is
introduced — only a second index. -/
def duplicatedSpecFamily (_ : ULift.{u} Bool) :
    yoneda.obj (Spec (CommRingCat.of k)) ⟶ (pic0SigmaSheaf C).1 :=
  yonedaEquiv.symm (specSigmaSectionTaut C)

variable (C) in
/-- Every member of the duplicated family is injective on every test — `specSecMap_injective`
verbatim. -/
theorem injective_duplicated (i : ULift.{u} Bool) (S : Scheme.{u}ᵒᵖ) :
    Function.Injective ((duplicatedSpecFamily C i).app S) :=
  specSecMap_injective C S

variable (C) in
/-- **INDEX SEPARATION IS NOT FREE, AND NOT IMPLIED BY PER-CHART INJECTIVITY.**

The duplicated family has both charts injective on every test (`injective_duplicated`) and is
*not* index separated: the identity point of `Spec k` has the same value in both components.

This is the negative answer to the multi-index question.  The one-chart refutation of the
`V`-interval concludes per-chart injectivity, and per-chart injectivity does not give the
index-separation premise that
`not_injective_of_pointwiseCoverage_of_indexSeparated_of_ne_top` needs — so the no-go has no
multi-index analogue, and a glueing atlas, whose charts overlap by construction, is precisely
the shape that evades it. -/
theorem not_indexSeparated_duplicated :
    ¬ IndexSeparated C (duplicatedSpecFamily C) := by
  intro hsep
  have hne : (⟨false⟩ : ULift.{u} Bool) ≠ ⟨true⟩ := by simp
  exact hne (hsep (op (Spec (CommRingCat.of k))) ⟨false⟩ ⟨true⟩
    (𝟙 (Spec (CommRingCat.of k))) (𝟙 (Spec (CommRingCat.of k))) rfl)

variable (C) in
/-- The same fact at the level the coverage step consumes: the duplicated family is not jointly
injective, although each of its charts is injective. -/
theorem not_jointlyInjective_duplicated :
    ¬ JointlyInjective C (duplicatedSpecFamily C) :=
  fun h => not_indexSeparated_duplicated C ((jointlyInjective_iff _).mp h).1

/-- **Joint injectivity is inhabited** — so the hypothesis of
`not_pointwiseCoverage_of_jointlyInjective_of_ne_top` is not vacuous, and the refutation above
is about the *index*, not about the Σ-sheaf admitting no injective family at all.

The one-element family at the tautological section of `Spec k` is jointly injective: index
separation is free by `indexSeparated_of_subsingleton` and per-chart injectivity is
`specSecMap_injective`. -/
theorem jointlyInjective_singleSpecFamily :
    JointlyInjective C (fun _ : PUnit.{u+1} => yonedaEquiv.symm (specSigmaSectionTaut C)) :=
  (jointlyInjective_iff _).mpr
    ⟨indexSeparated_of_subsingleton _, fun _ S => specSecMap_injective C S⟩

end

end AlgebraicGeometry
