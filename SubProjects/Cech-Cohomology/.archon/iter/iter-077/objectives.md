# iter-077 objectives (detail)

Two parallel `prove` lanes on the Route-A capstone (correct hypotheses). Gate: blueprint-reviewer
`fastpath-iter077` PASS. Build-wall: land edits even if exit-137 / timeout; review-build gate verifies.

## Lane 1 — `CechTermAcyclic.lean` (DEEP)
- `rightAcyclic_finite_prod` (L46): finite product/biproduct of right-`G`-acyclic objs is acyclic.
  Additive `G.rightDerived (k+1)` preserves finite biproducts; factors vanish; `Limits.IsZero.pi`.
  Mathlib: `PreservesFiniteBiproducts`/`Functor.mapBiproduct` [expected]. Abstract — no project deps.
- `cechTerm_pushforward_acyclic` (L72): the genuinely deep one. `pushPull_sigma_iso` product decomp →
  `rightAcyclic_finite_prod` to single factor `(j_s)_*(F|_{U_s})` → `higher_direct_image_openImmersion_comp`
  + `higherDirectImage_openImmersion_acyclic` + `affine_serre_vanishing`. Sketch: blueprint
  `lem:cech_term_pushforward_acyclic` proof (~L11670). May not close in one pass → hand off the precise
  stuck seam. If it stalls next iter → `[prover-mode: fine-grained]` / effort-break.

## Lane 2 — `CechToHigherDirectImage.lean` (seams + assembly; NOT blocked on Lane 1)
- `pushforward_mapHomologicalComplex_cechComplexOnX` (L60): `f_*` additive ⇒ commutes with alt-coface
  complex; differential via `Functor.map_sum`; build iso degreewise. Check Mathlib for
  `mapHomologicalComplex ∘ alternatingCofaceMapComplex` naturality first.
- `cechAugmented_to_acyclicResolutionInput` (L91): from `cechAugmented_exact` → augment index-shift gives
  `ExactAt (n+1)`; degree-0/1 vanishing gives `ε` mono + `im ε = ker d⁰` ⇒ `e : F ≅ cycles 0`. Return `⟨e,hexact⟩`.
- `cech_computes_higherDirectImage_of_affineCover` (L140): combine seam(a)+seam(b)+P4
  `rightDerivedIsoOfAcyclicResolution`; supply termwise acyclicity from `cechTerm_pushforward_acyclic`
  (black-box, even while sorry in Lane 1); rewrite RHS by seam(a); wrap `Nonempty`. Needs
  `(pushforward f).Additive` + `PreservesFiniteLimits (pushforward f)` instances. Sketch: blueprint
  `lem:cech_computes_cohomology_affineCover` (~L11966).

## Not dispatched
- `CechHigherDirectImage.lean:780` — frozen, mathematically false; user-owned; documented `sorry`.
