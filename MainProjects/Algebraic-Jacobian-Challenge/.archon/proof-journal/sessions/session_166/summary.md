# Session 166 — Iter-166 review

## Session metadata

- **Session number:** 166 (= iter-166).
- **Stage:** prover (2 parallel lanes) + review.
- **Sorry count before:** 15 (iter-165 close — AVR 3 deferred scaffolds + Genus0BaseObjects 9
  scaffold sorries + Jacobian 2 + RigidityKbar 1).
- **Sorry count after:** 15 (unchanged in NET; the AVR 3 deferred scaffolds were converted to
  proof bodies that internally propagate `sorryAx` through 5 honest helper sorries + 1 RR-bridge
  sorry on `genusZero_curve_iso_P1`; Genus0BaseObjects closed 3 of 9 sorries — the three
  `ℙ¹`-points — axiom-clean).
- **Per-file inventory (verified via grep + `lake build` + `lean_verify`):**
  - `AlgebraicJacobian/AbelianVarietyRigidity.lean` — **6** sorries at L944, L949, L953, L1029,
    L1037 (5 internal to the new helper `morphism_P1_to_grpScheme_const_aux`), L1137 (RR-bridge
    body of `genusZero_curve_iso_P1`).
  - `AlgebraicJacobian/Genus0BaseObjects.lean` — **6** sorries at L177
    (`projectiveLineBar_geomIrred`), L184 (`projectiveLineBar_smoothOfRelDim`), L335
    (`ga_grpObj`, off-path), L400 (`gm_grpObj`, CRITICAL deferred), L439 (`gmScalingP1` body,
    CRITICAL deferred), L456 (`gmScalingP1_collapse_at_zero` body, CRITICAL deferred).
  - `AlgebraicJacobian/Jacobian.lean` — **2** at L265 (`genusZeroWitness.key`), L303
    (`positiveGenusWitness`).
  - `AlgebraicJacobian/RigidityKbar.lean` — **1** at L88 (`rigidity_over_kbar`, fallback artifact).
- **Build:** `lake build AlgebraicJacobian.AbelianVarietyRigidity` and
  `lake build AlgebraicJacobian.Genus0BaseObjects` both green (sorry warnings only); no new
  custom `axiom`; no protected signature touched.

## Targets attempted (per the iter-166 plan)

### Lane 1 (`AlgebraicJacobian/AbelianVarietyRigidity.lean`) — PARTIAL per plan target

The prover landed all three iter-166 Lane 1 deliverables:

1. **Import added** — `import AlgebraicJacobian.Genus0BaseObjects` at L7.
2. **`morphism_P1_to_grpScheme_const` (L1089)** — signature refactored to drop the abstract
   `P1` parameter and use the concrete `ProjectiveLineBar kbar`; body proven via the
   𝔾ₘ-scaling shortcut (translate-to-base-point + apply private helper + un-translate via
   `div_eq_one`). `lean_verify` axioms `{propext, sorryAx, Classical.choice, Quot.sound}` —
   `sorryAx` propagates honestly through the new private helper
   `morphism_P1_to_grpScheme_const_aux`.
3. **`genusZero_curve_iso_P1` (L1131)** — signature refactored to target the concrete
   `ProjectiveLineBar kbar`; body remains `sorry` (RR bridge, deferred to iter-167+ per plan).
4. **`rigidity_genus0_curve_to_grpScheme` (L1156)** — body landed via iso transport from the
   refactored `morphism_P1_to_grpScheme_const` under the proven (axiom-clean wherever sourced)
   helper chain. `lean_verify` axioms identical (sorryAx propagation only).

The new private helper `morphism_P1_to_grpScheme_const_aux` (L931) carries the pointed-case
proof body (≈100 LOC) and the 5 internal sorries (3 product instances `[GeomIrred / LOFT /
IsReduced] (ℙ¹ ⊗ Gm)`, `[IsReduced ProjectiveLineBar.left]`, `[IsDominant iotaGm.left]`). All
five are honest open math obligations per the directive (verified by `lean-auditor-iter166`).

### Lane 2 (`AlgebraicJacobian/Genus0BaseObjects.lean`) — PARTIAL per plan target

The prover closed 3 of the 7 plan-flagged live-consumer scaffold sorries:

1. **`ProjectiveLineBar.zeroPt` (L268)** — `pointOfVec kbar (fun i => if i = 0 then 0 else 1) 1`,
   the `k̄`-point `[0:1]`. `lean_verify` axioms `{propext, Classical.choice, Quot.sound}` —
   kernel-clean (no `sorryAx`).
2. **`ProjectiveLineBar.onePt` (L274)** — `pointOfVec kbar (fun _ => 1) 0`, the `k̄`-point
   `[1:1]`. Kernel-clean.
3. **`ProjectiveLineBar.inftyPt` (L280)** — `pointOfVec kbar (fun i => if i = 0 then 1 else 0)
   0`, the `k̄`-point `[1:0]`. Kernel-clean.

Three pieces of supporting infrastructure landed alongside:

- `private noncomputable def ProjectiveLineBar.evalIntoGlobal` (L199) — ring map
  `MvPolynomial (Fin 2) kbar →+* Γ(Spec k̄, ⊤)` via `(ΓSpecIso).inv ∘ MvPolynomial.eval v`.
- `private lemma ProjectiveLineBar.irrelevant_map_eq_top` (L207) — the irrelevant-ideal
  condition from `IsUnit (v i)`, using `HomogeneousIdeal.mem_irrelevant_of_mem` +
  `MvPolynomial.isHomogeneous_X` + `Ideal.eq_top_iff_one` + the unit-mul-left trick.
- `private noncomputable def ProjectiveLineBar.pointOfVec` (L234) — the shared
  `Proj.fromOfGlobalSections + Over.homMk` constructor; the section condition chases through
  `fromOfGlobalSections_toSpecZero` + `IsScalarTower kbar (𝒜 0) MvPoly` collapse to
  `MvPolynomial.C` + `MvPolynomial.eval_C` + `AlgebraicGeometry.toSpecΓ_SpecMap_ΓSpecIso_inv`.

The 3 CRITICAL deferred sorries (`gm_grpObj` L400, `gmScalingP1` body L439,
`gmScalingP1_collapse_at_zero` body L456) and the 3 OPT-IN sorries
(`projectiveLineBar_geomIrred`, `projectiveLineBar_smoothOfRelDim`, `ga_grpObj`) remain — punt to
iter-167+. The 6 plan-flagged secondary objectives that did NOT land are recorded in
`recommendations.md`.

## Significant attempts (from `attempts_raw.jsonl`, both lanes)

### Lane 1 — `morphism_P1_to_grpScheme_const_aux` (NEW helper, L931)

The full ≈100-LOC proof was built incrementally over ~16 prover edits. Key attempts (in order):

1. **`set ι : Gm kbar ⟶ ProjectiveLineBar kbar := …`** — failed with
   `unexpected token 'ι'; expected '_' or identifier`. **Fix:** renamed to `iotaGm`. (Trap log
   recorded for future provers.)
2. **`haveI : IsSeparated (A.left ↘ Spec (.of kbar)) := ‹IsSeparated A.hom›`** — failed
   because only `[IsProper A.hom]` was in scope, not `[IsSeparated]`. **Fix:** derive via
   `IsProper.toIsSeparated`.
3. **`rw [← Category.assoc]`** on `a ≫ (b ≫ c) = d ≫ (e ≫ f)` — rewrites both sides
   simultaneously, not the target side. **Fix:** prove a `hreshape` lemma separately and
   `congrArg` it into place (the approach used for `hgoal` in the dominance step).
4. **`apply Scheme.Over.ext_of_eqOnOpen` (the wrapper in `AlgebraicJacobian.Rigidity`)** — fails
   in AVR.lean because `Rigidity.lean` is downstream of AVR (import cycle if added). **Fix:**
   replicate `rigidity_core`'s inline pattern using `ext_of_isDominant_of_isSeparated'` directly
   (located via `lean_leansearch "IsProper implies IsSeparated"`).
5. The chain ends with `ext_of_isDominant_of_isSeparated'` + `IsDominant iotaGm.left` (sorry
   propagated, awaiting concrete `gmScalingP1` body in Lane 2).

### Lane 2 — `ProjectiveLineBar.zeroPt / onePt / inftyPt`

Single prover attempt resolved all three via a shared `pointOfVec` helper:

1. **Approach:** parametrize over the evaluation vector + `IsUnit (v i)` unit-coordinate
   hypothesis. The section condition collapses via `Proj.fromOfGlobalSections_toSpecZero`,
   then a CommRingCat-level equation
   `CommRingCat.ofHom ((evalIntoGlobal v).comp MvPolynomial.C) = (ΓSpecIso (.of kbar)).inv`
   proved by `CommRingCat.hom_ext + ext r + change + rw [MvPolynomial.eval_C]`, finished by
   `AlgebraicGeometry.toSpecΓ_SpecMap_ΓSpecIso_inv`.
2. **Trap recorded for next prover:** `rw [heq]` where
   `heq : (f).comp C = ...` fails to match identical-looking patterns in the goal. Workaround:
   prove the CommRingCat-level equation, then `calc` + `congrArg Spec.map hcc` +
   `toSpecΓ_SpecMap_ΓSpecIso_inv`.
3. **Result:** All three are `noncomputable def`s (correctly so, since `Proj.fromOfGlobalSections`
   is `noncomputable`). `lean_verify` confirms kernel-clean for each.

### Lane 2 — `gm_grpObj`, `gmScalingP1` body, `gmScalingP1_collapse_at_zero` body

Approaches CONSIDERED, NOT ATTEMPTED this iter (per task_result):

- **`gm_grpObj` via `GrpObj.ofRepresentableBy`** — the units-functor `T ↦ GrpCat.of Γ(T.left,
  ⊤)ˣ` representable-by witness requires bridging through `IsLocalization.Away X`-Spec
  bijection ("morphism into `Spec (Localization.Away t)` ↔ unit in global sections"). Mathlib
  has `IsLocalization.away_of_isUnit_of_bijective` and `AffineSpace.homOverEquiv` but does not
  ship the units-functor → `Spec(k̄[t,t⁻¹])` representable-by witness; non-trivial sub-build.
- **`gmScalingP1` via `Scheme.Cover.glueMorphisms`** over `{D₊(X₀) × Gm, D₊(X₁) × Gm}` —
  requires writing the two `Spec.map`-of-ring-map chart morphisms (`t ↦ λ·t` on `𝔸¹ × Gm`,
  `u ↦ u/λ` near `∞`) and proving overlap agreement; substantial chart-level construction.
- **`gmScalingP1_collapse_at_zero`** strictly downstream of `gmScalingP1` — meaningful proof
  requires non-sorry body for `gmScalingP1` to compute against.

## Subagent reports (this review)

All three highly-recommended review subagents dispatched and returned; full reports under
`.archon/logs/iter-166/`:

| Subagent | Slug | Verdict | mf/maj/min | Headline |
|---|---|---|---|---|
| `lean-auditor` | iter166 | 0 must-fix | 0 / 11 / 3 | Iter-166 modifications sound — 5 honest helper sorries verified open obligations; point-soundness `[0:1]`/`[1:1]`/`[1:0]` verified for the new defs; no laundering. Main hygiene debt is **carry-over** iter-164 stale narrative in 6 files (Jacobian L237-263, RigidityKbar L9-89, Cotangent/GrpObj L297-326/L465-525/L552-560/L624-629, Cotangent/ChartAlgebra L36-79) + 5 NEW redundant `-- TODO:` excuse-comments inside `morphism_P1_to_grpScheme_const_aux` that duplicate the kernel `sorry` + docstring disclosure. Report: `logs/iter-166/lean-auditor-iter166-report.md`. |
| `lean-vs-blueprint-checker` | avr-iter166 | 0 must-fix | 0 / 0 / 3 | Iter-166 Lane 1 refactor faithfully matched by chapter (`ProjectiveLineBar` signature swap, helper decomposition, RR-bridge sorry honestly acknowledged in remark `rmk:genusZero_iso_subbuild`). 3 informational: (a) consider `\lean{...}` hook for the new private helper or document the outer/helper split in the chapter, (b) name the 5 scaffold sorries as named blueprint obligations / TODO blocks, (c) optionally strip the 3 off-path Route-A `\lean{...}` hints (rationalMap/Ga). Report: `logs/iter-166/lean-vs-blueprint-checker-avr-iter166-report.md`. |
| `lean-vs-blueprint-checker` | g0bo-iter166 | 1 must-fix (plan-deferred) | 1 / 6 / 1 | `gmScalingP1` body `:= sorry` on a chapter-pinned `\lean{...}` is a must-fix by the verbatim rule, but is plan-marked deferred to iter-167+ (already tracked). All 6 majors are missing `\lean{...}` hooks (iter-165 carry-over): the 3 new ℙ¹-points + `gmScalingP1_collapse_at_zero` + `gm_grpObj` + `Ga`/`Gm`. Point-soundness verified `[0:1]`/`[1:1]`/`[1:0]`; private helper privacy correct. Report: `logs/iter-166/lean-vs-blueprint-checker-g0bo-iter166-report.md`. |

## Key findings / patterns discovered

### NEW Proof Patterns (added to PROJECT_STATUS.md Knowledge Base this review)

1. **`Proj.fromOfGlobalSections` k̄-point constructor `pointOfVec`** — a shared helper
   parametrised over a `Fin 2 → kbar` evaluation vector + a `IsUnit (v i)` certificate at
   one coordinate; the irrelevant-ideal condition discharges via
   `HomogeneousIdeal.mem_irrelevant_of_mem` + `MvPolynomial.isHomogeneous_X` +
   `Ideal.eq_top_iff_one` + `IsUnit.map`. The `Over.homMk` section condition chases through
   `fromOfGlobalSections_toSpecZero` + `IsScalarTower kbar (𝒜 0) MvPoly` collapse to
   `MvPolynomial.C` + `MvPolynomial.eval_C` + `AlgebraicGeometry.toSpecΓ_SpecMap_ΓSpecIso_inv`.
   Reusable for any "`k̄`-rational point on `Proj 𝒜` from an explicit evaluation vector"
   construction. **DEAD-END trap:** `rw [heq]` where `heq : (f).comp C = ...` fails to match
   identical-looking patterns in the goal — workaround is to prove the CommRingCat-level
   equation via `CommRingCat.hom_ext + ext r + change + rw [MvPolynomial.eval_C]`, then `calc`
   + `congrArg Spec.map hcc`.

2. **Iso-transport of a rigidity headline through a curve-iso `C ≅ ℙ¹`** — the
   `rigidity_genus0_curve_to_grpScheme` body landed iter-166 via a clean iso-transport
   recipe: `obtain ⟨φ⟩ := genusZero_curve_iso_P1 _hgenus`; `set g := φ.inv ≫ f`;
   `obtain ⟨a₀, hga₀⟩ := morphism_P1_to_grpScheme_const g`; pin `a₀ = η[A]` by transporting
   the basepoint `p` along `φ.hom` (`hpoint : (p ≫ φ.hom) ≫ g = η[A]` then `toUnit_unique`
   collapse); back-transport via `φ.hom_inv_id`. Reusable for any "headline-on-target factors
   through iso-substituted source".

3. **`set ι := …` fails — `ι` is a near-reserved token** — `set ι : T := …` produces
   `unexpected token 'ι'; expected '_' or identifier` in Lean 4. Rename to a regular ASCII
   identifier (`iotaGm`, etc.).

4. **`IsSeparated A.hom` from `[IsProper A.hom]` only** — bare `‹IsSeparated A.hom›` fails;
   derive explicitly via `IsProper.toIsSeparated` (located via
   `lean_leansearch "IsProper implies IsSeparated"`).

5. **Inline `ext_of_isDominant_of_isSeparated'` when the `Scheme.Over.ext_of_eqOnOpen`
   wrapper is downstream** — when AVR.lean needs the dominant-globalisation pattern but
   `AlgebraicJacobian.Rigidity` imports `AlgebraicJacobian.Jacobian` which (transitively or
   directly) imports AVR, replicate `rigidity_core`'s inline call to the Mathlib lemma
   directly. (Pattern previously surfaced for `snd_left_isClosedMap` iter-158; recurred iter-166
   for the `morphism_P1_to_grpScheme_const_aux` dominance step.)

### Carry-over Known Blockers (iter-164/iter-165 still live; do NOT retry under same shape)

- `gm_grpObj` via `GrpObj.ofRepresentableBy` — requires a units-functor representable-by
  witness that bridges `IsLocalization.Away X`-Spec ("morphism into `Spec (Localization.Away
  t)` ↔ unit in global sections"); Mathlib lacks the units-functor → `Spec k̄[t,t⁻¹]`
  representable-by witness. Plan agent for iter-167 should dispatch
  `mathlib-analogist (api-alignment)` BEFORE the prover attempts this.

## Blueprint markers updated (manual)

- `AbelianVarietyRigidity.tex`, `prop:morphism_P1_to_AV_constant` (proof block, L1224-1279):
  added `% NOTE (iter-166 review): Lean factors the proof into the outer translation
  reduction (`morphism_P1_to_grpScheme_const`) + a private basepoint helper
  (`morphism_P1_to_grpScheme_const_aux`) carrying the 𝔾ₘ-scaling shortcut body. The chapter
  prose presents the proof at a single granularity; the Lean split is structural-only and
  preserves the chapter's logical content. The 5 scaffold sorries inside the helper (three
  `(ℙ¹⊗Gm)` product instances, `IsReduced ProjectiveLineBar.left`, `IsDominant iotaGm.left`)
  are honest open math obligations (Mathlib bridges + Lane 2 dependency); checker confirmed
  no laundering and the basepoint hypothesis `hf0` is genuinely consumed.`
- `AbelianVarietyRigidity.tex`, `thm:rigidity_genus0_curve_to_AV` (proof block, L1370-1383):
  added `% NOTE (iter-166 review): proof body landed (iter-166); axioms
  {propext, sorryAx, Classical.choice, Quot.sound} — sorryAx propagates honestly through
  genusZero_curve_iso_P1 (RR bridge, iter-167+) and morphism_P1_to_grpScheme_const's helper
  residuals.`

Did NOT touch `\leanok` (deterministic-sync domain). Did NOT correct any `\lean{...}` (no
rename happened — the prover used the planner's hints verbatim). No `\notready` markers to
strip.

## Recommendations for next session

See `recommendations.md` for the full prioritised list. Top items:

1. **(HIGH) `gm_grpObj` + `gmScalingP1` body + `gmScalingP1_collapse_at_zero` body** — the
   three CRITICAL deferred sorries that unlock axiom-clean lift of `morphism_P1_to_grpScheme_const`
   and `rigidity_genus0_curve_to_grpScheme`. Before any prover dispatch on `gm_grpObj`,
   dispatch `mathlib-analogist (api-alignment)` on the units-functor representable-by
   witness.
2. **(MEDIUM) Helper-internal residuals** — the 3 product instances + `IsReduced
   ProjectiveLineBar.left` + `IsDominant iotaGm.left` in `morphism_P1_to_grpScheme_const_aux`.
   Some have Mathlib bridges (e.g. `MorphismProperty.IsStableUnderBaseChange` for LOFT);
   probably a single bookkeeping iter once the relevant Mathlib lemmas are located.
3. **(MEDIUM) Stale-narrative purge** — carry-over from iter-164 still untouched (6 files,
   ~150 LOC of stale prose). A single hygiene-only iter would clear it.
4. **(MEDIUM) Blueprint `\lean{...}` per-decl coverage gap** — still open from iter-165:
   the three ℙ¹-points + `gmScalingP1_collapse_at_zero` + `gm_grpObj` + `Ga`/`Gm` need per-decl
   `\lean{...}` hooks under `def:genus0_base_objects` / `def:gaTranslationP1`. A
   blueprint-writer dispatch on `AbelianVarietyRigidity.tex` would close it.
5. **(LOW) Drop the 5 redundant `-- TODO:` excuse-comments** inside
   `morphism_P1_to_grpScheme_const_aux` — the docstring at L924-930 already discloses; the
   kernel `sorry` already alarms. Auditor flagged as major hygiene.
