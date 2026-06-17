# Strategy Critic Report

## Slug
ts244

## Iteration
244

## Routes audited

### Route: A.1.c.SubT — group law via tensor-invertibility carrier (DONE)

- **Verdict**: SOUND. `picCommGroup` axiom-clean; carrier choice well-motivated (inverse = witness, free). No issue beyond the accumulation note in Format (a DONE phase still occupies a full Routes paragraph + an Open-questions bullet).

### Route: A.1.c — relative Picard functor on `IsInvertible` (incl. substrate `IsInvertible.pullback` build)

- **Goal-alignment**: PASS — RPF functoriality genuinely requires pullback to preserve the carrier; this is on the critical path, correctly placed ACTIVE (not deferred).
- **Mathematical soundness**: PASS — the decomposition `pullback ≅ extendScalars ⋙ pullback₀`, `extendScalars` strong, `pullback₀ = Lan` strong-monoidal, transport via `leftAdjointUniq` is a correct route to a general strong-monoidal pullback. The math is sound; the question is whether it is the *minimal* route to the goal.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags. The reason given for not pursuing the dual/locally-free route ("deleted by carrier pivot") is historical, not a feasibility judgement, and is imported from the group-law context where the dual was genuinely unneeded into the pullback context where it is the cheaper tool.
- **Infrastructure-deferral detected**: no — the substrate is committed ACTIVE; this is the opposite of deferral. (Good. The pivot "stop avoiding, build it" is the correct response to a confirmed Mathlib absence.)
- **Phantom prerequisites**: none in the build itself. The root-gap claim is VERIFIED (see Prerequisite verification): `PresheafOfModules.pullback` is the bare left adjoint, no `Monoidal` instance exists. One name unverified: `final_of_representablyFlat` (loogle empty), but phase-1's DONE/axiom-clean status evidences the `[F.Final]` instance resolves in-project, so not blocking.
- **Effort honesty**: under-counted / internally inconsistent — `~500–900 LOC · ~25/it` alongside `Iters left: 10–18` does not reconcile. 500÷25 = 20 > 18 (lower LOC bound already exceeds upper iter bound); 900÷25 = 36 ≫ 18. The row is arithmetically inconsistent in both directions. Either velocity is optimistic for genuinely novel category-theory infra (Lan colimit model + filtered-colimit/⊗ interchange — there is no Mathlib scaffolding to lean on, so ~25/it is likely high), or the iter-count is.
- **Parallelism under-exploited**: no — A.1.c.fun is correctly parallelized against A.1.c.sub.
- **Verdict**: CHALLENGE — the build *target* is under-justified against a concrete cheaper alternative (see Alternative: locally-free route), and the effort row is arithmetically inconsistent.

### Route: A.2.c — representability + Quot fork (held)

- **Infrastructure-deferral detected**: partially — `R^i f_*` (i≥1), the strategy's own "deepest root," has only "Mathlib PR vs project Čech build vs typed-sorry pin — decide when the engine de-gates" as its plan. This construction is required by the RR-free engine route the goal depends on. Mitigations: the engine is explicitly HELD behind A.1.c (not the current frontier), three concrete options are named, and an active sub-lane (`Cohomology_FlatBaseChange`) shows the phase is progressing, not stagnant. So this is a deferred *decision* at a far horizon, not deferral-by-inaction. Watch, do not block this iter.
- **Verdict**: SOUND (with the `R^i f_*` decision-deferral noted for the de-gate horizon).

### Route: Albanese UP — Route 2 (preferred-pending) / Route 1 (RR-free fallback)

- **Goal-alignment**: PASS — `isAlbaneseFor` is reachable either way; the RR-free Route 1 (Weil/rigidity, in-tree) is a NAMED, substrated fallback, so the unverified autoduality RR-freeness of Route 2 does not threaten goal-reachability, only the choice of primary.
- **Verdict**: SOUND — good hygiene (goal-required step carries a verified-reachable fallback; the "second-verify when A.2.c nears" timing is acceptable precisely because the fallback guarantees reachability regardless).

### Route: Route C — Riemann–Roch — PAUSED (USER)

- **Verdict**: SOUND — user-directed pause, correctly recorded as FYI/cost-asymmetry only.

### Route: Genus-0 arm

- **Verdict**: SOUND — (a) transits A.2.c, (b) `Spec k` route user-paused.

## Format compliance

- **Size**: 156 lines / ~11 KB — within budget (borderline on bytes).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive. Representative verbatim: "settled iter-244: analyst presheaf-pullback-strong + progress-critic CHURNING→pivot"; "the iter-243 local-trivialization forward-bridge"; "the 5 iters of surface-route rotation"; "(DECIDED iter-244)". Iter-NNN references and "this iter we tried X" narrative belong in `iter/iter-NNN/plan.md`, never in STRATEGY.md.
- **Accumulation detected**: yes (minor) — A.1.c.SubT is DONE yet still occupies a full Routes paragraph plus a full Open-questions bullet; the file should shrink the completed group-law discussion toward a one-line "DONE" pointer.
- **Table discipline**: PASS (structurally) — LOC cells carry both figures. Note: several rows read `· 0/it` with positive Iters-left; for gated/not-yet-started phases (A.2.c, A.3, genusZero) a `0/it` realized velocity is honest, but the A.1.c.fun row is described as "PARALLEL ... unblocked" (i.e. active) while still reading `0/it` — reconcile once authoring starts.
- **Format verdict**: DRIFTED — driven by the pervasive per-iter narrative; resolve by lifting iter-NNN references into the iter sidecar and compressing the DONE SubT discussion.

## Alternative routes (suggested)

### Alternative: locally-free route to `IsInvertible.pullback` (avoids the general strong-monoidal build)

- **What it looks like**: The goal needs only invertibility-*preservation* (`IsInvertible M ⟹ IsInvertible (f^*M)`), NOT the general binary iso `f^*(A⊗B) ≅ f^*A ⊗ f^*B` for all `A,B`. Factor it as: (1) `IsInvertible M ⟹ M` locally-free-rank-1 — the EASY Stacks direction the strategy ALREADY schedules at A.2.c (`lemma-invertible-is-locally-free-rank-1`, ~1–2 iters); (2) pullback preserves locally-free-rank-1 — Mathlib **already ships this**: `SheafOfModules.pullbackObjFreeIso` (`pullback φ` of `free I` ≅ `free I`) and `pullbackObjUnitToUnit`, both gated on `[F.Final]`, the *same* `[F.Final]` machinery the strategy's DONE phase-1 unit-iso already uses (`instIsIsoPullbackObjUnitToUnitOfFinal`); (3) locally-free-rank-1 ⟹ `IsInvertible` — the reverse/dual construction (`M^∨ := ℋom(M,𝒪)`, evaluation `M⊗M^∨ → 𝒪` iso checked on the trivializing cover).
- **Why it might be cheaper or sounder**: the committed strong-monoidal build (Lan colimit model + filtered-colimit/⊗ interchange, ~500–900 LOC) is pure category-theory infrastructure with **no other consumer in the project**. The locally-free route instead spends its effort on the single construction `LF1 ⟹ IsInvertible` (the dual), which simultaneously discharges (a) pullback-preservation, (b) the A.2.c Quot-embedding bridge the strategy ALREADY needs (`IsInvertible ⟺ LF1`), and (c) full carrier-interchangeability — and it reuses Mathlib's existing `pullbackObjFreeIso` rather than rebuilding the inverse-image model from scratch. One construction, three payoffs, leaning on already-present Mathlib infra.
- **What the current strategy may have rejected**: the strategy lists "dual/internal-hom inverse manufacture (deleted by carrier pivot)" as a dead-end and asserts the reverse `IsLocallyTrivial ⟹ IsInvertible` is "never needed if the project carries `IsInvertible` throughout." That assertion is true for the GROUP LAW (witness gives the inverse free) but is being over-extended: pullback-preservation does need either the binary monoidal iso OR the reverse direction, and the reverse is the cheaper of the two given Mathlib's `pullbackObjFreeIso`. The genuine cost question — does `LF1 ⟹ IsInvertible` require internal-hom + a local-iso criterion that are themselves ~500 LOC of Mathlib-absent infra? — is NOT answered anywhere in STRATEGY.md.
- **Severity of the omission**: major — the planner should explicitly cost-compare the two build targets (general strong-monoidal pullback vs. `LF1⟹IsInvertible` dual leveraging `pullbackObjFreeIso`) before committing ~500–900 LOC, rather than defaulting to the strong-monoidal build because the dual was "deleted by carrier pivot."

## Sunk-cost flags

- `dual/internal-hom inverse manufacture (deleted by carrier pivot)` — Why this is sunk-cost: the dual was dropped because the carrier pivot made it unnecessary *for the group law*; that is a past-context reason, not a verdict that it is infeasible *for pullback-preservation*, where it is plausibly the cheaper route. Recommendation: re-evaluate the dual / `LF1⟹IsInvertible` on its current merits as the pullback-preservation tool, head-to-head against the strong-monoidal build, citing whether Mathlib has internal-hom + a local-iso criterion for sheaves of modules.

## Prerequisite verification

- `PresheafOfModules.pullback`: VERIFIED — exists, but is exactly the abstract left adjoint (`pullbackPushforwardAdjunction`); only `pullbackId`/`pullbackComp` compatibilities, **no `Monoidal` instance** (loogle "Monoidal PresheafOfModules pullback" / "SheafOfModules.pullback Monoidal" both empty). The "no concrete inverse-image/strong-monoidal model" root-gap claim is CONFIRMED.
- `SheafOfModules.pullbackObjFreeIso`: VERIFIED — `(pullback φ).obj (free I) ≅ free I` under `[F.Final]`, in `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackFree`. (Mathlib already has pullback-of-free — the locality step of the alternative route.)
- `SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal`: VERIFIED — `pullbackObjUnitToUnit` is iso under `[F.Final]` (backs the DONE phase-1 unit iso).
- `final_of_representablyFlat`: MISSING by that exact name (loogle empty) — but the DONE/axiom-clean phase-1 evidences the `[F.Final]` instance resolves; flag only as a name to confirm, not a phantom.

## Must-fix-this-iter

- Route A.1.c.sub: CHALLENGE — justify the build TARGET. Either (a) cost-compare the general strong-monoidal pullback build against the locally-free route (`IsInvertible⟹LF1` [scheduled] + Mathlib's `pullbackObjFreeIso` + `LF1⟹IsInvertible` dual), stating concretely whether the dual's prerequisites (internal-hom + local-iso criterion for sheaves of modules) are present in Mathlib or are themselves a comparable build; or (b) record an explicit rebuttal in `plan.md` naming why the strong-monoidal build is nonetheless the minimal path. Do not commit ~500–900 LOC to the general build on the strength of "the dual was deleted by the carrier pivot" alone.
- Route A.1.c.sub: CHALLENGE (effort honesty) — `~500–900 · ~25/it` with `Iters left 10–18` is arithmetically inconsistent (500÷25=20 > 18). Reconcile LOC, velocity, and iter-count; for novel infra with no Mathlib scaffold, ~25/it is likely optimistic.
- Route A.1.c.fun (typed-sorry bridge granularity): CHALLENGE — confirm the bridge's TYPE is sufficient for downstream RPF coherences. The plan pins `IsInvertible.pullback` as a bare Prop, but RPF group-functoriality needs more than "f^*M is invertible": it needs naturality of the group law under pullback and `pullbackComp`-style coherence, which plausibly require the monoidal *iso* (not just the existence Prop). If so, authoring A.1.c.fun against a bare-Prop bridge risks a re-author once coherences bite. State whether the bridge should expose the monoidal-naturality data, not just the Prop. (The parallelization itself is sound *if* the bridge's signature is stable at the right granularity — it is route-independent at the Prop level; the hazard is under-specification, not the parallelism.)
- Format: DRIFTED — strip iter-NNN per-iter narrative ("settled iter-244", "iter-243 local-trivialization", "5 iters of surface-route rotation", "DECIDED iter-244") into the iter sidecar, and compress the DONE A.1.c.SubT discussion to a one-line pointer. Resolve in-place this iter.

## Overall verdict

The overall Route-A arc (A.1.c → A.2.c → A.3 → A.4, RR-free, with a NAMED RR-free Albanese fallback) is goal-aligned and mathematically sound, and the four specific decisions are mostly defensible: (Q4) the rotation-churn DOES share one genuine root gap — `PresheafOfModules.pullback` is the bare left adjoint with no `Monoidal` instance, VERIFIED — so "build it" is the correct *category* of response to a confirmed Mathlib absence, not avoidance; (Q1) committing to the build rather than hunting a 6th cheap surface route is the right instinct; (Q2) the typed-sorry parallelization is sound at the Prop level because the statement is route-independent. BUT two challenges stand. First and most important (Q1): the strategy commits ~500–900 LOC to the *general* strong-monoidal pullback when the goal needs only invertibility-preservation, and Mathlib **already ships** `pullbackObjFreeIso` + `pullbackObjUnitToUnit` (the local building blocks, gated on the very `[F.Final]` the project already uses) — so a locally-free route (`IsInvertible⟹LF1` [already scheduled] + `pullbackObjFreeIso` + the `LF1⟹IsInvertible` dual) plausibly reaches the same goal while ALSO discharging the A.2.c Quot bridge and carrier-interchangeability, leaning on existing infra; the strategy dismisses the dual on the sunk-cost ground "deleted by carrier pivot" without a feasibility cost-comparison, so the build *target* is under-justified. Second (Q3): the A.1.c.sub effort row is arithmetically inconsistent (`~500–900 · ~25/it` vs `10–18 iters`), and for genuinely novel infra ~25/it is optimistic, so the substrate is likely bigger than even the re-estimate admits — the total Route-A arc remains coherent but the substrate's bite is under-counted. The typed-sorry bridge should also be checked for granularity (Prop vs monoidal-naturality data) before A.1.c.fun is authored against it. Format is DRIFTED on per-iter narrative and must be restructured in-place this iter.
