# Lean ↔ Blueprint Check Report

## Slug
cotangent-grpobj-review143

## Iteration
143

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/GrpObj.lean` (903 LOC)
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex` (1634 LOC)

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` (chapter: `lem:GrpObj_cotangentSpace`, L92–110)
- **Lean target exists**: yes (L162–201)
- **Signature matches**: yes — the iter-129 `{n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom] : ModuleCat k` shape is reproduced exactly in the blueprint's stub.
- **Proof follows sketch**: yes — Replacement (B), pure-term `Classical.choose`-chain on `Scheme.smooth_locally_free_omega`, body is `(ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of … Ω[…])`. Matches blueprint Step 1–5 sketch (L115–122).
- **notes**: full closure, sorry-free.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars}` (chapter: `lem:GrpObj_cotangentSpace_extendScalars_witness`, L124–160)
- **Lean target exists**: yes (L211–232)
- **Signature matches**: yes — blueprint stub at L134–147 reproduces the existential bundle `⟨U, V, e, htop, equation⟩` exactly.
- **Proof follows sketch**: yes — blueprint proof says "rfl once the right-hand side's `Classical.choose`-chain is unpacked on the same existential as the body's"; Lean uses `refine ⟨h.choose, ..., rfl⟩` after extracting witnesses.
- **notes**: full closure, sorry-free.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq}` (chapter: `lem:GrpObj_lieAlgebra_finrank`, L218–280)
- **Lean target exists**: yes (L257–295)
- **Signature matches**: yes — `Module.finrank k (cotangentSpaceAtIdentity G) = n`.
- **Proof follows sketch**: yes — Steps 1+2 live path: re-run the `Classical.choose`-chain, extract `hrank`/`hfree`, apply `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`. Lean body matches blueprint outline at L244–264 verbatim.
- **notes**: full closure, sorry-free.

### `\lean{AlgebraicGeometry.GrpObj.shearMulRight}` (chapter: `lem:GrpObj_shearMulRight`, L282–329)
- **Lean target exists**: yes (L350–384)
- **Signature matches**: yes — `def shearMulRight {C : Type*} [Category C] [CartesianMonoidalCategory C] (G : C) [GrpObj G] : G ⊗ G ≅ G ⊗ G`. Carrier `@[simps]` reproduced.
- **Proof follows sketch**: yes — `hom_inv_id` / `inv_hom_id` reduced via `CartesianMonoidalCategory.hom_ext`; second-projection cases closed via `MonObj.lift_lift_assoc` + `lift_comp_inv_left`/`lift_comp_inv_right` + `MonObj.lift_comp_one_left`. Matches blueprint L322–328 calculus list.
- **notes**: full closure, sorry-free. The `@[simps]`-spawned companions `shearMulRight_hom_fst` / `shearMulRight_hom_snd` (L387–394) are explicitly endorsed in the blueprint at L299–301.

### `\lean{AlgebraicGeometry.GrpObj.schemeHomRingCompatibility}` (chapter: `def:GrpObj_schemeHomRingCompatibility`, L427–437)
- **Lean target exists**: yes (L424–426)
- **Signature matches**: yes — `(TopCat.Presheaf.pullback (C := CommRingCat) f.base).obj Z.presheaf ⟶ Y.presheaf`, body `((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm f.c`. The blueprint informal $f_{\mathrm{top}}^{-1}\mathcal O_Z \to \mathcal O_Y$ via the adjunction transpose matches verbatim.
- **Proof follows sketch**: N/A (definition).
- **notes**: definition; sorry-free. The accompanying remark `rem:GrpObj_schemeHomRingCompatibility_vs_toRingCatSheafHom` distinguishing this from `toRingCatSheafHom` is mirrored in the Lean docstring (L420–423).

### `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_derivation}` (chapter: `lem:GrpObj_omega_basechange_proj_inv_derivation`, L1369–1452)
- **Lean target exists**: yes (L573–700)
- **Signature matches**: yes — `((PresheafOfModules.pushforward (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj (Scheme.relativeDifferentialsPresheaf (fst G G).left)).Derivation' (((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat G.hom.base).homEquiv _ _).symm G.hom.c)`. Blueprint stub at L1377–1383 matches verbatim.
- **Proof follows sketch**: partial. d_add / d_mul are closed honestly (matches blueprint L1442–1448 + the `have h ; change ; rw [h] ; exact` pattern codified in the iter-138 d_add/d_mul negative-lesson NOTE at L596–611); d_map is closed iter-142 (L664–700) using the iter-142 empirical Rule 1 fully-explicit `change` + Rule 2 `NatTrans.naturality_apply`-via-`show` packaging (blueprint L727–769); d_app remains `sorry` at L663 with the iter-143 1-LOC `hw` (categorical equality from `(fst G G).w` + `(snd G G).w`) committed but the residual nat-trans chase (sub-steps 3.b–3.d of the blueprint recipe at L786–865) deferred.
- **notes**: d_app residual is the documented iter-143+ target. Recipe coverage in the blueprint NOTE block at L786–865 is detailed (sub-steps 3.a/3.b/3.c/3.d with LOC bands and Mathlib name pins).

### `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv}` (chapter: `lem:GrpObj_omega_basechange_proj_inv`, L1454–1522)
- **Lean target exists**: yes (L711–725)
- **Signature matches**: yes — pullback-along-ψ of `relativeDifferentialsPresheaf G.hom` maps into `relativeDifferentialsPresheaf (fst G G).left`. Blueprint stub L1465–1470 matches verbatim.
- **Proof follows sketch**: N/A (definition; the universal-property `desc` + adjunction-transpose composition matches L1508–1510 verbatim).
- **notes**: sorry-free as a definition (the iso property is carried separately by `basechange_along_proj_two_inv_app_isIso` — see below).

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}` (chapter: `lem:GrpObj_omega_basechange_proj`, L445–1367)
- **Lean target exists**: yes (L753–774)
- **Signature matches**: yes — iso between `relativeDifferentialsPresheaf (fst G G).left` and the pullback-along-`snd.left` of `relativeDifferentialsPresheaf G.hom`. The iter-143 Lean refactor extracts the per-open IsIso obligation into a named theorem; the consuming `letI : IsIso ... := isIso_of_app_iso_module ... (basechange_along_proj_two_inv_app_isIso ...)` then `(asIso (...) ).symm` materialises the iso. Matches blueprint signature stub L457–461.
- **Proof follows sketch**: partial — Route (b'2) via `isIso_of_app_iso_module` + the named per-open IsIso theorem. Sorry is now in `basechange_along_proj_two_inv_app_isIso`, not inline.
- **notes**: the iter-143 in-Lean shape refactor is documented in the blueprint at L1132–1165 (a NOTE inside the proof block explaining that the IsIso residual moved from an in-line `(fun _ => sorry)` argument to a named sorry-bodied theorem). The Route (b'2) recipe (items 2–4 with concrete sub-recipes for `Algebra.IsPushout`, `pullbackObjEquivTensor`, `tensorKaehlerEquiv.symm` identification) is preserved and expanded with iter-143 sketches at L1250–1320.

### `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso}` — NEW iter-143 declaration
- **Lean target exists**: yes (L745–751); body `sorry`.
- **Blueprint block exists**: **NO** — there is no standalone `\begin{theorem}\label{...}\lean{...}` block dedicated to this new theorem. The only blueprint mention of the name is at L1141, inside a `% NOTE iter-143` comment block in the proof of `lem:GrpObj_omega_basechange_proj`.
- **Signature matches**: N/A (no blueprint signature to compare against).
- **Proof follows sketch**: the closure recipe for the body is documented at L1167–1320 (Route (b'2) items 1–4, with item 1 closed by `isIso_of_app_iso_module` and items 2–4 deferred to iter-144+). The narrative recipe is adequate, but it lives inside the NOTE comment block of the consumer's proof rather than as a first-class blueprint declaration.
- **notes**: **blueprint adequacy gap** — the iter-143 Lean refactor introduced a new top-level theorem whose obligation `∀ X, IsIso ((basechange_along_proj_two_inv G).app X)` deserves its own `\begin{theorem}\label{lem:GrpObj_basechange_along_proj_two_inv_app_isIso}\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso}` block in the blueprint. Currently audit-visible only via the `\lean{...}` inside a `%`-commented NOTE.

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section}` (chapter: `lem:GrpObj_omega_restrict_to_identity_section`, L1524–1570)
- **Lean target exists**: yes (L794–837)
- **Signature matches**: yes — both sides of the iso use the four-fold `PresheafOfModules.pullback`-with-`toRingCatSheafHom`-compatibility-morphism shape. Blueprint stub at L1531–1540 matches verbatim.
- **Proof follows sketch**: yes — `PresheafOfModules.pullbackComp` on both sides + the categorical identity `pr_2 ∘ s = η_G ∘ π_G` packaged in the private helper `section_snd_eq_identity_struct` at L458–463. Matches blueprint L1567–1569.
- **notes**: closed iter-136, sorry-free.

### `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}` (chapter: `lem:GrpObj_mulRight_globalises`, L331–425)
- **Lean target exists**: yes (L890–901)
- **Signature matches**: yes — iso `relativeDifferentialsPresheaf G.hom ≅ pullback π_G (pullback η_G (relativeDifferentialsPresheaf G.hom))` at the presheaf-of-modules level. Blueprint stub at L347–354 matches verbatim.
- **Proof follows sketch**: N/A — body is `sorry`. Recipe (Step 1 shear iso + Step 2 base-change + Step 3 section restrict + compose) is detailed at L407–424; closure pending Step 2 IsIso closure.
- **notes**: documented `sorry` (the main piece (i.b) target, awaiting `relativeDifferentialsPresheaf_basechange_along_proj_two` IsIso closure).

## Red flags

### Placeholder / suspect bodies

Three `sorry`s remain; all are documented and authorized by the blueprint's iter-138+ recipe-in-progress:

- `basechange_along_proj_two_inv_derivation` at L663 (d_app sub-goal): the iter-143 lean-shape commitment landed a 1-LOC `have hw` (categorical equality from `(fst G G).w` + `(snd G G).w`) and the canonical `change`-form goal, but the bespoke nat-trans chase (Step 3.b–3.d of the blueprint recipe at L786–865) remains `sorry`. The blueprint authorises this as the iter-143 narrowed target (per the iter-143 NOTE at L1161–1165).
- `basechange_along_proj_two_inv_app_isIso` at L751 (iter-143 NEW): the per-open IsIso obligation, extracted by the iter-143 in-Lean refactor from an in-line `(fun _ => sorry)`. Blueprint authorises this iter-144+ target via the Route (b'2) items 2–4 recipe at L1250–1320.
- `mulRight_globalises_cotangent` at L901 (main piece (i.b) target): blueprint documents that this `sorry` awaits Step 2 closure (i.e., closure of `relativeDifferentialsPresheaf_basechange_along_proj_two`'s IsIso sub-piece). Authorised iter-138+ scaffold.

None of these are placeholder bodies on declarations the blueprint claims are substantively closed; all three live on iter-138/iter-143+ work-in-progress declarations whose blueprint blocks carry detailed closure recipes.

### Excuse-comments
None. The lengthy docstrings on `basechange_along_proj_two_inv_derivation` (L520–572), `basechange_along_proj_two_inv` (L702–710), `relativeDifferentialsPresheaf_basechange_along_proj_two` (L726–744), and the new `basechange_along_proj_two_inv_app_isIso` (L727–744) document proof design, route choices, and audit-visibility considerations — explicitly endorsed by the iter-140/142 lean-auditor verdicts as NOT excuse-comments (per directive). The in-Lean recipe scaffolding at L640–662 (the iter-143 d_app residual) is a working-notes block consistent with the blueprint's tracked-residual prose at L786–865.

### Axioms / Classical.choice on non-trivial claims
- `cotangentSpaceAtIdentity` body uses `Classical.choose` (chart `V`, etc.); explicitly authorized by the blueprint (L121 "Caveat on canonicity") and downstream-immaterial for rigidity.
- No new `axiom` declarations.

## Unreferenced declarations (informational)
- `shearMulRight_hom_fst` (L387), `shearMulRight_hom_snd` (L392) — `@[simps]`-spawned companions of `shearMulRight`. Blueprint mentions them by name at L300–301; no own `\lean{...}` block, but acceptable since `@[simps]` auto-generation is the blueprint-endorsed pattern.
- `section_snd_eq_identity_struct` (L458, private) — helper used only inside `relativeDifferentialsPresheaf_restrict_along_identity_section`. Blueprint NOTE at L1549–1552 explicitly authorises it as "(\~5 LOC) helper".
- `isIso_of_app_iso_module` (L544, private) — Route (b'2) iso-reflection bridge. Blueprint authorises it explicitly: the verbatim Lean source is included at L1188–1196, with the existence of the helper acknowledged across L1183–1232. No standalone `\lean{...}` block (it's private and listed as item (1) of the Route (b'2) build list), but the inline code-block treatment is adequate for a private helper.

## Blueprint adequacy for this file

- **Coverage**: 9/10 substantive Lean declarations have a corresponding `\lean{...}` block. Unreferenced: 2 `@[simps]`-companion lemmas (acceptable; blueprint endorses by name), 2 private helpers (acceptable; blueprint endorses inline). **One substantive declaration lacks a blueprint block**: `basechange_along_proj_two_inv_app_isIso` (iter-143 NEW). The recipe is documented inside a `%`-comment NOTE at L1132–1165 but not in a first-class `\begin{theorem}` block. Recommend adding a proper block before iter-144+'s prover lane attacks the body.

- **Proof-sketch depth**: adequate-to-excellent. The chapter carries unusually detailed, iteratively-refined closure recipes: the iter-142 empirical-lessons Rules 1/2/3 at L713–784, the iter-142 Step 3 sub-recipe at L786–865, the iter-143 d_app residual scaffold endorsement (1-LOC `hw` + canonical `change`-form + deferred bespoke chase) at L1162–1163, the Route (b'2) items 2–4 sub-recipes at L1245–1320 with concrete Mathlib name pins (`CommRingCat.isPushout_iff_isPushout`, `pullbackSpecIso`, `isPullback_SpecMap_of_isPushout`, `tensorKaehlerEquiv_symm_D_tmul`). A prover attacking any of the three remaining residuals from prose alone has enough scaffolding.

- **Hint precision**: precise — every `\lean{...}` ties to an exact Lean identifier with verified namespacing, and the surrounding stubs at L100–102 / L134–147 / L347–354 / L457–461 / L1377–1383 / L1465–1470 / L1531–1540 spell the full signature shape (including instance binders).

- **Generality**: matches need — signatures are at the right level (presheaf-of-modules, not sheafified) per the iter-133 mathlib-analogist Decision 4 and iter-134 plan-agent pre-commitment.

- **Recommended chapter-side actions**:
  - **MAJOR**: Add a standalone `\begin{theorem}\label{lem:GrpObj_basechange_along_proj_two_inv_app_isIso}\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso}` block for the iter-143 NEW Lean theorem at L745–751. The body recipe is already documented inline at L1167–1320; promoting it to a first-class block (with a brief proof block citing Route (b'2) items 2–4) would restore one-to-one blueprint↔Lean coverage and let the iter-144+ prover lane orient against a named target. Estimated <30 LOC of new blueprint prose.
  - **MINOR**: The iter-143 plan-agent's iter-144+ stale-marker cleanup list (per directive) already flags the pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` iter-138 status text ("d_app + d_map + IsIso") as stale (d_map closed iter-142; d_app remains; named IsIso theorem replaced the in-line sorry). Cosmetic.

## Severity summary

- **must-fix-this-iter**: none. All three remaining sorries are on declarations whose blueprint blocks document the residual gap, with detailed closure recipes (per the iter-138/iter-142/iter-143 NOTE blocks). No placeholder bodies on declarations the blueprint claims are substantively closed.
- **major**: missing `\begin{theorem}\lean{...}` block for the iter-143 NEW `basechange_along_proj_two_inv_app_isIso` Lean theorem. The named theorem's existence and its body's closure recipe ARE documented in a NOTE-comment at L1141 + the surrounding Route (b'2) recipe, but the blueprint does not have a first-class block for it — recommend the iter-144+ blueprint-writer lane add one. Plan-agent gate: this should not block prover work on the body since the recipe is fully written; it should land in the blueprint-writer queue alongside iter-144+ work.
- **minor**: pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` iter-138 status line is stale (already on the iter-143 plan-agent's cleanup list per the directive's known-issues note).

Overall verdict: Lean follows the blueprint faithfully; signatures and proof structure match across all 9 referenced declarations; the iter-143 in-Lean refactor (named `basechange_along_proj_two_inv_app_isIso` theorem) is mathematically authorised by the blueprint NOTE at L1132–1165 but needs a first-class `\begin{theorem}` block before iter-144+ closure work, no must-fix-this-iter findings.
