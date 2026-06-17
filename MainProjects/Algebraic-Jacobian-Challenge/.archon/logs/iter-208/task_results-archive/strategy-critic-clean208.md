# Strategy Critic Report

## Slug
clean208

## Iteration
208

## Routes audited

### Route: A.1.c.SubT — line-bundle tensor group law (`tensorObj_restrict_iso`, Route A)

- **Goal-alignment**: PASS — a genuine root of the SubT → RelPic → A.2.c spine; representability is required for J to be a scheme.
- **Mathematical soundness**: PASS — the Route-A claim is correct: for an open immersion `j`, `j*` is sectionwise restriction and `j*O_X ≅ O_U` via `f.appIso`, so ⊗ commutes with restriction along a *ring isomorphism* (trivially monoidal), for arbitrary `M, N`, needing neither flatness nor a monoidal-pullback instance. The re-route off the 4-iter-dead mate-δ route is correct.
- **Sunk-cost reasoning detected**: no — the strategy correctly *abandons* the mate-δ route rather than defending prior investment in it.
- **Effort honesty**: under-counted / internally inconsistent — the row reads `Iters left ~2–4`, `LOC ~120–200 · ~0/it`. A `~0/it` realized velocity cannot consume 120–200 LOC in 2–4 iters; and a lane labeled "active; sole productive lane" at `~0/it` is the exact "claimed-progressing-but-zero-velocity" pattern. Either the velocity is stale (route just reset) or the lane is stagnant; the row should not assert both "sole productive lane" and `~0/it`.
- **Verdict**: CHALLENGE — math and route are sound; the effort row is internally inconsistent and a 30–60 LOC doorknob is the *only* moving lane (see Overall verdict for the risk-ordering consequence).

### Route: A.1.c — RelPic functor

- **Goal-alignment**: PASS — required intermediate between the group law and representability.
- **Mathematical soundness**: PASS — held with placeholder bodies; honestly labeled.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — the dishonest `PicSharp := const PUnit` / `functorial := 0` bodies are explicitly named with a RE-ENGAGE GATE; naming your own dishonest placeholder is the opposite of deferral-by-concealment.
- **Verdict**: SOUND.

### Route: A.2.c — FGA Pic representability + Quot/Cartier engine

- **Goal-alignment**: PARTIAL — the typeclass scaffolding is RR-free and downstream proceeds under sorry-axiomatized `⟨sorry⟩` constructors, but the goal's kernel-clean `#print axioms` end-state holds ONLY once the Quot/Cartier engine discharges those sorries. The strategy concedes "No protected decl yet closes with a kernel-only `#print axioms`."
- **Mathematical soundness**: PASS — representability via Nitsure §5 + Kleiman §4 is the standard route.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — the Quot scheme / Quot-Cartier engine (~2000–4000 LOC, ~30–60 iters, "the project's single largest build," Quot scheme "absent from Mathlib," "not separately started"). Required by goal: yes (kernel-clean end-state). A project-side plan exists (its own phase row with an iter estimate), so this is an *acknowledged, scheduled* deferral, not an upstream-Mathlib dump — but it is the dominant feasibility unknown and is scheduled LAST, unprobed.
- **Effort honesty**: reasonable as a range, but `~0/it` realized across the engine and all gated rows means there is no evidence-based velocity for >60% of the remaining work; the 95–150-iter total rests on unmeasured phases.
- **Parallelism under-exploited**: yes — a read-only Quot-engine *feasibility spike* is independent of the SubT→RelPic chain and could run alongside it; strict bottom-up serializes it to the end.
- **Verdict**: CHALLENGE — add an early feasibility spike that confirms a Quot scheme is Lean-expressible on today's Mathlib and surfaces the true blocking gaps, decoupled from bottom-up delivery order.

### Route: Albanese UP — Route 2 (UP on J^∨ via `rmk:Alb` + autoduality bridge `J^∨ ≅ J`)

- **Goal-alignment**: PASS — derives `isAlbaneseFor` per pointing from representability, consistent with the no-`C(k)` challenge signature (J built unconditionally; UP quantified over the pointing).
- **Mathematical soundness**: PARTIAL — the architecture is sound (deriving the UP from representability adds no new heavy substrate *except* the autoduality bridge), but two claims are under-verified:
  1. **"Autoduality is RR-free" is the load-bearing, least-certain claim in the document.** Classically the theta-divisor / principal-polarization route (Milne III §6, Mumford) leans on Riemann–Roch on C. The strategy rests RR-freeness on Kleiman `rmk:Jac` / EGK Thm 2.1 via a single iter-208 consult. EGK may indeed give a representability-driven RR-free autoduality, but the contrary prior is strong enough that this should not rest on one consult — especially now that Route 2 *obsoletes* the only alternative.
  2. **The k̄→k Galois descent is labeled "minor (Milne Prop 6.4)"** — yet descent without a k-rational point is the literal heart of Merten's challenge. "Minor" understates exactly the part the challenge exists to test; verify it composes cleanly with per-pointing `isAlbaneseFor` and the autoduality bridge.
- **Sunk-cost reasoning detected**: no — Route 2 *replaces* the 27-iter Route-1 investment rather than defending it; abandoning a 27-iter-stuck node is sound discipline.
- **Verdict**: CHALLENGE — obtain a second, independent reference verification that EGK/Kleiman autoduality is RR-free in a Lean-formalizable form BEFORE Route 1 is physically removed; re-earn "minor" on the descent step.

### Route: Route-1 cone EXCISION (CodimOneExtension / Thm32RationalMapExtension / AuslanderBuchsbaum)

- **Goal-alignment**: PASS — excised because Route 2 supplies the UP without it.
- **Mathematical soundness**: PASS — the reframe is credible: Milne Thm 3.1's codim-≥2 step needs only normality + the valuative criterion of properness (Hartshorne II.4.7), no conormal/Auslander–Buchsbaum cone, so "the COE / Stacks-02JK node was misidentified" is plausible, and 27 iters stuck is itself evidence the framing was wrong.
- **Sunk-cost reasoning detected**: no (this is the correct *anti*-sunk-cost move).
- **Verdict**: SOUND — with one guard (below): excision is currently a *relabel* ("removal pending"), so it is reversible, and the 20–30 LOC valuative-criterion repair path is documented. Do NOT physically delete before the Route-2 autoduality-RR-free claim is independently confirmed; deleting now couples two bets into one irreversible action. Preserve the repair sketch in the blueprint if/when the files are removed.

### Route: Route C — Riemann–Roch (PAUSED, USER directive)

- **Verdict**: SOUND — paused under explicit USER directive; files stay imported with sorries satisfied modulo option (c). Not a deferral the strategy chose to hide.

### Route: Genus-0 arm

- **Goal-alignment**: PARTIAL — arm (a) transits A.2.c; arm (b) `J := Spec k` via Mumford rigidity is PAUSED under a USER amendment.
- **Verdict**: SOUND — both sub-arms honestly labeled (one gated, one user-paused); the open question on whether genus-0 needs only `AbelianVarietyRigidity` (not `RigidityKbar`) is correctly logged as open rather than assumed.

## Format compliance

- **Size**: ~120 lines / ~11 KB (verbatim block) — within budget.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive. Verbatim: "route reset iter-208"; "the iter-207 `restrictScalarsLaxMonoidal` instance is axiom-clean but now off-path"; "Route 2 committed (iter-208, auditor albroute208)"; "(Route-1 codim cone excised iter-208)"; "**Albanese UP — Route 2 committed (iter-208, auditor albroute208).**". Iter-NNN references and "committed/abandoned this iter" narrative belong in `iter/iter-NNN/plan.md`, never in STRATEGY.md.
- **Accumulation detected**: minor — the excised Route-1 files and the off-path `restrictScalarsLaxMonoidal` instance are still narrated inline; once the refactor lands they should leave STRATEGY.md, not accrete as "excised but described."
- **Table discipline**: PASS — correct columns; LOC cells carry both figures. (Several cells carry per-iter narrative, which is the violation above, not a table-structure issue.)
- **Format verdict**: DRIFTED — skeleton is intact, but pervasive per-iter narrative must be scrubbed in-place this iter (move the iter-208/iter-207 attribution to the iter sidecar).

## Infrastructure-deferral findings

### Deferred: Quot scheme / Quot–Cartier engine

- **Required by goal**: yes — the kernel-clean `#print axioms` end-state for the nine protected decls holds only once this engine discharges the `⟨sorry⟩` constructors of A.2.c.
- **Current plan for building it**: a dedicated phase row (~2000–4000 LOC, ~30–60 iters); partial substrate in `QuotScheme.lean`. Not an upstream-only dump.
- **Timeline**: present but very wide and unstarted; `~0/it` realized, scheduled last under strict bottom-up.
- **Verdict**: CHALLENGE — the deferral is acknowledged and user-sanctioned under option (c), so it is not a hidden goal-weakening; but deferring the project's single largest *feasibility* unknown to the very end maximizes late-discovery risk. Probe it early with a read-only feasibility spike.

## Alternative routes (suggested)

### Alternative: complete sorry-axiomatized skeleton first (all nine decls typecheck-mod-sorry)

- **What it looks like**: wire all nine protected decls through the sorry-axiomatized A.2.c typeclasses to a state where every decl typechecks modulo named sorry-axioms, before honest-ifying the lowest substrate (SubT/RelPic).
- **Why it might be cheaper or sounder**: for a *challenge submission*, "all nine decls present and typechecking mod sorry" is a more demonstrable milestone than honestly-built lower substrate with the upper decls unwired. The strategy says downstream "proceeds under" the typeclasses, so much of this skeleton is reachable without SubT; the stated blocker is RelPic's dishonest bodies.
- **What the current strategy may have rejected**: the USER bottom-up directive ("no A.3+ before A.2.c") forces substrate-first ordering, which partly rejects this — but bottom-up *delivery* does not forbid stating which milestone capacity is racing to.
- **Severity of the omission**: minor — mainly a framing/sequencing clarification the strategy should make explicit.

## Must-fix-this-iter

- Route A.2.c: infrastructure-deferral CHALLENGE — Quot/Cartier engine required by the goal's kernel-clean end-state, scheduled last and unprobed. Add a read-only feasibility spike (Lean-expressibility of a Quot scheme on current Mathlib) decoupled from bottom-up order.
- Route Albanese UP (Route 2): CHALLENGE — "autoduality is RR-free" is now load-bearing for the entire UP and rests on one consult against a strong contrary prior. Get a second independent reference verification BEFORE physically removing Route 1; re-earn "minor" on the k̄→k Galois descent.
- Route Route-1 excision: keep reversible — relabel now (done), defer deletion until the autoduality-RR-free claim is confirmed; preserve the 20–30 LOC valuative-criterion repair sketch in the blueprint.
- Route A.1.c.SubT: CHALLENGE (effort honesty) — reconcile the `~0/it` velocity with "sole productive lane" + `Iters left ~2–4`; one of those three figures is wrong.
- Format: DRIFTED — scrub pervasive per-iter narrative (iter-208 / iter-207 attributions, "committed/abandoned/excised this iter") from STRATEGY.md in-place; move it to `iter/iter-208/plan.md`.

## Overall verdict

CHALLENGE. The strategy is internally coherent, mathematically literate, and unusually honest about its sorry-axiomatized posture — option (c) is openly surfaced ("No protected decl yet closes with a kernel-only `#print axioms`"; the `degComp` witness "still transits RR"; the RelPic placeholders named dishonest). The two iter-208 decisions are individually defensible: the SubT Route-A re-route is mathematically correct, and excising the 27-iter-stuck Route-1 cone in favor of deriving the UP from representability is sound anti-sunk-cost discipline, properly hedged by a documented repair path and a not-yet-executed (reversible) removal. I withhold SOUND for three reasons. First, **the strategy defers the Quot/Cartier engine, which is required for the stated goal's kernel-clean end-state**, to the very end and leaves its central feasibility question (can a Quot scheme be built in Lean on today's Mathlib?) unprobed while the *only* moving lane is a 30–60 LOC doorknob running at `~0/it` — a risk-ordering inversion that should be corrected with an early, parallel feasibility spike. Second, the Route-2 commitment now rests the *entire* Albanese UP on "autoduality is RR-free," a load-bearing claim against a strong contrary classical prior, verified by a single consult; this must get a second independent verification before Route 1 is physically deleted, and the k̄→k Galois descent (the literal heart of the no-`C(k)` challenge) should not be dismissed as "minor." Third, the document has drifted on format — pervasive per-iter narrative must be scrubbed in-place this iter.
