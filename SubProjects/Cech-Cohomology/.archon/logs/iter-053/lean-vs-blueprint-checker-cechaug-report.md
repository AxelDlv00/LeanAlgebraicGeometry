# Lean ↔ Blueprint Check Report

## Slug
cechaug

## Iteration
053

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.cechAugmented_exact}` (chapter: `lem:cech_augmented_resolution`)
- **Lean target exists**: yes (line 141)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i)) [X.IsSeparated] (F : X.Modules) (hF : F.IsQuasicoherent) : ∀ p, IsZero ((cechAugmentedComplex 𝒰 F).homology p)`. Blueprint says "finite affine open cover with all intersections affine (separatedness), quasi-coherent F, every homology zero." Lean encodes separatedness as `[X.IsSeparated]` (standard) and affineness as `h𝒰`; faithful.
- **Proof follows sketch**: partial — Steps 1–2 and the sieve assembly (Step 3 outer) are closed axiom-clean; the `hSec` sub-goal (section-complex homotopy vanishing, Steps 3/4 prepend-i_fix) is a `sorry` at line 180.
- **notes**: The `sorry` is inside the proof body of `cechAugmented_exact`, not its top-level statement, so `\leanok` on the statement block (line 7179 of the TeX) is consistent with the marker vocabulary. Proof divergence from blueprint: the Lean handles the augmentation node (blueprint Step 4) **uniformly** via the same `∀ p` quantifier rather than as a separate case; this is mathematically correct but collapses Step 4 into the Step 3 sorry. The sorry comment correctly describes the intended fix: "prepending that fixed index i is a contracting homotopy d∘h + h∘d = id on the section complex (template CombinatorialCech.combHomotopy / the objectwise homotopy of FreePresheafComplex), so every homology object vanishes. F-agnostic, cover-agnostic." This description is PRECISELY the gap named by blueprint Steps 3/4; the proof has not diverged onto a different route.

### Helper: `isZero_of_faithful_preservesZeroMorphisms` (lines 52–59)
- **Blueprint `\lean{}` reference**: **none** — this helper is not pinned in any `\lean{...}` block.
- **Signature matches blueprint prose**: yes — blueprint Step 1 describes "a faithful additive functor reflects the property of an object being zero"; the Lean statement is the correct category-theoretic formalisation (faithful + PreservesZeroMorphisms ⟹ reflects IsZero).
- **Proof body**: complete, no sorry. Three lines: `rw [IsZero.iff_id_eq_zero] at h ⊢; apply F.map_injective; rw [F.map_id, F.map_zero]; exact h`. No smuggled assumptions.
- **notes**: Substantive helper directly used in the Step-1 tactic of `cechAugmented_exact`. Missing `\lean{}` entry is a blueprint adequacy gap (flagged below).

### Helper: `isZero_presheafToSheaf_of_locally_isZero` (lines 76–106)
- **Blueprint `\lean{}` reference**: **none** — the `lem:sheafify_kills_locally_zero` block (lines 7138–7175) pins the three raw Mathlib declarations (`isZero_presheafToSheaf_obj_of_W`, `isZero_presheafToSheaf_obj_of_W_isZero`, `isZero_presheafToSheaf_obj_of_isLocallyBijective`) but does NOT pin this project-local wrapper.
- **Signature matches blueprint prose**: yes — blueprint `lem:sheafify_kills_locally_zero` part (2) says "if P vanishes on a basis of the topology, its sheafification is the zero sheaf." The Lean statement reformulates this as "for every U there is a covering sieve all of whose arrows point to opens where Q is zero," which is the correct site-theoretic basis-vanishing condition.
- **Proof body**: complete, no sorry. It constructs the locally bijective map `0 : Q ⟶ Z` (Z = constant PUnit presheaf, which is zero) by establishing local injectivity from the hypothesised fibrewise IsZero and local surjectivity freely (target is zero), then appeals to `isZero_presheafToSheaf_obj_of_isLocallyBijective`. No smuggled assumptions; the hypotheses `[HasSheafify J AddCommGrpCat]` and `[J.WEqualsLocallyBijective AddCommGrpCat]` are correctly pushed to the caller as instance parameters.
- **notes**: Substantive wrapper that packages three Mathlib lemmas into the "locally zero" form consumed by `cechAugmented_exact`. Missing `\lean{}` entry is a blueprint adequacy gap (flagged below).

---

## Red flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.cechAugmented_exact` at line 180: proof body contains `:= sorry` inside the `hSec` sub-goal. Blueprint `lem:cech_augmented_resolution` claims a substantive proof of exactness. **This is a must-fix-this-iter finding** per severity rules. It is the explicitly-named residual (the section-complex homotopy vanishing), not a diverged or placeholder proof—but the sorry nonetheless blocks full closure of the theorem.

### Excuse-comments
*(none)* — the comment at line 163–179 is accurate documentation of the intended fix (not an excuse for wrong code).

### Axioms / Classical.choice
*(none found)* — no `axiom` declarations; `Classical.choice` does not appear in this file.

---

## Unreferenced declarations (informational)

Both helper declarations are unreferenced in the blueprint's `\lean{...}` blocks. Given the directive's note that "the prover flagged both as needing blueprint entries," these are informational here but cross-listed as blueprint adequacy gaps below.

| Declaration | Lines | Blueprint ref | Assessment |
|---|---|---|---|
| `isZero_of_faithful_preservesZeroMorphisms` | 52–59 | none | Substantive — should be pinned (Step 1 of proof) |
| `isZero_presheafToSheaf_of_locally_isZero` | 76–106 | none | Substantive — should be pinned (Step 3 wrapper) |

The strategy comment block at lines 108–128 is not a declaration and needs no blueprint entry.

---

## Blueprint adequacy for this file

**Coverage**: 1/1 primary declaration (`cechAugmented_exact`) has a `\lean{}` block (line 7182). The 2 helper declarations are uncovered: both are substantive (directly used by the pinned theorem), not implementation-internal helpers.

**Proof-sketch depth**: **under-specified** for the sorry gap. Blueprint Steps 1–2 are precisely described and gave the prover the correct route (toSheaf reflection, homologyIsoSheafify + sheafification square). Steps 3/4 sketch the prepend-i_fix contracting homotopy conceptually and reference `combHomotopy`/`combHomotopy_spec` of `lem:cech_free_eval_prepend_homotopy`, but do **not** specify the Lean bridge from the `FreePresheafComplex` homotopy to the actual `cechAugmentedComplex 𝒰 F` sections. Specifically:
  - The blueprint says the argument is "cover-agnostic and coefficient-agnostic" and references `cechFreeEval_quasiIso_of_nonempty` / `combHomotopy_spec` as the template.
  - What a prover needs to close the sorry: (a) a map from sections of `cechAugmentedComplex 𝒰 F` over V to the free-eval complex of the restricted cover, (b) compatibility of that map with the `FreePresheafComplex` homotopy, (c) transport of `IsZero` across this comparison. The blueprint does not name the Lean mechanism for (a)–(c).

**Hint precision**: **loose** for Steps 3/4. The `\lean{}` pin on `lem:cech_augmented_resolution` correctly names `cechAugmented_exact`, but the proof sketch does not name the Lean declarations needed to instantiate the `combHomotopy` template at the F-section level (e.g. the comparison morphism between `cechAugmentedComplex` sections and the `FreePresheafComplex`, whatever its name turns out to be).

**Generality**: matches need — the helpers are at the right level of generality (universe-polymorphic, site-parameterised).

**Recommended chapter-side actions** (for a blueprint-writing subagent):

1. **Add `\lean{AlgebraicGeometry.isZero_of_faithful_preservesZeroMorphisms}`** (with a `\uses` back-reference) to a new `\begin{lemma}...\end{lemma}` block covering the faithful-functor-reflects-IsZero step. The block can be brief; the proof is 3 lines and the statement is pure category theory.

2. **Add `\lean{AlgebraicGeometry.isZero_presheafToSheaf_of_locally_isZero}`** to a new or expanded block within the `lem:sheafify_kills_locally_zero` family, or as its own auxiliary lemma, noting that it wraps `isZero_presheafToSheaf_obj_of_isLocallyBijective` into the "covering sieve of zero-fibre opens" form.

3. **Expand Step 3 of the `lem:cech_augmented_resolution` proof sketch** to specify the Lean route from `cechAugmentedComplex 𝒰 F` sections over V to the `FreePresheafComplex` / engine homotopy. Concretely the sketch should name (or describe the shape of) the comparison between `(cechAugmentedComplex 𝒰 F).X p V` and the free-eval form, so a prover knows which iso to transport the `combHomotopy` data through. The current text correctly identifies the homotopy strategy but leaves this transport step implicit.

---

## Severity summary

| Finding | Severity | Rule |
|---|---|---|
| `cechAugmented_exact` has `sorry` at line 180 (hSec section-complex homotopy) | **must-fix-this-iter** | Sorry on substantive claim |
| `isZero_of_faithful_preservesZeroMorphisms` lacks `\lean{}` blueprint entry | **major** | Substantive declaration uncovered |
| `isZero_presheafToSheaf_of_locally_isZero` lacks `\lean{}` blueprint entry | **major** | Substantive declaration uncovered |
| Blueprint Step 3/4 sketch under-specified (no Lean route for F-section bridge) | **major** | Chapter under-specified for this formalization step |
| Augmentation node (Step 4) handled uniformly rather than separately | **minor** | Proof-vs-sketch structural divergence, mathematically correct |

**Overall verdict**: The proof architecture is sound and faithful to the blueprint — the route (Steps 1–2 closed, Steps 3/4 correctly identified) has not diverged — but the residual `sorry` in `hSec` (line 180) is a must-fix blocker; the blueprint Step 3/4 sketch needs expansion to guide a prover closing it, and both new helper declarations need `\lean{}` entries.
