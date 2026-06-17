# Session 197 Summary

## Session metadata

- **Iter**: 197 (`session_197/` is the review of `iter-197`).
- **Sorry count**: entering 85 → exiting **84** (net −1).
- **Project axioms**: 0 → 0 — **17th consecutive zero-axiom build streak**.
- **Build**: `lake build AlgebraicJacobian` GREEN; all 8361 jobs replayed.
- **Plan status (per `logs/iter-197/meta.json`)**: `prover.status: done`;
  5/5 prover lanes returned `done` (no API 529 errors); plan.status
  was `skipped` (recorded), but the plan-phase work — 7 dispatches per
  `iter/iter-197/plan.md` — completed normally before prover dispatch.
- **Files edited this iter (prover)**:
  - `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean`
  - `AlgebraicJacobian/AbelianVarietyRigidity.lean`
  - `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
  - `AlgebraicJacobian/RiemannRoch/OCofP.lean`
  - `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`

## Headline

iter-197 delivered **THREE hard sorry closures across THREE lanes** —
the strongest closure rate in 10+ iters — plus a substantive structural
advance on a fourth lane (the iter-188—194 STUCK Proj.appIso signal
is now formally resolved). One lane (OCofP Lane A) consumed its full
helper budget on substrate building and remains correctly substrate-
gated; one lane (AVR Lane E) advanced to a strictly smaller project-
side residual on consumer #1.

### Sorry closures (3 hard closures across 3 lanes)

1. **Lane ChartIso** — `projectiveLineBar_smooth_chart_aux` (L406).
   Axiom-clean via new helper `projectiveLineBar_smooth_chart_X`
   (~50 LOC). Cascades to `projectiveLineBar_smoothOfRelDim`
   (also now fully axiom-clean — verified).
   ChartIso 1 → **0 sorries** (file complete).
2. **Lane I (WeilDivisor)** — `hy_ne_bot` in
   `isRegularInCodimOneProjectiveLineBar` (L916). Generic-point-
   contradiction shortcut (~30 LOC), bypassing the documented Stacks
   02IZ topological-coheight bridge entirely.
   `isRegularInCodimOneProjectiveLineBar` now fully axiom-clean.
   WD 4 → **3 sorries**.
3. **Lane H (H1Vanishing)** — `hinner_iso` residual on
   `Scheme.skyscraperSheaf_eq_pushforward_const` (L851). Route H-2
   constructive iso via 4 new declarations (`alphaConstToSkyPUnit`,
   `betaSkyToConstPUnit`, the composition lemma, and
   `Scheme.skyscraperSheaf_iso_constantSheaf_punit`).
   `skyscraperSheaf_eq_pushforward_const` now fully axiom-clean.
   H1V 3 → **2 sorries**.

### Structural advances (no closure, but residual reduced)

4. **Lane E (AVR)** — three new axiom-clean Proj-side helpers:
   `Proj.basicOpenIsoSpec_inv_app_top`,
   `Proj.awayι_app_basicOpen`,
   `Proj.awayι_appIso_top_inv`. Applied to consumer
   `kbarChart1Ring_specMap_fac` (L432): the iter-188—194 STUCK
   "Proj.appIso evaluation" signal is now FORMALLY RESOLVED; the
   residual reduces to a strictly smaller project-side
   `onePt.left.app(D₊(X_1))` evaluation.
   AVR 3 → 3 (no count change; substantive structural advance).

### Substrate landings (helper-budget probe)

5. **Lane A (OCofP)** — 3 axiom-clean substrate helpers
   (`localLift_of_log_ordFrac_eq_zero`,
   `algebraMap_bijective_of_finite_isDomain_isAlgClosed`,
   `functionField_localUnit_of_orderZero_at_primeDivisor`). Parent
   body of `functionField_const_of_complete_curve_of_orderZero`
   advanced to extract per-stalk witnesses before the sorry on
   global Hartogs gluing + Γ=k̄. The two remaining gaps are precisely
   typed for iter-198+.
   OCofP 3 → 3 (no count change; substantive substrate growth).

## Per-lane analysis

### Lane ChartIso (SOLVED) — `projectiveLineBar_smooth_chart_aux`

Closure path: helper-lemma factoring. The cover-form proof
`SmoothOfRelativeDimension 1 ((![X 0, X 1] : Fin 2 → _) i ≫ struct)`
is blocked because the `(![X 0, X 1] : Fin 2 → _) i` form's
`f_deg : f ∈ 𝒜 1` membership proof is tied to the elaborated form
and direct rewrite to `X i` fails. The fix: factor a named-`X i`
helper `projectiveLineBar_smooth_chart_X kbar i`, then `fin_cases`
at the cover level to bridge via `Matrix.cons` definitional
reduction.

Inside the helper: 11 ordered steps —
1) Rewrite the structure morphism via the `Proj.toSpecZero` form
   (`rfl`).
2) Re-associate via `(Category.assoc _ _ _).symm` (a plain
   `rw [← Category.assoc]` fails on the 3-fold composition due to
   HOU snags on the elided f_deg / hm proof args).
3) `Proj.awayι_toSpecZero` collapses `awayι ≫ Proj.toSpecZero` to a
   `Spec.map` form.
4) `Spec.map_comp` backward combines two `Spec.map`s.
5) `HasRingHomProperty.Spec_iff (P := @SmoothOfRelativeDimension 1)`
   translates to ring-hom property.
6) `RingHom.locally_of RingHom.isStandardSmoothOfRelativeDimension_respectsIso`
   peels `Locally`.
7) `change` to `algebraMap kbar (Away 𝒜 (X i))` form (rfl under the
   project's `algebraKbarAway` instance).
8) `RingHom.isStandardSmoothOfRelativeDimension_algebraMap.mp` to
   the algebra-property form.
9-10) Build kbar-algEquiv chain
   `MvPolynomial (Fin 1) kbar ≃ₐ[kbar] MvPolynomial Unit kbar ≃ₐ[kbar] Away`
   via `renameEquiv kbar finOneEquiv` + `AlgEquiv.ofRingEquiv` upgrading
   `homogeneousLocalizationAwayIso` with the project's
   `_algebraMap` lemma.
11) `Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv` with
    the iter-196 BareScheme substrate
    `mvPolynomialFin_isStandardSmoothOfRelativeDimension`.

Outer body of `projectiveLineBar_smooth_chart_aux`: `simp only`
unfold cover + `fin_cases i` + `exact` per branch.

**Cascade**: `projectiveLineBar_smoothOfRelDim` (L449 in ChartIso)
is now fully axiom-clean. Unlocks Lane RCI Route C smooth-dim-1
substrate (deferred consumer downstream).

### Lane E (AVR) — three new helpers + consumer #1 advance

Per the iter-195 mathlib-analogist recipe `lane-e-proj-appiso-pivot`
(ANALOGUE_FOUND verdict), built the three Proj-side helpers that
port `IsAffineOpen.fromSpec_app_self`'s Mathlib pattern to the
project's setting:

- **`Proj.basicOpenIsoSpec_inv_app_top`** — closed-form for
  `basicOpenIsoSpec.inv.app ⊤`. ~15 LOC. The key tactic:
  `cancel_mono` on `(basicOpenIsoSpec.hom).appTop`, then
  three sequential `Iso.{hom_inv_id,inv_hom_id}_assoc` reductions.
  Sidestepped iter-196's recorded failure (motive issues with
  `IsIso` typeclass-dependent rewrites).

- **`Proj.awayι_app_basicOpen`** — Proj-side port of
  `IsAffineOpen.fromSpec_app_self`. ~10 LOC. The decisive insight:
  `change` (definitional unfolding) replaces `Proj.awayι 𝒜 f f_deg hm`
  with `(basicOpenIsoSpec).inv ≫ ι` — this IS the definition; then
  `Scheme.Hom.comp_app` + `ι_app_self` + `Scheme.Hom.app_eq` on
  `ι_preimage_self` + the new helper #1 + `aesop_cat` eqToHom
  cascade. **`change` sidesteps the dependent-motive issue on
  `Scheme.Hom.app f V` that blocks `rw`, `conv_lhs => rw`, AND
  `appLE`-form transformations** — see the new KB entry below.

- **`Proj.awayι_appIso_top_inv`** — closed form for
  `((awayι).appIso ⊤).inv`. ~22 LOC. `Iso.comp_hom_eq_id` + `appIso_hom`
  + `Scheme.Hom.app_eq` (bridging `awayι ''ᵁ ⊤` and `basicOpen 𝒜 f`) +
  helper #2 + `slice_lhs` to collapse 2 eqToHom pairs + `hom_inv_id_assoc`.

**Blueprint pin rename**: the blueprint had
`\lean{AlgebraicGeometry.Proj.awayι_appIso_top_inv_apply_isLocElem}`
(point-value form). The prover built the morphism-level form (strictly
stronger). I updated the `\lean{...}` pin in
`AbelianVarietyRigidity.tex:1770` to
`AlgebraicGeometry.Proj.awayι_appIso_top_inv` with a `% NOTE (iter-197)`
explaining the rename. The prose still describes the point-value form
(which the morphism-level result implies via `congr`); a blueprint-writer
dispatch can fully reshape the prose in a future iter.

**Consumer #1 (`kbarChart1Ring_specMap_fac`, L432) PARTIAL advance**:
applied the helpers via
`rw [IsOpenImmersion.lift_app, Proj.awayι_appIso_top_inv]`. The
Proj.appIso evaluation (the iter-188—194 STUCK signal) is now
formally resolved. The remaining residual is a strictly smaller
project-side reasoning about `Proj.fromOfGlobalSections.app` on
the open `D₊(X_1)` — needs a `Proj.fromOfGlobalSections_app_basicOpen`
evaluator built on top of `Genus0BaseObjects/Points.lean`'s
`evalIntoGlobal` / `pointOfVec` infrastructure. Estimated ~50-100
LOC of project-side work for iter-198+.

Consumer #2 (`iotaGm_chart1_appIso_eval`, L640) was UNTOUCHED this
iter — same helper-substitution recipe applies but is gated on the
same `Proj.fromOfGlobalSections.app` residual.

### Lane I (WeilDivisor) — `hy_ne_bot` SOLVED

The documented iter-196 plan called for a Stacks 02IZ/005X
topological-coheight bridge (~5-10 LOC against a generic
`Order.coheight`-preservation-under-open-immersion substrate).

Instead, the prover found a **qualitatively cheaper shortcut** via
the generic-point + IsMax route:
- `y.asIdeal = ⊥` ⟹ `y = genericPoint Spec(R_i)` via
  `genericPoint_eq_bot_of_affine`.
- Open immersion sends generic-of-irreducible to generic-of-irreducible
  via `AlgebraicGeometry.genericPoint_eq_of_isOpenImmersion`.
- `(𝒰.f i).base y = Y.point` (the prime-divisor's chart-lift) forces
  `Y.point = genericPoint (ProjectiveLineBar kbar).left`.
- Generic points are `IsMax` in the scheme's specialisation preorder
  (via `Scheme.le_iff_specializes.mpr` + `Scheme.genericPoint_specializes`).
- `IsMax` ⟹ `Order.coheight Y.point = 0`, contradicting the binder
  `Y.coheight = 1`.

~30 LOC; `isRegularInCodimOneProjectiveLineBar` now fully axiom-clean
(`#print axioms` returns only kernel axioms).

Dead-ends recorded:
- `inferInstance` for `IrreducibleSpace ↥(𝒰.X i)` does not unfold
  through `openCover.X` — need explicit `show`-cast to `Spec(R)`.
- `Scheme.le_iff_specializes` takes endpoints as IMPLICIT args —
  must use `.mpr` no-args.
- `IsIntegral (ProjectiveLineBarScheme kbar)` does NOT auto-cast
  from `IsIntegral (ProjectiveLineBar kbar).left`; `letI`-style
  bridge required.

Push-beyond probe on `degree_positivePart_principal_eq_finrank`
(L1108): surveyed but blocked on Hartshorne I.6.12 (Mathlib gap)
per the analogist's prior `NEEDS_MATHLIB_GAP_FILL` verdict and the
directive's "do NOT attempt full closure" framing. Structural state
unchanged from iter-195.

### Lane A (OCofP) — 3-helper substrate landing

Plan-phase committed to the multi-iter substrate build for
`functionField_const_of_complete_curve_of_orderZero` (the
iter-196 EXTRACTED typed substrate capturing the Hartshorne I.3.4 /
Stacks 02P0 gap). Iter-197 prover-mode = `mathlib-build`, helper
budget = 3 (fully consumed):

1. `localLift_of_log_ordFrac_eq_zero` — pure DVR-side step. Bridge
   `WithZero.log y = 0` to `y = 1` via `WithZero.log_le_log`
   antisymmetric; then `Ring.mker_ordFrac_eq_isUnitSubmonoid` (the
   DVR-specific identification of `MonoidHom.mker (ordFrac R)` with
   the image of `IsUnit.submonoid R` in `K`).

2. `algebraMap_bijective_of_finite_isDomain_isAlgClosed` — re-export
   of `IsAlgClosed.algebraMap_bijective_of_isIntegral` against
   `Algebra.IsIntegral.of_finite`. Bundled as project-local lemma
   to isolate the algebraic kernel of sub-helper (ii) Γ=k̄.

3. `functionField_localUnit_of_orderZero_at_primeDivisor` — scheme-
   level wrapper. Unfold `Scheme.RationalMap.order Q f =
   WithZero.log (Ring.ordFrac (stalk Q.point) f)` and invoke #1
   against the DVR stalk supplied by `[Scheme.IsRegularInCodimensionOne X]`.
   Bridge instances `instIsFractionRingCarrierStalkCommRingCatPresheafFunctionField`
   and `Scheme.IsRegularInCodimensionOne.instIsDiscreteValuationRingStalk`
   make typeclass synthesis fire end-to-end.

Parent body of `functionField_const_of_complete_curve_of_orderZero`
(L1492) advanced to open with
`let stalkLift : ∀ Q, ∃ a, IsUnit a ∧ algebraMap (stalk Q) K(C) a = f`
extracted via #3, before the still-typed `sorry` on:

- (i) Global Hartogs gluing: `Γ(X, 𝒪_X) = ⋂_{Q codim 1} 𝒪_{X, Q}`
  (Stacks 0BCK, normal Noetherian). Mathlib gap.
- (ii) `Module.Finite kbar Γ(C, 𝒪_C)` (Hartshorne III.5.2 cohomology
  substrate). Mathlib gap.

The prover task report documents the precise type statement of both
remaining ingredients (a "type the sorry, then build" discipline).

### Lane H (H1Vanishing) — Route H-2 SOLVED

The iter-196 lane H plan offered two routes for closing the inner-iso
residual `hinner_iso : Nonempty (skyscraperSheaf PUnit.unit A ≅ (constantSheaf _ _).obj A)`:
- Route H-1: build `Full + Faithful` instances for `(constantSheaf J D)`
  on irreducible spaces (Mathlib gap).
- Route H-2: directly construct the iso for the PUnit case via
  `Opens.eq_bot_or_top` on IndiscreteTopology.

Route H-2 landed. The construction:

1. `alphaConstToSkyPUnit` (`(Functor.const).obj A → skyscraperPresheaf PUnit.unit A`)
   — pointwise: at `U` with `PUnit.unit ∈ U`, use `eqToHom`; at `U`
   without, use `IsTerminal.from` to the terminal in `ModuleCat kbar`.
2. `betaSkyToConstPUnit` (other direction) — at `U` with
   `PUnit.unit ∈ U`, compose `eqToHom` with `(toSheafify).app U`; at
   `U` without (forced `U.unop = ⊥`), use
   `TopCat.Sheaf.isTerminalOfEqEmpty.hom_ext`.
3. `alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify` —
   per-open case analysis. Unit-in branch: `eqToHom_trans_assoc`.
   ⊥ branch: `IsTerminal.hom_ext`.
4. `Scheme.skyscraperSheaf_iso_constantSheaf_punit` — iso record
   `hom = ⟨β⟩`, `inv = ⟨sheafifyLift α⟩`. `inv_hom_id` via
   `sheafify_hom_ext` + the composition identity. `hom_inv_id`
   via `toSheafify_sheafifyLift` for the unit-in-U branch and
   `TopCat.Sheaf.isTerminalOfEqEmpty.hom_ext` for the ⊥ branch.

Consumer body of `Scheme.skyscraperSheaf_eq_pushforward_const`
(L1059) replaces the iter-196 sorry with
`⟨Scheme.skyscraperSheaf_iso_constantSheaf_punit kbar A⟩`. Fully
axiom-clean (verified via `lean_verify`).

Two `change` tactics bridge `↑(of PUnit.{u + 1})` vs `PUnit.{u + 1}`
defeq mismatches that `rw` cannot bridge syntactically. One was
flagged by the unused-tactic linter (kept for documentation; can be
removed in a polish pass).

**Route pivot for IsFlasque.constant_of_irreducible non-empty branch**:
the prover task explicitly recommends a stalk-based route via
`TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso` for the next
attempt — this AVOIDS the blueprint's described Full+Faithful
`constantSheaf` Mathlib gap entirely. Recorded in
`recommendations.md` and `iter/iter-197/review.md`.

## Carrier-soundness probe smoke check (iter-196 commitment)

The iter-196 plan committed to a `lean_verify` smoke check at
iter-197 review on the `HasPicScheme` / `HasPicSharp`
representability carriers to detect silent `sorryAx` propagation
through typeclass synthesis.

**Smoke check result**: `AlgebraicGeometry.Scheme.PicScheme` (the
consumer-facing `def` at `FGAPicRepresentability.lean:223` with
`[HasPicScheme C]` binder) verifies as
`{propext, sorryAx, Classical.choice, Quot.sound}`. `instHasPicScheme`
(the `⟨sorry⟩` instance at L232) verifies as the same set. The
`sorryAx` arrives through the documented single sorry-carrying site
via `Classical.choose` — **this is the designed, not silent,
propagation**.

**Downstream consumer scan**: `grep` for `HasPicScheme` / `HasPicSharp`
/ `PicSchemeGroupObject` / `PicSharpRepresentable` across the project
returns ONLY `FGAPicRepresentability.lean`. The probe is currently
INERT outside its own file — no downstream consumers yet exercise the
typeclass-synthesis chain. **No silent-propagation signal can fire
until a downstream consumer is added**, which is correctly the
purpose of the probe period.

**Abort criterion status (iter-198 = probe end)**: PROBE STATE NEUTRAL.
The probe should run one more iter (iter-198) with the carrier-soundness
abort criterion live; if no downstream consumer is added by then, the
plan agent should either (a) extend the probe explicitly with a
documented downstream-consumer dispatch to exercise the chain, or
(b) close the probe with a "no signal observed; structurally sound"
verdict. The iter-198 plan agent should make this call.

## Blueprint markers updated (manual)

- `blueprint/src/chapters/AbelianVarietyRigidity.tex:1599` — removed
  empty `\uses{}` annotation on `lem:basicOpenIsoSpec_inv_app_top`'s
  proof block (blueprint-doctor must-fix; per the doctor report,
  empty annotation crashes `leanblueprint web` with infinite
  recursion).
- `blueprint/src/chapters/AbelianVarietyRigidity.tex:1770` — renamed
  the `\lean{...}` pin on `lem:awayi_appIso_top_inv_apply_isLocElem`
  from `AlgebraicGeometry.Proj.awayι_appIso_top_inv_apply_isLocElem`
  (point-value form, never built) to
  `AlgebraicGeometry.Proj.awayι_appIso_top_inv` (morphism-level form,
  what the prover built; strictly stronger, implies the point-value
  form via `congr`). Added `% NOTE (iter-197)` documenting the
  rename and rationale; the prose still describes the point-value
  form — full prose reshape can land in a future blueprint-writer
  dispatch.

No `\mathlibok` additions this iter (none of the iter-197 closures
were Mathlib re-exports; all were proper Archon-side proofs of
project-bespoke statements or porting of Mathlib patterns to the
Proj setting).

No stale `\notready` removals (per `sync_leanok-state.json` for
iter-197, the deterministic sync added 11 / removed 4 markers across
3 chapters — the prover-touched files all received correct
deterministic updates).

## Blueprint doctor findings (iter-197)

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/logs/iter-197/blueprint-doctor.md`:

- Malformed annotation — `blueprint/src/chapters/AbelianVarietyRigidity.tex`,
  `\uses{...}` empty argument on `lem:basicOpenIsoSpec_inv_app_top`
  proof block. **FIXED this review phase** (see Blueprint markers
  updated above).

No orphan chapters or broken `\ref` / `\uses` reported by the doctor
beyond the one fixed-now item.

## Subagent dispatches (review phase)

Dispatched in parallel (foreground in their own processes; awaited
on report-file existence):

- **lean-auditor** slug `iter197` (whole-project audit, extra
  attention to the 5 iter-197-edited files).
- **lean-vs-blueprint-checker** slug `iter197-chartiso` (ChartIso ↔
  consolidated AVR chapter).
- **lean-vs-blueprint-checker** slug `iter197-avr` (AbelianVarietyRigidity ↔
  consolidated AVR chapter, with attention to the
  `awayι_appIso_top_inv` rename).
- **lean-vs-blueprint-checker** slug `iter197-wd` (WeilDivisor ↔
  RiemannRoch_WeilDivisor chapter).
- **lean-vs-blueprint-checker** slug `iter197-ocofp` (OCofP ↔
  RiemannRoch_OCofP chapter, with attention to the iter-196 pin
  re-anchoring).
- **lean-vs-blueprint-checker** slug `iter197-h1v` (H1Vanishing ↔
  RiemannRoch_H1Vanishing chapter, with attention to the H-1 route
  pivot recommendation).

Reports auto-archived to `logs/iter-197/`. Headline findings
threaded into `recommendations.md`.

**Status — all 6 subagents returned**:
- `lean-auditor iter197` COMPLETE (9.2 min, $2.16). 2 must-fix-this-iter
  + 6 major + 4 minor + 2 excuse-comments. Findings threaded into
  `recommendations.md` as CRIT-0a (RelPicFunctor `PicSharp.addCommGroup`
  excuse-`exact sorry`) and CRIT-0b (AlbaneseUP `bundle := sorry`
  placeholder). **No new must-fix introduced by iter-197 changes**;
  both items predate iter-197.
- `lean-vs-blueprint-checker` 5 dispatches COMPLETE. **0 must-fix-this-iter
  across all 5 reports**. iter-197 prover changes landed cleanly with
  blueprint coverage. Aggregate: 8 major (mostly stale-comment / pin-
  missing / `\leanok`-not-yet-synced findings — all suitable for
  iter-198 plan-phase blueprint-writer dispatches) + many minor +
  **1 strategy-modifying finding** (lvb-h1v: Route C for
  `IsFlasque.constant_of_irreducible`, aligns with recommendations.md
  CRIT-2).

## Key findings / patterns discovered

- **`change` sidesteps `Scheme.Hom.app f V`'s dependent-motive
  blocker on `rw`** — see KB entry below. Generalises the iter-196
  Lane E recorded blocker.
- **Generic-point + IsMax shortcut for codim-1-on-Proj coheight
  reasoning** — avoids Stacks 02IZ topological-coheight transfer
  entirely. KB entry below.
- **PUnit IndiscreteTopology shortcut for skyscraper/constantSheaf
  iso** — avoids the Full+Faithful constantSheaf Mathlib gap. KB
  entry below.
- **Stalk-based iso bridge for `presheafToSheaf` is the recommended
  pivot for `IsFlasque.constant_of_irreducible` non-empty branch** —
  see recommendations.md.

## Recommendations summary

Top priorities for iter-198 plan agent (see `recommendations.md` for
details):

1. Lane E push: build `Proj.fromOfGlobalSections_app_basicOpen`
   evaluator (~50-100 LOC) and close consumer #1 + consumer #2
   axiom-clean — the strongest closure target available.
2. Lane H follow-up: Route H-1 via the new stalk-based pivot (NOT
   Full+Faithful constantSheaf).
3. Lane A: pivot to substrate-build path between (i) algebraic
   Hartogs on normal schemes and (ii) Γ=k̄ via cohomology — the
   prover task report types both ingredients precisely.
4. Carrier-soundness probe: explicit end-of-probe verdict in iter-198.
5. Blueprint maintenance: rerun blueprint-doctor and address any
   residual issues; the iter-197 `\uses{}` fix is the only one
   landed this iter.
