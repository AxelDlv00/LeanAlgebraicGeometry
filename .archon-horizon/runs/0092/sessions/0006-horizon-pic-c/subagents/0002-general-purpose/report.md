Read-only survey of the Lean project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (AJCR). Do NOT edit any file. Report declaration names with file:line and exact statements including all binders and instance arguments.

I need to know exactly what is landed for this chain, over a FIELD K (relCurve C K):

STEP A. From `2 ≤ Sheaf.h0 (divisorSheaf K W)` for an effective CurveDivisor W, produce TWO DISTINCT effective divisors W1 ≠ W2 with `picClass K W1 = picClass K W2` (both of the same degree). Look in AlgebraicJacobian/RiemannRoch/ (EffectiveUniqueness.lean, SectionBound.lean, ClassCohomology.lean, DivisorSheaf*.lean, Degree.lean, FLVClass.lean) and anywhere else. Specifically:
 - what is the exact statement of `Scheme.CurveDivisor.eq_of_picClass_eq_of_h0_one` (RiemannRoch/EffectiveUniqueness.lean:144)?
 - what is `exists_effective_of_h0_pos` (RiemannRoch/SectionBound.lean:175)?
 - is there ANY declaration producing two distinct effective divisors, or the divisor-of-zeros of a section (names like divisorOfSection, zeroDivisor, ofSection, sectionDivisor, exists_ne, not_subsingleton)? Is there a map from H^0 sections to effective divisors at all?
 - is there any statement of the form `h0 = 1 ↔ ...uniqueness...`, or a contrapositive `1 < h0 → ∃ D1 ≠ D2`?

STEP B. Two distinct effective degree-n divisors over K with equal picClass -> two DISTINCT elements of `DivFam C K π n` with equal `abelDiv`/`chartValue`. Relevant: `divFamFieldEquiv` (Picard/DivisorFamilyFieldSurj.lean:162), `divFamDivisor`, `divFamDivisor_injective` (Picard/DivisorFamilyFieldEquiv.lean:177), `picClass_divFamDivisor` (Picard/DivisorFamilyH1Locus.lean:130), `abelDiv_val`, `abelDiv` definition. Give exact statements. Is `abelDiv` (or chartValue) a function of the picClass of `divFamDivisor` only? Which lemma says so?

STEP C. `DivFam.toZar : DivFam C R π n -> DivFamZar C R π n` (Picard/DivisorFamilyZar.lean:272). Is there any INJECTIVITY statement for `toZar`, over a field or in general? Look for toZar_injective, toZar_eq_iff, divEq_of_divEqZar, or a characterization of `divFamZarSetoid` vs `divFamSetoid`. Report whether injectivity of toZar over a field is landed, refuted, or absent.

STEP D. What exactly does `not_isChartLocusFibre_of_divFamZar` (Picard/Pic0ChartAbelNonInjective.lean) state, with full binders? And `not_injective_abelSigmaChart_of_points`? And is there a version concluding `¬ IsOpenImmersion.presheaf (abelSigmaChart ...)` or `¬ Mono`?

STEP E. `exists_uniform_admissibleCoverageChart_two_le_h0` (Picard/Pic0ChartLocusH0Rank.lean:195) — exact statement with all binders, and exactly what the produced witness contains (what is W, what is its degree, what is its class, over which field).

Be precise and exhaustive on names; state clearly when something is ABSENT and list the search patterns you used.
