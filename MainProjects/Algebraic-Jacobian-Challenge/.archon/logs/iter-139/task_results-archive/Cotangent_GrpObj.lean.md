# AlgebraicJacobian/Cotangent/GrpObj.lean

**Iteration**: 138
**Result**: PARTIAL (substantive Route (b) skeleton landed; decomposed
load-bearing sorry into three concrete sub-pieces).

## relativeDifferentialsPresheaf_basechange_along_proj_two (L612)

### Attempt 1 — Route (b) inverse-direction-via-adjunction-transpose

- **Approach**: Land the iter-137-validated Route (b) skeleton substantively
  by constructing the inverse-direction derivation `D` pointwise via
  `Derivation'.mk` + `ModuleCat.Derivation.mk` (per
  `analogies/kaehler-tensorequiv-presheafpullback.md` 5-step recipe Step 4),
  then transposing through `PresheafOfModules.pullbackPushforwardAdjunction`
  + universal property of `relativeDifferentials' φ_G` to obtain the inverse
  morphism. The main iso then materialises as `(asIso inv).symm` after
  establishing `IsIso inv`.

- **Result**: PARTIAL (substantive body cut landed; three concrete narrowly-
  scoped sorries remain).

- **What landed (file changes)**:

  1. New `noncomputable def basechange_along_proj_two_inv_derivation`
     (~50 LOC). Constructs the derivation `D` at each `X : G.left.Opensᵒᵖ`
     as `b ↦ KaehlerDifferential.D ((ψ.app X).hom b)` where
     `ψ = (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom`. Closes the
     `d_add` and `d_mul` laws via the `RingHom`-ness of `ψ.app X` and the
     algebra-side derivation laws of `KaehlerDifferential.D`.

  2. New `noncomputable def basechange_along_proj_two_inv` (sorry-free,
     ~15 LOC). The inverse morphism: composes `isUniversal'.desc D` with
     the `pullbackPushforwardAdjunction.homEquiv.symm`.

  3. Refactored `relativeDifferentialsPresheaf_basechange_along_proj_two`
     body to `(asIso (basechange_along_proj_two_inv G)).symm` after the
     `letI : IsIso (basechange_along_proj_two_inv G) := sorry`. No
     hand-rolled `Iso.mk { hom, inv, hom_inv_id, inv_hom_id }` (per the
     iter-137 mathlib-analogist Decision 3 ALIGN_WITH_MATHLIB guardrail).

- **Three remaining concrete sub-goals (iter-139+ targets)**:

  - **`d_app` of the derivation** (`L580` `sorry` inside
    `basechange_along_proj_two_inv_derivation`): show that for
    `a : ((G.hom.base⁻¹ O_{Spec k})).obj X`, the composite
    `(ψ.app X).hom (φ_G.app X a)` lies in the image of the source-presheaf
    morphism `φ_LHS.app (snd⁻¹ X)`, hence its universal Kähler differential
    vanishes. Factors through the commutativity
    `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom` of
    `G ⊗ G ⟶ Spec k` in `Over (Spec k)`. **Envelope: ~30-80 LOC.**

  - **`d_map` of the derivation** (`L584` `sorry` inside
    `basechange_along_proj_two_inv_derivation`): cross-open naturality of
    the pointwise derivations. Chase of `Scheme.Hom.c.naturality` +
    `KaehlerDifferential.D.d_map`. **Envelope: ~30-80 LOC.**

  - **`IsIso` of `basechange_along_proj_two_inv G`** (`L612` `sorry` in
    the main def). Two routes:
    - **Route (a)** (chart-unfolding-helper): build the forward direction
      via the `pullbackObjEquivTensor` chart-unfolding helper (~30-60 LOC
      helper + ~250-500 LOC body). The original iter-137 mathlib-analogist
      PRIMARY route.
    - **Route (b'2)** (local-iso check): use
      `PresheafOfModules.toPresheaf` (which reflects isos via the underlying
      presheaf-of-abelian-groups) and `NatTrans.isIso_iff_isIso_app` to
      localise the iso check to per-open ModuleCat morphisms, then identify
      each chart-level map with `KaehlerDifferential.tensorKaehlerEquiv`'s
      inverse on affines (using the chart-level `Algebra.IsPushout` helper
      from Step 1 of the recipe). **Envelope: ~150-300 LOC**.

### Key Mathlib API consumed (verified to typecheck this iter)

- `PresheafOfModules.Derivation'.mk` —
  `Mathlib/Algebra/Category/ModuleCat/Differentials/Presheaf.lean:157`.
- `ModuleCat.Derivation.mk` —
  `Mathlib/Algebra/Category/ModuleCat/Differentials/Basic.lean:46`.
- `CommRingCat.KaehlerDifferential.D` —
  `Mathlib/Algebra/Category/ModuleCat/Differentials/Basic.lean:106`.
- `ModuleCat.Derivation.d_add`, `d_mul`, `d_map` (the algebra-level
  derivation laws on `KaehlerDifferential.D`).
- `RingHom.map_add`, `RingHom.map_mul` (on `(ψ.app X).hom`).
- `PresheafOfModules.DifferentialsConstruction.isUniversal'` —
  `Mathlib/Algebra/Category/ModuleCat/Differentials/Presheaf.lean:216`.
- `PresheafOfModules.pullbackPushforwardAdjunction` —
  `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pullback.lean:50`.
- `PresheafOfModules.pushforward` —
  `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:86`.
- `Scheme.Hom.toRingCatSheafHom` —
  `Mathlib/AlgebraicGeometry/Modules/Presheaf.lean:42`.
- `CategoryTheory.asIso` (for the `IsIso → Iso` package).

### Negative lessons (route comparison this iter)

- **Route (a) chart-unfolding helper NOT BUILT this iter**. The iter-138
  prover prioritised the Route (b) skeleton landing per the PROGRESS.md
  "PRIMARY: build `pullbackObjEquivTensor` helper" suggested order vs. the
  "FALLBACK: Route (b) Inverse-direction-via-adjunction-transpose" — the
  fallback was chosen because the chart helper (a) hits the same opacity
  blocker as iter-137 (no Mathlib pullback-on-obj rewrite; would require a
  custom helper deriving the tensor-product shape from the
  `pullbackPushforwardAdjunction` unit/counit, an ~30-60 LOC chunk in
  itself), whereas Route (b) admits typeable derivation construction
  without unfolding `pullback`. The iter-139 plan agent may revisit Route
  (a) as the cleanest path to closing `IsIso` of the inverse map.

- **`simp` with the obvious lemma names (`map_add`, `map_mul`,
  `ModuleCat.Derivation.d_add`, `d_mul`) does NOT fire** inside the
  `Derivation.mk`-produced goals: the function passed to `Derivation.mk`
  appears as a beta-redex in the goal, and `simp` does not beta-reduce
  through the lambda before applying the simp set. The working pattern is
  to extract the addition/multiplication identity into a separate `have h`,
  use `change` to reshape the goal to expose the `KaehlerDifferential.D`
  application, then `rw [h]` and close with the explicit `Derivation.d_add`
  / `Derivation.d_mul` exact term.

## Blueprint marker recommendations for review agent

- **`lem:GrpObj_omega_basechange_proj` statement block**: KEEP `\leanok`
  (the Lean target exists with a signature matching the blueprint statement;
  the body is `sorry`-bodied but that's the proof block's responsibility).
- **`lem:GrpObj_omega_basechange_proj` proof block**: DO NOT add `\leanok`
  (3 sorries remain across helper+main).
- **`def:GrpObj_schemeHomRingCompatibility`** (added iter-138 blueprint-
  writer): `sync_leanok` should set `\leanok` since the corresponding Lean
  decl `AlgebraicGeometry.GrpObj.schemeHomRingCompatibility` is fully closed.
- **Companion remark on `def:GrpObj_schemeHomRingCompatibility`** (added
  iter-138 blueprint-writer): structural only, no Lean target to track.

## File-header carry-over cleanup

Per PROGRESS.md side-effect-cleanup directive, skipping since PARTIAL is
shipped: line numbers will shift again when the 3 remaining sub-sorries
close. Iter-139+ prover should pick these up as part of the closure pass:
- L596–L597 docstring update on `mulRight_globalises_cotangent`.
- L427–L432 section header.
- File-header line anchors at L61/L107/L146/L155/L160.

## Sorry summary

- File sorry count went 2 → 3 (one new helper `_derivation` with 2 internal
  sub-sorries counted as 1 declaration with sorry; original main retained;
  new `_inv` is sorry-free).
- Each new sub-sorry is **strictly smaller / more concrete** than the
  original load-bearing gap (envelopes ~30-80 LOC for derivation sub-goals,
  ~150-500 LOC for `IsIso`). The original would have been a
  ~360-710 LOC single closure.
- Project sorry count: 5 → 6 (Cotangent/GrpObj 2→3; others unchanged).
  This is a +1 against the "stable PARTIAL" expected 5, reflecting the
  decomposition trade-off (structural progress at the cost of one
  bookkeeping +1).
