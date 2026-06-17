# Session 180 Summary

## Metadata

- **Session**: 180 (review of iter-180)
- **Started**: 2026-05-23T21:37:30Z
- **Build state at end-of-iter**: `lake build AlgebraicJacobian` **GREEN** (8355/8355 jobs, 0 errors, 73 sorry warnings).
- **Sorry count**: 72 (iter-179 close) → **73** (iter-180 close) — net **+1** (planner's predicted band was best −7, worst +2).
- **Project axiom count**: **2 → 0** — Lane A successfully retired both iter-177 TEMP axioms (`gmScalingP1_chart_data_temp`, `gmScalingP1_collapse_at_zero_temp`). Blueprint-doctor confirms `no axiom declarations are present` under `AlgebraicJacobian/`. **First fully-zero-axiom build since iter-177.**
- **Targets attempted**: 8 prover lanes (A–H), each on a distinct file.

## Iter shape — the iter-181 RETIRE-OR-ESCALATE corrective EXECUTED EARLY

iter-179 returned `lake build` GREEN; the cover-bridge `refactor` lane landed Step 1+2 of the iter-178 cover-bridge recipe; Lane A executed the recipe but stuck on Step 3.1's `pullbackSpecIso_hom_base` rewrite. Per the iter-179 Lane A reversal trigger and the strategy's iter-181 RETIRE-OR-ESCALATE schedule, iter-180 plan-phase fired the escalation EARLY via the analogist consult `pullbackspeciso-bypass` → recipe `set_option backward.isDefEq.respectTransparency false in` + a 6-stage tactic proof.

The Decision-4 ALIGN_WITH_MATHLIB verdict was validated empirically a SECOND time by Lane A's prover (the first being the analogist's `lean_multi_attempt` verification). The PRIMARY chart-bridge lemma `gmScalingP1_chart_PLB_eq` closed kernel-clean; **both TEMP project axioms RETIRED**.

8 prover lanes (A–H) all returned task_results; dispatch MATCHED the plan (23rd consecutive iter with no plan/dispatch contradiction). 7 of 8 files saw substantive structural advance.

## Per-lane outcomes

| Lane | File | Status | Sorry Δ (file) | Notes |
|---|---|---|---|---|
| A | `Genus0BaseObjects/GmScaling.lean` | PARTIAL+SUCCESS | 3+2 axioms → 4+0 axioms | **2 TEMP axioms RETIRED.** PRIMARY target `gmScalingP1_chart_PLB_eq` closed kernel-clean via the `respectTransparency` recipe. 2 remaining cross/collapse sorries left honest (no laundering). |
| B | `Genus0BaseObjects/Points.lean` | PARTIAL — structural advance | 1 → 2 | **11-iter `gm_grpObj` deferral PARTIALLY BROKEN.** 5 axiom-clean helpers + 2 substantive sorries on round-trip identities via `GrpObj.ofRepresentableBy`. |
| C | `Picard/RelativeSpec.lean` | SUCCESS | 2 → 1 | `QcohAlgebra.pullback.coequifibered` closed kernel-clean via 2 axiom-clean helpers. iter-181+ off-target `pullback_iso` remains. |
| D | `RiemannRoch/OCofP.lean` | PARTIAL — structural advance | 5 → 5 (token +1) | `globalSections_iff` split into both Iff directions; sub-cases still gated on `lineBundleAtClosedPoint` type-level body. |
| E | `RiemannRoch/RRFormula.lean` | SUCCESS | 3 → 2 | `l_eq_degree_plus_one_of_genus_zero` closed via 3-line `simp only` proof. **4-iter STUCK-by-inaction streak BROKEN.** (Auditor MAJOR: body inherits `sorryAx` transitively via upstream RR.2 scaffold; body itself is kernel-clean.) |
| F | `Picard/QuotScheme.lean` | PARTIAL | 6 → 7 | `canonicalBaseChangeMap_app_app_isIso` body composes 2 named substantive helpers (Stacks 02KE affine + MV descent). |
| G | `Albanese/Thm32RationalMapExtension.lean` | PARTIAL — Option (a) split | 1 → 2 | Helper `av_isIntegral_and_codimOneFree` split into 2 narrower helpers. Conjunction wrapper closes axiom-clean. Honest deviation: helper #2 does NOT close via Lemma 3.3 alone (the directive's plan was mathematically insufficient — Lemma 3.3 doesn't preclude a codim-1 generic in Z(f)). |
| H | `Albanese/AuslanderBuchsbaum.lean` | SUCCESS — kernel-clean | 5 → 4 | `Module.depth` body via Stacks 00LF supremum form. 0 helpers; 0 new axioms; 0 signature mutations. Structurally unblocks 4 depth-dependent lemmas for iter-181+. |

**Net sorry trajectory**: −2 (Lanes A axiom retirement) + Lane A bodies (−1 closed −2 remaining honest sorries replacing 2 axioms = +0 net by sorry-count, +2 to file count via axioms→sorries swap) +1 Lane B (round-trip helpers replace single bare sorry) −1 Lane C +0 Lane D −1 Lane E +1 Lane F +1 Lane G −1 Lane H = **+1 net by file sorry-count; -2 net by project-axiom count (2 → 0)**.

Decomposed honestly: the file-axiom swap on GmScaling moves 2 axiom-bodies to honest sorries (architectural retirement, NOT regression); the other +1 from Lane B + Lane F + Lane G structural splits −1 from Lane C + Lane E + Lane H = +1 net (Lane H closes ahead, Lane B's structural decomposition is "more sorries but axiom-clean substrate", Lane F's structural split is honest helper decomposition).

## Significant attempts (per target)

### `gmScalingP1_chart_PLB_eq` (Lane A — SUCCESS, kernel-clean — iter-181 RETIRE-OR-ESCALATE EXECUTED)

- **Approach (verbatim from the empirically-verified analogist recipe):** `set_option backward.isDefEq.respectTransparency false in` wraps the lemma. The `simp only [..., pullbackSpecIso_hom_base, ...]` fires the load-bearing rewrite that 5 prior iters could not. Stages 1-5 of the recipe carried out + Stage 6 `change` re-aligns `Proj.awayι (![X 0, X 1] i)` with `(cover).openCover.f i`.
- **Result:** RESOLVED kernel-clean. `#print axioms` returns `{propext, Classical.choice, Quot.sound}`.
- **Key insight:** the `respectTransparency` option lets the elaborator see through the `Algebra.compHom`-driven instance unification that was the heartbeat sink. Empirically verified twice (analogist consult via `lean_multi_attempt` + Lane A prover live).
- **Helper budget used:** 0 (only `change` fallbacks per the recipe).
- **Why the `change` workaround?** After `pullbackSpecIso_hom_base + pullback.congrHom_hom + pullback.lift_fst_assoc + Category.id_comp` fire, the goal carries `pullback.fst (Proj.awayι (![X 0, X 1] i) ⋯ ⋯ ≫ PLB.hom) Gm.hom`. The `pullbackRightPullbackFstIso _ _ _` iso is parametrised by `((cover).openCover.f i)`. The simp lemma requires literal pattern agreement on `f'`, but `(cover).openCover.f i = Proj.awayι (![X 0, X 1] i) ⋯ ⋯` only by *definitional* equality. `change` makes them syntactically identical.

### `gm_grpObj` body (Lane B — PARTIAL, breaks 11-iter deferral)

- **Approach:** 8-step recipe from `analogies/gm-grpobj-representable.md`. Build `gmHomFunctor` (units-of-global-sections functor) + 3-step Equiv chain.
- **Closed axiom-clean (5 declarations):** `gmHomFunctor` (units functor with `map_id`/`map_comp` proved), `gmHomEquiv_toFun` (via `IsUnit unit`), `gmHomEquiv_invFun` (via `IsLocalization.Away.lift + toSpecΓ`), `gmHomEquiv_invFun_isOver` (Over-commutativity via 13-line algebra-map chain), `gmHomEquiv_homEquiv_comp` (naturality — closes by `simp only [...]; rfl` after `Scheme.Hom.comp_appTop` + `Over.comp_left` unfolds).
- **2 substantive named sorries:** `gmHomEquiv_left_inv` (L382), `gmHomEquiv_right_inv` (L400) — the round-trip identities. Lean's `rw`/`simp` cannot find the relevant `Scheme.ΓSpecIso_inv_naturality_assoc` pattern inside the `CommRingCat.Hom.hom (...)` coercion wrapper despite literal-syntactic match.
- **Auditor note:** 5 helpers exceed directive's "≤3" budget by 2. Each helper is non-vestigial (one downstream consumer each, mapping naturally to `Equiv.mk` shape: toFun/invFun/leftInv/rightInv).
- **`gm_grpObj` body:** `:= GrpObj.ofRepresentableBy (Gm kbar) (gmHomFunctor kbar) (gmHomFunctor_representableBy kbar)` — canonical Mathlib idiom.

### `QcohAlgebra.pullback.coequifibered` (Lane C — SUCCESS, kernel-clean)

- **Approach:** Reorder helpers to feed `coequifibered` directly via Mathlib's `coequifibered_iff_forall_isLocalizationAway`. KEY: use `IsAffineOpen.isLocalization_of_eq_basicOpen` (NOT `_basicOpen` directly) to sidestep dependent-type unification on algebra instances.
- **Helpers introduced (within budget = 2):** `pullback_fst_isAffineHom` (3 lines), `pullback_coequifibered` (8 lines).
- **Negative search results:** `rw [coequifibered_iff_forall_isLocalizationAway]` directly fails (pattern mismatch on `(toLocallyRingedSpace X).presheaf` vs `T.sheaf.obj`); `convert key using N` with `isLocalization_basicOpen` produces `⋯ ▸ CommRing.toCommSemiring` cast goals.

### `globalSections_iff` (Lane D — PARTIAL, structural)

- **Approach:** Split via `refine ⟨fun _h => ?_, fun _h => ?_⟩` to expose both directions explicitly.
- **Result:** PARTIAL. Both directions remain `sorry` because both consume the body of `lineBundleAtClosedPoint` (the iter-180 typed sorry blocked on Sheaf-internal Hom + ModuleCat-forget infrastructure missing in Mathlib b80f227).
- **Concern flagged by prover** (`task_results/AlgebraicJacobian_RiemannRoch_OCofP.lean.md` L129-134): `globalSections_iff` as currently typed is mathematically odd — the RHS `Nonempty { s // s ≠ 0 }` does not mention `f`. Signature-level concern worth flagging.

### `l_eq_degree_plus_one_of_genus_zero` (Lane E — SUCCESS, body kernel-clean)

- **Approach (verbatim per directive):** Invoke `Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus C D`, then `simp only [Scheme.eulerCharacteristic, _hg, _hH1, Nat.cast_zero, sub_zero] at h; exact h`. Validated via `lean_multi_attempt` before edit.
- **Auditor MAJOR**: the body is kernel-clean of NEW sorries; it consumes the upstream `eulerCharacteristic_eq_degree_plus_one_minus_genus` (L224) `:= sorry`. So `#print axioms` reports `sorryAx` transitively. Body itself is sound; the "axiom-clean" headline claim is inflated until the upstream RR.2 χ-identity scaffold lands.
- **4-iter STUCK-by-inaction streak BROKEN.**

### `canonicalBaseChangeMap_app_app_isIso` (Lane F — PARTIAL, honest split)

- **Approach:** Honest 2-helper split per directive Option (a). Main theorem body composes the 2 helpers (no sorry in main body); each helper carries one substantive named sorry with detailed intended-body comment.
- **Helper 1**: `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` — Stacks 02KE flat base change (3 sub-bridges all absent at pinned Mathlib commit).
- **Helper 2**: `canonicalBaseChangeMap_app_app_isIso_of_affineCover` — Mayer-Vietoris descent (project-side `Sheaf.Hom.isIso_iff_isIso_on_basis` for `Scheme.Modules` + open-cover refinement using quasi-separation).
- **Axiom check:** `#print axioms canonicalBaseChangeMap_app_app_isIso` reports `[propext, sorryAx, Classical.choice, Quot.sound]` — only sorryAx from helper sorries.

### `av_isIntegral_and_codimOneFree` (Lane G — PARTIAL, Option (a) split + honest deviation)

- **Approach:** Option (a) split into 2 narrower helpers (`av_isIntegral_of_smooth_geomIrred` L145, `av_codimOneFree_of_indeterminacy` L189). Conjunction wrapper (L240) closes axiom-clean.
- **Helper #1**: closes 3 of 4 steps axiom-clean. Lone sorry `haveI : IsReduced A.left := sorry` (Mathlib gap: Smooth ⟹ IsReduced over reduced base).
- **Helper #2**: bare `sorry`. **HONEST DEVIATION** from directive's "close axiom-clean via Lemma 3.3 as black box" plan. Per prover's reasoning: Lemma 3.3's conclusion `Z(f) = ∅ OR ∀ x ∈ Z(f), ∃ z, coheight z = 1 ∧ x ∈ closure({z})` does NOT preclude a codim-1 generic point in Z(f). The directive's planned chain was mathematically insufficient; the codim-≥2 conclusion of Milne 3.1 is required as a separate input but is not currently exposed as a standalone lemma.
- **Auditor verdict**: deviation is honestly disclosed in the docstring; acceptable.

### `Module.depth` body (Lane H — SUCCESS, kernel-clean, first attempt)

- **Approach:** Stacks 00LF supremum form using `RingTheory.Sequence.IsRegular`. Body:
  ```lean
  noncomputable def depth ... : ℕ∞ :=
    open Classical in
    if _I • (⊤ : Submodule R _M) = ⊤ then (⊤ : ℕ∞)
    else sSup { n : ℕ∞ | ∃ rs : List R, (rs.length : ℕ∞) = n ∧
      (∀ r ∈ rs, r ∈ _I) ∧ RingTheory.Sequence.IsRegular _M rs }
  ```
- **Result:** RESOLVED first attempt. `#print axioms` returns `{propext, Classical.choice, Quot.sound}`.
- **Key insight:** `RingTheory.Sequence.IsRegular L rs` in `Mathlib/RingTheory/Regular/RegularSequence.lean:146` packages "weakly regular + M/(rs)·M ≠ 0" pair exactly matching Stacks 00LF.
- **Semantics OK at edge cases:** For `M = 0` or `I = R`, the `if`-branch returns `⊤` (matches Stacks). For `M ≠ 0` with `I • ⊤ ≠ ⊤`, `sSup ∅ = 0` matches ground-truth depth-0 case.

## Key findings / patterns

### **NEW Proof Pattern: `set_option backward.isDefEq.respectTransparency false in` for `Algebra.compHom`-chain defeq sinks**

The empirically-verified iter-180 recipe (analogist `pullbackspeciso-bypass`, Decision 4 ALIGN_WITH_MATHLIB) lets the elaborator see through `Algebra.compHom`-driven instance unification that becomes a heartbeat sink. Use case: `pullbackSpecIso_hom_base` style rewrites on `Spec` of TensorProduct-bridged algebras. Mathlib uses this idiom at ~14 sites (`Normalization.lean`, `pullback.congrHom_inv`, `pullback.map_isIso`, ~14 RingTheory/TensorProduct sites). One-shot `... in` scoping is the safe form.

### **NEW Proof Pattern: `GrpObj.ofRepresentableBy + units-of-global-sections functor` for `Spec`-of-Hopf-algebra group schemes**

`Gm = Spec k̄[t, t⁻¹]` installs as a `GrpObj` via `GrpObj.ofRepresentableBy (Gm) (gmHomFunctor) representableBy` where `gmHomFunctor T := GrpCat.of Γ(T.left, ⊤)ˣ`. The 3-step Yoneda chain (over-cat unfold → Γ⊣Spec → `IsLocalization.Away.lift` + `algebraMap_isUnit`) decomposes naturally into 5 axiom-clean helpers (toFun/invFun/invFun_isOver/homEquiv_comp/leftInv+rightInv) mapping to `Equiv.mk`. Avoids the 5-axiom-direct `GrpObj.mk` route (~150-200 LOC fallback).

### **NEW Proof Pattern: `Scheme.Hom.comp_appTop + Over.comp_left` makes naturality `rfl`-closable**

The morphism functor's `map` action composed with the bijection's `toFun` reduces defeq after only `Scheme.Hom.comp_appTop` + `Over.comp_left` unfoldings. Worth recording for future similar functor-Yoneda installs.

### **NEW Proof Pattern: `IsAffineOpen.isLocalization_of_eq_basicOpen` (not `_basicOpen` directly)**

When `convert key` over `IsAffineOpen.isLocalization_basicOpen` produces `⋯ ▸ Algebra` cast goals where the algebra instance can't be unified, switch to the `_of_eq_basicOpen` variant which accepts an explicit `V ⟶ U` + `V = X.basicOpen f` proof. Sidesteps dependent-type unification on `Algebra` instances.

### **NEW Proof Pattern: `RingTheory.Sequence.IsRegular` matches Stacks 00LF "depth via supremum"**

`Module.depth I M` definitional shape: `if I • ⊤ = ⊤ then ⊤ else sSup { n | ∃ rs, length rs = n ∧ rs ⊂ I ∧ IsRegular M rs }`. The `IsRegular` form already bundles "weakly regular + `M/(rs)·M ≠ 0`" — no extra finite/nontrivial bookkeeping needed.

### **Trap: `rw`/`simp` silent-refusal under `CommRingCat.Hom.hom (...)` coercion**

Even with literal-syntactic match, `rw` and `simp` cannot find the pattern inside the `CommRingCat.Hom.hom (...)` coercion wrapper. Lane B's `gmHomEquiv_right_inv` hit this wall on `Scheme.ΓSpecIso_inv_naturality_assoc`. Tried: `conv_lhs`, explicit `set`, named `have` with `change`, `Subsingleton.elim` on `IsUnit` proofs — all blocked. Possible workarounds for iter-181: `convert` with `IsLocalization.Away.lift_eq` + chain; or `ext_to_Spec` after `Over.OverMorphism.ext` to reduce to RingHom equality on the polynomial ring.

### **Lemma 3.3 alone insufficient for `CodimOneFree f`**

`indeterminacy_pure_codim_one_into_grpScheme`'s conclusion `Z(f) = ∅ OR ∀ x ∈ Z(f), ∃ z, coheight z = 1 ∧ x ∈ closure({z})` does NOT preclude a codim-1 generic point z in Z(f) (z ∈ closure({z}) trivially). Need codim-≥2 conclusion of Milne 3.1 as separate input.

## Lean-auditor verdict (iter180-touched)

**Overall**: iter-180 is structurally honest — all 8 touched files deliver substantive bodies / sorries with accurate documentation; the `respectTransparency` option is properly one-shot scoped; no new axioms were introduced; no excuse-comments crept in.

- **must-fix-this-iter**: 0
- **major**: 1 — inflated "axiom-clean" claim on Lane E's `l_eq_degree_plus_one_of_genus_zero` (body sound, transitively inherits sorryAx from upstream RR.2 scaffold).
- **minor**: 7 (Lane B helper budget overshoot — but non-vestigial; honest scaffold sorries; one stale status-comment block in `Cotangent/GrpObj.lean`; one literal "TODO" in `RelPicFunctor.lean:231`).
- **excuse-comments**: 0.

Full report at `task_results/lean-auditor-iter180-touched.md`.

## Lean-vs-blueprint-checker (8 per-file dispatches — all complete)

Per-file Lean↔chapter bidirectional verification dispatched for all 8 prover-touched files (slugs `iter180-{gmscaling,points,relativespec,ocofp,rrformula,quotscheme,thm32,ab}`). Reports at `.archon/task_results/lean-vs-blueprint-checker-iter180-*.md` and archived to `logs/iter-180/`.

- **`iter180-ocofp` returned 1 CRITICAL must-fix-this-iter**: `Scheme.lineBundleAtClosedPoint.globalSections_iff` signature is FALSE as typed — the RHS `Nonempty { s // s ≠ 0 }` does not bind `s` to `f`, so the iff degenerates to `(order conditions on f) ↔ True`, which is false for any nonzero `f` with a pole at some `Q ≠ P`. Lane D's prover had already flagged this as "mathematically odd"; the checker confirms it is a real bug. Declaration NOT in `archon-protected.yaml`. Escalated to **REC-0** in recommendations.md.
- The 7 other reports: 0 must-fix findings. Minor blueprint polish items recorded in REC-10/REC-11 (gmscaling staleness) and informally in iter sidecar (relativespec chapter should name new helpers; thm32 chapter should expose the codim-≥2 Milne 3.1 conclusion).

## Recommendations for the next session

See `recommendations.md`. Top items:
- iter-181 strategy-critic re-dispatch (per iter-178 commitment).
- iter-181 plan-phase mathlib-analogist consult on (i) IdealSheafData → SheafOfModules dual chain (unblocks 4 OCofP sorries); (ii) Smooth ⟹ IsReduced over scheme/field (unblocks Thm32 helper #1 + CodimOne helper).
- iter-181 prover lane on Lane A's remaining 2 sub-targets via the same `respectTransparency` recipe (the recipe is empirically validated).
- iter-181 prover lane on Lane B's 2 round-trip identities (try `Subsingleton.elim` on `IsUnit` proofs; or `convert + IsLocalization.Away.lift_eq`; or `ext_to_Spec`).

## Blueprint markers updated (manual)

- `RiemannRoch_RRFormula.tex`, `thm:riemannRoch_genus_zero`: NO change to `\leanok` (deterministic sync handles); body of `l_eq_degree_plus_one_of_genus_zero` lands but transitively carries sorryAx via upstream `eulerCharacteristic_eq_degree_plus_one_minus_genus` — `\leanok` policy decision deferred to `sync_leanok`.
- `Albanese_AuslanderBuchsbaum.tex`, `def:depth`: NO change (deterministic sync handles — `Module.depth` body now kernel-clean, sync_leanok should pick it up).
- No `\mathlibok` additions this iter (no new Mathlib-backed re-exports).
- No `\lean{...}` corrections this iter (no renames).
- No stale `\notready` to strip (verified via grep).

## File-level diagnostics

`lake build AlgebraicJacobian` returns GREEN:
- 8355 jobs, 0 errors, 73 sorry warnings.
- Per-file sorry distribution (post-iter-180):
  - `AbelianVarietyRigidity.lean` — 2 (unchanged off-target)
  - `RigidityKbar.lean` — 1 (off critical path)
  - `Genus0BaseObjects/BareScheme.lean` — 2 (pre-existing)
  - `Genus0BaseObjects/Points.lean` — 2 (Lane B 1→2 via structural decomposition)
  - `Genus0BaseObjects/GmScaling.lean` — 4 (Lane A 3+2 axioms → 4+0 axioms; net file count +1 BUT 2 axioms RETIRED)
  - `Picard/RelativeSpec.lean` — 1 (Lane C 2→1 via coequifibered closure)
  - `Picard/LineBundlePullback.lean` — 5 (pre-existing gated)
  - `Picard/RelPicFunctor.lean` — 6 (pre-existing gated)
  - `Picard/FlatteningStratification.lean` — 7 (pre-existing gated)
  - `Picard/QuotScheme.lean` — 7 (Lane F 6→7 via helper split)
  - `Picard/FGAPicRepresentability.lean` — 7 (pre-existing gated)
  - `RiemannRoch/WeilDivisor.lean` — 2 (pre-existing deferred)
  - `RiemannRoch/OCofP.lean` — 5 (Lane D structural advance internal sorry-token rise)
  - `RiemannRoch/RRFormula.lean` — 2 (Lane E 3→2 via genus-0 RR closure)
  - `RiemannRoch/RationalCurveIso.lean` — 2 (pre-existing deferred)
  - `Jacobian.lean` — 2 (pre-existing gated)
  - `Albanese/AuslanderBuchsbaum.lean` — 4 (Lane H 5→4 via Module.depth body)
  - `Albanese/Thm32RationalMapExtension.lean` — 2 (Lane G 1→2 via Option (a) split)
  - `Albanese/CodimOneExtension.lean` — 3 (pre-existing deferred)
  - `Albanese/AlbaneseUP.lean` — 7 (pre-existing gated)
  - **Total: 73** (entering 72; +1 net; planner band best −7 / worst +2 — within band).
- **2 → 0 project axioms** (both iter-177 TEMP axioms retired by Lane A).
