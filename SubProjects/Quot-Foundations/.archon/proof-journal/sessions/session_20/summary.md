# Session 20 — Review summary (iter-020)

## Metadata
- **Iteration / session**: iter-020 / session_20
- **Prover model**: claude-opus-4-8
- **Lanes dispatched**: 2 (QUOT = QuotScheme.lean; GF = FlatteningStratification.lean). FBC = no
  prover this iter (route just swapped by an iter-019 refactor; cleanup + `gstar_transpose` prover
  are iter-021 — planner decision).
- **Build**: both edited files GREEN under `lake build` (FlatteningStratification 8317 jobs;
  QuotScheme 8317 jobs). Only expected `sorry` + linter warnings. blueprint-doctor: 0 findings.
- **Active sorry per file (after)**:
  - QuotScheme.lean: **4** (the 4 deliberate file-skeleton stubs @126/165/201/228). The keystone
    `iSupIndep` leaf @~1494 was **CLOSED** → net **−1**.
  - FlatteningStratification.lean: **3** (L4 finiteness leaf @754; `genericFlatnessAlgebraic`
    quotient case @1810; `genericFlatness` GF-geo @1898) — net **0**, but `genericFlatnessAlgebraic`
    advanced 2/3 dévissage obligations.
  - FlatBaseChange.lean: **4** (untouched this iter — no prover lane).
- **Net this iter**: **−1 active sorry**, **+2 axiom-clean** declarations (1 new private helper +
  the closed keystone chain). Headline: **the SNAP-S2 keystone is now fully proved.**

## Target 1 — QUOT keystone leaf SOLVED (the headline result)

`AlgebraicGeometry.GradedModule.subquotient_base_eventuallyZero` (QuotScheme.lean:1486) — the single
residual `iSupIndep` base-case leaf, the last hole between the project and a fully-proved SNAP-S2
keystone.

- **Constraint honored**: ROUTE (b) ONLY. Route (a) (an outgoing κ-linear detector `Φ : Q₀ → M/N'`
  built via `Submodule.liftQ`) was hard-prohibited by the planner (confirmed scalar-ring dead end:
  `S = MvPolynomial (Fin 0) κ` vs `κ`) and never attempted. HARD ENTRY CONSTRAINT honored — no
  `DirectSum.Decomposition`/`IsInternal` on any quotient/subtype carrier; every graded fact stated in
  the ambient `M`. No `isDefEq`/`whnf` recurrence, no heartbeat bumps fired (continues to validate the
  Route-2 pivot).
- **Proof structure (3 ingredients)**:
  1. **Abstract lattice core** — new `private lemma iSupIndep_map_of_mem_ker_sup` (ring-agnostic): for
     `π : A →ₗ[F] Q` and `g : ι → Submodule F A`, if every `a ∈ g i` lying in `ker π ⊔ ⨆ j≠i, g j` is
     already in `ker π`, then `iSupIndep (fun i => map π (g i))`. Proof = `iSupIndep_def` +
     `Submodule.disjoint_def` + `Submodule.map_iSup`.
  2. **Ambient degree-`i` core** (`have core`): a homogeneous `x ∈ ℳ i` lying in `N' ⊔ ⨆ j≠i, ℳ j` is
     in `N'`. Built with the κ-linear degree-`i` projection
     `proj = (ℳ i).subtype ∘ component i ∘ decomposeLinearEquiv ℳ` (`proj m = ↑(decompose ℳ m i)`,
     defeq): `proj x = x` (`decompose_of_mem_same`), `proj` kills `⨆ j≠i, ℳ j`
     (`decompose_of_mem_ne`), `proj u ∈ N'` for `u ∈ N'` (`IsHomogeneous.mem_iff`).
  3. **Glue**: κ-linear quotient map `Φ : ↥N → Q` (un-restricted `ψ`), `g n = comap N.subtype (N ⊓ ℳ n)`,
     `range (ψ n) = map Φ (g n)` via `ψ n = Φ ∘ₗ inclusion inf_le_left` + `range_comp` +
     `range_inclusion`; apply ingredient 1, discharge its hypothesis by pushing the `↥N`-level join down
     to `M` along `N.subtype` (`map_sup`/`map_iSup`/`map_comap_le`) into `core`.
- **One intermediate error fixed mid-proof**: an `LinearMap.mem_ker` rewrite needed `SetLike.mem_coe`
  first → `rw [SetLike.mem_coe, LinearMap.mem_ker, hΦ] at hc`.
- **Verification**: `lean_verify` on `subquotient_base_eventuallyZero` AND on the keystone
  `AlgebraicGeometry.gradedModule_hilbertSeries_rational`: axioms `[propext, Classical.choice,
  Quot.sound]` (kernel-only, **axiom-clean**). `subquotient_base_eventuallyZero` ⟹
  `subquotient_hilbertSeries_rational` ⟹ `gradedModule_hilbertSeries_rational` all sorry-free.
- **Incidental tidy**: added `omit [∀ n, FiniteDimensional κ ↥(ℳ n)] in` on
  `subquotient_base_eventuallyZero` to silence a now-correctly-firing unused-section-variable linter
  (the instance was masked by the old `sorry`). No interface change; downstream callers unaffected.

## Target 2 — GF dévissage motive + 2/3 obligations CLOSED

`AlgebraicGeometry.genericFlatnessAlgebraic` (FlatteningStratification.lean:1767). The CHURNING
corrective required closing a dévissage step this session — done.

- **Approach**: prime-filtration induction `IsNoetherianRing.induction_on_isQuotientEquivQuotientPrime B`
  (added `haveI : IsNoetherianRing B := Algebra.FiniteType.isNoetherianRing A B`) with motive
  `P N := letI : Module A N := Module.compHom N (algebraMap A B); ∃ f ≠ 0, Free A_f (N_f)`. Scalar
  tower on each `N` from `IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)`.
- **Closed**: (i) **subsingleton** ⟹ `exists_free_localizationAway_of_torsion` with
  `htors` from `LocalizedModule.subsingleton_iff.mpr`; (ii) **short-exact** ⟹
  `exists_free_localizationAway_of_shortExact` fed the two ends' destructured witnesses (induction maps
  `i,q` are already `B`-linear).
- **Residual `sorry`**: the **quotient (N≅B/𝔭)** finite-type case — bottoms out at L4 + L5; cannot
  close until L4 finiteness closes. Honest residual.
- **Key transport insight (resolves a long-deferred plumbing concern)**: the induction yields
  `motive M` for the `compHom` A-structure but the goal uses the AMBIENT `Module A M`. Proved
  `hAinst : (Module.compHom M (algebraMap A B) : Module A M) = ‹Module A M›` via `Module.ext_iff.mpr`
  + `funext` + `change algebraMap A B a • m = a • m` + `rw [Algebra.algebraMap_eq_smul_one, smul_assoc,
  one_smul]`, then `rw [hAinst] at key; exact key`. The instances are **propositionally equal**, and
  `rw` on the instance transports the localization — dissolving the "defeq-compatible `Module A N`"
  worry that the old comment deferred.

## Target 3 — GF L4 finiteness leaf: assessed, deliberately NOT modified (honest scope call)

`AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial` (the `hfin` `sorry`
@754). UNCHANGED — but the prover surfaced the decisive finding and the path.

- **Why not touched**: the current `hfin` @754 has a **generically-FALSE local type**
  (`Module.Finite (MvPoly A_g0) B_g0` via `φ.toAlgebra`): `B_{g0}` is not module-finite over
  `A_{g0}[X]` until the integral-dependence denominators are cleared by inverting a further `g1`. An
  honest close MUST change the existential witness `g0 → g0·g1`, which forces rebuilding the
  `ν/ψ/b/φ/hφ_inj` assembly (lines ~634–738, inside `maxHeartbeats 4000000`) for the finer `g` — a
  ~150–250-line localization-heavy rebuild that risked the working assembly without a reliable finish
  in budget. Left compiling.
- **KEY LEMMA FIND (collapses the hardest part)**:
  `IsIntegral.exists_multiple_integral_of_isLocalization` (`Mathlib.RingTheory.Localization.Integral`)
  clears the denominators of an integral relation in ONE call, replacing the manual per-coefficient
  fold. Apply with `R = MvPoly A_g0`, `Rₘ = MvPoly K`, `S = B_K`, `x = σ_i` image; yields `m_i` with
  `m_i • x_i` integral over `MvPoly A_g0`; invert `g1 := ∏ (A-parts of m_i)`. Then
  `Algebra.finite_adjoin_of_finite_of_isIntegral` (verified) + `Subalgebra.topEquiv`.
- **Dead ends to avoid**: committing the witness to `g0` (false-typed finiteness);
  `Module.Finite.of_localizationSpan` (needs finiteness on a *spanning* family of opens — wrong
  direction).

## Subagent reports (this review)

- **lean-auditor `iter020`** — 7 files audited, **0 must-fix**, 1 **major**: stale comment block
  `QuotScheme.lean:1510–1519` ("RESIDUAL LEAF — the only sorry" / "OBSTRUCTION") on a proof that is now
  complete. No excuse-comments; all other `sorry`-bearing blocks carry honest scaffolding. Report:
  `task_results/lean-auditor-iter020.md`.
- **lean-vs-blueprint-checker `quot`** — keystone chain VERIFIED faithful to the blueprint (route-(b)
  ambient-membership matches the chapter prose); 59 decls checked, **0 must-fix**, 1 major (same stale
  comment 1510–1519), 2 minor (stale chapter `% NOTE` @406–410 — fixed this review; `IsRatHilb` toolkit
  private/public-pin discrepancy). Report: `task_results/lean-vs-blueprint-checker-quot.md`.
- **lean-vs-blueprint-checker `gf`** — all 3 `sorry`s honest-open; 43 decls checked, **0 must-fix**, 1
  major (**pre-existing, not this iter**): 11 `private` Nagata-machinery declarations carry public
  `\lean{}` blueprint pins → `private` name-mangling means the pins won't resolve, breaking
  `sync_leanok` `\leanok` tracking for those 11. Recommend de-`private`. Report:
  `task_results/lean-vs-blueprint-checker-gf.md`.

## Blueprint markers updated (manual)
- `Picard_QuotScheme.tex`, `lem:gradedHilbertSerre_rational`: updated stale `% NOTE` (lines 406–409)
  — replaced "The present theorem is not yet a Lean declaration" with a note that as of iter-020 it IS
  a closed, axiom-clean Lean declaration (`gradedModule_hilbertSeries_rational`).

## Coverage debt (`archon dag-query unmatched` → 2 nodes)
Both `private`, both must be blueprinted by the planner (see recommendations.md):
- `AlgebraicGeometry.GradedModule.iSupIndep_map_of_mem_ker_sup` (QuotScheme.lean:1462) — NEW this iter.
- `AlgebraicGeometry.GradedModule.finrank_comap_subtype` (QuotScheme.lean:901) — pre-existing (iter-018).

## Key findings / patterns
- Route (b) (ambient degree-`i` homogeneous-component membership) closes degreewise `iSupIndep` without
  any outgoing map out of the polynomial-quotient carrier; route (a) (`liftQ` detector) is a confirmed
  scalar-ring dead end. See Knowledge Base.
- `Module.compHom` restricted-scalar motive + propositional instance transport (`Module.ext_iff` +
  `rw [hAinst]`) is the general dévissage plumbing for "the induction's restricted A-action vs the
  ambient `Module A` instance".
- `IsIntegral.exists_multiple_integral_of_isLocalization` is the one-call denominator-clearing tool for
  the GF L4 finiteness rebuild.

## Recommendations
See `recommendations.md`. Top items: (1) GF L4 finiteness via the witness-refinement recipe (blueprint
round then prove); (2) FBC `gstar_transpose` prover + `fstar_reindex` dead-code removal; (3) clean the
stale `QuotScheme.lean:1510–1519` comment; (4) de-`private` the 11 GF Nagata helpers (recurring
`sync_leanok` debt, flagged iters 018/019/020); (5) blueprint the 2 unmatched QUOT helpers.
