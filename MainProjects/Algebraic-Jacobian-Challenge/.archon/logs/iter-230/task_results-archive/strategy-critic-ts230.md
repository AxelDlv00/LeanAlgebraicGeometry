# Strategy Critic Report

## Slug
ts230

## Iteration
230

## Routes audited

### Route: A.1.c.SubT — ⊗-group law substrate (the ⊗-inverse block)

- **Goal-alignment**: PASS — the by-hand `CommGroup` on locally-trivial iso-classes is a genuine prerequisite for RelPic → representability → `Pic⁰`. Not a detour.
- **Mathematical soundness**: PASS — and it survives the obvious-alternative test. The natural skeptic's objection ("why glue a global morphism when the canonical evaluation `L ⊗ L^∨ → 𝒪_X` already exists?") is anticipated and correctly answered by the strategy: the sheaf-level ⊗ forces sheafifying the eval map, which re-hits the `M ◁ η` whiskering (the abandoned d.2), so the eval-map route is genuinely a dead end at the sheaf level. The direct-gluing route reconstructs the *same* canonical pairing by gluing local trivial-case isos (which agree on overlaps precisely because the eval pairing is choice-independent), dodging sheafification. This is sound and the choice between the two is correctly resolved.
- **Sunk-cost reasoning detected**: no — the "`CommRing.Pic` not reusable / build by hand" justification is on the merits (varying `𝒪_X` ⇒ no coherent fixed-ring `MonoidalCategory`), not "we already did it." The vestigial whiskering apparatus is flagged for *deletion*, which is the opposite of sunk-cost.
- **Effort honesty**: under-counted (minor) — the LOC cell reads `~0/it` while the row is the *sole actively-worked lane* and claims 3–5 iters to land ~250–450 LOC. A `~0/it` realized velocity does not support a 3–5-iter close; the estimate implicitly assumes a jump to ~50–150/it the moment a consumer wires. Also: "assembly 1 iter" folds in re-routing `tensorObj_assoc_iso` off the to-be-deleted whiskering apparatus — that re-proof is real work, not bookkeeping.
- **Verdict**: CHALLENGE — the route is sound, but the iter-229 WATCH is genuinely untested and must not be marked addressed by wiring the wrong consumer (see WATCH re-verification below).

### Route: A.2.c — representability + Quot fork (held)

- **Verdict**: SOUND — held behind A.1.c.SubT→A.1.c with `⟨sorry⟩` scaffolding; the RR-free engine vs cheap-curve fork is honestly surfaced. `~0/it` is consistent with "held."

### Route: Albanese UP — Route 2

- **Mathematical soundness**: PARTIAL — rests on autoduality `J^∨≅J` whose RR-freeness is flagged UNVERIFIED and classically RR-dependent; the strategy correctly gates Route-2 investment behind re-verifying this. The Galois-descent `k̄→k` composition at the no-`C(k)` heart is also flagged for verification.
- **Verdict**: SOUND — the two load-bearing risks are surfaced as open questions and gated; no hidden assumption.

### Route: Route C — Riemann–Roch (USER PAUSE)

- **Goal-alignment**: PARTIAL — the cost-asymmetry comparison that frames the USER fork is incomplete. "divisor route ≈ Kleiman §5 (~600–1000 LOC) + the paused RR chain" never numbers the RR chain itself. The "~5×/2–4× cheaper" claim compares (RR-free engine, no RR) against (divisor + a *full RR proof of unstated cost*). For the user to make this fork decision, the RR-chain LOC must be estimated — RR for smooth proper curves over a general field (no CharZero) is itself a substantial build, and the goal requires it sorry-free on the divisor side.
- **Verdict**: CHALLENGE (minor) — number the RR chain so the LIVE user-fork FYI is actually actionable. Posture (keep building the sole ungated lane, don't unilaterally lift the pause) is otherwise correct.

### Route: Genus-0 arm

- **Verdict**: SOUND — both sub-arms (AV-wrap transit; direct `Spec k` via rigidity) are paused/gated honestly.

## Format compliance

- **Size**: 128 lines / ~9 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive. E.g. the A.1.c.SubT Status cell: "`(iter-229: overSliceSheafEquiv axiom-clean ...)`" and "`iter-230 = CONVERGENCE TEST`"; Open questions: "`shared root LANDED (iter-229)`", "`iter-230 = the CONVERGENCE TEST`". Per-iter history belongs in the iter sidecar.
- **Table discipline**: FAIL (mild) — the A.1.c.SubT Status cell is a multi-sentence paragraph carrying iter narrative; Status cells must be one short line.
- **Format verdict**: DRIFTED

## Sunk-cost flags

(none — the by-hand `CommGroup` and the whiskering-deletion plan are both justified on merits.)

## Must-fix-this-iter

- **Route A.1.c.SubT: CHALLENGE — re-verified LIVE WATCH (binding question).** The shared root `overSliceSheafEquiv : Sheaf J A ≌ Sheaf K A` is value-category-FIXED. The two consumers do NOT carry equal residual risk: the A-engine `homOfLocalCompat` is at value cat **Type** and its transport shadow (`homMk`) involves no ring action — it is the clean case. The C-bridge `dual_isLocallyTrivial` is at value cat **ModuleCat over the *varying* ring `𝒪_X(U)`**, and a fixed-value-cat site equivalence does NOT transport the module action for free. The suspected 4th cost growth is entirely concentrated in C: composing the fixed-A root with `restrictScalars`/CommRingCat transport may require a naturality square between the site equivalence and the varying-ring restriction — worst case it forces re-deriving the equivalence at the *module fibration* (ModuleCat-over-varying-ring), which would be a re-build, not a "compose with a shadow," and would falsify the "one shared root unblocks both" framing for C. The WATCH stays **LIVE**. Planner must, this iter, either resolve it (wire C and report the outcome) or explicitly record that the WATCH remains live.

- **Probe ordering (answers directive Q2): C-bridge IS the correct first probe — but guard against false confidence.** Because the suspected cost growth lives only in C, wiring the A-engine first would produce a green checkmark that does **not** discharge the binding question (Type carries no varying-ring transport). The danger is reporting "a consumer wired ⇒ root validated for both" — false. Recommendation: the iter-230 prover wires **C first**, and explicitly reports *which* of the two outcomes occurred — (i) the module transport is a clean compose onto the fixed-value-cat root (WATCH resolved, block converges fast), or (ii) it forces re-deriving the equivalence at ModuleCat-over-varying-ring (the 4th cost growth has materialized; re-scope). Keep the A-engine as the fallback convergence datapoint (it is independent and required regardless), but do not let an A-wiring stand in for resolving the WATCH.

- **Route C: CHALLENGE (minor) — number the RR chain** in the cost-asymmetry comparison so the LIVE user fork is actionable; the divisor arm's RR-proof cost is currently unstated.

- **Format: DRIFTED — strip per-iter narrative.** Move all `iter-229`/`iter-230` references out of STRATEGY.md into the iter sidecar, and collapse the A.1.c.SubT Status cell to one line. The route content survives this edit unchanged.

## Overall verdict

The strategy is mathematically sound and goal-aligned: the ⊗-inverse direct-gluing route correctly beats the obvious canonical-eval alternative (which is the already-identified d.2/whiskering dead end), the by-hand `CommGroup` is justified on merits not sunk cost, and the downstream gating is honest. The binding open question — the iter-229 WATCH — is genuinely LIVE and I re-confirm it: the value-category-FIXED shared root does **not** transport the C-bridge's varying-ring `𝒪_X`-module structure for free, so the "one shared root unblocks both consumers" framing understates the C cost, and the suspected 4th cost growth is concentrated entirely in the C-bridge. For that reason the C-bridge is the right first probe (it is the only consumer that exercises the risk); the failure mode to avoid is substituting the trivial A-engine (value Type) wiring and treating the WATCH as addressed. The standing RR-fork escalation is correctly LIVE, but its asymmetry is under-specified — the divisor arm's RR-proof LOC is unstated, leaving the user fork under-informed. Finally, STRATEGY.md has DRIFTED on format via pervasive per-iter narrative (`iter-229`/`iter-230`) and an overlong Status cell; strip these in place this iter.
