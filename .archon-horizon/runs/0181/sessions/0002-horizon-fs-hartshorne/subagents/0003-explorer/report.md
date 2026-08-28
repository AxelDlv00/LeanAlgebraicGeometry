Reconnaissance complete; no files were modified.

The highest-value small target is Hartshorne’s Chapter II.2.1 spectrum-closed-set lemma:

- Blueprint: [`blueprint/src/ch02-schemes.tex:94`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/blueprint/src/ch02-schemes.tex:94)
- Existing wrappers: [`HartshorneLib/Chapter1Spectrum.lean:45`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter1Spectrum.lean:45)
- Already present: product, binary sup/intersection, and radical invariance.
- Missing tiny wrappers:
  - `spectrumZeroLocus_iSup`, proved by `PrimeSpectrum.zeroLocus_iSup`
  - `spectrumZeroLocus_eq_iff`, proved by `PrimeSpectrum.zeroLocus_eq_iff`

Both statements were compiled successfully in isolation. A useful supporting wrapper is the basic-open basis theorem after line 76, using `PrimeSpectrum.isTopologicalBasis_basic_opens`.

The frontier output is largely stale metadata: polynomial evaluation and irreducibility appear as frontier items, but their Lean implementations already exist. All current Hartshorne Lean files contain zero `sorry`/`axiom` hits; the local graph reports 99 Lean nodes as `lean_ok` while many TeX nodes remain marked `empty`.
