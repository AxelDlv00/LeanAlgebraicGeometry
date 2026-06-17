# Iter-240 (Archon canonical) — review

## Outcome at a glance

- **The "both walled lanes get genuine pivots; one lands its linchpin, the other breaks its 4-iter
  carrier wall — but neither drops a canonical sorry" iter.** Two prover lanes, both `partial`:
  - **`Picard/TensorObjSubstrate.lean`** (Route Z / Phase 1, critical path): **2 axiom-clean
    declarations LANDED** — `unitToPushforwardObjUnit_comp` (L882, sectionwise-`rfl`) and
    **`pullbackObjUnitToUnit_comp`** (L923, ~87-line adjunction-mate transport), the latter being the
    blueprint's explicitly-named "genuinely-new ingredient" for `lem:pullback_unit_iso`. I re-verified
    the residual sorries: only the two pre-existing deferred ones (`exists_tensorObj_inverse` L715,
    `addCommGroup_via_tensorObj` L1184) remain — **0 new sorry**. The deliverable `pullbackUnitIso` is
    blocked on a precisely-characterised instance-synthesis non-canonicity (NOT math); the prover
    **removed the blocked decls (no sorry-pin)** and wrote a complete in-file HANDOFF.
  - **`Cohomology/FlatBaseChange.lean`** (`pushforward_spec_tilde_iso`, engine): **the 4-iter
    `Module.compHom` carrier wall is BROKEN** via `algebraize [φ.hom]` +
    `@IsLocalizedModule.powers_restrictScalars` (explicit instances). The `hloc` obligation is
    discharged and the `of_linearEquiv` tail compiles GIVEN a fresh single residual `hsq` (the
    naturality-in-the-open square of `gammaPushforwardIsoAt`). Net file sorry 3→3.
- **Canonical critical-path counter: flat.** No canonical sorry eliminated. Both lanes produced
  substantive, axiom-clean, honestly-scoped progress and reduced their open problem to ONE
  sharply-named obstacle with a concrete next step.
- **Build GREEN** both files. **Axioms re-verified:** the prover's `lean_verify` on
  `pullbackObjUnitToUnit_comp` returned `{propext, Classical.choice, Quot.sound}` (a transient
  `sorryAx` appeared mid-iter while the blocked chart-lemma was in the file, and was cleared by its
  removal — the final state is axiom-clean). **Blueprint-doctor CLEAN.** **sync_leanok** iter 240,
  sha `c98e4468`, **+2 / −0** on `Cohomology_FlatBaseChange.tex`. **No laundering** — the two new
  decls carry no blueprint pin yet (so no `\leanok` to launder); the two known sorries' `\leanok`
  on their blueprint blocks are pre-existing tracked state managed by sync.

## The defining tension — two armed reversing signals, both honoured

The iter-240 plan armed two cheap signals: (TensorObjSubstrate) *if Phase 1 also fails (≥3 helpers, no
iso), mathlib-analogist before re-dispatch*; (FlatBaseChange) *sorry MUST drop; if flat again, take the
#37189 bump — NOT another in-tree attempt*.

**TensorObjSubstrate.** This was NOT a churn iter — the prover added exactly the two coherence lemmas
the route needs (the hard one via a genuine adjunction-mate construction, confirmed substantive by both
the lean-auditor and the lean-vs-blueprint checker) and then stopped at the instance-synthesis wall
*without* accumulating fragile scaffolding or pinning a sorry. The HANDOFF is precise (recipe complete,
blocker characterised, fix ranked). This is the linchpin landing the iter-239 review predicted would
unblock the assembly — the assembly's remaining work is now plumbing, not invention.

**FlatBaseChange.** The carrier wall that stalled iters 234/235/236/239 is genuinely broken — `algebraize`
was the right mechanism and the prover proved it (plus the strong de-risking fact that the pushforward
peeling is `rfl`). But the *counter is flat*: the residual moved within the same decl from `hloc` to
`hsq`. Per the plan's own contract this is the trigger to switch tactics — and the prover's recommended
`NatIso` refactor + the standing #37189 bump are exactly the sanctioned non-repeat moves. Honest framing
for the next plan: do NOT re-dispatch a rewrite round on `hsq`; the blueprint must first specify the
naturality lemma (see below), then refactor `gammaPushforwardIsoAt` to a `NatIso` or take the bump.

## Process correctness

- **Provers: both on-target and honest.** No sorry-pinning of the blocked targets; both lanes localized
  their residual to a single named obstacle, named concrete unblocks, and left the tree compiling clean
  (Scratch.lean removed). The FlatBaseChange prover correctly warned that range-scoped
  `lean_diagnostic_messages` can be stale and to confirm with `lake env lean` — a reusable process note.
- **lean-auditor ts240: 0 must-fix.** Confirmed both new decls genuine/axiom-clean, no overstated sorry.
  2 MAJOR (stale `## Status` header) + 4 MINOR (stale "80→79" comment, dangling forward-ref,
  possibly-nonexistent `instIsIsoPullbackObjUnitToUnitOfFinal` name — verify before use, dead `nat1`
  `have`). All Lean-comment domain → next refactor pass; surfaced in recommendations.
- **lean-vs-blueprint ts240-tensorobj: 0 must-fix, 3 MAJOR** — the 2 new decls unpinned; the
  `lem:pullback_unit_iso` sketch calls the now-proved coherence lemma "remaining work."
- **lean-vs-blueprint ts240-fbc: 1 must-fix (blueprint-side), 2 MAJOR.** The `lem:pushforward_spec_tilde_iso`
  sketch is under-specified for the `hsq` naturality obligation; the prover's `NatIso` route is unblueprinted.
  Plus a stale `% NOTE:` (carrier-wall framing) and a missing statement `\leanok` (blocked by the
  malformed NOTE placement).

## Review-agent actions taken

- **Updated + relocated the stale `% NOTE:` on `lem:pushforward_spec_tilde_iso`** (my marker domain):
  it claimed the "sole difficulty" is the carrier wall (now resolved); rewrote it to name the `hsq`
  naturality residual + the `NatIso` route, and moved it from BETWEEN `\begin{lemma}` and the `[title]`
  arg (a malformation the checker flagged as blocking `\leanok` sync) to AFTER the `\lean{}` pin. Next
  iter's `sync_leanok` should now insert the statement `\leanok` deterministically.
- Did NOT add `\lean{...}` pins for the two new TensorObjSubstrate decls — adding NEW blueprint pins +
  prose is the plan-agent / blueprint-writer domain; surfaced as HIGH in recommendations instead.
- No `\leanok` touched.

## Honest framing for the next plan
- The critical path is **route-unblocked, work-remaining**: the linchpin exists; Phase 1 close is
  instance plumbing. Proceed on Lane A.
- The engine is **wall-broken, blueprint-gated**: do the CRITICAL blueprint-writer dispatch
  (naturality NatIso block) FIRST, then the `gammaPushforwardIsoAt`→`NatIso` refactor or the #37189 bump.
- Counter moves only when one of these single residuals closes — both are now the correct next unit.
