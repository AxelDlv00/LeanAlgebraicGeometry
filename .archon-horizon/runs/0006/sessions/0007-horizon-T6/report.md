## Summary

- **Closed the long-standing Stacks-00TT "genuine Mathlib gap" (`ALB.codim1` keystone) with a new Serre-free proof**: standard-smooth algebras over a perfect field are regular at **every** prime — no Stacks `00OF`, no Serre homological criterion, no Noether normalization.
- New file `AlgebraicJacobian/Albanese/SmoothPrimeRegularity.lean` (768 LOC, **axiom-clean**: `propext, Classical.choice, Quot.sound` only), verified by `#print axioms` on all four core theorems.
- Consequently `isRegularLocalRing_stalk_of_smooth`, `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`, and **`localRing_dvr_of_codim_one` (smooth codim-1 ⇒ DVR, Hartshorne II.6) are now sorry-free and axiom-clean** — this directly refutes Ground's `I-0041` assessment that the `ALB.codim1` leg was fully upstream-blocked.
- **Target 3 done**: `Thm32RationalMapExtension.lean` is now **sorry-free**; its branch-2 gap moved into the new named lemma `indeterminacy_codimGe2_of_smooth_of_complete` (the unbundled codim-≥2 half of Milne 3.1, sorry, as the task hint authorized).
- Target 1 (dead-code cleanup) was already done by the earlier T6 session this run — verified, nothing to do.

## Progress

- **Math route** (new, reusable): (A) trdeg–height inequality `#ι ≤ ht P + d`, `d ≤ trdeg k(k[x_ι]/P)` at any prime, by induction on variables via Stacks `00ON` going-down dimension formula; (B) transfer to standard-smooth via the existing Krull-height pullback; (C) `rank Ω[K⁄k] = trdeg k K` over perfect fields (separating basis + formally étale base change + localized `mvPolynomialBasis`); (D) conormal identity `dim m/m² + dim Ω[κ/k] = n` generalizing iter-199 by dropping `Subsingleton Ω[κ/k]`.
- Rewrote `isRegularLocalRing_stalk_of_smooth` to a 30-line chart/localization proof; updated all stale gap-narrative docstrings in `CodimOneExtension.lean` and `StandardSmoothDimension.lean`.
- Blueprint: 7 new nodes (`subsec:smooth_prime_regularity` + `thm:indeterminacy_codimGe2`), rewrote `lem:smooth_to_regular_local_ring`, updated `\uses` edges in both chapters; `horizon blueprint` green — Albanese 297 nodes / 167 edges / 0 dangling.
- **Full `lake build` green** (8582 jobs), run 3× after edits. Albanese sorry count: 15 → 14 declarations; the remaining CodimOneExtension sorries are Milne 3.1 (`extend_of_codimOneFree_of_smooth`), Milne 3.3, and the new `indeterminacy_codimGe2` — all gated on rational-map valuative-criterion / function-field / 0AVF machinery, not on regularity anymore.
- Inbox: filed `I-0046` (info, human — supersedes `I-0041`'s blocked verdict) and `I-0047` (memory — full recipe + Lean-engineering traps: coercion-path defeq timeouts, `set` vs `have` for computable equivs, `rw`-chain mid-list closure).

## Issues

- `stalkMap_flat_of_smooth` (Stage 1) and `exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth` (Stage 3) in `CodimOneExtension.lean` are now dead code (no Lean consumers); left in place as blueprint-pinned axiom-clean leaves — flagged in `I-0047` for Ground to prune or keep.
- The stage-6 placeholder blueprint nodes (`lem:stage6_regular_stalk_assembly` with its `TODO` lean pin, `lem:smooth_algebra_krull_dim_formula`) are off the critical path now; not removed (cross-referenced in prose) — candidates for a Ground blueprint tidy.
- This leandag engine only registers statement-level `\uses` (proof-level `\uses` are ignored, also for pre-existing nodes) — worth knowing when auditing edges.
- No inbox `comment` verb in this CLI build despite the skill documenting one; used a new info item instead.

## Next

- The genuine `ALB.codim1` frontier is now: `indeterminacy_codimGe2_of_smooth_of_complete` (valuative criterion for rational maps at DVR stalks — the DVR input is ready), Stacks 0AVF depth-2 vanishing for Milne 3.1 Step 2, and the function-field pullback bridge for Milne 3.3.
- `Algebra.rank_kaehlerDifferential_eq_trdeg` and the trdeg–height Lemma A are Mathlib-shaped and could be upstreamed.
