# progress-critic directive — iter-241

Assess convergence of the two active prover routes. Verdict per route
(CONVERGING / CHURNING / STUCK / UNCLEAR). Context discipline: only the signals
below; no STRATEGY.md, no blueprint, no full sidecars.

## Route A — `Picard/TensorObjSubstrate.lean` (A.1.c substrate `IsInvertible.pullback`, Route Z)

Phase entered: A.1.c substrate began iter-239 (after the group law `picCommGroup` closed iter-238).
Strategy `Iters left` for A.1.c (whole phase): ~5–9. This sub-step (`IsInvertible.pullback`) is its
prerequisite.

Last 4 iters' signals (this file, this sub-step):
- iter-237: closed `tensorObj_assoc_iso` (whiskering sorry) — group-law prerequisite. PARTIAL→done.
- iter-238: `picCommGroup` + 9 deps landed axiom-clean (group law DONE). COMPLETE for that sub-step.
- iter-239: `IsInvertible.pullback` sectionwise-`extendScalars` recipe found DEAD (abstract left-adjoint
  pullback has no sectionwise formula). 1 axiom-clean brick `sheafifyTensorUnitIso` added. Targets left
  ABSENT (no sorry pin). sorry 2→2. Status PARTIAL. Blocker phrase: "no sectionwise pullback formula".
- iter-240: pivoted to Route Z (local-chart finality). 2 axiom-clean decls landed:
  `unitToPushforwardObjUnit_comp` + the hard linchpin `pullbackObjUnitToUnit_comp` (the blueprint's
  named "genuinely-new ingredient", ~87-line adjunction-mate transport). Deliverable `pullbackUnitIso`
  NOT closed — blocked on a precisely-characterised **instance-synthesis canonicity** issue
  (`infer_instance` for `IsIso (pbu φ)` fails in a multi-hypothesis context, works STANDALONE), with a
  ranked concrete fix (type-ascribed named `Iso` before the coherence rewrite / `@[instance] lemma`).
  Blocked decls removed (no sorry pin). sorry 2→2. Status PARTIAL. Blocker phrase: "pbu instance
  non-canonicity (Lean plumbing, not math)".

Helpers added per iter: 239:+1, 240:+2. Prover status: PARTIAL/PARTIAL. Recurring blocker: each iter
a different wall (recipe-dead → instance-synthesis), each localized with a concrete next step.

This iter's proposed objective: re-dispatch the SAME file, `mathlib-build`, to close `pullbackUnitIso`
via the prover's own ranked fix (type-ascribe each component iso as a named `Iso` before the
`pullbackObjUnitToUnit_comp` rewrite; or add `@[instance] lemma isIso_pullbackObjUnitToUnit_of_final`),
then attempt Phase 2 `pullbackTensorIso` + Phase 3 `IsInvertible.pullback`. Question for you: is this a
CONVERGING route (linchpin landed, residual is named plumbing with a concrete fix) or a CHURNING one
(helpers accreting around a definition whose shape is the real bottleneck)? If you suspect the
`pullbackObjUnitToUnit` instance-shape is the bottleneck, say "design-shape suspected" so the planner
runs a mathlib-analogist consult before/with the re-dispatch.

## Route B — `Cohomology/FlatBaseChange.lean` (engine; `pushforward_spec_tilde_iso`)

Phase: A.2.c-engine FlatBaseChange sub-lane, active since ~iter-233. Strategy `Iters left` for the
engine: ~30–60 (focused); this is a parallel side-lane (~5 net LOC/it).

Last 5 iters' signals (this decl / file):
- iter-236: Γ-fragment built (3 axiom-clean decls). affine close not reached. sorry flat.
- iter-237: 3 route-iii decls; the hard commitment `affineBaseChange_pushforward_iso` MISSED. sorry 2→2.
- iter-238: NO prover (blueprint-expansion STUCK corrective instead).
- iter-239: 2 axiom-clean bricks (`gammaPushforwardIsoAt`, `tildeRestriction_isLocalizedModule`) +
  realized the dangling `pushforward_spec_tilde_iso` pin with an `hloc` sorry. sorry 2→3. Blocker:
  "Module.compHom carrier wall (4th recurrence)".
- iter-240: the 4-iter `Module.compHom` carrier wall **BROKEN** via `algebraize [φ.hom]` +
  `@IsLocalizedModule.powers_restrictScalars` (explicit instances); `hloc` discharged; the structural
  peeling shown `rfl`. Residual moved WITHIN the same decl to a single new sorry `hsq` (the
  naturality-in-the-open square of `gammaPushforwardIsoAt`). sorry 3→3. Blocker phrase:
  "restrictScalarsComp'App rewrite-matching pathology — won't unify despite printing identically".

Helpers/scaffold per iter: 239:+2 bricks, 240:large verified scaffold (algebraize+hGloc+rfl exposures+
`key`+`nat1`), residual reduced to ONE named square. Prover status: PARTIAL/PARTIAL across the run.
Recurring blocker: a `restrictScalars`-carrier wall that has now MOVED (compHom→resolved; new residual
is a rewrite-unification pathology, not the old wall).

This iter's proposed objective: ONE more attempt, but a STRUCTURALLY DIFFERENT mechanism (NOT a repeat
of the failed `hsq` rewrites): repackage `gammaPushforwardIsoAt` as a genuine `NatIso`
(`NatIso.ofComponents`) so naturality-in-the-open is the definitional `naturality` field, sidestepping
the `App.inv` rewrite-matching entirely. Blueprint will be updated to specify this first. Reversing
signal armed: if the sorry count stays flat AGAIN after the NatIso refactor, the next step is the
Mathlib bump (#37189, collapses the def to ~3 lines) — NOT another in-tree rewrite round. Question for
you: is ONE NatIso-refactor attempt justified (the carrier wall genuinely broke this iter; the new
residual has a clean structural fix), or is this route STUCK and should go straight to the bump now?

## What I need from you
Per-route verdict + the corrective TYPE if CHURNING/STUCK. Dispatch-sanity check on the 2-file
objective list (`Picard/TensorObjSubstrate.lean` re-dispatch + `Cohomology/FlatBaseChange.lean`
NatIso-refactor). Flag if either is a disguised verbatim re-dispatch.
