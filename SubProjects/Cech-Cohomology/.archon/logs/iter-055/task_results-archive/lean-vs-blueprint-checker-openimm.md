# Lean ↔ Blueprint Check Report

## Slug
openimm

## Iteration
054

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (relevant blocks: `lem:open_immersion_pushforward_comp` at L7596–7731,
  `lem:isZero_of_faithful_preservesZeroMorphisms` at L7177–7197,
  `lem:isZero_presheafToSheaf_of_locally_isZero` at L7199–7225)

---

## Per-declaration

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` (chapter: `lem:open_immersion_pushforward_comp`)
- **Lean target exists**: yes (line 266, `noncomputable def`)
- **Signature matches**: yes
  - Blueprint: "R^k f_*(j_*H) ≅ R^k g_*H" for k : ℕ (no lower bound, so k ≥ 0)
  - Lean: `(k : ℕ) : higherDirectImage f k ((pushforward j).obj H) ≅ higherDirectImage (j ≫ f) k H`
  - Canonical `≅` (not `Nonempty (A ≅ B)`) — matches blueprint claim exactly ✓
  - D2 re-signing from prior iter confirmed correct
- **Proof follows sketch**: N/A (body is `sorry`; structural plan comment at lines 273–289 is accurate and faithful to the blueprint's acyclic-resolution route)
- **notes**: Expected sorry for this iter; depends on `_acyclic` residual. Structural proof plan is complete, detail-level matches blueprint's acyclic-resolution scheme. No excuse-comment issue.

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_acyclic}` (chapter: `lem:open_immersion_pushforward_comp`)
- **Lean target exists**: yes (line 179, `theorem`)
- **Signature matches**: yes
  - Blueprint: "R^q j_*H = 0 for all q ≥ 1 and every quasi-coherent H"
  - Lean: `(H : U.Modules) (hH : H.IsQuasicoherent) (q : ℕ) (hq : 0 < q) : IsZero (higherDirectImage j q H)` ✓
- **Proof follows sketch**: partial — wired to a single leaf sorry
  - The reduction chain (presheaf description → sheafification square → sectionwise-locally-zero basis argument) is fully wired down to the single leaf at line 224:
    `IsZero (((pushforwardSectionsFunctor j W).rightDerived q).obj H)` for affine `W`, `q > 0`
  - This leaf is exactly Bridge (2) in the blueprint proof sketch: "for affine V, j⁻¹V is affine (j is affine-morphism), transport Serre vanishing"
  - Residual matches blueprint's intended leaf ✓
- **notes**: The reduction route uses a stronger site lemma (`isZero_presheafToSheaf_of_sections_locally_zero`) than the one the blueprint's sketch pointed toward — see Blueprint Adequacy below.

### `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}` (chapter: `lem:open_immersion_pushforward_comp`)
- **Lean target exists**: yes — but at line 137 as **`private lemma`**
- **Signature matches**: yes (content matches blueprint prose: "open immersion of an affine open into a separated scheme is an affine morphism")
- **Proof follows sketch**: yes (three-line proof: `IsAffineHom.of_comp` with `terminal.from`)
- **notes**: **MAJOR** — the declaration is `private`; in Lean 4 the environment name of a `private` declaration is mangled to include the file path, making `AlgebraicGeometry.isAffineHom_of_affine_separated` unresolvable. The blueprint's `\lean{}` pin is broken for this entry. Either remove `private` or remove the `\lean{}` pin.

### `\lean{AlgebraicGeometry.isZero_of_faithful_preservesZeroMorphisms}` (chapter: `lem:isZero_of_faithful_preservesZeroMorphisms`)
- **Lean target exists**: yes — but in `CechAugmentedResolution.lean` (namespace `AlgebraicGeometry`), NOT in `OpenImmersionPushforward.lean`
- **Signature matches**: yes (for the CechAugmentedResolution copy)
- **Proof follows sketch**: yes (both copies use the same 3-line proof)
- **notes**: `OpenImmersionPushforward.lean` contains a **copy** of this lemma at line 42 under a different FQ name: `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms`. The copy exists because `CechAugmentedResolution.lean` is not in the import chain. The blueprint's `\lean{}` pin points only to the CechAugmentedResolution version; the OpenImmersionPushforward copy is unreferenced. Duplicate reported under Unreferenced Declarations.

### `\lean{AlgebraicGeometry.isZero_presheafToSheaf_of_locally_isZero}` (chapter: `lem:isZero_presheafToSheaf_of_locally_isZero`)
- **Lean target exists**: yes — in `CechAugmentedResolution.lean`
- **Signature matches**: yes (for the CechAugmentedResolution version)
- **Proof follows sketch**: yes (for the CechAugmentedResolution version)
- **notes**: `OpenImmersionPushforward.lean` introduces a DIFFERENT, stronger lemma `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero` (line 71). The blueprint describes the weaker `of_locally_isZero` as sufficient for the open-immersion acyclicity argument (Bridge 3), but the actual proof needed the stronger `of_sections_locally_zero`. The stronger lemma has no `\lean{}` blueprint entry — see Blueprint Adequacy.

---

## Red flags

### Placeholder / suspect bodies
- `higherDirectImage_openImmersion_acyclic` at line 179: body has a `sorry` at line 224.
  - **NOT a disqualifying placeholder**: the reduction is complete and faithful to the blueprint; the sorry is the genuine leaf "IsZero (((pushforwardSectionsFunctor j W).rightDerived q).obj H)" for affine W, q > 0, which is precisely the Serre-vanishing leaf the blueprint identifies in Bridge (2). Acceptable for this iter.
- `higherDirectImage_openImmersion_comp` at line 266: body is entirely `sorry`.
  - **NOT a disqualifying placeholder**: the structural plan comment (lines 273–289) accurately records what's needed and matches the blueprint's acyclic-resolution scheme. Acceptable for this iter; depends on `_acyclic` residual.

### Excuse-comments
None. The `sorry` comment blocks are clear proof plans, not excuses for wrong code.

### Axioms / Classical.choice
None found.

---

## Unreferenced declarations (informational)

| Declaration | Line | Nature | Blueprint reference? |
|---|---|---|---|
| `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms` | 42 | Duplicate of `AlgebraicGeometry.isZero_of_faithful_preservesZeroMorphisms` (CechAugmentedResolution); copied due to import graph | No `\lean{}` block; the blueprint's `lem:isZero_of_faithful_preservesZeroMorphisms` points to the other copy |
| `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero` | 71 | Stronger sectionwise variant of `of_locally_isZero`; substantive new lemma actually consumed by `_acyclic` | No `\lean{}` block; needs one |
| `pushforwardSectionsFunctor` | 150 | Named composite `U.Modules ⥤ AddCommGrpCat`; introduced to give a named target for `rightDerived` in the proof | No `\lean{}` block; used internally by `_acyclic` |
| `pushforwardSectionsFunctor_additive` | 157 | Explicit `Additive` instance for `pushforwardSectionsFunctor`; needed because 5-fold composite defeats `inferInstance` | No `\lean{}` block; pure implementation detail, but worth noting |
| `isAffineHom_of_affine_separated` | 137 | Private helper; has a broken `\lean{}` pin (see Per-declaration) | Broken pin |

---

## Blueprint adequacy for this file

- **Coverage**: 3/5 substantive Lean declarations have a corresponding `\lean{}` block (`_comp`, `_acyclic` directly; `isAffineHom_of_affine_separated` via a broken pin). 2 substantive declarations (`isZero_presheafToSheaf_of_sections_locally_zero`, `isZero_of_faithful_preservesZeroMorphisms` copy) have no `\lean{}` entry. 2 helper/instance declarations (`pushforwardSectionsFunctor`, `pushforwardSectionsFunctor_additive`) also lack coverage.

- **Proof-sketch depth**: **under-specified** for one specific step.
  - Bridges (1) and (2) of the proof sketch are clear and faithfully realized in the Lean proof.
  - **Bridge (3) misdirects**: the blueprint (proof block and `\uses{}` at line 7643) says to use `lem:isZero_presheafToSheaf_of_locally_isZero` (the *objectwise* variant: "Q.obj (op V) = 0 for every member V of a covering sieve"). The actual Lean proof discovered that the objectwise condition cannot be satisfied with affine-opens-sieve arithmetic (affine opens are not downward-closed in the opens topology, so a single covering sieve of affines does not supply a downward-closed family on which Q is objectwise zero). The prover introduced the stronger *sectionwise* lemma `isZero_presheafToSheaf_of_sections_locally_zero` (section s restricts to 0 on some covering sieve, without needing Q(V) = 0 globally on V). The blueprint sketch did not describe this distinction; a prover following the sketch alone would have hit a real obstacle not explained in the text.
  - This `\uses{}` misdirection is the primary adequacy gap.

- **`pushforwardSectionsFunctor` not mentioned**: the need to introduce a named 5-fold composite (to overcome `inferInstance` failing for the composite's `Additive` typeclass) is not described in the blueprint. This is a non-trivial Lean formalization issue entirely absent from the proof sketch. The blueprint should at minimum acknowledge that the section functor `M ↦ Γ(W, j_*M)` needs to be named and its additivity established separately.

- **Hint precision**: **loose** for `isAffineHom_of_affine_separated`. The `\lean{}` hint points to a private declaration, which will never resolve correctly.

- **Generality**: matches need for the two main theorems.

- **Recommended chapter-side actions**:
  1. **Fix broken `\lean{}` pin**: change `AlgebraicGeometry.isAffineHom_of_affine_separated` to either remove it (since the helper is private) or make the declaration non-private and keep the pin.
  2. **Add `\lean{}` block for `isZero_presheafToSheaf_of_sections_locally_zero`**: add a new lemma block `lem:isZero_presheafToSheaf_of_sections_locally_zero` with `\lean{CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero}` and explain the sectionwise strengthening.
  3. **Correct Bridge (3)**: update the `lem:open_immersion_pushforward_comp` proof sketch Bridge (3) and `\uses{}` to reference the new sectionwise lemma instead of (or in addition to) `lem:isZero_presheafToSheaf_of_locally_isZero`; explain why the objectwise form is not sufficient.
  4. **Add coverage for `pushforwardSectionsFunctor`**: add a brief blueprint note or `\lean{}` block acknowledging the named section functor and its explicit additivity construction.
  5. **Add `\lean{}` block for `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms` copy**: or note the duplication and reference the CechAugmentedResolution copy as the canonical one, with a `% NOTE:` comment explaining the import-graph reason for the copy.

---

## Severity summary

| Finding | Severity |
|---|---|
| `isAffineHom_of_affine_separated` is `private` but blueprint's `\lean{}` pin expects a public name — pin is broken | **major** |
| `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms` (unreferenced duplicate) — substantive declaration, blueprint should reference it | **major** |
| `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero` — substantive new lemma, no `\lean{}` block; blueprint's Bridge (3) proof sketch misdirected toward `of_locally_isZero` | **major** |
| `pushforwardSectionsFunctor` / `pushforwardSectionsFunctor_additive` — helpers with no blueprint coverage; the 5-fold composite Additive problem is undocumented | **minor** |
| `_acyclic` and `_comp` have expected sorries matching blueprint's current state | informational |

**Overall verdict**: The two main theorem signatures match the blueprint faithfully (including the D2 re-signing of `_comp` to canonical `≅`), and the `_acyclic` reduction is wired to the correct leaf; the file is on-track. Three major gaps require blueprint-side attention before the next formalization pass: the broken `private` pin for `isAffineHom_of_affine_separated`, missing coverage for the new `isZero_presheafToSheaf_of_sections_locally_zero` lemma, and the stale Bridge (3) sketch that misdirects toward the weaker objectwise site lemma.

— 5 declarations checked, 3 major gaps (all blueprint-side), 0 must-fix-this-iter
