Read-only scout complete; no source edits.

Highest-value ready nodes:

1. `schemes-lemma-composition-immersion` (Tag 02V0), open-immersion case  
   File: [`StacksPart02Lib/OpenImmersion.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part02_Schemes/StacksPart02Lib/OpenImmersion.lean)  
   Add a wrapper for `[IsOpenImmersion f] [IsOpenImmersion g] -> IsOpenImmersion (f ≫ g)`; proof is `infer_instance`. Mathlib provides `AlgebraicGeometry.IsOpenImmersion.comp` at `OpenImmersion.lean:40`.

2. `schemes-lemma-fibre-product-immersion` (Tag 01JU), open case  
   Same file or a pullback module. For `[IsOpenImmersion f]`, prove `IsOpenImmersion (Scheme.pullback.fst g f)` by `infer_instance`. Mathlib has the exact base-change instance at `OpenImmersion.lean:547`; this node has four downstream consumers.

3. Pullback range consequence  
   Expose Mathlib’s `AlgebraicGeometry.IsOpenImmersion.range_pullbackFst` (`OpenImmersion.lean:592`), yielding  
   `Set.range (pullback.fst g f) = g ⁻¹ᵁ f.opensRange`.

The prior Tag 01I3 standard-open-affine and Tag 01IW two-affines work are already present and kernel-checked in [`AffineOpens.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part02_Schemes/StacksPart02Lib/AffineOpens.lean). I also sent these findings through the Horizon inbox.
