# Iter 023 — Plan (Quot-Foundations)

## TL;DR

A **corrective-then-dispatch** iter. Entry: iter-022 **closed the GF algebraic core
`genericFlatnessAlgebraic` axiom-clean** (GF-alg phase COMPLETE, vindicating iter-021/022's
GF-STUCK/CHURNING→pivot rebuttals) and landed the FBC `gstar_transpose` step-1 + conjugate-counit
scaffold (2nd PARTIAL). Both injected critics had already run (progress-critic `iter023` FBC **STUCK** /
GF-geo **UNCLEAR**; strategy-critic `iter023` GF reconcile + QUOT Serre CHALLENGE + format
NON-COMPLIANT). I executed the FBC STUCK must-fix corrective — **blueprint expansion**, exactly the type
the critic named — via an `effort-breaker` that split the gstar monolith into a 5-lemma `\uses`-linked
chain, then `blueprint-clean` + a fresh whole-blueprint `blueprint-reviewer` that **cleared the HARD GATE
for both lane chapters** (and confirmed the prior step-2 under-specification is resolved). Dispatched the
**two live frontier lanes**: FBC (fine-grained on the new chain) + GF-geo (prove `genericFlatness`). Also
rewrote STRATEGY.md to compliance and addressed the strategy-critic's three must-fixes.

## State at entry (iter-022 outcomes, verified)

- **GF 2→1 sorries** — `genericFlatnessAlgebraic` CLOSED axiom-clean (§4 dévissage over `C := B⧸p`,
  ring↔module bridge via `IsLocalizedModule.iso` + `extendScalarsOfIsLocalization`). GF-alg phase DONE.
  Sole GF sorry = geometric `genericFlatness` @~2173.
- **FBC 4 sorries (live=1)** — `gstar_transpose` PARTIAL: step-1 counit split + the `huce` conjugate
  scaffold (`conjugateEquiv_counit_symm` master identity) landed and compile; step-2/3 telescoping unmet.
  Dead `fstar_reindex_legs` @1421; deferred @1755/@1795.
- Build GREEN all modules (iter-022 verified at sha 7e2ae05).

## Subagents dispatched (4; all returned)

- **effort-breaker `fbc-gstar`** (the FBC STUCK corrective) — COMPLETE. Split
  `lem:base_change_mate_gstar_transpose` into a 5-lemma chain: Seam A `inner_unitReduce → inner_eCancel →
  inner_value_eq` (the ex-monolith `Γ_R(θ_in)=ρ`), Seam B `gstar_generator_close`, Seam C
  `gstar_counit_transport` (extracted from the landed `huce` scaffold). Target `effort_local` 4914→2978;
  all pieces ≤1364; no broken `\uses`. Flagged `inner_eCancel` as the still-hard re-break candidate.
- **blueprint-clean `fbc`** — COMPLETE. Stripped 4 project-history/Lean-leakage fragments from the new
  blocks; confirmed verbatim Stacks quotes on `inner_value_eq` + `gstar_generator_close`.
- **blueprint-reviewer `iter023`** (whole blueprint, HARD GATE) — **both lane chapters PASS**
  (`complete:true`, `correct:true`, no live must-fix). The FBC step-2 must-fix is RESOLVED by
  `inner_eCancel`. GF-geo `thm:generic_flatness` complete + faithful signature; algebraic core no longer
  described as sorry. DAG: 0 unknown_uses, 0 isolated, 0 orphan chapters, 0 new axioms.
- (progress-critic `iter023` + strategy-critic `iter023` were dispatched by the prior partial run before
  the context reset; consumed here.)

## Decision made

### FBC STUCK — honored via the named corrective (NOT a re-dispatch), pivot rebutted
The progress-critic's STUCK fires on real signal (zero sorry-elimination across 4 iters; same "step 2–3
~150-LOC" blocker twice) but explicitly says **no pivot** — the route is correct and structurally
advancing (step-1 + `huce` landed clean), and the gap is **blueprint adequacy + granularity**. Its named
corrective is blueprint expansion / effort-breaker decomposition, which I executed. The subsequent FBC
prover is therefore NOT a reworded re-dispatch of the monolith — it is fine-grained work on five
independently-checkable blocks the prior attempts did not have. This is the sanctioned "execute the
corrective, then dispatch" response, not a silent override.

### FBC merge-back tripwire (strategy-critic CHALLENGE) — rebutted
The strategy-critic notes the self-set "revisit merge-back necessity if Seam 2/3 stall ≥2 iters" tripwire
has fired (gstar live ≈3 iters). I rebut the implied *pivot to the ∃-iso/canonical-θ refactor*: the
"stall" cause is documentation granularity (now fixed), not route-shape — the progress-critic
independently confirms the route is correct and advancing. Pivoting to a merge-back refactor now would
discard the landed step-1/scaffold + the just-authored chain. Signal that would reverse me: the chain
itself stalls ≥2 iters (then re-break `inner_eCancel`, and only then reconsider merge-back).
**Classification of the two "long-term-deferred" FBC sorries** (strategy-critic ask): `affineBaseChange_pushforward_iso`
(@1755) and `flatBaseChange_pushforward_isIso` (@1795) ARE in the 29-node closure — they are the FBC goal
nodes (FBC-A affine reduction + FBC-B main theorem). Reclassified in STRATEGY as in-closure /
goal-required, sequenced after gstar, NOT "long-term-deferred." STRATEGY corrected.

### GF-geo — dispatch the prover this iter (progress-critic), not a refactor
GF-geo blueprint is complete + gate-cleared; the signature is faithful (`[IsQuasicoherent][IsFiniteType]`,
real fibrewise-flatness conclusion). Per the progress-critic, I dispatch the prover rather than spending
the lane on the cosmetic de-private/stale-comment cleanup (deferred to a GF-no-prover slot). It is a deep
geometry lane; partial progress with honest residuals is acceptable.

### QUOT S1 Serre-content (strategy-critic CHALLENGE) — addressed in STRATEGY, S1 NOT dispatched
The critic challenges the claim that the Hilbert-polynomial sublane is unconditionally Čech-independent:
the classical proof that `Γ_*(F)` is f.g. uses Serre H¹ vanishing, and the "Hartshorne II.5.17"
attribution is doubtful. I adopt the critic's **chosen-presentation alternative** as the primary S1 route
(f.g. *by construction*) and record honestly that making `Φ_s` a canonical invariant of `F`
(independent of the presentation) needs an `m≫0` agreement across presentations — a Serre-type input that
is likely genuinely required (Quot stratifies by Hilbert polynomial ⟹ `Φ` canonical). STRATEGY Open
questions now gates S1 on a reference read (confirm/replace the attribution; decide canonicity) BEFORE any
S1 prover. QUOT is not a prover lane this iter, so this is a strategy update, not a blocked dispatch.

## STRATEGY.md changes (strategy-critic must-fixes)
- GF-alg row MOVED to `## Completed` (done@022 · ~9 iters · ~900 LOC).
- FBC `@1755/@1795` reclassified as in-closure / goal-required (not "long-term-deferred").
- QUOT S1: chosen-presentation route + Serre caveat + reference-read gate added to Routes + Open questions.
- Format: per-iter narrative + `[verified iter-NNN]` stamps removed from table cells; cells compressed to
  one line; file 16.6KB → 12.8KB (135 lines). Headings order preserved.

## Subagent skips
- **strategy-critic**: NOT skipped — dispatched (`iter023`), STRATEGY changed materially this iter.
- **progress-critic**: NOT skipped — dispatched (`iter023`).
- **blueprint-reviewer**: NOT skipped — dispatched (`iter023`), chapters edited + new lane.

## Risks / watch
- `inner_eCancel` is the genuine hard piece (the ex-Seam-2 step-iii telescoping); the prover may only
  partially close it. Fallback (iter-024): re-dispatch effort-breaker to split its three cancellations.
- GF-geo plumbing (Γ(F,W) finite-module + affine cover) may exceed the LOC estimate (strategy-critic
  caveat); honest partial residuals expected if so.
