# Lean ↔ Blueprint Check Report

## Slug
dualinv255

## Iteration
255

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
  (chapter covers DualInverse.lean per `% archon:covers` at line 6)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `lem:dual_restrict_iso`, blueprint ~L5489)
- **Lean target exists**: yes (`DualInverse.lean` line 230)
- **Signature matches**: yes — `(f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules) : (dual M).restrict f ≅ dual (M.restrict f)` matches blueprint's "canonical isomorphism `(dual M)|_f ≅ dual(M|_f)`, natural in M"
- **Proof follows sketch**: partial — Steps 1–3 (reduce to presheaf via `restrictFunctorIsoPullback`, `sheafificationCompPullback`, strip outer sheafification) match the blueprint's 4-step recipe. Step 4 has a `sorry` at line 256, which is expected. However, the Lean's Step-4 approach uses H1 (`pushforwardPushforwardAdj`∘`leftAdjointUniq`) to convert `pullback φ` to `pushforward β` and then a `sorry` for `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`. The blueprint's proof describes "Leg (A) — Beck-Chevalley slice Hom base-change" and "Leg (B) — ground-ring reconciliation via `restrictScalarsRingIsoDualEquiv`" as the two pieces of Step 4. The Lean H1 is an adjunction-uniqueness mechanism that is mathematically adjacent to Leg (A) but operates at a different level of abstraction than the blueprint description. The Lean sorry subsumes both Blueprint Legs (A) and most of (B).
- **Blueprint `\leanok` status**: statement block has `\leanok` (correct: sorry present); proof block has no `\leanok` (correct: not closed)
- **notes**: Lean file's module-doc and planner comment (lines 160–228) transparently flag the Step-4 sorry as the "genuine new build" and reproduce the warning from the blueprint about `overSliceSheafEquiv` not applying. No discrepancy in the mathematical goal.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` (chapter: `lem:dual_unit_iso`, blueprint ~L5607)
- **Lean target exists**: yes (line 274)
- **Signature matches**: yes — `dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf` matches blueprint's `dual 𝒪_Y ≅ 𝒪_Y`
- **Proof follows sketch**: yes — Blueprint says "sheafifying the presheaf-level evaluation-at-1 isomorphism". Lean composes `presheafDualUnitIso` (which uses `dualUnitIsoGen`, the evaluation-at-1 linear equiv `unitDualSectionEquiv`) with the sheafification counit. Blueprint proof explicitly confirms "evaluation at 1 identifies the internal hom of the unit into itself with the unit." Match is accurate. Proof is sorry-free.
- **Blueprint `\leanok` status**: statement block has `\leanok` (line 5604: `\begin{lemma}\leanok`); proof block has no `\leanok` (sync_leanok should add this — the proof is sorry-free)
- **notes**: Blueprint proof states "No left unitor is needed: the identification is the direct evaluation-at-1 / global-scalar-multiplication isomorphism." The Lean proof does not use a left unitor — consistent with this note ✓.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `lem:dual_isLocallyTrivial`, blueprint ~L5641)
- **Lean target exists**: yes (line 332)
- **Signature matches**: yes — `hL : LineBundle.IsLocallyTrivial L → LineBundle.IsLocallyTrivial (dual L)` matches blueprint's "`dual L` is again locally trivial of rank one"
- **Proof follows sketch**: yes — Blueprint proof gives the exact three-step chain `(dual L)|_f ≅ dual(L|_f) ≅ dual 𝒪_U ≅ 𝒪_U` via `dual_restrict_iso ≪≫ dualIsoOfIso eL ≪≫ dual_unit_iso`. Lean line 341 is exactly `exact dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso`. The `.symm` on `dualIsoOfIso eL` correctly handles the contravariance. Match ✓.
- **Blueprint `\leanok` status**: statement block has `\leanok` (correct: transitive sorry via `dual_restrict_iso`); proof block has no `\leanok` (correct)
- **notes**: Lean module-doc correctly notes this is "TRANSITIVELY PARTIAL (depends on `dual_restrict_iso` Step-4 sorry)."

---

### `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` (chapter: `lem:scheme_modules_hom_local_section`, blueprint ~L5764)
- **Lean target exists**: yes (line 355)
- **Signature matches**: yes — `(U : ι → X.Opens) (f : ∀ i, M.restrict (U i).ι ⟶ N.restrict (U i).ι) (i : ι) : (CategoryTheory.presheafHom M.val.presheaf N.val.presheaf).obj (op (U i))` matches blueprint's "f_i determines a local section `localSection i ∈ H(U_i)`"
- **Proof follows sketch**: yes — Blueprint proof describes: (a) component at pair (V, h) is `(f_i).app(V')` conjugated by `eqToHom` from `ι_i(ι_i⁻¹(V)) = V`; (b) naturality is proved by M-side and N-side thin-poset equality via `Subsingleton.elim`. Lean lines 358–404 implement this exactly: `hML`/`hNR` are the M/N-side thin-poset equations, `hsubM`/`hsubN` are `Subsingleton.elim _ _` witnesses. Proof is sorry-free ✓.
- **Blueprint `\leanok` status**: statement block has `\leanok` ✓; proof block has no `\leanok` (sync_leanok should add — proof is sorry-free)
- **notes**: Blueprint prose calls the declaration `localSection` throughout, but `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` correctly pins the Lean name. Minor naming drift between prose and code (see § Minor findings below).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (chapter: `lem:sheafofmodules_hom_of_local_compat`, blueprint ~L5817)
- **Lean target exists**: yes (line 513)
- **Signature matches**: yes — signature matches blueprint's statement (open cover, compatible family of local morphisms, unique global morphism). The `hf` parameter uses the sectionwise form (comparing `M.val.presheaf.map (eqToHom ...) ≫ (f i).val.app ≫ N.val.presheaf.map (eqToHom ...)` on both sides) which the blueprint explicitly validates as "the only one a caller can actually produce" in sub-step (a). ✓
- **Proof follows sketch**: partial — The proof structure maps onto the blueprint's labeled sub-steps:
  - **(a) IsCompatible condition** (blueprint: explicit, detailed) → Lean `hcompat` block (lines 543–560), using `hf` + `Subsingleton.elim` ✓
  - **(b) Gluing + top-section-to-morphism conversion** (blueprint: "mechanical") → Lean: `hglue hcompat`, `topSectionToHom`, `presheafHomSectionsEquiv` (lines 561–564) ✓
  - **(c) Sectionwise linearity** (blueprint: "mechanical") → Lean: sorry at line 656 ← **NOT mechanical** (see Red flags §)
  - **(ii) homMk promotion** → Lean `refine homMk ... ?_` ✓
- **Blueprint `\leanok` status**: statement block has `\leanok` (line 5814, correct: sorry present); proof block has no `\leanok` (correct: not closed)
- **notes**: The proof is correctly structured. The sole sorry is isolated to the f-leg smul bridge in sub-step (c). The `hconn` connection lemma (lines 583–601) and the `section_ext` separatedness reduction (lines 603–617) are completed cleanly. Blueprint's sub-step (d) ("recovery of `g|_{U_i} = f_i`") is also done via `hconn`.

---

## Red Flags

### Placeholder / suspect bodies

- `dual_restrict_iso` at line 256: `sorry` for the Step-4 presheaf residual
  `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`.
  The blueprint statement block has `\leanok` (formalized-with-sorry = expected); proof block has no `\leanok` (not closed = expected). This is a **known, correctly-tracked open obligation**, not an unexpected placeholder.

- `homOfLocalCompat` at line 656: `sorry` for the f-leg native↔`restrictScalars-𝟙` smul bridge.
  The blueprint statement block has `\leanok`; proof block has no `\leanok`. Same classification: known, correctly-tracked open obligation.

### Excuse-comments

- `DualInverse.lean:651`: inline comment "TO CLOSE (next iter): bridge with `ModuleCat.restrictScalars.smul_def`/`restrictScalarsId'App` (Mathlib `ChangeOfRings.lean`)..." attached directly to the `sorry`. This is an informational description of the planned fix route, not a "we are using a wrong definition for now" style excuse. Classified as informational (minor).

### Axioms / Classical.choice on non-trivial claims

None found in `DualInverse.lean`.

---

## Unreferenced declarations (informational)

The following declarations have no `\lean{...}` reference in the blueprint:

| Declaration | Kind | Assessment |
|---|---|---|
| `PresheafOfModules.unitDualSectionEquiv` (line 63) | Helper | Feeds `dualUnitIsoGen`. The sectionwise linear equiv at the core of `dual_unit_iso`. Pure helper; blueprint proof describes the content informally. Acceptable. |
| `PresheafOfModules.dualUnitIsoGen` (line 105) | Helper | The general-D version of presheaf dual-of-unit iso. Feeds `presheafDualUnitIso`. No blueprint block needed. |
| `Scheme.Modules.presheafDualUnitIso` (line 263) | Helper | Scheme-specialized instance of `dualUnitIsoGen`. Feeds `dual_unit_iso`. No blueprint block needed. |
| `Scheme.Modules.topSectionToHom` (line 412) | Helper | Converts `presheafHom F G` section over `op ⊤` into a morphism. Sub-step (b) of `homOfLocalCompat`. No blueprint block needed. |
| `Scheme.Modules.topSectionToHom_app` (line 425) | Helper | Sectionwise formula for `topSectionToHom`. Pure helper lemma. |
| `Scheme.Modules.image_preimage_of_le` (line 436) | Helper | The `ι ''ᵁ (ι ⁻¹ᵁ V) = V` open-set equality. Referenced in `hf` signature. No blueprint block needed. |

None of these have names suggesting they should be in the blueprint. All are internal building blocks for the five `\lean{}`-referenced declarations.

---

## Blueprint adequacy for this file

### Coverage
5/5 main declarations have a corresponding `\lean{...}` block. 6 helpers are unreferenced (acceptable). Coverage: adequate.

### Proof-sketch depth: **under-specified** (two issues)

**Issue 1 (major): Sub-step (c) of `homOfLocalCompat` called "mechanical" when it is not.**

The blueprint proof (line 5936–5946) lists sub-steps (b), (c), and (d) as "mechanical": "(c) the sectionwise linearity check." The Lean proof shows sub-step (c) is NOT mechanical: after the M-leg semilinearity (`Scheme.Modules.map_smul M`, closed cleanly), the f-leg `(f i).val.app P`'s `map_smul` is over the `restrictScalars 𝟙` action `((M.restrict (U i).ι).val.obj (op P)).isModule`, whereas the goal's f-leg input action is the native `Module Γ(X, image) Γ(M, image)` action (`(M.val.obj (op image)).isModule`). These are propositionally equal (via `ModuleCat.restrictScalars.smul_def` + `RingHom.id`, since `(U i).ι.appIso = Iso.refl`) but NOT defeq — verified live (the `erw`/`:=`/`refine` defeq check rejects them even under `backward.isDefEq.respectTransparency false`). The specific bridge needed (`ModuleCat.restrictScalars.smul_def`/`restrictScalarsId'App` from `ChangeOfRings.lean`) is documented in the Lean comment at lines 644–655 but absent from the blueprint. A prover following only the blueprint would not know this bridge is needed.

**Recommended blueprint action**: In `lem:sheafofmodules_hom_of_local_compat`'s proof, expand sub-step (c) from "mechanical" to describe the f-leg obstacle: the `(f i).val.app P` is linear over the `restrictScalars 𝟙` action, which must be identified with the native `Γ(X, image)` action via `ModuleCat.restrictScalars.smul_def` + `(U i).ι.appIso = Iso.refl`.

**Issue 2 (major): Step-4 approach for `dual_restrict_iso` underdescribed.**

The blueprint proof (lines 5547–5572) describes Step 4 as "Leg (A) — slice-site Hom base-change (Beck-Chevalley)" and "Leg (B) — ground-ring reconciliation via `restrictScalarsRingIsoDualEquiv`". The Lean implementation at lines 244–256 uses a different mechanism for the Leg (A) part: H1 via `pushforwardPushforwardAdj`∘`leftAdjointUniq` converts `pullback φ` to `pushforward β`. This H1 step is an adjunction-uniqueness argument — it's correct and related to Leg (A) — but the blueprint doesn't name or describe it. The Lean sorry then covers `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`, which subsumes both the domain-reindexing content of Leg (A) AND the ring-iso transport of Leg (B). A prover filling the sorry by following the blueprint's Leg (A) / Leg (B) description will encounter a mismatch: after H1, only the "pushforward β commutes with dual" residual remains, not the full Beck-Chevalley base-change the blueprint describes.

**Recommended blueprint action**: Update the Step-4 proof sketch for `lem:dual_restrict_iso` to describe the two-stage approach: first, H1 uses `pushforwardPushforwardAdj`∘`leftAdjointUniq` to rewrite `pullback φ` as `pushforward β`; then the residual `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)` is the sectionwise composite of the Beck-Chevalley domain comparison (Leg A) and the ring-iso transport via `restrictScalarsRingIsoDualEquiv` (Leg B). The current description implies a clean 2-leg decomposition where the Lean has a 3-step: H1 + Leg A residual + Leg B residual.

### Hint precision: **precise**
All five `\lean{...}` names match the Lean declarations exactly: `dual_restrict_iso`, `dual_unit_iso`, `dual_isLocallyTrivial`, `homLocalSection`, `homOfLocalCompat`. No wrong predicates.

### Generality: **matches need**
No parallel APIs outside blueprint scope.

### Recommended chapter-side actions (blueprint-writing subagent)

1. **Expand `homOfLocalCompat` sub-step (c)**: replace "mechanical" with a 3-bullet description: (c.i) M-leg via `Scheme.Modules.map_smul M` (closes cleanly), (c.ii) f-leg obstacle — `map_smul` over `restrictScalars 𝟙` action must be identified with native action via `ModuleCat.restrictScalars.smul_def` + `(U i).ι.appIso = Iso.refl`, (c.iii) N-leg via `Scheme.Modules.map_smul N` once bridge is in place.

2. **Update `dual_restrict_iso` Step-4 sketch**: add a named H1 sub-step (adjunction uniqueness `pushforwardPushforwardAdj`∘`leftAdjointUniq` rewrites pullback to pushforward), then describe the sorry residual as the "pushforward β commutes with dual" goal, which the original Legs (A)+(B) description covers but only after H1 has been applied.

---

## Severity Summary

| Finding | Severity |
|---|---|
| `dual_restrict_iso` sorry at line 256 (Step-4 presheaf residual) | Known open — not a surprise. Blueprint correctly tracks with `\leanok` on statement only. |
| `homOfLocalCompat` sorry at line 656 (f-leg smul bridge) | Known open — correctly tracked. |
| Blueprint sub-step (c) for `homOfLocalCompat` described as "mechanical" when it requires a non-trivial native↔`restrictScalars-𝟙` bridge | **major** — blueprint adequacy failure: proof sketch misleads prover about difficulty of sub-step (c) |
| Step-4 of `dual_restrict_iso`: blueprint's Leg (A)/(B) description doesn't match the Lean's H1 + residual structure | **major** — blueprint adequacy failure: proof sketch for Step-4 diverges from actual Lean approach |
| `homLocalSection` blueprint prose uses "localSection" while `\lean{}` uses "homLocalSection" | **minor** — naming drift between prose and code, no correctness impact |
| "TO CLOSE (next iter)" comment at line 651 | **minor** — informational TODO on a known sorry, not an excuse-comment for wrong logic |

**Overall verdict**: The Lean file is in a correct, transparently sorry-tracked state with no axioms or wrong definitions; the two sorries are known open obligations. The main gap is bidirectional: (1) the blueprint under-specifies `homOfLocalCompat` sub-step (c) as "mechanical" when the Lean shows it requires a native↔`restrictScalars-𝟙` smul bridge, and (2) the blueprint's Leg (A)/(B) description for `dual_restrict_iso` Step-4 doesn't match the Lean's H1 approach, which will mislead the prover filling that sorry. — 5 declarations checked, 0 must-fix red flags, 2 major blueprint adequacy findings.
