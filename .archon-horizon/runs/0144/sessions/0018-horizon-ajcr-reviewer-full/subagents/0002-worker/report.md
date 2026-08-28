Audit complete. No canonical `PicRankOneEvaluationDivisorData` inhabitant or `rankOneAbelIso` proof is currently constructible.

The existing canonical divisor APIs are affine-only:

- `canonicalRankOneDivisor` requires a Noetherian presentation carrier.
- `canonicalRankOneDivisorOfMem` removes that condition but requires the additional equality `hpi : pi ≫ P1.structureMap k = C.hom`.
- Both return `DivFamZarAff` over an affine algebra, not the required natural transformation `rankOneLocus ⟶ rankOneDivisorLocus`.

The missing obligation is a family-level canonical divisor classifier, including arbitrary affine base-change naturality, presentation-independence, and extension from affine tests to the Sigma/big-site presheaf. No protected files were modified, and the temporary scratch probe was removed.
