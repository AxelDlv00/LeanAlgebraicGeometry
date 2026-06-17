# Lean ↔ Blueprint Check Report

## Slug
openimm-iter066

## Iteration
066

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` (chapter: `lem:open_immersion_pushforward_comp`)
- **Lean target exists**: yes (`noncomputable def` at Lean:942)
- **Signature matches**: yes — `higherDirectImage f k ((pushforward j).obj H) ≅ higherDirectImage (j ≫ f) k H` matches the blueprint's `R^k f_*(j_*H) ≅ R^k (j∘f)_* H`
- **Proof follows sketch**: yes (see detail below)
- **Blueprint `\leanok`**: yes — statement block (blueprint:9330) and proof block (blueprint:9352) both carry `\leanok`
- **notes**: Blueprint has `\leanok` on both statement and proof, correctly reflecting the closed state.

**`_comp` proof sub-cases:**

| Case | Blueprint description | Lean code | Match? |
|------|----------------------|-----------|--------|
| `hacyc` (b) | `restrictFunctor j` has left adjoint, hence preserves monos; `injective_of_adjoint` gives `pushforward j` preserves injectives; injective → acyclic | `inferInstanceAs (SheafOfModules.pushforward _).IsRightAdjoint` for `IsRightAdjoint`, then `Injective.injective_of_adjoint (restrictAdjunction j)` | YES — same mathematical argument; different route to mono-preservation (see §advisory below) |
| `eRes` (augmentation) | `j_*H ≅ K.cycles 0` via `R^0 j_* ≅ j_*` + cycles identification | `gCosyzygyIsoCocycles` + `singleObjHomologySelfIso` + `isoOfQuasiIsoAt` + `isoHomologyπ₀.symm` | YES — equivalent, bypasses `R^0 j_* ≅ j_*` explicitly (see §stale `\uses{}`) |
| `hexact` (a) | `H^k(j_*I•) ≅ R^k j_* H` vanishes by `_acyclic` | `isoRightDerivedObj` + `higherDirectImage_openImmersion_acyclic` | YES — exact match |
| `transport` | `pushforwardComp j f` degreewise + `isoRightDerivedObj` for `j ≫ f` | `NatIso.mapHomologicalComplex (Scheme.Modules.pushforwardComp j f)` + `isoRightDerivedObj` | YES — exact match |

**No stale Serre-vanishing-route prose**: The blueprint explicitly states the adjoint-preserves-injectives route is "the formalization-friendly categorical route" and mentions the Stacks `U ∩ f⁻¹V` route ONLY as a contrast that was deliberately avoided (blueprint:9358–9364). The old route is described as a known failure mode, not as an instruction. This is correct.

---

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_acyclic}` (chapter: `lem:open_immersion_pushforward_acyclic`)
- **Lean target exists**: yes (`theorem` at Lean:826)
- **Signature matches**: yes — `IsZero (higherDirectImage j q H)` for `q > 0`, `[IsOpenImmersion j]`, `[IsAffine U]`, `[X.IsSeparated]`, `[HasInjectiveResolutions U.Modules]`
- **Proof follows sketch**: yes — the proof follows the three-step blueprint route (presheaf description, affine-basis Ext vanishing via `ext_jShriekOU_eq_zero_of_specIso`, locally-zero sheafification collapse)
- **Blueprint `\leanok`**: **NO** — neither the statement block (starting blueprint:9183) nor the proof block (starting blueprint:9226) carries `\leanok`, despite the theorem being sorry-free (see §red flags)
- **notes**: The theorem has been sorry-free since iter-065 (see Lean:605–623 comment and memory). `sync_leanok` has NOT added `\leanok` for this lemma; the blueprint incorrectly shows it as unformalized.

---

### `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}` (helper for `lem:open_immersion_pushforward_acyclic`)
- **Lean target exists**: yes, `private lemma isAffineHom_of_affine_separated` at Lean:784
- **Signature matches**: yes
- **Proof follows sketch**: yes (straightforward; uses `IsAffineHom.of_comp`)
- **notes**: Declared `private` in Lean. In Lean 4, private declarations receive name-mangled identifiers. The blueprint's `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}` reference will NOT resolve externally. (See §minor findings.)

---

### `\lean{AlgebraicGeometry.jShriekOU_transport_along_iso}` (chapter: `lem:jshriek_transport_along_iso`)
*(Supporting lemma for `_acyclic`; checked as part of the `_acyclic` closed-state audit.)*
- **Lean target exists**: yes (`noncomputable def` at Lean:391)
- **Signature matches**: yes
- **Proof follows sketch**: yes — corepresentability transport via `CorepresentableBy.uniqueUpToIso`; blueprint describes this exactly
- **Blueprint `\leanok`**: **NO** — neither statement (blueprint:10053) nor proof block carries `\leanok`, despite the declaration being sorry-free
- **notes**: `sectionsCorep` and `sectionsCorepPushforward` listed in `\lean{}` are also `private` (same mangled-name issue). This is the same `sync_leanok` gap as `_acyclic`.

---

## Red Flags

### Missing `\leanok` on sorry-free theorems (`sync_leanok` artifact)
- **`lem:open_immersion_pushforward_acyclic`** (blueprint:9183): Both statement and proof blocks lack `\leanok`. The corresponding Lean theorem `higherDirectImage_openImmersion_acyclic` has zero `sorry` calls (grep confirms only a comment-internal mention at Lean:607). Closed in iter-065.
- **`lem:jshriek_transport_along_iso`** (blueprint:10053): Same issue. The declaration `jShriekOU_transport_along_iso` is sorry-free. Closed in iter-060.
- **Cause**: `sync_leanok` does not appear to have processed these declarations after their respective closures. The blueprint shows them as unformalized when they are complete. This is not a Lean-code error but the blueprint's reported state is wrong.

*(No placeholder bodies, excuse-comments, unauthorized axioms, or weakened definitions found anywhere in the file.)*

---

## Unreferenced declarations (informational)

The following declarations appear in the Lean file but are not directly tagged by any `\lean{}` reference in the chapter. All are structural helpers or private intermediates:

| Declaration | Type | Assessment |
|---|---|---|
| `isZero_of_faithful_preservesZeroMorphisms` (Lean:42) | local supplement | blueprint:`lem:isZero_of_faithful_preservesZeroMorphisms` references it indirectly via `lem:open_immersion_pushforward_acyclic` `\uses{}` |
| `isZero_presheafToSheaf_of_sections_locally_zero` (Lean:71) | local supplement | `lem:isZero_presheafToSheaf_of_sections_locally_zero` at blueprint:10899, which HAS `\leanok` — correctly tagged |
| `jShriekOU_homEquiv_nat` (Lean:126) | `private` helper | internal to corepresentability chain; no blueprint block needed |
| `toPresheafOfModules_additive` (Lean:141) | instance | blueprint:9458 `\lean{AlgebraicGeometry.toPresheafOfModules_additive}` — has `\leanok` |
| `sectionsFunctor_additive` (Lean:148) | instance | blueprint:9478 — has `\leanok` |
| `rightDerivedNatIso` (Lean:178) | def | blueprint:9527 — has `\leanok` |
| `Scheme.Modules.pushforwardEquivOfIso` (Lean:204) | def | part of `lem:modules_pushforward_mathlib` family; referenced as infrastructure |
| `enoughInjectives_of_hasInjectiveResolutions` (Lean:299) | lemma | blueprint:9150 — has `\leanok` |
| `subsingleton_ext_of_iso_fst` (Lean:311) | lemma | `lem:subsingleton_ext_of_iso_fst` — blueprint:9967 has `\leanok` |
| `ext_jShriekOU_eq_zero_of_specIso` (Lean:332) | lemma | blueprint:10851/10853 — has `\leanok` |
| `isAffineHom_of_affine_separated` (Lean:784) | `private` | referenced in `\lean{}` for `_acyclic` but private; see §minor |
| `pushforwardSectionsFunctor` / `_additive` (Lean:797/804) | def/instance | blueprint:9430–9443 `lem:pushforward_sections_functor` |
| RESIDUAL STATE comment (Lean:605–623) | comment | informational; describes iter-065 closure; now partially stale (see §minor) |

All slice-cascade declarations (`sliceStructureSheafHom`, `sliceReverseRingMap`, `pushforwardSliceAdjunctionH1/H2`, `pushforwardSliceTwoAdjunction`, `pushforwardSlicePullbackIso`, `pushforward_iso_preserves_qcoh`) are covered by `\lean{}` tags and all have `\leanok` markers — consistent with iter-065 axiom-clean closure.

---

## Blueprint adequacy for this file

### Coverage
- `lem:open_immersion_pushforward_acyclic` and `lem:open_immersion_pushforward_comp`: fully covered with `\lean{}` hints and extensive proof sketches.
- All major helper lemmas (corepresentability chain, Ext transport cascade, slice adjunction chain) have corresponding `\lean{}` tags.
- **Coverage verdict**: adequate — every substantive declaration has a blueprint block or is a clearly-helper internal.

### Proof-sketch depth
- **`_comp` proof sketch**: **adequate** — the blueprint's three-part structure (b)/(a)/transport is detailed enough to have guided the formalization. The explicit statement "adjoint-preserves-injectives route; the Stacks presheaf route deliberately avoided" gives precise enough guidance.
- **`_acyclic` proof sketch**: **adequate** — the three-step route (presheaf description, sub-steps 2a/2b/2c via isoSpec, locally-zero collapse) is detailed. However the lack of `\leanok` obscures that this was the guidance actually used and successfully formalized.

### Hint precision
- **`lem:open_immersion_pushforward_comp`** `\uses{}`: **stale on two entries**:
  - `lem:restrictFunctorIsoPullback_mathlib`: listed but NOT used in the Lean proof. The proof shows `restrictFunctor j` is a right adjoint by direct definitional unfolding (`unfold Scheme.Modules.restrictFunctor; exact inferInstanceAs (SheafOfModules.pushforward _).IsRightAdjoint`) — never uses the iso `restrictFunctor j ≅ pullback j`.
  - `lem:right_derived_zero_iso_self`: listed but NOT used in the Lean `eRes` case. The proof uses `gCosyzygyIsoCocycles` + `isoOfQuasiIsoAt` + `isoHomologyπ₀` to get the augmentation iso, bypassing `R^0 j_* ≅ j_*`.
- **`isAffineHom_of_affine_separated` in `\lean{}`**: is `private`; Lean 4 mangles the name, so the blueprint reference will not resolve to a public declaration.
- **`sectionsCorep` / `sectionsCorepPushforward` in `\lean{}`** (for `lem:jshriek_transport_along_iso`): also `private` — same name-mangling issue.

### Generality
- Matches need — the blueprint's statements are at the correct level of generality for the Lean consumers.

### Recommended chapter-side actions
1. **[`sync_leanok` fix]** Run `sync_leanok` (or manually trigger it) against `higherDirectImage_openImmersion_acyclic` and `jShriekOU_transport_along_iso`. Both are sorry-free and should have `\leanok` on statement AND proof blocks. This is an automated-sync fix, not a manual blueprint edit.
2. **[Major — stale `\uses{}` in `_comp`]** Remove `lem:restrictFunctorIsoPullback_mathlib` and `lem:right_derived_zero_iso_self` from the `\uses{}` lists of both the statement and proof blocks of `lem:open_immersion_pushforward_comp`. The Lean proof does not depend on these lemmas.
3. **[Minor — private declaration references]** Either rename `isAffineHom_of_affine_separated`, `sectionsCorep`, and `sectionsCorepPushforward` to non-private (remove `private`), or remove them from the `\lean{}` tags (leaving only the public declarations). Blueprint `\lean{}` hints pointing at Lean 4 private declarations are effectively dead references.
4. **[Advisory — stale comment]** The RESIDUAL STATE comment at Lean:605–623 describes iter-065 state. Now that `_comp` is also closed in iter-066, update it (or remove it entirely) to reflect the complete closure of both `_acyclic` and `_comp`.

---

## Severity summary

### Must-fix-this-iter
- **None.** All Lean proofs are sorry-free, all signatures match, no placeholder bodies, no excuse-comments, no unauthorized axioms, no weakened definitions.

### Major
- **Missing `\leanok` on `lem:open_immersion_pushforward_acyclic`** (statement + proof blocks). The blueprint does not reflect the closed state of a sorry-free theorem (iter-065). The `sync_leanok` sync is broken for this declaration. The blueprint incorrectly signals to downstream consumers that this theorem is unformalized.
- **Stale `\uses{}` entries in `lem:open_immersion_pushforward_comp`**: `lem:restrictFunctorIsoPullback_mathlib` and `lem:right_derived_zero_iso_self` are listed as dependencies but are not actually used in the Lean proof. These overstate the dependency graph and could mislead future blueprint-directed work.

### Minor
- **Private declarations in `\lean{}`**: `isAffineHom_of_affine_separated` (for `_acyclic`) and `sectionsCorep`/`sectionsCorepPushforward` (for `lem:jshriek_transport_along_iso`) are `private` in Lean but referenced by `\lean{}`. Blueprint-doctor tools that try to resolve these names externally will fail.
- **Missing `\leanok` on `lem:jshriek_transport_along_iso`** (used transitively by `_acyclic`). Same sync gap.
- **Blueprint prose vs Lean route for `hacyc` mono-preservation**: blueprint says "restriction is exact, hence preserves monos"; Lean says "restriction is a right adjoint, hence mono-preserving." Mathematically equivalent; no correctness issue.
- **Stale RESIDUAL STATE comment** (Lean:605–623): describes iter-065 state only; iter-066 also closed `_comp`. Update advisory.

---

**Overall verdict**: Both `_acyclic` (iter-065) and `_comp` (iter-066) are sorry-free and faithfully implement the blueprint's adjoint-preserves-injectives route; the `_comp` proof has zero stale Serre-vanishing prose. Two major findings: missing `\leanok` markers on `_acyclic` (sync_leanok artifact), and two stale `\uses{}` entries in `_comp` (`restrictFunctorIsoPullback_mathlib`, `right_derived_zero_iso_self`). — 2 declarations checked (primary targets), 0 red flags (sorry/axiom/placeholder), 4 findings (2 major, 2 minor/advisory).
