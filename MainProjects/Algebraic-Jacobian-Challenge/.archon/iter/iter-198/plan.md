# Iter-198 plan-agent run

## Headline outcome

**The "process iter-197 outcomes (84 → 83 sorries, −1, THREE HARD
CLOSURES, 17-consecutive-zero-axiom-build streak) + APPLY USER
2026-05-28 STANDING DIRECTIVE: ROUTE C PAUSE (permanent) + Route A
bottom-up execution + reference-driven proofs (mathlib-build for
all Route A) + rewrite STRATEGY.md to canonical skeleton reflecting
the route shift + apply one-shot blueprint plastex fix on
OCofP.tex L657 (`\(\lean\)` → `\texttt{\textbackslash lean}`) + 3
critic dispatches (strategy-critic, progress-critic, blueprint-
reviewer) + 5 Route A prover lanes scoped per priority-1/2/3 with
explicit reference citations + carrier-soundness probe verdict
(iter-198 abort criterion)" iter.**

iter-197 returned `lake build` GREEN with **83 sorries / 0 axioms**.
Net trajectory 84 → 83 (−1; THREE HARD CLOSURES). The user delivered
a major route-shift standing directive freezing the genus-0 / Route C
arm and re-prioritizing Route A bottom-up.

## User hints (iter-198 standing directives)

Three persistent standing directives now override any conflicting
historical guidance:

1. **ROUTE C PAUSE (permanent until further notice)**: no prover
   lane on H1Vanishing, RRFormula, OCofP, OcOfD, RationalCurveIso,
   BareScheme, GmScaling, RigidityKbar, AbelianVarietyRigidity, or
   any RR.* lane. Lane RCI remains HELD. The genus-0 arm is held in
   iter-197 closure state.
2. **ROUTE A BOTTOM-UP EXECUTION**: Route A strictly bottom-up from
   Mathlib roots. Priority order:
   - (1) ungated roots in parallel — RelativeSpec (A.1.a; complete),
     AuslanderBuchsbaum (A.4.b), WeilDivisor A.4.a material.
   - (2) RelPicFunctor (A.1.c) and CodimOneExtension (A.4.c.0) once
     their roots close.
   - (3) FGAPicRepresentability (A.2.c) and Thm32 (A.4.c.1).
   - (4) deeper gated layers only after predecessors closed.
   NEVER assign a prover lane to a gated target before its
   dependency roots are closed. IdentityComponent (excised),
   QuotScheme, FlatteningStratification are low-priority scaffolding;
   do not touch until critical path forces it.
3. **REFERENCE-DRIVEN PROOFS**: every prover directive must cite the
   precise theorem/proposition/tag number from Kleiman, Nitsure,
   Milne, Mumford, Hartshorne, Stacks, Matsumura, or Atiyah–Macdonald.
   If a proof step cannot be directly traced to a reference, find the
   reference before dispatch. Default prover mode for Route A:
   `mathlib-build`.

One-shot hint: FIX BLUEPRINT PLASTEX BUG on `RiemannRoch_OCofP.tex`
L657 (`\(\lean\)-pin` → `\texttt{\textbackslash lean}-pin`). The
math-mode wrapping of `\lean` causes plastex to treat it as a math
object and crash with 'math object has no attribute strip'. **APPLIED**
this iter.

## Plan-phase actions landed (in chronological order)

1. **Blueprint plastex fix LANDED** (`RiemannRoch_OCofP.tex` L655) —
   one-line edit per user hint.
2. **Blueprint-doctor empty-`\uses{}` finding investigated**: the
   iter-197 doctor flagged
   `AbelianVarietyRigidity.tex` for an empty `\uses{...}` argument
   but the current file has NONE under the doctor's exact regex
   (`\\uses\s*\{\s*([^{}]*?)\s*\}`). The iter-197 review-phase
   blueprint-writer dispatches cleared it before the post-iter commit.
   No action needed.
3. **STRATEGY.md REWRITTEN** to reflect Route C PAUSE + Route A
   bottom-up framing. Canonical skeleton (Goal / Phases / Routes /
   Open questions / Mathlib gaps); 230 lines including phase table;
   Route C marked PAUSED with explicit file list off-limits.
4. **task_pending.md REWRITTEN**: re-grouped per Route A active /
   Route C PAUSED / final-assembly framing. Sorry counts refreshed
   per direct file inspection (some entries were stale —
   `RelativeSpec.lean` shows 0 sorries despite prior 2-sorry claim).
5. **3 plan-phase critic dispatches LAUNCHED** in parallel
   (strategy-critic `route198`, progress-critic `route198`,
   blueprint-reviewer `iter198`). All write to `task_results/`;
   results pending at the time of this writing.

## Subagent dispatches (plan-phase)

| Subagent | Slug | Status |
|---|---|---|
| strategy-critic | `route198` | RETURNED — verdict CHALLENGE; 6 must-fix items addressed below |
| progress-critic | `route198` | RETURNED — 3 CHURNING + 1 STUCK + 1 UNCLEAR; must-fixes addressed below |
| blueprint-reviewer | `iter198` | RETURNED — RPF HARD GATE DEFER + 3 unstarted-phase proposals; actions below |
| blueprint-writer | `coe-stage6-expansion` | RETURNED — added 3 sub-lemmas (6.A/6.B/6.C) + Mathlib audit + cascade |
| blueprint-writer | `fga-sorry-order` | RETURNED — added §"Sorry-by-sorry closure order" with rank-1/2/3 partition |
| blueprint-writer | `rpf-mustfix` | RETURNED — added missing pin + Mathlib API confirmation + gate annotation refresh |
| blueprint-reviewer | `rpf-fastpath` | RETURNED — HARD GATE CLEAR; Lane RPF re-engaged in iter-198 |

## Strategy-critic `route198` — must-fix actions landed

The strategy-critic returned CHALLENGE with 6 must-fix items. All
addressed via in-place STRATEGY.md edits this iter:

1. **Route C REJECT — goal-coherence**: the Goal restated to scope
   "zero inline sorry" to the **dependency cone of each protected
   declaration** (not the global sorry count). Route C files are
   off-cone scaffolding; the genus-0 arm of `nonempty_jacobianWitness`
   closes via Route A's zero-dim group-scheme argument (newly
   spelled out under STRATEGY's "### Genus-0 arm" subsection).
   Cone-audit committed to iter-199+. If the audit shows protected
   decls still transitively depend on Route C, the strategy reverts
   to either (a) excise Route C from the import tree or (b) USER
   re-engages Route C.
2. **A.2.c "Cartier route" CHALLENGE — anchor / restore Quot**:
   acknowledged that "Cartier representability bypass of Quot" is
   not literature-anchored (neither Kleiman §4 nor any FGA chapter
   states a Cartier-only representability). Strategy revised to:
   Pic representability is **genuinely substrate-blocked on Route
   C (RR)** for both Quot and Sym^d alternatives; the
   carrier-soundness probe permits typeclass-level abstraction in
   the iter-loop. A.2.c moved to priority-4 conditional.
3. **Genus-0 witness CHALLENGE — lemma chain explicit**: added an
   8-step lemma chain (genus = dim H¹ = dim T_e Pic⁰ → dim 0 →
   smooth + étale → connected dim-0 group scheme over a field =
   Spec k) under STRATEGY's "### Genus-0 arm" subsection. The
   chain is Route-C-independent.
4. **A.3.vii effort honesty CHALLENGE**: A.3.ii / A.3.vii widened
   from ~80–200 LOC to ~300–600 LOC for the
   scheme-level-Hilbert-polynomial + Pphifin substrate. Phase
   table row revised.
5. **Carrier-soundness probe abort criterion CHALLENGE**: sharpened
   to name the specific declarations to `lean_verify`, the
   expected axiom triple `{propext, Classical.choice, Quot.sound}`,
   the FAIL trigger (any `sorryAx` in a consumer), and the
   rollback target (revert of the `carrier-soundness-fgapic`
   refactor).
6. **Format DRIFTED**: stripped per-iter narrative references
   ("iter-198 verdict due", "iter-197 closure state", date-stamped
   USER directive references). Dropped the A.1.a "landed" row
   from the phases table. Moved the carrier-soundness probe row
   out of the phases table (it lives only under "Open strategic
   questions" now).

## Progress-critic `route198` — must-fix actions landed

The progress-critic delivered 3 CHURNING + 1 STUCK + 1 UNCLEAR
across the 6 active routes. Verdicts per lane and actions:

- **Lane WD-A4a** (UNCLEAR — fresh): proceed; iter-198 dispatch
  goes ahead. No corrective.
- **Lane AB** (CHURNING — 3 consecutive iters of zero dispatch
  after iter-195 carving): dispatch initiated this iter
  (Objective #2). The 4-piece substrate is multi-iter; iter-199
  must plan the residual regardless of iter-198 outcome
  (committed under "## Iter-199 preliminary commitments").
- **Lane RPF** (CHURNING — 5-iter zero-dispatch; **GATE ANNOTATION
  STALE FOR 10 ITERS**): the in-file annotation citing
  `LineBundle.OnProduct` as the typed-sorry gate is stale; that
  sorry closed at iter-188. The actual residual gate on L235 is
  tensor-product `AddCommGroup` on `LineBundle.OnProduct` (a
  Mathlib b80f227 monoidal-structure gap). PROGRESS.md Objective
  #3 updated this iter to (a) correctly identify the real gate,
  (b) instruct the prover to fix the stale annotation in-passing,
  and (c) point out that L287-L482 can be closed using the file-
  local sorry `addCommGroup` scaffold (reducing the file to 1
  sorry on L235 alone).
- **Lane COE** (STUCK — iter-196 EXCISED was a premature sunk-cost
  giveaway per critic): dispatch initiated (Objective #4) BUT
  re-scoped from "close Stage 6 cold" to **substrate-build for
  sub-gaps (i)-(iv)** in parallel with a blueprint-writer
  dispatch (`coe-stage6-expansion`) that expands the chapter's
  Stage 6 sub-section with explicit sub-gaps. Iter-198 hard bar
  reduced from "close L526" to "land sub-gap (i)
  `Algebra.IsSmooth.krullDim_stalk` axiom-clean". STRATEGY.md
  Phase row widened to ~4-8 iters / ~300-500 LOC.
- **Lane FGA** (CHURNING — 5-iter zero-dispatch; carrier-soundness
  probe is structural meta-work without sorry-closure plan):
  **blueprint-writer dispatch** (`fga-sorry-order`) ordered to
  produce a sorry-by-sorry closure order this iter. No iter-198
  prover dispatch on FGA (probe verdict still pending in
  iter-198 review). Iter-199 must arrive with the sorry-closure
  order **OR** an explicit USER-directed out-of-scope decision.
- **Lane T32** (CHURNING resolved by iter-198 dispatch):
  Objective #5 stretch goal is correct; L294 deferred until
  iter-198 Lane COE outcome.

### Dispatch-sanity verdict (progress-critic)

OK — file count 4 (post-RPF-drop) within cap 10; FGA deferred for
stated reason; RPF deferred per blueprint-reviewer HARD GATE.

## Blueprint-reviewer `iter198` — actions landed

The blueprint-reviewer returned a comprehensive per-chapter
verdict. Outcomes:

**HARD GATE verdicts** (iter-198 prover-gating chapters):
- `Albanese_AuslanderBuchsbaum.tex`: **CLEAR**
- `RiemannRoch_WeilDivisor.tex`: **CLEAR**
- `Picard_RelPicFunctor.tex`: initial verdict **DEFER** — `thm:rel_pic_etale_sheaf_group_structure` missing `\lean{...}` pin; étale-Grothendieck-topology Mathlib API not confirmed. **SAME-ITER FASTPATH EXECUTED**: blueprint-writer `rpf-mustfix` added the missing pin + confirmed Mathlib API + corrected the 10-iter-stale gate annotation; scoped blueprint-reviewer `rpf-fastpath` returned **HARD GATE CLEAR**. Lane RPF RE-ENGAGED in iter-198 objectives as Objective #3.
- `Albanese_CodimOneExtension.tex`: **CLEAR**
- `Albanese_Thm32RationalMapExtension.tex`: **CLEAR**

**Unstarted-phase blueprint proposals** (3 total):
- `Picard_CarrierSoundnessProbe.tex` — covers the iter-198 review-phase `lean_verify` probe abort verdict. **PARTIAL OVERLAP** with the blueprint-writer `fga-sorry-order` already dispatched this iter; the FGA-sorry-order chapter expansion will document the probe declarations as part of its scope. Skip the separate carrier-soundness-probe chapter for now; re-evaluate after `fga-sorry-order` returns.
- `Picard_PicDSubstrate.tex` — A.4.d.0 Cartier-route Pic^d substrate, priority-5. **DEFER** to iter-199+ — STRATEGY.md acknowledges A.4.d is gated on Route C re-engagement for RR substrate; writing this chapter now is premature.
- `Albanese_TangentSpaceSubstrate.tex` — A.3.0 tangent-space substrate, priority-3 parallel. **DEFER** to iter-200+ — A.3.0 is parallel-able with A.4.b/A.4.a but the current iter-198 priorities are saturated. Re-evaluate after the priority-1 roots converge.

**Strategy-modifying findings**:
- `lem:symmetric_product_to_jacobian` (in `Albanese_AlbaneseUP.tex`) **hides a Route C dependency**: the birationality proof uses `h^0(D) = 1` generically (Riemann-Roch genus formula). Under Route C PAUSE, this proof step cannot close. STRATEGY.md amended this iter to acknowledge A.4.d (divisor-map Albanese UP) is gated on Route C re-engagement (consistent with Pic representability's RR substrate-block).

**Soon-severity items** (deferred to iter-199+):
- Add standalone `\lean{...}` pin for `rationalMap_order_finite_support` in `RiemannRoch_WeilDivisor.tex` (gates L249 prover target).
- Add standalone `\lean{...}` pin for `auslander_buchsbaum_formula_succ_pd` in `Albanese_AuslanderBuchsbaum.tex` (gates L1131 prover target).
- Add Route-C-dependency NOTE on `lem:symmetric_product_to_jacobian` in `Albanese_AlbaneseUP.tex`.

These soon-severity pins are documented but DO NOT block iter-198 prover dispatch (WD-A4a, AB chapters are CLEAR for their primary content; the L-number pin gaps are Lean-difficulty-quality issues, not content gaps).

## Alternative route surfaced by strategy-critic — Sym^d FGA Ch.9 §9.5

The critic surfaced FGA Ch.9 §9.5 (Sym^d / Abel–Jacobi for curves)
as a major-severity alternative to evaluate. Note: Sym^d requires
H⁰(C, L) locally-free-of-constant-rank for `d ≥ 2g-1`, which is
Riemann–Roch substrate. Under Route C PAUSE, Sym^d does NOT
circumvent the substrate block. **Decision**: do not adopt Sym^d
as a separate route this iter; the carrier-soundness probe remains
the iter-loop mitigation. If iter-200+ USER re-engages Route C,
re-evaluate Sym^d vs Quot for the curve-specific representability
proof.



References already present locally for every Route A priority-1/2
target — no reference-retriever dispatch needed this iter:
- Stacks-constructions (A.1.a/A.1.c).
- Kleiman-Picard (A.2.c, A.3.*).
- Nitsure-hilbert-quot (A.2.b — though bypassed; available for A.2.c
  representability arguments).
- Matsumura (A.4.b Auslander–Buchsbaum, A.4.c CodimOneExtension).
- Atiyah–Macdonald (codim-1 reasoning).
- Hartshorne (II.6 Weil divisors, IV.1 genus formulas).
- Milne / Mumford (Albanese UP, rigidity).
- Stacks-algebra (00OE / 02JK for A.4.c.0).

## Decision rebuttals / notes

### Promoting AuslanderBuchsbaum n=k+1 from off-critical to priority-1

Prior STRATEGY iter-196 marked `AuslanderBuchsbaum.lean` L1131
(n=k+1) as "off-critical-path" — iter-198 USER directive elevates
it to priority-1 root in parallel with WeilDivisor A.4.a and
RelativeSpec. Rationale (per the directive): Route A bottom-up
treats every Mathlib-root substrate as priority-1 regardless of
projected closure cost, because gated downstream lanes cannot
proceed until roots close. The 4-piece slice ordering documented in
the iter-195 docstring (depth-drops-by-one → minimal-resolution
carving → snake lemma → "what is exact") gives the iter-198 prover
a concrete next-step plan; the user directive sanctions investing
multi-iter budget here.

### Re-elevating CodimOneExtension from EXCISED to priority-2

Prior STRATEGY iter-196 marked Lane M↓ (`CodimOneExtension.lean`)
as EXCISED. iter-198 USER directive RE-ELEVATES it to priority-2
("A.4.c.0 once its roots close" — and CodimOneExtension IS the
root for Thm32). The earlier excision was made under the previous
Route A schedule that bypassed A.4.c.0 via the Cartier route, but
the user's bottom-up framing requires A.4.c.0 to be closed before
Thm32 (A.4.c.1) is touched. Stage 6 Stacks 00OE / 02JK is the
specific iter-198 target.

### WeilDivisor.lean — hybrid Route A / Route C scoping

The file `RiemannRoch/WeilDivisor.lean` hosts BOTH the general
A.4.a Weil-divisor substrate (e.g. L249
`rationalMap_order_finite_support` non-zero branch / Stacks 02RV,
which is general for any Noetherian integral scheme regular in
codim-1) AND the RR.1-specific Hartshorne II.6 lemmas (L538
`principal_degree_zero` non-constant branch; L1108
`degree_positivePart_principal_eq_finrank` — both gated on
genus-0 ℙ¹ structure).

USER directive's "WeilDivisor A.4.a material" + "Route C PAUSE"
combination is reconciled by SCOPE: the prover lane operates on the
file but is restricted to A.4.a sorries only. L538 and L1108 remain
PAUSED. The iter-198 lane directive will name L249 as the only
target and explicitly forbid touching L538/L1108.

### Carrier-soundness probe — iter-198 abort criterion

STRATEGY row for the probe says "abort if `lean_verify` still
shows silent sorryAx propagation through typeclass synthesis".
This iter we lack a clean prover signal to act on, so the abort
verdict is deferred to the iter-198 review phase (or iter-199 plan
phase). In the meantime, the FGAPicRepresentability lane is NOT
dispatched on its main `representable` body (L354 free sorry)
because the probe verdict could revert the surrounding carrier
structure.

## Sorry projection iter-198

Entering iter-198 prover phase: **83 sorries** (per iter-197
meta.json `sorry_count`). Route A-only dispatch with 5 lanes.

- **Best case** (AuslanderBuchsbaum close n=k+1 + WeilDivisor L249
  close + RelPicFunctor ≥2 functor-builder sub-pieces close +
  CodimOneExtension Stage 6 close + Thm32 L155 helper close):
  83 → **~75-77** (−6 to −8).
- **Realistic** (AuslanderBuchsbaum substrate carving + WeilDivisor
  L249 close + RelPicFunctor 1-2 sub-pieces + CodimOneExtension
  partial Stage 6 + Thm32 L155 helper): 83 → **~78-80** (−3 to −5).
- **Worst case** (WeilDivisor L249 only + others substrate-only):
  83 → **~81-82** (−1 to −2).

**Target: realistic-or-best band** — this is the first iter under
the new Route A directive, so even worst-case −1 is progress when
combined with the structural shift.

## Active monitors

- **Route A bottom-up: first iter under the new directive.** Every
  lane below carries explicit reference citations per the USER
  directive. mathlib-build mode is the default; lanes may switch
  to `prove` if the target sorry has a complete recipe + no
  Mathlib gap to fill.
- **Carrier-soundness probe abort verdict**: iter-198 review or
  iter-199 plan — `lean_verify` on `[HasPicScheme C]` consumers.
- **Pic⁰ pivot**: A.3.i excised; A.3.ii redefined as `degComp(0)`.
  No prover dispatch until A.2.c + A.3.vii substrate lands.
- **Lane RCI**: HELD per user directive.

## Iter-199 preliminary commitments

1. **Process iter-198 outcomes**: cascade closures on Route A
   priority-1/2 lanes.
2. **Carrier-soundness probe verdict**: confirm or revert based on
   iter-198 review's `lean_verify` smoke check.
3. **A.3.vii degree map dispatch**: load-bearing substrate for the
   Pic⁰ pivot, ~80-200 LOC.
4. **A.4.c.1 Thm32 branch 2 dispatch**: gated on iter-198
   CodimOneExtension closure.
5. **Iter-199 mandatory critics**: blueprint-reviewer (full pass) +
   progress-critic + lean-auditor.

## Standing deferrals (unchanged from iter-197 unless noted)

- **`Cross01Substrate`** — both substrates axiom-clean.
- **`LineBundlePullback`** — DONE iter-188.
- **`SymmetricPower`** — CANCELLED per iter-188 divisor-map pivot.
- **`RigidityKbar`** — Route C PAUSED.
- **OcOfD `sheafOf` def body** — Route C PAUSED + structurally
  blocked (iter-187).
- **AlbaneseUP body** — priority-5 (gated); no iter-198 dispatch.
- **A.2.a flattening / A.2.b Quot** — bypassed via Cartier route.
- **A.3.i identity component** — EXCISED per Pic⁰ pivot.
- **Lane M↓** — RE-ENGAGED iter-198 as A.4.c.0 (CodimOneExtension)
  per USER directive (was excised iter-196 STRATEGY).
- **RR.4 rational ⟹ ≅ ℙ¹** — Route C PAUSED.
- **Lane RCI** — Route C PAUSED + HELD per USER directive.
