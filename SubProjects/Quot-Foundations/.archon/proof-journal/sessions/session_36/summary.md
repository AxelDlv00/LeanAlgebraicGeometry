# Session 36 (iter-036) — Review Summary

## Metadata
- **Iteration:** 036 · **Session:** session_36 · **Model:** claude-opus-4-8
- **Global active sorry:** unchanged net. Per-file: FBC 4→4, QUOT 4→4 (protected stubs),
  GR 0→0, FlatteningStratification 1 (GF, untouched), all other modules 0.
- **Builds:** all three prover-touched modules `lake build` exit 0 (GrassmannianCells 8317 jobs/32s,
  QuotScheme 8317 jobs). New decls `lean_verify` = `{propext, Classical.choice, Quot.sound}`.
- **blueprint-doctor:** 0 findings. **sync_leanok (iter 36, sha 0b6513b):** +24 `\leanok`, 0 removed.
- **Targets attempted:** 3 parallel import-independent lanes — FBC-A (gstar_transpose step b),
  GR-existence (E1/E2/E3-core), QUOT-Hfr (gammaPullback section transport).

**Headline: a +7-axiom-clean-decl infrastructure iter (1 FBC + 3 GR + 3 QUOT), net 0 active sorry.**
Each lane hit its assigned objective; the two hard residuals (FBC gstar steps a/c, QUOT Hfr chaining)
are precisely characterized with named blockers. The FBC iter-035 explicit-inverse pivot was
**reverted** by the planner (strategy-critic CHALLENGE: the element route unfolds back onto
gstar_transpose); FBC-A resumed the conjugate-`huce` route and landed step (b), so the iter-036
tripwire's SUCCESS condition was met and the route is NOT escalated.

---

## Lane 1 — FBC-A: `base_change_mate_gstar_transpose` step (b) (FlatBaseChange.lean)

**Target:** close `base_change_mate_gstar_transpose` (the `(g^*⊣g_*)`-transpose section identity)
via the conjugate-counit `huce` remainder, decomposed into steps (a)/(b)/(c).

**Result: step (b) SOLVED axiom-clean as standalone `base_change_mate_extendScalars_inner_value_counit`
(@~1999); gstar_transpose sorry unchanged (steps (a)+(c) remain). Sorry 4→4.**

The new lemma states:
`(extendScalars ψ).map (base_change_mate_inner_value ψ φ M) ≫ (extendRestrictScalarsAdj ψ).counit.app _
= (base_change_mate_regroupEquiv ψ φ M).inv`.

Proof chain (≈12 lines, verified via `lean_goal` at each step):
1. `ext x` — reduces the `R'`-linear goal to the single generator `1⊗ₜx`.
2. `simp only [ModuleCat.extendScalars, ModuleCat.extendRestrictScalarsAdj]` +
   `change (...counit.app _ _) = _` — exposes the algebraic counit.
3. `erw [ExtendRestrictScalarsAdj.counit_app]; rw [ExtendScalars.map']` — `baseChange` sends
   `1⊗ₜx ↦ 1⊗ₜρ(x)`.
4. `erw [ExtendRestrictScalarsAdj.Counit.map_apply_one_tmul]` — counit sends `1⊗ρ(x) ↦ ρ(x)`; LHS
   collapses to the bare affine inner value `ρ(x)`.
5. Residual goal `ρ(x) = regroupEquiv.inv (1⊗ₜx)` holds **definitionally** (both unwind to
   `(1 : A⊗R')⊗ₜx` — `ρ` via identity-on-carrier `restrictScalarsComp'App`/`restrictScalarsCongr`
   bridges, `regroupEquiv.inv` via the `comm ≫ cancelBaseChange ≫ comm` chain); closed by
   `exact congrArg _ rfl`.

**Steps (a) and (c) NOT advanced (named blockers):**
- **Step (a)** `Γ_R(θ_in)=ρ` inline reproof — blocker: the ≈100-LOC pseudofunctor leg-reindex
  telescoping under the `X.Modules` instance diamond, reproving the inner reindex INLINE from the
  PROVED standalone inputs `..._legs_unitExpand`@1317, `..._gammaDistribute`@1348,
  `gammaMap_pushforwardComp_{hom,inv}_eq_id`@1218/1226, Seam-1 `base_change_mate_unit_value`@987,
  `pullbackPushforward_unit_comp`@1144 (NOT via the sorry-backed `base_change_mate_fstar_reindex_legs`).
- **Step (c)** dictionary cancellation — gated on (a); the `huce` master identity
  `base_change_mate_gstar_counit_transport`@1951 is proven & ready. In-file note: `set W` does not
  fold the goal's `ε_g` argument — stage via `conv`/`change`, not a bare `rw`.

**FBC sorry inventory (4, all pre-existing, per lean-auditor):**
1. ~L1700 `base_change_mate_fstar_reindex_legs_conj` (conj-2a) — now **off the critical path**
   (pruning debt); the iter-035 pivot that targeted it was reverted.
2. ~L2167 `base_change_mate_gstar_transpose` — TARGET; step (b) closed, (a)+(c) remain.
3. ~L2348 `affineBaseChange_pushforward_iso` — off critical path, downstream of L2167.
4. ~L2370 `flatBaseChange_pushforward_isIso` — off critical path, Čech infrastructure deferred.

---

## Lane 2 — GR-existence: E1/E2/E3-core (GrassmannianCells.lean)

**Result: 3 decls SOLVED axiom-clean; E3-full BLOCKED on a flagged matrix gap. Sorry 0→0.**

- **E1 `existence_chart_factorization`** (pinned `lem:gr_existence_chart_factorization`): a `K`-point
  of a field `Spec` is one point, covered by a chart immersion (`GlueData.ι_jointly_surjective`);
  range condition from `Subsingleton (Spec K)`; `IsOpenImmersion.lift` factors `i₁` through `ι I`;
  `Spec.preimage`/`Spec.map_preimage` turn it into `Spec` of a ring hom; `lift_fac` closes.
  **Gotcha:** `IsOpenImmersion ((theGlueData d r).ι I)` is not picked up from a local `haveI` —
  passed explicitly via `@IsOpenImmersion.lift _ _ _ … hoi …` (and `lift_fac`).
- **E2 `existence_minimal_valuation`** (pinned `lem:gr_existence_minimal_valuation`): maximise
  `v(f(P^I_J))` over the finite chart index (`Finite.exists_max`, `v := ValuationRing.valuation R K`);
  at the maximiser `v(f(P^I_I))=v(f 1)=v 1=1` so `1≤v(f(P^I_J))`, hence `≠0` via `Valuation.ne_zero_iff`.
  **Gotcha:** `Finite (theGlueData d r).J` is not synthesized — the `.J` projection blocks instance
  search; supplied via `inferInstanceAs (Finite {I : Finset (Fin r) // I.card = d})`.
- **E3 ratio core `existence_lift_transitionPreMap_minorDet_mul`** (NEW helper, no blueprint block):
  `f' := IsLocalization.Away.lift (minorDet) hf`; apply `f'` (congrArg+map_mul) to the ring-level
  `transitionPreMap_minorDet_mul`; `IsLocalization.Away.lift_eq` collapses the algebraMap images,
  yielding `g(P^J_K)·f(P^I_J)=f(P^I_K)` (the displayed E3 equation). Reusable; does NOT touch the
  cofactor gap.

**E3-full `existence_factor_through_valuationRing` BLOCKED (genuine, blueprint-acknowledged):**
factoring `g : R^J → K` through `R ⊆ K` needs every free generator `x^J_{p,q}` (`q∉J`) in `R`, which
reduces to a cofactor/Laplace expansion of a column-substituted identity minor. **No pre-existing
Mathlib matrix-algebra scaffold** for `det (1.updateColumn p (X q)) = ±(X q) p`. The chapter flags
this as the one matrix gap. **Precise next ingredient (iter-037):** the column-substituted-identity
determinant helper, then transport through the `K'`-vs-`J` order-iso; Mathlib candidates to scout:
`Matrix.det_updateColumn_*`, `Matrix.updateColumn`, `Matrix.det_succ_column`, `Matrix.cramer`.
**Dead end to avoid:** do NOT attempt E3 factorization without the cofactor helper.

---

## Lane 3 — QUOT-Hfr: gammaPullback section transport (QuotScheme.lean)

**Result: 3 decls SOLVED axiom-clean (lane's pinned objective COMPLETE); Hfr/descent/gap1 BLOCKED
(NOT a one-liner). Sorry 4→4 (protected stubs unchanged).**

- **`gammaPullbackTopIso`** (pinned `lem:pullback_gamma_top_iso`): `U=⊤` instance of
  `gammaPullbackImageIso`, then `eqToIso` along `Scheme.Hom.image_top_eq_opensRange`.
- **`gammaPullbackImageIso`** (NEW, general-in-`U`): `Γ(-,U)` of the inverse of Mathlib's
  `restrictFunctorIsoPullback f` at `M`. **Dead end (do not retry):**
  `asIso (((restrictFunctorIsoPullback f).symm.app M).hom.app U)` — Lean fails to synthesize
  `IsIso (Hom.app φ U)` even with `haveI : IsIso φ` in scope (the Mathlib instance at
  `Sheaf.lean:137` doesn't fire through `inferInstance`). **Fix:** apply the sections functor
  `toPresheaf ⋙ (evaluation).obj (op U)` via `Functor.mapIso` — sidesteps instance synthesis.
- **`gammaPullbackImageIso_hom_naturality`** (NEW): the hom reduces definitionally to the
  `mapPresheaf` component; `exact (...).hom.mapPresheaf.naturality i.op`. Intertwines restriction maps
  (incl. the `D(f)⊓U ≤ U` the descent needs).

**Hfr chaining / `isLocalizedModule_basicOpen_descent` / gap1 BLOCKED — the blueprint NOTE's
"one-liner" claim was over-optimistic (corrected this review).** Two Mathlib-absent ingredients sit
between `gammaPullbackTopIso` and Hfr:
- **(I)** ring-iso-semilinear `IsLocalizedModule` transport. The section iso is an `Ab` iso whose
  underlying map is only `Γ(X,U)`-semilinear over the **source-scheme** ring; Hfr is `R`-linear.
  Mathlib only has same-ring `IsLocalizedModule.of_linearEquiv`(`_right`) — already exhausted by the
  affine engine.
- **(II)** base-change-of-localization `R → R_r`. P1 yields `IsLocalizedModule (powers f')` **over `S`**
  (`S ≅ R_r`); Hfr wants `IsLocalizedModule (powers f)` **over `R`**. No direct Mathlib lemma
  (`lean_leansearch` returned only same-ring transports).

**Decomposition for the planner (from the prover):** (1) `isLocalizedModule_of_addEquiv_semilinear`;
(2) base-change-of-localization identification; (3) chain `gammaPullbackImageIso` through the three
pullbacks of `isIso_fromTildeΓ_restrict_basicOpen` + `overRestrictPullbackIso`; (4) assemble Hfr,
instantiate `isLocalizedModule_basicOpen_descent_of_cover` (landed iter-035) at the QC cover, gap1
via `isIso_fromTildeΓ_of_isLocalizedModule_restrict`.

---

## Key findings / patterns discovered
- **Algebraic-counit reduction (FBC step b):** `ext x` → `ExtendScalars.map'` →
  `Counit.map_apply_one_tmul` collapses an `extendScalars`/counit composite to a bare module value;
  the residual carrier equality often closes by `exact congrArg _ rfl` (defeq).
- **Functor.mapIso over `asIso (φ.app U)` (QUOT):** when `IsIso (φ.app U)` won't synthesize even with
  `IsIso φ` in scope, build the section iso as `(sectionsFunctor).mapIso φ` instead.
- **Explicit `@`-instances for `theGlueData`:** both `IsOpenImmersion (ι I)` and `Finite/.J` fail
  inferInstance through the GlueData projection; supply `@`-application / `inferInstanceAs` on the
  unfolded subtype.
- **"One-liner" blueprint NOTEs are a recurring over-optimism trap:** the QUOT descent NOTE claimed a
  trivial chain that hides two genuine Mathlib-absent transports. Corrected this review.

## Subagent dispositions (all dispatched this review phase)
- **lean-auditor `iter036`** (3 files): 4 must-fix / 3 major / 3 minor. The 4 must-fix are the
  **pre-existing iter-176 protected scaffold stubs** in QuotScheme (`hilbertPolynomial`,
  `QuotFunctor`, `Grassmannian`, `Grassmannian.representable` `:= sorry`) — strict-criteria flags, not
  new dead code. All 7 new decls confirmed honest + axiom-clean; FBC's 4 sorries characterized (2 off
  critical path). → recommendations §3.
- **lean-vs-blueprint-checker ×3:** `fbc` 0 must-fix (NOTE accurate, step-b prose matches);
  `gr` 0 must-fix, 1 major (E3 ratio-core coverage debt) + 9 private-pin minor; `quot` **1 must-fix**
  (over-optimistic "one-liner" NOTEs — FIXED this review) + 2 major (missing pins for
  `gammaPullbackImageIso`/`_hom_naturality`). → recommendations §1/§2.

## Blueprint markers updated (manual)
- `Cohomology_FlatBaseChange.tex`, `lem:base_change_mate_fstar_reindex_legs_conj`: rewrote the stale
  `% NOTE` (claimed iter-036 executes explicit-inverse pivot) → iter-036 reverted that pivot, resumed
  conjugate-`huce` and landed step (b); conj-2a now off the critical path / pruning debt.
- `Picard_QuotScheme.tex`, `lem:pullback_gamma_top_iso`: updated `% NOTE` (decl LANDED; corrected the
  "one-liner" claim — two Mathlib-absent ingredients remain).
- `Picard_QuotScheme.tex`, `lem:section_localization_descent`: added `% NOTE (iter-036, review)`
  correcting the "both one-liners" claim; named the two remaining ingredients for the planner.
- No `\leanok` touched (deterministic sync owns it); no `\mathlibok` added (all new decls are bespoke
  project infra, not Mathlib re-exports).

## Recommendations for next session
See `recommendations.md`. Headlines: (1) blueprint the QUOT/GR/FBC coverage-debt helpers; (2) FBC
iter-037 = prove step (a)+(c) (stay conjugate-`huce`, NOT element-ext, NOT conj-2a); (3) QUOT iter-037
= build ingredients (I) ring-iso-semilinear transport + (II) base-change-of-localization as standalone
steps; (4) GR iter-037 = build the column-substituted-identity determinant helper, then E3.
