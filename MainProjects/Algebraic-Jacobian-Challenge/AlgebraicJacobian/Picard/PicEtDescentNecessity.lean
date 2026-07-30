/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import AlgebraicJacobian.Picard.PicEtInvariantMatch

/-!
# The descent route is NOT a detour, and one of its four inputs is not an input

`AJC.picrep.etale-rep.descent-necessity`.

## The question this file answers, and why nobody had asked it

Four lanes have spent four rounds supplying **inputs** of
`Scheme.PicScheme.seamClauseOne_of_isGaloisQuotient` — a `k'`-side representation
`rep`, a Galois quotient `hq`, the covering statement `hcov`, and local finiteness
`hlft` of the quotient. What had never been measured is whether those are the
**right** four: which of them the theorem's own *conclusion* already implies, and
which are therefore consequences rather than obligations.

Two answers, and they go in opposite directions.

**1. `rep` is NECESSARY, not merely sufficient.** Clause (1) field 1 over `k` — a
`k`-scheme representing `picEt C` — *produces* a `k'`-scheme representing
`picEt (C_{k'})`, namely the base change of that very scheme
(`representableBy_picEt_baseChangeField_of_representableBy`). So the campaign's
undischarged output is not one sufficient route among several: any solution of the
seam contains one. Nobody can close field 1 over `k` and leave `rep` unwitnessed.

**2. `hlft` is NOT an independent input.** `LocallyOfFiniteType Y.hom` follows from
the `k'`-side finite type through the quotient's *own* isomorphism `e`
(`locallyOfFiniteType_of_isGaloisQuotient`), and the `k'`-side condition is itself
free by base change from the `k`-side one
(`locallyOfFiniteType_pullback_of_locallyOfFiniteType`). So a lane holding a
`k'`-side representation whose object is locally of finite type — which is what
Kleiman's `th:main` delivers, and what campaign `J5` is built to produce — owes
three inputs, not four.

## The direction that matters for a costing, stated precisely

These two facts are **not** the same shape and must not be quoted as one.

Fact 1 is an implication *out of* the conclusion, so it can only make the route look
better-aimed; it discharges nothing. In particular it is **not** a producer of
`rep`: its hypothesis is field 1 over `k`, which is exactly what the seam `sorry`
`Scheme.fgaPicardRepresentability` still owes and what no curve witnesses.

Fact 2 is a genuine subtraction from the antecedent list of a landed theorem, and it
is the reusable half.

## What is NOT claimed

* **No `sorry` is closed.** `Scheme.fgaPicardRepresentability` is untouched and is
  used here only as an axiom control. Clause (1) field 1 is witnessed for no curve.
* **Fact 1 is not a converse of the descent theorem.** It says field 1 over `k`
  implies the `rep` *input*; it does not imply `hq`, and §4 measures exactly how much
  of `hq` it does give (clauses 1 and 2, not clause 3). So "the four inputs are
  equivalent to the conclusion" is **false** and is not asserted anywhere below.
* **`hcov` is untouched.** It is `AJC.picrep.etale-rep.hcov` (`pic-a`'s row).

## How generic the necessity step is — measured, not guessed

`representableByCompLeftAdjoint` is the whole content of fact 1 with **every**
geometric hypothesis deleted: an arbitrary adjunction `L ⊣ R` between arbitrary
categories, an arbitrary presheaf, no scheme, no field, no curve. The Picard
statement is that lemma at `Over.mapPullbackAdj (specMapAlgebra k k')`, and the
`picEt`-specific step is only `picEt_crossBaseIso`. Recorded at that generality on
purpose: a reader must not budget a descent or base-change argument for it.

Reference: Kleiman, "The Picard scheme", §4 Thm. `th:main` (arXiv:math/0504020).
-/

set_option autoImplicit false

universe v u w

open CategoryTheory Limits Opposite AlgebraicGeometry

/-! ## §1. The generic transport: representability along a left adjoint

No schemes, no fields, no Picard functor. If `L ⊣ R` and `F` is represented by `X`,
then `L.op ⋙ F` is represented by `R.obj X` — the adjunction bijection *is* the
required natural bijection, and its naturality clause is
`Adjunction.homEquiv_naturality_left_symm`.

This is stated first, and at this generality, because the descent-necessity theorem
of §2 is *nothing else*: reading it as a geometric fact about base change is the
mispricing this file exists to prevent. -/

namespace CategoryTheory

/-- **Representability transports along a left adjoint.**

Fully generic. Mathlib has the `uliftFunctor` and partial-adjoint transports
(`Functor.representableByUliftFunctorEquiv`,
`Adjunction.Basic`'s `(F.op ⋙ yoneda.obj Y).RepresentableBy (G.obj Y)`) but not this
one: those transport along the *functor being represented*, or represent a
`yoneda.obj`, whereas this precomposes an arbitrary presheaf with a left adjoint.

Declared in `CategoryTheory`, not `AlgebraicGeometry`: it mentions no scheme, and a
reader who finds it under the geometric namespace would reasonably assume it does. -/
noncomputable def Functor.representableByCompLeftAdjoint {C : Type u} {D : Type u}
    [Category.{v} C] [Category.{v} D] {L : C ⥤ D} {R : D ⥤ C} (adj : L ⊣ R)
    {F : Dᵒᵖ ⥤ Type w} {X : D} (rep : F.RepresentableBy X) :
    (L.op ⋙ F).RepresentableBy (R.obj X) where
  homEquiv {T} := (adj.homEquiv T X).symm.trans rep.homEquiv
  homEquiv_comp {T T'} f g := by
    simp only [Equiv.trans_apply, Adjunction.homEquiv_naturality_left_symm]
    exact rep.homEquiv_comp _ _

end CategoryTheory

namespace AlgebraicGeometry

namespace Scheme

namespace PicScheme

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']

/-! ## §2. FACT 1 — the `k'`-side representation is NECESSARY -/

/-- **The restricted functor is represented by the base change**, for an arbitrary
field extension.

`restrictTest k k' = Over.map (specMapAlgebra k k')` is a left adjoint, with right
adjoint `Over.pullback (specMapAlgebra k k')`, so §1 applies verbatim. No hypothesis
on `k'/k`: not finite, not separable, not normal. -/
noncomputable def representableByRestrictTest_of_representableBy
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X : Over (Spec (CommRingCat.of k))}
    (rep : (picEt C).RepresentableBy X) :
    ((restrictTest k k').op ⋙ picEt C).RepresentableBy
      ((Over.pullback (specMapAlgebra k k')).obj X) :=
  Functor.representableByCompLeftAdjoint (Over.mapPullbackAdj (specMapAlgebra k k')) rep

/-- **THE NECESSITY THEOREM: field 1 of clause (1) over `k` PRODUCES the descent
route's `k'`-side input.**

Given a `k`-scheme `X` representing `picEt C`, the base change `X_{k'}` represents
`picEt (C_{k'})` — the Picard functor of the base-changed curve over `k'`, which is
exactly the `rep` hypothesis of
`Scheme.PicScheme.seamClauseOne_of_isGaloisQuotient` and of every theorem in
`Picard/PicEtDescentGoal.lean`.

**What this buys, and it is a statement about the ROUTE, not a discharge.** The
descent route is not one sufficient strategy among several that a cheaper `k`-side
argument might bypass: *any* solution of clause (1) field 1 carries a solution of
`rep` inside it. So `rep`'s 93 consumers and 0 producers is not a sign that the route
is badly chosen — the object it asks for is a consequence of the goal.

**What it does NOT buy.** Its hypothesis is the seam's own open obligation, so it
witnesses nothing. It also does not give `hq`: see §4, where clauses 1 and 2 of
`IsGaloisQuotient` are free at this object and clause 3 is not.

Two hypotheses it does *not* carry, both of which a reader would expect: no
finiteness and no separability of `k'/k`. Those are input 1's price
(`Scheme.picEt_ext_of_pullback_agrees`), and the same double-count has been corrected
twice in this cluster already. The proof is §1 plus `picEt_crossBaseIso`, and the
latter holds for an arbitrary field extension. -/
noncomputable def representableBy_picEt_baseChangeField_of_representableBy
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X : Over (Spec (CommRingCat.of k))}
    (rep : (picEt C).RepresentableBy X) :
    (picEt (Scheme.baseChangeField C k')).RepresentableBy
      ((Over.pullback (specMapAlgebra k k')).obj X) :=
  (representableByRestrictTest_of_representableBy (k' := k') C rep).ofIso
    (picEt_crossBaseIso C k').symm

/-! ## §3. FACT 2 — `hlft` is a consequence, not an input

`Scheme.PicScheme.seamClauseOne_of_isGaloisQuotient` carries
`(hlft : LocallyOfFiniteType Y.hom)` as a fourth hypothesis beside `rep`, `hq` and
`hcov`. It need not: the quotient's own isomorphism `e` identifies `Y_{k'}` with
`X'`, and `Picard/PicEtSeparated.lean`'s `locallyOfFiniteType_of_baseChange` descends
the property back to `Y`. So `hlft` is derivable from a condition on the object the
`k'`-side representation already names. -/

/-- **Local finiteness of the quotient is free from the `k'`-side.**

From the bundled `IsGaloisQuotient` — nothing else — plus
`LocallyOfFiniteType X'.hom`. Two steps: the quotient's `e` and `he` say `X'.hom`
*is* `pullback.snd Y.hom (specMapAlgebra k k')` up to a composition with an
isomorphism, hence that projection is locally of finite type; and
`locallyOfFiniteType_of_baseChange` (Mathlib's
`DescendsAlong @LocallyOfFiniteType (@Surjective ⊓ @Flat ⊓ @QuasiCompact)`) descends
it to `Y.hom`.

**So `hlft` is not a fourth obligation.** A lane closing the descent step should call
`seamClauseOne_of_isGaloisQuotient_lftFree` below, which asks for the `k'`-side
condition instead — and §3b shows *that* condition is itself free from the `k`-side
one, so nothing here has been relocated into a new hypothesis.

**Note the binder set, because the first draft of this lemma got it wrong in the
expensive direction.** It carried `[FiniteDimensional k k']` and `[IsGalois k k']`, on
the reading that `IsGaloisQuotient` needs them. It does not, and the reason is
sharper than "they come from elsewhere": `AlgebraicJacobian.GaloisDescent.SemilinearGalAction`
itself is declared under `variable (K L) [Field K] [Field L] [Algebra K L]` with **no**
Galois or finiteness binder, and `IsGaloisQuotient` adds none — so the word "Galois" in
both names is about the *intended* application, not about a hypothesis either carries.
(A first revision of this paragraph said the action "carries the Galois binders itself";
that is false, checked at the `variable` line, and it is the kind of plausible reason
that would have kept the trap alive.) Both are deleted here and the statement
re-elaborates (`lake env lean`, `EXIT=0`). Same double-count as
`Picard/PicEtSeparated.lean`'s field-2 theorem and the seam docstring's input 2: treat
a Galois binder on a descent-side lemma as unproven until checked without it. -/
theorem locallyOfFiniteType_of_isGaloisQuotient
    {X' : Over (Spec (CommRingCat.of k'))}
    {Y : Over (Spec (CommRingCat.of k))}
    (ρ : AlgebraicJacobian.GaloisDescent.SemilinearGalAction k k' X'.left X'.hom)
    (hq : AlgebraicJacobian.GaloisDescent.IsGaloisQuotient ρ Y.hom)
    (hX' : LocallyOfFiniteType X'.hom) :
    LocallyOfFiniteType Y.hom := by
  obtain ⟨e, he, -, -⟩ := hq
  refine locallyOfFiniteType_of_baseChange k' ?_
  have h2 : LocallyOfFiniteType (pullback.snd Y.hom (specMapAlgebra k k')) := by
    rw [← he]; exact MorphismProperty.comp_mem _ _ _ inferInstance hX'
  rw [← pullbackSymmetry_hom_comp_snd (specMapAlgebra k k') Y.hom]
  exact MorphismProperty.comp_mem _ _ _ inferInstance h2

/-! ### §3b. And the `k'`-side condition is free from the `k`-side one

Otherwise §3 would be a relocation rather than a subtraction: it would trade a
hypothesis about `Y` for one about `X'` with no net gain. It is a subtraction because
the object §2 produces satisfies the `k'`-side condition whenever `X` satisfies the
`k`-side one, by plain base-change stability — no descent, no field hypothesis. -/

/-- **Local finiteness base-changes to the `k'`-side object of §2**, and so does
separatedness. Both by `MorphismProperty.pullback_snd`; neither needs a hypothesis on
`k'/k`. `infer_instance` does **not** find either (measured), because the goal is
stated at the `Over.pullback` spelling rather than at the projection. -/
theorem locallyOfFiniteType_pullback_of_locallyOfFiniteType
    {X : Over (Spec (CommRingCat.of k))} (h : LocallyOfFiniteType X.hom) :
    LocallyOfFiniteType ((Over.pullback (specMapAlgebra k k')).obj X).hom :=
  MorphismProperty.pullback_snd _ _ h

/-- The separatedness companion of the previous lemma. Recorded because clause (1)'s
third field is `IsSeparated`, so a lane checking that §2 lands *inside* the campaign's
`k'`-side endpoint needs both. -/
theorem isSeparated_pullback_of_isSeparated
    {X : Over (Spec (CommRingCat.of k))} (h : IsSeparated X.hom) :
    IsSeparated ((Over.pullback (specMapAlgebra k k')).obj X).hom :=
  MorphismProperty.pullback_snd _ _ h

/-! ## §4. How much of `hq` is free — and which clause is the residue

§2 could be over-read as "the four inputs are equivalent to the conclusion". They are
not, and this section is the measurement that forbids it. At the base-changed object
`Y_{k'}` with its own pullback action, `IsGaloisQuotient` has four clauses; the
comparison isomorphism is `Iso.refl` and its two compatibility clauses close by
`simp`, so clauses 1 and 2 are free. Clause 3 — unique descent of an equivariant
`T_{k'}`-morphism to a `T`-morphism — is **not** free, and it is the whole residue.

That is the honest shape of the situation: `hq` at the object necessity produces is
one universal property, not four conditions. -/

/-- **Clauses 1 and 2 of `IsGaloisQuotient` are free at a base-changed object; clause
3 is the residue, isolated here as the single hypothesis.**

For an arbitrary `k`-scheme `Y`, `Y` is a Galois quotient of its own base change (with
the canonical pullback action) as soon as equivariant morphisms into `Y_{k'}` descend
uniquely. No Picard vocabulary, no curve, no representability: this is a statement
about `Y` alone, which is why it locates the residue rather than restating it.

**Read this as a NEGATIVE result about §2.** It is exactly what stops §2 from being a
converse to the descent theorem: necessity hands over the object, and the universal
property of the quotient still has to be proved for it. The hypothesis below is that
universal property, stated at the identity comparison so that no reader mistakes the
free clauses for the content.

Like §3, this carries **no** `[FiniteDimensional k k']` and **no** `[IsGalois k k']`,
and for the same reason given there: neither `SemilinearGalAction` nor
`IsGaloisQuotient` binds either class. Measured by deleting both and re-elaborating. -/
theorem isGaloisQuotient_pullbackAction_of_uniqueDescent
    (Y : Over (Spec (CommRingCat.of k)))
    (hdesc : ∀ (T : Scheme.{u}) (t : T ⟶ Spec (CommRingCat.of k))
      (h : Limits.pullback t (specMapAlgebra k k') ⟶
        Limits.pullback Y.hom (specMapAlgebra k k')),
      h ≫ pullback.snd Y.hom (specMapAlgebra k k')
          = pullback.snd t (specMapAlgebra k k') →
      (AlgebraicJacobian.GaloisDescent.pullbackSemilinearGalAction k k' t).IsEquivariant
        (AlgebraicJacobian.GaloisDescent.pullbackSemilinearGalAction k k' Y.hom) h →
      ∃! u : {u : T ⟶ Y.left // u ≫ Y.hom = t},
        AlgebraicJacobian.GaloisDescent.pullbackBaseChange k k' Y.hom t u.1 u.2 = h) :
    AlgebraicJacobian.GaloisDescent.IsGaloisQuotient
      (AlgebraicJacobian.GaloisDescent.pullbackSemilinearGalAction k k' Y.hom) Y.hom := by
  refine ⟨Iso.refl _, by simp, by intro γ; simp, ?_⟩
  intro T t h hcomp heq
  simpa using hdesc T t h hcomp heq

/-! ## §5. The descent step with `hlft` deleted — the form a lane should aim at

§3 carried out on the landed theorem. `seamClauseOne_of_isGaloisQuotient_noMatch`
(`Picard/PicEtInvariantMatch.lean`) is the current minimal-input form: `rep`, `hq`,
`hcov`, `hlft`. Below it is again with `hlft` replaced by the `k'`-side condition,
which §3b shows is not a new obligation.

**This is a three-input theorem**, and the three are: the `k'`-side representation
(the campaign's undischarged output, and by §2 a *consequence* of the goal), the
Galois quotient at a glued non-affine `X'` (`G2(c)`), and `hcov`
(`AJC.picrep.etale-rep.hcov`). Nothing else. -/

/-- **Clause (1) of the seam from THREE inputs**, with local finiteness of the
quotient removed in favour of the `k'`-side condition that §3b proves free.

`Scheme.fgaPicardRepresentability` is still untouched: `rep` is the campaign's
undischarged output and clause (1) field 1 is witnessed for no curve. What changed is
the length of the antecedent list a lane must fill. -/
theorem seamClauseOne_of_isGaloisQuotient_lftFree
    [Algebra.IsSeparable k k'] [Module.Finite k k']
    {C : Over (Spec (CommRingCat.of k))}
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {X' : Over (Spec (CommRingCat.of k'))}
    (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')
    {Y : Over (Spec (CommRingCat.of k))}
    (hq : AlgebraicJacobian.GaloisDescent.IsGaloisQuotient
      (semilinearGalActionOfRepresentableBy C rep) Y.hom)
    (hcov : ∀ T : Over (Spec (CommRingCat.of k)), Sieve.generate (Presieve.ofArrows
        (fun _ : k' ≃ₐ[k] k' => (restrictTest k k').obj (baseTest (k' := k') T))
        (fun γ => coverSelfSection T γ)) ∈
      Scheme.etaleTopologyOver k (Limits.pullback (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)))
    (hX' : LocallyOfFiniteType X'.hom) :
    ∃ Z : Over (Spec (CommRingCat.of k)),
      Nonempty ((picEt C).RepresentableBy Z) ∧
        LocallyOfFiniteType Z.hom ∧ IsSeparated Z.hom :=
  seamClauseOne_of_isGaloisQuotient_noMatch rep hq hcov
    (locallyOfFiniteType_of_isGaloisQuotient _ hq hX')

end PicScheme

end Scheme

end AlgebraicGeometry
