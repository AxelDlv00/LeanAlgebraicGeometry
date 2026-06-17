# Recommendations for iter-059

## TOP — must-fix before any Stub-1 prover round

### 1. [MAJOR / lean-auditor] Universe-generalize two CSI leaves (`.lean` fix)
`CechSectionIdentification.lean` `prod_coproduct_distrib` (line ~165) and
`coproduct_fibrePower_reindex` (line ~186) are stated with `{ι : Type}` (universe 0); every peer decl
uses `{ι : Type*}`. The Stub-1 induction instantiates `ι = 𝒰.I₀ : Type u` (`u > 0`), so these will
**silently fail to apply**. Trivial fix (`Type` → `Type*`) but it is a precondition for the assembly
lane working at all. Either fold into the Lane-2 prover directive or do it as a tiny `refactor`.
**Do this FIRST** — sending a prover at the induction before the fix wastes the round.

### 2. [MAJOR / lvb-csi] Blueprint σ-component normal-form bridge note (blueprint-writer)
`lem:coproduct_distrib_fibrePower_zero` (and prospectively `lem:coproduct_distrib_fibrePower`) write the
σ-component as `X_{σ(0)}` (widePullback form), but the Lean uses the **slice-product normal form**
`∏ᶜ fun k => Over.mk (f (σ k))` in `Over S` (deliberate, documented in the docstring; minimizes
`HasWidePullback` instance bookkeeping). The two are canonically iso via `widePullback_overX_eq_prod`.
Dispatch a blueprint-writer to add a bridge note (or restate in slice-product form) so the next prover
isn't confused. HARD-GATE-relevant for any further CSI prover work; take the same-iter fast path
(writer → scoped re-review) if the lane is to run iter-059.

## NEXT — the two ready forward lanes

### 3. Lane A (CONVERGING): Stub-1 inductive assembly `coproduct_distrib_fibrePower` + `cechBackbone_left_sigma`
**All categorical bricks now exist** (iter-058). Remaining work, per the full recipe in
`.archon/task_results/CechSectionIdentification.md`:
- Build the bridge `overProd_coproduct_distrib` (`(∐ᵢ Aᵢ) ⨯ B ≅ ∐ᵢ (Aᵢ ⨯ B)` in `Over S`) via
  `Over.prodLeftIsoPullback` (VERIFIED present) + `(∐ᵢ Aᵢ : Over S).left = ∐ᵢ Aᵢ.left` +
  `prod_coproduct_distrib`; prove the Over-S comparison is iso by `Over.forget S` reflecting isos. ~80–150 LOC.
- Wire the induction on `p` (step recipe in the task result): `widePullback_overX_eq_prod` →
  `prodFinSuccIso` (head split) → IH → `prod_coproduct_distrib` twice → `coproduct_fibrePower_reindex`.
- Then `cechBackbone_left_sigma` = `cechBackbone_obj_widePullback` (done) ≪≫ `widePullback_coproduct_iso`
  ≪≫ per-σ (`widePullback_overX_eq_prod.symm` ≪≫ `widePullback_openImm_inter`, both done).
This is genuine convergence (decomposition worked), NOT churn. Send the prover **only after #1 (and ideally #2).**

### 4. Lane B (the other live foundational route): Need #1 jShriekOU scheme-iso transport
Decomposed-only this iter (Route 3, no prover per the iter-058 plan). The 5 build-target sub-lemmas
(blueprint, Need1-coverage chapter, lines ~9257+) are ready to dispatch. **Verify the HARD GATE** via the
mandatory blueprint-reviewer dispatch before sending a prover. The dominant residual is `jShriekOU`
naturality under a scheme iso — do NOT treat as near-rfl (carried memory note). With Need #2 now closed
this is the remaining ingredient for open-immersion acyclicity (`OpenImmersionPushforward.lean`).

## Coverage debt — 9 unmatched lean_aux nodes (planner: restore Lean↔blueprint 1-to-1)
`archon dag-query unmatched` lists 9 nodes with no blueprint entry. The planner should blueprint these
(or bundle their `\lean{}` into a neighbouring node):
- `AlgebraicGeometry.affine_tildeVanishing_general` (NEW, proved) — bundle `\lean{}` into
  `lem:affine_cech_vanishing_general_seed` or a small dedicated block; depends on
  `sectionCech_homology_exact_of_affineOpen` + `moduleSpecΓFunctor`.
- `CategoryTheory.widePullback_overX_isLimit` (NEW) — `IsLimit` of the wide-pullback fan in `Over S`;
  fold into `lem:widePullback_overX_eq_prod`'s `\lean{}` or a helper block.
- `CategoryTheory.overSigmaDescCofan`, `overSigmaDescIsColimit`, `overSigmaDescIso` (NEW) — abstract
  `Over.mk (Sigma.desc f) ≅ ∐ Over.mk (f i)`; bundle into a new abstract node (analogue of
  `lem:coverArrow_over_sigma`).
- `CategoryTheory.FinitaryPreExtensive.prodFinSuccIso` (NEW, Mathlib-gap fill) — give it a node
  (e.g. `lem:prodFinSucc_split`); NOT `\mathlibok` (project-built, not a Mathlib reference).
- `AlgebraicGeometry.mem_iInf_opens_of_finite`, `AlgebraicGeometry.sectionCechComplexV` (older
  carry-over, proved) — still uncovered; blueprint or bundle.
- `AlgebraicGeometry.CechAcyclic.affine` (dead `affine` with sorry, dep_count 0) — long-standing dead
  node; consider deleting the declaration or giving it a `% NOTE`.

## Do-NOT-retry / cautions
- Do NOT re-throw the Stub-1 monolith at a prover undecomposed — it is now decomposed and the bricks
  are built; the remaining piece is targeted assembly glue (#3).
- Do NOT explore `Ext.mapExactFunctor` composition for Need #1 (no Mathlib composition lemma; use
  `mapExt_bijective_of_preservesInjectiveObjects`, already built).
- TOOLING: for instance-resolution-sensitive work in CechAcyclic/CechSectionIdentification, trust ONLY
  `lake env lean` / `lake build` / `lean_diagnostic_messages` — `lean_run_code`/`lean_multi_attempt`
  reported FALSE "success" off stale `.olean`s (iter-057/058).

## LOW (cleanup, non-blocking)
- AffineSerreVanishing.lean style (auditor minor): 4× `show`→`change`; 2× missing `maxHeartbeats`
  justification comments; long lines; reduce the D(f)-vs-general proof duplication.
- lvb-affineserre: add a blueprint `\lean{}` pin for `affine_tildeVanishing_general` (covered by #3's
  coverage-debt bullet).
