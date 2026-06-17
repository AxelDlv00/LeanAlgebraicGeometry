# Iter-124 (Archon canonical) — review

## Outcome at a glance

- **PARTIAL prover lane on `Differentials.lean:282`
  `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`** (M1.b body).
  A single substantive Edit at L332-L398 promoted the iter-123
  `forward : Localization M →+* A_colim` to an explicit `AlgHom`
  (`forwardAlg`) inside the `suffices AE` block, closed the
  `commutes'` algebra-map compatibility in-body via
  `RingHom.congr_fun h_fwd_comp` (1 LOC of proof), and reduced the
  residual `Localization M ≃ₐ[Γ(S, U)] A_colim` AlgEquiv to the
  named claim `Function.Bijective ⇑forwardAlg` via
  `AlgEquiv.ofBijective forwardAlg sorry`. Net per-file sorry change:
  **1 → 1** (the sorry moved L362 → L398). Net project sorry change:
  **2 → 2** (unchanged).
- **Closest match against the iter-124 PROGRESS.md "Expected outcome"
  watch criteria is case 2**: "iter-124 prover lane returns PARTIAL
  (any flavor) → iter-125 fires the M2.a pivot unconditionally per
  the sharpened commitment." Iter-124 delivered exactly that — a
  PARTIAL with structural narrowing (`commutes'` closed in body,
  residual named as bijectivity rather than as the whole AlgEquiv)
  but no full closure on M1.b. **The iter-125 unconditional M2.a
  pivot fires.**
- **Compile-verified**: yes. `lake env lean
  AlgebraicJacobian/Differentials.lean` (issued by the prover at
  end-of-session) succeeds with only the documented `declaration
  uses sorry` warning at L282 (the `appLE_isLocalization` declaration
  banner). Independent `sorry_analyzer.py AlgebraicJacobian/`
  confirms 2 sorry sites at L398 + L179.
- **No new axioms.** `archon-protected.yaml` unchanged (9 protected
  declarations at original paths with unchanged signatures).
  `appLE_isLocalization` is a non-protected leaf declaration
  introduced iter-122 as a named M1.b helper; the iter-124 Edit
  did NOT touch its signature, only the body.
- **Review-phase mandatory subagents dispatched**:
  - `lean-auditor-review124` — **clean** (must-fix: 0; major: 1
    on L332-L397 comment-bloat / iter-loop narrative; minor: 4
    carry-overs unchanged from iter-123). Overall verdict: clean
    iter; the iter-124 `forwardAlg` AlgHom promotion is well-shaped;
    the refactor-deadcode-cleanup landed cleanly; no new must-fix
    issues introduced.
  - `lean-vs-blueprint-checker-differentials-review124` — running
    at review-finalize time; findings folded into recommendations.md
    as they land.
- **Meta**: `meta.json planValidate.status: ok / objectives: 1`;
  `prover.durationSecs: 1218` (~20 min — between the iter-122 ~30 min
  and iter-123 ~16 min baselines). 60 events in
  `attempts_raw.jsonl`: **1 substantive edit**, 2 goal checks,
  3 diagnostic checks, 28 lemma searches (3 local + 18 leansearch +
  4 loogle + 1 leanfinder + 2 hover_info / declaration_file),
  0 errors, 0 `lake build` calls during the proof loop (only the
  final confirmation `lake env lean` shell call). The prover used a
  single substantial Edit and stuck with it.
- **Stage**: stays at `prover` for iter-125, BUT the prover lane
  shifts off M1.b. iter-125 plan-phase executes the staged Rigidity
  refactor (rename `GrpObj.eq_of_eqOnOpen` →
  `Scheme.Over.ext_of_eqOnOpen`; drop 8 unused hyps; weaken `IsProper
  Y` to `IsSeparated Y`; ~25 LOC; persistent rationale
  `analogies/rigidity-refactor.md`) and prepares the M2.a Rigidity
  prover lane for iter-126. M1.b parks indefinitely with its
  current state; the iter-126+ M1.b lane (if it materialises) starts
  from the bijectivity residual with the concrete ~130-210 LOC
  recipe documented in `task_results/AlgebraicJacobian_Differentials.lean.md`
  § "Next-step recipe for any future M1.b prover lane".

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **2**, distributed:
  - `AlgebraicJacobian/Differentials.lean:398` —
    `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` (M1.b body;
    `Function.Bijective ⇑forwardAlg` residual inside
    `AlgEquiv.ofBijective forwardAlg sorry`; the commutes' field
    is closed in-body via `RingHom.congr_fun h_fwd_comp r`).
  - `AlgebraicJacobian/Jacobian.lean:179` —
    `nonempty_jacobianWitness` (intended end-state for the project
    overall; off-limits to the autonomous loop until M2 + M3 land;
    user-escalation re-surfaced via `TO_USER.md` this iter with
    the named-axiom alternative option per strategy-critic-iter124).
- **Solved this iter**: 0 (no sorry-count change; structural narrowing
  only — `commutes'` field closed in body, residual narrowed to
  named bijectivity claim).
- **Partial this iter**: 1 (`appLE_isLocalization` body —
  `commutes'` closure + AlgEquiv.ofBijective reduction).
- **Blocked this iter**: 0.
- **Untouched (off-limits)**: 1 (`nonempty_jacobianWitness`).

## What the iter-124 prover got right

- **Right pivot from the iter-123 6-substep recipe**. The iter-123
  prover task result documented a 6-substep
  `RingEquiv.ofRingHom + AlgEquiv.ofRingEquiv` plan (Step 2a-d cocone
  construction; Step 3 inverse identities via `IsLocalization.ringHom_ext`
  + `IsColimit.hom_ext`; Step 4 already in-place via `suffices`). The
  iter-124 prover spent ~28 lemma searches verifying that this 6-substep
  plan would need 130-210 LOC of project-side bridge work and that no
  off-the-shelf Mathlib closer for "filtered colim of localizations
  is localization at union submonoid" exists, then pivoted to a
  structurally simpler `AlgEquiv.ofBijective` reduction that closes
  the `commutes'` sub-piece in body and reduces the remaining work
  to a single named bijectivity claim. This is the right reading of
  the available Mathlib lemmas (`IsLocalization.lift_injective_iff` +
  `IsLocalization.lift_surjective_iff` are the canonical bijectivity
  decomposition pair) and the right call on closure shape.
- **`RingHom.congr_fun h_fwd_comp r` for `commutes'`**. The
  iter-122 `appLE_colimAlgebra := (appLE_colimRingHom f e).hom.toAlgebra`
  helper makes `algebraMap Γ(S, U) A_colim` definitionally equal to
  `(appLE_colimRingHom f e).hom`. The iter-124 prover correctly
  identified that this lets `RingHom.congr_fun h_fwd_comp r` (a
  function-extensionality witness for the iter-123
  `IsLocalization.lift_comp` fact) close the `commutes'` field in
  1 line of proof, without a `show`/`change` rewrite. This is the
  payoff of the iter-122 helper-lemma extraction pattern: by lifting
  `appLE_colimAlgebra` to a top-level `@[reducible] noncomputable
  def`, the definitional unfolding becomes available wherever needed.
- **Concrete blocker analysis, not excuse text**. The L332-L397
  comment block names the precise Mathlib gap as (a) filtered-colim
  element representation for `IsPointwiseLeftKanExtensionAt`-defined
  colims of `CommRingCat` and (b) basic-open cofinality from
  `appLE_unitSubmonoid` to `Opens S`. Both pieces are cited with
  verified Mathlib lemma names (`IsLocalization.lift_injective_iff`,
  `IsLocalization.lift_surjective_iff`,
  `CommRingCat.FilteredColimits.colimitCoconeIsColimit`,
  `Functor.LeftExtension.IsPointwiseLeftKanExtensionAt`,
  `IsAffineOpen.exists_basicOpen_le`,
  `IsAffineOpen.isLocalization_basicOpen`, `AlgEquiv.ofBijective`).
  The lean-auditor-review124 explicitly audited this block against
  the excuse-comment rubric and concluded it is documentary blocker
  analysis, not a "will fix later" admission — the gap is genuinely
  identified, not invented.
- **Compact attempt count**. 1 substantive Edit (vs iter-123's 2,
  iter-122's 53). ~20 minutes of prover duration, with ~70% of the
  budget spent on the "is there an off-the-shelf bridge" Mathlib
  search question. This is the right shape for a structural-narrowing
  iter that exits with a documented blocker.

## What the iter-124 prover got wrong (or could have done better)

- **Comment bloat at L332-L397** (lean-auditor major flag). The
  comment block describes the bijectivity decomposition cleanly but
  leaks iter-loop narrative into the source: "Strategy this iter
  (iter-124)" (L334), "Mathlib b80f227" commit-hash citation (L335),
  "the iter-125+ prover lane would need to assemble" (L395), "the
  iter-125 pivot to M2.a fires per the strategy-critic-iter124
  sharpened commitment" (L396-L397). These ephemeral references
  belong in `task_results/` or `iter/iter-124/`, not in production
  Lean. The fix is small (trim ~5-10 LOC of iter-loop narrative
  from the comment block) and can be folded into the iter-125
  Rigidity-refactor iter as a discretionary cleanup, OR deferred to
  whatever iter eventually closes the bijectivity sorry (at which
  point the entire L332-L397 block is replaced with the actual
  proof and the iter-loop narrative auto-disappears).
- **The iter-123 closure-recipe comment block (L348-L361 in the
  iter-123 state) was deleted, not preserved as a historical record
  of the rejected RingEquiv.ofRingHom path**. The iter-123 recipe
  had value — it documents a path the prover considered and rejected.
  Deleting it in favour of the iter-124 `AlgEquiv.ofBijective`
  rationale (which IS more correct) is fine, but a one-line "see
  iter-123 task_results for a previously-considered RingEquiv.ofRingHom
  recipe" pointer would have been useful for future provers. Minor;
  the iter-123 task result is on disk and accessible.

## Cross-iter pattern: M1.b convergence trajectory

| Iter | Sub-step landed in body | Residual sorry |
|---|---|---|
| iter-122 | Plan-phase refactor opened 4 sorries; prover closed L109 (algebra letI), L142 (module letI), L145 (bridge body M1.e); Step 0 of M1.b closed as named helper `isUnit_appLE_unitSubmonoid_in_colim` | L304 (`appLE_isLocalization` body opening) |
| iter-123 | Step 1 (forward map via `IsLocalization.lift`) + Step 4 (reduction via `IsLocalization.isLocalization_of_algEquiv`) | L362 (`Localization M ≃ₐ[Γ(S, U)] A_colim` AlgEquiv hole) |
| iter-124 | `commutes'` algebra-map compatibility (the 3rd sub-piece of the iter-123 AlgEquiv hole) | L398 (`Function.Bijective ⇑forwardAlg`) |

The route has been structurally productive across 3 iters — each
iter closed a named sub-piece in body — but the per-file sorry
count has been flat at 1 across iter-122 → iter-123 → iter-124
(the project total is 2 throughout, with `Jacobian.lean:179` being
the off-limits second). Per the iter-124 strategy-critic sharpened
commitment + iter-124 progress-critic watch flag #1 firing at the
strict-3-iter-flat-count threshold, **iter-125 pivots to M2.a
unconditionally**. M1.b parks; the residual bijectivity claim has
its closure recipe documented for whoever picks it up next (the
likely candidates being a hand-formalization off-loop, or a Mathlib
contribution candidate that surfaces the filtered-colim bridge as
an upstream lemma).

## Decisions / lessons / pattern catalogue update

The session_124/summary.md § Key findings has the detail; the
PROJECT_STATUS.md § Knowledge Base will absorb the two reusable
findings:

1. **`AlgEquiv.ofBijective` is the canonical narrowing step when
   `IsLocalization.lift` + bijectivity-via-`lift_{inj,surj}_iff` is
   in scope**. Use this in preference to
   `RingEquiv.ofRingHom + AlgEquiv.ofRingEquiv` when (a) the forward
   map is already an `IsLocalization.lift`, (b) the algebra-map
   compatibility witness `forward.comp (algebraMap _ _) = g` is
   available via `IsLocalization.lift_comp`, and (c) the target
   algebra structure is constructed from `g.toAlgebra`. The
   `commutes'` field then closes in 1 LOC via `RingHom.congr_fun`,
   leaving only the bijectivity residual.

2. **`RingHom.congr_fun h_fwd_comp r` closes `commutes'` exactly when
   the target algebra structure is `someRingHom.toAlgebra`**. Companion
   to the iter-122 helper-lemma extraction pattern: top-level
   `@[reducible] noncomputable def appLE_colimAlgebra :=
   (appLE_colimRingHom f e).hom.toAlgebra` makes `algebraMap _ _ r`
   definitionally `(appLE_colimRingHom f e).hom r`, so a function-
   extensionality witness via `RingHom.congr_fun` closes the
   `commutes'` field without a `show`/`change` rewrite.

## Subagent dispatches this review

| # | Subagent | Slug | Outcome |
|---|---|---|---|
| 1 | lean-auditor | review124 | Clean — must-fix: 0; major: 1 (L332-L397 comment-bloat + iter-loop narrative bleed); minor: 4 (all iter-123 carry-overs unchanged); excuse-comments: 0. Overall verdict: clean iter. |
| 2 | lean-vs-blueprint-checker | differentials-review124 | (running at review-finalize; folded into recommendations.md as findings land). |

## TO_USER.md

Re-authored this iter to surface the strategy-critic-iter124
named-axiom alternative alongside the existing PR-and-wait
alternative for M3, per the iter-124 plan-agent's staging of the
M3 escalation options. The plan-agent standing rule against
proposing new axioms applies to the agent; the user retains
authority over the project direction (iter-121 pivot was a user
directive); the loop's role is to surface options the critic
raised, not to gate them away.
