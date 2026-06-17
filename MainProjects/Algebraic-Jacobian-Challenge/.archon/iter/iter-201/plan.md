# Iter-201 plan-agent run

## Headline outcome

**The "process iter-200 outcomes (78 → 78 sorries; 2 of 3 HARD BARs MET
via substantive structural advance — WD 8 axiom-clean substrate decls +
IsRegularInCodimensionOne open-immersion descent + 7 axiom-clean
substrate theorems in COE Stage 6 chain Steps 1+2 fully + Step 3 partial;
AB ALIGN_WITH_MATHLIB pivot via `HasProjectiveDimensionLT` SES-descent
landed 4 axiom-clean helpers but body still blocked on Stacks 00MF) +
process iter-200 review outcomes (lean-auditor `iter200` 2 carry-over
must-fix UNRESOLVED on RelPicFunctor + AlbaneseUP; 3 per-file
lean-vs-blueprint-checkers flagged blueprint expansion needs for WD/AB/COE
as `soon` not must-fix-this-iter; private/public mismatch on
`auslander_buchsbaum_formula_succ_pd` carry-forward iter-199+200) +
plan-agent direct blueprint edits for the 3 prover-touched chapters
(WD §Open-immersion descent for prime divisors with 5 new \\lean{...}
pins + IsRegularInCodimensionOne pin + stale 'may introduce' prose fix;
AB \\subsec:ab_gap1_haspdlt_pivot with 4 new \\lean{...} pins +
gap (3) OBVIATED reclassification + gap (2) Stacks 00MF recipe expansion;
COE \\subsec:stage6_iib_substrate_iter200 with 7 substrate refs +
Stage 6.A description refresh + Jacobian-witness recipe paragraph) +
STRATEGY.md aggressive trim toward ≤250 lines (LOW-6 corrective) + 5
plan-phase subagent dispatches (progress-critic `route201`,
strategy-critic `route201`, blueprint-reviewer `iter201`,
mathlib-analogist `coe-stacks00sw` cross-domain-inspiration for the
Jacobian-regular-sequence witness, mathlib-analogist `ab-stacks00mf`
cross-domain-inspiration for Stacks 00MF or LES-injectivity alternative)
+ 3 Route A prover lanes scoped per priority-1/2 with explicit reference
citations + Lane RPF + Lane FGA + Lane T32 + Lane RCI HELD with
explicit rationale" iter.**

iter-200 returned `lake build` GREEN with **78 sorries / 0 axioms**
(20th consecutive zero-axiom build streak). Net trajectory 78 → 78
(0; substrate-only iter, no top-level sorry closures, but 2 of 3
HARD BARs met via substantive structural advance per iter-200 review).

## User hints

No user hints this iteration. The 2026-05-28 standing directives
(ROUTE C PAUSE permanent; Route A bottom-up; reference-driven
mathlib-build) remain the active framing for every prover lane. The
blueprint plastex fix on `RiemannRoch_OCofP.tex` L657 already landed
iter-198 (`\(\lean\)` → `\texttt{\textbackslash lean}`); verified
inline at L655 of the current file.

## Plan-phase actions (in chronological order)

### 1. Blueprint edits LANDED directly by plan agent

**WeilDivisor chapter** (`blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`):
- Fixed stale "Iter-173+ may introduce a `Scheme.IsRegularInCodimensionOne`
  predicate" prose (L99-102) to a confirmed-and-pinned statement.
- Added `\lean{AlgebraicGeometry.Scheme.IsRegularInCodimensionOne}` pin
  (the class was introduced iter-173+ but never pinned).
- Added new section `\section{Open-immersion descent for prime divisors}`
  between §2 and §3, pinning 5 iter-200 axiom-clean substrate
  declarations (`Scheme.PrimeDivisor.restrictToOpen`, `ofOpen`,
  `equivOpen`, `stalkIso`, `IsRegularInCodimensionOne.instOpen`) with
  proof sketches citing Stacks 02IZ + iter-183 CoheightBridge substrate.

**AuslanderBuchsbaum chapter** (`blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`):
- Added new `\subsec:ab_gap1_haspdlt_pivot` documenting the iter-200
  ALIGN_WITH_MATHLIB pivot from `ChainComplex ℕ` to
  `HasProjectiveDimensionLT` SES-descent (per `ab-natrecursive`
  analogist + iter-200 task report).
- Added 4 standalone `\begin{lemma}…\end{lemma}` blocks pinning the
  iter-200 axiom-clean helpers:
  `hasProjectiveDimensionLT_succ_of_projectiveDimension_eq`,
  `hasProjectiveDimensionLT_ker_of_surjection`,
  `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`,
  `depth_ker_ge_min_of_surjection_finite_localRing`.
- Reclassified gap (3) (snake lemma) row in the per-gap effort table
  as **OBVIATED iter-200** per the SES-descent path obviating
  minimality.
- Added Stacks 00MF (gap (2)) proof recipe paragraph for the iter-201+
  prover: Buchsbaum-Eisenbud exactness criterion via depths of
  ideals of `r`-minors.
- Resolved private/public mismatch on
  `auslander_buchsbaum_formula_succ_pd`: chose **option (1)** —
  blueprint NOTE updated to direct an iter-201+ prover or refactor
  agent to remove `private` from the Lean declaration as part of
  the closure dispatch, with rationale.

**CodimOneExtension chapter** (`blueprint/src/chapters/Albanese_CodimOneExtension.tex`):
- Updated `lem:smooth_algebra_krull_dim_formula` (Stage 6.A) "Mathlib
  API state" paragraph: replaced the stale "NEEDS-BRIDGE; ~200-300 LOC"
  description with the iter-200 actual state (Steps 1+2 axiom-clean
  inline via 7 substrate decls; Step 3 = Jacobian-regular-sequence
  witness as residual ~30-60 LOC).
- Added new `\subsec:stage6_iib_substrate_iter200` enumerating the
  7 iter-200 axiom-clean private substrate decls with their roles
  (Step 1 / Step 2 LB / Step 2 UB / Step 2 Fin n / Step 2 general /
  capstone / Step 3 additive form). NOTE: the 7 decls are `private`;
  the subsection includes them in prose with explanation rather than
  inline `\lean{...}` pins (avoiding sync_leanok private-name
  resolution).
- Added Jacobian-witness recipe paragraph for the iter-201+ Lane COE
  main effort: name `Algebra.SubmersivePresentation.jacobian_isUnit`
  + `RingTheory.Sequence.isRegular_cons_iff` +
  `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`
  as the building blocks; cite Stacks 00SW / 00OW for the
  mathematical content.

### 2. STRATEGY.md aggressive trim (LOW-6 corrective)

STRATEGY.md was 331 lines / ~13 KB at iter-201 start. Trim target
≤250 lines / ≤12 KB per the canonical-structure rule.

Removed/tightened:
- Compressed the multi-paragraph End-state contract recital in `## Goal`
  to one paragraph (option (c) commitment kept; the parenthetical
  examples of USER actions trimmed to a single bullet).
- Tightened the `## Routes` "Pic representability — substrate
  dependency on Route C" narrative to ~6 lines.
- Removed the "Pic⁰ definition" subsection (already covered by the
  Pphifin row + the open-strategic-question; not load-bearing).
- Trimmed "Genus-0 arm — TWO candidate constructions" (a/b) to
  a 4-line summary cross-referencing `analogies/pic0-ker-deg-pivot.md`
  and the strategic-question entry.
- Compressed the A.2.c open-strategic-question option (a)/(b)/(c)
  recital to 6 lines (the full rebuttal of strategy-critic's
  Candidate (b) row recommendation kept; the verbatim USER-directive
  quote trimmed to a one-line reference).
- Removed the "Carrier-soundness probe — verdict CONFIRM" block
  (already promoted to the `## Routes` Pic representability paragraph;
  redundant).

Final size: ≤240 lines. Phase table preserved verbatim with one
estimate refresh: A.4.c.0 row velocity refreshed `~50/it (substrate)`
→ `~55/it (substrate)` per iter-200 +165 LOC realized.

### 3. Plan-phase subagent dispatches

**progress-critic `route201`** — verdict-feed for the iter-201 prover
lane decisions. Directive carries last 5 iters' signals (sorry counts,
helper additions, prover statuses, blocker phrases) for the 3 active
files (WD/AB/COE) plus the proposed objectives list.

**strategy-critic `route201`** — STRATEGY.md was substantially edited
this iter (trim per LOW-6 + estimate refresh). Re-validate the strategy
arc + acknowledge or refine the iter-200 A.2.c REJECT-level finding
verdict.

**blueprint-reviewer `iter201`** — mandatory HARD GATE on the 3
prover-touched chapters (WD/AB/COE) post-edits. Must return
`complete + correct` on all 3 chapters before prover dispatch is
authorized.

**mathlib-analogist `coe-stacks00sw`** — cross-domain-inspiration mode.
Structural problem: constructing `RingTheory.Sequence.IsRegular`
for the relations `(f_j)_{j ∈ σ}` of a smooth-algebra
`Algebra.SubmersivePresentation` at the closed point of the local
ring. Should produce a ranked recipe list for Lane COE iter-201+
main effort.

**mathlib-analogist `ab-stacks00mf`** — cross-domain-inspiration mode.
Structural problem: closing the AB inductive step body without
Stacks 00MF (`pd M > 0 ⟹ depth M < depth R`). Either find a Mathlib
precedent for direct LES connecting-map injectivity in the `Ext` chain
that obviates 00MF, or confirm 00MF is the binding gap (~150-200 LOC
Mathlib upstream PR candidate).

### 4. iter-200 task_results archived

`task_results/AlgebraicJacobian_*.lean.md` moved to
`task_results/archive/iter-200/`; iter-200 plan-phase + review-phase
subagent reports retained in `task_results/` for plan-agent reading.

## Subagent skips

(none — all 3 mandatory subagents dispatched this iter)

## Progress-critic `route201` correctives — applied this iter

`progress-critic route201` returned **STUCK on all 3 lanes** with
severity gradient AB > WD > COE. Must-fix correctives:

1. **WD** — STUCK; blueprint expansion required mapping
   Sub-build → sorry closure chain. **APPLIED**: added
   `\paragraph{End-to-end map: Sub-builds 1--3 ⇒ closure of
   rationalMap_order_finite_support}` to the new
   §"Open-immersion descent for prime divisors" in
   `RiemannRoch_WeilDivisor.tex`. The map names Sub-build 1
   (CLOSED iter-200), Sub-build 2 (iter-201 target ~30-50 LOC),
   Sub-build 3 (iter-202 target ~30-50 LOC), terminal closure
   (iter-203 target ~40-80 LOC), and explicitly verifies that the
   chain terminates (no Sub-build 4 risk).
2. **WD** — OVER_BUDGET; STRATEGY.md estimate revision required.
   **APPLIED**: A.4.a row in STRATEGY.md updated to "~4-6
   (revised iter-201)" + explicit note "14 iters elapsed against
   original 3-6 estimate; revised honest estimate".
3. **AB** — STUCK; user escalation required for the ℕ∞ arithmetic
   sub-blocker before another 150-200 LOC substrate build.
   **APPLIED**: TO_USER escalation note added to the iter sidecar
   below for the review agent to surface in `TO_USER.md`. Lane AB
   still dispatched this iter under the analogist `ab-stacks00mf`'s
   verdict — if the analogist returns "neither path closes without
   upstream Mathlib", the iter-201 prover dispatch is documentation-
   only (substrate honest gap) and the TO_USER escalation becomes
   the actionable next step.
4. **AB** — OVER_BUDGET (severe); STRATEGY.md estimate revision
   required. **APPLIED**: A.4.b row updated to "~4-8 (revised
   iter-201 — UNKNOWN-WAS-3-6)" + explicit "33 iters elapsed (5.5×
   over budget); ℕ∞ arithmetic at base case may need Mathlib
   upstream addition" + TO_USER escalation note flagged.
5. **COE** — STUCK; blueprint expansion required resolving
   `IsRegular` vs `IsWeaklyRegular` API friction before 30-60 LOC
   Jacobian-witness build. **APPLIED**: new `\textbf{API choice}`
   paragraph added to `\subsec:stage6_iib_substrate_iter200`'s
   Jacobian-witness recipe in `Albanese_CodimOneExtension.tex`.
   The paragraph explicitly resolves the choice as
   `RingTheory.Sequence.IsRegular` (the strong predicate consumed
   by `ringKrullDim_quotient_add_eq_of_regular_sequence`) with
   `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`
   as the bridge from the naturally-arising
   `IsWeaklyRegular` predicate in the Koszul argument.
6. **COE** — OVER_BUDGET (marginal); STRATEGY.md estimate revision.
   **APPLIED**: A.4.c.0 row updated to "~3-6 (revised iter-201 — was
   ~5-9)" + explicit "19 iters elapsed (marginal over original);
   3 sub-gaps discharged in 3 consecutive iters; iter-201
   dispatches witness + L1061 closure".

## Strategy-critic `route201` correctives — applied this iter

`strategy-critic route201` returned **substantively SOUND but
format NON-COMPLIANT** with 4 CHALLENGE-level findings. All
addressed:

1. **Format NON-COMPLIANT** — 18 `iter-NNN` references throughout
   STRATEGY.md (Phase table, Risks cells, Open questions, Mathlib
   gaps). **APPLIED**: full restructure of STRATEGY.md. Zero
   `iter-NNN` references; per-iter narrative content moved to iter
   sidecars; Risks cells carry stable risk descriptions only;
   Phase table Iters-left column carries stable estimates only.
   Final size: 225 lines / ~14 KB (within 250-line cap; slightly
   over 12 KB target — minor per critic).
2. **`## Goal` A.2.c framing ambiguity** — strategy said both
   "option (c) committed" AND "USER selection among (a)/(b)/(c)".
   **APPLIED**: `## Goal` now unambiguously commits option (c) as
   the operative end-state. Options (a)/(b) are USER amendments
   the loop honors *if requested*; option (c) is the active
   contract until USER acts.
3. **Genus-0 option ranking** — strategy listed (a)/(b)/(c) flatly.
   **APPLIED**: `## Open strategic questions` now ranks
   (a) RECOMMENDED (Mumford-rigidity carve-out, ~300-500 LOC,
   surgical), (b) FULLER CLOSURE BUDGET (full Route C re-engagement,
   ~2000+ LOC), (c) OPERATIVE (current contract). Recommendation
   is now explicit guidance to the USER.
4. **Infrastructure-deferral termination condition** — A.2.c
   deferral had no holding-pattern termination. **APPLIED**:
   `## Goal` and `## Open strategic questions` now state the
   loop's termination condition: "Loop runs Route A substrate
   until all priority-1 + priority-2 roots close, at which point a
   re-escalation surfaces the cone audit. Currently estimated
   ~10-25 iters away."

**NEW alternative flagged by strategy-critic (major):** **direct
`J := Spec k` for genus-0 may NOT require `RigidityKbar`**. If the
Albanese target is `Spec k` (not an arbitrary AV), the
constant-map descent is trivial (no Brauer-Severi twist on the
target); only the source side needs `C_{k̄} ≅ ℙ¹_{k̄}` +
`Mor(ℙ¹, A) = const` (Milne 3.10). **APPLIED**: added to
`## Open strategic questions` as audit-needed, with the
recommendation to run `lean_local_search` + fresh Milne §1 read.
If correct, the USER carve-out scope for Candidate (b) halves
(only `AbelianVarietyRigidity` needed, not `RigidityKbar`),
significantly cheapening option (a).

## Blueprint-reviewer `iter201` verdict + same-iter fast path

`blueprint-reviewer iter201` returned per-chapter checklist:

- **WD**: `complete: true, correct: true` — HARD GATE CLEARS for Lane
  WD-A4a-Sub-build-2.
- **AB**: `complete: true, correct: partial` — HARD GATE CONDITIONAL.
  Due to 3 pre-existing `Lemma~REF` cross-reference placeholders in
  proof bodies (`thm:auslander_buchsbaum` ×2 at L376/L391;
  `lem:depth_short_exact_sequence` ×1 at L251). All trivially
  fixable to `\cref{lem:depth_short_exact_sequence}` ×2 and
  `\cref{lem:depth_via_ext}` ×1. Same-iter fast path available.
- **COE**: `complete: true, correct: true` — HARD GATE CLEARS for
  Lane COE-Stage6.B-Jacobian.
- Other chapters (`TensorObjSubstrate`, `FGAPicRepresentability`):
  `complete: partial` but no prover lane dispatched on them this
  iter, so the partial verdicts do not affect any HARD GATE.

**Same-iter fast path executed by plan agent**:
1. Fixed 3 must-fix `Lemma~REF` substitutions directly (mechanical
   substrate; no new content) + 1 soon-rated `Theorem~REF` in
   `cor:regular_cohen_macaulay` for cleanliness.
2. Re-dispatched blueprint-reviewer scoped to AB chapter alone
   (slug `iter201-ab-fastpath`) for HARD GATE re-verification.
3. Verdict received: **`complete:true, correct:true` — HARD GATE
   CLEARS for Lane AB-Stacks-00MF**. All 3 substitutions confirmed
   resolved by line-level fix-confirmation checklist; no regression
   introduced. 2 `soon`-rated pre-existing `~REF` placeholders
   remain (L265 in a "compare with" comparison sentence, L190 in
   a forward-reference within `def:projective_dimension` prose) +
   informational `~REF` placeholders in the introductory roadmap
   and closing implementation-notes section; none in proof bodies.

**Final HARD GATE table**:

| Lane | Lean file | Verdict |
|---|---|---|
| WD-A4a-Sub-build-2 | `RiemannRoch/WeilDivisor.lean` | CLEARS |
| AB-Stacks-00MF (Path B) | `Albanese/AuslanderBuchsbaum.lean` | CLEARS (post fast-path) |
| COE-Stage6.B-Jacobian | `Albanese/CodimOneExtension.lean` | CLEARS |

All 3 iter-201 prover lanes authorized; iter-201 plan phase
complete.

## Analogist verdict iter-201 — Lane COE (`coe-stacks00sw`)

**Refined recipe**: instead of bundling
`Algebra.SubmersivePresentation.relations_isRegular_in_localization`
directly via `isRegular_cons_iff`, decompose into a 3-step chain:

1. **A1** — project-side Matsumura Thm 14.2 / Stacks 00NQ helper
   `matsumura_isRegular_of_linearIndependent_cotangent` (~30-50 LOC,
   Mathlib upstream PR candidate). "On a regular local Noetherian ring
   of Krull dim n, c elements with κ-linearly-independent cotangent
   images form an IsRegular sequence." Induction on c via Mathlib's
   `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim`.
2. **A2** — cotangent-localisation transport
   `submersivePresentation_relations_linearIndependent_cotangent_localization`
   (~20-30 LOC) via `LinearIndependent.of_isLocalizedModule_of_isRegular`
   + the conormal-localisation iso.
3. **A3** — assembly + close via
   `IsWeaklyRegular.isRegular_of_isLocalizedModule_of_mem` (DIRECT
   INVOCATION from Mathlib `RingTheory/Regular/Flat.lean:65-73`).

Total ~60-95 LOC (modestly above the iter-201 plan's 30-60 budget
upper bound; still well within iter-201 LOC budget).

4 direct Mathlib analogues identified
(`IsWeaklyRegular.isRegular_of_isLocalizedModule_of_mem`,
`Algebra.SubmersivePresentation.basisCotangent`,
`IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`,
`LinearIndependent.of_isLocalizedModule_of_isRegular`).

PROGRESS.md Lane COE objective updated with the 3-step chain;
blueprint COE chapter's Jacobian-witness recipe expanded with the
A1/A2/A3 decomposition + named Mathlib references.

## Analogist verdict iter-201 — Lane AB

**`ab-stacks00mf` returned Path B feasible + recommended over Path A**
(~130-200 LOC). Path B uses Mathlib's `Ext.bilinearCompOfLinear` +
the project's existing `ext_smul_eq_zero_of_mem_annihilator` (L229)
to collapse `Ext(κ, A)` postcomposition for a minimal-presentation
matrix `A` with entries in the annihilator — this gives the
`pd M = 1 ⇒ depth M < depth R` base case without building Stacks
00MF as standalone substrate. The inductive step `pd M = k + 1`,
`k ≥ 1` uses only existing LES infrastructure (`depth_of_short_exact`
parts (2)+(3), iter-200 `hasProjectiveDimensionLT_*` helpers) +
contradiction on Ext-vanishing at `i = depth K`.

iter-201 Lane AB recipe **switched from Path A-or-B to Path B**;
PROGRESS.md objective 2 updated.

## TO_USER FYI (review agent to surface — NOT escalation)

The iter-201 mathlib-analogist `ab-stacks00mf` resolved the Lane AB
ℕ∞ arithmetic / induction-base blocker that the progress-critic
flagged as User-escalation-required: **Path B (LES-injectivity +
matrix-collapse) is feasible at ~130-200 LOC and reuses the project's
existing axiom-clean primitives**. The iter-201 prover dispatches
Lane AB on Path B; no User action required this iter.

Recorded as a note rather than escalation: if Path B encounters
unforeseen friction in the matrix-collapse helper construction
(the only project-new piece, ~50-80 LOC), the fallback is Path A
(Stacks 00MF substrate, ~150-200 LOC; recipe in the blueprint
`\subsec:succ_pd_gap_sequence` gap (2) paragraph).

The 33-iter / 5.5× over-budget signal that prompted the
progress-critic escalation reflects a real history of strategy
churn (literal `ChainComplex ℕ` iter-167–199 → ALIGN_WITH_MATHLIB
pivot iter-200 → Path B iter-201); iter-201 expects to land closure
or substantial substrate toward closure within Path B's budget.

## Decision made — Lane FGA Sorry 4 re-engagement deferred

Lane FGA (`Picard/FGAPicRepresentability.lean`) carrier-soundness
refactor (iter-199 ABLE-clean theorem body + `⟨sorry⟩` instance
constructor) remains the iter-200+ frame. The instance constructor
sorries are gated on A.1.c.SubT chapter substrate landing (Lane RPF +
the new `Picard_TensorObjSubstrate.tex` chapter); since the iter-200
chapter dispatch only created the chapter (no Lean scaffold yet),
the first dispatchable derivative is iter-202+ once a
`Picard/TensorObjSubstrate.lean` scaffold lands. Lane FGA iter-201 = HELD.
Surface to TO_USER FYI via the review agent.

## Plan-phase critic / dispatch summary

| Subagent | Slug | Status |
|---|---|---|
| progress-critic | `route201` | dispatched |
| strategy-critic | `route201` | dispatched |
| blueprint-reviewer | `iter201` | dispatched |
| mathlib-analogist | `coe-stacks00sw` | dispatched |
| mathlib-analogist | `ab-stacks00mf` | dispatched |

## Prover-phase shape

3 prover lanes (Route A bottom-up; mathlib-build default for Route A
per USER directive). Reference-anchored per USER directive.

- **Lane WD-A4a-Sub-build-2**: `Ring.ordFrac` transport across the
  iter-200 `Scheme.PrimeDivisor.stalkIso` ring iso. Reference:
  Stacks 02RV / 02ME + iter-200 task report Sub-build 2 preview
  signature. Priority-1 (A.4.a root).
- **Lane AB-Stacks-00MF**: close `auslander_buchsbaum_formula_succ_pd`
  body via either (Path A) Stacks 00MF substrate build (~150-200 LOC)
  or (Path B) LES-injectivity alternative obviating 00MF, per the
  `ab-stacks00mf` analogist verdict (analogist dispatched parallel
  to the prover). Priority-1 (A.4.b root).
- **Lane COE-Stage6.B-Jacobian**: build the Jacobian-regular-sequence
  witness substrate (Stacks 00SW / 00OW) and attempt L1061 inline
  closure via `Algebra.SubmersivePresentation.jacobian_isUnit` +
  `isRegular_cons_iff` + `isRegular_iff_isWeaklyRegular_…`.
  Reference: Stacks 00SW / 00OW + iter-200 task report iter-201+
  handoff substrate-pieces list. Priority-2 (A.4.c.0).

## Held lanes (explicit rationale)

### Lane RPF (`Picard/RelPicFunctor.lean`) — HELD

Reason: A.1.c.SubT chapter exists but the corresponding Lean scaffold
(`Picard/TensorObjSubstrate.lean`) does not. Lane RPF closure
requires the upstream Mathlib `Scheme.Modules` monoidal structure
substrate, which the project must build via the
`Picard_TensorObjSubstrate.tex` chapter dispatched iter-200. The
iter-202+ commitment: dispatch a file-skeleton scaffold lane on
`Picard/TensorObjSubstrate.lean` after the iter-201 blueprint-reviewer
re-verifies the chapter as `complete + correct`. Lane RPF stays
1-sorry (L235 `addCommGroup`) + 5 placeholder bodies + carry-over
must-fix `-- TODO` excuse comment per lean-auditor iter200.

### Lane FGA (`Picard/FGAPicRepresentability.lean`) — HELD

Reason: 7 ⟨sorry⟩ instances gated rank-1 (A.1.c.SubT, not yet
scaffolded) and rank-3 (Route C blocked). Re-engages iter-203+ after
TensorObjSubstrate scaffold + Lane RPF body fill.

### Lane T32 (`Albanese/Thm32RationalMapExtension.lean`) — HELD

Reason: binding re-engagement trigger is `COE Stage 6.B Krull-dim
formula (Stacks 00OE) closed`. Lane COE iter-201 dispatches the
Jacobian-witness which is the substantive Step 3; if closure lands
(stretch goal), iter-202 re-engages Lane T32 as Lane COE derivative.

### Lane RCI (`RiemannRoch/RationalCurveIso.lean`) — HELD (USER directive)

Route C PAUSED.

## Carry-over must-fix items addressed this iter

**iter-200 lean-auditor `iter200` must-fix items**:

1. **`RelPicFunctor.lean:266-269`** `-- TODO` excuse-comment + `exact sorry`
   on `addCommGroup` instance body. **DEFERRAL DOCUMENTED**: the comment
   text accurately describes the gate (`Scheme.Modules` monoidal
   structure gap); the closure path is the iter-202+ Lane RPF lane
   (gated on `Picard/TensorObjSubstrate.lean` scaffold). The
   excuse-comment's "TODO" framing reflects an honest project-side
   gap, not a delaying tactic; the iter-201 plan agent commits the
   iter-202+ dispatch sequence and does NOT issue a closure dispatch
   this iter that would re-introduce placeholder-body
   headline-laundering risk. Surface to TO_USER FYI.

2. **`AlbaneseUP.lean:179-183`** `bundle : Bundle C := sorry` +
   "placeholder pending the A.3 row chapter" docstring excuse-comment.
   **DEFERRAL DOCUMENTED**: priority-5 standing deferral; A.3 row is
   gated on A.2.c (substrate-blocked on RR per option (c) framing).
   The "pending" language in the docstring accurately tracks the
   strategy state and is not a delaying tactic. iter-201 plan agent
   does NOT issue a refactor directive; the docstring revision
   awaits the A.3 row activation (estimated iter-220+ under current
   trajectory). Surface to TO_USER FYI.

**iter-200 lean-vs-blueprint-checker `ab-iter200` MED-5a**:
private/public mismatch on `auslander_buchsbaum_formula_succ_pd`.
**RESOLVED in blueprint**: NOTE updated to choose option (1) — remove
`private`. The iter-201 Lane AB prover OR a refactor agent dispatched
post-closure handles the `private` removal as part of the closure
landing. Tracked.

## Sorry projection iter-201

Entering iter-201 prover phase: **78 sorries / GREEN** (per
iter-200 meta.json `sorry_count`). 3 Route A lanes scheduled.

Prover phase projections:
- **Best case** (Lane WD Sub-build 2 closes L535 non-zero branch +
  Lane AB body closes via LES-injectivity alternative + Lane COE
  Jacobian witness lands & cascades to L1061 closure + Lane T32
  derivative re-engagement): 78 → **~73-75** (−3 to −5).
- **Realistic** (Lane WD substrate only; Lane AB substrate via
  analogist-named LES path; Lane COE Jacobian witness substrate
  axiom-clean but L1061 closure incomplete): 78 → **~76-77** (−1
  to −2).
- **Worst case** (all 3 lanes substrate-only, no closures, no
  cascade): 78 → **~78** (0).

**Target: realistic-band** — Lane COE Jacobian witness has a clean
recipe from iter-200 prover handoff + analogist `coe-stacks00sw`
dispatch; Lane AB has a documented Mathlib gap that may either be
filled (Path A 00MF) or sidestepped (Path B LES). Lane WD Sub-build 2
is structurally simpler than Sub-build 1 (~30-50 LOC budget vs.
iter-200 +120 LOC realized).

## Active monitors

- **A.2.c contract reachability**: option (c) honest framing committed
  iter-200; iter-201 strategy-critic `route201` re-evaluates after the
  STRATEGY.md trim.
- **Lane WD-A4a Sub-build cascade**: iter-201 = Sub-build 2; iter-202 =
  Sub-build 3 if Sub-build 2 lands. Closes L535 only after Sub-builds
  2+3 both land.
- **Lane RPF / FGA / TensorObjSubstrate sequence**: iter-202+ commitment:
  scaffold `Picard/TensorObjSubstrate.lean` (file-skeleton from the
  iter-200 chapter); iter-203+ fill TensorObjSubstrate bodies; iter-204+
  re-open Lane RPF body fill; iter-205+ re-open Lane FGA rank-1 ⟨sorry⟩
  instances. Total estimated 4-iter sequence to bring A.1.c chain to
  axiom-clean.
- **Lane T32 derivative**: re-engagement trigger remains COE Stage 6.B
  closed; if Lane COE Jacobian witness closes L1061 this iter, iter-202
  re-engages Lane T32.
- **Carry-over headline-laundering on RPF**: placeholder bodies at
  L287/L328/L373/L433/L482 + `% NOTE: placeholder body` markers; gates
  on `Scheme.Modules` monoidal substrate landing.

## Iter-202 preliminary commitments

1. Process iter-201 outcomes (closures, blockers, blueprint updates).
2. Lane TensorObjSubstrate file-skeleton scaffold dispatch on the
   iter-200 chapter — first Lean scaffold lane for A.1.c.SubT.
3. Lane WD Sub-build 3 (`Scheme.RationalMap.order` naturality across
   stalk iso) if Sub-build 2 lands; else continue Sub-build 2.
4. Lane AB: continue Path A or Path B per iter-201 analogist outcome
   + prover progress.
5. Lane COE: continue Jacobian-witness or cascade to L1061 closure
   + Lane T32 re-engagement.
6. Lane RPF: re-open iter-203+ post-TensorObjSubstrate body fill.
7. iter-202 mandatory critics: blueprint-reviewer + progress-critic +
   (strategy-critic conditional on edits).

## Standing deferrals (unchanged from iter-200 unless noted)

- **`Cross01Substrate`** — DONE.
- **`LineBundlePullback`** — DONE iter-188.
- **`SymmetricPower`** — CANCELLED.
- **`RigidityKbar`** — Route C PAUSED.
- **OcOfD `sheafOf` def body** — Route C PAUSED + structurally
  blocked.
- **AlbaneseUP body** — priority-5 (gated on Route C re-engagement +
  A.3 row activation).
- **A.2.a flattening / A.2.b Quot** — bypassed via Cartier route.
- **A.3.i identity component** — EXCISED per Pic⁰ pivot.
- **RR.4 rational ⟹ ≅ ℙ¹** — Route C PAUSED.
- **Lane RCI** — Route C PAUSED + HELD.
- **Lane T32** — Lane COE derivative; binding trigger: `COE Stage
  6.B Krull-dim formula closed`.
- **Lane RPF** — HELD iter-199/200/201; iter-204+ re-opens
  post-TensorObjSubstrate body fill.
- **Lane FGA** — HELD iter-200/201; iter-205+ re-opens post-Lane RPF
  body fill.
