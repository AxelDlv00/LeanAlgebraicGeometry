# Iter-242 plan-agent run

## Headline outcome

The **"both lanes hit fresh Mathlib-absent builds → design pass resolves the route, re-dispatch both"**
iter. iter-241 closed BOTH lanes' primary residuals (Lane A `pullbackUnitIso`; Lane B
`pushforward_spec_tilde_iso`). Each now faces a genuine Mathlib-absent multi-hundred-LOC build, and the
iter-241 review + proof-journal both demanded a **design pass + Mathlib-bump check before any prover
dispatch**. This iter ran that pass (mathlib-analogist cross-domain + the two mandatory critics), and it
delivered a decisive correction:

- **Lane A Phase 2 (`pullbackTensorIso`):** the standing "abstract left-adjoint pullback has no
  sectionwise formula / `leftAdjointOplaxMonoidal` absent" reading is **RETRACTED**. The
  doctrinal-adjunction tensorator machinery IS in the pinned Mathlib (PR #36599) — **no bump needed**. The
  route is to mirror Mathlib's OWN construction: build a concrete strong-monoidal pullback
  `P = sheafify∘(sectionwise extendScalars)` (tensorator `distribBaseChange` + `sheafifyTensorUnitIso`),
  prove `P ⊣ pushforward`, and obtain `pullbackTensorIso` as a **three-iso composite** with the bare
  functor iso `pullback ≅ P` from `leftAdjointUniq` (the proven iter-217 `tensorObj_restrict_iso` device).
  strategy-critic ts242 verified this is sound and gap-free (and that registering a `MonoidalCategory`
  instance on the abstract pullback is NOT needed — the three-iso composite suffices).
- **Lane B (`affineBaseChange`):** the next brick is the **pullback-of-tilde dictionary**
  `(Spec φ)^* M̃ ≅ (R'⊗_R M)~` (Stacks 01I9 part 1), the affine companion of the just-closed pushforward
  dictionary; then the affine close via `cancelBaseChange`.

Both lanes re-dispatched as `mathlib-build` on these now-scoped, reference-anchored targets. No strategic
route change beyond the Phase-2 recipe refinement; the carrier pivot + Route Y arc is intact.

## What I processed (iter-241 outcomes)
- TensorObjSubstrate.lean: `pullbackUnitIso` + 3 bricks landed axiom-clean (Phase-1 PRIMARY DONE). KEY
  FINDING: chart-chase unnecessary (`pullbackObjUnitToUnit` iso for ALL `f` by representable flatness). →
  migrated to task_done; result file cleared.
- FlatBaseChange.lean: `pushforward_spec_tilde_iso` CLOSED axiom-clean (sorry 3→2; 4-iter carrier wall
  broken via `eqToIso`→`restrictScalarsCongr` + `ext x; rfl`). → task_done; result cleared.
- blueprint-doctor: two "broken `\uses`" in `Cohomology_FlatBaseChange.tex` (sync_leanok had mis-placed
  `\leanok` INSIDE the `\uses{}` braces) — **FIXED directly** (relocated `\leanok` after `\begin{proof}`,
  collapsed each `\uses{}` to a single line so future syncs can't split it).
- lean-auditor ts241 MAJOR (stale HANDOFF comment block, TensorObjSubstrate L1120–1172) — folded into the
  Lane-1 prover objective as a secondary cleanup (plan agent cannot edit `.lean`).
- lean-vs-blueprint ts241 majors (obsolete `lem:pullback_unit_iso` proof; under-specified
  `lem:affine_base_change_pushforward`; dangling `lem:gammaPushforwardIsoAt_naturality`) — all ADDRESSED
  this iter by the two blueprint-writer passes.

## Subagents dispatched

| Subagent | Slug | Verdict |
|---|---|---|
| progress-critic | ts242 | **Both routes CONVERGING.** 4/4 PARTIAL fires as a false positive on staged multi-phase development with genuine milestone closures each iter; dispatch mathlib-build on both; no corrective warranted. Dispatch-sanity OK (2 files). Monitoring note on Lane B carrier wall. |
| mathlib-analogist (cross-domain) | pullback-tensor | **Premise STALE / route found.** `leftAdjointOplaxMonoidal` + doctrinal tensorator machinery IS in the pinned Mathlib (PR #36599) — no bump. Top route = mirror PR #36599: concrete strong-monoidal `P` + `leftAdjointUniq` transport. Negative results: oplax≠preserves-invertibles (Γ counterexample); locally-free route revives shelved arc. `analogies/pullback-tensor.md`. |
| strategy-critic | ts242 | **SOUND.** Phase-2 route gap-free; `leftAdjointUniq` gives only a bare functor iso but `pullbackTensorIso` is the three-iso composite (iso-ness automatic, no monoidal-instance transport needed). Must-fix: STRATEGY.md format DRIFTED (iter-NNN narrative + 2 paragraph cells) — ADDRESSED. |
| blueprint-writer | tos-pullback | COMPLETE — `lem:pullback_unit_iso` proof → one-liner (+ dropped stale `\uses`); §6 narrative + `lem:pullback_tensor_iso` proof → the concrete-`P`/`leftAdjointUniq` route; negative results folded in. |
| blueprint-writer | fbc-pullback | COMPLETE — new `lem:pullback_spec_tilde_iso` (Stacks 01I9, fetched via child reference-retriever `stacks-schemes`); expanded `lem:affine_base_change_pushforward`; demoted `lem:gammaPushforwardIsoAt_naturality` to a prose remark (cleared dangling label). |
| blueprint-clean | ts242 | PASS — 1 stale `% NOTE` strip (TensorObjSubstrate); both new/kept SOURCE QUOTEs byte-accurate (Stacks `lemma-tensor-product-pullback` + Stacks 01I9). |
| blueprint-reviewer | ts242-regate | (same-iter fast-path re-gate — see Gate judgment in PROGRESS.md) |

## Decision made — re-dispatch both lanes on the design-pass-verified routes

**Chosen:** TWO prover lanes, both `[prover-mode: mathlib-build]`:
1. `Picard/TensorObjSubstrate.lean` — Phase 2 `pullbackTensorIso` via the concrete-`P` + three-iso
   `leftAdjointUniq` composite (analyst + strategy-critic verified); then attempt Phase 3
   `IsInvertible.pullback` in the same dispatch; plus delete the stale HANDOFF comment block.
2. `Cohomology/FlatBaseChange.lean` — build `pullback_spec_tilde_iso` (Stacks 01I9), then attempt
   `affineBaseChange_pushforward_iso` via `cancelBaseChange`.

**Why this over the alternatives:**
- *vs. a Mathlib bump:* the analyst confirmed the needed tensorator machinery (PR #36599) is ALREADY at
  the pin — no bump buys anything for Lane A; the standing #37189 bump for Lane B is also unnecessary now
  that `pushforward_spec_tilde_iso` closed in-tree. Bumping would risk the large pinned axiom-clean
  substrate for zero gain. Bump REMAINS armed only as a fallback if the in-tree builds wall.
- *vs. the locally-free route to `IsInvertible.pullback`:* rejected by the analyst — it revives the
  deliberately-shelved dual-gluing arc and has a Mathlib gap (locally-free⇒tensor-invertible gluing).
- *vs. an idle/design-only iter:* the design pass produced concrete, verified, reference-anchored routes
  for both lanes; dispatching now is correct (no idle iter, per the autonomous directive).

**Cheapest reversing signal:** Lane A — if the `P ⊣ pushforward` adjunction assembly OR the `leftAdjointUniq`
composite proves multi-iter-intractable, re-consult the analyst on the transport mechanics (NOT the
locally-free route, NOT a flat restriction). Lane B — if a new `restrictScalars` carrier wall appears on
`pullback_spec_tilde_iso`, report early (progress-critic ts242 monitoring note) rather than accumulating
helpers; the #37189 bump remains the documented fallback for the affine close.

## STRATEGY.md edits this iter
- A.1.c Phase 2 route rewritten (concrete-`P` + three-iso `leftAdjointUniq` composite, mirroring PR #36599);
  corrected the RETRACTED "leftAdjointOplaxMonoidal absent / sectionwise recipe dead" Mathlib-gap claim.
- Format must-fix (strategy-critic ts242): stripped `iter-NNN` per-iter narrative; compressed the two
  paragraph-length table cells (A.1.c + A.2.c-engine "Key Mathlib needs") to one short line each, detail
  pushed into the `## Routes` prose.

## Prior critique status
- strategy-critic ts242 must-fix (format DRIFTED) — ADDRESSED (iter-NNN stripped, table cells compressed).
- strategy-critic ts242 refinement (three-iso composite, drop monoidal-instance transport) — ADOPTED in
  STRATEGY.md + objectives.md (the prover is told the composite suffices).
- All ts240/ts241 challenges remain addressed (no live carry-over).

## Subagent skips
- (none material) — all four [HIGHLY RECOMMENDED] plan-phase subagents dispatched this iter
  (progress-critic ts242, strategy-critic ts242, blueprint-reviewer ts242-regate) plus the analyst and the
  two writers + clean. strategy-critic was NOT skipped because STRATEGY.md changed (Phase-2 route +
  format).
