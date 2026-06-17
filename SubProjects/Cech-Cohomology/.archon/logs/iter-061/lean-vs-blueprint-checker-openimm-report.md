# Lean ↔ Blueprint Check Report

## Slug
openimm

## Iteration
061

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (relevant labels: `lem:open_immersion_pushforward_comp`, `lem:pushforward_commutes_restriction`,
  `lem:pushforward_iso_preserves_qcoh`, `lem:jshriek_transport_along_iso`,
  `lem:ext_jShriekOU_eq_zero_of_specIso`, and helpers)

---

## Per-declaration

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_acyclic}` (chapter: `lem:open_immersion_pushforward_comp`, part 1)
- **Lean target exists**: yes (line 504)
- **Signature matches**: yes — `[HasInjectiveResolutions U.Modules]`, `(j : U ⟶ X)`, `[IsOpenImmersion j]`, `[IsAffine U]`, `[X.IsSeparated]`, `(H : U.Modules)`, `(hH : H.IsQuasicoherent)`, `(q : ℕ)`, `(hq : 0 < q)`, returns `IsZero (higherDirectImage j q H)`. Matches blueprint part (1).
- **Proof follows sketch**: partial — the proof structure follows the blueprint (presheaf description → local vanishing on affine opens → `isZero_presheafToSheaf_of_sections_locally_zero`), but contains `case hqc => sorry` (the quasi-coherence transport of the pushed-forward module).
- **Notes**: `case hjt` discharged in this iter by `jShriekOU_transport_along_iso`; `case hqc` remains sorry. The sorry is honest — see Red Flags section. The `case hV'` was already closed.

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` (chapter: `lem:open_immersion_pushforward_comp`, part 2)
- **Lean target exists**: yes (line 630)
- **Signature matches**: yes — `[HasInjectiveResolutions X.Modules]`, `[HasInjectiveResolutions U.Modules]`, `(j : U ⟶ X) [IsOpenImmersion j] [IsAffine U] [X.IsSeparated]`, `(f : X ⟶ S)`, `(H : U.Modules)`, `(hH : H.IsQuasicoherent)`, `(k : ℕ)`, returns `higherDirectImage f k ((pushforward j).obj H) ≅ higherDirectImage (j ≫ f) k H`. Matches blueprint part (2).
- **Proof follows sketch**: no — the entire proof body is `:= by … sorry`. The comment correctly identifies the acyclicity facts needed; none are yet formalized.
- **Notes**: depends on Part (1)'s `hqc` residual plus `f_*`-acyclicity argument. Expected sorry for this iter.

### `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}` (chapter: `lem:open_immersion_pushforward_comp`)
- **Lean target exists**: yes (line 462, `private`)
- **Signature matches**: yes — `(j : U ⟶ X) [IsAffine U] [X.IsSeparated]` → `IsAffineHom j`. Matches blueprint part (1) prose ("an open immersion of an affine open into a separated scheme is an affine morphism").
- **Proof follows sketch**: yes — 3-line proof via `IsAffineHom.of_comp`, matching the blueprint's "separatedness argument".
- **Notes**: private helper; correctly not given its own blueprint lemma node.

### `\lean{AlgebraicGeometry.jShriekOU_transport_along_iso}` (chapter: `lem:jshriek_transport_along_iso`)
- **Lean target exists**: yes (line 391)
- **Signature matches**: yes — `(φ : X ≅ Y)`, `(V : TopologicalSpace.Opens X)` → `(pushforwardEquivOfIso φ).functor.obj (jShriekOU V) ≅ jShriekOU (φ.inv ⁻¹ᵁ V)`. Matches blueprint exactly.
- **Proof follows sketch**: yes — uses `sectionsCorepPushforward`/`sectionsCorep` + `CorepresentableBy.uniqueUpToIso`, matching blueprint's "both sides corepresent the same sections functor" sketch.
- **Notes**: axiom-clean; closed in iter-060.

### `\lean{AlgebraicGeometry.Scheme.Modules.pushforwardEquivOfIso}`, `pushforwardExtAddEquiv`, `modulesIsoSpecExtTransport` (chapter: `lem:modules_isoSpec_ext_transport`)
- **Lean target exists**: all three present (lines 204, 223, 241)
- **Signature matches**: yes for all three — the equivalence of module categories, the `AddEquiv` on `Ext`, and the transport along `U.isoSpec`.
- **Proof follows sketch**: yes — blueprint proof (equivalence + `mapExt_bijective_of_preservesInjectiveObjects` + argument identification) matches exactly.
- **Notes**: axiom-clean; closed in iter-060.

### `\lean{AlgebraicGeometry.ext_jShriekOU_eq_zero_of_specIso}` (chapter: `lem:ext_jShriekOU_eq_zero_of_specIso`)
- **Lean target exists**: yes (line 332); blueprint has `\leanok` on this lemma.
- **Signature matches**: yes — all parameters (`φ : U ≅ Spec R`, `V`, `H`, `q`, `hV'`, `hjt`, `hqc`, `e`) present and typed as in blueprint.
- **Proof follows sketch**: yes — blueprint sketch (enough injectives transport + Serre vanishing on `Spec R` + `Ext` transfer) is faithfully formalized.
- **Notes**: axiom-clean.

### `\lean{AlgebraicGeometry.pushforward_commutes_restriction}` (chapter: `lem:pushforward_commutes_restriction`)
- **Lean target exists**: NO — no declaration named `pushforward_commutes_restriction` exists in the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Blueprint already annotates `% NOTE: build target. The Lean declaration does not exist yet.` This is correctly flagged by the blueprint itself. The declaration was never built. See Blueprint Adequacy for route implications.

### `\lean{AlgebraicGeometry.pushforward_iso_preserves_qcoh}` (chapter: `lem:pushforward_iso_preserves_qcoh`)
- **Lean target exists**: NO — no declaration named `pushforward_iso_preserves_qcoh` exists in the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: Blueprint annotates `% NOTE: build target. The Lean declaration does not exist yet.` Correctly flagged. In its place, iter-061 added `pushforward_iso_qcoh_of_slice_qcoh` as a partial reduction lemma (see Unreferenced Declarations).

---

## Red Flags

### Placeholder / suspect bodies

- `higherDirectImage_openImmersion_acyclic`, `case hqc`, line 588: `:= sorry`. Blueprint claims a substantive proof (quasi-coherence transport along a scheme iso). The comment is detailed and honest (see below); the sorry is at the genuine goal. **Must-fix pending completion.**
- `higherDirectImage_openImmersion_comp`, line 654: entire proof `:= sorry`. Blueprint claims a substantive isomorphism. Expected; depends on `hqc` and `f_*`-acyclicity.

### `case hqc => sorry` — honesty check (directive Q2)

The sorry at line 588 is typed at the genuine goal:
```
((Scheme.Modules.pushforwardEquivOfIso U.isoSpec).functor.obj H).IsQuasicoherent
```
This IS the `hqc` parameter of `ext_jShriekOU_eq_zero_of_specIso`. It is NOT laundered through a weakened hypothesis or a trivially satisfied alias. The comment (lines 572–588) accurately describes:
- The available reduction lemma (`pushforward_iso_qcoh_of_slice_qcoh`) that would reduce this to the per-slice obligation
- The remaining unbuilt piece (cross-ring slice ring hom `ψ_r`)
- The simpler route via `SheafOfModules.pullback ψ_r`

**Verdict: sorry is honest.**

### Excuse-comments

None found. The `-- RESIDUAL` and `-- REDUCED (iter-061)` comments are accurate workflow documentation, not obfuscation.

---

## Unreferenced declarations (informational)

### Substantive public declarations without `\lean{...}` blueprint reference

- **`pushforward_iso_qcoh_of_slice_qcoh`** (line 425, non-private): reduces quasi-coherence of `Φ H` to the per-slice case via `SheafOfModules.IsQuasicoherent.of_coversTop` + `coversTop_preimage_of_iso`. This is an intermediate reduction lemma en route to `pushforward_iso_preserves_qcoh`, which IS in the blueprint but whose Lean target doesn't exist yet. **Needs a blueprint node or should be absorbed into `pushforward_iso_preserves_qcoh`'s proof block.**

### Private helpers without blueprint reference (acceptable)

- `coversTop_preimage_of_iso` (line 403, private): cover-transport helper for `pushforward_iso_qcoh_of_slice_qcoh`. Acceptable as private auxiliary.
- `jShriekOU_homEquiv_nat` (line 126, private): naturality helper.
- `sectionsCorep`, `sectionsCorepPushforward` (lines 363, 372, private): referenced via `\lean{AlgebraicGeometry.sectionsCorep, AlgebraicGeometry.sectionsCorepPushforward}` in `lem:jshriek_transport_along_iso`. Correctly present.
- `preadditiveCoyoneda_mapHomologicalComplex_d_apply` (line 263, private): homological helper. Fine.
- `isAffineHom_of_affine_separated` (line 462, private): referenced in `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}`. Fine.

### Instances and helpers without blueprint reference (expected)

`toPresheafOfModules_additive`, `sectionsFunctor_additive`, `pushforwardEquivOfIso_functor_additive`, `pushforwardSectionsFunctor_additive`, `isZero_of_faithful_preservesZeroMorphisms`, `isZero_presheafToSheaf_of_sections_locally_zero`, `sectionsFunctorCorepIso`, `rightDerivedNatIso`, `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`, `enoughInjectives_of_hasInjectiveResolutions`, `subsingleton_ext_of_iso_fst`, `pushforwardSectionsFunctor` — all are referenced via `\lean{...}` or are instances/lemmas covered under umbrella blueprint nodes.

---

## Blueprint adequacy for this file

- **Coverage**: 8 of the 10 substantive `\lean{...}` targets in the relevant blueprint nodes have Lean declarations (or are marked `\mathlibok`). The 2 missing (`pushforward_commutes_restriction`, `pushforward_iso_preserves_qcoh`) are correctly flagged with `% NOTE: build target` in the blueprint. Coverage is adequate given the build-target annotations. The new `pushforward_iso_qcoh_of_slice_qcoh` has NO blueprint node — a gap.

- **Proof-sketch depth**: under-specified for `lem:pushforward_iso_preserves_qcoh` — see below (directive Q3).

- **Hint precision**: precise for all existing declarations. The `% NOTE: build target` annotations on the two missing ones are honest.

- **Generality**: matches need for all closed declarations.

### Directive Q3: Blueprint route vs. prover's simpler route for `lem:pushforward_iso_preserves_qcoh`

The blueprint's proof sketch for `lem:pushforward_iso_preserves_qcoh` prescribes:
1. Build `pushforward_commutes_restriction` (uses `pushforwardPushforwardEquivalence_mathlib` — a site-equivalence equivalence of slice categories, roughly a 4-component plumbing: slice-over-V equivalence, comparison iso, presentation transport, `ofIsIso`).
2. Use `pushforward_commutes_restriction` to reduce per-slice quasi-coherence to the restriction comparison.
3. Then apply `presentation_map_mathlib` / `presentation_ofIsIso_mathlib`.

**The prover found a simpler route** (lines 580–587 comment):
- Use `SheafOfModules.pullback ψ_r` directly on each slice, where `ψ_r` is a SINGLE cross-ring structure-sheaf hom (restrict `φ.hom.toRingCatSheafHom` to the over-category via the Beck-Chevalley identity `Over.post _ ⋙ Over.forget = Over.forget ⋙ _`, which is `rfl`).
- This left-adjoint pullback is colimit-preserving by construction, carries presentations via `Presentation.map` + `Presentation.ofIsIso`, and establishes per-slice quasi-coherence directly.
- **The intermediate `pushforward_commutes_restriction` lemma (which itself requires `pushforwardPushforwardEquivalence_mathlib`) is entirely bypassed.**

**Assessment**: The blueprint prescribes the harder quadruple route because it was written before the simpler `pullback ψ_r` route was identified. The route is NOT wrong — both approaches prove the same thing — but the blueprint's route requires `pushforward_commutes_restriction`, which is its own build target using `pushforwardPushforwardEquivalence_mathlib`. That's an extra ~100 LOC of plumbing that the simpler route avoids.

**Recommended chapter-side actions** (for blueprint-writer subagent):

1. **Add a blueprint node for `pushforward_iso_qcoh_of_slice_qcoh`** (or, equivalently, update `lem:pushforward_iso_preserves_qcoh` to absorb the `of_coversTop` + cover-transport reduction as an explicit step). The non-private Lean declaration needs a `\lean{...}` reference.

2. **Update `lem:pushforward_iso_preserves_qcoh` proof sketch** to reflect the simpler single-hom route:
   - Remove `\uses{lem:pushforward_commutes_restriction, lem:pushforwardPushforwardEquivalence_mathlib}` (or downgrade to `% NOTE: alternative route`)
   - Replace with: `\uses{lem:pullback_presentation_mathlib}` (or whichever Mathlib lemma `Presentation.map` + `SheafOfModules.pullback` corresponds to)
   - Describe the route as: *fix `i`, let `ψ_r` be the restriction of `φ.hom`'s ring-sheaf hom to the over-category of `V_i`; the pullback `SheafOfModules.pullback ψ_r` (a left adjoint, hence colimit-preserving) carries the presentation `p_i` of `H.over U_i` to a presentation of `(Φ H).over V_i` via `Presentation.map` + `Presentation.ofIsIso`.*

3. **Demote `lem:pushforward_commutes_restriction`** from a build target used by `lem:pushforward_iso_preserves_qcoh` to either: (a) a separate Mathlib-gap lemma that may or may not be built, or (b) deleted if the simpler route makes it genuinely unnecessary. This will unblock the blueprint's `\uses` dependency chain.

---

## Severity summary

- **must-fix-this-iter**: 0 blocking issues. The sorries at `case hqc` and `higherDirectImage_openImmersion_comp` are genuine known residuals, not laundered placeholders.

- **major**:
  - `pushforward_iso_qcoh_of_slice_qcoh` is a non-private substantive public declaration with no `\lean{...}` blueprint reference. The blueprint should either gain a node for it or absorb it into `lem:pushforward_iso_preserves_qcoh`'s proof sketch.
  - Blueprint `lem:pushforward_iso_preserves_qcoh` prescribes a harder route (via `pushforward_commutes_restriction`) than what the prover found (simpler `pullback ψ_r` route). Blueprint proof sketch should be updated before the prover attempts to close `hqc`, to avoid implementing the harder route unnecessarily.

- **minor**:
  - `lem:open_immersion_pushforward_comp` does not list `pushforward_iso_qcoh_of_slice_qcoh` in its `\uses` (it will be needed as an indirect step through `lem:pushforward_iso_preserves_qcoh`). Not urgent since `pushforward_iso_preserves_qcoh` is already in the dependency chain.

**Overall verdict**: `OpenImmersionPushforward.lean` is honest and architecturally sound for iter-061. The two remaining sorries (`hqc` and `_comp`) are genuine, undisguised, and the comment documentation is accurate. The major action item is a blueprint update to align `lem:pushforward_iso_preserves_qcoh`'s prescribed proof route with the simpler `pullback ψ_r` approach the prover identified, and to add a blueprint node for `pushforward_iso_qcoh_of_slice_qcoh`. No must-fix blocking issues.
