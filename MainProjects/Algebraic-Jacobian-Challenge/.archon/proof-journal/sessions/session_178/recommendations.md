# Session 178 — Recommendations for iter-179 plan agent

## CRITICAL — lean-auditor `iter178-touched` must-fix landings

The whole-project audit returned 3 must-fix-this-iter findings;
report at `task_results/lean-auditor-iter178-touched.md`.

### A — `RationalCurveIso.lean:226-243` — EXCUSE-COMMENT in `morphismToP1OfGlobalSections` body (CRITICAL — weakened-wrong-by-missing-hypothesis pattern, fresh this iter)

The Lane 5 Part B body landed with an inline comment confessing the
signature is mathematically INSUFFICIENT to discharge the section
condition. Auditor verdict: "this is the canonical
weakened-wrong-by-missing-hypothesis pattern — the function ostensibly
constructs a morphism for any `f` satisfying the typed precondition,
but the section-condition obligation is undischargeable from those
preconditions, so the `sorry` would silently accept inputs for which
no such morphism exists ... Either add the missing hypothesis now or
revert the body to a bare typed `sorry` with no fictitious
construction."

This matches the iter-175 `chart-bridge-prover-bypass` pattern
(prover bypassed analogist verified recipe; recurring failure mode).

**iter-179 PRIMARY MUST-FIX**: dispatch a prover lane on
`RiemannRoch/RationalCurveIso.lean` with one of:
- **Option (a)** [recommended]: add the missing `kbar`-algebra
  hypothesis to the signature per Recommendation 5 below:
  ```lean
  (halg : f.comp (algebraMap kbar (MvPolynomial (Fin 2) kbar)) =
      (X.hom.appTop).comp (Scheme.ΓSpecIso _).inv.hom)
  ```
  then close the body via the `pointOfVec` template.
- **Option (b)**: revert the body to a bare typed `sorry` with NO
  fictitious `Over.homMk + Proj.fromOfGlobalSections` construction.

The prover directive must FORBID landing the current body shape +
sorry on the section condition (per iter-175 KB
`chart-bridge-prover-bypass-iter175` — when a structural objection
to the body shape is empirically verified, the prover directive
must encode an abort rule before the recipe is attempted on file).

### B — `CodimOneExtension.lean:391-406` — `extend_iff_order_nonneg` type is too shallow for the docstring (CRITICAL — name doesn't match what's proved)

The Lane 4 body landed as a 2-line `Scheme.RationalMap.mem_domain`
reshuffle; the `[Ring.KrullDimLE 1 (X.left.presheaf.stalk W.point)]`
binder is UNUSED. The docstring (L359-389) sells the Hartshorne II.6
"regular = no pole" valuative-criterion content, but the type
itself does NOT mention `order` anywhere. The lemma name
`extend_iff_order_nonneg` cannot be honest without the `order`
quantity appearing in the iff.

**iter-179 PRIMARY MUST-FIX**: dispatch a prover OR refactor lane
on `Albanese/CodimOneExtension.lean` to either:
- **Option (a)**: tighten the signature to include the order-`≥0`
  side, e.g.:
  ```lean
  W.point ∈ f.domain ↔
    ∃ g : ..., g.toRationalMap = f ∧ W.point ∈ (g.domain : Set _) ∧
    (∀ Y : X.left.PrimeDivisor, Scheme.RationalMap.order Y f ≥ 0)
  ```
  (and re-derive the body using the order/DVR connection).
- **Option (b)**: rename to `mem_domain_iff_partialMap` (or similar)
  to honestly reflect the actual content; remove the unused
  `[Ring.KrullDimLE 1 ...]` binder; downgrade the docstring claims.

Note: this is the SAME suspicious pattern as 178A — landing a body
that doesn't bear the claimed content. The two findings together
suggest iter-179 should add a planner-level discipline: when an
auditor MUST-FIX flags "unused binder + docstring overclaims" or
"excuse-comment + signature insufficient", the lane is forbidden
from landing until the signature is either tightened or the
docstring/name is honest.

### C — `AuslanderBuchsbaum.lean:165-167` — stale docstring on `projectiveDimension` (MAJOR-bordering-must-fix, low effort to fix)

The Lane 7 body landed kernel-clean
(`CategoryTheory.projectiveDimension (ModuleCat.of R _M)`), but the
docstring at L165-167 still says *"For the iter-175 file-skeleton
the body is a typed `sorry`"* — the docstring is now lying. The
module-level status block (L33-92) also lists declaration 3 as
`sorry`.

**iter-179 MUST-FIX**: 2-LOC docstring/status-block edit on
`Albanese/AuslanderBuchsbaum.lean` updating L165-167 and L33-92.
Could be bundled into any iter-179 lane that touches the file, or
landed as a quick polish refactor.

## CRITICAL — already-tracked carry-overs (do NOT reopen this iter)

- **2 TEMP project axioms** in `Genus0BaseObjects/GmScaling.lean`
  (`gmScalingP1_chart_data_temp`, `gmScalingP1_collapse_at_zero_temp`)
  — iter-181 RETIRE-OR-ESCALATE trigger active.
- **`Picard/RelativeSpec.lean` placeholder bodies** (`RelativeSpec _𝒜 := X`,
  `structureMorphism _𝒜 := 𝟙 X`) — iter-178 consult `relative-spec-encoding`
  produced 4-encoding option; iter-179 refactor lands Block A.
- **`Albanese/AlbaneseUP.lean:179-183 Pic0.bundle := sorry`** —
  load-bearing structure sorry; auditor flags as new CRITICAL this
  iter (escalation watch from iter-167 now 11 iters stale).
- **`Picard/LineBundlePullback.lean:119-121 OnProduct := sorry`** —
  TYPE-level sorry; auditor flags as MAJOR-bordering-must-fix; iter-179
  blueprint-writer / consult on `IsInvertible` Mathlib gap.

## HIGH — must address iter-179

### 1. Drop the `IsOpenImmersion → IsDominant` one-liner from any iter-179 Lane 2 recipe

Lane 2 iter-178 task_result conclusively proved the directive recipe
`exact IsOpenImmersion.isDominant _` does NOT work — Mathlib has no
such lemma, and the implication is FALSE in general (an open
immersion into a disconnected target need not be dominant).
**Iter-179+ planners must drop this framing.** The correct shape is
either route (a) chart-1 factorisation (per task_result § Next step)
or route (b) `IrreducibleSpace (ProjectiveLineBar kbar).left` (a
Mathlib bridge gap itself).

### 2. iter-179 BODY-lane on `iotaGm_isDominant` is GATED on `gmscaling-cover-bridge` consult applied

The iter-178 plan dispatched the consult on cover-vs-`Proj.awayι`
producing the iter-179 plan's recipe:

- **Step 1** (~12 LOC, structural, `BareScheme.lean`): hoist tactic-built
  proof closures in `projectiveLineBarAffineCover` to top-level named.
- **Step 2** (~-8 LOC net, structural, `GmScaling.lean`): rewrite
  `gmScalingP1_cover_X_iso` uniform-in-`i`.
- **Step 3** (~80-125 LOC, body fills, `GmScaling.lean`): 3 lemma
  bodies (`gmScalingP1_chart_PLB_eq`, `gmScalingP1_chart_agreement`,
  `gmScalingP1_collapse_at_zero`) retire BOTH TEMP axioms.

After Step 3 lands, the chart-1 factorisation route for
`iotaGm_isDominant` becomes viable. Dispatch `refactor` subagent on
Steps 1-2 BEFORE any iter-179 prover lane re-targets
`iotaGm_isDominant` body.

### 3. Blueprint-doctor — broken cross-ref in `Albanese_CodimOneExtension.tex`

L594-L596: the `\uses{def:order_at_point, def:codim1_cycles,
lem:smooth_codim_one_dvr,\n  \leanok\n        thm:codim_one_extension}`
has a `\leanok` macro *inside* the `\uses{}` brace pair, breaking
both the `\uses{}` target list (parser reads the entire glob as one
label) and misplacing the proof-block marker. The fix is to move
`\leanok` to its own line *outside* the closing `}` (matching the
pattern at L139, L379, etc.). **Review agent did NOT touch this**
(per the `\leanok` ownership rule — sync_leanok owns marker
add/remove). Dispatch a blueprint-writer for this chapter with a
narrow directive: "move `\leanok` from L595 (inside `\uses{}`) to
its own line after L596's closing `}`."

### 4. Iter-181 RETIRE-OR-ESCALATE trigger on TEMP axioms remains armed

Two named TEMP axioms (`gmScalingP1_chart_data_temp`,
`gmScalingP1_collapse_at_zero_temp`) in `GmScaling.lean` flagged by
blueprint-doctor. iter-181 is 3 iters away. The iter-178 plan's
post-consult roadmap (refactor Steps 1-2 iter-179 + body Step 3
iter-179/180) RETIRES these well before iter-181. Track the iter-179
refactor dispatch closely.

## MEDIUM — schedule iter-179 / iter-180

### 5. Lane 5 `morphismToP1OfGlobalSections` signature mutation

iter-178 Lane 5 task_result identified the residual goal as
"mathematically undischargeable from the current signature". The
iter-179 recommendation is a 1-LOC signature add:

```lean
(halg : f.comp (algebraMap kbar (MvPolynomial (Fin 2) kbar)) =
    (X.hom.appTop).comp (Scheme.ΓSpecIso _).inv.hom)
```

Under `halg`, the residual closes via `Scheme.toSpecΓ_naturality` +
algebra-tower commutativity. Downstream consumer audit: no current
consumer (only chained inside the still-sorry `genusZero_curve_iso_P1`
which is itself gated). Safe.

### 6. Lane 4 helper `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`

Closing this helper requires Mathlib upstream:
- (a) `Algebra.FormallySmooth k̄ R → IsRegularLocalRing R` for `R` a
  stalk over `k̄` (Stacks 00TT analogue), OR
- (b) `Algebra.IsSmoothAt R (IsLocalRing.maximalIdeal A) →
  IsRegularLocalRing A` (Stacks 00TT/00TX algebraic), PLUS
- (c) `Order.coheight z = 1 → Ring.KrullDimLE 1
  (X.left.presheaf.stalk z)` (Stacks 02IZ — already KB-recorded
  iter-176).

Once either (a) or (b) lands AND (c) lands, helper body is ~10 LOC
via `IsRegularLocalRing.iff_finrank_cotangentSpace` +
`IsLocalRing.finrank_CotangentSpace_eq_one_iff`. **iter-179 should
NOT re-attempt this body** unless a Mathlib upstream bump arrives;
record as Mathlib-gap deferred.

### 7. Lane 3 `principal_degree_zero` non-constant branch

Gated on:
- Lane 5 Part B residual closing (signature mutation needed per
  Recommendation 5).
- Project-side `Scheme.finiteMorphismOfNonConstantRational` (new
  declaration, gated on Pin 1 closing).
- Hartshorne II.6.9 degree-multiplicativity-under-finite-pullback
  (Mathlib gap or project stopgap).

Estimated 3-iter chain. Don't re-dispatch a WD-DEGREE lane until
the first two are in place.

### 8. Lane 6 helper `canonicalBaseChangeMap_app_app_isIso`

Closing requires affine-local identification of
`(pullback g).obj ((pushforward f).obj F)` sections with
`Γ(S', g⁻¹V) ⊗_{Γ(S, V)} Γ(X, f⁻¹V, F)` for affine `V ⊆ S`. This
is the algebraic content of `Module.Flat.isBaseChange` (Stacks
00H8 / 02KE). Substantial substrate. iter-179+ as multi-iter work.

## LOW — track only

### 9. Parallel-signature-race process change WORKED — keep the checklist

The iter-178 plan-agent's "signature-mutating lane audit" correctly
identified Lane 5 as the only mutating lane and verified zero current
consumer breakage. This is the first green-build iter after 2
consecutive build-broken iters. **The checklist should remain a
permanent fixture of the plan-agent's objectives composition phase.**

### 10. `IsScalarTower` `haveI` annotation trap (reusable KB pattern)

Lane 5 Part B surfaced: `haveI : IsScalarTower kbar (𝒜 0) (MvPoly ...)`
without explicit `(R := kbar) (S := ↥(...)) (A := MvPoly ...)`
annotations defaults to `IsScalarTower A A A`. The `pointOfVec` template
form does NOT elaborate here without the annotations. Promote to
Knowledge Base for reusable use across project-side `IsScalarTower`
applications.

### 11. Lane 6 `canonicalBaseChangeMap_isIso` is the GOLD STANDARD non-laundering pattern

The factorisation (a) main body axiom-clean via section-wise
`Hom.isIso_iff_isIso_app`; (b) substantive content in a named helper
with **substantive `IsIso` type** (not placeholder body) — should be
held up as the contrast against iter-176 RelativeSpec laundering
(which had `:= X` / `:= 𝟙 X` bodies). The Knowledge Base entry on
"Helper-with-sorry as honest scaffold" already documents this
pattern (iter-177 entry); iter-178 Lane 6 is a fresh example
confirming the rule.

## Blocked targets — do NOT re-assign in iter-179

- **`iotaGm_isDominant`** (AVR L86): gated on Steps 1-3 of the
  `gmscaling-cover-bridge` recipe landing first. Re-assigning in
  iter-179 BEFORE Steps 1-2 refactor lands will produce another
  PARTIAL.
- **`smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`**
  (CodimOneExtension L195 helper): gated on Mathlib upstream
  `Smooth → IsRegularLocalRing` or `IsSmoothAt → IsRegularLocalRing`.
- **`canonicalBaseChangeMap_app_app_isIso`** (QuotScheme L466
  helper): gated on the affine-local identification sub-build
  (multi-iter).
- **`principal_degree_zero` non-constant branch** (WeilDivisor L442
  branch): gated on Lane 5 Part B closing + Hartshorne II.6.9
  multiplicativity.

## Reusable proof patterns discovered iter-178

### Pattern A — `IsDiscreteValuationRing.TFAE.out 0 4` to reduce DVR-ness to principal-max-ideal

Lane 4 demonstrates the canonical Mathlib-aligned recipe for
proving `IsDiscreteValuationRing R` on a Noetherian local domain:

1. Establish `[IsLocalRing R]`, `[IsNoetherianRing R]`, `[IsDomain R]`,
   `¬ IsField R` (the last via `IsLocalRing.isField_iff_maximalIdeal_eq`).
2. Call `tfae := IsDiscreteValuationRing.TFAE R hfield`.
3. `(tfae.out 0 4).mpr ⟨principal, ne_bot⟩`.

The substantive geometric content reduces to proving
`Submodule.IsPrincipal (IsLocalRing.maximalIdeal R) ∧ maximalIdeal R ≠ ⊥`
— the cleanest factoring for Mathlib-gap deferral.

### Pattern B — Symptom-based case-split avoids algebra-tower substrate work

Lane 3 demonstrates: when a "constant vs non-constant" case-split
on a function-field element seems to require building a Algebra-tower
`kbar → Γ → functionField` (~40-60 LOC of substrate work over a
function-field `f`), case-split on the SYMPTOM instead — e.g.
`by_cases hconst : ∀ Y, Scheme.RationalMap.order Y f = 0` —
which sidesteps the algebra tower entirely. The constant case
closes via `Finsupp.ext + Finsupp.sum_zero_index + defeq through
Finsupp.ofSupportFinite_coe (via `change` tactic)`.

### Pattern C — `Scheme.Modules.Hom.isIso_iff_isIso_app` for section-wise iso

Lane 6 demonstrates: when the goal is an iso of `Scheme.Modules`
morphisms with substantive content, factor via the canonical
Mathlib lemma `Scheme.Modules.Hom.isIso_iff_isIso_app` (at
`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean`) to a section-wise
claim. The factored helper TYPE carries the substantive content;
distinguishes from `:= X` / `:= 𝟙 X` placeholder laundering.

### Pattern D — `CategoryTheory.projectiveDimension (ModuleCat.of R M)` for module projective dimension

Lane 7 demonstrates: project-side `Module.projectiveDimension R M`
is exactly `CategoryTheory.projectiveDimension (ModuleCat.of R M)`
(at `Mathlib/CategoryTheory/Abelian/Projective/Dimension.lean:265`).
Auto-resolves `[Abelian (ModuleCat R)]`. The 1-line wrapper is
genuinely a 1-line wrapper.

## Audit findings (lean-auditor iter178-touched) — LANDED ABOVE

Full report at `task_results/lean-auditor-iter178-touched.md` (38 files
audited; 3 must-fix-this-iter, 9 major, 6 minor, 3 excuse-comments
called out).

Severity summary landed:
- **must-fix-this-iter (3)**: 178A (RationalCurveIso excuse-comment +
  insufficient signature), 178B (CodimOneExtension shallow type +
  unused binder), 178C (AuslanderBuchsbaum stale docstring) — all
  landed at the TOP of this recommendations file.
- **major (9)**: stale "Status (iter-NNN)" markers across multiple
  files (AVR L136/276/319/342, AbelJacobi L14, RigidityKbar L20-29,
  Jacobian L193, GrpObj L433-435/483-488, AB L33-92, QS L25-29/374-385,
  LineBundlePullback OnProduct type-level sorry).
- **minor (6)**: short stale-status texts in 5 files plus 1
  iter-tagged-comment hygiene note.

Recommended iter-179 follow-up beyond the 3 must-fix:
- Status-block hygiene refactor lane (~30 LOC across 9 files; bundle
  the 9 major + 6 minor stale-status findings into one lane).
- TYPE-level `OnProduct := sorry` fragility (LineBundlePullback L119-121)
  — `IsInvertible` Mathlib gap; queue mathlib-analogist consult on
  whether a 30-LOC project-side `IsInvertible Scheme.Modules` shim is
  feasible vs waiting for Mathlib upstream.
