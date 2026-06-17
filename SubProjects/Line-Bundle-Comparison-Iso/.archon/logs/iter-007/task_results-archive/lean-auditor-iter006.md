# Lean Audit Report

## Slug
iter006

## Iteration
006

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - L39–140: Module docstring is a 100-line iter-history narrative ("iter-230", "iter-237", "iter-262", "iter-261", outcome chains). It mixes historical proof-attempt chronology with current status. The historical sections are not meaningful to a reader of the current code and belong in task_results/journal rather than source. Current-state content is accurate but buried.
  - L620–663: Dead-end diagnostic section `/-! ### iter-230 C-wiring diagnostic (the binding probe) — OUTCOME (ii)`. Explicitly admits "The diagnostic def is intentionally NOT committed." Describes a superseded exploration that went nowhere. This block is dead scaffolding that inflates the file and could mislead readers about live proof strategy.
  - L1244–1249: Empty section `PullbackLanDecomposition` — contains only two `variable` bindings, zero declarations. Remnant of a planned but abandoned decomposition approach; no proof content ever committed here.
  - L1676, L1718, L1877, L1914, L1977: `set_option maxHeartbeats` — multiple bumps at 1600000 and two at 3200000 (L1718 for `pullbackEtaUnitSquare`, L1977 for `pullbackTensorMap_natural`). The 3200000 bumps are heavy; the inline documentation attributes them to `whnf` expansion of sheafification-laden composites. Documented and locally scoped (not file-wide), so not unsound — but 3200000 is a yellow flag for future brittleness.
  - L712: `sorry` at `exists_tensorObj_inverse` — KNOWN per directive (deferred by design). Not a new finding. Inline comment accurately describes the two remaining bridges (D-bridge and global-iso upgrade).
  - L3144: `sorry` at `pullbackTensorMap_restrict` — KNOWN per directive (known-open). Not a new finding. Inline comments accurately describe the Sq1–Sq4 interleave status.
  - **D3′ focus — erw soundness assessment**: `sheafificationCompPullback_comp_natTrans` (L2469), `sheafificationCompPullback_comp_tail` (L2697), `pullbackTensorMap_restrict` (L2971) — all carry `set_option maxHeartbeats 1600000`. `erw` uses throughout the D3′ region (86 total in the file) are at documented friction points: `Sheaf.val`/`.obj` definitional equality mismatches (structurally unavoidable in Lean 4's sheaf API) and instance-level ring carrier mismatches (the `J1` simp lemma non-firing noted at L2479–2490 is a real instance-level defeq issue, not a proof shortcut). None of these `erw` uses meet the laundering pattern (no circular defeq collapses, no type-class abuse to force unification). The `pullbackTensorMap_restrict` sorry (L3144) is a genuine open mathematical obligation (Sq3/Sq4 interleave), not a laundered claim. Assessment: **D3′ proofs are sound**.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 3 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - L1–50 (module docstring): States "one `sorry` remains" and "dual_restrict_iso PARTIAL — Step-4 `isoMk` naturality sorry at ~L546; all other deps CLOSED." A grep for the literal `sorry` keyword across DualInverse.lean finds **zero occurrences in Lean proof bodies** (all seven hits are inside `--` line comments or `/-...-/` docstrings — none are tactic sorry calls). The docstring's sorry-state claims cannot be confirmed from the code. Two interpretations: (a) the sorries referenced were closed in a later iter but the docstring was not updated, OR (b) the sorry is encoded through a non-`sorry` mechanism (which would itself be a bad practice). This discrepancy is an active source of misinformation about the file's proof state.
  - L797: Inline comment `-- \`sliceDualTransport\`'s body is concrete (its \`.hom\` is currently a \`sorry\`, so the square…)`. The word "currently" implies active sorry status, but again: no sorry keyword in the actual code at or near this location. If this comment was written when sliceDualTransport.hom was a sorry and the sorry was later removed, this is a stale comment that actively misleads readers about the current state of `dual_restrict_iso`'s assembly.
  - L835–837: Inline comment block inside `dual_isLocallyTrivial`: "dual_restrict_iso is PARTIAL — Step-4 `isoMk` naturality sorry at ~L546". Same discrepancy — no sorry found in code at ~L546. Stale if the step was closed.
  - L683–767, L833–878, L1010–1059: Large `/-  Planner strategy: ... -/` blocks embedded INSIDE declaration docstrings for `dual_restrict_iso`, `dual_isLocallyTrivial`, and `homOfLocalCompat`. These are multi-paragraph proof-planning narratives ("Step 1 through Step 4", "route-(e) whisker", "Leg-A / Leg-B scheme") that describe HOW the proof was designed, not WHAT the declaration asserts. Planning notes belong in task_results (or the proof journal), not in source docstrings. They inflate the file by ~130 lines and will become stale as the proofs evolve.
  - `homOfLocalCompat` (L1060): CLOSED axiom-clean per pre-reading.
  - `dual_unit_iso` (L821): CLOSED axiom-clean per pre-reading.
  - `sliceDualTransportInv` (L317): marked CLOSED for `app` component (iter-303) in comments.
  - `isIso_ε_restrictScalars_appIso` (L179), `dualUnitRingSwap` (L193), `dualUnitRingSwapInv` (L208): CLOSED per reading.

---

## Must-fix-this-iter

None.

The sorry-state discrepancy in DualInverse.lean (stale docstring vs. no sorry in code) is major documentation drift but does not meet the must-fix bar: it is not an excuse-comment on a wrong definition, not a weakened API, not a suspect body on a substantive claim, and not an unauthorized axiom. The actual code may be sorry-free. Verification needed, but the issue is stale-comment hygiene rather than wrong-code.

---

## Major

- `DualInverse.lean:1–50` — Module docstring claims "one sorry remains" and "PARTIAL — Step-4 isoMk naturality sorry at ~L546" but grep finds zero `sorry` tactic keywords anywhere in the file's proof bodies. The documented sorry-state is unverifiable from the code. Either the docstring is stale (sorrys were closed, docstring not updated) or the sorry is encoded non-standardly — both cases require investigation. Stale sorry-state documentation is a significant hygiene risk: it leads plan/review agents to treat open obligations as genuinely open when they may be closed, or to miss genuinely open obligations masked by mismatched commentary.
- `DualInverse.lean:797` — Inline comment "its `.hom` is currently a `sorry`" for `sliceDualTransport`. No sorry at or near this location in the code. If stale, this misleads about the assembly state of `dual_restrict_iso` and the transitively sorry-flagged `dual_isLocallyTrivial`.

---

## Minor

- `TensorObjSubstrate.lean:39–140` — Module docstring is a 100-line iter-history narrative mixing historical proof-attempt chronology ("iter-230 outcome", "iter-237 closure", …) with the file's current state. Historical material belongs in the proof journal. The docstring should describe only the current mathematical content and status.
- `TensorObjSubstrate.lean:620–663` — Dead-end `/-! ### iter-230 C-wiring diagnostic …` section. Explicitly admits the diagnostic def was not committed. Dead scaffolding from a superseded exploration; inflates the file and adds noise with no live proof value.
- `TensorObjSubstrate.lean:1244–1249` — Empty `PullbackLanDecomposition` section with only two `variable` bindings, no declarations. Dead scaffolding from an abandoned decomposition approach.
- `TensorObjSubstrate.lean:1718, 1977` — `set_option maxHeartbeats 3200000` for `pullbackEtaUnitSquare` and `pullbackTensorMap_natural`. 4× the default is heavy; documented as `whnf` expansion cost, but warrants a note as a potential brittleness point if surrounding types are refactored.
- `DualInverse.lean:835–837` — Inline comment about "PARTIAL — Step-4 sorry at ~L546" inside `dual_isLocallyTrivial`. Same stale-state discrepancy as the major finding; counts separately because it is a different context (an inline comment inside a proof, not the module docstring).
- `DualInverse.lean:683–767, 833–878, 1010–1059` — Planner-strategy narrative blocks (~130 lines total) embedded in source docstrings. These belong in task_results, not source. They will become stale as the proof evolves and are not useful to a reader of the Lean.
- `DualInverse.lean:1–70` — General iter-status tracking in module docstring (iter-260, iter-303, iter-256 notes) mixed into source. Same pattern as TensorObjSubstrate — iter history belongs in journals.

---

## Excuse-comments (always called out separately)

None found. No declaration in either file carries an admission that it is "wrong but works", "placeholder", "temporary wrong def", or "will fix later" as a definition-level claim. The sorry bodies in TensorObjSubstrate.lean (L712, L3144) carry accurate-status progress commentary, not excuse-comments.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 — stale sorry-state documentation in DualInverse.lean (module docstring + inline comment at L797) that makes the file's actual proof completion status ambiguous and unverifiable from the code alone
- **minor**: 7 — iter-history docstrings (both files), dead diagnostic section and empty variable section (TensorObjSubstrate.lean), heavy maxHeartbeats bumps (TensorObjSubstrate.lean), two additional stale-state inline comments and planner-strategy narrative blocks (DualInverse.lean)
- **excuse-comments**: 0

Overall verdict: D3′ erw usage is sound (documented defeq bridges, not laundering); the two known sorries are correctly deferred with accurate progress commentary; the main hygiene issue is stale sorry-state claims in DualInverse.lean whose docstrings report open obligations that may already be closed, and dead proof scaffolding in TensorObjSubstrate.lean.
