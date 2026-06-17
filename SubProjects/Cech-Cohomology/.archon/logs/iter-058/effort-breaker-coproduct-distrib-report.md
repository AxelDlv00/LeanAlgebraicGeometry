# Effort Breaker Report

## Slug
coproduct-distrib

## Target
`lem:coproduct_distrib_fibrePower` (`CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso`)

## Status
COMPLETE — the monolithic induction is re-expressed as a `\uses`-linked chain of four
small build-target sub-lemmas plus one new Mathlib anchor; the target's proof is now a short
inductive assembly.

## Effort before → after
- target `effort_local`: 2351 → 2029 (proof body is now assembly only; the hard work is
  carried by the sub-lemmas, not the top node)
- target `effort_total`: 2351 → 4993 (rises as expected — it now sums the sub-lemma cones)
- sub-lemmas added: 4 build-targets + 1 Mathlib anchor (`lem:over_mkIdTerminal_mathlib`, effort 0)

## Chain added (target ← L4 ← L3 ← L2 ← L1)
All in `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`, inserted directly before
the target block (anchor added alongside the other Mathlib anchors near line ~8118).

- `\label{lem:widePullback_overX_eq_prod}` `\lean{CategoryTheory.widePullback_overX_eq_prod}` —
  wide fibre power over `S` = iterated product in `Over S`; gives recursion
  `P^{×_S(p+2)} ≅ P ×_S P^{×_S(p+1)}`. (effort_local ≈ 843)
  `\uses{lem:widePullbackCone_isLimitOfFan_mathlib, lem:over_mkIdTerminal_mathlib}`
- `\label{lem:coproduct_distrib_fibrePower_zero}`
  `\lean{CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso_zero}` — base case
  `p=0`: 1-fold fibre power of `∐ᵢ Xᵢ` is `∐_{σ:Fin 1→ι} X_{σ0} ≅ ∐ᵢ Xᵢ`. (≈578)
  `\uses{lem:widePullback_overX_eq_prod}`
- `\label{lem:prod_coproduct_distrib}`
  `\lean{CategoryTheory.FinitaryPreExtensive.prod_coproduct_distrib}` — one-sided binary
  distributivity in the slice (both sides), the single use of extensivity. (≈679)
  `\uses{lem:isIso_sigmaDesc_map_mathlib}`
- `\label{lem:coproduct_fibrePower_reindex}`
  `\lean{CategoryTheory.FinitaryPreExtensive.coproduct_fibrePower_reindex}` —
  `∐ᵢ∐_τ(Xᵢ×_S Y_τ) ≅ ∐_{(i,τ)} ≅ ∐_{σ:Fin(p+2)→ι}` via `sigmaSigmaIso` + `Fin.cons`
  reindexing, identifying with the `(p+2)`-fold fibre power. (≈864)
  `\uses{lem:sigmaSigmaIso_mathlib}`
- `\label{lem:over_mkIdTerminal_mathlib}` `\lean{CategoryTheory.Over.mkIdTerminal}` `\mathlibok` —
  NEW Mathlib anchor: `Over.mk (𝟙 S)` is terminal in `Over S` (needed by L1). VERIFIED present
  in Mathlib via leansearch (`Mathlib.CategoryTheory.Comma.Over.Basic`). (effort 0)

- Target `lem:coproduct_distrib_fibrePower` proof rewritten:
  `\uses{lem:widePullback_overX_eq_prod, lem:coproduct_distrib_fibrePower_zero,
  lem:prod_coproduct_distrib, lem:coproduct_fibrePower_reindex}`
  (statement-block `\uses` also lists `lem:finitaryExtensive_scheme_mathlib` for the `Scheme`
  instantiation). Statement and `\lean{}` unchanged.

## Conservation check
Every seam the original monolithic proof crossed is covered: slice reformulation → L1; base
case → L2; the inductive step's three moves (binary distributivity on each side → L3;
`sigmaSigmaIso` flatten + `Fin.cons` reindex → L4; recursion `P^{×(p+2)}≅P×_S P^{×(p+1)}` → L1).
No hard step was relabelled away. The four Mathlib anchors named in the directive are preserved
and distributed: `isIso_sigmaDesc_map`→L3, `sigmaSigmaIso`→L4, `widePullbackCone_isLimitOfFan`→L1,
`finitaryExtensive_scheme`→top (instantiation).

## Graph verification
- `archon dag-query node` on all five new labels: present, well-formed.
- `archon dag-query ancestors --node lem:coproduct_distrib_fibrePower`: cone now contains all four
  sub-lemmas + the three relevant anchors + the new `over_mkIdTerminal` anchor.
- `archon dag-query unmatched`: no relevant broken references (our four build-targets show as
  "unmatched" only because their Lean decls don't exist yet — by design; the prover builds them).
- Consumer `lem:cech_backbone_left_sigma` intact.

## Still hard (re-break candidates)
- None flagged. The four leaves are each a single mathematical move (terminal-base limit;
  trivial reindex; specialise binary instance to a singleton; `sigmaSigmaIso` + `Fin.cons`
  reindex). If the prover finds L1 (`widePullback_overX_eq_prod`) heavy — it bundles
  "wide-pullback-over-terminal = product" with the binary recursion split — that is the natural
  next re-break (separate `widePullback ≅ product in Over S` from the `Fin.cons` product
  recursion), but it should be attemptable as one piece first.

## Could not decompose (strategy items)
- None. The target was decomposable exactly along the seams its own proof named.

## References consulted
- `analogies/stub1-scheme-coproduct.md` — Decision A (binary distributivity `isIso_sigmaDesc_map`
  off-the-shelf for `Scheme`), Decision C (`WidePullbackCone.isLimitOfFan`, `sigmaSigmaIso`, wide
  step is the genuine gap). Cited inline in L1/L3/L4 proofs. No external math source (Archon-original
  categorical infrastructure), so no `% SOURCE` lines added, per directive.

## Notes for dispatcher
- `\lean{}` names assigned by convention (need Lean scaffolding by the prover):
  - `CategoryTheory.widePullback_overX_eq_prod` (L1 — general, no `FinitaryPreExtensive`)
  - `CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso_zero` (L2)
  - `CategoryTheory.FinitaryPreExtensive.prod_coproduct_distrib` (L3)
  - `CategoryTheory.FinitaryPreExtensive.coproduct_fibrePower_reindex` (L4)
- New Mathlib anchor `lem:over_mkIdTerminal_mathlib` → `CategoryTheory.Over.mkIdTerminal`
  (`\mathlibok`, verified present). No new macros required; chapter LaTeX balanced.
- Suggested prover order: L1 first (load-bearing, reused by L2 and the top), then L3, L4, L2
  in any order, then the top assembly.
