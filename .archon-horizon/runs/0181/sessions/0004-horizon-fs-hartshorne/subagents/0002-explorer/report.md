Read-only scout complete; no project files were edited.

Recommended formalization order:

1. `lem:II-2-1` (`f402a204448e`, READY): source at `blueprint/src/ch02-schemes.tex:94-106`. Existing compiled wrappers in `HartshorneLib/Chapter1Spectrum.lean` exactly cover the three identities:
   - `spectrumZeroLocus_mul`
   - `spectrumZeroLocus_iSup`
   - `spectrumZeroLocus_eq_iff`

2. II.2.2 affine structure sheaf (`ch02-schemes.tex:108-131`): compile-tested wrappers around Mathlib:
   - `StructureSheaf.stalkIso R p`
   - `IsLocalization.algEquiv (Submonoid.powers f) _ _`
   - `StructureSheaf.globalSectionsIso R`

3. II.2.3 affine morphisms (`ch02-schemes.tex:142-156`): compile-tested `Spec.homEquiv`, with `Spec.map_injective` and `Spec.map_surjective`.

`def:II-1-presheaf` is technically READY but a bare Mathlib presheaf omits Hartshorne’s `F(∅)=0` axiom; `def:II-1-stalk` and subsequent spectrum nodes are blocked. Blueprint files are frozen under protections I-2034/I-2035.
