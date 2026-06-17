# Effort-breaker directive — split Stub 1 `lem:cech_backbone_left_sigma`

Edit ONLY `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.

## Target
`lem:cech_backbone_left_sigma` (line ~7511, `\lean{AlgebraicGeometry.cechBackbone_left_sigma}`) — the
geometric backbone of Sub-brick A. It is the single hardest leaf of the augmented-Čech-resolution lane
and is currently one opaque block; a prover attempt at it as one task is explicitly ruled out (the
mathlib-analogist scoped it at ≈250–350 LOC, multi-iter). Split it into a `\uses`-linked chain so the
prover can formalize small pieces, with the genuinely hard piece isolated.

## Granularity
One level — the four sub-lemmas named in `## Proof structure` below. (This matches the analogist's
decomposition; do not over-split further this round.)

## Proof structure (from `analogies/stub1-scheme-coproduct.md`, verified Mathlib citations)
The claim: in `Over X`, the degree-`p` Čech-nerve object of the cover arrow
`q = Sigma.desc 𝒰.f : ∐ᵢ Uᵢ → X` (the `(p+1)`-fold fibre power of `q` over `X`) is isomorphic to
`∐_{σ : Fin (p+1) → 𝒰.I₀} coverInterOpen 𝒰 σ`, structure maps matching. KEY background facts (already
in Mathlib — cite them as `\mathlibok` anchors or in prose `\uses`, your call, but the names are verified):
`Scheme` is `FinitaryExtensive` (`AlgebraicGeometry.instFinitaryExtensiveScheme`); binary distributivity
`(∐X)×_S Y ≅ ∐ᵢ(Xᵢ×_S Y)` is `CategoryTheory.FinitaryPreExtensive.isIso_sigmaDesc_map`
(`Mathlib/CategoryTheory/Extensive.lean:568`); open-immersion pullback = intersection is
`AlgebraicGeometry.isPullback_opens_inf` (`Restrict.lean:548`); wide-pullback-over-terminal = product is
`CategoryTheory.Limits.WidePullbackCone.isLimitOfFan`; coproduct reindexing is
`CategoryTheory.Limits.sigmaSigmaIso`.

Create these four `\uses`-linked sub-lemma blocks (new `\label`s + build-target `\lean{}` names the
prover will create; add a `% NOTE: build target` line on each since the Lean decls do not exist yet):

1. **`lem:cechBackbone_obj_widePullback`** (≈30 LOC, MECHANICAL, INDEPENDENT) — unfold
   `coverCechNerveOver`/`augmentedCechNerve`/`Arrow.cechNerve` to expose the degree-`p` object as the
   wide pullback `widePullback X (fun _ : Fin (p+1) => ∐ᵢ Uᵢ) (fun _ => q)`, with structure map
   `WidePullback.base`. `\uses{}` the relevant `coverCechNerve`/nerve definitions.

2. **`lem:coproduct_distrib_fibrePower`** (≈120–200 LOC, HARD, LOAD-BEARING — the genuine gap C) — for
   `[FinitaryPreExtensive C] [HasPullbacks C]`, the wide fibre power of a coproduct
   `(∐ᵢ Xᵢ)^{×_S (p+1)}` is `∐_{σ : Fin(p+1)→ι} (X_{σ 0} ×_S ⋯ ×_S X_{σ p})`. Proof: induction on `p`,
   each step `isIso_sigmaDesc_map` (one-sided distributivity, second family a singleton) +
   `sigmaSigmaIso` to reindex to `σ`, recasting the wide pullback over `X` as an iterated product in
   `Over X` via `WidePullbackCone.isLimitOfFan` (terminal base). **State it abstractly for
   `FinitaryPreExtensive C`** (reusable, Mathlib-aligned — avoids a Scheme-only parallel API), then
   instantiate at `Scheme`. Note in the block that this is a multi-cycle build on its own.

3. **`lem:widePullback_openImm_inter`** (≈50–80 LOC, MECHANICAL, INDEPENDENT of 2) — the σ-component:
   `widePullback X (fun k => U_{σ k}) (fun k => (U_{σ k}).ι) ≅ (coverInterOpen 𝒰 σ).toScheme` over `X`,
   by iterating `isPullback_opens_inf` along `Fin (p+1)` (`⨅ₖ` is the `coverInterOpen` definition).
   `\uses{}` `isPullback_opens_inf` (anchor) + the `coverInterOpen` def.

4. **`lem:cechBackbone_left_sigma`** (the EXISTING target, ≈40 LOC assembly) — repoint its proof to
   assemble 1+2+3 in `Over X`; the structure-map agreement is automatic. Update its `\uses{}` to
   `{lem:cechBackbone_obj_widePullback, lem:coproduct_distrib_fibrePower, lem:widePullback_openImm_inter}`
   (keep any still-relevant existing refs). Keep its `\lean{AlgebraicGeometry.cechBackbone_left_sigma}`.

After the split, `lem:cech_backbone_left_sigma`'s effort should be carried by sub-lemma 2; sub-lemmas
1 and 3 are immediately prover-ready and independent of 2. Do not touch any other block.
