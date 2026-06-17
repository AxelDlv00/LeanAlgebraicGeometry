# Index of resolved targets
<!-- One line per closed target. Plan agent migrates entries here from task_pending.md when the prover-report-plus-verification confirms the closure. -->

- **iter-264 axiom-clean sub-bricks (3 lanes; no FULL decl/file sorry eliminated — 4th net-zero on the Picard critical path).** (1) **`AlgebraicGeometry.pushPullMap_id`** (ENGINE, `Cohomology/CechHigherDirectImage.lean`) — the identity functor law of the push–pull functor `G`, axiom-clean `{propext,Classical.choice,Quot.sound}` (aud264 + lean_verify first-hand). Mate calculus: `conjugateEquiv_pullbackId_hom` + `pseudofunctor_right_unitality` + sectionwise `hpf` (`hom_ext;intro U;rfl`) + `erw`/`reassoc_of%`. Engine stays DE-COUPLED from D3′ (Mathlib pseudofunctor coherences only). (2) **`AlgebraicGeometry.Scheme.Modules.leftAdjointUniqUnitEta_app`** (D3′, `Picard/TensorObjSubstrate.lean`) — the P-general recovery brick (step-1 of the Sq1 tail), axiom-clean; P-general twin of `leftAdjointUniqUnitEta`. (3) **`sliceDualTransport.map_smul'` field** (DUAL, `Picard/TensorObjSubstrate/DualInverse.lean`) — CLOSED axiom-clean (internal holes 5→4); projection-tolerant `conv_rhs => arg 2; change` + `congrArg d.hom |>.trans (.map_smul)` + `Scheme.Hom.appIso_inv_naturality`. Blueprint pin `lem:leftadjointuniq_app_unit_eta_general` added iter-265 (bw-tos265).

- **`AlgebraicGeometry.Scheme.Modules.{pushforwardComp_lax_μ, pullbackComp_δ}` (D3′ Sq2b, `Picard/TensorObjSubstrate.lean`) — CLOSED iter-260, axiom-clean `{propext,Classical.choice,Quot.sound}` (prover lean_verify + iter-260 review verified first-hand, no `sorryAx`; lean-auditor confirmed no laundering).** The D3′ Sq2b monoidality obligation, fully discharged. `pushforwardComp_lax_μ` ("pushforwardComp is monoidal") was NOT the predicted ~150-LOC `extendScalarsComp` change-of-rings build (that estimate AND the older "rfl/short-ext" prediction both refuted): the proof is a **short sectionwise pure-tensor collapse** on two `rfl`-foundations — `pushforward_μ_eq` (the pushforward μ reduces *definitionally* to the lighter `restrictScalars` μ on strongly-monoidal `pushforward₀` objects) + `restrictScalars_μ_app`, after which `ModuleCat.restrictScalars_μ_tmul` kills every pure tensor `m⊗ₜn`. Its consumer `pullbackComp_δ` (the ~90-line Sq2b mate calculus, proven iter-259) is now axiom-clean too. KEY engineering: the whnf-wall (direct `rw`/`erw`/`simp` of `restrictScalars_μ_tmul` explodes >200k heartbeats even at 2M) → solved by atom-helpers instantiated with the heavy objects as EXPLICIT args + `erw [have]`, pinning `forget₂`-association implicits `(R:=S₀)(S:=F.op⋙R₀)`. 6 private axiom-clean helpers added. **⇒ A.1.c.sub Sq2/Sq2b complete; remaining D3′-outer `pullbackTensorMap_restrict` = Sq1/Sq4 composition-coherence only.** Blueprint pins (Sq2b prose corrected iter-261 bw-tos261).

- **`Scheme.Modules.{restrictOverIso, unitOverIso}` (SHARED ROOT, `Picard/SheafOverEquivalence.lean`) — CLOSED iter-259, axiom-clean `{propext,Classical.choice,Quot.sound}` (prover lean_verify + soe259 lvb adequate, no must-fix).** The 2 remaining shared-root isos. `restrictOverIso` = verbatim mirror of `restrictFunctorAdjCounitIso`: `M.restrict U.ι = pushforward (psiRestrict U)` (reconstructed rfl-equal), 3-step composite `pushforwardComp (phiOver U)(psiRestrict U) ≫ pushforwardNatIso (overForgetNatIso U) ≫ pushforwardCongr (γ'=𝟙)`; the only content (`γ'=𝟙`) sectionwise via `ext V x; simp[…]` + `erw[ConcreteCategory.id_apply,←comp_apply,←Functor.map_comp];simp`. `unitOverIso` = the 1 leaf: `IsIso (phiOver U).hom` app-wise (`rw[NatTrans.isIso_iff_isIso_app]; …inferInstanceAs(IsIso(ringCatSheaf.obj.map(eqToHom …).op))`), then `change IsIso ((forget₂ RingCat AddCommGrpCat).map ((phiOver U).hom.app W)); infer_instance`. ⇒ **`SheafOverEquivalence.lean` FULLY sorry-free + axiom-clean.** 3 new private helpers (`psiRestrict`, `restrictFunctor_eq_pushforward_psiRestrict`, `overForgetNatIso`). RECIPES: continuity discrim-tree wall → `set_option backward.isDefEq.respectTransparency false in` on the def + `@Functor.isContinuous_comp …hF1 hF2`; `pushforwardComp φ ?ψ` metavar → whnf TIMEOUT (supply `psiRestrict` explicitly); `IsIso (phiOver U).hom` NOT `inferInstance`-able (derive app-wise). Blueprint pins `lem:sheafofmodules_restrict_over_iso` / `lem:sheafofmodules_unit_over_iso` / `lem:chart_over_iso`. Supersedes the 2 remaining-sorry entries of `overEquivalence`.

- **`Scheme.LineBundle.IsLocallyTrivial.{isFinitePresentation, isFiniteType, chartPresentation}` (A.2.c ENGINE, `Picard/LineBundleCoherence.lean`) — NOW FULLY axiom-clean iter-259 (verified first-hand `lean_verify` `IsLocallyTrivial.isFinitePresentation` = `{propext,Classical.choice,Quot.sound}`, NO `sorryAx`).** With the shared root closed, `Scheme.Modules.chartOverIso` is axiom-clean, so the engine `LineBundle.chartOverIso` redirect (iter-258) and its 3 downstream consumers drop their transitive `sorryAx` with ZERO edits to the file. **The A.2.c-engine loc-triv coherence deliverable `IsLocallyTrivial⟹IsFinitePresentation` (`analogies/engine252.md`, Stacks Quot-embedding) is COMPLETE.** lbc259 lvb: 5/5 pinned decls faithful, no must-fix. File locally sorry-free.

- **`AlgebraicGeometry.Scheme.Modules.overEquivalence` (SHARED ROOT, `Picard/SheafOverEquivalence.lean`) — CLOSED iter-258, axiom-clean `{propext,Classical.choice,Quot.sound}` (lean_verify first-hand; soe258 lvb + aud258 confirm).** The modules-level lift of `Opens.overEquivalence U : Over U ≌ Opens ↥U` — the construction BOTH the engine (`chartOverIso`) and the dual chain (`sliceDualTransport`) reduced to in iter-257. Built as `SheafOfModules.pushforwardPushforwardEquivalence (Opens.overEquivalence U) (phiOver U) (psiOver U) H₁ H₂` per `analogies/overeq258.md` — the ana258-overeq recipe held exactly. Genuine content: the open-immersion ring-sheaf morphism `φ` (=`phiOver`, sectionwise `eqToHom (image_overEquiv_functor_obj …).op` on the defeq structure sheaves), inverse `ψ`, coherences `H₁`/`H₂`, + 3 continuity instances + 2 image-equality lemmas. **3 REUSABLE recipes cracked:** (1) the `↥↑U`(scheme-carrier)-vs-`↥U`(subtype) discrimination-tree mismatch → state continuity instances on scheme-carrier form + `change …↥U…; infer_instance` defeq-convert; (2) `Functor.map_comp` WON'T `rw`-combine on the `forget₂`-composite `X.ringCatSheaf.obj.map` → erw (X-leg first) OR peel-forget₂ + a `(map_comp).symm.trans((congrArg _ Subsingleton.elim).trans map_comp)` TERM; (3) ALWAYS `.obj.map`, never `.val.map`. File sorry 4→2 (open: `restrictOverIso` full body, `unitOverIso` 1 leaf — both mechanical in-file finishes, NOT Mathlib gaps). Blueprint pin `def:sheafofmodules_over_equivalence`. **Closes the engine `chartOverIso` + dual `sliceDualTransport` as one-liner consumers once the 2 remaining isos land.**

- **`Picard/LineBundleCoherence.lean` engine — `chartOverIso` REDIRECTED to the shared root, file now LOCALLY sorry-free (iter-258).** The local `chartOverIso` sorry-def is now `Scheme.Modules.chartOverIso U M e` (import of `SheafOverEquivalence` added; no cycle). The 5 pinned engine decls (`exists_trivializing_cover`/`chartPresentation`/`isFinitePresentation`/`isFiniteType`/`chart_free_rank_one`) become FULLY axiom-clean with NO further edits to this file the moment the shared root's 2 remaining isos close. iter-258 net: 1→0 local sorry. lbc258 lvb: 5/5 pinned decls faithful, no must-fix.

- **`IsLocallyTrivial.{exists_trivializing_cover, chart_free_rank_one}` + reusable bricks `freeUnitIso`/`unitGenerators`/`unitPresentation` (+ `IsFinite` instance) (`Picard/LineBundleCoherence.lean`) — CLOSED iter-257, axiom-clean `{propext,Classical.choice,Quot.sound}`.** The engine lane crashed **5 sorry → 1**: four bodies closed (`exists_trivializing_cover` via `I:=X`/`hM x`-choice cover; `chart_free_rank_one` = `exact hM x`; the §1b unit-presentation bricks general over any `R : Sheaf J RingCat`). `chartPresentation`/`isFinitePresentation`/`isFiniteType` are CLOSED **modulo the single iso `chartOverIso`** (`#print axioms` = `sorryAx` only via it): the universe-correct `QuasicoherentData` assembly (`q.shrink` + `apply …mk` + `inferInstanceAs …IsFinite`) is all real. The planner's `Presentation.ofIsIso e.hom` recipe was TYPE-INCORRECT (slice-site `M.over U` vs open-subscheme `M.restrict U.ι` are different categories); prover rebuilt the chart presentation through an explicit bridge so the whole engine factors through ONE iso. Blueprint `Picard_LineBundleCoherence.tex`. **Sole remaining sorry `chartOverIso` = the SHARED ROOT `SheafOfModules.overEquivalence` (iter-258 primary lane); engine is 1 one-liner from done once it lands.**

- **`AlgebraicGeometry.Scheme.Modules.homOfLocalCompat` (A-bridge, `Picard/TensorObjSubstrate/DualInverse.lean`) — CLOSED iter-256, axiom-clean `{propext,Classical.choice,Quot.sound}` (lean_verify + aud256 first-hand).** Broke the **5-iter CHURNING streak** (file-sorry stuck 2→2 ×5). Closed INLINE per the pc256 corrective (no new top-level helper; local `have`s only): the inner f-leg native↔`restrictScalars 𝟙` smul bridge via `erw [ModuleCat.restrictScalars.smul_def']` + full `simp [Scheme.Opens.ι_appIso]` (collapses `β=(forget₂…).map(ι.appIso).inv` to `𝟙`) + `rfl`; M/N legs via `Scheme.Modules.map_smul`; scalar reconcile via a thinness `ConcreteCategory.congr_hom (congrArg X.presheaf.map (Subsingleton.elim _ (𝟙 …))) _` TERM (`rw [Subsingleton.elim]` FAILS metavar). The `-- TO CLOSE (next iter)` excuse-comment removed. Recipe in `[[ts256-homoflocalcompat-closed]]`. File sorry 2→1 (remaining: `dual_restrict_iso` Step-4). **This is the first DualInverse frontier close in 5 iters; unblocks the A-leg of `exists_tensorObj_inverse`.** Blueprint pin `lem:sheafofmodules_hom_of_local_compat` (dualinverse256 = chapter CLEAN, no must-fix).
- **`Picard/LineBundleCoherence.lean` file-skeleton (engine, A.2.c entry) — SCAFFOLD LANDED iter-256.** NEW file, 5 sorry-stub decls (`IsLocallyTrivial.{exists_trivializing_cover, chartPresentation, isFinitePresentation, isFiniteType, chart_free_rank_one}`) matching chapter `\lean{}` pins; compiles. **Site-instance de-risk RESOLVED POSITIVELY** — all four slice-site instances (`HasSheafCompose`, `HasWeakSheafify`, `WEqualsLocallyBijective`, `HasSheafify` on `J.over U`) resolve automatically; engine can proceed to a full prover lane. Import added to `AlgebraicJacobian.lean` (iter-257 refactor `add-lbc-import`; root build green, 8318 jobs exit 0). Blueprint `Picard_LineBundleCoherence.tex`.

- **`AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural` (D1′, `Picard/TensorObjSubstrate.lean`) — CLOSED iter-255, axiom-clean `{propext,Classical.choice,Quot.sound}` (lean_verify first-hand; lvb-tscmp255 = chapter CLEAN).** The TS-cmp canonical target across iters 251–254; **broke the 4-iter no-close M=2 streak** (first canonical substrate close since D2′ at iter-250). Square 2 closed by the mapin255 LIGHT `erw [← Functor.OplaxMonoidal.δ_natural (F := pullback (show …⋙forget₂… from …))]` proof-side `show…from` `F`-ascription — fired in the real file exactly as the analogist's `lean_multi_attempt` probe predicted, **disproving** the iter-254 "no instance-injection point" claim and the expected structural spelling-pin refactor (NO refactor needed; D2′ untouched). Squares 3+4 (the genuinely-new work) assembled across the `pullbackValIso` `.val`/`.obj` connecting-object boundary via a new reusable recipe: `erw [Category.assoc]`+`erw [Iso.cancel_iso_hom_left]` to bridge the gap; `refine ((Functor.map_comp _ _ _).symm.trans ?_).trans (Functor.map_comp _ _ _)` for the two-sided `a_Y.map` merge (refine's isDefEq beats erw keying); per-leg `pullbackValIso` naturality + `tensorHom_comp_tensorHom (C := …)` TERM. `set_option maxHeartbeats 3200000` (aud255 major: fragile, 5 defeq-boundary workarounds — polish-pass candidate). File proof-body sorry 2→1 (remaining: `exists_tensorObj_inverse` L712, cross-file gated). Blueprint pin `lem:pullback_tensor_map_natural`. **Next (iter-256): D3′ `pullbackTensorMap_restrict` (mirror `pullbackObjUnitToUnit_comp`).**
- **iter-255 (Lane TS-inv, `Picard/TensorObjSubstrate/DualInverse.lean`) — `homOfLocalCompat` sub-step (c) M-leg CLOSED (PARTIAL; not fully closed).** KEY mis-decomposition FIX: the iter-255 prover's first attempt (planner's literal `PresheafOfModules.map_smul` recipe) FAILED — it bakes a `restrictScalars e₁` over a *different base ring*, not defeq even under `respectTransparency false`. Attempt 2 switched the M/N legs to the Γ-level **`Scheme.Modules.map_smul`** (native action, no restrictScalars) and closed the M-leg, narrowing the residual to ONE native↔`restrictScalars 𝟙` (identity ring map, same base ring) f-leg smul reconciliation — the cleanest possible mismatch; all bridge ingredients (`ModuleCat.restrictScalars.smul_def`/`restrictScalarsId'App`, `(U i).ι.appIso = Iso.refl`) named + verified. File sorry 2→2 (homOfLocalCompat sorry advanced, not closed). pc256: Route 2 CHURNING; iter-256 = inline close, no new helper. `dual_restrict_iso` Step-4 correctly NOT entered (reversing-signal guardrail).

- **iter-253 (Lane TS-inv, `Picard/TensorObjSubstrate/DualInverse.lean`) — `homOfLocalCompat` sub-step (b) CLOSED + 2 axiom-clean helpers** `topSectionToHom` / `topSectionToHom_app` (terminal-`⊤` `presheafHom`-section → global morphism, via `presheafHomSectionsEquiv`). The remaining `homOfLocalCompat` sorries (a)/(c) were BLOCKED on an `hf : HEq` signature wrongly believed PROTECTED — iter-254 unblocks by re-signing `hf` sectionwise (`homOfLocalCompat` absent from `archon-protected.yaml`, no compiling caller). File sorry 2→2.
- **iter-253 (Lane TS-cmp, `Picard/TensorObjSubstrate.lean`) — D1′ STEP-B Square-1 CLOSED (partial)**: `pullbackTensorMap_natural` advanced from `simp;sorry` to a compiling Square-1 (`sheafificationCompPullback` naturality) + setup; blocked on the Square-2 `Sheaf.val`/`.obj` merge. STEP-A (`sheafifyTensorUnitIso_hom_natural`) reversing signal fired NEGATIVE (3 disproven approaches) → iter-254 corrective = tscmp254 δ/μ-naturality reformulation + canonical-spelling pin (which also dissolves this Square-2 merge). File sorry 3→3.

- **iter-251 (Lane TS-inv, `Picard/TensorObjSubstrate/DualInverse.lean`) — 4 NEW CLOSED axiom-clean decls + `dual_isLocallyTrivial` assembled.** `unitDualSectionEquiv` / `dualUnitIsoGen` / `presheafDualUnitIso` / `dual_unit_iso` — the eval-at-1 presheaf-dual-of-unit iso (`ℋom(𝟙,𝟙)≅𝟙`, every unit-endomorphism = mult by its value at `1`; non-trivial `left_inv` + `internalHomEval`-style naturality, scratch-verified axiom-clean). `dual_isLocallyTrivial` (`lem:dual_isLocallyTrivial`) ASSEMBLED as the 3-step chain `dual_restrict_iso ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` — compiles but TRANSITIVELY PARTIAL (carries `dual_restrict_iso`'s Step-4 sorry; lean-auditor aud251 must-fix relabel queued iter-252). Blueprint pin added iter-252: `lem:dual_unit_iso`. File sorry 3→2. Still open: `dual_restrict_iso` Step-4 (armed `analogies/dual252.md`: needs leg A slice-site transport + leg B), `homOfLocalCompat` (not started).
- **iter-251 (Lane TS-cmp, `Picard/TensorObjSubstrate.lean`) — 2 NEW CLOSED axiom-clean lemmas for D1′.** `pullbackValIso_hom_natural` (D1′ square 4, naturality of `pullbackValIso`; axiom-clean, reusable `erw` idiom kit for the `pullback φ`-vs-`pullback f` carrier friction) + `sheafifyTensorUnitIso_hom_eq` (`private`, `:= rfl`; strips the `letI instMS` cast — carrier-normalisation bridge). D1′ `pullbackTensorMap_natural` (`lem:pullback_tensor_map_natural`) AUTHORED + PARTIAL, reduced to ONE residual in helper `sheafifyTensorUnitIso_hom_natural` (sorry). File sorry 1→3 (honest typed). Blocker root-caused iter-252 by `analogies/whisker252.md`: an INSTANCE-TERM split, fixed by `letI instMS` `inferInstanceAs` transport + `erw` join-bridge (the iter-251 "author a 2nd whisker brick" diagnosis was LIVE-disproven; `tensorHom`-fold verified dead). Still open: close the helper → D1′ → D3′/D4′.

- **`AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso` (D2') + `pullbackEtaUnitSquare` + feeders `epsilonPresheafToSheafUnit`, `pullbackSheafifyUnitEtaTriangle`, `restrictScalarsId_map` (AlgebraicJacobian/Picard/TensorObjSubstrate.lean) — CLOSED iter-250, axiom-clean `{propext,Classical.choice,Quot.sound}` (verified no `sorryAx`, review + lean-auditor ts250).** The FIRST canonical critical-path sorry-elimination of the Picard pullback–tensor route: the (∗∗) presheaf residual inside `pullbackEtaUnitSquare` eliminated ⇒ `pullbackTensorMap_unit_isIso` (`lem:pullback_tensor_iso_unit`) closes automatically. The 245–249 "reduce-don't-close" obstacle was TACTICAL (`rw [Category.assoc]`/`rw [h]` silent-match failure on `.val` composites whose implicit ring arg is `X.ringCatSheaf.val` vs `X.presheaf ⋙ forget₂ …`, defeq-not-syntactic); defeated by the propositional `restrictScalarsId_map := rfl` strip + load-bearing `erw` keyed-defeq merge (NOT the analogist's `show`-into-syntactic-category idiom, which blew >6.4M heartbeats — recorded as a dead-end). `epsilonPresheafToSheafUnit` carries `set_option backward.isDefEq.respectTransparency false` (lean-auditor ts250 MAJOR: fragile-but-sound; revisit in a polish pass). File sorry 2→1 (only L705 `exists_tensorObj_inverse`). Blueprint pins: `lem:eta_bridge_unit_square`, `lem:pullback_tensor_iso_unit`, `lem:epsilon_presheaf_to_sheaf_unit`. **Next: D1'/D3'/D4' (none yet in Lean) → `IsInvertible.pullback`.**
- `AlgebraicGeometry.Scheme.Modules.compHomEquivFactor` + `leftAdjointUniqUnitEta` + `sheafificationCompPullback_eq_leftAdjointUniq` (AlgebraicJacobian/Picard/TensorObjSubstrate.lean) — landed iter-248, axiom-clean `{propext,Classical.choice,Quot.sound}` (verified): **the D2' η-bridge mate-calculus, fully discharged.** The fine-grained corrective on the atomized telescope closed 2/3 ★ step-lemmas — `compHomEquivFactor` (composite-adjunction homEquiv factorisation; `Adjunction.comp_homEquiv` does NOT exist in Mathlib — derived from `homEquiv_unit` + `comp_unit_app`) and `leftAdjointUniqUnitEta` — PLUS the `rfl` LINCHPIN `sheafificationCompPullback_eq_leftAdjointUniq`, which retires the prover's 5-iter "3-layer adjunction defeq wall" hypothesis (it holds DEFINITIONALLY). The whole D2' obligation `IsIso (pullbackTensorMap f 𝒪 𝒪)` now bottoms out in ONE concrete (∗∗) residual inside `pullbackEtaUnitSquare` (L1672). Blueprint pins: `lem:comp_homequiv_factor_sheafify_pullback`, `lem:leftadjointuniq_app_unit_eta`, `lem:sheafification_comp_pullback_eq_leftadjointuniq` (added iter-249). **NOT yet closed: `pullbackEtaUnitSquare` + D2' closer `pullbackTensorMap_unit_isIso`** — both carry the (∗∗) sorry transitively (iter-249 prove-pass target). progress-critic ts249 = STUCK by strict rules (canonical counter flat 10 iters) but endorsed the close-L1672 corrective.
- **RPF doc-hygiene (iter-248, Lane RPF, `Picard/RelPicFunctor.lean`)** — 7 stale/false docstrings fixed (the 2 lean-auditor iter247 must-fix: false "file-local addCommGroup sorry gated on Scheme.Modules monoidal upgrade" header L32–34, and the excuse-comment "sorry-free placeholder" on the `PUnit` `PicSharp` body L477; + 5 adjacent). Now state the true state: `addCommGroup` has a real sorry-free body, the only reachable sorry is the upstream `exists_tensorObj_inverse`, and `PicSharp`/`functorial` are honest tracked stubs gated cross-file on Lane TS D4' (`pullback_tensor_iso_loctriv`). Local sorry 0→0; build green. lean-auditor aud248 re-audit: 0 must-fix / 0 major / 0 excuse-comments for this file. No proof obligations remained.
- **Import-cycle refactor (iter-247, slug rpf-cycle)** — broke the `TensorObjSubstrate ↔ RelPicFunctor` cycle: dependency now flows `LineBundlePullback → TensorObjSubstrate → RelPicFunctor`. `tensorObjOnProduct` moved into RelPicFunctor (sorry-free); dead `addCommGroup_via_tensorObj` stub deleted from TensorObjSubstrate (TS sorry 2→1); imports flipped + reordered in `AlgebraicJacobian.lean`. Both files build clean, 0 new sorries. Unblocks Lane RPF to cite the real upstream substrate (memory `rpf-import-cycle-blocks-tensorobj` → RESOLVED). The cycle was caused by exactly 2 *dead* decls — no Core.lean split needed.
- `AlgebraicGeometry.Scheme.Modules.isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` + `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` + `W_of_isIso_sheafification` + `sheafifyUnitIso` (AlgebraicJacobian/Picard/TensorObjSubstrate.lean) — landed iter-246, axiom-clean `{propext,Classical.choice,Quot.sound}`: **the D2' δ-WRAPPING + assembly.** `IsIso (pullbackTensorMap f 𝒪 𝒪)` now reduces UNCONDITIONALLY to ONE residual — the η-bridge `IsIso (a_Y.map (η (pullback φ')))` (via `left_unitality_hom` + the converse W-lemma + `W_whiskerRight_of_W`, flatness-free). The η-bridge was reduced to a precise concrete transposed pushforward-side mate identity with all `leftAdjointUniq_*_app` glue named; mathlib-analogist eta247 (iter-247) confirmed the API exists (PROCEED). Closing it is the iter-247 Lane TS objective. File sorry 2→2 (no new pins).
- `AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_of_isIso_sheafifyDelta` + helper `isIso_sheafify_tensorHom_pullbackValIso` (AlgebraicJacobian/Picard/TensorObjSubstrate.lean) — landed iter-245, axiom-clean `{propext,Classical.choice,Quot.sound}`: **the loc-triv-route reduction brick** — reduces iso-ness of the 4-fold `pullbackTensorMap` composite `f^*(M⊗N)⟶f^*M⊗f^*N` to iso-ness of the single sheafified presheaf comparison `a_Y.map (δ (pullback φ') M.val N.val)`. Structurally collapses every remaining loc-triv target (D2'/D3'/D4'/`IsInvertible.pullback`) to one goal shape. The `IsIso.comp_isIso'` chain handles factors 1,3,4 unconditionally; factor 2 (sheafified δ) is the hypothesis. NOT a disguised escape (lean-auditor ts245: genuine). **Next genuine content = D2' η-bridge** `IsIso (a_Y.map (η (pullback φ')))` (~60–120 LOC mate calculus, unit-side analog of the PROVEN `pullbackObjUnitToUnit_comp`). File sorry 2→2 (no new sorry).
- `AlgebraicGeometry.Scheme.Modules.pullbackUnitIso` + bricks (`isIso_pbu_of_final`, `pullbackObjUnitToUnitIso`, `pullbackObjUnitToUnitIso_hom`) (AlgebraicJacobian/Picard/TensorObjSubstrate.lean) — closed iter-241: **Route-Z Phase-1 PRIMARY `f^*𝒪_X ≅ 𝒪_Y`**, axiom-clean `{propext,Classical.choice,Quot.sound}`. **KEY FINDING: the blueprint chart-chase is UNNECESSARY** — `SheafOfModules.pullbackObjUnitToUnit f` is iso for EVERY `f` because `(Opens.map f.base)` is always `Final` (preimage-on-opens preserves finite limits ⇒ representably flat ⇒ `final_of_representablyFlat`). TC-accident fix = `@asIso _ _ _ _ (pbu g) (isIso_pbu_of_final g)` (explicit witness ⇒ defeq at DEFAULT transparency). Blueprint pin `lem:pullback_unit_iso`. Phase 2 `pullbackTensorIso` STILL a genuine Mathlib-absent build (no tensor-pullback comparison map, no `MonoidalCategory (SheafOfModules)`); Phase 3 gated on it.
- `AlgebraicGeometry.pushforward_spec_tilde_iso` (AlgebraicJacobian/Cohomology/FlatBaseChange.lean) — closed iter-241: **the affine pushforward-of-tilde iso `(Spec φ)_*M̃ ≅ (restr_φ M)~`**, axiom-clean. Breaks the 4-iter Lane-B `hsq`/carrier wall: refactor `gammaPushforwardIsoAt`'s middle `eqToIso`→`(restrictScalarsCongr hcomp).app SecN` (deletes the only non-`rfl` cast) ⇒ open-naturality square closes by `ext x; rfl`. File sorry 3→2. **Next:** `affineBaseChange_pushforward_iso` STILL needs the Mathlib-absent **pullback-of-tilde** dictionary `pullback (Spec φ)(M̃) ≅ (R'⊗_R M)~` + identifying `pushforwardBaseChangeMap.app U` with `cancelBaseChange` (separate ~hundreds-LOC engine sub-lane).

- `AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp` + `unitToPushforwardObjUnit_comp` (AlgebraicJacobian/Picard/TensorObjSubstrate.lean) — landed iter-240: **the Route-Z Phase-1 coherence linchpins for `lem:pullback_unit_iso`.** `pullbackObjUnitToUnit_comp` = the blueprint's named "genuinely-new ingredient" (`pbu(h≫f) = (pullbackComp h f).inv ≫ (pullback h).map(pbu f) ≫ pbu h`, ~87-line adjunction-mate transport across the pullback–pushforward adjunction; Mathlib-absent); `unitToPushforwardObjUnit_comp` = the pushforward-side dual (sectionwise `rfl`). Axiom-clean `{propext,Classical.choice,Quot.sound}` (verified iter-240 review). Blueprint pins added iter-241 (`lem:pullbackObjUnitToUnit_comp`, `lem:unitToPushforwardObjUnit_comp`). **The deliverable `pullbackUnitIso` is NOT yet closed** — blocked on a Lean TC-resolution accident (stale `haveI : IsIso (pbu …)` shadows the global `OfFinal` instance on `rw`-composites), NOT math; fix = bundled-`asIso`/`Iso`-level idiom (mirror Mathlib `pullbackObjFreeIso`/`μIso`), iter-241 lane. See `analogies/pbu-canon.md`.

- `AlgebraicGeometry.Scheme.Modules.picCommGroup` + deps (`PicGroup`, `picSetoid`, `picMul`, `picInv`, `IsInvertible.tensorObj`, `isInvertible_unit`, `IsInvertible.inverse_unique`, `tensorObj_assoc_iso_invertible`, `tensorObj_middleFour`) (AlgebraicJacobian/Picard/TensorObjSubstrate.lean) — closed iter-238: **the by-hand carrier-pivot Picard `CommGroup` on `IsInvertible` iso-classes** — the ~20-iter group-law bottleneck DELIVERABLE. Step-0 also dropped the vestigial `IsLocallyTrivial` hyps from `tensorObj_assoc_iso` (now unconditional `{M N P}`). All 7 objective steps; inverse = membership witness (free); no pentagon/coherence. Axiom-clean `{propext,Classical.choice,Quot.sound}` (verified first-hand, review iter-238). lean-vs-blueprint ts238: 7/7 faithful, no must-fix. **Next:** re-base the RPF/OnProduct consumer onto `IsInvertible` (Route Y) — gated on the substrate lemma `IsInvertible.pullback` (general pullback strong-monoidal, iter-239 lane).
- `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` (AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean) — closed iter-237: **the ~20-iter critical-path whiskering obligation** (`F ◁ toSheafify ∈ J.W`). Wired `stalkTensorIso`: d.1-bridge `isIso_stalkFunctor_map_of_W` (`J.W ⇒ stalkwise iso` on `Opens X`, via new presheaf-level `injective_stalk_of_isLocallyInjective`) + inlined B-naturality (`(F◁g)_x = id⊗g_x`) ⇒ `id⊗(iso)` iso (flatness-free). 6 axiom-clean decls. Downstream `AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso` now **sorry-free + axiom-clean + unconditional**. lean-auditor ts237 NON-VACUOUS; lean-vs-blueprint PASS. Unblocks the by-hand `picCommGroup` (iter-238 lane).
- `AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars` / `fromTildeΓ_app_isIso_of_isLocalizedModule` / `pushforward_spec_tilde_iso_of_isLocalizedModule` (AlgebraicJacobian/Cohomology/FlatBaseChange.lean) — closed iter-237: route-iii skeleton for the affine-pushforward brick (ring-change converse of `IsLocalizedModule.of_restrictScalars` + per-`D(a)` section engine + conditional assembly taking `hloc`). Axiom-clean. Reduces unconditional `pushforward_spec_tilde_iso` to ONE named `hloc` obligation (the `D(a)` smul carrier wall — STUCK iter-238; corrective = blueprint expansion, prover next iter).
- `PresheafOfModules.stalkTensorIso` (AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean) — closed iter-236: **the d.2 stalk–tensor commutation iso `(A⊗ᵖB)_x ≅ A_x⊗_{R_x}B_x`** — the ~19-iter Picard group-law bottleneck INGREDIENT. Axiom-clean `{propext,Classical.choice,Quot.sound}`. Built over 4 iters (233 forward map → 234 R_x-linear packaging → 235 reverse descent → 236 balancing+bundle). Unblocks the unconditional associator; consumer wiring `isLocallyInjective_whiskerLeft_of_W` is the iter-237 lane. lean-auditor ts236 NON-VACUOUS; lean-vs-blueprint ts236 PASS.
- `AlgebraicGeometry.gammaPushforwardIso` / `gammaPushforwardTildeIso` / `globalSectionsIso_hom_comp_specMap_appTop` (AlgebraicJacobian/Cohomology/FlatBaseChange.lean) — closed iter-236: the Γ-fragment pushforward iso `Γ((Spec φ)_*N) ≅ restrictScalars φ (ΓN)` + tilde specialisation + ring-square naturality; axiom-clean. The carrier wall (iter-234/235) RESOLVED via element-free `restrictScalarsComp'App`+`eqToIso`. Engine lane (A.2.c flat base change).
- `AlgebraicGeometry.GrpObj.eq_of_eqOnOpen` (AlgebraicJacobian/Rigidity.lean) — closed iter-002: open-cover equality; kernel-only.
- `AlgebraicGeometry.Scheme.LineBundle` (AlgebraicJacobian/Picard/LineBundle.lean) — closed iter-002: CommRing.Pic approx; kernel-only.
- `AlgebraicGeometry.Scheme.instCommGroupLineBundle` (AlgebraicJacobian/Picard/LineBundle.lean) — closed iter-002: instance synthesis; kernel-only.
- `AlgebraicGeometry.Scheme.Pic.pullback` (AlgebraicJacobian/Picard/LineBundle.lean) — closed iter-002: functoriality via CommRing.Pic.mapRingHom; kernel-only.
- `AlgebraicGeometry.Cohomology.instHasSheafCompose_forget_CommRing_AddCommGrp` (AlgebraicJacobian/Cohomology/SheafCompose.lean) — closed iter-003: sheaf composition via universe pinning; kernel-only.
- `AlgebraicGeometry.Scheme.PicardFunctor` (AlgebraicJacobian/Picard/Functor.lean) — closed iter-003: contravariant functor; kernel-only.
- `AlgebraicGeometry.Scheme.PicardFunctor.representable` — **NOT closed**, intentionally deferred: `sorry` at `Picard/Functor.lean` L185 forbidden on global-sections-approximate `LineBundle`; tracked in `task_pending.md`.
- `AlgebraicGeometry.Cohomology.instHasSheafify_Opens_AddCommGrp` (AlgebraicJacobian/Cohomology/StructureSheafAb.lean L34) — closed iter-004: universe-pinned instance; kernel-only.
- `AlgebraicGeometry.Cohomology.instHasExt_Sheaf_Opens_AddCommGrp` (AlgebraicJacobian/Cohomology/StructureSheafAb.lean L43) — closed iter-004: HasExt.standard; kernel-only.
- `AlgebraicGeometry.Scheme.toAbSheaf` (AlgebraicJacobian/Cohomology/StructureSheafAb.lean L56) — closed iter-004: sheaf via HasSheafCompose; kernel-only.
- `AlgebraicGeometry.Scheme.PicardFunctorAb` (AlgebraicJacobian/Picard/FunctorAb.lean L48) — closed iter-004: Additive wrapper; kernel-only.
- `AlgebraicGeometry.Cohomology.instHasSheafify_Opens_ModuleCatK` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L39) — closed iter-005: ModuleCat k instance; kernel-only.
- `AlgebraicGeometry.Cohomology.instHasExt_Sheaf_Opens_ModuleCatK` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L49) — closed iter-005: HasExt.standard; kernel-only.
- `AlgebraicGeometry.Scheme.PicardFunctorAb.forgetCompare` (AlgebraicJacobian/Picard/FunctorAb.lean L73) — closed iter-005: natural iso; kernel-only.
- `AlgebraicGeometry.Scheme.toModuleKSheaf.kToSection` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L72) — closed iter-006: ring map structure; kernel-only.
- `AlgebraicGeometry.Scheme.toModuleKSheaf.algebraSection` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L80) — closed iter-006: RingHom.toAlgebra; kernel-only.
- `AlgebraicGeometry.Scheme.toModuleKSheaf.algebraMap_eq_kToSection` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L86) — closed iter-006: definitional; kernel-only.
- `AlgebraicGeometry.Scheme.toModuleKSheaf.kToSection_naturality` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L93) — closed iter-006: simp lemma; kernel-only.
- `AlgebraicGeometry.Scheme.toModuleKSheaf.algebraMap_naturality` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L101) — closed iter-006: naturality; kernel-only.
- `AlgebraicGeometry.Scheme.toModuleKPresheaf` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L117) — closed iter-006: presheaf functor; kernel-only.
- `AlgebraicGeometry.Scheme.toModuleKPresheaf_isSheaf` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L142) — closed iter-006: sheaf via forgetfulness; kernel-only.
- `AlgebraicGeometry.Scheme.toModuleKSheaf` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L152) — closed iter-006: Phase A complete; kernel-only.
- `AlgebraicGeometry.Scheme.toModuleKPresheaf_obj` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L143) — closed iter-007: simp lemma; kernel-only.
- `AlgebraicGeometry.Scheme.toModuleKSheaf_forgetCompare` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L170) — closed iter-007: forgetfulness; kernel-only.
- `AlgebraicGeometry.Scheme.PicardFunctorAb_forget_obj` (AlgebraicJacobian/Picard/FunctorAb.lean L83) — closed iter-007: simp lemma; kernel-only.
- `AlgebraicGeometry.Scheme.PicardFunctorAb.etaleSheafified` (AlgebraicJacobian/Picard/FunctorAb.lean L109) — closed iter-008: universe bridge; kernel-only.
- `AlgebraicGeometry.Scheme.HModule` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L185) — closed iter-009: Abelian.Ext abbreviation; kernel-only.
- `AlgebraicGeometry.Scheme.HModule_zero_linearEquiv` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L203) — closed iter-010: Abelian.Ext.linearEquiv₀; kernel-only.
- `AlgebraicGeometry.genus` (AlgebraicJacobian/Genus.lean L65) — closed iter-011: finrank computation; kernel-only.
- `AlgebraicGeometry.Scheme.cechCochain_OC` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L228) — closed iter-012: Čech complex; kernel-only.
- `AlgebraicGeometry.Scheme.cechCohomology_OC` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L241) — closed iter-012: Čech cohomology; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L232) — closed iter-014: free presheaf Abelian.Ext; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_zero_linearEquiv` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L253) — closed iter-015: HModule' Ext equiv; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_cohomologyPresheafFunctor` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L278) — closed iter-016: contravariant functor; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_cohomologyPresheaf` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L297) — closed iter-016: functor eval; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_toBiprod` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L321) — closed iter-017: biproduct lift; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_fromBiprod` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L345) — closed iter-017: biproduct desc; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_toBiprod_fromBiprod` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L380) — closed iter-018: simp via biproduct; kernel-only.
- `AlgebraicGeometry.Scheme.ModuleCat_free_isLeftAdjoint` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L400) — closed iter-019: Mathlib gap-fill; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_isPushoutModuleCatFreeSheaf` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L420) — closed iter-019: pushout; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_shortComplex` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L453) — closed iter-019: short complex; kernel-only.
- `AlgebraicGeometry.Scheme.ModuleCat_free_preservesMonomorphisms` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L491) — closed iter-020: Mathlib gap-fill; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_shortComplex_f_mono` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L505) — closed iter-020: monomorphism; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_shortComplex_g_epi` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L523) — closed iter-020: epimorphism; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_shortComplex_exact` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L538) — closed iter-020: exactness; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_shortComplex_shortExact` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L556) — closed iter-020: short exact; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_δ` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L590) — closed iter-021: connecting morphism; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_sequence` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L615) — closed iter-022: 5-term sequence; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_toBiprod_apply` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L629) — closed iter-025: biproduct application; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_fromBiprod_biprodIsoProd_inv_apply` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L652) — closed iter-025: concrete iso; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_biprodAddEquiv_symm_biprodIsoProd_hom_toBiprod_apply` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L675) — closed iter-025: Ext equiv; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_mk₀_f_comp_biprodAddEquiv_symm_biprodIsoProd_hom` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L691) — closed iter-025: surjectivity; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_sequenceIso` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L716) — closed iter-025: 5-term iso; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_sequence_exact` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L742) — closed iter-026: exactness via iso; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_δ_toBiprod` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L755) — closed iter-026: simp lemma; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_fromBiprod_δ` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L767) — closed iter-026: MV-LES complete; kernel-only.
- **Structural milestone — iter-027 file split:** LES infrastructure moved to MayerVietoris.lean; kernel-only.
- `AlgebraicGeometry.Scheme.AffineCoverMVSquare` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L572) — closed iter-028: structure; kernel-only.
- `AlgebraicGeometry.Scheme.AffineCoverMVSquare.toMayerVietorisSquare` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L593) — closed iter-028: conversion; kernel-only.
- `AlgebraicGeometry.Scheme.AffineCoverMVSquare.toMayerVietorisSquare_toSquare_X₁/_X₂/_X₃/_X₄` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L601/607/613/621) — closed iter-029: corner simp lemmas; kernel-only.
- `AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_sequence` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L633) — closed iter-029: sequence; kernel-only.
- `AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_sequence_exact` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L643) — closed iter-029: exactness; kernel-only.
- `AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_sequence_curve` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L657) — closed iter-030: curve; kernel-only.
- `AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_sequence_curve_exact` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L668) — closed iter-030: curve exactness; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_top_sourceIso` (AlgebraicJacobian/Cohomology/MayerVietoris.lean) — closed iter-031: terminal collapse; kernel-only.
- `AlgebraicGeometry.Scheme.HModule_top_linearEquiv` (AlgebraicJacobian/Cohomology/MayerVietoris.lean) — closed iter-032: linear equiv; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_top_linearEquiv` (AlgebraicJacobian/Cohomology/MayerVietoris.lean) — closed iter-033: linear equiv; kernel-only.
- `CategoryTheory.Abelian.Ext.chgUnivLinearEquiv` (AlgebraicJacobian/Cohomology/MayerVietoris.lean) — closed iter-034: Mathlib gap-fill universe change; kernel-only.
- `AlgebraicGeometry.Scheme.HModule'_eq_HModule_linearEquiv` (AlgebraicJacobian/Cohomology/MayerVietoris.lean) — closed iter-034: universe bridge; kernel-only.
- `AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_X₄_linearEquiv` (AlgebraicJacobian/Cohomology/MayerVietoris.lean) — closed iter-035: terminal spec; kernel-only.
- `AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_X₄_linearEquiv_curve` (AlgebraicJacobian/Cohomology/MayerVietoris.lean) — closed iter-035: curve; kernel-only.
- `AlgebraicGeometry.Scheme.AffineCoverMVSquare.finrank_HModule_eq_HModule'_X₄` (AlgebraicJacobian/Cohomology/MayerVietoris.lean) — closed iter-036: finrank; kernel-only.
- `AlgebraicGeometry.Scheme.AffineCoverMVSquare.finrank_HModule_eq_HModule'_X₄_curve` (AlgebraicJacobian/Cohomology/MayerVietoris.lean) — closed iter-036: curve finrank; kernel-only.
- `AlgebraicGeometry.Scheme.AffineCoverMVSquare.module_finite_HModule_of_HModule'_X₄` (AlgebraicJacobian/Cohomology/MayerVietoris.lean) — closed iter-037: finiteness; kernel-only.
- `AlgebraicGeometry.Scheme.AffineCoverMVSquare.module_finite_HModule_of_HModule'_X₄_curve` (AlgebraicJacobian/Cohomology/MayerVietoris.lean) — closed iter-037: curve finiteness; kernel-only.
- `AlgebraicGeometry.Scheme.module_finite_HModule_zero` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean) — closed iter-038: HModule finiteness; kernel-only.
- `AlgebraicGeometry.Scheme.module_finite_HModule'_zero` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean) — closed iter-038: HModule' finiteness; kernel-only.
- `AlgebraicGeometry.Scheme.module_finite_HModule_zero_curve` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean) — closed iter-039: curve; kernel-only.
- `AlgebraicGeometry.Scheme.module_finite_HModule'_zero_curve` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean) — closed iter-039: curve; kernel-only.
- `AlgebraicGeometry.Scheme.IsAffineHModuleVanishing` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean) — closed iter-040: Serre vanishing class; Mathlib gap-fill; kernel-only.
- `AlgebraicGeometry.Scheme.module_finite_HModule'_of_isAffineHModuleVanishing` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean) — closed iter-040: vanishing application; kernel-only.
- `AlgebraicGeometry.Scheme.IsAffineHModuleHomFinite` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L481) — closed iter-041: H⁰ Hom-finiteness; kernel-only.
- `AlgebraicGeometry.Scheme.module_finite_HModule'_zero_of_isAffineHModuleHomFinite` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean) — closed iter-041: H⁰ finiteness; kernel-only.
- `AlgebraicGeometry.Scheme.module_finite_HModule'_of_affine` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean) — closed iter-042: case analysis; kernel-only.
- `AlgebraicGeometry.Scheme.module_finite_HModule'_of_affine_curve` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean) — closed iter-042: curve; kernel-only.
- `AlgebraicGeometry.Scheme.IsHModuleHomFinite` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L481) — closed iter-043: global Hom-finiteness; kernel-only.
- `AlgebraicGeometry.Scheme.module_finite_HModule_zero_of_isHModuleHomFinite` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L494) — closed iter-043: H⁰ finiteness; kernel-only.
- `AlgebraicGeometry.Scheme.module_finite_HModule_zero_of_isHModuleHomFinite_curve` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L507) — closed iter-043: curve; kernel-only.
- `AlgebraicGeometry.Scheme.module_finite_globalSections_of_isProper` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L542) — closed iter-044: from properness; kernel-only.
- `AlgebraicGeometry.Scheme.SheafGammaObj_linearEquiv_top` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L597) — closed iter-045: Sheaf.ΓNatIsoSheafSections; kernel-only.
- `AlgebraicGeometry.Scheme.module_finite_gammaObj_of_isProper` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L622) — closed iter-045: sections finiteness; kernel-only.
- `CategoryTheory.Functor.const_additive` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L47) — closed iter-046: Mathlib gap-fill; kernel-only.
- `CategoryTheory.Functor.const_linear` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L54) — closed iter-046: Mathlib gap-fill; kernel-only.
- `CategoryTheory.Adjunction.left_adjoint_linear` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L72) — closed iter-046: Mathlib gap-fill; kernel-only.
- `CategoryTheory.Adjunction.right_adjoint_linear` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L78) — closed iter-046: Mathlib gap-fill; kernel-only.
- `CategoryTheory.Adjunction.homLinearEquiv` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L88) — closed iter-046: Mathlib gap-fill; kernel-only.
- `AlgebraicGeometry.Scheme.constantSheafGammaHom_linearEquiv` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L711) — closed iter-046: adjunction equiv; kernel-only.
- `AlgebraicGeometry.Scheme.homFromOne_linearEquiv` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L733) — closed iter-046: evaluation; kernel-only.
- `AlgebraicGeometry.Scheme.instIsHModuleHomFinite_toModuleKSheaf` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L762) — closed iter-046: instance; kernel-only.
- `AlgebraicGeometry.Scheme.cechCochain` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L811) — closed iter-047: Čech complex; kernel-only.
- `AlgebraicGeometry.Scheme.cechCohomology` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L834) — closed iter-047: Čech cohomology; kernel-only.
- `AlgebraicGeometry.Scheme.cechCochain_OC_eq` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L850) — closed iter-047: bridge; kernel-only.
- `AlgebraicGeometry.Scheme.cechCohomology_OC_eq` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L858) — closed iter-047: complete; kernel-only.
- `AlgebraicGeometry.Scheme.IsCechAcyclicCover` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L876) — closed iter-048: acyclicity class; kernel-only.
- `AlgebraicGeometry.Scheme.subsingleton_HModule'_supr_of_isCechAcyclicCover` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L899) — closed iter-048: subsingleton; kernel-only.
- `AlgebraicGeometry.Scheme.subsingleton_HModule'_supr_of_isCechAcyclicCover_curve` (AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean L920) — closed iter-048: curve; kernel-only.
- `AlgebraicGeometry.Scheme.subsingleton_HModule_of_isCechAcyclicCover_top` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1022) — closed iter-049: HModule subsingleton; kernel-only.
- `AlgebraicGeometry.Scheme.subsingleton_HModule_of_isCechAcyclicCover_top_curve` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1053) — closed iter-049: curve; kernel-only.
- `AlgebraicGeometry.Scheme.HasCechToHModuleIso` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1094) — closed iter-050: iso class; kernel-only.
- `AlgebraicGeometry.Scheme.cechToHModuleIso` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1110) — closed iter-050: iso; kernel-only.
- `AlgebraicGeometry.Scheme.subsingleton_HModule_of_hasCechToHModuleIso_top` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1134) — closed iter-050: subsingleton; kernel-only.
- `AlgebraicGeometry.Scheme.subsingleton_HModule_of_hasCechToHModuleIso_top_curve` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1152) — closed iter-050: curve; kernel-only.
- `AlgebraicGeometry.Scheme.subsingleton_HModule'_supr_of_hasCechToHModuleIso` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1184) — closed iter-051: subsingleton; kernel-only.
- `AlgebraicGeometry.Scheme.subsingleton_HModule'_supr_of_hasCechToHModuleIso_curve` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1201) — closed iter-051: curve; kernel-only.
- `AlgebraicGeometry.Scheme.subsingleton_HModule'_of_hasCechToHModuleIso` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1231) — closed iter-052: HModule' at open; kernel-only.
- `AlgebraicGeometry.Scheme.subsingleton_HModule'_of_hasCechToHModuleIso_curve` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1251) — closed iter-052: curve; kernel-only.
- `AlgebraicGeometry.Scheme.HasAffineCechAcyclicCover` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1279) — closed iter-053: affine cover class; kernel-only.
- `AlgebraicGeometry.Scheme.instIsAffineHModuleVanishing_of_hasAffineCechAcyclicCover` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1303) — closed iter-053: instance; kernel-only.
- `AlgebraicGeometry.Scheme.basicOpenCover` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1333) — closed iter-054: functor; kernel-only.
- `AlgebraicGeometry.Scheme.basicOpenCover_supr_of_span_eq_top` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1351) — closed iter-054: supremum; kernel-only.
- `AlgebraicGeometry.Scheme.basicOpenCover_isAffineOpen` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1369) — closed iter-054: affine; kernel-only.
- `AlgebraicGeometry.Scheme.hasAffineCechAcyclicCover_of_basicOpen` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1397) — closed iter-055: cover from opens; kernel-only.
- `AlgebraicGeometry.Scheme.hasAffineCechAcyclicCover_of_basicOpen_curve` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1421) — closed iter-055: curve; kernel-only.
- `AlgebraicGeometry.Scheme.basicOpenCover_inter_eq_basicOpen_mul` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1442) — closed iter-056: load-bearing unfold & symm; kernel-only.
- `AlgebraicGeometry.Scheme.basicOpenCover_inter_isAffineOpen` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1465) — closed iter-056: load-bearing rw; kernel-only.
- `AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_eq_basicOpen_prod` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1500) — closed iter-057: Finset.cons_induction; kernel-only.
- `AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_isAffineOpen` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1539) — closed iter-057: term-mode ▸; kernel-only.
- `AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_le` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1574) — closed iter-058: term-mode ▸; kernel-only.
- `AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_isLocalization` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1608) — closed iter-059: term-mode n-ary localization; kernel-only.
- `AlgebraicGeometry.Scheme.cechCohomology_subsingleton_of_cechCochain_exactAt` (AlgebraicJacobian/Cohomology/MayerVietoris.lean L1631) — closed iter-060: term-mode homology chaining; kernel-only.
- `AlgebraicGeometry.IsAlbanese` (AlgebraicJacobian/Jacobian.lean) — closed iter-069: Albanese universal-property predicate; kernel-only.
- `AlgebraicGeometry.IsAlbanese.unique` (AlgebraicJacobian/Jacobian.lean) — closed iter-069: universal-property uniqueness; kernel-only.
- `AlgebraicGeometry.geometricallyIrreducible_id_Spec` (AlgebraicJacobian/Jacobian.lean L113) — closed iter-069: genus-0 helper; kernel-only.
- `AlgebraicGeometry.Scheme.cotangentExactSeqBeta` (AlgebraicJacobian/Differentials.lean) — closed iter-069: cotangent β-map; kernel-only.
- `AlgebraicGeometry.JacobianWitness` (`AlgebraicJacobian/Jacobian.lean` L136) — closed iter-072: witness bundle consolidating group-scheme + Albanese; kernel-only.
- `AlgebraicGeometry.jacobianWitness` (`AlgebraicJacobian/Jacobian.lean` L177) — closed iter-071: Classical.choice witness extraction; kernel-only.
- `AlgebraicGeometry.Jacobian.ofCurve` (`AlgebraicJacobian/AbelJacobi.lean` L51) — closed iter-072: genus-conditioned routing; kernel-only.
- `AlgebraicGeometry.Jacobian.comp_ofCurve` (`AlgebraicJacobian/AbelJacobi.lean` L68) — closed iter-072: genus-split via Albanese; kernel-only.
- `AlgebraicGeometry.Scheme.cotangentExactSeqAlpha` (`AlgebraicJacobian/Differentials.lean` L199) — closed iter-072: adjunction-coherence identity; kernel-only.
- `AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp` (`AlgebraicJacobian/AbelJacobi.lean` L82) — closed iter-073: jacobianWitness routing; kernel-only.
- `AlgebraicGeometry.Jacobian.ofCurve` (`AlgebraicJacobian/AbelJacobi.lean` L51) — re-closed iter-073: direct jacobianWitness projection; kernel-only.
- `AlgebraicGeometry.Jacobian.comp_ofCurve` (`AlgebraicJacobian/AbelJacobi.lean` L62) — re-closed iter-073: direct jacobianWitness projection; kernel-only.
- `AlgebraicGeometry.Jacobian` (`AlgebraicJacobian/Jacobian.lean` L197) — re-closed iter-073: dite removal; kernel-only.
- `AlgebraicGeometry.Jacobian.instGrpObj` (`AlgebraicJacobian/Jacobian.lean` L207) — re-closed iter-073: term-mode projection; kernel-only.
- `AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus` (`AlgebraicJacobian/Jacobian.lean` L211) — re-closed iter-073: term-mode projection; kernel-only.
- `AlgebraicGeometry.Jacobian.instIsProper` (`AlgebraicJacobian/Jacobian.lean` L215) — re-closed iter-073: term-mode projection; kernel-only.
- `AlgebraicGeometry.Jacobian.instGeometricallyIrreducible` (`AlgebraicJacobian/Jacobian.lean` L218) — re-closed iter-073: term-mode projection; kernel-only.
- `AlgebraicGeometry.Scheme.cotangentExactSeqBeta` (AlgebraicJacobian/Differentials.lean) — closed iter-077: η-bridge; kernel-only.
- `AlgebraicGeometry.Scheme.cotangentExactSeqAlpha` (AlgebraicJacobian/Differentials.lean) — closed iter-077: four-of-five; kernel-only.
- `AlgebraicGeometry.Scheme.f_R.map_smul'` (AlgebraicJacobian/Cohomology/BasicOpenCech.lean) — closed iter-077: instance transport; kernel-only.
- `Jacobian.lean` (AlgebraicJacobian) — closed iter-077: 6 errors → 0; kernel-only.
- `AlgebraicGeometry.Scheme.cotangentExactSeqAlpha.d_app` (AlgebraicJacobian/Differentials.lean) — closed iter-078: τ-bridge coherence; kernel-only.
- `AlgebraicGeometry.Scheme.tensorObj` (AlgebraicJacobian/Modules/Monoidal.lean) — closed iter-078: presheaf tensor sheafification; kernel-only.
- `AlgebraicGeometry.Scheme.instMonoidalCategoryStruct` (AlgebraicJacobian/Modules/Monoidal.lean) — closed iter-078: iso synthesis; kernel-only.
- `AlgebraicGeometry.Scheme.h_diff_pi_smul_f` (AlgebraicJacobian/Cohomology/BasicOpenCech.lean) — closed iter-078: R-linearity reduction; kernel-only.
- `AlgebraicGeometry.Scheme.instMonoidalCategoryStruct` (AlgebraicJacobian/Modules/Monoidal.lean) — closed iter-079: LocalizedMonoidal bridge; kernel-only.
- `AlgebraicGeometry.Scheme.instMonoidalCategory` (AlgebraicJacobian/Modules/Monoidal.lean) — closed iter-079: symmetric coherence; kernel-only.
- `AlgebraicGeometry.Scheme.instIsMonoidal_W` (AlgebraicJacobian/Modules/Monoidal.lean) — closed iter-079: iso-stability; kernel-only.
- `AlgebraicGeometry.Scheme.epi_of_epi_presheaf` (AlgebraicJacobian/Differentials.lean) — closed iter-079: faithful bridge; kernel-only.
- `AlgebraicGeometry.Scheme.h_diff_pi_smul_f` (AlgebraicJacobian/Cohomology/BasicOpenCech.lean) — closed iter-079: R-module instances; kernel-only.
- `AlgebraicGeometry.Scheme.cotangentExactSeq_structure` (AlgebraicJacobian/Differentials.lean) — closed iter-080: Route (c) verified; kernel-only.
- `AlgebraicGeometry.Scheme.h_mod_pi` (AlgebraicJacobian/Cohomology/BasicOpenCech.lean) — closed iter-080: letI instances; kernel-only.
- `AlgebraicGeometry.Scheme.postcomp_comp` (AlgebraicJacobian/Differentials.lean) — closed iter-081: composition via ext; kernel-only.
- `AlgebraicGeometry.Scheme.cotangentExactSeq_structure` (AlgebraicJacobian/Differentials.lean) — closed iter-081: chain preservation; kernel-only.
- `AlgebraicGeometry.Scheme.cotangentExactSeq_structure` h_zero (AlgebraicJacobian/Differentials.lean) — closed iter-082: Route (c) chain; kernel-only.
- `AlgebraicGeometry.Scheme.cotangentExactSeqBeta_hη` (AlgebraicJacobian/Differentials.lean) — closed iter-083: η-coherence; kernel-only.
- `AlgebraicGeometry.Scheme.h_diff_pi_smul_f` (AlgebraicJacobian/Cohomology/BasicOpenCech.lean) — advanced iter-083: HSMul blockers; kernel-only.
- `AlgebraicGeometry.Scheme.cotangentExactSeq_structure` h_epi (AlgebraicJacobian/Differentials.lean) — closed iter-084: Option (c); kernel-only.
- `AlgebraicGeometry.Scheme.h_diff_pi_smul_f` (AlgebraicJacobian/Cohomology/BasicOpenCech.lean) — advanced iter-084: HSMul barriers cleared; kernel-only.
- **iter-086 advance** (BasicOpenCech.lean) — `presheafMap_restrict_collapse` proved; Mathlib gap on `ModuleCat.hom_sum` identified; kernel-only.
- **iter-086 closure** (Differentials.lean) — reverted false-universal; `h_exact` deferred; kernel-only.
- **iter-087 structural advance** (BasicOpenCech.lean) — two-pass refactor; inline `h_diff_pi_smul_f`; ~367 LOC removed; kernel-only.
- **iter-088 no-progress** (BasicOpenCech.lean) — S1–S5 transcribed; S6 not attempted due to LSP unavailability; kernel-only.
- **iter-089 structural advance** (BasicOpenCech.lean) — S6 steps (a)+(b) landed; +25 LOC; sorry shifted L522→L547; kernel-only.
- **iter-092 structural advance** (BasicOpenCech.lean) — foundation REPAIRED; file COMPILES end-to-end; 6 compiling sorries; kernel-only.

- **iter-093 structural advance** (BasicOpenCech.lean): body-local `have key₁ : ∀ F z, (∑F).hom z = ∑ (F i).hom z` proved by `ModuleCat.hom_sum F Finset.univ` + `LinearMap.sum_apply`; iter-092 HOU blocker refined; kernel-only; no new axioms.

- **iter-094 structural advance** (BasicOpenCech.lean): Mathlib's `ModuleCat.hom_comp : (f ≫ g).hom = g.hom ∘ₗ f.hom` applied in reverse direction to fuse `eqToHom_hom ∘ₗ (∑F).hom`; +1 committed `rw [← ModuleCat.hom_comp]`; kernel-only; no new axioms.

- **iter-095 negative result documented** (BasicOpenCech.lean): all three tactic-level routes (G/H/I) structurally blocked by HOU pattern unification on def-equal Pi-product types; lesson: structural refactor (top-level lemma with `F` as binder) required; kernel-only; no new axioms.

- `AlgebraicGeometry.Scheme.alternating_sum_pi_smul_aux` (AlgebraicJacobian/Cohomology/BasicOpenCech.lean L462–L494) — closed iter-097: abstract structural sum-of-R-linear-maps-is-R-linear lemma; `Finset.cons_induction` + simultaneous-side `simp only [Finset.sum_cons, ModuleCat.hom_add, LinearMap.add_apply, map_add]`; HOU-free because `F` is a binder; kernel-only.

- **iter-096 refactor `cechcoface-summand-extract`** (BasicOpenCech.lean): refactor subagent added `alternating_sum_pi_smul_aux` (abstract structural lemma) with `sorry` body; companion per-summand dropped due to signature-elaboration timeout on ComplexShape.prev unification; L637 trailing sorry preserved; sorries 6→7; kernel-only; no new axioms.

- **iter-097 structural advance** (BasicOpenCech.lean): `alternating_sum_pi_smul_aux` body CLOSED (L478–L494) via `revert hF; Finset.cons_induction s` + `simp only [Finset.sum_cons, ModuleCat.hom_add, LinearMap.add_apply, map_add]` distributing on both sides, then `rw [hF i, ih, smul_add]`. Empty case via `simp [Finset.sum_empty, ModuleCat.hom_zero, LinearMap.zero_apply, map_zero, smul_zero]`. Key lemma: `ModuleCat.hom_zero` (NOT `ModuleCat.zero_hom` as plan suggested) is the correct Mathlib name for `(0 : M ⟶ N).hom = 0`. Sorries 7→6; kernel-only; no new axioms. Six tactic-level attempts to close L657 (iter-094 trailing sorry) all failed at the structural bridging stage — root cause: existing structural lemma's `F` slot can't absorb intermediate `eqToHom` without re-triggering `Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀` vs `Fin (n + 1) → ↑s₀` unification outside tactic state. iter-097 B1 bridge `simp_rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j]` committed at L656.

- **iter-098 refactor `alt-sum-pi-smul-aux-sum-comp`** (BasicOpenCech.lean): refactor subagent inserted `alternating_sum_pi_smul_aux_sum_comp` at L513–L532 (parallel structural lemma splitting `F : ι' → ((∏ᶜ Z₁) ⟶ (∏ᶜ Z₂))` into a family `G : ι' → ((∏ᶜ Z₁) ⟶ (∏ᶜ Z_int))` plus single `E : (∏ᶜ Z_int) ⟶ (∏ᶜ Z₂)`, so call-site `eqToHom` lands in `E`'s independent elaboration slot, sidestepping the iter-097 Attempt 5 dead-end). Body `sorry`. `alternating_sum_pi_smul_aux` and `cechCofaceMap_pi_smul` unchanged. Sorries 6→7 (matches directive intent); kernel-only; no new axioms.

- **iter-099 structural advance** (BasicOpenCech.lean): `alternating_sum_pi_smul_aux_sum_comp` body CLOSED at L532–L537 via the directive's 3-line recipe: `intro r y; rw [Preadditive.sum_comp s G E]; exact alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ G i ≫ E) e₁ e₂ hG r y`. HOU-free at signature level because `G` and `E` are lemma binders (Miller-pattern unification fires cleanly). Inside `cechCofaceMap_pi_smul`, the iter-098 split-slot lemma was successfully *applied* at L710–L712 via `rw [← Pi.smul_apply (i := j)]; refine congrFun (alternating_sum_pi_smul_aux_sum_comp Z₁ _ Z₂ Finset.univ _ _ e₁ e₂ ?_ r y) j` — Miller-pattern unifier infers `?Z_int`, `?G`, `?E := eqToHom`, `?s := Finset.univ` from the goal's literal shape. Only the per-summand `?hG` discharge remains as residual `sorry` at L728 (was L695). Sorries 7→6; kernel-only; no new axioms. Six per-summand discharge routes for `?hG` exhausted at L728: `Preadditive.smul_comp` (unknown name; correct is `CategoryTheory.Linear.smul_comp`), `simp only [Linear.smul_comp]` (pattern not unified — polymorphic `(-1)^↑i` scalar elaboration), `simp only [Preadditive.zsmul_comp]` (same), `rw [ModuleCat.hom_smul]` (typeclass synth fails on polymorphic scalar), `change ((-1 : k) ^ (↑i : ℕ)) • _` (nested-`Pi.lift` metavariables prevent type ascription), smoke tests on `neg_smul`/`pow_succ`. Committed partial chain `intro i _ r' y'; simp only [ModuleCat.hom_comp, LinearMap.comp_apply]; sorry` so iter-100 starts from a partially-distributed goal where `eqToHom_hom` and `((-1)^↑i • Pi.lift_thing).hom` are separate `.hom`-applications.


- **iter-103 structural advance** (BasicOpenCech.lean): `alternating_zsmul_pi_smul_aux_sum_comp` body CLOSED at L590-L609 via Path B binder-level recipe: `intro r y; rw [Preadditive.sum_comp s (fun i ↦ σ i • G i) E]; simp_rw [Preadditive.zsmul_comp]; exact alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ σ i • (G i ≫ E)) e₁ e₂ (fun i hi r y => by show ...; rw [map_zsmul e₂ (σ i), map_zsmul e₂ (σ i), hG i hi r y, smul_comm (σ i) r]) r y`. HOU-free at binder level (G, E, σ are typed binder applications; no Pi.lift anonymous closure). Path A on the L827 call-site sorry FAILED across 5 routes (`simp only [hom_zsmul]` no progress; body-local rfl-helper `rw` no pattern; literal-body `show` whnf timeout at 1600000; `change` eqToHom metavar ambiguity; `← LinearMap.comp_apply` partial re-fuse stops at smul-prefix layer). Iter-103 committed S4 (rfl pivot `rw [show ConcreteCategory.hom = ModuleCat.Hom.hom from rfl]` at L823) + S5 (`simp only [ModuleCat.hom_comp, LinearMap.comp_apply]` at L826) as forward progress on the post-S3 frame. Sorries 7→6; kernel-only; no new axioms.

- **iter-102 (Archon) / iter-104 (project) refactor `cechcoface-named-family`** (BasicOpenCech.lean): refactor subagent inserted (1) `cechCofaceMap_summand_family` at L454 — sign-free Čech coface morphism family, named top-level def with codomain `∏ᶜ (Fin ((prev n) + 2) → ↑s₀ → ModuleCat k)`, body fully defined as `Pi.lift fun i_1 ↦ Pi.π Z₁ (i_1 ∘ δ i) ≫ (toModuleKPresheaf C).map (Pi.lift fun x ↦ Pi.π (basicOpenCover ↑s₀ ∘ i_1) ((δ i).toOrderHom x)).op`. No sorry. Marked `noncomputable`. (2) `cechCofaceMap_summand_family_R_linear` at L494 — per-summand R-linearity theorem skeleton, signature uses letI reconstruction of Pi.module + RingHom.toModule pattern from `cechCofaceMap_pi_smul`. Body `sorry` at L536. Change 3 (call-site rewrite at L929) deferred via documented fallback clause due to Fin-index mismatch between `Fin (n+1)` (post-`dif_pos hRel` call site sum) and `Fin ((prev n) + 2)` (natural index type for the new def); requires `Finset.sum_equiv` Fin transport (Route A) or wrapper def (Route B), to be handled by iter-105 prover. File compiles; sorries 6→7 (net +1 from new R-linearity body); kernel-only; no new axioms. Heartbeat budget unchanged (1600000 for `cechCofaceMap_pi_smul` block).

- **iter-104 structural closure** (BasicOpenCech.lean): `cechCofaceMap_summand_family_R_linear` body CLOSED at L536–L595 via a 50-LOC binder-level tactic chain. Recipe: `intro R Z₁ Z_int e₁ e_int`; reconstruct `letI perI₁/h_mod_pi₁/perI_int/h_mod_pi_int` inside body (mandatory — signature letI bindings don't survive `intro` for HSMul synth); `intro r y; funext j'; simp only [Pi.smul_apply]`; `show (Pi.π Z_int j').hom ((cechCofaceMap_summand_family s₀ n i).hom (e₁.symm (r • y))) = r • (Pi.π Z_int j').hom ((cechCofaceMap_summand_family s₀ n i).hom (e₁.symm y))`; `unfold cechCofaceMap_summand_family`; `simp only [Limits.Pi.lift_π_apply, ConcreteCategory.comp_apply]`; body-local `hSym` (via `ModuleCat.piIsoPi_inv_kernel_ι_apply`) for `(Pi.π Z₁ a).hom (e₁.symm Z) = Z a`; `rw [hSym, hSym]`; `simp only [Pi.smul_apply, RingHom.toModule_smul]`; `set Pl := Pi.lift fun x ↦ Pi.π _ ((δ i).toOrderHom x) with hPl_def`; close via term-level `((C.left.presheaf.map Pl.op).hom.map_mul _ _).trans (congrArg (· * (C.left.presheaf.map Pl.op).hom (y (j' ∘ (δ i).toOrderHom))) (presheafMap_restrict_collapse _ _ _ r))`. Key lessons: (1) `letI` reconstruction inside body is MANDATORY for HSMul synthesis to match the goal; (2) `piIsoPi_inv_kernel_ι_apply` (not `_hom_*_apply`) handles the `e₁.symm` form; (3) `RingHom.toModule_smul` is rfl and unfolds `•` to explicit ring multiplication; (4) term-level `Eq.trans + congrArg` bypasses HMul-synth issues on the output ring (W₂ side) that defeated tactic-level `rw [(...).hom.map_mul]`; (5) `set Pl := ...` gives `presheafMap_restrict_collapse` a target type that unifies with implicit metas. Sorries 7→6; kernel-only; no new axioms. ~25 LSP probes total. RESOLVED on first sustained attempt at the binder level, vindicating the iter-102/Archon refactor-then-prove cadence. Step 2 STRETCH (L988) explicitly skipped per the iter-104 escalation rule.

- `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` (AlgebraicJacobian/Cotangent/GrpObj.lean:149) — landed iter-128 (definition; body subsequently corrected through iter-131); iter-131 body refactor lands the pure-term `Classical.choose`-chain `noncomputable def` shape; kernel-only axioms.
- `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars` (AlgebraicJacobian/Cotangent/GrpObj.lean:198) — closed iter-131 refactor: strong acceptance lemma exposing the chart triple `(U, V, e, h_top)` + the equation that the body equals `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[…])`; closes by `rfl`; kernel-only axioms.
- `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq` (AlgebraicJacobian/Cotangent/GrpObj.lean:244) — closed iter-132: rank lemma `Module.finrank k (cotangentSpaceAtIdentity G) = n` via parallel `Classical.choose`-chain extraction on `Scheme.smooth_locally_free_omega` + `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq hrank` + `RingHom.domain_nontrivial` to discharge `[Nontrivial Γ(G, V)]`; ~40 LOC body; kernel-only axioms `{propext, Classical.choice, Quot.sound}`. **META-PATTERN TRIPWIRE PASSED** (5-iter watch iter-128 → iter-132 on the central declaration: 2 corrective cycles consumed; the iter-131 body shape proved tractable for the rank lemma close).
- `AlgebraicGeometry.GrpObj.shearMulRight` + `shearMulRight_hom_fst` + `shearMulRight_hom_snd` + `schemeHomRingCompatibility` (AlgebraicJacobian/Cotangent/GrpObj.lean L349 / L386 / L391 / L423) — closed iter-134: piece (i.b) Step 1 (shear iso ~30 LOC + 2 `@[reassoc (attr := simp)]` companions via `simp [shearMulRight]` + adjunction-transpose helper); ~50 LOC honest closure on `lift_lift_assoc` / `lift_comp_inv_left` / `lift_comp_one_left` calculus + `pullbackPushforwardAdjunction.homEquiv.symm`; kernel-only axioms.
- `AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section` + `section_snd_eq_identity_struct` (AlgebraicJacobian/Cotangent/GrpObj.lean L508 + L452) — closed iter-136: piece (i.b) Step 3 (section-restriction along the canonical section `s = ⟨𝟙_G, η_G⟩`) via `PresheafOfModules.pullbackComp` on both sides + `eqToIso` reshape via the c-composition rule + `rw [section_snd_eq_identity_struct]`; new private helper `section_snd_eq_identity_struct` captures the categorical identity `s.left ≫ pr_2.left = G.hom ≫ η[G].left` via `lift_snd` + `Over.toUnit_left` + `rfl` (~5 LOC); main body ~22 LOC, total ~27 LOC; kernel-only axioms `{propext, Classical.choice, Quot.sound}`.
- `AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product` (AlgebraicJacobian/Cotangent/ChartAlgebra.lean L84) — closed iter-146: chart-algebra (α) sub-piece sorry-free via `inferInstance` after re-enabling Mathlib's `local` `Algebra.TensorProduct.rightAlgebra` instance; ~5 LOC body; kernel-only axioms.
- `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` (AlgebraicJacobian/Cotangent/ChartAlgebra.lean L325) — closed iter-146 via signature reduction: thin renaming delegate to iter-125 `Scheme.Over.ext_of_eqOnOpen`. ~11 LOC body; kernel-only axioms. Iter-149+ refinement scheduled to encode `df = dg` substantively (gated on KDM body closure).
- `AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart` (AlgebraicJacobian/Cotangent/ChartAlgebra.lean L167) — closed iter-147: chart-algebra (β-core) sorry-free via one-line delegate to `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`. Required reordering KDM above the second `namespace GrpObj` reopening. Kernel-only axioms.
- `AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (KDM, AlgebraicJacobian/Cotangent/ChartAlgebra.lean L197) — closed iter-154 (axiom-clean; project 8→7). The single-element / perfect-field / Jacobi–Zariski `H1Cotangent` route: (FT.1) push `D_B b = 0` to `K = Frac B`; (FT.2) `by_contra` ⟹ `b` transcendental ⟹ `RatFunc k ↪ K`, `FormallySmooth (RatFunc k) K` (`of_perfectField`, char 0) ⟹ `mapBaseChange` injective (`H1Cotangent.exact_δ_mapBaseChange` + `Subsingleton H1`) ⟹ `D_{RatFunc k} X = 0`, contradicting base case `_ratfunc_D_X_ne_zero`; ⟹ `b` algebraic ⟹ `[IsAlgClosed k]` closer `_algebraic_mem_range`. Two new private helpers `_ratfunc_D_X_ne_zero`/`_algebraic_mem_range`, transitively clean. Discharges the chart-algebra ring/chart envelope; `df_zero_factors_through_constant_on_chart` now genuinely sorryAx-free (verified). The `_mvPoly_*` dead helpers removed. kernel-only axioms `{propext, Classical.choice, Quot.sound}`.
- `AlgebraicGeometry.constants_integral_over_base_field` (AlgebraicJacobian/Cotangent/ChartAlgebra.lean) — closed iter-153: the `[IsAlgClosed k]` collapse. `Γ(X, O_X)` is a field (irreducible + reduced via `GeometricallyIrreducible.irreducibleSpace_of_subsingleton` + `isIntegral_of_irreducibleSpace_of_isReduced` + `isField_of_universallyClosed`), finite over `k` (`finite_appTop_of_universallyClosed` transferred across `ΓSpecIso` via `RingHom.finite_respectsIso.2`), so `IsAlgClosed.algebraMap_bijective_of_isIntegral` gives `algebraMap k Γ` surjective ⟹ `range = ⊤`. ~25 LOC; kernel-only axioms `{propext, Classical.choice, Quot.sound}` (lean_verify confirmed, no sorryAx). Validated the iter-152 `[IsAlgClosed]` pivot signatures (project 9→8).
- `AlgebraicGeometry.rigidity_snd_lift` (AlgebraicJacobian/AbelianVarietyRigidity.lean L64) — closed iter-157: the pure cartesian-monoidal identity `snd ≫ lift (toUnit Y ≫ x₀) (𝟙 Y) = lift (toUnit (X⊗Y) ≫ x₀) (snd X Y)` via `ext1 <;> simp`; sorryAx-FREE, kernel-only axioms. The honest categorical-algebra step of the Rigidity Lemma chain; survives the iter-158 soundness repair untouched.
- `AlgebraicGeometry.eq_comp_of_isAffine_of_properIntegral` (AlgebraicJacobian/AbelianVarietyRigidity.lean L153) — closed iter-161: the cohomology-free algebraic core "two k̄-points (sections of `wk`) of a proper integral l.f.t. k̄-scheme `W` into an affine `V` compose equally with the map." `Γ(W)` a field (`isField_of_universallyClosed`) + `wk.appTop` integral (`finite_appTop_of_universallyClosed`) + alg-closed collapse (`IsAlgClosed.ringHom_bijective_of_isIntegral`) ⟹ `wk.appTop` iso ⟹ `cancel_epi` on the two sections ⟹ `ext_of_isAffine`. Axiom-clean `{propext, Classical.choice, Quot.sound}` (verified by both iter-161 auditors); every hypothesis load-bearing. Reusable; blueprinted iter-162 as `lem:eq_comp_of_isAffine_of_properIntegral`.
- `AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine` `JacobsonSpace U` instance (AlgebraicJacobian/AbelianVarietyRigidity.lean, lane (a)) — closed iter-161: `LocallyOfFiniteType.jacobsonSpace (X⊗Y).hom` + `JacobsonSpace.of_isOpenEmbedding U.ι.isOpenEmbedding` (the iter-160 signature gap was closed iter-161 by threading `[LocallyOfFiniteType (X⊗Y).hom]`). `rigidity_eqOn_saturated_open_to_affine` is now `sorry`-free in its OWN body; it delegates only to the still-open Step 1.

## Rigidity-Lemma chain (AbelianVarietyRigidity.lean) — FULLY CLOSED iter-162, axiom-clean
- `AlgebraicGeometry.rigidity_snd_lift` — closed iter-157; kernel-only.
- `AlgebraicGeometry.snd_left_isClosedMap` — closed iter-158 (bridge 1, closed map); kernel-only.
- `AlgebraicGeometry.morphism_eq_of_eqAt_closedPoints` — closed iter-160 (Step 2, dense-closed-points ⟹ hom-ext via coproduct probe + `ext_of_isDominant`); kernel-only.
- `AlgebraicGeometry.eq_comp_of_isAffine_of_properIntegral` — closed iter-161 (algebraic core: proper integral l.f.t. k̄-scheme into affine constant on k̄-points); kernel-only.
- `AlgebraicGeometry.isIntegral_of_retract` — closed iter-162 (retract of integral is integral; per-stalk reducedness); kernel-only.
- `AlgebraicGeometry.rigidity_eqAt_closedPoint_of_proper_into_affine` — closed iter-162 (Step 1, Over-level cartesian algebra); kernel-only.
- `AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine`, `rigidity_eqOn_dense_open`, `rigidity_core`, `rigidity_lemma` — all sorry-free + axiom-clean (`#print axioms rigidity_lemma` = {propext, Classical.choice, Quot.sound}). The whole Mumford Form-I Rigidity Lemma is PROVEN char-free. Foundational, route-independent (feeds genus-0 base case AND Route A's Albanese UP via Milne Cor 1.5).
- `AlgebraicGeometry.hom_additive_decomp_of_rigidity` (AlgebraicJacobian/AbelianVarietyRigidity.lean) — closed iter-163: Milne Cor 1.5 additive decomposition `h=(f∘p)·(g∘q)` from the proven `rigidity_lemma`; axiom-clean (`propext, Classical.choice, Quot.sound`). Foundation of the genus-0 base case (consumed by the 𝔾_m-scaling shortcut).
- `AlgebraicGeometry.av_regularMap_isHom_of_zero` (AlgebraicJacobian/AbelianVarietyRigidity.lean) — closed iter-163: Milne Cor 1.2 (pointed regular map of AVs is `IsMonHom`) from Cor 1.5; axiom-clean. Route-A Albanese-UP input (off the genus-0 critical path under the scaling shortcut).

## Genus-0 base objects (Genus0BaseObjects.lean) — iter-165 NEW-FILE scaffold landed (PARTIAL gate)
- `AlgebraicGeometry.projectiveLineBarGrading_gradedRing` (AlgebraicJacobian/Genus0BaseObjects.lean) — closed iter-165: standard ℕ-graded `MvPolynomial (Fin 2) k̄` via `MvPolynomial.gradedAlgebra`; kernel-only.
- `AlgebraicGeometry.projectiveLineBarScheme_canOver` (AlgebraicJacobian/Genus0BaseObjects.lean) — closed iter-165: explicit `Over (Spec k̄)` instance via `Proj.toSpecZero ≫ Spec.map (algebraMap k̄ ↥(𝒜 0))`; kernel-only.
- `AlgebraicGeometry.projectiveLineBar_isProper` (AlgebraicJacobian/Genus0BaseObjects.lean L127) — closed iter-165 AXIOM-CLEAN: `IsProper (ProjectiveLineBar kbar).hom` via the chain `Proj.toSpecZero` proper + `Spec.map (algebraMap k̄ → ↥(𝒜 0))` iso (bijective algebraMap via `MvPolynomial.C_injective` + `homogeneousComponent_of_mem`/`_zero`) + `composition proper · iso = proper`. Required the analogist-flagged "FREE-from-Mathlib" path actually go via the encoded `Proj.toSpecZero ≫ Spec.map ...` form, with the bijectivity check explicit. Better than the iter-164 plan target. Kernel-only.
- `AlgebraicGeometry.gaScheme_canOver`, `ga_isAffineHom`, `ga_locallyOfFinitePresentation`, `ga_isReduced` (AlgebraicJacobian/Genus0BaseObjects.lean L223/234/241/250) — closed iter-165: Mathlib bridges for `Ga` (`AffineSpace`-based). `ga_isReduced` notably via `isReduced_of_isOpenImmersion (AffineSpace.isoOfIsAffine ..).hom`. Kernel-only.
- `AlgebraicGeometry.gmScheme_canOver`, `gm_isAffine`, `gm_isReduced`, `gm_locallyOfFinitePresentation` (AlgebraicJacobian/Genus0BaseObjects.lean L288/298/315/306) — closed iter-165: Mathlib bridges for `Gm` (encoded as `Spec (Localization.Away (X : MvPolynomial Unit kbar))`, the AFFINE path not basic-open). `gm_locallyOfFinitePresentation` notably via `HasRingHomProperty.Spec_iff.mpr (RingHom.finitePresentation_algebraMap.mpr inferInstance)`. Kernel-only.
- **Iter-165 file landing — 4 main objects defined + 9 scaffold sorries** (`projectiveLineBar_geomIrred` L175, `projectiveLineBar_smoothOfRelDim` L182, `ProjectiveLineBar.{zeroPt,onePt,inftyPt}` L199/204/209, `ga_grpObj` L264, `gm_grpObj` L329, `gmScalingP1` L366, `gmScalingP1_collapse_at_zero` L381) — all plan-allowed per the iter-165 PARTIAL gate scorecard. `gmScalingP1_collapse_at_zero`'s STATEMENT matches the rigidity consumer's `_hf` shape verbatim (iter-166 Lane 1 consumes). `ga_smooth` / `gm_smooth` propagate `sorryAx` honestly via their `_grpObj` upstreams (no laundering).

## iter-166 outcomes (Lane 1 AVR refactor + Lane 2 G0BO live-consumer closures)
- `AlgebraicGeometry.morphism_P1_to_grpScheme_const` body (AlgebraicJacobian/AbelianVarietyRigidity.lean L1089) — landed iter-166 via the 𝔾ₘ-scaling shortcut; outer body sorry-free, delegates the pointed case to a private helper `morphism_P1_to_grpScheme_const_aux` (L931) carrying 5 internal sorries on product-stability / `IsReduced` / `IsDominant ι.left` (all named, no laundering). `lean_verify` axiom set = `{propext, sorryAx, Classical.choice, Quot.sound}`. Lifts to axiom-clean once the 5 residuals discharge.
- `AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme` body (AlgebraicJacobian/AbelianVarietyRigidity.lean L1156) — landed iter-166 via iso-transport from `morphism_P1_to_grpScheme_const` under `genusZero_curve_iso_P1`. Outer body sorry-free; `sorryAx` propagates honestly via the iso (RR bridge) + the aux's 5 residuals. Lifts to axiom-clean when both upstreams close.
- `AlgebraicGeometry.morphism_P1_to_grpScheme_const` + `rigidity_genus0_curve_to_grpScheme` signature refactor — landed iter-166: dropped the abstract `P1 : Over (Spec k̄)` parameter in favor of the concrete `ProjectiveLineBar kbar`. `genusZero_curve_iso_P1` target likewise refactored to `Nonempty (C ≅ ProjectiveLineBar kbar)`. Aligns Lean signatures verbatim with the chapter's "ℙ¹_{k̄}" language.
- `AlgebraicGeometry.ProjectiveLineBar.zeroPt` / `.onePt` / `.inftyPt` (AlgebraicJacobian/Genus0BaseObjects.lean L268/L274/L280) — closed iter-166 AXIOM-CLEAN: shared `private noncomputable def pointOfVec` helper via `Proj.fromOfGlobalSections + Over.homMk + IsUnit (v i)` discharge of the irrelevant-ideal condition. `#print axioms` = `{propext, Classical.choice, Quot.sound}` on all three. Coordinate-correct: `[0:1]` / `[1:1]` / `[1:0]` (verified by auditor + checker).
- `ga_grpObj` docstring reword (Genus0BaseObjects.lean L324-334) — landed iter-166 per the iter-165 lean-auditor minor: replaced the "PARTIAL placeholder … does not exercise this" wording with explicit off-path scaffold disclosure.

## iter-172 outcomes (Lane A PRIMARY 1 close + Lane C file-skeleton landing)
- `AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective` (AlgebraicJacobian/Genus0BaseObjects.lean L379) — closed iter-172 AXIOM-CLEAN: `Algebra.adjoin_induction` over `(𝒜 0)` using Mathlib's `HomogeneousLocalization.Away.adjoin_mk_prod_pow_eq_top` specialised to `d=1, v=![X 0, X 1], dv=![1, 1]`. ~140 LOC. Retires sorryAx taint of `homogeneousLocalizationAwayIso_aux_left` + `homogeneousLocalizationAwayIso` (both now `{propext, Classical.choice, Quot.sound}`). Documented dead-ends: `induction p using MvPolynomial.induction_on with` fails; `fin_cases i` keeps `⟨0, _⟩` form; `RingHom.map_pow` on `val (x^n)` resolves wrong (use `HomogeneousLocalization.val_pow`).
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — iter-172 Lane C COMPLETE file-skeleton landing: 9 pinned declarations scaffolded + 1 helper structure `Scheme.PrimeDivisor`. Build green (6 sorry warnings + 1 `True` placeholder on `PrimeDivisor.isCodim1AndIntegral`, flagged must-fix-this-iter for iter-173 Lane D). 3 declarations close `sorry`-free (`WeilDivisor` = `PrimeDivisor →₀ ℤ`, `degree` = `D.sum fun _ n => n`, `LinearEquivalence`). Umbrella import added. Scaffolds for body work iter-173+.
- `AlgebraicJacobian/Jacobian.lean` — iter-172 refactor agent `jacobian-purge-excuse`: purged iter-171 lean-auditor CRITICAL excuse-comment block (L237-263) + refreshed stale strategic docstring L182-208 to reference Route C `rigidity_genus0_curve_to_grpScheme` consumer.

## iter-173 plan-phase blueprint landings (this iter — non-prover)
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` — 4 new `\lean{...}` pins for `gmScalingP1_cover/chart/_chart_agreement/_over_coherence` (covers iter-172 lean-vs-blueprint MAJOR finding).
- `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — `def:prime_divisor` pin + Standing-hypothesis prose + `Lean signature scope` paragraphs on `def:divisor_closed_point` / `def:divisor_degree`. Recipe `coheight : Order.coheight point = 1` pinned for iter-173 Lane D PRIMARY 1.
- `blueprint/src/chapters/Picard_LineBundlePullback.tex` — NEW chapter for Route A.1.b (Kleiman §2 verbatim quotes; 5 pinned declarations).
- `blueprint/src/chapters/RiemannRoch_RRFormula.tex` — NEW chapter for genus-0 RR.2 (Hartshorne IV.1 verbatim; 4 pinned declarations).
- `blueprint/src/chapters/Jacobian.tex` — A.4 prose reconciled with iter-172 audit (bypass FAILS); Total Route A budget recomputed.
- `analogies/chart-bridge.md` — NEW persistent file: 30-LOC chart-bridge recipe + Mathlib citations + sub-lemma proof sketches. Resolves Lane A PRIMARY 3 blocker.


## Iter-174 closures

- `AlgebraicGeometry.gmScalingP1_chart` (Genus0BaseObjects.lean:911) — closed iter-173 axiom-clean via the analogist's chart-bridge recipe. Carry-over confirmation: still axiom-clean iter-174 entering.
- `AlgebraicGeometry.Scheme.PrimeDivisor` (RiemannRoch/WeilDivisor.lean:93) — closed iter-173 with `coheight : Order.coheight point = 1` predicate field; placeholder `True := trivial` retired axiom-clean.
- `AlgebraicGeometry.Scheme.WeilDivisor.degree_hom` (RiemannRoch/WeilDivisor.lean:207) — closed iter-173 via `Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)`; kernel-only.
- `AlgebraicGeometry.Scheme.WeilDivisor.degree_hom_apply` (RiemannRoch/WeilDivisor.lean:210) — new bridge `@[simp]` lemma added iter-173; axiom-clean.
- File-skeleton: `AlgebraicJacobian/Picard/RelativeSpec.lean` (260 LOC) — landed iter-173 with all 6 pinned declarations + helper `structureMorphism`. Now Lane G target iter-174 for `QcohAlgebra` body refinement.
- Cohomology/StructureSheafModuleK.lean refactored iter-174 into 3 sub-files + re-export — no signature changes, no sorry-count change.

## Iter-178 closures (summary)

- `AlgebraicGeometry.Module.projectiveDimension` (`Albanese/AuslanderBuchsbaum.lean:168`) — closed iter-178 Lane 7 AXIOM-CLEAN via `CategoryTheory.projectiveDimension (ModuleCat.of R _M)` one-liner. Required `open CategoryTheory` in namespace scope. Iter-178 auditor 178C flagged stale docstring afterwards (iter-179 Lane F target).
- `AlgebraicGeometry.Scheme.RationalMap.extend_iff_order_nonneg` (`Albanese/CodimOneExtension.lean:391`) — closed iter-178 Lane 4 KERNEL-CLEAN via `Scheme.RationalMap.mem_domain` rewrite + swap-pair `Iff.intro`. Iter-178 auditor 178B flagged the body as too shallow for claimed content + unused `KrullDimLE` binder (iter-179 Lane D target).
- `AlgebraicGeometry.Scheme.RationalMap.localRing_dvr_of_codim_one` (`Albanese/CodimOneExtension.lean:195`) — main body closed iter-178 Lane 4 via `IsDiscreteValuationRing.TFAE`; Mathlib gap factored into 1 named helper sorry `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` (substantive type; iter-179 Lane D STRETCH target).
- iter-178 Lane 5 Part A (`RationalCurveIso.lean`) — signature mutation on `iso_of_degree_one` from `≅` to `≃+*` axiom-clean (auditor MUST-FIX from iter-178 plan).
- iter-178 Lane 1 (`RiemannRoch/OCofP.lean`) — 1-LOC instance binder threading
  `[Scheme.IsRegularInCodimensionOne C.left]` restored `lake build` green
  (iter-177 carry-over error at L335 fixed).
- iter-178 Lane 3 (`WeilDivisor.lean`) — `principal_degree_zero` constant
  branch closed AXIOM-CLEAN via `Finsupp.ext` + `Finsupp.sum_zero_index`.
  Non-constant branch sorry remains (gated on Lane 5 progress + Hartshorne II.6.9).
- iter-178 Lane 6 (`Picard/QuotScheme.lean`) — `canonicalBaseChangeMap_isIso`
  body structural one-liner via `Scheme.Modules.Hom.isIso_iff_isIso_app`;
  substantive content factored into named helper sorry
  `canonicalBaseChangeMap_app_app_isIso` with substantive Stacks 02KH(ii) type.
- iter-178 plan-phase consult outputs:
  - `analogies/gmscaling-cover-bridge.md` — uniform-in-`i` refactor
    recipe (3-step: hoist tactic proofs in `BareScheme.lean`; rewrite
    `gmScalingP1_cover_X_iso` uniform; retire 2 TEMP axioms via 3 body
    lemmas). iter-179 consumed by refactor `cover-bridge-uniform-i` +
    Lane A.
  - `analogies/relative-spec-encoding.md` — `AffineZariskiSite.relativeGluingData`
    canonical Mathlib idiom; 3-block recipe (Block A carrier upgrade
    ~25 LOC; Block B downstream rewrites ~60 LOC; Block C representable ~40 LOC).
    iter-179 consumed by refactor `relative-spec-block-a` + Lane B.

## Iter-180 closures

- iter-180 Lane A (`Genus0BaseObjects/GmScaling.lean`) — PRIMARY
  `gmScalingP1_chart_PLB_eq` (L213) closed KERNEL-CLEAN via the
  empirically-verified `set_option backward.isDefEq.respectTransparency
  false in` recipe (analogist consult `pullbackspeciso-bypass`
  Decision-4 ALIGN_WITH_MATHLIB). Both iter-177 TEMP axioms
  (`gmScalingP1_chart_data_temp`, `gmScalingP1_collapse_at_zero_temp`)
  DELETED. First 0-axiom build since iter-177. RETIRE-OR-ESCALATE
  corrective EXECUTED iter-180 (was scheduled for iter-181).
- iter-180 Lane C (`Picard/RelativeSpec.lean`) —
  `QcohAlgebra.pullback.coequifibered` closed KERNEL-CLEAN via 2
  axiom-clean helpers `pullback_fst_isAffineHom` +
  `pullback_coequifibered` using
  `coequifibered_iff_forall_isLocalizationAway` +
  `IsAffineOpen.isLocalization_of_eq_basicOpen`.
- iter-180 Lane E (`RiemannRoch/RRFormula.lean`) —
  `l_eq_degree_plus_one_of_genus_zero` closed via 3-line proof.
  Body itself kernel-clean; inherits `sorryAx` transitively from
  upstream `eulerCharacteristic_eq_degree_plus_one_minus_genus`
  (iter-181 Lane H target — closure retires the transitive sorry).
  4-iter STUCK-by-inaction streak BROKEN.
- iter-180 Lane H (`Albanese/AuslanderBuchsbaum.lean`) — `Module.depth`
  body closed KERNEL-CLEAN first-attempt via Stacks 00LF supremum form
  using `RingTheory.Sequence.IsRegular`. 0 helpers, 0 axioms, 0
  signature mutations. Structurally unblocks 4 depth-dependent lemmas
  (`depth_eq_smallest_ext_index`, `depth_of_short_exact`,
  `auslander_buchsbaum_formula`, `CohenMacaulay.of_regular`).
- iter-180 Lane B (`Genus0BaseObjects/Points.lean`) — STRUCTURAL
  ADVANCE: 11-iter `gm_grpObj` deferral PARTIALLY BROKEN. 5
  axiom-clean supporting declarations landed (`gmHomFunctor`,
  `gmHomEquiv_toFun`, `gmHomEquiv_invFun`, `gmHomEquiv_invFun_isOver`,
  `gmHomEquiv_homEquiv_comp`); `gm_grpObj` body via
  `GrpObj.ofRepresentableBy` canonical Mathlib idiom; 2 named
  substantive sorries on round-trip identities (iter-181 Lane C target).
- iter-180 plan-phase `mathlib-analogist pullbackspeciso-bypass`:
  ALIGN_WITH_MATHLIB on Decision-4
  (`set_option backward.isDefEq.respectTransparency false`).
  EMPIRICALLY VERIFIED via `lean_multi_attempt`. Persistent recipe
  at `analogies/pullbackspeciso-bypass.md`. Consumed by Lane A above.

## Iter-181 plan-phase outputs

- `refactor ocofp-globalsections-sig` — COMPLETE. Added
  `Scheme.lineBundleAtClosedPoint.toFunctionField` typed-sorry def;
  re-typed `globalSections_iff` RHS as `∃ s, ι s = f` (binding `s`
  to `f`); blueprint chapter `RiemannRoch_OCofP.tex` prose tightened
  in lockstep. File compiles GREEN. Net file-sorry delta 0.
  Addresses iter-180 lean-vs-blueprint-checker `iter180-ocofp`
  CRITICAL must-fix-this-iter (signature was vacuous-in-`f`).
- `mathlib-analogist ratcurveiso-pins` — COMPLETE. Pin 2 PROCEED
  (no `Scheme.Hom.degree` / `Scheme.WeilDivisor.pullback` in Mathlib;
  recipe `analogies/ratcurveiso-pin2.md` via `Ideal.sum_ramification_inertia`
  chart calculation, ~80–150 LOC). Pin 3 PROCEED with
  DIVERGE_INTENTIONALLY (no `IsBirational` for smooth proper curves;
  recipe `analogies/ratcurveiso-pin3.md` via
  `Scheme.Hom.instIsIsoToNormalizationOfIsIntegralHom`; signature
  refinement needed — Lane I iter-181).

## Iter-181 prover outputs

- iter-181 Lane C (`Genus0BaseObjects/Points.lean`) — SUCCESS
  kernel-clean. Both round-trip identities `gmHomEquiv_left_inv` /
  `gmHomEquiv_right_inv` closed at `{propext, Classical.choice,
  Quot.sound}` kernel-only. **`gm_grpObj` transitively kernel-clean.
  11-iter STUCK pattern FULLY RESOLVED.** File sorry 2 → 0. The
  pattern that broke it (`GrpObj.ofRepresentableBy` decomposition
  + 2-iter close cycle) is template-able for future Mathlib-gap
  construction routes.

## Iter-182 plan-phase outputs

- `refactor pin2-sig-strengthen` — COMPLETE. New
  `Scheme.Hom.poleDivisor` typed-sorry `noncomputable def` +
  `morphism_degree_via_pole_divisor` signature strengthened to bind
  `D = φ^*[∞]` and `deg = Module.finrank K(ℙ¹) K(C)`. Build GREEN.
  Net file sorry delta: +1 (poleDivisor typed-sorry def).
  Addresses iter-181 `lean-vs-blueprint-checker iter181-ratcurveiso`
  must-fix-this-iter (Pin 2 signature weakened-wrong).
- `blueprint-writer ratcurveiso-pin3-prose` — COMPLETE. Pin 3
  chapter prose refactored to `[K(C):K(C')]=1` shape + canonical
  `[Algebra]` instance documentation. Pin 2 chapter prose refactored
  to bind `D = φ^*[∞]` via `Scheme.Hom.poleDivisor`. New OCofP
  definition block `def:lineBundleAtClosedPoint_toFunctionField`
  added + `\uses` cross-ref wired into
  `lem:lineBundleAtClosedPoint_globalSections_iff`. Addresses
  iter-181 `lean-vs-blueprint-checker iter181-{ratcurveiso,ocofp}`
  pending recommendations.
- `blueprint-writer ocofd-skeleton` — COMPLETE. New chapter
  `RiemannRoch_OcOfD.tex` written (Background, Definition of `O_C(D)`,
  three `\lean{...}`-pinned corollaries, Proof sketch, Lean signature
  scope). `\input` line added to `content.tex` manually (writer
  descriptor forbids editing `content.tex`). Unblocks iter-183 Lane K
  file-skeleton opening of `RiemannRoch/OcOfD.lean`.
- `mathlib-analogist intersection-ring-cross01` — JOINT for Routes
  1+3. Key finding: **Mathlib HAS `Proj.pullbackAwayιIso`** at
  `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:258-302`
  with 5 companion `simp` lemmas. iter-181 task_result misclassified
  this as Mathlib gap. Verdict: BUILD_PROJECT_HELPER ~50-60 LOC
  pasting iso + ~30-45 LOC cross01 body + ~45-60 LOC iotaGm_range
  body. Persistent recipe at `analogies/intersection-ring-cross01.md`.
- `mathlib-analogist ocofp-sheaf-internalhom` — NEEDS_MATHLIB_GAP_FILL
  on abstract internal-Hom route (Sheaf-of-ModuleCat-R internal-Hom
  + IdealSheafData → SheafOfModules realiser + Mathlib gaps).
  ALIGN_WITH_MATHLIB on Hartshorne subsheaf-of-`K_C` direct
  construction (mirror project's `toModuleKSheaf` template). ETA
  ~230-360 LOC full body; signature amendment needed (add
  `hPcoh : Order.coheight P = 1`). Recipe at
  `analogies/ocofp-sheaf-internalhom.md`.
- `mathlib-analogist quotscheme-pullback-affine-section` —
  BUILD_PROJECT_HELPER (Mathlib's `Scheme.Modules.pullback` is
  abstract partial-adjoint with no `pullback_obj_obj` simp lemma —
  only `pullbackObjFreeIso` for FREE sheaves). iter-181 "decompose
  more" strategy WRONG. PIVOT: create one new typed-sorry def
  `Scheme.Modules.pullback_app_isoTensor` (~120-200 LOC body
  iter-183+); collapse iter-181 helpers through it. Recipe at
  `analogies/quotscheme-pullback-affine-section.md`.
- `mathlib-analogist isregularlocalring-isdomain` —
  NEEDS_MATHLIB_GAP_FILL on Stacks 00NQ. ~300 LOC project-side via
  minimal-primes + Krull-intersection chain. **PIVOT Lane G** to
  `depth_of_short_exact` (Stacks 00LE) — less Mathlib-gap exposure.
  Recipe at `analogies/isregularlocalring-isdomain.md`.
- `mathlib-analogist stacks-00tt-coheight` — coheight bridge
  ~60-100 LOC scaffold tractable iter-183+ via in-scope Mathlib
  lemmas (`coheight_orderIso`, `AffineOpen.isLocalization_stalk`,
  `IsLocalization.AtPrime.ringKrullDim_eq_height`, etc.). Stacks
  00TT genuine gap ~200-300 LOC project-side. Milne 3.3 codim-1
  ~300-500 LOC multi-iter. **Recommend defer CodimOneExtension
  prover lane**; scaffold `CoheightBridge.lean` iter-183+. Recipe at
  `analogies/stacks-00tt-coheight.md`.


## iter-182 closures

- `AlgebraicGeometry.RingTheory.Module.depth_of_short_exact`
  (`Albanese/AuslanderBuchsbaum.lean`) — closed iter-182 Lane G PIVOT
  Tier-2 modulo `depth_eq_smallest_ext_index` upstream (in same
  file; iter-183 Lane G target). LES of `Ext^*(κ, ·)` via
  `ShortComplex.ShortExact` + `covariant_sequence_exact₁/₂/₃`;
  3-branch case split + 2 private helpers
  (`ext_vanish_of_natCast_lt_depth` Tier-2; `natCast_add_one_le_of_le_sub_one`
  Tier-1 axiom-clean). The sole net sorry-decrement of iter-182.


## iter-183 closures

- `Albanese.CoheightBridge` (new file, 4 declarations all Tier-1 axiom-clean):
  - `Order.coheight_eq_of_isOpenEmbedding` — coheight invariant under
    open embedding for topological spaces. ~50 LOC via
    `Continuous.specialization_monotone` + `subtype_specializes_iff`.
  - `Order.coheight_spec_eq_height_primeSpectrum` — `coheight x = height x.asIdeal`
    for `Spec R` via `OrderIso` transport. ~25 LOC.
  - `AlgebraicGeometry.Scheme.ringKrullDim_stalk_eq_coheight` — coheight
    of point in scheme = `ringKrullDim` of the stalk (via affine open
    + Spec preorder iso + `IsLocalization.AtPrime.ringKrullDim_eq_height`).
  - `AlgebraicGeometry.Scheme.ringKrullDimLE_of_coheight_eq_one` (instance) —
    `coheight z = 1 ⟹ Ring.KrullDimLE 1 (stalk z)`. Specialisation
    used by `Albanese/CodimOneExtension.lean` (Lane M downstream iter-184).
- `Hom.poleDivisor_degree_eq_finrank`-consumer Pin 2 wrapper
  `morphism_degree_via_pole_divisor` (`RiemannRoch/RationalCurveIso.lean`
  L342) — Pin 2 wrapper body LANDED iter-183 via witness `D := poleDivisor φ`
  + `rfl` + named Tier-3 helper. **5-consec-sig-only-iter streak BROKEN.**
  Helper body deferred iter-184+.
- `Scheme.eulerCharacteristic_sheafOf_zero` (`RiemannRoch/RRFormula.lean`
  L297) — base case of RR-on-curves induction closed Tier-2 modulo
  `OcOfD.sheafOf_zero` (Lane K typed sorry) +
  `Scheme.finrank_H0_toModuleKSheaf_eq_one` (new Lane H helper A).
- `Scheme.eulerCharacteristic_sheafOf_single_add` (`RiemannRoch/RRFormula.lean`
  L323) — inductive step closed Tier-2 via `Int.induction_on` 3-case +
  `Finsupp.single_add` + `_succ` helper.
- `iotaGm_isOpenImmersion` (`AbelianVarietyRigidity.lean` L283) — parent
  body sorry-FREE iter-183 via `Over.lift_left` + `← Cover.ι_glueMorphisms` +
  2 named Tier-3 sub-task helpers. Auxiliary `iotaGm_inner_lift_compat`
  + `iotaGm_chart1_section` axiom-clean.
- `ext_smul_eq_zero_of_mem_annihilator` (`Albanese/AuslanderBuchsbaum.lean`
  L229) — Stacks 00LP "x annihilates Ext^*" axiom-clean, generalised.
  ~25 LOC via `mk₀_smul + smul_comp + mk₀_id_comp` chain.
- `pullback_iso_construction` body (`Picard/RelativeSpec.lean`) —
  bare sorry replaced by 5-helper structured proof iter-183;
  3 axiom-clean (`pullback_iso_affine_piece`,
  `pullback_cocone_desc_comp_fst`, `pullback_iso_desc_isIso` iSup branch);
  2 Tier-3 helpers remaining (iter-184 Lane D target).

## iter-184 plan-phase activities (NOT closures; for log continuity)

- `mathlib-analogist gmscaling-projection-idiom` — Lane B CHURNING
  corrective; consult-driven recipe gate for iter-184 Lane B re-fire.
- `blueprint-writer pic0-identity-component-chapter` — A.3 unstarted
  phase coverage (must-fix-this-iter from iter-183 reviewer).
- Blueprint `RiemannRoch_RRFormula.tex` `\uses{}` blocks fixed (3 \leanok
  tokens moved out of `\uses{...}` arguments per iter-183 doctor finding).
- STRATEGY.md row `A.1.a — RelativeSpec` revised: `Iters left` `~6–10`
  → `~3–6` per progress-critic OVER_BUDGET finding (14 elapsed against
  original 6–10; 5-helper structured proof has reduced remaining LOC
  band to ~100–250).

## iter-184 prover-phase closures

- `RingTheory.Module.depth_eq_smallest_ext_index`
  (`Albanese/AuslanderBuchsbaum.lean`, inductive step at L295) — both
  named residuals (forward L366, backward L431) closed Tier-1 axiom-clean
  via shared LES-of-Ext chase on `IsSMulRegular.smulShortComplex_shortExact`
  SES + `ext_smul_eq_zero_of_mem_annihilator`. Helper budget 0/2 (HARD BAR met).
- `RingTheory.Module.depth_of_short_exact` — propagated kernel-clean by
  the iter-184 closure of `depth_eq_smallest_ext_index` (transitive via
  `ext_vanish_of_natCast_lt_depth`); no new code.
- `AlgebraicGeometry.iotaGm_onePt_chart1_factor`
  (`AbelianVarietyRigidity.lean` L105) — AVR Lane E sub-task (b) closed
  Tier-1 axiom-clean iter-184; 13 LOC body via `IsOpenImmersion.lift_fac`
  + `Proj.opensRange_awayι` + `Proj.fromOfGlobalSections_preimage_basicOpen`
  + `Scheme.basicOpen_of_isUnit`. Helper budget 0/0 (HARD BAR met).
- `pullback_map_fst_proj` / `pullback_map_snd_proj`
  (`Genus0BaseObjects/GmScaling.lean` Recipe 1) — 2 globally-active
  `@[reassoc (attr := simp)]` simp helpers landed Tier-1 axiom-clean
  iter-184; fills the missing-Mathlib-simp gap on `pullback.map ≫ pullback.fst/snd`.
- `hreg_dim` Krull-dim half (`Albanese/CodimOneExtension.lean` L254;
  structured sub-proof, not a top-level declaration) — closed iter-184
  Tier-1 axiom-clean as `rw [Scheme.ringKrullDim_stalk_eq_coheight];
  exact_mod_cast _hz` via the iter-183 CoheightBridge import. The
  `IsRegularLocalRing` half remains as Stacks 00TT typed sorry
  (iter-185+ blueprint expansion gated).

## Iter-186 closures (axiom-clean)

- `AlgebraicGeometry.Scheme.LineBundle.OnProduct`
  (`Picard/LineBundlePullback.lean` L118) — Lane A.1.b SUCCESS iter-186;
  carrier `(Limits.pullback πC πT).Modules` (axiom-clean, `@[reducible]`).
  iter-187+ refinement: pair with `IsInvertible` witness.
- `AlgebraicGeometry.Scheme.LineBundle.pullbackAlongProjection`
  (`Picard/LineBundlePullback.lean` L146) — Lane A.1.b SUCCESS iter-186;
  direct `Scheme.Modules.pullback` application, axiom-clean.
- `AlgebraicGeometry.Scheme.LineBundle.pullback_pullback_eq`
  (`Picard/LineBundlePullback.lean` L201) — Lane A.1.b SUCCESS iter-186;
  3-iso chain via `pullbackComp` + `pullbackCongr` + `pullbackComp.symm`,
  axiom-clean.
- `AlgebraicGeometry.Scheme.RelPicPresheaf.preimage_subgroup`
  (`Picard/LineBundlePullback.lean` L271) — Lane A.1.b SUCCESS iter-186;
  iso-class setoid, axiom-clean. iter-187+ refinement: full
  `L ⊗ L'⁻¹ ∈ image (pullback projection)` quotient.
- `AlgebraicGeometry.Scheme.RelPicPresheaf.functorial`
  (`Picard/LineBundlePullback.lean` L322) — Lane A.1.b SUCCESS iter-186;
  `Quotient.lift` on lifted base-change pullback, axiom-clean.
- `RingTheory.CohenMacaulay.regularLocal_inductive_step` (R⧸(x) bridge
  inline sorry, `Albanese/AuslanderBuchsbaum.lean` L1094) — Lane G SUCCESS
  iter-186; closed axiom-clean modulo the L975 substrate-helper
  (`exists_isSMulRegular_quotient_isRegularLocal_succ`) typed sorry. The
  `regularLocal_inductive_step` is now functionally complete; closing
  L975 transitively closes `regularLocal_inductive_step`,
  `exists_isRegular_of_regularLocal`, and `CohenMacaulay.of_regular`.
- `lineBundleAtClosedPoint.carrierSubmodule.{zero_mem',add_mem',smul_mem'}`
  (`RiemannRoch/OCofP.lean` L263, L268, L295) — Lane A SUCCESS iter-186;
  3 of 3 closure sorries closed axiom-clean. zero_mem' via
  `WithZero.log_zero`; add_mem' via `Ring.ordFrac_add` (DVR-shipped post
  iter-186 Step 1 IsDiscreteValuationRing upgrade) + `WithZero.log_le_log`
  monotonicity; smul_mem' via `Ring.ordFrac_ge_one_of_ne_zero` on the
  algebraMap lift.
- `lineBundleAtClosedPoint.instNonemptyTopOpen` /
  `instAlgebraKbarFunctionField` (`RiemannRoch/OCofP.lean`) — Lane A
  SUCCESS iter-186; 2 instance helpers landed axiom-clean (Algebra
  bridge `kbar → Γ(⊤) → K(C)`).
- `AlgebraicGeometry.Scheme.eulerCharacteristic_iso`
  (`RiemannRoch/RRFormula.lean` L347) — Lane H SUCCESS iter-186 sub-helper
  closed Tier-1 axiom-clean (1 of 3 sub-helpers from Hartshorne IV.1
  decomposition); `LinearEquiv.ofLinear` via `Abelian.Ext.postcompOfLinear`
  + `comp_assoc_of_third_deg_zero` + `mk₀_comp_mk₀` + `Iso.hom_inv_id`
  + `comp_mk₀_id`.

- `AlgebraicGeometry.Scheme.Modules.IsLocallyTrivial` + `IsLocallyTrivial.pullback` (AlgebraicJacobian/Picard/LineBundlePullback.lean) — closed iter-188 Lane A.1.b: full-file 0 sorries axiom-clean. 7-iso chain via `restrictFunctorIsoPullback` + `pullbackComp` + `pullbackCongr` + `pullbackObjUnitToUnit` (the latter iso via `RepresentablyFlat (Opens.map f)` + `final_of_representablyFlat`, works for any scheme morphism). Kernel-only.

## Iter-189 closures

- `AlgebraicGeometry.lineBundleAtClosedPoint.carrierPresheaf_isSheaf` Case B (`RiemannRoch/OCofP.lean` L644) — closed iter-189 Lane A axiom-clean via direct irreducibility argument (`nonempty_preirreducible_inter` bridge, `map_val` inline helper) — bypassing the iter-189 refactor's `Subfunctor.isSheaf_iff` framework (which the prover inspected but didn't consume, because the carrier is ModuleCat-valued rather than Type-valued). Net file-sorry 4 → 3. Kernel-only modulo pre-existing `Scheme.RationalMap.order` substrate sorries.
- `AlgebraicGeometry.IsClosedImmersion.lift_iff_range_subset` (NEW file `Genus0BaseObjects/Cross01Substrate.lean`) — landed iter-189 Lane B axiom-clean kernel-only. Substrate 1 of the Lane B Option B project-side build per `analogies/lane-b-substrate.md` §2 (6-step Galois-connection recipe via `Scheme.Hom.support_ker` + `vanishingIdeal_support` + `IsClosedImmersion.lift`). ~80 LOC including docs. Unblocks 3 GmScaling consumer sorries iter-191+.
- `AlgebraicGeometry.Scheme.iso_of_degree_one` Step 1 (function-field iso inline, `RiemannRoch/RationalCurveIso.lean` L760) — closed iter-189 Lane I Pin 3 Step 1 axiom-clean inline (10 LOC); `Subalgebra.bot_eq_top_of_finrank_eq_one` + `Algebra.surjective_algebraMap_iff` + `RingHom.injective` + `RingEquiv.ofBijective`. Step 2 (scheme-level lift via `Scheme.Hom.toNormalization`) remains as typed sorry; iter-190+ target. Pin 2 (`Hom.poleDivisor_degree_eq_finrank`) diagnosed mathematically false-as-stated (LHS principal divisor has degree 0; RHS positive finrank) — iter-190 plan-phase committed Option (a) corrective via new `WeilDivisor.positivePart` substrate.
- `RingTheory.CohenMacaulay.exists_isSMulRegular_quotient_isRegularLocal_succ` (`Albanese/AuslanderBuchsbaum.lean`) — closed iter-189 Lane G2 axiom-clean modulo `isDomain_of_regularLocal` (pure Stacks 00NQ named substrate sorry, iter-190+ target via Option (a) project-side build). Substrate narrowed from consolidated Stacks 00NQ + 00NU to pure 00NQ. Two new axiom-clean helpers landed: `exists_notMemSq_of_spanFinrank_pos` (Nakayama-based) + `exists_isSMulRegular_notMemSq_of_regularLocal_succ`. The G1 cotangent dim-drop bridge (iter-188) vindicates the entire G2 inductive route.

## Iter-190 closures (axiom-clean / hard-bar-met)

- `AlgebraicGeometry.iotaGm_r_1_range_subset` (AlgebraicJacobian/AbelianVarietyRigidity.lean L104) — closed iter-190 axiom-clean via Attempt-2 stepwise `change` chain bridging the `↥(ProjectiveLineBar kbar).left` vs `↥(Proj 𝒜)` carrier-type defeq; transitively closes `iotaGm_r_1` def + `iotaGm_r_1_fac` axiom-clean. Lane E HARD BAR met.
- `AlgebraicGeometry.gmRing_tensor_homogeneousAway_isDomain` (AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean L129) — closed iter-190 axiom-clean (~270 LOC) via explicit `kbar`-AlgHom `φ` into a localized polynomial domain + left-inverse `ψ_ring` via `IsLocalization.Away.lift` + `IsLocalization.ringHom_ext`. Lane B Substrate 2 complete (both substrates now axiom-clean; iter-191+ consumes for 3 GmScaling closures).
- `AlgebraicGeometry.Scheme.WeilDivisor.positivePart` (NEW; AlgebraicJacobian/RiemannRoch/WeilDivisor.lean L502) — closed iter-190 axiom-clean via `Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp)`.
- `AlgebraicGeometry.Scheme.WeilDivisor.positivePart_zero` (NEW; AlgebraicJacobian/RiemannRoch/WeilDivisor.lean L507) — closed iter-190 axiom-clean.
- `isDomain_of_isLocalRing_of_spanFinrank_maximalIdeal_eq_zero` (AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean L1299) — Stacks 00NQ base case helper closed iter-190 axiom-clean.
- `regularLocal_quotient_isRegularLocal_of_notMemSq` (AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean L1323) — Stacks 00NU axiom-clean.
- `Hom.poleDivisor` body refactored to `positivePart`-wrap form per iter-190 Pin 2 corrective Option (a) (the structurally-false-as-stated branch is replaced by the positivePart of the principal divisor; iter-191 refactor `lane-i-positivepart-clash-fix` updates the consumer).

## Iter-191 closures (axiom-clean / hard-bar-met)

- **Lane I refactor `lane-i-positivepart-clash-fix`** (iter-191 plan-phase) — clash fix LANDED; `degree_positivePart_principal_eq_finrank` reshaped from existential to equation form with explicit local-parameter `t` arg; `Hom.poleDivisor_degree_eq_finrank` body consumes the public pin axiom-clean. Integration build GREEN, 10-consecutive-zero-axiom-build streak restored.
- `AlgebraicGeometry.Scheme.IsFlasque.pushforward` (AlgebraicJacobian/RiemannRoch/H1Vanishing.lean L119) — Lane H closed iter-191 axiom-clean via by-definition unfolding (2-line proof, kernel-only).
- `AlgebraicGeometry.Scheme.PrimeDivisor.closure_isIrreducible` (AlgebraicJacobian/RiemannRoch/H1Vanishing.lean L226) — Lane H closed iter-191 axiom-clean via `isIrreducible_singleton.closure` (1-line).
- `AlgebraicGeometry.Scheme.skyscraperSheaf_isFlasque` (AlgebraicJacobian/RiemannRoch/H1Vanishing.lean L250) — Lane H closed iter-191 axiom-clean via direct ModuleCat route bypassing (3) + (5); `skyscraperPresheaf_map` + `eqToHom`-`IsIso` for `P.point ∈ V`, `Subsingleton`-of-`IsZero` for `P.point ∉ V`. The strategic consequence: decls (3) `IsFlasque.constant_of_irreducible` and (5) `skyscraperSheaf_eq_pushforward_const` become OPTIONAL auxiliaries rather than critical-path substrate.
- `AlgebraicGeometry.Scheme.H1_skyscraperSheaf_finrank_eq_zero` (AlgebraicJacobian/RiemannRoch/H1Vanishing.lean L283) — Lane H chained closure iter-191; visible body sorry-free but carries inherited sorryAx via #4 `HModule_flasque_eq_zero`.
- `AlgebraicGeometry.Scheme.stalkMap_flat_of_smooth` (AlgebraicJacobian/Albanese/CodimOneExtension.lean Stage 1) — Lane M↓ closed iter-191 axiom-clean via direct `AlgebraicGeometry.Flat.stalkMap` re-export.
- `AlgebraicGeometry.Scheme.exists_isStandardSmooth_at_of_smooth` (AlgebraicJacobian/Albanese/CodimOneExtension.lean Stage 2) — Lane M↓ closed iter-191 axiom-clean via direct `AlgebraicGeometry.Smooth.exists_isStandardSmooth` re-export (Stacks 00T7).
- `AlgebraicGeometry.exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes` (AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean) — Lane G iter-191 axiom-clean helper; minimal primes ⊆ zero-divisors; key input for route (iii) closure of `notMem_minimalPrimes_of_regularLocal_succ`.
- `AlgebraicGeometry.projGm_isReduced` (AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean L793) — Lane B-consumers iter-191 closed axiom-clean via Substrate 2 + chart-local `IsReduced.of_openCover` + iso transport.
- `AlgebraicGeometry.gm_geomIrred` (AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean L808) — Lane B-consumers iter-191 closed axiom-clean via bypass route exploiting `Gm ↪ 𝔸¹` open immersion (sidesteps Substrate 2 Mathlib regression on `IsLocalization.Away` in `set` bindings). 2 new reusable helpers landed: `isDomain_mvPolyUnit_tensor`, `affineLine_geomIrred`.
- `AlgebraicGeometry.iotaGm_chart1_section` refactor + `iotaGm_chart1_composition_isOpenImmersion` refactor (AbelianVarietyRigidity.lean iter-191 Lane E Part 1) — abstract `(r_1, h_r_1)` parameters dropped; signatures specialise on `iotaGm_r_1` / `iotaGm_r_1_fac`. Part 1 HARD BAR met; Part 2 body close deferred at 80 LOC budget wall (same `Proj.appIso` residual STUCK iter-188/189/190).

## Iter-192 closures (axiom-clean / hard-bar-met)

- `AlgebraicGeometry.notMem_minimalPrimes_of_regularLocal_succ` (AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean L1555) — Lane G closed iter-192 axiom-clean via PRIME-AVOIDANCE (`Ideal.subset_union_prime_finite` to pick `x' ∈ 𝔪 \ (𝔪² ∪ ⋃ minimalPrimes R)`; `hIH` on `R/(x')`; Nakayama `Submodule.FG.eq_bot_of_le_jacobson_smul` + `IsDomain.of_bot_isPrime` + `Ideal.minimalPrimes_eq_subsingleton_self`). The PROGRESS.md route (iii) Krull-intersection sketch (`y = x^m·z`) was empirically FALSIFIED inside the proof — `x̄ = 0` in `R/(x)` makes the supposed contradiction trivially true. Stacks 00NQ chain now kernel-clean end-to-end (notMem + isDomain + exists_isSMulRegular_notMemSq + exists_isSMulRegular_quotient + regularLocal_inductive_step + exists_isRegular_of_regularLocal + CohenMacaulay.of_regular). AB 2 → 1 (−1).
- `AlgebraicGeometry.pullback_of_openImmersion_iso_restrict` (AlgebraicJacobian/Picard/QuotScheme.lean L650) — Lane F closed iter-192 axiom-clean via the analogist `lane-f-restrictscalars-smul` aliasing-`set`/`change` recipe verbatim: `set y` for instance-scope binding of Y-side action; `change` for restrict_obj rfl-unfold; `Scheme.Modules.map_smul` to migrate scalar; key identity `(ΓSpecIso _).inv ≫ (hU.fromSpec.appIso ⊤).inv ≫ Y.presheaf.map _ = 𝟙` via `Scheme.Hom.appLE_appIso_inv` + `IsAffineOpen.fromSpec_app_self`. ~50 LOC; 0 of 2 helpers consumed. QuotScheme 13 → 12 (−1).
- `AlgebraicGeometry.Scheme.H1_skyscraperSheaf_finrank_eq_zero` import resolution (AlgebraicJacobian/RiemannRoch/RRFormula.lean) — Lane RRF closed iter-192 axiom-clean by `import AlgebraicJacobian.RiemannRoch.H1Vanishing` + deletion of the local `private theorem` shadow (`private` controls visibility, NOT namespace registration — full-qualified-name collision). The consumer `Scheme.eulerCharacteristic_skyscraperSheaf` now resolves to the public iter-191 declaration directly. RRF 2 → 1 (−1). New Project Status KB entry: `private` modifier semantics in Lean 4.
- `AlgebraicGeometry.Scheme.HModule_injective_finrank_eq_zero` (AlgebraicJacobian/RiemannRoch/H1Vanishing.lean L170) — Lane H helper iter-192 axiom-clean via `HasInjectiveDimensionLT.subsingleton 1 i hi _` + `Module.finrank_zero_of_subsingleton`.
- `AlgebraicGeometry.Scheme.injectiveSES` def + `injectiveSES_shortExact` theorem (AlgebraicJacobian/RiemannRoch/H1Vanishing.lean L188+L196) — Lane H helpers iter-192 axiom-clean (canonical injective-embedding SES `F → Injective.under F → cokernel(Injective.ι F)`).
- `AlgebraicGeometry.Scheme.ext_one_eq_zero_of_hom_surjective_of_injective` (AlgebraicJacobian/RiemannRoch/H1Vanishing.lean L224) — Lane H generic abelian-category helper iter-192 axiom-clean via `HasInjectiveDimensionLT.subsingleton` + `Abelian.Ext.covariant_sequence_exact₁` + `Abelian.Ext.addEquiv₀`.
- `AlgebraicGeometry.Scheme.exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth` (AlgebraicJacobian/Albanese/CodimOneExtension.lean L260) — Lane M↓ Stage 3 iter-192 axiom-clean composing Stage 2 + `RingHom.IsStandardSmooth.toAlgebra` + `IsAffineOpen.isLocalization_stalk`.
- `AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_of_isStandardSmooth` (AlgebraicJacobian/Albanese/CodimOneExtension.lean L294) — Lane M↓ Stage 4 iter-192 axiom-clean re-exporting `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential` + `Module.Free.of_basis`.
- `AlgebraicGeometry.iotaGm_chart1_appIso_eval` (NEW; AlgebraicJacobian/AbelianVarietyRigidity.lean L256) — Lane E iter-192 blueprint-named hook introduced; consumer body of `iotaGm_chart1_composition_isOpenImmersion` is now sorry-free (uses helper via `rw`). Helper body retains the residual `Proj.appIso` evaluation sorry; relocated, not closed.
- `AlgebraicGeometry.IdentityComponent.identityComponentCarrier_connectedSpace` + `identityComponent_connectedSpace` (AlgebraicJacobian/Picard/IdentityComponent.lean ~L350+L370) — Lane A.3.i iter-192 instances axiom-clean via `Subtype.preconnectedSpace` + explicit witness + `change`/`infer_instance`.
- `AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_eq_sum_max` (AlgebraicJacobian/RiemannRoch/WeilDivisor.lean L539) — Lane I iter-192 axiom-clean helper via `Finsupp.sum_mapRange_index`; reduces `degree (positivePart D)` to explicit `D.sum (fun _ n => max n 0)`.
- `AlgebraicGeometry.Scheme.WeilDivisor.rationalMap_order_finite_support` `f = 0` branch (AlgebraicJacobian/RiemannRoch/WeilDivisor.lean L226) — Lane I iter-192 axiom-clean (trivial — `order Y 0 = 0` ⟹ empty support).
- `AlgebraicGeometry.Scheme.RationalCurveIso.LocallyOfFiniteType` instance for `φ.left` — Lane RCI iter-192 axiom-clean via `IsProper.toLocallyOfFiniteType`; narrows Pin 3 Step 2 sub-step (a) to `IsAffineHom φ.left` only.

## Iter-202 closures (axiom-clean / hard-bar-met)

- `RingTheory.auslander_buchsbaum_formula_succ_pd` body + `RingTheory.auslander_buchsbaum_formula` (AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean) — **Lane AB closed iter-202 axiom-clean**, ending the 16+-iter gap. `induction k generalizing M`: inductive step via `projectiveDimension_ker_eq_of_surjection` + `depth_ses_ineqs_of_surjection_finite_localRing` + `enat_ab_inductive_combine`; base case `pd=1` via matrix-collapse (`ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator`) + LES + `exists_ne_zero_ext_of_depth_eq`. **Stacks 00MF OBVIATED** (Path B). 4 new helpers axiom-clean. AB file 1 → 0. The 3 `private` removals landed: `_succ_pd`, `RingTheory.CohenMacaulay.isDomain_of_regularLocal` (L2657), `RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq` (L2293) — **NOTE the `CohenMacaulay` namespace** for cross-file COE consumption.
- `AlgebraicGeometry.Scheme.PrimeDivisor.functionFieldIso_compat` + `order_eq_order_restrict` (AlgebraicJacobian/RiemannRoch/WeilDivisor.lean L572/L603) — **Lane WD Sub-build 3 closed iter-202 axiom-clean** (HARD BAR = both). Morphism-level `stalkIso`/`stalkSpecializes`/`functionFieldIso` compatibility via germ-chase (`stalk_hom_ext` + `germ_stalkSpecializes`); `order_eq_order_restrict` discharges `h_compat` of `ordFrac_stalkIso_naturality`. Open-chart naturality of `Scheme.RationalMap.order`. Blueprint pins added iter-203 (`lem:functionFieldIso_compat`, `lem:order_eq_order_restrict`).
- `exists_submersivePresentation_of_isStandardSmoothOfRelativeDimension` (B.a), `isLocalization_atPrime_stalk_of_affineOpen` (B.b, public), `open_eq_top_of_subsingleton` + `gammaSpecField_ringEquiv` (B.c, public) (AlgebraicJacobian/Albanese/CodimOneExtension.lean §3.B ~L994-1040) — **Lane COE Step B bridges iter-202 axiom-clean** (3 of 4; HARD BAR ≥2 exceeded). B.d (regular-stalk close) NOT added — gated on Step A1 (now unblocked iter-203) + Stage 6.A capstone (Stacks 00OE, still MISSING).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (NEW FILE) — **Lane TS scaffold iter-202 GREEN**: 4 blueprint-pinned typed-sorry stubs (`tensorObj`, `tensorObj_functoriality`, `monoidalCategory`, `addCommGroup_via_tensorObj`) + 2 supporting + 1 bodied (`tensorObjOnProduct`); import in `AlgebraicJacobian.lean`. `addCommGroup_via_tensorObj` is a `def` not `instance` (diamond avoidance). +6 typed-sorry stubs **by design** (body-fill work-list, not debt).

- `PresheafOfModules.restrictScalarsLaxMonoidal` (+ `restrictScalarsLaxε`, `restrictScalarsLaxμ`) (AlgebraicJacobian/Picard/TensorObjSubstrate.lean L114–L147) — closed iter-207: sectionwise lift of `ModuleCat.instLaxMonoidalRestrictScalars`; blueprint `lem:restrictscalars_laxmonoidal`; axiom-clean (kernel-only). NOTE: off the critical path as of iter-208 — the TS iso re-routed to Route A (open-immersion sectionwise base change), which does not consume this instance. Retained as reusable CommRingCat-level lax-monoidal supplement.

- `PresheafOfModules.W_whiskerLeft_of_flat` (the ⊗-group-law **go/no-go GATE**) + `AlgebraicGeometry.Scheme.Modules.IsInvertible`, `tensorObj_left_unitor`, `tensorObj_right_unitor`, `tensorObj_braiding` (AlgebraicJacobian/Picard/TensorObjSubstrate.lean) — **Lane TS gate CLEARED iter-211 axiom-clean** (`lean_verify`: `propext`/`Classical.choice`/`Quot.sound` only — NO `sorryAx`). The flat-exactness whiskerLeft realization (2) is confirmed buildable from present Mathlib; the `MonoidalClosed`/strong-monoidal-pushforward reversal trigger did NOT fire. Blueprint `lem:flat_whisker_localizer` (`\lean{}` corrected to the `PresheafOfModules` namespace), `def:scheme_modules_isinvertible`, `lem:tensorobj_unit_iso`, `lem:tensorobj_comm_iso`. Plus a Mathlib-bump bug fix (`isLocallyInjective_whiskerLeft_of_flat`, `erw [TensorProduct.tmul_zero]; rfl`). Lane continues: `tensorObj_assoc_iso` (associator) scaffolded with residual = the sheafification-localization bridge `isIso_sheafification_map_of_W`; `tensorObjIsoclassCommMonoid` follows — both tracked in `task_pending.md`.

- `PresheafOfModules.isIso_sheafification_map_of_W` (the sheafification-localization bridge / iter-212 designated go/no-go) + `PresheafOfModules.W_whiskerRight_of_flat` (braiding-conjugate of `W_whiskerLeft_of_flat`) (AlgebraicJacobian/Picard/TensorObjSubstrate.lean L373/L348) — **closed iter-212 axiom-clean** (`lean_verify`: `propext`/`Classical.choice`/`Quot.sound` only — NO `sorryAx`). Bridge = Mathlib's `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` read at one morphism (sheafification IS the localization at `J.W.inverseImage (toPresheaf _)`); 3-line proof, the `[expected]` localization characterisation is genuinely present in Mathlib. The reversal trigger as worded (bridge bottoming out in absent Mathlib) did NOT fire. **BUT the associator `tensorObj_assoc_iso` did NOT close** — iter-212 located a NEW, confirmed blueprint gap one level below: the 3-step composite feeds `W_whisker{Left,Right}_of_flat` with `F = M.val/P.val`, requiring sectionwise flatness `[∀ U, Module.Flat (𝒪_X(U)) (M.val U)]` over ALL opens, which is FALSE for non-affine opens and NOT derivable from `IsInvertible` (independently confirmed by lean-vs-blueprint-checker ts212). Neither `W_whiskerRight_of_flat` nor the bridge is blueprint-`\lean{}`-pinned yet (writer owes pins). See `memory/ts-assoc-flatness-gap.md`.

## Iter-213 closures (axiom-clean / hard-bar-met)

- `PresheafOfModules.W_whiskerLeft_of_W` + `PresheafOfModules.W_whiskerRight_of_W` (AlgebraicJacobian/Picard/TensorObjSubstrate.lean L427/L440) — **closed iter-213 axiom-clean** (flatness-free ROUTE (d) replacements for the `_of_flat` whisker lemmas): `J.W (toPresheaf g) → J.W (toPresheaf (F ◁ g))` for ARBITRARY `F`; surjectivity free via `isLocallySurjective_whiskerLeft`, injectivity delegated to the residual `isLocallyInjective_whiskerLeft_of_W`. NOTE: route reframed iter-214 → these are the `whiskerLeft`/`whiskerRight` data of the Mathlib `MorphismProperty.IsMonoidal (J.W)` instance (route (e)).
- `AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso` (AlgebraicJacobian/Picard/TensorObjSubstrate.lean L659) — **ASSEMBLED iter-213** into a complete compiling 3-step composite (no top-level sorry in its own body; transitively sorry via the one residual). `lean_verify`: `{propext, sorryAx, Classical.choice, Quot.sound}` — sorryAx from the residual only, NO project axioms. iter-212 `X.ringCatSheaf.val` defeq friction RESOLVED (`rfl` + `inferInstanceAs`). NOTE: iter-214 supersedes this hand-assembly — the associator is to be obtained from Mathlib `Localization.Monoidal.LocalizedMonoidal` once `(J.W).IsMonoidal` lands (route (e)); the hand-composite was a useful waypoint but is not the end-state construction.

## Iter-215 closures (axiom-clean)

- `restrictScalarsRingIsoTensorEquiv` (AlgebraicJacobian/Picard/TensorObjSubstrate.lean, top of file) — **closed iter-215 axiom-clean** (`lean_verify`: `propext`/`Quot.sound` only — NO `sorryAx`). Base change of modules along a ring iso `e:R≃+*S` commutes with ⊗ (`a⊗ₜ[R]b ↦ a⊗ₜ[S]b` is an R-linear equiv) — i.e. the **H2 "REAL bottom gap"** of the linchpin `tensorObj_restrict_iso` (strong-monoidal `restrictScalars` along a ring iso; Mathlib-absent). KEY TRICK: inverse via `TensorProduct.liftAddHom` + manual R-linearity (an S-linear lift hits `SMulCommClass`/`CompatibleSMul` synth failures); right-inverse via `LinearMap.ext` + `induction_on`. Reduces `tensorObj_restrict_iso`'s residual to H1 alone (presheaf `pushforwardPushforwardAdj`). Blueprint pin owed (`\lean{restrictScalarsRingIsoTensorEquiv}`, added by writer ts216).
- **iter-216 substrate advance (no sorry closed; H2 ModuleCat core + make-or-break)** (AlgebraicJacobian/Picard/TensorObjSubstrate.lean, `RestrictScalarsRingIsoTensor` section) — 6 axiom-clean decls (`restrictScalars_isIso_μ`/`_ε`, `restrictScalarsMonoidalOfRingEquiv`, `restrictScalars_isIso_{μ,ε}_of_bijective`, `restrictScalarsRingIsoTensorEquiv_apply_tmul`); `restrictScalars_isIso_μ` verified `{propext, Classical.choice, Quot.sound}`. Closes the **ModuleCat-level H2 core** (strong-monoidal `restrictScalars` along a ring iso). **MAKE-OR-BREAK RESOLVED NEGATIVE:** the consumer `tensorObj_isLocallyTrivial` applies `tensorObj_restrict_iso W.ι M N` to ARBITRARY `M N` (restrict commuted past the sheafified tensor before triviality used), so the free-cover shortcut does NOT exist — **H1 (presheaf `pushforwardPushforwardAdj`) is genuinely on the critical path.** Pinned in blueprint as `lem:restrictscalars_ringiso_strongmonoidal` (writer ts217). See `analogies/ts217.md` (H1 de-risked: ~70–90 LOC, `pullbackPushforwardAdjunction` exists).
- `AlgebraicGeometry.pushforwardBaseChangeMap` (AlgebraicJacobian/Cohomology/FlatBaseChange.lean) — closed iter-232 (built axiom-clean); WIRED into the aggregator iter-233 (import added; canonical build green, sorry 81→83 as FlatBaseChange's 2 honest sorries are now counted). The canonical base-change map g^*(f_*F)⟶f'_*(g'^*F) (Stacks 02KH, i=0). kernel-only {propext, Classical.choice, Quot.sound}.

## Iter-233 closures (axiom-clean infrastructure; no canonical sorry eliminated)

- `PresheafOfModules.stalkTensorDesc` (+ `stalkTensorBilin`, `stalkTensorBilin_balanced`, `stalkTensorDescU`, `stalkTensorDescU_tmul`, `germ_stalkTensorDesc`, `stalkTensorDesc_germ_tmul`) (AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean, NEW file) — **closed iter-233, 7 decls axiom-clean** {propext, Classical.choice, Quot.sound}. The d.2 FORWARD comparison map `(A⊗ᵖB).stalk x ⟶ A_x⊗_{R_x}B_x` (germ_U(a⊗b)↦germ a⊗germ b), stages (i)–(ii) of `lem:stalk_tensor_commutation`. The full iso `stalkTensorIso` NOT yet built (stages iii–v). Blueprint pin `lem:stalk_tensor_desc_forward` added iter-234. WIRED into the aggregator iter-234 (refactor `wire-stalktensor`; build green, 0 new sorries).
- `AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map`, `isIso_of_isIso_app_of_isBasis`, `isIso_iff_isIso_app_affineOpens` (AlgebraicJacobian/Cohomology/FlatBaseChange.lean) — **closed iter-233, 3 decls axiom-clean** {propext, Classical.choice, Quot.sound}. Stalk/basis/affine-open iso-locality criteria for `Scheme.Modules` morphisms; first reduction of `affineBaseChange_pushforward_iso`. Blueprint pins (`lem:modules_isIso_*`) added iter-234.
- `AlgebraicGeometry.higherDirectImage` (AlgebraicJacobian/Cohomology/HigherDirectImage.lean, NEW file) — **closed iter-233 no-sorry**, conditional on `[HasInjectiveResolutions X.Modules]` (honest hypothesis; `EnoughInjectives X.Modules` is Mathlib-absent for SheafOfModules). `def:higher_direct_image := ((pushforward f).rightDerived i).obj F`. The 3 sibling theorems remain honest sorries (Gaps 1–3: explicit Rⁱf_*=sheafify description, relative Mayer–Vietoris, Čech spectral sequences).

## Iter-234 closures (axiom-clean infrastructure; no canonical sorry eliminated)

- `PresheafOfModules.stalkTensorLinearMap` (+ `stalkTensorDescU_smul`, `stalkTensorDesc_germ`, `stalkTensorLinearMap_germ_tmul`) (AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean) — **closed iter-234, 4 decls axiom-clean** {propext, Classical.choice, Quot.sound}. The d.2 STAGE (iii): the `R.stalk x`-linear repackaging of the forward comparison map `(A⊗ᵖB).stalk x →ₗ[R.stalk x] A_x⊗_{R_x}B_x` (the iter-234 binary convergence probe — MET). The named carrier-duality obstacle (CommRingCat `R(U)` scalar vs RingCat-carrier section-tensor module) was identified AND resolved via the `erw`/defeq recipe (`stalkTensorDescU_smul` by `TensorProduct.induction_on`; `rw [smul_tmul']` FAILS on instance synth — defeq via `erw` instead). Blueprint pin `lem:stalk_tensor_linear_map` added iter-235. Stages (iv) reverse map + (v) bundle `stalkTensorIso` remain.

## Iter-235 closures (axiom-clean infrastructure; no canonical sorry eliminated)

- d.2 STAGE (iv) reverse-map descent — **10 `private` decls axiom-clean** {propext, Classical.choice, Quot.sound} (AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean): `revInnerLeg`, `revInnerLeg_apply`, `revInner`, `germ_revInner`, `revInner_germ`, `revOuterLeg`, `revOuterLeg_apply`, `revBihom`, `germ_revBihom`, `revBihom_germ_tmul`. The WHOLE nested double-colimit reverse descent `A_x→+(B_x→+(A⊗ᵖB).stalk x)`, `(germ a, germ b)↦germ_{U⊓V}(a|⊗b|)`. lean-auditor ts235 confirmed all 10 genuine non-vacuous constructions (substantive cocone-naturality sub-proofs via germ_res + tensorObj_map_tmul + Functor.map_comp + poset thinness); NOT helper-churn. 0 sorries. Built as the directed unit per the iter-234 no-fragmentation gate. SOLE residual = the `R_x`-balancing `revBihom_balanced` (→ `stalkTensorRev` via `TensorProduct.liftAddHom`), documented as an in-file COMMENT (not a sorry) — the carrier-duality wall resurfaced at the balancing (an extra `restrictScalars` wrapper from `map_smul` vs the stage-(iii) section recipe). Next route (handoff): prove balancing at the STALK level via `germ_smul` (scalar stays at R_x). Then stage (v) `stalkTensorIso`.

## Iter-239 closures (axiom-clean infrastructure; no canonical sorry eliminated)

- `PresheafOfModules.sheafifyTensorUnitIso` (private, AlgebraicJacobian/Picard/TensorObjSubstrate.lean ~L884) — **closed iter-239 axiom-clean** {propext, Classical.choice, Quot.sound}. "Sheafification is monoidal up to the unit" reconciliation brick: `a(P⊗ₚQ) ≅ a((aP).val ⊗ₚ (aQ).val)`, via whiskering the sheafification unit `η` (a `J.W`-map) on each side (`W_whisker{Right,Left}_of_W`) + `isIso_sheafification_map_of_W`. The eventual RHS reconciliation for `pullbackTensorIso`. Private, not blueprint-pinned (correct).

- `AlgebraicGeometry.gammaPushforwardIsoAt` (AlgebraicJacobian/Cohomology/FlatBaseChange.lean) — **closed iter-239 axiom-clean** {propext, Classical.choice, Quot.sound}. Open-indexed generalization of `gammaPushforwardIso`: `Γ((Spec φ)_* N, U) ≅ restrictScalars φ (Γ(N, (Spec φ)⁻¹ U))` for ANY open `U` (blueprint movement (1) `e_{D(a)}`). Proof = `gammaPushforwardIso`'s body with `op ⊤ → op U` (modulesSpecToSheaf restricts scalars uniformly at the top open). Blueprint pin owed (`\lean{gammaPushforwardIsoAt}`, generalizes `lem:gammaPushforwardIso`).

- `AlgebraicGeometry.tildeRestriction_isLocalizedModule` (AlgebraicJacobian/Cohomology/FlatBaseChange.lean) — **closed iter-239 axiom-clean** {propext, Classical.choice, Quot.sound}. The `R'`-side input: the tilde restriction `Γ(M^~,⊤)→Γ(M^~,D(b))` (in `ModuleCat R'`) is `IsLocalizedModule (powers b)`. Via `tilde.toOpen ⊤` localization-at-`powers 1` + `tilde.toOpen_res` triangle + `LinearEquiv.eq_comp_toLinearMap_symm` + `of_linearEquiv_right`.

- `AlgebraicGeometry.pushforward_spec_tilde_iso` (AlgebraicJacobian/Cohomology/FlatBaseChange.lean ~L535) — REALIZED iter-239 (the `\lean{}` pin was previously dangling) but NOT axiom-clean: body reduces (via `pushforward_spec_tilde_iso_of_isLocalizedModule`) to a typed `sorry` at `hloc(a)` (the Module-R carrier wall, 4th recurrence). NOT a closure — listed here only to record the pin↔decl realization. The `hloc` discharge is the open work; route pivot under consideration (mathlib-analogist fbc-qc, iter-240).

## Iter-241–242 closures (Lane A + Lane B)

- `AlgebraicGeometry.Scheme.Modules.pullbackUnitIso` (TensorObjSubstrate.lean) — **closed iter-241 axiom-clean** {propext, Classical.choice, Quot.sound}. Phase-1 PRIMARY of `IsInvertible.pullback`: `f^*𝒪_X ≅ 𝒪_Y` for ALL `f` (no chart-chase — `pullbackObjUnitToUnit` iso for every `f` by representable flatness `final_of_representablyFlat` + `instIsIsoPullbackObjUnitToUnitOfFinal`). Blueprint `lem:pullback_unit_iso`.
- `AlgebraicGeometry.pushforward_spec_tilde_iso` (FlatBaseChange.lean) — **closed iter-241 axiom-clean** (sorry 3→2). The 4-iter `Module.compHom`/`hsq` carrier wall broken via `eqToIso`→`(restrictScalarsCongr hcomp).app SecN` + `ext x; rfl`. Blueprint `lem:pushforward_spec_tilde_iso`.
- `AlgebraicGeometry.pullback_spec_tilde_iso` + `gammaPushforwardNatIso` (FlatBaseChange.lean) — **closed iter-242 axiom-clean**. Lane B TARGET 1 (Stacks 01I9 pt 1): `(Spec φ)^* M̃ ≅ (R'⊗_R M)~` via uniqueness-of-left-adjoints (`conjugateIsoEquiv`, identifying the two right adjoints by `gammaPushforwardNatIso`). Affine push+pull dictionary now complete. Blueprint `lem:pullback_spec_tilde_iso` (+ `lem:gammaPushforwardNatIso` pin added iter-243).
- `presheafPushforwardLaxMonoidal` + `presheafPullbackOplaxMonoidal` (TensorObjSubstrate.lean) — **closed iter-242 axiom-clean**. The presheaf-level lax pushforward (`μ`) + the canonical comparison MAP `δ : f^*(A⊗B) ⟶ f^*A ⊗ f^*B` (via `Adjunction.leftAdjointOplaxMonoidal`). REFUTES the prior "no `pushforward.LaxMonoidal`" belief. `δ` is only a MAP; iso-ness is the open content → consumed by the iter-243 local-trivialization pivot. Blueprint pins `lem:presheaf_pushforward_laxmonoidal` / `lem:presheaf_pullback_oplaxmonoidal` (added iter-243).

## Iter-243 closures (axiom-clean infrastructure; no canonical sorry eliminated)

- `AlgebraicGeometry.Scheme.Modules.pullbackTensorMap` (= δ_sheaf) + `pullbackValIso` (TensorObjSubstrate.lean ~L1217/L1204) — **closed iter-243 axiom-clean** {propext, Classical.choice, Quot.sound}. The sheaf-level comparison MAP `f^*(M⊗N) ⟶ f^*M ⊗ f^*N` for GENERAL M,N (a MAP, not yet iso), 4-step composite: `sheafificationCompPullback` + `a_Y.map δ` (presheaf oplax, via the `φ'` let-coercion fixing the CommRingCat/RingCat monoidal-instance disambiguation) + `sheafifyTensorUnitIso` + `pullbackValIso`. Blueprint `lem:pullback_tensor_map`. Lane B (FlatBaseChange) iter-243: 0 decls (attempted `pushforwardBaseChangeMap_naturality`, hit the SheafOfModules functor-`.map`-of-composite defeq wall, removed; both affine-close obligations confirmed Mathlib-scale).

## Iter-244 closures (axiom-clean infrastructure; no canonical sorry eliminated)

- **D1 of the committed strong-monoidal pullback build — 7 axiom-clean decls** {propext, Classical.choice, Quot.sound} (AlgebraicJacobian/Picard/TensorObjSubstrate.lean, `section PullbackLanDecomposition`, ~L1237–1298): `pullback0` (def, `(pushforward₀ F R).leftAdjoint`), `extendScalars` (def, `(restrictScalars φ).leftAdjoint`), `pullback0Adjunction`, `extendScalarsAdjunction`, `pushforward₀IsRightAdjoint` (private), `restrictScalarsIsRightAdjoint` (private), and **`pullbackLanDecomposition`** (def, D1) = the functorial iso `pullback φ ≅ extendScalars φ ⋙ pullback0 F R`. Proof: left-adjoint reversal of the *definitional* `pushforward φ = pushforward₀ ⋙ restrictScalars φ` (Mathlib Pushforward.lean:86) via `Adjunction.leftAdjointCompIso`. KEY enabling discovery: `restrictScalars (𝟙 R) ≡ 𝟭` defeq ⇒ `pushforward₀`/`restrictScalars` are right adjoints via the general `pushforward.IsRightAdjoint` instance. Blueprint `lem:pullback_lan_decomposition` (pin added by review iter-244). lean-auditor ts244 + lean-vs-blueprint ts244 both confirm honest signatures, axiom-clean, sketch-matched. Secondary cleanup also landed (no proof risk): `tensorObj_assoc_iso` docstring de-staled (unconditional ROUTE (d)); file-header `isLocallyInjective_whiskerLeft_of_W` stale-residual claim removed.

## Iter-247 closures

- **Lane TS (TensorObjSubstrate.lean) — 2 axiom-clean decls** {propext, Classical.choice, Quot.sound}:
  `presheafUnit_comp_map_eta` (~L1495, presheaf-side unit mate identity via
  `Adjunction.unit_app_unit_comp_map_η`) + `isIso_sheafifyEta_of_unitSquare` (~L1518, IsIso plumbing
  reducing the η-bridge to the single "unit square" equation `hsq`). D2' now reduces UNCONDITIONALLY to
  the unit square; a paper-complete 7-step mate-telescope recipe was captured (each step a named existing
  Mathlib lemma) but NOT encoded (no sorry pin). Canonical sorry 1→1. progress-critic ts248 = **TS STUCK**
  (5 PARTIALs / 0 critical-path closures / recurring "recipe complete, can't encode within budget").
- **Lane RPF (RelPicFunctor.lean) — local sorry 4 → 0** (1 cone, upstream): the iter-246 import cycle was
  broken (iter-247 refactor); all 4 local typed-sorry bridges rewired to upstream substrate
  (`tensorObj_isLocallyTrivial`, `tensorObj_assoc_iso`, `exists_tensorObj_inverse`) or deleted; the 5
  local pure-Mathlib substrate copies removed (~10 use sites retargeted). `isLocallyTrivial_unit` closed
  with a REAL axiom-clean proof (`restrictFunctorIsoPullback ≪≫ pullbackUnitIso`). `addCommGroup` now a
  real construction whose only `sorryAx` is the upstream `exists_tensorObj_inverse`. progress-critic
  ts248 = **RPF CONVERGING**. `functorial`/`PicSharp` real body genuinely gated on Lane TS D4'.

## Iter-251–252 closures (Lane TS-cmp + Lane TS-inv; axiom-clean infrastructure; no canonical sorry eliminated)

- **Lane TS-cmp (TensorObjSubstrate.lean) iter-251 — 2 axiom-clean decls** {propext, Classical.choice, Quot.sound}: `pullbackValIso_hom_natural` (D1′ square 4, naturality of the `pullbackValIso` comparison) + `sheafifyTensorUnitIso_hom_eq` (`:= rfl` carrier-normalisation brick). D1′ `pullbackTensorMap_natural` AUTHORED (4-square paste, gated). Blueprint pins `lem:pullback_val_iso_natural` (added bw253).
- **Lane TS-inv (DualInverse.lean) iter-251 — 4 axiom-clean decls** {propext, Classical.choice, Quot.sound}: the dual-unit leg — `unitDualSectionEquiv`, `dualUnitIsoGen`, `presheafDualUnitIso`, `dual_unit_iso` (`dual 𝒪_Y ≅ 𝒪_Y` via eval-at-1/globalSMul). `dual_restrict_iso` advanced to its Step-4 presheaf residual `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`. Blueprint `lem:dual_unit_iso`.
- **Lane TS-inv (DualInverse.lean) iter-252 — `homLocalSection` CLOSED axiom-clean** {propext, Classical.choice, Quot.sound} (verified `#print axioms`, no sorryAx). The blueprint's load-bearing `localSection` of `homOfLocalCompat` — incl. the hard naturality field, which beat the documented restrict/image carrier-friction wall (recipe: `hML` restrict-form + `hNR` pure-form + `erw [reassoc_of% hm]`; KB memory `homlocalsection-carrier-recipe`). `homOfLocalCompat` reduced from bare sorry → compiling scaffold (hom-sheaf `H` + `iSup U=⊤` + `existsUnique_gluing` fed `homLocalSection`) + one bounded gluing-bookkeeping sorry. Blueprint pin `lem:scheme_modules_hom_local_section` (added bw253).
- **Lane TS-cmp (TensorObjSubstrate.lean) iter-252 — STRUCTURAL: whisker route DISPROVED + element-level reduction** (no new named close). The armed whisker252 `letI instMS` recipe FAILED exactly as the iter-251 reversing signal predicted (verified by direct `lean_multi_attempt`: the η-whiskers carry `PresheafOfModules.monoidalCategoryStruct`, the `tensorHom_def` factors carry `monoidalCategory.toMonoidalCategoryStruct` — defeq-not-syntactic; `whisker_exchange` cannot bridge the cross-group crossing even via `erw`). Pivot: descend via `PresheafOfModules.Hom.ext` → sections → `ModuleCat.hom_ext; ext x`, reducing `sheafifyTensorUnitIso_hom_natural` to a single **instance-free element-level `TensorProduct` identity** ("no instance war left"). The whisker route is recorded DEAD; do not retry.

## Iter-254 closures (Lane TS-cmp + Lane TS-inv; axiom-clean; no canonical target closed)

- **Lane TS-cmp (TensorObjSubstrate.lean) iter-254 — STEP A `sheafifyTensorUnitIso_hom_natural` CLOSED axiom-clean** {propext, Classical.choice, Quot.sound}. The 5-iter whisker wall fell via the `tensorHom`-PIN device: new private helper `sheafifyTensorUnitIso_hom_eq'` (states `.hom` as ONE `a.map (η_P ⊗ η_Q)` on the canonical `⋙ forget₂` carrier) + monoidal lemmas (`tensorHom_comp_tensorHom`) applied as `(C := …)`-pinned TERMs (rw/erw fail on the non-canonical instance). D1′ `pullbackTensorMap_natural` advanced (Sq1 closed, Sq2 merge solved via `erw [← Functor.map_comp_assoc]`); residual sorry = the δ_natural carrier-spelling synthesis (UNBLOCKED iter-255: mapin255 LIGHT proof-side `show…from` `F`-ascription, NO refactor). File sorry 3→2.
- **Lane TS-inv (DualInverse.lean) iter-254 — `homOfLocalCompat` advanced to ONE isolated sorry**: `hf` re-signed HEq→sectionwise (legal, not protected); sub-step (a) `IsCompatible` CLOSED (defeq proof-irrelevance); sub-step (c) `𝒪_X`-linearity ~90% built (separatedness `section_ext`, naturality/`map_smul`, gluing-transport `hconn`, composite decomposition + M-leg `map_smul`). New helper `image_preimage_of_le`. SOLE residual = the open-immersion carrier-duality ring-bridge (L636), inline route mapped. File sorry 2→2 (internal 2→1).

## Iter-262 closures (axiom-clean infrastructure; one engine file-sorry; no critical-path target closed)

- **Lane TS-inv (DualInverse.lean) iter-262 — leg-B ε-iso CLOSED** (2 new axiom-clean decls
  `{propext,Classical.choice,Quot.sound}`): `isIso_ε_restrictScalars_appIso` (ε of `restrictScalars`
  along the open-immersion CommRingCat ring-iso is an iso) + `dualUnitRingSwap` (codomain unit swap =
  `inv ε`); codomainMap hole of `sliceDualTransport` filled by defeq (ma-legb262 predictions held
  exactly, incl. friction-(b) "no bridge needed"). `sliceDualTransport` internal typed holes 7→6;
  decl-sorry unchanged at 2. The STUCK-watch BAR met. **iter-263: ma-ihom263 VERIFIED a fully-closing
  `map_add'` recipe (`change` opener + `rfl` bridge + `Functor.map_add`/`Preadditive.add_comp`, goals
  `[]` at DualInverse.lean:343) + the `map_smul'` route (`homModule.smul`/`globalSMul` unfold, same
  opener); `internalHomObjModule` confirmed Mathlib-aligned, NO design refactor (`analogies/ma-ihom263.md`).**
- **Lane TS-cmp (TensorObjSubstrate.lean) iter-262 — Sq1 R0 factor PEELED in compiling code** (new
  axiom-clean helper `sheaf_unit_comp_pushforward_pullbackComp_inv` + `conv_rhs` distribution +
  `simp only [Functor.comp_map]; erw [Category.assoc]; erw [reassoc_of% key]` splice). R0 =
  `(pullbackComp h f).inv` GONE from the goal; `sheafificationCompPullback_comp` still ends in sorry
  (the R1/R5 collapse tail — the ~30-line analog of `pullbackObjUnitToUnit_comp` L969-996). file-sorry
  3→3. 2nd consecutive Sq1 PARTIAL-no-close. KEY: `Scheme.Modules.pushforward = SheafOfModules.pushforward
  ∘ toRingCatSheafHom` is `rfl` (the "whnf timeout" was a namespace typo).
- **A.2.c-engine (CechHigherDirectImage.lean) iter-262 — 3 axiom-clean decls + CechComplex reduced**
  (`coverArrow`/`coverCechNerve`/`relativeCechComplexOfNerve`; `CechComplex := relativeCechComplexOfNerve
  f (CechNerve 𝒰 F)`, a genuine body, not a disguised sorry). file-sorry 5→4. Nerve→complex plumbing
  coherence-free + DONE; sole residual = the push-pull functor `CechNerve.G`, whose `map_id`/`map_comp`
  CONSUME the bare `pullbackComp`/`pushforwardComp` composition coherence (the Sq1 piece) — COUPLED to
  D3′, NOT independent at the hard step. Independent brick `Gobj`/`Gmap` (no functor laws) lands next.

## iter-263 closes (processed iter-264)
- **DUAL `sliceDualTransport.map_add'`** (DualInverse.lean) — CLOSED axiom-clean (verified ma-ihom263
  recipe; `change`+`Functor.map_add`+`Preadditive.add_comp`+`rfl`). Internal holes 6→5.
- **D3′ Sq1 `sheafificationCompPullback_comp`** (TensorObjSubstrate.lean) — CLOSED sorry-free (consumes the
  extracted helper `sheafificationCompPullback_comp_tail`, which carries the relocated residual). Honest
  relocation (aud263-confirmed). Transposition route eliminated as CIRCULAR.
- **ENGINE `pushPullObj` + `pushPullMap`** (CechHigherDirectImage.lean) — axiom-clean object/morphism bricks
  of the push-pull functor `G`. Functor laws confirmed DE-COUPLED from D3′ Sq1 (Mathlib pseudofunctor
  coherences suffice).
