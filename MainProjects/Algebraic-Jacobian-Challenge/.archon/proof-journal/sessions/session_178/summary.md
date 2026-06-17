# Session 178 — Review of iter-178

## Metadata

- Session / iter: **178** (matches; `session_178/` reviews iter-178).
- Plan headline: "post-HARD-STOP recovery + 2 reversal-trigger
  consults + parallel-signature-race process change + 7 prover lanes".
- 7 prover lanes dispatched; all 7 returned task_results.
- Sorry count entering iter-178: 71 sorry warnings + **1 elaboration
  error** in `OCofP.lean:335` (per iter-177 close).
- Sorry count exiting iter-178: **70 sorry warnings, 0 errors**
  (`lake build AlgebraicJacobian` green).
- **Net per-iter delta**: −1 sorry, **build restored** (was broken
  2 consecutive iters).

## Build state — GREEN (parallel-race streak broken)

`lake build AlgebraicJacobian` completes with `Build completed
successfully (8355 jobs)`. The 4-minute parallel-signature-race
that broke iter-176 and iter-177 was averted this iter: the iter-178
plan-agent's "signature-mutating lane" process-change checklist
correctly identified Lane 5 RationalCurveIso as the only mutating
lane and verified no current consumer of `iso_of_degree_one` would
break. Lane 1 FIX-BUILD #2 closed the iter-177 carry-over error
with the 1-LOC instance-binder threading the directive prescribed.

This is the first green build in 3 iters.

## Per-lane outcomes

### Lane 1 — FIX-BUILD #2 (`RiemannRoch/OCofP.lean`) — **RESOLVED**

**Status**: complete, kernel-clean (build only — no body changes).

- Threaded `[Scheme.IsRegularInCodimensionOne C.left]` into the
  `lineBundleAtClosedPoint` namespace `variable` block (one line
  added at L157, alongside the iter-177 `[IsLocallyNoetherian
  C.left]`).
- `lake build AlgebraicJacobian` 0 errors; file warnings exactly
  the 5 pre-existing typed sorries.
- Helper budget: 0 used / 0 allowed.
- Out-of-scope: 5 body sorries untouched per directive.

### Lane 2 — AVR-IOTAGM (`AbelianVarietyRigidity.lean`) — **PARTIAL**

**Status**: not closed; advance is structural-only.

- Directive's recipe (`exact IsOpenImmersion.isDominant _`) does NOT
  work — Mathlib has no `IsOpenImmersion → IsDominant` lemma. Verified
  via `lean_local_search`, `lean_loogle`, `lean_leansearch`, exhaustive
  mathlib grep. **Dead-end recorded — future plans should drop the
  one-liner framing.**
- Attempts: (1) `exact IsOpenImmersion.isDominant _` → lemma absent;
  (2) `Surjective` route via `instIsDominantOfSurjective` → composition
  is NOT surjective (image is `Gm ⊂ ℙ¹`, missing `0` and `∞`);
  (3) `DenseRange.comp` factorisation → lift factor `(lift _ _).left`
  is a closed immersion, not dominant; (4) `IrreducibleSpace
  (ProjectiveLineBar kbar).left` via
  `IsOpenMap.denseRange_of_isPreirreducibleSpace` → `infer_instance`
  fails, `IrreducibleSpace Proj` is itself a missing Mathlib bridge.
- Final state: term-mode `:= sorry` → tactic-mode `by sorry` after
  reducing `IsDominant` to `DenseRange` via `refine ⟨?_⟩`. Sorry
  count file 2 → 2 (unchanged).
- Axiom check: `lean_verify AlgebraicGeometry.iotaGm_isDominant`
  reports `{propext, sorryAx, gmScalingP1_chart_data_temp,
  Classical.choice, Quot.sound}` — **NO new project axioms**.
- **Iter-179+ path**: route (a) chart-1 factorisation
  (`iotaGm = Spec.map (alg k̄[u] k̄[t,t⁻¹]) ≫ Proj.awayι _ X 1 _ _`)
  + per-factor open-immersion → open-map → dense-range chain.
  Gated on `gmscaling-cover-bridge` consult body lands.

### Lane 3 — WD-DEGREE (`RiemannRoch/WeilDivisor.lean`) — **PARTIAL**

**Status**: constant branch closed axiom-clean; non-constant branch
deferred (clearly factored).

- Approach: case-split via `by_cases hconst : ∀ Y,
  Scheme.RationalMap.order Y f = 0` on the symptom (cleaner than the
  `∃ c, algebraMap c = f` algebra-tower-based split which would have
  required ~40-60 LOC of substrate work).
- **Constant branch (PROVEN)**: from `hconst`, `principal f hf = 0`
  via `Finsupp.ext` + `change` defeq through
  `Finsupp.ofSupportFinite_coe`; close `degree = 0` via
  `Finsupp.sum_zero_index`.
- **Non-constant branch (DEFERRED)**: requires Pin 1 of Lane 5
  (`morphismToP1OfGlobalSections`) + Hartshorne II.6.9 degree
  multiplicativity (Mathlib gap).
- Axioms: `{propext, sorryAx, Classical.choice, Quot.sound}` — the
  `sorryAx` propagates from the non-constant branch only.
- Sorry count file 2 → 2 (one sorry now PARTIAL rather than bare).
- Dead end documented: direct `Algebra kbar C.left.functionField`
  synthesis fails — `Spec (CommRingCat.of kbar)`'s function-field
  algebra instance needs `[IsDomain kbar]` registered AND
  `C.hom : C.left ⟶ Spec (.of kbar)` does NOT auto-propagate
  algebra towers downstream. The symptom-based case-split sidesteps
  this entirely.

### Lane 4 — CodimOne-BODIES (`Albanese/CodimOneExtension.lean`) — **PARTIAL+RESOLVED**

**Status**: 1 sorry closed kernel-clean, 1 reduced to a single
named helper sorry capturing the substantive Mathlib gap.

- `extend_iff_order_nonneg` — **RESOLVED axiom-clean** via
  `rw [Scheme.RationalMap.mem_domain]` + 1-line swap-pair `Iff.intro`
  (Mathlib `mem_domain` reorders the conjuncts relative to project's
  pin signature; ~3 LOC).
- `localRing_dvr_of_codim_one` — **PARTIAL**: main body via
  `IsDiscreteValuationRing.TFAE` (`tfae.out 0 4`); typeclass scaffold
  threaded (`IsLocallyNoetherian`, `IsNoetherianRing` of stalk,
  `IsLocalRing`, `IsDomain`, `¬ IsField`). 1 named helper
  `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` carries
  the geometric content `(Smooth ⟹ IsRegularLocalRing) +
  (coheight = 1 ⟹ KrullDim = 1) ⟹ principal nonzero max ideal` —
  this is the entire Mathlib gap. Once Mathlib ships the
  `Smooth → IsRegularLocalRing` bridge (Stacks 00TT/00TX) or an
  `IsSmoothAt` → `IsRegularLocalRing` adapter, the helper body
  becomes ~10 LOC.
- Helper budget: 1 / 1.
- Sorry count file 4 → 3 (net −1; target was −2 but the
  Mathlib-gap-factoring is honest).
- Out-of-scope per directive: `extend_of_codimOneFree_of_smooth`,
  `indeterminacy_pure_codim_one_into_grpScheme` untouched.

### Lane 5 — RatCurveIso-FIX+BODY (`RiemannRoch/RationalCurveIso.lean`) — **PARTIAL+RESOLVED**

**Status**: signature mutation (Part A) landed; body attempt
(Part B) is structural-partial pending iter-179 signature
mutation.

- **Part A — `iso_of_degree_one` signature fix (RESOLVED)**: changed
  `_hφ_ff : Nonempty (C'.left.functionField ≅ C.left.functionField)`
  (Type-iso between two `Type u` fields — substantively trivial since
  any two infinite fields are set-isomorphic by cardinality) to
  `Nonempty (C'.left.functionField ≃+* C.left.functionField)`
  (`RingEquiv`, the intended meaning). 1 LOC.
- Downstream-consumer audit per iter-178 plan: only
  `genusZero_curve_iso_P1` (AVR L290, currently bare `sorry`) chains
  `iso_of_degree_one`. No current breakage.
- **Part B — `morphismToP1OfGlobalSections` body (PARTIAL)**: the
  morphism is constructed *concretely* as `Over.homMk
  (Proj.fromOfGlobalSections (projectiveLineBarGrading kbar) f _hf)`
  via the `pointOfVec` template. The `IsScalarTower` `haveI` required
  explicit `(R := kbar) (S := ↥(...)) (A := MvPolynomial ...)`
  annotations (Lean defaults to `IsScalarTower A A A` otherwise — a
  reusable trap).
- After the `Proj.fromOfGlobalSections_toSpecZero` rewrite chain,
  the residual goal
  `X.left.toSpecΓ ≫ Spec.map (CommRingCat.ofHom (f.comp
  MvPolynomial.C)) = X.hom` is **mathematically undischargeable
  from the current signature** — `f` carries no `kbar`-algebra
  compatibility hypothesis. Iter-179+ recommendation: signature
  mutation adding `halg : f.comp (algebraMap kbar (MvPolynomial
  (Fin 2) kbar)) = (X.hom.appTop).comp (Scheme.ΓSpecIso _).inv.hom`.
- Sorry count file 3 → 3 (Part B's residual sorry replaces the
  prior bare sorry, but the body shape now concrete).
- Dead-end recorded: `simp [Scheme.toSpecΓ, X.hom]` hits
  `maximum recursion depth` on `ΓSpec.adjunction_unit_app`;
  `Scheme.toSpecΓ_naturality_apply` is unknown (only the
  morphism-specialised `Scheme.toSpecΓ_naturality` exists).

### Lane 6 — QS-IsIso (`Picard/QuotScheme.lean`) — **PARTIAL (structural)**

**Status**: structural advance via `Scheme.Modules.Hom.isIso_iff_isIso_app`;
substantive content factored into one named helper.

- `canonicalBaseChangeMap_isIso` body is now a one-liner
  `Scheme.Modules.Hom.isIso_iff_isIso_app.mpr (fun U => ...)`
  applied to a new named helper
  `canonicalBaseChangeMap_app_app_isIso` (typed `IsIso` at section
  level, body sorry). Type carries the Stacks 02KH(ii) section
  claim — non-tautological.
- Sorry count file 6 → 6 (one retired from main, one new in helper).
- Axiom hygiene: `lean_verify
  AlgebraicGeometry.canonicalBaseChangeMap_isIso` reports
  `{propext, sorryAx, Classical.choice, Quot.sound}` — sorryAx
  propagates from helper only; **no new project axioms**.
- Helper budget: 1 / 2.
- Out-of-scope: 5 file-skeleton sorries (`hilbertPolynomial`,
  `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`,
  `QuotScheme`) untouched (gated on Nitsure §5).

### Lane 7 — AB-PROJDIM (`Albanese/AuslanderBuchsbaum.lean`) — **RESOLVED**

**Status**: complete kernel-clean (one-line body).

- `Module.projectiveDimension` body is the concrete one-liner
  `CategoryTheory.projectiveDimension (ModuleCat.of R _M)`
  (`Mathlib/CategoryTheory/Abelian/Projective/Dimension.lean:265`).
  `Abelian (ModuleCat R)` auto-resolves.
- Axiom check: `{propext, Classical.choice, Quot.sound}` —
  **kernel-only**.
- Sorry count file 6 → 5 (target −1 hit).
- Helper budget: 0 / 0.

## Cross-cutting findings

### Parallel-signature-race process change WORKED

The iter-178 plan's "signature-mutating lane" checklist correctly
classified Lane 5 as signature-mutating, audited zero current
downstream consumers, and dispatched Lane 5 without breaking the
build. First post-checklist iter with green-build outcome.
Recommend keeping the checklist in the planner's permanent
recipe.

### Dead-end recipe: `IsOpenImmersion → IsDominant`

The iter-178 plan-agent's Lane 2 directive recommended
`exact IsOpenImmersion.isDominant _` as a one-liner. Mathlib has
NO such lemma — the implication is FALSE in general (open immersion
into a disconnected target need not be dominant). The right path
requires explicit `PreirreducibleSpace` on the target plus
`IsOpenMap.denseRange_of_isPreirreducibleSpace`
(`Mathlib/Topology/Irreducible.lean:201`). Iter-179+ planners should
drop the directive's one-liner framing.

### Mathlib gaps surfaced this iter

- `IsOpenImmersion → IsDominant` (general; FALSE — needs irreducible
  target).
- `Smooth → IsRegularLocalRing` on scheme stalks (Stacks 00TT/00TX).
- `coheight = 1 → Ring.KrullDimLE 1` on the stalk (Stacks 02IZ /
  005X) — already KB-recorded as iter-176 gap.
- `IrreducibleSpace (Proj 𝒜)` for domain graded ring (no Mathlib
  formalisation; bridge `MvPolynomial domain ⟹ Proj
  IrreducibleSpace` would close it).

### Lean elaboration traps

- `IsScalarTower` `haveI` defaults to `IsScalarTower A A A` without
  explicit `(R :=) (S :=) (A :=)` annotations — adds 3-line cost to
  every `pointOfVec`-template body.

## Blueprint markers updated (manual)

None this iter. Reasoning:

- All `\leanok` decisions are owned by deterministic `sync_leanok`
  (which ran iter-178 and added 2 markers to
  `Albanese_CodimOneExtension.tex`; rest unchanged).
- No new Mathlib re-export landed this iter (Lane 7's
  `Module.projectiveDimension` is a 1-line wrapper using
  `CategoryTheory.projectiveDimension`, but the project-side decl
  is the carrier-pin so `\leanok` on the proof block is the right
  marker, not `\mathlibok` on the statement — `sync_leanok` handles
  this).
- No `\lean{...}` rename was flagged in any task_result.
- No `\notready` markers exist on landed bodies (none reported by
  any task_result).
- No translation-gap NOTE additions needed — task_results all
  match their chapters' prose.

## Blueprint doctor findings — surfaced

The deterministic `blueprint-doctor` (logs/iter-178/blueprint-doctor.md)
reported two classes of issues:

1. **2 project axioms** — `gmScalingP1_chart_data_temp` and
   `gmScalingP1_collapse_at_zero_temp` in
   `Genus0BaseObjects/GmScaling.lean`. Both are KNOWN iter-177
   HARD STOP TEMP axioms; iter-181 RETIRE-OR-ESCALATE trigger
   active per STRATEGY.md.
2. **1 broken cross-reference** in
   `Albanese_CodimOneExtension.tex`: the `\uses{...}` block at
   L594-L596 has a `\leanok` macro tucked inside (between
   `def:codim1_cycles, lem:smooth_codim_one_dvr,` and
   `thm:codim_one_extension}`), making the parser read
   `\leanok\n        thm:codim_one_extension` as one label.
   The `\leanok` should be moved outside the closing `}`
   (it's intended as the proof-block marker per the file's
   pattern). Surfaced to plan agent in recommendations.

## Subagent skips

- **lean-vs-blueprint-checker**: not dispatched per-file this iter.
  7 prover-touched files this iter, but: (i) every closure (Lane 1
  build-fix, Lane 7 body) and structural advance (Lanes 2/4/5/6)
  is on an existing chapter pin with no signature change requiring
  chapter re-spec; (ii) Lane 5 Part A's signature change from
  `≅` to `≃+*` matches the iter-178 plan's auditor-driven
  intent and the chapter prose still describes "rational map
  inducing a `≃+*` of function fields" correctly; (iii) the
  per-file checkers' marginal value over the task_results' own
  blueprint-pin/sorry/axiom hygiene reporting is low this iter
  (no laundering risk surfaces). lean-auditor was dispatched
  whole-project to cover the cross-cutting layer.

## Audit reports (dispatched this phase)

- `task_results/lean-auditor-iter178-touched.md` — whole-project
  audit of all `.lean` files with attention to iter-178 edits.
  **Verdict: 3 must-fix-this-iter findings**; recommendations landed
  at TOP of `recommendations.md`:
  - **178A** (CRITICAL): `RationalCurveIso.lean:226-243` Lane 5
    Part B body lands with an excuse-comment confessing the
    signature is mathematically insufficient (weakened-wrong-by-
    missing-hypothesis; fresh recurrence of iter-175 KB
    `chart-bridge-prover-bypass` pattern).
  - **178B** (CRITICAL): `CodimOneExtension.lean:391-406` Lane 4
    `extend_iff_order_nonneg` body is a shallow `mem_domain`
    reshuffle; the `[Ring.KrullDimLE 1 ...]` binder is UNUSED and
    the docstring sells content the type does not encode.
  - **178C** (MUST-FIX, low effort): `AuslanderBuchsbaum.lean:165-167`
    Lane 7 left the file's docstring + module status block still
    claiming the body is `sorry` after the body was filled.
  - **Severity totals**: 3 must-fix / 9 major / 6 minor / 3
    excuse-comments. The major class is largely stale "Status
    (iter-NNN)" annotations across 9 files.

  This is the iter-175 chart-bridge-prover-bypass-iter175 pattern
  recurring: when the analogist or auditor's structural objection
  to the body shape is empirically verified, the prover directive
  must encode an abort rule before the recipe is attempted on file.
  iter-179 plan should add this discipline to the Lane 5 follow-up
  directive.
