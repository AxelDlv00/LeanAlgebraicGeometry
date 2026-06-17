# Iter-185 per-lane prover directives

Detailed per-lane work plans for the 9 active lanes in `PROGRESS.md
## Current Objectives`. The dispatcher fans out one prover per `.lean`
file; each block below is what that prover should be told to do.

Iter-185 cross-cutting context: **quota refill window** (the user's
Anthropic max-account weekly quota fired during iter-184; resets
2026-05-28T07:00:00Z; today is 2026-05-25 — 3 days into refill, so
expect partial quota — some lanes may NOT_DISPATCH at session turn 1
with $0 / 0 tokens; this is external attrition, not directive failure).

**Iter-184 NOT_DISPATCHED carry-forwards** (lanes A, D, F, H, I, K were
all rate-limit-truncated iter-184). The directives below are
substantively the iter-184 directives, refreshed with the iter-185
progress-critic verdicts and iter-185 blueprint-reviewer HARD GATE
clearance. Lane A is the exception: critic CHURNING corrective mandates
analogist-first; Lane A DEFERRED iter-185.

**Iter-184 deferred lanes that fire iter-185** (not NOT_DISPATCHED, but
explicitly held by directive):
- Lane E sub-task (f) — iter-184 HARD BAR dropped sub-task (f); iter-185
  picks it up since sub-task (b) closed.
- Lane G PIVOT — iter-184 task_result + lean-vs-blueprint-checker
  redirected Lane G away from `auslander_buchsbaum_formula` toward
  `exists_isRegular_of_regularLocal`.
- Lane B Recipes 2/3 — iter-184 quota truncation; recipes ready in
  `analogies/gmscaling-projection-idiom.md`.

---

## Lane E — `AbelianVarietyRigidity.lean` — sub-task (f) pickup

**Status entering**: 2 sorries (iter-184 SUCCESS on sub-task (b)).
**Critic verdict**: CONVERGING with watch condition (sorry count net +1
over K=4 window from structural decomposition; if iter-185 adds another
sub-task sorry without closing anything, re-classify to CHURNING).
**Helper budget**: 1.
**Sorry decrement target**: 2 → 1 (close sub-task (f)).

### Target: `iotaGm_chart1_composition_isOpenImmersion` body (L225)

Sub-task (f) of the parent `iotaGm_isOpenImmersion` (iter-183 parent
body sorry-FREE). Per iter-184 task_result "Next-iter suggestions
(Lane E continuations)":

> `iotaGm_chart1_composition_isOpenImmersion` body via the 3-step
> canonical-inclusion chase outlined in its docstring (`gmScalingP1_chart 1`
> = `(cover_X_iso 1).hom ≫ Spec.map chart-ring-map ≫ Proj.awayι X_1`;
> combine with `pullback.lift_fst/snd` on the section +
> `IsOpenImmersion.of_isLocalization` + iso + Mathlib `Proj.awayι`
> open-immersion instance). ~30-60 LOC.

**Constraint**: the parent body is already sorry-FREE assembly; this
sub-task closure removes one of the 2 named Tier-3 sub-task helpers.
The other (sub-task (b)) closed iter-184 axiom-clean. Closing (f) makes
the parent transitively axiom-clean.

**Acceptable outcome**:
- (i) SUCCESS — sub-task (f) Tier-1 axiom-clean (sorry count 2 → 1);
- (ii) PARTIAL — substantive progress via 1 named typed-sorry helper
  (sorry count 2 → 2, helper budget 1/1);
- (iii) NO_PROGRESS acceptable only if a concrete Mathlib gap surfaces
  AND is logged for iter-186+ analogist consult.

**Forbidden**: adding more sub-task decomposition. Helper budget = 1 is
the hard cap. If the prover wants to split the canonical-inclusion chase
into 3 sub-steps, do it inline (`have h1 := ...` instead of new helpers).

---

## Lane G — `Albanese/AuslanderBuchsbaum.lean` — PIVOT to exists_isRegular_of_regularLocal

**Status entering**: 2 sorries (iter-184 SUCCESS on
`depth_eq_smallest_ext_index`; remaining: `auslander_buchsbaum_formula`
L835 — DROPPED this iter per iter-184 task_result gap analysis;
`exists_isRegular_of_regularLocal` L944 — NEW PRIMARY TARGET this iter).
**Critic verdict**: CONVERGING (pivot well-supported by iter-184
task_result + lean-vs-blueprint-checker `iter184-auslander` finding).
**Helper budget**: 2.
**Sorry decrement target**: 2 → 1 (close `exists_isRegular_of_regularLocal`
OR a load-bearing sub-helper).

### PIVOT rationale (NOT avoidance — read carefully)

Iter-184 task_result `Albanese_AuslanderBuchsbaum.lean.md` §Recommendation
identified that `auslander_buchsbaum_formula` requires ≥4 missing Mathlib
pieces (minimal-finite-free-resolutions, Stacks 00MF "what is exact",
snake-lemma applied to a commutative diagram of resolutions,
depth-drops-by-one lemma) — realistic 4-8 iters of substrate work, NOT
"30-60 LOC" as iter-184 directive estimated. **AND**: A.4.a's downstream
consumer `CohenMacaulay.of_regular` (the actual codim-1 extension blocker)
does NOT need the AB formula directly — it uses regular-sequence-length
= Krull-dim. The lean-vs-blueprint-checker `iter184-auslander` confirmed
this from the chapter's Application section.

**Conclusion**: AB formula is OFF the critical path for A.4.a.
`exists_isRegular_of_regularLocal` IS on the critical path (it's the
direct ungate for `CohenMacaulay.of_regular`).

### Target: `exists_isRegular_of_regularLocal` (L944)

Two attack paths:

**Path (b) — Koszul-homology via system of parameters** (preferred; lighter):
Now that `depth_eq_smallest_ext_index` is closed iter-184 axiom-clean,
the `depth(R) ≥ d` lower bound might be obtainable via Koszul homology
of a system of parameters instead of an explicit regular sequence.
Concretely: given `IsRegularLocalRing R` with Krull dim `d`, take a
system of parameters `x₁, …, x_d`; show the Koszul complex `K(x₁, …, x_d)`
is acyclic in positive degree (via Mathlib's `KoszulComplex` /
`HasKoszulComplex` if shipped); extract that `(x₁, …, x_d)` is M-regular
on `M = R`.

**Path (a) — Stacks 00NQ `IsRegularLocalRing → IsDomain`** (fallback):
Stacks 00NQ argues "no embedded prime in (0) ⟹ (0) is prime" using
the associated-primes-of-a-regular-ring characterisation. ~300 LOC
project work (not currently in Mathlib at b80f227). Cite Stacks 00NQ
in the proof prose. The exists statement reduces to: pick a regular
system of parameters via the regular-local-ring structure (Mathlib ships
`IsRegularLocalRing.exists_isRegular`-style API if available; check
`lean_loogle` `IsRegularLocalRing → IsRegular`).

**Order of attack**:
1. First spend ~15 min searching Mathlib (`lean_leansearch`,
   `lean_loogle`, `lean_hammer_premise`) for either:
   - `IsRegularLocalRing → IsRegular (parameters)` direct shipment
     (fastest win — would close the lemma in ~5 LOC),
   - Koszul-complex-acyclicity infrastructure to use path (b).
2. If Mathlib ships either: directly close the lemma using it.
3. Otherwise: scaffold path (b) Koszul-homology proof using
   `depth_eq_smallest_ext_index` as bridge, even partial typed-sorry
   helpers count toward acceptable.

**Acceptable outcome**:
- (i) SUCCESS — `exists_isRegular_of_regularLocal` Tier-1 axiom-clean
  via Mathlib direct shipment OR Koszul proof (sorry count 2 → 1);
- (ii) PARTIAL — 1-2 named typed-sorry helpers landed with a clean
  scaffold; sorry count 2 → ≤3 (helper budget 2/2);
- (iii) NO_PROGRESS acceptable only if both paths blocked AND a concrete
  Mathlib gap is identified for iter-186+ analogist consult.

**Forbidden**: attempting `auslander_buchsbaum_formula` body this iter
(off critical path per iter-184 gap analysis). Helpers added for AB
formula substrate (minimal-free-resolutions, etc.) are wasted work this
iter.

---

## Lane B — `Genus0BaseObjects/GmScaling.lean` — Recipes 2 + 3, NO new helpers

**Status entering**: 4 sorries (iter-184 PARTIAL — Recipe 1 axiom-clean,
Recipes 2/3 truncated mid-flight at turn 22 / $2.02).
**Critic verdict**: CHURNING post-corrective (analogist verdict from
iter-184 plan-phase landed Recipe 1 axiom-clean; sorry decrement gate
4 → ≤3 must hit iter-185).
**Helper budget**: **0** (NO new helpers — recipes 1+2 helpers already
in place from iter-184).
**Sorry decrement target**: 4 → ≤3 (mandatory).

### Recipe-driven directive

Persistent recipe at `analogies/gmscaling-projection-idiom.md`. Iter-184
landed Recipe 1 (2 globally-active `@[reassoc (attr := simp)]` helpers
`pullback_map_fst_proj` / `pullback_map_snd_proj`). Iter-185 executes:

### Recipe 2 — 2 named projection lemmas

Prove `gmScalingP1_cover_intersection_X_iso_inv_fst` and
`gmScalingP1_cover_intersection_X_iso_inv_snd` via simp chain using:
- Recipe-1 helpers (`pullback_map_fst_proj` / `_snd_proj` are simp);
- existing Mathlib simp set: `pullbackRightPullbackFstIso_inv_*`,
  `pullbackLeftPullbackSndIso_inv_*`, `pullbackSymmetry_inv_comp_*`,
  `Proj.pullbackAwayιIso_inv_*`.

Bodies should be one-tactic (`simp` with the explicit Mathlib lemma
list) or near-it.

### Recipe 3 — `gmScalingP1_chart_agreement_cross01` body (L382)

Close via:
- `Proj.SpecMap_awayMap_awayι.symm` (Mathlib);
- `cancel_mono (awayι (X 0 · X 1))` to drop the post-composition iso;
- `MvPolynomial.algHom_ext` to reduce to comparing ring-map values on
  the generators `X 0` and `X 1`;
- `IsLocalization.Away.mul_invSelf` for the `t · u = 1` residual that
  comes from the cocycle condition on `Spec (R[t,t⁻¹,u,u⁻¹])`.

This is the cocycle-body closure that drops one sorry from 4 → 3.

### Acceptable outcome

- (i) **SUCCESS** — sorry count 4 → 3 (Recipe 3 closes cross01 body;
  Recipes 2 named lemmas axiom-clean);
- (ii) **SUCCESS — Stretch** — sorry count 4 → ≤2 (also `collapse_at_zero`
  body via Mathlib idioms from `analogies/gmscaling-cover-bridge.md`);
- (iii) **FAILURE** — sorry count stays 4 → iter-186 re-triggers
  analogist for Recipes 2/3 AND opens genus-0 separated-locus alternative
  for chart-bridge cross-case (per STRATEGY.md Open Qs).

### Critical constraint

**Helper budget = 0**. Do not add any new `private lemma` or `local
def` declarations. The recipes are "execute existing simp lemma chains
+ close one cocycle body"; the route is recipe-driven now, not
helper-accumulation-driven. The progress-critic's CHURNING verdict
specifically calls out helper accumulation as the failure mode to avoid.

---

## Lane (NEW) — `Picard/IdentityComponent.lean` — file-skeleton

**Status entering**: file does not exist on disk.
**Critic verdict**: UNCLEAR (fresh route; blueprint-reviewer HARD GATE
CLEARED).
**Helper budget**: 0 (mechanical scaffold).
**Sorry trajectory**: NEW FILE → 5 typed sorries (deliberate).

### Mandate

Scaffold `AlgebraicJacobian/Picard/IdentityComponent.lean` from the
iter-184 blueprint chapter `blueprint/src/chapters/Picard_IdentityComponent.tex`
(561 lines, 5 declarations + 4 proof blocks). This is a file-skeleton
dispatch: scaffold the bare declarations with `sorry` bodies, add import
+ namespace boilerplate, **do NOT attempt to prove anything yet**.

### Declarations to scaffold (in dependency order from the chapter)

1. **`AlgebraicGeometry.GroupScheme.IdentityComponent`** — `def`,
   blueprint `def:identity_component_group_scheme`. The identity
   component of a group scheme over a base; per chapter, defined as
   the connected component of the identity section. Signature: take
   `[GroupScheme G]` (or whatever predicate the chapter pins) and
   return a subscheme. Body: `sorry`.

2. **`AlgebraicGeometry.GroupScheme.identityComponent_open_subgroup`**
   — `theorem`, blueprint `thm:identity_component_open_subgroup`. The
   identity component is an open subgroup. Body: `sorry`.

3. **`AlgebraicGeometry.Scheme.Pic0Scheme`** — `def`, blueprint
   `def:pic_zero_subscheme`. The degree-zero part of `Pic_{C/k}`,
   defined as the identity component (via the previous def applied to
   `PicScheme C`). Body: `sorry`.

4. **`AlgebraicGeometry.Scheme.PicScheme.degree`** — `def`, blueprint
   `def:divisor_degree_pic`. The degree map `Pic_{C/k} → ℤ`. Body:
   `sorry`.

5. **`AlgebraicGeometry.Scheme.Pic0Scheme.isAbelianVariety`** —
   `theorem`, blueprint `thm:pic_zero_is_abelian_variety`. `Pic⁰_{C/k}`
   is an abelian variety (forward-pointing to Kleiman §5 `th:qpp&p` +
   `cor:sm`; per chapter, this theorem is the route-A culmination).
   Body: `sorry`.

### Import + namespace boilerplate

The file should import:
- `Mathlib.AlgebraicGeometry.GroupObject` (or whatever Mathlib namespace
  carries `GroupScheme` at b80f227; if unsure, use the same imports as
  `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` and add
  whatever the chapter prose names).
- `AlgebraicJacobian.Picard.FGAPicRepresentability` (consumer of
  `PicScheme C`).
- `AlgebraicJacobian.Genus` (for `genus C`).

`namespace AlgebraicGeometry.Scheme` / `namespace AlgebraicGeometry.GroupScheme`
as appropriate.

### Wiring

If `AlgebraicJacobian/Picard.lean` is a re-export shim, add a line
re-exporting `Picard.IdentityComponent`. If not, no wiring step.

### Acceptable outcome

- **SUCCESS** — file lands with 5 declarations as `sorry`-bodied;
  `lake build` GREEN; 5 new typed sorries appear; chapter
  `\lean{...}` pins resolve correctly.

**Forbidden**: attempting to fill any body. This is mechanical
scaffolding only. Bodies are iter-186+ work.

---

## Lane F — `Picard/QuotScheme.lean` — Tilde-isoTop body (first body-substance test)

**Status entering**: 9 sorries (iter-184 NOT_DISPATCHED; iter-183 PIVOT
landed the typed-sorry def `Scheme.Modules.pullback_app_isoTensor`).
**Critic verdict**: UNCLEAR (iter-185 is the FIRST body-substance test
of the Tilde-isoTop route; if no body substance, flips to CHURNING).
**Helper budget**: 2.
**Sorry decrement target**: 9 → ≤9 (PARTIAL acceptable; the gate is
"≥1 substantive step on the body", not strict decrement).

### Target: `Scheme.Modules.pullback_app_isoTensor` body (L480)

Per iter-183 task_result + iter-184 directive (Tilde-isoTop route via
Stacks 01HQ / 01I8). The body work:

1. **Reduce to affine case** — `pullback_app_isoTensor` for a pullback
   `g : Y ⟶ X` of schemes and a quasi-coherent sheaf `N` on `X`,
   restricted to an affine open `U = Spec A` of `X` mapping to an
   affine open `V = Spec B` of `Y` (`g(V) ⊆ U`).

2. **Identify `tilde N` via `AlgebraicGeometry.Modules.Tilde.isoTop`**
   — Mathlib's `Tilde.isoTop` (Stacks 01HQ) gives `Γ(V, tilde N) ≅
   N ⊗_A B` for `N : Module A` and `V = Spec B`.

3. **Base-change identification** — `(pullback g).obj (tilde N) ≅
   tilde (Γ(Y, V) ⊗_{Γ(X, U)} N)` as a quasi-coherent sheaf on `Y`,
   restricted to `V`.

4. **Close LinearEquiv** — via `IsBaseChange.equiv` + `Module.Flat.isBaseChange`
   (Mathlib idioms for base-change linear equivalences). The
   `pullback_app_isoTensor` packaging asserts this LinearEquiv on
   global sections.

### Acceptable outcome

- (i) **SUCCESS** — entire body closes Tier-2 or better (sorry count
  9 → 8);
- (ii) **PARTIAL — substantive step closes** — `Tilde.isoTop`
  identification lands as a separate axiom-clean step; remaining work
  as 1-2 named typed-sorry helpers; sorry count 9 → ≤10 (helper budget
  2/2);
- (iii) **CHURNING flip** — no body substance at all → iter-186
  escalates with mathlib-analogist on Tilde-isoTop route OR pivots
  substrate.

### Consumer ripple

If `pullback_app_isoTensor` body has substance, the consumer's BC
inline sorry (iter-183 task_result identified) closes via the
rfl-bridge.

---

## Lane D — `Picard/RelativeSpec.lean` — HARD BAR test (close BOTH Tier-3 helpers)

**Status entering**: 2 sorries (iter-184 NOT_DISPATCHED; iter-183 5-helper
structured proof landed).
**Critic verdict**: **STUCK + OVER_BUDGET** (15 elapsed vs ~3-6 estimated;
iter-183 added 5 helpers with net +1 sorry; recurring blocker
"IsAffineOpen.map_fromSpec transparency" 2-of-2 dispatched iters).
**Helper budget**: 2.
**Sorry decrement target**: 2 → 0 (HARD BAR: close BOTH Tier-3 helpers).

### HARD BAR

Per iter-184 directive (rate-limit-truncated): close BOTH:

**(i) L494 `pullback_cocone` naturality** via
`IsAffineOpen.map_fromSpec` after transparency unfolds.

**(ii) L583 `pullback_iso_desc_isIso` per-piece factorisation** via
the explicit 3-iso chain:
`hPre identity → isoOpensRange → pullback_iso_affine_piece.symm`
(outlined in iter-183 task_result).

### Failure mode (per progress-critic)

If both Tier-3 helpers DO NOT close iter-185, **iter-186 plan-phase MUST
dispatch `blueprint-writer relativespec-3iso-chain-expansion`** to spell
out the 3-iso chain factorisation at Lean-proof granularity in
`Picard_RelativeSpec.tex`. The chapter currently describes the
factorisation at textbook level but not at the per-step granularity a
prover can directly transcribe.

### Acceptable outcome

- (i) **SUCCESS** — sorry count 2 → 0 (both Tier-3 helpers close);
- (ii) **PARTIAL** — sorry count 2 → 1 (one helper closes; the other
  PARTIAL or NEW typed-sorry); iter-186 escalates with blueprint-writer
  dispatch for the remaining one;
- (iii) **FAILURE** — sorry count 2 → 2 (no closures) → iter-186 plan-phase
  MUST dispatch blueprint-writer; A.1.a phase enters formal escalation.

---

## Lane K — `RiemannRoch/OcOfD.lean` — `sheafOf_zero` body (first body-substance test)

**Status entering**: 4 sorries (iter-184 NOT_DISPATCHED; iter-183 NEW
FILE skeleton).
**Critic verdict**: UNCLEAR (genuinely fresh route).
**Helper budget**: 2.
**Sorry decrement target**: 4 → ≤3 (close `sheafOf_zero`).

### Target: `sheafOf_zero` body (L150)

Per iter-184 directive: unfold `sheafOf` at `0 : C.left.WeilDivisor`;
the order conditions trivially satisfy on the zero divisor; the carrier
reduces to the structure sheaf; identify with `Scheme.toModuleKSheaf C`
via a sheaf hom from equal `Set`-carriers; close via `Sheaf.ext`.

Concretely: the rational functions with order ≥ 0 everywhere
(no pole/zero conditions imposed) = the regular functions = the structure
sheaf sections. The identification with `Scheme.toModuleKSheaf C` is
exactly this — `toModuleKSheaf` packages the structure sheaf as a
`ModuleCat k̄`-valued sheaf.

### Off-target

- `sheafOf` def body — iter-186+ substantive Hartshorne II.5/II.7
  content;
- `sheafOf_singlePoint` — gated on `lineBundleAtClosedPoint` having
  substance (Lane A is DEFERRED iter-185; so this lemma's substrate is
  also gated);
- `sheafOf_ses_single_add` — iter-186+ substantive.

### Acceptable outcome

- (i) **SUCCESS** — `sheafOf_zero` Tier-1 axiom-clean (sorry count
  4 → 3);
- (ii) **PARTIAL** — substantive scaffold via 1-2 named typed-sorry
  helpers (helper budget 2/2; sorry count 4 → ≤5);
- (iii) **NO_PROGRESS** acceptable only if a specific Mathlib gap
  surfaces AND is logged for iter-186+ analogist consult.

---

## Lane H — `RiemannRoch/RRFormula.lean` — 2 Tier-3 helpers (throughput SLIPPING)

**Status entering**: 2 sorries (iter-184 NOT_DISPATCHED).
**Critic verdict**: CONVERGING-with-watch (throughput SLIPPING: 10 of
12 iters elapsed; if 2 Tier-3 helpers don't close iter-185, crosses to
OVER_BUDGET).
**Helper budget**: 2.
**Sorry decrement target**: 2 → 0 (close both Tier-3 helpers).

### Target (i): `Scheme.finrank_H0_toModuleKSheaf_eq_one` (L231)

Via the `Cohomology_StructureSheafModuleK` H⁰-bridge: the constant-sheaf-
Γ adjunction gives `H⁰(C, O_C) = k` for geometrically irreducible
curves; therefore `finrank k H⁰ = 1`. Use the Mathlib `finrank_eq_one_iff`
or similar to close.

### Target (ii): `Scheme.eulerCharacteristic_sheafOf_succ` (L258)

Via `OcOfD.sheafOf_ses_single_add` (Lane K typed sorry; will remain
typed-sorry iter-185 since `sheafOf_zero` is the only body-target this
iter) → χ-additivity over the SES.

**Mathlib substrate check**: search for
`CategoryTheory.ShortExact.eulerChar_additive` in Mathlib at b80f227.
- If PRESENT: directly close via additivity + `sheafOf_ses_single_add`.
- If ABSENT: scaffold as a 1-helper project lemma
  `Scheme.eulerCharacteristic_of_shortExact` (~30-50 LOC; standard
  finite-rank χ-additivity argument).

### Watch condition (per critic)

If the H⁰-bridge blocker persists into iter-185 without closing the 2
Tier-3 helpers, iter-186 upgrades Lane H to CHURNING. The helpers were
added explicitly to enable closure; failure to close next iter would
confirm churn.

### Acceptable outcome

- (i) **SUCCESS** — sorry count 2 → 0 (both Tier-3 helpers close);
- (ii) **PARTIAL** — sorry count 2 → 1 or 2 → 2 with a single Tier-3
  closing and one typed-sorry helper added (helper budget 2/2);
- (iii) **FAILURE** — sorry count stays 2 → iter-186 reassessment per
  watch condition.

---

## Lane I — `RiemannRoch/RationalCurveIso.lean` — Pin 2 helper body

**Status entering**: 3 sorries (iter-184 NOT_DISPATCHED; iter-183
breakthrough Pin 2 wrapper body sorry-free; helper
`Hom.poleDivisor_degree_eq_finrank` L321 typed-sorry).
**Critic verdict**: CONVERGING (iter-183 breakthrough intact; iter-184
rate-limit not failure).
**Helper budget**: 3.
**Sorry decrement target**: 3 → 2 (close `poleDivisor_degree_eq_finrank`).
**ESCALATION RULE**: **DO NOT escalate Route 2d** — the iter-183
breakthrough is intact; iter-184 was rate-limit, not directive-miss.

### Target: `Hom.poleDivisor_degree_eq_finrank` body (L321)

Via `Ideal.sum_ramification_inertia` per `analogies/ratcurveiso-pin2.md`
Decision 2 (~80-150 LOC).

**Construction**:
1. Pick an affine open `Spec A ⊂ ℙ¹` containing `∞`.
2. Preimage `Spec B ⊂ C` is finite over `Spec A` (the curve map `φ : C → ℙ¹`
   restricts to a finite ring extension `A ⊂ B` on the affine pieces
   because `C → ℙ¹` is finite as a morphism of smooth proper curves).
3. Both `A` and `B` are Dedekind domains (smooth curve over field).
4. Apply `Ideal.sum_ramification_inertia`:
   `Σ_Q e(Q|P)·f(Q|P) = [Frac B : Frac A] = [K(C) : K(ℙ¹)]`.
5. The LHS is the pole-divisor degree (each `Q` mapping to `∞` contributes
   `e(Q|∞)·f(Q|∞)`); the RHS is the function-field degree.

### Off-target

- Pin 3 body L482 — iter-186+ separately;
- `Hom.poleDivisor` body — iter-186+ separately.

### Acceptable outcome

- (i) **SUCCESS** — Tier-1 axiom-clean (sorry count 3 → 2);
- (ii) **PARTIAL — substantive scaffold** — 2-3 named typed-sorry
  helpers (e.g. `finite_extension_of_finite_morphism`, `dedekind_of_smooth_curve`,
  `ramification_sum_eq_field_extension_degree`); sorry count 3 → ≤5
  (helper budget 3/3);
- (iii) **NO_PROGRESS** acceptable only if `Ideal.sum_ramification_inertia`
  is absent from Mathlib at b80f227 AND a substitute lemma is identified
  for iter-186+.

---

## Lane A — DEFERRED iter-185

**Status entering**: 7 sorries.
**Critic verdict**: **CHURNING + OVER_BUDGET** (18 elapsed vs ~8-12;
recurring blocker "carrierSet → Submodule upgrade gated" 2-of-2
dispatched iters; sorry count 7→7→7→7 over K=4).
**Iter-185 action**: **DEFERRED from prover dispatch this iter.**
**Plan-phase substitute**: `mathlib-analogist ocofp-carrierset-submodule-api`
DISPATCHED (running).

Per progress-critic must-fix: "Do not add more helpers until the API
question is resolved." Lane A's iter-186+ dispatch shape (BUILD_PROJECT_HELPER
recipe / ALIGN_WITH_MATHLIB refactor / NEEDS_MATHLIB_GAP_FILL pivot)
depends on the analogist verdict. The analogist consults on:

- Q1 — Mathlib idiom for "subsheaf of `K(C)` cut out by an order condition"
  (subpresheaf/subsheaf machinery; `Module.LocallyConstant`; `LinearMap.range`
  presheaf functor);
- Q2 — `Submodule` upgrade granularity (zero/add/scalar closures via
  `Valuation.toFun` / `IsDedekindDomain.HeightOneSpectrum.valuation`);
- Q3 — sheaf property route (gluing-by-stalks vs constant-sheaf-restriction
  via `Subpresheaf.IsSheaf`);
- Q4 — parallel-API risk between project `Scheme.RationalMap.order` and
  Mathlib `IsDedekindDomain.HeightOneSpectrum.valuation`.

Persistent recipe lands at `analogies/ocofp-carrierset-submodule-api.md`.
STRATEGY.md row `Genus-0 RR.3 — O_C(P)` already revised this plan-phase
`~8-12` → `~20-30`.

---

## Lane M↓ — DEFERRED iter-185 (chapter-expansion gating)

**Status entering**: 3 sorries (iter-184 SUCCESS on Krull-dim half;
`IsRegularLocalRing` half remains as Stacks 00TT gap).
**Critic verdict**: **STUCK + deferred** (sorry count 3→3→3→3 over K=4;
recurring "Stacks 00TT gap" blocker ≥3 iters; deferral correct ONLY IF
blueprint expansion is actively dispatched this iter).
**Iter-185 action**: **DEFERRED from prover dispatch this iter.**
**Plan-phase substitute**: `blueprint-writer codimone-stacks-00tt`
DISPATCHED (running).

Per progress-critic must-fix: "Blueprint expansion must be actively
dispatched in iter-185 (not deferred again). Task: expand
`Albanese_CodimOneExtension.tex` to address Stacks 00TT for the
`IsRegularLocalRing` half."

The writer addresses:
- **MF-1** Stacks 00TT bridge: `% SOURCE:` + verbatim quote + derivation
  sketch + `[IsAlgClosed kbar]` hypothesis note;
- **MF-2** missing `lem:mem_domain_partial_map_reshuffle` block.

On writer completion + iter-186 blueprint-reviewer re-audit, Lane M↓
re-opens for the `IsRegularLocalRing` half (multi-iter Stacks 00TT
substrate work). No same-iter fast path attempted: the
`IsRegularLocalRing` half is genuinely multi-iter (Stacks 00TT
formalisation is iter-200+ per STRATEGY.md Mathlib gap list); no value
to a same-iter prover dispatch.
