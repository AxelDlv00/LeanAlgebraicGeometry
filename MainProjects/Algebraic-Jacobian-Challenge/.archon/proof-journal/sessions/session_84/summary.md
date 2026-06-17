# Session 84 — iter-084 review

## Metadata

- **Archon iteration**: 084
- **Stage**: prover (two substantive lanes — BasicOpenCech, Differentials; Modules/Monoidal off-limits per plan).
- **Sorry count before iter-084**: 14 active syntactic sorry sites (BasicOpenCech 6 + Differentials 5 + Modules/Monoidal 1 + Jacobian 1 + Picard/Functor 1).
- **Sorry count after iter-084**: **14** active syntactic sorry sites.
  - Per-file:
    - `Cohomology/BasicOpenCech.lean`: 6 — L502, L826, L854, **L1383** (was L1323), **L1428** (was L1368), **L1457** (was L1397). Lines shifted +60 LOC due to a documentation/proof-step comment block landing at L1325–1382.
    - `Differentials.lean`: 5 — L122, **L640** (was L645), L961 (was L929), L978 (was L946), L1120 (was L1088). Lines shifted −5/+32 LOC due to the new `refine ⟨?h_exact, ?h_epi⟩` split plus a comment block.
    - `Modules/Monoidal.lean`: 1 — L173 (unchanged, off-limits).
    - `Jacobian.lean`: 1 — L179 (unchanged, deferred Phase C).
    - `Picard/Functor.lean`: 1 — L190 (unchanged, deferred Phase C).
- **Net change**: **0** syntactic sorries. **Substantive Lane 2 closure**: `h_epi` of `cotangentExactSeq_structure` is now fully proved — the 1 remaining sorry on that lemma (L640) covers only `h_exact` (was `h_exact ∧ h_epi`).
- **Compilation status**: All files compile cleanly at end-of-iteration.
  - `BasicOpenCech.lean`: final `lean_diagnostic_messages` event 88 (line 38 in JSONL): 0 errors, 1 style warning.
  - `Differentials.lean`: final `lean_diagnostic_messages` event 362 (line 154 in JSONL): 0 errors, 0 warnings.
- **Env state** (from `attempts_raw.jsonl` summary line):
  164 total events; **17 source edits** (2 BasicOpenCech, 15 Differentials); **16** `lean_goal`; **17** `lean_diagnostic_messages`; **23** lemma searches; **0** `lake build`; **0** `lean_run_code` pre-validation (per user policy).
- **`lean_verify`** on `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` and `cotangentExactSeq_structure`: only standard axioms (`propext`, `sorryAx`, `Classical.choice`, `Quot.sound`). **No new axioms introduced**.

---

## Lane summary

| Lane | File | Status | Sorry Δ | Compile |
|---|---|---|---|---|
| 1 | `Cohomology/BasicOpenCech.lean` | PARTIAL ADVANCE — cleared BOTH iter-083 typeclass barriers via `letI hmod_pi_Z₁/Z₂ : Module ↑R ↑(∏ᶜ Z_i) := h_mod_X_i` (bound at the literal `↑(∏ᶜ Z_i)` source-type) + explicit `show e₁.symm (r • y) = e₁.symm (r • e₁ (e₁.symm y)); rw [LinearEquiv.apply_symm_apply]` smul-commutation rw. Residual = genuine R-linearity content (no longer typeclass scaffolding). No closure landed (Phase B target deferred to iter-085+). | 0 (6 → 6) | yes |
| 2 | `Differentials.lean` | **RESOLVED** (Lane 2 closure target) — `h_epi` of `cotangentExactSeq_structure` closed via `SheafOfModules.epi_of_epi_presheaf` + `PresheafOfModules.epi_iff_surjective` + `Submodule.span_induction` over `_root_.KaehlerDifferential.span_range_derivation` + `ModuleCat.Derivation.desc_d` for the mem case. `h_exact ∧ h_epi` conjunction split via `refine ⟨?h_exact, ?h_epi⟩`; `h_exact` now carries the single absorbed sorry (deferred iter-085+: needs `SheafOfModules.exact_iff_stalkwise` + `KaehlerDifferential.exact_mapBaseChange_map`). | 0 (5 → 5, but conjunction split: h_epi closed; bridges previously-known dead-end) | yes |
| 3 | `Modules/Monoidal.lean` | not assigned (deferred pending Mathlib upstream gap on `PresheafOfModules.stalk_tensorObj` for varying-ring R₀). | — | unchanged |

---

## Lane 1 — `BasicOpenCech.lean`: typeclass-barrier clearance, no closure

**Status**: PARTIAL ADVANCE. The two iter-083-identified typeclass barriers are now fully resolved at source level, leaving the residual = genuine per-summand R-linearity. No syntactic-sorry closure landed; the sorry shifted L1323 → L1383 due to an ~60-LOC comment block recording the new structural findings.

### Concrete delivery — letI surface + smul-commutation rw + comment block (events 35, 37 in JSONL)

The single edit on L1325–1382 added:

```lean
        letI hmod_pi_Z₁ : Module ↑R ↑(∏ᶜ Z₁) := h_mod_X₁
        letI hmod_pi_Z₂ : Module ↑R ↑(∏ᶜ Z₂) := h_mod_X₂
        rw [show (ModuleCat.piIsoPi Z₁).toLinearEquiv.symm (r • y)
              = (r • (ModuleCat.piIsoPi Z₁).toLinearEquiv.symm y : ↑(∏ᶜ Z₁))
              from by
                show e₁.symm (r • y) = e₁.symm (r • e₁ (e₁.symm y))
                rw [LinearEquiv.apply_symm_apply]]
        -- (~60-LOC comment block follows; sorry preserved)
        sorry
```

inserted before the existing sorry at L1383. These:
1. Surface `h_mod_X₁/X₂` instances under the literal `↑(∏ᶜ Z_i)` source-type (not `↑scK₀.X_i`, which iter-083 found insufficient).
2. Commute `(piIsoPi Z₁).symm` past `r •` via the explicit `Equiv.smul_def`-unfolded show + `LinearEquiv.apply_symm_apply` rw.

### Attack record (iter-084)

| Event | Tactic | Result | Insight |
|---|---|---|---|
| 14 (line 34) | `lean_diagnostic_messages` baseline | clean | starting state established |
| 15 (line 36) | `lean_goal` at L1323 | got the full `case h` goal involving `h_a`, `h_a_fun`, `h_a₀`, etc. (1984 chars truncated) | enormous local context confirmed |
| 20 (line 48) | `lean_multi_attempt` `simp only [map_sum, LinearMap.coe_comp, Function.comp_apply]` | simp made no progress (no change to goal head) | confirmed iter-083 Finding 1: `LinearMap.coe_comp` HOU fails on `∘ₛₗ`-vs-`∘ₗ` even after `letI` surface |
| 21 (line 50) | `lean_local_search` `AddEquiv.module` | found `AddEquiv.module` and `Equiv.smul_def` | the smul-def is `r • z := e.symm (r • e z)` per `Equiv.smul_def`, which is the rewriting key |
| 27 (line 62) | `lean_loogle` `Equiv.smul_def` | got the exact signature in `Mathlib.Algebra.Group.TransferInstance` | confirmed the recipe |
| 28 (line 65) | `lean_multi_attempt` `simp only [LinearMap.coe_comp, Function.comp_apply, map_sum, LinearMap.smul_apply]` | partial — `simp` doesn't unfold `Equiv.smul_def` for the `AddEquiv.module` instance | need explicit `show` + `rw` |
| 29 (line 67) | `lean_multi_attempt` `letI hmod_pi_Z₁_alt : Module ↑R ↑(∏ᶜ Z₁) := h_mod_X₁; sorry` | success (sorry-only branch, no new errors after letI surface at the literal `↑(∏ᶜ Z₁)` type) | **NEW iter-084 finding**: binding the R-module under the literal `↑(∏ᶜ Z_i)` form (not `↑scK₀.X_i`) is the key to bridging HSMul synthesis |
| 30 (line 69) | `lean_multi_attempt` `letI hmod : Module ↑R ↑(∏ᶜ Z₁) := h_mod_X₁; rw [show (piIsoPi Z₁).toLinearEquiv.symm (r • y) = (r • ... : ↑(∏ᶜ Z₁)) from by rw [Equiv.smul_def]; rfl]` | partial — `rfl` does not close the residual at the AddEquiv.module level | the smul on the LHS uses `AddEquiv.module`'s `Equiv.smul_def`, but the RHS needs `e₁.apply_symm_apply` to collapse |
| 31 (line 71) | `lean_multi_attempt` same + `show e₁.symm (r • y) = e₁.symm (r • e₁ (e₁.symm y)); rfl` | partial — `rfl` not the closer | **NEW iter-084 finding**: the side condition is **not** rfl after the show; need `rw [LinearEquiv.apply_symm_apply]` explicitly |
| 32 (line 74) | `lean_multi_attempt` two `letI`s + `show e₁.symm (r • y) = e₁.symm (r • e₁ (e₁.symm y)); rw [LinearEquiv.apply_symm_apply]` | success on the side condition | recipe confirmed |
| 33 (line 77) | `lean_multi_attempt` same as 32 but verifying full rewrite block | success — both typeclass barriers cleared | recipe verified prior to file edit |
| 35 (line 83) | `Edit` file with the verified rewrite block + ~60-LOC comment block + preserved sorry | clean | source-level change landed |
| 37 (line 88) | `lean_diagnostic_messages` post-edit | clean (0 errors, 1 style warning, all pre-existing) | edit verified |
| 44 (line 104) | `lean_verify basicOpenCover_isCechAcyclicCover_toModuleKSheaf` | only standard axioms (propext, sorryAx, Classical.choice, Quot.sound) | no new axioms introduced |

### Remaining work (deferred to iter-085+, ~50–80 LOC)

Per `task_results/AlgebraicJacobian_Cohomology_BasicOpenCech.lean.md`:
1. `LinearMap.coe_comp` + `Function.comp_apply` to split the comp.
2. `Finset.sum_apply` + `Pi.smul_apply` (with `perI₁`) to distribute the sum across smul.
3. Per summand at fixed `i`: use `Pi.lift_π` + `Pi.π Z₁ k (e₁.symm z) = z k` to reduce j-th component of `Σ.hom (r • z)` to `restr ((presheaf.map …).hom r * z (j∘δ_i))`.
4. `RingHom.map_mul` + `← C.left.presheaf.map_comp` to collapse the algebra-map chain to `(presheaf.map (V_j ≤ U).op).hom r`, matching `perI₂ j`'s definition.
5. `Finset.smul_sum` on RHS + `Finset.sum_congr rfl` to reassemble.

### Dead-ends (preserved)

- `letI : Module ↑R ↑scK₀.X₁ := h_mod_X₁` (typed at `↑scK₀.X_i`) is **insufficient** for the HSMul synthesis even though the two types are defeq. Type-class search is syntactic.
- `simp [Equiv.smul_def]` on the side condition — does NOT fire (argument unused).
- Naive `rw [map_smul]` on the LHS — fails at `MulActionHomClass` synthesis (`e₁` is `≃ₗ[k]`, not `≃ₗ[R]`).

---

## Lane 2 — `Differentials.lean`: `h_epi` closed via Option (c) — Lane 2 closure target hit

**Status**: **RESOLVED**. The `h_epi` branch of `cotangentExactSeq_structure` (line 641–677 after the edits) is fully proved using `Submodule.span_induction` over `_root_.KaehlerDifferential.span_range_derivation`. The conjunction `h_exact ∧ h_epi` was split via `refine ⟨?h_exact, ?h_epi⟩`; only `h_exact` retains an explicit sorry at L640. Net file sorry count unchanged (5 → 5; one absorbed sorry split into one explicit sorry + one proved branch). No regression.

### Final proof (excerpted)

```lean
    refine ⟨?h_exact, ?h_epi⟩
    case h_exact =>
      sorry  -- deferred iter-085+: SheafOfModules.exact_iff_stalkwise + KaehlerDifferential.exact_mapBaseChange_map
    case h_epi =>
      apply SheafOfModules.epi_of_epi_presheaf
      rw [PresheafOfModules.epi_iff_surjective]
      intro U
      letI :=
        (((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv
              Y.presheaf X.presheaf).symm f.c).app U |>.hom.toAlgebra
      intro y
      have hspan := _root_.KaehlerDifferential.span_range_derivation
            ↑(((TopCat.Presheaf.pullback CommRingCat f.base).obj Y.presheaf).obj U)
            ↑(X.presheaf.obj U)
      have hy := hspan ▸ (Submodule.mem_top : y ∈ ⊤)
      induction hy using Submodule.span_induction with
      | mem x hx =>
        obtain ⟨b, rfl⟩ := hx
        refine ⟨CommRingCat.KaehlerDifferential.d b, ?_⟩
        unfold cotangentExactSeqBeta
        exact ModuleCat.Derivation.desc_d _ _
      | zero => exact ⟨0, map_zero _⟩
      | add x y hx hy ih_x ih_y =>
        obtain ⟨a₁, ha₁⟩ := ih_x
        obtain ⟨a₂, ha₂⟩ := ih_y
        refine ⟨a₁ + a₂, ?_⟩
        rw [map_add, ha₁, ha₂]; rfl
      | smul a x hx ih =>
        obtain ⟨a', ha'⟩ := ih
        refine ⟨a • a', ?_⟩
        rw [map_smul, ha']; rfl
```

### Attack record (iter-084 — 15 edits)

| Event | Tactic | Result | Insight |
|---|---|---|---|
| 66 (line 164) | `lean_goal` (initial attempt at relative path) | error: file not found in any Lean project | path must be absolute under LSP |
| 67 (line 166) | `lean_goal` at L645 absolute | got `(h_exact ∧ h_epi)`-style goal | starting state |
| 71 (line 174) | `lean_leansearch` `PresheafOfModules epi morphism surjective application` | found `PresheafOfModules.epi_of_surjective` + `PresheafOfModules.surjective_of_epi` | confirmed `epi_iff_surjective` is the iff form |
| 72 (line 176) | `lean_leansearch` `KaehlerDifferential span range derivation top` | found `_root_.KaehlerDifferential.span_range_derivation` | recipe key found |
| 80 (line 193) | `lean_multi_attempt` `refine ⟨?h_exact, ?h_epi⟩` + scaffold | success (sorry-only) | scaffolding verified |
| 82 (line 197) | `Edit` file: split conjunction with scaffold for both branches | clean | source change landed |
| 86 (line 207) | `lean_goal` at L650 | `Function.Surjective ⇑(ConcreteCategory.hom ((cotangentExactSeqBeta f g).val.app U))` | post-`epi_of_epi_presheaf` + `epi_iff_surjective` |
| 88 (line 211) | `lean_leansearch` `Function.Surjective range top LinearMap submodule` | found `LinearMap.range_eq_top_of_surjective` | initial (wrong) direction tried |
| 90 (line 215) | `Edit` add `rw [← LinearMap.range_eq_top]` | clean | progress |
| 92 (line 220) | `lean_goal` after rw | `(ConcreteCategory.hom ((cotangentExactSeqBeta f g).val.app U)).range = ⊤` | dead-end direction; bundled-vs-unbundled `⊤` mismatch surfaces |
| 101 (line 239) | `Edit` add `letI := …` for the algebra instance + `rw [eq_top_iff, ← span_range_derivation ..., Submodule.span_le]` | error: "Did not find an occurrence of the pattern `⊤` in the target expression `⊤ ≤ (…).range`" | the LHS `⊤` is bundled, RHS `⊤` is unbundled |
| 106 (line 251) | `Edit` simplify to `rw [eq_top_iff]; have hspan := …` and preserve sorry | clean | reset |
| 108 (line 256) | `lean_goal` | `⊤ ≤ (ConcreteCategory.hom ((cotangentExactSeqBeta f g).val.app U)).range` with `hspan` in context | better state |
| 110 (line 260) | `Edit` rewrite to direct `intro y` + `induction hy using span_induction` | clean | switch from `range_eq_top` route to `span_induction` route |
| 122 (line 287) | `lean_goal` at sorry L661 | `∃ a, (ConcreteCategory.hom ((cotangentExactSeqBeta f g).val.app U)) a = y` | post-intro state |
| 123 (line 289) | `lean_multi_attempt` `have hy : y ∈ Submodule.span … := hspan ▸ Submodule.mem_top` | error: type mismatch — the explicit Module annotation forces synthesis of bundled `Module ↑(X.presheaf.obj U) ↑((relativeDifferentials f).val.obj U)`, which fails | **NEW iter-084 finding**: do NOT write the explicit `Submodule.span ↑R ↑M ...` form; let elaboration infer it from `hspan ▸ Submodule.mem_top` |
| 124 (line 291) | `Edit` change to `have hy := hspan ▸ (Submodule.mem_top : y ∈ ⊤)` (implicit type) | clean | implicit form works |
| 126 (line 296) | `Edit` simplify the `have hy` line | clean | progress |
| 130 (line 305) | `lean_multi_attempt` `refine Submodule.span_induction (p := ...) ?_ ?_ ?_ ?_ hy` | not the cleanest pattern | switch to `induction hy using` form |
| 131 (line 307) | `lean_multi_attempt` `induction hy using Submodule.span_induction with | mem | zero | add | smul` | success (sorries-only scaffold) | scaffold verified |
| 132 (line 309) | `Edit` install the four-case `induction` scaffold with sorries | clean | scaffold landed |
| 135 (line 314), 136 (line 316) | `lean_goal` for `case h.mem`, `case h.zero` | got the per-case goals; mem case: `… (d b) = D b` | per-case state |
| 140 (line 327) | `lean_multi_attempt` mem case `unfold cotangentExactSeqBeta; rw [ModuleCat.Derivation.desc_d]; rfl` | partial — the `rfl` after rw is the residual | mem case recipe known |
| 142 (line 331) | `Edit` mem case → `unfold cotangentExactSeqBeta; exact ModuleCat.Derivation.desc_d _ _` | clean | mem case closed |
| 146 (line 341) | `Edit` install zero/add/smul cases with `exact ⟨0, map_zero _⟩` / `exact ⟨a₁+a₂, by simp [ha₁, ha₂]⟩` / `exact ⟨a • a', by simp [ha']⟩` | error: unsolved goals on the simp side conditions | `simp` overshoots |
| 148 (line 346) | `Edit` change `add`/`smul` to `refine ⟨…, ?_⟩; rw [map_add, ha₁, ha₂]` | error: still unsolved | the `rw` leaves a residual reflexivity goal of the form `x + y = x + y` |
| 150 (line 351) | `Edit` change to `refine ⟨…, ?_⟩; rw [map_add, ha₁, ha₂]; rfl` | error (one branch still failed) | progress on add but smul still requires the same fix |
| 152 (line 356) | `Edit` apply the same `; rfl` trailing fix to smul as well | **clean (0 errors)** | both branches closed |
| 153 (line 359), 154 (line 362) | `lean_diagnostic_messages` | clean | **Lane 2 fully closed except for `h_exact` sorry at L640** |
| 158 (line 371) | `lean_verify cotangent_exact_sequence` | only standard axioms | no new axioms |

### Key insight that unblocked iter-083's typeclass barrier

The iter-083 plan's Option (c) recipe was correct in **shape** but overspecified the membership claim, forcing the elaborator to synthesize `Module ↑(X.presheaf.obj U) ↑((relativeDifferentials f).val.obj U)` — which fails because the natural module is over the forget₂-image `RingCat`. **The fix** is to let elaboration infer the membership type: `have hy := hspan ▸ (Submodule.mem_top : y ∈ ⊤)`, and the inferred type threads through both `span_range_derivation` and the induction without ever forcing the explicit `Module` synthesis. The `Algebra` instance is introduced as an untyped `letI :=` (no explicit `: Algebra A B` annotation), so `f.hom.toAlgebra` can be matched against the bundled `CommRingCat.KaehlerDifferential`'s internal `letI`-block.

### Mathlib lemmas used (Lane 2)

- `SheafOfModules.epi_of_epi_presheaf` (project-local, iter-079).
- `PresheafOfModules.epi_iff_surjective` (Mathlib).
- `_root_.KaehlerDifferential.span_range_derivation` (Mathlib).
- `Submodule.mem_top`, `Submodule.span_induction` (Mathlib).
- `ModuleCat.Derivation.desc_d` (Mathlib) — **key for the mem case**: closes `((isUniversal' φ_fg').desc d1).app U) (d b) = d2.d b` after `unfold cotangentExactSeqBeta`.
- `map_zero`, `map_add`, `map_smul` (general).

### Dead-end note (preserved in code as comment)

The iter-083-attempted `LinearMap.range_eq_top` + `rw [← span_range_derivation]` path fails: the `⊤` on the LHS of the `eq_top_iff`-style goal has type `Submodule ↑(X.presheaf.obj U) ↑((relativeDifferentials f).val.obj U)`, while `span_range_derivation`'s `⊤` is over the unbundled `_root_.KaehlerDifferential A B` type. Lean's `rw` cannot bridge these definitionally-equal but syntactically-distinct types. **Solution**: avoid `LinearMap.range_eq_top` entirely; use `Submodule.span_induction` directly on `hy : y ∈ ⊤` (with implicit type).

---

## Key findings / proof patterns discovered (iter-084 — NEW)

1. **`letI` binding under the literal target type (not the abbreviation)** *(NEW iter-084, BasicOpenCech)*: `letI : Module ↑R ↑(∏ᶜ Z₁) := h_mod_X₁` succeeds where `letI : Module ↑R ↑scK₀.X₁ := h_mod_X₁` fails for HSMul synthesis, even though `↑(∏ᶜ Z₁) = ↑scK₀.X₁` is rfl. Typeclass search is syntactic.

2. **`show e₁.symm (r • y) = e₁.symm (r • e₁ (e₁.symm y)); rw [LinearEquiv.apply_symm_apply]` to commute `AddEquiv.module`'s smul past `e.symm`** *(NEW iter-084, BasicOpenCech)*. The `AddEquiv.module R e` instance defines `r • z := e.symm (r • e z)`; substituting `z = e.symm y` and collapsing via `e.apply_symm_apply` gives the desired commutation. `simp [Equiv.smul_def]` does NOT fire on this; need explicit `show` + `rw`.

3. **Implicit-type membership via `hspan ▸ Submodule.mem_top`** *(NEW iter-084, Differentials)*: when the explicit type annotation forces synthesis of a bundled `Module` instance that doesn't exist, write `have hy := hspan ▸ (Submodule.mem_top : y ∈ ⊤)` and let elaboration infer the membership type from `hspan`. This sidesteps the iter-082's "Submodule.span_induction under bundled ModuleCat (forget₂-image) setup fails" blocker.

4. **`Submodule.span_induction` four-case `induction … using … with | mem | zero | add | smul`** *(NEW iter-084, Differentials)*: standard four-case pattern. The `mem` case closes via `obtain ⟨b, rfl⟩ := hx; refine ⟨preimage, ?_⟩; unfold map_under_proof; exact KEY_d_lemma`. The `add`/`smul` cases require trailing `rfl` after `rw [map_add/map_smul, ha₁, ha₂/ha']` because `rw` leaves the structural-equality `x + y = x + y` reflexivity goal explicit.

5. **`unfold cotangentExactSeqBeta` + `ModuleCat.Derivation.desc_d`** *(NEW iter-084, Differentials)*: the bundled `desc d` collapses against `d b` to the inner derivation's value, which equals `D b` after the letI bridges `D` ≡ `_root_.KaehlerDifferential.D A B`.

---

## Recommendations for next session

See `recommendations.md`. Headlines:
- **Lane 2 next**: close `h_exact` at Differentials.lean L640 via `SheafOfModules.exact_iff_stalkwise` + `KaehlerDifferential.exact_mapBaseChange_map`. The Lane 2 helper structure now exists (iter-083: `cotangentExactSeqBeta_hη`; iter-084: `h_epi` proof structure as in-code reference for the `Submodule.span_induction` recipe). Estimate: ~40–80 LOC, two new project-local helpers OK.
- **Lane 1 next**: per-summand `Φ_j` construction with explicit `map_smul'`. Both iter-083 typeclass barriers are now resolved; residual is genuine R-linearity content. Estimate: ~50–80 LOC.
- **Realistic iter-085 target**: net **−1 to −2** sorries (12–13 active).

---

## Blueprint markers updated (manual)

None this iteration. The deterministic `sync_leanok` phase (commit `archon[084/marker-sync]: +1 -0`) added `\leanok` to `thm:cotangent_exact_sequence` (Differentials.tex line 131–) — that was the script's domain, not mine. I did not add or remove any `\leanok`, `\mathlibok`, `\lean{...}`, or `\notready` markers myself.

No new declarations were introduced by the provers this iteration (both task results explicitly state "no new helpers"), so no `\lean{...}` rename was needed. No `\mathlibok` opportunities surfaced (Lane 2 used Mathlib lemmas in the proof body, but the *declaration* `cotangentExactSeq_structure` is project-local with a nontrivial Archon-side proof obligation — `\leanok` is the appropriate marker once the remaining `h_exact` sorry is closed, not `\mathlibok`). No `\notready` markers exist anywhere in `blueprint/src/chapters/*.tex` (`grep -nE "notready" blueprint/src/chapters/*.tex` returns nothing), so none to strip. No `% NOTE:` annotations needed (no translation obstacles surfaced this iter).

---

## Process discipline (iter-084 retro)

- Two-lane parallel dispatch ran cleanly. Lane 2 hit its closure target; Lane 1 hit its structural target.
- Zero new axioms; zero new project-local helper lemmas (per task reports, both lanes preserved iter-079/081/082/083 byte-for-byte).
- 17 source edits (2 BasicOpenCech, 15 Differentials); 17 `lean_diagnostic_messages` calls; 16 `lean_goal` checks; 23 lemma searches; 0 `lean_run_code` pre-validation (per user policy).
- `lean_multi_attempt` used productively for both position-bound previews (Lane 1: events 28, 29, 30, 31, 32, 33) and recipe validation (Lane 2: events 80, 109, 115, 117, 123, 130, 131, 136, 140, 141, 145).
- Lane 2 conditional clause respected: `h_exact` was preserved as an explicit sorry (deferred to iter-085+) rather than packaging it free-floating.
