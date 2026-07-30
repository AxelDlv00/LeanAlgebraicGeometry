/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartVMonotone
import Mathlib.CategoryTheory.Sites.LocallyBijective

/-!
# The two seam antecedents COLLAPSE at a one-chart atlas: the pair forces an ISOMORPHISM

Four rows and three file headers in this project defer to one question, in these words:
**"inhabitation of the pair `(huniv V, hcov V)` is unmeasured at every `V` and may be empty
everywhere"** (`AJCR.w4-rep.datum.chart-restrict`, repeated verbatim on
`…datum.atlas-coupling`, whose own summary adds that its round "removed a candidate escape from
that question, it did not answer it").  Five files of endpoint refutations and monotonicity
results (`Pic0ChartRestrictedFibreSat`, `Pic0ChartVMonotone`, `Pic0ChartBotRefute`,
`Pic0ChartAtlasCoupling`, `Pic0ChartCoverForcesNonInj`) all stop there.

**This file answers what the pair IS.**  For a one-chart atlas the two antecedents are not two
independent conditions to be met at some lucky `V` — together they say the chart map is an
**isomorphism of sheaves onto `pic0SigmaSheaf C`**, and conversely any such isomorphism
satisfies both.  So the question "is the pair inhabited at some `V`?" is *equivalent* to
"is `pic0SigmaFunctor C` representable by an open of the divisor scheme?", which is the
project's own headline restricted to a one-chart atlas.

## Why this is a collapse and not a restatement

The two clauses are `MorphismProperty.relative`-shaped and sieve-shaped respectively, and
nothing in the tree related them.  The bridge is that each is *half of a bijectivity*:

* antecedent 1 (`IsChartUniv`, i.e. `IsOpenImmersion.presheaf`) **implies** elementwise
  injectivity on every test — that is `injective_of_isOpenImmersion_presheaf`
  (`Pic0ChartOpenImmersionCriterion.lean`), which routes through
  `IsOpenImmersion.le_monomorphisms`.  Injectivity on the nose is *stronger* than
  `Presheaf.IsLocallyInjective`, so it gives it (`isLocallyInjective_of_injective`);
* antecedent 2 is `Presheaf.IsLocallySurjective` verbatim;
* and mathlib's `Sheaf.isLocallyBijective_iff_isIso` turns locally-injective-plus-locally-
  surjective into `IsIso` — **provided both sides are sheaves**.  The target is one by
  construction (`pic0SigmaFunctor_isSheaf`); the source is one because the big Zariski topology
  is **subcanonical** (`AlgebraicGeometry.subcanonical_zariskiTopology`, mathlib), so `yoneda.obj X`
  is a sheaf for it with no hypothesis on `X` at all.

That last point is the step that had never been taken here: the chart source is representable,
and on a subcanonical site a representable presheaf is a sheaf, so the seam's two antecedents
live in a category where mathlib's bijectivity criterion applies.  Nothing about `pic⁰`,
divisors, charts or the curve enters any proof below.

## What this buys, stated as three consequences and one non-consequence

* **`chartIso_of_seam`** — the collapse. Both antecedents at a one-chart atlas give
  `IsIso` of the sheaf morphism.
* **`representableBy_of_seam`** — hence `pic0SigmaFunctor C` is represented by the chart
  source *on the nose*, without going through mathlib's 01JJ gluing engine at all.  For a
  one-chart atlas the whole `Scheme.LocalRepresentability` apparatus of
  `pic0RepresentableByOfCharts` is bypassed: the glued scheme is the chart.
* **`exists_retraction_of_seam`** — the sharp constraint on `V`.  If the pair holds at `V` then
  the open inclusion `V.ι : ↥V ⟶ D.left` is a **split mono in `Scheme`**: the chart map
  composed with the inverse retracts it.  So a working `V` is not merely a proper intermediate
  open (which is all the endpoint results gave); it is a **retract of the divisor scheme**.
  That is a much stronger structural demand, and it is the form in which the inhabitation
  question should be attacked next.
* **The non-consequence, and it is why this file does not claim to have answered the question.**
  `IsIso` is an *equivalent reformulation*, not a refutation and not a witness.  Nothing below
  exhibits a `V` at which the pair holds, and nothing below refutes one.  What changes is that
  the target is now a single familiar statement about one morphism instead of a conjunction of
  two conditions of different shapes — and that the retraction constraint is available to
  whoever attacks it.

## Scope: one chart, and that is a real restriction

Every statement here is for a **`PUnit`-indexed** atlas.  That is not a convenience: for a
general `ι` the two antecedents are about *different* morphisms (`f i` versus `Sigma.desc f`),
`Sigma.desc f` is not a map out of a representable, and the collapse genuinely fails to
typecheck.  The one-chart case is not a caricature either — `Pic0AtlasFromDivRep.lean` builds a
one-chart atlas, and `IsChartUniv`, `RestrictedChartFibre` and `restrictedChartFibre_top_iff`
are all stated for one.  But a lane must not read `chartIso_of_seam` as a statement about
`mixedParamChart` at arbitrary `ι`.  `isLocallySurjective_oneChart` below is the bridge that
makes the one-chart hypothesis usable in the coproduct spelling the seam consumes, so the
restriction is to the *index*, not to the *spelling*.

## Main declarations

* `AlgebraicGeometry.chartSourceSheaf` — the chart source as a sheaf, by subcanonicity.
* `AlgebraicGeometry.isLocallySurjective_oneChart` — antecedent 2 in the coproduct spelling
  gives local surjectivity of the single chart.
* `AlgebraicGeometry.chartIso_of_seam` — **the collapse**.
* `AlgebraicGeometry.seam_of_chartIso` — **the converse**, so this is an equivalence and not a
  weakening.
* `AlgebraicGeometry.representableBy_of_seam` — the representation, engine-free.
* `AlgebraicGeometry.exists_retraction_of_seam` — `V.ι` is a split mono.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

noncomputable section

/-! ## The chart source is a sheaf -/

/-- **A representable presheaf is a big-Zariski sheaf**, because the big Zariski topology is
subcanonical (`subcanonical_zariskiTopology`, mathlib).

Recorded as a named lemma because it is the step the whole file rests on and the step nobody
had taken: the chart source of the atlas is `yoneda.obj (V : Scheme)`, hence a sheaf, hence the
chart map is a morphism *of sheaves* — which is what lets mathlib's bijectivity criterion see
it.  No hypothesis on the scheme. -/
theorem isSheaf_yoneda_obj (X : Scheme.{u}) :
    Presheaf.IsSheaf Scheme.zariskiTopology (yoneda.obj X) :=
  (isSheaf_iff_isSheaf_of_type _ _).mpr
    (GrothendieckTopology.Subcanonical.isSheaf_of_isRepresentable (yoneda.obj X))

/-- The chart source bundled as a sheaf on the big Zariski site. -/
def chartSourceSheaf (X : Scheme.{u}) : Sheaf Scheme.zariskiTopology.{u} (Type u) :=
  ⟨yoneda.obj X, isSheaf_yoneda_obj X⟩

variable (C) in
/-- A chart map read as a morphism of sheaves. -/
def chartSheafHom {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) :
    chartSourceSheaf X ⟶ pic0SigmaSheaf C :=
  ⟨f⟩

/-! ## Antecedent 2 at a one-chart atlas -/

variable (C) in
/-- **Antecedent 2, de-coproducted at one chart**: local surjectivity of `Sigma.desc` for a
`PUnit`-indexed family gives local surjectivity of the chart itself.

The image sieve of `Sigma.desc` is contained in that of the single chart, because a section of
the coproduct presheaf resolves into a section of the one summand
(`FunctorToTypes.jointly_surjective'`, the lemma `Pic0ChartBotRefute.lean` first brought into
this project) and `Sigma.ι_desc` identifies the two readings.

This is what makes the one-chart restriction a restriction on the *index* only: a lane holding
the instance the seam consumes holds this. -/
theorem isLocallySurjective_oneChart {X : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (h : Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (fun _ : PUnit.{u+1} => f))) :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology f := by
  haveI := h
  constructor
  intro T s
  refine Scheme.zariskiTopology.superset_covering ?_
    (Presheaf.imageSieve_mem (J := Scheme.zariskiTopology)
      (Sigma.desc (fun _ : PUnit.{u+1} => f)) s)
  intro Y g hg
  obtain ⟨t, ht⟩ := hg
  obtain ⟨i, y, rfl⟩ := CategoryTheory.FunctorToTypes.jointly_surjective'
    (Discrete.functor fun _ : PUnit.{u+1} => yoneda.obj X) (op Y) t
  refine ⟨y, ?_⟩
  rw [← ht, ← NatTrans.comp_app_apply]
  simpa using
    (NatTrans.congr_app (Sigma.ι_desc (fun _ : PUnit.{u+1} => f) i.as) (op Y)).symm ▸ rfl

/-! ## The collapse -/

variable (C) in
/-- **THE COLLAPSE**: at a one-chart atlas the two seam antecedents together say the chart map
is an isomorphism onto the Σ-sheaf.

Antecedent 1 gives injectivity on every test, hence local injectivity; antecedent 2 is local
surjectivity; and on a site where both sides are sheaves mathlib's
`Sheaf.isLocallyBijective_iff_isIso` closes it.  The source is a sheaf by subcanonicity
(`isSheaf_yoneda_obj`) — the observation this file exists to spend.

Read against the five files of `V`-interval results: those establish that a working `V` must be
a proper intermediate open.  This says what a working `V` *is*. -/
theorem chartIso_of_seam {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (hf : IsOpenImmersion.presheaf f)
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology f) :
    IsIso (chartSheafHom C f) := by
  haveI : Presheaf.IsLocallyInjective Scheme.zariskiTopology (chartSheafHom C f).hom :=
    Presheaf.isLocallyInjective_of_injective _ _
      (fun T => injective_of_isOpenImmersion_presheaf hf T)
  haveI : Presheaf.IsLocallySurjective Scheme.zariskiTopology (chartSheafHom C f).hom := hcov
  exact (Sheaf.isLocallyBijective_iff_isIso (chartSheafHom C f)).mp
    ⟨inferInstance, inferInstance⟩

variable (C) in
/-- **THE CONVERSE**, so the collapse is an equivalence and not a weakening (the `I-0896`
criterion).  An isomorphism satisfies both antecedents:

* antecedent 1 because `IsOpenImmersion.presheaf` is `MorphismProperty.relative`, which
  contains the isomorphisms (`MorphismProperty.of_isIso`, available since `relative` is
  multiplicative and respects isos);
* antecedent 2 because a locally surjective map is what an iso trivially is
  (`Presheaf.isLocallySurjective_of_iso`).

Together with `chartIso_of_seam` this says: **the pair is inhabited at `V` if and only if the
restricted chart is an isomorphism of sheaves.**  So the unmeasured inhabitation question has
not been weakened into something easier — it has been identified. -/
theorem seam_of_chartIso {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (h : IsIso f) :
    IsOpenImmersion.presheaf f
      ∧ Presheaf.IsLocallySurjective Scheme.zariskiTopology f := by
  haveI := h
  exact ⟨MorphismProperty.of_isIso (P := IsOpenImmersion.presheaf) f, inferInstance⟩

/-! ## The representation, without the gluing engine -/

variable (C) in
/-- **The seam's conclusion at a one-chart atlas, engine-free**: the two antecedents represent
`pic0SigmaFunctor C` by the chart source itself.

`pic0RepresentableByOfCharts` obtains its representing object from mathlib's 01JJ
`Scheme.LocalRepresentability` gluing engine, as
`(Scheme.LocalRepresentability.glueData hf).glued`.  At one chart that is unnecessary: the
underlying presheaf map of the iso is already an equivalence at every test, and naturality is
the chart map's own naturality.  So a lane that closes the pair at one `V` does not owe the
glue-data bookkeeping — it gets the representation directly, over the chart.

This is stated for `pic0SigmaFunctor` rather than `pic0TypeFunctor`: the Σ-descent to the
slice is `Functor.RepresentableBy.overSlice`, exactly as in `pic0RepresentableByOfCharts`, and
is not re-proved here. -/
def representableBy_of_seam {X : Scheme.{u}} (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (hf : IsOpenImmersion.presheaf f)
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology f) :
    (pic0SigmaFunctor C).RepresentableBy X :=
  letI : IsIso f := by
    haveI := chartIso_of_seam C f hf hcov
    exact (inferInstance : IsIso ((sheafToPresheaf Scheme.zariskiTopology (Type u)).map
      (chartSheafHom C f)))
  { homEquiv := fun {T} => Iso.toEquiv ((asIso f).app (op T))
    homEquiv_comp := fun {_T _T'} g x => NatTrans.naturality_apply f g.op x }

/-! ## The sharp constraint on `V` -/

variable (C) in
/-- **A WORKING `V` IS A RETRACT OF THE CHART SOURCE.**

If the two antecedents hold for `restrictChart f V` then `V.ι : ↥V ⟶ X` is a **split mono in
`Scheme`**: its retraction is `yoneda.preimage (f ≫ inv (restrictChart f V))`, i.e. "read the
class, then invert the restricted chart".  Yoneda is full, so this is an honest morphism of
schemes and not merely a presheaf-level section.

This strictly strengthens what the endpoint literature gives.  `Pic0ChartRestrictedFibreSat`
and `Pic0ChartVMonotone` establish that a working `V` must be a *proper intermediate open*;
this says it must be a *retract*, which for an open subscheme is a strong structural demand
(e.g. it forces `V.ι` to be a topological embedding admitting a continuous left inverse on all
of `X`, so `V` meets every connected component and its closure is `X` whenever `X` is
irreducible and `V` nonempty).

Deliberately not pushed to a refutation.  Whether the divisor scheme admits a proper open
retract is a question about `DivScheme`'s geometry that this file does not touch, and asserting
it cannot is exactly the kind of unverified claim the `unverified-counterexample-in-docstring`
lesson is about.  What is established is the obligation's *shape*. -/
theorem exists_retraction_of_seam {X : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) (V : X.Opens)
    (hf : IsOpenImmersion.presheaf (restrictChart f V))
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology (restrictChart f V)) :
    ∃ r : X ⟶ (V : Scheme.{u}), V.ι ≫ r = 𝟙 _ := by
  letI : IsIso (restrictChart f V) := by
    haveI := chartIso_of_seam C (restrictChart f V) hf hcov
    exact (inferInstance : IsIso ((sheafToPresheaf Scheme.zariskiTopology (Type u)).map
      (chartSheafHom C (restrictChart f V))))
  refine ⟨yoneda.preimage (f ≫ inv (restrictChart f V)), ?_⟩
  apply yoneda.map_injective
  have h1 : yoneda.map (V.ι ≫ yoneda.preimage (f ≫ inv (restrictChart f V)))
      = yoneda.map V.ι ≫ (f ≫ inv (restrictChart f V)) := by
    rw [Functor.map_comp, yoneda.map_preimage]
  have h2 : yoneda.map V.ι ≫ (f ≫ inv (restrictChart f V))
      = 𝟙 (yoneda.obj (V : Scheme.{u})) := by
    rw [← Category.assoc]; exact IsIso.hom_inv_id (restrictChart f V)
  rw [h1, h2, ← yoneda.map_id]

end

end AlgebraicGeometry
