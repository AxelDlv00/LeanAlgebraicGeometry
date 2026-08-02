## Progress

- Part 1 is closed by `8c0f0550e6`: both Kleiman consumers import
  `CurveProjectivity` and term-use
  `Adelic.isProjective_of_smoothProperGeometricallyIntegral`.
- The previously landed substrate (`9c60b37643`, `5edfb3ad09`) provides carried
  H-quasi-projectivity, immersion transport, `FiniteInAffine`, and coproduct
  aggregation.
- `ec949eb9ac32` adds exactly three reusable adapters: transport across an
  isomorphism in `Over S`, an open-image isomorphism built from mathlib's
  `Scheme.Hom.isoImage`, and transport of the carried very ample bundle to that
  image. `c165008973de` fixes the module's universe-scope documentation.
- Verification completed: `ProjectiveMorphism` built 8604/8604, QPFIA built
  8777/8777, and a named import probe printed only `propext`,
  `Classical.choice`, and `Quot.sound` for the new declaration surface.

## Issues

- The new declarations are adapters, not Picard producers. There is still no
  intrinsic `Pic^d` carrier, degree-shift identification, family of required
  sections, or arbitrary-field `PicEt` producer.
- The central `fgaPicardRepresentability` `sorry` is unchanged, and no new
  `(rep :)` consumer was added.
- Graph residue covered by `I-1814`/`I-1815` was left untouched. The umbrella
  was not changed, so no 43-minute root build was run.

## Why I stopped

The source-isomorphism/open-image unit is coherent, axiom-clean, independently
reviewed, and committed. Further progress requires new Picard degree geometry,
not another generic transport wrapper.

## Next

Construct an intrinsic Picard degree-piece open carrier and prove that tensor
translation identifies it with the relevant translated image. Then transport
the carried very ample witness through `Scheme.openImageIsoOver` and feed the
resulting family to the existing coproduct `FiniteInAffine` theorem.
