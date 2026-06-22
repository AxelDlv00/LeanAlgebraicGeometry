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
  CONCRETE-tilde equalizer chain. FOUNDATION SORRY-FREE (iter-016); BOTH ring-square mate legs CLOSED
  (iter-018). **iter-022: glue DECOMPOSED into a 6-lemma scaffold** (`ring_square_glue_*`) — the
  churn-breaking corrective (pc022). Frontier = prove the 6 sub-lemmas + reduce the glue, then crux
  rewire + 2 seeds.
- **SNAP** — the section graded ring `Γ_*(X,L)` (`lem:sectionGradedRing_gcommSemiring`). The associator
  bridge route (Option B) was STUCK ~14 iters on a dual-`MonoidalCategory`-instance μ-token-divergence
  (pc022). **iter-022: REFACTOR PIVOT to Option A** (re-base `tensorObj` onto Mathlib `⊗_loc`; bridges
  become `rfl`; ~900L deleted) — executed in the plan phase via the `refactor` subagent. NO SNAP prover
  this iter; next iter fills the new (cheap) coherence sorries.

## Current Objectives

ONE prover lane this iter (SNAP is being refactored in the plan phase, NOT proved — do not add it here).

1. **`Cohomology/FlatBaseChange.lean`** — build + prove the 6-lemma glue scaffold, then reduce the glue
   sorry (~L1900), which transitively closes the crux (`pullback_spec_tilde_iso_ring_square_natural` @L1921
   already `exact … mate_glue …`). Blueprint: `chapters/Cohomology_FlatBaseChange.tex`
   (`lem:ring_square_glue_{whiskerRight_lift,whiskerLeft_lift,pst_iterated_mate,geom_leg_nat,alg_leg_nat,
   natTrans}` @bp L2457–2606; `lem:pullback_spec_tilde_iso_ring_square_mate_glue` @bp L2608).
   [prover-mode: prove]
   - **CONTEXT (pc022: CHURNING route — this 6-lemma split IS the churn-breaker, NOT another helper round).**
     iter-019→021 attacked the glue monolithically (whole-goal transposition of the `TwoSquare`-valued
     `iterated_mateEquiv_conjugateEquiv` → composite-adjunction-unit whnf → 200k-hb bomb). The fix is to
     isolate the unit-forcing telescoping inside ONE nat-trans-level lemma (`natTrans`) and keep the glue
     itself a mechanical whiskering rewrite.
   - **The 6 lemmas do NOT exist in Lean yet — CREATE each with the blueprint statement, then prove:**
     - `ring_square_glue_whiskerRight_lift` / `..._whiskerLeft_lift`: definitional — `exact rfl` /
       `CategoryTheory.whiskerRight_app` / `whiskerLeft_app` (both [verified] real; `(Φ ▷ H)_M = H.map Φ_M`,
       `(F ◁ Φ)_M = Φ_{F M}` by definition). NO component of the leg is expanded.
     - `ring_square_glue_pst_iterated_mate` (LINCHPIN): the recognition that the conjugate of the affine
       dictionary leg is the iterated single-step mate of `gammaPushforwardNatIso`. Package =
       `CategoryTheory.iterated_mateEquiv_conjugateEquiv` (+ `_symm` for the inverse dir) [verified REAL,
       `Mathlib/CategoryTheory/Adjunction/Mates.lean:450,456`, namespace `CategoryTheory`, toolchain-checked
       by fbc-pst writer + br022-fbc-rereview — NOT fictional]. Grounded alt: `mateEquiv_vcomp` +
       `conjugateEquiv_mateEquiv_vcomp` / `mateEquiv_conjugateEquiv_vcomp` [verified]. Recover the NatTrans
       via `.natTrans` / `TwoSquare.equivNatTrans`. Operate at the `TwoSquare` level — never `.app M`.
     - `ring_square_glue_geom_leg_nat`: paste the CLOSED `chartBaseChangeGeometricComparison_mate` via
       `CategoryTheory.conjugateEquiv_mateEquiv_vcomp` [verified].
     - `ring_square_glue_alg_leg_nat`: paste the CLOSED `chartBaseChangeModuleReassoc_extendScalarsComp`
       via `CategoryTheory.mateEquiv_conjugateEquiv_vcomp` [verified] (NOT `conjugateEquiv_comp` —
       source/target categories mismatch the legs).
     - `ring_square_glue_natTrans`: the composite-functor nat-trans equation — recognise the 4 `pst` legs
       as iterated mates (`pst_iterated_mate`), use `pullback_spec_tilde_iso_inv_unit_triangle` (@L897) per
       leg, telescope conjugates via `conjugateEquiv_symm_comp`, discharge geom/alg legs by the two vcomp
       lemmas, close the residual on `gammaPushforwardNatIso_comp` (@CLOSED iter-016). ALL at TwoSquare/
       nat-trans level — no `.app M`. This is where the unit-forcing risk lives.
   - **Then the glue** (~L1900 sorry): reduce the iso eq to the inverse nat-trans eq, rewrite the
     `pushforward.map`/`Γ.map`/`extendScalars` wrappers as whiskerings via `whiskerRight_lift`/
     `whiskerLeft_lift`, recognise the result as `ring_square_glue_natTrans`, evaluate at `M`. Helper
     `chartBaseChangeModuleReassoc_eq_natApp` (~L1770, KEPT iter-021) is wired in the glue `\uses`.
   - **HAZARD (KB):** `mateEquiv` is `TwoSquare`-valued; feeding bare `NatTrans` into the vcomp/mate
     lemmas is the type-mismatch that stalled the hand-peel. The whiskerings in the vcomp lemmas are
     TwoSquare pasting, NOT `Functor.whiskerLeft`. If `pst_iterated_mate`'s transposition whnf-bombs,
     leave it a TYPED sorry, CLOSE the other 5 (still net reduction), and report the exact blocked step.
   - **VERIFY before building** (Mathlib bumps rename): `loogle`/`local_search`
     `iterated_mateEquiv_conjugateEquiv`, `mateEquiv_vcomp`, `conjugateEquiv_mateEquiv_vcomp`,
     `mateEquiv_conjugateEquiv_vcomp`, `conjugateEquiv_symm_comp`. If a name mismatches, STOP + surface.
   - **MANDATORY cold-build self-check + revert-on-bomb:** after each close run cold `lake build
     AlgebraicJacobian.Cohomology.FlatBaseChange`. If it bombs → REVERT that close to a clean stub-sorry.
     The file MUST end green. Do NOT touch the COMPILE-DEAD mate apparatus sorries (@L2192/L2373/L2395);
     no `set_option`/comment cleanup (deferred to the mate-excision refactor). Do NOT add `maxHeartbeats 1e6`.

## In-plan-phase (no prover lane)

- **SNAP `SectionGradedRing.lean` — REFACTOR Option A** (dispatched in the plan phase via the `refactor`
  subagent, slug `snap-optiona-r3`). Re-base `tensorObj`/unitor/braiding/associator onto Mathlib `⊗_loc`
  (`modulesLocalizedMonoidal X`); `tensorObjAssoc_eq_localizedAssociator` + unit/braiding bridges become
  `rfl`; ~900L hK/seam/head machinery deleted; `sorry` inserted at every broken downstream coherence proof.
  Design `analogies/snap-instance-design.md`. The file must end COLD-GREEN (safe-revert to
  `iter/iter-022/backups/SectionGradedRing.lean.iter021-green` if a compiling state can't be reached).
  Next iter (023) = a SNAP prover lane to fill the new coherence sorries (Mathlib pentagon/triangle/hexagon
  + `Functor.Monoidal L` lax-coherences).

## Queued — NEXT iters

- **SNAP coherence prover (iter-023, after the refactor lands green):** fill the post-refactor sorries
  (`tensorPowAdd_*`, section cores, `sectionsMul_*`, `sectionMul_coherent`, graded assembly) via the
  Mathlib monoidal laws. WATCH (sc022): a section-level coherence (`sectionsMul_*`/`sectionMul_coherent`)
  may re-summon the Γ-level μ-boundary → if a sorry resists the law-based re-prove, re-consult the analogist
  (NOT another structural attempt). Then `sectionGradedModule_gmodule`.
- **FBC downstream (after glue + crux):** seeds (`affineBaseChange_pushforward_iso` @~L2373,
  `flatBaseChange_pushforward_isIso` @~L2395) via the concrete chain → Global assembly
  `baseChange_sheafConditionFork_tensorIso` (+ `TensorProduct.piRight`; add
  `[IsSeparated X]`/`[Fintype ι]`/`[F.IsQuasicoherent]`) → separated → MV → bridge → goal. Bridge reverse
  gated on Stacks 01XJ (`qcqs-pushforward-qcoh`, CONFIRMED ABSENT from Mathlib — build project-side via
  `[prover-mode: mathlib-build]`, est. 1–2 iters / ~100–200 LOC; STRATEGY Open Q).
- **FBC mate excision + cleanup (dedicated `refactor` iter):** delete the COMPILE-DEAD mate apparatus
  (`base_change_mate_{domain,codomain}_read`/`_gstar_transpose`/`_section_identity`/`_generator_trace`,
  `pushforward_base_change_mate_*`) + the `_sections_direct` gap node + dead `/-!` blocks; FIX the latent
  `set_option maxHeartbeats` placement bug (scopes to comments not theorems); strip stale iter-NNN comments.
  KEEP `base_change_mate_regroupEquiv` + `base_change_map_affine_local`. Sync blueprint `\uses` same iter.
- **SNAP file-split + coverage-debt clear** — `SectionGradedRing.lean` >2200 lines, ~70 unmatched
  `RelativeTensorCoequalizer.*`/`W_*` helpers. Split into smaller files (user standing directive:
  parallelism) + mark impl-detail helpers `private` + blueprint genuine infra. Dedicated `refactor` iter
  (best done AFTER the Option A refactor settles).

## Standing notes

- **Prover model:** `opus`.
- **Import architecture:** root `AlgebraicJacobian.lean` imports each leaf. FlatBaseChangeGlobal imports
  FlatBaseChange (one-way); FlatBaseChange imports RegroupHelper. SectionGradedRing standalone.
- **Cold-build is the ONLY kernel-bomb detector:** validate with real `lake build
  AlgebraicJacobian.Cohomology.FlatBaseChange` / `...Picard.SectionGradedRing`. The LSP / `lean_multi_attempt`
  HIDE `(kernel) deterministic timeout`. Never add `maxHeartbeats 1e6`.
- **No LLM API key in env** — use blueprint + Mathlib search + the analogist subagent.
- **FBC mate API (KB):** `iterated_mateEquiv_conjugateEquiv` (+`_symm`), `mateEquiv_vcomp`,
  `conjugateEquiv_mateEquiv_vcomp`, `mateEquiv_conjugateEquiv_vcomp` ALL REAL (`…Adjunction.Mates`,
  toolchain-verified iter-022). `mateEquiv` is `TwoSquare`-valued — recover NatTrans via `.natTrans`;
  vcomp whiskerings are TwoSquare pasting. Both b2 legs CLOSED iter-018 (`← conjugateEquiv_comp` split ×2
  + `simp only […eq_mpr_eq_cast,cast_eq]` cast-dissolve). `conjugateEquiv_pullbackComp_inv` REAL
  (Sheaf.lean:238). Drive composites by splits, NEVER `unit_conjugateEquiv` over the composite.
- **SNAP Option A (KB):** the associator-bridge wall = parallel-API anti-pattern (two `MonoidalCategory`
  instances on defeq copies). Fix = re-base onto `⊗_loc` (bridges `rfl`). Dual-instance DELETION REFUTED
  (load-bearing). Design `analogies/snap-instance-design.md`. The Option-B recipes
  (`snap-suffix-cancel`/`snap-reassoc-pin`/`snap-mu-identity`/`snap-assoc-expose`/`snap-localized-comp-cancel`)
  are now historical (the decls they targeted are being deleted).
- **Merge-back discipline:** never rename kept decls/labels; never add `\leanok` by hand. No declarations
  are currently protected — chain decls may be re-signed to add missing hyps / pin instances.
