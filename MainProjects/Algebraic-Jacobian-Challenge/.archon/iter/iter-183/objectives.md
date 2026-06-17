# Iter-183 objectives — detailed prover lane briefings

Per-lane detailed directive for the iter-183 prover phase. The prover
for each file reads PROGRESS.md `## Current Objectives` for the
one-paragraph headline and this file for the detailed work plan.

---

## Lane E — `AlgebraicJacobian/AbelianVarietyRigidity.lean`

**Status entering**: 2 sorries (L110 helper `iotaGm_isOpenImmersion` +
L402 off-target `genusZero_curve_iso_P1`).

**Iter-182 outcome**: PARTIAL — strictly-stronger helper
`iotaGm_isOpenImmersion` landed; main body `iotaGm_range_isOpen` 2 LOC.
2 residual sub-tasks identified by the iter-182 task_result:

### Sub-task (b) — chart-1 factorisation of `onePt.left` (~30-50 LOC)
Build `r_1 : Spec k̄ ⟶ Spec(Away 𝒜 (X 1))` with
`onePt.left = r_1 ≫ Proj.awayι (X 1) _ _`. The `r_1` is
`Spec.map (CommRingCat.ofHom (eval Away 𝒜 (X 1) → k̄))` where the
eval map sends `u ↦ 0` (since `onePt = pointOfVec (fun _ => 1) _ _`
has `X 0 / X 1 = 1/1 = 1`, i.e. `r_1` is the chart-1 evaluation
point `u = 1`). Factorisation equation via
`Proj.fromOfGlobalSections_morphismRestrict` applied to the basic
open `D₊(X 1)`. Note: chart-1 analogue of the chart-bridge work
`awayι_comp_PLB_hom` (axiom-clean iter-173 — read as reference).

### Sub-task (f) — chart-1 open immersion (~30-60 LOC)
After building the section `s : Gm.left ⟶ (cover).X 1` and reducing
via `Cover.ι_glueMorphisms`, show that `s ≫ gmScalingP1_chart 1`
decomposes into three open immersions (the chart-iso, the ring-map
Spec.map at chart-1 which is a localization, and `Proj.awayι (X 1)`).
Use `IsOpenImmersion.of_isLocalization` for the middle step (lemma
verified present at `Mathlib/AlgebraicGeometry/Morphisms/OpenImmersion.lean:290`).

**Helper budget**: 2.

**Disclosure tier guidance**: target Tier-1 (axiom-clean) for sub-task
(b)/(f) bodies; the parent `iotaGm_isOpenImmersion` will inherit Tier-1
once both sub-tasks close.

**Coordination with Lane B**: Lane B's
`gmScalingP1_cover_intersection_X_iso` (axiom-clean iter-182) shares
the chart-1 infrastructure. Reuse its chart-1 unfold work where
possible.

**Off-target**: `genusZero_curve_iso_P1` L402 unchanged (gated on RR.4
chain — Pin 2 wrapper body iter-183 Lane I → Pin 2 body iter-184+ →
Pin 3 body iter-184+).

**Blueprint**: `chapters/AbelianVarietyRigidity.tex` (consolidated
chapter via `% archon:covers AVR + G0BO + RigidityLemma`).

---

## Lane G — `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`

**Status entering**: 3 sorries (L228 `depth_eq_smallest_ext_index`;
L326 `auslander_buchsbaum_formula`; L562 `exists_isRegular_of_regularLocal`).

**Iter-182 outcome**: SUCCESS Tier-2 — `depth_of_short_exact` closed
via LES-of-Ext 3-branch case split + 2 private helpers
(`ext_vanish_of_natCast_lt_depth` Tier-2 modulo upstream;
`natCast_add_one_le_of_le_sub_one` Tier-1 axiom-clean).

### Primary target this iter: `depth_eq_smallest_ext_index` (L228)

The substantive inductive chase per Stacks 00LE. The Stacks proof:
inducts on `depth M` using the SES `0 → M →[x] M → M/xM → 0` where
`x` is a regular element. Two cases:
- `depth M = 0`: there's a non-zero `Ext^0(κ, M) = Hom(κ, M)` element.
- `depth M = d+1`: there's a regular element `x`, so `depth (M/xM) = d`,
  and the LES of `Ext^*(κ, ·)` gives the recursive identity.

ETA ~100-150 LOC. Reuse iter-182's `ext_vanish_of_natCast_lt_depth`
helper (Tier-2 modulo `depth_eq_smallest_ext_index` itself — so this
target is itself the upstream! The Tier-2 inheritance flips when this
closes: the helper becomes Tier-1 axiom-clean modulo nothing).

### Alternative target: `auslander_buchsbaum_formula` (L326)

If `depth_eq_smallest_ext_index` proves too large for one iter, fall
back to `auslander_buchsbaum_formula` per Stacks 090V base case (SES
splitting argument). The Tier-2 helper `depth_of_short_exact` from
iter-182 is the building block.

**Pick `depth_eq_smallest_ext_index` first** — closing it retroactively
upgrades all iter-182 helpers from Tier-2 to Tier-1, plus unblocks
`auslander_buchsbaum_formula`'s SES splitting.

**Helper budget**: 2.

**Off-target**: `exists_isRegular_of_regularLocal` L562 — Mathlib gap
per `analogies/isregularlocalring-isdomain.md`; ~300 LOC project-side
build; iter-184+ work.

**Blueprint**: `chapters/Albanese_AuslanderBuchsbaum.tex`.

---

## Lane M (NEW) — `AlgebraicJacobian/Albanese/CoheightBridge.lean`

**Status entering**: file does NOT exist. Chapter
`Albanese_CoheightBridge.tex` LANDED this iter plan-phase
(blueprint-writer `coheightbridge-skeleton`; 477 lines).

### File-skeleton + body assembly (one lane, all in iter-183)

Per `analogies/stacks-00tt-coheight.md` Decision 2 recipe (L240-308):
write 4 declarations totaling ~60-100 LOC.

1. **`Order.coheight_eq_of_isOpenEmbedding`** (~20 LOC) — topology
   lemma: coheight commutes with open embedding. Forward direction
   via `Subtype.val ⁻¹'`; backward via `Specializes.mem_open`. SEARCH
   `lean_loogle "Order.coheight, IsOpen"` FIRST before scaffolding —
   may already be in Mathlib under a different name.

2. **`Order.coheight_spec_eq_height_primeSpectrum`** (~10 LOC) —
   algebra-geometry duality. Use `coheight_orderIso` with the
   order-iso `Spec R ≃o PrimeSpectrum R^op` + `height_toDual`.

3. **`AlgebraicGeometry.Scheme.ringKrullDim_stalk_eq_coheight`**
   (~30 LOC) — the bridge. 5-step assembly:
   - Pick affine open `U ∋ z` via `exists_isAffineOpen_mem_and_subset`.
   - Let `p = hU.primeIdealOf ⟨z, hzU⟩`.
   - `haveI := hU.isLocalization_stalk ⟨z, hzU⟩`.
   - `rw [IsLocalization.AtPrime.ringKrullDim_eq_height (S := X.presheaf.stalk z) p.asIdeal _]`
     then `rw [Ideal.height_eq_primeHeight]`.
   - Identify with coheight via lemmas 1+2.

4. **`AlgebraicGeometry.Scheme.ringKrullDimLE_of_coheight_eq_one`**
   instance (~10 LOC) — the consumer-facing wrapper. Rewrite via the
   bridge; close via the Krull-dim ≤ 1 unfold.

**Required imports**: `Mathlib.Order.KrullDimension`,
`Mathlib.AlgebraicGeometry.Stalk` (for `IsAffineOpen.isLocalization_stalk`,
`IsAffineOpen.primeIdealOf`), `Mathlib.RingTheory.Ideal.Height` (for
`IsLocalization.AtPrime.ringKrullDim_eq_height`, `Ideal.height_eq_primeHeight`),
`Mathlib.AlgebraicGeometry.AffineSpace` (for `spec_le_iff` / order-iso
basis).

**Acceptable iter-183 outcomes**:
- BEST: all 4 declarations axiom-clean kernel-only (Tier-1).
- MID: 3 of 4 axiom-clean; one with honest named sorry.
- WORST: file scaffold lands with 4 typed sorries; bodies iter-184.

**Helper budget**: 0 (the 4 declarations ARE the chapter; no auxiliary).

**Blueprint**: `chapters/Albanese_CoheightBridge.tex` (NEW; landed
iter-183 plan-phase). `\input{chapters/Albanese_CoheightBridge}` added
to `content.tex` manually by planner.

---

## Lane B — `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`

**Status entering**: 4 sorries (L362 `gmScalingP1_chart_agreement_cross01`
cocycle body — Lane B target; L498 `collapse_at_zero`; L580 `gm_geomIrred`;
L610 `projGm_isReduced`).

**Iter-182 outcome**: PARTIAL — new axiom-clean helper
`gmScalingP1_cover_intersection_X_iso` via Mathlib `Proj.pullbackAwayιIso`.
Cocycle body still gated on aggregated projection lemmas.

### Primary target: cross01 cocycle body (L362)

Iter-183 path forward per iter-182 task_result §"Iter-183 path forward":

1. **Add 2 named projection lemmas** on the iter-182 iso (~30-40 LOC each):
   - `gmScalingP1_cover_intersection_X_iso_inv_comp_fst :
        iso.inv ≫ pullback.fst ((cover).f 0) ((cover).f 1) = (specific Spec.map)`
   - same for `snd`.
   Each requires unfolding the chain stage by stage. Try `@[simps]`
   annotation on the helper FIRST — it may auto-generate the projection
   lemmas. If not, write them manually.

2. **Close cocycle body** (~10 LOC):
   - `apply cancel_epi iso.inv` (lifts goal to
     `Spec ((Away X_0X_1) ⊗ GmRing) ⟶ Proj 𝒜`).
   - `simp` collapses both sides to Spec.maps via the projection lemmas.
   - `Spec.map_injective` reduces to ring equality.
   - Closed by `Algebra.TensorProduct.tmul_mul_tmul` +
     `IsLocalization.Away.mul_invSelf`.

**Helper budget**: 2 (the 2 projection lemmas; `@[simps]` counts as 0
if it works).

**Critic mandate**: Route 1 CHURNING for 4 iters at sorry count 4. If
iter-183 doesn't drop the count, iter-184 escalates to Mathlib-idiom
consult on remaining projection lemmas (per progress-critic iter-183
finding).

**Off-target**: `collapse_at_zero` (iter-184+ via cover-glue chase);
`gm_geomIrred` + `projGm_isReduced` (Mathlib gaps).

**Blueprint**: `chapters/AbelianVarietyRigidity.tex` (consolidated).

---

## Lane F PIVOT — `AlgebraicJacobian/Picard/QuotScheme.lean`

**Status entering**: 8 sorries. Iter-181's "decompose more helpers"
strategy DECLARED WRONG by iter-182 analogist consult; PIVOT below.

### Primary target: typed-sorry def + helper collapse

Per `analogies/quotscheme-pullback-affine-section.md` (BUILD_PROJECT_HELPER
verdict):

1. **Add typed-sorry def** `Scheme.Modules.pullback_app_isoTensor` —
   the LOAD-BEARING gap (affine-open section formula for
   `Scheme.Modules.pullback`). This is a NEW typed-sorry def in
   `QuotScheme.lean`; body ~120-200 LOC iter-184+ (not this iter).

2. **Collapse iter-181 `_of_isAffineBase` helper body** through the
   new typed-sorry def + `Module.Flat.isBaseChange`. Net effect: the
   `_of_isAffineBase` body closes (modulo the new typed-sorry); sorry
   count UP by 1 (new typed-sorry) but the helper body becomes
   sorry-free assembly.

**Helper budget**: 1 (the new typed-sorry def is the entire helper
budget; do NOT add more decomposition helpers — that was the wrong
strategy iter-181).

**Disclosure tier**: the new typed-sorry def is Tier-3 (direct sorry
on a substantive type); the collapsed `_of_isAffineBase` body becomes
Tier-2 modulo the new typed-sorry.

**Off-target**: do NOT touch the other 7 sorries (file-skeleton stubs +
unrelated substantive bodies).

**Blueprint**: `chapters/Picard_QuotScheme.tex`.

---

## Lane D — `AlgebraicJacobian/Picard/RelativeSpec.lean`

**Status entering**: 1 sorry (`pullback_iso_construction` L484-530).

**Iter-182 outcome**: NOT DISPATCHED (planValidate deferral). iter-181
identified a 5-helper recipe; pickup intact.

### Primary target: `pullback_iso_construction` body (L484-530)

Per iter-181 task_result 5-helper recipe (Helpers 3-8):
- **Helper 3**: hoist functor abbrev (already a typed sorry per
  iter-181 task_result; check if still named or absorbed).
- **Helper 4**: forward map via `glueMorphismsOfLocallyDirected`.
- **Helper 5**: backward map via `colimit.desc`.
- **Helper 6**: `Iso.mk` assembly using Helpers 4+5.
- **Helpers 7-8**: 2 inverse-law closures (`hom_inv_id` + `inv_hom_id`).

**Alternative shortcut**: `IsColimit.coconePointUniqueUpToIso` may
collapse Helpers 4+5+6 into a single bundle. Try this first; fall
back to manual decomposition if it doesn't fit the colimit shapes.

**Template**: `Mathlib/AlgebraicGeometry/Normalization.lean:136-155`
(canonical iso-of-coconePoints construction).

**Helper budget**: 5.

**Critic mandate**: Route 4a CHURNING + SLIPPING; this lane is the
must-fire-this-iter primary corrective. 2nd consecutive planValidate
deferral triggers TO_USER.md escalation.

**Off-target**: do not touch other sorries (file is already at 1 sorry).

**Blueprint**: `chapters/Picard_RelativeSpec.tex`.

---

## Lane A — `AlgebraicJacobian/RiemannRoch/OCofP.lean`

**Status entering**: 7 sorries.

**Iter-182 outcome**: NOT DISPATCHED (planValidate deferral). iter-182
plan-phase blueprint-writer added the `toFunctionField` pin.

### Primary target: sig amend + substantive scaffold

Per `analogies/ocofp-sheaf-internalhom.md` (ALIGN_WITH_MATHLIB on
Hartshorne subsheaf-of-`K_C` direct construction):

1. **Sig amend** `lineBundleAtClosedPoint` to add
   `(hPcoh : Order.coheight P = 1)`. This is a sig mutation but is
   blueprint-driven (chapter prose specifies this hypothesis); not a
   protected sig (verified absent from `archon-protected.yaml`).

2. **Scaffold carrier + presheaf bodies + sheaf-property typed sorry**
   via the Hartshorne subsheaf-of-`K_C` direct construction
   (~230-360 LOC full body; iter-183 partial OK).

   - `lineBundleAtClosedPoint.carrier` (presheaf) — define as the
     subsheaf of `K_C` consisting of sections vanishing at `P` to
     order ≥ 0 (i.e. `O_C(P)` as a subsheaf of `K_C`).
   - `lineBundleAtClosedPoint.presheaf` — presheaf structure on the
     carrier.
   - `lineBundleAtClosedPoint.isSheaf` — typed sorry; close via
     gluing-by-stalks (iter-184 work).

**Helper budget**: 5.

**PARTIAL acceptable** (full body exceeds one-iter budget).

**Critic mandate**: Route 2b STUCK; iter-183 acceptable outcome is
sorry count ≤ 7 (no regression); ≤ 6 strong; ≤ 5 stretch. If sorry
count goes ≥ 8, iter-184 escalates to structural refactor.

**3-tier disclosure on each new decl**: per iter-181 vocabulary, every
new typed sorry / scaffolded body documents its tier (Tier-1 axiom-clean,
Tier-2 modulo upstream X, Tier-3 honest sorry with strategy comment).

**Blueprint**: `chapters/RiemannRoch_OCofP.tex` (iter-182 writer added
the `toFunctionField` pin block; sig amend may add `hPcoh` to the
`lineBundleAtClosedPoint` pin's `\lean{...}` line).

---

## Lane K (NEW) — `AlgebraicJacobian/RiemannRoch/OcOfD.lean`

**Status entering**: file does NOT exist. Chapter `RiemannRoch_OcOfD.tex`
LANDED iter-182 plan-phase.

### File-skeleton dispatch (mechanical)

Open the file with statements + `\lean{...}` pins for the chapter's
4 declarations:

- `WeilDivisor.sheafOf` — the sheaf `O_C(D)` for a Weil divisor `D`
  (type-level def; typed sorry).
- `sheafOf_zero` — the special case `D = 0` gives `O_C`.
- `sheafOf_singlePoint` — the special case `D = [P]` gives `O_C(P)`
  (recovers Lane A's `lineBundleAtClosedPoint`).
- `sheafOf_ses_single_add` — the short exact sequence
  `0 → O_C(D) → O_C(D + [P]) → κ(P) → 0` (the building block for
  Lane H's `RRFormula` induction).

All bodies as `sorry`. Add import + namespace boilerplate. Total
~50-100 LOC scaffold.

**HARD GATE**: clears via iter-183 mandatory blueprint-reviewer
dispatch (the new chapter has its first audit this iter).

**Helper budget**: 0.

**Off-target**: do NOT attempt to prove anything (file-skeleton iter only).

**Blueprint**: `chapters/RiemannRoch_OcOfD.tex` (NEW; landed iter-182).

**Coordination with Lane H**: paired dispatch; Lane H consumes the
`sheafOf` pin as soon as Lane K creates it (dispatcher handles in
import order).

---

## Lane H — `AlgebraicJacobian/RiemannRoch/RRFormula.lean`

**Status entering**: 3 sorries (`sheafOf` L168 type-level — UNBLOCKS
via Lane K; iter-181 helpers `eulerCharacteristic_sheafOf_zero` L236
+ `eulerCharacteristic_sheafOf_single_add` L261).

**Iter-182 outcome**: NOT DISPATCHED (deferral; gated on OcOfD opening).

### Primary target: close 2 iter-181 helper bodies using Lane K pin

Once Lane K creates `OcOfD.lean` with the `sheafOf` typed-sorry def,
this lane closes the 2 iter-181 induction helpers by referencing
`OcOfD.sheafOf` directly:

- `eulerCharacteristic_sheafOf_zero`: `D = 0` base case, uses
  `OcOfD.sheafOf_zero` from Lane K.
- `eulerCharacteristic_sheafOf_single_add`: induction step, uses
  `OcOfD.sheafOf_ses_single_add` from Lane K.

Both close Tier-2 modulo Lane K's typed sorries (when Lane K bodies
land iter-184+, these helpers automatically upgrade to Tier-1).

**Helper budget**: 2 (one per closure; can be inlined if simpler).

**Off-target**: the `sheafOf` typed-sorry in this file (L168) RETIRES
once `OcOfD.sheafOf` lands — replace with a one-line re-export.

**Blueprint**: `chapters/RiemannRoch_RRFormula.tex`.

**Coordination with Lane K**: paired dispatch — dispatcher runs Lane
K first (creates file), then Lane H (consumes pin).

---

## Lane I CRITICAL — `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

**Status entering**: 3 sorries (Pin 2 wrapper L320; `Scheme.Hom.poleDivisor`
typed-sorry L290 from iter-182 plan-phase; Pin 3 L438).

**Iter-182 outcome**: NOT DISPATCHED (planValidate deferral). **5TH
CONSECUTIVE SIG-ONLY ITER** — body MUST land or escalate per
progress-critic iter-183 must-fix.

### Primary target: Pin 2 wrapper body close (L320)

Post-iter-182 plan-phase refactor, the Pin 2 wrapper now binds
`D = φ^*[∞]` + `deg = Module.finrank K(ℙ¹) K(C)`. Close via:

1. **Witness**: `D := Scheme.Hom.poleDivisor φ` (the typed-sorry def
   from iter-182 plan-phase refactor).
2. **Equality** `D = poleDivisor φ` is `rfl` (definitional).
3. **Degree identity**: deferred via single named helper sorry
   `Scheme.Hom.poleDivisor_degree_eq_finrank` (substantive body
   iter-184+ via `Ideal.sum_ramification_inertia` per
   `analogies/ratcurveiso-pin2.md` Decision 2).

Net: Pin 2 wrapper body closes; 1 new named typed-sorry helper
`poleDivisor_degree_eq_finrank` (Tier-3, body iter-184+). Sorry count
3 → 3 (wrapper closes; helper added).

**Helper budget**: 3 (the named degree-identity helper + 2 reserve
for any minor projection / coercion).

**CRITICAL ESCALATION RULE**: this is the 5th consecutive sig-only
iter for Route 2d. If Lane I closes Pin 2 wrapper body iter-183, the
streak breaks. If iter-183 produces another sig-only or
NOT_DISPATCHED outcome, **user-escalation triggers** (review writes
TO_USER.md with the explicit escalation request; iter-184 plan-phase
treats Route 2d as requiring user input on direction).

**Off-target**: Pin 3 body L438 (iter-184+ via
`analogies/ratcurveiso-pin3.md` Decision 2);
`Scheme.Hom.poleDivisor` body L290 (iter-184+ via
`Ideal.sum_ramification_inertia` ~80-150 LOC).

**Blueprint**: `chapters/RiemannRoch_RationalCurveIso.tex` (iter-182
plan-phase writer updated Pin 2 + Pin 3 prose).
