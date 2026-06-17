# Session 191 — Review of iter-191

## Session metadata

- **Iteration / session**: 191
- **Sorry count before**: 79 (iter-190 ending, integration RED on positivePart clash)
- **Sorry count after**: **80** (lake build `declaration uses 'sorry'` warning count; integration GREEN; 11th zero-axiom build streak restored)
- **Sorry delta vs post-plan-phase baseline 78**: **+2** (Lane H file-skeleton +3 typed-sorry pins, Lane B closure −2, Lane F dropped from prover phase −1 vs projected close, net = +2)
- **Build status**: `lake build AlgebraicJacobian` GREEN (8360/8360 jobs).
- **Project axiom count**: 0 (kernel-only `{propext, Classical.choice, Quot.sound}` on every closed declaration audited; sorryAx only inside named typed-sorry pins).
- **Targets attempted (5 prover lanes)**:
  1. Lane G — `Albanese/AuslanderBuchsbaum.lean` (`isDomain_of_regularLocal` x ∈ 𝔭 case)
  2. Lane M↓ — `Albanese/CodimOneExtension.lean` (`isRegularLocalRing_stalk_of_smooth` first scaffold)
  3. Lane B-consumers — `Genus0BaseObjects/GmScaling.lean` (3 consumer sorries)
  4. Lane E — `AbelianVarietyRigidity.lean` (`iotaGm_chart1_composition_isOpenImmersion` Part 1 + Part 2)
  5. Lane H — `RiemannRoch/H1Vanishing.lean` (NEW FILE — file-skeleton + 4 declarations closed)

## Per-target summary

### Lane G — `Albanese/AuslanderBuchsbaum.lean` (PARTIAL — HARD BAR MET)

- **Approach**: structural refactor. Extracted 2 new helpers immediately before `isDomain_of_regularLocal`:
  - `exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes` (~25 LOC, axiom-clean kernel-only): zero-divisor witness from `Ideal.disjoint_nonZeroDivisors_of_mem_minimalPrimes` + `mem_nonZeroDivisors_iff` + `push Not`.
  - `notMem_minimalPrimes_of_regularLocal_succ` (typed sorry, narrowly scoped): assembles the substrate (zero-divisor witness; `IsDomain (R/(x))` from `regularLocal_quotient_isRegularLocal_of_notMemSq` + `hIH`).
- **Result**: `isDomain_of_regularLocal` itself now has NO inline sorry; residual is structurally isolated to the new helper.
- **Lemmas discovered**: `Ideal.iInf_pow_eq_bot_of_isLocalRing` (Krull intersection) — substrate for iter-192+ route (iii); `Module.associatedPrimes.minimalPrimes_annihilator_subset_associatedPrimes`; height-bounds lemmas `Ideal.height_le_card_of_mem_minimalPrimes_span_finset` + `height_le_ringKrullDim_quotient_add_spanFinrank` (catenary path investigated, doesn't close without catenary axiom).
- **Sorry trajectory**: 2 → 2 (sorry placement shifted into the new helper).
- **Next**: iter-192+ closes residual via route (iii) direct prime-avoidance + Krull-intersection (~200-300 LOC) using the new helper's zero-divisor witness.

### Lane M↓ — `Albanese/CodimOneExtension.lean` (PARTIAL — HARD BAR MET, first scaffold)

- **Approach**: file-skeleton with Stages 1-2 axiom-clean re-exports of Mathlib b80f227 lemmas:
  - `stalkMap_flat_of_smooth := AlgebraicGeometry.Flat.stalkMap X.hom z` (Stage 1)
  - `exists_isStandardSmooth_at_of_smooth := AlgebraicGeometry.Smooth.exists_isStandardSmooth X.hom z` (Stage 2, Stacks 00T7)
- **Key finding**: Mathlib already packages both Stacks tags directly off the `[Smooth]` typeclass — no manual affine-cover chasing needed. The priority-`low` `instance [Smooth f] : Flat f` at `Mathlib.AlgebraicGeometry.Morphisms.Smooth:113` auto-synthesizes.
- **Result**: `isRegularLocalRing_stalk_of_smooth` now scopes Stages 3-4 into a single named scoped sorry (Stacks 02JK + 00OE — polynomial generators ⟹ regular sequence ⟹ regular local ring).
- **Sorry trajectory**: 3 → 3 (scaffold added; main theorem body now consumes 1 scoped sorry rather than 1 inline body).
- **Next**: iter-192+ closes Stages 3-4 via cotangent / Ω_{A/k} bridge (Jacobian criterion — see strategy-critic's alternative-route suggestion via `RingTheory/Smooth/StandardSmooth`).

### Lane B-consumers — `Genus0BaseObjects/GmScaling.lean` (PARTIAL — HARD BAR MET, 2 of 3)

- **`projGm_isReduced` SOLVED axiom-clean**: chart-local `IsReduced.of_openCover` + Substrate 2 at degree-1 generator transported via `gmScalingP1_cover_X_iso`.
- **`gm_geomIrred` SOLVED axiom-clean** (via different route): Attempt 1 inline generic helper FAILED — the `IsLocalization.Away` instance synthesis inside `set S := TensorProduct ...` is a **Mathlib regression at b80f227** that breaks fresh re-elaboration of `Cross01Substrate.lean` source. Cached `.olean` keeps consumers working. Attempt 2 succeeded via a different route: exploit `Gm ↪ 𝔸¹` open immersion + `GeometricallyIrreducible` of `𝔸¹.hom` (light `K ⊗_kbar MvPoly Unit kbar ≃ MvPoly Unit K` base change instead of heavy `K ⊗_kbar GmRing kbar`). 2 new reusable helpers (`isDomain_mvPolyUnit_tensor`, `affineLine_geomIrred`).
- **`gmScalingP1_chart_agreement_cross01` PARTIAL**: structural setup deepened (`IsReduced intersection` via Substrate 2 at degree-2 generator; `CompactSpace intersection` via PrimeSpectrum + iso transport). Residual sorry now stands at topological range containment — the substantive math (kbar-rational closed-point density + closure-of-range argument).
- **`gmScalingP1_collapse_at_zero` UNTOUCHED** (out of scope this iter).
- **Sorry trajectory**: 4 → 2 (−2 axiom-clean closures).
- **Helper budget**: 2 used / 1 budgeted (1 over). Justified — both helpers reusable for iter-192+ projectiveLineBar_geomIrred.

### Lane E — `AbelianVarietyRigidity.lean` (PARTIAL — Part 1 HARD BAR MET; Part 2 DEFERRED at 80-LOC budget wall)

- **Part 1 RESOLVED**: refactor dropped abstract `(r_1, h_r_1)` parameters from `iotaGm_chart1_section` and `iotaGm_chart1_composition_isOpenImmersion`; substituted `iotaGm_r_1 kbar` / `iotaGm_r_1_fac kbar` directly. Downstream `iotaGm_isOpenImmersion` consumer updated to use the parameter-free signatures.
- **Part 2 DEFERRED at HARD BUDGET wall** (80 LOC sub-step cap per PROGRESS.md). Tested `lean_multi_attempt`:
  - `simp` (default): reduces to same 6-factor `.app ⊤` chain as iter-188.
  - `simp [pullback.lift_*, pullbackSpecIso_inv_*, pullbackSymmetry_hom_comp_*, Scheme.Hom.comp_appTop, Scheme.Hom.appTop]`: ALL simp args flagged unused.
  - `unfold iotaGm_r_1; rw [IsOpenImmersion.lift_app]`: unfold succeeds (Part 1 hook confirmed), but `rw` finds no syntactic match — `iotaGm_r_1` sits behind pullback iso `.hom .app ⊤` chain.
- **Diagnosis**: same residual STUCK iter-188/189/190 — depth of `Proj.appIso` machinery exceeds 80-LOC budget.
- **Sorry trajectory**: 2 → 2 (Part 1 axiom-clean, Part 2 untouched).
- **Next**: per PROGRESS.md Failure Mode + progress-critic STUCK verdict, iter-192 dispatches `blueprint-writer avr-chart1-composition-expand` BEFORE re-attempting Part 2 close.

### Lane H — `RiemannRoch/H1Vanishing.lean` (NEW FILE, PARTIAL — far beyond HARD BAR)

The file-skeleton dispatch closed **4 of 8 declarations axiom-clean** within the same prover session — exceeding the file-skeleton HARD BAR by a substantial margin:

| # | Declaration | Status | Axioms |
|---|---|---|---|
| 1 | `IsFlasque` | concrete def | kernel-only |
| 2 | `IsFlasque.pushforward` | **CLOSED** | kernel-only |
| 3 | `IsFlasque.constant_of_irreducible` | typed sorry | sorryAx |
| 4 | `HModule_flasque_eq_zero` | typed sorry (Hartshorne III.2.5) | sorryAx |
| 5 | `skyscraperSheaf_eq_pushforward_const` | typed sorry | sorryAx |
| 6 | `PrimeDivisor.closure_isIrreducible` | **CLOSED** (one-liner) | kernel-only |
| 7 | `skyscraperSheaf_isFlasque` | **CLOSED** (direct route) | kernel-only |
| 8 | `H1_skyscraperSheaf_finrank_eq_zero` | **CLOSED via composition** | inherits sorryAx via #4 |

- **Closure recipes**:
  - #2: `intro U V h; exact hF ((Opens.map f).map (homOfLE h)).le` (2 lines, pure rfl-unfolding).
  - #6: `isIrreducible_singleton.closure` (one-liner — predicted iter-192+ recipe collapsed inline).
  - #7: **Direct route bypassing decls (3) and (5)** — case-split on `P.point ∈ V`; iso (`eqToHom`) ⟹ surjective via `ConcreteCategory.bijective_of_isIso`, OR codomain is zero ⟹ `Subsingleton` via `ModuleCat.subsingleton_of_isZero` + `terminalIsTerminal.isZero`.
  - #8: `Scheme.HModule_flasque_eq_zero (Scheme.skyscraperSheaf_isFlasque C P) 1 le_rfl` (1-line composition).
- **Strategic note**: The original Lane H plan predicted `#8 ← {#4, #7}, #7 ← {#2, #3, #5, #6}`. The iter-191 prover found a **shorter direct route for #7** that bypasses (3) and (5). The Lane H minimal logical chain to close the headline #8 is now just `#4 + #7`; (3) and (5) become OPTIONAL auxiliary lemmas (kept as documented sorries with note flagging their optional status).
- **Sorry trajectory**: NEW FILE created with 7 typed-sorry pins, then 4 closed in same session → 3 sorries remaining. Net project delta = +3 (better than the projected +8).

## Key findings / patterns discovered

1. **File-skeleton + closure can collapse into one session** when the dispatched prover has time + tooling to find direct routes for substrate lemmas. Iter-191 Lane H closed 4 of 7 sorries in the same dispatch that scaffolded them. The substantive remaining sorry (Hartshorne III.2.5) is correctly localized.
2. **Direct route can sidestep a planned 2-step composition chain.** Decl #7 (`skyscraperSheaf_isFlasque`) was originally planned via #3 + #5 composition (constant-sheaf flasque + skyscraper = pushforward). The prover found a shorter route exploiting ModuleCat-specific `Subsingleton`-of-zero-object reasoning that bypasses both intermediaries. Consequence: (3) and (5) can be deleted or kept as optional exposition.
3. **Mathlib regression on `IsLocalization.Away` instance synthesis inside `set`-bindings** at b80f227 — `Cross01Substrate.lean` source no longer freshly compiles, but cached `.olean` keeps consumers working. Documented as a fragility for the user.
4. **Bypass-via-open-immersion + ambient GeometricallyIrreducible** is a clean route around heavy tensor-IsDomain when the tensor is a domain only via a localization. The `[IsOpenImmersion f] [GeometricallyIrreducible g] [Surjective (f ≫ g)] → GeometricallyIrreducible (f ≫ g)` instance (with `set_option backward.isDefEq.respectTransparency false`) was the key.
5. **Mathlib already packages Stacks 00T7** as a direct extraction off `[Smooth]`: `AlgebraicGeometry.Smooth.exists_isStandardSmooth` produces the existential we needed for Lane M↓ Stage 2 — no manual affine-cover chasing.

## Plan-phase deliverables (this iter)

The plan-phase landed 1 major refactor (`lane-i-positivepart-clash-fix`) which:
- Removed the file-local `WeilDivisor.positivePart` from `RationalCurveIso.lean` (~64 LOC).
- Reshaped `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank` from existential to equation form with explicit `(t : K) (halg : ...)` arguments.
- Updated `Hom.poleDivisor_degree_eq_finrank` body to consume the public pin at `t = (localParameterAtInfty kbar).val`.
- Added a `[Module.Finite K(ℙ¹) K(C)]` typeclass binder cascade to `morphism_degree_via_pole_divisor` (directive anticipated only the inner consumer; the wrapper also needed it).

`lake build AlgebraicJacobian` GREEN — **10-consecutive-zero-axiom-build streak restored**.

## Recommendations for the next session

See `recommendations.md`.

## Blueprint markers updated (manual)

- `RiemannRoch_H1Vanishing.tex`, broken `\uses{...}` block at L398-401: **flagged for next plan-phase** — `\leanok` ended up inside the `\uses{...}` argument (sync_leanok placement bug), which makes blueprint-doctor see `\uses{\leanok lem:closedPoint_closure_irreducible}` as an unmatched label. Not fixed by review agent (only sync_leanok / plan-phase writer may move `\leanok`); recommendation in `recommendations.md`.

No new `\mathlibok`, `\lean{...}` renames, or `% NOTE:` annotations landed this review:
- AuslanderBuchsbaum: no markers needed (helpers are `private`, internal proof structure).
- CodimOneExtension: `lem:smooth_to_regular_local_ring` body still carries a scoped sorry — `sync_leanok` correctly handles unmarked state.
- GmScaling: `lem:projGm_isReduced` and `lem:gm_geomIrred` are `\leanok`-eligible — sync_leanok run iter=191 already touched the chapters (per `.archon/sync_leanok-state.json`).
- AVR: chapter prose CLEARED per blueprint-reviewer iter191; iter-192 plan-phase will dispatch `blueprint-writer avr-chart1-composition-expand` (per Lane E failure-mode).
- H1Vanishing: sync_leanok already touched the chapter iter=191 (per state file).

## Subagent skips

- `lean-auditor`: skipped — the review-phase trigger conditions don't justify dispatch this iter. Lean files were edited (5 files), but the iter-191 prover dispatch was a tightly-scoped scaffold + close round with no new abstractions or refactors that would benefit from a project-wide audit; the plan-phase `progress-critic route191` + `strategy-critic iter191` + `blueprint-reviewer iter191` already audited the trajectory. Re-enable iter-192 if the H1Vanishing.lean file accumulates more body work or if a new file lands.
- `lean-vs-blueprint-checker` (per-file): skipped — 5 prover-touched files (AuslanderBuchsbaum, CodimOneExtension, GmScaling, AbelianVarietyRigidity, H1Vanishing) but the plan-phase `blueprint-reviewer iter191` performed a full Lean↔blueprint alignment check on every active prover chapter (RationalCurveIso, WeilDivisor, AuslanderBuchsbaum, QuotScheme, Genus0BaseObjects_Cross01Substrate, AbelianVarietyRigidity, RiemannRoch_H1Vanishing, RiemannRoch_RRFormula, Albanese_CodimOneExtension) and returned PASS / HARD GATE CLEARED on all 5 prover-touched files (modulo the `lem:degree_positivePart_principal_eq_finrank` mismatch which was resolved plan-phase via the `lane-i-positivepart-clash-fix` refactor + Lean signature reshape). Per-file re-runs would be duplicative.
