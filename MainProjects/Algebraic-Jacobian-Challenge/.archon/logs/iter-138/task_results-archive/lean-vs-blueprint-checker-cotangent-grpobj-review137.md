# Lean ↔ Blueprint Check Report

## Slug
cotangent-grpobj-review137

## Iteration
137

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/GrpObj.lean` (638 lines)
- Blueprint chapters: `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`
  (pointer chapter, 60 lines) + `blueprint/src/chapters/RigidityKbar.tex`
  (cross-chapter prose for piece (i) declarations, all `\lean{...}` hints
  for this file's declarations live here; 593 lines).

## Iter-137 framing

Per the directive, iter-137 was a **docstring-only PARTIAL session**: no
code/signature changes, no new declarations. Two `sorry`-bodied scaffolds
remain from earlier iterations (iter-135), pinned to intended-type
signatures: `_basechange_along_proj_two` (L508 = Step 2 of piece (i.b))
and `mulRight_globalises_cotangent` (L635 = piece (i.b) Main lemma). All
other declarations in the file are fully closed. The audit below
focuses on the four directive questions; carry-over items listed in the
directive's "Known issues" are NOT re-flagged.

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` (RigidityKbar `lem:GrpObj_cotangentSpace`, L94–110)
- **Lean target exists**: yes, at `Cotangent/GrpObj.lean:161`.
- **Signature matches**: yes — blueprint stub `noncomputable def
  cotangentSpaceAtIdentity (G : Over (Spec (.of k)))
  [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
  [IsProper G.hom] [GeometricallyIrreducible G.hom] : ModuleCat k`
  matches the Lean signature verbatim.
- **Proof follows sketch**: yes — body is the iter-131 pure-term
  `Classical.choose`-chain on `Scheme.smooth_locally_free_omega`,
  followed by the explicit `extendScalars`-of-`ModuleCat.of`-`Ω[…]`
  outer expression, matching blueprint prose at RigidityKbar L115–119
  and the encoding note at L563–567.
- **notes**: closed iter-130/131; no `sorry`.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars}` (`lem:GrpObj_cotangentSpace_extendScalars_witness`, L124–154)
- **Lean target exists**: yes, at `Cotangent/GrpObj.lean:210`.
- **Signature matches**: yes — blueprint stub L133–147 spells out the
  existential `∃ U V e htop, letI algebra := …, cotangentSpaceAtIdentity G
  = (extendScalars …).obj (ModuleCat.of Γ(G, V) Ω[…])`, which is the
  Lean signature verbatim.
- **Proof follows sketch**: yes — blueprint proof L159 prescribes
  "reproduce the body's `Classical.choose`-chain on the same
  existential, then close by `rfl`"; the Lean proof L223–231 does
  exactly this (with `Subsingleton.elim` for the top-inclusion
  discharge, as the prose specifies).
- **notes**: closed iter-131; no `sorry`.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq}` (`lem:GrpObj_lieAlgebra_finrank`, L218–280)
- **Lean target exists**: yes, at `Cotangent/GrpObj.lean:256`.
- **Signature matches**: yes — blueprint stub `Module.finrank k
  (cotangentSpaceAtIdentity G) = n` matches Lean verbatim.
- **Proof follows sketch**: yes — Steps 1+2 live closure path
  (chart-side Kähler rank via `Module.finrank_eq_of_rank_eq` +
  base-change to `k` via `Module.finrank_baseChange`) matches blueprint
  proof L244–265 step-for-step; Step 3 (the stalk-side bridge via
  `m/m²`) is correctly deferred via `lem:GrpObj_cotangent_bridge`
  remaining `\notready`. The Lean's `Classical.choose`-chain
  re-extraction at L260–275 matches the blueprint encoding note at L572.
- **notes**: closed iter-132; no `sorry`.

### `\lean{AlgebraicGeometry.GrpObj.shearMulRight}` (`lem:GrpObj_shearMulRight`, L282–329)
- **Lean target exists**: yes, at `Cotangent/GrpObj.lean:349` (with `@[simps]`).
- **Signature matches**: yes — blueprint stub L295–301 spells the
  `lift (fst G G) μ` hom + `lift (fst G G) (lift (fst G G ≫ ι) (snd G G) ≫ μ)`
  inv exactly; `@[simps]` auto-generates `shearMulRight_hom_fst` and
  `shearMulRight_hom_snd` which the blueprint names verbatim.
- **Proof follows sketch**: yes — Mathlib calculus
  (`MonObj.lift_lift_assoc`, `GrpObj.lift_comp_inv_left/right`,
  `MonObj.lift_comp_one_left`) cited in blueprint proof L328 matches
  the Lean proof at L352–383.
- **notes**: closed iter-134; no `sorry`.

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}` (`lem:GrpObj_omega_basechange_proj`, L423–481)
- **Lean target exists**: yes, at `Cotangent/GrpObj.lean:500`.
- **Signature matches**: yes — blueprint stub at L434–450 specifies
  `relativeDifferentialsPresheaf (fst G G).left ≅ (PresheafOfModules.pullback
  φ_pr_two).obj (relativeDifferentialsPresheaf G.hom)`; the Lean
  signature at L504–507 uses `(Scheme.Hom.toRingCatSheafHom (snd G G).left).hom`
  for `φ_pr_two`, which is the iter-135 mathlib-analogist
  Decision (`analogies/phi-compatibility-morphisms.md`) canonical
  realisation. No signature drift since iter-135.
- **Proof follows sketch**: N/A — body is `sorry` (iter-135 honest
  scaffold; iter-137 PARTIAL). The iter-137 docstring at L479–499
  documents an inverse-direction-via-adjunction analysis finding; see
  "Blueprint adequacy" section below for a divergence between this
  finding and the blueprint's prose recipe.
- **notes**: ONE minor signature-precision flag. The Lean signature
  carries the extra instance binders `{n : ℕ}
  [SmoothOfRelativeDimension n G.hom] [IsProper G.hom]
  [GeometricallyIrreducible G.hom]` (L502–503). The blueprint stub
  L434–450 only requires `[CategoryTheory.GrpObj G]`; the mathematical
  statement `Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}` does not need
  smoothness/properness/geometric-irreducibility. These extra binders
  are over-constraining but not wrong — they match the consumer's
  context. Minor (not must-fix); see severity summary.

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section}` (`lem:GrpObj_omega_restrict_to_identity_section`, L483–529)
- **Lean target exists**: yes, at `Cotangent/GrpObj.lean:528`.
- **Signature matches**: yes — blueprint stub L490–503 spells the
  `s^*(pr_2^* Ω_{G/k}) ≅ π_G^*(η_G^* Ω_{G/k})` iso with the four
  compatibility morphisms (for `s`, `pr_2`, `π_G`, `η_G`); Lean
  signature at L532–543 uses
  `(Scheme.Hom.toRingCatSheafHom _).hom` inline for each, per the
  iter-135 mathlib-analogist verdict.
- **Proof follows sketch**: yes — blueprint proof L527–528 prescribes
  "apply `PresheafOfModules.pullbackComp` to both sides of
  `pr_2 ∘ s = η_G ∘ π_G`"; Lean proof L544–571 does exactly this,
  with the categorical identity packaged into the private helper
  `section_snd_eq_identity_struct` (L457–462).
- **notes**: closed iter-136; no `sorry`. NOTE iter-136 (RigidityKbar
  L505–518) is a known carry-over per the directive — not re-flagged.

### `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}` (`lem:GrpObj_mulRight_globalises`, L331–421)
- **Lean target exists**: yes, at `Cotangent/GrpObj.lean:624`.
- **Signature matches**: yes — blueprint stub L347–370 specifies
  `relativeDifferentialsPresheaf G.hom ≅
   (PresheafOfModules.pullback φ_str).obj
   ((PresheafOfModules.pullback φ_η).obj (relativeDifferentialsPresheaf G.hom))`,
  which the Lean signature at L628–634 realises with
  `(Scheme.Hom.toRingCatSheafHom G.hom).hom` for `φ_str` and
  `(Scheme.Hom.toRingCatSheafHom (CategoryTheory.CommaMorphism.left
  η[G])).hom` for `φ_η`. No signature drift since iter-135.
- **Proof follows sketch**: N/A — body is `sorry` (iter-135 honest
  scaffold). The proof-outline docstring at L595–615 names the
  three-step `shearMulRight` + base-change + section-restriction chain
  from the blueprint proof at L402–420; closure is iter-138+ target
  pending Step 2 closure.
- **notes**: nothing new this iter; iter-135 NOTE at RigidityKbar
  L372–381 is a known carry-over per the directive.

## Red flags

None this iter beyond the two known `sorry` bodies (both on honest
scaffolds with `\notready` on the corresponding blueprint proof
blocks; per the directive, NOT re-flagged as fake placeholders).

### Placeholder / suspect bodies
None this iter. The two `sorry` bodies at L508 and L635 are honest
scaffolds with intended-type signatures, pinned to `\notready`
blueprint proof blocks (RigidityKbar L382 for `mulRight_globalises`
and L463 for `_basechange_along_proj_two`).

### Excuse-comments
None. The iter-137 docstring updates at L429–450, L474–499, L504–509,
L616–623 honestly report the `sorry` status, the iter-138+ closure
plan, and the LOC envelope estimate. No "wrong but works for now"
phrasing; the forward-looking iter-138+ next-step notes are project
planning prose, not excuses.

### Axioms / `Classical.choice` on non-trivial claims
None. The `Classical.choose`-chain on
`Scheme.smooth_locally_free_omega` in `cotangentSpaceAtIdentity` is
authorised by the blueprint encoding note at RigidityKbar L563–567
(iter-131 Lean encoding note) and is structurally exposed via the
witness lemma `_eq_extendScalars`.

## Unreferenced declarations (informational)

The following declarations in the Lean file do not have a `\lean{...}`
block in the blueprint but appear in the
`AlgebraicJacobian_Cotangent_GrpObj.tex` pointer-chapter itemize list:

- `AlgebraicGeometry.GrpObj.schemeHomRingCompatibility` (L423) — listed
  in the pointer chapter L34–42 as a packaging helper. No `\lean{...}`
  block exists in RigidityKbar.tex for this declaration; the pointer
  chapter description is the only documentation. **Minor**:
  promoting this to a stand-alone blueprint `\lean{...}` block in
  RigidityKbar.tex (under piece (i.b)) would improve graph coverage.
- `AlgebraicGeometry.GrpObj.shearMulRight_hom_fst` and
  `shearMulRight_hom_snd` (L386, L391) — `@[simps]`-generated
  companions; the pointer chapter L29–33 mentions them by name but no
  `\lean{...}` block. Acceptable as auto-generated artefacts.
- `AlgebraicGeometry.GrpObj.section_snd_eq_identity_struct` (L457,
  private) — helper for `_restrict_along_identity_section`; mentioned
  in NOTE comment at RigidityKbar L509 but not as a blueprint
  `\lean{...}` block. Acceptable as a private helper.

## Blueprint adequacy for this file

A bidirectional check: does the blueprint chapter give a prover enough
detail to formalize this file correctly?

- **Coverage**: 7/11 file declarations have a `\lean{...}` block
  in RigidityKbar.tex (the seven listed in Per-declaration above).
  Unreferenced declarations: 4 — 1 helper (`schemeHomRingCompatibility`,
  flagged minor for promotion), 2 `@[simps]`-generated (acceptable),
  1 private (acceptable).

- **Proof-sketch depth**: **under-specified for `lem:GrpObj_omega_basechange_proj`**.
  The blueprint proof at RigidityKbar L471–480 prescribes a chart-by-chart
  recipe: at each affine chart, identify sections via
  `KaehlerDifferential.tensorKaehlerEquiv` on an
  `Algebra.IsPushout`-of-charts square, then "promote chart-by-chart
  equivalence to natural iso of presheaves of modules" via
  `TopCat.Presheaf.pullback` + `relativeDifferentialsPresheaf_obj_kaehler`.
  The iter-137 PARTIAL prover finding (`task_results/Cotangent_GrpObj.lean.md`
  + Lean docstring L479–499) reveals a load-bearing infrastructure gap
  the blueprint's recipe does not anticipate: **Mathlib's
  `PresheafOfModules.pullback` is OPAQUE on `.obj`/`.map`** (defined
  as `(pushforward φ).leftAdjoint`), so the chart-wise sections of the
  RHS `(pullback ψ).obj M_G` cannot be expressed directly without an
  intermediate ~30–60 LOC chart-unfolding helper
  (`pullbackObjEquivTensor`) that the blueprint never names. The
  inverse direction is feasible via `pullbackPushforwardAdjunction`
  transpose + universal property of `relativeDifferentials' φ_G` +
  derivation on the (transparent) `(pushforward ψ).obj LHS` — an
  alternative closure path that the blueprint's prose also does not
  anticipate. The Lean docstring's iter-137 finding (L479–499) accurately
  predicts this; the blueprint prose lags.

- **Hint precision**: precise on the `\lean{...}` side. All seven
  `\lean{...}` hints pin to declarations whose signatures match the
  prose. The compatibility-morphism convention split between
  `schemeHomRingCompatibility` (the `adj.homEquiv.symm f.c` shape used
  by `relativeDifferentialsPresheaf`) and the inline
  `Scheme.Hom.toRingCatSheafHom` (used by
  `PresheafOfModules.pullback`) is documented in the Lean docstring at
  L407–422 and is acknowledged at RigidityKbar L376–378 (iter-135 NOTE
  in `mulRight_globalises_cotangent`'s block). No drift.

- **Generality**: matches need. The Lean signatures use
  `Scheme.Hom.toRingCatSheafHom` inline (rather than introducing a
  named compatibility-morphism shorthand), which the blueprint's
  iter-135+ NOTEs explicitly authorise. The over-constraint on
  `_basechange_along_proj_two`'s signature (carrying
  `[SmoothOfRelativeDimension n G.hom] [IsProper G.hom]
  [GeometricallyIrreducible G.hom]`) is wider than the blueprint's
  intent (the statement is independent of those instance binders) but
  is a minor precision issue, not a generality failure — they match
  the consumer's context.

- **Recommended chapter-side actions** (NEW iter-137 findings,
  blueprint-writer dispatch suggested for iter-138+):
  1. **In `RigidityKbar.tex` `lem:GrpObj_omega_basechange_proj` proof
     (L471–480)**: add a paragraph or `% NOTE iter-137:` block
     acknowledging the `PresheafOfModules.pullback` chart-opacity
     gap. Either (a) name the chart-unfolding helper
     `pullbackObjEquivTensor` (~30–60 LOC) as a required
     infrastructure piece in the recipe, or (b) document the
     alternative inverse-direction-via-adjunction-transpose route
     (~100–200 LOC for the derivation construction +
     `isomorphism-from-inverse` pattern) as a viable alternative
     closure path. This makes the blueprint actionable for iter-138+
     provers without their having to rediscover the gap.
  2. **In `AlgebraicJacobian_Cotangent_GrpObj.tex`** (or
     `RigidityKbar.tex` under piece (i.b) prose): promote
     `schemeHomRingCompatibility` to a `\lean{...}` block (it is
     listed only in the pointer chapter's itemize, not in
     RigidityKbar.tex).

## Directive question audit

1. **Did the new docstrings introduce excuse-comments or false claims
   that the body is closer to closed than it really is?**
   No. The docstring updates at L429–450, L474–499, L504–509, L616–623
   honestly report `sorry` status. The forward-looking "iter-138+
   next step" framing is project planning prose, not an excuse-comment.
   The LOC estimate "(~360–710 LOC total)" at L499 is consistent with
   the blueprint's "$\sim 150$--$300$ LOC" for the load-bearing helper
   plus the additional chart-unfolding infrastructure the iter-137
   analysis surfaced (the larger range honestly reflects the iter-137
   PARTIAL finding).

2. **Does the iter-137 inverse-direction analysis (docstring L479–499)
   accurately predict the iter-138+ closure path, or misrepresent the
   blueprint's prose?**
   The docstring accurately predicts the iter-138+ closure path. The
   `pullbackPushforwardAdjunction` transpose + universal property of
   `relativeDifferentials' φ_G` + derivation route was validated as
   compiling-typeable by the prover (`lean_run_code` sketch at
   `task_results/Cotangent_GrpObj.lean.md` L67–81). The docstring does
   NOT misrepresent the blueprint's prose; instead it **surfaces a
   gap** in the blueprint's chart-by-chart recipe (see Blueprint
   adequacy above). The docstring is honest about both directions:
   forward route blocked by chart-opacity, inverse route feasible but
   requires derivation construction (~100–200 LOC sub-goal).

3. **Are the `\lean{...}` hints in `RigidityKbar.tex` still correctly
   pinned to the still-sorry signatures (no signature drift since
   iter-135)?**
   Yes, both `\lean{...}` hints (RigidityKbar L425 for
   `_basechange_along_proj_two` and L333 for `mulRight_globalises_cotangent`)
   still pin precisely to the iter-135 signatures, unchanged this
   iter. The iter-137 docstring-only session preserved all signatures
   exactly. No drift.

4. **Blueprint adequacy: did the prover's inverse-direction finding
   surface a blueprint-side prose gap that should be addressed by a
   future blueprint-writer dispatch?**
   YES. The blueprint's chart-by-chart recipe at RigidityKbar L471–480
   does not anticipate the `PresheafOfModules.pullback` chart-opacity
   blocker, and so does not document either (a) the chart-unfolding
   helper needed to make the chart-by-chart route work, or (b) the
   alternative inverse-direction-via-adjunction-transpose route. A
   blueprint-writer dispatch in iter-138 plan phase should add either
   a `% NOTE iter-137:` block or expanded prose covering one of these
   alternatives, so future provers do not have to rediscover the gap
   via independent analysis. **Recommended**: dispatch
   blueprint-writer to address `RigidityKbar.tex` L471–480 in iter-138
   plan phase. (Severity: minor — the Lean docstring at L479–499 is a
   sufficient interim record; the blueprint can lag by one iter
   without blocking iter-138+ closure work.)

## Severity summary

- **must-fix-this-iter**: NONE. The two `sorry` bodies are pinned to
  `\notready` blueprint proof blocks per the directive's instructions
  and are NOT re-flagged. No excuse-comments, no fake-placeholder
  bodies on `\leanok`-claimed statements, no signature drift, no
  unauthorised axioms.
- **major**: NONE. All seven `\lean{...}`-tagged declarations have
  signatures that match the blueprint's prose; no missing
  `\lean{...}` references on substantive declarations.
- **minor**:
  1. Blueprint adequacy: `RigidityKbar.tex` proof of
     `lem:GrpObj_omega_basechange_proj` (L471–480) is under-specified
     re: the `PresheafOfModules.pullback` chart-opacity blocker.
     Recommend iter-138 blueprint-writer dispatch to add a NOTE or
     prose paragraph documenting either the chart-unfolding helper
     route or the inverse-direction-via-adjunction route. The Lean
     docstring at L479–499 is a sufficient interim record.
  2. `_basechange_along_proj_two` signature (L500–507) carries the
     instance binders `{n : ℕ} [SmoothOfRelativeDimension n G.hom]
     [IsProper G.hom] [GeometricallyIrreducible G.hom]` which are not
     required by the mathematical statement (the iso is independent of
     smoothness/properness/geometric-irreducibility). Minor
     over-constraint matching the consumer's context; deferrable.
  3. Blueprint coverage: `schemeHomRingCompatibility` (Lean L423) is
     listed in the pointer chapter but lacks a `\lean{...}` block in
     RigidityKbar.tex. Cleanup deferrable.

Overall verdict: **PASS for the iter-137 docstring-only PARTIAL
session** — Lean ↔ blueprint stay aligned, no must-fix findings, no
signature drift; the docstring honestly records the iter-137
PARTIAL state and points downstream at the validated iter-138+
closure path. The lone non-trivial finding is a blueprint-side prose
gap (chart-opacity blocker un-anticipated) which can be addressed by a
single-iter blueprint-writer dispatch and does not block prover work.
