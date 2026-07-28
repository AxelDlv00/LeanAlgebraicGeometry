Both items landed (I-0715 issue, I-0716 memory).

# Review: ajcr-cert-r2, commits a65bd79c6 + 9fb1a5404

**Verdict: PROGRESSING, but the headline claim is over-sold — the new producer is vacuous on exactly the divisors the widening exists for.** The code is real, sorry-free, axiom-clean and kernel-green; nothing is faked. But a hypothesis inherited from the seed re-imposes the fixed-chart confinement that R2 was chosen to escape, so the "producer from geometry" cannot fire on any divisor the old chart-typed carrier could not already handle. That is the one finding that matters.

## Verification (lock-free, no mutex taken)

Both modules, zero diagnostics: `LEAN_PATH=/tmp/claude-1001/certr2-scratch:$(lake env printenv LEAN_PATH) lean AlgebraicJacobian/Picard/DivisorFamilyAffSeed{Gate,Section}.lean` → `EXIT=0`. Caveat on your scratch protocol: it broke three times mid-review because another lane's `lake build` was churning `.lake/build/lib/lean`, leaving symlinks dangling (`DivisorFamilyAffCollapse`, `Assemble`, `Fibre`, `Rank`, `AffMap` all vanished at some point). Recovery is a rebuild loop, not a retry.

Axiom probe with a firing control: all nine new declarations report exactly `[propext, Classical.choice, Quot.sound]`; control `ctrl_a` reports `sorryAx`.

## 1. Central claim — CONFIRMED, and by declaration closure, not grep

At `a65bd79c6^`, zero files in the whole AJCR tree mention both `ThetaGeneratorSeed` and `IsLocallyCertifiedAff`/`DivFamZarAff` (cross-grep in the ledger, both directions). Stronger, at HEAD: a `run_cmd` census over the environment finds 8 declarations whose *type* mentions both — all 8 are yours. A value-closure walk finds exactly 2 declarations producing a widened value whose closure reaches `ThetaGeneratorSeed` — again both yours. No hidden producer existed. Claim survives.

## 4 (promoted to first place). The chart typing IS smuggled back — through `hWle`

This is the damaging finding you asked for bluntly. `20bb502ae` (the follow-up commit, after the reviewed pair) found `relPinnedChart` in the closure and added a table, then concluded the residue is cosmetic: *"the widened route consumes it without ever needing the containment."* That sentence is false.

`hWle : W ≤ (D.localEquations hD).cover.opens z₀` **is** the containment. At a seed, `cover.opens z₀ = D.piece z₀` (`DivSchemeFamily.lean:351`, rfl) and `D.piece_le z₀ : D.piece z₀ ≤ relPinnedChart C R pi (D.side z₀)` (`DivSchemeFamily.lean:98`). Two probes, both `EXIT=0`:

- `/tmp/claude-1001/rev-probe/Chart.lean` — from `hsub` + `hWle` alone: `supportLocus ⊆ relPinnedChart C R pi (D.side z₀)`, proof `fun w hw => D.piece_le z₀ (hWle (hsub hw))`.
- `/tmp/claude-1001/rev-probe/Straddle.lean` — if the support has a point off `V₀` and a point off `V₁`, then **no** tuple `(W, hW, hsub, z₀, hWle)` exists.

So the gate's hypothesis set is *empty* for every straddling divisor. Straddling divisors are the entire payoff: `DivisorFamilyAffStrict.lean:186` proves strictness by exhibiting one — at a **bare** `LocalEquations` whose cover is unconstrained. Your gate is that theorem restated at a seed, and at a seed the restatement voids it. You are right that this is not a clause-3 breach (clause 3 governs the certificate clauses, and those are clean: no `FinCoverData`, no `ChartTyping`, and notably no `relCover_sup`). But clause 5 governs the *route*, and this route keeps the support inside the fixed pair.

## 2. The `Away (1 : R)` composition — legitimate, NOT vacuous

`CertifiedDivisorFamilyAff.isLocallyCertifiedAff` (`DivisorFamilyAffGlueZarKit.lean:575`) witnesses `IsLocallyCertifiedAff` at `g = ![1]`, `Ideal.span {1} = ⊤`. Yes, `Localization.Away (1 : R)` is essentially `R`. But that does not weaken the predicate: `IsLocallyCertifiedAff` (`DivisorFamilyAffZar.lean:103`) is an *existential* over span-⊤ families, so "the trivial cover works" is a legitimate discharge of an ∃, exactly as the chart-typed `isLocallyCertified_of_isCertified` (`DivSchemeCertZarSeed.lean:150`) does. The "locally" is a genuine relaxation in the other direction — it lets a *weaker* input suffice; it does not weaken the conclusion. A reader is not misled. Your docstring at `DivisorFamilyAffSeedGate.lean:112-115` states this correctly, and flags that the per-prime form remains needed for degree data only available after shrinking. Claim survives.

## 3. Joint satisfiability — the caveat WAS missing from the reviewed commits, and was fixed after

At `a65bd79c6`/`9fb1a5404` neither file mentioned the `n = 0` caveat: correct finding, and it was your own. `20bb502ae` added `isLocallyCertifiedAff_of_supportLocus_empty` (`DivisorFamilyAffSeedGate.lean:308`) plus a scope note reading it at exactly the endpoint's strength ("not about nothing", never "non-trivially inhabited"). The transfer is legitimate — the gate's hypotheses are literally the endpoint's. But note the interaction with the finding above: the only inhabitation witness has *empty support*, and the probe shows non-empty straddling supports are *refuted*, not merely un-witnessed. The hypothesis set is inhabited only in a region where the widening buys nothing.

## 5. `divFunctorAffSection` is more than a rename — CONFIRMED

`(divFunctorAff C n).obj (op (overSpec k R))` unfolds to `divFamZarAff C n (overSpec k R)`, and `divFunctorAff` is a real functor with `map_id`/`map_comp` proved (`DivisorFamilyAffMap.lean:290`, over `divFamZarAff.map` at `:208`). The identification lemma is in the useful direction: `divFamZarAffAffineEquiv ... (divFunctorAffSection ...) = divFamZarAff_of_swallowing_affineOpen ...`, i.e. a consumer holding the section recovers the certificate's class. `divFunctorAffSection_val` gives the equivalence-free value by `rfl`. Your staleness claim is also correct: `divFamZarAff.map` exists at HEAD (`DivisorFamilyAffMap.lean:208`), so `divFamZarAffAffineEquiv`'s docstring caveat at `DivisorFamilyAffVehicle.lean:204-207` ("does not exist yet") is stale — and you correctly noted it in your own file rather than editing another lane's.

## 6. Scope honesty — one defect, otherwise good

The representability and general-test disclaimers (`DivisorFamilyAffSeedSection.lean:40-45`) are accurate; nothing implies more. The commit messages are also honest, including "no gate cleared" style admissions elsewhere in the lane. The single scope defect is the sentence quoted in finding 4 — and it is in the *newest* commit, so it is live.

## Throughput

Not churning: both commits add real, consumed-shaped declarations, and the self-audit commit `20bb502ae` is exactly the right instinct. The concern is a different one: `divFunctorAffSection` and `divFamZarAff_of_swallowing_affineOpen` have **zero consumers** outside their own files, and `DivRepGlobalAffLift.lean` — named in your docstring as the consumer — references `divFunctorAff` only in prose, not in a signature. Combined with finding 4, the lane has built a functorially-correct bridge whose input side cannot be fed by this project's only seed notion.

Files: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyAffSeedGate.lean`, `.../DivisorFamilyAffSeedSection.lean`, `.../DivSchemeFamily.lean`, `.../DivisorFamilyAffStrict.lean`, `.../DivisorFamilyAffGlueZarKit.lean`, `.../DivisorFamilyAffVehicle.lean`. Probes: `/tmp/claude-1001/rev-probe/{Chart,Straddle,Census,Census2,Probe}.lean`. Inbox: I-0715 (issue), I-0716 (memory).
