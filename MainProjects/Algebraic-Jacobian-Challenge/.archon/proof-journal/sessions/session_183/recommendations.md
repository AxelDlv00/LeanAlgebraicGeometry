# Iter-184 plan recommendations

## CRITICAL — do this iter-184 plan-phase or carry forward

1. **Lane B `GmScaling.lean` — 5-iter CHURNING; DO NOT re-fire without mathlib-analogist consult.** Per iter-183 progress-critic mandate and the Lane B prover's documented Q1/Q2/Q3 (in task_result), iter-184 plan-phase MUST dispatch a `mathlib-analogist` consult on these three questions BEFORE re-firing Lane B:
   - **Q1**: What is the canonical Mathlib idiom for collapsing `inv (pullback.map _ _ _ _ (𝟙) i₂ (𝟙) _ _) ≫ pullback.fst _ _` when `i₂ : Iso`? The natural `pullback.map_fst` is not a Mathlib constant.
   - **Q2**: Does Mathlib ship a `pullbackAwayιIso_inv_fst_assoc`-style simp lemma that fires through an outer `pullback.map` / `pullback.congrHom` wrap? If not, is there an `@[simps]`-style attribute that the project should add to `gmScalingP1_cover_intersection_X_iso` to auto-generate the projection lemmas?
   - **Q3**: For a `gmScaling`-style cocycle between two `Proj.awayι X_i` compositions through different chart-rings, what is the canonical "shared intersection chart" definition? Is `Algebra.TensorProduct.map (awayMapₐ _ _) (AlgHom.id _ _)`-based extension the right idiom, or is there a more direct way?
   If the consult delivers concrete answers, the cocycle should close in ~40-80 LOC of cleanly-mappable simp/rewrite. **If the consult lands NEEDS_MATHLIB_GAP_FILL on all three**, Route 1 escalates to user-input on whether to commit to a project-side simp-set + `@[simps]` campaign (~150-250 LOC, off-mainline) or pivot the cover-bridge approach.

2. **Blueprint-writer dispatch for `Picard_IdentityComponent.tex` (A.3 Pic⁰ identity + degree)** — iter-183 blueprint-reviewer flagged this as the single must-fix-this-iter unstarted-phase blueprint gap. A.3 has zero coverage and blocks the A.2.c → A.3 → A.4.d pipeline. Concrete proposal (5 declarations) in `task_results/blueprint-reviewer-iter183.md` "Unstarted-phase blueprint proposals" section. References ready (`abelian-varieties.md`, `kleiman-picard.md`).

3. **Blueprint cross-reference fix in `RiemannRoch_RRFormula.tex`** — blueprint-doctor flagged two broken `\uses{...}` calls where `\leanok` is incorrectly threaded INSIDE the `\uses{}` argument:
   ```
   \uses{\leanok thm:divisor_degree_hom}
   \uses{\leanok thm:euler_char_eq_deg_plus_one_minus_genus}
   ```
   These need to be split: `\leanok` belongs at proof-block level, not inside `\uses{}`. Either label-rename and add stand-alone proof-block `\leanok`, OR remove the `\leanok` from inside `\uses{}` and let the deterministic `sync_leanok` re-add it correctly. Plan-phase task for blueprint-writer (small).

## HIGH — closest-to-completion targets

4. **Lane E `iotaGm_onePt_chart1_factor` — easy iter-184 win.** Sub-task (b) residual collapses to just the range containment `Set.range onePt.left ⊆ Set.range (awayι (X 1))` (~10-15 LOC). Two Mathlib lemmas (`opensRange_awayι` + `fromOfGlobalSections_preimage_basicOpen`) bridge it.

5. **Lane H `Scheme.finrank_H0_toModuleKSheaf_eq_one`** — close via `Cohomology_StructureSheafModuleK` H⁰-bridge (constant-sheaf-Γ adjunction in `Carriers.lean`). Modest LOC (single-iter target).

6. **Lane I `Hom.poleDivisor_degree_eq_finrank` body** — primary iter-184 follow-up after the streak break. Per `analogies/ratcurveiso-pin2.md` Decision 2: ~80-150 LOC via `Ideal.sum_ramification_inertia`. Closing this auto-upgrades the Pin 2 wrapper to Tier-1 axiom-clean modulo the `Hom.poleDivisor` def body.

7. **Lane M downstream consumer**: now that `Albanese/CoheightBridge.lean` is axiom-clean Tier-1, the `hreg_dim` conjunction in `CodimOneExtension.lean` halves — `ringKrullDim` discharged by `Scheme.ringKrullDimLE_of_coheight_eq_one` instance. iter-184 can refactor `hreg_dim` to consume the bridge, leaving only the `IsRegularLocalRing` half (still gated on Stacks 00TT). Lane-able as a small refactor + body-close iter.

## MEDIUM — promising approaches needing more work

8. **Lane G `depth_eq_smallest_ext_index`** — backward direction final assembly (L432) is now close to closable: `ih (M := MxM)` on the Ext-pullback gives a regular sequence of length `n`; cons with `x` gives length `n+1` (~50-80 LOC). Forward direction (L346) is heavier: supremum extraction with Nakayama for `⊤` branch + truncation for the finite case (~80-120 LOC). Helper budget rolled over: 1 slot reserved for the LES-pullback helper deriving `Ext^j(κ, M/xM) = 0` for `j < n` from `Ext^*(κ, M) = 0`.

9. **Lane D `pullback_cocone` naturality (Tier-3, ~30-50 LOC)** — try `dsimp [relativeGluingData, AffineZariskiSite.toOpensFunctor, Functor.rightOp, NatTrans.whiskerLeft]` unfolding directive + `set_option maxHeartbeats 800000`, then `IsAffineOpen.map_fromSpec` closes. `respectTransparency false` alone was insufficient.

10. **Lane D `pullback_iso_desc_isIso` per-piece (~30-50 LOC)** — build the iso explicitly via `IsOpenImmersion.isoOfRangeEq` on `pullback.fst desc (q⁻¹U.1).ι` and `colimit.ι d.functor U`; identify `desc ∣_ q⁻¹U.1` with `e.inv ≫ pullback.snd desc (q⁻¹U.1).ι`. The `hPre` identity is the key bridge (already in place). Template at `Sites/SmallAffineZariski.lean:343`.

11. **Lane F `pullback_app_isoTensor` body** (~120-200 LOC) — Tilde-on-Spec route + affine-open promotion. Closes the sorryAx taint of `_of_isAffineBase` (modulo the inline BC compat sorry). Companion: build project-side `mateEquiv_app_sections` compat lemma OR exhibit BC arrow's inverse directly via the iso chain.

12. **Lane A `lineBundleAtClosedPoint` body, two-iter path**:
    - Iter-184 (closure lemmas): pre-build `order_add_min_le` as typed sorry helper. +1 sorry but unlocks downstream.
    - Iter-185 (Submodule + presheaf): collapses to 0 NEW sorries in a single iter, eliminating 1 OLD sorry → 6 total (strong target hit).

## BLOCKED — do NOT re-assign without structural change

- **Lane B `gmScalingP1_chart_agreement_cross01`** — see CRITICAL #1 above. 5-iter CHURNING; no further attempts without analogist verdict on Q1/Q2/Q3.
- **Lane A `lineBundleAtClosedPoint` Submodule upgrade** — blocked by Mathlib gap on `Ring.ordFrac_add` requiring `[IsDiscreteValuationRing]` (the `KrullDimLE 1` regime does not provide). Either (i) accept Tier-3 typed sorry on the non-archimedean inequality, OR (ii) escalate to Mathlib upstream — do NOT keep retrying without one of these.
- **Lane G `exists_isRegular_of_regularLocal`** (L562) — Mathlib gap per `analogies/isregularlocalring-isdomain.md`; ~300 LOC project-side build; iter-184+ work (NOT iter-184 target).

## Reusable patterns from this iter (Knowledge Base candidates)

- **`@Order.coheight … (specializationPreorder …)` explicit pinning trick** (Lane M) — for coheight/height on topological spaces where `specializationPreorder` is `@[instance_reducible]` not an instance, and `Subtype.preorder` conflicts on subspaces.
- **`induction n generalizing M` for depth-via-Ext** (Lane G) — `generalizing M` load-bearing for recursion onto `QuotSMulTop x M`.
- **`x • 𝟙_N = 0` via `mk₀_smul + smul_comp + mk₀_id_comp` chain** (Lane G) — `ext_smul_eq_zero_of_mem_annihilator` is the precise Stacks 00LP "x annihilates Ext^*" technique.
- **`IsOpenImmersion.lift` as factorisation hook** (Lane E sub-task b) — collapses residual obligation to range containment alone.
- **`@[simps! hom left]` on `OverClass.asOver` trap** (Lane E) — `rw [Over.w]` fails because `asOver_hom` simp rewrites eagerly to `X ↘ S`. Term-mode `congrArg` workaround.
- **`HasColimit (relativeGluingData _).functor` instance does NOT auto-synthesize through abbrev** (Lane D) — explicit `haveI : ... .IsLocallyDirected := Cover.RelativeGluingData.instIsLocallyDirectedI₀CompFunctorForgetOfIsThin _` required for direct `colimit.desc d.functor _` usage.

## Estimated iter-184 sorry trajectory

- **Best case** (all Lane E sub-task (b) + Lane H finrank closure + Lane I helper + Lane M consumer refactor + Lane G backward final + Lane B analogist unblocks closure): 81 → ~73-75 (−6 to −8).
- **Realistic** (Lane E sub-task (b) + Lane I helper + 1 of Lane H helpers + Lane G partial + 1 Lane D helper close): 81 → ~77-79 (−2 to −4).
- **Worst case** (analogist consult returns NEEDS_MATHLIB_GAP_FILL on Lane B; multiple "PARTIAL with new helper" outcomes): 81 → ~80-83 (−1 to +2).
