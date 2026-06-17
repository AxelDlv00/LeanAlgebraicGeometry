# Iter-167 plan-agent run

## Headline outcome

**The "close the deferred genus-0 base-case stack" iter.** iter-166 PARTIAL converted the genus-0
arm from "scaffold ready" to "scaffold + AVR refactor + outer-body proven (sorryAx propagation
only)." iter-167 picks up the residual: discharge the 3 CRITICAL deferred items on
`Genus0BaseObjects.lean` AND the 5 aux-helper internal sorries on `AbelianVarietyRigidity.lean`
that propagate from them.

Three proactive consults landed first to set up the prover work:

1. **progress-critic `routec167` → CONVERGING (both lanes).** Iter-166 expansion of Lane B's
   sorry count (3→6 inside the new private aux) is "decomposition, not churn" — outer bodies
   landed sorry-free, every new sorry is named with a concrete blocker, and the encapsulator
   helper is a single ~100-LOC body (not a wrapper-proliferation pattern). Recommended Q4:
   pick `gmScalingP1` + `gmScalingP1_collapse_at_zero` as iter-167 PRIMARY (these unblock
   Lane B), defer `gm_grpObj` to iter-168 unless the analogist surfaces a tractable recipe.
   Hard test: iter-167 must close ≥3 of 5 aux sorries on AVR or Lane B escalates to CHURNING.
2. **mathlib-analogist `gm-grpobj` → PROCEED (7 of 7 questions).** Concrete recipes for all 7
   targets: `gmScalingP1` via `Scheme.Cover.glueMorphisms` + `Proj.affineOpenCoverOfIrrelevantLESpan`
   + `pullbackSpecIso`; `gm_grpObj` via `GrpObj.ofRepresentableBy` + the 4-step bijection chain
   `OverHom → ΓSpec → IsLocalization.Away.lift → IsUnit`; product-stability instances via
   composition/base-change stability + `IsReduced.of_openCover` workaround for the
   `Smooth → GeometricallyReduced` Mathlib gap; `IsReduced ProjectiveLineBar.left` via the
   same chart-cover idiom. **Bonus**: `ga_grpObj` becomes 2-3 LOC via `AffineSpace.homOverEquiv`.
   Persistent file: `analogies/gm-grpobj-and-friends.md`.
3. **blueprint-writer `avr-lean-hooks` → COMPLETE.** Added 8 per-decl `\lean{...}` blocks
   under `def:genus0_base_objects` + 1 new lemma block `lem:gmScaling_fixes_zero` pinning
   `gmScalingP1_collapse_at_zero` + cross-referenced from `prop:morphism_P1_to_AV_constant`'s
   W-axis-collapse step. Promoted 3 "[expected]" annotations to real `\lean{...}` hooks.
   Closes the iter-165/166 chapter-side per-decl coverage gap the `g0bo-iter166` checker
   flagged. No strategy-modifying findings.

The analogist's concrete `gm_grpObj` recipe — surfacing a 4-step bijection chain through
Mathlib API hooks the iter-166 prover characterised as "non-trivial sub-build, out of scope" —
is a substantial de-risking. Combined with the FREE `ga_grpObj` bonus path, the planner
upgrades `gm_grpObj` from "DEFERRED to iter-168" to "OPT-IN this iter, attempt after the
PRIMARY load lands." This is the recommended-by-critic version PLUS a concrete tackle on the
critic's watch item.

## Decision made (lane count + scope)

**2 parallel lanes (Lane A on `Genus0BaseObjects.lean`, Lane B on `AbelianVarietyRigidity.lean`)
with PRIMARY/OPT-IN tiering, NOT a single-lane Lane-A drill.**

Reasoning:

- The progress-critic explicitly answered Q3: "2 lanes is right — file-disjoint with within-iter
  interlock is exactly what parallel dispatch handles well." The alternative (single-lane
  Lane-A drill, defer Lane B to iter-168) idles the prover budget Lane B can productively use
  on 4 of 5 aux sorries that DON'T require Lane A's `gmScalingP1` body.
- Lane B's within-iter interlock on Lane A's `gmScalingP1` body affects ONLY 1 of 5 aux sorries
  (L1037, `IsDominant iotaGm.left`). The other 4 (3 product instances + 1 `IsReduced
  ProjectiveLineBar.left`) close from Lane A's exported product/Proj instances independently
  of `gmScalingP1`'s body — they only need Lane A to ADD the named instances.
- Tiering: each lane has a PRIMARY (must-land) target + OPT-IN (nice-to-land) targets. The
  PRIMARY set is conservative — what the critic explicitly endorses + what the analogist
  recipes are simplest for. The OPT-IN set captures the analogist's "bonus" findings:
  `ga_grpObj` becomes FREE, `gm_grpObj` becomes tractable, `projectiveLineBar_geomIrred` shares
  the chart-cover technique with `IsReduced ProjectiveLineBar.left` so the prover may close it
  for free if both fit in the iter.

**Cheapest reversal signal (per progress-critic Q4 framing):**

- If Lane A's prover reports `gmScalingP1` body intractable to even *state* cleanly (the
  `Scheme.Cover.glueMorphisms` 2-chart cover assembly trips on Mathlib instance synthesis),
  the structural recourse is a single-iter `mathlib-analogist` cross-domain consult on
  similar `Proj`-cover gluing in any domain. The iter-167 plan does NOT pre-schedule that
  consult — only fire it if Lane A reports the specific blocker.
- If Lane B's prover reports ≥3 of 5 aux sorries closing on the named product/Proj instances
  but `IsDominant iotaGm.left` (L1037) tripping on the open-immersion-into-ℙ¹ argument, that
  is a Lane A coupling problem and is closed by iter-168 picking up `gmScalingP1`'s concrete
  open-immersion form.

## Prior critique status

- **progress-critic `routec166` iter-166 tripwire ("iter-167 must convert to closure / cleanup
  the residual sorries, else CHURNING is on the table for Lane B")** — ADDRESSED this iter:
  Lane B PRIMARY = close ≥3 of 5 aux sorries via Lane A's exported instances. Lane A PRIMARY =
  ship the instances Lane B consumes. Fresh `routec167` consult re-confirms CONVERGING on
  both lanes (this iter is the discriminator the critic named).
- **lean-vs-blueprint-checker `g0bo-iter166` 6 MAJOR chapter-side coverage gaps** (missing
  per-decl `\lean{...}` hooks for `zeroPt`/`onePt`/`inftyPt`/`Ga`/`Gm`/`Gm.onePt`/`gm_grpObj`/
  `gmScalingP1_collapse_at_zero`) — ADDRESSED this iter: blueprint-writer `avr-lean-hooks`
  closed all 6 with 8 new per-decl pins + 1 companion lemma block. Reviewed in the writer
  report; no fresh blueprint-reviewer dispatch needed (no must-fix to clear, no new chapter
  edits gating any prover lane).
- **lean-auditor `iter166` 5 MAJOR TODO/excuse-comments in `AbelianVarietyRigidity.lean`
  (L943/947/952/1028/1034)** — ADDRESSED this iter as part of Lane B PRIMARY (the planner's
  instruction to the prover: drop the `-- TODO:` lines and let the `sorry`s + docstring carry
  the alarm).
- **lean-auditor `iter164/165/166` 6 MAJOR stale-narrative blocks in fallback-route files
  (`Cotangent/GrpObj` ×2, `Cotangent/ChartAlgebra`, `RigidityKbar`, `Jacobian`)** — DEFERRED
  to a future hygiene-only iter when no critical-path lane is open. Not blocking iter-167.
- **lean-vs-blueprint-checker `avr-iter166` 3 minor recommendations** (Lean's private helper
  `morphism_P1_to_grpScheme_const_aux` lacks chapter coverage; 5 scaffold sorries not named as
  blueprint obligations; off-path `\lean{...}` hints on 3 demoted decls) — DEFERRED: the
  private helper is a Lean-side decomposition refactor, not load-bearing for the proof
  correctness (the outer body is the contract); the 5 scaffold sorries are documented in the
  helper docstring; the off-path `\lean{...}` hints are informational.

## Subagent skips

- `strategy-critic`: STRATEGY.md SHA unchanged from iter-166-end (only iter-166's velocity
  refresh ~10–18 → ~5–12 is in place); prior strategy-critic verdict was iter-164's
  `basecase-reopen` CHALLENGE — addressed iter-164 (route resolved to 𝔾_m-scaling shortcut)
  and recorded as "addressed" in iters 164/165/166. No live CHALLENGE since.
- `blueprint-reviewer`: per the dispatcher_notes skip rule — no chapter edits in iter-166
  (Lane 1's `% archon:covers` extension was iter-165; iter-166 had no chapter edits); the
  iter-164 `avr-fastpath2` HARD GATE clear remains in force for `AbelianVarietyRigidity.tex`;
  this iter's blueprint-writer `avr-lean-hooks` edits are coverage-pin additions only (no
  proof-content edits), and the lean-vs-blueprint-checker `avr-iter166` + `g0bo-iter166`
  reports raised no must-fix-this-iter findings. Re-dispatching the reviewer now would
  reratify already-cleared content. Will re-dispatch in iter-168 if the writer edits
  surfaced any structural concern after the prover runs against them.

## Pre-prover landscape

### Genus0BaseObjects.lean
- **3 ℙ¹-points axiom-clean** (iter-166: `zeroPt`/`onePt`/`inftyPt`).
- **5 Mathlib bridge instances axiom-clean** (iter-165: `gaScheme_canOver`, `ga_isAffineHom`,
  `ga_locallyOfFinitePresentation`, `ga_isReduced`, `gm_isAffine`, `gm_locallyOfFinitePresentation`,
  `gm_isReduced`).
- **`projectiveLineBar_isProper` axiom-clean** (iter-165).
- **6 scaffold sorries remain on file** — `projectiveLineBar_geomIrred` (L177, OPT-IN),
  `projectiveLineBar_smoothOfRelDim` (L184, OPT-IN), `ga_grpObj` (L335, OPT-IN now FREE via
  analogist bonus), `gm_grpObj` (L400, CRITICAL — analogist gives 4-step recipe),
  `gmScalingP1` (L437/439, CRITICAL — PRIMARY this iter), `gmScalingP1_collapse_at_zero`
  (L452/456, CRITICAL — PRIMARY this iter).

### AbelianVarietyRigidity.lean
- **Rigidity Lemma chain + Cor 1.5 + Cor 1.2 axiom-clean** (iter-162/163).
- **`morphism_P1_to_grpScheme_const` body landed** (iter-166, outer body sorry-free,
  delegates to private helper).
- **`rigidity_genus0_curve_to_grpScheme` body landed** (iter-166, outer body sorry-free).
- **`genusZero_curve_iso_P1` body remains `sorry`** (L1131/1137, RR-bridge long pole,
  iter-168+).
- **5 internal sorries in `morphism_P1_to_grpScheme_const_aux`** (L944/L949/L953/L1029/L1037
  — PRIMARY closure target this iter).
- **5 `-- TODO:` excuse comments** (L943/L947/L952/L1028/L1034 — drop this iter per
  lean-auditor major).

## Soundness check before spending budget

The `gmScalingP1` body lemma's statement specifies the morphism behaviour entirely chart-wise
on the standard 2-chart cover of `ℙ¹ × Gm`. Counterexample check: chart-level definitions are
`(x, λ) ↦ λx` on `𝔸¹ × Gm` and `(u, λ) ↦ u/λ` on the `∞`-chart. Take the simplest non-trivial
model: `kbar = ℂ` (alg closed). `x = 0`: chart-`x` map sends `(0, λ) ↦ 0` for all `λ`,
exactly the `gmScalingP1_collapse_at_zero` fixed-point statement. `x = ∞`: chart-`u` map sends
`(u = 0, λ) ↦ 0/λ = 0` — also `∞` fixed (a known second fixed point). Cross-chart agreement:
on `(𝔸¹ \ {0}) × Gm` both charts compute `λ x ↦ 1/(λx) = u/λ`; they agree iff
`λ·x · u/λ = u·x = 1`, i.e. `u = 1/x`, which is the chart-transition relation. The statement
is consistent with the elementary fact that the Möbius scaling action of `𝔾_m` on `ℙ¹` is a
genuine total morphism. No counterexample. Proceed.

The product-stability instances Lane A exports are stated for the specific encoding
`ProjectiveLineBar ⊗ Gm` (`Over k̄`-categorical product). Counterexample check: on alg-closed
`kbar`, both factors are irreducible (`ℙ¹` from `Proj` of a polynomial domain; `Gm` from
`Spec` of a localization of a polynomial domain), reduced (same reasoning), and LOFT (both
finite type over `k̄`). The product over an alg-closed base preserves irreducibility (no
Galois-conjugate component splits) and reducedness (perfect base) and LOFT (stable under
composition + base change). All four product-stability claims are mathematically correct. No
counterexample. Proceed.

## Iter-167 dispatch plan summary

2 prover lanes, both file-disjoint:

- **Lane A (`Genus0BaseObjects.lean`)** — primary: `gmScalingP1` body + `gmScalingP1_collapse_at_zero`
  body + 4 product/Proj instances Lane B consumes. Opt-in: `gm_grpObj` (analogist recipe),
  `ga_grpObj` (analogist FREE), `projectiveLineBar_geomIrred` (shares chart-cover technique).
- **Lane B (`AbelianVarietyRigidity.lean`)** — primary: close ≥3 of 5 aux sorries via Lane A's
  exported instances; drop the 5 `-- TODO:` excuse comments. Opt-in: close all 5 if Lane A
  ships fully (including `IsDominant iotaGm.left` once `gmScalingP1`'s open-immersion form
  is concrete).

Three subagent dispatches already executed (above). One blueprint-doctor run will be
automatically triggered between prover and review phases (deterministic).

## Post-iter watch items (for iter-168)

- Lane A may PARTIAL on `gm_grpObj` if the `IsLocalization.Away.lift` ↔ `IsUnit` bijection is
  thornier than the analogist scoped. Acceptable: `gm_grpObj` propagates `sorryAx` through
  `gm_smooth` etc., but no actual blockage for Lane B's PRIMARY targets.
- Lane B may PARTIAL on `IsDominant iotaGm.left` if Lane A's `gmScalingP1` body lands but the
  `Gm ↪ ℙ¹` open-immersion form isn't immediately readable from it. iter-168 ships a small
  `iotaGm_isDominant` lemma to close.
- `genusZero_curve_iso_P1` body (the RR-bridge long pole) — iter-168 OR later. Pre-prover
  consult: mathlib-analogist on Mathlib's divisor / RR / degree-map machinery (whatever
  fragments exist).

## Pin: blueprint-writer findings to read

`task_results/blueprint-writer-avr-lean-hooks.md` — 8 new per-decl `\lean{...}` blocks + 1
new lemma block + 1 cross-reference; details which Lean declarations now have chapter
coverage hooks. iter-168 prover may consume the new `lem:gmScaling_fixes_zero` block as
the formal record of the σ_× fixed-point fact.

## Pin: analogist findings to read

`analogies/gm-grpobj-and-friends.md` — concrete Mathlib citations for all 7 iter-167 targets,
incl. the 4-step `gm_grpObj` bijection chain, the `Scheme.Cover.glueMorphisms` chart-cover
recipe for `gmScalingP1`, and the `IsReduced.of_openCover` workaround for the `Smooth →
GeometricallyReduced` Mathlib gap on Q4(c). iter-167 prover should read this file before
attempting any of the targeted constructions.
