# Project Progress

## Current Stage

prover

## Stages
- [x] init
- [x] autoformalize
- [ ] prover
- [ ] polish

## End-state overview

**Zero inline `sorry` in the dependency cone of each protected declaration + kernel-only axioms**
for Christian Merten's Jacobian challenge. `J := Pic⁰_{C/k}` built uniformly (`picardJacobianWitness`).
PRIMARY near-term goal = **`Pic_{C/k}` representability** via Kleiman §4 Thm 4.8 (+ Cor 4.18.3), the
4-step skeleton: (1) stratify Picᵖ by Hilbert polynomial — strata-openness IS flat base change
(Stacks 02KH) + generic flatness; (2) m-regularity; (3) Abel map Div=Quot; (4) smooth-proper-quotient
descent. Full framing in STRATEGY.md.

## Iter-323 — progress-critic STUCK×2; both correctives executed (FBC blueprint effort-break; PTC blueprint + isolated core-C); 1 prover lane

**Context (iter-322 results processed).** FBC closed 2 carved blocks but `restrictedCartesianAffinePushout`
was a TAUTOLOGICAL under-statement (lvb-fbc322 **must-fix**: proved trivial scheme square, not the
asserted affine ring pushout); aud322 MAJOR = `twisted_cech_nerve_per_sigma` missing `[Finite κ]`.
PTC: analogist de-risk FAILED mechanically; prover hand-reduced to isolated named **core C**
(`cmp_leg` residual sorry), but `cmp_leg` had NO blueprint block (lvb-ptc322 MAJOR). progress-critic
**conv323 = STUCK on BOTH**.

**Correctives executed THIS iter (blueprint-before-prover, per the STUCK rule):**
- **FBC must-fix resolved + heart effort-broken (NO FBC prover this iter).** blueprint-writer fbc323
  restated `lem:restricted_cartesian_affine_pushout` to the scheme-square form (matches the sorry-free
  Lean) and relocated the ring-pushout into the heart's step 4. effort-breaker fbc-heart323 split the
  4-iter-STUCK heart `pushPullObj_coverInter_baseChange` into a **3-lemma chain** — closing the real gap
  (the RHS `f'_*((g')^*…)` over X' was never put in tilde form). bp323 PASS, must-fix cleared.
- **PTC blueprint gap closed; core C is now a blueprinted, isolated, gate-clear target.** blueprint-writer
  ptc323 added `lem:cmp_leg` (verified-prefix + core-C `leftAdjointUniq` mate-calculus sketch incl. the
  `Adjunction.comp_unit_app` η-alignment hazard) + the explicit 7-step assembly. bp323 PASS — **HARD GATE
  cleared for PullbackTensorComp.lean**.

## Current Objectives

1. **`Picard/TensorObjSubstrate/PullbackTensorComp.lean`** — **D3′: close core C = the `cmp_leg`
   residual `sorry` (L~822), as a STANDALONE scratch lemma; then wire the assembly.**
   **[prover-mode: prove]** Blueprint: `chapters/Picard_TensorObjSubstrate.tex` (`lem:cmp_leg` NEW this
   iter + `lem:pullback_tensor_map_basechange`; bp323 PASS — gate GREEN). Recipes:
   `analogies/ptc-cmpleg-slide-322.md` + `analogies/pullback-spelling-310.md` + the in-file 7-step
   roadmap.
   - **core C — the genuine remaining math, now ISOLATED + BLUEPRINTED.** After the verified 22-line
     prefix, `cmp_leg`'s sole residual is core coherence C: `scPb_h = Adjunction.leftAdjointUniq adjA
     adjB` (adjA = sheafificationAdj ∘ pushforwardAdj φ_h; adjB = pushforwardAdj φ_h.hom ∘
     sheafificationAdj). Close it via `Adjunction.unit_leftAdjointUniq_hom_app` [verified] +
     `Adjunction.leftAdjointUniq_hom_app_counit` [verified], **AFTER first re-expressing the plain
     sheafification unit η as adjB's composite-adjunction unit via `Adjunction.comp_unit_app`**
     [expected] — `simp` with the two `@[simp]` lemmas does NOT align them for free (the documented
     hazard; blueprint `lem:cmp_leg` core-C sketch).
   - **METHOD = develop core C as a STANDALONE lemma in a SMALL scratch file** importing the deps of
     `cmp_leg` (adjunction infra) where **LSP WORKS** — core C is a SMALL goal, so it does NOT trigger
     the giant-assembly whnf-explosion (that was `pullbackTensorMap_restrict`'s relaxed-transparency
     giant goal, a different problem). Then transplant the closed term into `cmp_leg`.
   - **Pullback-spelling (the conv323 question — ANSWER BANKED, do NOT re-search):**
     `Scheme.Modules.pullback h` IS `SheafOfModules.pullback h.toRingCatSheafHom` *definitionally*
     (`Sheaf.lean:167`). If a `(pullback h).map …` term needs aligning inside core C, use a
     `let`/`change` spelling-pin (`analogies/pullback-spelling-310.md`), NOT a hunt for a bridging
     lemma.
   - **THEN the assembly `pullbackTensorMap_restrict` (L~1060)** — once `cmp_leg` is sorry-free, wire
     the blueprinted 7-step assembly (scPb_slide ×3 → δ_h-natural ×2 → `tensorHom_comp_tensorHom` M/N
     split → `cmp_leg` per leg). If the slide still detonates, `set Pbh := Scheme.Modules.pullback h`
     opaque-fvar freeze + a DEFAULT-transparency continuation lemma re-pinning `(C := PresheafOfModules
     (W.presheaf ⋙ forget₂ CommRingCat RingCat))` on every `⊗ₘ` (`analogies/ptc-cmpleg-slide-322.md`).
   - **HAZARD:** do NOT re-edit `TensorObjSubstrate.lean` (READ its olean only). LSP times out on
     PullbackTensorComp.lean → that is WHY core C must be developed in a small scratch file first.
   - **Env/perf:** keep `respectTransparency false` only where a pullback-defeq genuinely detonates;
     pick the SMALLEST `maxHeartbeats` that compiles + rationale comment (USER build-time directive).
   - **Bar:** **closing core C** (⇒ `cmp_leg` sorry-free) is the genuine win — the assembly is
     mechanical once `cmp_leg` lands. Partial OK: core C closed alone is real progress. This is the
     ISOLATED-standalone core-C development (a structurally NEW target shape), NOT the giant-assembly
     re-paste the prior 4 PARTIAL iters kept hitting. **Reversal signal:** if core C walls on the
     η-alignment despite the standalone-scratch + `comp_unit_app` approach, STOP and report the precise
     residual — next corrective is effort-breaking core C into (unit-alignment) + (leftAdjointUniq
     application), NOT another assembly paste.

## Held lanes / deferrals (rationale)

- **FBC `CechHigherDirectImageUnconditional.lean` — HELD this iter (STUCK corrective = blueprint
  effort-break done; prover resumes NEXT iter on the carved chain).** The 4-iter-STUCK heart
  `pushPullObj_coverInter_baseChange` was split (effort-breaker fbc-heart323) into a `\uses`-linked
  3-lemma chain (all scaffold targets — Lean decls do not exist yet):
  - `lem:coverinter_lhs_iso_tilde` → `pushPullObj_coverInter_pushforward_iso_tilde` (LHS abstract→tilde;
    1 move).
  - `lem:coverinter_baseChanged_module_iso_tensor` → `coverInter_baseChanged_sections_iso_tensor`
    (corner module `N' ≅ N⊗_R R'`).
  - `lem:coverinter_rhs_iso_tilde` → `pushPullObj_coverInter_baseChanged_pushforward_iso_tilde`
    (RHS abstract→tilde — the previously-glossed multi-hundred-LOC gap; reuses
    `twisted_cech_nerve_per_sigma`; LARGEST, re-break candidate per effort-breaker report).
  NEXT-ITER FBC objective = **scaffold these 3 (+ the heart's rewired glue) as `sorry` stubs, then prove
  L1/L3 (cheap) first**; ALSO apply aud322 MAJOR fix `[Finite κ]` on `twisted_cech_nerve_per_sigma`'s
  signature + close `openImmersion_beckChevalley` leaf. Recipe: `analogies/fbc-pushpull-tilde-317.md`.
- **FBC general-S 02KH (non-affine base)** — later locality-on-S' reduction node; affine-base suffices.
- **FBC leaf-1 `pullback_preservesFiniteLimits`** — abstract left-adjoint wall; reduce-to-absolute
  plausibly bypasses it.
- **FBC general quasi-separated SS lift** (`lem:cech_to_derived_pushforward_ss`) — off the separated path.
- **`Cohomology/FlatBaseChange.lean` sorries (L866/L888)** — kept-opaque canonical-mate holes OFF the
  live reduce-to-absolute path; restoration needs a file-split FIRST (70+ min build). Dedicated
  split-then-restore lane.
- **`Picard/FlatteningStratification.lean` (genericFlatness)** — opens after a mathlib-analogist/dag-walker
  prep (poly-ring generic-flatness algebraic core = Mathlib gap).
- **`Cohomology/CechHigherDirectImage.lean` (pushPullMap_comp) — PAUSED** (separated 02KH suffices).
- **`RelPicFunctor.lean` (A.1.c.fun)** — 0 local sorry; gated cross-file on D4′ + the now-done dual chain.
- **Coverage / blueprint hygiene (off active front, bp323 non-gating):** pre-existing broken `\cref`
  in `Picard_QuotScheme.tex`(14)/`Picard_GlueDescent.tex`(2) — held Kleiman/Quot lanes; repoint when
  reopened. `\leanok`-before-`[title]` render nit in 2 CechHDI lemmas (cosmetic). ~385 isolated
  `lean_aux` nodes (held Quot/Grassmannian/GenericFreeness backlog). DualInverse stale comments. PTC
  codomain nit. Fix on touch.
- **v4.31.0 interim sorries** (~20–30, build GREEN) — restored when each file is next touched.

**USER FYI** (loop autonomous per the 2026-05-31 directive; override via `USER_HINTS.md`):
- **FBC (PRIMARY 02KH):** the 4-iter-STUCK affine-reduction heart was effort-broken this iter into a
  3-lemma chain that closes the real gap (RHS tilde identification). The prover resumes next iter on the
  carved (now-tractable) pieces. Delivers the affine-base separated case (sufficient for strata-openness).
- **D3′ (last substrate pole):** the genuine core (`cmp_leg`'s core C) is now isolated + blueprinted;
  the prover closes it this iter as a standalone scratch lemma (sidestepping the file LSP-timeout), then
  the assembly is mechanical.
