# Lean ↔ Blueprint Check Report

## Slug
openimm

## Iteration
059

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (chapter covers this file via `% archon:covers AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`)

---

## Per-declaration (blueprint `\lean{...}` blocks)

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` (chapter: `lem:open_immersion_pushforward_comp` part 2)
- **Lean target exists**: yes (line 527–551)
- **Signature matches**: yes (pinned declaration: `higherDirectImage f k ((pushforward j).obj H) ≅ higherDirectImage (j ≫ f) k H`)
- **Proof follows sketch**: **no** — body is `haveI ... sorry`. The blueprint has a full sketch (acyclic resolution comparison via `rightDerivedIsoOfAcyclicResolution` + `pushforwardComp`); the Lean has only setup boilerplate followed by `sorry`. Two sub-obligations (resolution exactness, f\_*-acyclicity of j\_\*Iⁿ) are identified in comments but not proven.
- **notes**: placeholder body on a declaration the blueprint claims is substantive. **MUST-FIX flag** — see Red Flags §1.

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_acyclic}` (chapter: `lem:open_immersion_pushforward_comp` part 1)
- **Lean target exists**: yes (line 418–510)
- **Signature matches**: yes (`IsZero (higherDirectImage j q H)` for `q ≥ 1`, qcoh `H`, open immersion `j`, affine `U`, separated `X`)
- **Proof follows sketch**: **partial** — the main structural reduction (presheaf description → sheafification → locally zero → affine Serre vanishing via Ext transport) is correctly wired. Two sorry holes remain: `hjt` (type `Φ.functor.obj (jShriekOU V) ≅ jShriekOU V'`) and `hqc` (type `(Φ.functor.obj H).IsQuasicoherent`).
- **notes**: The Lean proof structure faithfully encodes the blueprint's step-by-step argument (steps 2a/2b/2c from lines 8670–8700). The two sorry holes are correctly typed against their blueprint targets (see §hjt/hqc typing below).

### `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}` (chapter: `lem:open_immersion_pushforward_comp`)
- **Lean target exists**: yes (line 376–382, `private lemma`)
- **Signature matches**: yes (`IsAffineHom j` given `IsAffine U` and `X.IsSeparated`)
- **Proof follows sketch**: yes — separatedness + terminal factoring; correct.
- **notes**: none.

### `\lean{AlgebraicGeometry.modulesIsoSpecExtTransport}` (chapter: `lem:modules_isoSpec_ext_transport`)
- **Lean target exists**: yes (line 241–247)
- **Signature matches**: yes — `Ext A B n ≃+ Ext (Φ.functor.obj A) (Φ.functor.obj B) n` at `Φ = pushforwardEquivOfIso U.isoSpec`
- **Proof follows sketch**: yes — one-liner delegating to `pushforwardExtAddEquiv`.
- **notes**: none.

### `\lean{AlgebraicGeometry.Scheme.Modules.pushforwardEquivOfIso}` (chapter: `lem:modules_isoSpec_ext_transport`)
- **Lean target exists**: yes (line 204–211)
- **Signature matches**: yes — equivalence assembled from `pushforward φ.hom`/`φ.inv` + coherences.
- **Proof follows sketch**: yes.
- **notes**: none.

### `\lean{AlgebraicGeometry.pushforwardEquivOfIso_functor_additive}` (chapter: `lem:modules_isoSpec_ext_transport`)
- **Lean target exists**: yes (line 214–216, `noncomputable instance`)
- **Signature matches**: yes.
- **notes**: none.

### `\lean{AlgebraicGeometry.Scheme.Modules.pushforwardExtAddEquiv}` (chapter: `lem:modules_isoSpec_ext_transport`)
- **Lean target exists**: yes (line 223–230)
- **Signature matches**: yes — `Ext A B n ≃+ Ext (Φ.functor.obj A) (Φ.functor.obj B) n` via `mapExt_bijective`.
- **notes**: none.

### `\lean{AlgebraicGeometry.jShriekOU_transport_along_iso}` (chapter: `lem:jshriek_transport_along_iso`)
- **Lean target exists**: **no** — no declaration named `jShriekOU_transport_along_iso` anywhere in the file or project. Only `hjt : Φ.functor.obj (jShriekOU V) ≅ jShriekOU V'` as a sorry hole inside `higherDirectImage_openImmersion_acyclic` (line 484).
- **Signature matches**: N/A (declaration absent)
- **notes**: Blueprint marks this as `% NOTE: build target. The Lean declaration does not exist yet.` — acknowledged gap. The sorry hole `hjt` provides the correctly-typed local instance. See §hjt/hqc typing. **Major** (missing declared Lean target for named blueprint lemma).

### `\lean{AlgebraicGeometry.pushforward_iso_preserves_qcoh}` (chapter: `lem:pushforward_iso_preserves_qcoh`)
- **Lean target exists**: **no** — only `hqc : (Φ.functor.obj H).IsQuasicoherent` as sorry hole (line 485).
- **Signature matches**: N/A
- **notes**: Blueprint marks as `% NOTE: build target. The Lean declaration does not exist yet.` See §hjt/hqc typing. **Major**.

### `\lean{AlgebraicGeometry.pushforward_commutes_free}` (chapter: `lem:pushforward_commutes_free`)
- **Lean target exists**: **no** (blueprint: `% NOTE: build target. The Lean declaration does not exist yet.`)
- **notes**: Sub-lemma needed to prove `jShriekOU_transport_along_iso`. **Major** (build chain is 4 deep: this → sheafify + yoneda → jshriek\_transport → hjt/hqc → acyclicity → comp).

### `\lean{AlgebraicGeometry.pushforward_commutes_sheafify}` (chapter: `lem:pushforward_commutes_sheafify`)
- **Lean target exists**: **no** (blueprint: `% NOTE: build target.`)
- **notes**: Same. **Major**.

### `\lean{AlgebraicGeometry.yoneda_transport_along_homeo}` (chapter: `lem:yoneda_transport_along_homeo`)
- **Lean target exists**: **no** (blueprint: `% NOTE: build target.`)
- **notes**: Same. **Major**.

### `\lean{CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero}` (chapter: `lem:isZero_presheafToSheaf_of_sections_locally_zero`)
- **Lean target exists**: yes (line 71–101)
- **Signature matches**: yes — hypothesis is sectionwise-locally-zero (stronger than objectwise); correct.
- **Proof follows sketch**: yes.
- **notes**: none.

### `\lean{AlgebraicGeometry.sectionsFunctorCorepIso}` (chapter: `lem:sectionsFunctorCorepIso`)
- **Lean target exists**: yes (line 160–173)
- **Signature matches**: yes.
- **notes**: none.

### `\lean{AlgebraicGeometry.rightDerivedNatIso}` (chapter: `lem:rightDerivedNatIso`)
- **Lean target exists**: yes (line 178–184)
- **Signature matches**: yes.
- **notes**: none.

### `\lean{AlgebraicGeometry.pushforwardSectionsFunctor}` + `pushforwardSectionsFunctor_additive` (chapter: `lem:pushforward_sections_functor`)
- **Lean target exists**: yes (lines 389–416)
- **Signature matches**: yes.
- **notes**: none.

### `\lean{AlgebraicGeometry.toPresheafOfModules_additive}` + `sectionsFunctor_additive` (chapter: `lem:toPresheafOfModules_additive`, `lem:sectionsFunctor_additive`)
- **Lean target exists**: yes (lines 141–154)
- **Signature matches**: yes.
- **notes**: none.

---

## hjt / hqc sorry typing

**`hjt`** (line 484): type `(Scheme.Modules.pushforwardEquivOfIso φ).functor.obj (jShriekOU V) ≅ jShriekOU V'`
with `φ = U.isoSpec`, `V = j ⁻¹ᵁ W`, `V' = U.isoSpec.inv ⁻¹ᵁ (j ⁻¹ᵁ W)`.

Blueprint `lem:jshriek_transport_along_iso` states: `Φ.functor.obj(j_!𝒪_V) ≅ j_!𝒪_{φ.hom''V}`.
The Lean `V' = U.isoSpec.inv ⁻¹ᵁ (j⁻¹W)` equals `U.isoSpec.hom''(j⁻¹W)` (for a scheme iso, preimage under `.inv` = image under `.hom`). **Type is correct** for the local instance at `φ = U.isoSpec`, `V = j⁻¹W`.

**`hqc`** (line 485): type `((Scheme.Modules.pushforwardEquivOfIso φ).functor.obj H).IsQuasicoherent`
with `φ = U.isoSpec`.

Blueprint `lem:pushforward_iso_preserves_qcoh` states: `Φ.functor.obj H` is quasi-coherent for iso `φ` and qcoh `H`. **Type is correct** for the local instance.

**Conclusion**: both sorry holes are correctly typed for their purpose as local applications of the respective blueprint lemmas. Neither is vacuous or weakened. The obligation is genuine.

---

## Red Flags

### Placeholder / suspect bodies

1. **`AlgebraicGeometry.higherDirectImage_openImmersion_comp`** (line 527–551): proof body is effectively `sorry` — after the `haveI IsAffineHom` setup, the only tactic is `sorry`. Blueprint (`lem:open_immersion_pushforward_comp` part 2) describes a full, substantive proof via acyclic resolution comparison. **MUST-FIX-THIS-ITER.**

2. **`hjt` goal** (line 484, `case hjt => sorry`) and **`hqc` goal** (line 485, `case hqc => sorry`): these are open obligations within `higherDirectImage_openImmersion_acyclic` for the two geometric transport sub-lemmas. Blueprint acknowledges them as unbuilt targets but names them as standalone lemmas (`jShriekOU_transport_along_iso`, `pushforward_iso_preserves_qcoh`). Not standalone declarations yet — they exist only as local sorry holes. **Major** (these need to be extracted to standalone declarations matching the blueprint's `\lean{}` hints).

### Excuse-comments

None found. The `-- RESIDUAL (...)` comments in `higherDirectImage_openImmersion_comp` and `higherDirectImage_openImmersion_acyclic` accurately identify the remaining proof obligations without excusing wrong code.

### Axioms / Classical.choice on non-trivial claims

None found.

---

## Unreferenced declarations (informational)

The following declarations appear in the Lean file but have no `\lean{...}` reference in the blueprint chapter:

| Declaration | Private? | Substantive? | Comment |
|---|---|---|---|
| `preadditiveCoyoneda_mapHomologicalComplex_d_apply` | yes (private) | helper | differential computation; fine as private helper |
| `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` | **no** | **yes** | Bridge (1)/(2): converts `∀ e : Ext P H q, e = 0` to `IsZero (coyoneda.rightDerived q)(H)`. Non-trivial: uses `InjectiveResolution.extMk`, `extMk_eq_zero_iff`, `HomologicalComplex.ExactAt.isZero_homology`. Blueprint proof sketch (line 8676–8679) alludes to this step but gives no standalone declaration. **Should be blueprinted.** |
| `enoughInjectives_of_hasInjectiveResolutions` | **no** | connector | Derives `EnoughInjectives C` from `HasInjectiveResolutions C`. Minor connector, but non-private suggests it should get a blueprint note. |
| `subsingleton_ext_of_iso_fst` | **no** | **yes** | Transfers `Subsingleton (Ext B Y q)` to `Subsingleton (Ext A Y q)` via `φ : A ≅ B`. Used to transport Serre vanishing through the `hjt` iso. Non-trivial. **Should be blueprinted.** |
| `ext_jShriekOU_eq_zero_of_specIso` | **no** | **yes** | The assembled Serre-vanishing leaf, parameterized over `hjt`/`hqc`. The most important intermediate result in the file: combines `pushforwardExtAddEquiv` + `subsingleton_ext_of_iso_fst` + `affine_serre_vanishing_general_open`. Blueprint describes this argument inline (lines 9526–9534) but names no standalone Lean declaration. **Should be blueprinted.** |
| `jShriekOU_homEquiv_nat` | yes (private) | helper | Naturality of `jShriekOU_homEquiv`; private helper for `sectionsFunctorCorepIso`. Fine. |
| `toPresheafOfModules_additive` | no (instance) | helper | Explicitly blueprinted in `lem:toPresheafOfModules_additive`. ✓ |
| `sectionsFunctor_additive` | no (instance) | helper | Explicitly blueprinted in `lem:sectionsFunctor_additive`. ✓ |
| `isAffineHom_of_affine_separated` | yes (private) | helper | Blueprinted inside `lem:open_immersion_pushforward_comp`. ✓ |
| `pushforwardSectionsFunctor_additive` | no (instance) | helper | Blueprinted in `lem:pushforward_sections_functor`. ✓ |

---

## Blueprint adequacy for this file

**Coverage**: 18 declarations (excluding private helpers) vs. ~10 with `\lean{...}` blueprint references. 3 substantive public declarations lack blueprint entries: `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`, `subsingleton_ext_of_iso_fst`, `ext_jShriekOU_eq_zero_of_specIso`. Additionally, 5 named blueprint targets (`jShriekOU_transport_along_iso`, `pushforward_iso_preserves_qcoh`, `pushforward_commutes_free`, `pushforward_commutes_sheafify`, `yoneda_transport_along_homeo`) are marked as unbuilt but lack Lean declarations.

**Proof-sketch depth**:

- `lem:open_immersion_pushforward_comp` (part 1, the acyclicity theorem): **adequate** — steps 2a/2b/2c (lines 8670–8700) give a clear road map. The prover correctly follows it. The step that converts "Ext vanishing" to "right-derived vanishing" (`isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`) and the assembled transport lemma (`ext_jShriekOU_eq_zero_of_specIso`) are mentioned implicitly but not separated out as named blueprint lemmas. This required the prover to extract two non-trivial named intermediate results not described as standalone declarations by the blueprint. **Under-specified** in this respect.

- `lem:open_immersion_pushforward_comp` (part 2, the composition formula): **adequate as a sketch** — the sorry body shows the prover understood the structure, but actual formalization is blocked by the acyclicity residual.

- `lem:jshriek_transport_along_iso`: **adequate** — three explicit sub-lemmas (commutes with free/sheafify, yoneda transport) with mathematical content spelled out (lines 9436–9453). However, all three sub-lemmas are themselves unbuilt, creating a chain of 3 missing declarations as prerequisites.

- `lem:pushforward_iso_preserves_qcoh`: **under-specified** — the proof says "transports verbatim" and "covers go to covers under the homeomorphism." No Mathlib API is named (no `SheafOfModules.isQuasicoherent_pushforward` or similar), and the Lean formalization of "quasi-coherence transports across a ring-sheaf iso" is non-trivial. A prover following this blueprint would not know which Mathlib primitives to use. **Recommend expanding with specific API guidance.**

**Hint precision**: **loose** for `lem:pushforward_iso_preserves_qcoh` (prose describes the argument but names no Lean predicate or Mathlib lemma for the key step). Precise for all other covered lemmas.

**Generality**: matches need — all declarations are at the right generality for the project.

**Recommended chapter-side actions**:
1. Add a `\lean{...}` block for `AlgebraicGeometry.isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` (new lemma block between `lem:ext_homcomplex_mathlib` and `lem:open_immersion_pushforward_comp`). Statement: if `∀ e : Ext P H q, e = 0` for `q ≥ 1` then `IsZero ((preadditiveCoyoneda.obj (op P)).rightDerived q).obj H`. Proof sketch: recognize the right-derived object as the homology of the Hom-cochain-complex via `isoRightDerivedObj`, then apply `extMk_eq_zero_iff` to convert zero Ext classes to boundary witnesses.
2. Add a `\lean{...}` block for `AlgebraicGeometry.subsingleton_ext_of_iso_fst`. Trivial from contravariant Ext functoriality.
3. Add a `\lean{...}` block for `AlgebraicGeometry.ext_jShriekOU_eq_zero_of_specIso`. Statement: given `φ : U ≅ Spec R`, affine open `V'`, iso `Φ(jShriek V) ≅ jShriek V'`, and qcoh `Φ H`, every `e : Ext(jShriek V) H q` is zero for `q ≥ 1`. This is the assembly of `pushforwardExtAddEquiv` + `subsingleton_ext_of_iso_fst` + `affine_serre_vanishing_general_open`.
4. Add a brief `\lean{...}` note for `AlgebraicGeometry.enoughInjectives_of_hasInjectiveResolutions`.
5. Expand the `lem:pushforward_iso_preserves_qcoh` proof sketch with concrete API: the `SheafOfModules.pushforward` functor at an isomorphism should preserve the quasi-coherence property; identify the relevant Mathlib lemma or note that it requires `Scheme.Modules.pushforward_isQuasicoherent` (or equivalent).

---

## Severity summary

| # | Finding | Severity |
|---|---|---|
| 1 | `higherDirectImage_openImmersion_comp` body is `sorry` (placeholder on substantive blueprint claim) | **must-fix-this-iter** |
| 2 | `jShriekOU_transport_along_iso` — blueprint `\lean{}` target missing in Lean | major |
| 3 | `pushforward_iso_preserves_qcoh` — blueprint `\lean{}` target missing in Lean | major |
| 4 | `pushforward_commutes_free` / `_sheafify` / `yoneda_transport_along_homeo` — all three blueprint `\lean{}` targets missing | major |
| 5 | `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` — substantive public decl, no blueprint block | major |
| 6 | `ext_jShriekOU_eq_zero_of_specIso` — substantive public decl (key assembled leaf), no blueprint block | major |
| 7 | `subsingleton_ext_of_iso_fst` — substantive public decl, no blueprint block | major |
| 8 | Blueprint `lem:pushforward_iso_preserves_qcoh` proof sketch under-specified (no Lean API guidance) | major |
| 9 | `enoughInjectives_of_hasInjectiveResolutions` — public connector, no blueprint block | minor |

**Overall verdict**: One must-fix (`higherDirectImage_openImmersion_comp` is a sorry placeholder) and a significant blueprint coverage gap — four new public substantive lemmas added this iteration have no `\lean{...}` references, and five named blueprint targets remain unbuilt. The `hjt`/`hqc` sorry holes are correctly typed for their respective blueprint lemma instances and the blueprint adequately sketches `lem:jshriek_transport_along_iso`; `lem:pushforward_iso_preserves_qcoh` needs API-level expansion.
