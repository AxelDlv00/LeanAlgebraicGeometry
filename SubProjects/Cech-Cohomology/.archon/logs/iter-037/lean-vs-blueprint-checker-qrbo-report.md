# Lean ↔ Blueprint Check Report

## Slug
qrbo

## Iteration
037

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (relevant zone: lines 3827–4235 Route B B1–B4, and lines 4437–4523 module-restrict-basicOpen cluster)

---

## Per-declaration

### `\lean{AlgebraicGeometry.specBasicOpen}` (chapter: `def:spec_basic_open`, line 4483)
- **Lean target exists**: yes (`abbrev specBasicOpen : (Spec R).Opens := PrimeSpectrum.basicOpen f`, line 87)
- **Signature matches**: yes — blueprint says "packaged as an object of (Spec R).Opens; it is PrimeSpectrum.basicOpen f"
- **Proof follows sketch**: N/A (abbrev, definitional)
- **notes**: Statement block has `\leanok`. Match is exact.

---

### `\lean{AlgebraicGeometry.specAwayToSpec}` (chapter: `lem:spec_away_to_spec`, line 4493)
- **Lean target exists**: yes (`noncomputable abbrev specAwayToSpec : Spec (CommRingCat.of (Localization.Away f)) ⟶ Spec R`, lines 92–93)
- **Signature matches**: yes — blueprint: "the composite of the inverse of basicOpenIsoSpecAway f with the open immersion of D(f)". Lean: `(basicOpenIsoSpecAway f).inv ≫ (specBasicOpen f).ι`
- **Proof follows sketch**: N/A (abbrev, definitional)
- **notes**: Statement block has `\leanok`. Match is exact.

---

### `\lean{AlgebraicGeometry.specAwayToSpec_eq}` (chapter: `lem:spec_away_to_spec_eq`, line 4507)
- **Lean target exists**: yes (`theorem specAwayToSpec_eq`, lines 118–121)
- **Signature matches**: yes — blueprint: "specAwayToSpec f = Spec.map(algebraMap R (R_f))". Lean: `specAwayToSpec f = Spec.map (CommRingCat.ofHom (algebraMap R (Localization.Away f)))`. The `CommRingCat.ofHom` wrapper is the correct Lean coercion for a bare ring map; the mathematical claim is identical.
- **Proof follows sketch**: yes — blueprint says "rewriting with Iso.inv_comp_eq reduces the claim to the defining property of basicOpenIsoSpecAway". Lean proof: `rw [specAwayToSpec, Iso.inv_comp_eq]` then `exact (IsOpenImmersion.isoOfRangeEq_hom_fac _ _ _).symm`. Faithfully follows the sketch.
- **notes**: Statement and proof blocks both have `\leanok`. No issues.

---

### `\lean{AlgebraicGeometry.modulesRestrictBasicOpen, AlgebraicGeometry.modulesRestrictBasicOpenIso}` (chapter: `lem:modules_restrict_basicOpen`, lines 4439–4440)
- **Lean target exists**: yes — both (`noncomputable def modulesRestrictBasicOpen`, lines 100–102; `noncomputable def modulesRestrictBasicOpenIso`, lines 109–113)
- **Signature matches**: yes
  - `modulesRestrictBasicOpen (F : (Spec R).Modules) : (Spec (CommRingCat.of (Localization.Away f))).Modules` — blueprint: "object F_{(f)} ∈ (Spec R_f).Modules". Match.
  - `modulesRestrictBasicOpenIso (F : (Spec R).Modules) : modulesRestrictBasicOpen f F ≅ (Scheme.Modules.pullback (specAwayToSpec f)).obj F` — blueprint: "isomorphism F|_{D(f)} ≅ F_{(f)} over the identification D(f) ≅ Spec R_f". Match: the pullback along `specAwayToSpec f` is exactly the transport along the iso that the blueprint describes.
- **Proof follows sketch**: yes — blueprint: "pulling F|_{D(f)} back along the inverse of the comparison transports it to F_{(f)}". Lean: `(F.restrict (specBasicOpen f).ι).restrict (basicOpenIsoSpecAway f).inv`, then the iso is `restrictFunctorComp.app F ≪≫ restrictFunctorIsoPullback.app F`. Mathematically identical.
- **notes**: The blueprint block does NOT yet carry `\leanok`. The embedded `% NOTE (review iter-035)` explains this correctly: both decls are axiom-clean but `sync_leanok` cannot see them because the root barrel (`AlgebraicJacobian.lean`) does not yet import `QcohRestrictBasicOpen.lean`. This is a tracking gap, not a quality issue with the Lean code.

---

### `\lean{AlgebraicGeometry.presentationOverBasicOpen}` (chapter: `lem:presentation_over_basicOpen`, lines 4082–4098)
- **Lean target exists**: yes (`noncomputable def presentationOverBasicOpen`, lines 129–149)
- **Signature matches**: yes — blueprint: "Let M be an O_{Spec R}-module, let U be open carrying a presentation of M.over U, and let g ∈ R with D(g) ⊆ U. Then M.over D(g) admits a presentation." Lean: `(M : (Spec R).Modules) (U : (Spec R).Opens) (P : (M.over U).Presentation) (g : R) (hg : specBasicOpen g ≤ U) : (M.over (specBasicOpen g)).Presentation`. Perfect match.
- **Proof follows sketch**: partial — the blueprint sketch says: "Transport the presentation of M.over U along the further over-restriction functor (a left adjoint) via `lem:presentation_map_mathlib` (`Presentation.map`)." The Lean proof does use `Presentation.map` (step `P.map (pushforward ...)`, line 142) but also:
  1. constructs an equivalence `e` via `pushforwardPushforwardEquivalence` (not named in B2's `\uses`),
  2. calls `P1.map e.inverse` using `Presentation.map` on the inverse of `e`,
  3. closes with `Presentation.ofIsIso.{u,u,u}` (also not in B2's `\uses`).
  The mathematical content is correct, but the blueprint's `\uses{lem:presentation_map_mathlib}` for the proof block omits `lem:pushforwardPushforwardEquivalence_mathlib` and `lem:presentation_ofIsIso_mathlib`, both of which the Lean proof materially uses.
- **notes**: `\leanok` present on both statement and proof blocks. The `set_option backward.isDefEq.respectTransparency false` in the Lean proof is a technical elaboration option, not a quality flag.

---

## Red flags

*(none found in the formalized code)*

### Placeholder / suspect bodies
None. Every declaration has a genuine proof or definition body with no `:= sorry`, `:= True`, or equivalent. The `presentationOverBasicOpen` body is a multi-step letI construction, not a placeholder.

### Excuse-comments
None.

### Axioms / Classical.choice on non-trivial claims
No `axiom` declarations. The file uses only standard Mathlib-backed constructions.

---

## Unreferenced declarations (informational)

The following four declarations have no corresponding `\lean{...}` block in the blueprint:

| Lean declaration | Line | Role |
|---|---|---|
| `Opens.overEquivalence_functor_coverPreserving` | 35 | theorem — forward functor of `overEquivalence U` is cover-preserving |
| `Opens.overEquivalence_inverse_coverPreserving` | 51 | theorem — inverse functor is cover-preserving |
| `Opens.overEquivalence_functor_isContinuous` | 68 | instance — forward functor is continuous |
| `Opens.overEquivalence_inverse_isContinuous` | 76 | instance — inverse functor is continuous |

These four close a Mathlib TODO (recorded in the Lean file's module docstring: Mathlib's `Opens.overEquivalence U` does not yet prove continuity of the two functors). They are substantive infrastructure, not internal helpers — they are the "gateway brick for the Route B restrict–over bridge B3" as stated in the Lean docstring. Their absence from the blueprint is a **Lean → blueprint coverage gap**.

---

## Blueprint adequacy for this file

- **Coverage**: 6 of 10 Lean declarations have a corresponding `\lean{...}` block (counting the joint `modulesRestrictBasicOpen` / `modulesRestrictBasicOpenIso` pin as two). 4 unreferenced declarations are the `overEquivalence` continuity quartet — not internal helpers but substantive Mathlib infra closes.

- **Proof-sketch depth**: **under-specified** in two respects:

  1. **B2 (`lem:presentation_over_basicOpen`) proof `\uses` is incomplete.** The proof block cites only `\uses{lem:presentation_map_mathlib}`. The Lean proof materially uses `SheafOfModules.pushforwardPushforwardEquivalence` (= `lem:pushforwardPushforwardEquivalence_mathlib`) to build the equivalence `e`, and `SheafOfModules.Presentation.ofIsIso` (= `lem:presentation_ofIsIso_mathlib`) to close the iso transport step. A prover following only the blueprint sketch might try a simpler direct `Presentation.map` call and run into universe / transparency issues without the equivalence scaffold. The missing `\uses` entries are **not** a Lean quality issue but they do make the blueprint sketch misleading about the proof's actual dependency structure.

  2. **B3 (`lem:restrict_over_compat`) proof sketch does not capture the B3a/B3b/B3c sub-structure the next prover will need.** The blueprint gives a correct high-level description (over-picture ≅ affine restriction via the `Opens.over D(g) ≃ Opens(Spec R_g)` site equivalence), but the actual formalization obstruction (recorded in the project memory from iter-035) is the construction of the site-equivalence compat via `(specBasicOpen g).ι.appIso`. The blueprint does not hint at this decomposition. Since B3 is the single remaining to-build obligation gating B4, the next prover will effectively need to rediscover this structure from scratch. This is a **major** blueprint adequacy failure for B3.

- **Hint precision**: **precise** for all formalized declarations. The `\lean{...}` names match the Lean namespace and declaration name exactly in every case checked.

- **Generality**: **matches need** for formalized declarations. No parallel APIs were written; the existing Lean code matches what the blueprint prescribes.

- **Recommended chapter-side actions** (for a blueprint-writing subagent):

  1. **Add an infra block for the `overEquivalence` continuity quartet** in the Route B Mathlib-anchor section (around line 3912). Proposed label: something like `lem:overEquivalence_isContinuous_mathlib` (marked `\mathlibok` even though it's project-local, since it closes a Mathlib TODO). Add `\lean{AlgebraicGeometry.Opens.overEquivalence_functor_coverPreserving, AlgebraicGeometry.Opens.overEquivalence_inverse_coverPreserving, AlgebraicGeometry.Opens.overEquivalence_functor_isContinuous, AlgebraicGeometry.Opens.overEquivalence_inverse_isContinuous}`. Thread this into B3's `\uses` chain so it is visible to the prover.

  2. **Extend B2 proof block's `\uses`** to include `lem:pushforwardPushforwardEquivalence_mathlib` and `lem:presentation_ofIsIso_mathlib`. Optionally expand the proof sketch to describe the two-step: first build the equivalence `e : SheafOfModules(ringCatSheaf.over D(g)) ≌ SheafOfModules((ringCatSheaf.over U).over W)` via `pushforwardPushforwardEquivalence`, then transport the presentation through `e.inverse` and close with `Presentation.ofIsIso`.

  3. **Expand B3 proof sketch** with the decomposition the prover will need:
     - B3a: identify the structure-sheaf component `(ringCatSheaf.over D(g))` with `(ringCatSheaf.over U).over W` via `(specBasicOpen g).ι.appIso` or equivalent.
     - B3b: invoke `pushforwardPushforwardEquivalence` to get the sheaves-of-modules equivalence.
     - B3c: check the object correspondence sends `F.over D(g)` to `modulesRestrictBasicOpen g F` by the definitional equality of `restrict_obj_mathlib`.
     Add `\uses{lem:overEquivalence_isContinuous_mathlib}` (once the infra block is added).

  4. **Wire root import** (`AlgebraicJacobian.lean` importing `QcohRestrictBasicOpen.lean`) so that `sync_leanok` can set `\leanok` on `lem:modules_restrict_basicOpen`. (This is a planner task, not a blueprint prose task, but the NOTE comment in the blueprint should be cleared once done.)

---

## Severity summary

- **must-fix-this-iter**: None. All formalized declarations have correct statements, genuine proofs, no sorries, and no excuse-comments.

- **major** (3 findings):
  1. **Lean → blueprint gap**: the four `Opens.overEquivalence_*` continuity declarations are substantive and unreferenced in the blueprint. The blueprint needs an infra block for them, and B3's `\uses` should thread them in.
  2. **Blueprint → Lean**: B2 proof block's `\uses` is missing `lem:pushforwardPushforwardEquivalence_mathlib` and `lem:presentation_ofIsIso_mathlib`. A prover following the B2 sketch will be surprised by the equivalence scaffold requirement.
  3. **Blueprint → Lean**: B3 proof sketch does not describe the B3a/B3b/B3c decomposition (via `ι.appIso`). Since B3 is the sole remaining to-build gate for B4, this under-specification will slow the next prover materially.

- **minor** (1 finding):
  1. `lem:modules_restrict_basicOpen` is missing `\leanok`. This is a known sync_leanok propagation delay (root import not yet wired). The embedded NOTE is accurate and self-explanatory; no immediate action needed beyond wiring the import.

**Overall verdict**: The Lean file is clean — all formalized declarations faithfully realize their blueprint statements and proofs, with no placeholder or quality issues — but the blueprint has three major adequacy gaps: missing infra block for the `overEquivalence` continuity quartet (Lean → blueprint coverage debt), incomplete `\uses` in B2's proof block, and insufficient decomposition detail in B3's proof sketch for the next prover.
