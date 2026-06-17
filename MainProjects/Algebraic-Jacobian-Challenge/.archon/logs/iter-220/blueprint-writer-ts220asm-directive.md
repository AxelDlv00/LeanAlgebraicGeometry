# Blueprint Writer Directive

## Slug
ts220asm

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Strategy context

This chapter blueprints the `Pic X` ⊗-group-law substrate (Route A). The active sub-build is
section `\label{sec:tensorobj_dual_infra}` — the construction of the Mathlib-absent **sheaf internal
hom of 𝒪_X-modules**, which supplies the ⊗-inverse `L⁻¹ = ℋom(L, 𝒪_X)` needed by the group law.
The build is decomposed into sub-steps; the FIRST sub-step (the per-object value module) is now
formalized in Lean, and the NEXT sub-step (restriction maps + full presheaf assembly) is the one a
prover will formalize next iter. The latest per-file blueprint review flagged the presheaf-assembly
step as **under-specified for formalization**: the existing `\begin{definition}` block
`def:presheaf_internal_hom` describes the value `ℋom(M,N)(U)` and mentions the restriction map only
in one prose sentence, with NO named intermediate target for the restriction map and no explicit
statement of the presheaf functoriality (identity/composition) the assembly requires. Your job is to
make that sub-step formalization-ready and to pin the already-built value module as a named
intermediate block, WITHOUT disturbing the later sub-steps (dual/evaluation/sheaf), which the review
judged adequate.

## Required content

All edits are WITHIN `sec:tensorobj_dual_infra` (the section starting at `\label{sec:tensorobj_dual_infra}`),
clustered around the existing `\begin{definition}...\label{def:presheaf_internal_hom}...\end{definition}`.

1. **New definition block — the value module (pin the built object).** Immediately BEFORE the existing
   `def:presheaf_internal_hom` block, add a `\begin{definition}` for the per-object value module:
   - `\label{def:presheaf_internal_hom_value}`
   - `\lean{PresheafOfModules.InternalHom.homModule}`
   - `\uses{def:scheme_modules_tensorobj}`
   - Content: For a presheaf of commutative rings `R` on a base category `C` that has a terminal
     object `T`, and `M, N ∈ PresheafOfModules R`, the morphism group `M ⟶ N` carries a canonical
     `R(T)`-module structure: a global scalar `f ∈ R(T)` acts on a morphism `φ : M ⟶ N` by `f • φ :=
     φ ≫ (multiplication-by-f)`, where multiplication-by-`f` is the endomorphism of `N` that on each
     open multiplies by the restriction of `f` to that open (the restriction along the unique map to
     the terminal). State that the module axioms hold because multiplication-by-`f` is a ring
     homomorphism `R(T) → End(N)` (sending `f·g` to the COMPOSITE of the two multiplications — note
     the order-reversal that post-composition forces) and composition is biadditive in a preadditive
     category. This is the genuinely-new core: Mathlib has the fixed-ring internal hom
     `ihom M N = (M ⟶ N)` but nothing for the *varying* structure presheaf at the
     `PresheafOfModules` level.
   - Add a short second paragraph defining its **slice specialisation**
     `\lean{PresheafOfModules.InternalHom.internalHomObjModule}` (you may pin it in the same block via
     a sentence, or — preferred — a tiny separate `\begin{definition}\label{def:presheaf_internal_hom_slice_value}\lean{PresheafOfModules.InternalHom.internalHomObjModule}\uses{def:presheaf_internal_hom_value}`):
     for an open/object `U` of `C`, restricting along `Over.forget U : Over U ⥤ C` (the open-immersion
     restriction `M ↦ M|_U`) makes `M|_U ⟶ N|_U` an `R(U)`-module, because `Over U` has terminal
     object `Over.mk(𝟙 U)` at which the restricted ring is `R(U)`. This `R(U)`-module
     `(M|_U ⟶ N|_U)` is exactly the value `ℋom(M,N)(U)` of `def:presheaf_internal_hom`.

2. **New lemma block — the restriction map (the under-specified next target).** Immediately AFTER the
   `def:presheaf_internal_hom` block (or right before it, your judgement on flow), add a
   `\begin{lemma}` (or `\begin{definition}` if you judge it a construction) for the presheaf
   restriction map:
   - `\label{lem:presheaf_internal_hom_restriction}`
   - `\lean{PresheafOfModules.InternalHom.restrictionMap}`
   - `\uses{def:presheaf_internal_hom_value, def:presheaf_internal_hom}`
   - Content: For a morphism `g : V ⟶ U` in `C` (i.e. an inclusion `V ⊆ U` of opens), there is a
     restriction map `ℋom(M,N)(U) → ℋom(M,N)(V)`, `φ ↦ φ|_V`, sending a morphism of restricted
     modules `M|_U ⟶ N|_U` to its further restriction `M|_V ⟶ N|_V`. Mathematically: `Over.map g :
     Over V ⥤ Over U` realises "restrict from `U` to `V`", and `φ|_V` is `φ` pulled back along it
     (the further restriction of the same morphism of sheaves of modules). State the **semilinearity**:
     this map is additive and is semilinear over the ring restriction `R(g) : R(U) → R(V)`, i.e.
     `(f • φ)|_V = R(g)(f) • (φ|_V)` for `f ∈ R(U)` — the compatibility `PresheafOfModules.ofPresheaf`/
     `mk` will require. Give a one-line proof sketch: further-restriction is functorial and commutes
     with the global-scalar action because restricting the scalar `f` to `V` is `R(g)(f)`.

3. **Expand the assembly prose in `def:presheaf_internal_hom`.** In the existing
   `def:presheaf_internal_hom` block, after the value-formula display, expand the single restriction
   sentence into an explicit statement that `ℋom(M,N)` is the presheaf of `R`-modules assembled from:
   (a) the per-object value modules `def:presheaf_internal_hom_value`/`_slice_value`; (b) the
   restriction maps `lem:presheaf_internal_hom_restriction`; (c) **functoriality** — identity
   restriction is the identity and restriction along a composite `V ⟶ U ⟶ W`... (state `g` then `h`
   composition) is the composite of restrictions, inherited from the functoriality of further
   restriction (`Over.map` is a functor). Add `\uses{lem:presheaf_internal_hom_restriction}` to the
   `def:presheaf_internal_hom` block's uses list. Keep the `\lean{PresheafOfModules.internalHom}` pin
   as the full assembled presheaf (the assembly target the next prover builds).

4. **Remove the stale planner `% NOTE (review iter-219): ...` comment** currently inside the
   `def:presheaf_internal_hom` block (the multi-line `% NOTE` asking the plan agent to add pins and
   expand the assembly step) — it is now actioned by edits 1–3, so delete that NOTE block. Do NOT
   remove the `% SOURCE`/`% SOURCE QUOTE`/`\textit{Source:}` citation lines.

## Out of scope
- Do NOT touch `def:presheaf_dual`, `lem:internal_hom_eval`, `lem:internal_hom_isSheaf`,
  `lem:dual_isLocallyTrivial`, `rem:dual_discharges_inverse`, `rem:dual_via_stack`, or anything
  outside `sec:tensorobj_dual_infra`. The review judged those adequate.
- Do NOT touch any other chapter, `content.tex`, `.lean` files, or markers (`\leanok`/`\mathlibok`).
- Do NOT add Lean tactic syntax. Mathematical prose + the named `\lean{}`/`\uses{}` pins only.

## References
- `references/stacks-modules.tex` — the "Modules on Ringed Spaces, §Internal Hom" section (tag area
  01CM) is already cited in this section for `def:presheaf_internal_hom`. The same source's statement
  that `U ↦ Hom_{O_X|_U}(F|_U, G|_U)` "is a sheaf of abelian groups" and "we in fact get a sheaf of
  𝒪_X-modules" backs the presheaf/restriction structure. If you add a `% SOURCE QUOTE` for the
  restriction-map block, quote verbatim from this local file (re-open it; do not cite from memory).
  A new verbatim quote is OPTIONAL here — the restriction map is the standard presheaf functoriality
  already implied by the existing 01CM quote; if you reuse the existing block's source pointer, ensure
  the quote you place is genuinely present in `references/stacks-modules.tex`.

## Expected outcome

`sec:tensorobj_dual_infra` gains two small named blocks pinning the already-built value module
(`def:presheaf_internal_hom_value` → `homModule`; the slice value → `internalHomObjModule`) and one
named block for the restriction map (`lem:presheaf_internal_hom_restriction` → `restrictionMap`),
and the `def:presheaf_internal_hom` block's prose now states the full presheaf assembly (value
modules + restriction maps + identity/composition functoriality + semilinearity compatibility)
explicitly, so a `mathlib-build` prover can formalize the restriction maps and the
`PresheafOfModules.internalHom` assembly without inferring the decomposition. The stale iter-219
`% NOTE` is removed. The later sub-steps are untouched.
