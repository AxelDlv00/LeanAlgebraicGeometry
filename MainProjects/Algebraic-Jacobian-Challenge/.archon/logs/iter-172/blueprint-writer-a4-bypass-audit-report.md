# Blueprint Writer Report

## Slug
a4-bypass-audit

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/Jacobian.tex`

## Audit verdict

**Outcome (b) — the A.4 bypass FAILS.** Milne III §6's proof of the Albanese
universal property (Proposition 6.1, the existence-and-uniqueness statement
consumed by Route A.4) is NOT derivable from Picard-functor functoriality + Cor
1.5 / Cor 1.2 + cohomology-and-base-change. The proof as written invokes
(I 3.2) — Milne's Theorem 3.2 of §I.3 — to upgrade the symmetric-product
rational map `C^(g) ⇢ A` to a regular map `J → A`. Theorem 3.2 = Theorem 3.1
(valuative extension outside codimension ≥ 2) ∘ Lemma 3.3 (pure-codim-1
indeterminacy locus for maps into a group variety). Lemma 3.3 is the
Weil-divisor / Auslander–Buchsbaum-flavoured sub-build the project's own
`AbelianVarietyRigidity.tex` already records as the route's Mathlib-gap blocker
(`rmk:thm32_codim1_mathlib_gap`).

A "pure Picard-functoriality / Poincaré-sheaf" detour around Theorem 3.2 is
imaginable but would route through autoduality `J ≅ J^∨` (Milne III Thm 6.6),
which itself rests on the theorem of the cube — and the cube was excised from
this project iter-163 (`rmk:cube_not_needed`). A.4 therefore commits to the
Theorem 3.2 sub-build rather than the cube.

The STRATEGY.md row "A.4 reuses in-tree Rigidity Lemma + Cor 1.2/1.5; no new
Mathlib namespace" is materially under-counted with respect to the Lemma 3.3
codim-1 sub-build. **Recommend the planner re-estimate the A.4 row.**

## Changes Made

- **Added subsection** `\subsection{Route A.4: the Albanese universal property of $\Pic^0_{C/k}$ (Milne III §6 audit)}` / `\label{sec:Jacobian_routeA4_albaneseUP}` — new orientation subsection sitting between the genus-0 arm proof and the positive-genus arm subsection in `Jacobian.tex`.
- **Added `% NOTE:`** (the audit comment, immediately before the theorem block) — records audit outcome (b), author (this writer), one-sentence chain summary, and the implication for the STRATEGY.md A.4 row estimate.
- **Added theorem** `\theorem` / `\label{thm:albanese_universal_property}` / `\lean{AlgebraicGeometry.Scheme.Pic.albaneseUP}` — Milne III Prop 6.1, statement in the project's notation (smooth proper geometrically irreducible curve `C` of genus `g ≥ 1` over `k`, with `J = Pic^0_{C/k}` and the Abel–Jacobi map `f^P`); pointed at the project-bespoke Lean target `AlgebraicGeometry.Scheme.Pic.albaneseUP` named in the directive.
  - Proof sketch added: Y. ~1 paragraph of mathematical content (symmetric-product factorisation → rational map → Thm 3.2 → Cor 1.2 → uniqueness via image-sum-fills-`J`), plus a half-page **dependency audit** classifying each ingredient as (i) in-tree axiom-clean, (ii) reserved Lean target + Mathlib gap, (iii) Mathlib gap shared with Route B, (iv) Route A.3 output, (v) explicitly NOT a dependency.
- **Citation discipline**: three verbatim quotes in the statement block (Prop 6.1, Prop 6.4, Remark 6.5) and one verbatim quote of the Prop 6.1 proof, all character-by-character copies from the PDF read in this session.

## Cross-references introduced

- `\uses{def:IsAlbanese, def:genus, lem:av_regular_map_is_hom, lem:hom_additivity_over_product, lem:rational_map_to_av_extends}` on the theorem statement — all five labels verified present in the blueprint tree.
- `\uses{lem:av_regular_map_is_hom, lem:hom_additivity_over_product, lem:rational_map_to_av_extends, thm:nonempty_jacobianWitness}` on the proof — same set, plus the witness existence theorem this block fits under.
- Body references `\cref{rmk:thm32_codim1_mathlib_gap}`, `\cref{rmk:cube_not_needed}`, `\cref{thm:rigidity_lemma}` — all verified present in `AbelianVarietyRigidity.tex` (lines 875, 667, 90 respectively).
- A `\cref{lem:rational_map_to_av_extends}` reference now appears in `Jacobian.tex` for the first time; the upstream target itself sits in `AbelianVarietyRigidity.tex` (line 820) and is already documented as "Route-A-only" / "riskiest sub-build" there. No definition cycle: `Jacobian.tex` imports from `AbelianVarietyRigidity.tex` semantically (the latter is upstream).

## References consulted

- `references/abelian-varieties.pdf`, pages 110–112 (doc pp. 104–106) — Milne III §6: read **directly via the `Read` tool's PDF rendering** to extract the verbatim text of Proposition 6.1 (statement + proof), Proposition 6.4 (statement + proof), and Remark 6.5. Pages 113–115 (doc pp. 107–109) were also rendered to verify Theorem 6.6 / Lemma 6.7 / Lemma 6.8 / Lemma 6.9 (the autoduality chain) — these confirm that autoduality is established AFTER Prop 6.1 and so cannot be silently used inside the Prop 6.1 proof.
- `references/abelian-varieties.md` — Milne summary; cross-checked the references to Prop 6.1 / Prop 6.4 / Remark 6.5 and the standing hypothesis "genus `g > 0` with `k`-rational point `P`".
- `blueprint/src/chapters/AbelianVarietyRigidity.tex`, lines 40–75, 685–688, 695, 767, 820–906 — to read the existing in-tree dependency notes: `lem:av_regular_map_is_hom` (Cor 1.2), `lem:hom_additivity_over_product` (Cor 1.5), `lem:rational_map_to_av_extends` (Thm 3.2), `rmk:thm32_codim1_mathlib_gap` (the codim-1 / Weil-divisor / Auslander–Buchsbaum blocker), `rmk:cube_not_needed`. Confirmed line 685–688 already records "the Albanese universal property that the positive-genus arm needs (Milne Proposition 6.1/6.4, §III.6) is also cube-free, resting on Theorem 3.2 + Corollary 1.2/1.5".
- `blueprint/src/chapters/Genus.tex`, line 16 — to confirm `def:genus` exists.

I did NOT consult `references/kleiman-picard.pdf` or `references/mumford-abelian-varieties.pdf` for this audit: the Milne text already pins down the dependency chain unambiguously, and the chapter's existing Picard-scheme citations to Kleiman already supply the surrounding context.

## Macros needed (if any)

None. The block uses `\Pic^0_{C/k}`, `\Spec`, `\cref`, `\lean{...}`, `\uses{...}`, `\label{...}`, `\textit{Source: ...}` — all already in use elsewhere in `Jacobian.tex`.

## Reference-retriever dispatches (if any)

None. The Milne PDF was sufficient; Outcome (b) was reachable without needing a fresh `references/auslander-buchsbaum.pdf` retrieval (the relevant Auslander–Buchsbaum-equivalent statement is Milne's Lemma 3.3 itself, already paraphrased in `rmk:thm32_codim1_mathlib_gap`). The directive's permission to spawn a `reference-retriever` was not exercised.

## Notes for Plan Agent

- The new subsection `sec:Jacobian_routeA4_albaneseUP` is positioned between the genus-0 arm proof (ends at line 569) and the positive-genus arm subsection (line 571 in the old file). It now sits at lines 571–637 (approximately) in the edited file.
- The `\lean{AlgebraicGeometry.Scheme.Pic.albaneseUP}` target is project-bespoke and **does not yet exist in the Lean tree** (verified by grep across `AlgebraicJacobian/` and `AlgebraicJacobian.lean`). This is intentional per the directive — it becomes the prover-ready spec for the A.4 lane. The protected-decl registry (`archon-protected.yaml`) does not need to be touched by this writer; if the planner wants to freeze the signature, that is a user-side action.
- **Cross-chapter note (not fixed here):** the Jacobian.tex paragraph at L344–L391 (the per-sub-phase budget block) still says A.4 "Reuses the proven Rigidity Lemma + Cor 1.2 + Cor 1.5 ... no new Mathlib namespace" and "~ 900–1200 LOC / ~ 7–11 iters". After this audit, that prose understates the A.4 cost because it omits the Thm 3.2 / Lemma 3.3 sub-build. The directive scopes me to NOT touch the A.1/A.2/A.3 sub-sections, but the wording in A.4's row is itself the thing under audit. I have left the old A.4 budget prose unchanged because the new subsection now contains the authoritative dependency audit and the cross-reference back to `rmk:thm32_codim1_mathlib_gap`. The planner may wish to either (a) re-write the L344 / L384–391 A.4 budget bullet to reference `thm:albanese_universal_property` and the audit there, or (b) leave both in place with the new audit taking precedence — flagging here rather than editing.
- The existing chapter already had partial awareness of this dependency (line 685–688 of `AbelianVarietyRigidity.tex` records it); the audit's new contribution is consolidating it into a single named theorem with a `\lean{...}` pin in the Jacobian chapter and explicitly flagging the STRATEGY.md mis-estimate.

## Strategy-modifying findings

- **A.4 budget under-count.** The STRATEGY.md row for Route A.4 ("reuses in-tree Rigidity Lemma + Cor 1.2/1.5; no new Mathlib namespace; ~900–1200 LOC / ~7–11 iters") does not account for the Theorem 3.2 / Lemma 3.3 sub-build that Milne III §6 Prop 6.1's proof explicitly invokes. The codim-1 / Weil-divisor / Auslander–Buchsbaum half is the riskiest sub-build of the project's existing rigidity chain and has no Mathlib Weil-divisor API. The audit-derived dependency chain (now in `thm:albanese_universal_property`) is:

  - In-tree axiom-clean: Cor 1.2 (`lem:av_regular_map_is_hom`), Cor 1.5 (`lem:hom_additivity_over_product`), Rigidity Lemma (`thm:rigidity_lemma`).
  - Reserved Lean target + Mathlib gap: Theorem 3.2 (`lem:rational_map_to_av_extends`), gated on Lemma 3.3.
  - Mathlib gap shared with Route B: symmetric powers of schemes `C^(g)`.
  - Route A.3 output: identity component, dimension count, surjectivity of `f^(g)`.

  The planner should re-estimate the A.4 row. Two natural recostings:
  - **Pessimistic** (build Mathlib Weil-divisor theory + Lemma 3.3 as a stand-alone sub-cascade): adds ~ 5+ iters and a new Mathlib namespace (`Mathlib.AlgebraicGeometry.WeilDivisor` or equivalent).
  - **Optimistic** (pointwise-valuative detour around Lemma 3.3, mentioned as an open question in `rmk:thm32_codim1_mathlib_gap`): may keep A.4 within its current envelope if the detour proves out, but the detour is unproven and would itself need a feasibility scaffold.

  Either way, "no new Mathlib namespace" is no longer accurate. The strategic question raised in iter-172's STRATEGY.md "Open strategic questions" section is now resolved: the answer is Outcome (b), and A.4 is materially more expensive than the row currently claims.
