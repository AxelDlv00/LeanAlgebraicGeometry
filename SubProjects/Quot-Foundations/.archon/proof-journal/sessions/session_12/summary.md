# Session 12 — Review of iter-012

## Metadata
- **Iteration:** 012 (4 import-independent prover lanes: FBC-A, GF, GR-cells, SNAP-S2/QUOT)
- **Model:** claude-opus-4-8
- **Build:** GREEN (all four files compile, 0 errors; only `sorry`/style warnings)
- **Sorry deltas (active, per file):**
  - FlatBaseChange.lean: **3 → 5** (+2, intentional decomposition — see below)
  - FlatteningStratification.lean: **5 → 5** (flat; substantial *verified* internal progress on `gf_torsion_reindex`)
  - GrassmannianCells.lean: **0 → 0** (+12 axiom-clean decls; `lem:gr_cocycle` CLOSED — file GREEN)
  - QuotScheme.lean: **4 → 4** (+8 axiom-clean private power-series helpers; no new sorry)
- **Axioms:** every landed decl verified `{propext, Classical.choice, Quot.sound}` (lean_verify). No `axiom` declarations in the project (blueprint-doctor confirms).
- **blueprint-doctor:** CLEAN — no orphan chapters, no broken `\ref`/`\uses`/`\proves`, no new axioms.
- **sync_leanok:** ran for iter-012 (sha 9859768), added 6 `\leanok`, removed 0, touched FBC + GrassmannianCells chapters.

## Per-target outcomes

### FBC-A — `base_change_mate_section_identity` (PARTIAL, honest decomposition)
The single opaque `section_identity` hole was **decomposed and the structural glue verified**:
- `base_change_mate_section_identity` body is now **`sorry`-free**, closed by the counit factorization
  `unfold pushforwardBaseChangeMap; rw [Adjunction.homEquiv_counit]; exact base_change_mate_gstar_transpose …`.
  (Key insight: `pushforwardBaseChangeMap = (adj.homEquiv).symm inner = g^*(inner) ≫ ε_g` verbatim.)
- `base_change_mate_inner_value` (the ρ `m ↦ (1⊗1)⊗m` of Seam 2) **fully PROVEN, axiom-clean** —
  transports the algebraic unit across `inclA∘φ = inclR'∘ψ`; `hring` closes by
  `ext r; … Algebra.algebraMap_eq_smul_one; TensorProduct.smul_tmul` (after `letI φ.hom.toAlgebra`).
- **3 new seam lemmas created** with exact elaboration-checked signatures, each a documented `sorry`:
  `_unit_value` (Seam 1, square-free base), `_fstar_reindex` (Seam 2), `_gstar_transpose` (Seam 3,
  partial body `rw [Functor.map_comp]`). These are the deep adjoint-mate/conjugate coherences,
  Mathlib-absent, that resisted iters 234–241 in the source project.
- **Why +2 sorry:** the plan's requested decomposition — one opaque hole → verified glue + 3
  precisely-characterized holes (each with signature + sketch + `\uses`). Genuine content
  (`cancelBaseChange`, `inner_value`) is now proven. lvb-fbc + lean-auditor confirm **no deception**.

### GF — `gf_torsion_reindex` (PARTIAL; CHURNING must-close NOT met, but real verified progress)
The progress-critic's CHURNING must-close target did **not** fully close (still 1 sorry), but the
*hard* mathematical content landed and compiles:
- Pivoted away from the blueprint's "twist `T` by `e`" (the **A**-localisation `LocalizedModule (powers g) T`
  gets no P-module structure — `inferInstance` fails) to the **P**-localisation
  `Tg' := LocalizedModule MC T`, `MC = map C (powers g) ⊆ P`.
- **VERIFIED and in the proof body:** `IsLocalization MC P_g`, `Module P_g Tg'` (via `letI`
  `moduleOfIsLocalization`), `Module.Finite P_g Tg'` (the hard localisation-of-a-finite-module step,
  `Module.Finite.of_isLocalizedModule MC (mkLinearMap MC T)`), `Fg` annihilates `Tg'`,
  `Module.Finite (P_g ⧸ span{Fg}) Tg'` via `Module.Finite.of_surjective` + `IsTorsionBySet.mk_smul`.
- **Remaining `sorry` (a)-(e):** base-change `e` to `ebar`, quotient transport along `ψ`,
  `Module.Finite R (P_g⧸span{Fg})`, trans to `Module.Finite R Tg'`, and **descend** P-localisation to
  the goal's A-localisation. The chain is correct but, assembled **inline**, triggers `isDefEq`/`whnf`
  heartbeat blow-ups even at `maxHeartbeats 1000000` (prover wrote it, it timed out, reverted to sorry).
  **Lesson: factor (a)-(e) into standalone helper lemmas** with minimal instance contexts.

### GR-cells — `cocycleCondition` / `lem:gr_cocycle` (SOLVED, axiom-clean)
The headline win. 12 new decls (triple-overlap localised transition maps `cocycleΘIJ/JK/IK` +
8 helpers + `cocycleCondition`), file fully GREEN, 0 sorry, `lean_verify` clean.
- Design call (kept): no generic `S_K/S_J/S_I` ring builder — the blueprint ordering convention is
  **not permutation-symmetric**, so a generic builder produces the wrong product order (a distinct,
  non-defeq `Localization.Away` type). The `cocycleΘ` defs carry the products inline.
- Proof: `IsLocalization.ringHom_ext` → `Away.lift_comp` → `MvPolynomial.ringHom_ext` → generator step
  = matrix identity (`(X^I_K)⁻¹X^I = θ_{I,J}((X^J_K)⁻¹X^J)`, both reduce to `(Y_K)⁻¹Y`).
- **Reusable gotcha (now in Knowledge Base):** `rw [Matrix.map_mul]` / `rw [RingHom.map_det]` on
  `Localization.Away`-base-changed matrices fails "pattern not found" (hidden `algebraMap` instance
  diamond); state the distributed form as a `have` closed by `exact Matrix.map_mul` (defeq path), then `rw`.

### SNAP-S2 / QUOT — `gradedModule_hilbertSeries_rational` (BLOCKED on a genuine Mathlib gap)
The **entire power-series half** of Stacks 00K1 landed as 8 axiom-clean private helpers — notably
`rationalHilbert_antidiff` (antidifference step) and `IsRatHilb.ofDiffEq` (the inductive-step engine:
a degreewise SES first-difference identity yields `IsRatHilb` at `d+1`). The main theorem reduces to
one graded-SES additivity input.
- **The public theorem is NOT added** (would require a sorry, forbidden). Blocker is a **Mathlib gap,
  not a tactic gap:** no packaged graded-module quotient `M/xM`, graded kernel of a degree-shifting
  endo, regrading over `A/(x)`, nor `Module.Finite` transfer through these as GRADED objects
  (`GradedModule` is not a class — only `DirectSum.Decomposition` + `SetLike.GradedSMul`). This graded
  API is a multi-lemma sub-build, the correct unit of work for a dedicated next-iter lane.
- **Pins discovered:** `open PowerSeries Polynomial in` must precede the docstring; `ℚ[X]` notation
  did not resolve (use `Polynomial ℚ`); `PowerSeries.C` takes the ring as an implicit arg.

## Review subagents dispatched (5; all returned)
- **lean-auditor `iter012`** — 20 issues (14 must-fix / 3 major / 3 minor / 0 excuse). The 14 "must-fix"
  are all **openly-disclosed sorry bodies on load-bearing decls — no weakened statements, no deception**.
  GrassmannianCells fully axiom-clean, cocycle verified non-circular. The 3 **major = stale cross-project
  STATUS comments** (iter-234/236/240/241 in FlatBaseChange; iter-177+ in QuotScheme) orphaned from the
  pre-extraction AlgebraicJacobian project. Prover-cleanup (review cannot edit `.lean`).
- **lvb-fbc** — no must-fix; 1 minor dangling `\uses{lem:base_change_regroup_linearEquiv}` in
  `lem:base_change_mate_regroupEquiv`.
- **lvb-gf** — no must-fix, no major. Minor: 13 sorry-free proof blocks missing `\leanok` (sync_leanok
  timing); 2 stale comment typos in `gf_torsion_reindex` (`≃ₐ[A]`→`≃ₐ[A_g]`, `Module.Finite`→`RingHom.Finite`).
- **lvb-gr** — no must-fix. 2 major: `affineChart` omits the `hI : I.card = d` guard; **blueprint coverage
  gap** — `cocycleΘIJ/JK/IK` + `universalMatrix_map_transitionPreMap` are public decls with no `\lean{}`.
  4 minor coverage helpers.
- **lvb-quot** — **1 must-fix:** `Scheme.Grassmannian.representable` (QuotScheme.lean:225) is a weakened
  skeleton (`∃ Y, Nonempty (RepresentableBy Y)`) dropping the prose's smooth/proper/rel-dim-`d(r-d)`/
  tautological-quotient/Plücker content, with an "iter-177+ refinement work" excuse-comment — the
  `\lean{thm:grassmannian_representable}` pin is corrupted. 2 major: `Grassmannian` def missing rank
  hypotheses; `QuotFunctor`/`hilbertPolynomial` `_L` typed plain `X.Modules` not a line bundle.

Reports under `.archon/task_results/` (auto-archived to `logs/iter-012/`). Findings landed in
`recommendations.md`.

## Blueprint markers updated (manual)
- `Picard_QuotScheme.tex`, `lem:gradedHilbertSerre_rational`: added `% NOTE (iter-012)` recording that
  the power-series engine landed and the public theorem is blocked on the absent Mathlib graded API.
- `Picard_QuotScheme.tex`, `thm:grassmannian_representable`: added `% NOTE (iter-012, lvb)` flagging that
  the Lean STATEMENT (not just the proof) is a weakened skeleton and the `\lean{}` pin under-delivers.
- No `\lean{...}` corrections needed (`cocycleCondition` matches its pin). No stale `\notready` found.
  No `\mathlibok` added (no new decl is a pure Mathlib re-export/alias).

## Key findings / patterns
1. **Decomposition raises sorry count honestly** — FBC's +2 is the plan's requested split; verifiers
   confirm no deception. Judge FBC by "genuine content proven + holes precisely characterized," not raw count.
2. **Inline instance-stacking is the recurring GF/QUOT wall** — both GF (a)-(e) and earlier GF attempts
   blow `isDefEq`/`whnf` heartbeats when 4+ module/algebra instances stack on one `LocalizedModule` type.
   The corrective is **standalone helper lemmas**, not bigger heartbeat budgets.
3. **`rw` syntactic matcher fails on `Localization.Away`-base-changed matrices** (instance diamond);
   use `have … := exact Matrix.map_mul` then `rw` the hypothesis. (Now in Knowledge Base.)
4. **A genuine Mathlib gap ≠ a stuck route** — QUOT's graded-module API absence is a well-scoped sub-build,
   correctly deferred to a dedicated lane rather than forced with a sorry.
