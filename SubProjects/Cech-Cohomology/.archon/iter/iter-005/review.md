# iter-005 review (session_5)

## Overall Progress — this session
- **Prover lane**: one (P4 → `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`,
  `[prover-mode: mathlib-build]`). Model: sonnet.
- **Global sorry**: 2 → 2 (unchanged). Both in `CechHigherDirectImage.lean` (P3/P5, out of scope).
- **`AcyclicResolution.lean`**: 0 → 0 sorries; **27 new declarations added**, all axiom-clean
  (`{propext, Classical.choice, Quot.sound}`).
- **Decomposed horseshoe sub-goals**: 3 of 4 closed (`lem:horseshoe_twist`, `_dComp`, `_chainMap`),
  1 blocked (`_resolvesMiddle`). The assembly `ofShortExact` + downstream remain blocked behind it.
- **Solved / partial / blocked / untouched** (5 targets): 3 / 0 / 2 / 0.

## This session's analysis
The strongest content iter so far: the prover built the **genuinely novel mathematical core** of
the dual Horseshoe Lemma — a twisted-biproduct cochain complex (`twistedBiprod`,
`twistedBiprodD_comp`, `twistedBiprodSplitting`), the degree-recursive off-diagonal twist family
with its cocycle identity (`horseshoeτ`, `twistPair`, `horseshoeτ_cocycle`), the augmentation
(`horseshoeβ`), and the degreewise-split SES of complexes (`horseshoeSES_shortExact`) — all
axiom-clean. iter-004 had built every *consumer* of the horseshoe; iter-005 built almost all of
the horseshoe itself. The decompose-then-build response to iter-004's monolith was correct: the
prover landed 3 of the 4 leaves with no sorry-bearing scaffolding.

The work collapses the entire P4 lane to **one precise, well-scoped Mathlib gap**: the middle-term
quasi-iso transfer `quasiIso_τ₂`, absent from Mathlib (only the last-term `quasiIso_τ₃` exists).
The prover correctly declined to leave half-built `sorry` code and handed off a concrete recipe
(homology five-lemma on a 7-term LES window). This is the single thing to build next; everything
downstream (`ofShortExact` → `rightDerivedShiftIsoOfAcyclic` → `rightDerivedIsoOfAcyclicResolution`)
is straight-line off already-proven decls.

### Headline finding — stale `\lean{...}` names blocked `sync_leanok` detection
The planner's decomposition named the leaves `ofShortExact_twist`/`_dComp`/`_chainMap`. The prover
correctly abstracted the injective-free core into a top-level `TwistedBiprod` section and realized
the twist content as a 15+-decl cluster, so three blueprint blocks ended up with `\lean{...}` names
**no declaration has**. `sync_leanok` ran this iter (`sha 973bd6f`, `added: 2`) before the names
were fixed and so could not mark these three (complete, axiom-clean) blocks `\leanok` — and never
would have until corrected. I corrected all three `\lean{...}` hints + added explanatory `% NOTE:`s
(review-agent domain); next iter's `sync_leanok` will now detect them. Independently caught by
lean-vs-blueprint-checker (3 major). This is the iter-004 false-`\leanok` story inverted: there a
fake decl produced a false *positive*; here a name-divergence produced a false *negative*. Both are
`\lean{}`/`sync_leanok` matching hazards — captured as a Known Blocker.

## Subagent dispatches
- **lean-auditor** (`iter005`): dispatched (`.lean` modified this iter). 0 must-fix, 1 major
  (177-line embedded status comment), 6 minor. All 27+ decls non-vacuous + axiom-clean; workarounds
  sound (`ιC0` defeq confirmed); iter-004 code-fence trap NOT reintroduced. Report:
  `task_results/lean-auditor-iter005.md`.
- **lean-vs-blueprint-checker** (`acyclic`): dispatched (file received prover work). 4 major (3
  stale `\lean{}` + 1 hand-waved `quasiIso_τ₂` gap), 2 minor. 0 sorry/placeholder red flags; all
  Lean faithful. Report: `task_results/lean-vs-blueprint-checker-acyclic.md`.

(No `## Subagent skips` — both highly-recommended review subagents dispatched.)

## Blueprint markers updated (manual)
- `Cohomology_AcyclicResolution.tex`, `lem:horseshoe_twist`: `\lean{...ofShortExact_twist}` →
  `\lean{...horseshoeτ, ...horseshoeτ_cocycle, ...horseshoeβ, ...twistPair}` + `% NOTE:`.
- `Cohomology_AcyclicResolution.tex`, `lem:horseshoe_dComp`: `\lean{...ofShortExact_dComp}` →
  `\lean{CategoryTheory.twistedBiprodD_comp}` + `% NOTE:`.
- `Cohomology_AcyclicResolution.tex`, `lem:horseshoe_chainMap`: `\lean{...ofShortExact_chainMap}` →
  `\lean{...twistedBiprodInl, ...twistedBiprodSnd, ...twistedBiprodSplitting, ...horseshoeSES_shortExact}` + `% NOTE:`.
- `Cohomology_AcyclicResolution.tex`, `lem:horseshoe_resolvesMiddle`: `% NOTE:` — sole remaining
  gap; needs Mathlib-absent `quasiIso_τ₂`; planner to scaffold as a new leaf.
- No `\leanok` touched (sync_leanok domain). No `\mathlibok` added (6 anchors already present +
  verified faithful). No stale `\notready` found.

## Pointers
- Session journal: `proof-journal/sessions/session_5/{summary,recommendations,milestones.jsonl}`.
- Doctor: `logs/iter-005/blueprint-doctor.md` (no findings).
- Plan sidecar: `iter/iter-005/plan.md` (D1 same-iter fast path; decompose + dispatch).
- `\leanok` sync state: `.archon/sync_leanok-state.json` (`iter 5`, `sha 973bd6f`, `added 2` — ran
  before the `\lean{}` corrections, so the three corrected blocks will only register `\leanok` next iter).
