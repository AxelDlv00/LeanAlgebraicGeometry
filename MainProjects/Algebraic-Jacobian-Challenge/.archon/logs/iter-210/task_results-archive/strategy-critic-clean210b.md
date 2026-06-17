# Strategy Critic Report

## Slug
clean210b

## Iteration
210

## Routes audited

### Route: A.1.c.SubT — line-bundle ⊗-group law (associator via local trivialization)

- **Goal-alignment**: PASS — a Picard-group group-law on ⊗-iso-classes of invertible
  objects is exactly the substrate `J := Pic⁰` needs.
- **Mathematical soundness**: PARTIAL — the *iso-class* half of the claim is sound; the
  *construction method* half is over-complicated and smuggles in a gluing obligation.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no (the route is being actively built, not deferred),
  but see the method critique below.
- **Phantom prerequisites**: none — but the strategy *under-uses* verified Mathlib infra
  (see Prerequisite verification).
- **Effort honesty**: PARTIAL — row reads `active; gate cleared` with `~0/it` realized
  velocity yet `~3–6 iters left`. A claimed-active phase with `~0/it` realized throughput is
  the check-#6 inconsistency: the iters-left figure is not evidenced by any landed LOC.
- **Verdict**: CHALLENGE

**Why CHALLENGE (the substance).** The strategy makes two claims; the first is correct, the
second is not the cheapest sound route and misstates its own obligation.

1. *"Group axioms on iso-classes are propositions, so we need only existence-of-iso, not a
   coherent monoidal category / pentagon."* **SOUND.** Passing to ⊗-iso-classes collapses the
   monoid axioms to `Nonempty (… ≅ …)`; pentagon/triangle coherence is vacuous at that level.
   This is precisely how Mathlib's `CategoryTheory.Skeleton.instCommMonoid` and
   `CommRing.Pic` (built on the `Module.Invertible` predicate, `∃ N, M ⊗ N ≅ 𝒪` — Stacks 0B8K)
   work. The invertibility-predicate-on-iso-classes design matches Mathlib's real `CommRing.Pic`
   implementation, not merely the loose "Units(Skeleton)" gloss the strategy writes.

2. *"The associator is built objectwise on invertible objects by local trivialization (each is
   locally `𝒪`, the iterated tensor is locally `𝒪⊗𝒪⊗𝒪=𝒪`, glue the standard module associator),
   avoiding MonoidalClosed."* **This is the hidden coherence obligation.** "Glue local
   trivializations into a global iso of sheaves" *is* a cocycle/descent condition (the local
   associator isos must agree on overlaps). The strategy trades pentagon-coherence — which it
   correctly says it doesn't need — for **gluing-coherence**, which it does need and does not
   name. So the "no coherence obligation" framing is misleading.

   Worse, the local-trivialization route is unnecessary. The associator of `⊗` on
   **presheaves** of modules already exists in Mathlib for *all* objects (invertible or not),
   with full coherence proven: `PresheafOfModules.monoidalCategory` is a complete
   `MonoidalCategory` instance. The project's sheaf-level tensor is
   `sheafification ∘ PresheafOfModules.Monoidal.tensorObj`, and Mathlib ships the exact
   transport template for pushing a monoidal structure through sheafification:
   `CategoryTheory.Sheaf.monoidalCategory` + `(presheafToSheaf J A).Monoidal`
   (`Mathlib.CategoryTheory.Sites.Monoidal`). The real, single obligation is the analogue of
   `J.W.IsMonoidal`: **the sheafification weak-equivalences are compatible with the
   `PresheafOfModules` tensor.** Discharge that *one* lemma and the associator, both unitors,
   the braiding, *and* pentagon transport to `SheafOfModules` for free, for all objects — no
   per-object local trivialization, no invertibility restriction, no gluing cocycle.

   The hardest prerequisite is the same under both framings ("does `⊗` descend through
   sheafification?"). The local-trivialization story renames it object-by-object instead of
   solving it once. The planner must either (a) adopt the monoidal-localization transport
   (cheaper, coherence-free by Mathlib precedent), or (b) if there is a real obstruction to the
   general transport for module sheaves over a non-constant ring sheaf that forces the
   invertible-only shortcut, record that obstruction explicitly and acknowledge the gluing
   obligation rather than claiming "no coherence."

### Route: A.2.c — Pic representability + the Quot fork

- **Goal-alignment**: PASS as math — Kleiman's FGA existence theorem (geometrically integral
  fibers, `f_*𝒪 = 𝒪` universally — both hold for a smooth proper geometrically irreducible
  curve with **no** section) represents `Pic_{C/k}` via the Quot engine. The source mapping is
  correct: Kleiman §4 = general existence/Quot (RR-free); Kleiman §5 `Sym^n`/Abel–Jacobi =
  curve-specific, RR-dependent (dim |D| = deg D − g + 1 *is* Riemann–Roch). So the fork is
  **stated correctly**.
- **Mathematical soundness**: PASS for the engine route; the cheap-route RR-dependence claim is
  also correct.
- **Sunk-cost reasoning detected**: no — but a **premature-commitment** smell, see below.
- **Infrastructure-deferral detected**: yes — `A.2.c-engine` (~2150 LOC, every component
  Mathlib-absent) is an undecomposed mega-phase at `~0/it`, "unstarted," "single largest build,"
  with `~30–60 iters left`. Per check #7, a critical-path phase at `~0/it` with no active prover
  lane and no blueprint progress is infrastructure-deferral by inaction. Separately, the A.2.c
  **typeclass scaffolding** (~600–800 LOC, six `⟨sorry⟩` constructors) is the check-#7
  "build infra for a weaker statement (typechecks-modulo-sorry) than the goal (kernel-clean)
  with intent to extend later" pattern: the `⟨sorry⟩`s *are* the sorries the goal forbids, and
  discharging them is exactly the deferred engine.
- **Phantom prerequisites**: none claimed-present-but-absent; the strategy correctly lists the
  engine components as absent.
- **Effort honesty**: under-counted-risk — 2150 LOC for a from-scratch relative Quot scheme +
  CM-regularity + relative Grassmannian + flattening stratification, with Mathlib currently
  lacking all four, is optimistic. The wide ranges are honest hedging, but the bottom of the
  range is not credible.
- **Parallelism under-exploited**: no (single critical-path build).
- **Verdict**: CHALLENGE

**Why CHALLENGE (the substance).** The fork is *described* honestly but the **commitment** is
the wrong default. The strategy simultaneously says "**Committed**: the RR-free general engine
(honors the standing pause)" and "the cheaper RR route is available iff the USER lifts the pause
… surfaced as an FYI." These are contradictory postures: you cannot be *committed* to a 30–60
iter / 2150 LOC Mathlib-absent build while a 600–1000 LOC alternative is one USER-yes away.
The sole stated justification for the expensive route is **process-compliance with a pause**, not
mathematical merit — and the strategy itself authored the cheaper alternative. Committing to the
expensive route *before* the USER has been asked to decide risks burning ~30 iters building
something the USER would have waived. The correct default for a fresh planner: **do not start the
2150 LOC engine until the USER has explicitly declined to lift the RR pause for the `Sym^n`
slice.** Escalate the amendment from "FYI" to a blocking decision; until then the engine is a
hold, not a commitment.

### Route: Albanese UP — Route 2 (Pic-rep ⇒ UP on `J^∨`, land on `J` via autoduality + descent)

- **Goal-alignment**: PASS *if* the RR-freeness holds; the UP-via-`rmk:Alb` derivation is the
  right target for `isAlbaneseFor`.
- **Mathematical soundness**: PARTIAL — load-bearing on an **unverified** RR-freeness claim that
  classical mathematics suggests is false.
- **Sunk-cost reasoning detected**: no (Route-1 cone retained *reversibly* is sound risk
  management, not sunk cost).
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: `autoduality J^∨ ≅ J` RR-free — strategy itself flags UNVERIFIED.
- **Verdict**: CHALLENGE

**Why CHALLENGE (the substance) — this is the project's single most important strategic risk.**
The *entire* option-(c) posture exists to honor the RR pause, and **two** distinct load-bearing
claims are asserted RR-free: (1) the A.2.c engine, and (2) Route-2 autoduality. The strategy
already concedes the autoduality claim is doubtful — "theta divisor `W_{g-1}` classically rests
on RR." That concession is correct: the canonical principal polarization of the Jacobian, hence
the standard proof of `J^∨ ≅ J`, is built from the theta divisor, whose construction (image of
`Sym^{g-1}C` in `Pic^{g-1}`, dimension counts) is Riemann–Roch. **If autoduality cannot be made
RR-free, Route 2 silently collides with the paused Route C, and the claimed "RR-free path to the
goal does not exist"** — the project would then be structurally blocked behind a USER decision it
has filed as a side-note. This must be second-verified (EGK Thm 2.1 directly, or a
Poincaré-bundle/biextension argument) **before** any investment in Route 2 over the retained
Route-1 cone, not after. Treat the Route-1 deletion gate as firmly closed until then. The
`k̄→k` Galois-descent composition (per-pointing `isAlbaneseFor` ∘ descent ∘ autoduality) is a
correctly-flagged secondary open question.

### Route: Route C — Riemann–Roch (PAUSED, USER)

- **Verdict**: SOUND — a USER constraint, correctly recorded as a constraint rather than a
  strategic choice. The one caveat: the pause is the lynchpin that forces both the A.2.c-engine
  expense and the Route-2 autoduality-RR-freeness gamble. The strategy should make explicit that
  *the cost of the pause is the 2150 LOC engine + the autoduality risk*, so the USER's
  lift/keep decision is priced correctly.

### Route: Genus-0 arm

- **Verdict**: SOUND — both sub-arms (Pic⁰-via-AV-wrap transiting A.2.c; direct `J := Spec k`
  via Mumford rigidity, PAUSED under USER amendment) are coherently gated. No fresh challenge.

## Format compliance

- **Size**: ~108 lines / ~6.4 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`,
  `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes — `gate cleared** iter-210`, `the associator (iter-210
  gate, cleared)`, and the `analogies/ts-assoc-gate210.md` / `ts-design206.md` filename
  references embed specific-iteration history in STRATEGY.md. Per check #9, "iter-NNN" references
  are a violation; move the gate-clearance narrative to `iter/iter-210/plan.md`.
- **Accumulation detected**: no (Route C and the Route-1 cone are retained *reversibly behind
  named gates*, which is justified retention, not dead accumulation).
- **Table discipline**: PASS — six canonical columns; LOC cells carry both figures
  (e.g. `~180–300 · ~0/it`).
- **Format verdict**: DRIFTED — single class of violation (iter-NNN narrative); strip the
  three iteration references in place this iter.

## Infrastructure-deferral findings

### Deferred: A.2.c general Quot/Cartier engine (relative Quot functor, CM-regularity, relative Grassmannian, flattening stratification)

- **Required by goal**: yes — discharging the six `⟨sorry⟩` representability constructors is
  exactly this engine; the goal demands kernel-clean (zero inline sorry), so the engine is on
  the critical path by definition.
- **Current plan for building it**: named but undecomposed — a single `~30–60 iter` row at
  `~0/it`, "unstarted," with no startable sub-phase ladder.
- **Timeline**: vague (`~30–60 iters`, no concrete first sub-phase).
- **Verdict**: CHALLENGE — decompose into a concrete sub-phase ladder (e.g. relative Grassmannian
  → boundedness/CM-regularity → flattening stratification → relative Quot representability →
  Pic-from-Quot) with a startable first node, OR hold the entire engine pending the USER
  pause-lift decision (preferred — see A.2.c route). A 2150 LOC mega-phase that no one starts is
  deferral by inaction.

## Alternative routes (suggested)

### Alternative: Monoidal-localization transport for the SheafOfModules tensor (replaces A.1.c.SubT local-trivialization)

- **What it looks like**: Prove the one lemma "sheafification weak-equivalences are compatible
  with `PresheafOfModules.Monoidal.tensorObj`" (the `J.W.IsMonoidal` analogue), then transport
  the full `PresheafOfModules.monoidalCategory` structure to `SheafOfModules` via the Mathlib
  template `CategoryTheory.Sheaf.monoidalCategory` / `(presheafToSheaf J A).Monoidal`. Read the
  associator/unitors/braiding off the transported instance.
- **Why it might be cheaper or sounder**: one compatibility lemma instead of four hand-rolled
  objectwise isos; coherence (pentagon, triangle) is inherited from Mathlib rather than
  re-discharged via a gluing cocycle; works for all objects, so the `IsInvertible` subtype only
  needs `∃ N, M⊗N ≅ 𝒪`, not bespoke structural isos.
- **What the current strategy may have rejected**: possibly a real obstruction — module sheaves
  over a *non-constant* ring sheaf are not `Sheaf J A` for fixed `A`, so the Mathlib template is
  not literally applicable and the compatibility lemma may be genuinely hard. If so, that is the
  rebuttal the planner should record; it is not visible in the current prose.
- **Severity of the omission**: major.

### Alternative: Hold the A.2.c engine; escalate the RR-pause-lift to a blocking USER decision

- **What it looks like**: Rather than "commit to RR-free engine, FYI the cheaper route," present
  the USER with the priced choice — keep pause ⇒ ~2150 LOC engine + autoduality-RR risk; lift
  pause for the `Sym^n` slice ⇒ ~600–1000 LOC curve route + genus-0 closure — and do not begin
  the engine until they decide.
- **Why it might be cheaper or sounder**: avoids sinking 30+ iters into infra the USER may waive;
  resolves the autoduality collision risk in the same decision.
- **What the current strategy may have rejected**: it treats the pause as immovable; but it also
  authored the amendment question, so the immovability is assumed, not confirmed.
- **Severity of the omission**: major.

## Sunk-cost flags

- `Committed: the RR-free general engine (honors the standing pause)` — Why this is a
  premature-commitment (commitment-before-decision) smell: the route is justified by
  process-compliance with a pause rather than by being the right way, while a 2–4× cheaper
  alternative the strategy itself authored sits one USER-yes away. Recommendation: reframe as a
  *hold* pending the USER pause-lift decision, not a commitment.

## Prerequisite verification

- `PresheafOfModules.monoidalCategory`: VERIFIED — full `MonoidalCategory` on presheaves of
  modules (associator + pentagon proven). Strategy under-uses it.
- `CategoryTheory.Sheaf.monoidalCategory` + `(presheafToSheaf J A).Monoidal`: VERIFIED
  (`Mathlib.CategoryTheory.Sites.Monoidal`) — sheafification-transport template, for fixed-`A`
  sheaves.
- `SheafOfModules R` monoidal instance: MISSING — genuine new material (strategy correct that the
  sheaf-level tensor must be built; incorrect that it must be built by local trivialization).
- `CommRing.Pic` / `Module.Invertible`: VERIFIED (`Mathlib.RingTheory.PicardGroup`) — the actual
  Mathlib Picard group uses the invertibility predicate, matching the strategy's design; the
  "Units(Skeleton(ModuleCat R))" phrasing is a loose gloss, not the literal Mathlib definition.
- `CategoryTheory.Skeleton.instCommMonoid`: VERIFIED but requires `MonoidalCategory` +
  `BraidedCategory` — hence not directly usable on `SheafOfModules` (no such instance), which is
  why the project hand-rolls. Correct.
- `AlgebraicGeometry.Scheme.Modules`: VERIFIED.

## Must-fix-this-iter

- Route A.1.c.SubT: CHALLENGE — the associator's "glue local trivializations" method hides a
  gluing/cocycle obligation while claiming "no coherence." Either adopt the
  `PresheafOfModules.monoidalCategory` + sheafification-transport route (one compatibility lemma,
  coherence free), or record the concrete obstruction forcing the invertible-only shortcut and
  name the gluing obligation explicitly.
- Route A.2.c: CHALLENGE — resolve the contradictory "committed to 2150 LOC engine" vs.
  "cheaper route is one USER-yes away" posture. Reframe the engine as a hold and escalate the
  RR-pause-lift to a blocking USER decision.
- Route A.2.c-engine: infrastructure-deferral CHALLENGE — the engine is required by the goal
  (discharges the `⟨sorry⟩` constructors) but is an undecomposed `~0/it` mega-phase. Decompose
  into a startable sub-phase ladder or formally hold pending the USER decision.
- Route Albanese UP (Route 2): CHALLENGE — autoduality `J^∨ ≅ J` RR-freeness is load-bearing for
  the whole RR-free posture and is classically RR-dependent (theta divisor). Second-verify
  (EGK Thm 2.1 / Poincaré-bundle argument) before any Route-2 investment over the retained
  Route-1 cone; keep the Route-1 deletion gate closed.
- Format: DRIFTED — strip the three `iter-210`/`gate210`/`design206` per-iter references from
  STRATEGY.md; move that narrative to `iter/iter-210/plan.md`.

## Overall verdict

The strategy's *descriptions* are honest and its source mapping (Kleiman §4 RR-free Quot vs.
Kleiman §5 RR-dependent `Sym^n`) is correct, so neither focus question yields a REJECT. But two
soundness problems and one document-format drift must be addressed this iter. On focus Q2, the
iso-class "no pentagon" reasoning is sound, yet the associator's local-trivialization
construction hides a gluing-coherence obligation and ignores the verified Mathlib monoidal +
sheafification-transport infrastructure that would deliver the whole structure coherence-free.
On focus Q1, the fork is stated correctly but the commitment is premature: the strategy is
*committed* to a 2150 LOC Mathlib-absent engine on pure process-compliance grounds while a 2–4×
cheaper route it authored itself is one USER decision away, and **the strategy defers the A.2.c
Quot engine, which is required for the stated goal** (it discharges the representability
`⟨sorry⟩`s the kernel-clean goal forbids) as an undecomposed `~0/it` mega-phase. Most gravely,
**the entire RR-free posture rests on the autoduality `J^∨ ≅ J` being RR-free, which the strategy
itself flags as unverified and which classical mathematics (the theta divisor) suggests is
false** — if it is RR-dependent, Route 2 collides with the paused Route C and the claimed RR-free
path to the goal does not exist. Second-verify autoduality and resolve the engine-commitment
posture before proceeding.
