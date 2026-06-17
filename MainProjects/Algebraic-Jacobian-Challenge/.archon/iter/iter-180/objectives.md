# Iter-180 prover lane directives

Per the iter-180 plan, 8 prover lanes A–H. Each carries the iter-180
**no-laundering boilerplate** at the end:

> HARD RULE — no laundering. Do NOT close a sorry by introducing a NEW
> project axiom (kernel-only end-state contract — iter-181
> RETIRE-OR-ESCALATE arms iter-180 with no further extension). Do NOT
> close a sorry by making the body a placeholder that discards the
> meaningful argument (`def F := <something not containing the
> argument>`). If the body mathematically requires content you cannot
> produce honestly, leave PARTIAL with a substantive named helper
> sorry, NOT a laundered closure.

## Lane A — `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` — retire 2 TEMP axioms via `respectTransparency` recipe

**iter-181 RETIRE-OR-ESCALATE EXECUTION lane.** The iter-180 plan-phase
mathlib-analogist consult `pullbackspeciso-bypass` returned
ALIGN_WITH_MATHLIB on Decision 4
(`set_option backward.isDefEq.respectTransparency false`),
EMPIRICALLY VERIFIED via `lean_multi_attempt` to fire
`pullbackSpecIso_hom_base` on the actual stuck goal.

**REQUIRED**: read `analogies/pullbackspeciso-bypass.md` (the
persistent recipe file) BEFORE attempting alternatives. The recipe is
EMPIRICALLY VERIFIED and is the canonical Mathlib idiom for
`Algebra.compHom`-chain-driven defeq sinks; deviation is a violation
of the iter-175 KB `chart-bridge-prover-bypass` rule.

### Targets (3 body lemma retirements + 2 axiom deletions)

1. **`gmScalingP1_chart_PLB_eq`** (at line ~213 post-iter-179):
   replace the partial body's `sorry` with the recipe in
   `analogies/pullbackspeciso-bypass.md` "### Concrete recipe (iter-180
   PRIMARY corrective)":

   ```lean
   set_option backward.isDefEq.respectTransparency false in
   private lemma gmScalingP1_chart_PLB_eq (kbar : Type u) [Field kbar] (i : Fin 2) :
       gmScalingP1_chart kbar i ≫ (ProjectiveLineBar kbar).hom =
         (gmScalingP1_cover kbar).f i ≫ ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom := by
     unfold gmScalingP1_chart gmScalingP1_cover_X_iso gmScalingP1_cover
     have h := awayι_comp_PLB_hom kbar (m := 1) Nat.one_pos
       (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)
       (MvPolynomial.isHomogeneous_X kbar i)
     -- `change` to expose the middle object (per iter-179 Attempt 2 trick)
     change (gmScalingP1_cover_X_iso kbar i).hom ≫ _ ≫
         ((Proj.awayι _ _ _ _ : Spec _ ⟶ Proj _) ≫ (ProjectiveLineBar kbar).hom) = _
     rw [h, ← Spec.map_comp, ← CommRingCat.ofHom_comp, RingHom.comp_assoc,
       homogeneousLocalizationAwayIso_algebraMap, MvPolynomial.algebraMap_eq,
       MvPolynomial.eval₂Hom_comp_C]
     simp only [Iso.trans_hom, Category.assoc, pullbackSpecIso_hom_base,
       pullback.congrHom_hom, pullback.lift_fst_assoc, Category.id_comp]
     -- residual cleanup per recipe Stages 2-4
     ...
   ```

   The recipe's "Residual cleanup (after Decision 4 fires)" section
   spells out Stages 2-4 (apply `pullbackRightPullbackFstIso_hom_fst_assoc`,
   `pullbackSymmetry_hom_comp_snd_assoc`, and the final defeq close).
   Verify each step with `lean_goal`. **Helper budget = 1**: if Stage 2
   trips on a `(cover).openCover.f i` vs `Proj.awayι (![X 0, X 1] i) ...`
   alignment, factor out a small wrapper lemma
   `coverF_eq_proj_awayι` (≤8 LOC). The recipe's reversal trigger
   (`change` fall-back) is ALLOWED as a backup if the option fails.

2. **`gmScalingP1_chart_agreement`** (line ~270 post-iter-179): currently
   axiom-laundered via `(gmScalingP1_chart_data_temp kbar).2`. Replace
   with the honest proof per `analogies/gmscaling-cover-bridge.md` Step
   3 (2): diagonal cases via `CategoryTheory.Limits.fst_eq_snd_of_mono_eq`
   (since `(cover).f i` is `IsOpenImmersion`, hence mono); cross cases
   `(0, 1) / (1, 0)` via the algebraic identity `λ · u = (1/t) · λ` in
   `Localization.Away t ⊗[kbar] GmRing` per `analogies/gmscaling-deep.md`
   Q4. The `respectTransparency` option may also be helpful here.

3. **`gmScalingP1_collapse_at_zero`** (line ~363 post-iter-179):
   currently axiom-laundered via `gmScalingP1_collapse_at_zero_temp`.
   Replace per `analogies/gmscaling-cover-bridge.md` Step 3 (3): unfold
   `gmScalingP1`, apply `Scheme.Cover.hom_ext` on the cover, reduce on
   chart-1 to a ring-level identity in `MvPolynomial Unit kbar ⊗[kbar]
   GmRing` (chart-1 ring map sends `u ↦ u ⊗ λ`; `zeroPt` factors
   through chart-1 at `u = 0`; composite evaluates to `zeroPt`
   independently of `λ`).

**After all 3 body retirements land**, DELETE the two `axiom`
declarations (`gmScalingP1_chart_data_temp` at L177-200 and
`gmScalingP1_collapse_at_zero_temp` at L327-339) from the file.

### Acceptance criteria

- File compiles GREEN.
- No new project axioms (current 2 axioms RETIRED).
- `#print axioms gmScalingP1_chart_PLB_eq` returns
  `{propext, Classical.choice, Quot.sound}` only.
- Helper budget ≤ 1 (only `coverF_eq_proj_awayι` permitted if needed).

### Reversal trigger (iter-181 formal escalation)

If after honest attempts (≥3 attempt cycles per `lean_multi_attempt`),
the recipe cannot close axiom-clean — for example, if the
`respectTransparency` option also doesn't fire `pullbackSpecIso_hom_base`
(empirically the analogist consult verified it DOES fire, so this would
be surprising; but Lean / Mathlib version drift could change behavior),
LEAVE the file PARTIAL with the partial body in place, document the
new failure mode in the task_result, and the iter-181 review fires the
formal TO_USER.md escalation per Decision 1's reversal trigger.

NEVER reintroduce TEMP axioms even if the recipe fails — the
no-laundering rule and the iter-181 RETIRE-OR-ESCALATE schedule both
forbid axiom-laundering retreat.

---

## Lane B — `AlgebraicJacobian/Genus0BaseObjects/Points.lean` — `gm_grpObj` body via `ofRepresentableBy`

**Break 11-iter persistent deferral.** The iter-179 plan-phase analogist
consult `gm-grpobj-representable` returned PROCEED on the
`GrpObj.ofRepresentableBy` route; persistent recipe at
`analogies/gm-grpobj-representable.md` (8 steps, ~75-115 LOC).

### Target

- `Genus0BaseObjects/Points.lean:251` — `instance gm_grpObj` body.

### Approach (per recipe Section "Recommendation")

Use `GrpObj.ofRepresentableBy` with the units functor
`T ↦ GrpCat.of Γ(T.unop.left, ⊤)ˣ`. The `homEquiv` field is the
3-step bijection chain:

1. `(T ⟶ Gm) in Over (Spec k̄)` ≃ `{f : T.unop.left ⟶ Spec(k̄[t,t⁻¹]) // IsOver Spec k̄}`
   (over-cat unfold via `Over.homMk` or `homOverEquiv`-style).
2. ≃ `{φ : k̄[t,t⁻¹] →ₐ[k̄] Γ(T.unop.left, ⊤)}` (via `ΓSpec.adjunction.homEquiv`).
3. ≃ `{u : Γ(T.unop.left, ⊤) // IsUnit u} = Γ(T.unop.left, ⊤)ˣ` (via
   `IsLocalization.Away.lift` + `IsLocalization.Away.algebraMap_isUnit`).

Split each step into a named helper lemma (`gm_homEquiv_step_1`,
`_step_2`, `_step_3`), each ~15-20 LOC, then compose via
`Equiv.trans ∘ Equiv.trans`. The `homEquiv_comp` (naturality) reduces
to `Scheme.Hom.appTop` naturality + `Units.map` functoriality.

**Helper budget = 3** (one per Equiv step + composition).

### Reversal trigger (per recipe Section "Reversal trigger")

If the 3-step bijection composition encounters universe issues,
def-eq issues with `IsOver`, or `IsScalarTower` synthesis failures on
the `k̄[t, t⁻¹]`-side, **fall back to direct `GrpObj.mk`** (Section
"Reversal trigger" of the analogy file): hand-define `μ`, `η`, `ι`
as `Spec.map` of explicit ring maps (the comultiplication, counit,
antipode of the Hopf algebra `k̄[t, t⁻¹]`), prove the 5 group-object
axioms by `Spec.map_comp + CommRingCat.hom_ext + ring computation`.
~150-200 LOC fallback.

The recipe explicitly authorizes this fallback ONLY after the Yoneda
path stalls for ≥2 iters — iter-180 is the first iter on the Yoneda
path, so fallback is NOT authorized yet. Prover should attempt Yoneda
first.

### Acceptance criteria

- File compiles GREEN.
- `gm_grpObj` body axiom-clean OR helper-with-sorry on substantive
  Mathlib-gap content (NO axioms, NO placeholder bodies).
- Helper budget ≤ 3.

---

## Lane C — `AlgebraicJacobian/Picard/RelativeSpec.lean` — close `coequifibered` field

**iter-179 Lane B helper closure.** Lane B closed `UniversalProperty`
+ `affine_base_iff` + `base_change` (the latter via 2 named helpers
`QcohAlgebra.pullback` and `pullback_iso`). Lane C this iter targets
the substantive Mathlib-gap content in `QcohAlgebra.pullback.coequifibered`
field (file L236).

### Target

- `Picard/RelativeSpec.lean:236` — `coequifibered := sorry` field in
  `QcohAlgebra.pullback` constructor.

### Approach (per iter-179 Lane B task_result Section "Concrete next steps (iter-180+)")

The Mathlib-gap is "pushforward along an affine morphism preserves
Coequifibered" (Stacks 01LR pullback compatibility). Steps:

1. `q := pullback.fst g (structureMorphism 𝒜)` is affine via
   `MorphismProperty.pullback_fst` applied to
   `UniversalProperty 𝒜 : IsAffineHom (structureMorphism 𝒜)`.
2. On every affine `U ⊆ T` with section `f ∈ Γ(T, U)`, `q⁻¹U ⊆ P` is
   affine; basic open `q⁻¹(D(f)) ⊆ q⁻¹U` is `D(q.app f)`.
3. The ring identity `Γ(P, D(q.app f)) = Γ(P, q⁻¹U)[1/q.app f]` is
   `IsAffineOpen.isLocalization_basicOpen` (from
   `Mathlib/AlgebraicGeometry/AffineScheme.lean`).
4. Unwind to match `coequifibered_iff_forall_isLocalizationAway`
   (Mathlib's coequifibered characterization).

**Helper budget = 2**: one for the `IsAffineHom q` lemma (Step 1) and
one for the `D(q.app f) ↔ IsLocalization.Away` translation (Step 3),
if needed inline.

### Acceptance criteria

- File compiles GREEN.
- `coequifibered` field axiom-clean OR helper-with-substantive-Mathlib-gap.
- The OTHER helper `pullback_iso` STAYS sorry this iter (separate
  body, iter-181+ work).
- Helper budget ≤ 2.

### Off-target

- `pullback_iso` body (L357) — leave sorry; iter-181+ work.

---

## Lane D — `AlgebraicJacobian/RiemannRoch/OCofP.lean` — close smallest body sorry

**Break 4-iter STUCK-by-inaction streak.** Per progress-critic finding,
this file has had 0 sorry-elimination across 5 iters (the iter-177
auditor-fix added 1 sorry, net up by 1).

### Target

Prover picks the smallest of these candidates:

1. **`lineBundleAtClosedPoint`** (L140) — type-level
   `sorry` returning a Sheaf. Per the docstring (L130-139), the body
   is `(IdealSheafData.idealOfPoint P hP).idealSheaf.dual ⊗ HModule.forget`.
   Concretely:
   - Get the closed-point ideal sheaf via
     `Scheme.IdealSheafData.idealOfPoint` (Mathlib).
   - Take `O_C`-linear dual `ℋom_{O_C}(ℐ_P, O_C)`.
   - Forget to `ModuleCat k̄` via the `HModule` adjunction.
2. **`globalSections_iff`** (L192) — substantive iff Prop. Reduces
   the sheaf-side statement to a sum of order conditions at each
   prime divisor, via DVR valuation identification. Depends on
   `lineBundleAtClosedPoint` body (so closing this requires Pin 1
   first OR using a stub).

Lane D opens BOTH; the prover picks at-attempt based on which has
the cleaner body. **Pick the one with fewer dependencies on uncommitted
upstream files.**

### Approach

For `lineBundleAtClosedPoint`: structure the construction as a chain
of Mathlib morphisms; if any intermediate piece is Mathlib-missing,
factor out as a named helper sorry. Helper budget = 2.

For `globalSections_iff`: assume `lineBundleAtClosedPoint`'s body is
in scope (stub via `Classical.choice` is FORBIDDEN — must use the
real body if attempted). Body uses Hartshorne II.7 Prop 7.7's iff
content + DVR identification of valuations. Helper budget = 2.

### Acceptance criteria

- File compiles GREEN.
- At least one of the 5 sorries closed OR PARTIAL with a structural
  advance + ≤2 named helper sorries.
- No new axioms.

### Off-target

- `h1_vanishing_genusZero`, `dim_eq_two_of_genusZero`,
  `exists_nonconstant_genusZero` — depend on RR.2 chain (RRFormula
  Lane E target this iter); leave for iter-181 if Lane E lands.

---

## Lane E — `AlgebraicJacobian/RiemannRoch/RRFormula.lean` — close smallest sorry

**Break 4-iter STUCK-by-inaction streak.** Per progress-critic finding,
this file has had 0 sorry-elimination across 5 iters.

### Target

- **`Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero`** (L253):
  the smallest of the file's 3 sorries. Body is the genus-0
  specialisation of `eulerCharacteristic_eq_degree_plus_one_minus_genus`
  (which is the substantive sorry at L224) followed by unfolding `χ`
  and substituting `_hH1 : finrank H¹ = 0`.

### Approach

The body sketched in the lemma's docstring (L243-249) is the
substantive content; the prover should:

1. Invoke `eulerCharacteristic_eq_degree_plus_one_minus_genus C D` to
   get `χ(𝒪_C(D)) = deg(D) + 1 - genus C`.
2. Substitute `_hg : genus C = 0` and `_hH1 : finrank H¹ = 0` (the
   second flattens χ to `finrank H⁰`).
3. Unfold `Scheme.eulerCharacteristic` and `Scheme.WeilDivisor.l`
   to expose the `Module.finrank kbar H⁰` form, then conclude
   `l D = deg D + 1`.

**Helper budget = 1**: a small helper for the `χ`-to-`l` translation
if needed.

**Note**: the body depends on `eulerCharacteristic_eq_degree_plus_one_minus_genus`'s
body (L224, also `sorry`). If the prover closes Lane E by treating the
upstream lemma as a black box, that's acceptable (the upstream `sorry`
remains for iter-181+).

### Acceptance criteria

- File compiles GREEN.
- `l_eq_degree_plus_one_of_genus_zero` body axiom-clean (modulo
  the upstream `eulerCharacteristic_eq_degree_plus_one_minus_genus`
  sorry).
- Helper budget ≤ 1.

### Off-target

- `eulerCharacteristic_eq_degree_plus_one_minus_genus` body (L224):
  the substantive χ-identity proof; leave sorry. iter-181+ work.
- `Scheme.WeilDivisor.sheafOf` body (L171): type-level; leave sorry.

---

## Lane F — `AlgebraicJacobian/Picard/QuotScheme.lean` — close `canonicalBaseChangeMap_app_app_isIso` helper

**iter-178 Lane 6 STRETCH carry-over.** The iter-178 Lane 6 closed the
structural one-liner `canonicalBaseChangeMap_isIso` via the helper
`canonicalBaseChangeMap_app_app_isIso`; the helper carries the
substantive Stacks 02KH(ii) content.

### Target

- `Picard/QuotScheme.lean` — the iter-178 named helper
  `canonicalBaseChangeMap_app_app_isIso` (find via grep — should be
  near L420-450 post-iter-178 landing).

### Approach (per Stacks 02KH(ii) reduction)

For every open `U` of `S'`, the section over `U` of the canonical
base-change map is an iso. On quasi-compact opens `U ⊆ S'`:

1. Reduce to the algebraic flat base change `B ⊗_A H⁰(X, F) ≅ H⁰(X_B, F_B)`
   (Stacks 00H8 / 02KE).
2. Apply `Module.Flat.isBaseChange` on the ring map
   `A = Γ(S, V) → B = Γ(S', V')` for an affine open `V ⊆ S` with
   `V' = g⁻¹V`.

The general case follows by Mayer-Vietoris from quasi-separation of
`f` (so intersections of preimages are quasi-compact, hence the
algebraic step applies to each pair of affine charts).

**Helper budget = 2**: one for the `Module.Flat.isBaseChange` invocation
on the affine-local case, one for the MV gluing if needed.

### Acceptance criteria

- File compiles GREEN.
- Helper body axiom-clean OR helper-with-substantive-Mathlib-gap.
- Helper budget ≤ 2.

### Off-target

- All other sorries in `QuotScheme.lean` (file-skeleton pins) —
  leave; iter-181+ work.

---

## Lane G — `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean` — refactor helper `av_isIntegral_and_codimOneFree`

**Re-engage iter-179 helper.** iter-179 Lane E broke the 4-iter
inaction streak by landing `extend_to_av`'s body with 1 named helper
`av_isIntegral_and_codimOneFree` (file L187). Lane G this iter
splits or closes the helper.

### Target

- `Albanese/Thm32RationalMapExtension.lean:187` — the helper
  `av_isIntegral_and_codimOneFree`.

### Approach

The helper consolidates 2 Mathlib gaps (per iter-179 Lane E
task_result Section "What's substantive in the helper"):

1. **`IsIntegral A.left`** — derives from `Smooth + GeometricallyIrreducible
   + IsAlgClosed kbar`. Chain: `Smooth ⟹ IsReduced` (GAP), then
   `GeometricallyIrreducible + Spec K subsingleton ⟹ IrreducibleSpace`
   (`GeometricallyIrreducible.irreducibleSpace_of_subsingleton`, verified),
   then `IsReduced + IrreducibleSpace ⟹ IsIntegral`
   (`isIntegral_of_irreducibleSpace_of_isReduced`, verified).
2. **`CodimOneFree f`** — combination of Theorem 3.1 (codim-≥2
   indeterminacy, bundled inside `extend_of_codimOneFree_of_smooth`)
   + Lemma 3.3 (pure-codim-1-or-empty,
   `indeterminacy_pure_codim_one_into_grpScheme` from
   `Albanese/CodimOneExtension.lean`).

**Lane G choice**:

- **Option (a)**: split `av_isIntegral_and_codimOneFree` into 2 named
  pieces:
  - `av_isIntegral_of_smooth_geomIrred` (substantive Mathlib gap on
    `Smooth ⟹ IsReduced`).
  - `av_codimOneFree_of_indeterminacy` (substantive on `CodimOneFree`).
  The first one stays sorry (Mathlib gap deferred); the second one
  closes axiom-clean via `indeterminacy_pure_codim_one_into_grpScheme`
  (currently `sorry` in CodimOneExtension, but treating as black box
  for the body chain).
- **Option (b)**: close ONE of the two conjuncts inside the helper
  while leaving the other as a named sub-helper sorry. Less clean
  than (a) but lower LOC.

**Helper budget = 2** (Option (a)) or 1 (Option (b)).

### Acceptance criteria

- File compiles GREEN.
- Helper body refactored honestly (split OR partial close).
- No new axioms.

### Off-target

- `extend_to_av` body (L187): leave as-is from iter-179 (already
  honest helper-based body).

---

## Lane H — `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` — close `Module.depth` body

**Build on iter-179 Lane F STRETCH PARTIAL.** Lane F iter-179
task_result documented the closure path (Stacks 00LF supremum form
using `RingTheory.Sequence.IsRegular` from
`Mathlib/RingTheory/Regular/RegularSequence.lean:146`).

### Target

- `Albanese/AuslanderBuchsbaum.lean:146` — `Module.depth` body.

### Approach (per Lane F iter-179 task_result Section "Concrete next step")

Replace the body with the Stacks 00LF supremum form:

```lean
def Module.depth (I : Ideal R) (M : Type v) [AddCommGroup M] [Module R M] : ℕ∞ :=
  if I • (⊤ : Submodule R M) = ⊤ then (⊤ : ℕ∞)
  else sSup { n : ℕ∞ | ∃ rs : List R, (rs.length : ℕ∞) = n ∧
    (∀ r ∈ rs, r ∈ I) ∧ RingTheory.Sequence.IsRegular M rs }
```

Verify that `RingTheory.Sequence.IsRegular` has the right semantics
(the stronger "regular AND `M/(rs)·M ≠ 0`" form, matching Stacks 00LF).

**No helpers needed** — direct body. Helper budget = 0.

### Acceptance criteria

- File compiles GREEN.
- `Module.depth` body axiom-clean.
- Optional STRETCH: confirm `depth_eq_smallest_ext_index`,
  `depth_of_short_exact`, or `auslander_buchsbaum_formula` become
  tractable now that `depth` has a body (may require their own bodies
  in iter-181+).

### Off-target

- All other sorries in `AuslanderBuchsbaum.lean` (depth-dependent
  lemmas): leave; iter-181+ work after `depth` body lands.

---

## Cross-lane process safeguards

1. **No signature mutations this iter**: all 8 lanes work intra-file
   without modifying existing signatures (Lane A adds a `set_option` on
   the lemma; Lane G splits a helper into 2 helpers, both new names;
   Lane H replaces `:= sorry` with a body, no signature change). The
   parallel-signature-race process from iter-176/177 is averted.
2. **Build-state check**: every lane runs `lake build <its-module>`
   before reporting SUCCESS.
3. **Axiom-set check**: every lane reports `#print axioms <key-decl>`
   in its task_result.
4. **No-laundering boilerplate** (top of file): re-read before each
   attempt cycle.
5. **iter-175 KB `chart-bridge-prover-bypass` rule** applies to Lane A
   specifically: read `analogies/pullbackspeciso-bypass.md` verbatim;
   the empirically-verified recipe is the FIRST attempt; helper budget
   = 1; no alternative-approach experimentation before the recipe is
   attempted on file.
