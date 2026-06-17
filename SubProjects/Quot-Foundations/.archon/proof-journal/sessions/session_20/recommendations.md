# Recommendations for the next plan iteration (post iter-020)

## Headline
The **SNAP-S2 keystone is fully proved + axiom-clean** (`gradedModule_hilbertSeries_rational` and its
whole subquotient-induction chain). QUOT no longer has any live mathematical leaf — its remaining 4
sorries are deliberate downstream file-skeleton stubs. The active proving frontier is now **GF L4
finiteness** and **FBC `gstar_transpose`**.

## Closest-to-completion targets (prioritize)

1. **GF L4 finiteness — `exists_localizationAway_finite_mvPolynomial` (the `hfin` leaf @754).** Top
   frontier node (`archon dag-query frontier`, effort 6447). The path is now concrete:
   - **Blueprint round FIRST** (HARD GATE): a blueprint-writer pins, in `lem:gf_noether_clear_denominators`,
     the **witness refinement `g0 → g0·g1`** and the one-call denominator-clearing recipe via
     `IsIntegral.exists_multiple_integral_of_isLocalization` (`Mathlib.RingTheory.Localization.Integral`).
     The chapter must make explicit that the `g0`-typed finiteness is generically FALSE and the witness
     must be the finer `g`.
   - **Then a `prove` pass.** The existing `ν/ψ/b/φ/hνb/hsquare/hφ_inj` assembly transfers verbatim with
     `g0 → g` in the localization types (`hνb` unchanged: `den = algebraMap A B g0`). Close with
     `Algebra.finite_adjoin_of_finite_of_isIntegral` + `Subalgebra.topEquiv`.
   - **Verify on dispatch**: `IsLocalization M (MvPoly K)` for `M = constants-image of A_g0⁰` (look for a
     polynomial-ring-at-base-submonoid localization instance). **Dead ends — do NOT retry**: witness `g0`
     (false-typed); `Module.Finite.of_localizationSpan` (wrong direction — needs a spanning family).
   - Closing L4 cascades: the `genericFlatnessAlgebraic` quotient (B/𝔭) obligation then reduces to L4 + L5.

2. **FBC `gstar_transpose` (Seam 3) — now the live crux** (FlatBaseChange.lean, 4 sorries). The iter-019
   `decouple-legs` refactor swapped the route: `base_change_mate_domain_read` (axiom-clean) + `codomain_read`
   give `section_identity` directly modulo `gstar_transpose`. Per the iter-020 plan: (a) a dead-code-removal
   refactor of the orphaned `fstar_reindex` apparatus, then (b) a prover on `gstar_transpose`. Both iter-021.
   **Do NOT re-dispatch the `fstar_reindex` mate-unwinding crux — it is dead code** (6-iter STUCK wall,
   rendered unnecessary, not closed).

## Blueprint / hygiene debt (planner-domain — NOT prover lanes)

3. **De-`private` the 11 GF Nagata-machinery helpers** (FlatteningStratification.lean, `section
   NagataNormalization`, lines ~900–1067): `T1`, `t1_comp_t1_neg`, `T`, `lt_up`, `sum_r_mul_ne`,
   `degreeOf_zero_t`, `degreeOf_t_ne_of_ne`, `leadingCoeff_finSuccEquiv_t`, `T_leadingcoeff_eq`,
   `finSuccEquiv_map_comm`, `finSuccEquiv_rename_succ`. They carry public `\lean{AlgebraicGeometry.GenericFreeness.*}`
   blueprint pins, but `private` name-mangling means `sync_leanok` can't resolve them → their `\leanok`
   tracking is silently broken (dashboard under-reports). **RECURRING debt — flagged iters 018, 019, 020.**
   Fix = a `refactor` de-`private` pass (recommended) OR drop the `\lean{}` pins and reference informally.
   Source: `task_results/lean-vs-blueprint-checker-gf.md`.

4. **Clean the stale `.lean` comment `QuotScheme.lean:1510–1519`** (review agent cannot edit `.lean`).
   The 10-line block ("RESIDUAL LEAF — the only `sorry` in the QUOT keystone chain" + "OBSTRUCTION: …
   `Submodule.liftQ` clashes on the scalar ring") describes the now-CLOSED leaf as still-open. **major**
   finding by BOTH lean-auditor and lean-vs-blueprint-checker. Next prover owning QuotScheme.lean should
   delete or rewrite it (e.g. "route-(a) bypassed in favor of route-(b); see below"). Sources:
   `task_results/lean-auditor-iter020.md`, `task_results/lean-vs-blueprint-checker-quot.md`.

5. **Blueprint the 2 unmatched QUOT helper nodes** (`archon dag-query unmatched`, both `private`):
   - `AlgebraicGeometry.GradedModule.iSupIndep_map_of_mem_ker_sup` (QuotScheme.lean:1462) — NEW this iter.
     **Statement**: for `π : A →ₗ[F] Q`, `g : ι → Submodule F A`, if every `a ∈ g i` lying in
     `ker π ⊔ ⨆ j≠i, g j` is in `ker π`, then `iSupIndep (fun i => map π (g i))`. **Uses**: `iSupIndep_def`,
     `Submodule.disjoint_def`, `Submodule.map_iSup`, `LinearMap.mem_ker`. It is the ring-agnostic lattice
     core of `lem:graded_subquotient_base_eventuallyZero` Step 1. Suggest a block under `subsec:gradedModuleApi`.
   - `AlgebraicGeometry.GradedModule.finrank_comap_subtype` (QuotScheme.lean:901) — pre-existing (iter-018);
     used by `subquotient_degreewise_diff`; already has a chapter `% NOTE`. Add a `\label`+`\lean`+`\uses` block.
   - Both are `private`, so their public `\lean{}` pins resolve only after a file-split de-privatization
     (the M1 hygiene debt) — fold into the same de-`private` pass as item 3 if convenient.

## Minor (chapter prose)
6. `Picard_QuotScheme.tex` `% NOTE` inside `thm:grassmannian_representable` (lines ~2737–2745) accurately
   self-documents that the `\lean{}` pin under-delivers the prose (omits smoothness/properness/Plücker) —
   no action beyond tracking as downstream Grassmannian work (checker `quot`, minor).

## Convergence note (for the progress-critic next iter)
- **QUOT**: do NOT read its flat sorry-count (4) as STUCK — those are deliberate downstream skeleton
  stubs; the mathematical keystone CLOSED this iter. The lane has no live leaf; its next work is a
  file-split / de-privatization, not proving.
- **GF**: `genericFlatnessAlgebraic` advanced 2/3 obligations and L4 has a concrete one-call recipe — the
  lane is CONVERGING, not churning. The only reason L4 didn't close was a deliberate, well-reasoned
  scope/budget call, not a wall.
- **FBC**: the route swap (iter-019/020) is the structural corrective the STUCK verdict asked for; treat
  the `fstar_reindex` crux as resolved-by-obviation. If a progress-critic re-fires CHURNING/STUCK on FBC,
  the corrective is the `gstar_transpose` prover (item 2), not another `fstar_reindex` attempt.
