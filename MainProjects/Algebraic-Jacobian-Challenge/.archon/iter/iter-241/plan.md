# Iter-241 plan-agent run

## Headline outcome

The **"both critical lanes reduced to ONE named residual with a verified fix → sharpen and re-dispatch
both"** iter. iter-240 made substantive axiom-clean progress on BOTH lanes (Lane A: the named linchpin
`pullbackObjUnitToUnit_comp` landed; Lane B: the 4-iter `Module.compHom` carrier wall broke via
`algebraize`), each terminating at a single sharply-named residual. This iter ran the design pass the
residuals called for — a mathlib-analogist consult that turned Lane A's "design-shape suspected" flag
into a precise Mathlib-anchored fix — added the two blueprint passes the lean-vs-blueprint must-fix
demanded, cleared the HARD GATE via the same-iter fast path, and re-dispatched both lanes on concrete,
reference-anchored next mechanisms. NEITHER is a verbatim re-dispatch. No strategic change (carrier
pivot + Route Z + Route Y all decided; this is in-route execution).

## What I processed (iter-240 outcomes)
- **TensorObjSubstrate.lean:** 2 axiom-clean coherence linchpins landed (`pullbackObjUnitToUnit_comp` =
  the blueprint's named "genuinely-new ingredient", ~87-line adjunction-mate transport;
  `unitToPushforwardObjUnit_comp` = pushforward-side dual). `pullbackUnitIso` NOT closed (instance-synthesis
  accident, no sorry pin). → migrated to task_done; result file cleared.
- **FlatBaseChange.lean:** the 4-iter `Module.compHom` carrier wall BROKEN (`algebraize [φ.hom]` +
  `@IsLocalizedModule.powers_restrictScalars`); `hloc` discharged; structural peeling shown `rfl`. Residual
  moved WITHIN `pushforward_spec_tilde_iso` to a single `hsq` naturality square. sorry 3→3. → result cleared.
- **lean-vs-blueprint ts240-fbc must-fix** (under-specified `hsq`/NatIso route) — ADDRESSED this iter
  (writer `fbc-natiso` + fast-path re-review CLEARS).
- **lean-vs-blueprint ts240-tensorobj MAJOR** (2 new decls unpinned) — ADDRESSED (writer `tensorobj-pins`).

## Subagents dispatched

| Subagent | Slug | Verdict |
|---|---|---|
| progress-critic | ts241 | **Lane A UNCLEAR + design-shape flag** (2 iters data; linchpin landed; `pbu` canonicity may propagate → recommended a concurrent analogist consult) / **Lane B STUCK** (4 PARTIAL dispatches, 0 sorry eliminated, count +1; corrective = NatIso one-shot + EXPLICIT trip-wire). Dispatch-sanity OK. |
| mathlib-analogist (api-alignment) | pbu-canon | **PROCEED / ALIGN / PROCEED** — `pbu` signature CANONICAL (mirrors `Functor.Monoidal.μIso`); fix = bundled-`asIso`/`Iso`-level idiom (per `pullbackObjFreeIso`), NOT `rw+infer_instance`, NOT `@[instance] lemma`; Phase-2 same fix, Phase-3 no recurrence, NO refactor. `analogies/pbu-canon.md`. |
| blueprint-writer | tensorobj-pins | COMPLETE — 2 coherence pins + `lem:pullback_unit_iso` revision. |
| blueprint-writer | fbc-natiso | COMPLETE — `lem:gammaPushforwardIsoAt_naturality` + `pushforward_spec_tilde_iso` rewrite. |
| blueprint-clean | ts241 | PASS — 2 Lean-leakage strips (`i7` step label; `eqToHom` combinator name). |
| blueprint-reviewer | ts241-fastpath | **HARD GATE CLEARS — both lanes** (35 chapters complete+correct, 0 must-fix, 0 unstarted-phase). |

## Subagent skips
- **strategy-critic**: STRATEGY.md unchanged this iter (no route swap, no phase add/remove/reorder, no
  >30% estimation change — both lanes are in-route execution on the already-decided carrier pivot + Route Z
  + Route Y). Prior verdict ts240 was SOUND with all CHALLENGEs addressed; no live challenge. The
  mathlib-analogist this iter CONFIRMED no signature/design refactor is needed (the `pbu` shape is canonical),
  so nothing surfaced that touches the strategic arc. Skip conditions met.

## Decision made — re-dispatch both lanes on their now-verified fixes; arm the Lane-B trip-wire

**Chosen:** TWO prover lanes this iter — (1) `Picard/TensorObjSubstrate.lean` [mathlib-build]: close
`pullbackUnitIso` via the bundled-`asIso`/`Iso`-level idiom (mathlib-analogist pbu-canon), then Phase 2/3;
(2) `Cohomology/FlatBaseChange.lean` [prove]: close `pushforward_spec_tilde_iso` →
`affineBaseChange_pushforward_iso` via the `gammaPushforwardIsoAt`-as-`NatIso` refactor.

**Why this is NOT a verbatim re-dispatch (both lanes):**
- Lane A: iter-240 used `rw [pullbackObjUnitToUnit_comp]; infer_instance` (failed on TC collision). This
  iter uses the structurally-different bundled-`asIso`/`Iso`-level cancellation idiom — Mathlib's own
  pattern (`pullbackObjFreeIso`), which the analogist verified pre-empts the collision AND the Phase-2
  recurrence. The progress-critic's "design-shape suspected" flag is RESOLVED: the analogist confirmed the
  signature is canonical, so there is nothing to refactor — it is a one-time per-proof idiom adoption.
- Lane B: iter-240 fought the `hsq` square with ~15 rewrite/simp/conv/slice forms (all failed on the
  `restrictScalarsComp'App` unification pathology). This iter repackages `gammaPushforwardIsoAt` as a
  `NatIso` so naturality is the DEFINITIONAL `NatTrans.naturality` field — sidestepping the rewrite-matching
  entirely. This is the review iter-240 + progress-critic ts241 sanctioned structural move.

**progress-critic STUCK on Lane B — corrective executed, NOT rebutted.** The named corrective (NatIso
refactor as a ONE-SHOT structural attempt) is exactly what I dispatched. The EXPLICIT hard trip-wire,
per the critic's must-fix: **if `pushforward_spec_tilde_iso`'s sorry count does not strictly decrease
after this iter's prover run, Route B PAUSES immediately and the next step is the Mathlib bump (#37189) —
NOT another in-tree rewrite round.** This is a hard condition, not a suggestion; recorded here and in
PROGRESS.md (`## Standing deferrals`, the #37189 line is now ARMED).

**LOC/risk trade-off.** Lane A: ~30–60 LOC plumbing (wrapper + per-chart `asIso` cancellation + the
already-built chart-chase); low risk now that the idiom is Mathlib-precedented. Lane B: the NatIso refactor
is a self-contained rewrite of a def THIS file owns (consumers use only `.app U`); if it works it closes a
canonical sorry, if not the bump is a ~3-line collapse (deferred only for mid-flight disruption). Both are
the cheapest path to moving the counter.

**Cheapest reversing signal.** Lane A: if Phase 1 fails AGAIN with the bundled-`asIso` idiom (the analogist's
precise recipe), that would contradict the Mathlib precedent and warrant a deeper LSP-level investigation of
the `asIso` site's instance context — but the analogist's `pullbackObjFreeIso` citation makes this unlikely.
Lane B: the trip-wire above (flat sorry → bump).

## Notes
- `analogies/pbu-canon.md` is the persistent rationale for Lane A; the prover is pointed at it explicitly
  in PROGRESS.md + objectives.md.
- `lem:gammaPushforwardIsoAt_naturality` is intentionally UNPINNED (no `\lean{}`); the prover adds the
  `NatIso` decl and a later sync attaches the marker.
- STRATEGY.md left unchanged. Minor wording drift in the A.1.c table cell (it still names
  `CoreMonoidal.ofOplaxMonoidal` as part of Phase 2, which the route paragraph correctly marks OFF-path/
  descoped) is non-blocking; not editing to avoid churn (the authoritative route paragraph is correct).
  Refresh at the next genuine STRATEGY.md edit.
