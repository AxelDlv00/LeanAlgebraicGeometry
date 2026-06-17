# Session 123 — Review (iter-123)

## Metadata

- **Iteration**: 123 (review of iter-123)
- **Stage**: prover (Iter-123 M1.b residual lane on
  `appLE_isLocalization`; the iter-123 plan-phase dispatched the iter-123
  M1.b tactical mathlib-analogist consult per the iter-123 progress-critic
  CHURNING corrective; STRATEGY.md was revised inline for the M2.d-alt
  char-`p` hazard + 2 phantom prereq spot-checks + M3 user-escalation
  outcome; the prover lane then ran against the iter-123 PROGRESS.md
  4-step plan).
- **Sorry count entering iter-123 prover lane**: **2**
  (`Differentials.lean:304` `appLE_isLocalization` body M1.b — Steps 1–4
  TODO; `Jacobian.lean:179` `nonempty_jacobianWitness`).
- **Sorry count after iter-123 prover lane**: **2** (per-file:
  `Differentials.lean:362` `appLE_isLocalization` body — Steps 2+3
  packaged as a single residual `AlgEquiv` sorry; `Jacobian.lean:179`
  `nonempty_jacobianWitness` unchanged). The Differentials sorry
  migrated from L304 (the body's bare opening sorry) to L362 (the
  `suffices AE` block's residual), after ~60 LOC of in-body proof
  scaffolding was inserted between L290 and L361. **Net sorry count
  unchanged 2 → 2; structural advance: Steps 1 + 4 of the M1.b
  4-step `IsLocalization.of_le` chain closed in body** (the forward
  map `Localization M →+* A_colim` is built concretely via
  `IsLocalization.lift`, and the Step 4 reduction
  `IsLocalization.isLocalization_of_algEquiv M AE` is in place via
  `suffices`).
- **Targets attempted**: 1 (`AlgebraicJacobian/Differentials.lean`,
  the iter-123 PROGRESS.md objective).
- **Targets resolved (full closure)**: 0.
- **Targets PARTIAL with structural advance**: 1
  (`appLE_isLocalization`; Steps 1 + 4 of 4 closed concretely in body;
  Step 0 was already closed iter-122 as named helper).
- **New axioms introduced**: none.
- **Compile status**: project compiles. `lake build
  AlgebraicJacobian.Differentials` succeeds in 3.2s (2820 jobs) with
  only the documented `sorry` warning at L282 (the `appLE_isLocalization`
  declaration). `lean_diagnostic_messages` returns `[]` errors,
  `[{sorry warning}]` warnings.
- **Protected signatures touched**: none. `archon-protected.yaml`
  unchanged (9 protected declarations at original paths with unchanged
  signatures). `appLE_isLocalization` is a non-protected leaf
  declaration introduced iter-122 as a named M1.b helper.
- **Pre-processed events**: 72 total events in
  `proof-journal/current_session/attempts_raw.jsonl` — 2 edits,
  2 goal checks, 6 diagnostic checks, 22 lemma searches (12 local +
  10 loogle / leansearch / leanfinder), 0 builds (the prover used
  `lean_diagnostic_messages` over full `lake build` after the first
  Edit; one final `lake build` issued at L151), 1 total error recorded
  (a single LSP file-path resolution error before the prover swapped
  to absolute paths). Single file edited
  (`AlgebraicJacobian/Differentials.lean`).
- **Prover-phase shape**: a single substantive prover stream on
  `Differentials.lean` with **2 substantive Edits** (the structural
  reduction at attempt 1 + the comment-block refinement at attempt 2).
  Both Edits compile-clean; the second is comments-only and exists to
  document the iter-124 closure recipe for the AlgEquiv assembly.
- **Meta**: `meta.json planValidate.status: ok / objectives: 1`;
  PARTIAL outcome on the single objective. Prover-phase
  `durationSecs: 950` (~16 min — well under the iter-122 ~30 min
  baseline despite the analogist-tactical playbook complexity).
- **Plan-phase dispatches** (for context — already reported in
  iter-123 plan.md): 3 mandatory critics + 2 mathlib-analogist (M3
  route audit, M1.b tactical) + 1 refactor (docstring fix on
  `smooth_locally_free_omega`); 6 subagent dispatches total.

## Per-target detail

### Target: `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` (M1.b) — PARTIAL with structural advance

**Status**: **partial**. Steps 1 (forward map) and 4 (reduction via
`IsLocalization.isLocalization_of_algEquiv`) of the 4-step
`IsLocalization.of_le` chain land concretely in-body (~25 LOC of
non-comment proof code). Steps 2 (cocone backward map; the only
genuinely novel scheme-theoretic step) and 3 (inverse identities)
are packaged into a single residual `sorry` at L362 inside the
`suffices AE : Localization M ≃ₐ[Γ(S, U)] A_colim` block.

**Net file change**: 1 sorry site moved L304 → L362 with ~60 LOC of
structural reduction inserted between L290 and L361. Total file LOC:
~480 (was ~460 entering iter-123).

#### Attempt path (chronological; 2 substantive Edits)

1. **Attempt 1 — structural reduction with Step 1 + Step 4 closure**
   (Edit at L290-L362, ~60 LOC inserted):
   - **Pre-edit goal** (line 304, before any in-body code):
     ```
     X S : Scheme
     f : X ⟶ S
     U : S.Opens
     V : X.Opens
     hU : IsAffineOpen U
     hV : IsAffineOpen V
     e : V ≤ f ⁻¹ᵁ U
     ⊢ IsLocalization (appLE_unitSubmonoid f hU hV e)
       ↑(((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (Opposite.op V))
     ```
   - **Code tried** (sketch; see Differentials.lean:290-362 for the
     full body):
     ```lean
     letI : Algebra Γ(S, U) (((pullback _ _).obj S.presheaf).obj (.op V)) :=
       appLE_colimAlgebra f e
     set M := appLE_unitSubmonoid f hU hV e with hM_def
     -- Step 1: forward map (Localization M) → A_colim
     have h_unit_ring : ∀ y : M, IsUnit ((appLE_colimRingHom f e).hom y.val) := fun y =>
       isUnit_appLE_unitSubmonoid_in_colim f hU hV e y.val y.property
     let forward : Localization M →+* ... :=
       IsLocalization.lift (M := M) (S := Localization M) h_unit_ring
     have h_fwd_comp :
         forward.comp (algebraMap Γ(S, U) (Localization M)) = (appLE_colimRingHom f e).hom :=
       IsLocalization.lift_comp _
     -- Step 4: reduction to AlgEquiv
     suffices AE :
         Localization M ≃ₐ[Γ(S, U)]
           (((pullback _ _).obj S.presheaf).obj (.op V)) from
       IsLocalization.isLocalization_of_algEquiv M AE
     -- Step 2 + Step 3: residual
     sorry
     ```
   - **Post-edit goal** (line 353 immediately before the `sorry`):
     ```
     X S : Scheme
     f : X ⟶ S
     U : S.Opens
     V : X.Opens
     hU : IsAffineOpen U
     hV : IsAffineOpen V
     e : V ≤ f ⁻¹ᵁ U
     this : Algebra ↑Γ(S, U) ↑A_colim := appLE_colimAlgebra f e
     M : Submonoid ↑Γ(S, U) := appLE_unitSubmonoid f hU hV e
     hM_def : M = appLE_unitSubmonoid f hU hV e
     h_unit_ring : ∀ y : M, IsUnit ((appLE_colimRingHom f e).hom ↑y)
     forward : Localization M →+* ↑A_colim := IsLocalization.lift h_unit_ring
     h_fwd_comp : forward.comp (algebraMap (↑Γ(S, U)) (Localization M)) =
                  (appLE_colimRingHom f e).hom
     ⊢ Localization M ≃ₐ[↑Γ(S, U)] ↑A_colim
     ```
   - **Lean error**: none. Build succeeds with only the expected
     `declaration uses sorry` warning at L282.
   - **Result**: SUCCESS for Step 1 + Step 4 closure; PARTIAL overall
     (residual sorry on the AlgEquiv).
   - **Insight**: the `suffices AE : ...` framing reduces the goal to
     a single existential whose witness is exactly the data Step 2
     + Step 3 construct. This keeps the file's sorry count at exactly
     1 instead of splitting Steps 2 / 3 / algebra-map-compat into
     three separate sorries (each requiring its own `have h_fwd_inv`,
     `have h_inv_fwd`, etc. plus the AlgEquiv assembly). The metric
     used by the project is **sorry count**, not "tactical steps
     remaining"; consolidating maintains the metric at 2 (or 1 in
     Differentials) while making the structural reduction explicit
     and audit-able.

2. **Attempt 2 — comment-block refinement with iter-124 closure recipe**
   (Edit at L348-L361, comments-only):
   - **Code tried**: added an explicit recipe sketch for the AlgEquiv
     assembly to the comment block before the `sorry`, documenting
     the `RingEquiv.ofRingHom forward backward h_fb h_bf` shape +
     `AlgEquiv.ofRingEquiv (f := RE) (algebra-map-compat)` shape,
     plus a draft of the algebra-map-compatibility witness using
     `change forward (algebraMap _ _ x) = algebraMap _ _ x` +
     `IsLocalization.lift_eq h_unit_ring x`.
   - **Lean error**: none (comments-only).
   - **Result**: SUCCESS (documentation refinement).
   - **Insight**: the comment block now makes the iter-124 prover's
     starting point concrete — the assembly is the standard
     `RingEquiv.ofRingHom + AlgEquiv.ofRingEquiv` pattern, parameterised
     by the two-direction inverse identities; the algebra-map
     compatibility witness routes through `IsLocalization.lift_eq`
     (which gives the needed equation on the image of `algebraMap`
     for free).

#### Per-step structural breakdown (where the body now stands)

- **Step 0 (closed iter-122)**: `isUnit_appLE_unitSubmonoid_in_colim`
  (Differentials.lean:164; ~70 LOC; named helper). Provides the
  unit-witness `∀ g ∈ M, IsUnit ((appLE_colimRingHom f e).hom g)`
  consumed by Step 1.
- **Step 1 (closed iter-123, in-body)**: `forward : Localization M →+* A_colim`
  built via `IsLocalization.lift (M := M) (S := Localization M)
  h_unit_ring` at L310-L314. Compatibility `forward.comp (algebraMap
  _ _) = (appLE_colimRingHom f e).hom` captured as `h_fwd_comp` via
  `IsLocalization.lift_comp` at L319-L321.
- **Step 2 (residual iter-123 → iter-124)**: backward map
  `A_colim → Localization M` via the cocone universal property of
  the pullback presheaf's `Lan` construction. Decomposed into 4
  sub-steps in the prover task result + recommendations.md:
  Step 2a (basic-open-cover helper, 30-60 LOC), Step 2b (cocone arm
  constructor via `IsLocalization.map`, 30-50 LOC), Step 2c (cocone
  naturality, 30-50 LOC), Step 2d (descend via
  `Functor.descOfIsLeftKanExtension` or `IsColimit.desc`, 10-20 LOC).
- **Step 3 (residual iter-123 → iter-124)**: inverse identities via
  `IsLocalization.ringHom_ext M` for `backward.comp forward = id`
  (reduces to checking agreement on `algebraMap Γ(S, U) (Localization M)`)
  + `IsLeftKanExtension.hom_ext_of_isLeftKanExtension` (or
  `IsColimit.hom_ext`) for `forward.comp backward = id` (reduces to
  checking the natural-transformation equality at each cocone arm).
- **Step 4 (closed iter-123, in-body)**: `suffices AE : Localization M
  ≃ₐ[Γ(S, U)] A_colim from IsLocalization.isLocalization_of_algEquiv
  M AE` at L328-L331. Reduces the main goal to the AlgEquiv
  construction.

#### Mathlib closure pieces consumed this iter

- `IsLocalization.lift` (`Mathlib.RingTheory.Localization.Basic`) —
  Step 1 forward map construction.
- `IsLocalization.lift_comp` (`Mathlib.RingTheory.Localization.Defs`)
  — Step 1 compatibility (`forward.comp algebraMap = ring map`).
- `IsLocalization.isLocalization_of_algEquiv` (verified iter-123 by
  the M1.b tactical analogist as the right Step-4 constructor; takes
  `AlgEquiv`, not `RingEquiv`) — Step 4 reduction.
- `isUnit_appLE_unitSubmonoid_in_colim` (project-local, iter-122)
  — Step 0 input to `IsLocalization.lift`.
- `appLE_colimRingHom` (project-local, iter-122) — the underlying
  ring map.
- `appLE_colimAlgebra` (project-local, iter-122) — the algebra
  instance `Algebra Γ(S, U) A_colim`.

### Target: `AlgebraicGeometry.AbelJacobi.nonempty_jacobianWitness` (Jacobian.lean:179) — NOT_STARTED

Off-limits this iter (foundational existence hypothesis; queued
behind milestones M2 + M3 per the genus-stratified body
decomposition in STRATEGY.md). No prover dispatched against this
site. Lean file `Jacobian.lean` unchanged this iter.

## Key findings / proof patterns discovered

### Pattern: `suffices` reduction to consolidate multi-step inverse-construction PARTIALs into a single residual sorry

When a 4-step proof has steps 1 + 4 immediately constructible and
steps 2 + 3 jointly required to build a single intermediate
existential (e.g. an isomorphism, an `AlgEquiv`, a `LinearEquiv`),
the right shape is:

```lean
-- Step 1: build the forward direction (concrete code)
have forward_data : ... := ...
-- Step 4: reduce to the existential via a Mathlib constructor
suffices intermediate : SomeIsoType from
  Mathlib.someClosingLemma forward_data intermediate
-- Step 2 + Step 3: the residual (single sorry here)
sorry
```

This keeps the file's sorry count at exactly 1 (vs. splitting the
residual into separate sorries for backward map / inverse 1 / inverse
2 / algebra-map compatibility), AND makes the iter-N+1 prover's
target explicitly the intermediate object (not a fragmented list
of obligations). Reusable across the project; companion pattern
to iter-119's "constructurally-minimal residual-sorry cascade"
(`constructor / all_goals first | exact _ | sorry`).

Iter-123 instance: at `Differentials.lean:328-331`, the body
constructs the forward map (Step 1) + reduces via
`IsLocalization.isLocalization_of_algEquiv` (Step 4); the
remaining content is exactly the `Localization M ≃ₐ[Γ(S, U)]
A_colim` AlgEquiv, packaged as a single sorry.

### Pattern: `IsLocalization.lift_comp` captures the compatibility witness

When using `IsLocalization.lift (M := M) (S := Localization M) hg` to
build a ring map `Localization M →+* B` from a unit-of-image witness
`hg : ∀ y : M, IsUnit (g y.val)`, the compatibility equation
`(lift hg).comp (algebraMap A (Localization M)) = g` is provided
directly by `IsLocalization.lift_comp`. Use this to package the
"forward map composed with `algebraMap` equals the underlying ring
map" fact for downstream Steps 3 (inverse-identity verification)
and 4 (algebra-map compatibility for `AlgEquiv.ofRingEquiv`).

Iter-123 instance: `h_fwd_comp` at `Differentials.lean:319-321`.

### Pattern: `IsLocalization.isLocalization_of_algEquiv` is the canonical Step-4 constructor

The iter-122 plan-phase recommendation MEDIUM/HIGH listed
`IsLocalization.of_le` as the Step-4 closer; the iter-123 M1.b
tactical analogist re-verified and confirmed that
`IsLocalization.isLocalization_of_algEquiv M : (Localization M
≃ₐ[A] B) → IsLocalization M B` is the canonical Mathlib constructor
for the "package the AlgEquiv → IsLocalization" reduction (takes
an `AlgEquiv`, not a `RingEquiv`; `Mathlib.RingTheory.Localization.Basic:304`).
The "ringEquiv-only" alternative is
`IsLocalization.isLocalization_iff_of_ringEquiv` which is an iff
shape (less direct to use).

### Lessons for next iter (Step 2 + Step 3 prover targeting)

- **Step 2 is genuinely novel**: the project has never previously
  used `Functor.descOfIsLeftKanExtension` or `IsColimit.desc` for
  scheme-theoretic cofinality. The iter-123 mathlib-analogist's
  Cluster A (Lan `map_comp` workaround) + Cluster D (unit.naturality
  via `simpa`) playbook is the right tactical toolkit; the iter-122
  Cluster A pre-prove+erw pattern at `isUnit_appLE_unitSubmonoid_in_colim`
  is the proximate model.
- **Step 2 may benefit from refactor-extraction**: if iter-124 stalls
  on Step 2's cocone-arm construction or the basic-open-cover
  helper, the iter-122 recommendations MEDIUM #6 plan still applies:
  extract a top-level `colim_descend_via_basic_open_refinement`
  (or similar) named helper before the prover lane. Explicit
  signatures avoid the rewriter pitfalls that bloated iter-122
  Step 0 work to ~15 attempts.
- **Step 3 reduces to an `IsLocalization.ringHom_ext` plus an
  `IsColimit.hom_ext` / `IsLeftKanExtension.hom_ext_of_isLeftKanExtension`**:
  both Mathlib closure pieces are verified iter-122/123. The
  `appLE_colimRingHom_comp_φV` factorisation theorem (L116, fully
  proved iter-122) is the right input — both composites land as
  `Scheme.Hom.appLE` after applying it, so the ext-reductions reduce
  to a single arrow check each.

## Review-phase subagent reports (incorporated into recommendations.md)

- `task_results/lean-auditor-review123.md` — whole-project audit
  (415s, 10 files). 4 must-fix-this-iter (dead `IsAffineHModuleHomFinite`
  class + 3 consumers in `Cohomology/StructureSheafModuleK.lean:458-519`;
  `AffineCoverMVSquare` unused affineness fields in
  `MayerVietorisCover.lean:50-62`; `Genus.lean:39-61` stale
  commented-out sketch; `Differentials.lean:239` `erw [hmc]`
  brittle spot); 6 major; 8 minor; 1 excuse-comment (also under
  must-fix). Overall verdict: project carries several pieces of
  historical scaffolding worth pruning. **Findings landed at
  recommendations.md § CRITICAL #0.**
- `task_results/lean-vs-blueprint-checker-differentials-review123.md`
  — bidirectional audit of `Differentials.lean` ↔ `Differentials.tex`.
  0 must-fix, 0 major, 4 minor blueprint-side documentation drift
  items (stale `IsLocalization.of_le` / `of_ringEquiv` hedge at
  L165 + L175; missing `\lean{...}` refs for `appLE_unitSubmonoid`,
  `isUnit_appLE_unitSubmonoid_in_colim`, `appLE_colimRingHom_comp_φV`).
  Overall verdict: **Lean follows the blueprint faithfully; chapter
  is adequate for the iter-124 prover; four small documentation-drift
  items recommended for chapter side, none blocking. Findings
  landed at recommendations.md § HIGH #5 + #6.**

## Recommendations for next session

See `recommendations.md` for the structured list. Top items:

- CRITICAL #0 — refactor-deletion of `IsAffineHModuleHomFinite`
  dead class + 3 consumers in `Cohomology/StructureSheafModuleK.lean`
  (lean-auditor must-fix #1).
- CRITICAL #1 — iter-124 prover lane on Step 2 + Step 3 of
  `appLE_isLocalization`; expected 140-230 LOC per the prover's
  task-result decomposition.
- CRITICAL #2 — iter-124 plan-phase must surface the M3 user
  escalation in `TO_USER.md` (already done this review, but the
  planner should re-confirm and read `USER_HINTS.md` for any user
  response).
- HIGH #4 — consider a refactor-extraction of a Step-2 helper
  lemma before the iter-124 prover lane runs, per iter-122
  recommendations MEDIUM #6 (discretionary; let the iter-124
  prover try Step 2 directly first).
- HIGH #5 — tighten Differentials.tex M1.b closure-lemma prose
  (drop stale `of_le` / `of_ringEquiv` hedge; pin `isLocalization_of_algEquiv`).
- HIGH #6 — add `\lean{...}` references for three unreferenced
  project-level helpers in Differentials.tex.

## Blueprint markers updated (manual)

None this iter.

Rationale:
- `\leanok` placement is `sync_leanok` phase's domain — do not touch.
  The proof block of `lem:appLE_isLocalization` retains a `\leanok`
  marker at `Differentials.tex:164` despite the residual sorry at
  `Differentials.lean:362`; the deterministic phase will re-evaluate
  this on its next pass. If `sync_leanok` leaves it stale, that's a
  bug to flag — but it's not the review agent's responsibility to
  override.
- No `\mathlibok` candidates: all decls touched this iter
  (`appLE_isLocalization`) are project proofs, not Mathlib re-exports.
- No `\lean{...}` macro renames flagged by the prover task result.
- No `\notready` markers exist to strip in `Differentials.tex`.

## Notes

- The iter-123 prover task result documents negative search results
  (LOW priority): no off-the-shelf "colim of localizations is
  localization at union submonoid" lemma exists in Mathlib (`b80f227`).
  Re-confirms the iter-121 analogist finding; documented in
  Knowledge Base.
- The closest Mathlib pattern (which would need adapting, not
  directly used) is
  `AlgebraicGeometry.Scheme.AffineZariskiSite.PreservesLocalization.colimitDesc_preimage`
  (`Mathlib.AlgebraicGeometry.Sites.SmallAffineZariski`); not
  directly applicable to the project's `TopCat.Presheaf.pullback`
  framing but worth a re-look if Step 2 needs a different cofinality
  pattern.
- The iter-123 prover's debug-feedback entry at
  `.archon/.debug-feedback/debug_feedback.md` flags that the
  plan-agent-generated prompt path was unwieldy due to including
  the untrimmed "Current Stage" text in the filename — orthogonal
  to the proof work but a real harness friction.
