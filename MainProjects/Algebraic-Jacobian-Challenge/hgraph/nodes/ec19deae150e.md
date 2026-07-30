---
author: sync
content_type: theorem
created: '2026-07-31T02:29:40'
decl: AlgebraicGeometry.Scheme.PicScheme.locallyOfFiniteType_of_isGaloisQuotient
docstring: '**Local finiteness of the quotient is free from the `k''`-side.**


  From the bundled `IsGaloisQuotient` — nothing else — plus

  `LocallyOfFiniteType X''.hom`. Two steps: the quotient''s `e` and `he` say `X''.hom`

  *is* `pullback.snd Y.hom (specMapAlgebra k k'')` up to a composition with an

  isomorphism, hence that projection is locally of finite type; and

  `locallyOfFiniteType_of_baseChange` (Mathlib''s

  `DescendsAlong @LocallyOfFiniteType (@Surjective ⊓ @Flat ⊓ @QuasiCompact)`) descends

  it to `Y.hom`.


  **So `hlft` is not a fourth obligation.** A lane closing the descent step should
  call

  `seamClauseOne_of_isGaloisQuotient_lftFree` below, which asks for the `k''`-side

  condition instead — and §3b shows *that* condition is itself free from the `k`-side

  one, so nothing here has been relocated into a new hypothesis.


  **Note the binder set, because the first draft of this lemma got it wrong in the

  expensive direction.** It carried `[FiniteDimensional k k'']` and `[IsGalois k k'']`,
  on

  the reading that `IsGaloisQuotient` needs them. It does not, and the reason is

  sharper than "they come from elsewhere": `AlgebraicJacobian.GaloisDescent.SemilinearGalAction`

  itself is declared under `variable (K L) [Field K] [Field L] [Algebra K L]` with
  **no**

  Galois or finiteness binder, and `IsGaloisQuotient` adds none — so the word "Galois"
  in

  both names is about the *intended* application, not about a hypothesis either carries.

  (A first revision of this paragraph said the action "carries the Galois binders
  itself";

  that is false, checked at the `variable` line, and it is the kind of plausible reason

  that would have kept the trap alive.) Both are deleted here and the statement

  re-elaborates (`lake env lean`, `EXIT=0`). Same double-count as

  `Picard/PicEtSeparated.lean`''s field-2 theorem and the seam docstring''s input
  2: treat

  a Galois binder on a descent-side lemma as unproven until checked without it.'
file: AlgebraicJacobian/Picard/PicEtDescentNecessity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.locallyOfFiniteType_of_isGaloisQuotient
type: lean
updated: '2026-07-31T02:29:40'
---
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