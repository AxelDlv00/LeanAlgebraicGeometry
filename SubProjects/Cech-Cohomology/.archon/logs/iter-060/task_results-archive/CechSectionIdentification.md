# AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

## Summary
- **Declarations added: 8, all axiom-clean** (`#print axioms` = `[propext, Classical.choice, Quot.sound]`,
  verified via `lake env lean` / `lake build`, source-compiled not stale olean):
  1. `CategoryTheory.FinitaryPreExtensive.coprodFirst_distrib` — coproduct-FIRST one-sided distributivity
     `∐ᵢ pullback (gᵢ) b ≅ pullback (Sigma.desc g) b` (from the existing `prod_coproduct_distrib` via `pullbackSymmetry`).
  2. `…pcd_hom_fst` — `prod_coproduct_distrib.hom ≫ pullback.fst` descent compat.
  3. `…pcd_hom_snd` — `prod_coproduct_distrib.hom ≫ pullback.snd` descent compat.
  4. `…cf_hom_fst` — `coprodFirst_distrib.hom ≫ pullback.fst` descent compat.
  5. `…overSigma_hom_eq` (private) — structure map of a coproduct in `Over S`:
     `(∐ A).hom = (PreservesCoproduct.iso (Over.forget S) A).hom ≫ Sigma.desc (·.hom)`.
  6. **`…overProd_coproduct_distrib`** — THE blueprint-named keystone "single new-infra leaf"
     (`lem:overProd_coproduct_distrib`): `(∐ᵢ Aᵢ) ⨯ B ≅ ∐ᵢ (Aᵢ ⨯ B)` in `Over S`.
  7. `…overProd_coproduct_distrib_right` — right-handed form `A ⨯ (∐ᵢ Yᵢ) ≅ ∐ᵢ (A ⨯ Yᵢ)` (braiding + #6).
  8. **`…widePullback_coproduct_iso`** — the full inductive assembly (`lem:coproduct_distrib_fibrePower`):
     `Over.mk (WidePullback.base (Fin(p+1) copies of Sigma.desc f)) ≅ ∐_σ ∏ᶜₖ Over.mk (f (σ k))`.
- **Declarations blocked: 1** — `cechBackbone_left_sigma` (line 537), the Stub-1 *consumer*. All categorical
  bricks now exist; the lone remaining obstacle is the **universe reduction** (`𝒰.I₀ : Type u`, but
  `widePullback_coproduct_iso` needs `{ι : Type}` = Type 0). Precise handoff below.
- **Sorry count: 5 → 5** (unchanged — the 8 new decls are all complete; Stub 1's sorry stays, Stubs 2/4/5/6
  remain as before). No protected signature touched.

## overProd_coproduct_distrib (DONE — keystone, ~80 LOC)
- **Approach:** `Over.isoMk` from a `C`-level `.left`-iso. The `.left`-iso chains
  `Over.prodLeftIsoPullback (∐A) B` → `pullback.map` (transporting `(∐A).hom = pIso.hom ≫ Sigma.desc` via
  `overSigma_hom_eq` + `PreservesCoproduct.iso (Over.forget S) A`) → `(coprodFirst_distrib …).symm` →
  `Sigma.map (prodLeftIsoPullback (Aᵢ) B).inv` → `(PreservesCoproduct.iso (Over.forget S) (Aᵢ⨯B)).symm`.
- **Structure-map compat** (the painful 40-LOC core): reduced via `Over.w prod.fst` +
  `prodLeftIsoPullback_hom_fst/inv_fst` + `overSigma_hom_eq` + the `pcd/cf` descent-compat lemmas +
  `pullback.map`/`lift_fst`.
- **KEY TRAPS (record for reuse):**
  - `Over.forget S` **creates colimits** (`createsColimitsOfSize`) ⇒ provide
    `HasColimit (Discrete.functor A ⋙ Over.forget S)` via `hasColimit_of_iso (Discrete.natIso (fun _ => Iso.refl _))`,
    then `PreservesColimit … (Over.forget S)` + `PreservesCoproduct.iso` synthesize.
  - `HasBinaryProducts (Over S)` is **NOT** an instance — pass `[HasBinaryProducts (Over S)]` as a binder
    (or `Over.ConstructProducts.over_binaryProduct_of_pullback`).
  - **`set` + `clear_value` for the two `PreservesCoproduct.iso` terms** — the iso term re-elaborated by a
    fresh lemma application synthesizes *different instances* than the one inside `eLeft`, so
    `Iso.inv_hom_id_assoc` won't unify `?self`. `set pA/pAB … ; clear_value pA pAB`, prove a local
    `hA/hAB/hAB'` against the bound var, then cancel. `simp` also normalizes `(Over.forget S).obj X → X.left`,
    so the cancel hypothesis is matched with **`erw`** (defeq) not `rw`.
  - `Iso.inv_hom_id` / `_assoc` fire cleanly only in an *isolated* clean goal; in the big chain use a
    pre-proved `hAB' : pAB.inv ≫ (∐…).hom = Sigma.desc …` then `erw [hAB']`.

## widePullback_coproduct_iso (DONE — induction, ~25 LOC tactic body)
- **Approach:** induction on `p` (pattern match). Base = `widePullback_coproduct_iso_zero f`. Step `p+1`
  in tactic mode: `widePullback_overX_eq_prod` → `prodFinSuccIso` → `prod.mapIso (overSigmaDescIso f).symm
  (… ≪≫ widePullback_coproduct_iso f p)` → `overProd_coproduct_distrib` → `Sigma.mapIso
  overProd_coproduct_distrib_right` → `Sigma.mapIso (Sigma.mapIso (prodFinSuccIso …).symm)` →
  `coproduct_fibrePower_reindex`.
- **TRAPS:** (a) `set_option maxHeartbeats 1600000 in` (the `Fin.cons` defeq through nested `∏ᶜ/Over.mk` is
  heavy). (b) The final `Sigma.mapIso (Sigma.mapIso (prodFinSuccIso …).symm)` must elaborate **bottom-up**
  — a `show`/expected-type forces a bad higher-order unification (`X 0` ↦ metavar instead of reducing
  `Fin.cons i τ 0 = i`). Fix: `have e7 := Sigma.mapIso (…)` with **no** type ascription, then
  `exact e7 ≪≫ coproduct_fibrePower_reindex …` (the `≪≫` discharges the `Fin.cons` defeq at the seam).

## cechBackbone_left_sigma (NOT added — line 537 sorry, the Stub-1 consumer)
- **Goal:** `(coverCechNerveOver 𝒰).obj (op [p]) ≅ ∐_{σ:Fin(p+1)→𝒰.I₀} Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))`.
- **All bricks exist:** `cechBackbone_obj_widePullback` (LHS ≅ `Over.mk (WidePullback.base (Fin(p+1) copies of Sigma.desc 𝒰.f))`),
  `widePullback_coproduct_iso`, and per-σ `widePullback_overX_eq_prod.symm ≪≫ widePullback_openImm_inter`
  (`widePullback_openImm_inter (fun k => 𝒰.f (σ k)) : widePullback X _ _ ≅ (⨅ₖ (𝒰.f (σ k)).opensRange).toScheme`,
  and `⨅ₖ coverOpen 𝒰 (σ k) = coverInterOpen 𝒰 σ` by def).
- **SOLE BLOCKER = universe reduction.** `𝒰.I₀ : Type u` (verified), but `widePullback_coproduct_iso` (and
  `prod_coproduct_distrib` underneath) are `{ι : Type}` = **Type 0 only** (`isIso_sigmaDesc_fst` is Type-0;
  widening BREAKS the build — do NOT). Must pick `e : 𝒰.I₀ ≃ Fin (Nat.card 𝒰.I₀)` (`Finite.equivFin`),
  instantiate `widePullback_coproduct_iso (f := 𝒰.f ∘ e.symm) p` over `Fin n`, then transport:
  - **(LHS)** `Over.mk (WidePullback.base (… Sigma.desc 𝒰.f))` ≅ `… (Sigma.desc (𝒰.f∘e.symm))`: needs the
    coproduct-reindex iso `∐ 𝒰.X ≅ ∐ (𝒰.X∘e.symm)` (`Limits.Sigma.reindex`/`Sigma.whiskerEquiv e`) compatible
    with the two `Sigma.desc`, then `WidePullback.base` functoriality.
  - **(RHS)** `∐_{σ':Fin(p+1)→Fin n} ∏ᶜₖ Over.mk ((𝒰.f∘e.symm)(σ'k))` ≅
    `∐_{σ:Fin(p+1)→𝒰.I₀} ∏ᶜₖ Over.mk (𝒰.f(σk))`: reindex along `(Fin(p+1)→Fin n) ≃ (Fin(p+1)→𝒰.I₀)`
    (`Equiv.arrowCongr (Equiv.refl _) e` / `Sigma.whiskerEquiv`), per-component `∏ᶜ` matches by
    `(𝒰.f∘e.symm)(σ'k) = 𝒰.f(e.symm(σ'k))`, `σ = e.symm∘σ'`.
  - then `∐_σ ∏ᶜₖ Over.mk(𝒰.f(σk)) ≅ ∐_σ Over.mk(ι(coverInterOpen 𝒰 σ))` via per-σ
    `Sigma.mapIso (widePullback_overX_eq_prod.symm ≪≫ widePullback_openImm_inter + eqToIso for the iInf=coverInterOpen)`.
- **Effort estimate:** ~80–150 LOC; the two reindex transports (LHS/RHS) are the load-bearing work.
  Recommend a dedicated next-iter prover pass.

## Stubs 2/4/5/6 (NOT added — lines 591, 682, 752, 811)
- Downstream of Stub 1, left as before per PROGRESS directive ("leave their sorries for the post-Stub-1 round").

## Needs blueprint entry
All 8 new non-private declarations correspond to blueprint nodes already authored by the effort-breaker
(iter-058) / blueprint-writer, EXCEPT possibly `overProd_coproduct_distrib_right` (the right-handed form),
which is a NEW helper not separately blueprinted — it is the braiding-symmetric twin of
`lem:overProd_coproduct_distrib`, consumed inside the `widePullback_coproduct_iso` induction. Suggest the
planner add a one-line `lem:overProd_coproduct_distrib_right` block `\uses{lem:overProd_coproduct_distrib}`.
The compat lemmas `pcd_hom_fst`/`pcd_hom_snd`/`cf_hom_fst`/`overSigma_hom_eq` are proof-internal plumbing for
`lem:overProd_coproduct_distrib`; bundle their names into that lemma's `\lean{...}` to clear `unmatched`.
Names:
- `CategoryTheory.FinitaryPreExtensive.coprodFirst_distrib`
- `CategoryTheory.FinitaryPreExtensive.pcd_hom_fst` / `pcd_hom_snd` / `cf_hom_fst`
- `CategoryTheory.FinitaryPreExtensive.overSigma_hom_eq` (private)
- `CategoryTheory.FinitaryPreExtensive.overProd_coproduct_distrib`  (= `lem:overProd_coproduct_distrib`)
- `CategoryTheory.FinitaryPreExtensive.overProd_coproduct_distrib_right`  (NEW — needs a block)
- `CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso`  (= `lem:coproduct_distrib_fibrePower`)

## Why I stopped
**Real progress: 8 axiom-clean declarations added** (lines, in `CategoryTheory.FinitaryPreExtensive`,
inserted before `end FinitaryPreExtensive`):
- `coprodFirst_distrib`, `pcd_hom_fst`, `pcd_hom_snd`, `cf_hom_fst`, `overSigma_hom_eq`,
  `overProd_coproduct_distrib` (keystone), `overProd_coproduct_distrib_right`,
  `widePullback_coproduct_iso` (induction).
The two blueprint-named build-targets of Stub 1's distributivity chain
(`lem:overProd_coproduct_distrib`, `lem:coproduct_distrib_fibrePower`) are now **fully proved
axiom-clean** — the "single new-infra leaf" the blueprint flagged is closed.
**Partial on Stub 1 overall:** the consumer `cechBackbone_left_sigma` remains a sorry — its sole blocker is
the documented universe reduction (`𝒰.I₀ : Type u` → `Fin n` reindex transport), a well-scoped ~80–150-LOC
follow-up, NOT a missing ingredient. Every categorical brick it composes now exists and is axiom-clean.
Stopped here as the responsible boundary after delivering the two hardest pieces; the reindex transport is
a clean next-iter unit.
