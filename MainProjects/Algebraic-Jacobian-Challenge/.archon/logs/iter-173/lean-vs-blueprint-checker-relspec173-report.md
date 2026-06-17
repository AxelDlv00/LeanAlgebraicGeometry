# Lean ↔ Blueprint Check Report

## Slug
relspec173

## Iteration
173

## Files audited
- Lean: `AlgebraicJacobian/Picard/RelativeSpec.lean` (260 LOC, NEW this iter)
- Blueprint: `blueprint/src/chapters/Picard_RelativeSpec.tex` (458 LOC)

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.QcohAlgebra}` (chapter: `def:qc_sheaf_of_algebras`)
- **Lean target exists**: yes — `Scheme.QcohAlgebra` at L98.
- **Signature matches**: partial — declared as `Type (u+1) := sorry`. The blueprint says "a sheaf of $\mathcal{O}_X$-algebras whose underlying $\mathcal{O}_X$-module is quasi-coherent, with category $\mathrm{QcohAlg}(X)$". The Lean encodes only the carrier type; the category/Hom-set structure that the blueprint references in `def:qc_sheaf_of_algebras` and consumes in `thm:relative_spec_univ` / `thm:relative_spec_functorial` is absent.
- **Proof follows sketch**: N/A — definition, body is a typed `sorry` at the type level.
- **notes**: type-level `sorry` is an unusual but legal pattern — it makes the dependent declarations vacuously inhabited only at the type-checking level (no instance can be constructed until iter-174+ supplies a real structure). The docstring (L87-97) transparently describes the iter-174+ refinement plan as a `structure` of `Modules + Mon_Class + commutativity`. No excuse-comment phrasing. Acceptable iter-173 scaffold.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec}` (chapter: `thm:relative_spec_exists`)
- **Lean target exists**: yes — `Scheme.RelativeSpec` at L123.
- **Signature matches**: partial — signature `{X : Scheme.{u}} (𝒜 : X.QcohAlgebra) : Scheme.{u}` captures the existence of the scheme. The chapter's existence statement *also* asserts the structure morphism `π : Spec_X(A) → X` is affine, plus the per-affine-open isomorphism `i_U` and the cocycle property. Lean captures only the underlying-scheme part of the structured existence statement; the affine structure morphism is hoisted to a separate auxiliary declaration `RelativeSpec.structureMorphism` (L134, not pinned by the chapter — see "Unreferenced declarations").
- **Proof follows sketch**: N/A — body is `sorry`. The docstring (L116-122) sketches the iter-174+ `Scheme.GlueData` construction that matches the chapter proof's gluing+cocycle plan (L125-138 in chapter).
- **notes**: the structured `(scheme, π, {i_U}, cocycle)` tuple from Stacks 01LQ is split across two Lean declarations (this `def` + `structureMorphism`). Pragmatic but worth a blueprint pin upgrade — see blueprint-adequacy section.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty}` (chapter: `thm:relative_spec_univ`)
- **Lean target exists**: yes — `Scheme.RelativeSpec.UniversalProperty` at L169.
- **Signature matches**: **no** — the chapter prose pins the full Yoneda-style natural bijection
  `Hom_X(T, Spec_X(𝒜)) ≅ Hom_{O_X-alg}(𝒜, g_* O_T)`
  (the *representability* of the functor `F`). The Lean encodes only the affine-morphism consequence `IsAffineHom (structureMorphism 𝒜)`. The two statements are not equivalent: affineness of `π` is a structural *necessary condition* of being the relative spectrum, but does NOT singled-out `Spec_X(𝒜)` among all affine `X`-schemes (e.g. any other affine `X`-scheme also satisfies `IsAffineHom π`). The substantive content of "represents the functor F" is dropped.
- **Proof follows sketch**: N/A — body is `sorry`. The chapter's proof sketch (Zariski-sheaf + cover by affine subfunctors + base-change identification) is a proof of representability, not of affineness — so the chapter's sketch is not even the right proof for the current Lean type.
- **notes**: the prover explicitly acknowledges the gap (L155-167 docstring + module-preamble L40-50) and schedules an iter-174+ refinement to `CategoryTheory.Functor.RepresentableBy` once `QcohAlgebra` ships its Hom-set. This is a *signature-mismatch-by-scaffolding*: documented, not concealed, not a fake-proof of a substantive claim (body is `sorry`). Per directive Q2: flagging as major (not must-fix) because (i) the body is `sorry` so no false claim is being made about a substantive theorem proof, (ii) the iter-173 file-skeleton plan explicitly schedules the type refinement, (iii) the docstring transparently describes the gap. Strict reading of "signature mismatch with blueprint prose" would put this in must-fix; respecting the directive's explicit "soft-finding" framing, classifying as major with a hard iter-174 must-refine recommendation. **The iter-174 prover MUST upgrade the type to capture the natural bijection (or to a `RepresentableBy` witness) before any consumer file relies on this theorem.**

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff}` (chapter: `thm:relative_spec_affine_base`)
- **Lean target exists**: yes — `Scheme.RelativeSpec.affine_base_iff` at L193.
- **Signature matches**: partial — chapter pins the canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X, 𝒜))` for affine `X`; Lean encodes the weaker existential `IsAffine ((Spec R).RelativeSpec 𝒜)`. The existence-of-iso → `IsAffine` direction is sound (if it's iso to a Spec it's affine), so the Lean is a strict structural consequence. Stronger encoding (`Nonempty (... ≅ Spec(Γ ...))`) is gated on `Γ : QcohAlgebra → CommRingCat`, which isn't available at iter-173.
- **Proof follows sketch**: N/A — body is `sorry`. The chapter sketch (representability via `(Spec A, f_univ, φ_univ)`) is a proof of the canonical iso, weaker version follows from it.
- **notes**: name `affine_base_iff` suggests an `iff` but the type is a one-shot proposition (no `↔`). Naming is mildly misleading; either rename to `isAffine_of_affineBase` or refine to the iff-with-Γ statement in iter-174.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.base_change}` (chapter: `thm:relative_spec_base_change`)
- **Lean target exists**: yes — `Scheme.RelativeSpec.base_change` at L223.
- **Signature matches**: partial — chapter pins the canonical iso
  `T ×_X Spec_X(𝒜) ≅ Spec_T(g^* 𝒜)` where `g^* 𝒜` is *the* (named) pullback algebra.
  Lean encodes this with an existential `∃ (𝒜' : T.QcohAlgebra), Nonempty (pullback g (structureMorphism 𝒜) ≅ T.RelativeSpec 𝒜')`. The `𝒜'` is bound but not *named* (no claim that `𝒜' = g^* 𝒜`), so the equation says "*there is some* `T`-algebra that pulls back correctly" — not "*the* pullback `g^* 𝒜` works". The non-canonical existential is weaker than the chapter prose. Acknowledged in docstring (L213-216): iter-174+ refines to a named `pullbackQcoh g 𝒜`.
- **Proof follows sketch**: N/A — body is `sorry`. Chapter sketch (universal-property + factorisation, Yoneda) is the standard route.
- **notes**: existential weakening + use of `Nonempty (... ≅ ...)` rather than producing a canonical iso is acceptable as scaffold but degrades downstream usability. Major (not must-fix) because (i) scaffold transition, (ii) docstring acknowledges and schedules upgrade.

### `\lean{AlgebraicGeometry.Scheme.RelativeSpec.functor}` (chapter: `thm:relative_spec_functorial`)
- **Lean target exists**: yes — `Scheme.RelativeSpec.functor` at L251.
- **Signature matches**: partial — chapter pins a *contravariant functor* `QcohAlg(X)^op ⥤ AffSch/X` (object + morphism action + functoriality witness). Lean encodes only the *object-level assignment* as a bare function `X.QcohAlgebra → Over X`, with morphism action and the `Functor` packaging deferred to iter-174+. The codomain is `Over X` instead of `AffSch/X` — the affine-subcategory refinement is also deferred. The chapter explicitly claims "the equivalence between QcohAlg^op and the full subcategory of affine X-schemes"; none of the equivalence content is present in the Lean type.
- **Proof follows sketch**: N/A — concrete body `fun 𝒜 => Over.mk (RelativeSpec.structureMorphism 𝒜)`. The body is honest: it builds an `Over X` from the structure morphism, propagating the sorry through `structureMorphism`. Body matches the chapter's "object level: π : Spec_X(𝒜) → X over X" description.
- **notes**: signature is strictly weaker than the chapter pin (function vs. functor; `Over X` vs. `AffSch/X`; no equivalence claim). Scaffold-acceptable, must be refined iter-174+. Body has zero sorries by virtue of using `structureMorphism` whose sorry it inherits.

## Red flags

### Placeholder / suspect bodies
- `Scheme.QcohAlgebra` at L98: `Type (u+1) := sorry`. Type-level sorry. Documented as iter-173 scaffold (L87-97); iter-174+ structure plan spelled out. Acceptable as a documented file-skeleton landing; flagging here for visibility.
- `Scheme.RelativeSpec` at L123: body `sorry`. Documented scaffold (L116-122). Acceptable iter-173.
- `Scheme.RelativeSpec.structureMorphism` at L134: body `sorry`. Documented scaffold (L126-133). Acceptable iter-173.
- `Scheme.RelativeSpec.UniversalProperty` at L169: body `by sorry`. *On the encoded type* (`IsAffineHom`) this is an honest scaffold sorry. But — see "Signature mismatch" below: the encoded type doesn't match the blueprint prose, so a future sorry-fill on this type does NOT discharge the chapter pin.
- `Scheme.RelativeSpec.affine_base_iff` at L193: body `by sorry`. Honest scaffold sorry against the (weakened) type.
- `Scheme.RelativeSpec.base_change` at L223: body `by sorry`. Honest scaffold sorry against the (existential-weakened) type.

No `:= True`, no `Iso.refl _`, no `Classical.choice _` patterns. Bodies are honest sorrys, not concealed-trivial bodies.

### Signature mismatches against blueprint prose
- `RelativeSpec.UniversalProperty` (L169): encoded as `IsAffineHom π`, blueprint pin is the natural bijection `Hom_X(T, Spec_X(𝒜)) ≅ Hom_{O_X-alg}(𝒜, g_* O_T)` (representability). The encoded type is a strict structural *consequence*, not the substantive content. Documented as deliberate scaffold; iter-174+ refinement scheduled.
- `RelativeSpec.affine_base_iff` (L193): encoded as `IsAffine` of the resulting scheme, blueprint pin is the canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X, 𝒜))`. Strict structural consequence, weaker than blueprint. Gated on iter-174+ `Γ` for `QcohAlgebra`.
- `RelativeSpec.base_change` (L223): encoded as existential `∃ 𝒜', Nonempty (... ≅ T.RelativeSpec 𝒜')`, blueprint pin is the canonical iso with *named* pullback `g^* 𝒜`. Existential weakening, gated on iter-174+ `pullbackQcoh`.
- `RelativeSpec.functor` (L251): encoded as bare function `QcohAlgebra → Over X`, blueprint pin is the contravariant *functor* `QcohAlg(X)^op ⥤ AffSch/X` with equivalence onto affine X-schemes. Strict structural projection.

### Excuse-comments
None. Docstrings use forward-looking workflow phrasing ("iter-174+: refine to ...") which transparently describes the scaffold transition — not the wrong-code-excuse antipattern. None of the comments say "wrong but works for now" or "TODO replace with real def" against a declaration claimed to be real; they explicitly mark each declaration as scaffold.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations. No `Classical.choice _` patterns.

## Unreferenced declarations (informational)

- `AlgebraicGeometry.Scheme.RelativeSpec.structureMorphism` (L134) — NEW helper, no `\lean{...}` pin. *Justified addition*: the universal-property, base-change, and functor declarations all need to reference the structure morphism `π`, and the existing pin `thm:relative_spec_exists` packages `(scheme, π)` together without a separately-pinnable name. The helper is the right Lean ergonomic split. Per directive Q3, this is a clean addition. **Recommendation**: the blueprint should add a `\lean{AlgebraicGeometry.Scheme.RelativeSpec.structureMorphism}` pin to a sub-statement of `thm:relative_spec_exists` (or break out a tiny `def:relative_spec_structureMorphism` block) so the pin coverage is complete.

## Blueprint adequacy for this file

- **Coverage**: 6/7 Lean declarations pinned (`QcohAlgebra`, `RelativeSpec`, `UniversalProperty`, `affine_base_iff`, `base_change`, `functor` are pinned; `structureMorphism` is not). 1 unreferenced declaration, justified as helper (see above) but worth promoting to a pin. Coverage is *adequate-with-one-gap*.
- **Proof-sketch depth**: **adequate**. The chapter provides full Stacks-aligned proof sketches for each theorem (relative spec construction via `Scheme.GlueData`, universal property via Zariski-sheaf + affine subfunctor cover, affine-base case via `(Spec A, f_univ, φ_univ)`, base change via universal property + factorisation, functoriality via universal property + naturality). Source quotes are present for definition + four theorems. **One adequacy gap**: the `thm:relative_spec_univ` proof block (L189-194) has a `% SOURCE QUOTE PROOF: TODO retrieve from references/stacks-constructions.tex` placeholder — verbatim Stacks proof quote is missing (the proof sketch in the body is present and adequate; only the source-quote comment is unfilled). Per directive Q4: this is **NOT a hard gate for further work on the Lean file** at iter-173, because the iter-173 prover's Lean body for `UniversalProperty` is `sorry` (no proof-content match needed) and the *type* refinement is the iter-174 dependency, not the proof-prose. It WILL gate iter-174+ proof-body work, where the prover will need the Stacks verbatim to align tactics. **Recommendation**: blueprint-writer should fetch the L553-L600 verbatim quote in iter-174 before any prover starts on the `UniversalProperty` body.
- **Hint precision**: **loose**. The pinned-Lean targets for `UniversalProperty`, `affine_base_iff`, `base_change`, and `functor` land on Lean declarations whose *types are strictly weaker* than the chapter prose pins. The chapter prose unambiguously pins the strong statements (Yoneda bijection, canonical iso with Γ, named pullback, full functor), but the `\lean{...}` hint provides only a name — there's no machine-checkable assertion that the hinted name carries the prose's type. The Lean file's scaffold-weakening is documented and intentional, but the blueprint provides no `% NOTE:` markers acknowledging the iter-173-vs-iter-174 type-gap. **Recommendation**: blueprint should add per-pin `% NOTE: iter-173 file-skeleton lands a weakened type X; iter-174+ refines to the type stated in the theorem prose.` comments on the four affected pins.
- **Generality**: **matches need**. The blueprint generality (full `QcohAlg(X)^op ⥤ AffSch/X` functor with equivalence claim) matches the downstream A.1.b / A.1.c needs. No too-narrow scoping detected. The Lean file's gap is a scaffold-staging issue, not a blueprint generality issue.
- **Recommended chapter-side actions**:
  - Add `% NOTE:` annotations on the four pins (`thm:relative_spec_univ`, `thm:relative_spec_affine_base`, `thm:relative_spec_base_change`, `thm:relative_spec_functorial`) flagging the iter-173 weakened-type encoding and the iter-174 refinement obligation.
  - Add a `\lean{AlgebraicGeometry.Scheme.RelativeSpec.structureMorphism}` pin to a sub-block of (or near) `thm:relative_spec_exists`, since the Lean file legitimately needs this as a separately-named declaration.
  - Backfill the missing verbatim Stacks proof quote on `thm:relative_spec_univ` (chapter L189) before iter-174 prover work on `UniversalProperty` body.

## Severity summary

- **must-fix-this-iter**: none. The signature mismatches are deliberately scaffolded with transparent docstrings + module preamble + iter-174 refinement plan, and all bodies are honest `sorry`s (no fake proofs against the weakened types). The file IS a documented file-skeleton landing as advertised. Calling the type-weakening must-fix this iter would require either (i) rejecting the iter-173 file-skeleton landing pattern outright, or (ii) demanding the type definition of `QcohAlgebra` be filled this iter (which is iter-174 work).
- **major**:
  - `UniversalProperty` type encoded as `IsAffineHom` rather than the chapter-pinned natural bijection (representability). Documented scaffold, but the iter-174 prover MUST upgrade the type before any consumer relies on this theorem. **Treat as hard precondition for iter-174 work on this declaration**.
  - `affine_base_iff` type encoded as `IsAffine` rather than the canonical iso with `Spec(Γ ...)`. Naming (`_iff`) is mildly misleading. iter-174 refinement obligation.
  - `base_change` type encoded as `∃ 𝒜', Nonempty (... ≅ ...)` rather than the canonical iso with the *named* pullback `g^* 𝒜`. iter-174 refinement obligation.
  - `functor` typed as bare function rather than `CategoryTheory.Functor`. iter-174 refinement obligation (Stacks 01LR has the morphism action + functoriality witnesses needed).
  - Blueprint adequacy: missing verbatim Stacks proof quote on `thm:relative_spec_univ` (chapter L189 TODO marker). NOT a gate for iter-173 (Lean body is `sorry`), IS a gate for iter-174 proof work.
- **minor**:
  - `structureMorphism` not pinned by the blueprint despite being substantive enough to deserve a pin.
  - Blueprint lacks `% NOTE:` annotations acknowledging the iter-173 weakened-type encoding on the four affected pins.
  - `affine_base_iff` name suggests an `iff` but the type is a one-shot proposition (no `↔`).

**Overall verdict**: iter-173 file-skeleton lands cleanly *as a file-skeleton* — pin coverage 6/7, signatures honestly weaker than the blueprint prose with documented iter-174+ refinement plan, no concealed-wrong bodies or excuse-comments; the four type-weakenings are major scaffold-transition obligations the iter-174 prover MUST discharge before downstream consumers (A.1.b/A.1.c) build on this file.
