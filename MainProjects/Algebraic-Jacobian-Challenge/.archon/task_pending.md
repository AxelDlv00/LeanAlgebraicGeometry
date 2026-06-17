# Pending Tasks

Current open task set with last-known state only. Per-iter attempt detail lives in
`iter/iter-NNN/{plan,objectives}.md`.

## iter-303 current state (AUTHORITATIVE — supersedes older per-lane tails below)

**RESUME prover after iters 272–302 (DAG/blueprint only; blueprint now COMPLETE + fully connected,
iter-302).** The last actual proving was iter-271 (which DID run and made partial progress — see lane
tails). Build green this phase. The two formerly-∞ substrate nodes now carry full reviewer-certified
informal proofs. **4 lanes dispatched iter-303**: the 3 iter-271 critical-path lanes below (whose
correctives were devised but never executed — this is their first run) + a 4th A.2.c-engine lane:
- **FLATTENING — `Picard/FlatteningStratification.lean`** (NEW lane, A.2.c-engine generic flatness,
  RR-free). 7 typed sorries: `genericFlatness` (L208, the deepest root — Stacks 052B), `flatLocusStratification`
  (L252), `flatLocusReduction` (L280), `flatLocusAssembly` (L310), `flatteningStratification` (L358),
  `flatteningStratification_universal` (L399), `.ofCurve` (L438). [prover-mode: mathlib-build] Build
  `genericFlatness` bottom-up from Mathlib's module/algebra-level generic flatness; stop + decompose when
  blocked. Blueprint `Picard_FlatteningStratification.tex` (complete+correct iter-302).

The 3 carried lanes (iter-271 correctives, first execution; now with full blueprint proofs):
- **DUAL — `DualInverse.lean` `sliceDualTransport`** (CHURNING). iter-265 built leg-B `.hom`-direction
  swaps axiom-clean (`dualUnitRingSwapHom`, `dualUnitRingSwapInv`, 2 cancellation lemmas,
  `isIso_ε_restrictScalars_appIso_hom`). Open: `invFun`, `left_inv`, `right_inv`, `naturality` (internal
  holes 4). iter-271 corrective = EXTRACT `sliceDualTransportInv` as a top-level def FIRST (the binder-
  metavar blocker), then close `invFun`+round-trips. Blueprint invFun ε-direction prose CORRECTED iter-271
  (was the gate blocker): the codomain swap is `dualUnitRingSwapHom = inv(ε(restrictScalars (f.appIso W'').hom.hom))`.
  `restrictScalarsLaxε` for `naturality` EXISTS at `PresheafInternalHom.lean:290` [verified].
- **D3′ — `TensorObjSubstrate.lean` `sheafificationCompPullback_comp_tail`** (STUCK; file-sorry flat 3 ×4).
  iter-265 landed the bridge `forget_map_pushforward_map` (axiom-clean) + 2 wiring steps. Residual = R1/R5
  recovery (the composite sheafify∘pushforward unit-mate step). iter-271 corrective = the analogist route
  `conjugateEquiv_whiskerLeft` (Mates.lean:525) giving the stuck factor a homEquiv head; fallback =
  `leftAdjointCompNatTrans_assoc` surjective/injective reduction (Mathlib's `pullback_assoc` proof).
  Recipe: `analogies/d3-mate271.md`.
- **ENGINE — `CechHigherDirectImage.lean` `pushPullMap_comp`** (UNCLEAR/on-track). iter-264/265 landed
  `pushPullMap_id` + `pushPull_unit_mate` axiom-clean. `pushPullMap_comp` blocked by a KERNEL whnf blow-up
  on the `eqToHom` over-triangle transports in `pushPullMap`'s def (L175–187). iter-271 = build a
  GENERALIZED kernel-cheap eqToHom-cancellation lemma (free equality var + `subst`; option b); escalate to
  a transport-light def refactor (option a) if the kernel wall survives `subst`.

## SHARED ROOT — `Picard/SheafOverEquivalence.lean` — CLOSED (iter-259) → task_done
`overEquivalence` (iter-258) + `restrictOverIso` + `unitOverIso` (iter-259) all axiom-clean; file fully
sorry-free. ⇒ engine `chartOverIso` axiom-clean ⇒ `IsLocallyTrivial⟹IsFinitePresentation` DONE. **NOTE:
the shared root is STRUCTURALLY INSUFFICIENT for the dual `sliceDualTransport` (iter-260 finding — it
carries no internal-hom/dual content); the dual takes route-2 instead (see Lane TS-inv).** Recipes in
`analogies/overeq258.md` + [[ts259-soe-shared-root-closed]] + [[ts260-route1-dead-for-dual]].

## A.1.c.sub — comparison-iso substrate (CRITICAL PATH)

### Lane TS-inv — `Picard/TensorObjSubstrate/DualInverse.lean` (ACTIVE iter-261 — route-2 SANCTIONED)
- **`homOfLocalCompat` — CLOSED axiom-clean iter-256.** → task_done.
- **`dual_restrict_iso` (L356) → `sliceDualTransport` (L184) — ACTIVE iter-261, ROUTE-2 (route-1 DEAD).**
  iter-260 PROVED route-1 (consume the shared root `overEquivalence`/`restrictOverIso`/`unitOverIso`)
  **STRUCTURALLY INSUFFICIENT**: those are sheaf-object isos with NO internal-hom/dual content; the
  reduced goal's content is dual-commutes-with-slice-reindexing along `f.opensFunctor`, which route-1
  cannot supply (needs the avoided `MonoidalClosed`). **PLANNER SANCTIONS ROUTE-2** (iter-261; rebuttal
  to strategy-critic recorded in iter sidecar): build the `≃ₗ` BY HAND, self-contained in this file.
  `sliceDualTransport f M V` = the per-`V` `𝒪_Y(V)`-linear equivalence realizing **leg A** =
  slice-site Hom base-change (Beck–Chevalley) — forward/inverse = `eqToHom`-conjugation of the slice-Hom
  components across `f.opensFunctor` along the down-set identity `image_preimage_of_le` (`ι(ι⁻¹V)=V`),
  naturality `Subsingleton.elim` on the thin poset (SAME pattern proven for `homLocalSection`/
  `dualUnitIsoGen`) — composed with **leg B** = `restrictScalarsRingIsoDualEquiv` along `(f.appIso V).inv`.
  NB leg B does NOT type-apply standalone (different over-cat indexing) — leg A runs first; the build is
  ONE intricate ~150–250 LOC piece, NOT decomposable into independent compiling sub-pieces. Then
  `dual_restrict_iso` `isoMk` naturality is the thin-poset coherence of the now-concrete family.
  **iter-261 BUILT leg-A (categorical `.map`) + Module-instance wall resolved.** **iter-262 CLOSED leg-B**
  (codomainMap; 2 axiom-clean decls `isIso_ε_restrictScalars_appIso` + `dualUnitRingSwap`; internal holes
  7→6) ⇒ pc263 **DUAL = STUCK**. **iter-263: `map_add'` CLOSED** (holes 6→5). **iter-264: `map_smul'`
  CLOSED axiom-clean** (holes 5→4; projection-tolerant `conv_rhs => arg 2; change` +
  `congrArg d.hom |>.trans (.map_smul)` + `appIso_inv_naturality`). **iter-265 (pc265 = CONVERGING — the
  decl-sorry-flat-at-2 is a monolithic-`≃ₗ` artifact; the real metric, internal holes, falls 1 field/iter):
  open `invFun` (the linchpin; recipe ADEQUATE per di264) + `naturality`.** invFun: `(f.appIso W'').hom`
  (not `.inv`) + `ε(restrictScalars β_{W''})` itself + reindex by the inverse bijection `image_preimage_of_le`;
  the reverse `map_add'`/`map_smul'` mirror the closed forward proofs; then `left_inv`/`right_inv` by
  `Iso.inv_hom_id`/`hom_inv_id` + down-set cancellation. naturality: (a) `Subsingleton.elim` thin poset +
  (b) ε-square via **`PresheafOfModules.restrictScalarsLaxε`** (di264 gap fixed by bw-tos265). If all close
  → `dual_restrict_iso` isoMk naturality (L546, thin-poset-trivial), finishing the decl (holes 4→0).
  Recipe blueprint `lem:slice_dual_transport` (bw-tos265 named the ε-helper + isoMk sequencing; br265
  GATE-CLEARED). [prover-mode: fine-grained]
  - **Reversing signal:** if `invFun` does NOT close with the adequate recipe (a granularity problem, not
    tactic friction) ⇒ planner reassesses `≃ₗ`-by-hand vs a categorical `.map`-only rebuild (sc264: NO
    cheaper architecture — the `picCommGroup`-inverse alt collapses to the same `dual_restrict_iso`; the
    stalkwise Plan-B is strictly larger). Report the wall, do NOT pivot unilaterally.
- **`exists_tensorObj_inverse`** (in TensorObjSubstrate.lean L693) — the RPF group inverse. Both its
  loc-triviality (C) AND its evaluation-iso local pieces route through `dual_restrict_iso`; A-bridge
  (`homOfLocalCompat`) + B-bridge (`isIso_of_isIso_restrict`) already CLOSED, so `dual_restrict_iso`
  closes the WHOLE remaining inverse chain. Unblocks once `dual_isLocallyTrivial` is axiom-clean. A
  future refactor moves it into DualInverse.lean. Not this iter.

### Lane TS-cmp — `Picard/TensorObjSubstrate.lean` (D3′; ACTIVE iter-261 — `pullbackTensorMap_restrict`)
- **D1′/D2′/STEP A + D3′ Sq2/Sq2b (`pullbackComp_δ`+`pushforwardComp_lax_μ`) CLOSED axiom-clean.**
  `pushforwardComp_lax_μ` CLOSED iter-260 (→ task_done; short sectionwise pure-tensor collapse, NOT the
  extendScalarsComp build). Code sorries now: `exists_tensorObj_inverse` (L693, gated on the dual chain),
  `pullbackTensorMap_restrict` (L2521, the D3′-outer lemma).
- **D3′ Sq1 — `sheafificationCompPullback_comp` closed iter-263; residual in `sheafificationCompPullback_comp_tail`
  (L2578).** **iter-264: step-1 recovery brick `leftAdjointUniqUnitEta_app` (P-general, axiom-clean) +
  step-0 setup landed; tail still sorry; file-sorry 3→3 — 5th PARTIAL.** Precise blocker NAMED by the
  prover: the presheaf↔sheaf `forget ∘ pushforward^sheaf = pushforward^pre ∘ forget` compatibility bridge
  feeding the recovered units. **iter-265 (pc265 = STUCK; primary corrective = BLUEPRINT DECOMPOSE, done
  this phase by bw-tos265/bc265/br265):** the chapter Sq1-tail now has an ordered (a)–(e) assembly + the
  pinned brick `lem:leftadjointuniq_app_unit_eta_general` + a NAMED binding obligation (the bridge). Prover
  task: **STEP 1 — extract the bridge as a standalone named lemma, prove it axiom-clean** [expected: short
  `hom_ext; intro U; rfl` or existing `toPresheaf`/`pushforward` naturality; mirror the engine's
  `pushforwardComp_hom_app_app = 𝟙 by rfl` idiom]; **STEP 2 — paste (a)–(e)** ((a)/(b) DONE iter-264; (c)
  `leftAdjointUniqUnitEta_app`; (d) `pushforwardComp.hom.naturality` consuming the bridge; (e)
  `comp_unit_app`+`unit_naturality`+`erw`). Blueprint `lem:pullback_tensor_map_basechange` (br265
  GATE-CLEARED). [prover-mode: fine-grained]
  - **Known dead-end:** do NOT re-transpose the whole tail equation (circular). Keep LHS concrete, assemble RHS.
  - **RACE MITIGATION:** `DualInverse.lean` imports this file. KEEP IT COMPILABLE; retain the typed sorry if
    the tail does not close. The route-2 DualInverse lane does NOT need Sq1.
  - **Bar:** close the tail (file-sorry 3→2) OR land the STEP-1 bridge axiom-clean (measurable decompose
    progress). **If (a)–(e) still blocks WITH the bridge proved ⇒ a 6th PARTIAL ⇒ escalate to cross-domain
    analogist on the bicategorical-cocycle/mate-assembly shape** (then the assembly is genuinely novel, not
    under-specified).
- D4′ `pullbackTensorIsoOfLocallyTrivial` (the chart-chase via `isIso_of_isIso_restrict`) — gated on
  `pullbackTensorMap_restrict`'s open-immersion base-change form; next iter.

## A.1.c.fun — `Picard/RelPicFunctor.lean` (CONVERGED, HELD)
0 local sorry; `addCommGroup`/`PicSharp`/`functorial` real bodies gated cross-file on D4′
(`pullback_tensor_iso_loctriv`) + `exists_tensorObj_inverse` (the dual chain). Re-opens when those land.
Transport modeled on Mathlib `CommRing.Pic.mapAlgebra`/`.functor`.

## A.2.c-engine
- **Loc-triv coherence `IsLocallyTrivial ⟹ IsFinitePresentation` (`Picard/LineBundleCoherence.lean`) —
  DONE iter-259, fully axiom-clean** (verified `{propext,Classical.choice,Quot.sound}`, no `sorryAx`).
  → task_done. No further work; the deliverable is complete.
- **`Rⁱf_*` (i≥1) project Čech build (~800–1200 LOC) — LANE OPEN (DOMINANT POLE / rate-limiter, sc264).**
  Nerve→complex plumbing DONE axiom-clean; the push-pull object/morphism bricks `pushPullObj`/`pushPullMap`
  DONE axiom-clean iter-263. **DE-COUPLED from D3′ (iter-263 finding, sc264+ma-d3264 confirmed):** the functor
  laws `pushPullMap_id`/`pushPullMap_comp` use ONLY Mathlib's `Pseudofunctor (LocallyDiscrete Schemeᵒᵖ)
  (Adj Cat)` coherences (sheaf-level; `pushforwardComp_hom_app_app = 𝟙` by `rfl`), NOT project Sq1.
  **iter-264: `pushPullMap_id` LANDED axiom-clean** (`conjugateEquiv_pullbackId_hom` +
  `pseudofunctor_right_unitality` + sectionwise `hpf` `hom_ext; intro U; rfl`); file-sorry 4→4.
  **iter-265 (pc265 = CHURNING-mechanical-false-positive; NARROW to `pushPullMap_comp` ONLY — ~150-LOC
  pentagon is a full iter):** mirror `pushPullMap_id` one step up — pushforward coercions collapse by
  `hom_ext; intro U; rfl`; `Adjunction.comp_unit_app`; `Scheme.Modules.pseudofunctor_associativity
  (f:=g.left)(g:=h.left)(h:=Y₁.hom)` [verified typechecks]; `Adjunction.unit_naturality`; `erw`+`reassoc_of%`;
  `eqToHom`-through-`Over.w` as fully-applied forward terms w/ explicit `congrArg`; `respectTransparency
  false`. STRETCH only if comp closes early: assemble `pushPullFunctor` (G) + discharge `CechNerve` (L89).
  Do NOT touch the 3 infra-gated downstream sorries. Blueprint `lem:push_pull_functor` (br264 GATE-CLEARED).
  Stacks 02KE–02KH. [prover-mode: mathlib-build] **If `pushPullMap_comp` does not close by iter-266 ⇒
  blueprint sub-lemma decomposition of the pentagon (pc265).**
- **`Cohomology/FlatBaseChange.lean`** [mathlib-build] — HELD (defeq wall, STUCK iter-244).
  `pushforward_spec_tilde_iso` + `pullback_spec_tilde_iso` CLOSED; `affineBaseChange_pushforward_iso`
  blocked on two Mathlib-absent obligations. Re-engage after D4′ OR #37189 bump.
- **`Cohomology/HigherDirectImage.lean`** — DEFERRED (3 Mathlib-absent sorries; needs `Rⁱf_*`).

## Held / paused lanes
See PROGRESS.md "Held lanes". Route C (RR chain) + genus-0 substrate PAUSED (USER); A.3+ not dispatched
(USER directive #6, bottom-up).
