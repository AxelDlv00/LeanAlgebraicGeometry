# Lean ↔ Blueprint Check Report

## Slug
iter185-relativespec

## Iteration
185

## Files audited
- Lean: `AlgebraicJacobian/Picard/RelativeSpec.lean`
- Blueprint: `blueprint/src/chapters/Picard_RelativeSpec.tex`

---

## Compilation status

Lean LSP reports **0 errors, 0 warnings** for the file. Grep confirms **no `sorry` in proof bodies** — all occurrences of "sorry" in the file are in module-header docstrings or multi-iteration history prose, not in any declaration body. This confirms the iter-185 Lane D claimed result (sorries 2 → 0).

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.QcohAlgebra}` (chapter: `def:qc_sheaf_of_algebras`)
- **Lean target exists**: yes — `structure QcohAlgebra (X : Scheme.{u}) where` at line 143.
- **Signature matches**: partial. Blueprint prose says "a sheaf of O_X-algebras whose underlying O_X-module is quasi-coherent." Lean uses `NatTrans.Coequifibered` (strictly weaker than `SheafOfModules.IsQuasicoherent`). Equivalence holds under `AffineZariskiSite.sheafEquiv`; chapter NOTE at L62–78 documents this deliberate encoding choice.
- **Proof follows sketch**: N/A (structure definition, no proof body).
- **Notes**: The encoding deviation is intentional and documented. The three fields (`sheaf`, `unit`, `coequifibered`) are concrete Mathlib types. Chapter NOTE at L62–78 remains accurate and should stay.

---

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec}` (chapter: `thm:relative_spec_exists`)
- **Lean target exists**: yes — `noncomputable def RelativeSpec {X : Scheme.{u}} (𝒜 : X.QcohAlgebra) : Scheme.{u}` at line 192.
- **Signature matches**: yes — the declaration produces a `Scheme.{u}`, matching the blueprint's claim that such a scheme exists.
- **Proof follows sketch**: yes — body is `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued`, i.e., gluing of affine pieces `Spec(𝒜(U))` exactly as the blueprint sketches. Blueprint proof block has `\leanok`. Chapter NOTE at L61 ("supersedes iter-174 carrier note") is accurate documentation of the iter-179 upgrade to a real Mathlib value.
- **Notes**: No sorry. Body is real. Clean.

---

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty}` (chapter: `thm:relative_spec_univ`)
- **Lean target exists**: yes — `theorem UniversalProperty {X : Scheme.{u}} (𝒜 : X.QcohAlgebra) : IsAffineHom (RelativeSpec.structureMorphism 𝒜)` at line 264.
- **Signature matches**: partial. Blueprint states the full Yoneda-bijection `Hom_X(T, Spec_X(𝒜)) ≅ Hom_{O_X-alg}(𝒜, g_* O_T)`. Lean type is the strictly weaker structural consequence `IsAffineHom (structureMorphism 𝒜)`, which follows from representability (Stacks 01LQ) but does not encode it. Chapter NOTE at L162–170 acknowledges this and defers to iter-174+.
- **Proof follows sketch**: partial. Blueprint proof sketch describes the Zariski-sheaf / open-subfunctor representability argument. The Lean proof (lines 265–289) instead uses `isAffineHom_of_forall_exists_isAffineOpen` + `toBase_preimage_eq_opensRange_ι` + `isAffineOpen_opensRange` — a different (direct affineness) route that proves the weaker statement. The mathematical content is a valid consequence of the blueprint statement, not an unrelated argument.
- **Notes**: No sorry. Real proof. Chapter NOTE at L222–234 remains accurate (correctly describes the iter-179 Lane B proof route and flags the Yoneda deferral).

---

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff}` (chapter: `thm:relative_spec_affine_base`)
- **Lean target exists**: yes — `theorem affine_base_iff {R : CommRingCat.{u}} (𝒜 : (Spec R).QcohAlgebra) : IsAffine ((Spec R).RelativeSpec 𝒜)` at line 311.
- **Signature matches**: partial. Blueprint states the canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X, 𝒜))`. Lean type is the weaker `IsAffine ((Spec R).RelativeSpec 𝒜)`. Additionally the name `affine_base_iff` is misleading — there is no "iff" in the statement. Chapter NOTE at L253–258 acknowledges both deviations and defers to iter-174+.
- **Proof follows sketch**: the Lean proof (lines 317–318) uses `UniversalProperty 𝒜` + `isAffine_of_isAffineHom` — a simple 2-step chain. Blueprint proof sketch involves the full `Γ(X,𝒜)` identification and the universal family. Lean proves a weaker claim, so the proof is simpler but sound.
- **Notes**: No sorry. Chapter NOTE at L302–310 remains accurate (correctly describes the iter-179 Lane B proof closure).

---

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.base_change}` (chapter: `thm:relative_spec_base_change`)
- **Lean target exists**: yes — `theorem base_change {X T : Scheme.{u}} (g : T ⟶ X) (_𝒜 : X.QcohAlgebra) : ∃ (𝒜' : T.QcohAlgebra), Nonempty (pullback g (RelativeSpec.structureMorphism _𝒜) ≅ T.RelativeSpec 𝒜')` at line 679.
- **Signature matches**: partial (pre-known, directive flags as iter-186+ pending). Blueprint states a canonical iso `T ×_X Spec_X(𝒜) ≅ Spec_T(g^* 𝒜)` with a **named** pullback `g^* 𝒜`. Lean type is an existential `∃ 𝒜', Nonempty (iso)`. The body witnesses with `QcohAlgebra.pullback g _𝒜` and `pullback_iso g _𝒜` concretely, but the type does not pin the witness. Chapter NOTE at L338–342 acknowledges this.
- **Proof follows sketch**: partial. Lean proof (lines 679–683) is a one-line existential witness; blueprint proof sketch is the full Yoneda functor argument. Lean proves the weaker statement differently.
- **Notes**: No sorry. **The helper chain `pullback_cocone` / `pullback_iso_desc_isIso` / `pullback_iso_construction` is now fully closed (0 sorries) per iter-185 Lane D.** See "Red flags / Stale blueprint NOTE" below — this changes the validity of the chapter proof-block NOTE at L383–391.

---

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.functor}` (chapter: `thm:relative_spec_functorial`)
- **Lean target exists**: yes — `noncomputable def functor (X : Scheme.{u}) : X.QcohAlgebra → Over X := fun 𝒜 => Over.mk (RelativeSpec.structureMorphism 𝒜)` at line 707.
- **Signature matches**: partial. Blueprint states a contravariant categorical Functor `QcohAlg(X)^op → AffSch/X` with a morphism action induced by the universal property. Lean has a bare object-level function `X.QcohAlgebra → Over X` — no `map`, no functoriality laws, and the target is `Over X` (not `AffSch/X`). Chapter NOTE at L380–387 acknowledges this and defers to iter-174+.
- **Proof follows sketch**: N/A (definition; blueprint has a proof of functoriality which the Lean does not formalize yet).
- **Notes**: No sorry. Body is real (`Over.mk (structureMorphism 𝒜)`). However, the **Lean docstring is stale** — see "Red flags" below.

---

## Red flags

### Stale blueprint proof-block NOTE (major — review agent action required)

**Location**: blueprint chapter `Picard_RelativeSpec.tex`, proof block of `thm:relative_spec_base_change`, lines ~383–391.

The NOTE reads (paraphrased): "The iter-179 Lane B closes the existential by witnessing with named helpers … **both substantive but with `sorry` on Mathlib-gap content**: the `coequifibered` field of the pullback and the canonical iso body … Consumers should treat the iso witness as **load-bearing-pending until `pullback_iso`'s body lands**."

**This NOTE is now factually wrong.** Iter-185 Lane D closed both remaining sorries:
- `QcohAlgebra.pullback_coequifibered` (the `coequifibered` field, lines 358–377): real proof via `coequifibered_iff_forall_isLocalizationAway` + `isLocalization_of_eq_basicOpen`.
- `pullback_iso_desc_isIso` (the canonical iso body, lines 546–632): real proof via `IsZariskiLocalAtTarget`.

The file now has **0 sorries**. The NOTE's instruction to treat `pullback_iso` as "load-bearing-pending" is obsolete and should be updated or removed by the review agent.

---

### Stale Lean docstring (minor)

**Location**: `AlgebraicJacobian/Picard/RelativeSpec.lean`, docstring of `RelativeSpec.functor`, lines 700–706.

The docstring says: "the body is concrete via `Over.mk (RelativeSpec.structureMorphism 𝒜)` **but is left as `sorry` here** because `RelativeSpec.structureMorphism` is itself **a typed `sorry`**; once the structure morphism lands the body collapses to `fun 𝒜 => Over.mk (structureMorphism 𝒜)`."

Both claims are now stale:
1. `functor`'s body is NOT sorry — it is `fun 𝒜 => Over.mk (RelativeSpec.structureMorphism 𝒜)`.
2. `structureMorphism` is NOT a sorry — its body is `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).toBase`.

The "once the structure morphism lands the body collapses to …" text is describing the current state, not a future state. This is a minor stale docstring. It is not an excuse comment on wrong code (the code is correct), but it is misleading if read literally.

---

## Unreferenced declarations (informational)

The following Lean declarations in this file have no `\lean{...}` reference in the blueprint. All are helper infrastructure for `base_change`; none appear to be unintentional.

| Declaration | Line | Nature |
|---|---|---|
| `RelativeSpec.structureMorphism` | 208 | Semi-pinned (blueprint says "implicit in `thm:relative_spec_exists`"); would benefit from explicit `\lean{...}` hint |
| `QcohAlgebra.pullback_fst_isAffineHom` | 335 | Helper lemma |
| `QcohAlgebra.pullback_coequifibered` | 358 | Helper lemma (closes the `coequifibered` field) |
| `QcohAlgebra.pullback` | 390 | **Substantive def** — the pulled-back `O_T`-algebra `g^* 𝒜`; serves as the explicit witness in `base_change`. Should arguably have a blueprint block or at least a `\lean{...}` reference. |
| `RelativeSpec.pullback_iso_affine_piece` | 432 | Helper def |
| `RelativeSpec.pullback_cocone` | 471 | Helper def |
| `RelativeSpec.pullback_cocone_desc_comp_fst` | 506 | Helper lemma |
| `RelativeSpec.pullback_iso_desc_isIso` | 546 | Helper lemma |
| `RelativeSpec.pullback_iso_construction` | 643 | Helper def |
| `RelativeSpec.pullback_iso` | 665 | Helper theorem (the `Nonempty` iso witness) |

**Note**: `QcohAlgebra.pullback` is the most substantive unreferenced declaration — it is the concrete construction of the pulled-back algebra and is referenced by `base_change`'s body. Downstream consumers might need it by name. A `\lean{...}` hint in the blueprint for `base_change`'s proof block would help.

---

## Blueprint adequacy for this file

- **Coverage**: 6/16 Lean declarations have a `\lean{...}` block. Of the 10 unreferenced declarations, 9 are legitimate proof-infrastructure helpers; 1 (`QcohAlgebra.pullback`) is substantive enough to warrant a blueprint mention.
- **Proof-sketch depth**: **under-specified** for `base_change`. The blueprint proof sketch (Yoneda functor argument for the canonical iso) does not describe the actual proof route taken (colimit-cocone descent + `IsZariskiLocalAtTarget` affineness criterion). A reader using only the blueprint could not have arrived at the current proof structure. For the other five declarations, the sketches are acceptable given the iter-174+ deferred refinement plan.
- **Hint precision**: **precise** — all six `\lean{...}` hints name the correct Lean declarations.
- **Generality**: **matches need** — the constructions are at the right level of generality for the project.
- **Recommended chapter-side actions**:
  - **[Required]** Update or remove the stale proof-block NOTE at L383–391 of `thm:relative_spec_base_change` (says "sorry on Mathlib-gap content" / "load-bearing-pending" — both now false; iter-185 closed the sorries).
  - **[Optional]** Add a `\lean{...}` reference or prose mention for `QcohAlgebra.pullback` in the `base_change` proof block, since it is the explicit witness.
  - **[Optional]** Expand the `base_change` proof sketch to describe the colimit-cocone descent route actually used.
  - **[Not required now]** The statement-level NOTEs at L162, L253, L338, L380 documenting signature gaps remain accurate and should stay until iter-174+ closes the gaps.

---

## Severity summary

### Major (non-blocking for this iter but must be tracked)

1. **`UniversalProperty` signature drift** (pre-known): Lean type `IsAffineHom` vs. blueprint's full Yoneda-bijection. Chapter NOTE L162 tracks this; iter-174+ commitment.
2. **`affine_base_iff` signature drift** (pre-known): Lean type `IsAffine` vs. canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X,𝒜))`; misleading name. Chapter NOTE L253 tracks this; iter-174+ commitment.
3. **`base_change` signature drift** (pre-known, directive-confirmed): Lean type is existential vs. canonical iso with named `g^*𝒜`. Chapter NOTE L338 tracks this; iter-186+ commitment.
4. **`functor` signature drift** (pre-known): Lean is bare function `QcohAlgebra → Over X` vs. categorical `Functor (QcohAlgebra X)^op (AffSch/X)`. Chapter NOTE L380 tracks this; iter-174+ commitment.
5. **Stale blueprint proof-block NOTE at L383–391** (new finding): claims sorry on `pullback_iso` content that iter-185 has now closed. Review agent should update or remove this NOTE.

### Minor

6. **Stale Lean docstring on `functor`** (lines 700–706): says "left as sorry" and "structureMorphism is a typed sorry" — both false since iter-179. Misleading but code is correct.
7. **`QcohAlgebra.pullback` unreferenced** in blueprint despite being substantive enough to be cited.

---

**Overall verdict**: The file is sorry-free and axiom-clean (0 errors, 0 warnings, 0 sorry bodies) as of iter-185; all 6 blueprint-pinned declarations exist and compile. The 4 pre-known signature gaps (UniversalProperty, affine_base_iff, base_change, functor) remain open major findings deferred to iter-174+/186+; 1 stale chapter proof-block NOTE (L383–391, `base_change`) requires a review-agent update now that iter-185 closed the sorries it described as pending.
