# Iter-241 (Archon canonical) — review

## Outcome at a glance

- **The "both walled lanes broke through in the same iter — one eliminates a sorry, the other lands
  its primary with a simpler-than-blueprinted proof" iter.** Two prover lanes, both productive:
  - **`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`** (prove, engine): **`pushforward_spec_tilde_iso`
    CLOSED axiom-clean.** The 4-iter `hsq`/carrier wall (iters 237–240) is resolved by a one-line
    structural refactor (`eqToIso` → `(ModuleCat.restrictScalarsCongr hcomp).app SecN`) that makes the
    open-naturality square defeq, closed by `ext x; rfl`. **File sorry 3 → 2.**
  - **`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`** (mathlib-build, A.1.c critical path): the
    Phase-1 PRIMARY **`pullbackUnitIso` LANDED axiom-clean**, plus 3 reusable bricks. File sorry 2 → 2
    (the new decl is sorry-free; the two remaining are the pre-existing deferred dual-bridge sorries,
    untouched). **No new sorry.**
- **Canonical critical-path counter: −1** (`pushforward_spec_tilde_iso`). The first canonical sorry
  elimination since iter-238, breaking three flat iters (239/240 produced bricks but no elimination).
- **Both armed reversing trip-wires honoured by SUCCESS, not pivot.** Lane B's "flat sorry → bump
  #37189" did not fire (the sorry dropped). Lane A's Phase-1 closed via the analogist's `@asIso`
  idiom — and the prover went further, discovering the chart-chase is entirely unnecessary.
- **Build GREEN** both files. **Axioms re-verified first-hand:** `pushforward_spec_tilde_iso` and
  `pullbackUnitIso` both `{propext, Classical.choice, Quot.sound}`. **No laundering** — the
  `lean_verify` "opaque" source-flag at TensorObjSubstrate L488 is the word "opaque" inside a comment
  (verified by reading L485–488). **sync_leanok** iter 241, sha `802f4318`, **+16 / −0** on
  `Cohomology_FlatBaseChange.tex` + `Picard_TensorObjSubstrate.tex`.

## The defining tension — momentum recovered, but the canonical Picard counter still has not dropped

After two consecutive flat-counter iters (239, 240) that produced bricks and route-pivots but no
elimination, iter-241 is a genuine inflection: Lane B eliminated a canonical sorry, and Lane A landed
its named Phase-1 primary. The 4-iter FlatBaseChange wall — the project's longest-running engine
blocker — is gone, and the fix is a clean, reusable pattern (delete the `eqToIso`, the rest is `rfl`).

The honest sting, carried cleanly: **the Picard group's own critical-path counter (the two deferred
dual-bridge sorries in TensorObjSubstrate) did not move, and cannot until Phase 2/3 land.** Phase 1
(`pullbackUnitIso`) is the EASY leg — and the prover's representable-flatness finding shows it was even
easier than the blueprint assumed. Phase 2 (`pullbackTensorIso`) is the real cost: a confirmed
Mathlib-absent build with NO comparison map even to state the iso (no `MonoidalCategory (SheafOfModules)`,
no tensor-pullback at the pin). The prover correctly left it absent (no sorry pin) and handed off a
multi-hundred-LOC decomposition. The honest framing for the next plan: **A.1.c's remaining work is now
a genuine engine sub-build (or a Mathlib bump), not plumbing** — and it should be scoped in the
blueprint and possibly checked against a fresh Mathlib bump before any prover dispatch.

Both provers again did the disciplined thing under the no-sorry-pin invariant: each closed/landed
exactly what was reachable, left the genuinely-blocked targets absent with concrete handoffs, and
neither accumulated fragile scaffolding. The lean-auditor and lean-vs-blueprint findings (landed in
`recommendations.md`) are the authoritative check on that.

## Structural finding — sync_leanok mis-placed `\leanok` inside two `\uses{}` braces

The blueprint-doctor flagged two "broken cross-references" in `Cohomology_FlatBaseChange.tex`. Root
cause (single): `sync_leanok` inserted `\leanok` on its own line *inside* the multi-line `\uses{...}`
brace at L500 and L551 (the `\uses{` opens immediately after `\begin{proof}`). The referenced labels
exist; the only defect is the marker's position, which both breaks the `\uses` edges and mis-places the
proof-block marker. This is the sync's / plan agent's domain (not the review agent's — I do not edit
`\leanok` or `\uses{}` prose). Surfaced in `recommendations.md` + a Knowledge-Base process gotcha so it
does not recur.

## Documentation note (non-blocking)

The blueprint proof of `lem:pullback_unit_iso` still describes the affine chart-chase the prover proved
unnecessary (the one-line representable-flatness argument is what actually ships). This is blueprint
prose (plan-agent / blueprint-writer domain) — flagged for simplification in `recommendations.md`, not
edited here. The Lean docstrings were rewritten by the prover this iter (the HANDOFF block now records
the representable-flatness resolution), so the Lean side is current.

## Subagents
- lean-auditor (ts241, both modified files), lean-vs-blueprint-checker (fbc, tos) dispatched. Findings
  landed in `recommendations.md`; reports under `task_results/`.
