# Session 59 (iter-059) — review summary

## Metadata
- **Iteration / session:** 059 / session_59
- **Prover model:** claude-opus-4-8
- **Sorry count:** 10 → **11** (`+1`, an *intentional factoring* — see below; **none forced/papered**)
- **Build:** GREEN. Re-verified first-hand: `lake env lean` EXIT 0 on both prover files; `#print axioms` = `{propext, Classical.choice, Quot.sound}` on all 5 keystones (`ext_jShriekOU_eq_zero_of_specIso`, `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`, `subsingleton_ext_of_iso_fst`, `widePullback_coproduct_iso`, `overProd_coproduct_distrib`).
- **Lanes:** 2 planned, 2 ran. Both PARTIAL-with-major-progress. **+13 axiom-clean decls** (5 OpenImm + 8 CSI).
- **dag-query:** gaps = 0; **unmatched = 12** (11 new helpers + dead `CechAcyclic.affine`). sync_leanok ran iter-059 (sha `0b5f5b5`, +1/−3). blueprint-doctor: **no structural findings**.

## The +1 sorry: an honest factoring, not a regression
OpenImmersionPushforward went 2→3 sorries. This is *not* papering. The prover discharged the entire **homological half** of the open-immersion acyclicity argument (Bridge (1)/(2) remainder) and, in doing so, replaced the single *opaque* `Ext`-vanishing residual at the `higherDirectImage_openImmersion_acyclic` leaf with the assembly `ext_jShriekOU_eq_zero_of_specIso … hjt hqc`, which **typechecks** — leaving exactly two *blueprint-named geometric* hypotheses still `sorry`:
- `hjt : Φ.functor.obj (jShriekOU V) ≅ jShriekOU V'` (= `lem:jshriek_transport_along_iso`)
- `hqc : (Φ.functor.obj H).IsQuasicoherent` (= `lem:pushforward_iso_preserves_qcoh`)

Both lean-auditor and lvb-openimm independently confirmed the two holes are **correctly typed for their local instances** (`φ = U.isoSpec`, `V = j⁻¹W`), neither vacuous nor weakened, and the `Subsingleton (Ext …)` used in the assembly comes from `affine_serre_vanishing_general_open` transferred via the *genuine bijectivity* of `pushforwardExtAddEquiv` — **no Subsingleton-laundering**.

## Lane 1 — OpenImmersionPushforward (Need #1, open-immersion acyclicity): homological half DONE
The 5 new axiom-clean decls:
- `preadditiveCoyoneda_mapHomologicalComplex_d_apply` (private apply-lemma, line 263).
- `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` (274) — **Bridge (1)/(2) remainder, SOLVED.** Identifies the `q`-th right-derived object of `preadditiveCoyoneda(op P)` at `H` with the homology of the Hom-cochain-complex (`InjectiveResolution.isoRightDerivedObj`); exact at `q ≥ 1` iff every `Ext^q(P,H)` class is zero (`InjectiveResolution.extMk_eq_zero_iff`). **Decisive insight:** this works on the ℕ-indexed `cocomplex`, so the planner's `extAddEquivCohomologyClass ∘ homologyAddEquiv` (ℤ-indexed) route — and the *nonexistent* `Functor.rightDerived ≅ Ext` lemma — are both sidestepped. *Do not search for a `rightDerived ≅ Ext` lemma; there isn't one.*
  - Attempt trail: first `rw [preadditiveCoyoneda_mapHomologicalComplex_d_apply …]` forward → `rewrite failed: did not find pattern`. Reversed to `rw [← hg]; exact preadditiveCoyoneda_mapHomologicalComplex_d_apply …` → success.
- `enoughInjectives_of_hasInjectiveResolutions` (299) — the requested `HasInjectiveResolutions → EnoughInjectives` connector. **Trap:** auto `Mono`/`Injective` structure-default tactics *fail to synthesize in this file*; must supply `mono := InjectiveResolution.instMonoFNatι R 0`, `injective := R.injective 0` explicitly, and obtain a *concrete* `R` from `(HasInjectiveResolutions.out X).out` (the opaque `injectiveResolution X` defeats synthesis).
- `subsingleton_ext_of_iso_fst` (310) — contravariant `Ext`-transfer along a first-arg iso (`Ext.mk₀_comp_mk₀_assoc` + `hom_inv_id` + `Ext.mk₀_id_comp` + `Ext.comp_zero`).
- `ext_jShriekOU_eq_zero_of_specIso` (332) — **Bridge (2) Serre-vanishing assembly.** Generic over `φ : U ≅ Spec R`; uses `pushforwardExtAddEquiv φ` + `EnoughInjectives.of_equivalence Φ.inverse` + `subsingleton_ext_of_iso_fst hjt` + `affine_serre_vanishing_general_open` (Need #2, now unconditional). `hV'` (affineness of `j⁻¹W` carried across `U.isoSpec.inv`) is **proved inline** via `IsAffineOpen.preimage` (+ `[IsAffineHom j]` from separatedness) `.preimage_of_isIso`.

**Why hjt/hqc were not attempted:** both are genuine Mathlib gaps and large constructions — `hjt` is a 4-deep chain (`pushforward_commutes_free` / `_sheafify` / `yoneda_transport_along_homeo` → `jShriekOU_transport_along_iso`); `hqc` is qcoh-transport across an iso of ringed spaces (Mathlib's `Scheme.Modules.pushforward` has *no* qcoh-preservation lemma). Budget was spent on the homological bridge. **Note (review):** `hqc` is qcoh-preservation along an **iso** (`U.isoSpec`), so it is *not* a fundamental wall — pushforward along an iso does preserve qcoh; the work is transporting the `QuasicoherentData` presentation across the iso.

## Lane 2 — CechSectionIdentification (Stub-1 geometric backbone): both blueprint build-targets PROVED
8 new axiom-clean decls in `namespace CategoryTheory.FinitaryPreExtensive`:
- `overProd_coproduct_distrib` (305) — **keystone** `(∐ᵢ Aᵢ) ⨯ B ≅ ∐ᵢ (Aᵢ ⨯ B)` in `Over S` (= `lem:overProd_coproduct_distrib`). ~80 LOC; the painful 40-LOC core is structure-map compat. **Traps (recorded to KB):** `Over.forget S` *creates* colimits (provide `HasColimit` via `hasColimit_of_iso (Discrete.natIso …)`); `HasBinaryProducts (Over S)` is NOT an instance (pass as binder); the two `PreservesCoproduct.iso` terms re-elaborate to *different instances* (`set … ; clear_value`, then cancel with `erw` because `simp` normalizes `(Over.forget S).obj X → X.left`).
- `widePullback_coproduct_iso` (363) — **the full induction** (= `lem:coproduct_distrib_fibrePower`). **Trap:** the nested `Sigma.mapIso (Sigma.mapIso (prodFinSuccIso …).symm)` must elaborate *bottom-up* (no type ascription) else a bad higher-order unification (`X 0 ↦ metavar` instead of reducing `Fin.cons i τ 0 = i`); `≪≫ coproduct_fibrePower_reindex` discharges the `Fin.cons` defeq at the seam. `maxHeartbeats 1600000`.
- Plus `coprodFirst_distrib`, `pcd_hom_fst`/`pcd_hom_snd`/`cf_hom_fst` (descent-compat), `overSigma_hom_eq` (private), `overProd_coproduct_distrib_right` (braided twin — **NEW, lacks a blueprint block**).

**The Stub-1 consumer `cechBackbone_left_sigma` (line 537) stays a sorry.** Every categorical brick it composes now exists; the **sole blocker is the universe reduction**: `𝒰.I₀ : Type u` but `widePullback_coproduct_iso` (and `prod_coproduct_distrib` under it) are `{ι : Type}` = Type 0 only (`isIso_sigmaDesc_fst` is Type-0; widening to `Type*` **does not compile** — confirmed empirically by the planner, contra the iter-058 auditor's "trivial widen"). Fix = reindex `𝒰.I₀ ≃ Fin (Nat.card 𝒰.I₀)` and transport LHS + RHS (~80–150 LOC). The prover stopped at this responsible boundary after delivering the two hardest pieces.

## Soundness — confirmed three ways, no papering
- **Review first-hand:** both files `lake env lean` EXIT 0 (only `declaration uses sorry` warnings); 5 keystones `#print axioms` kernel-only.
- **lean-auditor `iter059`** (0 must-fix / 1 major / 9 minor): both files clean; all 8 sorries honest with correctly-typed goals; no Subsingleton-laundering; Stubs 5/6 use the corrected augmented `D'_aug` form; **no excuse-comments**. The 1 major is code duplication (`isZero_of_faithful_preservesZeroMorphisms` copied from `CechAugmentedResolution.lean` — documented in the docstring, no correctness risk). Report: `.archon/task_results/lean-auditor-iter059.md`.
- **lvb-openimm** (1 must-fix / 8 major / 1 minor) + **lvb-csi** (1 must-fix / 5 major / 2 minor): see recommendations. The must-fixes are *blueprint-coverage / placeholder-flag* issues, not Lean unsoundness.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:overProd_coproduct_distrib`: stripped stale `% NOTE: build target. The Lean declaration does not exist yet` (decl now proved axiom-clean).
- `Cohomology_CechHigherDirectImage.tex`, `lem:coproduct_distrib_fibrePower`: stripped stale `% NOTE: build target …` (decl now proved axiom-clean).
- (Kept: the 5 build-target NOTEs at the `lem:pushforward_commutes_*` / `lem:jshriek_transport_along_iso` / `lem:pushforward_iso_preserves_qcoh` blocks — those decls genuinely do not exist yet; and the 2 augmented-form NOTEs on Stubs 5/6.)
- No `\mathlibok` added (no new Mathlib-backed leaf decls). No `\lean{}` renames needed (prover used the exact anchor names). No stale `\notready` found.

## Note on `\leanok` (ambiguity, not a flag)
lvb-csi observed that `widePullback_overX_eq_prod` and `widePullback_coproduct_iso` statement blocks lack `\leanok` despite being fully proved + axiom-clean. sync_leanok ran this iter (`iter:59`, sha `0b5f5b5`), so this is the script's verdict — but the two prover `.lean` files are git-**untracked** (whole tree is one commit), so the sync's git-diff path may not have picked them up. Not laundering, not mine to fix (`\leanok` is sync's domain). Recorded for the planner to re-confirm after the next commit/sync.

## LOW-severity notes (auditor minors)
- Two bare `simp` (should be `simp only`); one `show` that should be `change`; two `set_option maxHeartbeats` without explanatory comments; a `synthInstance.maxHeartbeats` on a sorry-body (inert). All cosmetic.

## Recommendations
See `recommendations.md`. Headline next-iter items: (1) Lane-2 universe reduction (frontier-ready, all bricks built); (2) Lane-1 `hjt`/`hqc` geometric transport (decompose first — 4-deep chain); (3) blueprint coverage debt — 11 unmatched helpers + 4 OpenImm public lemmas need blocks; (4) `lem:pushforward_iso_preserves_qcoh` blueprint is under-specified (qcoh-along-iso — give the `QuasicoherentData`-transport API).
