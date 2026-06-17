# Iter-164 plan-agent run

## Headline outcome

**The genus-0 base-case route was RESOLVED and a multi-iter misconception corrected.** The prior
plan treated "ℙ¹→A constant" as needing Milne Thm 3.2's surface rational-map extension (riskiest,
no Mathlib Weil divisors). This iter three consults dismantled that and replaced it with a
dramatically simpler, char-general route:

1. **mathlib-analogist `thm32-extend`** — Thm 3.2 splits: codim-1 half buildable in Mathlib
   (`ValuativeCriterion`/`RationalMap`/`SpreadingOut`); emptiness half (Lemma 3.3) needs
   Auslander–Buchsbaum (ABSENT) or a CIRCULAR rigidity reduction. Surfaced the circularity.
2. **strategy-critic `basecase-reopen` → CHALLENGE**: the circularity is ILLUSORY — it conflated
   the base case with Milne's *general* Thm 3.4 (non-complete source). Since ℙ¹ is already complete
   and `f` total, the **direct `ℙ¹×𝔾` rigidity** argument applies with the already-proven Cor 1.5.
   Verified vs. Milne PDF p.19.
3. **blueprint-writer `basecase-4throute` Finding 2** → the **𝔾_m-scaling shortcut** (adopted): the
   total scaling action `σ_× : ℙ¹×𝔾_m → ℙ¹` fixes `0`, so Cor 1.5's W-axis restriction collapses,
   giving `f(λx)=f(x)` ⟹ `f|_{𝔾_m}` constant ⟹ (density + separated) `f` constant. Uses ONLY proven
   Cor 1.5 + density (`ext_of_eqOnOpen`). Avoids Thm 3.2, Auslander–Buchsbaum, the cube, AND
   `Hom(𝔾_a,A)=0` (whose standalone proof needs "image of a group hom is a closed subgroup", a deep
   Mathlib gap — the writer's Finding 1).

Two blueprint-writer passes installed the scaling shortcut as the PRIMARY proof of
`prop:morphism_P1_to_AV_constant`; Thm 3.2 / `Hom(𝔾_a,A)=0` / the 𝔾_a-additive route are demoted
off the genus-0 critical path. The fast-path re-review (`avr-fastpath2`) verified the new proof
end-to-end and **CLEARED the HARD GATE** for `AbelianVarietyRigidity.tex`.

Net: the genus-0 arm's scariest gap (Thm 3.2 / Auslander–Buchsbaum surface extension) is GONE; the
remaining base-case work is the elementary concrete-ℙ¹/𝔾_m/σ_× infra + a short rigidity proof.
STRATEGY genus-0 estimate dropped ~18–35 → ~10–18 iters.

## Decision made (strategy fork)

**Adopt the 𝔾_m-scaling shortcut as the genus-0 base-case route** (over the strategy-critic's
candidate menu (A) Auslander–Buchsbaum / (B) differential / (C) cube, all rejected, and over the
writer's own 𝔾_a-additive primary).
- **Why:** uses ONLY already-proven infrastructure (Cor 1.5 + `ext_of_eqOnOpen`) + one elementary
  new ingredient (the σ_× scaling action); char-general (the protected goal is char-general, which
  killed (B)); least-Mathlib-blocked; sidesteps the `Hom(𝔾_a,A)=0` "image is a closed subgroup" gap
  that the 𝔾_a-additive route hits (Finding 1).
- **LOC/risk trade-off:** the only new infra is concrete ℙ¹/𝔾_m group objects + σ_× (elementary,
  bounded) vs. multi-thousand-LOC detours into Auslander–Buchsbaum (A) or Serre-duality/coherent
  cohomology/Frobenius (B). Risk concentrated in the concrete ℙ¹/𝔾_m Mathlib idiom (mitigated by an
  api-alignment consult before scaffolding, iter-165).
- **Cheapest reversal signal:** if the api-alignment consult finds no workable concrete-ℙ¹/𝔾_m/`GrpObj`
  scheme idiom in Mathlib (forcing a from-scratch projective-line build heavier than expected),
  revisit (the differential route's `H⁰(ℙ¹,O(-2))=0` is concretely citable in Hartshorne and could
  re-enter for a char-0 sub-case). Watch the iter-165 scaffold: if `gmScalingP1`/`ProjectiveLineBar`
  prove intractable to even state cleanly, that's the reversal trigger.

## Prior critique status

- **strategy-critic `basecase-reopen` CHALLENGE — ADDRESSED.** STRATEGY.md rewritten: base-case
  route marked RESOLVED = 𝔾_m-scaling shortcut; Auslander–Buchsbaum / Lemma 3.3 / Thm 3.2 struck
  from the genus-0 critical path (now Route-A-only); the (A)/(B)/(C) menu replaced by the resolution;
  format drift fixed (stripped `(iter-NNN)` tags + the `iter/iter-163/plan.md` cross-ref; trimmed
  11475 B, under the 12 KB budget).
- **blueprint-reviewer `iter164` must-fix (AVR.tex frontier blocks not prover-ready) — ADDRESSED**
  via the 2 writer passes + `avr-fastpath2` re-review clearing the gate.

## Subagent verdicts (absorbed)

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| progress-critic | routec | **CONVERGING** | de-risk+deepen correct this iter; iter-165 MUST convert to depth (infra/proof, not 2nd cosmetic). Set as the iter-165 plan. |
| mathlib-analogist | thm32-extend | Thm 3.2 splits; emptiness needs absent A–B | Demoted Thm 3.2 to Route-A; `analogies/thm32-extend.md`. |
| blueprint-reviewer | iter164 | must-fix: AVR.tex frontier blocks NOT prover-ready | Triggered the 2 writer passes. |
| strategy-critic | basecase-reopen | **CHALLENGE → 4th route** | Adopted (then sharpened to scaling). STRATEGY rewritten. |
| blueprint-writer | basecase-4throute | COMPLETE + Finding 2 (scaling shortcut) | Rewrote base case; surfaced the superior scaling variant. |
| blueprint-writer | scaling-primary | COMPLETE | Promoted scaling shortcut to PRIMARY proof; demoted 𝔾_a route + Thm 3.2. |
| blueprint-reviewer | avr-fastpath2 | **HARD GATE CLEARS** | AVR.tex complete+correct; scaling proof verified end-to-end; gate cleared. |

## Prover lane this iter

No-regret cleanup on `AbelianVarietyRigidity.lean` (docstring refresh to the scaling-shortcut
reality + optional Cor 1.5/1.2 unused-hyp generalization). Justification: the gate cleared, but the
deep infra scaffold (ℙ¹/𝔾_m/σ_×) needs an api-alignment consult FIRST (mathlib-analogist proactive
trigger — building foundational scheme objects blind risks a parallel API). The cleanup carries a
real prover lane (not plan-only), fixes now-actively-misleading docstrings (they still cite the
abandoned cube/Thm-3.2 route), and is gate-safe. The progress-critic sanctioned a cosmetic lane
"once"; this iter's DEPTH is the strategic route correction. iter-165 = the aligned infra scaffold +
scaling-shortcut proof (set in PROGRESS "Next iter").

## Infra bug found + reported (CRITICAL from iter-163 recommendations)

Root-caused the persistent false `\leanok` on the 3 genus-0 scaffold props:
`sorry_analyzer.py` emits `in_declaration` WITH the Lean keyword prefix (e.g.
`"theorem morphism_P1_to_grpScheme_const"`), but `sync_leanok.py::_decl_has_sorry` compares against
the bare/qualified name without stripping the keyword — so it never matches, concludes "no sorry",
and keeps the proof-block `\leanok` (false positive; never a false removal). Confirmed via
`sorry_analyzer --format=json` (3 keyword-prefixed sorries) + `sync_leanok --dry-run` (0 removals).
Reported to the developer via `.debug-feedback` with the one-line fix (strip the keyword in
`_decl_has_sorry`). Not mine to patch (`\leanok` is sync-owned); the 3 scaffold props remain OPEN
regardless of the marker (everyone already treats them so). Surfaced to the user via the sidecar →
TO_USER.

## Subagent skips

- (none) — all HIGHLY RECOMMENDED subagents dispatched: progress-critic (routec), strategy-critic
  (basecase-reopen, NOT skipped — material STRATEGY change + a re-opened question), blueprint-reviewer
  (iter164 whole-blueprint + avr-fastpath2 fast-path).
