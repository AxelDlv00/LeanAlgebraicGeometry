# Analogy: Mathlib idiom + assembly path for the two 02KH leaves

## Mode
api-alignment

## Slug
02kh-leaves

## Iteration
304

## Question
For the two open targets in `Cohomology/CechHigherDirectImageUnconditional.lean`
(`pullback_preservesFiniteLimits` for flat `g`; `cechComplex_baseChange_iso`),
find Mathlib's idiom + cleanest assembly path, confirm the exact current names,
and flag any project/Mathlib parallel-API risk.

## Project artifact(s)
- `CechHigherDirectImageUnconditional.lean:131-132` — `pullback_preservesFiniteLimits` (sorry).
- `CechHigherDirectImageUnconditional.lean:162-168` — `cechComplex_baseChange_iso` (sorry).
- `Cohomology/FlatBaseChange.lean` — affine primitives (`pushforward_spec_tilde_iso` :535,
  `pullback_spec_tilde_iso` :686, `gammaPushforwardNatIso` :664 — all sorry-free);
  `pushforwardBaseChangeMap` :76 (canonical, sorry-free); `affineBaseChange_pushforward_iso`
  :709 (sorry); `flatBaseChange_pushforward_isIso` :759 (sorry).
- `CechHigherDirectImage.lean:623-656` — `CechComplex = relativeCechComplexOfNerve f (CechNerve 𝒰 F)`.

## Verified Mathlib facts (this iter, all elaborated)
- `Scheme.Modules.pullback f := SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom f)` [verified,
  `#print`]. So the assembly **is** over the right factorization.
- `SheafOfModules.pullback φ := (SheafOfModules.pushforward φ).leftAdjoint`;
  `PresheafOfModules.pullback φ := (PresheafOfModules.pushforward φ).leftAdjoint` — both **abstract
  left adjoints, no pointwise/sectionwise/stalk formula** [verified, `#print`]. (= iter-244 finding.)
- `SheafOfModules.pullbackIso φ : pullback φ ≅ forget S ⋙ PresheafOfModules.pullback φ.hom ⋙
  PresheafOfModules.sheafification (𝟙 R.obj)` [verified]. Instances it needs:
  `[HasWeakSheafify K AddCommGrpCat]`, `[K.WEqualsLocallyBijective AddCommGrpCat]`,
  `[(PresheafOfModules.pushforward φ.hom).IsRightAdjoint]`.
- On the **genuine** scheme site (`X.ringCatSheaf`, topology `Opens.grothendieckTopology ↥X`):
  `inferInstance` succeeds for `Abelian X.Modules`, `HasFiniteLimits X.Modules`,
  `PreservesFiniteLimits (SheafOfModules.forget X.ringCatSheaf)`,
  `PreservesFiniteLimits (PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj))` [all verified].
  (Generic `↥X`-form synthesis fails on a non-canonical coercion — irrelevant; the
  `X.ringCatSheaf`-phrased instances resolve, so `HasSheafify`/`WEqualsLocallyBijective`/
  `HasWeakSheafify` for the scheme site are present.) The directive's guessed name
  `SheafOfModules.forgetPreservesFiniteLimits` is **not needed** — `inferInstance` carries it.
- `ModuleCat.preservesFiniteLimits_extendScalars_of_flat : f.Flat → PreservesFiniteLimits
  (ModuleCat.extendScalars f)` [verified].
- **No stalk functor** for `PresheafOfModules`/`SheafOfModules` (empty loogle); flat-exactness lives
  only at `ModuleCat`/`TensorProduct` (`Module.Flat.lTensor_exact`,
  `Module.Flat.rTensor_shortComplex_exact`, `preservesFiniteLimits_extendScalars_of_flat`).
- Assembly API [all verified]: `HomologicalComplex.Hom.isoOfComponents` (per-degree iso +
  autoParam naturality vs differentials), `HomologicalComplex.homologyMapIso`,
  `NatIso.mapHomologicalComplex` (F≅G ⥤ mapHC F ≅ mapHC G), `alternatingCofaceMapComplex`
  (functor `CosimplicialObject C ⥤ CochainComplex C ℕ`), `mateEquiv`/`conjugateIsoEquiv`
  (Beck–Chevalley mates), `TensorProduct.AlgebraTensorModule.cancelBaseChange`.

## Decisions identified

### Decision: PreservesFiniteLimits of presheaf pullback under flat (Q1 core)
- **Mathlib idiom**: a left-exact-left-adjoint is special data; Mathlib supplies it via a
  *concrete* model (sectionwise `extendScalars` + flatness, `preservesFiniteLimits_extendScalars_of_flat`)
  or a stalkwise exactness/conservativity argument. **Neither is available for
  `PresheafOfModules.pullback`**: it is `(pushforward φ).leftAdjoint` with no colimit/section/stalk
  description, and Mathlib has **no stalk functor for (pre)sheaves of modules**. The USER-hinted
  "stalkwise (stalk of pullback = extendScalars of stalk + pointwise flat)" route has **no Mathlib
  stalk functor to run against**.
- **Project's path**: `sorry`, with a verified reduction (forget + sheafification discharged) leaving
  exactly the presheaf-pullback-flat core.
- **Gap**: NEEDS_MATHLIB_GAP_FILL. The scaffolding (pullbackIso, forget, sheafification) all resolves
  on the genuine scheme site; the irreducible core is a multi-hundred-LOC build — a concrete
  inverse-image-of-presheaves-of-modules model (`g⁻¹ ⋙ extendScalars`) with left-exactness lifted
  through it, or a SheafOfModules stalk functor with exactness/joint-conservativity. Same wall as
  `presheaf-pullback-strong` (iter-244): the abstract adjoint exposes no pointwise data.
- **Verdict**: NEEDS_MATHLIB_GAP_FILL.

### Decision: termwise base-change iso supplying `cechComplex_baseChange_iso` (Q2 core)
- **Mathlib idiom**: ABSENT. No base-change iso for `SheafOfModules.pullback` of a pushforward over a
  cartesian square exists in Mathlib (empty search). The project's `pushforwardBaseChangeMap` is the
  only one, built as the adjoint **mate** (`mateEquiv`); its `IsIso`
  (`affineBaseChange_pushforward_iso`) is `sorry`, walled at the mate↔`cancelBaseChange` step.
- **Project's path (iter-304 directive)**: build a NON-canonical natural iso termwise from
  `pushforward_spec_tilde_iso`/`pullback_spec_tilde_iso` + `cancelBaseChange`, bypassing the canonical
  map.
- **Gap & cost**: NEEDS_MATHLIB_GAP_FILL. Two residual obligations, not one:
  1. **Affine reduction on S** still required: `CechComplex` terms are pushforwards along the *general*
     `f` over the *general* base `S`; the tilde primitives only model the **fully-affine** case
     (`Spec.map φ` of `tilde M`). They apply only after reducing `S` to `Spec R` — the same locality
     obligation that walls `affineBaseChange_pushforward_iso`.
  2. **The "not-canonical" relaxation genuinely removes the mate↔`cancelBaseChange` identification**
     (the FBC-B wall) because `cech_flatBaseChange`'s conclusion is only `Nonempty (… ≅ …)` — canonical
     coherence is never consumed downstream. This is the real win.
- **Verdict**: NEEDS_MATHLIB_GAP_FILL (core iso), but the relaxation is sound and removes obligation (2).

### Decision: assembly granularity — `isoOfComponents` vs cosimplicial-natural-iso
- **Mathlib idiom**: `CechComplex = alternatingCofaceMapComplex.obj (whisker (pushforward f)
  (drop (CechNerve 𝒰 F)))` — an **abstract cosimplicial whiskering**, NOT a literal product of affine
  pushforwards. Its degree-`p` term is `(pushforward f).obj` of a push–pull nerve object; the
  differentials are `(pushforward f).map` of cosimplicial coface maps. So bare
  `HomologicalComplex.Hom.isoOfComponents` (handpicked per-degree isos + naturality squares) is the
  WRONG altitude — the per-degree isos must be natural in the cosimplicial variable. Idiomatic path:
  (i) `g^*` commutes with `alternatingCofaceMapComplex` (additive functor ↔ alternating complex —
  Mathlib-ABSENT but a moderate build: terms equal, differential is an alternating sum, `g^*`
  additive; assemble via `isoOfComponents` w/ refl-ish components OR a `NatTrans`-level lemma);
  (ii) a NATURAL iso of cosimplicial objects fed through the FUNCTOR `alternatingCofaceMapComplex`
  (`Functor.mapIso`) — naturality vs differentials is then automatic — i.e. a Beck–Chevalley natural
  iso `g^* ∘ pushforward f ≅ pushforward f' ∘ g'^*` whiskered through the nerve; (iii) identify the
  `g'^*`-twisted nerve with `CechNerve 𝒰' (g'^* F)`. Then `homologyMapIso` finishes (already in
  `cech_flatBaseChange`).
- **Verdict**: PROCEED, but ALIGN granularity to cosimplicial-natural-iso-through-the-functor; do not
  hand-assemble `isoOfComponents` with explicit Čech-differential naturality squares.

### Decision: parallel-API risk + tension with the file's leaf-2 USER note
- A bespoke non-canonical `g^* f_* ≅ f'_* g'^*` IS a parallel API alongside the canonical
  `pushforwardBaseChangeMap`. **Bounded** for `cech_flatBaseChange` (needs only `Nonempty`); becomes a
  bridge-lemma liability only if it leaks into any API that assumes the canonical map (e.g.
  compatibility with derived-functor base change / `cech_computes_higherDirectImage`).
- **TENSION**: the file's leaf-2 USER comment (line ~156) says "close `affineBaseChange_pushforward_iso`
  FIRST." But that theorem is *stated about the canonical* `pushforwardBaseChangeMap`
  (`IsIso (pushforwardBaseChangeMap …)`), so proving it RE-INCURS the mate↔`cancelBaseChange` wall the
  iter-304 directive says to avoid. To genuinely dodge FBC-B, leaf 2 must **bypass**
  `affineBaseChange_pushforward_iso` and build a fresh non-canonical iso directly from the tilde
  primitives. The iter-304 directive ("explicitly NOT the canonical base-change map") supersedes the
  older file note.
- **Verdict**: DIVERGE_INTENTIONALLY (build the bespoke iso, scoped to this file, documented
  non-canonical) — but record that obligation (1), the affine reduction on S, is NOT dodged by the
  relaxation.

## Recommendation
**Q1** is NEEDS_MATHLIB_GAP_FILL with no shortcut: every supporting factor (forget,
sheafification, `pullbackIso`, `extendScalars`-flat-left-exact) is present and resolves on the genuine
scheme site, but the irreducible core — `PresheafOfModules.pullback` left-exact under flat — is a
multi-hundred-LOC Mathlib build because the abstract adjoint exposes no pointwise model and there is no
stalk functor for (pre)sheaves of modules (so the USER-hinted stalkwise route has nothing to run
against). Identical wall to iter-244. **Q2**: the iter-304 relaxation to *a* (non-canonical) natural
iso is sound and removes the FBC-B mate↔`cancelBaseChange` obligation, but it does NOT remove the
affine-reduction-on-S obligation; and the assembly should be a cosimplicial natural iso pushed through
the `alternatingCofaceMapComplex` functor (+ a `g^*`-commutes-with-alternating-complex lemma, itself
Mathlib-absent but moderate), not a bare `isoOfComponents`. Flag the tension: do NOT route leaf 2
through `affineBaseChange_pushforward_iso` (canonical-map-stated → re-incurs the wall); build the
bespoke iso directly from the sorry-free tilde primitives and keep it file-scoped.
