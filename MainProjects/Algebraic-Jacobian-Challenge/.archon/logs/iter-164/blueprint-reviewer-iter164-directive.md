# Blueprint-reviewer directive — iter-164 (whole-blueprint audit)

Audit the WHOLE blueprint under `blueprint/src/chapters/`. Produce your standard
per-chapter completeness + correctness checklist and the must-fix list.

## Focus this iter (do not restrict the audit, but weight these)

The active route is **Route C** (genus-0 base case via Milne §I.3), file
`AlgebraicJacobian/AbelianVarietyRigidity.lean`, chapter `AbelianVarietyRigidity.tex`.
iter-163 landed Cor 1.5 (`lem:hom_additivity_over_product`) and Cor 1.2
(`lem:av_regular_map_is_hom`) axiom-clean; those blocks cleared the HARD GATE last iter.

The NEXT prover frontier is the pair:
- `lem:rational_map_to_av_extends` (Milne Thm 3.2 — the codim-1 rational-map-extension
  on a surface; the route's RISKIEST piece; no Lean decl exists yet; flagged in
  `rmk:thm32_codim1_mathlib_gap`).
- `lem:hom_from_Ga_trivial` (`morphism_Ga_to_av_const`, Prop 3.9 core; depends on the
  above + the proven Rigidity Lemma; no Lean decl exists yet).

Judge specifically whether THESE TWO blocks are prover-ready:
1. Is the proof of `lem:hom_from_Ga_trivial` detailed enough to formalize? In
   particular the closing "𝔾_a / 𝔾_m incompatibility ⟹ f constant" step (chapter
   lines ~878–885) is currently a one-sentence assertion ("the two relations are
   incompatible ... unless f is constant"). Is that decomposed into a formalizable
   argument, or does it need a blueprint-writer to break it into sub-lemmas (e.g. an
   explicit `Hom(𝔾_a, A) = 0` lemma + how the additive/multiplicative structures
   collide)? Flag the level of infrastructure assumed (a concrete ℙ¹, 𝔾_a/𝔾_m as
   group schemes, the open immersion 𝔾_a ↪ ℙ¹) and whether the chapter says where it
   comes from.
2. Is `lem:rational_map_to_av_extends` stated/proved at a level a prover can act on, or
   is it still an open research question pending the Mathlib-divisor-gap resolution
   (`rmk:thm32_codim1_mathlib_gap`)? If the latter, say so plainly — it should NOT be
   marked prover-ready until the pointwise-valuative approach is fleshed out.

## Also check
- The 3 deferred genus-0 scaffold blocks (`prop:morphism_P1_to_AV_constant`,
  `prop:genusZero_curve_iso_P1`, `thm:rigidity_genus0_curve_to_AV`) still carry
  proof-block `\leanok` while their Lean bodies are `sorry` — this is a KNOWN infra
  bug in `sync_leanok` (keyword-prefix mismatch; reported separately). Note it if you
  see it, but it is NOT yours to fix and should NOT block your gate decision; treat
  those three as OPEN regardless of the marker.
- `\uses` graph forward-acyclic; any laundering (a `\leanok` proof that secretly
  rests on a `sorry`).

## Output
Per-chapter checklist (complete? correct? must-fix?), plus your
`## Unstarted-phase blueprint proposals` section if any strategy phase has no coverage.
The planner uses your checklist to decide which chapters get a blueprint-writer this
iter and whether the deep frontier may enter prover objectives.
