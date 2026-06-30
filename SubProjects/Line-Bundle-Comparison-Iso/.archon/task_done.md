# Done Tasks
<!-- Resolved items, last-known state only. Per-attempt detail → iter sidecars. -->

- **Dual-unit FLANK LEAF CLOSED iter-098 (`PresheafDualUnitPullback.lean`) — sorry-free + axiom-clean
  EXIT 0.** The genuine open math that churned 085–087. File was RED (6 v4.31 α-NatTrans naturality-autoparam
  errors at L34/40/65/73/98/134, masked by grep's 1-sorry count) + 1 FLANK sorry. STEP 0 recovered the 6
  sites (`naturality := fun _ _ i => f.appIso_inv_naturality i`). STEP 1 authored + proved the linchpin
  `pushforwardBetaUnitEpsAppOne` (general-`y` carrier value of `q.hom = εIso(pushforward β)⁻¹ = (f.appIso V).hom`).
  STEP 2 closed L1′ `presheafDualUnitIso_pullback_natural`: both flank comparators (`q.hom` RHS,
  `dualUnitRingSwap` LHS) collapse to the same `(f.appIso V).hom`, then an `H1.hom.naturality` telescope.
  +2 helpers (`restrictScalars_laxMonoidal_ε_app`, `presheafPushforwardUnitIso_inv_app`), both proven +
  blueprinted iter-099. Sole `dag-query gaps` ∞-source closed (1→0). Unblocks the TensorObjInverse dual cone.

- **v4.31.0 migration: B1 CLOSED iter-094 + K1 file-split DONE iter-095 (`TensorObjInverse.lean`).** B1
  `tensorObj_restrict_iso_eq_pullbackTensorMap` filled via verbatim v4.30 body (`117100c4` TensorObjInverse
  L843), ZERO v4.31 fixes (validated iter-093's keystone re-port). `TensorObjInverse` 7→6. iter-095: refactor
  `k1-leaf-split` relocated K1 `pullbackTensorMap_isIso_of_isOpenImmersion` (name+sig verbatim) into new leaf
  `TensorObjSubstrate/PullbackTensorMapIso.lean` (imports only TensorObjSubstrate ⇒ monster-free OOM-isolation
  for the 6.4M-HB fill); TensorObjInverse imports it, stub removed, EXIT 0. Project sorry count unchanged (K1
  relocated, fill ACTIVE iter-095).

- **v4.31.0 migration: `TensorObjSubstrate.lean` 5→1 — CLOSED iter-090, axiom-clean EXIT 0.** Recovered #1
  `tensorObj_unit_iso` (leftUnitor-over-`λ_` unit-slot defeq), #2 `tensorObj_restrict_iso` α-nat
  (`appIso_inv_naturality`), #3 `sheafificationCompPullback_comp` (ported parent `_natTrans` body), #4
  `pullbackTensorMap_restrict` (ported ~1030 LOC / 15 helpers incl. PUBLIC `pullbackValIso_comp_leg`). Sole
  remaining sorry = dead private `exists_tensorObj_inverse` dup (delete in cleanup). 3 new fix axes (7–9) →
  ARCHON_MEMORY. LSP DEAD on this file → `trace_state` in build.
- **v4.31.0 migration: `DualInverse.lean` 6→0 — CLOSED iter-089, axiom-clean EXIT 0.** First migration-recovery
  file. Established the reusable 6-axis v4.31 fix pattern (`task_results/…DualInverse.lean.md`). Recovery source =
  orphan sibling `SliceTransport.lean`, NOT `main`. 2 sorries were non-math (forward-ref ordering bug; thin-poset
  `subsingleton` naturality).

- **Cone B c.2 ASSEMBLY + L377 + L434 — iter-074 (`DualInverse/PresheafDualPullback.lean`).** PresheafDualPullback
  sorry **3 → 1**. (1) The iters-067–073 whnf-seam blocker RESOLVED: the entire iter-071 H1-cancellation is
  realised in COMPILING code via a NEW private generic single-`[Category C]` skeleton `c2_assemble` (8 hyps,
  axiom-free), `refine`-applied to the c.2 goal — `refine` crosses the `PresheafOfModules`-over-`Z` `≫` seam by
  metavariable unification with NO whnf bomb (the iter-071 "fictional trio" `comp_cancel_mid/_slide_nested/
  _three_lr` never existed; superseded). (2) `presheafDual_pullback_comparison_eval_apply` (L377) CLOSED:
  `unfold evalLin; erw [sliceDualTransport_app_apply, dualUnitRingSwap_apply]; rfl` (erw bridges
  ConcreteCategory.hom vs ModuleCat.Hom.hom). (3) `evalLin_restrict_commute_aux` (L434, off-path) CLOSED:
  one-shot term-mode `(naturality_apply (internalHomEval N) j.op (s⊗ₜφ)).symm` (no private re-exposure needed).
  c.2 reduced to its SOLE residual (★) `hstar` (L855) = pushforward-flank `sliceDualTransport`
  pseudofunctoriality, blocked on `FC=leftAdjointCompIso` opacity (→ §0 mate route, iter-075). Coverage:
  `c2_assemble` blueprint block added iter-075 (`lem:c2_assemble`).
- **Forward apply brick `sliceDualTransport_app_apply` — CLOSED iter-073** (`SliceTransport.lean:1037`, `:= rfl`,
  axiom-clean). `:= rfl` ONLY with β as a folded `letI` in the φ-binder; concrete-inlined β zeta-bombs at 10M HB
  in STATEMENT elaboration. The last cross-file brick the c.2 lane needed (iter-072 was a validator no-op).

- **Cone B c.2(a) `presheafDualH1Cocycle` (`lem:presheafdual_h1_cocycle`) — CLOSED iter-070 sorry-free,
  axiom-clean** (`{propext, Classical.choice, Quot.sound}`). The H1=`leftAdjointUniq` cocycle over the
  immersion factorisation. Realized as a one-line `exact` instantiation of a NEW generic mate-calculus
  engine **`CategoryTheory.Adjunction.leftAdjointUniq_leftAdjointCompIso_comm`** (+ 2 new mate helpers
  `conjugateEquiv_leftAdjointUniq_hom` = `𝟙 G`, `conjugateEquiv_leftAdjointCompIso_hom` = `e.inv`), all
  axiom-clean — the dual-flank analogue of the project keystone `conjugateEquiv_restrictFunctorComp_inv`,
  generalised away from the restrict world. Engine proof: `conjugateEquiv.injective`, both mates collapse
  to `e.inv` via `← conjugateEquiv_comp` (SPLIT a conjugate-of-composite — the simp lemma only COMBINES),
  `conjugateEquiv_whiskerLeft/Right`. Idioms: use `Functor.whiskerRight/Left` (bare names shadowed to
  monoidal whiskering by `open MonoidalCategory`); composite-immersion `αhf` needs an EXPLICIT
  `naturality := fun _ _ i => (h ≫ f).appIso_inv_naturality i` (aesop default fails for `h ≫ f`). The (a)
  statement ∀-quantifies the three `pushforward β` adjunctions (faithful strengthening). **The blueprint
  c.2 finding (iter-070): c.2 is NOT "(a)+(b) paste" — it is the interleaved dual of proven
  `pullbackTensorMap_restrict`; (a) is the H1-recombination factor inside that merge.** (Reversal-armed
  trip-wire RESOLVED: (a) closed, not PARTIAL.)

- **Cone B CRUX `presheafDual_pullback_restrict_natural` (`…/DualInverse/PresheafDualPullback.lean`) — CLOSED
  iter-066, sorry-free + axiom-clean `{propext, Classical.choice, Quot.sound}`.** This is the lemma the dual
  flank S3/S4a consume. KEY FINDING: it closes in ONE line by θ.hom's BUILT-IN `PresheafOfModules.Hom`
  naturality (`funext φ; naturality_apply θ.hom (homOfLE j).op φ`), NOT the effort-broken L1;L2;L3a chain —
  the whole L1/L3a decomposition was unnecessary (now 2 abandoned off-path sorries in the sibling). Also
  closed iter-066: L3b `_apply`, L2 `dualPrecompHom_restrict_apply`, the `dualPrecompHom` def (dual-carrier
  `ofHom` instance trick: 4 `letI`s both carrier forms + explicit ring ascription), and the θ-def
  `presheafDualPullbackComparison`. File RED→green-mod-sorry (2). **Unblocks S3/S4a (iter-067 lane).**

- **B1-crux ENGINE `H1inv_app_eq_pullbackVal_restrict` + `sheafPullbackUnit_forget_eq` (`TensorObjInverse.lean`) —
  CLOSED iter-053, sorry-free + axiom-clean.** The 050–052 plateau (whole-composite homEquiv PROVEN circular) broken
  via forget-faithful (`fullyFaithfulForget.map_injective`) + INNER presheaf-pullback transpose + INVERSE-`leftAdjointUniq`
  triangle (`hAcancel`=`leftAdjointUniq_inv_app`+`unit_leftAdjointUniq_hom_app`) + `sheafificationCompPullback_eq_leftAdjointUniq`;
  term-mode assembly across the `SheafOfModules ≫` seam. Unblock = mathlib-analogist cross-domain
  (`analogies/ofisrightadjoint-unit.md`, `Functor.toSheafify_pullbackSheafificationCompatibility` precedent).
  With B2 (iter-050) the entire B1/B2 engine layer is done; remaining = the 5 immersion-naturality squares.
- **S2 tensor-flank square `tensorObj_restrict_iso_restrict_compat` (`TensorObjInverse.lean`, L1027) — CLOSED
  iter-054, sorry-free + axiom-clean** (file 5→4). First close on the squares. B1-route exactly as blueprint:
  `simp [tensorObj_restrict_iso_eq_pullbackTensorMap]` (B1) → B2 expands the leading RFIP at `M⊗N` only → cancel
  prefixes → `Iso.ext` + RFIP-j naturality → pre-cancelled composition law `pullbackTensorMap_restrict_cancel` +
  `pullbackTensorMap_natural` → merge two 3-fold `tensorObj_functoriality` composites via
  `tensorObj_functoriality_comp3` (EXPLICIT morphism args) → discharge each leg by
  `restrictFunctorIsoPullback_comp_compat_leg`. Needs `maxHeartbeats 6400000`. **whnf-seam idiom (KB):** prefer
  `exact`/`refine` of a FULLY-APPLIED generic lemma over `erw`/placeholder-`refine` on sheafification-carrier goals.
  9 new private helpers (coverage debt, deferred to cleanup phase).
- **D3′ composition law `pullbackTensorMap_restrict` (`TensorObjSubstrate.lean`, L3451) — CLOSED + axiom-clean
  (re-verified iter-054).** Despite stale in-proof comments "Typed sorry retained" (L3480/3541, parent-iter-261
  leftovers that FALSE-ALARMED a blueprint-reviewer iter-054), the proof CLOSES at L3982 (`exact pullbackValIso_comp_leg`);
  axiom check `{propext, Classical.choice, Quot.sound}`. Unblocks the tensor-flank squares S2/S4b.

- **SHARED KEYSTONE `conjugateEquiv_restrictFunctorComp_inv` (`TensorObjSubstrate.lean`, ~L4943) — CLOSED iter-048,
  PUBLIC, axiom-clean (lake EXIT 0, 8321 jobs).** The multi-iter (044–047) terminal blocker — restrict-side mirror
  of Mathlib `conjugateEquiv_pullbackComp_inv`; BOTH B2 + B1-crux reduce to it. iter-046's "irreducible to library
  algebra" verdict was WRONG: the working route INSTANTIATES `Adjunction.leftAdjointCompIso` on `pushforwardComp`
  (does NOT equate it definitionally with `restrictFunctorComp`). Recipe: `rw [show (restrictFunctorComp f g).hom =
  (leftAdjointCompIso … (pushforwardComp f g)).inv from ?_]`; main goal `exact conjugateEquiv_leftAdjointCompIso_inv`;
  residual concrete iso-hom equality `ext M U : 3` (SAFE — conjugate head gone; the whnf-bomb was at `ext` on the
  conjugate-headed goal, NEVER do that) + sectionwise MAP-level merge (`← M.presheaf.map_comp`) + `Subsingleton.elim`.
  Private helper `restrictFunctor_map_app'` (`:= rfl`) added alongside.
- **K1 μ/δ-side `pushforward_mu_appIso_collapse` (`TensorObjSubstrate.lean`) — CLOSED iter-031, axiom-clean.**
  The circular-mate blocker for iters 026–030. Bypassed by extracting the reduction as a NEW abstract helper
  `deltaConjOfMuComparison` (`private`, L4423; `Type*` clean fvars dodge the zeta-`let`/whnf friction that
  killed every inline attempt) + a one-line `exact deltaConjOfMuComparison hadj' (pullbackPushforwardAdjunction
  φ') A B (pushforward_lax_mu_comparison f A B)`. `lean_verify`: only propext/Classical.choice/Quot.sound.
  Transitively sorry ONLY via `lhs_tmul` (through `pushforward_lax_mu_comparison`). `deltaConjOfMuComparison`
  is private → no blueprint block owed (coverage phase). Closes fully once `lhs_tmul` lands.

- **K1 μ-side RHS `pushforward_lax_mu_comparison_rhs_tmul` (`TensorObjSubstrate.lean`) — PROVEN iter-029,
  axiom-clean (green).** The RHS-composition tensorator's pure-tensor value: `(μ (restrictScalars φ') M₁ M₂).app W
  (m⊗ₜn) = m⊗ₜn`, proof `= restrictScalars_μ_app_tmul`. Stated generic/abstract (abstract base-ring functors +
  abstract `M₁ M₂`) with `set_option backward.isDefEq.respectTransparency false in` BEFORE the doc comment —
  concrete K1 `Gβ.obj`/`pushforward₀` section binders fail module-synth (memory `restrictscalars-mu-tmul-binder-trap`);
  applied to the K1 objects by defeq. Also: parent `pushforward_lax_mu_comparison` body is now sorry-free
  (clean `hom_ext` delegation to the per-section lemma — the prior undecomposed in-proof sorry eliminated);
  transitively sorry only via `_lhs_tmul` (still open, deferred to iter-031 solo lane).

- **K1 η-side `pushforward_eta_appIso_collapse` (`TensorObjSubstrate.lean`) — CLOSED iter-028, axiom-clean.**
  First K1 critical-path sorry eliminated after the ~14-iter η stall (leaf sorries 6→5). The blocker was pure
  Lean plumbing (RingCat `map_one` won't fire; `𝟙_` `OfNat` won't synth), solved by the mathlib-analogist
  `analogies/eta-plumbing.md` idiom: new sorry-free helper `restrictScalars_oplaxMonoidal_η_app_one` states
  `1` through `(S ⋙ forget₂ CommRingCat RingCat).obj W`; closer `erw [restrictScalars_oplaxMonoidal_η_app_one
  β' hβ (op (f⁻¹ᵁU)), map_one]; rfl`. (`rw [Functor.map_id]` FAILS — dependent motive; `erw [helper]` matches
  the whole `(restrictScalars β').map 𝟙 ≫ η` composite up to defeq.) Blueprint helper entry authored bp029.
- **Cocycle-A collapse mechanism (`TensorObjInverse.lean`) — PROVEN mod B1, iter-028, axiom-clean.** Two new
  fully-proven helpers: `tensorHom_inv_comp_leftUnitor` (generic monoidal coherence `s≫s'=𝟙 → (s⊗ₘs')≫λ=λ`)
  and `tensorObjIsoOfIso_comp_unit_iso` (B2; the `X.ringCatSheaf.val` vs `presheaf⋙forget₂` carrier diamond
  crossed via `erw [Functor.map_comp]` + `exact congrArg (·≫_) hmap`). `tensorObj_unit_self_duality_collapse`
  body now sorry-free (N-leg via `congrArg Iso.symm (dualUnitIso_dualIsoOfIso t)` + `simpa`; the
  `(dualIsoOfIso t).symm = dualIsoOfIso t.symm` rewrite is a DEAD route — `Iso.self_symm_id` "pattern not
  found"). Memory: [[cocycle-a-collapse-mechanism]]. Residual = B1's eval-core (N) only.

- **Connector `homOfLocalCompat_restrictFunctor_map` (`DualInverse.lean`) — CLOSED iter-026, axiom-clean.**
  `(restrictFunctor (U i).ι).map (homOfLocalCompat U hU f hf) = f i`. Route: reconstruct gluing internals
  defeq + `change` to glued-section form + morphism-level `key` collapsing the `homLocalSection`
  eqToHom-conjugation via `eqToHom_comp_iff` + `exact`-matched `α.naturality` (forward `rw [naturality]`
  fails — X-level vs restrict-level only defeq, not syntactic). `SheafOfModules.Hom.ext` BEFORE
  `PresheafOfModules.hom_ext`. `(U i).ι ''ᵁ P ≤ U i` = `Scheme.Opens.ι_image_le` (NOT `image_le_range`).
  DualInverse.lean now fully sorry-free. (Memory: [[restrictfunctor-glued-morphism-pattern]].)
- **Terminal residual B (`exists_tensorObj_inverse`, `TensorObjInverse.lean`) — CLOSED iter-026.** With the
  connector decl present, `rw [key]; exact hfiso x` where `key := homOfLocalCompat_restrictFunctor_map U _ f _ x`.
  Leaf sorries 5→3. The 3-iter connector "non-delivery" was a plan-validate DROP (file had 0 sorries →
  prover never dispatched), fixed by scaffolding the stub first (iter-026 plan turn).

- **Seed-1 D4′ chart-chase ASSEMBLED iter-020** (`pullbackTensorIsoOfLocallyTrivial`, L4238): body sorry-free,
  reduces the whole D4′ `IsIso` obligation to the single open-immersion brick K1. 3 new sorry-free `private`
  helpers (aud020: non-vacuous + used): `isIso_of_isIso_comp4_mid` (generic plumbing), `chart_isIso` (per-chart
  core: `isIso_of_isIso_restrict` transport + two `pullbackTensorMap_restrict` D3′ splits), and K2
  `pullbackTensorMap_isIso_of_base_unit` (trivial-base case via `pullbackTensorMap_natural` D1′ +
  `pullbackTensorMap_unit_isIso` D2′). Residual = K1 only (see task_pending). aud020 + tos020 PASS; tos020
  must-fix = blueprint mis-counted D4′ ("only D3′ is new" wrong) → K1 node added iter-021.

- **`pullbackValIso_comp_leg` (Sq4, `lem:pullback_val_iso_comp`) — CLOSED iter-019 axiom-clean** (`propext, Classical.choice, Quot.sound`; no `sorryAx`). The 5-iteration-stuck D3′ leaf brick. Key unblock: `η^Z` unit-naturality on both legs factors a common leading `η ≫ forget(·)`, collapsing the goal to a clean sheaf-level cocycle `hH`; `slice_lhs`/`slice_rhs` fold + `exact comp_forget_cocycle`. `hH` chased via Sq4a inverse (`inv_telescope`) + `pullbackComp` naturality at counit + adjunction triangle `(adj.homEquiv).left_inv`. 5 new sorry-free `private` helpers: `comp_forget_cocycle`, `inv_telescope`, `cocycle_assemble`, `sheafificationCompPullback_comp_inv` (realises `lem:pullback_val_iso_comp_scpb`), `adj_unit_map_counit` (realises `lem:pullback_val_iso_comp_counit`). **Consequence: `pullbackTensorMap_restrict` (`lem:pullback_tensor_map_basechange`) and the WHOLE D3′ comparison-iso substrate cone are now sorry-free.** progress-critic standing CHURNING resolved by an actual sorry elimination. (aud019 + tos019 PASS.)

- `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwap_apply` — solved helper from session 2; supports the DUAL inverse path and is now accounted for in the project state.
- `sheafificationCompPullback_comp_tail` (`lem:sheafificationcomppullback_comp_tail`) — CLOSED iter-006 (the 6-iter STUCK D3′ node) via `conjugateEquiv_comp` at NatTrans level (recipe `d3cocycle006.md`); its caller `sheafificationCompPullback_comp` is now sorry-free end-to-end. Also `sheafificationCompPullback_comp_natTrans` (prototype) and the `hδ`/Sq2b sub-sorry of `pullbackTensorMap_restrict`.
- `sliceDualTransport.toFun.naturality` (forward ε-square) — CLOSED iter-007 via the morphism-level recipe (`dualnat006.md`): extracted standalone `sliceDualTransport_naturality_apply`, closed pointwise through `appIso_hom_naturality_apply` + `dualUnitRingSwap_apply` + `φ.naturality_apply` (never sending `inv ε` through `whnf`). Also `map_add'`/`map_smul'`. This is the working template for the inv-naturality root.
- `sliceDualTransportInv.naturality` (the DUAL ROOT, multi-iter blocker gating the whole dual chain) — CLOSED iter-012 axiom-clean. NOT the morphism-level rotation (that times out at `whnf` of `inv ε`); instead the forward template's route — an extracted shallow-statement lemma `sliceDualTransportInv_naturality_apply` (down-set facts passed explicitly, ε-swap legs kept shallow), then the def's `naturality` field closed by `exact` (defeq matches the rfl-legs automatically). Proof of the apply-lemma: `hM` M-side coherence + `ψ`-naturality + `appIso_inv_naturality`. Helper `sliceDualTransportInv_app_apply` (rfl) also added. Blueprint entries authored iter-013 (`lem:slice_dual_transport_inv_naturality_apply`, `lem:slice_dual_transport_inv_app_apply`).
- `sheafifyMap_pullbackComp_hom_inv_id` (D3′ brick 1, `lem:sheafify_pullbackcomp_hom_inv_cancel`) — PROVED iter-012 axiom-clean (`private lemma`): `rw [← Functor.map_comp]; erw [Iso.hom_inv_id_app]; exact aZ.map_id _`. The step-(i) cancellation of the four-square interleave. (`Functor.map_id/comp` resolve to the monad first — use `aZ.map_id`/`aZ.map_comp`; `Iso.hom_inv_id_app` needs `erw` post-merge.)
- `sliceDualTransport.left_inv` + `.right_inv` (DUAL route final) — CLOSED iter-015 axiom-clean; `SliceTransport.lean` now sorry-free, seed `dual_isLocallyTrivial` delivered, DUAL route COMPLETE. Root cause was NOT a tactic gap: L890 was already fixed; the file was RED from a heartbeat-budget overflow on the inline 6-field `≃ₗ` — fixed by `set_option maxHeartbeats 1600000`. `right_inv` = 3-step mirror of `left_inv` (ring-identity collapse via `appIso_inv_naturality`, ψ-naturality at a thin-poset slice, `Y.presheaf` round-trip). Built in an isolated HEAD worktree to dodge the import race. (Dead ends: `rw [← hnat]` proof-term mismatch → `show … from hnat.symm`; `simp [eqToHom_map]` over-collapses → targeted `rw`.)
- **D3′ step (i) `D ≫ E = 𝟙` cancellation** (the iters-012–015 wall) — CLOSED iter-015. New `private comp_cancel_mid` (generic single-`[Category C]` middle-cancellation `(r0 ≫ r1 ≫ r5 ≫ d) ≫ e ≫ rest = r0 ≫ r1 ≫ r5 ≫ rest` for `d ≫ e = 𝟙`) applied by `exact` (NOT `rw`): the defeq unifier crosses the defeq-but-not-syntactic `SheafOfModules` instance gap that defeats `rw [Category.assoc]` and mate-`whnf`-bombs `erw`. Spliced via `erw [reassoc_of% hmain]`. General device for instance-boundary cancellation. (lean-auditor aud015: SOUND, not vacuous, genuinely used.)
- **D3′ step (ii) δ-split** — CLOSED + SPLICED iter-016 via `sheafifyMap_δcomp_split` (`lem:sheafifymap_deltacomp_split`, axiom-clean): `a_Z.map δcomp = a_Z.map((pullback φ'_h).map δ_f) ≫ a_Z.map δ_h`, definitional from `Functor.OplaxMonoidal.comp` (`rw [← Functor.map_comp]; congr 1`), spliced by `erw`.
- **D3′ step (iii)-a/b.1/b.2** — SPLICED iter-017, narrowing the `pullbackTensorMap_restrict` residual to the single presheaf identity `hcore2`. (iii)-a = `S1^h` slide (`comp_slide_nested` + `.symm` of `sheafificationCompPullback h` naturality at `δ_f`); (iii)-b.1 = prefix cancel (`comp_cancel_three_lr`); (iii)-b.2 = slide of `V` (`comp_slide_three` + `map_comp_slide`; `hcomb` via `sheafificationCompPullback h` naturality at `gg` + `a_Y.map_comp` + `sheafifyTensorUnitIso_hom_eq'`). All helpers `private`, generic instance-boundary plumbing applied by `exact`/`refine`. Also iter-017 RED→GREEN repair (stray bombing `erw` removed). (lean-auditor aud017: 4 helpers non-vacuous + used.)
- **D3′ step (iii).b.3 merged Sq3/Sq4 presheaf core `hcore2`** — CLOSED iter-018. Fold-then-presheaf chase mirroring D1′ `pullbackTensorMap_natural`: `sheafifyTensorUnitIso_hom_eq'` rewrites each `sTUI.hom` to `a_Z.map(η⊗η)`; new `private map_comp4_eq_comp5` folds the 4-vs-5 `a_Z.map` chain to one `a_Z.map Ψ` (applied by `refine`, crosses the instance wall); concrete fully-applied `have hδnat := δ_natural …` (instance pinned via `show … from`) spliced by `erw [← reassoc_of% hδnat]` (metavar `δ_natural` whnf-bombs); new `private tensorHom_collapse_3_4` collapses the tensorHom chains by bifunctoriality to two per-leg identities. `pullbackTensorMap_restrict` is now **sorry-free modulo** the single isolated brick `pullbackValIso_comp_leg`. (lean-auditor aud018: 3 helpers non-vacuous + used; not laundered.) The standalone-extraction `pullbackTensorMap_restrict_core` was ABANDONED (carrier `MonoidalCategoryStruct` not top-level synthesizable); blueprint node `lem:pullback_tensor_basechange_presheaf_core` DROPPED iter-019 (content realised in-place).

- **Seed-1 `pullbackTensorIsoOfLocallyTrivial` (D4′, `lem:pullback_tensor_iso_loctriv`) — DELIVERED iter-042.** Root `TensorObjSubstrate.lean` GREEN (`lake build` EXIT 0, 8321 jobs), sorry-free, axiom-clean. The sole open brick K1 `pullbackTensorMap_isIso_of_isOpenImmersion` (L4770, **public**) closed: its `hδ` (`IsIso (δ (PresheafOfModules.pullback φ') M.val N.val)`) realized via the abstract sandwich `isIso_oplaxδ_of_conj` fed the δ-conjugation `pushforward_mu_appIso_collapse f M.val N.val` (built on abstract mate-conjugation `deltaConjOfMuComparison`): `δ(pullback φ')` is conjugate via `leftAdjointUniq` to the strong `δ(Gβ)` of `pushforward₀OfCommRingCat ⋙ restrictScalars β'` (β sectionwise-bijective ⇒ `restrictScalarsMonoidalOfBijective`). This SUPERSEDED the planned helpers `pullbackTensorMap_presheafDelta_eq`/`pullbackTensorComparison` (never realized — they were the undefined-id stub that masked the root as RED for iters 039–041 under LSP stale-green). **LESSON: trust ONLY `lake build`, never LSP, on the >4800-LOC root.** Blueprint reconciled to the realized machinery iter-043 (reconcile043; gate cleared). `lhs_tmul` + the whole D4′ chart-chase cone are sorry-free.

- **Shared keystone `conjugateEquiv_restrictFunctorComp_inv` (root) — CLOSED iter-048.** Public, axiom-clean (`lake build` EXIT 0). The 044–047 terminal blocker. iter-046's "irreducible" verdict OVERTURNED: INSTANTIATE `Adjunction.leftAdjointCompIso` on `pushforwardComp` (do NOT equate with `restrictFunctorComp`); `exact conjugateEquiv_leftAdjointCompIso_inv`, residual concrete iso-hom eq by MAP-level merge (`← presheaf.map_comp`) + `Subsingleton.elim`. **The whnf-bomb was `ext` on the conjugate-headed goal — NEVER `ext` before the abstract rewrite.** Consumed by terminal iter-049 (deleted the colliding private sorry-stub of the same FQ name).
- **Bridge B2 `restrictFunctorIsoPullback_comp_compat` (terminal) — FULLY CLOSED iter-050.** The multi-iter 044–049 blocker, eliminated. Sorry 7→6, axiom-clean. 6 new public lemmas: LHS-collapse keystone `conjugateEquiv_restrictFunctorIsoPullback_hom` (= 𝟙), `conjugateEquiv_pullbackComp_hom` (c₅), `…_whiskerRight` (c₃), `…_whiskerLeft` (c₄), `conjugateEquiv_reindexCongr` (c₁/c₆), and the assembled `restrictFunctorIsoPullback_comp_compat_hom`. **Recipe:** `conjugateEquiv.injective` → LHS-collapse keystone → N explicit `← conjugateEquiv_comp` splits over the FIXED `(C,D)=(X.Mod,V.Mod)` through G₀..G₆ → per-leg pushforward-world values (c₂ = root keystone) → cancel `pushforwardComp` pair → `conjugateEquiv_reindexCongr`. **`mateEquiv_hcomp`/`vcomp` confirmed UNNEEDED** (all legs share (C,D); leg-by-leg `conjugateEquiv_comp` suffices). The breakthrough was fine-grained'ing the telescope into atomic per-leg sub-lemmas after CHURNING on the whole-`hNat`. Blueprint blocks for all 5 per-leg lemmas + the LHS-collapse keystone present (the keystone block + dangling-pin cleanup done iter-051).
- **B1-crux engine `H1inv_app_eq_pullbackVal_restrict` + `sheafPullbackUnit_forget_eq` (terminal) — CLOSED iter-053.** Sheafification-boundary unit coherence, axiom-clean. forget-faithful (`fullyFaithfulForget.map_injective`) + INNER presheaf-pullback transpose + INVERSE-`leftAdjointUniq` triangle + `sheafificationCompPullback_eq_leftAdjointUniq`; whole-composite homEquiv route was PROVEN CIRCULAR (mathlib-analogist `analogies/ofisrightadjoint-unit.md` unblock). **S2 CLOSED iter-054.**
- **Cone A (S4b square) — CLOSED end-to-end iters 054–065; the tensor-flank left-unitality.** Sequence: S2 (054); S4b body (055) + inner seam (056) → whole S4b rides on bridge-3 `pullbackTensorMap_left_unitality`; effort-broken (057) into L1/L2/L3 chain. **iter-064:** STU-collapse keystone `tensorObj_left_unitor_image_collapse` (sorry-free; by-hand presheaf reduction across the `restrictScalars 𝟙`/`𝟭.obj` defeq seam — NOT the localization-monoidal API; term-mode `congrArg₂`/right-triangle `htri`/`map_comp_assoc` merge/explicit-left-factor) + L2 `tensorObj_left_unitor_pullback_eq_sheafify` (sorry 6→5). **iter-065:** L3 `pullbackUnitIso_whisker_eq_sheafify_eta_whisker` (central leg = arg-1 q=𝟙 specialization of the ALREADY-PROVEN `sheafifyTensorUnitIso_hom_natural`, root `:1896` — REUSE not rebuild; the iter-065 plan cross-check killed the iter-064 "must build a 2nd core" plan) + bridge-3 assembly `pullbackTensorMap_left_unitality` (sorry 5→3; fixed a STALE-GREEN pre-written body: missing `maxHeartbeats` whnf-timeout + bare-`_` mis-unification of `reassoc_of%`'s `k`/`congrArg` prefix across the `SheafOfModules ≫` seam — both pinned explicitly; `rw [reassoc_of% …]` MISSES the seam, term-mode only). **Cone A is DONE; only the dual flank (Cone B) + telescope remain.** Memory `stu-collapse-keystone.md`, `seam-split-fold-idiom.md`.

- **Cone B c.1 `pushforwardObjValRestrictIso` (`def:pushforward_obj_val_restrict_iso`) — CLOSED iter-069 sorry-free, axiom-clean** (`{propext, Classical.choice, Quot.sound}`, no `sorryAx`). The foundational object-id iso `(pushforward β).obj M.val ≅ (M.restrict f).val`. Realized as **`Iso.refl _`**: Mathlib's `Scheme.Modules.restrictFunctor f` is *defined* as `SheafOfModules.pushforward ⟨whiskerRight α (forget₂ …)⟩` whose object action is `{ val := (PresheafOfModules.pushforward β).obj M.val, … }`, so `(M.restrict f).val` is DEFINITIONALLY `(pushforward β).obj M.val` — the blueprint's abstract H1∘(RFIP;SCP) composite IS the identity once the concrete `restrictFunctor` defeq is used. Inspect the Mathlib def BEFORE building a composite. c.2 (the cocycle consuming c.1) effort-broken into (a)+(b) iter-070 → see task_pending.

- **Cone B brick `sliceDualTransport_app_apply` (forward apply, `lem:slice_dual_transport_app_apply`) — CLOSED iter-073 sorry-free, axiom-clean** (`SliceTransport.lean:1037`, `:= rfl`, kernel-only). The FORWARD mirror of the proven inverse `sliceDualTransportInv_app_apply` (L563). **LESSON:** closes by `rfl` at DEFAULT heartbeats ONLY if β is a folded `letI` in the φ-binder (the consumer's own spelling) — concrete-inlined β zeta-bombs the `whiskerRight`/`toModuleIso` carrier in STATEMENT elaboration (confirmed 200k/4M/10M HB; super-linear, HB does NOT help). Unblocks c.2 (∗∗) + the off-path consumer L377 (`rw [sliceDualTransport_app_apply, dualUnitRingSwap_apply]`). iter-072 was a validator no-op (header "ADD" ≠ scaffold keyword); re-dispatched correctly iter-073.

- **Cone B brick `sliceDualTransport_comp` (`lem:slice_dual_transport_comp`) — LANDED iter-077 sorry-free, axiom-clean** (`SliceTransport.lean:1068`, sectionwise structure-ring split via `sliceDualTransport_app_apply` + `dualUnitRingSwap_apply` + `comp_appIso` + `comp_image`). **BUT it does NOT close the c.2 consumer `case hstar`** — after slice-peeling, the residual is the sectionwise action of `FC = leftAdjointCompIso`, pushforward content not slice content. **iter-078 mathlib-analogist `fc-pushforwardcomp` (STUCK-corrective):** (a) KEEP `FC=leftAdjointCompIso` — Mathlib idiom (`pullbackComp` literally = it; cocycle (a) needs both flanks = `leftAdjointCompIso` of the SAME `e`); (b) swapping FC→concrete `pushforwardComp βf βh` is DIVERGENT-AND-WRONG (codomain differs by `comp_appIso` eqToHom → not type-compatible; breaks cocycle (a)) — DEAD; (c) VALIDATED CLOSE = diamond-free sectionwise `(FC.hom.app dM).app V` via the `change`-to-`X.presheaf.map(·).op` triangle-component idiom (`pushforwardPushforwardAdj_unit/counit_app_app_apply`; idiom @ `PresheafInternalHom.lean:449-461`); `change` NOT `simp` (carrier diamond). Blueprint close-route corrected + HARD GATE CLEARED iter-078 (fast-path); SOLO `prove` lane dispatched iter-078. `analogies/fc-pushforwardcomp.md`.

- **Cone B c.2 `presheafDualPullbackComparison_restrict` `case hstar` (★, `lem:presheafdual_pullback_comparison_restrict`) — CLOSED iter-079 sorry-free, axiom-clean** (`{propext, Classical.choice, Quot.sound}`). **PresheafDualPullback.lean is now fully sorry-free; the entire Cone B DUAL-crux substrate (crux/c.1/(a)/c.2) is COMPLETE.** After the iter-078 sectionwise FC reduction, the residual was φ's presheaf-morphism naturality square along the canonical (thin, UNIQUE) slice morphism `g`; **KEYSTONE = `Over (Opens X)` is a thin poset whose homs are proof-irrelevant ⇒ `homOfLE ≡ eqToHom` DEFINITIONALLY**, so the goal's `eqToIso`/`restrictFunctorComp` reindexes are defeq to `(restr base …).map g` and `convert key using 2` finishes by `rfl` (NO residual `Subsingleton` goals). New private helper `hstar_naturality` (packages `naturality_apply φ g z` with `g` a DECOUPLED explicit arg — an internally-built `g` defeats `convert`'s slice unification). DEAD: `erw [restrictFunctorComp_hom_app_app]` on RHS (geometry `Hom.app` level ≠ goal's ModuleCat `.val.app`); `rw [show RHS = M.val.map(eqToHom).op]` (semilinear restrictScalars carrier diamond). **Unblocks the terminal cone in TensorObjInverse.lean — see task_pending.**

- **Terminal S3 `dual_restrict_iso_restrict_compat` + L1 `dual_restrict_iso_comp` STEP-B — CLOSED iter-084 sorry-free, axiom-clean** (`{propext, Classical.choice, Quot.sound}`; `TensorObjInverse.lean` sorry 3→2). The inline ★pb-iso SCP-cocycle (former L1384) closed → S3 fully sorry-free → the ~15-iter `restrictFunctor j` source-cat instance diamond cone RETIRED on the dual-restriction leg. **REUSABLE winning idiom:** `apply Iso.ext`→syntactic `.hom` flatten (`simp only [Iso.trans_hom, Functor.map_comp, …]`, seam-safe — never touches `θ_g`'s `sliceDualTransport`)→generic abstract `dual_scp_assemble` (NEW pure single-`[Category C]` helper: head-cancel + mid-cancel + SCP naturality) by `exact` (objects opaque ⇒ NO sheafify-colimit whnf bomb — exactly why the iter-080 Scheme-typed `s3_assemble` bombed at 6.4M HB). Five concrete `have`s feed it (bridge (b) `sheafificationCompPullback_comp`, distribute-`sheafify` via `← Functor.map_comp ×3`, two inverse-pair cancels, SCP naturality at `θ_g.hom`). DEAD (lake-verified): `rw [hb]`/`rw [Iso.trans_assoc]` across the `≫` seam (defeq-not-syntactic, "pattern not found"); `erw [hb]` fires but leaves an un-reassociable iso-bracket; `rw [Iso.hom_inv_id_app]` inside `sheafify.map(·≫·)` MISSES (use term-mode `congrArg`). Remaining: S4a (effort-broken iter-085) → telescope.

- **ROOT δ/η-collapse machinery RE-PORT (v4.31 KEYSTONE GAP) — CLOSED iter-093, axiom-clean.** The Jun-27 bump
  had *DELETED* (not sorry'd) the whole ~690-LOC δ/η-collapse block from ROOT `TensorObjSubstrate` (v4.30
  `117100c4` L4077–4768). Re-ported as **13 declarations** (TensorObjSubstrate L3906–4629), all
  `[propext, Classical.choice, Quot.sound]` only (no `sorryAx`): `restrictScalars_δ_app_tmul` (the dropped
  transitive dep), `isIso_of_isIso_comp4_mid`, `pullbackTensorMap_isIso_of_base_unit`,
  `pushforwardPushforwardAdj_unit/counit_app_app_apply`, `restrictScalars_oplaxMonoidal_η_app_one`,
  `pushforward_eta_appIso_collapse`, `pushforward_lax_mu_comparison_rhs_tmul`/`_lhs_tmul` (220-LOC, ported
  clean, NO OOM — monster-free cone confirmed), `pushforward_lax_mu_comparison`, `deltaConjOfMuComparison`,
  **`pushforward_mu_appIso_collapse`** (THE keystone EQUATION), `isIso_oplaxδ_of_conj`. `lake build
  …TensorObjSubstrate` EXIT 0, 8562 jobs. Only 2 v4.31 fixes beyond verbatim: (1) axis-#1 α-naturality field at
  6 sites (`naturality := fun _ _ i => f.appIso_inv_naturality i`, column-aligned to `app`); (2) NEW axis —
  `simp [..._δ_assoc]` mate reductions stopped firing in `deltaConjOfMuComparison` → `conv_rhs` + iterated
  `erw [reassoc_of% …]` (the 3 closing rewrites must be ONE `erw`). Unblocks K1 + B1 in TensorObjInverse.
  Recipe map: `iter/iter-093/objectives.md`; fix detail: `task_results/…TensorObjSubstrate.lean.md` (archived).

## K1 `pullbackTensorMap_isIso_of_isOpenImmersion` — DONE iter-095 (leaf `TensorObjSubstrate/PullbackTensorMapIso.lean`)
Relocated (refactor `k1-leaf-split`) from TensorObjInverse into monster-free leaf, then filled verbatim
v4.30 (`117100c4:TensorObjSubstrate:4790`) with 1 v4.31 fix (α-NatTrans `naturality := f.appIso_inv_naturality`).
sorry-free, EXIT 0 (8563 jobs, ~13s), axiom-clean. OOM-isolation hypothesis confirmed (13s, no Exit 137).
Keystone deps `pushforward_mu_appIso_collapse`/`isIso_oplaxδ_of_conj` (re-ported iter-093) compiled as-is.

## S2 `tensorObj_restrict_iso_restrict_compat` (`TensorObjInverse.lean`) — DONE iter-096, axiom-clean
Filled IN PLACE (6.4M-HB, consumes B1). Verbatim v4.30 (`117100c4`) body + **4 v4.31 fixes (one recurring axis):**
the `(pullback U.ι ⋙ pullback j).obj X` vs nested `(pullback j).obj ((pullback U.ι).obj X)` spelling is
defeq-not-syntactic under `instances` transparency → poisons `rw` motives / `congr` / simp-matching. Fixes:
(1) `refine Eq.trans (pullbackTensorMap_restrict_cancel_assoc … _) ?_` to cross by unification (the verbatim
`rw [..._assoc]` is DEAD); (2) explicit `rw [Category.assoc]` before `congr 1` (`@[reassoc]` left-bracketed
head; `simp only [Category.assoc]` won't flatten → spurious HEq); (3) `set_option
backward.isDefEq.respectTransparency false in` (the durable knob — without it `simp [tensorObjIsoOfIso_hom]`
is permanently "no progress"); (4) deleted a now-redundant trailing `rfl`. `lake build …TensorObjInverse`
EXIT 0 (8565 jobs), `[propext, Classical.choice, Quot.sound]` (no `sorryAx`). **OOM caution RETIRED** — the
filled 6.4M-HB proof built in the monster-importing file without Exit 137 (Lean frees memory between decls;
monster is a warm upstream olean). **All v4.31 recovery targets (B1/K1/S2) now closed.** TensorObjInverse =
4 remaining = the genuine-open dual-unit FLANK + terminal (gated on the ∞-source informal proof).

## Dual cone (b)/(d) + keystone (a) — DONE iters 099–102, axiom-clean (`TensorObjInverse.lean`)
- **(b) `dualUnitIso_dualIsoOfIso` + (d) `exists_tensorObj_inverse` body — iter-099** (4→2). Root block was
  NOT difficulty: the v4.31 recovery had SILENTLY DROPPED 3 DualInverse helpers (`presheafDualUnitIso_naturality`,
  `homOfLocalCompat_restrictFunctor_map`, private `linearEndo_apply_comm`) → re-ported as private locals +
  v4.31 term-mode `eqToHom_comp_iff` fix → v4.30 bodies closed.
- **keystone (a) `dual_unit_iso_restrict_assemble` — ASSEMBLED iter-100** (monolithic sorry → machine-checked
  abstract-`[Category]` `unit_assemble`/`hcore_assemble`, body sorry-free), reduced to RES1+RES2.
- **RES1 `forgetUnitRestrict_eq_pushforwardUnit` — iter-101**, axiom-clean. Breakthrough: collapse at the
  MORPHISM level FIRST (generic `leftAdjointUniq_hom_app_homEquiv_symm`), then section. Durable v4.31 idioms:
  term-mode `congrArg (F.map g ≫ ·) (leftAdjointUniq_hom_app_counit …)`; term-mode `(forget _).map_comp`; `erw`
  for the Scheme.Modules↔SheafOfModules adjunction-spelling seam; `Subsingleton.elim` on `Opens` poset homs.
- **RES2 `pullbackUnit_sheafify_reconcile` + keystone (a) sorry-free — iter-102.** effort-broke RES2 into L1
  `pullbackValIso_unit_factor` (concrete rfl) + L2 `presheafPullbackUnitIso_sheafify_reconcile`. L2 closed FULLY
  via a transpose-free (†)-factorisation reusing `H1inv_app_eq_pullbackVal_restrict` + RES1, capped by generic
  `adj_unit_counit_collapse`. All axiom-clean, `lake build` EXIT 0. TensorObjInverse now = **1 sorry**:
  (c) `trivialisation_restrict_compat` (gated until (a); now active). `adj_unit_counit_collapse` +
  the 3 iter-103 seam lemmas need blueprint entries (coverage debt, cleanup phase).
