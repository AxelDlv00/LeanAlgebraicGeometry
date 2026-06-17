# Iter-238 (Archon canonical) — review

## Outcome at a glance

- **The "the ~20-iter Picard group-law bottleneck is CLOSED" iter.** ONE prover lane,
  `done` (the FlatBaseChange slot was correctly swapped for a blueprint-writer STUCK corrective
  per the iter-238 progress-critic — no prover ran on FlatBaseChange):
  - **`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`** (mathlib-build, the named critical path):
    the full by-hand carrier-pivot Picard commutative group landed axiom-clean in ONE iteration.
    **`picCommGroup : CommGroup (PicGroup X)`** (L834) plus `PicGroup`/`picSetoid` (def:pic_carrier),
    `IsInvertible.tensorObj`, `isInvertible_unit`, `IsInvertible.inverse_unique`,
    `tensorObj_assoc_iso_invertible`, helpers `picMul`/`picInv`/`tensorObj_middleFour`, and step-0:
    `tensorObj_assoc_iso` made **unconditional** (the three vestigial `IsLocallyTrivial` hyps dropped).
    All 7 objective steps done. I re-verified first-hand:
    `lean_verify picCommGroup = lean_verify tensorObj_assoc_iso = {propext, Classical.choice, Quot.sound}`.
- **Per-file sorry delta:** TensorObjSubstrate 2→2 (§5 added **zero** sorries; the two deferred
  dual-bridge sorries `exists_tensorObj_inverse` L693 and `addCommGroup_via_tensorObj` L891 untouched).
- **Build GREEN.** `lean_diagnostic_messages` → 0 errors; only deprecation (`Sheaf.val`) + long-line
  style warnings + the 2 known `sorry`s. **`sync_leanok` iter 238, sha 6dc91191, +12/−0**
  (`Picard_TensorObjSubstrate.tex`, `Cohomology_FlatBaseChange.tex`). **No laundering** — verified
  first-hand: every `\leanok` on the 7 new pins is backed by an axiom-clean, sorry-free decl.

## The defining tension — the gate was MET; the counter is owed but now trivially reachable

The d.2 → associator → group-law arc, four-plus iters in the running, **terminated in the deliverable.**
iter-236 built `stalkTensorIso`; iter-237 wired it through and closed the whiskering sorry, making
`tensorObj_assoc_iso` unconditional; iter-238 dropped the vestigial hyps and assembled the entire
group law on top. Both review subagents independently confirmed the construction is genuine
(`lean-auditor`: "real construction with no vacuity, circular steps, or hidden sorries";
`lean-vs-blueprint-checker`: "7/7 declarations exist with correct signatures and faithful proofs;
no must-fix blocking findings"). This is the honest resolution of the project's central ~20-iter
bottleneck — and a strictly stronger result than the abandoned flat-restricted route ever promised.

One honest sting, carried cleanly: **the canonical critical-path counter did not drop.** `picCommGroup`
is the new honest group carrier, but the two deferred sorries and Lane RPF's dishonest
`PicSharp := const PUnit` / `functorial := 0` are still open. This is categorically different from the
prior flat iters: the gating *ingredient* now exists, axiom-clean and in-tree; the remaining work is
wiring (re-base RPF onto `IsInvertible`/`PicGroup`), not invention. The next plan should dispatch that
wiring and is the right place to expect the counter to move.

## Documentation rot — the one real finding (non-blocking, both reviewers)

The associator's two-step route change (flatness → route-(d), then hyp-drop) outran its prose. Stale
descriptions now sit in BOTH the Lean comments (`lean-auditor`: docstring L302–340 still describes the
flatness argument and claims sorry-transitivity through a lemma the body no longer uses; module header
L43–45 lists wrong residuals + omits §5; §5-before-§4 ordering) AND the blueprint
(`lean-vs-blueprint-checker`: L1452–1456 note + title both still claim `IsLocallyTrivial` hypotheses that
were dropped). Neither is in the review agent's write domain (Lean comments → prover/refactor; blueprint
informal prose → plan agent / blueprint-writer); both are surfaced as MAJOR in `recommendations.md` for
next-iter cleanup. Importantly, the axiom check proves the *code* is clean — this is purely description
rot on a load-bearing decl, the kind that misleads the next agent about sorry-debt.

## Process correctness

- **Prover: on-target and honest.** Built the whole group law as the directed unit, kept §5 0-sorry /
  axiom-clean, left the two off-limits deferred sorries untouched, and handed off a precise next-step
  (re-open Lane RPF; `PicGroup.lean` split). The two real friction points (namespace shadowing inside
  `IsInvertible.tensorObj`; class-`def`→`instance` lint) were named and resolved, not papered over.
- **Planner (iter-238): correct on both lanes.** Dispatched the group law as the convergent next unit
  (progress-critic CONVERGING) and honored the FlatBaseChange STUCK verdict by swapping the prover slot
  for the sanctioned blueprint-expansion corrective rather than a verbatim re-dispatch — consistent with
  the iter-235 precedent. Skipped strategy-critic with a sound rationale (route unchanged, prior SOUND).
- **Review subagents: both warranted and dispatched** (substantial new definitions this iter, prover
  committed edits). Both returned 0 must-fix; their findings (documentation rot) are landed in
  `recommendations.md`.

## Review-agent marker actions this iter
- Removed the dangling `\lean{PresheafOfModules.stalkTensorIso_naturality_right}` pin on
  `lem:stalk_tensor_commutation_naturality_right` (decl never created — inlined into the whiskering
  lemma iter-237); `\label` retained (consumed by `\uses`/`\cref`), `% NOTE:` updated. This resolves
  the planner's iter-238 "soon" review-agent handoff.
- No `\mathlibok` (all 7 new pins are genuine project constructions, not Mathlib re-exports).
- No `\lean{...}` renames (all pins already matched the prover's decl names).
- No stale `\notready` on any landed block.

## Blueprint-doctor
1 finding: `Cohomology_FlatBaseChange.tex` L350–352 — malformed `\uses{\leanok …}` (a `sync_leanok`
artifact: `\leanok` injected inside the `\uses{}` braces; the target label exists at L302). Surfaced as
HIGH in `recommendations.md` for the next plan agent (the `\leanok` relocation is outside the review
agent's marker domain; no active prover is blocked).
