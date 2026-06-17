Target: blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex (only this chapter)

Context: P5b Route-A capstone. The frozen `lem:cech_computes_cohomology` proof glosses two
non-definitional Lean seams as "by construction." Add the missing sub-lemmas + an aux theorem
stating the TRUE (correctly-hypothesised) form. Place new blocks adjacent to
`lem:cech_computes_cohomology` (~L11705). All four below are project-bespoke (no external source —
omit SOURCE lines); the aux theorem reuses the existing Stacks 02KE quote.

Actions:
1. Add seam (a) `\begin{lemma}` `\label{lem:pushforward_mapHC_cechComplexOnX}`
   `\lean{AlgebraicGeometry.pushforward_mapHomologicalComplex_cechComplexOnX}`
   `\uses{def:cech_complex_on_X, def:cech_complex}`. Statement: a canonical iso of cochain
   complexes in `S.Modules`, `(pushforward f).mapHomologicalComplex (cechComplexOnX 𝒰 F) ≅
   CechComplex f 𝒰 F`. Proof: `f_*` is additive, so it commutes past the alternating-coface-map
   complex functor — the degree-`p` differential `f_*(∑_j (-1)^j δ_j) = ∑_j (-1)^j f_*(δ_j)` by
   `map_sum`/`map_zsmul`/`map_neg`; assemble degreewise identities into a complex iso.

2. Add seam (b) `\begin{lemma}` `\label{lem:cechAugmented_to_acyclicResolutionInput}`
   `\lean{AlgebraicGeometry.cechAugmented_to_acyclicResolutionInput}`
   `\uses{lem:cech_augmented_resolution, def:cech_complex_on_X, def:cech_augmented_complex}`.
   Statement: from `cechAugmented_exact` (∀ p, `IsZero ((cechAugmentedComplex 𝒰 F).homology p)`)
   extract `e : F ≅ (cechComplexOnX 𝒰 F).cycles 0` and `hexact : ∀ n,
   (cechComplexOnX 𝒰 F).ExactAt (n+1)`. Proof: the augmented complex is `cechComplexOnX.augment ε`,
   so its homology at `p = n+2` is the dropped complex's homology at `n+1` (augment index shift) ⇒
   `hexact`; homology vanishing at `p=0` makes `ε : F → C⁰` a mono (kernel zero), at `p=1` makes it
   epi onto `cycles 0`, together an iso `F ≅ cycles 0`.

3. Edit `lem:cech_term_pushforward_acyclic` (statement + proof `\uses`): add `lem:pushPull_sigma_iso`
   (term-structure identification `(cechComplexOnX).X p ≅ ∏_s (j_s)_*(F|_{U_s})`). Add a dependency
   for "a finite product of right-`f_*`-acyclic objects is right-`f_*`-acyclic": add a short block
   `\label{lem:rightAcyclic_finite_prod}` (project lemma; if Mathlib provides it via
   `Functor.rightDerived` commuting with finite biproducts, the prover/review will mark `\mathlibok`)
   and cite it in cechTerm's `\uses`.

4. Add aux theorem `\begin{lemma}[Čech computes higher direct images — affine-cover form]`
   `\label{lem:cech_computes_cohomology_affineCover}`
   `\lean{AlgebraicGeometry.cech_computes_higherDirectImage_of_affineCover}`
   `\uses{lem:cech_augmented_resolution, lem:cech_term_pushforward_acyclic,
   lem:acyclic_resolution_computes_derived, lem:pushforward_mapHC_cechComplexOnX,
   lem:cechAugmented_to_acyclicResolutionInput, def:cech_complex, def:higher_direct_image}`.
   Statement: identical conclusion to `lem:cech_computes_cohomology` but with EXPLICIT hypotheses
   `(h𝒰 : ∀ i, IsAffine (𝒰.X i))` and `[X.IsSeparated]` added (the genuine Stacks 02KE form). Proof:
   the assembly — seam (b) gives `(e, hexact)`; `lem:cech_term_pushforward_acyclic` gives the termwise
   acyclicity instance; apply `lem:acyclic_resolution_computes_derived` with `G = f_*`,
   `K = cechComplexOnX 𝒰 F`; rewrite the result's complex via seam (a) to `CechComplex f 𝒰 F` and the
   derived functor to `higherDirectImage`; take `Nonempty`. In the prose note that the frozen
   `lem:cech_computes_cohomology` is the SAME statement whose Lean signature currently omits
   `h𝒰`/`[X.IsSeparated]` (false without them — single-element-cover counterexample); once the
   mathematician adds them its body reduces to this lemma.

5. Add `% archon:covers AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean` to the covers block.

Constraints: math-only prose, no Lean tactic strings. Do NOT add/remove `\leanok` (sync owns it).
`\mathlibok` only on genuine Mathlib anchors. Define any new macro in macros/common.tex before use.
Stay within this one chapter.
