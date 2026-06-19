# Project Progress

## Current Stage

prover

## Stages
- [x] init
- [x] autoformalize
- [ ] prover
- [ ] polish

## End-state overview

**Zero inline `sorry` in the dependency cone of the seed declarations + kernel-only axioms.**
Two Čech-independent (i=0) legs split from the parent *Quot-Foundations* `thm:fga_pic_representability`
cone (full arc in STRATEGY.md):

- **FBC-B** — flat base change of the degree-0 pushforward (`thm:flat_base_change_pushforward`), via the
  CONCRETE-tilde equalizer chain. Per-chart iso (a) DONE sorry-free; restriction-naturality (b) reduced
  to its crux `pullback_spec_tilde_iso_ring_square_natural`, gated on the foundation
  `gammaPushforwardNatIso_comp`. **iter-011:** foundation own-body CLOSED; genuine content isolated into
  `gammaPushforwardIso_comp`, now 1 named residual = the cast identity `Γ(cast) x = x`, blocked on 2 named
  rw-only (kernel-light) exposure lemmas. iter-012: build the 2 exposure lemmas + close the comp lemma.
- **SNAP** — the section graded ring `Γ_*(X,L)` (`lem:sectionGradedRing_gcommSemiring`). Foundation +
  `tensorObjLocalizedIso` + braiding bridge + `sectionMul_assoc_core` + 4 associator-bridge seams DONE.
  **iter-011:** 2 canonical-μ keystones CLOSED; iter-010 object-fold blocker CLEARED. Assembly
  `tensorObjAssoc_eq_localizedAssociator` still open; the full-goal cancel blockers (adjacency +
  instance-identity) DISSOLVE under the hK split. iter-012: derive the well-typed common form `K` +
  prove `hK_lhs`/`hK_rhs`; assembly = `hK_lhs.trans hK_rhs.symm`.

## Current Objectives

TWO focused prover lanes this iter. pc012 = **CHURNING (both routes)**; the proposed focused lanes are
verdict-confirmed **genuine correctives** (NOT warm-retry churn): FBC switched from defeq/kernel-bomb to
2 named rw-only exposure lemmas; SNAP from the monolithic/object-fold goal to a specific K-derivation via
`Localization.Monoidal.associator_hom_app`. Both strategy timelines are over-budget — if neither closes
its residual sorry this iter, the iter-013 corrective is a **Mathlib-idiom consult** (NOT another helper
round), pre-committed in the sidecar.

1. **`Cohomology/FlatBaseChange.lean`** — close the foundation by building 2 exposure lemmas + the comp
   lemma AS A UNIT. Blueprint: `chapters/Cohomology_FlatBaseChange.tex`. [prover-mode: prove]
   - **Build 2 named rw-only (kernel-light) exposure lemmas:**
     1. **`moduleSpecΓFunctor.map` exposure** — `moduleSpecΓFunctor.map g` underlying =
        `(modulesSpecToSheaf.map g).val.app (op ⊤)` underlying. Read the `moduleSpecΓFunctor` unfold via
        `lean_declaration_file` / `lean_hover_info` (it unfolds to
        `evaluation(op ⊤).map (TopCat.Sheaf.forget.map (modulesSpecToSheaf.map g))`; the Mathlib source
        `AlgebraicGeometry/Modules/Tilde.lean` was only in `.ltar` cache last iter — use the LSP decl tools).
     2. **`eqToHom`-on-carrier cast** — `(ConcreteCategory.hom (eqToHom E)) x = x` for `ModuleCat` (true
        by proof-irrelevance; source/target carriers are the literally-equal `N.val.obj ⊤`).
   - **Close `gammaPushforwardIso_comp`** (sorry @L699, residual `x = restrictScalarsComp.inv
     (restrictScalars.map γ_ρ (γ_φ (Γ(cast) x)))`): `eqToIso.hom`/`eqToHom_app`/`eqToHom_map` turn
     `Γ((eqToIso h).hom.app N)` into `eqToHom E` → discharge by exposure lemma (2); kill the right factor
     `Γ(pushforwardComp.inv.app N)` by `SheafOfModules.pushforwardComp_inv_app_val_app` [expected] AFTER
     exposing `.val.app (op ⊤)` via exposure lemma (1). All `rw`/`erw`, NO defeq.
   - **pc012 HARD: close the 2 exposures AND `gammaPushforwardIso_comp` as a UNIT** — partial (exposures
     proved but the sorry left open) is insufficient this iter. Closing it fully closes
     `gammaPushforwardNatIso_comp` (own body already proved, transitively gated).
   - **THEN, if budget remains,** attempt the crux `pullback_spec_tilde_iso_ring_square_natural` (@L1289)
     via the mate recipe (`analogies/fbc-pst-pseudofunctor.md`): the 3 mate-composition lemmas EXIST;
     `mateEquiv` is `TwoSquare`-valued — recover NatTrans via `.natTrans`/`TwoSquare.equivNatTrans`;
     whiskerings are TwoSquare pasting, NOT `Functor.whiskerLeft`. Do NOT hand-peel `homEquiv.injective`
     (dead end). Fine to leave the crux as a typed `sorry` if the foundation consumed the budget.
   - **Do NOT** touch the 3 COMPILE-DEAD mate sorries (L1549/1730/1752); do NOT attempt cleanup
     (set_option / stale comments) — deferred to a dedicated refactor iter (latent set_option bug there).
   - **Coverage debt:** the 2 new `:= rfl` helpers `gammaPushforwardIso_{hom,inv}_apply` are now
     blueprinted (`lem:gammaPushforwardIso_hom_apply`/`_inv_apply`).
   - Validate with cold `lake build AlgebraicJacobian.Cohomology.FlatBaseChange` (LSP hides kernel timeouts).
     Do NOT add `maxHeartbeats 1e6`.

2. **`Picard/SectionGradedRing.lean`** — derive the well-typed common form `K`, prove the 2 isolated hK
   halves, close the assembly. Blueprint: `chapters/Picard_SectionGradedRing.tex`. [prover-mode: fine-grained]
   - **Step 0 (GATING — pc012 HARD: verify FIRST, surface immediately if it fails):** the well-typed Lean
     common form `K` does NOT exist yet (the chapter's schematic `K = L'(α^p) ≫ μ⁻¹ ≫ (L'a ◁ μ⁻¹) ≫
     (c_A ⊗ₘ (c_B ⊗ₘ c_C))` does NOT typecheck — its domain `sheafification.obj((a⊗b)⊗c)` differs from the
     assembly domain `tensorObj (tensorObj A B) C`; `K` must absorb counit object-glue on all 4 tensor
     slots). Derive `K` by reducing the localized side in an isolated lemma — do NOT pre-commit a schematic.
   - **Step 1 — `tensorObjAssoc_eq_localizedAssociator_hK_lhs : Φ^L ≫ α^loc = K`
     (`lem:tensorObjAssoc_hK_lhs`):** expand `α^loc` via `Localization.Monoidal.associator_hom_app`
     [verified Mathlib b80f227, Basic.lean] so the localized μ's are inferred-native; READ OFF the reduced
     RHS and DEFINE that as `K`. (This is the structural route: the inferred-`_` μ object args unify
     natively, so the full-goal adjacency/instance-identity collision never forms.)
   - **Step 2 — `tensorObjAssoc_eq_localizedAssociator_hK_rhs : α ≫ Φ^R = K`
     (`lem:tensorObjAssoc_hK_rhs`):** prove FRESH — expand `tensorObjAssoc` + `tensorObjLocalizedIso`
     DIRECTLY (WITHOUT the `Iso.eq_inv_comp`/`asIso` maneuver, so the keystone-μ and the
     `tensorObjLocalizedIso`-μ are placed cleanly, un-wrapped). The whiskered units live on this side
     (segments 1, 3–5); rewrite them by the canonical keystones `sheafification_whisker{Right,Left}_unit_eq_mu'`
     (PROVED iter-011), then `simp only [tensorObj]` (makes both μ's print identical — verified iter-011),
     then `rw [Iso.hom_inv_id_assoc]` [verified] now fires (μ's adjacent + un-wrapped) and the μ-pair cancels;
     triangle + `μ_natural_left/right` [verified Basic.lean:188/200] leave `K`.
   - **Step 3 — Assembly** `tensorObjAssoc_eq_localizedAssociator` (sorry @L1796) = `hK_lhs.trans hK_rhs.symm`.
   - **Do NOT** re-fire the full monolithic warm lane expecting `Iso.hom_inv_id_assoc` to fire (adjacency +
     instance-identity blockers — DEAD on the full goal). Do NOT retry `rw [show μ=μ from rfl]` (motive not
     type correct). Do NOT touch the 5 cascade coherences yet — they wait on the assembly.
   - **If K won't typecheck or `hK_rhs` won't close → STOP and surface it** (do NOT finer-μ-chase); iter-013
     corrective is a Mathlib-idiom consult on the `Localization.Monoidal` entry point.
   - HAZARD: the `𝟭`-wrapper on `unit.app P` prints as `(𝟭).obj P` and blocks rewrites — leading
     `simp only [Functor.id_obj]` normalizes it. Validate with cold `lake build
     AlgebraicJacobian.Picard.SectionGradedRing`. Do NOT add `maxHeartbeats 1e6`.

## Queued — NEXT iters

- **iter-013 escalation (pre-committed):** if FBC `gammaPushforwardIso_comp` is still open → mathlib-analogist
  api-alignment consult on `ConcreteCategory.hom (eqToHom _) x = x` for ModuleCat. If SNAP assembly still
  open → mathlib-analogist consult on the `Localization.Monoidal` associator entry point (is
  `associator_hom_app` the right form, or a `monoidal_of_hasLocalization` coherence route?). Reassess the
  over-budget STRATEGY timelines.
- **FBC crux → Global assembly** `baseChange_sheafConditionFork_tensorIso`: after the crux +
  `TensorProduct.piRight`; add `[IsSeparated X]`/`[Fintype ι]`/`[F.IsQuasicoherent]` hyps.
- **FBC separated → MV → bridge → goal**: both seeds. Bridge reverse gated on qcqs-pushforward-QC
  (Stacks 01XJ) — verify Mathlib / `mathlib-build` first (STRATEGY Open Q).
- **FBC mate excision + cleanup (dedicated `refactor` iter)** — delete the COMPILE-DEAD mate apparatus +
  dead `/-!` blocks; FIX the latent `set_option maxHeartbeats` placement bug (L1430/1465-1468 scope to
  comments not theorems); strip stale comments + the misleading `gammaPushforwardNatIso_comp` docstring;
  sync the blueprint `\uses` same iter. KEEP `base_change_mate_regroupEquiv` + `base_change_map_affine_local`.
  Run via `refactor`, NOT alongside a prover.
- **SNAP file-split + coverage-debt clear** — `SectionGradedRing.lean` >2200 lines with ~70 unmatched
  Lean helpers (mostly `RelativeTensorCoequalizer.*`). Split into smaller files (user standing directive:
  parallelism) + mark impl-detail helpers `private` + blueprint genuine infra. Dedicated `refactor` iter.
- **SNAP cascade + `sectionGradedModule_gmodule`** — the 5 coherences (`tensorPowAdd_rightUnit/_braiding/
  _assoc×2`, `sectionsMul_mul_assoc`) cascade once the assembly closes; then the graded module instance.

## Standing notes

- **Prover model:** `opus`.
- **Import architecture:** root `AlgebraicJacobian.lean` imports each leaf. FlatBaseChangeGlobal imports
  FlatBaseChange (one-way); FlatBaseChange imports RegroupHelper. SectionGradedRing standalone.
- **Cold-build:** validate with real `lake build AlgebraicJacobian.Cohomology.FlatBaseChange` /
  `...Picard.SectionGradedRing` (LSP hides `(kernel) deterministic timeout`); never add `maxHeartbeats 1e6`.
- **No LLM API key in env** — use blueprint + Mathlib search + the analogist subagent.
- **FBC residual (iter-011):** `gammaPushforwardIso_comp` reduces to `Γ(cast) x = x`; the defeq shortcut is
  a VERIFIED cold-build KERNEL BOMB. Finish needs 2 rw-only exposure lemmas (see Objective 1). Foundation
  `gammaPushforwardNatIso_comp` own body is already proved (transitively gated on the comp lemma).
- **SNAP assembly μ-cancel (iter-011, analogist-verified):** NO zero-restate Mathlib coherence cancels the
  μ-pair; the canonical-keystone restatement + `simp only [tensorObj]` clears the OBJECT fold; the cancel
  needs hK ISOLATION (un-wrapped μ's via fresh `hK_rhs`, no `Iso.eq_inv_comp`) + structural localized side
  via `associator_hom_app`. Recipe: `analogies/snap-mu-nesting.md`.
- **SNAP hazard:** localized `⊗_loc` is NOT defeq to hand-built `tensorObj` → bridges are object-iso-
  conjugated via `tensorObjLocalizedIso = μ⁻¹;counit`; a bare `α = α^loc` is a type error.
- **Merge-back discipline:** never rename kept decls/labels; never add `\leanok` by hand. No declarations
  are currently protected — chain decls may be re-signed to add missing hyps.
