# Analogy: Do the object-iso-conjugated bridges transport pentagon/triangle/hexagon to close the 6 SNAP coherences?

## Mode
api-alignment

## Slug
snap-bridge-api

## Iteration
007

## Question
Given the hand-built sheaf structural isos bridged as `hand_iso = i.symm ≪≫ loc_iso ≪≫ i`
(`i = tensorObjLocalizedIso = μ⁻¹ ≫ counit`), can `MonoidalCategory.{pentagon,triangle}` /
`BraidedCategory.hexagon` be transported through these bridges to close `tensorPowAdd_{assoc,
rightUnit-succ,braiding-succ}`, the pentagon base/succ, and `sectionMul_assoc_core` WITHOUT a new
round of wrapper lemmas? Name the precise transport-lemma shape, or flag the mismatch.

## Project artifact(s)
- `SectionGradedRing.lean:1462` — `tensorObjLocalizedIso` (`i = μ⁻¹ ≫ (c_F ⊗ c_G)`).
- `SectionGradedRing.lean:1651` — `tensorBraiding_eq_localizedBraiding` (the ONLY bridge that exists).
- `SectionGradedRing.lean:1317` — `tensorObjAssoc`, hand-built as an explicit 5-segment composite
  (inverse whiskered-unit, `(α_p)^#`, two `(β_p)^#`, whiskered-unit), μ-laden.
- `SectionGradedRing.lean:1852,1926` — `unitor_sectionsMul`, `sectionMul_braiding_core` (the two
  section-level η-cores already CLOSED; the template for `sectionMul_assoc_core`).
- Sorries: 2019 `sectionMul_assoc_core`; 2089 `tensorPowAdd_rightUnit` succ; 2111
  `tensorPowAdd_braiding` succ; 2126/2129 `tensorPowAdd_assoc` base/succ; 2189 `sectionsMul_mul_assoc`.

## Premise correction (load-bearing)
The directive states "all four bridge lemmas proved sorry-free." **False.** Only
`tensorBraiding_eq_localizedBraiding` (1651) exists. `tensorObjAssoc_eq_localizedAssociator`,
`tensorObjUnitor_eq_localized`, `tensorObjRightUnitor_eq_localized` are **absent** from the file
(grep: zero hits for `_eq_localized*` other than the braiding one). Consequently NO iso-level
coherence can be transported next iter — three of the bridges it would rewrite through don't exist.

## Decisions identified

### Decision: per-iso conjugation bridges vs `CategoryTheory.Monoidal.transport`
- **Mathlib idiom**: `CategoryTheory.Monoidal.transport (e : C ≌ D) : MonoidalCategory D`
  (`Mathlib.CategoryTheory.Monoidal.Transport`). This is the canonical machine for "structure M on
  one category ⇒ the object-iso-conjugated structure on the equivalent category, with
  pentagon/triangle/hexagon proved ONCE." It DEFINES the transported associator/unitors as the
  conjugates and discharges coherence generically, **handling whiskering compatibility internally**
  through the equivalence's functoriality.
- **Project path**: hand-build each structural iso with a bespoke presheaf-descent formula, then
  prove a per-iso conjugation bridge, then transport each LAW separately.
- **Gap**: divergent-with-cost. The project's bridge API is a hand-rolled, *partial* re-implementation
  of `transport` that omits the whiskering layer (see next decision).
- **Cost**: full alignment is correctly rejected — registering `MonoidalCategory X.Modules` risks the
  instance clash flagged in ARCHON_MEMORY, and `tensorObj` is not defeq to `transport`'s tensorObj —
  so the recurring whiskering bridges are the price of staying hand-rolled.
- **Verdict**: DIVERGE_INTENTIONALLY on the *structure* (don't adopt `transport`), but the divergence
  obliges the explicit whiskering bricks below.

### Decision: the bridge set is missing the WHISKERING layer (the actual mismatch)
- **Mathlib idiom**: `MonoidalCategory.pentagon` (`Mathlib.CategoryTheory.Monoidal.Category`) is
  `(α_ W X Y).hom ▷ Z ≫ (α_ W (X⊗Y) Z).hom ≫ W ◁ (α_ X Y Z).hom = (α_ (W⊗X) Y Z).hom ≫ (α_ W X (Y⊗Z)).hom`
  — stated in **whiskerings** `▷`/`◁`. Same for `triangle` and `hexagon_forward/reverse`.
- **Project path**: the bridges relate the structural isos (`tensorObjAssoc`, braiding, unitors) but
  say NOTHING about `tensorObjWhiskerRightIso`/`tensorObjWhiskerLeftIso`. Rewriting a hand-built
  coherence through the bridges leaves whiskered hand-built isos `(tensorObjAssoc).hom ▷ C` that do
  NOT match `(α^loc).hom ▷_loc C` without a whiskering-compatibility bridge.
- **Gap**: divergent-with-cost — the transport literally cannot proceed past the first whiskered term.
- **Cost (concrete)**: to close ANY of 2089/2111/2126/2129 the prover must first build a CLOSED set
  of 5 bridges — none open-ended, each a clone of the working `tensorBraiding_eq_localizedBraiding`:
    1. `tensorObjAssoc_eq_localizedAssociator` — via `Localization.Monoidal.associator_hom_app`
       (verified: localized α = `(μ ⊗ 𝟙) ≫ μ ≫ L'(α_p) ≫ μ⁻¹ ≫ (𝟙 ⊗ μ⁻¹)`) + μ-cancellation.
    2. `tensorObjUnitor_eq_localized` — via `leftUnitor_hom_app`.
    3. `tensorObjRightUnitor_eq_localized` — FREE: `tensorObjRightUnitor := tensorBraiding ≪≫
       tensorObjUnitIso`, so compose bridges (1)+(2)+existing braiding bridge; no new μ-work.
    4. `tensorObjWhiskerRight_eq_loc` — via `Localization.Monoidal.μ_natural_left` (verified:
       `(L'.map f ▷ L'Y) ≫ μ = μ ≫ L'.map(f ▷ Y)`).
    5. `tensorObjWhiskerLeft_eq_loc` — via `μ_natural_right`.
- **Verdict**: NEEDS_MATHLIB_GAP_FILL — these 5 must be built; the set is finite and bounded, not churn.

### Decision: which sorry closes THIS iter with NO bridge at all
- **Mathlib idiom**: `Adjunction.homEquiv_unit`/`homEquiv_counit` triangle trick (already used in
  `unitor_sectionsMul`).
- **Project path**: `sectionMul_assoc_core` (2019) is a section-level (`Γ` at `⊤`) statement,
  INDEPENDENT of the iso-level bridges. It reduces — exactly like the CLOSED `unitor_sectionsMul`
  (1852) and `sectionMul_braiding_core` (1926) — to η-naturality against the EXPLICIT 5-segment def of
  `tensorObjAssoc` (1317): segments 2/3/5 are pure `sheafification.mapIso` → η-naturality
  (`sectionMul_braiding_core` pattern); segments 1/4 are whiskered-unit comparison isos
  `asIso(sheafification.map(η ▷ -))` → "act trivially on η-image" via the SAME `homEquiv_unit/counit`
  triangle that closed `unitor_sectionsMul`.
- **Gap**: identical to the two proven cores — no new API.
- **Verdict**: PROCEED — closeable next iter without any synonym/bridge.

## The conflation the planner must break
The directive folds two DIFFERENT obstacles into "comparison-iso-acts-trivially":
- ISO level (`tensorPowAdd_*`): the comparison `i`'s **telescope formally** (`i ≪≫ i.symm = 𝟙`,
  exactly the `key`/`hom_inv_id_assoc` cancellation already done inside the braiding bridge). There is
  NO "acts trivially" step here — the only obstacle is the MISSING whiskering bridges (4)/(5).
- SECTION level (`sectionMul_assoc_core`): "acts trivially on η-image" is genuine, but it is the
  solved `unitor_sectionsMul` triangle pattern, NOT the iso-transport obstacle.
Keeping these separate is what unblocks the route; conflating them is what produced CHURNING.

## Recommendation
The bridge↔law transport DOES compose in principle, but the bridge set as scoped (and as falsely
assumed complete in the directive) lacks the whiskering layer, so it forces ~5 wrapper lemmas before
ANY iso-coherence closes — the churn pc007 saw. Split the work:
(B, this iter) Dispatch the prover at `sectionMul_assoc_core` (2019) via the in-file section-η
template (`unitor_sectionsMul` + `sectionMul_braiding_core`, peeling `tensorObjAssoc`'s 5 segments).
NO bridges. This is the genuine "closed a coherence" deliverable.
(A, framed honestly) Land the CLOSED set of 5 bridges (3 structural + 2 whiskering) as an explicit
"build the bridge layer" deliverable — NOT as "close a coherence." Each is a clone of
`tensorBraiding_eq_localizedBraiding`; bricks `associator_hom_app`, `leftUnitor_hom_app`,
`μ_natural_left`, `μ_natural_right` all verified present. Once they exist, 2089/2111/2126/2129 close
mechanically: `rw` all bridges → `Iso.ext` → telescope `i`'s → `exact pentagon/triangle/
hexagon_forward`. Then 2189 (`sectionsMul_mul_assoc`) needs only 2019 + `tensorPowAdd_assoc` + the
two `sectionsMul`-whiskering naturalities (themselves η-naturality of `sectionsMul` against
`μ_natural_left/right`, same template).
