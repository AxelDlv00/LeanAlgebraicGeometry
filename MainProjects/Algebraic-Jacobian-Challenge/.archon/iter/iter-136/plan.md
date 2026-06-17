# Iter-136 (Archon canonical) plan-agent run

## Headline outcome

Iter-135 closed plan-only with 3 honest sorry-bodied scaffolds at
`Cotangent/GrpObj.lean:468/496/560` typed against the intended
sheaf-level RHS (Mathlib's `Scheme.Hom.toRingCatSheafHob`). Both
iter-135 review-phase audits classified the refactor as a "legitimate
honesty improvement". Per session_135/recommendations.md HIGH +
iter-135 PROGRESS.md watch criterion 4, **iter-136 dispatches a
prover lane on Step 3 only** —
`relativeDifferentialsPresheaf_restrict_along_identity_section`
at `Cotangent/GrpObj.lean:496` — the cheapest substantive piece
(~30–80 LOC closure via `PresheafOfModules.pullbackComp` +
`PresheafOfModules.pullbackId` on the categorical identity
`pr_2 ∘ s = η_G ∘ π_G`).

**Iter-136 is a plan + parallel-writer (small) + prover iter.**
3 mandatory critics returned cleanly; 1 plan-agent direct edit
clears the blueprint-reviewer must-fix (broken `\ref{chap:rigidity_kbar}`
in `AlgebraicJacobian_Cotangent_GrpObj.tex`, 2 instances; case-only
fix); 2 STRATEGY.md edits absorb strategy-critic-iter136 CHALLENGE 1
(over-k qualitative-defense framing tightening) + CHALLENGE 2
(piece-(ii) `Differential.ContainConstants` alignment must be pinned
before iter-141+).

## Subagent dispatches this iter (3 mandatory critics)

| Subagent | Slug | Verdict | Outcome |
|---|---|---|---|
| `strategy-critic` | iter136 | **SOUND** with 2 CHALLENGEs + 1 minor-to-moderate alternative (7 routes audited, 0 REJECT) | CHALLENGE 1 (over-k qualitative-defense framing) **ABSORBED** via STRATEGY.md edit demoting (iii) from "defense ground" to "risk mitigation" + honestly naming (ii) blueprint cleanliness as switching-cost-flavored. CHALLENGE 2 (piece-(ii) `Differential.ContainConstants` alignment loose) **ABSORBED** via STRATEGY.md edit adding new sequencing-table row for an iter-139/140 mathlib-analogist consult on the bridge, MUST dispatch before iter-141+ piece-(ii) scaffolding. Minor alternative (partial-result shipping; ship 9 protected decls with `sorry` on `0 < genus C`) **REBUTTED WITH SCOPE NOTE** — see § "Rebuttal to strategy-critic minor alternative" below. |
| `blueprint-reviewer` | iter136 | 11 chapters audited; **1 must-fix-this-iter** + 3 informational | Must-fix (broken `\ref{chap:rigidity_kbar}` → `\ref{chap:RigidityKbar}` in `AlgebraicJacobian_Cotangent_GrpObj.tex` L6 + L59) **ABSORBED** via plan-agent direct edit this iter (2-character case-fix in pointer chapter; too cheap to dispatch a writer). HARD GATE on `Cotangent/GrpObj.lean` now CLEAR for the iter-136 prover dispatch. 3 informational items (Jacobian.tex:400 stale citation; Cohomology_StructureSheafModuleK.tex label-prefix asymmetry; Jacobian.tex C.2.d second-bullet prose thinness) deferred — iter-135 carry-overs, no blast radius. |
| `progress-critic` | iter136 | **UNCLEAR leaning CONVERGING** overall; 4 routes; 0 CHURNING / 0 STUCK | Route 1 (piece (i.a)): CONVERGING (closed iter-132, no regression). Routes 2 + 3: UNCLEAR (deferred-by-design). Route 4 (piece (i.b)): UNCLEAR leaning CONVERGING — only 2 iters substantive data; iter-135 honest-scaffold refactor was the corrective response to iter-134 must-fix, executed. Critic explicitly endorses **Step 3 only, NOT Step 2+3 bundled**. Iter-136 prover-lane scope adopted accordingly. Secondary correctives named preemptively if iter-136 returns PARTIAL: (a) `mathlib-analogist` on `PresheafOfModules.pullbackId`/`pullbackComp` usage; (b) `blueprint-writer` expansion on `RigidityKbar.tex § Step 3 proof`. |

## STRATEGY.md edits this iter

### Edit 1: Over-k qualitative-defense framing (CHALLENGE 1 absorption)

Per `strategy-critic-iter136` CHALLENGE 1, the over-k commitment's
qualitative defense was carrying procedural-reassurance framing on
ground (iii) "active revert option" — a *risk mitigation*, not a
*positive defense*. Edit at STRATEGY.md § "Over-k re-defense on
revised numbers":

- **(ii) Blueprint cleanliness**: retained, **honestly named as
  switching-cost-flavored** (reflects past investment in
  `RigidityKbar.tex` + the iter-128 → iter-132 build over `[Field k]`).
- **(iii) Active revert option**: **DEMOTED iter-136 from "defense
  ground" to "risk mitigation" classification**. The revert wiring
  (triggers (a')/b/c) is retained operationally as guardrail; it is
  no longer cited as positive evidence the over-k route IS right,
  only as bounded-downside framing.
- **(iv) Piece (i.a) tractability**: retained scope-narrow as
  *route-validation* evidence (the over-k construction is
  Lean-tractable for piece (i.a)), NOT *route-comparison* evidence
  (over-k vs over-`k̄`). Same proof would have worked over `k̄`;
  pieces (i.b)/(i.c)/(ii)/(iii) tractability remains empirically
  untested.
- **Net iter-136 framing**: over-k commitment carries on (ii)+(iv)
  with (iii) demoted; quantitative case is lower-bound zero;
  operationally correct but not strongly "the over-k route IS
  better" defended. If the next route-pivot trigger fires, revert
  without further deliberation.

### Edit 2: Piece-(ii) `Differential.ContainConstants` alignment (CHALLENGE 2 absorption)

Per `strategy-critic-iter136` CHALLENGE 2, the "ring-level half
aligns with Mathlib `Differential.ContainConstants`" framing
inherited from iter-127+ is loose: Mathlib's typeclass is keyed on
`Differential B` (derivation `B → B`), not on the Kähler form
`B → Ω_{B/A}` the scheme-level argument uses. Two paths under
evaluation:

- (a) install a `Differential` typeclass instance on chart algebras
  via a splitting of the universal derivation `B → Ω_{B/A}`;
- (b) pivot piece-(ii) to route through `KaehlerDifferential`
  exactness lemmas directly (`KaehlerDifferential.exact_mapBaseChange_map`
  family + a kernel-of-derivation argument; the strategy-critic
  Alternative 1 explicitly raised this).

**New sequencing-table row added (iter-139 or iter-140 dispatch)**:
mathlib-analogist on the alignment, MUST dispatch before iter-141+
piece-(ii) scaffolding so the bridge is pinned in Lean shape before
the prover lane fires. Entering iter-141+ with "morally aligned"
framing risks repeating the iter-134 placeholder-pattern mistake
(under-specified Lean shape spawning low-quality prover work).

The piece (ii) row itself updated to "alignment pinned iter-139 or
iter-140 per the new row above"; LOC + iter estimates unchanged
pending the analogist verdict.

### Edit 3: Mathlib gap inventory entry for piece-(ii) (CHALLENGE 2 follow-through)

Added explicit prose in the gap inventory entry for
`AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` PHANTOM (piece (ii))
documenting the loose-alignment issue, the two evaluation paths,
the iter-139/140 analogist consult schedule, and the must-dispatch-
before-iter-141+ guardrail.

## Plan-agent direct edits this iter (3)

1. **`blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` L6 + L59**:
   `\ref{chap:rigidity_kbar}` → `\ref{chap:RigidityKbar}` and
   `\cref{chap:rigidity_kbar}` → `\cref{chap:RigidityKbar}`. Two
   character-case typos in a per-Lean-file pointer chapter; blueprint
   `chap:RigidityKbar` label is CamelCase (verified at
   `RigidityKbar.tex:2`). Resolves the iter-136 blueprint-reviewer's
   single must-fix-this-iter; clears the per-file HARD GATE on
   `Cotangent/GrpObj.lean` for the iter-136 prover dispatch.

2. **STRATEGY.md § "Over-k re-defense on revised numbers"** —
   demote (iii) to risk mitigation; honestly name (ii) as
   switching-cost-flavored; net framing tightening per
   `strategy-critic-iter136` CHALLENGE 1.

3. **STRATEGY.md sequencing table + gap inventory** — new iter-139
   or iter-140 analogist row for piece-(ii) `Differential.ContainConstants`
   alignment + corresponding prose in the gap inventory entry.

## Rebuttal to strategy-critic minor alternative (partial-result shipping)

The strategy-critic-iter136 minor-to-moderate alternative proposes
shipping the 9 protected declarations with `nonempty_jacobianWitness`
proved on `genus C = 0` only, with a single inline `sorry` for the
positive-genus case — a milestone-shipping decision the strategy
treats as foreclosed by the iter-126 user hint. The critic notes
that the strategy's own § "Soundness rules ▸ User-hint citation
discipline" flags the hint as M3-user-escalation-scoped and
**suggests this milestone-shipping decision warrants its own TO_USER
consultation**.

**Iter-136 plan-agent response**: ACKNOWLEDGED but NOT escalated
this iter. Reasons:

- The iter-126 user hint as cited verbatim ("do the work, no axioms;
  ~6500–9000 LOC may not be that much for an AI") was issued in the
  specific context of the M3 user-escalation TO_USER banner. The
  strategy correctly flags this is M3-scoped, not blanket. **But**:
  the hint's reasoning ("do the work, no axioms") generalises
  naturally to "ship the work fully formalized" and the user has
  consistently endorsed do-the-work directions across iter-121+.
- The cost differential is real but currently unactionable: M2.b
  body close (the genus-0 arm) is scheduled iter-153–156 +
  iter-157+ M2 closure; M3 body close is multi-month away
  (100+ iter / 10000+ LOC). A milestone-shipping decision is
  worth surfacing to the user **once M2 closure is in sight**
  (i.e. iter-151+) and the partial-shipping question is concrete
  with measured iter-distance to full close. Surfacing this iter
  (iter-136 close, M2 closure 15+ iter away) is premature —
  the user has nothing concrete to react to.
- **Recorded as a future TO_USER candidate**: dispatch the
  consultation iter-151+ when M2.b body closure is in flight, with
  concrete iter-distance estimates to both M2-only-shipping AND
  full closure. The iter-151+ plan agent receives this as part of
  the carry-over.

**Implication**: no STRATEGY.md edit this iter. The strategy's
existing § "Soundness rules ▸ User-hint citation discipline"
already documents the citation-scope rule the critic invokes;
adding a future-TO_USER-candidate note inline would clutter
without changing iter-136 behavior. The carry-over is recorded
here in the plan sidecar; iter-151+ plan agent reads it via the
recent-iters context-injection mechanism.

## Iter-135 carry-forward items (status check)

- **Iter-135 progress-critic PASS criterion** (≥ 2 of 3 placeholders
  to non-`Nonempty (X ≅ X)` types): **already fully satisfied**
  iter-135 close (3 of 3 typed against intended sheaf-level RHS).
- **Iter-135 next-tier PASS criterion** (iter-136 prover round
  substantively closes ≥ 1 of the 3 honest-scaffold bodies): testable
  end of iter-136 prover phase.
- **META-PATTERN TRIPWIRE** (iter-132 non-promise: no 4th body
  reshape on `cotangentSpaceAtIdentity`): HOLDS — iter-136 prover
  lane does not touch piece-(i.a) declarations.
- **Trigger (a')/(c) LOC arm** (`strategy-critic-iter134`
  CHALLENGE 1; > 600 LOC of (i.b)-side build without converging):
  iter-135 added 0 LOC (signature swap only). Iter-136 prover lane
  budgeted ~30–80 LOC for Step 3 alone; well within envelope.
- **Iter-135 deferred docstring-rot items** (4 "line N below"
  references inside `cotangentSpaceAtIdentity` docstring at L61/L107/
  L146/L155/L160; ~5 sites total per iter-135
  lean-vs-blueprint-checker MED-C): not iter-136 priority; will
  drift on next non-trivial file edit; iter-137+ docstring refactor
  if convenient.
- **Stale `\leanok` markers** (iter-134 placeholder bodies; iter-135
  MED-A): sync_leanok will auto-clear post iter-136 prover phase.

## Iter-136 prover-lane scope (single target)

**File**: `AlgebraicJacobian/Cotangent/GrpObj.lean`

**Target**: `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section`
at L496 (piece (i.b) Step 3 honest scaffold; intended sheaf-level
RHS already pinned by iter-135 refactor + iter-135 mathlib-analogist
verdict).

**LOC envelope**: ~30–80 LOC (per iter-133 mathlib-analogist Step 3
estimate + blueprint § Step 3 proof).

**Closure path** (per `RigidityKbar.tex` § Step 3 +
`analogies/mulright-globalises-cotangent.md`): The categorical
identity `pr_2 ∘ s = η_G ∘ π_G` in `Over (Spec k)` (where
`s = ⟨𝟙_G, η_G⟩` and `π_G : G ⟶ Spec k` is the structure map) holds
by direct evaluation. Apply `PresheafOfModules.pullbackComp`
(`Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback`; for
composable morphisms `f, g`, `(f ∘ g)^* ≅ g^* ∘ f^*` as functors on
`PresheafOfModules`) to both sides of the composition identity,
applied to the presheaf-of-modules
`Ω_{G/k} = relativeDifferentialsPresheaf G.hom`, to yield the
displayed iso `s^*(pr_2^* Ω_{G/k}) ≅ π_G^*(η_G^* Ω_{G/k})`.

**Why this target is iter-136-appropriate**:

- It is the **cheapest substantive piece** of the 3 honest scaffolds
  (~30–80 LOC vs Step 2's ~150–300 LOC vs Main's compose-Steps-2+3).
- Step 3 closure is a **convergence probe** for Route 4: success
  resolves the progress-critic-iter136 UNCLEAR verdict to
  CONVERGING in iter-137 and unlocks Step 2 (~150–300 LOC) as the
  iter-137 target.
- The Mathlib APIs needed (`PresheafOfModules.pullbackComp`,
  `PresheafOfModules.pullbackId`) are the load-bearing iter-135
  mathlib-analogist verified idiom; the compatibility morphisms via
  `Scheme.Hom.toRingCatSheafHom` are already documented at
  `analogies/phi-compatibility-morphisms.md`.

**Explicit NON-bundling**: Step 2 (L468) and Main (L560) are NOT
iter-136 targets. The progress-critic explicitly endorsed Step 3
only, citing the risk of re-introducing the iter-134 must-fix
pattern under time pressure if Step 2+3 were bundled. If Step 3
closes within iter-136, iter-137 picks up Step 2; if Step 3 stalls,
secondary correctives (mathlib-analogist on `pullbackId`/`pullbackComp`
usage; blueprint-writer expansion on Step 3 proof sketch) fire
before iter-137 prover lane.

## Predictions for iter-136 prover phase

| Outcome | Iter-137 plan-phase action |
|---|---|
| Step 3 body substantively closed (sorry → 0 on L496) | Route 4 flips UNCLEAR → CONVERGING per progress-critic-iter136 next-tier PASS. Dispatch iter-137 prover lane on Step 2 (L468, ~150–300 LOC). |
| Step 3 returns PARTIAL (new helper + sorry remaining at L496) | Dispatch mathlib-analogist on `PresheafOfModules.pullbackComp`/`pullbackId` usage before iter-137 prover lane; or blueprint-writer to expand Step 3 proof sketch. Do NOT re-dispatch with same scope. |
| Step 3 returns INCOMPLETE or adds new declarations that don't match docstring intent | Route 4 flips UNCLEAR → CHURNING per progress-critic-iter136 FAIL criterion. Must-fix-this-iter under iter-137 plan agent. Possible trigger (a') firing if the pattern is value-level-stalk-RHS-shaped. |

## Per-file status entering iter-136 prover phase

| File | Sorries | Iter-136 prover scope |
|---|---|---|
| `AlgebraicJacobian/Cotangent/GrpObj.lean` | 3 (L468 + L496 + L560) | **L496 only** (Step 3) |
| `AlgebraicJacobian/Jacobian.lean` | 2 (L197 `genusZeroWitness` + L223 `positiveGenusWitness`) | off-limits (gated on M2.a body iter-151+ / M3 user-escalation) |
| `AlgebraicJacobian/RigidityKbar.lean` | 1 (L87 `rigidity_over_kbar`) | off-limits (gated on M2.body-pile) |

Total project sorry count entering iter-136: **6**. Expected at
iter-136 prover-phase close: **5** (Step 3 closes) or **6** (no
substantive closure; PARTIAL or stable).

## Fallback if no user response

(No user escalation this iter; the partial-result shipping minor
alternative is recorded as a future TO_USER candidate for iter-151+
when M2 closure is concrete, not surfaced this iter. No fallback
section needed; `USER_HINTS.md` is empty and the plan agent
proceeds normally.)
