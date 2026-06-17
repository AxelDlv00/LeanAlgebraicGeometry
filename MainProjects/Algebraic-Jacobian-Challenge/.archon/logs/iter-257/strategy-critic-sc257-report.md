# Strategy Critic Report

## Slug
sc257

## Iteration
257

## Routes audited

### Route: A.1.c.sub — comparison iso on line bundles (incl. dual-inverse chain)

- **Goal-alignment**: PASS — the loc-triv pullback–tensor comparison iso is the substrate prerequisite for `IsInvertible.pullback`, on the stated critical path A.1.c.sub → A.1.c.fun → A.2.c.
- **Mathematical soundness**: PASS — `f^*` strong monoidal ⇒ δ iso on all objects; proving it only on loc-triv pairs and assembling over a common trivialising cover via `isIso_of_isIso_restrict` is a sound and strictly easier route. D2′ closed; D1′/D3′/D4′ are coherence plumbing, not new math.
- **Sunk-cost reasoning detected**: no — the OVER_BUDGET admission is honest, and the residual is correctly characterised as bounded plumbing rather than "we've come this far."
- **Infrastructure-deferral detected**: no.
- **Effort honesty**: reasonable-but-watch — `≈23 it vs 6–11` is a 2–4× overrun openly flagged; remaining `~80–160 · ~20/it` with `~5–9` left is arithmetically consistent (160÷20 = 8). The "~1 sorry/it last 2 iters" claim is the right metric to hold the lane to; if it slips below that next iter the bounded-plumbing defense weakens.
- **Verdict**: SOUND

**On the directive's central question — is the dual-inverse chain (`dual_restrict_iso` → `exists_tensorObj_inverse`) on-path, or a re-derivation of a group inverse the carrier pivot already made free?**

CONFIRM — the dual arc is genuinely on-path; it is NOT redundant. The reasoning:

- The carrier pivot makes the inverse free **for the `Pic X` = `IsInvertible` carrier**: the inverse of `M` is the membership witness `N` in `∃N, M⊗N≅𝒪`. `picCommGroup` is done on that carrier.
- RPF (A.1.c.fun) carries a **different** object: `{M // IsLocallyTrivial M}`. For `RPF.addCommGroup` to be a group law *in that carrier*, the inverse must itself be locally trivial. `exists_tensorObj_inverse` is exactly the statement "a loc-triv `L` has a loc-triv inverse" (`∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (L⊗Linv≅𝒪)`). That is the *closure of the loc-triv subset under inverse*, not a re-derivation of the free `IsInvertible` witness.
- Critically, this obligation does **not** disappear under any carrier choice. Even if RPF were carried on `IsInvertible` with loc-triviality attached as a side-Prop, the subgroup `{M : IsInvertible M ∧ IsLocallyTrivial M}` is a group only if the witness `N` of a loc-triv `M` is itself loc-triv — i.e. "the dual of a line bundle is a line bundle," which is precisely `dual_restrict_iso`. The dual arc is forced regardless of which carrier RPF uses.
- The strategy's stated reason for carrying loc-triv directly (rather than `IsInvertible` + later `IsInvertible⟹loc-free-rank-1`) is sound and explicitly avoids the off-path Mathlib-scale spreading-out (`IsInvertible⟹locally-free-rank-1`, RESOLVED open question). Carrying loc-triv from the start uses only the *easy* direction (loc-triv ⟹ has loc-triv inverse), which is the dual arc.

So the two-carrier design (Pic on `IsInvertible`, RPF on `IsLocallyTrivial`) is internally consistent: the free witness serves the group-law carrier; the dual arc serves the RPF carrier-closure. No contradiction with the carrier pivot.

### Route: A.1.c.fun — relative Picard functor on `IsLocallyTrivial`

- **Goal-alignment**: PASS — RPF is the next critical-path node; `OnProduct`/`pullbackAlongProjection` already axiom-clean.
- **Mathematical soundness**: PASS — `map_add` ← comparison iso, `map_zero` ← `pullbackUnitIso`, inverse ← `exists_tensorObj_inverse` (loc-triv witness), modeled on `CommRing.Pic.mapAlgebra`/`.functor`. Coherent.
- **Infrastructure-deferral detected**: no — authored against a typed-sorry bridge whose discharge is D4′, with a concrete dependency, not an indefinite defer.
- **Effort honesty**: reasonable — `~350–600 · 0/it` is correctly tagged "OPENING," not "actively progressing at 0/it."
- **Verdict**: SOUND

**On the directive's second question — is opening the A.2.c engine pole (LineBundleCoherence `IsLocallyTrivial⟹IsFinitePresentation`) in parallel NOW the right call, or premature?**

The A.2.c-engine opening is audited as its own route below; the short answer is RIGHT CALL (parallelism, not premature) — see that block.

### Route: A.2.c — representability scaffolding

- **Goal-alignment**: PASS — six `⟨sorry⟩` Prop-typeclasses scaffold representability; Route A proceeds under them, discharged by the engine.
- **Mathematical soundness**: PASS — standard FGA representability skeleton.
- **Infrastructure-deferral detected**: no (held behind A.1.c with a concrete gate, not deferred indefinitely).
- **Verdict**: SOUND

### Route: A.2.c-engine — Quot/Cartier (RR-free)

- **Goal-alignment**: PASS — the engine discharges A.2.c; `Rⁱf_*`, Relative Proj, CM-regularity etc. are genuinely required for representability.
- **Mathematical soundness**: PASS — the on-path entry `IsLocallyTrivial⟹IsFinitePresentation` (~120–250 LOC) is the correct cheap substitute for the off-path `IsInvertible⟹loc-free-rank-1`, and is independent of the comparison-iso substrate (it concerns the site/finite-presentation structure, not δ).
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: borderline-no — `Rⁱf_*` (the dominant ~800–1200 LOC pole) is required by the goal and is correctly named with a DEFAULT project-side build (Čech), an externally-unblocked fallback, and a blueprint chapter "scheduled next iter." This is a *concrete* plan with a (loose) timeline, so it clears the deferral bar — but the one-iter blueprint deferral is the kind of thing that silently becomes N iters; hold it to "blueprinted next iter."
- **Effort honesty**: reasonable — `~3400–5500 · ~0/it (opening)`; the `÷~40/it ≈ 85–140 it` reconciliation is shown and internally consistent.
- **Parallelism under-exploited**: no — the strategy explicitly parallelises this group-law-independent pole as capacity frees.
- **Verdict**: SOUND

**Is opening it NOW premature given A.1.c.sub is not closed?** No — it is correct parallelism. The loc-triv coherence entry is provably independent of the comparison-iso substrate (it does not consume δ or `exists_tensorObj_inverse`; its first-iter de-risk is the `J.over X`/`X.ringCatSheaf` site instances). The strategy gates its prover lane on *capacity* ("opens once a substrate lane closes and frees capacity"), not on A.1.c.sub completion — which is the right gate. Serializing a group-law-independent engine pole behind the substrate would be the throughput error; opening it avoids that. The only caveat: ensure the loc-triv coherence lane genuinely does not contend for the same prover that is closing D3′/D4′/dual-chain — if it does, it should yield to the critical path.

### Route: A.4 — Albanese UP (Route 1 primary, Route 2 contingent)

- **Goal-alignment**: PASS — Route 1 (Weil's φ via divisor-sum, RR-free, in-tree) targets `isAlbaneseFor`.
- **Mathematical soundness**: PASS — well-definedness via `Mor(ℙ¹,A)` constant (Milne 3.2/3.10, bare rigidity, no Serre duality) is a sound RR-free path.
- **Infrastructure-deferral detected**: no — Route 2 autoduality is honestly flagged "UNVERIFIED for RR-freeness" and demoted to contingent, with a cheap scheduled literature check, while Route 1 carries the goal. Not a goal weakening.
- **Verdict**: SOUND

### Route: Route C — Riemann–Roch (PAUSED, USER, permanent)

- **Goal-alignment**: PASS — pause is a USER directive, not a project deferral; Route 1 / the engine route the goal around it.
- **Verdict**: SOUND (USER-mandated pause; not the critic's to overturn).

### Route: Genus-0 arm

- **Goal-alignment**: PASS — arm (a) transits A.2.c; arm (b) `J:=Spec k` is USER-paused.
- **Verdict**: SOUND.

## Format compliance

- **Size**: 144 lines / 12625 bytes — marginally **over budget** on bytes (12625 > ~12288 / 12 KB); within the line budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — verbatim: "D1′ axiom-clean **iter-255**" (Phases table, A.1.c.sub row); "scaffold lane dispatched **iter-256**" (A.2.c-engine row); "deferred **ONE iter**, not by inaction" and "blueprint chapter scheduled **next iter**" (Open strategic questions). Specific-iteration references belong in `iter/iter-NNN/plan.md`, not STRATEGY.md.
- **Accumulation detected**: no — paused routes (RR, genus-0 arm b) are retained context, not completed-phase clutter; the done group law occupies no phase row.
- **Table discipline**: PARTIAL/FAIL — column set is correct and the LOC cell carries both figures, but the **Status** and **Risks** cells contain multi-clause paragraph prose (the A.1.c.sub Status cell is a ~5-clause sentence). "One short line per cell" is violated.
- **Format verdict**: DRIFTED

## Must-fix-this-iter

- Format: DRIFTED — (1) strip the three explicit iteration references (`iter-255`, `iter-256`, "ONE iter"/"next iter") and re-phrase as state ("D1′ closed", "loc-triv coherence scaffold dispatched", "blueprint scheduled"); (2) compress the over-long Status/Risks table cells to one short line each (move the multi-clause detail to the iter sidecar); (3) trim ~350 bytes to get back under the 12 KB ceiling. In-place restructure this iter.

## Overall verdict

The strategic content is SOUND across all routes. On the directive's central question: the dual-inverse chain (`dual_restrict_iso` → `exists_tensorObj_inverse`) is genuinely on-path and is NOT a re-derivation of the inverse the carrier pivot made free — the free witness serves the `IsInvertible` carrier (`picCommGroup`, done), whereas `exists_tensorObj_inverse` establishes that the *loc-triv* subset is closed under inverse, which `RPF.addCommGroup` needs and which no carrier choice can avoid (it is "the dual of a line bundle is a line bundle"). The two-carrier design is internally consistent. On the second question: opening the A.2.c engine pole (`IsLocallyTrivial⟹IsFinitePresentation`) in parallel now is correct parallelism, not premature — it is provably independent of the unfinished comparison-iso substrate and is gated on prover capacity rather than on A.1.c.sub, with the sole caveat that the new lane must yield to the critical path if they contend for the same prover. No infrastructure-deferral findings: `Rⁱf_*`, the one construction the goal requires that could have been deferred, carries a concrete project-side Čech build, an unblocked fallback, and a next-iter blueprint slot. The only must-fix is format: STRATEGY.md has DRIFTED via per-iter narrative ("iter-255"/"iter-256"), over-long table cells, and a marginal byte-budget overrun — restructure in-place this iter.
