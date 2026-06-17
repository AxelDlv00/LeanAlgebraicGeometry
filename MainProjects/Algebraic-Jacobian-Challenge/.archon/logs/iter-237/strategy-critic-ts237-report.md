# Strategy Critic Report

## Slug
ts237

## Iteration
237

## Routes audited

### Route: A.1.c.SubT — ⊗-group law (carrier `IsInvertible`, inverse free)

- **Goal-alignment**: PASS — a by-hand `CommGroup` on tensor-invertibility is a sound carrier for `Pic X`; the inverse-as-witness reduction is correct (Stacks 0B8M).
- **Mathematical soundness**: PASS — the associator-via-d.2 argument is valid: a `J.W`-morphism is a stalkwise iso and `(F◁g)_x = id ⊗ g_x`, so the stalk-tensor commutation makes `isLocallyInjective_whiskerLeft_of_W` close unconditionally.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no (the prior d.2 gap is now BUILT — see below).
- **Effort honesty**: STALE / under-counted-in-the-wrong-direction — the row reads `~0/it` velocity and "sole remaining bottleneck = d.2 stalk-tensor for the UNCONDITIONAL associator", but `PresheafOfModules.stalkTensorIso` is in-tree and axiom-clean (verified: axioms `propext, Classical.choice, Quot.sound` only). d.2 is DONE. The document does not reflect the milestone the directive describes.
- **Verdict**: SOUND (content) — but the document is materially stale; see Format compliance. The planner must rewrite this row so the bottleneck reads "wire `stalkTensorIso` into `tensorObj_assoc_iso`, then close the by-hand `CommGroup`," drop the `~0/it`, and move d.2 from `## Mathlib gaps` "PRIMARY GAP" to done.

### Route: A.1.c — RelPic functor
- **Verdict**: SOUND — honestly flagged as held with dishonest placeholder bodies to re-engage; re-basing `OnProduct`/RPF onto `IsInvertible` is cheap and correctly scoped.

### Route: A.2.c — representability (scaffolding)
- **Verdict**: SOUND — `⟨sorry⟩` Prop-typeclass scaffolding with the engine as the honest discharge is a standard, legitimate pattern; LOC is large but flagged.

### Route: A.2.c-engine — Quot/Cartier (RR-free)
- **Goal-alignment**: PASS — RR-free representability of `Pic_{C/k}` is genuinely reachable via Quot/Hilbert (Nitsure §5, Kleiman §4) without RR.
- **Effort honesty**: reasonable-but-enormous — `~3400–5500 LOC` over `~30–60` iters is honestly the project's dominant cost and is labelled as such. No dishonesty, but see the cross-cutting risk in Must-fix: this entire RR-avoidance engine is only worthwhile if RR is avoidable *end-to-end*, which the terminal `isAlbaneseFor` node does not yet establish.
- **Verdict**: SOUND — but its strategic justification ("exists solely to avoid RR") is hostage to the unverified Albanese RR-freeness below.

### Route: A.4 — Albanese UP (Route 2, autoduality)
- **Goal-alignment**: PARTIAL — `isAlbaneseFor` IS goal-required (it is the only pointing-quantified protected obligation). Route 2 reaches it via Kleiman `rmk:Alb` on the dual `J^∨` landed on `J` by autoduality `J^∨≅J`. The landing step is classically the principal polarization via the theta divisor, which rests on Riemann–Roch.
- **Mathematical soundness**: PARTIAL — the autoduality step's RR-freeness is asserted-pending, not established. STRATEGY itself: "classically RR-dependent (theta-divisor proof rests on RR — top risk)."
- **Infrastructure-deferral detected**: YES — the goal-required terminal construction (an RR-free route to `isAlbaneseFor`) has no *verified-viable* plan. Route 2 is named "the ONLY planned path" while its key step may need the permanently-paused Route C, and the strategy admits "a fallback must be named" without naming one. See Infrastructure-deferral findings.
- **Verdict**: CHALLENGE — the RR-freeness of the autoduality landing must be second-verified NOW (cheap literature check), not deferred to "before any Route-2 LOC" (which is ~50 iters out behind A.2.c). The whole RR-free engine investment is predicated on RR being avoidable at *every* goal node; if the terminal node is irreducibly RR-dependent, the engine's premise collapses. This is exactly the verification that protects the largest downstream investment, so its cost-to-defer is maximal.

### Route: Genus-0 arm
- **Verdict**: SOUND — `J := Spec k` via char-free rigidity (no theorem-of-cube, no cohomology) is RR-free and well-substrated; correctly the cheap arm.

## Format compliance

- **Size**: 146 lines / 12398 bytes — marginally OVER budget (~12288 byte / 12 KB ceiling). Minor.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: YES — `"(iter-212 finding)"` in `## Routes`, and `"(strategy-critic ts233 CHALLENGE — verify before any Route-2 LOC.)"` in `## Open strategic questions`. Per-iter / per-subagent references belong in iter sidecars.
- **Accumulation / staleness detected**: YES — and this is the material violation. d.2 (`stalkTensorIso`) is BUILT and axiom-clean, but the document still presents it as the unbuilt "**Sole remaining bottleneck = d.2**" (Routes), the A.1.c.SubT phase-row Status, and "**PRIMARY GAP = d.2**" with future-tense "Once d.2 lands, the associator is unconditional" (`## Mathlib gaps`). The strategy describes a solved problem as the open frontier. A fresh reader (or the next plan agent) would mis-prioritize re-building what is already done.
- **Table discipline**: PASS — proper Markdown table with the required columns; the A.1.c.SubT Status cell is verbose but tolerable.
- **Format verdict**: DRIFTED — fix the d.2 staleness in-place this iter (it is not cosmetic: it inverts the document's account of what remains), strip the two per-iter references, trim ~110 bytes.

## Infrastructure-deferral findings

### Deferred: an RR-free route to `isAlbaneseFor` (the Albanese universal property)
- **Required by goal**: yes — `isAlbaneseFor` is the pointing-quantified protected obligation; the goal does not hold without it.
- **Current plan for building it**: Route 2 (Kleiman `rmk:Alb` on `J^∨` + autoduality `J^∨≅J` + Galois descent), explicitly named "the ONLY planned path," whose autoduality step is classically RR-dependent and is flagged UNVERIFIED. The strategy concedes "a fallback must be named" and names none.
- **Timeline**: absent — gated behind A.2.c (~12–16 iters) and the engine (~30–60 iters); the RR-freeness verification is itself deferred to "before any Route-2 LOC," i.e. indefinitely.
- **Verdict**: CHALLENGE — not REJECT, because a concrete RR-free alternative exists and is already substrated (see Alternative below), so the goal is not provably unreachable. But the strategy must either (a) verify autoduality RR-freeness now, or (b) promote the RR-free rigidity/rational-map route to primary. Continuing to pour LOC into an RR-avoidance engine while the terminal node's RR-freeness is unverified is the deferral pattern: the hardest prerequisite (avoid RR at the Albanese node) is renamed "top risk" rather than resolved.

## Alternative routes (suggested)

### Alternative: Weil's RR-free Albanese via rigidity + rational-map extension (promote Route 1)
- **What it looks like**: Build `φ : Pic⁰_{C/k} → A` for `f : C → A`, `f(P₀)=0`, by the divisor-sum map `[Σnᵢ(Pᵢ−P₀)] ↦ Σnᵢ f(Pᵢ)`. (i) Well-definedness on `Pic⁰` (principal divisors ↦ 0) reduces to `Mor(ℙ¹,A)` being constant — the reference card for `abelian-varieties.md` states this is proved "via bare rigidity, NO Serre duality" (Milne 3.2/3.10). (ii) Generation of `Pic⁰` by the Abel–Jacobi image is tautological: a degree-0 divisor `ΣnᵢPᵢ` with `Σnᵢ=0` literally equals `Σnᵢ(Pᵢ−P₀)`, so uniqueness/surjectivity of `φ` needs no RR-driven `Sym^g` birationality. (iii) Regularity of `φ` follows from the rational-map-into-AV extension theorem (Milne Thm 3.2), which is RR-free and is exactly `Albanese/Thm32RationalMapExtension.lean` (+ `CodimOneExtension.lean`, `AbelianVarietyRigidity.lean`).
- **Why it might be cheaper or sounder**: it never touches the theta divisor / autoduality, so it sidesteps the RR collision entirely; its substrate is already in-tree (63 KB + 105 KB + 19 KB of Lean, plus the `AbelianVarietyRigidity` blueprint chapter, which self-documents as char-free and cohomology-free). The strategy is currently treating its own RR-free asset as "superseded."
- **What the current strategy may have rejected**: STRATEGY says Route 2 "Supersedes the Route-1 codim cone." The supersession appears to be a cost/elegance judgement made when RR was assumed available; under the *permanent* Route C pause it is inverted — the RR-free route should be primary and the RR-dependent autoduality route the fallback.
- **Severity of the omission**: critical — it is the named fallback the strategy says it lacks, and it bears directly on whether the goal is reachable under the RR pause.

## Sunk-cost flags

- `"Albanese UP — Route 2 ... Supersedes the Route-1 codim cone, retained reversibly"` — Why this is sunk-cost-adjacent: Route 2 is preferred over an already-built RR-free alternative on a supersession decision that predates the permanent RR pause; the strategy keeps Route 1 only "reversibly" rather than re-evaluating it on current merits. Recommendation: re-rank both routes on RR-freeness under today's pause, not on the historical elegance comparison.

## Prerequisite verification

- `PresheafOfModules.stalkTensorIso` (the d.2 milestone): VERIFIED — present in `AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`, axioms `{propext, Classical.choice, Quot.sound}`, no project axioms.
- `Albanese/Thm32RationalMapExtension.lean`, `AbelianVarietyRigidity.lean`, `CodimOneExtension.lean` (RR-free alternative substrate): VERIFIED present (non-trivial, recently modified).

## Must-fix-this-iter

- Format: DRIFTED → must-fix. **The document is stale w.r.t. the d.2 milestone.** Rewrite the A.1.c.SubT phase row, the `## Routes` "Sole remaining bottleneck = d.2" sentence, and the `## Mathlib gaps` "PRIMARY GAP = d.2 ... Once d.2 lands" block to reflect that `stalkTensorIso` is BUILT; the remaining bottleneck is wiring it into `tensorObj_assoc_iso` + closing the by-hand `CommGroup`. Also strip the two per-iter references (`iter-212`, `strategy-critic ts233`) and trim ~110 bytes to get under 12 KB.
- Route A.4 (Albanese UP): CHALLENGE — second-verify autoduality `J^∨≅J` RR-freeness NOW, decoupled from "before any Route-2 LOC." If it is RR-dependent (likely — theta divisor), the strategy must name the RR-free fallback explicitly in `## Routes`.
- Infrastructure-deferral (RR-free `isAlbaneseFor`): CHALLENGE — the goal-required terminal construction has no verified-viable RR-free plan. The planner must either verify Route 2's RR-freeness or promote the Weil/rigidity route this iter (at minimum, name it as the fallback in STRATEGY.md).
- Alternative (Weil RR-free Albanese via rigidity + Milne Thm 3.2): critical omission — already substrated in-tree; STRATEGY must stop framing Route 2 as "the ONLY planned path."

## Overall verdict

The post-milestone critical-path arc A.1.c.SubT → A.1.c → A.2.c is SOUND and the d.2 landing genuinely advances it; the carrier-on-invertibility group law and the associator-via-`stalkTensorIso` argument are mathematically correct, and `stalkTensorIso` is verified axiom-clean. Two things, however, must be fixed this iter. First, **the strategy document does not reflect the milestone**: it still names d.2 as the unbuilt "sole remaining bottleneck / PRIMARY GAP," which mis-describes a solved problem as the frontier — a material staleness/accumulation violation, not a cosmetic one. Second, and more consequentially, **the strategy defers an RR-free route to `isAlbaneseFor`, which is required for the stated goal**: it names autoduality Route 2 as the ONLY path to `isAlbaneseFor`, concedes that step is classically RR-dependent (theta divisor) while Route C is permanently paused, and admits "a fallback must be named" without naming one — even though the project already holds a substrated, char-free, cohomology-free alternative (Weil's construction via abelian-variety rigidity + Milne Theorem 3.2 rational-map extension, whose own blueprint chapter advertises "neither the theorem of the cube nor any cohomology"). The verification of autoduality's RR-freeness is cheap and protects the entire RR-avoidance engine investment, so it must happen NOW rather than ~50 iters downstream; and the RR-free rigidity route should be re-ranked to primary (or at minimum named as the fallback) under the permanent RR pause. Deferring this is the project's one live dead-end risk.
