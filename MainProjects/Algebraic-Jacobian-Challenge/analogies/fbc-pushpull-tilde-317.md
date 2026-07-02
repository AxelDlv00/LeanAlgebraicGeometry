# Analogy: the `pushPullObj F Yₙ ≅ tilde Mₙ` abstract→affine bridge for the FBC leaves

## Mode
api-alignment

## Slug
fbc-bridge317

## Iteration
317

## Question
For the Čech flat-base-change leaves (Stacks 02KG/02KH, SEPARATED case), which pieces of the
abstract→affine identification `pushPullObj F Yₙ ≅ tilde Mₙ` does Mathlib / the existing project
01I8 infrastructure already provide, and is the bridge a thin assembly or a genuine
multi-hundred-LOC development?

## Project artifact(s)
- `CechHigherDirectImageUnconditional.lean:346` `cech_pushforward_baseChange_natIso` — leaf 1, `app n` sorry.
- `CechHigherDirectImageUnconditional.lean:399` `twisted_cech_nerve_iso` — leaf 2, `app n` sorry.
- `CechHigherDirectImageUnconditional.lean:317` `cech_degree_affine_baseChange` — sorry-free shared brick (delegates to `affinePushforwardPullbackBaseChange`).
- `FlatBaseChange.lean:798` `affinePushforwardPullbackBaseChange` — sorry-free affine NON-mate base change.
- `QcohTildeSections.lean:66/75` `qcoh_iso_tilde_sections{,_of_presentation}` — conditional 01I8 vehicle.
- `QcohTildeSections.lean:1362` `qcoh_section_isLocalizedModule` — **sorry-free** Route-B 01I8 keystone (= Mathlib `IsLocalizing` for QC `F`).
- `QcohRestrictBasicOpen.lean:101/110` `modulesRestrictBasicOpen{,Iso}` — restriction-to-affine-basic-open infra.
- `CechHigherDirectImage.lean:145` `pushPullObj F Y := (pushforward Y.hom).obj ((pullback Y.hom).obj F)`.

## Key environment fact
Project pin is now **`leanprover/lean4:v4.31.0`** (mathlib `fabf563`, rev `v4.31.0`), i.e. the
v4.31.0 migration **has landed**. This is PAST 2026-05-31 / PR #37189, so the whole `IsLocalizing`
chain that iter-240 (`fbc-qc.md`) flagged as the desired bump target is now present in Mathlib.

## Decisions identified

### Decision 1 (sub-Q1): 01I8 affine structure theorem (Serre)
- **Mathlib idiom**: counit-iso / essential-image, NOT a packaged category equivalence. Provided in
  `Mathlib/AlgebraicGeometry/Modules/Tilde.lean`:
  - `Scheme.Modules.fromTildeΓ` (:249) — counit `tilde(Γ F) ⟶ F`.
  - `isIso_fromTildeΓ_iff` (:396) — `IsIso fromTildeΓ ↔ (tilde.functor R).essImage F`.
  - `isIso_fromTildeΓ_of_presentation` (:454).
  - `IsLocalizing` (:474), `isLocalizing_tilde` (:499), **`isIso_fromTildeΓ_iff_isLocalizing` (:513)** ← NEW in v4.31.0.
  - `tilde.adjunction` (:335), `tilde.fullyFaithfulFunctor` (:368).
  - **NO** packaged `QCoh(Spec R) ≃ ModuleCat R` equivalence; the project's `qcoh_iso_tilde_sections`
    (= `(asIso fromTildeΓ).symm`) IS the Mathlib-aligned object.
  - The **unconditional** `[IsQuasicoherent F] → IsIso fromTildeΓ` is **NOT** in Mathlib — explicit
    `TODO` comment in Tilde.lean (~:575: "Once `IsIso M.fromTildeΓ` is shown to be equivalent to `M`
    being quasicoherent…").
- **Project's path**: `qcoh_iso_tilde_sections` (conditional on `IsIso fromTildeΓ`) + the Route-B
  keystone `qcoh_section_isLocalizedModule` which is **already sorry-free** and proves exactly
  Mathlib's `IsLocalizing (modulesSpecToSheaf.obj F)` for quasi-coherent `F` (per-`f`
  `IsLocalizedModule (powers f) (F.presheaf.map (basicOpen f ≤ ⊤).op).hom`).
- **Gap**: project-already-has (nearly complete). The unconditional instance is **NOT yet wired**,
  but the wiring is now ~2 lines: `isIso_fromTildeΓ_iff_isLocalizing.mpr (fun f => qcoh_section_isLocalizedModule F f)`
  (modulo a `.presheaf`/`.obj` + `.leTop`/`homOfLE le_top` defeq nudge). Newly enabled by v4.31.0.
- **Verdict**: ALIGN_WITH_MATHLIB — wire the unconditional 01I8 instance now; reuse
  `qcoh_iso_tilde_sections` as the bridge vehicle (no parallel API; it is the Mathlib idiom).

### Decision 2 (sub-Q2): quasi-coherence preserved by pushforward + pullback
- **Affine pushforward (`Spec.map φ`)**: Mathlib-provides —
  `isLocalizing_pushforward_of_isLocalizing` (Tilde.lean:537), `isIso_fromTildeΓ_pushforward` (:577),
  `pushforwardCompModulesSpecToSheafIso` (:524). This is the only pushforward direction the
  separated-affine-cover route needs (each `f∘pₙ : Yₙ=Spec A → S=Spec R` is `Spec.map`).
- **Pullback (any morphism)**: Mathlib has the **machinery** but no packaged instance —
  `Presentation.map` (`Mathlib/Algebra/Category/ModuleCat/Sheaf/Quasicoherent.lean:180`) transports a
  presentation along any `PreservesColimitsOfSize` functor with `F.obj(unit)≅unit`.
  `Scheme.Modules.pullback` is a left adjoint (preserves colimits) and `pullback(unit)≅unit`, so
  pullback-preserves-QC is a **thin ~15-LOC build**, OR reuse the project's restriction infra
  (`modulesRestrictBasicOpenIso`, `QcohRestrictBasicOpen.overEquivalence_*`).
- **General separated-qc (non-affine) pushforward**: Mathlib-absent — but **NOT needed** for the
  separated route (degreewise everything is `Spec.map`).
- **Verdict**: pushforward affine = Mathlib-provides; pullback-QC = genuine-gap-but-cheap (thin).

### Decision 3 (sub-Q3): fibre powers of an affine cover of a separated scheme are affine
- **Mathlib idiom**: `IsAffineOpen.inf` / `IsAffineOpen.iInf` / `IsAffineOpen.biInf`
  (`Mathlib/AlgebraicGeometry/Morphisms/Affine.lean:327/333/338`), hypothesis
  `[IsAffineHom (pullback.diagonal (terminal.from X))]` ("in particular when `X` is separated").
  Also `diagonal_isAffine_iff_forall_isAffineOpen_inf` (:291), `isAffineHom_diagonal_iff` (:311).
- For an **open-immersion affine cover** the `(n+1)`-fold fibre powers `Yₙ` are the finite
  intersections `U_{i₀} ⊓ ⋯ ⊓ U_{iₙ}`, affine by `IsAffineOpen.biInf`. Separatedness ⟹ affine
  diagonal ⟹ the instance.
- **Verdict**: Mathlib-provides (fully).

### Decision 4 (sub-Q4): Beck–Chevalley / non-mate QCoh base change
- **General QCoh pushforward base-change iso** (`g^*(f_*M) ≅ f'_*(g'^*M)` over a cartesian square):
  Mathlib-ABSENT (confirmed iter-304; empty search). The only canonical map is the adjoint **mate**
  `pushforwardBaseChangeMap` whose `IsIso` is FORBIDDEN (FBC-B wall, ~30 iters).
- **Project's NON-mate affine brick**: `affinePushforwardPullbackBaseChange` (FlatBaseChange.lean:798)
  — **sorry-free**, built from the concrete tilde dictionaries `pushforward_spec_tilde_iso` /
  `pullback_spec_tilde_iso` + `TensorProduct.AlgebraTensorModule.cancelBaseChange`. Exactly the
  mate-free route the standing directive prefers. Consumed by the sorry-free
  `cech_degree_affine_baseChange`.
- **Verdict**: project-already-has the affine non-mate iso; the general sheaf-level iso is a genuine
  gap that the **separated/degreewise** route correctly **avoids** (never forms the mate).

## Recommendation
**PROCEED with the separated-case route; the bridge is a THIN ASSEMBLY, not a multi-hundred-LOC
gap.** Both genuinely-hard ingredients are already sorry-free in the project — the 01I8
section-localization keystone `qcoh_section_isLocalizedModule` and the affine non-mate base-change
brick `affinePushforwardPullbackBaseChange`. What remains is (i) **signature strengthening** of the
two leaves with `[IsSeparated f]` + an affine open-immersion cover (architectural, the planner's
option (a)); (ii) **mechanical altitude plumbing** (`IsAffineOpen.isoSpec` / `arrowIsoSpecΓOfIsAffine`
to present `f∘pₙ` as `Spec.map`, `pushforwardComp` to collapse `f_* ∘ pₙ_*`, `eqToHom` transports);
(iii) **wiring the unconditional 01I8 instance** (now ~2 lines via v4.31.0's
`isIso_fromTildeΓ_iff_isLocalizing`).

**Phrasing caveat for the writer (load-bearing).** Do NOT state the node as the X-level
`pushPullObj F Yₙ ≅ tilde Mₙ`: `pushPullObj F Yₙ = pₙ_* pₙ^* F` lives over `X` (generally
non-affine), while `tilde` lives over `Spec` — that iso is type-ill-formed. State it at one of the
two well-typed altitudes:
- restriction level: `(pullback Yₙ.ι).obj F ≅ tilde Nₙ` over the affine `Yₙ = Spec A`
  (01I8-on-`Yₙ` via `qcoh_iso_tilde_sections` + pull-preserves-QC), **then**
- assemble `(pushforward f).obj (pushPullObj F Yₙ) ≅ (pushforward (Spec.map φ)).obj (tilde Nₙ)` over
  the affine base `S` via `pushforwardComp` + `isoSpec`. The base-change `app n` is
  `g^*(f_*(pushPullObj F Yₙ))`, so the leaf needs this pushed-forward form, which is then exactly
  `affinePushforwardPullbackBaseChange`.

The prover's "multi-hundred-LOC novel" estimate is correct ONLY for the abstract sheaf-level
Beck–Chevalley (option (b), keep-abstract-signature) — which the separated route avoids. Reuse the
project's `qcoh_iso_tilde_sections`; it is the Mathlib idiom (Mathlib ships no packaged
`QCoh(Spec R) ≃ ModuleCat R`).
