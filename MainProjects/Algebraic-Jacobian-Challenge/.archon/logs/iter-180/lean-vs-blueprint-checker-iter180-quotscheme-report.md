# Lean ↔ Blueprint Check Report

## Slug
iter180-quotscheme

## Iteration
180

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean` (583 LOC, 7 `sorry`)
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex` (910 LOC)

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (chapter: `def:hilbert_polynomial`)
- **Lean target exists**: yes — `hilbertPolynomial` at L170.
- **Signature matches**: yes (mod docstring caveat). Returns `Polynomial ℚ` keyed by `s : S`, with `[IsLocallyNoetherian S]`, `[LocallyOfFiniteType _π]` plus underscored `_L _F : X.Modules`. Matches the blueprint's "Hilbert polynomial of `F` at `s` relative to `L`" framing.
- **Proof follows sketch**: N/A — definitional, body `:= sorry` (file-skeleton).
- **notes**: Status documented in the file-header as iter-176 file-skeleton; iter-177+ body. Body absence is openly acknowledged on both sides.

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (chapter: `def:quot_functor`)
- **Lean target exists**: yes — `QuotFunctor` at L208.
- **Signature matches**: yes. Returns `(Over S)ᵒᵖ ⥤ Type u`, with the expected typeclass / line-bundle / coherent-sheaf / Hilbert-polynomial arguments.
- **Proof follows sketch**: N/A — body `:= sorry` (file-skeleton).
- **notes**: Per-fiber Hilbert polynomial condition and the `ker(q)=ker(q')` quotient are described in the docstring at the level the blueprint specifies (no quotient-of-Setoid placeholder in the type yet).

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (chapter: `def:grassmannian_scheme`)
- **Lean target exists**: yes — `Grassmannian` at L245.
- **Signature matches**: yes. `Grassmannian (V : S.Modules) (d : ℕ) : (Over S)ᵒᵖ ⥤ Type u`.
- **Proof follows sketch**: N/A — body `:= sorry`.
- **notes**: Acceptable; the blueprint says "concretely `Grass(V,d) = Quot^{d,O_S}_{V/S/S}`" — the file-skeleton notes plan to re-export via `QuotFunctor` in iter-177+.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (chapter: `thm:grassmannian_representable`)
- **Lean target exists**: yes — `Grassmannian.representable` at L272.
- **Signature matches**: partial. The Lean signature packages only `∃ Y : Over S, Nonempty ((Grassmannian V d).RepresentableBy Y)`. The blueprint additionally pins (i) smooth, (ii) projective, (iii) relative dimension `d(r-d)`, (iv) tautological rank-`d` quotient, (v) Plücker closed embedding into `ℙ_S(⋀^d V)`. None of these enrichments are in the Lean type.
- **Proof follows sketch**: N/A — body `:= sorry`.
- **notes**: Acceptable as documented file-skeleton (the docstring calls out the smooth/Plücker enrichment as iter-177+ refinement). Same iter-176 file-skeleton status.

### `\lean{AlgebraicGeometry.Scheme.QuotScheme}` (chapter: `thm:quot_representable`)
- **Lean target exists**: yes — `QuotScheme` at L326.
- **Signature matches**: partial. The Lean uses `[LocallyOfFiniteType π] [IsProper π]` as a structural stand-in for "projective π" (acknowledged in the docstring; Mathlib has no `IsProjective` morphism predicate at the pinned commit). Conclusion is the bare existence + `RepresentableBy` witness; the blueprint statement additionally specifies (i) projectivity of `Q ⟶ S`, (ii) universal quotient `q^univ : π*_Q E ↠ F^univ` on `X ×_S Q`, (iii) constant Hilbert polynomial `Φ` on every fiber.
- **Proof follows sketch**: N/A — body `:= sorry`.
- **notes**: The weakening (`IsProper` standing in for projective) is documented and is the project-side workaround until Mathlib gains `IsProjective` for morphisms. Not a placeholder/excuse-comment; honest mathematical reduction.

### `\lean{AlgebraicGeometry.flatBaseChangeCohomology}` (chapter: `thm:flat_base_change_cohomology`)
- **Lean target exists**: yes — `flatBaseChangeCohomology` at L570.
- **Signature matches**: partial. Lean states the `i=0` form ("`(pullback g).obj ((pushforward f).obj F) ≅ (pushforward f').obj ((pullback g').obj F)`" on `Scheme.Modules`); the blueprint pins the full Stacks 02KH statement "**For every `i ≥ 0`**" plus the affine `H^i ⊗_A B = H^i(X', F')` form. The Lean only delivers part (ii) of the Stacks lemma at level `i=0`.
- **Proof follows sketch**: partial — the Lean now has a substantive proof body (no longer just `:= sorry`): it composes through five named helpers in a four-deep chain. The chapter has **no `\begin{proof}` block at all** for this theorem, so there is no chapter sketch to compare against.
- **notes**: This is the iter-180 Lane F deliverable. The substantive content is pushed into two private helpers — see the next section.

## Lane F (iter-180) — new substantive helpers

The directive asks specifically about the two new helpers introduced this iter. Neither has a `\lean{...}` pin.

### `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` (private, L446)
- **Type**: `IsIso (((canonicalBaseChangeMap sq).app F).app U)` under `[QuasiCompact f] [QuasiSeparated f] [Flat g]` plus `_hU : IsAffineOpen U`.
- **Body**: `sorry`, with a thorough intended-body comment that names Stacks 02KE / 00H8 (algebraic flat base change via `Module.Flat.isBaseChange`), enumerates four steps, and explicitly flags the project-side identification of `Scheme.Modules` sections with `Γ(S', U) ⊗_{Γ(S, V)} Γ(f⁻¹V, F)` as a Mathlib gap.

### `canonicalBaseChangeMap_app_app_isIso_of_affineCover` (private, L488)
- **Type**: from the affine-open case + `h_affine` quantifier to all opens `U` of `S'`.
- **Body**: `sorry`, with a thorough intended-body comment describing the Mayer-Vietoris descent (affine cover + sheaf-restriction equalizer + naturality of the base-change transformation), explicitly flagging the missing `Sheaf.Hom.isIso_iff_isIso_on_basis`-style helper as the second project-side Mathlib gap.

### `canonicalBaseChangeMap_app_app_isIso` (theorem, L538)
- **Body**: `:= canonicalBaseChangeMap_app_app_isIso_of_affineCover sq F (fun V hV => canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen sq F V hV) U` — clean composition, zero sorries in the body itself.

### `canonicalBaseChangeMap_isIso` (theorem, L561)
- **Body**: `Scheme.Modules.Hom.isIso_iff_isIso_app.mpr (fun U => canonicalBaseChangeMap_app_app_isIso sq F U)` — clean.

### `canonicalBaseChangeMap` (def, L409)
- **Body**: explicit `CategoryTheory.mateEquiv` of the `pullback ⊣ pushforward` adjunctions, composed with `pullbackComp` / `pullbackCongr` / `pullbackComp` along the cartesian square. Honest Beck–Chevalley construction; no `sorry`.

## Red flags

None.

- All 7 `sorry`s are typed against substantive (non-tautological) signatures that match the blueprint's intended mathematical content.
- No `:= True`, `:= rfl` on non-trivial claim, `:= Classical.choice _`, or axiom-introduction.
- No "TODO / placeholder / wrong but works" excuse-comments; the iter-176/iter-180 status notes are honest workflow markers, not laundering of weakened content.
- The 5 file-skeleton sorries (1–5 above) are openly tagged as iter-176 file-skeleton bodies awaiting iter-177+ proof work.
- The 2 new sorries (Lane F helpers) are both substantive Mathlib-gap-carrying private helpers, openly tagged in the docstring as needing the affine-tensor-product identification (gap A) and the sheaf-iso-on-basis (gap B) — exactly the two project-side bridges the chapter's §7 (Lean encoding) paragraph already anticipates.

## Unreferenced declarations (informational)

Five Lean declarations introduced this iter have no `\lean{...}` pin in the chapter:

| Lean declaration | Status |
|------------------|--------|
| `canonicalBaseChangeMap` (def, L409) | substantive Beck–Chevalley def, should be a blueprint block `def:canonical_base_change_map` |
| `canonicalBaseChangeMap_isIso` (theorem, L561) | substantive iso claim, should be a blueprint block `lem:canonical_base_change_iso` (the natural-transformation-form Stacks 02KH(ii)) |
| `canonicalBaseChangeMap_app_app_isIso` (theorem, L538) | substantive section-form iso claim; the iso-iff-iso-app reduction is a helper, could be inlined or its own blueprint helper-lemma |
| `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` (private theorem, L446) | substantive affine-case of Stacks 00H8 / 02KE — should be a blueprint block `lem:flat_base_change_affine` |
| `canonicalBaseChangeMap_app_app_isIso_of_affineCover` (private theorem, L488) | substantive Mayer-Vietoris descent — should be a blueprint block `lem:flat_base_change_mv_descent` (or `lem:sheaf_iso_on_affine_basis`) |

These are all substantive helpers carrying the actual proof content of `thm:flat_base_change_cohomology`. The chapter does **not** anticipate this decomposition.

## Blueprint adequacy for this file

- **Coverage**: 6/11 substantive Lean declarations have a corresponding `\lean{...}` block. Unreferenced: 5 substantive helpers (Lane F iter-180), 0 trivial.
- **Proof-sketch depth**: under-specified for `thm:flat_base_change_cohomology` and silent on the affine-then-MV decomposition. Adequate for `thm:grassmannian_representable` and `thm:quot_representable` (the chapter prose gives detailed multi-step proofs); adequate for `lem:quot_boundedness` / `lem:quot_alpha_injective` / `lem:quot_valuative_criterion` / `lem:quot_reduction_to_pi_star_W` (each has a `\begin{proof}` body). Critical gap: `thm:flat_base_change_cohomology` carries **no `\begin{proof}` block at all**, and Section §7 ("Cohomology and base change", L851–856) limits itself to one sentence ("Mathlib carries a partial form ... the full `R^i f_*` statement is a project-side bridge if not present at the pinned commit"). The Lean encoding ended up requiring a four-deep helper chain (`canonicalBaseChangeMap` def + section-form helper + affine-open case + MV descent + assembled iso) that the chapter does not preview.
- **Hint precision**: precise where pins exist. The 6 existing `\lean{...}` hints are well-targeted. The gap is *missing pins* (the 5 new Lane F helpers), not *wrong* ones.
- **Generality**: matches need for the 6 pinned declarations. For `thm:flat_base_change_cohomology` the blueprint pins the **full Stacks 02KH** ("for every `i ≥ 0`") while the Lean delivers only `i=0`. This is openly documented in the Lean docstring as a Mathlib-gap restriction (no `R^i f_*` infrastructure at the pinned commit), and the chapter's §7 paragraph acknowledges this — but the `\lean{...}` pin should ideally be either (a) refined to point at an explicit `i=0` Lean variant with a `\lean{...}` pin on a separate `flatBaseChangeCohomology_i0` block, or (b) split into a `flatBaseChangeCohomology_i0` (shipped) + `flatBaseChangeCohomology_Rfstar` (deferred) pair so the `\leanok` markers don't over-claim.
- **Recommended chapter-side actions**:
  1. Add a `\begin{proof}` block to `thm:flat_base_change_cohomology` outlining the standard reduction: (i) construct the canonical Beck–Chevalley natural transformation via the mate of the `pullback ⊣ pushforward` adjunction, (ii) reduce iso-on-sheaves to iso-on-sections over a basis of opens, (iii) prove iso on affine opens via algebraic `Module.Flat.isBaseChange` (Stacks 00H8 / 02KE), (iv) descend along an affine cover via Mayer-Vietoris using `QuasiSeparated f`.
  2. Add blueprint blocks for the four new substantive Lane F helpers:
     - `def:canonical_base_change_map` → `\lean{AlgebraicGeometry.canonicalBaseChangeMap}`
     - `lem:flat_base_change_affine` → `\lean{AlgebraicGeometry.canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen}` (the affine case, Stacks 00H8 / 02KE)
     - `lem:flat_base_change_mv_descent` → `\lean{AlgebraicGeometry.canonicalBaseChangeMap_app_app_isIso_of_affineCover}` (the MV descent / "iso on affine basis ⟹ iso on opens" piece)
     - `lem:canonical_base_change_iso` → `\lean{AlgebraicGeometry.canonicalBaseChangeMap_isIso}` (the assembled natural-transformation-form iso)
  3. Add a project-side-bridges paragraph naming the two open mathematical gaps the helpers carry: (a) the affine identification of `Scheme.Modules.pullback`/`pushforward` sections with algebraic tensor products / pushforward modules, and (b) the sheaf-theoretic "iso on a basis of opens ⟹ iso" principle for a natural transformation of sheaves of `O_S`-modules. Both gaps belong in the chapter's "Out of scope" / project-side-bridges discussion in §7.
  4. Either refine the `\lean{thm:flat_base_change_cohomology}` pin's prose to explicitly the `i=0` form, or split into `i=0` (shipped) + `R^i f_*` (deferred) blocks so the deterministic `\leanok` sync doesn't paper over the `i ≥ 1` Mathlib gap.

## Severity summary

- **must-fix-this-iter**: none. The two new Lane F helpers are substantive private helpers with honestly-typed signatures and honestly-flagged Mathlib gaps. No placeholder bodies, no wrong-signature laundering, no excuse-comments, no unauthorized axioms.
- **major**:
  - Blueprint adequacy gap for `thm:flat_base_change_cohomology`: no `\begin{proof}` block, no preview of the affine-then-MV decomposition that the Lean file ended up needing. The chapter is significantly under-specified for the actual proof structure the iter-180 prover landed.
  - Missing `\lean{...}` pins for 5 substantive new helpers (Lane F): the affine case, the MV descent, the assembled natural-transformation iso, the section-form iso, and the Beck–Chevalley def. These are not stylistic helpers — they encode the substantive proof content of `thm:flat_base_change_cohomology`.
  - `flatBaseChangeCohomology` signature delivers `i=0` only while the chapter pin claims `i ≥ 0`; the project-side gap is documented, but a chapter-side adjustment (split pin or `i=0` qualifier) would prevent over-claiming.
- **minor**:
  - `Grassmannian.representable` and `QuotScheme` Lean signatures omit the smooth / projective / relative-dimension / tautological-quotient / Plücker enrichments that the blueprint prose pins. Documented as iter-177+ refinement; acceptable for the iter-176 file-skeleton stage but should be tightened when bodies land.

## Overall verdict

The 6 originally pinned declarations all exist with substantively-typed signatures (modulo documented file-skeleton sorries + the `IsProper`-for-projective and `i=0`-for-`R^i f_*` Mathlib-gap workarounds). The iter-180 Lane F split of `flatBaseChangeCohomology` into the affine-case + MV-descent helpers is mathematically sound and honestly typed — the body is real proof composition, not a placeholder, and the two new `sorry`s sit on substantive private helpers with thorough intended-body comments. The blueprint chapter is the weaker side of the pair: it does not preview the affine-then-MV decomposition of Stacks 02KH that the Lean file required, and the 5 new substantive helpers have no `\lean{...}` pins — a blueprint-writer follow-up should add `\begin{proof}` content and helper blocks so that the project-side bridges (affine `Scheme.Modules` ↔ algebraic tensor products; sheaf-iso-on-basis) are visible chapter-side rather than buried in Lean docstrings.

`iter180-quotscheme: clean Lean, under-specified chapter — 6 declarations checked (+5 new unreferenced helpers), 0 red flags`
