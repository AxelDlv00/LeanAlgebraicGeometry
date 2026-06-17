# Iter-166 plan-agent run

## Headline outcome

**The "AVR refactor + scaffold-close" iter** — iter-166 picks up the iter-165 depth-conversion
scaffold and converts it into closed structural content. Two parallel prover lanes:

1. **`AbelianVarietyRigidity.lean`** — import `Genus0BaseObjects`; refactor
   `morphism_P1_to_grpScheme_const` to the concrete `ProjectiveLineBar` signature; prove the body
   via the proven `hom_additive_decomp_of_rigidity` (Cor 1.5) consuming
   `gmScalingP1_collapse_at_zero` as the `W`-axis-collapse `_hf`, then density of `Gm ⊆ ℙ¹`
   + `A` separated (`ext_of_eqOnOpen`, proven). Refactor `genusZero_curve_iso_P1`'s target to
   `ProjectiveLineBar` so `rigidity_genus0_curve_to_grpScheme` can transport.
2. **`Genus0BaseObjects.lean`** — close the LIVE-CONSUMER scaffold sorries Lane 1 references as
   black boxes: `gm_grpObj`, `gmScalingP1` body, `gmScalingP1_collapse_at_zero` body, and the three
   `ProjectiveLineBar` k̄-points (`zeroPt`, `onePt`, `inftyPt`). Optionally also
   `projectiveLineBar_geomIrred` / `projectiveLineBar_smoothOfRelDim` if time permits (sub-builds
   Mathlib does not ship for `Proj`).

The lanes are **file-disjoint** (parallel-safe). Lane 1's proof body consumes only Lane 2's
SIGNATURES (already landed iter-165), not bodies — so even if Lane 2 ships PARTIAL, Lane 1's
theorem still type-checks, propagating `sorryAx` upward through the scaffolds that remain.

## Decision made (lane count + signature refactor)

**2 parallel lanes, signature of `morphism_P1_to_grpScheme_const` refactored from the
abstract `(P1 : Over (Spec k̄))` proxy to the concrete `ProjectiveLineBar kbar`.**

Reasoning:
- The progress-critic `routec166` verdict is CONVERGING with the iter-164 tripwire ("iter-166
  must show AVR refactor / proof body started, else CHURNING") **satisfied**: Lane 1 IS the
  refactor + proof body. Going to 2 lanes at exactly the iter the second lane becomes ready
  (Genus0BaseObjects.lean shipped iter-165) is the dispatch-sanity sweet spot — not under-dispatch,
  not over-dispatch.
- Signature refactor (abstract `P1` ⟶ concrete `ProjectiveLineBar`): the abstract proxy was a
  pre-iter-164 device when no concrete ℙ¹ existed in the project. Now it does, so the proof can
  directly consume `gmScalingP1_collapse_at_zero`'s exact shape. Keeping the abstract proxy would
  force a transport-via-iso step that is gratuitous (and circular: the iso to ℙ¹ is precisely
  `genusZero_curve_iso_P1`, which we're also refactoring on this iter). The downstream consumer
  `rigidity_genus0_curve_to_grpScheme` uses `genusZero_curve_iso_P1 → C ≅ ProjectiveLineBar` to
  transport its hypothesis-curve to ℙ¹, then applies the concrete
  `morphism_P1_to_grpScheme_const`.

**Cheapest reversal signal** (per progress-critic Q3): a Lane 1 failure with the blocker phrase
"instance synthesis fails at the V/W slots of `hom_additive_decomp_of_rigidity`" or
"`gmScalingP1_collapse_at_zero` statement doesn't match `_hf` literally" — both of these are
structural-shape issues (re-align signatures), NOT a route pivot. Lane 1's math has been
validated in the blueprint chapter (AVR.tex L1199-1278). If the prover hits issue (3) of the
critic's list — the `_hf` shape doesn't unify — iter-167 fixes the lemma statement in one shot.

## Prior critique status

- **progress-critic `routec` iter-165 tripwire ("iter-166 must convert to depth via AVR refactor
  / proof body started, else CHURNING")** — ADDRESSED this iter: Lane 1 IS the AVR refactor +
  proof body. The fresh `routec166` consult confirmed compliance and re-issued CONVERGING.
- **lean-vs-blueprint-checker `g0bo-iter165` 3 minor coverage gaps** (missing `\lean{...}` hints
  on `Ga`/`Gm`/`Gm.onePt`/the three ℙ¹ points/`gmScalingP1_collapse_at_zero`; MulAction-prose
  trim on `def:gaTranslationP1`) — DEFERRED to a future blueprint-writer hygiene iter; not
  blocking iter-166 prover work (the chapter already pins the two load-bearing
  `\lean{...}` hooks `def:genus0_base_objects` and `def:gaTranslationP1`, and
  `sync_leanok` resolves the rest automatically). Recorded as a standing recommendation.
- **lean-auditor `iter165` 5 stale-narrative majors** (carry-over from iter-164; fallback-route
  files; code axiom-clean) — DEFERRED to a future hygiene-only iter; off-path and non-blocking.

## Subagent verdicts (absorbed)

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| progress-critic | routec166 | **CONVERGING** (Route C) — tripwire SATISFIED; 2-lane count CORRECT; cheapest reversal = signature/shape mismatch on Cor 1.5 V/W slots or `_hf` shape; recommends STRATEGY estimate refresh ~10–18 → ~5–12 with RR-bridge as long pole | iter-166 dispatches 2 lanes as planned. STRATEGY.md updated: ~10–18 → ~5–12, base-case scaffold landed flagged, RR-bridge `genusZero_curve_iso_P1` named as long pole. |

## Subagent skips

- **strategy-critic** — STRATEGY.md is unchanged from iter-165 verbatim (only one cell —
  genus-0 rigidity Iters-left + LOC — was just refreshed *this plan phase* per the progress-critic
  recommendation, no route swap or phase split). iter-163's verdict was SOUND with no live
  CHALLENGE; iter-164/iter-165 strategy-critic was skipped on the same grounds. The single-cell
  estimation refresh is exactly the licensed "estimation change >~30%" edit, not a strategic
  pivot — re-running the critic on it would be a hollow dispatch.
- **blueprint-reviewer** — `AbelianVarietyRigidity.tex` (the consolidated chapter that covers both
  AVR.lean and `Genus0BaseObjects.lean` via `% archon:covers`) cleared the HARD GATE in iter-164
  (`blueprint-reviewer avr-fastpath2` → `complete: true` + `correct: true`, 0 must-fix). iter-165
  edited only the one-line covers directive; iter-166 plan does NOT edit any chapter content. The
  iter-165 `lean-vs-blueprint-checker g0bo-iter165` already audited the chapter against the new
  Lean file and returned 0 must-fix / 0 major / 3 minor (all chapter-side coverage gaps that
  blueprint-writer will pick up in a future hygiene iter). Re-running blueprint-reviewer this iter
  would not change the HARD GATE outcome.

## Prover lanes this iter

### Lane 1 — `AlgebraicJacobian/AbelianVarietyRigidity.lean`

Refactor + proof close. Detailed objective in `PROGRESS.md`. Mathematical content lives in
`blueprint/src/chapters/AbelianVarietyRigidity.tex` (`prop:morphism_P1_to_AV_constant`,
L1199-1278; `prop:genusZero_curve_iso_P1`, L1282-1335; `thm:rigidity_genus0_curve_to_AV`,
L1339-1384).

### Lane 2 — `AlgebraicJacobian/Genus0BaseObjects.lean`

Close the 7 LIVE-CONSUMER scaffold sorries (out of 9 total). Two scaffold sorries
(`ga_grpObj`, and consequently `ga_smooth`) are OFF the primary route (the 𝔾_a-additive
alternative is demoted iter-164) and may be left as `sorry` if convenient; the writer/auditor
will pick them up later. Two sub-build sorries (`projectiveLineBar_geomIrred`,
`projectiveLineBar_smoothOfRelDim`) are nice-to-have but Mathlib does not ship them for `Proj`;
flag PARTIAL if they require deep sub-builds (acceptable per the iter-165 PARTIAL gate scorecard
re-use).

## Acceptable outcomes (per-lane status target)

- **Lane 1 COMPLETE**: signature refactored to concrete `ProjectiveLineBar`; proof body closed
  modulo Lane 2's residual sorries; build green; the 3 AVR scaffold sorries (L936/L960/L989)
  are RESOLVED into actual proof bodies (with `sorryAx` propagated only through the upstream
  `Genus0BaseObjects` sorries still in flight). The headline
  `rigidity_genus0_curve_to_grpScheme` still depends on the (also-deferred)
  `genusZero_curve_iso_P1` until the RR bridge closes — that's the long pole called out by
  the progress-critic.
- **Lane 1 PARTIAL**: signature refactored, proof body started but instance synthesis trips on
  the V/W slot of Cor 1.5 or `_hf` shape doesn't unify. iter-167 lane: signature/shape alignment
  patch.
- **Lane 1 INCOMPLETE**: blocker phrase suggests a deeper math gap; iter-167 plan re-dispatches
  mathlib-analogist (cross-domain mode) on the failing piece.

- **Lane 2 COMPLETE**: all 7 live-consumer sorries close axiom-clean. Lane 1 lifts to fully
  axiom-clean automatically.
- **Lane 2 PARTIAL**: ≥4 of 7 close axiom-clean (e.g. `gm_grpObj` + `gmScalingP1` body +
  `gmScalingP1_collapse_at_zero` body + `ProjectiveLineBar.zeroPt`). The 3 ProjectiveLineBar
  k̄-points and the geomIrred/smoothness sub-builds can slip to iter-167+. Lane 1 still ships
  `sorryAx`-propagated.
- **Lane 2 INCOMPLETE**: cross-domain consult required (e.g. `GrpObj.ofRepresentableBy` doesn't
  accept the units-functor shape for `Gm`); iter-167 lane: mathlib-analogist on the failing piece.

## Open observations (informational, not driving this iter)

- The progress-critic's iter-166 watch tripwire is now: if Lane 1 closes but Lane 2 ships
  INCOMPLETE on `gm_grpObj` / `gmScalingP1` body, iter-167 must NOT spin a 3rd cosmetic lane on
  the same files — instead it should consult mathlib-analogist (cross-domain) on the failing
  installer.
- After iter-166, the next live frontier is `genusZero_curve_iso_P1` (Hartshorne IV.1.3.5 / RR
  bridge — STRATEGY-flagged "no Mathlib RR" long pole). When iter-167+ approaches it, the planner
  should first dispatch a literature/mathlib-analogist consult on whether a partial RR or
  Hurwitz-style alternative is in Mathlib reach; the genus-0 ⟹ ℙ¹ argument has multiple
  textbook realizations and Mathlib may have surprised us with a partial degree-1 divisor / map-to-ℙ¹
  characterization.
- `genusZeroWitness`'s `key` field + the `k̄ → k` descent (in `Jacobian.lean`) remain gated on
  `rigidity_genus0_curve_to_grpScheme` axiom-cleanness, which itself depends on
  `genusZero_curve_iso_P1`. The descent direction is still unconfirmed (STRATEGY open question).

## User-silent fallback executed

No user hints this iter and no prior-iter sidecar fallback section is declared. Proceeded with
normal planning per `## Decision made`.
