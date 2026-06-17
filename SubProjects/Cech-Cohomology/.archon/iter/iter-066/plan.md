# Iter-066 plan — iter-065 broke through on BOTH routes (sorry 12→9): open-immersion acyclicity FULLY CLOSED (φ'' was a defeq), CSI Stubs 2/4 cascaded. This iter: dispatch CSI Stubs 5/6 (`prove`) + OpenImm `_comp` (`prove`) after fixing a FLAWED `hacyc` blueprint route via fast-path

## Entering state (verified from iter-065 prover results + iter-065 review subagents)
- **iter-065 ran 2 targeted `prove` lanes, BOTH with major closures (sorry 12→9), 0 papered** (lean-auditor
  iter-065: 0 axiom-laundering, all closed decls genuine).
  - **OpenImm (5→4): `higherDirectImage_openImmersion_acyclic` FULLY CLOSED axiom-clean.** The 4-iter φ'' wall
    (billed ~40–80 LOC object-relabel iso) was a DEFEQ (`sheafPushforwardContinuousComp`/`Over.mapForget` =
    `Iso.refl`/`rfl`); H₁/H₂/pullbackIso cascaded. The project's sole open-immersion-acyclicity milestone, DONE.
    Residual = STRETCH `_comp` (4 sub-sorries: hacyc/eRes/hexact/transport, 974/979/982/985).
  - **CSI (4→2): both `pushPull_coprod_prod` induction leaves CLOSED → Stubs 2 & 4 cascaded axiom-clean.**
    Residual = Stub 5 `cechSection_complex_iso` (1418) + Stub 6 `cechSection_contractible` (1477).
- **Project inline-sorry: 9** (CSI 1418/1477 + OpenImm 974/979/982/985 + CechAugmentedResolution 229 + frozen
  P5b CechHigherDirectImage:780 + dead CechAcyclic.affine:110).
- iter-065 review subagents: lean-auditor 0 must-fix (the 6 "must-fix" = the 6 honest open sorries) / 2 major
  (stale CSI module docstring; duplicate `isZero_of_faithful_preservesZeroMorphisms`); lvb-csi: Stubs 5/6
  ADEQUATE, 1 stale `% NOTE` (already cleaned by iter-065 review agent — verified absent); lvb-openimm: 2 stale
  NOTEs (cleaned) + φ'' proof over-complicated (major) + `hacyc` underspecified (minor) + acyclic co-pinning (major).

## What I did this phase
1. **Investigated the OpenImm `_comp` / `hacyc` route BEFORE dispatching** (the standing soundness-check
   discipline). Read the blueprint `lem:open_immersion_pushforward_comp` (9180–9319) + the in-file `_comp`
   (942–985). **Found the `hacyc` proof FLAWED:** it claims `R^k f_*(j_* Iⁿ)=0` via "Serre vanishing on the
   affine open `U∩f⁻¹V`" — but for affine `V⊆S`, `f⁻¹V` is open (NOT affine) in X, so `U∩f⁻¹V` is a general
   open of affine U and need NOT be affine; the blueprint's claim (9311–9314) that it is affine "because j is
   affine" is false (would need `f⁻¹V` an affine open of X). This re-enters the restriction-of-injectives wall.
2. **Worked out the correct, cleaner route** (verified all infra exists via grep/Read):
   `pushforward j` preserves injectives = right adjoint (`Scheme.Modules.pullbackPushforwardAdjunction`) of the
   mono-preserving `pullback j` (`restrictFunctorIsoPullback`: `pullback j ≅ restrictFunctor j`, exact for open
   immersions) via `Injective.injective_of_adjoint` ⟹ `j_* Iⁿ` injective ⟹ `f_*`-acyclic by the EXISTING
   instance `Functor.IsRightAcyclic.ofInjective` (AcyclicResolution.lean:160). `hexact` = `_acyclic` on H
   (`H^{n+1}(K)=R^{n+1}j_*H=0`); `eRes` = left-exact augmentation; `transport` = `pushforwardComp` mechanical.
3. **progress-critic `iter066`:** Route A CONVERGING; Route B CHURNING (trailing 061–063) — corrective = the
   blueprint rewrite + fast-path, "correct and sufficient, must execute first" (done). Flag acted on: the
   in-file `hacyc` comment (960–964) still describes the flawed route — Lane 2 objective explicitly says DO NOT
   follow it.
4. **blueprint-writer `comp-iter066`:** rewrote `_comp` part (2) onto the adjoint route (deleted the flawed
   `U∩f⁻¹V` argument); split `lem:open_immersion_pushforward_acyclic` into its own block (so the closed
   milestone gets independent `\leanok`); corrected the φ'' defeq sketch; added `\mathlibok` anchors; folded
   coverage `isZero_modules_of_isEmpty`; fixed the stale CSI `% NOTE`. 0 broken `\uses`; 0 strategy-modifying.
5. **blueprint-clean `iter066`:** 2 Lean-syntax leaks (`Iso.refl`, `defeq`) scrubbed; 25 refs resolve.
6. **blueprint-reviewer `iter066` (whole-blueprint, mandatory + fast-path): HARD GATE CLEARS for BOTH files** —
   rewritten part (2) CORRECT + 4 obligations formalizable; CSI Stubs 5/6 ADEQUATE; 0 broken `\uses`.
   Non-blocking: 2 isolated nodes (dead `pullbackObjUnitToUnit_mathlib` anchor; dead `CechAcyclic.affine`).
7. Updated STRATEGY (both phase rows: acyclic CLOSED, CSI Stubs 2/4 cascaded, `hacyc` route corrected),
   PROGRESS (iter-066 context + decisions + 2 `prove` objectives + Next-iter plan), task_done (iter-065 entry),
   task_pending (iter-066 status), this sidecar, objectives.md, TO_USER, ARCHON_MEMORY. Cleared the 2 processed
   prover result files.

## Decision made — D1: dispatch BOTH `prove` lanes this iter (CSI Stubs 5/6 + OpenImm `_comp`), after the same-phase fast-path gate clearance
- **Why both this iter (not defer OpenImm):** the OpenImm `hacyc` route was FLAWED, so a bare re-dispatch would
  have churned a 6th time (progress-critic CHURNING). Rather than defer a whole iter, I fixed the blueprint this
  phase (writer→clean→reviewer fast-path) and the gate cleared. The corrected route is crisp and mechanical
  (one categorical lemma chain + an existing instance); the only non-mechanical piece is
  `PreservesMonomorphisms (pullback j)`, which transports from the exact `restrictFunctor j`. CSI Stubs 5/6 are
  independently frontier-ready (CONVERGING). Both fit one iter.
- **LOC/risk trade-off:** OpenImm `_comp` ~80–180 LOC (was billed ~150–280 before the route simplification);
  the adjoint route removes the entire Serre-vanishing-on-U∩f⁻¹V sub-assembly. CSI Stubs 5/6 ~150–250 LOC,
  Stub 6's augmentation node the documented risk.
- **Cheapest reversal signal:** if OpenImm `hacyc`'s `PreservesMonomorphisms (pullback j)` turns out to need a
  substantial sub-proof (not a quick transport), isolate it as a typed sub-lemma + focused next-iter dispatch
  (NOT re-dispatch whole). If CSI Stub 6 augmentation node stalls, effort-break that node only.

## Subagent skips
- strategy-critic: STRATEGY.md edits this iter are bounded retrospective/estimate updates (acyclic milestone
  closed; CSI Stubs 2/4 cascaded; `hacyc` route corrected at the CHAPTER/proof level, not the strategy arc) —
  the route arc (Route A acyclic-resolution comparison) is UNCHANGED, no route swap / phase split / new fork.
  Prior strategy verdict was SOUND with no live CHALLENGE (last full critic run pre-iter-065; skipped iter-065
  with rationale). The `hacyc` correction is a proof-route fix validated by the blueprint-reviewer (which reads
  the actual chapter math), the appropriate gate for it — not a strategy-level decision.

## Tool substitutions
None. No external-LLM API key in env; all analysis via grep/Read + Mathlib file inspection + subagents.
