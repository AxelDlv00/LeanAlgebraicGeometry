# Iter-169 — Objectives (sidecar narrative for the prover dispatch)

## Lane A — `AlgebraicJacobian/Genus0BaseObjects.lean`

### PRIMARY (must-land) — `gmScalingP1` body + `gmScalingP1_collapse_at_zero` body via Option B

Headline target: close the `sorry` at L661 (`gmScalingP1`) and L678
(`gmScalingP1_collapse_at_zero`) via the **direct
`Proj.fromOfGlobalSections` route**, NOT via the iso
(`homogeneousLocalizationAwayIso`) skeleton landed iter-168.

**Why Option B**: progress-critic `routec169` returned **CHURNING** with
the headline target untouched for 4 consecutive iters (`gmScalingP1` body
has not been attempted since iter-165's scaffold). The iter-168 prover
themselves surfaced Option B as the "cleaner overall" alternative that
"would not require the iso to be axiom-clean." Option B sidesteps the
iter-168 `aux_left` residual sorry entirely and lands the body directly.

**Option B recipe** (the prover should treat as a starting sketch, not a
verbatim transcription):

1. **Chart-side morphism via `Proj.fromOfGlobalSections` directly into
   the product ring `Away 𝒜 (X i) ⊗ GmRing`** — one for each chart
   `i ∈ Fin 2`. The ring map
   ```
   φ_i : MvPolynomial (Fin 2) kbar →+* Away 𝒜 (X i) ⊗[kbar] GmRing kbar
   ```
   sends (chart i = 1, the chart where `zeroPt = [0:1]` lives):
   - `X 1 ↦ (HomogeneousLocalization.Away.mk X 1 isHomogeneous 1) ⊗ 1`
     (the canonical lift, a unit in `Away 𝒜 (X 1)` since
     `X 1 / X 1 = 1`).
   - `X 0 ↦ (HomogeneousLocalization.Away.mk X 0 isHomogeneous 1) ⊗ λ`
     (the affine coord `X 0 / X 1` of `Away 𝒜 (X 1)`, scaled by
     `λ ∈ GmRing`).

   For chart 0 (symmetric, `X 0` is the unit coord, `X 1 ↦ X 1 / X 0`
   scaled by `λ⁻¹` via `IsLocalization.Away.invSelf`).

2. **Irrelevant-ideal condition for `Proj.fromOfGlobalSections`**: the
   image of `(X 0, X 1)` under `φ_i` must generate the unit ideal in
   `Γ(Spec (Away 𝒜 (X i) ⊗ GmRing), ⊤)`. Since `X i ↦ (unit lift) ⊗ 1`
   in chart `i`, the image of `X i` is a unit, so the irrelevant ideal
   maps to the unit ideal. The discharge is exactly the same shape as
   `ProjectiveLineBar.irrelevant_map_eq_top` (L409, axiom-clean) — copy
   that template.

3. **Glue via `Scheme.Cover.glueMorphisms`** over `projGmCover`
   (the pullback of `projectiveLineBarAffineCover.openCover` along
   `pullback.fst (ProjectiveLineBar).hom (Gm).hom`, i.e.
   `Scheme.Cover.pullback₁`). Cross-chart agreement on `D₊(X 0 · X 1)`:
   both chart maps restrict to the same morphism into ℙ¹ on the
   intersection. The cleanest discharge: use `Proj.fromOfGlobalSections`'s
   functoriality + the explicit ring identity
   `λ·X 0 ⊗ X 1 = X 0 ⊗ X 1 · λ` (or its chart-form variant).

4. **`gmScalingP1_collapse_at_zero` body** (L678): chart-level direct
   computation. `zeroPt = pointOfVec (v 0 := 0, v 1 := 1) 1` lives in
   chart 1; precomposing the chart-1 map with `zeroPt`'s factorization
   gives `X 0 ↦ 0 · 1 ⊗ λ = 0` and `X 1 ↦ 1 ⊗ 1 = 1`. The resulting
   composite at the `Proj.fromOfGlobalSections` level evaluates to
   `zeroPt` independent of `λ` — i.e. constant in `Gm`. This is
   `toUnit (Gm kbar) ≫ zeroPt`. Helper (~15 LOC): a
   `zeroPt_factors_through_chart1` lemma derived via
   `Proj.fromOfGlobalSections_morphismRestrict`
   (`ProjectiveSpectrum/Basic.lean:493`).

**Key Mathlib idioms** (taking what's still applicable from
`analogies/gmscaling-deep.md`):
- `Proj.affineOpenCoverOfIrrelevantLESpan` — already used by Step 1
  (`projectiveLineBarAffineCover`, axiom-clean iter-168).
- `Proj.fromOfGlobalSections` + `Proj.fromOfGlobalSections_toSpecZero` +
  `Proj.fromOfGlobalSections_morphismRestrict` —
  `ProjectiveSpectrum/Basic.lean:439, 493`.
- `Scheme.Cover.glueMorphisms` + `ι_glueMorphisms` + `hom_ext` —
  `Gluing.lean:436, 457, 448`.
- `Scheme.Cover.pullback₁` + `AffineOpenCover.openCover` —
  `Cover/MorphismProperty.lean:177`, `Cover/Open.lean:128`.
- `pullbackSpecIso` and its `inv_fst / _snd / hom_fst' / hom_base`
  reassoc simps — `Pullbacks.lean:703-770`.
- `HomogeneousLocalization.Away.mk` + `algebraMap = .val` injection
  pattern — `RingTheory/GradedAlgebra/HomogeneousLocalization.lean:609`.
- `IsLocalization.Away.invSelf` (for chart 0's `λ⁻¹`) —
  `RingTheory/Localization/Away/Basic.lean:471`.
- `IsLocalization.Away.lift` / `lift_eq` (for ring-hom factorization
  through `Localization.Away`).

**Reversal mid-iter**: if Option B's irrelevant-ideal discharge runs into
a hidden Mathlib gap (e.g. the product ring `Away ⊗ GmRing`'s
irrelevant-ideal needs an extra "unit times unit" bridge not shipped),
abort cleanly and report PARTIAL — do NOT pivot to Option A or open a
new helper-supports round. The iter-170 plan handles user escalation per
the iter-169 plan's commitment.

### SECONDARY (hygiene must-fix items from `lean-auditor iter168`)

These are textual/structural cleanups; the prover should land them inline
during the same lane (one prover, one file, multiple sorries — the file's
context stays warm). They are NOT optional — the auditor flagged them as
must-fix-this-iter.

**SECONDARY-1**: Refresh the misleading `aux_left` docstring (L350-367 in
`Genus0BaseObjects.lean`). The current docstring claims "iter-168 partial:
structural setup via `ext`, `Away.mk_surjective`, `val_injective` gets us
to the underlying `Localization.Away (X i)` comparison; the residual
identity reduces to a monomial-by-monomial check…" but the body is bare
`sorry`. Rewrite to honestly say: "TODO — no body landed; deferred
infrastructure not on the genus-0 critical path (iter-169 pivoted to
Option B for `gmScalingP1`, sidestepping the iso). If needed later (e.g.
upstreaming the chart-ring iso as `HomogeneousLocalization.PolynomialQuotient`),
close via the analogist's `surjective + cancel` route described in
`analogies/gmscaling-deep.md` Q2." The body stays `sorry` — only the
docstring changes.

**SECONDARY-2**: Refresh `projectiveLineBar_isReduced` docstring (L708-718).
The current docstring claims "Project-side scaffold sorry (Mathlib does not
ship `IsReduced (Proj 𝒜)` … would close via `IsReduced.of_openCover` …
once `HomogeneousLocalization.Away` is bridged to `IsDomain`)" but the
body L719-753 actually closes the lemma axiom-clean via exactly that
strategy (the `val_injective` bridge is built inline). Rewrite docstring
to: "**`ℙ¹` is reduced.** Closed axiom-clean iter-168 via
`IsReduced.of_openCover` over `projectiveLineBarAffineCover`; each chart
`Spec (HomogeneousLocalization.Away 𝒜 (X_i))` is a domain because the
canonical `val`-injection into `Localization.Away (X_i)` (a localization
of `k̄[X_0, X_1]` at a non-zero-divisor) factors through
`Function.Injective.isDomain`." The body stays unchanged.

**SECONDARY-3**: Refresh section-(E) header (L680-696). Currently lists
"`ℙ¹` is reduced — scaffold (Mathlib gap…)" alongside the other
product-stability scaffolds, but `projectiveLineBar_isReduced` is no
longer a scaffold. Update that bullet to: "`ℙ¹` is reduced — **closed
axiom-clean iter-168** via the chart-cover + `val_injective` bridge
(`projectiveLineBar_isReduced`)." Other bullets unchanged.

**SECONDARY-4**: Drop `ga_grpObj` instance (L526-540). The auditor flagged
this as a major: "off-path for the genus-0 closure" — no live consumer in
`AbelianVarietyRigidity.lean` uses it; a sorried public instance for a
demoted route should be deleted, not kept "for the demoted route." Action:
**delete L526-540** entirely. The corresponding blueprint pin
`def:ga_grpObj` becomes orphaned but that's a downstream cleanup (the
blueprint-doctor will flag it next iter; not the prover's job to touch
the chapter).

**SECONDARY-5 (re-audit, optional but encouraged)**: For the four
remaining "Mathlib gap"-framed scaffolds in `Genus0BaseObjects.lean` —
`projectiveLineBar_geomIrred` (L175), `projectiveLineBar_smoothOfRelDim`
(L182), `gm_geomIrred` (L763), `projGm_isReduced` (L795) — re-audit
whether each "Mathlib gap" claim is actually true, per the iter-168
`projectiveLineBar_isReduced` lesson (a "gap" claim that turned out to be
< 10 LOC of inline bridge). If any closes in <20 LOC of inline work using
Mathlib lemmas already available, land it axiom-clean. If genuinely
blocked, rewrite the docstring to spell out **specifically which Mathlib
lemma is missing** (not vague "the bridge is missing at scheme level").
Acceptable to defer this entire SECONDARY-5 if PRIMARY consumes the
prover budget — but report the deferral in the prover's task result with
the per-scaffold investigation outcome (which is genuinely blocked, which
is "not investigated this iter").

### Optional / OPT-IN

- **OPT-IN**: if PRIMARY lands quickly (e.g. <80 LOC) and budget remains,
  attempt `gm_grpObj` (L622) via `GrpObj.ofRepresentableBy` per the
  iter-167 `gm-grpobj-and-friends.md` analogist recipe. This is the
  4-iter-deferred OPT-IN with escalation watch firing this iter; closing
  it would clear the escalation. Not required.

### Status criteria

- **COMPLETE** if `gmScalingP1` body lands axiom-clean (L661 closed
  without `sorry`) AND `gmScalingP1_collapse_at_zero` body lands
  axiom-clean (L678 closed without `sorry`) AND SECONDARY 1-4 all
  landed AND `lake build AlgebraicJacobian.Genus0BaseObjects` exits 0.
- **PARTIAL** if `gmScalingP1` body lands axiom-clean but
  `gmScalingP1_collapse_at_zero` body does not (or vice versa) — one
  of the two PRIMARY items lands, the other surfaces a documented
  Mathlib gap or budget exhaustion.
- **PARTIAL (acceptable)** if both PRIMARY bodies stay `sorry` but the
  prover lands ≥3 SECONDARY hygiene items + reports a *specific*
  blocking technical reason on PRIMARY (e.g. "`Proj.fromOfGlobalSections`
  for `Away 𝒜 (X i) ⊗ GmRing` requires a tensor-of-rings algebra
  instance Mathlib does not ship; the missing piece is XXX"). This is
  the "armed-trigger escalation" case — the iter-170 planner takes
  over with user escalation.
- **INCOMPLETE** if neither PRIMARY body lands AND ≤2 SECONDARY items
  land — same outcome as PARTIAL-acceptable, but the prover should
  explicitly flag "the iter is escalation-bound."

### Constraints (binding on the prover)

- NO new axioms. NO protected signature touches. Build must be green
  before exit.
- Every `sorry` (if any) must be the body of a top-level named
  declaration — NEVER buried in a `letI`/`have :=`/anonymous `fun`.
- **The iso (`homogeneousLocalizationAwayIso` and its helpers) MUST NOT
  be consumed by the `gmScalingP1` body or the `_collapse_at_zero`
  body.** This is the Option B distinguishing constraint. If the
  prover finds itself reaching for the iso to close the body, abort
  to PARTIAL and document the technical reason.
- **`gm_grpObj` MUST NOT be consumed by the `gmScalingP1` body.** The
  morphism `σ_× : ℙ¹ × Gm ⟶ ℙ¹` is a `Scheme.Hom`, not a `GrpObj.Hom`;
  the group-object structure on the target `A` (consumed by Cor 1.5 in
  AVR) is on `A`, not on `Gm`. If the prover finds itself reaching for
  `[GrpObj (Gm kbar)]`, the construction is over-specified — find the
  bare `Scheme.Hom` route.

### Off-limits this iter

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — Lane B body
  `iotaGm_isDominant` (gated on Lane A landing) + `genusZero_curve_iso_P1`
  (RR bridge, deferred to upstream Mathlib). Defer to iter-170.
- `AlgebraicJacobian/Jacobian.lean` — `genusZeroWitness` (gated on Lane A
  + AVR axiom-clean lift) + 26-line stale excuse-comment (auditor #12,
  deferred to Jacobian-touch iter). Defer.
- `AlgebraicJacobian/RigidityKbar.lean` — `rigidity_over_kbar` fallback
  artifact + stale Mumford `% SOURCE`. Off-path. Defer.
- The 5 lean-auditor stale-narrative majors in fallback-route files
  (`Cotangent/GrpObj.lean:297-326,465-525`,
  `Cotangent/ChartAlgebra.lean:20-34,552-560,624-629`,
  `RigidityKbar.lean:9-89`, AVR L1090/L1156/L915-922 iter-tag bumps).
  Hygiene iter, defer.
- The 4 OPT-IN/scaffold blueprint chapter additions of new
  `\lean{...}` blocks for `projectiveLineBar_geomIrred` /
  `projectiveLineBar_smoothOfRelDim` per checker's minor
  recommendations — defer to a future writer-pass.
- All protected signatures (`genus`, `Jacobian.*`, `Jacobian.ofCurve`
  cluster) — read-only.

### Reference documents the prover MUST consult

- `analogies/gmscaling-deep.md` — Mathlib idiom citations + the
  abandoned-this-iter Option A recipe (useful for Q3/Q4/Q5 Mathlib
  citations, NOT for the iso-route construction itself).
- `analogies/gm-grpobj-and-friends.md` — `gm_grpObj` recipe (if OPT-IN
  attempted).
- `blueprint/src/chapters/AbelianVarietyRigidity.tex`
  (`def:gaTranslationP1`, `lem:gmScaling_fixes_zero`,
  `def:projlinebar_affine_cover`, `def:proj_chart_ring_iso`,
  `lem:projlinebar_isReduced`) — informal prose + the iter-169
  new blueprint pins.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` L958-1075
  (`morphism_P1_to_grpScheme_const_aux`) — the live consumer; shows
  exactly how `gmScalingP1` is used and what its `_collapse_at_zero`
  shape must satisfy.
