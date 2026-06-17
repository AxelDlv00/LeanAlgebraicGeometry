# Effort Breaker Report

## Slug
stub1

## Target
`lem:cech_backbone_left_sigma` (`\lean{AlgebraicGeometry.cechBackbone_left_sigma}`) — the geometric
backbone of Sub-brick A.

## Status
COMPLETE — target re-expressed as a `\uses`-linked chain; the single genuine gap is isolated as one
sub-lemma. All blocks edited in `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` only.

## Effort before → after
- target `effort_local`: single opaque block (analogist-scoped ≈250–350 LOC, multi-iter) → **1355**
  (now pure assembly prose; the geometric content moved into the chain). The committed `dag.json`
  predates this lane so an exact "before" number was not recoverable; the point is the heavy content
  is no longer in the target's proof.
- sub-lemmas added: **3 new project sub-lemmas** + **5 Mathlib `\mathlibok` anchors** = 8 new blocks.
- effort is now carried by sub-lemma 2 (`lem:coproduct_distrib_fibrePower`, `effort_local` **2528** —
  the largest in the chain), exactly as the directive intended. The two mechanical pieces are small
  (979 and 1040).

## Chain added (target ← L1, L2, L3)
Inserted immediately before the target block, in dependency order:

- `\label{lem:cechBackbone_obj_widePullback}` `\lean{AlgebraicGeometry.cechBackbone_obj_widePullback}`
  — degree-`p` nerve object `(coverCechNerveOver 𝒰).obj [p]` is the wide pullback
  `widePullback X (fun _:Fin(p+1) => ∐ᵢ Uᵢ) (fun _ => q)`, structure map `WidePullback.base`.
  MECHANICAL (≈30 LOC), `\uses{def:cover_cech_nerve}`. **Prover-ready, independent of L2.** (effort 979)
- `\label{lem:coproduct_distrib_fibrePower}`
  `\lean{CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso}` — for
  `[FinitaryPreExtensive C] [HasPullbacks C]`, `(∐ᵢ Xᵢ)^{×_S (p+1)} ≅ ∐_{σ:Fin(p+1)→ι} (X_{σ0}×_S…×_S X_{σp})`.
  Stated abstractly, instantiated at `Scheme`. **THE genuine Mathlib gap (gap C), multi-cycle build.**
  Proof = induction on `p`, each step `isIso_sigmaDesc_map` (one-sided) + `sigmaSigmaIso` (reindex to σ
  via `Fin.cons`) + `WidePullbackCone.isLimitOfFan` (recast wide pullback over `S` as slice product).
  `\uses{lem:isIso_sigmaDesc_map_mathlib, lem:sigmaSigmaIso_mathlib,
  lem:widePullbackCone_isLimitOfFan_mathlib, lem:finitaryExtensive_scheme_mathlib}`. (effort 2528)
- `\label{lem:widePullback_openImm_inter}` `\lean{AlgebraicGeometry.widePullback_openImm_inter}` —
  the σ-component: `widePullback X (fun k => U_{σk}) (fun k => (U_{σk}).ι) ≅ (coverInterOpen 𝒰 σ).toScheme`
  over `X`, by iterating `isPullback_opens_inf` along `Fin(p+1)`. MECHANICAL (≈50–80 LOC),
  `\uses{def:cech_free_presheaf_complex, lem:isPullback_opens_inf_mathlib}`.
  **Prover-ready, independent of L2.** (effort 1040)
- Target `lem:cech_backbone_left_sigma` proof **rewritten** to assemble L1+L2+L3 in `Over X`
  (structure-map agreement automatic); `\uses{lem:cechBackbone_obj_widePullback,
  lem:coproduct_distrib_fibrePower, lem:widePullback_openImm_inter, def:cover_cech_nerve,
  def:cech_free_presheaf_complex}`. Statement and `\lean{}` unchanged.

### Mathlib `\mathlibok` anchors added (all verified names from the analogy, effort 0)
Appended to the "Mathlib dependency anchors" group near the end of the Sub-brick A section:
- `lem:finitaryExtensive_scheme_mathlib` → `AlgebraicGeometry.instFinitaryExtensiveScheme`
- `lem:isIso_sigmaDesc_map_mathlib` → `CategoryTheory.FinitaryPreExtensive.isIso_sigmaDesc_map`
- `lem:isPullback_opens_inf_mathlib` → `AlgebraicGeometry.isPullback_opens_inf`
- `lem:widePullbackCone_isLimitOfFan_mathlib` → `CategoryTheory.Limits.WidePullbackCone.isLimitOfFan`
- `lem:sigmaSigmaIso_mathlib` → `CategoryTheory.Limits.sigmaSigmaIso`

## Still hard (re-break candidates)
- `lem:coproduct_distrib_fibrePower` — by design the load-bearing piece (≈120–200 LOC, multi-cycle).
  It is one mathematical claim (wide distributivity) and already isolated; **do not re-break further
  this round** (the directive scoped granularity at one level). If a first prover attempt stalls, the
  natural finer cut is: (a) the slice-product reformulation `widePullback over S ≅ ∏ in Over S`, and
  (b) the `Fin.cons` inductive step `P^{×(p+2)} ≅ P ×_S P^{×(p+1)}` with `sigmaSigmaIso` reindex —
  each could become its own sub-lemma. Flag for the dispatcher, not done now.

## Could not decompose (strategy items)
- None. Every gap the original opaque proof crossed is covered by some `L_i`; nothing was relabelled
  away. The hard content is conserved in L2.

## Verification
- `node` query: target now `dep_count=5`, `descendant_count=7`, `effort_local=1355`.
- All 8 new nodes present in the graph; the 3 sub-lemmas resolve their deps; the 5 anchors are
  `mathlib_ok=True, effort=0`.
- `unmatched` verb: 1 pre-existing unmatched node, **none touching this chain** (no broken `\uses`).
- LaTeX balance: `\begin/\end{lemma}` 180/180, `\begin/\end{proof}` 134/134.

## References consulted
- `analogies/stub1-scheme-coproduct.md` — the four-step decomposition (steps 1–4), the verified
  Mathlib citations (decisions A/B/C), and the LOC/effort scoping. Cut along exactly its seams.

## Notes for dispatcher
- `\lean{}` build-target names I assigned (each carries a `% NOTE: build target` line; the prover
  creates the Lean decls): `AlgebraicGeometry.cechBackbone_obj_widePullback`,
  `CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso`,
  `AlgebraicGeometry.widePullback_openImm_inter`. Rename freely if a better convention is preferred —
  none exist in Lean yet.
- **Suggested prover order:** L2 first (the load-bearing lane, attempt as the abstract
  `FinitaryPreExtensive` lemma, instantiate at `Scheme` after). L1 and L3 are mechanical, independent
  of L2, and immediately prover-ready — good parallel/early picks.
- No new macros needed; all notation (`coverInterOpen`, `WidePullback`, `Sigma.desc`, `Over.mk`) is
  already in use in this chapter.
- The 5 Mathlib anchor names are verified in the analogy (read from source); they should compile as
  `\mathlibok` re-exports without an Archon proof obligation.
