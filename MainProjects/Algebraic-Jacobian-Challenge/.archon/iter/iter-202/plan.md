# Iter-202 plan-agent run

## Headline outcome

**The "process iter-201 outcomes (78 → 78 sorries; 1 of 3 HARD BARs MET
— WD Sub-build 2 closed axiom-clean + PUSH-BEYOND partial with 6 new
decls including `Ring.ordFrac_ringEquiv` anchor + `Scheme.Opens.functionFieldIso`;
AB Path B matrix-collapse substrate landed axiom-clean (4 helpers) but
`_succ_pd` body still NOT CLOSED; COE Step A landed 3 axiom-clean
auxiliary substrate decls but Step A1 BLOCKED on what the prover
classified as 3 Mathlib gaps) + process iter-201 review's CRITICAL
lean-auditor cross-file finding (2 of 3 'Mathlib gaps' for Lane COE
Step A1 are actually project-local private witnesses in
AuslanderBuchsbaum.lean — `isDomain_of_regularLocal` L2657 + 
`regularLocal_quotient_isRegularLocal_of_notMemSq` L2293, both
axiom-clean; only `IsRegularLocalRing.localization` (Stacks 00OF)
remains genuinely Mathlib-absent) + plan-agent direct blueprint edits
for 3 prover-touched chapters (WD adds new `def:functionFieldIso`
block pinning iter-201 public `Scheme.Opens.functionFieldIso` per
wd-iter201 MAJOR + updates Sub-build 2 description to past tense +
Sub-build 3 to reference `def:functionFieldIso`; AB updates matrix-
collapse paragraph to past tense + records the 4 axiom-clean iter-201
helpers + adds iter-202 status note enumerating Nat-induction
restructuring recipe + AB-promotions commitment; COE corrects
`IsRegularLocalRing.localization` "EXISTS" → "MISSING" per
coe-iter201 SOON + reframes Step A1 from "Mathlib gap ~30-50 LOC" to
"cross-file imports from AB project-local witnesses ~80-150 LOC
including promotions" + describes iter-201 A2 done-vs-open split with
3 substrate decls listed) + STRATEGY.md row refreshes (A.4.b row:
Iters-left ~3-6 → ~2-4, LOC remaining ~130-200 → ~80-120, OBVIATED
markers consolidated, body-closure recipe stated; A.4.c.0 row:
Iters-left ~3-6 → ~4-7, LOC remaining ~200-350 → ~180-320,
velocity-realized refreshed ~35/it, Step A1 reframed as cross-file
import) + 4 Route A prover lanes scoped (Lane AB Path B body close +
2 helper promotions; Lane COE Step B scheme-to-algebra bridges
independent of Step A1; Lane WD Sub-build 3 h_compat discharge;
Lane TS file-skeleton scaffold of `Picard/TensorObjSubstrate.lean`) +
2 plan-phase subagent dispatches (progress-critic `route202`,
blueprint-reviewer `iter202`; strategy-critic skipped with rationale
— STRATEGY.md edits are row-refresh only, prior verdict SOUND with
addressed findings) + iter-201 task_results archived to
`task_results/archive/iter-201/`" iter.**

iter-201 returned `lake build` GREEN with **78 sorries / 0 axioms**
(21st consecutive zero-axiom build streak).

## User hints

USER hint this iter requested a 1-line plastex fix at
`blueprint/src/chapters/RiemannRoch_OCofP.tex` L657
(`\(\lean\)` → `\texttt{\textbackslash lean}`). Verified inline: the
fix already landed iter-198 (the line is now at L657 in the iter-201
file, reading `\texttt{\textbackslash lean}-pin`). No-op this iter;
USER_HINTS.md will be auto-cleared by the loop on successful plan
phase.

The 2026-05-28 standing directives (ROUTE C PAUSE permanent; Route A
bottom-up; reference-driven mathlib-build) remain the active framing
for every prover lane.

## Plan-phase actions (in chronological order)

### 1. Blueprint edits LANDED directly by plan agent

**WeilDivisor chapter** (`blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`):
- Added new `\begin{definition}[Function-field isomorphism along an
  open immersion]\label{def:functionFieldIso}` block (after L374) with
  `\lean{AlgebraicGeometry.Scheme.Opens.functionFieldIso}` pin +
  `\uses{lem:primeDivisor_stalkIso}` + 1-paragraph proof sketch
  (compose `Scheme.Opens.stalkIso` at generic point with `stalkCongr`
  along `genericPoint_eq_of_isOpenImmersion`). Closes wd-iter201
  MAJOR finding (the only iter-201 public decl without a `\lean{...}`
  pin).
- Updated Sub-build 2 description from "iter-201 target, ~30-50 LOC"
  to "CLOSED iter-201, 6 axiom-clean decls L247--L519" with full
  enumeration of the 4 private `Ring.*` helpers + the new
  public `Scheme.Opens.functionFieldIso` + the private packaging
  `Scheme.PrimeDivisor.ordFrac_stalkIso_naturality`, plus the recipe
  for the `ordFrac_ringEquiv` anchor proof (case-split on `x = 0`,
  `IsLocalization.surj`, `mem_nonZeroDivisors_of_ne_zero`,
  `Ring.ordFrac_eq_div`).
- Updated Sub-build 3 description to reference `def:functionFieldIso`
  and describe the morphism-level naturality of `stalkSpecializes`
  required to discharge `h_compat`, with explicit Mathlib API path
  (`PresheafedSpace.stalkMap.stalkSpecializes_stalkMap_assoc`).

**AuslanderBuchsbaum chapter** (`blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`):
- Rewrote matrix-collapse helper paragraph (formerly future-tense
  recipe at L931-950) to past tense: "CLOSED iter-201, 4 axiom-clean
  private decls at AuslanderBuchsbaum.lean L1418-L1517". Enumerated
  the 4 helpers (`elemMap`, `elemMap_apply`,
  `linearMap_finFunR_matrix_decomp`, the closure helper itself).
  Corrected the API path note: realised API used
  `ModuleCat.hom_sum`/`Ext.mk₀_sum`/`Ext.comp_sum` +
  `ModuleCat.hom_smul`/`Ext.mk₀_smul`/`Ext.comp_smul` (not
  `Ext.bilinearCompOfLinear` as the analogist had projected; the
  mathematical content is identical). Closes ab-iter201 SOON finding.
- Added new `\paragraph{Iter-201 status update: matrix-collapse
  substrate landed; closure body deferred to iter-202.}` block at
  end of Path B section: enumerates the iter-202 recipe
  (Nat-induction restructuring, base case via matrix-collapse + LES
  ~50-80 LOC, inductive step via `depth_of_short_exact` parts (2)+(3)
  alone ~30-50 LOC without matrix-collapse per iter-201 prover
  discovery, total ~80-120 LOC) + iter-202 AB-promotions commitment
  (drop `private` from `_succ_pd`, `isDomain_of_regularLocal`,
  `regularLocal_quotient_isRegularLocal_of_notMemSq` for cross-file
  consumption by Lane COE Step A1).

**CodimOneExtension chapter** (`blueprint/src/chapters/Albanese_CodimOneExtension.tex`):
- Corrected the Mathlib API state bullet on
  `IsRegularLocalRing.localization_isRegularLocalRing` (Stacks 00OF)
  from "EXISTS" to "MISSING at b80f227" with the iter-201 prover-scout
  citation (grep of `Mathlib/RingTheory/RegularLocalRing/`). Closes
  coe-iter201 SOON finding.
- Reframed Step A1 ("Matsumura helper") with a new `\textbf{Mathlib
  API state (iter-201 prover scout + iter-201 \texttt{lean-auditor
  iter201} cross-file finding).}` sub-paragraph: enumerates the 2
  project-local private witnesses in AuslanderBuchsbaum.lean
  (`isDomain_of_regularLocal` L2657 = Stacks 00NQ forward direction
  closed iter-186 modulo `notMem_minimalPrimes_of_regularLocal_succ`
  itself closed iter-201; `regularLocal_quotient_isRegularLocal_of_notMemSq`
  L2293 = `A / (f₁) → IsRegularLocalRing` preservation) +
  iter-202 Lane AB promotion path. Revised A1 LOC estimate from
  ~30-50 to ~80-150 LOC (including the cross-file imports). Closes
  coe-iter201 SOON finding (Step A1 Mathlib-gap classification flip).
- Reframed Step A2 with explicit `\textbf{Iter-201 landed substrate.}`
  enumerating the 2 iter-201 axiom-clean private decls
  (`submersivePresentation_relation_cotangent_mk_linearIndependent`,
  `..._localized`) + `\textbf{Iter-202+ A2 residual.}` naming the
  conormal-localisation iso for `IsLocalization.AtPrime` as the
  remaining substantive gap (~50-100 LOC). Closes coe-iter201 SOON
  finding (A2 done-vs-open split).
- Added `\textbf{Iter-201 landed substrate.}` to Step A3 mentioning
  `ringKrullDim_quotient_localization_MvPolynomial_of_regular`
  (L924) as the Steps-1+2+3 composite consumer for the polynomial-
  ring setting.

### 2. STRATEGY.md edits LANDED (2 substantive row refreshes)

- **A.4.b row**: Iters-left `~3-6` → `~2-4`; LOC remaining `~130-200`
  → `~80-120`; Key Mathlib needs simplified to "Body closure via
  `induction k generalizing M`"; Risks rephrased to name the
  Nat-induction restructuring + LES bookkeeping as iter-202 work +
  the matrix-collapse substrate as landed + the iter-202 cross-file
  promotions commitment.
- **A.4.c.0 row**: Iters-left `~3-6` → `~4-7`; LOC remaining
  `~200-350` → `~180-320`; velocity-realized refreshed `~55/it` →
  `~35/it` (iter-201 landing was 3 substrate decls totalling ~95
  LOC, narrower than the iter-200 ~180-LOC capstone landings); Key
  Mathlib needs rephrased: "Step A1 (Matsumura) cross-file import
  of project-local Stacks 00NQ + RLR-preservation witnesses from
  `AuslanderBuchsbaum.lean` (per iter-201 lean-auditor cross-file
  finding); A2 conormal-localisation iso for `AtPrime`;
  scheme-to-algebra bridge"; Risks rephrased to name the
  prover-scout misclassification flip + the iter-202 parallel-
  dispatch coordination (Lane AB helper promotions + Lane COE
  Step B bridges in parallel; Lane COE Step A1 closure waits for
  promotions iter-203+).

### 3. Subagent dispatches (2 plan-phase subagents in parallel)

- `progress-critic route202` — fresh-context audit of 3 active lanes
  (Lane WD A.4.a, Lane AB A.4.b, Lane COE A.4.c.0); signals extracted
  from last 5 iters (iter-197--201). Strategy `Iters left` snapshot
  refreshed iter-202.
- `blueprint-reviewer iter202` — full blueprint audit post-3-chapter
  edits this iter; HARD GATE re-verification for the 3 prover-touched
  chapters (WD, AB, COE) + the new `def:functionFieldIso` block.

### 4. Subagent skips

- **strategy-critic**: SKIP. Rationale: STRATEGY.md edits this iter
  are 2 velocity-refresh row updates (A.4.b, A.4.c.0) per the
  velocity-mismatch consistency check — these are exactly the kind of
  in-table refresh the canonical structure rule licenses without a
  full strategy re-evaluation. Prior strategy-critic verdict (iter-201
  `route201`) was SOUND with 4 CHALLENGE-level findings ALL addressed.
  No new live CHALLENGE this iter; no route swap, no phase split, no
  new Mathlib gap, no resolved/new strategic question. Skip condition
  met per descriptor: edits are not substantive enough to warrant a
  fresh-context audit.

### 5. iter-201 task results processed

- `task_results/AlgebraicJacobian_Albanese_AuslanderBuchsbaum.lean.md`
  → archive (matrix-collapse substrate landed; body deferred).
- `task_results/AlgebraicJacobian_Albanese_CodimOneExtension.lean.md`
  → archive (3 substrate decls; Step A1 newly-confirmed gated, but
  the lean-auditor cross-file finding inverted the gate).
- `task_results/AlgebraicJacobian_RiemannRoch_WeilDivisor.lean.md`
  → archive (Sub-build 2 HARD BAR MET + PUSH-BEYOND partial).
- `task_results/lean-auditor-iter201.md` → archive (1 must-fix
  carry-over on RPF L266-269 — deferred per Held lane rationale;
  2 major stale labels in AB; 5 minor).
- `task_results/lean-vs-blueprint-checker-{wd,ab,coe}-iter201.md`
  → archive (all 3 returned with `soon`/`minor` findings; the WD
  and AB MAJOR/SOON findings are addressed by this iter's blueprint
  edits; the COE Step-A1 reframe accomplished).

### 6. PROGRESS.md rewritten for iter-202

- Iter-201 section archived under "Iter-202" header.
- Sorry projection refreshed for iter-202: best 78 → ~72-75, realistic
  78 → ~76-77, worst 78 → ~78.
- Held lanes rationale extended with iter-202 explicit notes on:
  - Lane RPF still HELD; the iter-201 lean-auditor must-fix on L266-269
    is the `addCommGroup` `-- TODO + exact sorry` pattern, deferred per
    the standing Held lane rationale (Lane TS this iter unblocks
    iter-203+ TensorObjSubstrate body fill which then unblocks Lane
    RPF body iter-204+).
  - Lane FGA still HELD (iter-205+ post-Lane RPF body fill).
  - Lane T32 still HELD (iter-203+ post-Lane COE Stage 6.B closure).
  - Lane RCI still HELD (Route C PAUSED).

## Subagent results awaited (parallel dispatch)

- `progress-critic-route202.md`
- `blueprint-reviewer-iter202.md`

## Decision made

The **iter-202 Lane COE re-dispatch decision** is the binding choice
this iter. Two readings of the iter-201 review:

- **(option α — DEFERRED)**: Per review L187-189, "Do NOT re-dispatch
  Lane COE Step A1 prover before the analogist verdict" — defer Lane
  COE entirely to iter-203 after a `mathlib-analogist` re-scout.
- **(option β — RE-DISPATCH WITH SCOPE PIVOT, CHOSEN)**: Per review
  L230-239 (lean-auditor cross-file finding) and L326-331 (CRIT-2
  resolution), re-dispatch Lane COE this iter with explicit cross-file
  import directives — the 2 of 3 "Mathlib gaps" are project-local
  private witnesses; only the dispatch shape changes (cross-file
  import, not Mathlib build).

**I chose option β with a coordination split**: Lane COE this iter
does Step B scheme-to-algebra bridges (~30-50 LOC of substrate
independent of Step A1); Lane AB this iter handles its own Path B
body closure AND additionally promotes 2 helpers from `private` to
public. Lane COE Step A1 itself waits until iter-203, when the
AB-promoted helpers are in the file state visible to the COE prover
session. The reasoning:

- A truly parallel Lane COE Step A1 dispatch this iter would have the
  prover writing code against the cross-file public names *while* the
  AB lane is still mid-session removing `private` — `lean_verify`
  would fail in the COE session (it sees iter-start file state), so
  the prover would burn budget on a guaranteed-incomplete attempt.
- Step B (extracting `SubmersivePresentation` from
  `IsStandardSmoothOfRelativeDimension`, identifying `z`'s maximal
  ideal, the `Γ(Spec(.of kbar), U) = kbar` definitional bridge,
  closing `IsRegularLocalRing (stalk z)` via
  `IsRegularLocalRing.iff_finrank_cotangentSpace` + iter-199 Stage 6.B
  substrate) is structurally orthogonal to Step A1 (it lives on the
  scheme-side, not the algebra-side), so iter-202 Lane COE substrate
  work is non-trivial even without Step A1.
- iter-203 then runs Lane COE Step A1 in a single-session lane with
  the AB-promoted public names visible at session start, hitting the
  recipe in the originally-projected ~30-50 LOC.

Cheapest signal that would reverse this: if iter-202 review's
progress-critic flags Lane COE as STUCK with "substrate-only iter
without Step A1 attempt as a pacing failure", I reconsider option α
or a single-iter-late re-dispatch under different prover-mode
discipline.

## Tool substitutions

None this iter. No tools requested that couldn't run.

## Deferred chapter records (per `blueprint-reviewer iter202` partial verdicts)

`blueprint-reviewer iter202` returned `partial` for 10 chapters and
requires per-chapter deferral records. All deferrals are already
reflected in PROGRESS.md's `## Off-limits / deferred iter-202`
section + `## Held lanes` section, but recorded here per descriptor
rule:

- `Albanese_AlbaneseUP.tex` — DEFERRED iter-202. Reason: priority-5
  gating on Route C re-engagement + A.4.d. No blueprint writer
  dispatch this iter; chapter is adequate for the priority it
  carries.
- `AbelianVarietyRigidity.tex` — DEFERRED iter-202. Reason: PAUSED
  per USER 2026-05-28 ROUTE C PAUSE permanent.
- `RigidityKbar.tex` — DEFERRED iter-202. Reason: PAUSED per USER
  2026-05-28 ROUTE C PAUSE permanent.
- `RiemannRoch_H1Vanishing.tex` — DEFERRED iter-202. PAUSED Route C.
- `RiemannRoch_RRFormula.tex` — DEFERRED iter-202. PAUSED Route C.
- `RiemannRoch_OCofP.tex` — DEFERRED iter-202. PAUSED Route C.
- `RiemannRoch_OcOfD.tex` — DEFERRED iter-202. PAUSED Route C.
- `RiemannRoch_RationalCurveIso.tex` — DEFERRED iter-202. PAUSED
  Route C.
- `Picard_RelPicFunctor.tex` — DEFERRED iter-202. Gated on
  A.1.c.SubT body fill iter-203+ (TS scaffold this iter is the first
  step in the unblock chain).
- `Picard_FGAPicRepresentability.tex` — DEFERRED iter-202. Sorries
  5-7 Route-C-blocked; Sorries 1-4 sibling-gated on A.1.c + A.2.b.
  Re-engages iter-205+ post-Lane RPF body fill.

## Plan-phase correctives applied (iter-202)

After both subagent reports returned, the plan agent applied the
following correctives in-iter:

### From `progress-critic route202` (3 STUCK + UNCLEAR + 4 must-fix)

- **WD HARD BAR reclassification**: PROGRESS.md L154-159 +
  `iter/iter-202/objectives.md` updated so HARD BAR for Lane
  WD-A4a-Sub-build-3 requires BOTH step (1)
  `functionFieldIso_compat` AND step (2)
  `order_eq_order_restrict` axiom-clean — step (1) alone is no
  longer a HARD BAR landing (the 5-iter substrate-only PARTIAL
  pattern is the must-fix corrective).
- **AB user-escalation pre-commitment**: PROGRESS.md `## Active
  monitors` extended with a new bullet making the iter-203
  escalation trigger explicit: if iter-202 Lane AB body closure
  returns PARTIAL/INCOMPLETE on `_succ_pd` body, immediate user
  escalation is mandatory before iter-203 AB dispatch. The review
  agent will file the actual TO_USER note if the trigger fires.
- **STRATEGY.md WD + COE rows** updated to expose ELAPSED totals
  alongside refreshed forward windows:
  - A.4.a: `~4-6 (elapsed 14 of original 3-6; honest total ~18-20)`.
  - A.4.b: `~2-4 (elapsed 16 of original 3-6; honest total ~18-20)`.
  - A.4.c.0: `~4-7 (elapsed 24 of original 3-6; honest total ~28-31,
    ~4× over original upper bound)`.
- **COE blueprint Step A1 iter-203 recipe fully specified**:
  `blueprint/src/chapters/Albanese_CodimOneExtension.tex` extended
  with a complete `\textbf{Iter-203 Lane COE Step A1 prover recipe
  (full specification per iter-202 \texttt{progress-critic route202}
  must-fix).}` block — imports, target declaration signature, proof
  structure (7-step induction recipe), linear-independence transfer
  note, target sorry-line clarification, verification step.

### From `blueprint-reviewer iter202` (4 PASSES + 10 partial deferrals)

- All 4 HARD GATE lanes PASS (WD, AB, COE, TS).
- 10 partial-chapter deferrals recorded (see `## Deferred chapter
  records` section above).
- 0 strategy-modifying findings; 0 unstarted-phase proposals.

### Open progress-critic note (not actionable this iter)

Progress-critic's "Informational" section flags that if iter-202
ends with 0 net sorry movement across all 4 lanes (e.g. Lane AB
body close fails AND Lane WD step (2) fails), all three primary
routes (WD, AB, COE) MUST trigger user escalation immediately in
iter-203. This is a conditional pre-commitment surfaced for the
iter-202 review agent and iter-203 plan agent. The Lane TS scaffold
adding ~4 typed-sorry stubs is not a sorry-elimination signal and
should not be counted in this assessment.

## Per-lane outline (full directives in `objectives.md`)

1. **Lane WD-A4a-Sub-build-3** (mathlib-build): discharge `h_compat`
   hypothesis of `Scheme.PrimeDivisor.ordFrac_stalkIso_naturality`
   from `Scheme.Opens.functionFieldIso` + `stalkSpecializes`
   naturality. HARD BAR: discharge h_compat axiom-clean. PUSH-BEYOND:
   begin terminal closure of L535 non-zero branch if signature
   strengthening to `[IsNoetherian X]` is safe to introduce.

2. **Lane AB-Path-B-Close** (mathlib-build): close
   `auslander_buchsbaum_formula_succ_pd` body via Nat-induction
   restructuring + remove `private` from 3 declarations
   (`_succ_pd`, `isDomain_of_regularLocal`,
   `regularLocal_quotient_isRegularLocal_of_notMemSq`).
   HARD BAR: body closure axiom-clean + 3 private removals.
   PUSH-BEYOND: attempt the main `auslander_buchsbaum_formula`
   inductive step axiom-clean.

3. **Lane COE-Step-B-Bridges** (mathlib-build): build the
   scheme-to-algebra bridges for L1061 closure (extracting
   `SubmersivePresentation`, identifying `z`'s maximal ideal,
   `Γ(Spec(.of kbar), U) = kbar` bridge, regular-stalk close via
   `IsRegularLocalRing.iff_finrank_cotangentSpace` + iter-199 Stage
   6.B substrate). HARD BAR: at least 2 of the 4 sub-bridges
   axiom-clean. PUSH-BEYOND: 3+ sub-bridges + a sketch of the L1061
   inline assembly skeleton that consumes them (with Step A1 left
   as a typed sorry awaiting iter-203 AB-promotion-dependent close).

4. **Lane TS-Scaffold** (file-skeleton, prove mode): scaffold
   `Picard/TensorObjSubstrate.lean` with declarations for
   `def:scheme_modules_tensorobj`,
   `lem:scheme_modules_tensorobj_functoriality`,
   `thm:scheme_modules_monoidal`,
   `thm:rel_pic_addcommgroup_via_tensorobj` from the iter-200
   blueprint chapter; leave bodies as `sorry`; add the import +
   namespace boilerplate; do NOT attempt proofs yet. HARD BAR: file
   compiles GREEN with typed sorries; +1 import in
   `AlgebraicJacobian.lean`. PUSH-BEYOND: scaffold the 5 supporting
   helper lemma declarations from `\subsec:tensorobj_supporting`
   too.

## Iter-202 projection bands

- **Best case** (Lane WD closes L535 non-zero branch − 1; Lane AB
  closes `_succ_pd` body + main `auslander_buchsbaum_formula` − 2 +
  AB promotions land cleanly; Lane COE Step B 4-of-4 bridges + L1061
  inline skeleton enough to defer only Step A1 closure to iter-203;
  Lane TS scaffold lands GREEN with 4+ stubs):
  78 → **~72-75** (−3 to −6).
- **Realistic** (Lane WD Sub-build 3 substrate axiom-clean,
  terminal closure deferred; Lane AB body closes via Nat-induction;
  Lane COE Step B 2-of-4 bridges; Lane TS scaffold lands GREEN):
  78 → **~76-77** (−1 to −2).
- **Worst case** (all 4 lanes substrate-only; AB body closure
  blocked by unforeseen Nat-induction friction; Lane COE Step B
  finds further Mathlib API holes): 78 → **~78** (0).

**Target: realistic-band** — Lane AB Path B is structurally
unblocked (matrix-collapse + analogist recipe both axiom-clean);
Lane WD Sub-build 3 is a clean follow-on with iter-201 prover's
explicit Mathlib API map; Lane COE Step B is orthogonal substrate;
Lane TS is a textbook file-skeleton scaffold against a complete
blueprint chapter.
