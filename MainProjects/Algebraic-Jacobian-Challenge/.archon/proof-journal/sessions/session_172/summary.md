# Session 172 (= iter-172) — review summary

## Session metadata

- **Iteration / session number**: 172
- **Stage**: prover (3 lanes dispatched per plan)
- **Sorry count**:
  - Entering: 15 (AVR × 2, RigidityLemma × 0, G0BO × 10, Jacobian × 2, RigidityKbar × 1).
  - Exiting: **20** (AVR × 2, RigidityLemma × 0, G0BO × 9, Jacobian × 2, RigidityKbar × 1, NEW RiemannRoch/WeilDivisor × 6).
  - NET: **+5** = Lane A −1 (PRIMARY 1 axiom-clean closure) + Lane C +6 (file-skeleton landing).
  - Lane B 0 (file `Picard/RelativeSpec.lean` does NOT exist on disk — prover died to API 529).
- **Targets attempted (3 prover lanes per plan + 1 umbrella NO-OP)**:
  1. **Lane A (Genus0BaseObjects.lean)**: PRIMARY 1 + PRIMARY 2 + PRIMARY 3 + SECONDARY (4 targets) → **PRIMARY 1 SOLVED** axiom-clean; PRIMARY 2/3/SECONDARY left as typed sorries (blocked: PRIMARY 2 gated on PRIMARY 3, PRIMARY 3 needs structural pullback-bridge build, SECONDARY gated on PRIMARY 3). **Status bucket: PARTIAL-low** per the plan's grid.
  2. **Lane B (Picard/RelativeSpec.lean — file-skeleton)**: SCHEDULED post-HARD-GATE-clear. Prover lane terminated at `2026-05-22T06:24:17Z` with `API Error: 529 Overloaded` after 13 turns / 4.5 min; **0 file edits**. Identical failure mode to iter-170 Lane A's API-500. The HARD GATE for `Picard_RelativeSpec.tex` was CLEARED iter-172 plan-phase via `blueprint-reviewer picard-scoped172` (PASS). Re-dispatch iter-173 verbatim.
  3. **Lane C (RiemannRoch/WeilDivisor.lean — file-skeleton)**: NEW file (13 KB). 9 `\lean{...}`-pinned declarations scaffolded + 1 helper `Scheme.PrimeDivisor` structure + 2 trivial instances. 3 declarations close `sorry`-free (`WeilDivisor` = `PrimeDivisor →₀ ℤ`; `degree` = `D.sum (fun _ n => n)`; `LinearEquivalence` = `∃ f hf, D - D' = principal f hf`). 6 carry `sorry` bodies (`order`, `ofClosedPoint`, `degree_hom`, `principal`, `principal_hom`, `principal_degree_zero`). **Status: COMPLETE.**
  4. **Umbrella (AlgebraicJacobian.lean)**: NO-OP COMPLETE. Already contained `import AlgebraicJacobian.RiemannRoch.WeilDivisor` line; Lane B's planned umbrella append (`import AlgebraicJacobian.Picard.RelativeSpec`) did not happen because Lane B never landed the file.
- **Build**: `lake build AlgebraicJacobian` → green (sorry warnings only on 9 G0BO + 6 RR/WeilDivisor + 2 AVR + 2 Jacobian + 1 RigidityKbar = 20 sorries).
- **Axioms verified via `lean_verify`** (per prover's task_result, this review):
  - `AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective`: `{propext, Classical.choice, Quot.sound}` ✓ (NEW iter-172).
  - `AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left`: `{propext, Classical.choice, Quot.sound}` ✓ (was sorryAx-tainted iter-171; PRIMARY 1 closure retired the taint).
  - `AlgebraicGeometry.homogeneousLocalizationAwayIso`: `{propext, Classical.choice, Quot.sound}` ✓ (was sorryAx-tainted iter-171; PRIMARY 1 closure retired the taint).
- **New `axiom` declarations**: 0. **Protected-signature touches**: 0.

## Targets — attempts and outcomes

### Target 1: `mvPolyToHomogeneousLocalizationAway_surjective` (G0BO L379) — SOLVED axiom-clean

**Goal**: `Function.Surjective (mvPolyToHomogeneousLocalizationAway kbar i)` for each `i : Fin 2`.

**Attempt 1** (prover edit chain ~140 LOC):

```lean
private lemma mvPolyToHomogeneousLocalizationAway_surjective
    (kbar : Type u) [Field kbar] (i : Fin 2) :
    Function.Surjective (mvPolyToHomogeneousLocalizationAway kbar i) := by
  classical
  -- 4-step plan:
  -- (1) Show `Algebra.adjoin (𝒜 0) (range ![X 0, X 1]) = ⊤` via MvPolynomial.induction_on
  --     (C / add / mul_X cases via Subalgebra.{algebraMap_mem, add_mem, mul_mem}).
  -- (2) Invoke Mathlib's `Away.adjoin_mk_prod_pow_eq_top` with d=1, v=![X 0, X 1], dv=![1, 1].
  -- (3) `gen_eq_pow` helper: each generator `Away.mk hf a (∏ v j^ai j) _` collapses to
  --     `(isLocalizationElem hfi hgi)^(ai (otherFin i))` via val_injective +
  --     Localization.mk_eq_mk_iff + r_iff_exists + Fin.ext+omega case-split on `i.val`.
  -- (4) Algebra.adjoin_induction over the htop ⊤: mem / algebraMap / add / mul cases each
  --     produce a preimage in `MvPolynomial Unit kbar`. The algebraMap case uses
  --     surjectivity of `algebraMap kbar (𝒜 0)` via MvPolynomial.homogeneousComponent_zero.
  -- (~140 LOC body; complete listing in AlgebraicJacobian/Genus0BaseObjects.lean:379-519)
```

**Result**: SUCCESS. `lean_verify` axioms `{propext, Classical.choice, Quot.sound}` (standard Lean 4 axioms; no `sorryAx`, no custom axioms).

**Downstream impact verified**:
- `homogeneousLocalizationAwayIso_aux_left` (G0BO L528) — its iter-171 cancel-surjective body was depending on this helper; now propagates axiom-clean.
- `homogeneousLocalizationAwayIso` (G0BO L545) — was sorryAx-tainted via `aux_left` iter-171; now axiom-clean.

**Insights / dead-ends recorded by prover**:
1. Avoid `set 𝒜 := projectiveLineBarGrading kbar`: causes type-class friction with `Subalgebra.algebraMap_mem` and `SetLike.GradeZero` machinery. Inline `projectiveLineBarGrading kbar` directly.
2. Auxiliary `algebra.adjoin (𝒜 0) (Set.range v) = ⊤` is proved by `MvPolynomial.induction_on p` using `Subalgebra.{algebraMap_mem, add_mem, mul_mem}` (NOT bare `add_mem` / `mul_mem` — caused "synthetic hole" elaboration errors). Use `refine MvPolynomial.induction_on p ?C ?add ?mulX` (avoid the `induction ... with` syntax which had elaboration trouble).
3. `algebraMap kbar ↥(𝒜 0)` surjectivity bridge for the algebraMap case: reuses the proof pattern from `projectiveLineBar_isProper` (homogeneousComponent decomposition).
4. The `gen_eq_pow` helper: quantified equation `Away.mk hf a (∏ v j ^ ai j) _ = (isLocalizationElem hf hg)^(ai (otherFin i))`. Proved via `HomogeneousLocalization.val_pow` + `Localization.mk_pow` + `Localization.mk_eq_mk_iff` + `Localization.r_iff_exists` + ring identity. Case-split on `i : Fin 2` via `Fin.ext` + `omega` to get clean `0`/`1` substitutions (avoid `fin_cases` which preserves `⟨0, _⟩` form).
5. Power-of-RingHom: use the dedicated `HomogeneousLocalization.val_pow`, NOT `RingHom.map_pow` (the latter has type inference issues since `val` is a plain function, not bundled as a RingHom in this usage).

### Target 2: `gmScalingP1_over_coherence` (G0BO L877) — BLOCKED-by-PRIMARY-3

**Goal**: Each chart's composite to `Spec k̄` agrees with the structure morphism.

**Attempt 1 (mental, no edit)**: `Scheme.Cover.hom_ext` over `gmScalingP1_cover` to reduce to per-chart equations.

**Result**: FAILED. The goal reduces to `∀ i, gmScalingP1_chart kbar i ≫ PLB.hom = cover.f i ≫ (PLB ⊗ Gm).hom`. Since `gmScalingP1_chart kbar i = sorry`, the LHS is sorry-bearing and the equation cannot be discharged. **The planner-side hint that PRIMARY 2 could land independently of PRIMARY 3 is DISPROVED** — recorded as a planner-side discrepancy for iter-173.

**Decision**: left as typed sorry; gated on PRIMARY 3 closing.

### Target 3: `gmScalingP1_chart kbar i` (G0BO L847) — NOT ATTEMPTED (out of budget)

**Goal**: define the chart-`i` scheme morphism `(cover).X i ⟶ ProjectiveLineBarScheme kbar`.

**Recipe considered (per analogies/gmscaling-deep.md Q3)**: `pullbackSpecIso ≫ Spec.map gmScalingP1_chart_i_ringMap ≫ Spec.map homogeneousLocalizationAwayIso.symm ≫ Proj.awayι`.

**Blocker analysis** (from prover task_result, accepted this review): the source type `(gmScalingP1_cover kbar).X i = pullback (pullback.fst PLB.hom Gm.hom) (Proj.awayι _ (X i) _)` is an abstract pullback over `Proj 𝒜 = PLB.left`, while `pullbackSpecIso` operates on pullbacks of `Spec.map (algebraMap kbar _)` morphisms. Bridging needs a structural lemma `(cover).X i ≅ Spec((Away 𝒜 (X i)) ⊗[kbar] (GmRing kbar))` over `Over (Spec kbar)`.

**Decision**: typed sorry; status docstring (L831-839) refreshed by prover to reflect PRIMARY 1 unblocking.

### Target 4: `gmScalingP1_chart_agreement` (G0BO L861) — BLOCKED-by-PRIMARY-3

Gated on PRIMARY 3. Reserved for iter-173 once chart morphism lands.

### Target 5: `RiemannRoch/WeilDivisor.lean` file-skeleton (Lane C) — SOLVED

**Attempt 1**: NEW file with 9 `\lean{...}`-pinned decls + 1 helper struct + 2 instances. Imports = `import Mathlib` + `import AlgebraicJacobian.Genus`. Three decls land sorry-free (`WeilDivisor`, `degree`, `LinearEquivalence`); six carry typed sorry bodies; helper `PrimeDivisor` has placeholder field `isCodim1AndIntegral : True := trivial`. Umbrella import line already present (no edit needed).

**Result**: SUCCESS. `lake build AlgebraicJacobian.RiemannRoch.WeilDivisor` exit 0 with 6 sorry warnings.

**Insights**:
- `AlgebraicGeometry.Scheme.functionField` requires `[IrreducibleSpace X]` (not `[IsIntegral X]` directly — IsIntegral implies it).
- `AlgebraicGeometry.instFieldCarrierFunctionField` shipped for `[IsIntegral X]`.
- `Scheme.RationalMap` is a `def`, not `class`/`structure`; adding `order` to its namespace is non-conflicting.
- `IsDiscreteValuationRing.addVal : R → ℕ∞` is the canonical valuation reader.
- `Finsupp` instances supply free-abelian-group structure on `(α →₀ ℤ)` for any `α`.

**Must-fix-this-iter callout from lean-auditor `iter172`**: the helper `Scheme.PrimeDivisor.isCodim1AndIntegral : True := trivial` is a weakened-wrong definition — until refined to the real `Order.coheight point = 1 ∧ IsIntegral (closure)` conjunction, `Scheme.WeilDivisor X` is structurally the free abelian group on **all** points of `X`. Mitigation: no project file currently consumes `WeilDivisor`/`PrimeDivisor` (only the umbrella imports it). Two acceptable resolutions for iter-173: (a) replace `True := trivial` with the real conjunction the moment any sibling file under `RiemannRoch/` consumes `PrimeDivisor`; or (b) widen to a `sorry` on a `Prop`-valued field so the wrongness surfaces as a kernel obligation rather than hiding behind `True`.

### Target 6: `Picard/RelativeSpec.lean` (Lane B) — BLOCKED-by-API-529

**Attempted**: Scaffold 6 decls from `Picard_RelativeSpec.tex` (QcohAlgebra, RelativeSpec, RelativeSpec.UniversalProperty, RelativeSpec.affine_base_iff, RelativeSpec.base_change, RelativeSpec.functor); bodies as sorry; ~100-200 LOC of stubs; update umbrella.

**Result**: BLOCKED on session terminate. Final event: `text` with content `"API Error: 529 Overloaded. This is a server-side issue, usually temporary — try again in a moment."` at `2026-05-22T06:24:17.119569Z` after 13 turns, 275s, with `cache_read_input_tokens: 453939`, `cache_creation_input_tokens: 55487`, **0 file edits**.

**Path**: prover ran `mkdir AlgebraicJacobian/Picard` directory (only filesystem action before death). The empty `AlgebraicJacobian/Picard/` directory is now on disk; blueprint-doctor flagged the resulting orphan-cover at `Picard_RelativeSpec.tex` (chapter covers a non-existent `.lean` file). Informational only; resolves when Lane B re-fires iter-173.

**Decision**: per iter-170 review's KB pattern "external-API failure mode tests nothing about the route", reversal trigger DOES NOT FIRE. iter-173 plan re-dispatches Lane B verbatim — chapter on disk + HARD GATE clear.

## Key findings / patterns discovered

1. **PRIMARY 1's axiom-clean close demonstrates the "single load-bearing helper unlocks multiple downstream synthesis chains" KB pattern (iter-167)**, realized end-to-end iter-172. One ~140-LOC body retires sorryAx taint from 3 declarations (`mvPolyToHomogeneousLocalizationAway_surjective`, `homogeneousLocalizationAwayIso_aux_left`, `homogeneousLocalizationAwayIso`).
2. **The planner's "PRIMARY 2 can land independently of PRIMARY 3" hint was DISPROVED.** The `gmScalingP1_over_coherence` proof's `Scheme.Cover.hom_ext` reduction unfolds through `gmScalingP1_chart`, which is sorry-bodied. Planner-side discrepancy to absorb in iter-173.
3. **Second consecutive iter where an Anthropic API 5xx killed a prover lane mid-run with zero file edits** (iter-170: 500 / Lane A G0BO; iter-172: 529 / Lane B Picard). KB pattern from iter-170 holds: reversal trigger does not fire; lane re-dispatches verbatim iter-173.
4. **`sync_leanok` did NOT add `\leanok` to the AVR chapter for the three proof-block closures that landed axiom-clean this iter.** sync_leanok-state.json shows `chapters_touched: ["RiemannRoch_WeilDivisor.tex"]` only. Possible causes: sync_leanok may not track `private` declarations OR may treat axiom-cleanness via sorry-counting rather than per-decl axiom verification. Flagged for iter-173 doctor investigation.

## Subagent dispatches this review

| Subagent | Slug | Verdict |
|---|---|---|
| lean-auditor | iter172 | **1 must-fix-this-iter** (`PrimeDivisor.isCodim1AndIntegral : True := trivial` weakened-wrong def), **3 major** (3 of the iter-171 stale-narrative blocks still need header refresh: `RigidityKbar.lean`, `Cotangent/GrpObj.lean`, `Cotangent/ChartAlgebra.lean`), **3 minor**. **iter-171's headline CRITICAL `Jacobian.lean` excuse-comment block was FULLY RESOLVED by the refactor agent — verified.** |
| lean-vs-blueprint-checker | g0bo172 | **0 must-fix-this-iter**, **1 major** (blueprint coverage gap: the 3 named scaffold sorries `gmScalingP1_chart`, `_chart_agreement`, `_over_coherence` lack per-decl `\lean{...}` pins), **3 minor**. PRIMARY 1 closure is 1:1 with `lem:mvPoly_to_homogeneousLocalization_away_surjective` chapter sketch. |
| lean-vs-blueprint-checker | wd172 | (in flight at write-time; report path = `.archon/logs/iter-172/lean-vs-blueprint-checker-wd172-report.md`; findings folded into `recommendations.md` upon arrival) |
| lean-vs-blueprint-checker | jacobian172 | **0 must-fix-this-iter**, **1 major** (blueprint internal inconsistency: 3 paragraphs at `Jacobian.tex` L344/L384-390/L425-427 still carry pre-audit "A.4 bypass-holds / no new Mathlib namespace" prose that the iter-172 A.4 audit at L574-602 + L656 explicitly refutes), **1 minor** (stale line-number reference at L556). The refactor `jacobian-purge-excuse` cleanup is verified. |

## Blueprint markers updated (manual)

- `RiemannRoch_WeilDivisor.tex`, `def:codim1_cycles`: added `% NOTE (iter-172):` calling out the `PrimeDivisor.isCodim1AndIntegral : True := trivial` placeholder + consequence (Lean `WeilDivisor X` is structurally `points →₀ ℤ` until iter-173+ refines the codim-1 witness). Flagged for iter-173 plan-agent absorption. (No `\leanok` touched.)

## Recommendations for the next session

See `recommendations.md`. Headline items:
1. **Honor the progress-critic-mandated `mathlib-analogist` consult on the pullback-bridge specialisation** before opening another G0BO prover lane on PRIMARY 3. The bridge `(gmScalingP1_cover).X i ≅ Spec(Away ⊗ GmRing)` is the next-iter unblocker.
2. **Re-dispatch Lane B verbatim** on `Picard/RelativeSpec.lean` — HARD GATE clear, chapter on disk, mechanical file-skeleton work.
3. **Address the lean-auditor must-fix on `PrimeDivisor.isCodim1AndIntegral`** before any sibling RR file consumes the structure.
4. **Plan agent must dispatch a refactor on `RigidityKbar.lean` / `Cotangent/GrpObj.lean` / `Cotangent/ChartAlgebra.lean`** to refresh stale-narrative headers (iter-171 carry-overs still open).
5. **Blueprint-writer dispatch on `Jacobian.tex`** to reconcile the 3 surviving "A.4 bypass-holds" paragraphs (L344/L384-390/L425-427) with the iter-172 audit verdict at L574-602+L656.
6. **`sync_leanok` AVR-chapter miss** flagged for iter-173 doctor investigation.
