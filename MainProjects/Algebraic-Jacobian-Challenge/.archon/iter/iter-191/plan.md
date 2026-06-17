# Iter-191 plan-agent run

## Headline outcome

**The "process iter-190 outcomes (79 sorries / integration RED on
positivePart name clash) + dispatch 3 [HIGHLY RECOMMENDED] critics +
dispatch deferred mathlib-analogist lane-a3i-isconnected-prod +
dispatch refactor `lane-i-positivepart-clash-fix` to atomically resolve
the iter-190 paired-prover clash AND reshape the public
`degree_positivePart_principal_eq_finrank` pin from existential to
equation form (option (i) per iter-190 review recommendations §1/§4)
+ minor blueprint edit on WeilDivisor chapter `positivePart` def to
note `mapRange` equivalence + set 7 prover lanes including a NEW
file-skeleton dispatch on `RiemannRoch/H1Vanishing.lean` (addressing
the iter-190 blueprint-doctor finding) + a NEW first scaffold prover
on `Albanese/CodimOneExtension.lean` (Lane M↓ re-open per iter-190
plan-phase commitment)" iter.**

iter-190 exited at **79 sorries / integration RED** (`lake build`
exited 1 on duplicate
`AlgebraicGeometry.Scheme.WeilDivisor.positivePart`). Sorry trajectory
77 → 79 (+2, transitions to integration RED). The 10-consecutive-zero-
axiom build streak is interrupted until iter-191 plan-phase resolves
the clash via the dispatched refactor.

## Decision made

**`lane-i-positivepart-clash-fix` refactor dispatch (option (i) per
iter-190 review recommendations §1).** The iter-190 paired-prover
collision is repaired atomically by a single `refactor` subagent
holding write_domain on BOTH affected files
(`RiemannRoch/WeilDivisor.lean` + `RiemannRoch/RationalCurveIso.lean`).
The refactor:

1. Removes the file-local `WeilDivisor.positivePart` def + private
   pin in `RationalCurveIso.lean` (~64 LOC removed including
   docstrings).
2. Reshapes the public
   `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
   signature from existential
   (`∃ t halg, deg(positivePart(principal _)) = finrank`) to equation
   form with explicit `(t : K)` + `(halg : ... ≠ 0)` arguments. The
   semantic shift is from "exists a witness" to "for any concrete
   witness". Both forms are mathematically equivalent at the
   typed-sorry level (body owed iter-191+ regardless).
3. Updates `Hom.poleDivisor_degree_eq_finrank` body in
   `RationalCurveIso.lean` to consume the public pin specialised at
   `t = (localParameterAtInfty kbar).val`.

**Why option (i)** (reshape Lean signature, NOT reshape blueprint
prose): The chapter prose in `RiemannRoch_WeilDivisor.tex` §6
states Hartshorne II.6.9 in equation form (`deg(...) = finrank`).
This is mathematically natural and matches the verbatim Hartshorne
quote. The existential form was an iter-190 prover-side soundness
fix because the chapter's `t` was implicitly the localParameterAtInfty
witness, but no Lean instance binding tied `K = K(ℙ¹)` with that
specific witness. The proper fix at the Lean side is to take the
local-parameter `t` as an explicit argument — restoring the equation
form AND preserving soundness (any caller must produce a `halg`
witness, which they have).

**Reversal signal**: if the refactor agent reports that the equation
form refactor introduces a new sorry (e.g. typeclass instance
synthesis on `[Module.Finite K K(C)]` no longer derives at the
consumer site without manual binder), revert option (i) and instead
have the iter-192 plan agent re-write the blueprint chapter prose to
match the existential form (option (ii)). The iter-191 plan agent
considers option (i) higher-leverage because the equation form is the
canonical mathematical content of II.6.9.

**Lane H scaffold dispatch on `H1Vanishing.lean` (NEW file).** The
iter-190 blueprint-doctor flagged `% archon:covers
AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` against a non-existent
Lean file. iter-191 dispatches a prover with file-skeleton mode on
`H1Vanishing.lean` to scaffold the 8 declarations the
`RiemannRoch_H1Vanishing.tex` chapter pins:
`IsFlasque`, `IsFlasque.pushforward`, `IsFlasque.constant_of_irreducible`,
`HModule_flasque_eq_zero`, `skyscraperSheaf_eq_pushforward_const`,
`PrimeDivisor.closure_isIrreducible`, `skyscraperSheaf_isFlasque`,
`H1_skyscraperSheaf_finrank_eq_zero`. Bodies as `sorry` (file-skeleton
dispatch type — not yet attempting to fill any of them).

This unblocks iter-192+ Lane H continuation (RRFormula consumer of
`H1_skyscraperSheaf_finrank_eq_zero`).

**Lane M↓ first scaffold dispatch on `CodimOneExtension.lean`.** Per
iter-190 plan-phase re-open commitment (Option (a) project-side Stacks
00TT build), iter-191 dispatches the first prover with file-skeleton
mode on `CodimOneExtension.lean` for
`isRegularLocalRing_stalk_of_smooth` (~50-100 LOC initial skeleton via
the smooth → flat → polynomial presentation chain). Body bounded to
the initial Stage 1 of the Stacks 00TT proof; subsequent stages owed
iter-192+ across the ~8-15 iter pipeline.

**Other dispatches**: Lane G continues (project-side `x ∈ 𝔭`
contradiction; ~150 LOC bounded attempt iter-191), Lane F closes
Step 3 residual (per iter-190 prover analysis, 30-60 LOC chain via
`appLE_appIso_inv` + `fromSpec_app_self` + `restrictScalars.smul_def`
— Mathlib b80f227 has all ingredients), Lane B consumers in
`GmScaling.lean` (Substrate 1 + 2 now both axiom-clean), Lane E
continues `iotaGm_chart1_composition_isOpenImmersion` via approach (b)
recipe.

## Critic verdicts (this iter — pending)

| Critic | Slug | Verdict (pending) |
|---|---|---|
| blueprint-reviewer | `iter191` | dispatched; awaiting report |
| progress-critic | `route191` | **COMPLETE** — 3 CONVERGING (Lane I, Lane G, Lane B); 1 UNCLEAR (Lane M↓ fresh); 4 must-fix: Lane F CHURNING (5 iters flat at 13 sorries; needs Mathlib analogy consult), Lane E STUCK (2 iters at budget on `chart1_composition_isOpenImmersion`; needs blueprint expansion OR sub-step scope), Lane A.3.i CHURNING (analogist queued — corrective in flight), Lane H + Lane A CHURNING (deferred-infrastructure — H1Vanishing scaffold this iter is the corrective). ACTIONED: Lane F dropped from iter-191 prover (`mathlib-analogist lane-f-restrictscalars-smul` dispatched plan-phase); Lane E scoped to sub-step (refactor + close in 2 parts with hard budget). |
| strategy-critic | `iter191` | **COMPLETE** — SOUND with CHALLENGE on 3 effort-honesty items + 1 format DRIFTED. **ACTIONED**: (1) STRATEGY.md A.4.d.0.AJ sub-substrate row split out (~150-250 LOC Abel-Jacobi morphism extraction); (2) Lane M↓ upper-bound LOC widened ~150-500 with named Mathlib entry point `RingTheory/Smooth/StandardSmooth` Jacobian criterion; (3) Total positive-genus envelope re-framed as upper-bound assuming throughput improvement (acknowledges realized cumulative-velocity below implied rate); (4) iter-191 tag stripped from Status cell at line 30. **No infrastructure-deferral findings** — every previously-deferred construction is on the project-side critical path with concrete LOC estimate. Alternative suggested: Lane M↓ via Étale-local standard-smooth + Jacobian criterion may halve the Option (a) estimate (noted but not yet committed — iter-192+ explore). |
| Lane A.3.i mathlib-analogist | `lane-a3i-isconnected-prod` | **COMPLETE** — substrate is OWNED in Mathlib at `Geometrically/Connected.lean:100` (`ConnectedSpace (pullback f g)` instance). The ONLY project-side gap is `geometricallyConnected_of_connected_of_section` (Stacks 04KU / EGA IV₂ 4.5.14 — connected scheme with k-rational section is geometrically connected); ~80-120 LOC single declaration, upstream-able to Mathlib. Also: consume `grpObjMkPullbackSnd` (Cartesian/Over.lean:312) for the `GrpObj` inheritance — NOT the scheme-side `GrpObjAsOverPullback` (avoids `asOver` / `OverClass` plumbing). **Total iter-192 budget**: ~100-140 LOC across the helper file + IdentityComponent.lean plumbing. Lane A.3.i prover dispatch SCHEDULED iter-192 (not added to iter-191 to keep this iter's prover budget bounded; the analogist verdict landed mid-iter and a fresh prover lane would over-extend iter-191's 5-lane budget). |
| Lane I refactor | `lane-i-positivepart-clash-fix` | **COMPLETE** — clash fix landed + public pin reshaped to equation form + `Hom.poleDivisor_degree_eq_finrank` body consuming the public pin axiom-clean. **`lake build AlgebraicJacobian` GREEN.** 1 explicit `[Module.Finite K(ℙ¹) K(C)]` binder cascade added to `morphism_degree_via_pole_divisor` (directive anticipated only the consumer; instance failed at the wrapper too). RationalCurveIso.lean sorry 2 → 1 (file-local pin removed). WeilDivisor.lean sorry 3 → 3 (signature reshape preserves the typed-sorry). |

Verdicts will be incorporated into iter-191 prover objectives + this
sidecar as they return. If any critic returns a must-fix-this-iter
finding that materially changes the plan, this sidecar is amended.

## Acting on iter-190 review recommendations.md

The session_190 recommendations.md is the primary input for iter-191
plan-phase. Each item:

### CRITICAL §1 — clash fix
**ACTIONED**: refactor `lane-i-positivepart-clash-fix` dispatched
this iter. Includes option (i) signature reshape per recommendations
§4.

### §3 — H1Vanishing.lean missing
**ACTIONED**: file-skeleton prover dispatch in iter-191 Current
Objectives (slot 6).

### §4 — Blueprint mismatch on `lem:degree_positivePart_principal_eq_finrank`
**ACTIONED via §1**: the refactor reshapes Lean to equation form
(matches chapter prose). No blueprint chapter prose edit needed for
the lem block. The `def:WeilDivisor_positivePart` block was patched
this iter to note the `mapRange` ↔ lattice equivalence.

### MEDIUM §5 — Lane F ready to close
**ACTIONED**: Lane F prover dispatch in iter-191 Current Objectives
(slot 3). The iter-190 escalation rule on Stacks 01I8 does NOT
apply — Step 3 residual is in a different Mathlib region (01HH +
restrictScalars). HARD BAR: close axiom-clean.

### MEDIUM §6 — Lane G `(x) ∈ minimalPrimes R` substrate
**ACTIONED**: Lane G prover dispatch in iter-191 Current Objectives
(slot 4). Bounded budget ~150 LOC iter-191 (NOT the full ~500-800 LOC
graded ring substrate); attempt the Cohen-via-completion bypass first
OR initiate graded ring scaffold. If neither lands ≥1 axiom-clean
helper, iter-192 dispatches mathlib-analogist `lane-g-stacks-00nq`
cross-domain consult.

### MEDIUM §7 — Lane E `chart1_composition_isOpenImmersion`
**ACTIONED**: Lane E prover dispatch in iter-191 Current Objectives
(slot 5) via approach (b) recipe (specialise on `iotaGm_r_1` /
`iotaGm_r_1_fac` directly). ~110 LOC budget over this iter.

### MEDIUM §8 — Lane B consumers
**ACTIONED**: Lane B-consumers prover dispatch in iter-191 Current
Objectives (slot 7).

### DO NOT RETRY (Lane A.3.i, J, M↓)
**Lane A.3.i**: dispatched analogist this iter; prover dispatch
GATED on analogist verdict + verdict-acted upon. NOT in iter-191
Current Objectives.

**Lane J**: DO NOT DISPATCH iter-191 (carry-forward).

**Lane M↓**: dispatched first scaffold prover this iter per iter-190
plan-phase re-open commitment.

## Plan-phase subagent dispatches iter-191 (this iter)

1. **`blueprint-reviewer iter191`** ([HIGHLY RECOMMENDED]) — DISPATCHED.
   Verifies iter-190 plan-phase chapter additions
   (RR_H1Vanishing.tex / WeilDivisor §6 / QuotScheme pins / RationalCurveIso
   Pin 2 NOTE) and iter-190 prover-phase mismatches
   (positivePart-mapRange + existential-vs-equation pin).
2. **`progress-critic route191`** ([HIGHLY RECOMMENDED]) — DISPATCHED.
   Re-verdict on the 5 active routes given iter-190 prover output.
3. **`strategy-critic iter191`** ([HIGHLY RECOMMENDED]) — DISPATCHED.
   Re-validates iter-190 STRATEGY.md substantive revisions (Lane M↓
   re-open, A.3.0 / A.4.d.0 substrate additions, format compliance).
4. **`mathlib-analogist lane-a3i-isconnected-prod`** (deferred from
   iter-190) — DISPATCHED in cross-domain-inspiration mode.
5. **`refactor lane-i-positivepart-clash-fix`** — DISPATCHED.
   Atomic 2-file repair of iter-190 clash + signature reshape.
6. **`mathlib-analogist lane-f-restrictscalars-smul`** — **COMPLETE**.
   Verdict: **(B) PROCEED** — the iter-190 prover's chaining sequence
   (`Hom.app_smul` → `restrictScalars.smul_def` → `Scheme.Modules.map_smul`
   → `appLE_appIso_inv` + `fromSpec_app_self`) IS the canonical Mathlib
   idiom at b80f227. No high-level `LinearEquiv` lemma exists; a carrier
   refactor would just relocate the Stacks 01HH bridge.
   **Critical new finding (Decision 3, verified by `lean_multi_attempt`)**:
   Lean's HSMul resolution does NOT unfold `Scheme.Modules.restrict_obj`
   even though it's `rfl`. The iter-192 prover directive MUST include
   the **aliasing-`let` workaround**: introduce `let y : ↑Γ(N, hU.fromSpec
   ''ᵁ ⊤) := (Hom.app isoSheaf.hom ⊤).hom x` BEFORE attempting the
   smul-unfold, so the Y-side `Module` instance becomes visible.
   Without this, the prover risks a 6th flat iter on the elaboration
   hazard. Lane F prover SCHEDULED iter-192 with this recipe.

## Plan-phase deferrals (with explicit rationale)

- **`blueprint-writer pic0-abelian-variety-skeleton`** (A.3.iii–vii
  unstarted chapter): MEDIUM-priority. No active prover blocked this
  iter; the substrates A.3.0 + A.3.ii are themselves gated on
  multi-iter work (A.2.c + A.3.i). Defer iter-192+ until a
  Pic⁰AV-targeted prover lane is on the horizon.
- **`blueprint-writer albaneseup-divisormap-rewrite`** (A.4.d pivot
  chapter rewrite): deferred a THIRD time iter-191. AlbaneseUP body is
  iter-200+ standing deferral; the chapter rewrite is informational
  + structural and does NOT block any active prover. Defer iter-192+.
  The directive is ready for re-dispatch at
  `.archon/logs/iter-189/blueprint-writer-albaneseup-divisormap-rewrite-directive.md`.
- **`mathlib-analogist lane-g-stacks-00nq`** (cross-domain consult
  on `(x) ∈ minimalPrimes R` substrate): considered for this iter
  but deferred to iter-192 IF iter-191 Lane G prover dispatch fails
  to land ≥1 axiom-clean helper. The progress-critic CONVERGING
  verdict on Lane G iter-190 suggests the route is healthy enough
  to continue without a consult.

## Sorry projection iter-191

Entering iter-191 plan-phase: **79 sorries** (integration RED on
positivePart clash; per-file deltas + clash absence indicate ~79).

Post-refactor `lane-i-positivepart-clash-fix` (clash resolved):
- RationalCurveIso.lean: 2 → 2 sorries (file-local pin removed but
  consumer body now closes axiom-clean modulo the public pin's
  sorryAx — net −1 file-local pin + 0 new sorry).
- WeilDivisor.lean: 3 → 3 sorries (signature reshape preserves sorry
  count; the body is still typed-sorry).
- Integration GREEN.

Net post-refactor: **78 sorries** (one file-local pin sorry removed).

Prover phase projections (7 lanes):

- **Best case** (Lane G ≥1 axiom-clean helper + Lane I Pin 3 sub-tasks
  axiom-clean + Lane F Step 3 close + Lane B 3 GmScaling consumers
  close + Lane E chart1_composition_isOpenImmersion close + Lane H +
  Lane M↓ skeletons file-scaffolds [each adds ~5-10 typed-sorry pins
  per file-skeleton]):
  78 → **~75-80** (small net change because file-skeletons add typed-
  sorry pins but other lanes close several).

- **Realistic** (3-4 lanes HARD BAR met; ≥1 lane PARTIAL):
  78 → **~78-82** (file-skeletons land but other closures cluster
  around 2-3 axiom-clean per iter).

- **Worst case** (Lane G fails Cohen + graded-ring; Lane I Pin 3
  hits unanticipated Mathlib gaps; Lane F Step 3 fights restrictScalars;
  Lane B consumers fight Cross01Substrate API + 2 new file-skeletons
  add ~15 typed-sorry pins):
  78 → **~88-93** (significant pin-count growth from file-skeletons).

## Active monitors

- **Integration build monitor**: post-refactor lake build must be
  GREEN before any other prover lane is dispatched. If refactor
  reports STRUCTURAL_BLOCKED, escalate to user (write to TO_USER.md
  via review).
- **Lane G commit-watch**: iter-191 prover must land ≥1 axiom-clean
  helper on the `x ∈ 𝔭` case OR a structural pivot to graded ring
  scaffold (with first axiom-clean piece). If 0 closures + 0 scaffold
  pieces, route tips to CHURNING for iter-192.
- **Lane F Step 3 watch**: iter-190 review §5 estimated 30-60 LOC
  axiom-clean closure. If Lane F PARTIAL again iter-191, route is
  confirmed CHURNING and iter-192 escalates to refactor subagent.
- **Lane M↓ first-scaffold watch**: this is the FIRST prover
  dispatch on the Stacks 00TT pipeline. Stages 1-2 (smooth ⟹ flat,
  flat at stalk ⟹ standard smooth presentation, polynomial generators)
  ~50-100 LOC. If iter-191 lands these axiom-clean, the pipeline is
  validated.
- **Lane H file-scaffold watch**: file-skeleton dispatches typically
  succeed (low risk); the failure mode would be a chapter-Lean
  signature mismatch (e.g. `Scheme.HModule kbar` accessibility from
  H1Vanishing.lean depending on imports). If the dispatch reports
  STRUCTURAL_BLOCKED, fall back to a manual file creation via review-
  agent annotation.
- **Quota envelope**: resets 2026-05-28T07:00:00Z (~14h out at
  iter-191 plan-phase mid-point). Healthy.

## Standing deferrals (gated, not active iter-191)

- **Pic⁰AbelianVariety A.3.iii-vii** (blueprint chapter unstarted;
  iter-192+ blueprint-writer dispatch when A.3.0 + A.3.ii substrates
  mature).
- **AlbaneseUP divisor-map rewrite** (deferred 3rd time; iter-192+
  plan-phase target).
- **AlbaneseUP body lanes** — iter-200+ standing deferral.
- **A.4.a / A.4.c body** — gated on Lane M↓ Stacks 00TT close.
- **OcOfD `sheafOf` def body** — STRUCTURALLY BLOCKED (iter-187).
- **Lane A.3.i prover dispatch** — GATED on analogist verdict +
  verdict-acted upon (iter-192+ if analogist returns a tractable
  Mathlib path).
- **Lane J `OcOfD.lean`** — DO NOT RETRY (carry forward).

## Iter-192 (preliminary commitments)

1. **Lane I body work** — `degree_positivePart_principal_eq_finrank`
   body via Hartshorne II.6.9 affine-chart `Ideal.sum_ramification_inertia`
   chain (~50-80 LOC, per `analogies/ratcurveiso-pin2.md` Decision 2).

2. **Lane H body work** — close `H1_skyscraperSheaf_finrank_eq_zero`
   body via the flasque-vanishing chain landed in the new
   `H1Vanishing.lean` scaffold (after the iter-191 file-skeleton).

3. **Lane M↓ Stage 2-3 scaffold** — continue Stacks 00TT pipeline
   (~100-150 LOC additional skeleton; ~3-5 iter chain).

4. **Mandatory `blueprint-reviewer iter192`** confirms iter-191
   blueprint mismatch resolution + new H1Vanishing.lean ↔ chapter
   alignment.

5. **Mandatory `progress-critic iter192`** verifies iter-191 HARD
   BARs against the 7 dispatched lanes.

6. **Strategy-critic skip eligible** if STRATEGY.md unchanged
   between iter-190 and iter-191 AND prior verdict CONVERGING.
