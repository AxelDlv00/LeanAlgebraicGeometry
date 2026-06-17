# Lean ↔ Blueprint Check Report

## Slug
cotangent-grpobj-review135

## Iteration
135

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/GrpObj.lean` (573 lines, 10 declarations)
- Blueprint (canonical): `blueprint/src/chapters/RigidityKbar.tex` (590 lines)
- Blueprint (auxiliary pointer): `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` (59 lines)

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` (chapter: `lem:GrpObj_cotangentSpace`)
- **Lean target exists**: yes (line 161, `noncomputable def`).
- **Signature matches**: yes. The stub `noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom] : ModuleCat k` (RigidityKbar.tex L100–102) is verbatim the Lean signature at L161–164.
- **Proof follows sketch**: yes (definition body). The body's structure — `Classical.choose`-chain on `Scheme.smooth_locally_free_omega` exposing `U, V, e, hxV`, then the explicit `(ModuleCat.extendScalars ψV.hom).obj (ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)])` — matches the chapter's iter-131 Replacement (B) construction (RigidityKbar.tex L113–122 + the L560–573 iter-131 body-shape encoding note).
- **notes**: fully closed; no `sorry`. The variable name `ηleft` for `CategoryTheory.CommaMorphism.left η[G]` matches the prose `ηleft : Spec k → G.left`.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars}` (chapter: `lem:GrpObj_cotangentSpace_extendScalars_witness`)
- **Lean target exists**: yes (line 210, `theorem`).
- **Signature matches**: yes. The blueprint's verbatim Lean-stub box (RigidityKbar.tex L133–147) is character-for-character the Lean signature at L210–222.
- **Proof follows sketch**: yes. The Lean proof at L223–231 reproduces the body's `Classical.choose`-chain, supplies the `htop` membership witness via `Subsingleton.elim` on `Spec` of a field, and closes via `rfl`. Matches RigidityKbar.tex L156–160 exactly.
- **notes**: fully closed; no `sorry`.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent}` (chapter: `lem:GrpObj_cotangent_bridge`)
- **Lean target exists**: NO (not in this file).
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: Acceptable. Blueprint marks the lemma `\notready` (RigidityKbar.tex L183) and the iter-131 strategy-critic Q4 collapse footer (L278–279) explicitly classifies it as vestigial-on-live-path / deferred. This is a known multi-iter deferral, not a missing declaration.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq}` (chapter: `lem:GrpObj_lieAlgebra_finrank`)
- **Lean target exists**: yes (line 256, `theorem`).
- **Signature matches**: yes. Stub at RigidityKbar.tex L225–228 (`Module.finrank k (cotangentSpaceAtIdentity G) = n`) is the Lean signature at L256–259.
- **Proof follows sketch**: yes. Steps 1 (chart-side Kähler rank from `smooth_locally_free_omega`'s existential, via `Module.finrank_eq_of_rank_eq` on `hrank`) and 2 (`Module.finrank_baseChange`) of RigidityKbar.tex L243–264 map exactly onto the Lean body L260–294. The `change Module.finrank k (TensorProduct ↥Γ(G.left, V) k …) = n` step reflects the L568–569 "direct `change`-based route" pattern documented in the blueprint.
- **notes**: fully closed; no `sorry`.

### `\lean{AlgebraicGeometry.GrpObj.shearMulRight}` (chapter: `lem:GrpObj_shearMulRight`)
- **Lean target exists**: yes (line 349, `def`).
- **Signature matches**: yes. The stub at RigidityKbar.tex L295–298 is the Lean signature at L348–351 (including the generic `{C : Type*} [Category C] [CartesianMonoidalCategory C]` framing — more general than just `Over (Spec k)`, faithful to the prose "let `G` be a group object in a Cartesian monoidal category" at L303).
- **Proof follows sketch**: yes. The `hom_inv_id` / `inv_hom_id` proofs at L352–383 verify both compositions via `CartesianMonoidalCategory.hom_ext` componentwise, exactly as the proof at L322–328 describes (`lift_lift_assoc`, `lift_comp_inv_left/right`, `lift_comp_one_left`).
- **notes**: fully closed; the `@[simps]` attribute auto-generates `shearMulRight_hom_fst` / `shearMulRight_hom_snd` matching the blueprint's promised identifications $\sigma_{hom} \circ \pr_1 = \pr_1$ and $\sigma_{hom} \circ \pr_2 = \mu$.

### `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}` (chapter: `lem:GrpObj_mulRight_globalises`)
- **Lean target exists**: yes (line 560, `noncomputable def`, body `sorry`).
- **Signature matches**: yes. The Lean signature at L560–570 — `Scheme.relativeDifferentialsPresheaf G.hom ≅ (PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom G.hom).hom).obj ((PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom (CategoryTheory.CommaMorphism.left η[G])).hom).obj (Scheme.relativeDifferentialsPresheaf G.hom))` — is the intended sheaf-level RHS `Ω_{G/k} ≅ π_G^*(η_G^* Ω_{G/k})` that the blueprint pins (RigidityKbar.tex L388–390). The blueprint stub box at L347–354 names compatibility morphisms abstractly as `φ_str` / `φ_η`; the iter-135 NOTE at L372–381 explicitly authorizes constructing those via `Scheme.Hom.toRingCatSheafHom`, matching the Lean exactly.
- **Proof follows sketch**: N/A — body is `sorry`. Per the iter-135 known-issues clause, this is an honest scaffold; the docstring at L536–559 lists Steps 1/2/3/Compose mirroring the proof at RigidityKbar.tex L398–420.
- **notes**: `\notready` marker at RigidityKbar.tex L382 correctly flags non-closure; the NOTE block at L372–381 instructs `sync_leanok` to remove the iter-134 `\leanok` from the proof block (the deterministic sync runs between this checker and the review agent).

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}` (chapter: `lem:GrpObj_omega_basechange_proj`)
- **Lean target exists**: yes (line 468, `noncomputable def`, body `sorry`).
- **Signature matches**: yes. Lean signature at L468–475 — `Scheme.relativeDifferentialsPresheaf (fst G G).left ≅ (PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj (Scheme.relativeDifferentialsPresheaf G.hom)` — is the intended sheaf-level base-change iso `Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}` of RigidityKbar.tex L465–467. The blueprint stub at L434–440 (with the abstract `φ_pr_two` placeholder) is upgraded by the iter-135 NOTE at L452–462 to `Scheme.Hom.toRingCatSheafHom (snd G G).left).hom`, matching the Lean.
- **Proof follows sketch**: N/A — body is `sorry`. Acknowledged honest scaffold; proof outline at RigidityKbar.tex L471–480 (chains `KaehlerDifferential.tensorKaehlerEquiv` with `TopCat.Presheaf.pullback` / `PresheafOfModules.pullback`) is intact.
- **notes**: `\notready` at RigidityKbar.tex L463. Load-bearing piece (~150–300 LOC), NEEDS_MATHLIB_GAP_FILL.

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section}` (chapter: `lem:GrpObj_omega_restrict_to_identity_section`)
- **Lean target exists**: yes (line 496, `noncomputable def`, body `sorry`).
- **Signature matches**: yes. The four composed `PresheafOfModules.pullback`s in the Lean at L500–511 spell out the LHS `s^*(pr_2^* Ω)` and the RHS `π_G^*(η_G^* Ω)`. The section `s = ⟨𝟙_G, η_G⟩` is realised on the LHS as `lift (𝟙 G) (toUnit G ≫ η[G])` (consistent with `GrpObj`-supplied identity-section idioms); `pr_2` on `G ⊗ G` as `snd G G`; `π_G` as `G.hom`; `η_G` as `CategoryTheory.CommaMorphism.left η[G]`. Each maps to a `Scheme.Hom.toRingCatSheafHom _.hom` compatibility morphism per the iter-135 NOTE at RigidityKbar.tex L505–514.
- **Proof follows sketch**: N/A — body is `sorry`. Acknowledged honest scaffold; closure target documented as `PresheafOfModules.pullbackComp` + `pullbackId` on the categorical identity `pr_2 ∘ s = η_G ∘ π_G` (~30–80 LOC).
- **notes**: `\notready` at RigidityKbar.tex L515.

## Red flags

None must-fix-this-iter. Per the iter-135 known-issues clause in the directive, the three `sorry`-bodied honest scaffolds (`relativeDifferentialsPresheaf_basechange_along_proj_two`, `relativeDifferentialsPresheaf_restrict_along_identity_section`, `mulRight_globalises_cotangent`) are the explicitly-adopted multi-iter NEEDS_MATHLIB_GAP_FILL pattern — they have intended-type signatures pinned in the blueprint, `\notready` markers, and iter-135 NOTE blocks documenting closure targets. Not red flags.

## Unreferenced declarations (informational)

- `AlgebraicGeometry.GrpObj.schemeHomRingCompatibility` (line 423, `noncomputable def`). Not given a `\lean{...}` block in RigidityKbar.tex (the canonical chapter); the auxiliary pointer chapter (`AlgebraicJacobian_Cotangent_GrpObj.tex` L34–42) describes it as a packaging helper. Status: acceptable — this is a helper-only declaration that wraps `((adj).homEquiv _ _).symm f.c` once so the surrounding section docstrings can refer to it uniformly. The Lean docstring at L407–422 is explicit that this is NOT the φ for `PresheafOfModules.pullback`. **Minor recommendation**: promoting it to a blueprint block in RigidityKbar.tex (with cross-reference to `phi-compatibility-morphisms.md`) would close a small adequacy gap, but the current placement in the auxiliary chapter is acceptable as a helper.
- `AlgebraicGeometry.GrpObj.shearMulRight_hom_fst` (line 386) and `AlgebraicGeometry.GrpObj.shearMulRight_hom_snd` (line 391). These are companion `@[reassoc (attr := simp)]` lemmas surfacing the first/second-coordinate identifications. The blueprint at RigidityKbar.tex L312–316 names them in the prose but does not give each its own `\lean{...}` block; the auxiliary chapter L29–33 enumerates them. Acceptable (they are `@[simps]`-style derived facts; the parent `lem:GrpObj_shearMulRight` block covers them implicitly).

## Blueprint adequacy for this file

- **Coverage**: 7/7 substantive declarations have a corresponding `\lean{...}` block in RigidityKbar.tex. Unreferenced declarations: 1 packaging helper (`schemeHomRingCompatibility`) + 2 derived simp lemmas — all acceptable, all listed in the auxiliary pointer chapter.
- **Proof-sketch depth**: **adequate**. The two closed proofs (`cotangentSpaceAtIdentity_eq_extendScalars`, `cotangentSpaceAtIdentity_finrank_eq`, `shearMulRight`) match the chapter's `\begin{proof}` blocks step-by-step. The three honest scaffolds have detailed Step-1/2/3/Compose outlines in both the Lean docstrings and the chapter, naming the specific Mathlib idioms (`KaehlerDifferential.tensorKaehlerEquiv`, `PresheafOfModules.pullbackComp`, `PresheafOfModules.pullbackId`, `Scheme.Hom.toRingCatSheafHom`) needed for closure. Cross-references to `analogies/mulright-globalises-cotangent.md` and `analogies/phi-compatibility-morphisms.md` are tight.
- **Hint precision**: **precise**. Every `\lean{...}` hint pins a real declaration in this file (modulo the deferred `cotangentSpaceAtIdentity_iso_localRingCotangent` whose `\notready` marker is correct). The iter-135 NOTE blocks at RigidityKbar.tex L372–381, L452–462, L505–514 explicitly state the `Scheme.Hom.toRingCatSheafHom`-based compatibility-morphism shape, matching the Lean verbatim — no guesswork required by the prover.
- **Generality**: **matches need**. The `cotangentSpaceAtIdentity` signature with the free `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` binder (iter-129 relaxation) is correctly pinned in the blueprint stub. `shearMulRight`'s generic `{C : Type*} [Category C] [CartesianMonoidalCategory C]` framing matches the prose's "in a Cartesian monoidal category" generality.
- **Recommended chapter-side actions**: none must-fix this iter. (Optional polish: add a `\lean{AlgebraicGeometry.GrpObj.schemeHomRingCompatibility}` helper block to RigidityKbar.tex so the canonical chapter mentions it once explicitly, since it appears in the bullet list of the auxiliary chapter only.)

## File-level minor findings (Lean-side hygiene)

1. **Stale Lean-line anchors in the file-header docstring** (minor; partial de-pinning). The directive's "What's new this iter" item 4 declares: "File-header stale Lean-line anchors de-pinned (declaration names)." Verification shows partial completion only:
   - Lines 32–33 (header references): correctly de-pinned to "below" without numbers. ✓
   - Lines 61, 107, 146, 155: still read "line 244 below" (referring to `cotangentSpaceAtIdentity_finrank_eq`). Actual line is **256**. ✗
   - Line 160: reads "line 198 below" (referring to `cotangentSpaceAtIdentity_eq_extendScalars`). Actual line is **210**. ✗
   The 5 stale anchors are off by 12 lines (the three new iter-135 scaffolds pushed declarations down). The intent (de-pin to declaration names) is correct; the execution is incomplete. **Severity: minor** — cosmetic / docstring-hygiene only; no compilation impact, no `\lean{...}` mismatch.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 1 (partial de-pinning of file-header line anchors at L61/L107/L146/L155/L160; intent stated in directive item 4 was not fully executed)

**Overall verdict**: this Lean file follows its blueprint chapter faithfully, the three honest-scaffold `sorry` bodies are the explicitly-authorized iter-135 pattern (intended-type signatures pinned, `\notready` markers correct, closure targets documented), the blueprint chapter is adequately detailed to have guided this file's formalisation, and the only finding is a cosmetic docstring-hygiene issue from a partially-completed iter-135 de-pinning task.
