# Lean ↔ Blueprint Check Report

## Slug
quot

## Iteration
029

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean` (751 lines, 20 top-level declarations)
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex` (3444 lines)
- Note: the chapter carries `% archon:covers … QuotScheme.lean AlgebraicJacobian/Picard/GradedHilbertSerre.lean`; this report scopes only to `QuotScheme.lean`.

---

## Per-declaration

The blueprint chapter's `\lean{...}` blocks that map to declarations **in `QuotScheme.lean`** are listed below (mathlibok-only anchors and declarations that the blueprint explicitly notes do not yet exist are omitted from the per-declaration section and summarised separately).

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (def:hilbert_polynomial)
- **Lean target exists**: yes (line 123)
- **Signature matches**: yes — both blueprint prose and Lean take `X ⟶ S`, `_L _F : X.Modules`, `_s : S` and return `Polynomial ℚ`; the blueprint "encoded as a function `S → Polynomial ℚ`" is just the curried form
- **Proof follows sketch**: N/A — intentional typed `sorry` skeleton (directive line ~126; blueprint iter-177+ note)
- **notes**: `\leanok` on the blueprint statement block is correct (formalized stub); sorry body is an authorised skeleton

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (def:quot_functor)
- **Lean target exists**: yes (line 161)
- **Signature matches**: yes — `(Over S)ᵒᵖ ⥤ Type u`, matches blueprint "contravariant functor `(Over S)^op ⥤ Set`"
- **Proof follows sketch**: N/A — intentional typed `sorry` skeleton (directive line ~165; blueprint iter-177+ note)
- **notes**: `\leanok` correct; sorry body authorised

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (def:grassmannian_scheme)
- **Lean target exists**: yes (line 198)
- **Signature matches**: yes — `(Over S)ᵒᵖ ⥤ Type u`, matches blueprint "functor `Grass(V,d) : (Sch/S)^op ⥤ Set`"
- **Proof follows sketch**: N/A — intentional typed `sorry` skeleton (directive line ~201; blueprint iter-177+ note)
- **notes**: `\leanok` correct; sorry body authorised

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (thm:grassmannian_representable)
- **Lean target exists**: yes (line 225)
- **Signature matches**: **partial** — Lean states `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`, whereas the blueprint prose claims representability by a *smooth projective S-scheme of relative dimension d(r-d)* with a tautological rank-d quotient and Plücker embedding. The blueprint has an explicit `% NOTE:` acknowledging the statement "under-delivers the prose statement; it should be strengthened or split into a separate skeleton label." No smoothness, properness, relative dimension, tautological quotient, or Plücker structure is expressed in the Lean type.
- **Proof follows sketch**: N/A — intentional typed `sorry` (directive line ~228)
- **notes**: Blueprint is honest about the weakness via NOTE; the weakness is a known deferred gap, not a silent divergence. Classified **major** (not must-fix this iter) because it is explicitly documented.

### `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` (def:is_locally_free_of_rank)
- **Lean target exists**: yes (line 253)
- **Signature matches**: yes — existential over an index `ι`, open cover `U : ι → X.Opens`, `⨆ i, U i = ⊤`, and an iso of the pullback with the free module of rank `d` (via `ULift (Fin d)`)
- **Proof follows sketch**: yes — the definition body directly encodes the blueprint's open-cover condition
- **notes**: No issues

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` (def:modules_annihilator)
- **Lean target exists**: yes (line 298)
- **Signature matches**: yes — `(F : X.Modules) : X.IdealSheafData`, assembled via `IdealSheafData.ofIdeals (fun U => Module.annihilator Γ(X, U.1) Γ(F, U.1))`
- **Proof follows sketch**: yes — body uses `ofIdeals` exactly as the blueprint describes (the "largest ideal sheaf" construction mirroring `Scheme.Hom.ker`)
- **notes**: Minor blueprint documentation issue: the definition block carries `\uses{lem:annihilator_localization_eq_map, lem:qcoh_section_localization_basicOpen}` but those dependencies are needed only for the *characterization* (`annihilator_ideal`), not the definition. The definition itself discharges basic-open coherence internally via `ofIdeals` and does not require either cited lemma. This over-states the definition's dependency and could mislead a prover. Classified **minor**.

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_ideal_le}` (lem:modules_annihilator_ideal_le)
- **Lean target exists**: yes (line 305)
- **Signature matches**: yes — `(annihilator F).ideal U ≤ Module.annihilator Γ(X, U.1) Γ(F, U.1)`, exactly the "≤ direction" the blueprint describes
- **Proof follows sketch**: yes — one-liner via `IdealSheafData.ideal_ofIdeals_le`
- **notes**: No issues

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupport}` (def:schematic_support)
- **Lean target exists**: yes (line 312)
- **Signature matches**: yes — `(F : X.Modules) : Scheme.{u}`, closed subscheme cut out by `(annihilator F).subscheme`
- **Proof follows sketch**: yes
- **notes**: No issues

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupportι}` (def:schematic_support_immersion)
- **Lean target exists**: yes (line 320)
- **Signature matches**: yes — `schematicSupport F ⟶ X` via `(annihilator F).subschemeι`
- **Proof follows sketch**: yes
- **notes**: No issues

### `\lean{AlgebraicGeometry.Scheme.Modules.HasProperSupport}` (def:has_proper_support)
- **Lean target exists**: yes (line 328)
- **Signature matches**: yes — `{S : Scheme.{u}} (f : X ⟶ S) (F : X.Modules) : Prop := IsProper (schematicSupportι F ≫ f)`
- **Proof follows sketch**: yes
- **notes**: No issues

### `\lean{Module.annihilator_isLocalizedModule_eq_map}` (lem:annihilator_localization_eq_map)
- **Lean target exists**: yes (line 362)
- **Signature matches**: yes — `Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ)` under `IsLocalization S Rₚ`, `IsLocalizedModule S f`, `Module.Finite R M`
- **Proof follows sketch**: yes — the proof follows the blueprint's two-direction sketch faithfully: `⊆` clears a common denominator over generators (finset product), `⊇` uses the image of an annihilator element
- **notes**: No issues; complete, non-sorry proof

### `\lean{AlgebraicGeometry.isLocalizedModule_tilde_restrict}` (lem:isLocalizedModule_tilde_restrict)
- **Lean target exists**: yes (line 467)
- **Signature matches**: yes — `IsLocalizedModule (Submonoid.powers f) ((modulesSpecToSheaf.obj (tilde N)).presheaf.map (homOfLE le_top).op).hom`
- **Proof follows sketch**: yes — uses `tilde.toOpen_res`, `tilde.isoTop`, and `IsLocalizedModule.of_linearEquiv_right` exactly as the blueprint describes
- **notes**: No issues; complete, non-sorry proof

### `\lean{AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ}` (lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ)
- **Lean target exists**: yes (line 510)
- **Signature matches**: yes — `(M : (Spec R).Modules) [IsIso M.fromTildeΓ] (f : R) : IsLocalizedModule (Submonoid.powers f) …`
- **Proof follows sketch**: yes — naturality square of ψ, `of_linearEquiv` / `of_linearEquiv_right` chain matches blueprint
- **notes**: No issues; complete proof

### `\lean{AlgebraicGeometry.isIso_sheaf_of_isIso_app_basicOpen}` (lem:isIso_sheaf_of_isIso_app_basicOpen)
- **Lean target exists**: yes (line 554)
- **Signature matches**: yes
- **Proof follows sketch**: yes — basis injectivity → stalk injectivity, surjectivity on stalks via germ lift, `isIso_of_stalkFunctor_map_iso`
- **notes**: The declaration is **`private`** in Lean but the blueprint pins it as a public fully-qualified name `AlgebraicGeometry.isIso_sheaf_of_isIso_app_basicOpen`. The `private` modifier makes it inaccessible by that name from outside the file. The blueprint should either remove the pin or the declaration should be de-privatised. Classified **minor**.

### `\lean{AlgebraicGeometry.bijective_comp_of_localizations}` (lem:bijective_comp_of_localizations)
- **Lean target exists**: yes (line 579)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `linearEquiv` agreement via `linearMap_ext`, then bijectivity of an equivalence
- **notes**: Same `private` issue as `isIso_sheaf_of_isIso_app_basicOpen`. Classified **minor**.

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_isLocalizedModule_restrict}` (lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict)
- **Lean target exists**: yes (line 614)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `toOpen_fromTildeΓ_app`, per-basic-open bijectivity, sheaf-iso upgrade, fully-faithful reflection
- **notes**: No issues; complete proof

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_iff_isLocalizedModule_restrict}` (lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict)
- **Lean target exists**: yes (line 653)
- **Signature matches**: yes — biconditional packaging the two engines
- **Proof follows sketch**: yes
- **notes**: No issues; complete proof

### `\lean{AlgebraicGeometry.isLocalizedModule_basicOpen_of_presentation}` (lem:isLocalizedModule_basicOpen_of_presentation)
- **Lean target exists**: yes (line 686)
- **Signature matches**: yes — takes `(M : (Spec R).Modules) (_P : M.Presentation) (f : R)`, returns `IsLocalizedModule (Submonoid.powers f) …`
- **Proof follows sketch**: yes — two-step: `isIso_fromTildeΓ_of_presentation` then `isLocalizedModule_restrict_of_isIso_fromTildeΓ`
- **notes**: No issues; complete proof

### `\lean{AlgebraicGeometry.map_units_restrict_basicOpen}` (lem:map_units_restrict_basicOpen)
- **Lean target exists**: yes (line 705)
- **Signature matches**: yes — universal `f^n` invertibility on `Γ(M, D(f))`
- **Proof follows sketch**: yes — `simpa` via `tilde.isUnit_algebraMap_end_basicOpen`
- **notes**: No issues

---

## Open-gap declarations (blueprint `\lean{}` pins with `% NOTE: does not yet exist`)

These are in-blueprint but not in `QuotScheme.lean`; the blueprint honestly marks them missing.

| Blueprint label | Pinned Lean name | Status |
|---|---|---|
| `lem:qcoh_section_localization_basicOpen` | `Scheme.Modules.isLocalizedModule_basicOpen` | Not in file; bridge-gated on gap1 |
| `lem:qcoh_affine_section_localization` (G1-core) | `Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent` | Not in file; corollary of gap1 |
| `lem:exists_isIso_fromTildeΓ_basicOpen_cover` | `Scheme.Modules.exists_isIso_fromTildeΓ_basicOpen_cover` | Not in file; **partial realization exists** (see below) |
| `lem:qcoh_affine_isIso_fromTildeΓ` (gap1) | `Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent` | Not in file; known-open multi-iter gap |

**Confirmation on gap1 blueprint representation**: The blueprint chapter represents gap1 (`isIso_fromTildeΓ_of_isQuasicoherent`) honestly. The `% NOTE:` blocks correctly describe the irreducible mathematical content (QCoh(Spec R) ≃ Mod R essential-image gap, Stacks 01HA), the proof route (finite basic-open cover + Mayer–Vietoris gluing), and that the Lean declaration does not yet exist. The blueprint does not over-claim formalization status.

---

## Red flags

### Placeholder / suspect bodies
- `Scheme.hilbertPolynomial` at line 126: body is `:= sorry` — **intentional protected skeleton** per directive.
- `Scheme.QuotFunctor` at line 165: body is `:= sorry` — **intentional protected skeleton** per directive.
- `Scheme.Grassmannian` at line 201: body is `:= sorry` — **intentional protected skeleton** per directive.
- `Scheme.Grassmannian.representable` at line 228: body is `:= sorry` — **intentional protected skeleton** per directive.

No non-authorised sorry bodies, no `:= True`, no excuse-comments, no axiom declarations found.

---

## Unreferenced declarations (informational)

### `AlgebraicGeometry.exists_finite_basicOpen_cover_le_quasicoherentData` (line 730)

This is the **substantive new theorem** added this iteration. It is not referenced by any `\lean{...}` block in the blueprint. Its statement:

> Given `M : (Spec R).Modules` and `q : M.QuasicoherentData`, there exists `t : Finset R` with `Ideal.span (t : Set R) = ⊤` and `∀ r ∈ t, ∃ i, PrimeSpectrum.basicOpen r ≤ q.X i`.

This is the **topological finite-cover front** of `lem:exists_isIso_fromTildeΓ_basicOpen_cover`: it extracts a finite basic-open subcover of the quasi-coherence datum's cover, producing the topological witness (`t` and the containments) but *not* yet the `IsIso ((M|_{D(r)}).fromTildeΓ)` witnesses for each `D(r)`. The proof is complete and axiom-clean.

**Mapping**: this theorem should correspond to a new blueprint block placed as a *sub-lemma inside* `lem:exists_isIso_fromTildeΓ_basicOpen_cover`, or as a standalone lemma `lem:exists_finite_basicOpen_cover_le_quasicoherentData` that `lem:exists_isIso_fromTildeΓ_basicOpen_cover` cites. The current `\lean{...}` pin for `lem:exists_isIso_fromTildeΓ_basicOpen_cover` points at a non-existent declaration; the actual pinned name should be updated or a new block added.

---

## Blueprint adequacy for this file

- **Coverage**: 19/20 Lean declarations in `QuotScheme.lean` have a corresponding `\lean{...}` block. The 1 unreferenced declaration (`exists_finite_basicOpen_cover_le_quasicoherentData`) is substantive — it is a complete proof and the load-bearing topological step of `lem:exists_isIso_fromTildeΓ_basicOpen_cover`. Coverage debt is **known per directive**.

- **Proof-sketch depth**: **adequate** for the formalized declarations (annihilator localization, tilde-restrict, isIso engines, G1-assemble). The four sorry stubs have detailed iter-177+ notes explaining what the future proof body must do (graded Euler characteristics, Quot pullback machinery, Grassmannian chart gluing). The Grassmannian representability proof sketch is complete and correct as informal mathematics, even though the Lean statement it pins is weaker.

- **Hint precision**: **loose** at two points:
  1. `lem:exists_isIso_fromTildeΓ_basicOpen_cover` has `\lean{AlgebraicGeometry.Scheme.Modules.exists_isIso_fromTildeΓ_basicOpen_cover}` which does not exist; the partial realization (`exists_finite_basicOpen_cover_le_quasicoherentData`) has a different namespace, different signature, and no blueprint block. The `\lean{}` pin is a forward-looking placeholder acknowledged by `% NOTE:`, but a prover reading the blueprint would not find the connection to the actual formalized partial realization.
  2. `thm:grassmannian_representable` has `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` which exists but is weaker than the prose. The blueprint itself flags this via `% NOTE:`.

- **Generality**: **matches need** for the formalized declarations.

- **Recommended chapter-side actions**:
  1. **Add a new blueprint block** `lem:exists_finite_basicOpen_cover_le_quasicoherentData` (or split `lem:exists_isIso_fromTildeΓ_basicOpen_cover` into a "topological front" sub-lemma) with `\lean{AlgebraicGeometry.exists_finite_basicOpen_cover_le_quasicoherentData}` and appropriate proof sketch describing the `PrimeSpectrum.isBasis_basic_opens` + quasi-compactness + `Ideal.span_eq_top_iff_finite` route (which the Lean proof already follows).
  2. **Update `\lean{}` pin** for `lem:exists_isIso_fromTildeΓ_basicOpen_cover`: either point to `exists_finite_basicOpen_cover_le_quasicoherentData` as a sub-step, or keep the current (non-existent) target and add a `% NOTE:` cross-link to the partial realization.
  3. **Fix `def:modules_annihilator` `\uses{}`**: remove `lem:annihilator_localization_eq_map` and `lem:qcoh_section_localization_basicOpen` from the *definition* `\uses{}`; move them to a downstream characterization lemma (`lem:annihilator_ideal_full`) if desired.
  4. **Note `private` conflict**: either remove the `\lean{}` pins for `bijective_comp_of_localizations` and `isIso_sheaf_of_isIso_app_basicOpen` from the blueprint, or mark them as project-internal helpers with a `private` note, or de-privatise the declarations.

---

## Severity summary

| Finding | Severity |
|---|---|
| `Grassmannian.representable` Lean statement weaker than blueprint prose (missing smoothness, properness, rel. dim., tautological quotient, Plücker) — blueprint acknowledges via NOTE | **major** |
| `exists_finite_basicOpen_cover_le_quasicoherentData` (line 730) has no blueprint block; `lem:exists_isIso_fromTildeΓ_basicOpen_cover` `\lean{}` pin points at non-existent declaration | **major** |
| `def:modules_annihilator` `\uses{}` lists `lem:annihilator_localization_eq_map` and `lem:qcoh_section_localization_basicOpen` as definition dependencies when they are only needed for characterization | **minor** |
| `bijective_comp_of_localizations` and `isIso_sheaf_of_isIso_app_basicOpen` are `private` in Lean but publicly pinned in blueprint | **minor** |

No must-fix-this-iter findings. The 4 typed sorry stubs are authorised skeleton placeholders per directive. No excuse-comments, no axiom declarations, no weakened-wrong definitions. Open gaps (gap1, G1-core, general `isLocalizedModule_basicOpen`) are accurately represented with `% NOTE:` markers in the blueprint.

**Overall verdict**: `QuotScheme.lean` is faithful to the blueprint for all formalized declarations; one substantive new theorem (`exists_finite_basicOpen_cover_le_quasicoherentData`) is uncharted in the blueprint (known coverage debt), and the `Grassmannian.representable` statement falls short of the blueprint's full prose claim — both gaps are acknowledged in the blueprint itself. Blueprint adequacy is good for formalized content but requires a new block for the partial cover theorem and a pin correction for `lem:exists_isIso_fromTildeΓ_basicOpen_cover`.
