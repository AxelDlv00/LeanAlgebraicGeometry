/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartRestrictedFibre

/-!
# `RestrictedChartFibre` is inhabited, and where the content of antecedent 1 actually sits

`Picard/Pic0ChartRestrictedFibre.lean` repairs the route to `IsChartUniv` — antecedent 1 of
`pic0RepresentableByOfCharts` — by demanding the fibre datum at the **restricted** chart.  Its
own "honest limits" section then recorded the thing it could not settle:

> an inhabitant at `V = ⊥` was **attempted and not obtained** in this session … the `sq` field
> … needs `Subsingleton (pic0Subgroup C (Over.mk a₁))` over an empty base.  That is the
> triviality of `picEt` over the empty scheme: true, a genuinely separate lemma, and absent
> from the tree.

**That pricing was wrong, and the error was in the reduction rather than in the census.**  The
`sq` goal is an equality of two elements of `(pic0SigmaSheaf C).1.obj (op S)` at an *empty* test
`S`, and `pic0SigmaSheaf` is a **sheaf**.  A sheaf's value at an object covered by the empty
sieve is terminal, so the goal is closed with no fact about `picEt` at all:

* `Scheme.bot_mem_grothendieckTopology` (mathlib, `Sites/Pretopology.lean`) — stated exactly for
  `[IsEmpty X]`;
* `Sheaf.isTerminalOfBotCover` (mathlib, `Sites/Sheaf.lean`).

The `congr 1` that peeled the Σ-component and named `pic0Subgroup` as the residue is what made
a free goal look like a missing lemma.  Recorded because the prose pricing outlived the check.

## What this file establishes

* `pic0Sigma_obj_subsingleton_of_isEmpty` — the sheaf value at an empty test is a subsingleton.
  Three lines, no `picEt` input, no geometry.
* `restrictedChartFibre_bot` — **`RestrictedChartFibre` at `V = ⊥` is inhabited,
  unconditionally**: for every `rep`, `m`, `Z`, `hdeg`.  So the class is non-empty and the
  unmeasured-inhabitation risk `Pic0ChartRestrictedFibre.lean` flagged against itself (and that
  `ChartTyping` and `IsChartLocusFibre` carried) is discharged for this class.
* `isChartUniv_bot` — hence `IsChartUniv C π n rep m Z hdeg ⊥` holds with **no hypothesis**.

## The consequence, and it is a statement about the seam rather than about this file

`isChartUniv_bot` says antecedent 1 **carries no content at `V = ⊥`**.  That is not a defect of
the repair, and it is *not* a vacuity of the coupled assembly — because the coverage side is
refuted at the same value:

* `not_coverageContainment_bot` — the `hcov` hypothesis of
  `pic0RepresentableBy_of_restrictedChartFibre_of_coverage` at `V = ⊥` is **false** as soon as
  some test has a point.  Its witness `x` would have range inside `Set.range ((⊥).ι.base) = ∅`
  while `t ∈ W` exhibits a point of the source.

Put together, these two say precisely where the mathematics lives: `⊥` is the value at which
`hf` is free and coverage is impossible, and any `V` at which coverage becomes possible is one
at which `hf` must be re-earned.  The `V`-coupling is therefore not bookkeeping — it is the
whole obligation, and the pair (`huniv`, `hcov`) cannot be discharged at a convenient `V` by
either side alone.  This is the non-vacuity check for
`Pic0ChartRestrictedFibre.lean`'s assembly that `necessity_of_restrictedChartFibre` was
wrongly claimed to be (`I-0937`).

**What is still NOT closed, stated plainly.**  `rep` remains a hypothesis with no producer, so
`IsChartUniv` is not even statable without it; `hcov` at a useful `V` has no producer; and
nothing here produces a chart at a `V` other than `⊥`.  No antecedent of
`pic0RepresentableByOfCharts` is discharged by this file.  What is discharged is the
*satisfiability question* about the class, plus the sharp localisation of the remaining
obligation.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

noncomputable section

/-! ## The empty test, from the sheaf axiom -/

/-- **The Σ-sheaf is trivial on an empty test** — by the sheaf axiom, not by any property of
`picEt`.

The empty sieve covers an empty scheme (`Scheme.bot_mem_grothendieckTopology`), and a sheaf's
value at an object with a `⊥` cover is terminal (`Sheaf.isTerminalOfBotCover`); a terminal
object of `Type u` is a subsingleton.

This is the declaration `Pic0ChartRestrictedFibre.lean` priced as "the triviality of `picEt`
over the empty scheme: true, a genuinely separate lemma, and absent from the tree".  Note what
does *not* appear: no `picEt`, no `pic0Subgroup`, no `relPic`, no curve geometry.  The residue
was named after a `congr 1` had already thrown away the structure that makes it free. -/
theorem pic0Sigma_obj_subsingleton_of_isEmpty (S : Scheme.{u}) [IsEmpty S] :
    Subsingleton ((pic0SigmaSheaf C).1.obj (op S)) :=
  (Equiv.subsingleton_congr
    ((Types.isTerminalEquivIsoPUnit _
      (Sheaf.isTerminalOfBotCover (pic0SigmaSheaf C) S
        (Scheme.bot_mem_grothendieckTopology S))).toEquiv)).mpr inferInstance

/-- The carrier of the bottom open of a scheme is empty.  Stated as an instance because the
`isInitialOfIsEmpty` applications below need it by synthesis. -/
instance isEmpty_coe_bot_opens (T : Scheme.{u}) : IsEmpty ((⊥ : T.Opens) : Scheme.{u}) :=
  ⟨fun x => x.2⟩

/-! ## Inhabitation of the restricted datum -/

/-- **`RestrictedChartFibre` at `V = ⊥` is inhabited, with no hypotheses beyond the data the
statement mentions.**

Take `W := ⊥` as well.  Then:

* `r` is the unique map out of an empty scheme (`isInitialOfIsEmpty`);
* `sq` is an equality of natural transformations out of `yoneda.obj ↑⊥`; after `ext S x` the
  morphism `x : S.unop ⟶ ↑⊥` forces `S.unop` empty, and
  `pic0Sigma_obj_subsingleton_of_isEmpty` closes it;
* `exists_factor` is free: `v : S ⟶ ↑⊥` forces `S` empty, hence initial, so the factoring map
  and both compatibilities are unique.

**Why this is worth landing rather than just knowing.**  `Pic0ChartRestrictedFibre.lean` said a
lane picking up that row "should produce that witness first … it decides whether the repair is
real".  It does, and the answer is yes: the class is not empty, so the repaired route to
`IsChartUniv` is not a route to an uninhabitable hypothesis. -/
theorem restrictedChartFibre_bot {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ)) :
    RestrictedChartFibre C π n rep m Z hdeg ⊥ := by
  intro T g
  refine ⟨⟨⊥, isInitialOfIsEmpty.to _, ?_, ?_⟩⟩
  · ext S x
    have : IsEmpty (S.unop : Scheme.{u}) := x.base.hom.1.isEmpty
    exact (pic0Sigma_obj_subsingleton_of_isEmpty (C := C) S.unop).elim _ _
  · intro S v w _
    have : IsEmpty S := v.base.hom.1.isEmpty
    exact ⟨isInitialOfIsEmpty.to _, isInitialOfIsEmpty.hom_ext _ _,
      isInitialOfIsEmpty.hom_ext _ _⟩

/-- **Antecedent 1 is free at `V = ⊥`**: `IsChartUniv` holds there with no hypothesis.

One application of `isChartUniv_of_restrictedChartFibre` to the witness above.  Read together
with `not_coverageContainment_bot` below: `⊥` is exactly the value at which `hf` costs nothing
and coverage is impossible. -/
theorem isChartUniv_bot {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ)) :
    IsChartUniv C π n rep m Z hdeg ⊥ :=
  isChartUniv_of_restrictedChartFibre rep m Z hdeg ⊥ (restrictedChartFibre_bot rep m Z hdeg)

/-! ## The coverage side is refuted at the same value — so the assembly is not vacuous -/

variable (C π) in
/-- **The coverage hypothesis of the coupled assembly is FALSE at `V = ⊥`.**

This is the statement that stops `isChartUniv_bot` from making
`pic0RepresentableBy_of_restrictedChartFibre_of_coverage` vacuous.  Given any test `T` with a
point `t` and a section `s`, the `hcov` clause would supply an open `W ∋ t` and a chart point
`x : ↑W ⟶ (D i).left` whose base range is contained in `Set.range ((⊥).ι.base)`, which is
empty — while `t ∈ W` exhibits an element of `↑W`, hence of the range.

So the pair (`huniv`, `hcov`) is **not** jointly satisfiable at the value where `huniv` is
free.  Both hypotheses mention the same `V` by typing, and this says the typing is doing real
work: an `hf` lane and a coverage lane cannot each retreat to a convenient `V`.

Only the containment conjunct is used; the class equation is discarded.  So the refutation is
of the *containment at `⊥`*, and it does not depend on anything about the Abel chart. -/
theorem not_coverageContainment_bot {ι : Type u} (nn : ι → ℕ)
    (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
    (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)) (t : ↥T) :
    ¬ (∀ (T' : Scheme.{u}) (s' : (pic0SigmaSheaf C).1.obj (op T')) (t' : ↥T'),
      ∃ (W : T'.Opens) (_ : t' ∈ W) (i : ι) (x : (W : Scheme.{u}) ⟶ (D i).left),
        (abelSigmaChart C π (nn i) (rep i) (m i) (Z i) (hdeg i)).app
            (op (W : Scheme.{u})) x
          = (pic0SigmaSheaf C).1.map (W.ι).op s' ∧
        Set.range (x.base) ⊆ Set.range ((⊥ : (D i).left.Opens).ι.base)) := by
  intro hcov
  obtain ⟨W, htW, i, x, -, hrange⟩ := hcov T s t
  obtain ⟨y, -⟩ := hrange (Set.mem_range_self (⟨t, htW⟩ : ↥W))
  exact y.2

end

end AlgebraicGeometry
