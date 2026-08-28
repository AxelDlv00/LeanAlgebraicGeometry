Reconnaissance is complete; I made no edits.

The live Hartshorne tree already contains the zero-locus `iSup`/radical identities, basic-open basis, and both directions of the affine-variety/prime-ideal characterization. The cleanest next theorem is:

```lean
theorem spectrumZeroLocus_isIrreducible_iff_radical_isPrime
    {R : Type*} [CommSemiring R] (I : Ideal R) :
    IsIrreducible (spectrumZeroLocus I) ↔ I.radical.IsPrime := by
  exact PrimeSpectrum.isIrreducible_zeroLocus_iff I
```

I verified this declaration in isolation. Other compiling, low-risk wrappers are `spectrumBasicOpen_pow` from `PrimeSpectrum.basicOpen_pow`, `spectrumBasicOpen_iSup_eq_top_iff` from `PrimeSpectrum.iSup_basicOpen_eq_top_iff`, and set-level spectrum-comap preimage lemmas following `StacksPart01Lib/Spectrum.lean:84-99`.

For a larger Chapter 1 target, spectra of Noetherian rings have `TopologicalSpace.NoetherianSpace.exists_finite_set_isClosed_irreducible` and `finite_irreducibleComponents`; these avoid needing a custom Noetherian instance for `AffinePoint`.
