# Iter-123 (Archon canonical) — review

## Outcome at a glance

- **PARTIAL prover lane on `Differentials.lean:282`
  `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`** (M1.b body).
  Steps 1 + 4 of the 4-step `IsLocalization.of_le` chain land
  concretely in body (~60 LOC of structural reduction inserted
  between L290 and L361); Steps 2 + 3 packaged as a single residual
  `sorry` at L362 inside the `suffices AE : Localization M ≃ₐ[Γ(S, U)]
  A_colim` block. Net per-file sorry change: **1 → 1** (the sorry
  moved L304 → L362). Net project sorry change: **2 → 2** (unchanged).
- **Closest match against the iter-123 PROGRESS.md "Expected outcome"
  watch criteria is case 2**: "PARTIAL with Step 2 residual only —
  iter-124 continues M1.b with a focused Step 2 prover lane." Iter-123
  delivered exactly that, plus the bonus that Step 4 is closed in
  place (the PROGRESS.md case 2 framing assumed Step 4 might be
  open; it is not).
- **Compile-verified**: yes. `lake build AlgebraicJacobian.Differentials`
  succeeds in 3.2s (2820 jobs) with only the documented `sorry`
  warning at L282 (the `appLE_isLocalization` declaration).
- **No new axioms.** `archon-protected.yaml` unchanged (9 protected
  declarations at original paths with unchanged signatures).
  `appLE_isLocalization` is a non-protected leaf declaration
  introduced iter-122 as a named M1.b helper.
- **Meta**: `meta.json planValidate.status: ok / objectives: 1`;
  `prover.durationSecs: 950` (~16 min — well under the iter-122
  ~30 min baseline despite the iter-123 tactical playbook complexity).
  72 events in `attempts_raw.jsonl`: 2 edits, 2 goal checks,
  6 diagnostic checks, 22 lemma searches, 1 LSP file-path error
  (resolved on retry with absolute paths). The prover used a single
  file edit + a comment-block refinement — the second Edit was
  comments-only documenting the iter-124 closure recipe.
- **Stage**: stays at `prover` for iter-124 per PROGRESS.md watch
  criterion 2. STRATEGY.md is unchanged (iter-123 plan phase
  revised it for the M3 user escalation + M2.d-alt + M2.c phantom
  spot-checks but those are iter-124 plan-phase work, not a
  strategy pivot). The iter-123 progress-critic CHURNING verdict
  resolves to **CONVERGING** given this iter's structural advance:
  Step 4 (the Mathlib-closure step) landed in-body, eliminating
  half of the iter-122 residual.

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **2**, distributed:
  - `AlgebraicJacobian/Differentials.lean:362` —
    `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` (M1.b body;
    Steps 2 + 3 packaged into the residual `AlgEquiv` sorry; Step 0
    closed iter-122 as `isUnit_appLE_unitSubmonoid_in_colim`; Steps
    1 + 4 closed iter-123 in body).
  - `AlgebraicJacobian/Jacobian.lean:179` —
    `nonempty_jacobianWitness` (intended end-state for the project
    overall; off-limits to the autonomous loop until M2 + M3 land;
    user escalation on M3 routes surfaced this review via
    `TO_USER.md`).
- **Solved this iter**: 0 (no sorry-count change; structural advance
  only — Steps 1 + 4 closed in body).
- **Partial this iter**: 1 (`appLE_isLocalization` body — Step 1 +
  Step 4 closure; Steps 2 + 3 residual).
- **Blocked this iter**: 0.
- **Untouched (off-limits)**: 1 (`nonempty_jacobianWitness`).

## What the iter-123 prover got right

- **Right Mathlib closer for Step 4**. The iter-123 plan-phase
  mathlib-analogist explicitly verified that Step 4 should use
  `IsLocalization.isLocalization_of_algEquiv` (takes `AlgEquiv`,
  not `RingEquiv`) — the iter-122 plan listed `IsLocalization.of_le`
  which is a different constructor (and would have required a
  separate witness shape). The iter-123 prover picked the verified
  one, used `suffices` to reduce the goal, and the closure landed in
  3 LOC (L328-L331). One-shot Step 4.
- **`suffices` reduction is the right shape for the metric**. The
  body contains exactly **one** residual sorry — the AlgEquiv — not
  three (Step 2 + Step 3a + Step 3b). The project metric is sorry
  count; the prover correctly read PROGRESS.md's COMPLETE/PARTIAL
  shape and packaged the residual to fit. This avoids inflating the
  metric without adding closure (which a "split into named helpers"
  approach would have).
- **Explicit iter-124 closure recipe in comments**. The Attempt-2
  Edit added a recipe sketch documenting `RingEquiv.ofRingHom forward
  backward h_fb h_bf` + `AlgEquiv.ofRingEquiv (f := RE) (algebra-map-compat)`
  + the `IsLocalization.lift_eq` route for the compat witness
  (L348-L361). The iter-124 prover starts from a concrete assembly
  plan instead of having to re-derive the shape from PROGRESS.md.
- **Honest negative search results**. The prover documented in the
  task result that no off-the-shelf "colim of localizations is
  localization at union submonoid" lemma exists in Mathlib `b80f227`
  (re-confirming the iter-121 analogist finding) and that the
  closest pattern
  (`AlgebraicGeometry.Scheme.AffineZariskiSite.PreservesLocalization.colimitDesc_preimage`)
  is not directly applicable. This forecloses redundant search
  budget on iter-124.
- **Compact attempt count**. 2 substantive Edits (vs. iter-122's 53);
  the prover spent ~30% of its search budget on `lean_loogle` and
  `lean_local_search` confirming the Step 4 closer name, then
  committed to the `suffices`-reduction shape and stuck with it.
  16 min total prover duration vs. iter-122's ~30 min on a goal
  of similar size — concrete evidence that the iter-122/123
  helper-extraction pattern (Step 0 named, Step 1 inputs ready) is
  paying off.

## What deserves attention next iter

- **Step 2 cofinality is genuinely novel for the project**. The
  closest precedent is the `isUnit_appLE_unitSubmonoid_in_colim` Step 0
  closure (which used the cocone leg of a single basic open). Step 2
  needs the full cocone universal property — `Functor.descOfIsLeftKanExtension`
  or `IsColimit.desc` — applied to a family of cocone arms built
  from basic-open refinements. The iter-122/123 Cluster A workaround
  (pre-prove + `erw` for `Lan.map_comp`) will recur in Step 2c
  naturality; the analogist's tactical playbook is the right toolkit.
- **The Step-2 helper-extraction refactor option is still on the
  table** per iter-122 recommendations MEDIUM #6 (still active).
  Discretionary; let the iter-124 prover try Step 2a directly first.
  If Step 2a stalls in a single iter, fire the refactor before
  iter-125.
- **Two strategic spot-checks scheduled iter-124 plan phase** (M2.c
  Galois descent + M2.d-alt cotangent triviality) per the iter-123
  STRATEGY.md commitment. These do NOT block iter-124's prover
  lane; they refine the iter-124+ horizon.
- **M3 user escalation is now in TO_USER.md** (this review's
  responsibility). The iter-124 plan agent must read `USER_HINTS.md`
  for any user response and act accordingly. If `USER_HINTS.md` is
  empty, the iter-123 fallback ("continue M1; M3 paused pending user
  response") remains the iter-124 action.

## Subagent dispatches this review

Both mandatory review subagents fired and completed:

- **`lean-auditor-review123`** — whole-project audit (read-only,
  415s, 10 files). Report at
  `task_results/lean-auditor-review123.md`. **4 must-fix-this-iter**:
  - `Cohomology/StructureSheafModuleK.lean:458-519` `IsAffineHModuleHomFinite`
    dead class + 3 consumers (author-acknowledged dead scaffolding).
  - `Cohomology/MayerVietorisCover.lean:50-62` `AffineCoverMVSquare`
    unused-affineness-fields.
  - `Genus.lean:39-61` stale commented-out "OXAsAddCommGrpSheaf / H1OC"
    sketch.
  - `Differentials.lean:239` `erw [hmc]` brittle spot (inside the
    iter-122-closed Step 0 body).

  Plus 6 major, 8 minor, 1 excuse-comment (also under must-fix).
  Findings landed at `recommendations.md` § CRITICAL #0.

- **`lean-vs-blueprint-checker-differentials-review123`** —
  bidirectional audit (read-only). Report at
  `task_results/lean-vs-blueprint-checker-differentials-review123.md`.
  **0 must-fix, 0 major**; 4 minor blueprint-side documentation
  drift items:
  - Chapter L165 + L175 stale `IsLocalization.of_le` /
    `of_ringEquiv` hedge — should pin
    `isLocalization_of_algEquiv` per planner verification.
  - `appLE_unitSubmonoid` (named submonoid $M$ in chapter prose)
    has no `\lean{...}` reference.
  - `isUnit_appLE_unitSubmonoid_in_colim` (iter-122 Step 0 helper)
    is now a top-level theorem; chapter still inlines Step 0 without
    a sub-block.
  - `appLE_colimRingHom_comp_φV` factorisation lemma (cocone-leg
    triangle identity bridging M1.b → M1.e) is unreferenced.

  Overall verdict: **Lean follows blueprint faithfully; chapter
  adequate for iter-124 prover; none of the 4 items block iter-124
  work**. Findings landed at `recommendations.md` § HIGH #5 + #6.

## Blueprint markers updated (manual)

None this iter.

- `\leanok` is `sync_leanok`'s domain — do not touch.
- No `\mathlibok` candidates: all decls touched this iter
  (`appLE_isLocalization`) are project proofs, not Mathlib re-exports.
- No `\lean{...}` macro renames flagged by the prover task result.
- No `\notready` markers exist to strip in `Differentials.tex`.

## Iter-124 handoff

Per PROGRESS.md "Watch criteria committed for iter-124":

- This iter result is closest to **case 2 (PARTIAL with Step 2 + 3
  residual only)** — Step 1 + Step 4 both closed in body.
- Recommended iter-124 prover action: focused Step 2 + Step 3
  prover lane with the 6-sub-step decomposition from this review's
  `recommendations.md` § CRITICAL #1.
- Per the iter-123 STRATEGY.md commitment, iter-124 fires the
  STRATEGY.md 2-iter CHURNING trigger ONLY if Step 2 produces no
  closure (i.e. another PARTIAL with no substantive Step 2a / 2b
  advance). Step 4 closure this iter resolves the iter-123
  CHURNING verdict to CONVERGING; the trigger countdown resets.
