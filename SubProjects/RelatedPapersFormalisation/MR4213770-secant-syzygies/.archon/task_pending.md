# Index
<!-- One line per file. Update line numbers when the file changes. -->

- `Foundations.lean` (iter-016 ACTIVE) — Core-2 affine-reduction chain (effort-broken iter-016 from
  `found:isLocallyFree_kernel_of_shortExact` = Hartshorne III Ex 6.5; the bespoke `Scheme.Modules.IsLocallyFree`
  is KEPT — a mathlib-analogist `SheafOfModules.IsLocallyFree` ALIGN claim was FABRICATED, grep-disproven).
  mathlib-build, lead "Scaffold", deps all done, HARD GATE GREEN (blueprint-reviewer r16). Build the 3
  READY bottom sub-lemmas (mutually independent):
  • L2 `Scheme.Modules.kernel_module_free_on_basicOpen_cover` (`lem:module_kernel_free_basicOpen_cover`):
    module SES `0→K→R^m→R^n→0` ⇒ K f.p. projective ⇒ free on basic-open cover of Spec R. Anchors
    [verified]: `splittingOfProjective`, `Module.Projective.of_split/of_free`, `Module.freeLocus`,
    `isOpen_freeLocus`, `freeLocus_eq_univ_iff`, `basicOpen_subset_freeLocus_iff`. MUST supply
    `Module.FinitePresentation R K` (f.g.+projective⇒f.p.) before the freeLocus lemmas.
  • L3 `Scheme.Modules.kernel_iso_tilde_of_free_ses_affine` (`lem:kernel_iso_tilde_affine`): free SES of
    `(Spec R).Modules` is `tilde` of an R-module SES, `𝒦≅tilde K`. Anchors [verified]:
    `AlgebraicGeometry.{tilde, tildeFinsupp, tilde.fullyFaithfulFunctor}`. Reflect epi via tilde
    conservative.
  • L1 `Scheme.Modules.isLocallyFree_of_isLocallyFree_cover` (`lem:isLocallyFree_local`): loc-freeness is
    local on the base. `\uses{found:locally_free, found:locally_free_of_iso}`. Needs restrict-restrict iso.
  DO-NOT-USE (FABRICATED, absent in Mathlib v4.30.0): `SheafOfModules.IsLocallyFree`, `IsLocallyFreeData`,
  `ModuleCat.Tilde.stalkIso`, `tildeInModuleCat`, `ModuleCat.tilde{,Finsupp}` (real names in `AlgebraicGeometry`).

- DEFERRED — Core-2 chain TIP (gated on L2+L3): L4 `lem:isLocallyFree_kernel_on_affine`, target
  `found:isLocallyFree_kernel_of_shortExact`, `found:rank_kernel_of_shortExact`,
  `found:eval_kernel_locally_free`; then `MR4213770.kernelBundle_isLocallyFree`
  (`lem:kemeny_kernel_bundle_locally_free`, Basic.lean) waits on the whole chain. Assemble next iter once
  L2/L3 land. L2/L4 are content-heavy (effort 914/943) → re-break finely if the prover stalls.

- DEFERRED (substrate absent, P2/P3 arc) — `def:kemeny_LM_bundle` (E), `lem:kemeny_grassmann_pencil_map`,
  `lem:kemeny_BNP_gen`: "ready" on the frontier but `\uses` UNDER-DECLARES the true deps (K3 Picard-rank-one
  lattice, curve inclusion i:C↪X, g^1_{k+1} pencils, pushforward i_*A, Brill–Noether W^1, the Grassmannian)
  — none blueprinted. Their `opaque` stubs in Basic.lean stay. Do NOT dispatch a formalize prover (fake
  statements — HARD GATE forbids). `def:kemeny_koszul_cohomology` waits on line-bundle tensor powers `L^q`
  + Koszul differentials (later substrate lane).
