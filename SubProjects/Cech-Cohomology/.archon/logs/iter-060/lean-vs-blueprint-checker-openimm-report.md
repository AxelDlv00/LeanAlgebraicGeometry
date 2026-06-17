# Lean ↔ Blueprint Check Report

## Slug
openimm

## Iteration
060

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (blocks whose `\lean{...}` targets live in OpenImmersionPushforward.lean)

---

## Per-declaration

### `\lean{CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms}` (chapter: `\lem:isZero_of_faithful_preservesZeroMorphisms`, line 7177)
- **Lean target exists**: yes (line 42, namespace `CategoryTheory.Functor`)
- **Signature matches**: yes — faithful, zero-morphism-preserving functor reflects zero objects; matches prose exactly
- **Proof follows sketch**: yes — `IsZero.iff_id_eq_zero` + `Functor.map_injective`, matches blueprint proof
- **notes**: Blueprint block has a correct explanatory `% NOTE` (line 7180) about the import-isolation duplicate. Block is missing `\leanok` despite being sorry-free; see Red Flags.

---

### `\lean{CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero}` (chapter: `\lem:isZero_presheafToSheaf_of_sections_locally_zero`, line 9803)
- **Lean target exists**: yes (line 71)
- **Signature matches**: yes — presheaf whose every section is locally killed by a covering sieve has zero sheafification; matches prose exactly
- **Proof follows sketch**: yes — zero map to constant-zero presheaf, locally injective via hypothesis on `x - y`, locally surjective for free; matches blueprint proof
- **notes**: `\leanok` correctly present (set by sync_leanok). No issues.

---

### `\lean{AlgebraicGeometry.toPresheafOfModules_additive}` (chapter: `\lem:toPresheafOfModules_additive`, line 8891)
- **Lean target exists**: yes (line 141)
- **Signature matches**: yes — `toPresheafOfModules X` is additive
- **Proof follows sketch**: yes — exhibited as instance of composite of two additive functors
- **notes**: `\leanok` correctly present.

---

### `\lean{AlgebraicGeometry.sectionsFunctor_additive}` (chapter: `\lem:sectionsFunctor_additive`, line 8910)
- **Lean target exists**: yes (line 148)
- **Signature matches**: yes — `sectionsFunctor V` is additive for any open `V`
- **Proof follows sketch**: yes
- **notes**: `\leanok` correctly present.

---

### `\lean{AlgebraicGeometry.sectionsFunctorCorepIso}` (chapter: `\lem:sectionsFunctorCorepIso`, line 8928)
- **Lean target exists**: yes (line 160)
- **Signature matches**: yes — natural iso `sectionsFunctor V ≅ preadditiveCoyoneda.obj (op (jShriekOU V))`
- **Proof follows sketch**: yes — `NatIso.ofComponents` from `jShriekOU_homEquiv`, naturality via `jShriekOU_homEquiv_nat`
- **notes**: `\leanok` correctly present.

---

### `\lean{AlgebraicGeometry.rightDerivedNatIso}` (chapter: `\lem:rightDerivedNatIso`, line 8955)
- **Lean target exists**: yes (line 178)
- **Signature matches**: yes — natural iso `F ≅ G` induces `F.rightDerived n ≅ G.rightDerived n`
- **Proof follows sketch**: yes — `NatTrans.rightDerived_comp` and `NatTrans.rightDerived_id` for hom-inv cancellations
- **notes**: `\leanok` correctly present.

---

### `\lean{AlgebraicGeometry.isZero_coyoneda_rightDerived_of_forall_ext_eq_zero, AlgebraicGeometry.preadditiveCoyoneda_mapHomologicalComplex_d_apply}` (chapter: `\lem:isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`, line 8605)
- **Lean target exists**: yes (lines 263, 274)
- **Signature matches**: yes — both targets match blueprint prose precisely
- **Proof follows sketch**: yes — `isoRightDerivedObj` + `ExactAt.isZero_homology` + `extMk_eq_zero_iff`; matches blueprint
- **notes**: Block is missing `\leanok` despite both Lean targets being sorry-free. See Red Flags.

---

### `\lean{AlgebraicGeometry.subsingleton_ext_of_iso_fst}` (chapter: `\lem:subsingleton_ext_of_iso_fst`, line 8635)
- **Lean target exists**: yes (line 310)
- **Signature matches**: yes — iso in first Ext-argument transfers subsingletons
- **Proof follows sketch**: yes
- **notes**: `\leanok` correctly present.

---

### `\lean{AlgebraicGeometry.enoughInjectives_of_hasInjectiveResolutions}` (chapter: `\lem:enoughInjectives_of_hasInjectiveResolutions`, line 8661)
- **Lean target exists**: yes (line 299)
- **Signature matches**: yes
- **Proof follows sketch**: yes — degree-0 term of injective resolution as injective presentation
- **notes**: `\leanok` correctly present.

---

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp, AlgebraicGeometry.higherDirectImage_openImmersion_acyclic, AlgebraicGeometry.isAffineHom_of_affine_separated}` (chapter: `\lem:open_immersion_pushforward_comp`, line 8676)
- **Lean target exists**: yes (lines 423, 465, 574)
- **Signature matches**: yes — all three match blueprint statements exactly
- **Proof follows sketch**: partial — `higherDirectImage_openImmersion_acyclic` follows the blueprint route (presheaf description → sections functor corepresentation → coyoneda right-derived → Ext-vanishing) except for `case hqc => sorry` (authorized frontier hole). `higherDirectImage_openImmersion_comp` has trailing `sorry` (authorized frontier hole). `isAffineHom_of_affine_separated` is complete and follows sketch.
- **notes**: No `\leanok` (correct — two open sorries). `isAffineHom_of_affine_separated` is `private` in the Lean file; `sync_leanok` may not resolve `AlgebraicGeometry.isAffineHom_of_affine_separated` due to privacy, but this is a helper and the absence of `\leanok` on the block is explained by the two open sorries.

---

### `\lean{AlgebraicGeometry.pushforwardSectionsFunctor, AlgebraicGeometry.pushforwardSectionsFunctor_additive}` (chapter: `\lem:pushforward_sections_functor`, line 8863)
- **Lean target exists**: yes (lines 436, 443)
- **Signature matches**: yes — pushforward-sections functor `U.Modules ⥤ AddCommGrpCat` and its additivity instance
- **Proof follows sketch**: yes — 5-fold composite with explicit `instAdditiveComp` chain (the `-- Instance search will not pick up` comment is an implementation note, not an excuse-comment)
- **notes**: Block is missing `\leanok` despite both targets being sorry-free. See Red Flags.

---

### `\lean{AlgebraicGeometry.modulesIsoSpecExtTransport, AlgebraicGeometry.Scheme.Modules.pushforwardEquivOfIso, AlgebraicGeometry.pushforwardEquivOfIso_functor_additive, AlgebraicGeometry.Scheme.Modules.pushforwardExtAddEquiv}` (chapter: `\lem:modules_isoSpec_ext_transport`, line 9705)
- **Lean target exists**: yes (lines 204, 214, 223, 241)
- **Signature matches**: yes — all four targets match blueprint prose; `pushforwardEquivOfIso` assembles the module-category equivalence from iso coherences; `pushforwardExtAddEquiv` provides the Ext transport as an additive equiv
- **Proof follows sketch**: yes — `mapExt_bijective_of_preservesInjectiveObjects` + `AddEquiv.ofBijective`; matches blueprint
- **notes**: Block is missing `\leanok` despite all four Lean targets being sorry-free. See Red Flags.

---

### `\lean{AlgebraicGeometry.jShriekOU_transport_along_iso}` (chapter: `\lem:jshriek_transport_along_iso`, line 9508)
- **Lean target exists**: yes (line 391)
- **Signature matches**: yes — `(pushforwardEquivOfIso φ).functor.obj (jShriekOU V) ≅ jShriekOU (φ.inv ⁻¹ᵁ V)` matches blueprint exactly
- **Proof follows sketch**: partial divergence — blueprint sketches a 3-step path through `compCoyonedaIso_mathlib` and `coyoneda_fullyFaithful_mathlib`; Lean proof uses `CorepresentableBy.uniqueUpToIso` applied to two `CorepresentableBy` instances (`sectionsCorep` and `sectionsCorepPushforward`). Mathematical content matches (both prove unique-corepresentant); the `\uses{}` list references `compCoyonedaIso_mathlib` and `coyoneda_fullyFaithful_mathlib` which are NOT used in the actual Lean proof. This is proof-path divergence but not wrong.
- **notes**: `\leanok` is correctly present (line 9506: `\begin{lemma}\leanok`). **Stale NOTE at line 9510 is a must-fix.** See Red Flags.

---

### `\lean{AlgebraicGeometry.ext_jShriekOU_eq_zero_of_specIso}` (chapter: `\lem:ext_jShriekOU_eq_zero_of_specIso`, line 9758)
- **Lean target exists**: yes (line 332)
- **Signature matches**: yes — takes `φ : U ≅ Spec R`, geometric hypotheses `hjt` and `hqc`, returns `e = 0` for every `e : Ext^q(jShriekOU V, H)` with `q ≥ 1`
- **Proof follows sketch**: yes — `pushforwardExtAddEquiv` injectivity + `subsingleton_ext_of_iso_fst` + `affine_serre_vanishing_general_open`; matches blueprint
- **notes**: `\leanok` correctly present.

---

## Red Flags

### Stale excuse-comment
- **`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` line 9510**: `% NOTE: build target. The Lean declaration does not exist yet.` on `lem:jshriek_transport_along_iso`. **This is factually false as of iter-060**: `AlgebraicGeometry.jShriekOU_transport_along_iso` is built and axiom-clean. The `\leanok` marker (line 9506) is already correctly present; only this NOTE is stale. The review agent should remove it.

### Missing `\leanok` markers (likely sync_leanok artifacts)
The following blocks have all Lean targets sorry-free in the `.lean` file but lack `\leanok`:

- `lem:isZero_of_faithful_preservesZeroMorphisms` (line 7174): `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms` is sorry-free (line 42–49).
- `lem:isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` (line 8603): both `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` (line 274) and `preadditiveCoyoneda_mapHomologicalComplex_d_apply` (line 263) are sorry-free.
- `lem:pushforward_sections_functor` (line 8861): `pushforwardSectionsFunctor` and `pushforwardSectionsFunctor_additive` (lines 436, 443) are sorry-free.
- `lem:modules_isoSpec_ext_transport` (line 9703): all four targets (`modulesIsoSpecExtTransport`, `pushforwardEquivOfIso`, `pushforwardEquivOfIso_functor_additive`, `pushforwardExtAddEquiv`) are sorry-free (lines 204–247).

These missing markers prevent the blueprint dependency graph from correctly reflecting the formalization state. Likely cause: `sync_leanok` may have encountered a universe-elaboration or name-resolution issue (e.g. `isAffineHom_of_affine_separated` is `private`; the block `lem:open_immersion_pushforward_comp` that imports `pushforwardSectionsFunctor` has open sorries). The review agent should investigate and add `\leanok` manually where warranted, or flag for the next `sync_leanok` run.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` blueprint block:

- `AlgebraicGeometry.sectionsCorep` (private, line 363): corepresentability helper for `jShriekOU_transport_along_iso`.
- `AlgebraicGeometry.sectionsCorepPushforward` (private, line 372): pushforward corepresentability helper for `jShriekOU_transport_along_iso`.
- `AlgebraicGeometry.jShriekOU_homEquiv_nat` (private, line 126): re-declaration for import isolation; the canonical version is referenced in `lem:absolute_cohomology_zero_natural` (line 3145) from a different file.

All three are `private` and purely auxiliary. The absence of blueprint blocks for `sectionsCorep` and `sectionsCorepPushforward` is coverage debt already noted in the directive — they are the intermediate steps of the corepresentability-transport proof that the blueprint sketches at a higher level.

---

## Blueprint adequacy for this file

- **Coverage**: 13/13 substantive Lean declarations in the file have a corresponding `\lean{...}` block. Unreferenced declarations: 3 private helpers (acceptable). No substantive public declarations are left uncovered.
- **Proof-sketch depth**: **adequate** overall. The proofs of `higherDirectImage_openImmersion_acyclic` and `higherDirectImage_openImmersion_comp` are detailed, covering all major steps (presheaf description, corepresentability, Ext-transport, acyclic resolution). The `hqc` residual is clearly previewed via the blueprint blocks `lem:pushforward_commutes_restriction` (line 9581, `% NOTE: build target`) and `lem:pushforward_iso_preserves_qcoh` (line 9623, `% NOTE: build target`), both of which remain unbuilt Lean targets and are correctly identified as the blocking geometric residual requiring `pushforward_commutes_restriction` (absent in Mathlib). The `jShriekOU_transport_along_iso` proof sketch over-specifies the route (three-step coyoneda path vs. `CorepresentableBy.uniqueUpToIso`), but the mathematical content is equivalent and the sketch is not wrong — it is one valid proof of the same fact.
- **Hint precision**: **precise** for all built declarations. The `\lean{...}` names match the actual Lean qualified names. One minor issue: the `\uses{}` of `lem:jshriek_transport_along_iso` lists `lem:compCoyonedaIso_mathlib` and `lem:coyoneda_fullyFaithful_mathlib`, which are not actually referenced in the final Lean proof (the proof goes through `CorepresentableBy.uniqueUpToIso` instead). This is a stale `\uses{}` entry but does not affect `\leanok` semantics.
- **Generality**: **matches need** — all declarations are at the right level of generality for the project.
- **Recommended chapter-side actions**:
  1. **(major)** Remove the stale `% NOTE: build target. The Lean declaration does not exist yet.` at line 9510 of `lem:jshriek_transport_along_iso` — the declaration is axiom-clean.
  2. **(minor)** Add `\leanok` to the four blocks listed under Red Flags: `lem:isZero_of_faithful_preservesZeroMorphisms`, `lem:isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`, `lem:pushforward_sections_functor`, `lem:modules_isoSpec_ext_transport`.
  3. **(minor)** Optionally update `\uses{}` for `lem:jshriek_transport_along_iso` to reflect the actual proof path (remove `lem:compCoyonedaIso_mathlib` and `lem:coyoneda_fullyFaithful_mathlib`; add a note about `CorepresentableBy.uniqueUpToIso`).
  4. **(minor, coverage debt)** Consider adding a `% NOTE:` or informal subsection covering the corepresentability-transport sub-steps (`sectionsCorep`, `sectionsCorepPushforward`) that the blueprint currently leaves implicit in the proof sketch of `lem:jshriek_transport_along_iso`.

---

## Severity summary

- **must-fix-this-iter**: 1 — stale `% NOTE: build target. The Lean declaration does not exist yet.` on `lem:jshriek_transport_along_iso` (line 9510): falsely asserts the declaration is unbuilt; must be removed to avoid misleading future provers.
- **major**: 0 (the stale NOTE is the only active misdirection finding; the missing `\leanok` markers are likely sync artifacts, not a human-facing mislead)
- **minor**: 5 — (a) four missing `\leanok` markers on sorry-free blocks; (b) stale `\uses{}` entries in `lem:jshriek_transport_along_iso`; (c) blueprint coverage debt for `sectionsCorep`/`sectionsCorepPushforward` private helpers.

**Overall verdict**: The Lean file faithfully follows the blueprint for all substantive declarations; all signatures match; no fake or placeholder statements beyond the two authorized frontier sorries (`hqc` and `higherDirectImage_openImmersion_comp` trailing sorry). One must-fix blueprint annotation (stale NOTE on `lem:jshriek_transport_along_iso`) and four missing `\leanok` markers on sorry-free blocks.
