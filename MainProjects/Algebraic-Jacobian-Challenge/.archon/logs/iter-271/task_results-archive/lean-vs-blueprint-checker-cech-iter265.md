# Lean ↔ Blueprint Check Report

## Slug
cech-iter265

## Iteration
265

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.CechNerve}` (chapter: `def:cech_nerve`)
- **Lean target exists**: yes (line 89)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) (F : X.Modules) : CosimplicialObject.Augmented X.Modules` matches the blueprint's "augmented cosimplicial object in QCoh(X)"
- **Proof follows sketch**: N/A — body is `sorry`; blueprint documents this as a genuine gap pending `pushPullFunctor`
- **Notes**: `\leanok` on statement block is correct (sorry present). Body comment faithfully explains the two missing ingredients.

### `\lean{AlgebraicGeometry.coverArrow}` (chapter: `def:cover_arrow`)
- **Lean target exists**: yes (line 130)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) : Arrow Scheme.{u}` matches
- **Proof follows sketch**: yes — `Arrow.mk (Sigma.desc 𝒰.f)`, axiom-clean
- **Notes**: clean; `\leanok` appropriate.

### `\lean{AlgebraicGeometry.coverCechNerve}` (chapter: `def:cover_cech_nerve`)
- **Lean target exists**: yes (line 139)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) : SimplicialObject.Augmented Scheme.{u}` matches the blueprint's "augmented simplicial scheme"
- **Proof follows sketch**: yes — `(coverArrow 𝒰).augmentedCechNerve`, axiom-clean
- **Notes**: clean; `\leanok` appropriate.

### `\lean{AlgebraicGeometry.pushPullObj}` (chapter: `def:push_pull_obj`)
- **Lean target exists**: yes (line 163)
- **Signature matches**: yes — `(F : X.Modules) (Y : Over X) : X.Modules` with body `(pushforward Y.hom).obj ((Scheme.Modules.pullback Y.hom).obj F)` matches `p_* p^* F`
- **Proof follows sketch**: yes — axiom-clean definition
- **Notes**: clean; `\leanok` appropriate.

### `\lean{AlgebraicGeometry.pushPullMap}` (chapter: `def:push_pull_map`)
- **Lean target exists**: yes (line 175)
- **Signature matches**: yes — `(F : X.Modules) {Y₁ Y₂ : Over X} (g : Y₂ ⟶ Y₁) : pushPullObj F Y₁ ⟶ pushPullObj F Y₂`
- **Proof follows sketch**: yes — the five-step composite `unit → pushforwardComp.hom → eqToHom → pushforward.map(pullbackComp.hom) → eqToHom` matches the blueprint's diagram exactly; axiom-clean
- **Notes**: clean; `\leanok` appropriate.

### `\lean{AlgebraicGeometry.pushPullMap_id}` and `\lean{AlgebraicGeometry.pushPullMap_comp}` (chapter: `lem:push_pull_functor`) — **CRITICAL ISSUE**
- **Lean target exists**:
  - `pushPullMap_id`: **yes** (line 216), real proof, axiom-clean ✓
  - `pushPullMap_comp`: **NO** — this declaration does not exist in the Lean file. It appears only in a `/- ... -/` block comment (lines 273–302), not as a declared `lemma`. The `% NOTE (iter-264)` comment in the blueprint explicitly flags this: "the statement-block `\leanok` therefore over-states this lemma."
- **Signature matches**:
  - `pushPullMap_id`: yes
  - `pushPullMap_comp`: N/A — declaration absent
- **Proof follows sketch**: partial — `pushPullMap_id` proof follows the mate-calculus sketch (`unit_conjugateEquiv`, `conjugateEquiv_pullbackId_hom`, `pseudofunctor_right_unitality`). `pushPullMap_comp` not yet started.
- **Notes (must-fix-this-iter)**: The `\leanok` on the statement block of `lem:push_pull_functor` is **incorrect** because the block carries two `\lean{}` pins and one (`pushPullMap_comp`) names a non-existent declaration. The iter-264 `% NOTE` documented this but the corrective action (split the block OR add a `sorry` stub) was not taken. This means `sync_leanok` is operating on a block with a dead `\lean{}` pin — its output is undefined/ambiguous for this block.

### `\lean{AlgebraicGeometry.relativeCechComplexOfNerve}` (chapter: `def:relative_cech_complex_of_nerve`)
- **Lean target exists**: yes (line 342)
- **Signature matches**: yes — `(f : X ⟶ S) (N : CosimplicialObject.Augmented X.Modules) : CochainComplex S.Modules ℕ` matches; body is the three-step coherence-free pipeline (drop augmentation, whiskering by pushforward f, alternatingCofaceMapComplex), axiom-clean
- **Proof follows sketch**: yes
- **Notes**: clean; `\leanok` appropriate.

### `\lean{AlgebraicGeometry.CechAcyclic.affine}` (chapter: `lem:cech_acyclic_affine`)
- **Lean target exists**: yes (line 394)
- **Signature matches**: yes — `[IsAffine X] (f : X ⟶ S) [IsAffineHom f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ) (hp : 1 ≤ p) : IsZero ((CechComplex f 𝒰 F).homology p)` is the relative form of the blueprint's affine acyclicity; slight generalization (over S with affine f) is consistent with the chapter's relative setup
- **Proof follows sketch**: N/A — sorry body; blueprint proof sketch is detailed (contracting homotopy at primes) but documented as Mathlib-absent
- **Notes**: `\leanok` on statement block is correct (sorry present).

### `\lean{AlgebraicGeometry.cech_computes_higherDirectImage}` (chapter: `lem:cech_computes_cohomology`)
- **Lean target exists**: yes (line 431)
- **Signature matches**: yes — `[HasInjectiveResolutions X.Modules]` hypothesis present, comparison as `Nonempty (... ≅ higherDirectImage f i F)`, matches blueprint prose
- **Proof follows sketch**: N/A — sorry body; spectral sequence argument documented as Mathlib-absent
- **Notes**: `\leanok` on statement block is correct (sorry present).

### `\lean{AlgebraicGeometry.cechHigherDirectImage}` (chapter: `def:cech_higher_direct_image`)
- **Lean target exists**: yes (line 459)
- **Signature matches**: yes — `(f : X ⟶ S) (𝒰 : X.OpenCover) (F : X.Modules) (i : ℕ) : S.Modules` with body `(CechComplex f 𝒰 F).homology i` matches `H^i(Č•(𝒰, F))`; axiom-clean definition (chains through the CechNerve sorry but the definition itself is clean)
- **Proof follows sketch**: yes
- **Notes**: `\leanok` appropriate.

### `\lean{AlgebraicGeometry.cech_flatBaseChange}` (chapter: `lem:cech_flat_base_change`)
- **Lean target exists**: yes (line 491)
- **Signature matches**: yes — `Nonempty ((Scheme.Modules.pullback g).obj (cechHigherDirectImage f 𝒰 F i) ≅ cechHigherDirectImage f' 𝒰' ((Scheme.Modules.pullback g').obj F) i)` matches the blueprint's `g^*(R^i f_*F) ≅ R^i f'_*((g')^*F)`
- **Proof follows sketch**: N/A — sorry body; affine base change of Čech complex documented as Mathlib-absent
- **Notes**: `\leanok` on statement block is correct (sorry present).

---

## Red flags

### Placeholder / suspect bodies
- `CechNerve` at line 97: `:= sorry` — expected; documented as the main open gap
- `CechAcyclic.affine` at line 404: `:= sorry` — expected; documented as Mathlib-absent (contracting homotopy on localizations)
- `cech_computes_higherDirectImage` at line 441: `:= sorry` — expected; spectral sequences absent
- `cech_flatBaseChange` at line 503: `:= sorry` — expected; affine base change of Čech complex absent

These are all expected and documented; none are "excuse-comment" cases.

### Dead `\lean{}` pin (must-fix-this-iter)
- `AlgebraicGeometry.pushPullMap_comp` is listed as `\lean{AlgebraicGeometry.pushPullMap_comp}` in `lem:push_pull_functor` but **does not exist as a Lean declaration**. It lives only in a block comment (lines 273–302). The `\leanok` on the statement block therefore over-marks: a dead pin cannot be "at least sorry-present." This was documented in the iter-264 `% NOTE` but not corrected.

---

## Unreferenced declarations (informational)

| Declaration | Line | Notes |
|---|---|---|
| `pushPull_unit_mate` | 313 | **Substantive** axiom-clean lemma added this iter. No `\lean{...}` reference in the blueprint. Described in Lean as "project-local supplement" and "the reusable ingredient that the functoriality (pentagon) law of `pushPullMap` repeatedly consumes." Should have its own blueprint entry. See **major** finding below. |

---

## Blueprint adequacy for this file

- **Coverage**: 11/12 Lean declarations have a corresponding `\lean{...}` block. Unreferenced: 1 substantive declaration (`pushPull_unit_mate`, added this iter). The 12th `\lean{}` pin (`pushPullMap_comp`) names a non-existent declaration, so it does not count as covered.

- **Proof-sketch depth**: **under-specified** for `pushPullMap_comp`.

  The chapter's proof sketch for `lem:push_pull_functor` correctly identifies the high-level ingredients: `pseudofunctor_associativity` (pentagon), `Adjunction.unit_naturality`, and `eqToHom` bookkeeping along the over-triangle. However it is **silent on three things that the prover's in-file analysis (lines 273–302) shows are the actual obstacles**:

  1. **The `pushPull_unit_mate` helper**: The chapter does not mention the newly-isolated reusable lemma `pushPull_unit_mate` that converts `p_*(η^f) ≫ pushforwardComp` into `η^{f≫p} ≫ (f≫p)_*(pullbackComp⁻¹)`. This helper is the mate-calculus core that the pentagon proof consumes repeatedly; a prover reading the blueprint sketch alone would re-derive or fail to decompose this step.

  2. **The `eqToHom` whnf blow-up**: The chapter says "the work is the bookkeeping of the eqToHom coercions along the over-triangle" but gives no guidance on *how* to handle them. The Lean analysis (lines 293–302) documents that the standard cancellation routes (`subst`, heartbeat-heavy `rw`/`erw` telescope) all fail due to kernel whnf blow-up exceeding 1e6 heartbeats. This is not a generic bookkeeping remark — it is a specific structural obstacle that changes the required strategy.

  3. **The transport-light reformulation prescription**: The Lean analysis concludes that resolving `pushPullMap_comp` requires "a transport-light formulation (e.g. defining `pushPullMap` so the over-triangle substitution is `eqToHom`-free, or a kernel-cheap `eqToHom` cancellation lemma)." The blueprint chapter does not contain this recommendation.

  A prover following only the blueprint sketch for `pushPullMap_comp` would reach the same whnf wall as the current prover, without guidance on how to escape it.

- **Hint precision**: **loose** for `lem:push_pull_functor`. The block has two `\lean{}` pins but they are not individually gated — `sync_leanok` cannot distinguish `pushPullMap_id` (done) from `pushPullMap_comp` (absent) when both share one statement block and one `\leanok`.

- **Generality**: matches need for all other declarations.

- **Recommended chapter-side actions**:
  1. **(must-fix-this-iter)** Split `lem:push_pull_functor` into two separate lemma blocks — one for `pushPullMap_id` (with `\lean{AlgebraicGeometry.pushPullMap_id}` and `\leanok`) and one for `pushPullMap_comp` (with `\lean{AlgebraicGeometry.pushPullMap_comp}` and no `\leanok` until the declaration exists). The iter-264 `% NOTE` already prescribed this; it needs to be executed.
  2. **(must-fix-this-iter)** Add a `\begin{lemma}...\lean{AlgebraicGeometry.pushPullMap_comp}...\end{lemma}` block for the pentagon law, with a revised proof sketch that (a) references `pushPull_unit_mate` as the mate-core helper, (b) names the `eqToHom` whnf blow-up as the concrete obstacle, and (c) states the transport-light reformulation of `pushPullMap` as the recommended route.
  3. **(major)** Add a `\begin{lemma}\lean{AlgebraicGeometry.pushPull_unit_mate}` block documenting the mate identity and its role as the reusable ingredient for the pentagon.

---

## Severity summary

### must-fix-this-iter
1. **Dead `\lean{}` pin**: `\lean{AlgebraicGeometry.pushPullMap_comp}` in `lem:push_pull_functor` names a non-existent declaration (present only in a comment); the `\leanok` on the statement block therefore overstates formalization status. The iter-264 `% NOTE` flagged this; corrective action not yet taken. Fix: either add a `lemma pushPullMap_comp ... := sorry` stub to the Lean file, or split the blueprint block so each `\lean{}` pin has its own statement node.

2. **Blueprint proof sketch under-specified for `pushPullMap_comp`**: The chapter does not mention `pushPull_unit_mate`, the `eqToHom` whnf blow-up, or the transport-light reformulation requirement. A prover dispatched to close `pushPullMap_comp` from the blueprint alone would hit the same wall with no prescriptive guidance on escaping it.

### major
1. `pushPull_unit_mate` (axiom-clean, line 313, added this iter) has no `\lean{...}` reference in the blueprint. This is a substantive helper (described as "the reusable ingredient that the functoriality law of `pushPullMap` repeatedly consumes") and warrants its own blueprint entry.

2. `lem:push_pull_functor` shares one statement block and `\leanok` for two independent declarations — this prevents `sync_leanok` from tracking their completion independently. Must be split (already prescribed by the iter-264 `% NOTE`, now past due).

### minor
1. `CechAcyclic.affine` Lean statement is relative (`f : X ⟶ S`, `[IsAffineHom f]`), slightly more general than the blueprint's "Let U = Spec A be affine" framing. This is a benign extension; the blueprint prose already uses the relative complex. No action needed.

---

**Overall verdict**: One critical structural defect (dead `\lean{}` pin on `pushPullMap_comp`) carried over unresolved from iter-264 plus an under-specified proof sketch for that same law, together blocking `sync_leanok` reliability and prover guidance for the next pass; `pushPull_unit_mate` (new this iter, axiom-clean) has no blueprint entry — 12 declarations audited, 3 findings (2 must-fix-this-iter, 2 major).
