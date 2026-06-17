# Iter-121 (Archon canonical) plan-agent run

## Headline outcome

**Strategic pivot under user directive + iter-121 prover lane DEFERRED
per HARD GATE.**

Per the iter-121 user directive in `USER_HINTS.md` ("act as a mathlib
contributor; fill the mathlib gap by writing it; no deferred tasks"),
the project's strategy is rewritten to drop the "ship with one inline
sorry" end-state and adopt a multi-iter Mathlib-build-out roadmap
(M1, M2, M3 with sub-step decomposition). However, the
`blueprint-reviewer-iter121` HARD GATE fires on both
`Differentials.tex` and `Jacobian.tex` (both `complete: partial`),
deferring the iter-121 prover lane.

Specifically:

1. **STRATEGY.md rewritten** for the new end-state and roadmap.
2. **`blueprint/src/chapters/Differentials.tex` partially rewritten
   inline** (LaTeX syntax error fixed; broken refs fixed; section
   moved from "out-of-scope" to in-scope M1; bridge stated as a
   theorem; three auxiliary lemmas added).
3. **`blueprint/src/chapters/Jacobian.tex`** unchanged (still
   one-sentence C.2; blueprint-writer dispatched to expand).
4. **Two blueprint-writer subagents dispatched** for the remaining
   blueprint defects:
   - `differentials-iter121` — expand M1.b cofinality proof
     skeleton; fix `\uses{...}` direction on
     `lem:kaehler_localization_subsingleton`; replace
     "out-of-autonomous-loop scope" framing per pivot.
   - `jacobian-iter121` — expand C.2 (rigidity for `ℙ¹_{k̄} → A`)
     from one sentence to multi-paragraph skeleton with classical
     "proper rational curves on abelian varieties are constant"
     input and Galois descent step.
5. **No prover lane this iter.** The M1 prover lane on
   `Differentials.lean` is deferred to iter-122 per the
   `blueprint-reviewer-iter121` HARD GATE.

Project sorry trajectory entering iter-122: **1** (unchanged from
iter-121 entry — `nonempty_jacobianWitness`). Iter-122 will:
1. Re-dispatch blueprint-reviewer to confirm both chapters clear the
   HARD GATE.
2. Dispatch refactor subagent to introduce the bridge declaration
   `relativeDifferentialsPresheaf_iso_kaehler_appLE` with `sorry`
   body.
3. Dispatch the M1 prover lane.

## Iter-121 prover lane deferred (HARD GATE)

Per the `blueprint-reviewer-iter121` per-chapter checklist, both
`Differentials.tex` and `Jacobian.tex` are `complete: partial`:

- **`Differentials.tex`** must-fix items (some now fixed inline, some
  still pending after the writer pass):
  - LaTeX syntax error `\end{remark>` at line 199 [FIXED inline].
  - Three broken `\ref{sec:bridge-out-of-scope}` at lines 30, 41, 46
    [FIXED inline via sed].
  - **M1.b cofinality proof skeleton missing** — flagged as the
    "heart of the milestone" with no concrete proof shape. [WRITER
    DISPATCHED `differentials-iter121` to address.]
  - Wrong `\uses{lem:appLE_isLocalization}` direction on
    `lem:kaehler_localization_subsingleton`. [WRITER DISPATCHED.]
  - "Out-of-autonomous-loop scope" framing still present in
    converse-direction + later-content sections, not aligned with
    iter-121 pivot. [WRITER DISPATCHED.]

- **`Jacobian.tex`** must-fix items:
  - C.2 (rigidity for `ℙ¹_{k̄} → A`) is one sentence; the directive
    identifies M2.a as a future prover lane, so per HARD GATE this
    chapter must clear `complete: true` before the M2.a lane runs.
    [WRITER DISPATCHED `jacobian-iter121` to expand.]

Per the blueprint-reviewer's dispatcher_notes (verbatim):

> If C has `complete: true` AND `correct: true` AND no must-fix-this-iter
> finding touches it, F may go into the objectives.
> Otherwise (C is `partial | false` on either axis, OR a must-fix
> finding names C, OR a broken `\uses{}` in C points at a label F's
> blueprint depends on):
> 1. DROP F from this iter's objectives. Defer the prover round on F
>    to the next iter.
> 2. Dispatch a `blueprint-writer` for C THIS iter with a directive
>    targeting the specific must-fix items I flagged.
> 3. Record in iter/iter-NNN/plan.md why F was deferred (cite the
>    reviewer findings).

Both steps (2) and (3) executed this iter. The 1-iter latency cost
of waiting for the writer is far less than the cost of a prover
formalizing against a broken blueprint.

## What I consumed

- `task_results/AlgebraicJacobian_Differentials.lean.md` (iter-120
  prover report — COMPLETE on `smooth_locally_free_omega`).
- `task_results/lean-auditor-review120.md` (clean audit; 0
  must-fix; 2 minor long-line warnings; no excuse-comments).
- `task_results/lean-vs-blueprint-checker-differentials-review120.md`
  (clean bi-directional check). All three iter-120 results archived
  to `logs/iter-120/` and cleared from `task_results/`.

- `USER_HINTS.md` carried ONE substantive new directive:

  > [...] You still wrote some deferred tasks in the plan, there
  > should not be as your goal is to fill the mathlib gap by writing
  > it ! You should act as a mathlib contributor, your code may be
  > merged into mathlib.

  Acted on this iter: STRATEGY.md rewritten; `Differentials.tex`
  reorganized to bring the bridge into scope; M2/M3 milestones
  fully decomposed; `USER_HINTS.md` cleared after acting.

- `STRATEGY.md`: read; **rewritten this iter** to reflect the new
  end-state. Major changes:
  - Adopted strategy-critic-iter121's recommendation for the
    genus-stratified body of `nonempty_jacobianWitness`
    (`by_cases h : genus C = 0`).
  - Corrected M2.c (the false unconditional `C ≅ ℙ¹_k` step)
    with base-change-to-`k̄` + Galois descent.
  - Added explicit M3 route-pick decision criterion + top-3
    gating Mathlib pieces per route + per-iter progress signal
    rules.
  - Spelling fix: `IsAffineOpen.isLocalization_basicOpen`.

- `PROGRESS.md`: rewritten this iter for the iter-121 deferral.

- `task_pending.md` / `task_done.md`: read for sorry inventory.
  Iter-121 doesn't change pending/done state (no prover lane).

- `archon-protected.yaml`: unchanged. 9 protected declarations.

- `iter/iter-118/{plan,review}.md`, `iter/iter-119/{plan,review}.md`,
  `iter/iter-120/{plan,review}.md`: read for context.

## Critic findings + actions

### strategy-critic-iter121 → CHALLENGE + SOUND-with-clarifications

Verdict per route:
- **M1**: SOUND with two clarifications required (a) framing as
  upstream-infrastructure-not-project-sorry-reduction; (b) spelling
  fix `IsAffineOpen.isLocalization_basicOpen` (not
  `basicOpen_isLocalization`). **Addressed** in the STRATEGY.md
  rewrite this plan phase.
- **M2**: CHALLENGE on (a) no genus parameter on
  `nonempty_jacobianWitness`; (b) M2.c `C ≅ ℙ¹_k` is false for
  curves without `k`-rational points (Brauer–Severi conics); (c)
  base-change infrastructure unbudgeted. **Addressed** by adopting
  the genus-stratified body decomposition and the
  base-change-to-`k̄` + Galois descent route in STRATEGY.md.
- **M3**: CHALLENGE on (a) route-pick criterion absent; (b) gating
  Mathlib pieces unnamed; (c) per-iter progress signal absent.
  **Addressed** by adding explicit route-pick criterion, top-3
  gating pieces per route (A.1–A.3 / B.1–B.3), and per-iter
  progress signal rules in STRATEGY.md § "Per-iter progress
  signal for M3".

Two major alternatives raised by the critic — genus-stratified body
and genus-0 via base change to `k̄` — both **adopted** in the
revised strategy.

### progress-critic-iter121 → UNCLEAR on both routes

Both M1 and M2 are fresh routes; UNCLEAR is the expected verdict.
Watch criteria committed for iter-122/iter-123 (see PROGRESS.md §
"Watch criteria"); no CHURNING/STUCK signals.

### blueprint-reviewer-iter121 → HARD GATE fires; defer prover lane

- `Differentials.tex` `complete: partial / correct: partial` — four
  must-fix items, two fixed inline this iter (LaTeX, refs), two
  delegated to writer dispatch (M1.b skeleton, `\uses{...}`
  direction; plus "out-of-scope" prose cleanup).
- `Jacobian.tex` `complete: partial` — one must-fix item (C.2
  expansion), delegated to writer dispatch.
- All other chapters `complete: true / correct: true`.

**HARD GATE response**: iter-121 prover lane on `Differentials.lean`
deferred to iter-122. No `## Current Objectives` entries this iter
(uses recognized no-prover marker `(no prover dispatch this iter —
see iter/iter-121/plan.md for rationale)`).

### mathlib-analogist-bridge-iter121 → ALIGN_WITH_MATHLIB + NEEDS_MATHLIB_GAP_FILL (M1.b re-framing)

Returned with 5 ALIGN_WITH_MATHLIB verdicts (statement shape,
`IsLocalization` packaging, namespace, naming, M1.c reduction) and
1 NEEDS_MATHLIB_GAP_FILL with REDESIGNED approach (M1.b re-framing).

Persistent file written to
`analogies/relative-differentials-presheaf-bridge.md`.

**Key findings — all incorporated into the revised STRATEGY.md
this iter:**

1. **Statement shape**: `LinearEquiv` (`≃ₗ[B]`) with `@[simps]`,
   not `ModuleCat.Iso`, not global `PresheafOfModules` natural iso.
   Mirrors `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale`.

2. **`appLE_isLocalization` shape**: bare theorem giving
   `IsLocalization M A_colim` predicate (NOT also an `AlgEquiv`).
   Mirrors `IsAffineOpen.isLocalization_basicOpen`.

3. **M1.b cofinality re-framing**: avoid `Functor.Final` colim-
   comparison entirely. Mathlib has no off-the-shelf "colim of
   localizations is localization at M" lemma. Use instead:
   (a) construct `A_M → A_colim` via `Localization M` universal
       property (after showing each `g ∈ M` is a unit in `A_colim`);
   (b) construct `A_colim → A_M` via colim cocone universality;
   (c) verify composites are identity via
       `IsLocalization.ringHom_ext`;
   (d) conclude `IsLocalization M A_colim` via `IsLocalization.of_le`.
   Mathlib workhorse: `IsLocalization.of_le`.
   Cost estimate revised: 100-250 LOC (from prior 120-180 LOC).

4. **Rename**: `_iso_` → `_equiv_`. New main bridge declaration
   name: `relativeDifferentialsPresheaf_equiv_kaehler_appLE`.

5. **Namespace**: prefer `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`
   over `AlgebraicGeometry.Scheme.appLE_isLocalization`.

6. **M1.c is NOT a Mathlib gap (correction from iter-121 first
   draft)**: Mathlib has
   `Algebra.FormallyUnramified.of_isLocalization` +
   `subsingleton_kaehlerDifferential` instance. M1.c can be dropped
   as a standalone declaration and inlined at M1.d (2 lines).

7. **M1.d is short** (10-30 LOC), not a separate Mathlib gap.
   Uses `KaehlerDifferential.exact_mapBaseChange_map` +
   `KaehlerDifferential.map_surjective` + the M1.c
   `Subsingleton` consequence. This is the most extractable
   Mathlib contribution candidate (generalises
   `tensorKaehlerEquivOfFormallyEtale`).

STRATEGY.md § "M1 — Bridge" was updated this plan phase to absorb
all 7 findings.

### blueprint-writer-differentials-iter121 → COMPLETE (pre-analogist directive)

The Differentials writer completed its pass on the pre-analogist
directive. Outcome:

- **M1.b proof skeleton landed.** Four concrete steps: (1) cofinality
  of basic opens via quasi-compactness + product `g = ∏ g_i`; (2)
  single-element localization via
  `IsAffineOpen.isLocalization_basicOpen`; (3)
  `colim_{g ∈ M} A_g = Localization M A` (named as a Mathlib gap
  with candidate home `Mathlib.RingTheory.Localization.Submonoid`);
  (4) assemble. Stacks Tag 02M5 cited.
- **`\uses{lem:appLE_isLocalization}` direction on
  `kaehler_localization_subsingleton` fixed** (now empty).
- **"Out of autonomous-loop scope" framing replaced** at 6
  occurrences (slightly more than directive's "4"). Section headings
  renamed: "Converse direction (milestone M4)" and "Content
  scheduled for later milestones" (with the M5–M8 numbering
  applied to the four tail bullets).

**Drift from analogist findings**: the writer used the
`Functor.Final` cofinality framing that the analogist recommended
to avoid; it kept M1.c as a standalone lemma rather than dropping it
to the inline `FormallyUnramified.of_isLocalization` two-liner; it
kept the `_iso_` naming. **None of these are correctness defects**;
they are sub-optimal Mathlib-alignment choices that iter-122 can
correct via either (a) a second blueprint-writer pass on
Differentials.tex with the analogist findings as directive content,
or (b) a refactor pass on the Lean side that uses the
analogist-recommended shapes and updates the blueprint `\lean{...}`
hints to match. **Recommendation for iter-122**: dispatch (b) — the
refactor pass — and let the in-Lean signatures (with the analogist
shapes) drive the blueprint `\lean{...}` hint updates via a small
follow-up writer pass.

### blueprint-writer-jacobian-iter121 → COMPLETE

The Jacobian writer completed its pass on the C.2 (genus-0 rigidity)
expansion. Outcome:

- **C.2 expanded into 7 sub-steps** (C.2.a–C.2.g, ~110 LOC of
  blueprint LaTeX) covering: statement of rigidity over `k̄`;
  reduction to `GrpObj_eq_of_eqOnOpen`; image-dimension argument;
  key classical input (Mumford's "proper rational curves on abelian
  varieties are constant"); set-to-scheme equality promotion;
  Galois descent for the `k`-side conclusion; Mathlib-gap statement.
- **Two proofs sketched** for the classical input: (i) via dual
  abelian variety + autoduality + `Pic^0(ℙ¹) = 0`; (ii) via
  triviality of `Ω_{A/k̄}` + vanishing `H⁰(ℙ¹, Ω_{ℙ¹}) = 0`.
- **Provisional Lean name**: `AlgebraicGeometry.AbelianVariety.constant_of_P1_map`.
- **Refactor recommendation for iter-122+**: writer flagged that
  `GrpObj.eq_of_eqOnOpen` requires the source to be a group scheme
  (`ℙ¹_{k̄}` is not). Either inline the underlying equaliser-closed
  argument or refactor `Rigidity.lean` / `Rigidity.tex` to drop the
  group-object-on-source hypothesis (which the proof doesn't use)
  into `Scheme.eq_of_eqOnOpen`. This is a future refactor candidate
  for M2.a.
- **Minor notes**: stale phrasing at lines 376, 387 in `Jacobian.tex`
  (still uses old `Hom(ℙ¹_k, A) = A(k)` framing) was left untouched
  per the directive's out-of-scope rule; a future writer pass can
  align them to the new C.2 base-change-and-descent framing.

Strategy unchanged (no strategy-modifying findings).

## Iter-121 Lean changes (none, by design)

The iter-121 plan phase makes **zero Lean changes**. The bridge
declaration `relativeDifferentialsPresheaf_iso_kaehler_appLE` is
NOT introduced this iter (refactor subagent dispatch deferred to
iter-122 after the blueprint clears the HARD GATE and the
analogist's API-shape recommendation lands).

## Iter-121 blueprint changes

- `STRATEGY.md` — rewritten (multi-iter Mathlib-build-out end-state).
- `blueprint/src/chapters/Differentials.tex` — partial rewrite
  inline by the plan agent (sections moved from out-of-scope to
  in-scope, bridge stated as theorem, three auxiliary lemmas
  added). Two `\end{remark>` / `\ref{sec:bridge-out-of-scope}`
  must-fix items fixed inline. The remaining defects (M1.b proof
  skeleton, `\uses{...}` direction, out-of-scope prose) are the
  subject of the running `differentials-iter121` blueprint-writer
  dispatch.
- `blueprint/src/chapters/Jacobian.tex` — unchanged in plan-phase
  inline edit. The running `jacobian-iter121` blueprint-writer
  dispatch will expand C.2.

## Iter-122 plan preview (for the next iter's planner)

1. **Re-dispatch `blueprint-reviewer`** to confirm
   `Differentials.tex` and `Jacobian.tex` are now `complete: true`
   and `correct: true`.
2. **Check the mathlib-analogist report** (arrived at the end of
   iter-121 or early in iter-122) for the bridge API shape
   recommendation. The recommendation will be one of:
   - **LinearEquiv** (`≃ₗ[B]`) — most likely, matches the blueprint's
     prose verbatim.
   - **IsLocalizedModule** — if the analogist recommends framing
     the bridge as a module-localization-instance rather than an
     explicit LinearEquiv.
   - **Iso in ModuleCat B** — categorical phrasing; less likely.
3. **Dispatch refactor subagent** with the chosen signature shape;
   add the bridge declaration to `AlgebraicJacobian/Differentials.lean`
   with `sorry` body.
4. **Dispatch the M1 prover lane** on
   `AlgebraicJacobian/Differentials.lean`, targeting M1.a (the
   submonoid `M`) as the locked-in first sub-step (per
   progress-critic-iter121 watch criterion 4: lock in M1.a vs M1.b
   in iter-122's plan).

## Watch criteria committed for iter-122 (from progress-critic-iter121)

1. **iter-121 blueprint-writer passes return COMPLETE on both
   chapters** → iter-122 re-dispatches blueprint-reviewer; HARD
   GATE clears; M1 prover lane proceeds.
2. **One or both blueprint-writer passes return INCOMPLETE** →
   iter-122 escalates with a follow-up writer pass. M1 prover lane
   stays deferred.
3. **iter-121 prover lane returns PARTIAL with M1.a body
   structurally landed** (hypothetical — depends on whether the
   iter-122 prover lane actually runs after the HARD GATE clears)
   → UNCLEAR but healthy; iter-123 continues M1.a closure.
4. **The mathlib-analogist returns ALIGN_WITH_MATHLIB** → iter-122
   refactor directive uses the recommended idiom.
5. **The mathlib-analogist returns NEEDS_MATHLIB_GAP_FILL** → the
   iter-122 directive includes a note that M1.c's "Kähler module
   of a localization is zero" is a Mathlib gap to be supplied as
   part of the M1 work.

## Fallback if no user response

USER_HINTS.md is cleared after acting on this iter's directive. If
the user provides no further hint before iter-122, the plan agent's
default action is: **continue executing the M1 roadmap as named in
STRATEGY.md**. Specifically:

- iter-122: re-dispatch blueprint-reviewer; dispatch refactor on
  the bridge declaration (per analogist's API-shape recommendation);
  dispatch prover lane on M1.a.
- iter-123: continue prover work on M1.a/M1.b until the bridge
  closes (5–10 iter horizon).
- iter-125+: M2 enters the prover queue after M1 produces enough
  structural advance.
- iter-128+: M3 route-pick + first sub-step prover lane.

If iter-121 blueprint-writer passes return INCOMPLETE on either
chapter, the iter-122 default is to dispatch a follow-up writer pass
on the still-incomplete chapter rather than push prover lanes onto
an incomplete blueprint.

If the mathlib-analogist returns with a surprising ALIGN_WITH_MATHLIB
finding on something other than the bridge API shape (e.g. "the
project's `relativeDifferentialsPresheaf` should be a different
construction"), the iter-122 plan-phase will pause M1 and reconsider
the strategy. This is the only path under which iter-122 might NOT
dispatch a refactor + prover lane.
