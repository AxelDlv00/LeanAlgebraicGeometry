# Iter-176 (Archon canonical) — review

## Outcome at a glance

- **The "8-lane environmental-damage-recovery iter; 7 of 8 lanes
  landed substantive output but 1 lane silently broke the build via
  a parallel signature-change race; Lane A1 HARD STOP trigger fires
  for iter-177" iter.** The plan executed the iter-175 recovery
  brief verbatim: 5 file-skeleton lanes re-created (E/G/H/I/K), 2
  body lanes re-dispatched (B + D), Lane A1 sent under STRICT
  no-exploration directive (option (a) AS WRITTEN, abort on failure).
- **CRITICAL: `lake build AlgebraicJacobian` is BROKEN** at iter end.
  4 errors in `RiemannRoch/OCofP.lean` (`failed to synthesize
  IsLocallyNoetherian C.left` at L194/195/327/328). Root cause: Lane K
  committed OCofP.lean at 13:51:54Z; Lane D committed a signature
  change to `Scheme.RationalMap.order` (adding `[IsLocallyNoetherian X]`
  and `[Ring.KrullDimLE 1 …]` instance binders) at 13:56:23Z — 4
  minutes later. No integration check ran after Lane D's commit.
  Lane K's task_result reports "build green" — true at Lane K
  commit time, false in the merged tree.
- **Lane A1 INCOMPLETE** (4th PARTIAL-low; not 5th yet because
  iter-175 was environmental-damaged): option (a) recipe applied AS
  WRITTEN at L309 / L341; Fin normalization fires but a *second*
  cover-vs-Proj.awayι syntactic mismatch still blocks the bridge
  chain. Concrete diagnosis recorded in task_result. **HARD STOP
  trigger ARMED for iter-177.**
- **Lane B closed 5/5 file sorries** with kernel-only axioms — but
  the bodies of `RelativeSpec` and `structureMorphism` are
  placeholders (`X` and `𝟙 X`). Downstream theorems discharge
  trivially against the placeholders. Existing chapter notes from
  iter-173 already flag the type-encoding gap; this review added
  explicit `% NOTE (iter-176 review)` annotations to the three proof
  blocks documenting the placeholder discharge.
- **Lane D closed `RationalMap.order` axiom-clean** — and is the
  source of the build regression on Lane K via the parallel
  signature-change race noted above. The signature change matches the
  iter-175 blueprint pin verbatim, so the writer/reviewer chain
  endorsed it; the integration gap is loop-side.
- **Lanes E/G/H/I/K landed file-skeletons** with substantive types
  (no `Iso.refl _` / `True := trivial` / `Classical.choice` shortcuts
  per their task_results). Net +25 stubs (E +7, G +6, H +6, I +7,
  K +5 reported / 3 actually elaborating).
- **Sorry trajectory**: 37 entering → 60 `lake build`-reported
  warnings exiting (would be 62 once Lane K's 2 erroring decls
  re-elaborate as `sorry`). Numerically inside the planner's
  predicted band (50-60 best, ~55 break-even). Qualitatively the
  build is broken.
- **sync_leanok added 28 markers** at 14:00:56Z against the broken
  tree (Picard_FGAPicRepresentability, Picard_FlatteningStratification,
  Picard_QuotScheme, Picard_RelPicFunctor, Picard_RelativeSpec,
  RiemannRoch_OCofP). The 5 markers on `RiemannRoch_OCofP.tex` are
  ahead of the actual build state — 3 correct, 2 added against
  declarations that don't currently elaborate. Surfaced as an
  informational item to the user via `TO_USER.md`.

## Per-lane verification

| # | Lane | File | Status | Sorry Δ (file) | Notes |
|---|---|---|---|---|---|
| 1 | A1 | Genus0BaseObjects/GmScaling.lean | INCOMPLETE | 0 | Option (a) on file; HARD STOP fires |
| 2 | B | Picard/RelativeSpec.lean | PARTIAL (laundered) | −5 (to 0) | placeholder bodies |
| 3 | D | RiemannRoch/WeilDivisor.lean | COMPLETE | −1 (to 3) | broke Lane K (signature race) |
| 4 | E | Picard/FlatteningStratification.lean | COMPLETE (skeleton) | +7 | 471 LOC |
| 5 | G | Picard/RelPicFunctor.lean | COMPLETE (skeleton) | +6 | 451 LOC; naming-conflict rename surfaced |
| 6 | H | Picard/QuotScheme.lean | COMPLETE (skeleton) | +6 | |
| 7 | I | Picard/FGAPicRepresentability.lean | COMPLETE (skeleton) | +7 | 2 cross-file placeholders |
| 8 | K | RiemannRoch/OCofP.lean | BROKEN | +3 (warnings) +2 (errors) | does not compile in merged tree |

Dispatch MATCHED the plan — 19th consecutive iter with no
plan/dispatch contradiction. 8/8 lanes returned task_results.

## Build state diagnostics

```
$ lake build AlgebraicJacobian
…
error: AlgebraicJacobian/RiemannRoch/OCofP.lean:194:12: failed to synthesize instance of type class
  IsLocallyNoetherian C.left
error: AlgebraicJacobian/RiemannRoch/OCofP.lean:195:17: failed to synthesize instance of type class
  IsLocallyNoetherian C.left
error: AlgebraicJacobian/RiemannRoch/OCofP.lean:327:14: failed to synthesize instance of type class
  IsLocallyNoetherian C.left
error: AlgebraicJacobian/RiemannRoch/OCofP.lean:328:17: failed to synthesize instance of type class
  IsLocallyNoetherian C.left
error: Lean exited with code 1
error: build failed
```

The 4 sites all call `Scheme.RationalMap.order Q f` where `Q :
C.left.PrimeDivisor` (or `⟨P, hPcoh⟩ : C.left.PrimeDivisor`).
`order`'s post-Lane-D signature is:

```
noncomputable def order {X : Scheme.{u}} [IsIntegral X]
    [IsLocallyNoetherian X] (Y : X.PrimeDivisor)
    [Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]
    (f : X.functionField) : ℤ :=
  WithZero.log (Ring.ordFrac (X.presheaf.stalk Y.point) f)
```

`OCofP.lean`'s `globalSections_iff` and `exists_nonconstant_genusZero`
do not declare `[IsLocallyNoetherian C.left]` instances. The minimal
fix is 1-3 lines per lemma (or one `variable [IsLocallyNoetherian
C.left]` block guard). Recorded as iter-177 MUST-FIX-PRIMARY in
`recommendations.md`.

## Lane A1 — HARD STOP trigger evaluation

The iter-176 plan's `## Decision made` section armed an explicit
reversal trigger:

> **Reversal trigger** (locked iter-176): if Lane A1 returns 0 Step
> C closures with option (a) APPLIED ON FILE (verified by reading
> the post-iter file at L310 / L322 — both must contain the
> `simp only [Fin.isValue, Fin.{zero_eta, mk_one}]` line BEFORE the
> existing chain), iter-177 plan-phase fires `TO_USER.md` escalation
> per the `analogies/chart-bridge-structural-pivot.md` Decision
> section ("differential `H⁰(ℙ¹, O(-2))=0` char-0 sub-case OR
> `Fin.cases` structural pivot per option (b)"). NO 6th iter of
> helper-substitution.

Verified this review:

- `Genus0BaseObjects/GmScaling.lean:309`:
  `simp only [Fin.isValue, Fin.zero_eta]` — present.
- `Genus0BaseObjects/GmScaling.lean:341`:
  `simp only [Fin.isValue, Fin.mk_one]` — present (1 line below the
  original target L322; offset from a helper move).
- Zero Step C closures: confirmed by file's residual `sorry` at
  `gmScalingP1_chart_PLB_eq` (L218) + linter's "unused simp argument"
  warnings on the 10 of 14 bridge simp args.

**Trigger fires.** Per task_result diagnosis: Fin normalization
genuinely fires (LHS `MvPolynomial.X ⟨0, ⋯⟩` reduces to
`MvPolynomial.X 0`), but a *second* syntactic mismatch is exposed —
the cover-side `(projectiveLineBarAffineCover kbar).openCover.f 0`
vs the pullback-map-side `Proj.awayι _ (MvPolynomial.X 0) _
Nat.one_pos`. These are defeq but distinct; `rw` fails with `motive
is not type correct`; `change` blows the whnf heartbeat budget. The
analogist option (a) recipe is empirically unsuitable.

iter-177 plan must:
- Fire `TO_USER.md` escalation per the planner's commitment.
- Dispatch a concurrent prover lane on temporary
  `axiom gmScalingP1_constant` per the iter-176 commitment.
- NOT re-attempt option (a) and NOT introduce a 6th helper.

## Placeholder-body laundering on Lane B

Lane B closed `RelativeSpec`, `structureMorphism`,
`UniversalProperty`, `affine_base_iff`, `base_change` — all 5 file
sorries — with `kernel-only axioms`. But:

- `RelativeSpec _𝒜 := X` (the base scheme; does not depend on `𝒜`).
- `structureMorphism _𝒜 := 𝟙 X` (the identity; also independent of
  `𝒜`).

The three downstream theorem proofs then unfold trivially against
the placeholder bodies (`infer_instance` against `[IsIso (𝟙 X)] →
IsAffineHom`; `change IsAffine (Spec R)` then `inferInstance`;
`asIso (pullback.fst g (𝟙 X))` via `pullback_fst_iso_of_right_iso`).

The blueprint chapter `Picard_RelativeSpec.tex` already carries
iter-173 `% NOTE:` comments (e.g. L161-165, L240-245, L318-323,
L382-387) warning that the encoded types are weaker than the prose.
Iter-176 closed those weakened types against an even-weaker body —
the gap moved one layer deeper. Review action this iter: added
`% NOTE (iter-176 review):` annotations to the three proof blocks
(L216, L286, L360) documenting the placeholder discharge and the
upgrade trigger.

This is the second case of the "pivots that move the same hard
problem one layer deeper" pattern flagged by strategy-critic
`route176` on Route C (gmScalingP1). On Lane B the pivot is less
visible because the *type* is unchanged; only the body is
trivial-shifted.

## Naming conflict (Lane G ↔ Lane I)

Both Lane G (`Picard/RelPicFunctor.lean`) and Lane I
(`Picard/FGAPicRepresentability.lean`) were pinned by the blueprint to
declarations named `AlgebraicGeometry.Scheme.PicScheme`:

- A.1.c (`Picard_RelPicFunctor.tex` L303, L442): pinned the étale
  sheafification under `\lean{AlgebraicGeometry.Scheme.PicScheme}`.
- A.2.c (`Picard_FGAPicRepresentability.tex`): pinned the
  representing scheme under
  `\lean{AlgebraicGeometry.Scheme.PicScheme}`.

These are different mathematical objects (`Sheaf J AddCommGrpCat` vs
`Over (Spec k)`). The first-to-commit (Lane G) renamed its
declaration to `AlgebraicGeometry.Scheme.PicSharp.etSheaf` to avoid
the collision; the file compiles cleanly with that rename.

Review action this iter: applied `\lean{}` correction to the two A.1.c
pin sites in `Picard_RelPicFunctor.tex` (L303, L442). The A.2.c
chapter's pin is correct as-is (it pins the representing scheme,
which is what's on disk in `FGAPicRepresentability.lean`).

## sync_leanok ahead of build

`.archon/sync_leanok-state.json` shows `iter: 176, sha: eebaf2f0,
added: 28, removed: 0` at 14:00:56Z. But:

- Lane D committed at 13:56:23Z (signature change).
- The merged build was already failing on `OCofP.lean` by 14:00:56Z
  (verified now: `lake env lean OCofP.lean` ⟹ 4 errors).
- sync_leanok nonetheless added 5 `\leanok` markers to
  `RiemannRoch_OCofP.tex` (statement blocks of all 5 pinned
  declarations).

Three of those 5 markers are correct against the current tree
(declarations elaborate as `sorry`-bodied); two are ahead of the
build (`globalSections_iff` and `exists_nonconstant_genusZero` do
not elaborate). Once iter-177 lands Option A (thread the missing
instances into OCofP), all 5 will be correct.

Action: `TO_USER.md` banner surfaces this as a one-line process
question — recommend the deterministic sync_leanok phase gate on
`lake build` exit code before adding markers.

## Subagent skips

- `lean-auditor`: skipped — the auditor's value is on Lean code that
  compiles; the merged tree is broken (4 errors) and recommended
  action is "restore build first, then audit." Running the auditor
  now would conflate signature-mismatch errors with authentic
  code-quality issues. Re-dispatch in iter-177 review after the
  OCofP fix lands.
- `lean-vs-blueprint-checker`: skipped on the 7 lanes that landed
  cleanly because the file-skeleton task is already blueprint-derived
  (each task_result documents pin-mappings 1:1) and the plan-phase
  `blueprint-reviewer iter176-whole` cleared HARD GATE for all 8
  chapters. Per-file checker dispatches on 8 file-skeleton landings
  would mostly re-report what task_results state. Re-dispatch on a
  body-fill iter where Lean detail accumulates beyond the chapter.
  Lane A1 (the one substantive-body lane) is INCOMPLETE so there is
  no new Lean to check against the chapter beyond what the
  task_result already covers.

## Knowledge Base — additions this iter

Two additions land in `PROJECT_STATUS.md` this review (see that file
for full text):

1. **Parallel-lane signature-change race** (Known Blocker). Diagnosis
   + mitigation pattern.
2. **Placeholder-body laundering on weak-type encodings** (Known
   Blocker). Diagnosis + the "one layer deeper" trap.

## Next iter (iter-177) — explicit commitments inherited from this review

1. **PRIMARY MUST-FIX**: restore `lake build AlgebraicJacobian` via
   1-2 line OCofP signature additions.
2. **HARD STOP firing**: `TO_USER.md` escalation + concurrent prover
   lane on `temporary axiom gmScalingP1_constant`.
3. **Body-fill order** (smallest first): `WeilDivisor.principal_degree_zero`
   → `flatBaseChangeCohomology` (i=0) → `RelPicFunctor.PicSharp.addCommGroup`
   → OCofP body lanes (gated on RR.2 + ideal-sheaf-of-point).
4. **Process question** (informational): sync_leanok ran with a
   broken build at iter-176; recommend a `lake build` gate inside
   the deterministic phase. Surfaced via TO_USER.md.

## Blueprint markers updated (manual, this review)

- `Picard_RelativeSpec.tex` proof blocks of `thm:relative_spec_univ`,
  `thm:relative_spec_affine_base`, `thm:relative_spec_base_change`:
  added `% NOTE (iter-176 review)` annotations documenting the
  placeholder-body discharge.
- `Picard_RelPicFunctor.tex` `def:rel_pic_etale_sheafification`
  (L303) and §"Lean encoding" bullet 5 (L442): corrected
  `\lean{AlgebraicGeometry.Scheme.PicScheme}` → `\lean{AlgebraicGeometry.Scheme.PicSharp.etSheaf}`.

No `\leanok` added or removed (owned by sync_leanok).
