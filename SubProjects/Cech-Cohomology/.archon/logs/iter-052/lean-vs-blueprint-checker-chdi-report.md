# Lean ↔ Blueprint Check Report

## Slug
chdi

## Iteration
052

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.CechNerve}` (chapter: `def:cech_nerve`)
- **Lean target exists**: yes (`CechNerve`, line 599)
- **Signature matches**: yes — augmented cosimplicial `O_X`-module built from `coverCechNerveOverAug` and `pushPullFunctor F`, matching the informal description of the degree-`p` product over `(p+1)`-fold intersections
- **Proof follows sketch**: N/A (definition)
- **notes**: correctly constructed axiom-clean; augmentation point is `(𝟙 X)_* (𝟙 X)^* F` (identified with `F` via `cechNervePointIso`)

### `\lean{AlgebraicGeometry.CechComplex}` (chapter: `def:cech_complex`)
- **Lean target exists**: yes (`CechComplex`, line 638)
- **Signature matches**: yes — `CochainComplex S.Modules ℕ` from `f`, `𝒰`, `F`, via `relativeCechComplexOfNerve`
- **Proof follows sketch**: N/A (definition)
- **notes**: axiom-clean; definitionally folds through `relativeCechComplexOfNerve (CechNerve 𝒰 F)`

### `\lean{AlgebraicGeometry.coverArrow}` (chapter: `def:cover_arrow`)
- **Lean target exists**: yes (line 103)
- **Signature matches**: yes
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.coverCechNerve, coverCechNerveOver, coverCechNerveOverAug}` (chapter: `def:cover_cech_nerve`)
- **Lean target exists**: yes (lines 111, 552, 561)
- **Signature matches**: yes — augmented simplicial scheme objects
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.pushPullObj}` (chapter: `def:push_pull_obj`)
- **Lean target exists**: yes (line 135)
- **Signature matches**: yes
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.pushPullMap, rawPushPullMap, pushPullMap_eq_raw, rawPushPullMap_self, rawPushPullMap_self_gen, pushforwardComp_hom_app_id, pushPull_unit_comp}` (chapter: `def:push_pull_map`)
- **Lean target exists**: yes (lines 147, 326, 343, 356, 373, 314, 295)
- **Signature matches**: yes — five-step composite matching blueprint prose exactly
- **Proof follows sketch**: N/A (definitions) / yes for the lemma versions

### `\lean{AlgebraicGeometry.pushPullMap_id}` (chapter: `lem:push_pull_id`)
- **Lean target exists**: yes (line 174)
- **Signature matches**: yes
- **Proof follows sketch**: yes — right-unitality of pseudofunctor + unit-triangle identity

### `\lean{AlgebraicGeometry.pushPullMap_comp, rawPushPullMap_comp, pushPull_pentagon}` (chapter: `lem:push_pull_comp`)
- **Lean target exists**: yes (lines 528, 437, 392)
- **Signature matches**: yes
- **Proof follows sketch**: yes — mate-calculus decomposition of composite unit + pseudofunctor pentagon + over-triangle cancellation

### `\lean{AlgebraicGeometry.pushPull_unit_mate}` (chapter: `lem:push_pull_unit_mate`)
- **Lean target exists**: yes (line 241)
- **Signature matches**: yes — correct conjugate-mate identity
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.pushPull_transport_cancel}` (chapter: `lem:push_pull_transport_cancel`)
- **Lean target exists**: yes (line 274)
- **Signature matches**: yes
- **Proof follows sketch**: yes — subst + simp

### `\lean{AlgebraicGeometry.pushPullFunctor}` (chapter: `def:push_pull_functor`)
- **Lean target exists**: yes (line 541)
- **Signature matches**: yes — `(Over X)ᵒᵖ ⥤ X.Modules`
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.cechNerveCosimplicial}` (chapter: `def:cech_nerve_cosimplicial`)
- **Lean target exists**: yes (line 571)
- **Signature matches**: yes
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.relativeCechComplexOfNerve}` (chapter: `def:relative_cech_complex_of_nerve`)
- **Lean target exists**: yes (line 613)
- **Signature matches**: yes
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.cechComplexOnX}` (chapter: corresponding definition ~line 7047)
- **Lean target exists**: yes (line 667)
- **Signature matches**: yes
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.cechNervePointIso}` (chapter: ~line 7068)
- **Lean target exists**: yes (line 676)
- **Signature matches**: yes — `(CechNerve 𝒰 F).left ≅ F` via pushforwardId ≪≫ pullbackId
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.cechAugmentation}` (chapter: ~line 7086)
- **Lean target exists**: yes (line 686)
- **Signature matches**: yes — `F ⟶ (cechComplexOnX 𝒰 F).X 0`
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.cechAugmentation_comp_d, augmentation_comp_alternatingCofaceMap_objD_zero}` (chapter: `lem:cech_augmentation_comp_d`)
- **Lean target exists**: yes (lines 727, 697)
- **Signature matches**: yes
- **Proof follows sketch**: yes — cosimplicial augmentation identity via naturality

### `\lean{AlgebraicGeometry.cechAugmentedComplex}` (chapter: `def:cech_augmented_complex`)
- **Lean target exists**: yes (line 745)
- **Signature matches**: yes
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.cechAugmented_exact}` (chapter: `lem:cech_augmented_resolution`)
- **Lean target exists**: **NO** — declaration is absent from `CechHigherDirectImage.lean` and from the entire project
- **Signature matches**: N/A (declaration does not exist)
- **Proof follows sketch**: N/A
- **notes**: Prover reported a hard structural blocker: all proof ingredients (`homologyIsoSheafify`, `sectionCech_affine_vanishing`, `sectionCech_homology_exact_of_localizationAway`, `sectionCechComplex`, `affineCoverSystem`, `qcoh_iso_tilde_sections`) live in files that transitively import `CechHigherDirectImage.lean`, making a back-import cyclic. A blueprint `% NOTE:` at line 7142–7148 already acknowledges this and flags that `cechAugmented_exact` is not yet proved, but provides no resolution. The recommended action is to relocate `cechAugmented_exact` to a downstream file once the import graph permits it. The `\lean{}` pin must then be updated to the new location; the declaration name is frozen by `archon-protected.yaml`.

### `\lean{AlgebraicGeometry.cech_computes_higherDirectImage}` (chapter: `lem:cech_computes_cohomology`)
- **Lean target exists**: yes (line 773, frozen protected signature)
- **Signature matches**: yes — `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` under `[HasInjectiveResolutions X.Modules]`, matching the blueprint's "Nonempty" / existence form
- **Proof follows sketch**: N/A — body is `:= sorry`, known-intentional frozen sorry per directive; not flagged
- **notes**: Pre-existing frozen sorry; acknowledged by directive; downstream of the `cechAugmented_exact` blocker

---

## Red flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.cechAugmented_exact`: blueprint `lem:cech_augmented_resolution` pins this declaration via `\lean{AlgebraicGeometry.cechAugmented_exact}`, but the declaration does **not exist** anywhere in `CechHigherDirectImage.lean`. The blueprint claims a substantive theorem (exactness of the augmented Čech complex); the Lean file has neither a proof nor a sorry placeholder. This is more severe than a sorry: the declaration is entirely absent. Root cause is a confirmed import cycle, not mathematical failure.
  - **Note**: the frozen sorry at line 780 (`cech_computes_higherDirectImage`) is separate, known, and intentional — not reported here per directive.

---

## Unreferenced declarations (informational)

The following three declarations in `CategoryTheory.GrothendieckTopology` (lines 811–847) appear in `CechHigherDirectImage.lean` but have **no `\lean{...}` reference** anywhere in the blueprint chapter:

1. `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_obj_of_W` (line 811)
   — If `J.W f` and `sheafify(Q)` is zero, then `sheafify(P)` is zero.

2. `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_obj_of_W_isZero` (line 825)
   — If `f : P → Q` is a `J.W`-equivalence and `Q` is objectwise zero, then `sheafify(P)` is zero.

3. `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_obj_of_isLocallyBijective` (line 840)
   — Concrete version: locally bijective map to an objectwise-zero presheaf implies `sheafify(P)` is zero.

**Assessment of mathematical content vs. blueprint**: These three lemmas faithfully formalize the sheafification portion of Step 3 of the `lem:cech_augmented_resolution` proof sketch (blueprint lines 7235–7237: "a map of sheaves is an isomorphism if and only if it is locally bijective, and sheafification carries a locally bijective map to an isomorphism; hence the sheafification of the presheaf homology is the zero sheaf"). The formalizations are correct and well-placed in the upstream file to avoid import cycles. They belong to Step 3 more precisely than Step 2 (Step 2 concerns `homologyIsoSheafify`; Step 3 is the "locally bijective to zero ⇒ sheafification is zero" argument). The directive's label "Step-2 lemmas" reflects the prover's terminology for the combined Steps 2–3 of the sheafification route.

**Architectural placement**: The module-level comment at Lean lines 784–800 correctly explains why these pure-Mathlib site-theory lemmas are placed in `CechHigherDirectImage.lean` (the most upstream Cohomology file) rather than downstream: it is precisely so that `cechAugmented_exact` (in a future downstream file) can import them without cycles. This is architecturally sound.

**Blueprint gap**: Despite being substantive project-contributed declarations that are not mere tactic helpers, none of the three has a `\lean{...}` blueprint block. The blueprint's `lem:cech_augmented_resolution` proof prose alludes to them indirectly but does not pin them. A blueprint-writing subagent should add three dedicated blocks.

---

## Blueprint adequacy for this file

- **Coverage**: 30 Lean declarations have a corresponding `\lean{...}` block in the chapter. 1 declaration that the blueprint explicitly pins (`cechAugmented_exact`) is absent from the Lean file (not an unreferenced helper — a missing target). 3 unreferenced substantive declarations (`isZero_presheafToSheaf_obj_of_W*`) need blueprint blocks.

- **Proof-sketch depth**: **under-specified** on one critical point — file placement and import-cycle constraints. The `lem:cech_augmented_resolution` proof sketch at lines 7201–7255 correctly describes the mathematical steps (Steps 1–4 via sections and sheafification), but does NOT indicate that the declared Lean target must live in a file downstream of all files that the proof ingredients live in. The blueprint presents the four steps as if all ingredients are available in the same file, but `PresheafOfModules.homologyIsoSheafify`, `sectionCech_affine_vanishing`, and `sectionCech_homology_exact_of_localizationAway` all live in files that import `CechHigherDirectImage.lean`. No blueprint prose flags this dependency structure.

- **Hint precision**: **loose** for `lem:cech_augmented_resolution` specifically. The `\lean{AlgebraicGeometry.cechAugmented_exact}` pin correctly names the target (matching the frozen protected signature name in `archon-protected.yaml`), but the hint does not say *which file* will host it. After relocation, the `\lean{...}` pin needs a file update (the `% archon:covers` header at line 3 of the tex chapter should include the receiving file).

- **Generality**: **matches need** — no parallel API was written to compensate for blueprint under-specification. The three site-theory lemmas are additions *beyond* what the blueprint specifies, not substitutes for a blueprint-specified API.

- **Recommended chapter-side actions** (for a blueprint-writing subagent):
  1. Add three new `\begin{lemma}...\end{lemma}` blocks with `\lean{CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_obj_of_W}`, `\lean{...isZero_presheafToSheaf_obj_of_W_isZero}`, and `\lean{...isZero_presheafToSheaf_obj_of_isLocallyBijective}` — these are the reusable Step-3 engines of the resolution proof.
  2. Add a `% NOTE:` or `\begin{remark}` to `lem:cech_augmented_resolution` explaining the import-cycle constraint and documenting that `cechAugmented_exact` must be placed in a file downstream of `CechBridge.lean` / `PresheafCech.lean` (whichever is the most upstream file that imports `CechHigherDirectImage.lean` and provides all proof ingredients).
  3. Once `cechAugmented_exact` is placed in a downstream file, update the `\lean{AlgebraicGeometry.cechAugmented_exact}` pin's `% archon:covers` entry and/or the chapter header to include the new file.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `AlgebraicGeometry.cechAugmented_exact` absent from the Lean file; `\lean{}` pin in `lem:cech_augmented_resolution` is dangling | **must-fix-this-iter** |
| No `\lean{...}` blueprint blocks for the 3 site-theory lemmas (`isZero_presheafToSheaf_obj_of_W*`) | **major** |
| Blueprint proof sketch for `lem:cech_augmented_resolution` does not account for import-cycle / file-placement constraint; `\lean{}` pin will need a file update after relocation | **major** |
| Three site-theory lemmas correctly formalize Step-3 content and are correctly placed upstream | (positive finding, no severity) |
| All other `\lean{...}`-pinned declarations exist, have matching signatures, and follow the proof sketch | (clean) |

**Overall verdict**: One must-fix-this-iter finding (missing `cechAugmented_exact`, import-cycle blocker) and two major blueprint-adequacy gaps (missing blocks for 3 site-theory lemmas, no import-cycle guidance); all other checked declarations are clean.
