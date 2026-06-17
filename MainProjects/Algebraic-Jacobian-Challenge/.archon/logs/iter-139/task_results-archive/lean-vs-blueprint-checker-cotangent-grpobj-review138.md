# Lean ↔ Blueprint Check Report

## Slug
cotangent-grpobj-review138

## Iteration
138

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/GrpObj.lean` (754 lines, 13 declarations)
- Blueprint (mathematical content): `blueprint/src/chapters/RigidityKbar.tex`
  (relevant block: §"Piece (i)" decomposition, lines 81–731)
- Blueprint (pointer chapter): `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` (chapter: lem:GrpObj_cotangentSpace)
- **Lean target exists**: yes (line 161, `noncomputable def`)
- **Signature matches**: yes — `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` binder + `[IsProper G.hom]` + `[GeometricallyIrreducible G.hom]` matches the encoding note at chapter line 100–102 verbatim
- **Proof follows sketch**: yes — Replacement (B) chart-base-change construction matches the proof prose at chapter line 115–122; iter-131 `Classical.choose`-chain body shape is the one described in the lemma's blueprint caveat (line 121)
- **notes**: no sorry; pointer chapter line 13–16 already records iter-128/iter-131 history

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars}` (chapter: lem:GrpObj_cotangentSpace_extendScalars_witness)
- **Lean target exists**: yes (line 210, `theorem`)
- **Signature matches**: yes — the existential `∃ U V e htop, ...` shape with the explicit `appLE`-derived algebra and explicit `extendScalars`/`ModuleCat.of`/`Ω[...]` RHS matches chapter line 134–147 verbatim
- **Proof follows sketch**: yes — chapter line 156–160 prose (`Classical.choose`-chain reproduction + `Subsingleton.elim` on points of `Spec k` + `rfl`) matches Lean lines 223–231
- **notes**: no sorry

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq}` (chapter: lem:GrpObj_lieAlgebra_finrank)
- **Lean target exists**: yes (line 256, `theorem`)
- **Signature matches**: yes — `Module.finrank k (cotangentSpaceAtIdentity (n := n) G) = n` matches chapter line 225–228 stub
- **Proof follows sketch**: yes — Lean's Step 1 (`Classical.choose`-chain to extract `hfree`/`hrank`) + Step 2 (`Module.finrank_baseChange` + `Module.finrank_eq_of_rank_eq`) implement Steps 1+2 of the chapter proof (lines 244–265) faithfully. The `Nontrivial Γ(G, V)` discharge via `ψV.hom.domain_nontrivial` matches the chapter's note about the field-target ring map
- **notes**: no sorry; iter-132 closure

### `\lean{AlgebraicGeometry.GrpObj.shearMulRight}` (chapter: lem:GrpObj_shearMulRight)
- **Lean target exists**: yes (line 349, `@[simps] def`)
- **Signature matches**: yes — general-purpose `{C : Type*} [Category C] [CartesianMonoidalCategory C] (G : C) [GrpObj G]` matches chapter stub line 295–296. `hom = lift (fst G G) μ`, `inv = lift (fst G G) (lift (fst G G ≫ ι) (snd G G) ≫ μ)` matches the displayed maps at chapter line 309–310
- **Proof follows sketch**: yes — chapter line 322–328 references the exact tactic ingredients (`CartesianMonoidalCategory.hom_ext`, `lift_lift_assoc`, `lift_comp_inv_left`/`right`, `lift_comp_one_left`); Lean lines 352–384 use exactly those
- **notes**: `@[simps]` generates `shearMulRight_hom_fst`/`shearMulRight_hom_snd`; chapter explicitly anticipates those companion names at line 300–301

### `\lean{AlgebraicGeometry.GrpObj.schemeHomRingCompatibility}` (chapter: def:GrpObj_schemeHomRingCompatibility)
- **Lean target exists**: yes (line 423, `noncomputable def`)
- **Signature matches**: yes — `(TopCat.Presheaf.pullback f.base).obj Z.presheaf ⟶ Y.presheaf` is the φ_f shape described in chapter line 429–432; built as `((pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm f.c`, matching the chapter's "adjunction transpose of f^♯"
- **Proof follows sketch**: N/A (definition, not theorem)
- **notes**: companion remark `rem:GrpObj_schemeHomRingCompatibility_vs_toRingCatSheafHom` (chapter line 436–438) correctly disambiguates this from `toRingCatSheafHom`; Lean docstring (lines 418–422) explicitly mirrors the distinction

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}` (chapter: lem:GrpObj_omega_basechange_proj)
- **Lean target exists**: yes (line 612, `noncomputable def`)
- **Signature matches**: yes — `Scheme.relativeDifferentialsPresheaf (fst G G).left ≅ (PresheafOfModules.pullback (toRingCatSheafHom (snd G G).left).hom).obj (relativeDifferentialsPresheaf G.hom)` matches the stub at chapter line 452–457; LHS uses `pr_1` for the source-side structure, RHS uses `pr_2` via `PresheafOfModules.pullback` of the canonical compatibility morphism per the iter-135 mathlib-analogist verdict explicitly cited at chapter line 473–476
- **Proof follows sketch**: partial — body is `letI : IsIso (basechange_along_proj_two_inv G) := sorry ; (asIso (basechange_along_proj_two_inv G)).symm`. This is exactly the Route (b) "inverse-direction-via-adjunction-transpose" closure path described in the chapter's `% NOTE iter-137:` block (lines 577–620). The IsIso obligation is the third concrete sub-piece; chapter line 617–620 acknowledges this as "checking the iso property locally on PresheafOfModules generators — is on the table but not yet scoped", consistent with Lean docstring line 502–510's two-path closure plan
- **notes**: 1 sorry at line 624 (`IsIso` obligation). Lean docstring lines 482–487 honestly describe the net-change ("1 hollow scaffold sorry → 3 narrowly-scoped concrete sorries"). The structural Route (b) decomposition is substantive — the inverse-direction map is constructed end-to-end via `DifferentialsConstruction.isUniversal'.desc` + adjunction transpose (Lean lines 596–610), which is exactly the iter-137 NOTE block's Route (b) plan

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section}` (chapter: lem:GrpObj_omega_restrict_to_identity_section)
- **Lean target exists**: yes (line 645, `noncomputable def`)
- **Signature matches**: yes — four nested `PresheafOfModules.pullback`s of `(Scheme.Hom.toRingCatSheafHom _).hom` for `s.left`, `(snd G G).left`, `G.hom`, `η[G].left` matches the chapter stub at line 648–657
- **Proof follows sketch**: yes — chapter line 686 names `PresheafOfModules.pullbackComp` as the closure ingredient + categorical identity `pr_2 ∘ s = η_G ∘ π_G`; Lean lines 661–688 implement exactly that, with the helper `section_snd_eq_identity_struct` (lines 457–462) supplying the categorical identity from `lift_snd` + `Over.toUnit_left` per the iter-136 review NOTE at chapter line 663–676
- **notes**: no sorry; iter-136 closure

### `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}` (chapter: lem:GrpObj_mulRight_globalises)
- **Lean target exists**: yes (line 741, `noncomputable def`)
- **Signature matches**: yes — `relativeDifferentialsPresheaf G.hom ≅ (pullback (toRingCatSheafHom G.hom).hom).obj ((pullback (toRingCatSheafHom η[G].left).hom).obj (relativeDifferentialsPresheaf G.hom))` matches chapter stub line 347–354 (RHS at presheaf-of-modules level per iter-133 mathlib-analogist Decision 4)
- **Proof follows sketch**: no body — body is `sorry` at line 752. Honest scaffold per chapter line 372–381 NOTE; Lean docstring lines 733–740 acknowledges this is iter-135 honest scaffold awaiting Step 2 closure
- **notes**: 1 sorry at line 752; consistent with chapter's `\notready` (line 382)

## Red flags

### Placeholder / suspect bodies

- `relativeDifferentialsPresheaf_basechange_along_proj_two` at line 612: body contains `letI : IsIso (basechange_along_proj_two_inv G) := sorry` (line 624). **NOT a fake placeholder**: blueprint `lem:GrpObj_omega_basechange_proj` is `\notready` (chapter line 481), directive explicitly authorizes this PARTIAL state. Severity: **expected partial closure**, no flag.
- `basechange_along_proj_two_inv_derivation` at line 547: contains two `sorry`s (line 581 = d_app, line 585 = d_map). **NOT a fake placeholder**: both sorries are narrowly-scoped sub-pieces of Route (b), each with a concrete description in the surrounding comment (lines 577–580, 583–584) naming the closure ingredient (line 577–580: "factors through (fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom in Over (Spec k)"; line 583–584: "chase of (snd G G).left.c.naturality + KaehlerDifferential.D.d_map"). Severity: **expected partial closure**, no flag.
- `mulRight_globalises_cotangent` at line 741: body is bare `sorry` (line 752). **NOT a fake placeholder**: chapter `\notready` (line 382), chapter NOTE line 372–381 explicitly anticipates this iter-135 scaffold. Severity: **expected partial closure**, no flag.

### Excuse-comments

None. The Lean docstrings honestly describe partial closure ("Status (iter-138 PARTIAL): … `d_app` and `d_map` sub-goals remain `sorry`-bodied"; "Net change this iter: 1 hollow scaffold sorry → 3 narrowly-scoped concrete sorries (each documented + each strictly smaller than the original load-bearing gap)"). None of the comments excuse wrong code or claim spurious progress — they describe what was built (Route (b) skeleton via `DifferentialsConstruction.isUniversal'.desc` + `pullbackPushforwardAdjunction.homEquiv.symm`, with `d_add`/`d_mul` closed) versus what remains (`d_app`, `d_map`, `IsIso`).

### Axioms / Classical.choice on non-trivial claims

`cotangentSpaceAtIdentity` (line 161) and `cotangentSpaceAtIdentity_finrank_eq` (line 256) use `Classical.choose`-chains on `Scheme.smooth_locally_free_omega`'s existential. The chapter explicitly authorizes this at the iter-131 caveat (lines 121, 137–143 of RigidityKbar.tex) and at the rank-lemma chart-extraction prose (line 244). No flag.

No new `axiom` declarations.

## Unreferenced declarations (informational)

- `shearMulRight_hom_fst` (line 386, `@[reassoc (attr := simp)] lemma`) — auto-companion of `@[simps]` on `shearMulRight`; chapter line 300–301 explicitly anticipates this name. Acceptable.
- `shearMulRight_hom_snd` (line 391, `@[reassoc (attr := simp)] lemma`) — ditto.
- `section_snd_eq_identity_struct` (line 457, `private lemma`) — internal helper for `_restrict_along_identity_section`; chapter line 666–670 NOTE explicitly names this `~5 LOC helper`. Acceptable, no `\lean{...}` needed since it's `private`.
- `basechange_along_proj_two_inv_derivation` (line 547, `noncomputable def`) — **new iter-138 Route (b) Step 4 helper**, NOT `\lean{...}`-referenced from blueprint. The chapter's iter-137 NOTE block (lines 577–620) describes it abstractly as "the derivation D" but does not pin a named Lean target. See blueprint-adequacy section below for severity classification.
- `basechange_along_proj_two_inv` (line 596, `noncomputable def`) — **new iter-138 Route (b) Step 5 helper**, NOT `\lean{...}`-referenced from blueprint. Same status as above.

## Blueprint adequacy for this file

- **Coverage**: 8 / 13 Lean declarations have a corresponding `\lean{...}` block in the chapter (`cotangentSpaceAtIdentity`, `_eq_extendScalars`, `_finrank_eq`, `shearMulRight`, `schemeHomRingCompatibility`, `_basechange_along_proj_two`, `_restrict_along_identity_section`, `mulRight_globalises_cotangent`). The 5 unreferenced declarations break down as 3 acceptable helpers (`shearMulRight_hom_fst`/`_snd` auto-`@[simps]`; private `section_snd_eq_identity_struct`) and 2 new iter-138 Route (b) helpers (`basechange_along_proj_two_inv_derivation`, `basechange_along_proj_two_inv`).
- **Proof-sketch depth**: adequate. The chapter's `% NOTE iter-137:` block in the proof of `lem:GrpObj_omega_basechange_proj` (RigidityKbar.tex lines 492–630) is unusually detailed — it lays out Route (a) (chart-unfolding helper, 5-step recipe with per-step LOC estimates) and Route (b) (inverse-direction via adjunction transpose, with reference to `DifferentialsConstruction.isUniversal'` and explicit pushforward transparency observation). The iter-138 Route (b) helper signatures (the two new `basechange_along_proj_two_inv*` defs) are direct realisations of the Route (b) prose: `((pushforward ψ).obj LHS).Derivation' φ_G` (helper #1) is exactly the chapter's "(pushforward ψ).obj Ω_{(G ×_k G)/G}-valued derivation of φ_G", and the inverse-direction map `(pullback ψ).obj Ω_{G/k} ⟶ Ω_{(G ⊗ G)/G}` (helper #2) is exactly the chapter's "(pullback ψ).obj Ω_{G/k} → Ω_{(G ×_k G)/G}" with the explicit adjunction transpose. A prover could (and did) implement these from the prose alone.
- **Hint precision**: precise. The `\lean{...}` blocks all pin fully-qualified Lean names. The chapter's iter-135 NOTE explicitly designates `Scheme.Hom.toRingCatSheafHom` (not `schemeHomRingCompatibility`) as the canonical `PresheafOfModules.pullback` compatibility-morphism source, and the Lean file uses that exact idiom throughout the new Route (b) helpers.
- **Generality**: matches need. The `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` parameterisation supports arbitrary relative dimension; the `Over (Spec (.of k))` ambient base scheme is the iter-127 over-k commitment.
- **Recommended chapter-side actions**: (minor, optional)
  - Consider promoting the two new iter-138 Route (b) helpers to dedicated `\lean{...}`-blocks within or adjacent to `lem:GrpObj_omega_basechange_proj`. Suggested labels: `lem:GrpObj_omega_basechange_proj_inv_derivation` and `lem:GrpObj_omega_basechange_proj_inv`. Rationale: iter-139+ provers attacking the remaining sub-sorries (`d_app`, `d_map`, `IsIso`) will benefit from blueprint anchors that name them — currently the helpers exist only in Lean docstrings + an analogist file. Not blocking; the iter-137 NOTE prose is sufficient context for iter-139+ work.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - 2 new iter-138 helpers (`basechange_along_proj_two_inv_derivation`, `basechange_along_proj_two_inv`) lack dedicated `\lean{...}` blocks in `RigidityKbar.tex`. They are described abstractly in the iter-137 NOTE prose but no named blueprint anchor exists. Promoting them to first-class blueprint blocks would help iter-139+ provers triangulate the remaining sub-sorries against a stable blueprint reference.
  - **Possible `sync_leanok` mis-mark to flag** (per directive § "marker management"): The proof block of `lem:GrpObj_omega_basechange_proj` carries `\leanok` (RigidityKbar.tex line 491). The Lean target `relativeDifferentialsPresheaf_basechange_along_proj_two` has a `sorry` at line 624 (the `IsIso` letI), so the proof is NOT fully closed. By the marker vocabulary ("`\leanok` inside a proof block when the proof is fully closed with no `sorry`"), this `\leanok` should have been removed by `sync_leanok` this iter. Note: I am only flagging; per the directive I do not propose the marker edit.
  - File-header docstring line anchors at L61/L107/L146/L155/L160 drift further (carry-over from iter-135 MED-C; directive flagged as already-known and not to re-elevate).

Overall verdict: The iter-138 prover lane substantively decomposed the iter-137 single load-bearing sorry into three concrete narrowly-scoped sub-sorries along the blueprint's Route (b) plan, with honest docstrings and faithful signatures; no must-fix or major findings, and the blueprint's iter-137 NOTE block is detailed enough that a future iter-139+ prover can attack the three remaining sub-sorries without re-reading external analogist files.
