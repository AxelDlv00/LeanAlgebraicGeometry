# Lean ↔ Blueprint Check Report

## Slug
cotangent-grpobj-review140

## Iteration
140

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/GrpObj.lean` (819 LOC)
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex` (1224 LOC; pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` also re-references the same Lean targets)

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` (chapter: lem:GrpObj_cotangentSpace, L92)
- **Lean target exists**: yes (Lean L162)
- **Signature matches**: yes — `(G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom] : ModuleCat k` matches the chapter's verbatim Lean signature stub (L100–L102).
- **Proof follows sketch**: yes (no `sorry`) — body realises Replacement (B): `Classical.choose`-chain through `Scheme.smooth_locally_free_omega` extracting `U, V, e, hxV`, then outer `(ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of … Ω[…])`. Matches blueprint's iter-131 "Classical.choose-chain body shape" paragraph (L1194–L1198) verbatim.
- **notes**: none

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars}` (chapter: lem:GrpObj_cotangentSpace_extendScalars_witness, L124)
- **Lean target exists**: yes (Lean L211)
- **Signature matches**: yes — the existential statement exposing `(U, V, e, htop)` plus the explicit equation matches the chapter's verbatim Lean signature stub (L134–L147).
- **Proof follows sketch**: yes (no `sorry`) — reproduces the body's `Classical.choose`-chain and closes by `rfl` (modulo `change` + `Subsingleton.elim` for `htop`). Matches blueprint sketch at L159.
- **notes**: none

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent}` (chapter: lem:GrpObj_cotangent_bridge, L162)
- **Lean target exists**: no — explicitly deferred (chapter marks `\notready`, vestigial under Replacement (B) per iter-131 strategy-critic Q4 collapse).
- **Signature matches**: N/A (no Lean target)
- **Proof follows sketch**: N/A
- **notes**: deferral is consistent with blueprint prose; no action needed.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq}` (chapter: lem:GrpObj_lieAlgebra_finrank, L218)
- **Lean target exists**: yes (Lean L257)
- **Signature matches**: yes — `Module.finrank k (cotangentSpaceAtIdentity (n := n) G) = n` matches the verbatim Lean signature stub (L225–L228).
- **Proof follows sketch**: yes (no `sorry`) — Steps 1+2 closure: reproduces the same `Classical.choose`-chain, extracts `hfree`/`hrank`, runs `change` to expose the `TensorProduct` carrier, then `Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`. Matches blueprint's "live closure path" (L244–L265) verbatim.
- **notes**: none

### `\lean{AlgebraicGeometry.GrpObj.shearMulRight}` (chapter: lem:GrpObj_shearMulRight, L282)
- **Lean target exists**: yes (Lean L350)
- **Signature matches**: yes — `def shearMulRight (G : C) [GrpObj G] : G ⊗ G ≅ G ⊗ G` with `hom = lift (fst G G) μ`, `inv = lift (fst G G) (lift (fst G G ≫ ι) (snd G G) ≫ μ)` matches the Lean signature stub (L295–L298) and the companion-lemma stubs (L300–L301).
- **Proof follows sketch**: yes (no `sorry`) — both `hom_inv_id` and `inv_hom_id` close componentwise via `CartesianMonoidalCategory.hom_ext`, then `lift_lift_assoc` + `GrpObj.lift_comp_inv_left/right` + `MonObj.lift_comp_one_left`. Matches blueprint sketch at L322–L328.
- **notes**: companion lemmas `shearMulRight_hom_fst` (L387) and `shearMulRight_hom_snd` (L391) are auto-generated via `@[reassoc (attr := simp)]`; blueprint mentions both in the Lean signature stub (L300–L301), so they're previewed even without a separate `\lean{...}` block.

### `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}` (chapter: lem:GrpObj_mulRight_globalises, L331)
- **Lean target exists**: yes (Lean L806)
- **Signature matches**: yes — sheaf-level RHS `relativeDifferentialsPresheaf G.hom ≅ (PresheafOfModules.pullback ⟨π_G⟩).obj ((PresheafOfModules.pullback ⟨η_G⟩).obj (relativeDifferentialsPresheaf G.hom))` with compatibility morphisms inline via `Scheme.Hom.toRingCatSheafHom`. Matches the verbatim Lean signature stub (L347–L354) and the iter-135 mathlib-analogist Decision 4 commitment.
- **Proof follows sketch**: N/A — body is `sorry` (L817). Chapter marks `\notready` (L382) and the proof block records the Step 1/2/3/Compose outline (L403–L416). The `sorry` is explicitly acknowledged and tracked.
- **notes**: body `sorry` is documented as iter-141+ work pending Step 2 closure; not a placeholder for a fake substantive claim.

### `\lean{AlgebraicGeometry.GrpObj.schemeHomRingCompatibility}` (chapter: def:GrpObj_schemeHomRingCompatibility, L423)
- **Lean target exists**: yes (Lean L424)
- **Signature matches**: yes — `(TopCat.Presheaf.pullback (C := CommRingCat) f.base).obj Z.presheaf ⟶ Y.presheaf` constructed via `pullbackPushforwardAdjunction.homEquiv.symm f.c` matches the blueprint's adjunction-transpose framing (L428–L432).
- **Proof follows sketch**: N/A (pure definition)
- **notes**: companion remark `rem:GrpObj_schemeHomRingCompatibility_vs_toRingCatSheafHom` (L435) explicitly disambiguates this from the `Scheme.Hom.toRingCatSheafHom` shape used inside `PresheafOfModules.pullback` consumers; matches the Lean docstring at L419–L423.

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}` (chapter: lem:GrpObj_omega_basechange_proj, L441)
- **Lean target exists**: yes (Lean L670)
- **Signature matches**: yes — `Scheme.relativeDifferentialsPresheaf (fst G G).left ≅ (PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj (Scheme.relativeDifferentialsPresheaf G.hom)` matches the iter-135 mathlib-analogist verdict and the chapter's prose at L482–L486.
- **Proof follows sketch**: partial — body is the iter-140 Route (b'2) skeleton: `letI : IsIso (basechange_along_proj_two_inv G) := isIso_of_app_iso_module ... (fun _ => sorry)` then `(asIso ...).symm` (Lean L688–L690). The per-open `sorry` at Lean L689 is exactly the third concrete sub-goal of the iter-139 NOTE block (L890–L920), namely the per-open identification with `tensorKaehlerEquiv.symm` modulo `pullbackObjEquivTensor`. Iter-140's structural refactor (introducing `isIso_of_app_iso_module`) is faithful to the blueprint's iter-139 "5-line iso-reflection bridge" prescription (L858–L871, verbatim).
- **notes**: blueprint preview is unusually thorough — Route (b'2) is explicitly named, the 5-line code block for `isIso_of_app_iso_module` is reproduced verbatim, and the four iter-140 gap items are enumerated in build order (L909–L920). See "Blueprint adequacy" below.

### `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_derivation}` (chapter: lem:GrpObj_omega_basechange_proj_inv_derivation, L969)
- **Lean target exists**: yes (Lean L573)
- **Signature matches**: yes — the `Derivation'` carrier `((pushforward ψ).obj LHS).Derivation' φ_G` with `φ_G` obtained via `pullbackPushforwardAdjunction.homEquiv.symm G.hom.c` matches the verbatim Lean signature stub (L977–L983).
- **Proof follows sketch**: partial — body uses `PresheafOfModules.Derivation'.mk + ModuleCat.Derivation.mk` with the pointwise rule `d_X(b) := KaehlerDifferential.D _ ((ψ.app X).hom b)`. `d_add` (Lean L586–L593) and `d_mul` (L594–L601) close honestly via the `RingHom.map_add/map_mul` + `change` + `rw` + `ModuleCat.Derivation.d_add/d_mul` pattern. `d_app` (L624) and `d_map` (L643) remain `sorry`. Matches blueprint's iter-138 prose at L1037–L1046 and the iter-138 d_app / d_map closure recipes (L594–L700).
- **notes**: iter-140 added an in-Lean `change` scaffold + 16-line closure-recipe docstring on `d_app` (L603–L622) and an 18-line docstring on `d_map` (L626–L642). These docstrings closely mirror the blueprint's iter-138 NOTE blocks; no divergence.

### `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv}` (chapter: lem:GrpObj_omega_basechange_proj_inv, L1049)
- **Lean target exists**: yes (Lean L654)
- **Signature matches**: yes — `(PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj (Scheme.relativeDifferentialsPresheaf G.hom) ⟶ Scheme.relativeDifferentialsPresheaf (fst G G).left` matches the verbatim Lean signature stub (L1060–L1065).
- **Proof follows sketch**: N/A — pure definition, no `sorry` in the body itself. Construction reads `((pullbackPushforwardAdjunction ψ).homEquiv MG LHS).symm univStep` where `univStep := (DifferentialsConstruction.isUniversal' φG).desc (basechange_along_proj_two_inv_derivation G)`. Matches the blueprint's iter-138 prose at L1098–L1101 verbatim.
- **notes**: the iso property `IsIso (basechange_along_proj_two_inv G)` is the third remaining concrete sub-sorry (Lean L689), explicitly acknowledged in this lemma's chapter block at L1085–L1092.

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section}` (chapter: lem:GrpObj_omega_restrict_to_identity_section, L1114)
- **Lean target exists**: yes (Lean L710)
- **Signature matches**: yes — the two-step nested-pullback iso with four `Scheme.Hom.toRingCatSheafHom` compatibility morphisms inline matches the verbatim Lean signature stub (L1121–L1130).
- **Proof follows sketch**: yes (no `sorry`) — closed via `PresheafOfModules.pullbackComp` on both sides, then `eqToIso` after `section_snd_eq_identity_struct` identifies the composed morphisms. Matches the iter-136 closure described in the chapter at L1136–L1149 (no `sorry`; closed via the new private helper `section_snd_eq_identity_struct`).
- **notes**: no issue.

## Red flags

(No must-fix-this-iter findings.)

### Placeholder / suspect bodies
None — all four sorries (Lean L624, L643, L689, L817) correspond to concrete sub-goals that the blueprint substantively documents:
- L624 (`d_app`): blueprint d_app closure recipe at L594–L651 (3-step categorical-chase recipe, verbatim).
- L643 (`d_map`): blueprint d_map closure recipe at L653–L700 (2-piece ψ-naturality + `KaehlerDifferential.map_d` chase).
- L689 (per-open IsIso inside `(fun _ => sorry)`): Route (b'2) at L842–L958 (5-line bridge + per-open `tensorKaehlerEquiv.symm` identification, iter-140 prover-lane targets in build order at L909–L920).
- L817 (`mulRight_globalises_cotangent` body): Steps 1/2/3/Compose outline at L403–L416 (Step 2 still partial, blocks Compose).

### Excuse-comments
None. The Lean docstrings around the open sorries explicitly call out "iter-141+ target" or "iter-140 prover-lane target" with concrete closure recipes — these are workflow status markers tied to dated planning, not "we are using a wrong definition" excuses.

### Axioms / Classical.choice on non-trivial claims
- `Classical.choose`-chains inside `cotangentSpaceAtIdentity` body (L175–L181) and `cotangentSpaceAtIdentity_finrank_eq` proof (L264–L268) are authorised by the blueprint's iter-131 Caveat on canonicity (L121) and the iter-131 Classical.choose-chain body-shape paragraph (L1194–L1198). The use is non-canonical-as-value but mathematically faithful; explicitly previewed.
- No new `axiom` declarations; no `Classical.choice _` outermost head symbol on substantive claims.

### Stale blueprint markers (sync_leanok territory — informational only)

These are observations only; per CLAUDE.md `\leanok` is the deterministic `sync_leanok` phase's territory, not the review agent's, so I flag without proposing an edit.

- `lem:GrpObj_omega_basechange_proj`'s **proof block** (L505): `\leanok` is present, but the body has sorries at Lean L624, L643, L689. The iter-139 NOTE block at L491–L504 *already explicitly flags* this as a probable `sync_leanok` mis-mark on a `letI : IsIso ... := sorry` pattern; iter-140's structural refactor moved that pattern to a plain `(fun _ => sorry)` inside an `isIso_of_app_iso_module` application — still sorry-laden, so the mis-mark persists.
- `lem:GrpObj_omega_basechange_proj_inv_derivation`'s **proof block** (L1032): `\leanok` is present, but the body has sorries at Lean L624 and L643.
- `lem:GrpObj_mulRight_globalises`'s **proof block** (L402): `\leanok` is present, but the body is plain `sorry` at Lean L817.
- Mirror image: `lem:GrpObj_omega_basechange_proj` (L481), `lem:GrpObj_omega_basechange_proj_inv_derivation` (L985), `lem:GrpObj_omega_basechange_proj_inv` (L1067), and `lem:GrpObj_mulRight_globalises` (L382) all carry **statement-side** `\notready` even though the Lean targets are formalized (with or without sorries). Per CLAUDE.md marker vocab, formalized statements should have `\leanok` regardless of sorries; `\notready` is a legacy marker the review agent removes when stale.

Recommendation: the iter-140 plan agent should run `doctor` / verify `sync_leanok` handles the `(fun _ => sorry)` and plain-`sorry` patterns alike; the iter-139 NOTE block at L491–L504 already flagged this as a doctor consult target.

## Unreferenced declarations (informational)

Lean declarations without a `\lean{...}` reference:
- `shearMulRight_hom_fst` (L387) — `@[reassoc (attr := simp)]` companion of `shearMulRight`; previewed in the chapter's Lean stub at L300. Acceptable.
- `shearMulRight_hom_snd` (L391) — same; previewed at L301. Acceptable.
- `section_snd_eq_identity_struct` (L458, `private`) — local categorical-identity helper used inside `relativeDifferentialsPresheaf_restrict_along_identity_section`. Previewed in the chapter's iter-136 NOTE block at L1140–L1141. Acceptable as `private` helper.
- `isIso_of_app_iso_module` (L544, `private`, **iter-140 new**) — iso-reflection bridge for `PresheafOfModules` morphisms. **Per directive question**: confirmed adequate without a dedicated `\lean{...}` block — the blueprint's iter-139 NOTE block at L858–L871 reproduces the helper's 5-line body **verbatim** inside the closure-recipe prose, names it precisely (`isIso_of_app_iso_module`), and even cites the two transitive Mathlib facts it chains. This is unusually thorough preview-as-prose; a separate `\lean{...}` block would be redundant given that the helper is `private`. **No action needed.**

## Blueprint adequacy for this file

- **Coverage**: 9/9 substantive Lean declarations have a corresponding `\lean{...}` block. Helpers: 2 `@[simps]`-companions (previewed in stub), 2 `private` helpers (one — `isIso_of_app_iso_module` — previewed verbatim in prose; one — `section_snd_eq_identity_struct` — previewed in NOTE block). 0 substantive Lean declarations without a chapter block.
- **Proof-sketch depth**: **adequate** — every open sorry has a substantively-detailed closure recipe in the blueprint. The iter-138 d_app/d_map recipes (L594–L700), the iter-139 Route (b'2) IsIso recipe (L842–L958), the iter-138 NOTE block enumeration of the three sub-sorries with line numbers (L530–L573), and the iter-139 NOTE on the `letI := sorry` `sync_leanok` mis-mark concern (L491–L504) collectively give a prover enough to attempt closure without re-deriving the strategy. Iter-139's +468 LOC expansion is load-bearing for iter-140 and remains adequate for iter-141 work.
- **Hint precision**: **precise** — every `\lean{...}` block names a fully-qualified declaration whose Lean signature is reproduced verbatim in the surrounding comment-stub (e.g. L100–L102, L295–L298, L347–L354, L977–L983). The iter-135 `Scheme.Hom.toRingCatSheafHom` idiom for `PresheafOfModules.pullback` compatibility morphisms is explicitly pinned across all four iter-138+ helpers; no guess-work for the prover.
- **Generality**: **matches need** — sheaf-level `PresheafOfModules` framing (vs. value-level `ModuleCat k`) is exactly what piece (i.b) requires and explicitly decoupled from chart localisation (which is piece (i.c) territory, L420 + L774–L775). Statement bindings (`{n : ℕ} [SmoothOfRelativeDimension n G.hom]`) match the consumer downstream (`omega_free`, `omega_rank_eq_dim`).
- **Recommended chapter-side actions**: none load-bearing for iter-140 sign-off. Optional housekeeping for iter-141 plan:
  - The chapter's iter-139 NOTE block at L491–L504 should be updated by a future plan/blueprint-writer pass to reflect that iter-140's structural refactor moved the IsIso scaffold from `letI := sorry` to `(fun _ => sorry)` inside `isIso_of_app_iso_module` — the same `sync_leanok` mis-mark concern persists, but the pattern shape has changed.
  - No new `\lean{...}` block needed for `isIso_of_app_iso_module` (verbatim-in-prose preview is adequate; helper is `private`).

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - Stale `\leanok` markers on three proof blocks (`lem:GrpObj_mulRight_globalises` L402, `lem:GrpObj_omega_basechange_proj` L505, `lem:GrpObj_omega_basechange_proj_inv_derivation` L1032) and stale `\notready` markers on four statement blocks of formalized targets. Both are `sync_leanok`'s territory, not the review agent's; the iter-139 NOTE block at L491–L504 already flagged the first instance.
  - Chapter's iter-139 NOTE block at L491–L504 references the iter-138 `letI := sorry` pattern; iter-140's refactor changed the shape to `(fun _ => sorry)` inside an `isIso_of_app_iso_module` application. Note text is not actively wrong (the `sync_leanok` concern still applies), but is no longer perfectly current.

Overall verdict: **PASS** — Lean follows blueprint faithfully; blueprint adequately guides iter-140 deliverables including the new private helper `isIso_of_app_iso_module` (whose 5-line body is reproduced verbatim in the chapter prose); the four open sorries are concrete, narrowly-scoped, and individually documented; no fake/placeholder/excuse-comment red flags.
