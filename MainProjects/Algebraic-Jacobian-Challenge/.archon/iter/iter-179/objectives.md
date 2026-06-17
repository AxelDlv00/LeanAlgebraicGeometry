# Iter-179 prover lane directives

Per the iter-179 plan, prover lanes A–F dispatched post-plan (after the
plan-phase refactor subagents land). Each prover lane is one `.lean`
file. All lanes carry the iter-179 **no-laundering boilerplate** at the
end:

> HARD RULE — no laundering. Do NOT close a sorry by introducing a NEW
> project axiom (kernel-only end-state contract). Do NOT close a sorry
> by making the body a placeholder that discards the meaningful argument
> (`def F := <something not containing the argument>`). If the body
> mathematically requires content you cannot produce honestly, leave
> PARTIAL with a substantive named helper sorry, NOT a laundered
> closure.

## Lane A — `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` — Step 3: retire 2 TEMP axioms

**Depends on** the iter-179 plan-phase `refactor-cover-bridge-uniform-i`
landing FIRST (the file is in uniform-in-`i` form at the start of this
lane's work).

**Targets** (3 body lemma retirements):

1. `gmScalingP1_chart_PLB_eq` (at the new line after the refactor; was
   L232 pre-refactor) — body currently discharged via
   `(gmScalingP1_chart_data_temp kbar).1 i`. Rewrite as honest proof
   per `analogies/gmscaling-cover-bridge.md` Step 3 (1) — chain through
   `pullbackSpecIso_hom_base` ∘ `awayι_comp_PLB_hom` post-refactor, with
   `Matrix.cons_val_zero` / `Matrix.cons_val_one` doing the per-`i`
   splitting LOCALLY inside the proof (not at the `gmScalingP1_cover_X_iso`
   construction level).

2. `gmScalingP1_chart_agreement` (was L246-252 pre-refactor) — body
   currently discharged via `(gmScalingP1_chart_data_temp kbar).2`.
   Rewrite as honest proof per `analogies/gmscaling-cover-bridge.md` Step
   3 (2) — diagonal cases via `fst_eq_snd_of_mono_eq` (since
   `(gmScalingP1_cover kbar).f i` is `IsOpenImmersion`, hence mono);
   cross cases `(0, 1) / (1, 0)` via the algebraic identity
   `λ · u = (1/t) · λ` in `Localization.Away t ⊗[kbar] GmRing` per the
   `analogies/gmscaling-deep.md` Q4 recipe.

3. `gmScalingP1_collapse_at_zero` (was L323 pre-refactor) — body
   currently discharged via `gmScalingP1_collapse_at_zero_temp`. Rewrite
   as honest proof per `analogies/gmscaling-cover-bridge.md` Step 3 (3) —
   unfold `gmScalingP1`, apply `Scheme.Cover.hom_ext` on the cover, reduce
   on chart-1 to the ring-level identity in `MvPolynomial Unit kbar ⊗[kbar]
   GmRing` (the chart-1 ring map sends `u ↦ u ⊗ λ`; `zeroPt` factors
   through chart-1 at `u = 0`).

**After all 3 body retirements land**, DELETE the two `axiom` declarations
`gmScalingP1_chart_data_temp` (L212-219 pre-refactor) and
`gmScalingP1_collapse_at_zero_temp` (L308-311 pre-refactor) from the
file. Verify via `lean_verify AlgebraicGeometry.gmScalingP1_chart_PLB_eq`
that no `gmScalingP1_chart_data_temp` axiom remains in the axiom-set
output.

**STRICT BAN — encoded per iter-175 KB `chart-bridge-prover-bypass`**:
The empirically-verified recipe is in
`analogies/gmscaling-cover-bridge.md`. Quote the relevant Step 3 (1)/(2)/(3)
recipe verbatim into your attempt's pre-amble. Do NOT substitute
alternative approaches before the recipe has been attempted with
`lean_multi_attempt`. Helper budget = **0 helpers**. The refactor has
provided the structural ground; the body proofs are recipe-execution,
NOT structural-helper-multiplication. If the recipe doesn't close after
≤8 substantive attempts per lemma, REPORT honestly — do NOT add helpers.

**Expected outcome**:
- File sorry count: 2 → 2 (the 2 off-target Mathlib-gap sorries
  `gm_geomIrred`, `projGm_isReduced` remain — they are not Lane A targets).
- File axiom count: 2 → 0.
- `lake build AlgebraicJacobian` green.
- iter-181 RETIRE-OR-ESCALATE trigger RESOLVED.

**Reversal trigger**: if the recipe sticks even on Step 3 (1) after the
refactor lands cleanly, the iter-180 plan-agent fires the iter-181 escalation
EARLY (do not silently iter another helper-cycle).

[HARD RULE — no laundering — boilerplate, see top.]

## Lane B — `AlgebraicJacobian/Picard/RelativeSpec.lean` — Block B: 3 downstream rewrites

**Depends on** the iter-179 plan-phase `refactor-relative-spec-block-a`
landing FIRST (the file's body is `(relativeGluingData _).glued` at the
start of this lane's work; 3 downstream theorems have honest `sorry`
bodies).

**Targets** (3 theorem body fills per `analogies/relative-spec-encoding.md`
Block B):

1. `UniversalProperty` (was L227-237 pre-refactor; now carries `sorry`):
   prove `IsAffineHom (RelativeSpec.structureMorphism 𝒜)` via
   `HasAffineProperty.iff_of_iSup_eq_top`
   (`Mathlib/AlgebraicGeometry/Morphisms/Affine.lean:146`). The argument:
   use the open cover `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).cover`
   (`Mathlib/AlgebraicGeometry/RelativeGluing.lean:107`); each fiber is
   `Spec(𝒜.sheaf.val.obj _)`, affine by `AlgebraicGeometry.AffineScheme`;
   each restriction is `Spec` of the algebra unit `α.app _`, affine.
   Estimate ~15 LOC.

2. `affine_base_iff` (was L259-267 pre-refactor; now carries `sorry`):
   prove `IsAffine ((Spec R).RelativeSpec 𝒜)`. On `Spec R`,
   `X.AffineZariskiSite` has a top element ⊤ = `X`; the
   `relativeGluingData` collapses to `Spec(𝒜.sheaf.val.obj ⊤) =
   Spec(Γ(Spec R, 𝒜))`. Adapt the proof of
   `Mathlib/AlgebraicGeometry/Sites/SmallAffineZariski.lean:343
   isColimitCocone` to the non-trivial `α` case (multiply by the algebra
   unit; the colimit structure persists). Estimate ~25 LOC.

3. `base_change` (was L295-311 pre-refactor; now carries `sorry`):
   prove `∃ 𝒜' : T.QcohAlgebra, Nonempty (pullback g (structureMorphism 𝒜) ≅ T.RelativeSpec 𝒜')`.
   Construct `𝒜' = g^* 𝒜` (the pullback of `𝒜.sheaf` along `g` with the
   pullback `unit` natTrans, plus the `Coequifibered` predicate's
   stability under pullback — `IsLocalization.Away` is preserved by
   ring base change per `Mathlib/RingTheory/Localization/BaseChange.lean`).
   The iso follows from the universal property of
   `relativeGluingData.glued`. Estimate ~30 LOC.

**Helper budget**: 2 (you MAY introduce up to 2 named helpers carrying
substantive Mathlib-gap content — e.g. `Coequifibered.pullback` if
Mathlib doesn't ship the explicit lemma, or
`relativeGluingData_glued_iff_affine` if a one-liner needs an
intermediate fact. Each helper MUST have a substantive type — NOT a
tautology, NOT `:= 𝟙 X`, NOT `:= sorry` with `True`-like type. No
laundering.

**Expected outcome**:
- File sorry count: 3 (post-refactor scaffold) → 0–2 (depending on
  how many helpers carry residual content). Best case: 0 file sorries.
- `lake build AlgebraicJacobian.Picard.RelativeSpec` green.

[HARD RULE — no laundering — boilerplate, see top.]

## Lane C — `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` — sig tightening (auditor 178A) + Pin 1 body

**Auditor 178A finding** (`task_results/lean-auditor-iter178-touched.md`):
`morphismToP1OfGlobalSections` (L198-243) has body
`Over.homMk (Proj.fromOfGlobalSections (projectiveLineBarGrading kbar) f _hf) <| by ... sorry`
and an inline EXCUSE-COMMENT confessing the signature does NOT encode
the `kbar`-algebra hypothesis needed to discharge the section condition.
The body would silently succeed via `sorry` on inputs `f` that are NOT
`kbar`-algebra maps. This is the iter-175 chart-bridge-prover-bypass
pattern recurring.

**FORBIDDEN this iter** (encoded per iter-175 KB `chart-bridge-prover-bypass`):
- Do NOT keep the current signature and use `sorry` for the section
  condition. The auditor identified this as the weakened-wrong pattern.
- Do NOT try alternative approaches that don't tighten the signature.
- Do NOT add helpers that hide the gap. Helper budget = 0.

**Target** (sig + Pin 1):

1. **Signature tightening** (1-2 LOC): add the missing `kbar`-algebra
   hypothesis as a NEW positional argument:

   ```lean
   noncomputable def morphismToP1OfGlobalSections
       {kbar : Type u} [Field kbar]
       (X : Over (Spec (.of kbar)))
       (f : MvPolynomial (Fin 2) kbar →+* Γ(X.left, ⊤))
       (_halg : f.comp (algebraMap kbar (MvPolynomial (Fin 2) kbar)) =
                 (Scheme.ΓSpecIso _).inv.hom.comp X.hom.appTop)
       (_hf :
         Ideal.map f
             (HomogeneousIdeal.irrelevant (projectiveLineBarGrading kbar)).toIdeal = ⊤) :
       X ⟶ ProjectiveLineBar kbar :=
   ```

   (The order of `_halg` and `_hf` doesn't matter; pick whichever reads
   most naturally. The literal form `_halg` should be the equation the
   `change`/`rw` chain reduces to — the auditor's flagged
   `X.toSpecΓ ≫ Spec.map (CommRingCat.ofHom (f.comp MvPolynomial.C)) = X.hom`.)

2. **Pin 1 body close** (~20-30 LOC): with the new `_halg` hypothesis in
   scope, the existing tactic chain
   `change … rw [← Category.assoc, Proj.fromOfGlobalSections_toSpecZero,
   …, MvPolynomial.algebraMap_eq]` reduces the goal to
   `X.toSpecΓ ≫ Spec.map (CommRingCat.ofHom (f.comp MvPolynomial.C)) = X.hom`,
   which is now closable via `_halg` (modulo a `Spec.map` /
   `CommRingCat.ofHom` rewrite chain). Mirror the verbatim closed proof
   in `Genus0BaseObjects/Points.lean:86 pointOfVec` for the post-`_halg`
   chain.

**Signature-mutating lane** — downstream consumer audit (per iter-178
process change):
- `morphismToP1OfGlobalSections` is consumed by `morphism_degree_via_pole_divisor`
  (RationalCurveIso L266-306, still `sorry`) and `iso_of_degree_one`
  (L356-369, still `sorry`); both are in the same file. After the sig
  change, update any in-file consumer.
- `genusZero_curve_iso_P1` (`AbelianVarietyRigidity.lean:290`, `sorry`) is
  chained downstream via `iso_of_degree_one`; NOT a current consumer of
  the literal signature, no breakage expected.

**Expected outcome**:
- File sorry count: 3 → 2 (Pin 1 closes; Pin 2 `morphism_degree_via_pole_divisor`
  and Pin 3 `iso_of_degree_one` remain — both off-target this iter).
- `lake build` green for the file.

**Reversal trigger**: if even the threaded `_halg` doesn't close the
residual `X.toSpecΓ ≫ Spec.map (...) = X.hom` (e.g., `_halg`'s exact
shape needs refinement), REPORT honestly with the residual goal state.
Do NOT add helpers; iter-180 plan-agent will refine `_halg` from the
report.

[HARD RULE — no laundering — boilerplate, see top.]

## Lane D — `AlgebraicJacobian/Albanese/CodimOneExtension.lean` — sig fix (auditor 178B) + helper body

**Auditor 178B finding**: `extend_iff_order_nonneg` (L391-406) body is
2-LOC `mem_domain` reshuffle; `[Ring.KrullDimLE 1 (X.left.presheaf.stalk W.point)]`
binder is UNUSED; docstring claims substantive Hartshorne II.6
valuation content (`Scheme.RationalMap.order`, valuative criterion)
that the type doesn't encode.

**Two acceptable closure paths** — the lane prover decides based on
which discharges cleanly in ≤30 LOC:

### Path D1 — TIGHTEN signature (preferred — the auditor's recommended)

1. Add the order-≥0 condition to the iff and thread `Scheme.RationalMap.order`:

   ```lean
   theorem extend_iff_order_nonneg
       ...
       [Ring.KrullDimLE 1 (X.left.presheaf.stalk W.point)] :
       W.point ∈ f.domain ↔
         (∀ g : ..., 0 ≤ Scheme.RationalMap.order W (f.pullback g)) := …
   ```

   (The exact shape depends on what `Scheme.RationalMap.order` accepts —
   verify via `lean_hover_info` BEFORE writing. The key is that the iff
   now mentions `order`, the binder is genuinely used.)

2. Body chases `localRing_dvr_of_codim_one` to get the DVR stalk;
   `Scheme.RationalMap.order` is then the canonical valuation; the iff
   is the standard "regular = no pole" criterion. Estimate ~20-30 LOC.

### Path D2 — RELAX docstring + RENAME (honest fallback)

1. Rename the lemma to `extend_iff_exists_partialMap_domain` (or similar)
   reflecting what the existing 2-LOC body actually proves (it's a
   re-shuffle of `mem_domain`).
2. Relax the docstring to match.
3. Remove the unused `[Ring.KrullDimLE 1]` binder.

(This option is honest but the auditor noted it's "mathematically less
valuable" because the substantive content the file-skeleton was
supposed to introduce is then deferred to a fresh lemma. Prefer Path
D1 if it discharges.)

### Helper body (separately): `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`

The iter-178 Lane 4 task result identified this as a single named helper
sorry capturing the Mathlib-gap content (smooth ⟹ regular local ⟹
principal nonzero maximal ideal at codim-1 points). Attempt to close it
via Stacks `00TT` / `00TX` Jacobian criterion if Mathlib ships them; OR
via `IsRegularLocalRing.iff_finrank_cotangentSpace` plus a
`coheight ≥ 1` ⟹ `dim ≥ 1` chain. PARTIAL acceptable; document the
remaining Mathlib gap.

**Helper budget**: 1 (the existing
`smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` helper sorry can
have its body filled, AND if Path D1 needs a small intermediate the
prover MAY add ONE more helper).

**Expected outcome**:
- File sorry count: 3 → 1 or 2.
- `lake build` green.

[HARD RULE — no laundering — boilerplate, see top.]

## Lane E — `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean` — fill 1 sorry

**Critic finding `route179`**: STUCK-by-inaction; file skeleton landed
iter-175, untouched for 4 iters.

**Target**: `extend_to_av` (L162-173) is the only sorry in this file. It
formalizes Milne Thm 3.2: a rational map `f : V ⇢ A` from a smooth
variety to an abelian variety extends uniquely to a regular morphism.

**Read** `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex`
for the chapter's prose AND `references/abelian-varieties.pdf` Milne
Thm 3.2 (page 15-20) for the source proof. The proof builds on Milne
Lemma 3.3 (`Albanese/CodimOneExtension.lean:indeterminacy_pure_codim_one_into_grpScheme`)
which itself is `sorry`; AND `auslander_buchsbaum_formula`
(`Albanese/AuslanderBuchsbaum.lean`, `sorry`).

**Closure path** (~20-50 LOC):
- Either close `extend_to_av` MODULO the two upstream sorries (Lemma 3.3
  + Auslander-Buchsbaum), which is fine — the body uses them as black
  boxes and the file builds.
- OR factor into a smaller intermediate lemma if the body is multi-step.

PARTIAL acceptable; the goal is to break the 4-iter inaction streak,
not to close transitively.

**Helper budget**: 1.

**Expected outcome**:
- File sorry count: 1 → 0 or 1 (depending on closure depth).
- `lake build` green.

[HARD RULE — no laundering — boilerplate, see top.]

## Lane F — `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` — auditor 178C docstring + depth body stretch

**Auditor 178C finding**: `projectiveDimension` (L165-170) docstring
still claims iter-175 file-skeleton typed-sorry status, but iter-178
Lane 7 filled the body to `CategoryTheory.projectiveDimension (ModuleCat.of R _M)`.
Stale-by-evolution.

**Target 1 (auditor 178C, low-effort)**: Update the docstring
(L155-167) to reflect the closed body. Drop the "For the iter-175
file-skeleton the body is a typed `sorry`" paragraph. Also drop the
"iter-175 Lane F file-skeleton" claim from the module-level status block
(L33-92) wherever it references this declaration as `sorry`.

**Target 2 (STRETCH — depth body)**: Look up
`Mathlib.RingTheory.Depth` (or the canonical Mathlib idiom for
Stacks 00LF depth). If Mathlib ships a `Module.depth` or
`RingTheory.depth` that matches the project's signature
`{R : Type u} [CommRing R] (_I : Ideal R) (_M : Type v) [AddCommGroup _M] [Module R _M] : ℕ∞`,
re-export via a one-liner per `Module.projectiveDimension`'s template.
If Mathlib doesn't ship it, document the gap and leave PARTIAL (sorry
stays).

**Helper budget**: 0 for Target 1; 0 for Target 2 (one-liner re-export
OR PARTIAL).

**Expected outcome**:
- Target 1: docstring cleanups committed.
- Target 2: file sorry count 5 → 4 or stays 5.
- `lake build` green.

[HARD RULE — no laundering — boilerplate, see top.]

## Dispatch ordering

The loop's `prover-fanout` post-plan ensures all 6 prover lanes fire in
parallel. Refactor lanes 1 + 2 land in plan-phase (this phase, blocking)
BEFORE prover-fanout fires. Lane A consumes the refactor 1 outputs;
Lane B consumes the refactor 2 outputs.

## Per-lane non-target lists (so the prover doesn't drift)

- Lane A: do NOT touch `gm_geomIrred`, `projGm_isReduced`,
  `gmScalingP1_chart{0,1}_ringMap`, `gmScalingP1_chart`, `gmScalingP1`,
  `gmScalingP1_over_coherence`, or the underlying `gmScalingP1_cover` /
  `awayι_comp_PLB_hom` declarations. ONLY the 3 body retirements +
  axiom deletions.
- Lane B: do NOT touch the `QcohAlgebra` carrier (refactor 2 owns it),
  the `RelativeSpec` body (refactor 2 owns it), or
  `RelativeSpec.structureMorphism` body. ONLY the 3 downstream theorem
  bodies.
- Lane C: do NOT touch `iso_of_degree_one` Pin 3 (let the iter-180+
  lane retry there). ONLY `morphismToP1OfGlobalSections` (Pin 1) sig +
  body. The morphism_degree_via_pole_divisor (Pin 2) stays sorry.
- Lane D: do NOT touch `extend_of_codimOneFree_of_smooth`,
  `indeterminacy_pure_codim_one_into_grpScheme`. ONLY
  `extend_iff_order_nonneg` + the helper sorry it depends on.
- Lane E: do NOT touch the chapter prose; do NOT add cross-file
  consumers. ONLY `extend_to_av` body.
- Lane F: do NOT touch `depth_eq_smallest_ext_index`,
  `depth_of_short_exact`, `auslander_buchsbaum_formula`,
  `CohenMacaulay.of_regular`. ONLY `projectiveDimension` docstring +
  STRETCH `depth`.
