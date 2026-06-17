# Progress Critic Directive — iter-139

## Slug

iter139

## Iter

139

## Active routes / files under review

### Route: Piece (i.b) Step 2 — `Cotangent/GrpObj.lean` `relativeDifferentialsPresheaf_basechange_along_proj_two`

- **Started at iter**: 134 (the iter-135 honest-scaffold body was
  installed as a 1-sorry placeholder; iter-137 PARTIAL diagnostic-
  only; iter-138 PARTIAL with substantive body cut).
- **Iters audited**: iter-134 → iter-138 (K=5).

#### Sorry counts per iter

(File-level sorry count in `Cotangent/GrpObj.lean`. Project total in
parens.)

- iter-134: 3 in GrpObj (5 project). 3 hollow placeholders shipped
  (Steps 2/3/Main) alongside Step 1's substantive close.
- iter-135: 3 in GrpObj (5 project). Refactor REPLACED 3 hollow
  placeholders with honest sorry-bodied scaffolds (signatures
  retyped against intended sheaf-level RHS via
  `Scheme.Hom.toRingCatSheafHom`).
- iter-136: 2 in GrpObj (4 project + 1 RigidityKbar + 2 Jacobian, 
  but Step 3 closed substantively this iter). After iter-136 close:
  2 in GrpObj (Step 2 + Main remain), 5 project.
- iter-137: 2 in GrpObj (5 project). Lane PARTIAL — 4 docstring
  edits, 0 code edits, 0 new declarations. Validated typeable
  Route (b) skeleton at code-comment level only.
- iter-138: **3 in GrpObj** (decls using sorry = 3 in GrpObj because
  the helper carries 2 inner sorries; **4 inline sorries** in GrpObj
  at L581 + L585 + L624 + L752). 6 project decls using sorry / 7
  inline sorries. Lane PARTIAL with substantive body cut — Route (b)
  skeleton landed end-to-end; d_add + d_mul of pointwise derivation
  closed honestly; d_app + d_map + IsIso remain.

#### Helpers added per iter

- iter-134: `shearMulRight` + 3 companion lemmas (`_hom_fst`,
  `_hom_snd`, `schemeHomRingCompatibility`) + helper `lift_helper`.
  Step 1 of piece (i.b) substantively closed via these (~50 LOC
  kernel-only).
- iter-135: 0 new declarations (REFACTOR: 3 hollow placeholder
  bodies → 3 honest sorry-bodied scaffolds with retyped signatures).
- iter-136: 1 new helper `section_snd_eq_identity_struct` (~5 LOC).
  Step 3 (`_restrict_along_identity_section`) closed substantively.
- iter-137: 0 new declarations (4 docstring edits only).
- iter-138: 2 new helpers (`basechange_along_proj_two_inv_derivation`
  with 2 internal sub-sorries, `basechange_along_proj_two_inv`
  sorry-free) + main body refactored to use them. ~92 LOC body +
  ~50 LOC docstring.

#### Prover statuses per iter

- iter-134: COMPLETE (Step 1 substantively closed; Steps 2/3/Main
  shipped as hollow placeholders, a structural decision pre-iter-135
  refactor).
- iter-135: COMPLETE (refactor lane; replaced placeholders with
  honest scaffolds).
- iter-136: COMPLETE (Step 3 substantively closed).
- iter-137: PARTIAL (no code edits; iter-137 mathlib-analogist's
  5-step recipe blocked at recipe Step 2 chart-opacity; iter-137
  prover validated Route (b) inverse-direction-via-adjunction-
  transpose skeleton as compiling-typeable at code-comment level
  only — no actual body edits because adoption would have added +1
  sorry, exceeding the iter-137 PARTIAL ceiling).
- iter-138: PARTIAL with substantive body cut (Route (b) skeleton
  landed end-to-end; d_add + d_mul closed; d_app + d_map + IsIso
  remain).

#### Recurring blocker phrases

- "`PresheafOfModules.pullback` chart-opacity" / "no Mathlib
  pullback-on-obj rewrite" — appears in iter-137 + iter-138 prover
  reports. **Iter-137 ⇒ iter-138 was not "same blocker; same
  approach": iter-138 sidestepped the blocker by pivoting to Route
  (b)** (which uses `pushforward` transparency instead of unfolding
  `pullback`). The iter-138 progress-critic codified this as
  "single-blocker-doubling rule applies to the unchanged-approach
  case, not the changed-approach case" — confirm or contest this
  ruling.
- "`simp` does not beta-reduce inside `Derivation.mk` lambdas" —
  surfaced iter-138 prover only; not a recurring blocker (knowledge-
  base candidate this iter).

#### Planner's current proposal for this iter

- **Iter-139 prover lane on
  `Cotangent/GrpObj.lean`**: close the two derivation sub-sorries
  (d_app at L581 + d_map at L585) in a single prover lane. Estimated
  ~60–160 LOC total. PARTIAL trigger if only one of the two closes;
  ITER-139 COMPLETE requires both. Side-effect cleanups to fold in:
  drop "Iter-139+ target" deferral comments per
  `lean-auditor-review138` CRIT-A; rewrite L483–487 framing-
  overstatement block per CRIT-B.
- **Parallel Wave 2 dispatch**: `mathlib-analogist` consult on
  Route (a) chart-unfolding-helper vs Route (b'2) local-iso check
  for closing the `IsIso` sub-sorry at L624 (iter-140 target). The
  choice is non-obvious and has long-term blueprint shape
  implications.
- **Off-limits this iter**: `mulRight_globalises_cotangent` (Main,
  gated on Step 2 full closure i.e. all 3 sub-sorries closed);
  `RigidityKbar.lean:87 rigidity_over_kbar` (gated on Step 2 +
  pieces (i.c)+(ii)+(iii) pile); `Jacobian.lean` 2 sorries (M2.b
  schedule iter-151+).

## Out of scope

The route `M3 positiveGenusWitness` is deliberately off-critical-
path (user-escalation-RESOLVED iter-126, no schedule); the route
`M2.b genusZeroWitness` body is iter-151+ schedule (after M2.a body
closes). Do not assess these.

## Your task

Render a CONVERGING / CHURNING / STUCK / UNCLEAR verdict on Route
"Piece (i.b) Step 2" per your rubric, using only the signals above.

Specific points the iter-138 progress-critic flagged that you should
re-evaluate:

1. **iter-138 verdict was "CONVERGING-with-caveat"** (per iter-138
   review.md): "substantive structural decomposition is convergence-
   shaped (the 3 narrowly-scoped sub-sorries are independently
   dispatchable), but the auditor's 'framing overstatement' finding
   + 'fully sorry-supported' verdict on the iso is a legitimate
   caveat to the CONVERGING reading." Iter-139 should re-evaluate
   whether the structural decomposition has actually advanced the
   route, or whether it's "1 hollow sorry → 3 narrowly-scoped
   sorries with no mathematical content verified" (the auditor's
   read).

2. **3 of the last 5 prover statuses were PARTIAL** (iter-137 +
   iter-138 are 2 of last 2). Your CHURNING rule says: "PARTIAL
   prover status ≥3 of last K iters." Iter-134 was COMPLETE on
   Step 1 only; the Step 2 / Main / Step 3 cluster was hollow-
   placeholder-shipped. Counting backward: iter-138 PARTIAL,
   iter-137 PARTIAL, iter-136 COMPLETE (Step 3), iter-135 COMPLETE
   (refactor), iter-134 COMPLETE (Step 1). On Step 2 alone, the
   relevant window is iter-137 + iter-138 = 2 PARTIAL in a row. Is
   that the "3-of-last-5 PARTIAL" trigger, or a 2-in-a-row pattern
   that needs one more iter to resolve?

3. **Sorry trajectory on the Step 2 target alone**: iter-134 hollow
   placeholder (1 sorry) → iter-135 honest scaffold (1 sorry) →
   iter-137 unchanged (1 sorry) → iter-138 decomposed (3 sub-sorries
   replacing the 1 main scaffold sorry). The aggregate count
   increased +2 on Step 2 alone; the iter-138 planner-side rebuttal
   is "structural decomposition is mid-route progress." Is the
   rebuttal sound?

4. **Helper accumulation across the Step 2 window**: iter-134 added
   helpers for Step 1 (off-target for Step 2). iter-135 0 helpers.
   iter-136 1 helper for Step 3 (off-target). iter-137 0 helpers.
   iter-138 2 helpers for Step 2 (the iter that finally targeted
   Step 2 with code edits). So Step 2 itself has had ONE iter of
   helper accumulation (iter-138). That is not "helpers added
   without sorry-elimination across K iters" — it's the helper
   construction iter of a route that has been preparing the
   approach for 4 iters of analysis.

5. **The CHURNING corrective the iter-138 progress-critic named was
   `mathlib-analogist` consult on Route (a) vs Route (b'2) before
   iter-140 IsIso dispatch.** The iter-139 plan agent has adopted
   this as the parallel Wave 2 dispatch. **You should consider
   whether this satisfies the iter-138 progress-critic's
   recommendation, or whether more is needed.**

## Verdict format

Apply your standard rubric verbatim. If CONVERGING, name what the
next 1–2 iters should look like. If CHURNING or STUCK, name the
ONE primary corrective. Watch criteria for iter-140 may be
appended.
