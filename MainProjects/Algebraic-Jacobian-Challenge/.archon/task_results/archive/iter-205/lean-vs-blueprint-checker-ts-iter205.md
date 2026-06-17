# Lean ↔ Blueprint Check Report

## Slug
ts-iter205

## Iteration
205

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)
- **Lean target exists**: yes (L113)
- **Signature matches**: yes — `{X : Scheme.{u}} (M N : X.Modules) : X.Modules`; blueprint says "binary operation on `Scheme.Modules X`" with the same type shape
- **Proof follows sketch**: yes — body uses `PresheafOfModules.sheafification … .obj (PresheafOfModules.Monoidal.tensorObj M.val N.val)`, which is exactly the "compose `PresheafOfModules.Monoidal.tensorObj` with the sheafification functor" route the blueprint specifies
- **notes**: `\leanok` present on statement block (correct: non-sorry body). Substantive implementation, no concerns.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes (L129)
- **Signature matches**: yes — `{M M' N N' : X.Modules} (f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N'`; blueprint says "morphism pair `f, g` determines `f ⊗ g : tensorObj M N ⟶ tensorObj M' N'`"
- **Proof follows sketch**: yes — body applies `(sheafification …).map (MonoidalCategory.tensorHom f.val g.val)`, lifting the presheaf-level `tensorHom` via sheafification exactly as the blueprint describes
- **notes**: `\leanok` present on statement block (correct). The lemma statement block in the blueprint also lists associator/unitor/braiding isomorphisms; those are not encoded as separate fields of this `def` but instead emerge from the `monoidalCategory` instance. This is an acceptable structural deviation: the blueprint's lemma bundles "bifunctoriality + natural-isomorphism data" while the Lean file separates `tensorObj_functoriality` (raw morphism action) from `monoidalCategory` (coherence isomorphisms). Not a mismatch — the mathematical content is the same.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.monoidalCategory}` (chapter: `thm:scheme_modules_monoidal`)
- **Lean target exists**: yes (L150)
- **Signature matches**: yes — `instance monoidalCategory {X : Scheme.{u}} : MonoidalCategory (X.Modules)`; blueprint targets exactly this instance
- **Proof follows sketch**: N/A — body is `:= sorry` (KNOWN scaffold from directive; pre-acknowledged)
- **notes**: `\leanok` present on statement block (correct: sorry-bodied decl exists). The blueprint proof block deliberately has no `\leanok` and carries a `% NOTE (plan iter-204)` explaining the omission. The statement-level `\leanok` is accurate. **No new regression.**

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (chapter: `lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes (L277)
- **Signature matches**: yes — `{M N : X.Modules} (hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N) : LineBundle.IsLocallyTrivial (tensorObj M N)`; blueprint says "locally-trivial rank-one implies tensor product is locally trivial rank-one"
- **Proof follows sketch**: yes (structurally) — proof picks a common affine open `W ∋ x` contained in trivialising opens for `M` and `N`, refines trivialisations via `restrictIsoUnitOfLE`, then chains `tensorObj_restrict_iso ≪≫ tensorObjIsoOfIso … ≪≫ tensorObj_unit_iso`. This exactly mirrors the blueprint's "pick common affine open, restrict trivialisations, tensor-of-trivials is trivial" argument
- **notes**: `\leanok` present on statement block (correct). The proof body is substantive, but `tensorObj_restrict_iso` (called at L288) has a typed `sorry` body (KNOWN scaffold). The proof compiles conditionally on that scaffold; the structure is correct. Not a new regression.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: `lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes (L300)
- **Signature matches**: yes — `{L : X.Modules} (hL : LineBundle.IsLocallyTrivial L) : ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ 𝟙_ (X.Modules))`; blueprint says "dual `L⁻¹` is again a line bundle with `L ⊗ L⁻¹ ≅ 𝒪_X`"
- **Proof follows sketch**: N/A — body is `:= sorry` (KNOWN scaffold from directive; pre-acknowledged)
- **notes**: `\leanok` present on statement block (correct: sorry-bodied decl exists). **No new regression.**

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (chapter: `lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes (L312)
- **Signature matches**: yes — `{S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S) (L L' : LineBundle.OnProduct πC πT) : LineBundle.OnProduct πC πT`; blueprint says bifunctor restricts to `LineBundle.OnProduct πC πT` with the locally-trivial constraint preserved
- **Proof follows sketch**: yes — body constructs `⟨tensorObj L.carrier L'.carrier, tensorObj_isLocallyTrivial L.isLocallyTrivial L'.isLocallyTrivial⟩`, which is exactly "apply `tensorObj_isLocallyTrivial` to the carriers"
- **notes**: `\leanok` present on statement block (correct). Substantive, no concerns.

---

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (chapter: `thm:rel_pic_addcommgroup_via_tensorobj`)
- **Lean target exists**: yes (L339)
- **Signature matches**: yes — `{S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S) : AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))`; blueprint targets exactly `AddCommGroup` on `Pic(C ×_S T) / π_T^* Pic(T)`
- **Proof follows sketch**: N/A — body is `:= sorry` (KNOWN scaffold from directive; pre-acknowledged)
- **notes**: `\leanok` present on statement block (correct: sorry-bodied decl exists). **No new regression.**

---

## Red flags

### Placeholder / suspect bodies — KNOWN scaffolds only (pre-acknowledged in directive)

| Declaration | Line | Body | Blueprint claim |
|---|---|---|---|
| `Scheme.Modules.monoidalCategory` | 150 | `:= sorry` | `thm:scheme_modules_monoidal` — instance body deferred |
| `Scheme.Modules.tensorObj_restrict_iso` | 249 | `sorry` in `by` block | Supporting lemma (PUSH-BEYOND, not `\lean{}`-pinned); typed scaffold |
| `Scheme.Modules.exists_tensorObj_inverse` | 300 | `:= sorry` | `lem:tensorobj_inverse_invertible` — body deferred |
| `Scheme.PicSharp.addCommGroup_via_tensorObj` | 339 | `:= sorry` | `thm:rel_pic_addcommgroup_via_tensorobj` — body deferred |

All four are pre-acknowledged in the directive as iter-202 Lane TS scaffold stubs. No new regressions.

### Excuse-comments
None new. The docstrings and section headers explain deferred bodies accurately as scaffolds ("iter-202 Lane TS scaffold", "iter-203+ work"), which is appropriate workflow annotation, not an excuse for wrong code.

### Axioms / Classical.choice on non-trivial claims
None found.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` blueprint pin:

| Declaration | Line | Role | Assessment |
|---|---|---|---|
| `Scheme.Modules.tensorObjIsoOfIso` | 169 | Helper: iso-of-iso for `tensorObjIsoOfIso` feeding `tensorObj_isLocallyTrivial` | Acceptable internal helper |
| `Scheme.Modules.tensorObj_unit_iso` | 185 | Helper: `𝒪_X ⊗ 𝒪_X ≅ 𝒪_X`, feeding `tensorObj_isLocallyTrivial` | Acceptable internal helper |
| `Scheme.Modules.restrictIsoUnitOfLE` | 203 | Helper: restriction-to-smaller-open for `tensorObj_isLocallyTrivial` | Acceptable internal helper; substantive proof |
| `Scheme.Modules.tensorObj_restrict_iso` | 249 | PUSH-BEYOND scaffold: `(M ⊗ N)|_f ≅ M|_f ⊗ N|_f`; consumed by `tensorObj_isLocallyTrivial` | PUSH-BEYOND (expected unformalized); worth a future `\lean{}` pin once formalized |
| `isMonoidal_W_of_whiskerLeft` | 417 | Project-local Mathlib supplement: `whiskerLeft` stability → `W.IsMonoidal` | New iter-205 addition — see "Blueprint adequacy" below |
| `monoidalCategoryOfIsMonoidalW` | 446 | Project-local Mathlib supplement: `W.IsMonoidal` → `MonoidalCategory (SheafOfModules R)` | New iter-205 addition — see "Blueprint adequacy" below |

The blueprint also has `lem:pullback_compatible_with_tensorobj` (the `π_T^*` is a tensor functor lemma) without a `\lean{...}` pin and no corresponding Lean declaration. This is expected per the chapter's own LOC sequencing (Piece 3d, PUSH-BEYOND); not a regression.

---

## Blueprint adequacy for this file

### Coverage
7/7 `\lean{...}`-pinned declarations have corresponding Lean targets. Unreferenced Lean declarations: 4 helper defs (acceptable) + 2 substantive project-local infrastructure declarations (discussed below). Blueprint has 1 un-pinned lemma block (`lem:pullback_compatible_with_tensorobj`) — expected PUSH-BEYOND.

### Proof-sketch depth
**Adequate** for all pinned declarations, with one **under-specified** area:

The blueprint's proof sketch for `thm:scheme_modules_monoidal` (chapter §3, L288–335) describes:
1. Pentagon/triangle inheritance from `PresheafOfModules.Monoidal` (affine descent)
2. The localization transport strategy: `PresheafOfModules.sheafification.IsLocalization` + `instMonoidalCategoryLocalizedMonoidal` gives `MonoidalCategory (SheafOfModules R)` from `MorphismProperty.IsMonoidal W`
3. **Identifies `IsMonoidal W` for the relative `⊗_R` as the single missing ingredient**

The two new iter-205 Lean declarations go one level deeper:
- `isMonoidal_W_of_whiskerLeft` (L417): decomposes `IsMonoidal W` into `whiskerLeft` stability alone, using the symmetric braiding to recover `whiskerRight` via `arrow_mk_iso_iff`
- `monoidalCategoryOfIsMonoidalW` (L446): makes the localization transport explicit as `inferInstanceAs (MonoidalCategory (LocalizedMonoidal …))` with `Iso.refl`

**Gap**: The blueprint correctly identifies `IsMonoidal W` as the key missing piece but does **not** describe the further reduction `whiskerLeft → IsMonoidal W` (the `arrow_mk_iso_iff` braiding trick for `whiskerRight`). This step is non-trivial and is the novel mathematical content of the two new declarations. A future reader of the blueprint would know "build `IsMonoidal W`" but would not be guided to "reduce it to `whiskerLeft` via the braiding".

Since these two declarations are explicitly project-local infrastructure (labeled `@[implicit_reducible]`, not `\lean{}`-pinned, described as "precise compiled decomposition of the obstruction"), they fall in the helper category. However, the proof-sketch for `thm:scheme_modules_monoidal` is now **under-specified** relative to the Lean file's actual construction strategy for the `IsMonoidal W` step.

### Hint precision
**Precise** — all 7 `\lean{...}` tags name the correct fully-qualified Lean identifiers, and the signatures match the prose descriptions.

### Generality
**Matches need** — the two new supplement declarations are stated at full generality (arbitrary site `J`, presheaf of commutative rings `R'`, sheaf `R`) as intended; blueprint's discussion of the obstacle is for the scheme-specific case, which is appropriately the downstream consumer.

### Recommended chapter-side actions

1. **(Minor)** Expand the proof sketch of `thm:scheme_modules_monoidal` to describe the `isMonoidal_W_of_whiskerLeft` reduction: specifically, that `IsMonoidal W` follows from `whiskerLeft` stability alone, and that `whiskerRight` follows from `whiskerLeft` via the symmetric braiding (`arrow_mk_iso_iff`). One or two sentences in the "Concrete Mathlib realisation" paragraph (after L325) would suffice:

   > *Concretely, `IsMonoidal W` reduces to `whiskerLeft` stability alone: if `W g` holds then `W (F ◁ g)` for all `F`, because `W (g ▷ G)` follows by `(W.arrow_mk_iso_iff (Arrow.isoMk (β_ F₁ G) (β_ F₂ G))).2` applied to the `whiskerLeft` case (using the symmetric braiding). This is encoded project-locally as `isMonoidal_W_of_whiskerLeft`; given `W.IsMonoidal`, the transport itself is `monoidalCategoryOfIsMonoidalW` via `inferInstanceAs (MonoidalCategory (LocalizedMonoidal …))`.*

2. **(Informational)** Once `tensorObj_restrict_iso` is formalized (iter-203+ PUSH-BEYOND), add a `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` pin to the proof of `lem:tensorobj_preserves_locally_trivial` with a brief statement block.

---

## Severity summary

- **must-fix-this-iter**: None. The 4 typed-sorry bodies are pre-acknowledged KNOWN scaffolds; the 2 new declarations have clean substantive bodies; no signature mismatches, no excuse-comments, no unauthorized axioms.
- **major**: None.
- **minor**: (1) `thm:scheme_modules_monoidal` proof sketch is under-specified regarding the `whiskerLeft → IsMonoidal W` reduction encoded by `isMonoidal_W_of_whiskerLeft`; the chapter should be updated to describe this reduction at one or two sentence level. (2) `tensorObj_restrict_iso` (unpin, sorry-body, PUSH-BEYOND) warrants a future `\lean{}` pin.

**Overall verdict**: No new regressions this iteration; the file is consistent with the blueprint at the 7 pinned declarations, the 4 known scaffold sorries are pre-acknowledged, and the 2 new project-local supplement declarations are axiom-clean and consistent with (though slightly ahead of) the chapter's proof sketch for `thm:scheme_modules_monoidal`.
