# Effort Breaker Report

## Slug
fbc-step3

## Target
`lem:base_change_mate_fstar_reindex_legs` (`AlgebraicGeometry.base_change_mate_fstar_reindex_legs`,
in `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`)

## Status
COMPLETE — the unmoved step-(iii) "mate-unwinding crux" is re-expressed as a five-link
`\uses`-chain; target proof rewritten to "by (iii-1)…(iii-5)". Statement and `\lean{}` unchanged.

## Effort before → after
- target `effort_local`: 2253 → 2790 (see note: this metric *rose* because the five children are
  not yet formalized; it does not mean the break failed — each child is strictly smaller, below).
- sub-lemmas added: 5 (all new frontier-ready pieces).

The meaningful reduction is per-piece: the monolithic 2253-effort `sorry` is now five separately
formalizable goals, the largest of which is 1657 (eCancel) — every piece is smaller than the
original, and four of the five are ≤ 941. The `effort_local` heuristic on the *target* counts its
unproven dependency fanout, so it inflates until the children get `\leanok`; the relevant signal for
"did breaking help" is the per-child effort, which dropped.

## Chain added (target ← iii-5 ← iii-4 ← iii-3 ← iii-2 ← iii-1)
All in `chapters/Cohomology_FlatBaseChange.tex`, namespace `AlgebraicGeometry`, no `\leanok`
(sync's job), no `% SOURCE` (Archon-original mate calculus, per directive).

- `lem:base_change_mate_fstar_reindex_legs_unitExpand` (effort 941, deps 1) — invert the
  comp-coherence: the bare `(g')`-unit `η^{g'}_{M̃}` expands as the 4-factor composite
  `η^{Spec ιA} ∘ (Spec ιA)_*(η^e) ∘ pushforwardComp(e,Spec ιA).hom ∘ g'_*(pullbackComp(e,Spec ιA).hom)`.
  `\uses{lem:pullbackPushforward_unit_comp}`.
- `lem:base_change_mate_fstar_reindex_legs_gammaDistribute` (effort 355, deps 1) — distribute that
  expansion through `(Spec φ)_*` and `Γ` (functoriality → four Γ-image factors).
  `\uses{…_unitExpand}`.
- `lem:base_change_mate_fstar_reindex_legs_eCancel` (effort 1657, deps 4) — **the load-bearing
  telescoping.** The two `e`-factors `(Spec ιA)_*(η^e)` and `g'_*(pullbackComp(e,Spec ιA).hom)`,
  plus the surviving step-(ii) `pushforwardComp(g',Spec φ).hom` (Γ-image = id), cancel against the
  three `e`-pieces built into `base_change_mate_codomain_read_legs`
  (`pullbackComp(e,ιA).inv` in `iso_g`, `(η^e)^{-1}` in `unit_iso⁻¹`,
  `pushforwardComp(e,ιR').inv`), leaving only the affine `(Spec ιA)`-unit over the affine codomain
  remnant. `\uses{…_gammaDistribute, lem:base_change_mate_codomain_read_legs,
  lem:pullback_isEquivalence_of_iso, lem:gammaMap_pushforwardComp_hom_eq_id}`.
- `lem:base_change_mate_fstar_reindex_legs_affineUnit` (effort 849, deps 3) — the surviving affine
  unit, pushed by `(Spec φ)_*` and read over `Spec R`, equals `restr_φ(η_M)` (Seam 1 + pushforward
  dictionary). `\uses{lem:base_change_mate_unit_value, lem:pushforward_spec_tilde_iso, …_eCancel}`.
- `lem:base_change_mate_fstar_reindex_legs_innerMatch` (effort 927, deps 3) — `restr_ψ` of
  `restr_φ(η_M)` transported across `ιA∘φ = ιR'∘ψ` is, by definitional unfolding, `ρ`.
  `\uses{def:base_change_mate_inner_value, lem:base_change_mate_unit_value, …_affineUnit}`.
- Target `lem:base_change_mate_fstar_reindex_legs` proof rewritten to "(i) subst legs → (ii)
  Γ-collapse → (iii) the five-link chain". Statement-block and proof-block `\uses{}` both updated to
  include the five new labels (proof drops `lem:pullbackPushforward_unit_comp` /
  `lem:base_change_mate_unit_value` / `def:base_change_mate_inner_value` as *direct* deps since they
  are now reached transitively through the chain; statement-block retains them).

## Still hard (re-break candidates)
- `lem:base_change_mate_fstar_reindex_legs_eCancel` — effort 1657, still the largest piece and the
  genuine mathematical crux (three simultaneous coherence cancellations against the internals of the
  codomain read). If the fine-grained prover cannot close it from the prose, **re-dispatch the
  breaker on this lemma alone** at sentence granularity: natural sub-cuts are one named lemma per
  cancellation — (a) `(Spec ιA)_*(η^e)` vs `unit_iso⁻¹`; (b) `g'_*(pullbackComp.hom)` vs
  `pullbackComp.inv` in `iso_g`; (c) the two `pushforwardComp` re-association factors — each an
  isomorphism-inverse cancellation that should be a few moves once isolated. I did not pre-cut these
  because the directive asked for the five-way split first; doing (a)/(b)/(c) now would risk
  guessing the exact internal composite of `base_change_mate_codomain_read_legs` wrong.

## Could not decompose (strategy items)
- None. The mathematics is conserved: every gap the original step-(iii) crossed is covered by one of
  the five links (unit expansion → Γ-distribution → e-cancellation → Seam-1 value → inner-value
  match), and the existing step-(i)/(ii) scaffold in the Lean proof already aligns with links'
  entry point.

## References consulted
- None external. Per directive this is the project's own adjoint-mate calculus over the proved
  change-of-rings dictionaries; no `% SOURCE`/`% SOURCE QUOTE` lines were added (correct — these
  blocks are Archon-original). Internal anchors read: `base_change_mate_codomain_read_legs` (Lean
  body, lines 1210–1258), `pullbackPushforward_unit_comp` (Lean, 1144–1161),
  `base_change_mate_inner_value` (Lean, 1102–1133), and the current `sorry` scaffold of the target
  (Lean, 1297–1347), to keep the cut faithful to the iter-018 prover's established structure.

## Notes for dispatcher
- `\lean{}` names assigned by convention (confirm/scaffold in PROGRESS.md for the fine-grained
  prover), all under `AlgebraicGeometry`:
  - `base_change_mate_fstar_reindex_legs_unitExpand`
  - `base_change_mate_fstar_reindex_legs_gammaDistribute`
  - `base_change_mate_fstar_reindex_legs_eCancel`
  - `base_change_mate_fstar_reindex_legs_affineUnit`
  - `base_change_mate_fstar_reindex_legs_innerMatch`
- None of these names currently exist in `AlgebraicJacobian/` (checked) — all are new obligations.
- Prover ordering: formalize bottom-up (unitExpand → gammaDistribute → eCancel → affineUnit →
  innerMatch), then close the target by chaining. The (i)/(ii) scaffold + literal `key` are already
  in place at the target's `sorry` (FlatBaseChange.lean:1347); unitExpand is precisely the "invert
  `key`" move described in that file's comment block (lines 1329–1346), so it should land quickly.
- No new macros needed; all notation (`pushforwardComp`, `pullbackComp`, `Γ`, `restr`/`ext`, `η^h`)
  is already in the chapter.
- Verified: chapter LaTeX environments balanced (lemma 46/46, proof 40/40, enumerate 4/4), no broken
  `\uses` (`archon dag-query gaps` count 0), all five nodes present in the graph.
