# Recommendations for the iter-013 plan agent

## CRITICAL / HIGH (from review subagents)

1. **[lvb-quot MUST-FIX] `Scheme.Grassmannian.representable` is a corrupted blueprint pin.**
   The Lean statement (QuotScheme.lean:225) is a weakened skeleton
   `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)` that drops the prose's
   smoothness, properness/projectivity, relative dimension `d(r-d)`, tautological rank-`d` quotient,
   and Plücker content, and carries an "iter-177+ refinement work" excuse-comment. The
   `\lean{thm:grassmannian_representable}` pin therefore points at a decl that under-delivers.
   **Action:** dispatch a refactor (strengthen the Lean statement to match the prose, proof may stay
   `sorry`) **or** split the weak existence form under a distinct label so the pin is not corrupted.
   A `% NOTE` was added to the blueprint block this iter, but the structural fix is a `.lean` edit the
   planner must direct. (Not on any current critical path, but it corrupts the DAG's claim coverage.)

2. **[lvb-quot major] `Grassmannian` def + `QuotFunctor`/`hilbertPolynomial` signatures under-specified.**
   `Grassmannian` is missing the `IsLocallyFreeOfRank`/rank-`r`/`1 ≤ d ≤ r` hypotheses; `QuotFunctor`'s
   `_L` is typed as plain `X.Modules` rather than a line bundle. These are skeleton stubs (the iter-012
   QUOT prover worked only the power-series engine, not these). Tighten before any prover targets them.

3. **[lean-auditor major ×3 — prover-cleanup, review cannot edit `.lean`] Stale cross-project comments.**
   `FlatBaseChange.lean` STATUS block references iter-234/236/240/241 (from the pre-extraction
   AlgebraicJacobian project; this project is at iter-012); `QuotScheme.lean` has an "iter-177+" comment.
   Direct the owning prover to strip/refresh these when next editing the file.

## GF — CHURNING, must-close NOT met this iter (escalation per the iter-012 plan)

4. **`gf_torsion_reindex` did NOT fully close** (still 1 sorry) despite the must-close obligation —
   BUT the hard content (`Module.Finite (P_g⧸span{Fg}) Tg'`) is verified and compiles. The iter-012 plan
   recorded the escalation: **if it doesn't close, iter-013 escalates to a mathlib-analogist consult on
   the localization-module transport (instance-diamond identification).** Recommended next iter:
   - **First**, dispatch an effort-breaker on `gf_torsion_reindex` to split the residual (a)-(e)
     bookkeeping into standalone helper lemmas (the prover's explicit lesson: inline assembly blows
     `isDefEq` heartbeats even at 1,000,000 — the fix is decomposition, NOT bigger budgets).
   - The single missing glue for step (e) is a **descent lemma**: turn `IsLocalizedModule MC f` (over P)
     into `IsLocalizedModule (powers g) (f.restrictScalars A)` (over A). Ask mathlib-analogist if this
     exists; if absent, build the `A_g`-equiv from `IsLocalizedModule.mk'`/`surj`.
   - Do **NOT** re-dispatch the same monolithic inline-assembly prompt — it is the documented wall.

## FBC — closest-to-completion seams

5. **FBC seam ladder is prover-ready, close in order.** `base_change_mate_section_identity` is
   `sorry`-free pending Seam 3; `base_change_mate_inner_value` is proven. Remaining: Seam 1
   (`_unit_value`, square-free base case — try `Adjunction.conjugateEquiv` unit-coherence, no `ext`:
   the `conjugateIsoEquiv` element actions are opaque, so element chases are dead ends), then Seam 2
   (`_fstar_reindex`, + `pullback_fst_snd_specMap_tensor`), then Seam 3 (`_gstar_transpose`, +
   `pullback_spec_tilde_iso`). Closing Seam 3 immediately lands `section_identity`, `generator_trace`,
   `cancelBaseChange`. If the abstract route stalls, mathlib-analogist on conjugate-adjunction unit transport.
   `affineBaseChange_pushforward_iso` (affine reduction) + `flatBaseChange_pushforward_isIso` (FBC-B) are
   the larger out-of-scope holes — independent of the seam tower.

## QUOT — SNAP-S2 needs a dedicated graded-module-API lane

6. **The power-series engine is DONE; the next QUOT lane is the graded-module API sub-build.** Build
   (as its own lane): graded quotient `M/xM`, graded kernel of a degree-shifting endo, regrading over
   `A/(x)`, and `Module.Finite` transfer through these as GRADED objects (Mathlib has none at the pinned
   commit — `GradedModule` is not a class). Then the `Finset.card` induction on degree-1 generators feeds
   `IsRatHilb.ofDiffEq`. Consider adding a finite-degree-1-generation hypothesis to the signature.
   This is comparable in size to the engine just landed — scope it as one full lane, not a tail task.

## Blueprint coverage debt (1-to-1; `archon dag-query unmatched` = 44 nodes)

Review does not author informal prose — these are for the planner to blueprint. Substantive
(non-`private`, or load-bearing) uncovered Lean decls needing `\lean{}` blocks:
- **GR (lvb-gr major/minor):** `cocycleΘIJ`, `cocycleΘJK`, `cocycleΘIK`, `universalMatrix_map_transitionPreMap`
  (public, appear in `cocycleCondition`'s statement/proof) + helpers `universalMatrix_submatrix_self`,
  `imageMatrix_submatrix_self`, `imageMatrix_submatrix_I`, `transitionPreMap_minorDet`,
  `awayInclLeft`/`Right` (+ `_comp_algebraMap`), `map_nonsing_inv`, `isUnit_*`, `map_map_eq_of_comp`,
  `imageMatrix_map_eq`, `inv_mul_inv_mul_cancel`, `cocycle_imageMatrix_eq`.
- **FBC:** `base_change_mate_inner_value` (the proven ρ helper) — add a `\label`+`\lean`+`\uses` block
  (it is the RHS referenced by `lem:base_change_mate_fstar_reindex`).
- **QUOT power-series engine** (worth blueprinting — reusable, citable): `rationalHilbert_antidiff` and
  `IsRatHilb.ofDiffEq` are the two load-bearing facts; also `Scheme.Modules.annihilator_ideal_le`,
  `schematicSupportι` (half of `def:schematic_support`, lvb-quot minor).
- **GF private Nagata helpers (11):** `GenericFreeness.T/T1/T_leadingcoeff_eq/degreeOf_*/finSuccEquiv_*/`
  `leadingCoeff_finSuccEquiv_t/lt_up/sum_r_mul_ne/t1_comp_t1_neg` — `private`, optional per prior iters.

## Minor / cosmetic (no action gate)

- **[lvb-gf minor]** 2 stale comment typos in `gf_torsion_reindex` roadmap: `≃ₐ[A]`→`≃ₐ[A_g]`,
  `Module.Finite`→`RingHom.Finite` (prover-cleanup).
- **[lvb-gr major]** `affineChart` (line 56) omits the `hI : I.card = d` guard present downstream —
  minor generality mismatch with the blueprint domain.
- **[lvb-fbc minor]** dangling `\uses{lem:base_change_regroup_linearEquiv}` inside
  `lem:base_change_mate_regroupEquiv` (blueprint-doctor reported refs clean, so the label resolves but
  the dependency is the abandoned `cancelBaseChange` route — reconcile the prose, carried from iter-011).
- **Missing-`\leanok` reports (lvb-gf/quot minor)** are sync_leanok timing artifacts, not laundering —
  sync_leanok ran for iter-012 (sha 9859768); do not act.

## Do NOT retry without a structural change
- **GF `gf_torsion_reindex` inline assembly** — the (a)-(e) chain assembled in one tactic block blows
  `isDefEq`/`whnf` heartbeats even at `maxHeartbeats 1000000`. Re-dispatching the same monolith wastes the
  iter. Decompose into helper lemmas first (effort-breaker), then prove the small pieces.
- **FBC seams via element `ext` chase** — `pullback_spec_tilde_iso` / `conjugateIsoEquiv` element actions
  are opaque by construction; only abstract adjunction calculus closes the seams.
