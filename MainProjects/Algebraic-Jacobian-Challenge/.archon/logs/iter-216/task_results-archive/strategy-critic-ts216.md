# Strategy Critic Report

## Slug
ts216

## Iteration
216

## Routes audited

### Route: A.1.c.SubT — ⊗-group law (the "restructured route" / Challenge 1)

- **Goal-alignment**: PARTIAL — the substrate produces a group law on `Pic X`, but it is **route-A-specific machinery, not goal-mandated**. `## Goal` requires `Pic⁰_{C/k}` to carry a group law; it does NOT require that law to come from the `SheafOfModules` ⊗. A divisor-class law (`Cl(C)=Div/principal`, the cheap RR route) is an equally valid source. Its necessity is contingent on the unresolved RR fork (see Challenge 2).
- **Mathematical soundness**: PASS (core claim) — "the group law on iso-classes consumes only *existence* of the assoc/unit/braid isos, never the pentagon/coherence" is **correct and has a direct Mathlib precedent**: `CommRing.Pic` / `instCommGroupPic : CommGroup (CommRing.Pic R)` is built straight on `Module.Invertible` iso-classes with NO monoidal category. Deleting the pentagon/coherence obligation is justified.
- **Sunk-cost reasoning detected**: no — the pivot *deletes* prior work (the d.1 stalk, whiskering wall); the risk here is the opposite (thrash), not sunk cost.
- **Infrastructure-deferral detected**: yes (potential) — the pivot replaces the deleted `J.W.IsMonoidal`/whiskering wall with `tensorObj_restrict_iso`, whose stated H1 (`pushforwardPushforwardAdj` + presheaf `pushforwardNatTrans`/`pushforwardCongr`) is *also* Mathlib-absent and of "uncertain depth (1–3 iters)." Both the old and new hardest prerequisites encode the same underlying content — *"sheaf-tensor of locally-trivial modules behaves well under sheafification/restriction."* Per the pivot test, if the hardest prerequisite is the same gap one layer deeper, the pivot is avoidance. It is rescued ONLY if `tensorObj_restrict_iso` is proven narrowly on the trivializing (free) cover — where sheaf-tensor = presheaf-tensor with no sheafification — rather than as a general pushforward-adjunction lemma. The strategy does not demonstrate this; it asserts the new path is cheaper.
- **Phantom prerequisites**: `monoidOfSkeletalMonoidal` is **mis-cited** — it exists (`CategoryTheory.monoidOfSkeletalMonoidal`) but its signature is `[MonoidalCategory C] → Skeletal C → Monoid C`; likewise `Skeleton.instCommMonoid` needs `[MonoidalCategory C] [BraidedCategory C]`. Using it REQUIRES building the full coherent monoidal category the strategy claims to avoid. Only the *other* cited analogy, `CommRing.Pic`, actually supports "build directly, no monoidal category." Citing both as if equivalent is a trap that will force a future implementer back into the deleted apparatus.
- **Effort honesty**: under-counted / stagnation signal — the row reads "~200–400 · ~0 net sorry/it (6-iter flat)" while still "active" with 3–6 iters projected. Six iters flat at zero net progress is the infrastructure-deferral-by-inaction signature; the row's own numbers confirm the substrate is stuck, and the pivot's cost advantage over the thing it deletes is unquantified (both Mathlib-absent, both "1–3 iters uncertain").
- **Verdict**: CHALLENGE

### Route: A.1.c — RelPic functor

- **Goal-alignment**: PASS — needed under either discharge route.
- **Verdict**: SOUND — held behind SubT honestly; the "replace dishonest `PicSharp := const PUnit`" note is a correct self-flag, not a concern.

### Route: A.2.c — representability + Quot fork (Challenge 2)

- **Goal-alignment**: PASS — A.2.c representability is the literal gate to the protected `Jacobian` decls.
- **Mathematical soundness**: PASS — both fork prongs (RR-free Quot/Cartier engine; RR-lifted `Sym^n`/Abel–Jacobi) are sound classical constructions.
- **Sunk-cost reasoning detected**: no — but a **sequencing risk**: the strategy is grinding the *hardest* substrate linchpin (A.1.c.SubT, Mathlib-absent) NOW, while the RR fork it has escalated to USER could moot that very substrate. If the USER lifts the pause and the project takes the `Sym^n`/divisor-class route, the ⊗-group-law substrate is plausibly discarded (the group law would come from `Cl(C)`, for which the project already has `WeilDivisor`/`OcOfD`). Sinking the most expensive substrate iters before the fork resolves is questionable.
- **Infrastructure-deferral detected**: no (legitimate gate) — the engine is HELD behind A.1.c, not deferred to "upstream Mathlib"; it has a concrete (if large) LOC/iter estimate. That is an honest gate, not a goal-weakening.
- **Effort honesty**: reasonable — engine ~3400–5500 LOC / 30–60 iters is the dominant cost (≈⅓–½ of the ~90–170-iter Route-A total). Confirmed as the project's dominant cost/risk. The ~5× gap vs the RR-lifted route (~600–1000 LOC) is correctly the project's single highest-leverage decision.
- **Parallelism under-exploited**: no — appropriately serialized behind its true prerequisite.
- **Verdict**: CHALLENGE — fork identification and USER-escalation are correct (escalating is the *only* valid move under a standing USER pause). What must be addressed: justify continuing the expensive SubT linchpin while the escalated decision could moot it — either (a) confirm the ⊗-group-law substrate is required under BOTH fork outcomes, or (b) prefer cheaper/reversible substrate or parallel non-substrate work until the USER resolves the fork.

### Route: A.2.c-engine — Quot/Cartier (RR-free)

- **Verdict**: SOUND — honestly gated and estimated; not a deferral. Its existence is the *cost* of the RR pause, correctly stated.

### Route: Albanese UP (Route 2) / A.3 / A.4 / Route C / genus-0

- **Verdict**: SOUND — each honestly gated. The autoduality `J^∨≅J` RR-freeness flag (top risk, "theta divisor rests on RR") is a correctly-surfaced open question, not hidden. Route C PAUSED is a USER directive, correctly recorded.

## Format compliance

- **Size**: 111 lines / ~11 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes — pervasive. Verbatim: "active; **iter-216 PIVOT**: DELETE vestigial…", "**iter-216 PIVOT (mathlib-analogist ts216, CRITICAL):**", "H2 bottom gap … closed **iter-215**", "the **6-iter** open-sorry wall", "**ESCALATED to USER iter-216**", "The **iter-216 PIVOT** first DELETES…". Per-iter history belongs in `iter/iter-NNN/plan.md`, never in STRATEGY.md.
- **Accumulation detected**: yes (mild) — deletion/"VESTIGIAL"/"Dead realizations (do NOT revisit)"/"Dead-end (do NOT re-attempt)" transition narrative is excised-route bookkeeping that belongs in a sidecar, not standing strategy.
- **Table discipline**: FAIL — the `## Phases & estimations` cells carry multi-line paragraphs (the A.1.c.SubT Status cell alone is a full paragraph). Spec is "one short line per cell."
- **Format verdict**: NON-COMPLIANT

## Infrastructure-deferral findings

### Deferred: sheaf-level associator existence for invertible 𝒪_X-modules (`tensorObj_restrict_iso` vs `J.W.IsMonoidal`)

- **Required by goal**: partially — *some* group law on `Pic⁰` is required; this *particular* ⊗-substrate construction is route-A-specific, not goal-mandated.
- **Current plan for building it**: build `tensorObj_restrict_iso` by hand (H1 = Mathlib-absent presheaf `pushforwardPushforwardAdj` + `pushforwardNatTrans`/`pushforwardCongr`) + Hom-sheaf gluing. The deleted alternative — prove `J.W.IsMonoidal` and consume Mathlib's ready-made `CategoryTheory.Sheaf.monoidalCategory` (verified to exist, gated exactly on `[J.W.IsMonoidal]`+`[HasWeakSheafify]`) — is dropped without a head-to-head cost comparison.
- **Timeline**: vague — "uncertain depth (1–3 iters)"; same uncertainty band as the 6-iter wall it replaces.
- **Verdict**: CHALLENGE — the planner must either tie `tensorObj_restrict_iso` to the trivializing-cover/local-triviality structure (making it provably smaller than `J.W.IsMonoidal`) or justify the pivot against the `Sheaf.monoidalCategory` path it deleted.

## Alternative routes (suggested)

### Alternative: prove `J.W.IsMonoidal`, consume Mathlib `Sheaf.monoidalCategory`, then iso-classes à la `CommRing.Pic`

- **What it looks like**: discharge the one typeclass `[J.W.IsMonoidal]` (the local-iso morphism class is monoidal) → Mathlib's `CategoryTheory.Sheaf.monoidalCategory` + `symmetricCategory` hand you α/λ/ρ/β on `SheafOfModules` for free (coherence included) → build `CommGroup` on locally-trivial iso-classes directly, exactly as `instCommGroupPic` does over `Module.Invertible`.
- **Why it might be cheaper or sounder**: it targets ONE named, reusable, Mathlib-aligned obligation instead of a hand-rolled `pushforwardPushforwardAdj` sub-chain of unknown depth; it cannot accidentally re-introduce coherence because Mathlib supplies it; and `PresheafOfModules.monoidalCategory` already provides the presheaf half.
- **What the current strategy may have rejected**: the whiskering lemma `isLocallyInjective_whiskerLeft_of_W` (the "6-iter wall") is the cited blocker for `J.W.IsMonoidal`. But the pivot's replacement is also Mathlib-absent and unbounded, so the rejection is asserted, not shown.
- **Severity of the omission**: major — the two paths should be compared head-to-head before committing the project's hardest current iters to the hand-built one.

### Alternative: divisor-class group law (`Cl(C)=Div(C)/principal`) under an RR-lifted route

- **What it looks like**: if the USER lifts the RR pause, build `Pic⁰` group law from Weil-divisor classes (project already has `WeilDivisor.lean`, `OcOfD`), bypassing the `SheafOfModules` ⊗-substrate entirely.
- **Why it might be cheaper or sounder**: collapses A.1.c.SubT (the current bottleneck) into existing divisor infrastructure; aligns with the ~5×-cheaper `Sym^n`/Abel–Jacobi A.2.c route.
- **What the current strategy may have rejected**: held behind the RR pause; not evaluated as a *substrate*-replacing option, only as an A.2.c-discharge option.
- **Severity of the omission**: major — it reframes the SubT grind as fork-contingent rather than unconditional critical path.

## Prerequisite verification

- `CommRing.Pic` / `instCommGroupPic`: VERIFIED (`Mathlib.RingTheory.PicardGroup`; built on `Module.Invertible`, direct CommGroup).
- `CategoryTheory.monoidOfSkeletalMonoidal`: VERIFIED-BUT-MISCITED — exists, but requires `[MonoidalCategory C]`; does not support "no monoidal category."
- `CategoryTheory.Sheaf.monoidalCategory`: VERIFIED — gated on `[J.W.IsMonoidal]` + `[HasWeakSheafify]` (the deleted route-(e) is the canonical Mathlib unlock).
- `PresheafOfModules.monoidalCategory` / `PresheafOfModules.symmetricCategory`: VERIFIED — presheaf-level structural isos already in Mathlib.
- `pushforwardPushforwardAdj`, presheaf `pushforwardNatTrans`/`pushforwardCongr`: MISSING (strategy already states Mathlib-absent — these are gaps to build, not assumed-present).

## Must-fix-this-iter

- Route A.1.c.SubT: CHALLENGE — (1) fix the `monoidOfSkeletalMonoidal` mis-citation (it requires the coherent `MonoidalCategory`; only `CommRing.Pic` supports the direct/existence-only build); (2) demonstrate `tensorObj_restrict_iso` is a strictly smaller gap than the deleted `J.W.IsMonoidal` whiskering wall by tying it to the trivializing-cover (free-on-opens) structure, else the pivot is the same gap one layer deeper.
- Route A.2.c: CHALLENGE — justify grinding the hardest SubT linchpin while the escalated RR fork could moot the ⊗-substrate; confirm the substrate is required under BOTH fork outcomes, or sequence cheaper/reversible work until the USER resolves it.
- Alternative `J.W.IsMonoidal`→`Sheaf.monoidalCategory`: major omission — head-to-head it against the hand-built `tensorObj_restrict_iso` path before committing.
- Format: NON-COMPLIANT — strip per-iter narrative (every "iter-216 PIVOT", "iter-215", "6-iter wall", "ESCALATED … iter-216") into the iter sidecar; collapse the multi-line `## Phases & estimations` cells to one short line each; move the "VESTIGIAL/Dead-end" excision bookkeeping to the sidecar. Restructure in-place this iter.

## Overall verdict

Both still-live challenges land as CHALLENGE. Challenge 1's mathematical core is correct — the iso-class group law needs only *existence* of the structural isos, and `CommRing.Pic`/`instCommGroupPic` proves Mathlib supports exactly this direct build, so deleting the pentagon/coherence apparatus is justified. But the restructuring is not yet clean: the cited `monoidOfSkeletalMonoidal` analogy in fact *requires* the coherent monoidal category the strategy claims to avoid, and the replacement linchpin `tensorObj_restrict_iso` (→ Mathlib-absent `pushforwardPushforwardAdj`) is not shown to be a smaller gap than the deleted `J.W.IsMonoidal` whiskering wall — the strategy defers the sheaf-level associator-existence construction across a pivot that may relocate the same hard problem one layer deeper, which is required for this route's group law. Challenge 2 is correctly diagnosed: A.2.c representability is the project's dominant cost/risk (the RR-free engine is a third to a half of the entire remaining build), and escalating the RR pause to the USER is the only valid posture under a standing USER directive — but the strategy should not treat A.1.c.SubT as unconditional critical path while that escalation is open, because the ⊗-group-law substrate is route-A-specific (a divisor-class law is the goal-equivalent alternative) and could be mooted by the very decision it is waiting on. Separately, STRATEGY.md is format NON-COMPLIANT (pervasive per-iter narrative, multi-line table cells) and must be restructured in-place this iter.
