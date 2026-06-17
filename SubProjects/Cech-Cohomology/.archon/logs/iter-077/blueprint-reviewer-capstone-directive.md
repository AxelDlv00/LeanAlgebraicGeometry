# Blueprint review — whole blueprint (capstone focus)

Audit the WHOLE blueprint as usual. Extra attention to the Route-A capstone in the
consolidated chapter `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`:

- `lem:cech_computes_cohomology` (`AlgebraicGeometry.cech_computes_higherDirectImage`, ~L11705)
  — the FINAL assembly. Its proof block (~L11770) applies the P4 lemma
  `lem:acyclic_resolution_computes_derived` and asserts "by construction the complex
  `f_* C•` is precisely the relative Čech complex." Assess whether the proof spells out
  the actual Lean-level seams a prover must build, specifically:
  (a) the functor-commutation iso `(f_*).mapHomologicalComplex (cechComplexOnX 𝒰 F) ≅ CechComplex f 𝒰 F`
      (pushforward applied AFTER vs BEFORE the alternating-coface complex — NOT definitional);
  (b) extracting `(e : F ≅ (cechComplexOnX).cycles 0, hexact : ∀ n, ExactAt (n+1))` from
      `cechAugmented_exact` (which is stated as `∀ p, IsZero ((cechAugmentedComplex).homology p)`
      with `cechAugmentedComplex = cechComplexOnX.augment …`);
  (c) the term-structure identification `(cechComplexOnX 𝒰 F).X p ≅ ∏_s (j_s)_*(F|_{U_s})`
      used by `lem:cech_term_pushforward_acyclic`.
  Flag whether these need explicit blueprint sub-lemma blocks (with `\lean{}`/`\uses`) before a
  prover is dispatched, or whether the existing prose is adequate.

- `lem:cech_term_pushforward_acyclic` (`AlgebraicGeometry.cechTerm_pushforward_acyclic`, ~L11634)
  — is its proof detailed enough to formalize directly? (a prover IS being dispatched at it this iter).

Report per-chapter complete/correct verdicts as usual; this gates the prover dispatch.
