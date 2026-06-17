# Lean ↔ Blueprint Checker Directive

## Slug
thm32-iter179

## Lean file
AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean

## Blueprint chapter
blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex

## Known issues
- `extend_to_av` body landed this iter (Lane E) as a 6-line block:
  it derives `IsSeparated A.hom` and `LocallyOfFiniteType A.hom` via
  `inferInstance`, then invokes the helper `av_isIntegral_and_codimOneFree f`
  to get `IsIntegral A.left ∧ CodimOneFree f`, then calls
  `extend_of_codimOneFree_of_smooth f hcod`.
- The helper `av_isIntegral_and_codimOneFree` carries a `sorry` body
  consolidating two pieces: (i) Smooth ⟹ IsReduced for schemes over an
  algebraically-closed-field base (Mathlib gap at `b80f227`), and
  (ii) the codim-≥2 indeterminacy half of Milne's Thm 3.2 not unbundled
  from `extend_of_codimOneFree_of_smooth` yet.
- A new import `AlgebraicJacobian.Albanese.CodimOneExtension` was added
  to bring `extend_of_codimOneFree_of_smooth`, `CodimOneFree`,
  `indeterminacyLocus`, `indeterminacy_pure_codim_one_into_grpScheme`
  into scope.
- Verify the blueprint Pin sketch matches the new body's structure; flag if
  the blueprint says something different about how `CodimOneFree` should be
  derived.
