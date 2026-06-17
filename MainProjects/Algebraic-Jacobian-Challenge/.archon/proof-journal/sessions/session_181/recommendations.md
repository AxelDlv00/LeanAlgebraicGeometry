# iter-182 plan-phase recommendations

## Review-phase subagent findings

- **lean-auditor `iter181`** (whole project, foreground): **Solid iter** — 0 must-fix / 4 major / 6 minor / 0 excuse-comments. All 3-tier kernel-clean disclosure claims verify against `lean_verify`. No new project axioms. No laundering helpers. iter-178 178A excuse-comment fully retired by Lane I signature refactor. Full report at `.archon/task_results/lean-auditor-iter181.md`.
- **lean-vs-blueprint-checker `iter181-ocofp`** (background, completed): **complete: partial, correct: true.** iter-180 CRITICAL must-fix RESOLVED — `globalSections_iff` RHS now binds `s` to `f` matching the chapter prose verbatim. Minor: missing `\lean{...}` pin for new `toFunctionField` declaration in the blueprint. iter-182 plan agent should dispatch a small blueprint-writer to add a definition block `def:lineBundleAtClosedPoint_toFunctionField` referencing `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField}`. Full report at `.archon/task_results/lean-vs-blueprint-checker-iter181-ocofp.md`.
- **lean-vs-blueprint-checker `iter181-points`** (background, completed): **PASS HARD GATE on both axes.** iter-181 closure of `gm_grpObj` faithfully reflected; chapter has correct pin; instance is kernel-clean. Minor: stale narrative in `gmHomFunctor_representableBy` docstring (Lean L477–482 still describes the three closed lemmas as "named substantive sorries"); optional chapter expansion noting `ofRepresentableBy` construction route in `def:gm_grpObj`. Full report at `.archon/task_results/lean-vs-blueprint-checker-iter181-points.md`.
- **lean-vs-blueprint-checker `iter181-ratcurveiso`** (background, completed): **must-fix-this-iter:** `morphism_degree_via_pole_divisor` (Pin 2, L310-320) signature is **structurally weaker than the blueprint claim** — discharged by ANY positive-degree divisor on `C` and does not reference `φ`. Per the file-skeleton weakening pattern: type must be strengthened before any iter-182+ body work, else any body would close a vacuous statement. **Major:** Pin 3 chapter prose lags the iter-181 Lane I signature refinement (prover-deferred to iter-182 plan-phase per Lane I task_result); chapter does not document the canonical `[Algebra K(C') K(C)]` instance convention. **Minor:** `morphismToP1OfGlobalSections` Lean signature is the trivialised specialisation of the blueprint's general invertible-sheaf statement; gap acknowledged in docstring but worth a chapter `% NOTE:`. Full report at `.archon/task_results/lean-vs-blueprint-checker-iter181-ratcurveiso.md`.

## CRITICAL (RatCurveIso Pin 2 — must-fix-this-iter)

### Strengthen `morphism_degree_via_pole_divisor` signature before any body work

`RiemannRoch/RationalCurveIso.lean:310-320` Pin 2 type is structurally
weaker than the blueprint claim. iter-181 lean-vs-blueprint-checker
flagged it as **weakened-wrong** — the lemma is discharged by ANY
positive-degree divisor on `C` and does not reference `φ`. Body is
`sorry` so no false proof is shipped, but **any iter-182+ body work
would close a vacuous statement**.

**Recommended iter-182 plan-phase action**: dispatch a `refactor`
subagent (analogous to `refactor ocofp-globalsections-sig` from
iter-181) to strengthen Pin 2's signature to reference `φ` and the
specific divisor `morphism_degree_via_pole_divisor (φ : C ⟶ C') ...
: φ.degree = D.degree` per `analogies/ratcurveiso-pin2.md` Decision
2 framing. Keep the body `sorry`. **DO NOT dispatch Lane Pin 2
body work** in iter-182 until the signature is fixed.

Companion blueprint-writer follow-up (per checker recommendation):
update `lem:degree_one_morphism_iso` (Pin 3) chapter prose to match
the iter-181 Lean signature refinement (`Module.finrank K(C') K(C) = 1`
vs `deg(φ) = 1`), and add a sentence documenting the canonical
`[Algebra K(C') K(C)]` instance convention.

## CRITICAL (lean-auditor MAJOR)

### Address the vacuous-`globalSections_iff` condition

`OCofP.lean:154 lineBundleAtClosedPoint.toFunctionField` is currently
`noncomputable def := sorry` on a non-`Prop` carrier. The iter-181
plan-phase refactor moved the iff's RHS from `Nonempty { s // s ≠ 0 }`
(vacuous-in-`f`) to `∃ s, toFunctionField P hP s = f` (binds `s` to
`f`). But until `toFunctionField` has a real body, the equation
`toFunctionField P hP s = f` compares two opaque "the" values, so the
iff is mathematically vacuous **even with** the iter-181 binding fix.

**Lane A (OCofP) cannot productively re-fire until `toFunctionField`
or `lineBundleAtClosedPoint` has a real body.** The directional
helpers `globalSections_iff_mp` and `globalSections_iff_mpr` will
themselves remain vacuous-bodied while `toFunctionField` is opaque.

**Recommended iter-182 action**: dispatch a `mathlib-analogist`
consult on the Sheaf-internal-Hom + ModuleCat-forget infrastructure
path for `lineBundleAtClosedPoint`'s body. This was flagged iter-180
Lane D task_result as the substantive Mathlib gap and is now the
critical-path blocker on OCofP. **Alternative**: open a bottom-up
`IdealSheafDual.lean` lane that constructs the dual of the ideal
sheaf of a closed point directly, bypassing the
Sheaf-internal-Hom gap.

**Until then, do NOT dispatch Lane A again** — it cannot close
without unblocking `toFunctionField`. iter-181's Lane A correctly
delivered the directive's GATE RISK PARTIAL shape; re-firing without
a structural change is wasted work.

## HIGH-VALUE

### Schedule Lane B `cross01` + Lane E `iotaGm_range_isOpen` together

These two helpers share the **same chart-1 unfold work**: extract a
chart-1 section `s` of `gmScalingP1_cover`, identify
`s ≫ gmScalingP1_chart 1` with `Gm = Spec k̄[t, t⁻¹] ↪ Spec(Away 𝒜 (X 1))
⟶ ℙ¹` open immersion. Once landed, **both helpers close in 1-2 LOC
each** via `IsOpenImmersion.isOpen_range` + the ring identity on
`Localization.Away t ⊗_{k̄} GmRing`.

**Recommended**: dispatch a `mathlib-analogist` consult to extend
the `analogies/gmscaling-cover-bridge.md` recipe to chart-1 section
extraction. The iter-181 Lane B 3-step body recipe captures the
substance:
1. Add `Away_X0_X1_iso : Away 𝒜 (X 0 · X 1) ≃+* Localization.Away (chart-1 affine coord)` (~25-40 LOC) in `ChartIso.lean`, mirroring `homogeneousLocalizationAwayIso` for the product.
2. Build `pullback ((cover).f 0) ((cover).f 1) ≅ Spec ((Away 𝒜 (X 0 · X 1)) ⊗[kbar] GmRing kbar)` (~30-50 LOC), via `pullbackSymmetry`, `pullbackRightPullbackFstIso`, `pullbackSpecIso`.
3. Reduce `cross01` to `congrArg Spec.map` on the underlying ring-level equation `λ · u = (1/t) · λ` and close with `Algebra.TensorProduct.tmul_mul_tmul` + `IsLocalization.Away.mul_invSelf`.

Total iter-182 estimate: ~70-115 LOC; closes 2 sorries (cross01 in GmScaling + iotaGm_range_isOpen in AVR). Single dispatch.

### Lane G AuslanderBuchsbaum continued

Real downward sorry trajectory (6 → 5 → 4 across 3 iters). The named
helper `exists_isRegular_of_regularLocal` captures the substantive
gap. **Recommended iter-182 lane**: close `exists_isRegular_of_regularLocal`
body. Strategy:
1. Dispatch `mathlib-analogist` consult on `IsRegularLocalRing → IsDomain`
   (Stacks 00NQ). Likely Mathlib has this in flight; if not, scaffold a
   1-iter direct proof using `Mathlib.RingTheory.Ideal.MinimalPrime` +
   `Mathlib.RingTheory.Ideal.KrullIntersection`.
2. With (1), the regular-quotient induction (R/x₁R is regular of dim d-1)
   composes via `Ideal.height_le_one_of_principal` (already in Mathlib).
   ~50-80 LOC.

**Alternative**: pivot to `auslander_buchsbaum_formula` (L326) or
`depth_eq_smallest_ext_index` (L228) — either unblocks more of the
depth API for downstream consumers; **but** the iter-181 Lane G prover
report explicitly recommends the `of_regular` continuation, and the
iter-181 helper sets it up cleanly.

## MEDIUM-VALUE

### Lane D RelativeSpec continuation

`pullback_iso_construction` body is the remaining substantive sorry.
iter-181 Lane D task_result suggests an ~150-250 LOC over 2-3 helpers
plan (cocone + colimit universal property) OR a shortcut via
`IsColimit.coconePointUniqueUpToIso` with a natural iso between
indexing categories (may collapse 2-3 helpers into 1). The shortcut is
the cheaper try first.

### Lane F QuotScheme — watch for churn

`canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` body is now
structurally decomposed but `_of_isAffineOpen_of_isAffineBase` still
carries a substantive `sorry` (the affine-open section formula for
`Scheme.Modules.pullback` is a real Mathlib gap). File 7 → 8 sorry net
+1 across iter-180 and iter-181. **iter-182 is the decisive test**:
either close `_of_isAffineOpen_of_isAffineBase` body (the gap is
project-side ~50-100 LOC of `Module.Flat.isBaseChange` plumbing) OR
classify the route as CHURNING and pause for blueprint expansion.

## CONTINUING

### Lane H RRFormula continuation

`eulerCharacteristic_sheafOf_zero` (base case `χ(sheafOf 0) = 1 - g`)
and `eulerCharacteristic_sheafOf_single_add` (inductive step) are the
two named helpers. Both gated on RR.3 supplying
`sheafOf 0 = toModuleKSheaf C`. iter-182 lane: dispatch RR.3 work in
`RiemannRoch/OcOfD.lean` (the `sheafOf` body is the project-side
locally-principal ideal-sheaf glue per Hartshorne II §6 Prop 6.13).
With `sheafOf` body landed, **both** RRFormula helpers become
provable directly, AND the transitive `sorryAx` on
`l_eq_degree_plus_one_of_genus_zero` retires (iter-180 auditor MAJOR
satisfied).

### Lane I RationalCurveIso body lane (iter-182+ — first body lane)

iter-181 landed Pin 3 signature refinement (`[Algebra k₁ k₂]` +
`Module.finrank k₁ k₂ = 1`). iter-182 body lane via 4-step
normalisation route in the docstring:
1. Non-constant smooth-curve morphism is finite (Hartshorne II.6.8;
   needs project-bespoke surjective+proper+quasi-finite chain).
2. Normalisation of `φ` equals `C'` under smoothness of `C'`
   (~30-50 LOC; smooth ⟹ regular ⟹ normal in dim-1).
3. Mathlib's `Scheme.Hom.instIsIsoToNormalizationOfIsIntegralHom`
   fires once the above two land.
4. Compose into the final iso.

~80-150 LOC total. iter-182 plan-phase prose tightening of chapter §3
needed first (to reflect new signature shape).

**Bundle with**: Pin 2 `morphism_degree_via_pole_divisor` body
attempt — analogist verdict (`analogies/ratcurveiso-pin2.md`) says
~80-150 LOC via `Ideal.sum_ramification_inertia` chart calculation.

## DO NOT RETRY

### Lane A OCofP body without `toFunctionField` body first

iter-181 delivered the directive's GATE RISK PARTIAL shape; iter-182
must NOT re-dispatch Lane A without first landing `toFunctionField`
(or `lineBundleAtClosedPoint`). The helpers are vacuous-bodied.

### `cancel_mono` on `PLB.hom`

iter-181 Lane B confirmed `(ProjectiveLineBar kbar).hom : ℙ¹ → Spec k̄`
is NOT mono (positive-dimensional fibre over the closed point). Do
not attempt this approach in any chart-bridge / cocycle proof.

### `IsOpenImmersion.isDominant`

iter-178 dead-end memory confirmed in iter-181 Lane E search log. The
lemma does not exist in Mathlib. The standard chain is
`IsOpenImmersion ⟹ IsOpen (range) ⟹ Dense range ⟹ DenseRange`.

### iter-180 PRIMARY `respectTransparency` recipe for cross-case sorries

iter-181 Lane B Attempt 3 confirmed the chart_PLB_eq recipe does NOT
generalize to `gmScalingP1_chart_agreement` cross case nor to
`gmScalingP1_collapse_at_zero`. The cross case sits in TensorProduct
of `Localization.Away` with `GmRing`, a different blocker family. Do
not directly try Stage-3-simp from iter-180 on these; use the 3-step
ring-identity recipe in `cross01` docstring instead.

## STRATEGY-LEVEL

### 3-tier kernel-clean disclosure adoption — KEEP

The iter-181 prover directives required 3-tier disclosure
(kernel-clean (this body) / kernel-clean modulo upstream X /
kernel-clean transitively). lean-auditor `iter181` confirms zero
inflation: every prover's disclosure tier matches the actual
`lean_verify` axiom set. Keep this directive language in iter-182+.

### Signature audit microstep for chapter-first-then-Lean lemmas

iter-180 surfaced the OCofP `globalSections_iff` CRITICAL signature
bug; iter-181 plan-phase refactored it. iter-181 informational from
progress-critic `route181`: adopt a "signature audit" microstep for
any lemma whose statement was authored in the blueprint before the
Lean signature crystallized — particularly when the prose uses
informal predicates with multiple non-equivalent formalizations.
Recommended trigger: dispatch `lean-vs-blueprint-checker` on any
OCofP-style file where the chapter prose predates the Lean signature
by ≥2 iters.

### iter-status docstring embedding — pruning pass scheduled?

lean-auditor `iter181` MAJOR: ~417 cumulative `iter-1XX` references
across 27 files. The auditor recommends demoting to bottom-of-file
blocks or periodic pruning of >3-iter-out status. Recommended
iter-185+ refactor lane: structural-refactor subagent pass to
demote inline iter-status docstrings to a `## iter-history` block at
file bottom. Not blocking, not urgent, but the comments are now a
substantive fraction of file source.

## Off-target deferrals (PROGRESS.md `## Standing deferrals`)

Per iter-181 plan-phase decision (deadline-branch over blueprint-expansion-branch):

- **4c RelPicFunctor** — re-engage when A.1.b `LineBundle.OnProduct` body lands; estimated iter-184+.
- **4e FGAPicRepresentability** — re-engage when A.2.c Quot+RelPic pipeline assembles; estimated iter-190+.
- **4f FlatteningStratification** — re-engage when A.2.a sub-build starts; estimated iter-185+ (currently substrate UNOWNED — gated on writer capacity).
- **5d AlbaneseUP** — re-engage when A.3 substrate (`Pic⁰.bundle` / `IdentityComponent.lean` skeleton) and A.4.d.i (`Sym^g` skeleton) land; estimated iter-200+.

If a STUCK-by-inaction streak exceeds 8 iters on any of these, the
deadline branch should escalate to the blueprint-expansion branch
(dispatch a `blueprint-writer` subagent to expand the chapter sub-section).

## Re-engagement summary

| Lane | iter-182 action | Helper budget | Sorry close target |
|---|---|---|---|
| OCofP-toFunctionField | mathlib-analogist consult on Sheaf-Hom + ModuleCat-forget | 0 (consult only) | 0 this iter; sets up iter-183+ body lane |
| GmScaling+AVR coordinated | mathlib-analogist consult on chart-1 section extraction + body lane | 1 helper (Away_X0_X1_iso) | 2 (cross01 + iotaGm_range_isOpen) |
| AuslanderBuchsbaum | mathlib-analogist consult on IsRegularLocalRing → IsDomain + body lane | 2 helpers | 1 (exists_isRegular_of_regularLocal) |
| RelativeSpec | body lane via IsColimit.coconePointUniqueUpToIso shortcut | 1-3 helpers | 1 (pullback_iso_construction) |
| QuotScheme | body lane on _of_isAffineOpen_of_isAffineBase | 2 helpers | 1 (the substantive helper) |
| RRFormula | RR.3 sheafOf body lane (file = OcOfD.lean) | 2 helpers | 2 helpers + transitive l_eq_degree retirement |
| RatCurveIso | plan-phase prose tightening + iter-182+ body lane | 2 helpers (incl. Pin 2) | 2 (Pins 2+3 bodies) |

Total iter-182 lanes proposed: 7. Cap = 10. Comfortable.
