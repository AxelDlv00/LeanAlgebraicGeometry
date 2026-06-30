# Pending Tasks

Current open task set with last-known state only. Per-iter attempt detail lives in
`iter/iter-NNN/{plan,objectives}.md`.

## iter-323 active front (AUTHORITATIVE)

Build GREEN. conv323 = STUCK×2; correctives executed (FBC blueprint effort-break; PTC blueprint +
isolated core-C). bp323 PASS: PTC gate GREEN. **1 prover lane (PTC); FBC held.**

1. **FBC — HELD this iter (STUCK corrective = blueprint effort-break done; prover resumes NEXT iter).**
   iter-322 closed `coverInterOpen_baseChange_eq` + (correctly) the SCHEME-square
   `restrictedCartesianAffinePushout`; lvb-fbc322 must-fix (it was overstated as a ring pushout) +
   aud322 MAJOR (`twisted_cech_nerve_per_sigma` missing `[Finite κ]`). iter-323: fbc323 restated the
   blueprint to match Lean + relocated the ring-pushout into heart step 4; effort-breaker fbc-heart323
   split the 4-iter-STUCK heart `pushPullObj_coverInter_baseChange` into a 3-lemma chain (scaffold
   targets): `coverinter_lhs_iso_tilde` (`pushPullObj_coverInter_pushforward_iso_tilde`, cheap),
   `coverinter_baseChanged_module_iso_tensor` (`coverInter_baseChanged_sections_iso_tensor`, corner
   `N'≅N⊗_R R'`), `coverinter_rhs_iso_tilde`
   (`pushPullObj_coverInter_baseChanged_pushforward_iso_tilde`, the REAL gap — RHS over X' into tilde;
   reuses `twisted_cech_nerve_per_sigma`; largest, re-break candidate). NEXT-ITER FBC = scaffold the 3
   (+ rewired heart glue) as stubs, prove L1/L3 first; ALSO `[Finite κ]` fix +
   `openImmersion_beckChevalley` leaf. Recipe `analogies/fbc-pushpull-tilde-317.md`. LSP dead → build-
   blind. Open leaves: `pullback_preservesFiniteLimits` (held), the 3 carved + heart glue,
   `openImmersion_beckChevalley`, `twisted_cech_nerve_per_sigma`, 2 cosimplicial naturalities.

2. **D3′ close core C (= `cmp_leg` residual) — `Picard/TensorObjSubstrate/PullbackTensorComp.lean`**
   [prover-mode: prove]. ACTIVE. iter-322: homEquiv de-risk FAILED mechanically (`naturality_left`
   whnf-detonates; `Sheaf.val` coercion poison); prover hand-reduced `cmp_leg` (22-line verified prefix:
   cancel_mono `forget pbc.inv` → `pullbackValIso_comp` → unit.naturality_assoc → PC cancel) to lone
   **core C** sorry (L~822). iter-323: `lem:cmp_leg` + core-C sketch BLUEPRINTED (bp323 PASS, gate GREEN).
   core C = `scPb_h=leftAdjointUniq adjA adjB` composite-adjunction-unit mate calc: close via
   `unit_leftAdjointUniq_hom_app`+`leftAdjointUniq_hom_app_counit` AFTER aligning plain η to adjB's
   comp-unit via `Adjunction.comp_unit_app` (simp won't). **METHOD = STANDALONE scratch lemma** (small
   goal ⇒ LSP works, NO giant-assembly whnf — that wall is `pullbackTensorMap_restrict` only). Pullback
   spelling banked: `Scheme.Modules.pullback h = SheafOfModules.pullback h.toRingCatSheafHom` defeq
   (`analogies/pullback-spelling-310.md`); `change`-pin, no bridge-lemma hunt. THEN wire the 7-step
   assembly (`analogies/ptc-cmpleg-slide-322.md`: `set Pbh` freeze + default-transparency continuation
   lemma re-pinning `(C:=…)` on every `⊗ₘ`). HAZARD: do NOT re-edit `TensorObjSubstrate.lean`. Bar:
   close core C (⇒ `cmp_leg` sorry-free). Reversal: walls on η-alignment ⇒ effort-break core C, NOT paste.

## Held / deferred (rationale in PROGRESS.md "Held lanes")

- **FBC general-S 02KH (non-affine base)** — later locality-on-S' reduction node; affine-base suffices now.
- **FBC leaf-1 `pullback_preservesFiniteLimits`** (L153) — abstract left-adjoint wall; reduce-to-absolute
  plausibly bypasses it.
- **FBC general quasi-separated SS lift** (`lem:cech_to_derived_pushforward_ss`) — off the separated path.
- **genericFlatness (`Picard/FlatteningStratification.lean`)** — opens after mathlib-analogist/dag-walker
  prep on the poly-ring generic-flatness core (Mathlib gap).
- **pushPullMap_comp (`CechHigherDirectImage.lean`) — PAUSED** (separated 02KH suffices).
- **A.1.c.fun `RelPicFunctor.lean`** — 0 local sorry; gated cross-file on D4′ + the (now-done) dual chain.
- **Route C (RR) + genus-0 substrate + A.3+** — PAUSED/not-dispatched (USER directives).
- **Off-front hygiene:** broken `\cref` in `Picard_QuotScheme.tex`(14)/`Picard_GlueDescent.tex`(2) — held
  lanes, repoint when reopened. Duplicate `mapAlternatingCofaceMapComplexIso` (private vs public) — resolve
  on the FBC prover touch if cheap. 1 stale `\uses` on `lem:dual_unit_iso`. DualInverse stale comments
  (L837/L1012/L1084/L1347). PTC chapter "soon" nit (bp320): trailing codomain annotation `h*f*M ⊗ h*f*N`
  → `(h∘f)*M ⊗ (h∘f)*N` (formula+pin correct; cosmetic).
- **FlatBaseChange.lean v4.31.0 / mate sorries (L866/L888)** — NOT a clean mechanical restore: the 2 open
  sorries are the kept-opaque canonical-mate holes off the LIVE reduce-to-absolute path (per STRATEGY).
  Restoration needs a file-split first (70+ min build, USER build-time directive). Scheduled as a dedicated
  split-then-restore lane, NOT this iter; the live FBC path bypasses these.
