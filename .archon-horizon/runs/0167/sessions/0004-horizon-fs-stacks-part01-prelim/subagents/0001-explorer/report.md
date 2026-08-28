Frontier scan complete; no source edits.

Highest-value ready nodes in `StacksPart01_Preliminaries`:

- **Zariski topology**, Stacks 00E0, node `4025d6b029f4`, 593 unlocks: spectrum emptiness/maximal and minimal primes, `V/D` identities, radicals, unions/intersections, and `D(fg) = D(f) ∩ D(g)`. Likely APIs: `PrimeSpectrum.mem_basicOpen`, `basicOpen_mul/one/zero`, ideal radical APIs.
- **Functoriality of spectrum**, 00E2, node `7a3b94d5bba5`, 430 unlocks: `Spec.comap φ` continuous and inverse image of `D(f)` equals `D(φ f)`. Likely `PrimeSpectrum.continuous_comap` and `comap_basicOpen`.
- **Localization exactness**, 00CS, node `699a091516f3`, 426 unlocks: localization preserves exact sequences. Search around localization maps and flatness APIs.
- **Matrix left inverse**, 07DQ, node `c1d6b91a993a`, 415 unlocks: minors ideal iff existence of `B` with `BA = fI`; likely `Matrix.det_submatrix`, Cauchy-Binet, `Ideal.span`.
- **Universal property for localized modules**, 07K0, node `2386f22ac2fa`, 365 unlocks: `Hom_R(S⁻¹M,N) ≃ Hom_R(M,N)` when `S` acts invertibly on `N`; likely `IsLocalization.lift`.

Secondary tractable node: **Idempotent spec**, 00EC, node `72671055e791`, 327 unlocks: `Spec R = D(e) ⊔ D(1-e)`.

Existing wrappers in `StacksPart01Lib/{Topology,Spectrum,Categories}.lean` are fully proved and contain reusable compactness, spectrum-basic-open, and categorical inverse APIs.
