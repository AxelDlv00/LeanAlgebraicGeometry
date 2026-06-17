# Strategy Critic Report

## Slug
route-c-decision

## Iteration
163

## Routes audited

### Route: A — Picard/Quot/Hilbert FGA engine (positive-genus object)

- **Goal-alignment**: PASS — the protected object must be a real dim-`g` AV even when `C(k)=∅`, so the unconditional `Pic⁰` construction is the right (and essentially forced) target.
- **Mathematical soundness**: PASS — and I verified the strategy's *new* iter-163 claim against the source: the **Albanese UP derivation** (Milne Prop 6.1/6.4) uses only Thm 3.2 + Cor 1.2 + Cor 1.5, with **no theorem of the cube**. Confirmed verbatim on PDF p.109–110: Prop 6.1's proof = "(I 3.2) shows [the rational map] to be a regular map ... (I 1.2) shows it is a homomorphism"; Prop 6.4 = "(I 1.5) shows there exist unique maps ... From (6.1) ...". Neither invokes §I.5.
- **Effort honesty**: reasonable — the strategy is candid that the Albanese UP shares Route C's Cor 1.5/1.2/Thm 3.2 infra and that the ~5100 LOC under-counts (true budget higher). One honest caveat the strategy already respects: J's *existence / projectivity / autoduality* (the FGA bulk, §III.1–5 + §I.6 + Thm 6.6's Poincaré sheaf) **does** rest on cube/square/seesaw — but the strategy never claims Route A is cube-free, only that the UP *derivation step* is, which is correct.
- **Verdict**: SOUND

### Route: C — genus-0 rigidity completion via Milne §I.3 (COMMITTED iter-163)

- **Goal-alignment**: PASS — genus-0 object is the trivial `J = Spec k`; the only content is "`ℙ¹→A` constant over `k̄`", which feeds `genusZeroWitness.key`.
- **Mathematical soundness**: PASS — cube-excision verified directly against `abelian-varieties.pdf`:
  - **Cor 1.2** (AV map `0↦0` is a hom): proof (PDF p.14) builds `φ(a,a')=α(a+a')−α(a)−α(a')`, collapses both axes, "and so `φ=0`" — by the **Rigidity Theorem 1.1**. No cube.
  - **Cor 1.5** (additivity `h=f∘p+g∘q`): proof (PDF p.14–15) "and so **the theorem** shows that `ψ=0`" — "the theorem" = Rigidity 1.1. This is exactly the project's proven Form-I Rigidity Lemma. No cube. (Requires `V,W` **complete**; `ℙ¹` is, so applicable.)
  - **Thm 3.2** = Thm 3.1 (valuative criterion on a DVR, PDF p.21–22) + **Lemma 3.3** (PDF p.22–23). Lemma 3.3 uses *Weil-divisor theory* on `V×V` (`div(f)₀/div(f)₁`) — but **no cube/seesaw/square**.
  - **Prop 3.9** (`ℙ¹→A` const, PDF p.24): Thm 3.2 + translate-to-`0↦0` + homomorphism + `𝔾_a/𝔾_m` incompatibility. No cube.
  - **Cube** (Thm 5.1, §I.5, PDF p.26) is *deferred/unproven* in Milne ("[this section needs to be rewritten to include the complete proof]") and its corollaries serve projectivity (§I.6), seesaw, dual AV, Poincaré sheaf — **none on the genus-0 or Albanese-UP path**. Excision is sound.
- **Phantom prerequisites**: none — `IsProper.of_valuativeCriterion` / `ValuativeCriterion` are the named Mathlib hooks for Thm 3.1; the divisor theory for Lemma 3.3 is correctly flagged as *absent* and to-build.
- **Effort honesty**: reasonable-to-optimistic — `~3000–5500` LOC for the base case is wide but plausible *given* that Lemma 3.3 needs surface divisor machinery with no Mathlib support; could under-count if full Weil-divisor theory is forced.
- **Verdict**: SOUND — with two accuracy notes for the planner (neither changes soundness or risk profile), see below.

**Note C-1 (citation imprecision).** The genus-0 chain cites **Cor 1.2** for the homomorphism step, but Cor 1.2 is stated for maps **between abelian varieties** (`A→B`, both complete). The genus-0 base case needs the `𝔾_a→A` analogue: `φ(x,y)=f(x+y)−f(x)−f(y)` on `A¹×A¹`, killed by **Thm 3.4** (the *non-complete* product-rigidity), which itself routes through Thm 3.2. The correct citation for the genus-0 row is **Thm 3.4** (⟸ Thm 3.2 + Rigidity 1.1), not Cor 1.2. Cosmetic — Thm 3.2 is already listed and the surface gap is already the flagged risk.

**Note C-2 (riskiest-piece identification is CORRECT — I checked the doubt).** I initially suspected Lemma 3.3 / `ℙ¹×ℙ¹` was mis-attributed to the genus-0 row (since the *source* `ℙ¹` is a curve, where Thm 3.1's curve case alone extends a rational map with no divisor theory). That suspicion is **wrong**: the genus-0 argument kills the additivity map `φ` which lives on `A¹×A¹`; to apply the complete Rigidity Lemma you must first extend `φ` to `ℙ¹×ℙ¹` (the `𝔾_a`-addition `A¹×A¹→A¹` does **not** extend to `ℙ¹×ℙ¹`), and that extension is precisely Thm 3.2's **surface** case = **Lemma 3.3**. So the surface divisor gap **is** genuinely on the genus-0 path, and the strategy's risk identification is correct. The "pointwise valuative side-step avoids building divisor theory?" open question is well-posed and correctly flagged OPEN — the valuative criterion gives extension *across one codim-1 point*, but "indeterminacy is *pure* codim 1 so codim-1-extension ⟹ everywhere-defined" is exactly Lemma 3.3's divisor-theoretic content. Not under-estimated.

### Route: off-path fallbacks (c-hybrid / c-cube / b / a)

- **Verdict**: SOUND — (c-cube) is correctly excised on a source-verified basis (cube on neither path); (c-hybrid) and (a) are correctly demoted for the char-`p` gap + from-scratch Ω-sheaf/cohomology/Frobenius cost; (b) correctly noted as coupling genus-0 to the Route A monster.

## Format compliance

- **Size**: 171 lines / 12,165 bytes — **marginally over budget** (~12 KB ceiling exceeded by ~165 B).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: **yes** — 12 `iter-NNN` occurrences embedded throughout, e.g. "DECIDED iter-163 = Route C", "PROVEN axiom-clean (iter-162)", "EXCISED iter-163", "REJECTED iter-163". The canonical skeleton forbids inline iteration references in STRATEGY.md (they belong in `iter/iter-NNN/plan.md`). The pointer "See `iter/iter-163/plan.md` for the full decision record" is fine; the inline `iter-162/163` tags are the violation.
- **Accumulation detected**: yes (mild) — the **char-`p` genus-0 rigidity** table row is now "(subsumed by genus-0 row)" / "— · 0" and could be dropped entirely; the "Off-path fallbacks" subsection documents the *excised* (c-cube) at length (excised routes belong in an iter sidecar, not occupying live strategy space).
- **Table discipline**: PASS — all six named columns present; LOC cells carry both figures. Minor: a couple of LOC cells substitute prose ("chain done, base-case 0/it") for the velocity figure.
- **Format verdict**: DRIFTED — core skeleton (headings + table) is intact; the pervasive `iter-NNN` narrative + the marginal size overflow + the subsumed char-`p` row are cleanup items the planner should resolve in-place this iter without a full restructure.

## Must-fix-this-iter

- Format (DRIFTED, not blocking but resolve in-place): purge the 12 inline `iter-NNN` tags (replace "DECIDED iter-163 = Route C" with "DECIDED: Route C", etc.), drop the subsumed char-`p` row, and trim the excised-(c-cube) prose into `iter/iter-163/plan.md` to bring the file back under 12 KB.

## Overall verdict

A fresh mathematician would approve the iter-163 resolution. The cube-excision is not hand-waved — I confirmed against Milne's text that every link in the genus-0 chain (Cor 1.2, Cor 1.5, Thm 3.2, Prop 3.9) and in the Route-A Albanese-UP derivation (Prop 6.1/6.4) rests on the already-proven Rigidity Lemma + the valuative criterion + divisor theory, and that the theorem of the cube is a *deferred, unproven* §I.5 result feeding only projectivity/autoduality. The committed Route C is sound and is genuinely the least-blocked path (valuative criterion present; differential route needs three from-scratch foundations). The single substantive risk — extending the additivity map across the `ℙ¹×ℙ¹` codim-1 indeterminacy without building full Weil-divisor theory (Lemma 3.3) — is correctly identified and honestly flagged OPEN; my attempt to find it mis-attributed failed (the surface extension really is on the genus-0 path). Two minor accuracy items (Cor 1.2 → Thm 3.4 citation; the genus-0 row arguably needs only Thm 3.4 + `Hom(𝔾_a,A)=0` + RR-bridge, with Cor 1.5 being a Route-A no-regret rather than strictly genus-0-essential) and a DRIFTED format (strip `iter-NNN`, trim accumulation) are the only cleanups. No route-level CHALLENGE or REJECT.
