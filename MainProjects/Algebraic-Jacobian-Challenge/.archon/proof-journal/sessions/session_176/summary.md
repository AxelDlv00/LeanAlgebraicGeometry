# Session 176 — Review of iter-176

## Metadata
- Session / iter: 176
- Plan call: "environmental-damage recovery — re-dispatch iter-175's
  7 session-limit-killed lanes verbatim + Lane A1 STRICT one-shot of
  analogist option (a)"
- 8 prover lanes dispatched; all 8 returned task_results.
- Sorry count entering iter-176: 37 (per plan); exiting: 60 sorry
  warnings + 4 elaboration errors → see "Build state" below.

## Build state — BROKEN

`lake build AlgebraicJacobian` exits **non-zero** with 4 errors in
`AlgebraicJacobian/RiemannRoch/OCofP.lean`:

```
OCofP.lean:194:12: failed to synthesize instance IsLocallyNoetherian C.left
OCofP.lean:195:17: failed to synthesize instance IsLocallyNoetherian C.left
OCofP.lean:327:14: failed to synthesize instance IsLocallyNoetherian C.left
OCofP.lean:328:17: failed to synthesize instance IsLocallyNoetherian C.left
```

**Root cause = parallel-lane signature-change race.**

- Lane K (`OCofP.lean`) committed step-002 at 13:51:54Z. It references
  `Scheme.RationalMap.order Q f` in `globalSections_iff` (L194-195) and
  `exists_nonconstant_genusZero` (L327-328).
- Lane D (`WeilDivisor.lean`) committed step-001 at 13:56:23Z — **4
  minutes later**. Lane D added two new instance binders to
  `Scheme.RationalMap.order`:
  ```
  [IsLocallyNoetherian X] [Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]
  ```
- No integration check ran after Lane D's commit. Lane K reported
  "build green" — true at Lane K's commit time, false at iter end.
- `sync_leanok` ran at 14:00:56Z and still added 28 `\leanok` markers,
  including 5 on the chapters touching the broken file. The script
  must have either used a stale `.olean` cache or skipped the broken
  `OCofP.lean`; either way the markers are now ahead of the build.

Two of Lane K's five pinned declarations (`globalSections_iff`,
`exists_nonconstant_genusZero`) do **not** elaborate at all in the
current tree; the other three (`lineBundleAtClosedPoint`,
`h1_vanishing_genusZero`, `dim_eq_two_of_genusZero`) survive as `sorry`
warnings.

## Per-target outcomes

### Lane A1 — `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
- **Status**: INCOMPLETE (0 Step C closures).
- **Sub-task A on `gmScalingP1_chart_PLB_eq`**: option (a) recipe
  inserted **AS WRITTEN** at the right places —
  - L309: `simp only [Fin.isValue, Fin.zero_eta]` (case 0)
  - L341: `simp only [Fin.isValue, Fin.mk_one]` (case 1)
  Fin-normalization fires (LHS `MvPolynomial.X ⟨0, ⋯⟩` reduces to
  `MvPolynomial.X 0`) but the downstream bridge `simp only [Iso.trans_hom,
  …, pullbackSpecIso_hom_base, pullback.lift_fst, …, Category.id_comp]`
  chain leaves 10 of 14 args unused.
- **Diagnosis** (per task_result): a *second* Fin-mismatch is still
  in the chart-map argument — the cover side is
  `(projectiveLineBarAffineCover kbar).openCover.f 0` while the
  pullback-map side wants `Proj.awayι _ (MvPolynomial.X 0) _ Nat.one_pos`.
  These are defeq but syntactically distinct; `rw` of the bridge fails
  with `motive is not type correct`; `change` blows the
  whnf-heartbeat budget.
- **Sub-task B** (cross cases): NOT ATTEMPTED per directive's gating.
- **HARD STOP trigger (per iter-176 plan PROGRESS.md §Decisions)**:
  ARMED. iter-177 same-iter commits to (a) TO_USER.md escalation
  surfacing the temporary-axiom option, and (b) concurrent prover lane
  on `temporary axiom gmScalingP1_constant`. No 6th option-(a) retry.

### Lane B — `AlgebraicJacobian/Picard/RelativeSpec.lean`
- **Status**: closes 5/5 file sorries — but the bodies of `RelativeSpec`
  and `structureMorphism` are placeholders:
  ```
  RelativeSpec _𝒜 := X            -- base scheme itself
  structureMorphism _𝒜 := 𝟙 X     -- identity
  ```
  The three theorems (`UniversalProperty`, `affine_base_iff`,
  `base_change`) all then discharge trivially against the placeholder.
- **Axiom check**: `propext`, `Classical.choice`, `Quot.sound` only
  (per prover task_result `lean_verify` calls).
- **Concern**: this is the kind of close-on-placeholder pattern the
  blueprint chapter `Picard_RelativeSpec.tex` already flags with
  iter-173 `% NOTE:` comments warning that the encoded types are
  weaker than the prose. The proofs are honest given the body; the
  body is not. Genuine `RelativeSpec` requires `Scheme.GlueData` over
  `Spec(𝒜(U))` which isn't formable until the quasi-coherence overlay
  + sheafified-tensor infrastructure lands.
- **Marker action**: added `% NOTE (iter-176 review)` to the proof
  blocks of the three theorems documenting that proofs discharge
  against placeholder bodies. See "Blueprint markers updated
  (manual)" below.

### Lane D — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- **Status**: PRIMARY closed axiom-clean. Sorry count this file 4 → 3.
- `Scheme.RationalMap.order` (L154) body landed as
  `WithZero.log (Ring.ordFrac (X.presheaf.stalk Y.point) f)` per the
  analogist `dvr-rationalmap-order` recipe. Axioms = kernel-only.
- **Side-effect: signature change broke Lane K** — see Build state.
  The signature change matched the iter-175 blueprint pin verbatim,
  so the writer/reviewer chain endorsed it; the integration gap is
  that no iter-176 dispatch step re-checked downstream consumers
  (the only existing one being Lane K's brand-new OCofP file).

### Lane E — `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- **Status**: file-skeleton LANDED. 471 LOC, 7 sorries (4 pinned + 3
  named sub-lemmas + 1 ofCurve corollary; `CoherentSheafFlat` is a
  `def` with non-`sorry` body).
- Type-expressivity audit passes per task_result (no `Iso.refl`,
  `True := trivial`, or `Classical.choice` shortcuts).

### Lane G — `AlgebraicJacobian/Picard/RelPicFunctor.lean`
- **Status**: file-skeleton LANDED. 451 LOC, 6 sorries.
- **Naming conflict surfaced**: blueprint pinned the étale
  sheafification at `AlgebraicGeometry.Scheme.PicScheme`, but Lane I
  (`FGAPicRepresentability.lean`) also uses that name for the
  *representing scheme* (different object). Lane G renamed its
  declaration to `AlgebraicGeometry.Scheme.PicSharp.etSheaf` and
  flagged for blueprint-writer fix iter-177. The `\lean{...}` pin in
  `Picard_RelPicFunctor.tex` for `def:rel_pic_etale_sheafification`
  still points at `AlgebraicGeometry.Scheme.PicScheme` and so is now
  stale. **Marker action**: applied `\lean{}` correction (see below).

### Lane H — `AlgebraicJacobian/Picard/QuotScheme.lean`
- **Status**: file-skeleton LANDED. 6 pinned declarations, all with
  substantive types and `sorry` bodies. Build green for this file.

### Lane I — `AlgebraicJacobian/Picard/FGAPicRepresentability.lean`
- **Status**: file-skeleton LANDED. 5 pinned + 2 cross-file
  placeholders (`picSharp`, `divFunctor`) typed-`sorry` to avoid
  weakening pinned declaration types. Total 7 sorries.

### Lane K — `AlgebraicJacobian/RiemannRoch/OCofP.lean`
- **Status**: file LANDED at Lane-K commit time, but **does not
  compile in the merged tree** (see Build state). 5 pinned
  declarations + module import added. 3 of 5 declarations elaborate;
  2 fail with `failed to synthesize IsLocallyNoetherian C.left`.

## Sorry trajectory (Lane-by-lane)

| Lane | File | Pre | Post (this run's view) | Build-tree view |
|---|---|---|---|---|
| A1 | Genus0BaseObjects/GmScaling.lean | 5 | 5 | 5 |
| B | Picard/RelativeSpec.lean | 5 | 0 (with placeholder bodies) | 0 |
| D | RiemannRoch/WeilDivisor.lean | 4 | 3 | 3 |
| E | Picard/FlatteningStratification.lean | 0 (new) | +7 | 7 |
| G | Picard/RelPicFunctor.lean | 0 (new) | +6 | 6 |
| H | Picard/QuotScheme.lean | 0 (new) | +6 | 6 |
| I | Picard/FGAPicRepresentability.lean | 0 (new) | +7 | 7 |
| K | RiemannRoch/OCofP.lean | 0 (new) | +5 | 3 (other 2 = errors, not sorries) |

Total `lake build`-reported sorry warnings: **60**; would be 62 after
Lane K's signature fix (the 2 OCofP error-line declarations would
re-elaborate as `sorry`-bodied).

Counted against plan expectation: best-case end-of-iter sorries
`≈50–60`, worst-case `≈55`. The 60-with-build-broken outcome is in
the predicted range *numerically* but is a build-regression
qualitatively.

## Key findings / patterns

1. **Parallel-lane signature-change race (NEW pattern)** — when one
   lane edits a `RationalMap.order`-style shared definition and
   another lane in the same dispatch authors a new file that consumes
   it, the loop currently performs no post-merge integration check.
   The first file to commit "wins" the type signature; later
   commits with breaking changes produce errors that the per-lane
   build does not see. See Knowledge Base entry added this iter.

2. **`sync_leanok` ran against a broken build** — markers were added
   to OCofP.tex against declarations that do not elaborate. The
   deterministic phase should have caught this; either it uses
   per-file `lean` (which can succeed against stale `.olean`s) or it
   skipped the unbuildable file. Recommendation: surface to user via
   `recommendations.md`.

3. **Placeholder-body laundering risk (RECURRING)** — Lane B closed
   3 theorems to `\axioms = kernel-only` against
   `RelativeSpec _𝒜 := X` (i.e. the base scheme itself). The proofs
   are honest given that body; the body is not "the relative
   spectrum". `Picard_RelativeSpec.tex` already had 3 iter-173
   `% NOTE:` flags warning of the type-encoding gap; iter-176
   completed the discharge against the placeholder, so the gap
   moved one layer deeper. iter-177 review must ensure no consumer
   relies on the iter-176 closures.

4. **Lane A1 option (a) recipe is empirically unsuitable** — applied
   AS WRITTEN, Fin normalization fires, but a *second* syntactic
   mismatch (cover-side `(cover).openCover.f 0` vs pullback-map-side
   `Proj.awayι _ X_0 _ _`) still blocks the bridge chain. The
   prover diagnosed this concretely; the planner-armed HARD STOP
   trigger now fires for iter-177. Forward-path options are
   recorded in the task_result.

## Recommendations for next session (full text in recommendations.md)

1. **MUST-FIX iter-177 PRIMARY**: restore `lake build AlgebraicJacobian`
   to green. Two options recorded.
2. **HARD STOP trigger fires**: iter-177 must commit to TO_USER.md
   escalation + concurrent temporary-axiom lane on
   `gmScalingP1_constant` per plan-agent's iter-176 commitment.
3. **Tighten placeholder-body discipline**: blueprint review pass on
   Lane B's RelativeSpec consumers.
4. **`sync_leanok` audit**: report to user that the phase added
   markers against a broken build.

## Blueprint markers updated (manual)

- `Picard_RelativeSpec.tex` `proof:relative_spec_univ` (L216–231),
  `proof:relative_spec_affine_base` (L286–290), and
  `proof:relative_spec_base_change` (L360–372): added
  `% NOTE (iter-176 review): proof discharged against placeholder
   body of RelativeSpec (= X) / structureMorphism (= 𝟙 X); the
   downstream theorem TYPES survive but the proofs MUST be re-derived
   once the genuine quasi-coherent-algebra glue construction lands.`
- `Picard_RelPicFunctor.tex` `def:rel_pic_etale_sheafification`
  (L303): corrected `\lean{AlgebraicGeometry.Scheme.PicScheme}` →
  `\lean{AlgebraicGeometry.Scheme.PicSharp.etSheaf}` (Lane G renamed
  to avoid collision with FGA's `PicScheme`).
- `Picard_RelPicFunctor.tex` §"Lean encoding" bullet 5 (L442):
  same `\lean{...}` correction.

Total manual changes: 5 markers (3 `% NOTE:` adds + 2 `\lean{}`
corrections). No `\leanok` added or removed (sync_leanok owns that).

## Subagent skips

- `lean-auditor`: skipped — the lean-auditor's value is on completed
  Lean code; this iter the build is broken (4 errors) and the
  recommended action is "fix the build first, then audit." Running
  the auditor now would conflate signature-mismatch errors with
  authentic code-quality issues. Re-dispatch in iter-177 review
  after the OCofP fix lands.
- `lean-vs-blueprint-checker`: skipped on the 7 lanes that landed
  cleanly because the underlying file-skeleton task is already
  blueprint-derived (the prover's task_results document
  pin-mappings 1:1) and the blueprint-reviewer `iter176-whole`
  ran this plan-phase and cleared HARD GATE for all 8 chapters
  (note: `cleared HARD GATE` is the plan-phase pre-prover check,
  not a post-prover code-vs-blueprint diff). Running per-file
  checkers on 8 file-skeleton landings would re-report what the
  task_results already state. Re-dispatch on a body-fill iter.
