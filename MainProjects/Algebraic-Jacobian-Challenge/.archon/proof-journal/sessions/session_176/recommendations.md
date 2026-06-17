# Recommendations — iter-177 plan agent

## CRITICAL — must-fix before any new prover work

### 1. Restore the build (`lake build AlgebraicJacobian` exits non-zero)

Four errors in `AlgebraicJacobian/RiemannRoch/OCofP.lean`:

```
L194:12  failed to synthesize  IsLocallyNoetherian C.left
L195:17  failed to synthesize  IsLocallyNoetherian C.left
L327:14  failed to synthesize  IsLocallyNoetherian C.left
L328:17  failed to synthesize  IsLocallyNoetherian C.left
```

Caused by a parallel-lane signature-change race: Lane D
(WeilDivisor.lean) added `[IsLocallyNoetherian X]` and
`[Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]` instance binders to
`Scheme.RationalMap.order`; Lane K (OCofP.lean) — committed 4 minutes
earlier — calls `Scheme.RationalMap.order Q f` in
`globalSections_iff` (L194-195) and `exists_nonconstant_genusZero`
(L327-328) without those instances in scope.

**Recommended fix (preferred — Option A)**: thread the two instances
into `OCofP.lean`'s `variable` block (or per-lemma binders for the
two affected declarations). The change is 1-3 lines per lemma and
matches Lane D's intent + the iter-175 blueprint pin for `order`'s
signature.

**Alternative (Option B, NOT recommended)**: revert Lane D's signature
change. This unwinds an axiom-clean closure and disagrees with the
blueprint pin, so should only be considered if Option A breaks the
type-class system elsewhere.

Action: dispatch a 1-iter prover lane on `OCofP.lean` with helper
budget 0 and scope `add IsLocallyNoetherian / Ring.KrullDimLE 1
instance binders where needed to restore compilation` BEFORE any
body-fill lane on the iter-176 file-skeletons (E/G/H/I/K).

### 2. HARD STOP trigger fires for Lane A1 (per planner's iter-176 commitment)

The iter-176 plan armed an explicit reversal trigger:

> If Lane A1 returns 0 Step C closures with option (a) APPLIED ON
> FILE (verified by reading post-iter `GmScaling.lean` at L310/L322
> — both must contain the `simp only [Fin.isValue, …]` line BEFORE
> the existing chain), iter-177 SAME-ITER commits to (a) `TO_USER.md`
> escalation per `analogies/chart-bridge-structural-pivot.md`
> Decision section ("differential `H⁰(ℙ¹, O(-2))=0` char-0 sub-case
> OR `Fin.cases` structural pivot per option (b)"). NO 6th iter of
> helper-substitution.

Verified this review: option (a) is on file at L309 / L341 (line
shift from L310 / L322 due to a helper move); zero Step C closures.
**The trigger fires.** iter-177 plan must:

- Surface `TO_USER.md` banner asking the user to pick between
  (i) char-0 differential alternative `H⁰(ℙ¹, O(-2))=0`,
  (ii) `Fin.cases` structural pivot per analogist option (b),
  (iii) temporary `axiom gmScalingP1_constant` shortcut to unblock
       the genus-0 witness arm.
- Concurrently, dispatch a prover lane on the temporary-axiom path
  per the planner's iter-176 §Decisions made point 1(b).
- Do NOT re-run option (a). The recipe is empirically unsuitable
  (Fin normalization fires but a second cover-vs-Proj.awayι
  syntactic mismatch still blocks the bridge).

### 3. `sync_leanok` ran against a broken build — markers may be stale

`.archon/sync_leanok-state.json` reports `iter: 176` with 28 added
markers (sha `eebaf2f0`, 2026-05-23T14:00:56Z). But `lake build
AlgebraicJacobian` was already failing at that timestamp (Lane D
committed at 13:56:23Z; Lane K's broken OCofP at 13:51:54Z). The
script must either be using a stale `.olean` cache for downstream
files or skipping unbuildable ones.

The 5 `\leanok` markers added to `RiemannRoch_OCofP.tex` (statement
blocks of all 5 pinned declarations) are correct for the 3
declarations that elaborate (`lineBundleAtClosedPoint`,
`h1_vanishing_genusZero`, `dim_eq_two_of_genusZero`) but
incorrect for the 2 that error out (`globalSections_iff`,
`exists_nonconstant_genusZero`). After Option A above lands, all 5
will be correct; until then iter-177 plan should treat the OCofP
`\leanok` as provisional.

Action: surface this as a process question for the user via
`TO_USER.md` (one line — "sync_leanok ran with a broken build at
iter-176; markers are ahead of compilation. Recommend a `lake build`
gate in the sync_leanok script.").

## HIGH — placeholder-body laundering on Lane B (RelativeSpec)

Lane B closed 5/5 sorries in `Picard/RelativeSpec.lean`, but the
bodies of `RelativeSpec` and `structureMorphism` are placeholders:

```
RelativeSpec _𝒜 := X            -- the base scheme itself
structureMorphism _𝒜 := 𝟙 X     -- the identity morphism
```

The three downstream theorems (`UniversalProperty`,
`affine_base_iff`, `base_change`) then discharge trivially. The
prover explicitly flagged this and the existing
`Picard_RelativeSpec.tex` has iter-173 `% NOTE:` comments warning
the encoded types are weaker than the prose. This review added
explicit `% NOTE (iter-176 review):` annotations to all three proof
blocks documenting that the proofs discharge against the placeholder
body.

**Action for iter-177+**: when the quasi-coherent-algebra glue
construction lands (Stacks 01LR / 01LS — needs `Scheme.GlueData`
over `Spec(𝒜(U))` + quasi-coherence overlay + sheafified tensor),
**both bodies upgrade AND all three proofs MUST be re-derived**. Do
not allow downstream files (Picard_LineBundlePullback,
Picard_RelPicFunctor, Picard_FGAPicRepresentability) to consume the
iter-176 closures without an explicit re-check after the body
upgrade.

Strategy-critic `route176` made the parallel call about the same
underlying pattern on Route C (gmScalingP1): "pivots that move the
same hard problem one layer deeper rather than introducing a
different mathematical reduction." Lane B's iter-176 closure is the
same shape — the *type* is unchanged but the *body* is now further
from the genuine construction.

## HIGH — Knowledge Base addition: parallel-lane signature-change race

Add a Known Blocker / Proof Pattern pair to PROJECT_STATUS.md:

- **Pattern**: when a prover lane edits a shared declaration's
  signature, every other lane in the same iter that consumes that
  declaration sees the *pre-edit* signature (because lanes run in
  parallel). The first-to-commit shape wins; later commits with
  breaking changes produce errors that no per-lane build catches.
- **Mitigation**: planner should EITHER serialize signature-changing
  lanes (don't co-dispatch them with consumer-authoring lanes) OR
  require a final post-merge `lake build` check inside the loop with
  an automatic same-iter repair pass.
- **Caught here**: Lane D + Lane K iter-176.

## MEDIUM — blueprint hygiene from this iter

- **OCofP.lean is named in `RiemannRoch_OCofP.tex`'s `% archon:covers`**
  (the iter-174 chapter covers L1) — blueprint-doctor will stop
  flagging this once iter-177's build fix lands.
- **Picard_RelPicFunctor.tex `\lean{}` correction already applied this
  review**: `def:rel_pic_etale_sheafification` now points at
  `AlgebraicGeometry.Scheme.PicSharp.etSheaf` (was the colliding
  `PicScheme`). Verify on next plan-phase blueprint-reviewer pass.

## MEDIUM — body-fill candidates for iter-177+ (after build fix)

Per progress-critic `route176` Route 2/3 CONVERGING + the file-skeleton
landings, the smallest body lanes are:

1. **`WeilDivisor.principal_degree_zero`** (Lane D, post-PRIMARY) —
   `WithZero.log_one` + finsum collapse. ~5-10 LOC.
2. **`flatBaseChangeCohomology` (i=0 form)** (Lane H) —
   `Scheme.Modules.pullbackPushforwardAdjunction` + flatness reduction.
   ~50-100 LOC.
3. **`RelPicFunctor.PicSharp.addCommGroup`** (Lane G) — `QuotientAddGroup`
   once `LineBundle.OnProduct` unpacks.
4. **`OCofP.dim_eq_two_of_genusZero`** — pure arithmetic specialisation
   of `Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus`
   (RR.2) — but **gated on RR.2's body landing first**.
5. **`OCofP.exists_nonconstant_genusZero`** — pure assembly once
   `dim_eq_two_of_genusZero` lands.

Defer the deep bodies: `genericFlatness` (Lane E, Nitsure §4),
`Grassmannian` (Lane H, Nitsure §1), `PicScheme.representable`
(Lane I, four-step Kleiman §4), `lineBundleAtClosedPoint` (Lane K,
ideal-sheaf-of-closed-point + Hom-dual).

## LOW — do NOT retry on these targets

- **`gmScalingP1_chart_PLB_eq` Step C cases via option (a)** — the
  recipe is empirically unsuitable (see HARD STOP above).
- **`gmScalingP1_chart_agreement` cross cases** — gated on Step C
  closing; do not attack while Step C is blocked.
- **iter-175 environmental re-strike on the same 7 lanes** — all
  re-dispatched this iter landed; mark Lane F (AuslanderBuchsbaum)
  + Lane J (Thm32) as already-landed iter-175 work, not
  re-dispatchable.

## NEW INFORMATIONAL

- Strategy-critic `route176` returned CHALLENGE on BOTH Routes A + C
  with 5 infrastructure-deferral findings + sunk-cost flag on
  gmScalingP1 + effort-estimate inconsistency (claimed ~50-95 iters
  but with realized 50 LOC/it the same LOC band lands at ~180-320
  iters). Planner acted on most of these in STRATEGY.md restructure
  this iter; Open Question of "axiomatise-then-replace staging"
  remains TRACKED but not COMMITTED. iter-177's HARD STOP firing on
  Lane A1 may force a decision on this earlier than the iter-180
  trigger.
- Blueprint-doctor flags 3 chapter-coverage warnings for chapters
  whose Lean files don't yet exist: `Albanese_AlbaneseUP.lean`,
  `Albanese_CodimOneExtension.lean`, `RiemannRoch_RationalCurveIso.lean`.
  These are file-skeleton-deferral items per iter-176 plan's iter-177
  commitment list (point 4). Informational only; no action required
  this iter.
