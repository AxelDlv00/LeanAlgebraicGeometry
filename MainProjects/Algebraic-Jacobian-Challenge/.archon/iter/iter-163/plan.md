# Iter-163 plan-agent run

## Headline outcome

iter-163 is the **base-case route DECISION iter** mandated as the binding iter-163 task. The
Rigidity-Lemma chain closed axiom-clean in iter-162, so the prior Current-Objective (Step 1) was
done and the gating question was: how to finish the genus-0 base case `ℙ¹→A constant`. This iter
resolved it from primary sources and pivoted the blueprint accordingly.

**The decision: commit Route C (Milne *Abelian Varieties* §I.3 rigidity completion); EXCISE the
theorem of the cube; demote the differential/Frobenius route to off-path fallback.**

This corrects a multi-iter MISCONCEPTION (iter-156→162): the blueprint had asserted "ℙ¹→A constant
rests on the theorem of the cube." Reading Milne directly showed this is **false**.

## What I read (the binding gating verification)

From `references/abelian-varieties.pdf` (Milne), verbatim:
- **§I.1 Rigidity Thm 1.1** (PDF p.14–15): IS the project's proven Mumford Form-I `rigidity_lemma`;
  its proof uses only completeness + "complete connected → affine is constant" — NO cube.
- **§I.1 Cor 1.2 / Cor 1.5** (PDF p.15): AV-maps-are-homs + additivity, both from Rigidity 1.1.
- **§I.3 Thm 3.1/3.2 + Lemma 3.3** (PDF p.22–24): rational-map extension via the valuative criterion
  + pure-codim-1 indeterminacy (Weil divisors on a surface).
- **§I.3 Prop 3.9/3.10** (PDF p.25–26): `ℙ¹→A constant` = Thm 3.2 + Cor 1.2 + the `𝔾_a/𝔾_m`
  incompatibility — NO cube.
- **§III.6 Prop 6.1/6.4** (PDF p.110–111): the Albanese UP Route A needs is ALSO cube-free (Thm 3.2
  + Cor 1.2/1.5). The cube (§I.5) feeds only projectivity/seesaw/dual-AV/Poincaré — neither path.

## Subagent verdicts (absorbed)

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| mathlib-analogist | route-support | **Route R (rigidity) ≫ Route H (differential)** | Route C keystone (valuative criterion) is IN Mathlib (`IsProper.of_valuativeCriterion`); Route H needs THREE from-scratch foundations (Ω-sheaf, coherent cohomology + Serre H⁰ = "single largest gap", scheme Frobenius). Decisive for committing Route C. `analogies/route-support.md`. |
| strategy-critic | route-c-decision | **SOUND (all routes), no CHALLENGE/REJECT** | Independently re-verified the cube-excision against Milne's text (every §I.3 link + the Albanese UP). Confirmed the surface gap (Lemma 3.3 on `ℙ¹×ℙ¹`) IS genuinely on the genus-0 path (Note C-2). Must-fix = STRATEGY format DRIFTED (iter-NNN tags, char-p row, fallback prose) — **addressed in-place** (160 lines / 10.9 KB). |
| blueprint-writer | route-c | COMPLETE | Cube `\section`+`rmk:cube_is_load_bearing` removed; §I.3 chain added (Cor 1.5, Cor 1.2, Thm 3.2, Prop 3.9 core + 2 remarks); Prop 3.9 rewritten. Strategy-finding #2 (Lemma 3.3 "not needed for ℙ¹") was **WRONG** — see below. |
| blueprint-reviewer | iter163 | **partial** (4 small must-fix) | Cube-excision mathematically correct; Rigidity chain intact. Must-fix: (1) prop:morphism_P1 still cited Cor 1.2 for 𝔾_a step; (2/3) Jacobian.tex stale cube refs; (4) Cor 1.5 group-structure provenance. |
| blueprint-writer | jacobian-cube-purge | COMPLETE | Jacobian.tex route-(c) narrative aligned to cube-free Milne §I.3 (8 spots); no broken `\cref`; protected sigs untouched. |
| blueprint-reviewer | avr-fastpath | **HARD GATE CLEARS** | AVR.tex `complete:true`+`correct:true`, 0 must-fix after my 2 fixes; gate clears for Cor 1.5 + Cor 1.2 this iter. |

## A blueprint error I caught and corrected (writer finding #2 was wrong)

The route-c writer claimed "for V=ℙ¹ the map is already a morphism, so Lemma 3.3 / the surface
extension is NOT invoked — defer it to Route A." This is **mathematically wrong** (corroborated by
strategy-critic Note C-2): proving `f|_{𝔾_a}` is an additive homomorphism requires killing the
additive-defect map `ψ(x,y)=f(x+y)−f(x)−f(y)`, which lives on the affine surface `𝔾_a×𝔾_a`; to
apply the (complete-source) Rigidity Lemma one must FIRST extend ψ to the complete `ℙ¹×ℙ¹` (the
addition does not extend), which IS Thm 3.2's surface case = Milne Thm 3.4 → Lemma 3.3. So the
surface rational-map-extension gap (no Mathlib Weil divisors) is genuinely on the genus-0 critical
path and is the route's riskiest piece. I hand-corrected `rmk:thm32_codim1_mathlib_gap` and the
`lem:hom_from_Ga_trivial` proof to state this correctly before the review.

## Decision made

**(A) Commit Route C (Milne §I.3), excise the cube.** Why: the cube is on NEITHER the genus-0 base
case NOR Route A's Albanese UP (source-verified twice); building it now is a pure ~8–15-iter
zero-Mathlib tax. Route C reuses the just-proven Rigidity Lemma maximally, is uniformly char-free
(no Frobenius epicycle), and is the least Mathlib-blocked path (valuative criterion present).
LOC/risk: ~15–30 iters; the single substantive risk is the surface divisor gap (Lemma 3.3), honestly
flagged OPEN (pointwise valuative side-step may avoid building Weil-divisor theory). Cheapest
reversal signal: if the surface extension proves intractable in Mathlib over several iters, reweigh
(c-hybrid)/(b) — but the analogist shows those are worse.

**(B) Fire ONE deep prover lane this iter on AVR.lean: Cor 1.5 (`hom_additive_decomp_of_rigidity`)
then Cor 1.2 (`av_regularMap_isHom_of_zero`).** No-regret (both feed Route A's Albanese UP too),
directly from the proven `rigidity_lemma`, and the gate is freshly cleared (fast-path). Cor 1.5 is
the foundational additivity; Cor 1.2 follows. Deep lane → PARTIAL acceptable.

## Subagent skips

- progress-critic: the only active route (Rigidity-Lemma chain) COMPLETED in the prior iter (iter-162,
  sorry→0 for the chain); the genus-0 base-case route is freshly decided THIS iter with zero prover
  trajectory to extrapolate from. Per its skip condition ("the only active route just completed in
  the prior iter"), there is no convergence signal to assess. Will re-dispatch once the Cor 1.5 lane
  produces ≥1 iter of trajectory.

## For iter-164

1. Collect the Cor 1.5 / Cor 1.2 lane. If both close axiom-clean → the §I.3 additivity foundation is
   in place; next targets are Thm 3.2 (the surface rational-map extension — the riskiest sub-build;
   consider a mathlib-analogist cross-domain consult on "extend a rational map to a proper/group
   target across codim-1 on a smooth surface, no Weil divisors") and the `𝔾_a/𝔾_m` triviality.
2. The genus-0⟹ℙ¹ RR bridge (`genusZero_curve_iso_P1`) remains a parallel sub-build (no Mathlib RR).
3. Re-dispatch progress-critic (trajectory now exists).
