# Blueprint Writer Directive

## Slug
ts-engine210b

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Why this corrective round
A prior round (ts-engine210) re-scoped `lem:tensorobj_assoc_iso` to ⊗-invertible
objects but built its proof by **local trivialization** (each object locally `𝒪`,
glue `Module.TensorProduct.assoc`). A focused Mathlib-alignment consult
(`analogies/ts-assoc-gate210.md`) has since shown that local-trivialization is a
**renamed wall**: gluing the local isos forces the comparison
`((M⊗N)⊗P).restrict W ≅ …`, which is exactly the sorry'd `tensorObj_restrict_iso`,
whose residual is absent from Mathlib and flatness-independent. (LSP-verified: even
`tensorObj_isLocallyTrivial` carries `sorryAx` because its proof calls that sorry.)
The associator must instead be built by the **flat-exactness whiskerLeft** route,
which IS buildable from present Mathlib. This round replaces the associator proof
method only (the statement — invertible `M,N,P` — stays).

## Required content

1. **Add a supporting bridge lemma** (new block, e.g. `\label{lem:flat_whisker_localizer}`,
   `\lean{AlgebraicGeometry.Scheme.Modules.W_whiskerLeft_of_flat}` or a name you judge
   matches the project's conventions): *for a flat presheaf-of-modules `F` and a
   morphism `g` in the sheafification localizer class `J.W`, the whiskered morphism
   `F ◁ g` is again in `J.W`.* Proof sketch (objectwise/local): `J.W` = locally
   bijective (`J.WEqualsLocallyBijective`); local injectivity of `F ◁ g` follows from
   flatness (`Module.Flat.lTensor_preserves_injective_linearMap`), local surjectivity
   from right-exactness of `⊗` (always). Note that an ⊗-invertible object is flat
   (`Module.Invertible` ⇒ `Projective` ⇒ `Flat`), so the flatness hypothesis is FREE
   for our invertible `M,N,P`.

2. **Rewrite the proof of `lem:tensorobj_assoc_iso`** (keep the statement: invertible
   `M,N,P`; `(M⊗N)⊗P ≅ M⊗(N⊗P)`) as the 3-step composite, where `a =
   PresheafOfModules.sheafification`, `η = toSheafify` (the sheafification unit, which
   lies in `J.W`), `α` = the presheaf associator (Mathlib `PresheafOfModules.monoidalCategory`):
   - `(M⊗N)⊗P = a( a(M.val ⊗ᵖ N.val).val ⊗ᵖ P.val )`
   - `≅` [apply `a` to `η ◁ P`, which is in `J.W` by the bridge lemma since `P` is flat]
     `a( (M.val ⊗ᵖ N.val) ⊗ᵖ P.val )`
   - `≅` [`a.mapIso α`, the sheafified presheaf associator]
     `a( M.val ⊗ᵖ (N.val ⊗ᵖ P.val) )`
   - `≅` [apply `a` to `M ▷ η`, in `J.W` by the bridge since `M` is flat]
     `a( M.val ⊗ᵖ a(N.val ⊗ᵖ P.val).val ) = M ⊗ (N⊗P)`.
   The only non-`mapIso` content is the bridge lemma of step 1; everything else is the
   presheaf monoidal data already in Mathlib. Emphasise: NO `MonoidalClosed`, NO
   `tensorObj_restrict_iso`, NO per-object local trivialization / gluing cocycle.
   The full reasoning + the exact Mathlib lemma names are in `analogies/ts-assoc-gate210.md`.

3. **Remove the local-trivialization prose** from the associator proof and from any
   block that now mis-describes it. Do NOT claim the associator is built by gluing local
   `𝒪⊗𝒪⊗𝒪=𝒪` trivializations.

4. **`uses{}` hygiene:** the associator block should `\uses{def:scheme_modules_tensorobj,
   def:scheme_modules_isinvertible}` and the new bridge lemma; the bridge lemma
   `\uses{def:scheme_modules_tensorobj}`.

## Out of scope
- Do NOT change the unitor / braiding lemmas (already the cheap `sheafification.mapIso`
  pattern; correct as-is).
- Do NOT change the statements of any lemma — only the associator's proof method and the
  new bridge lemma.
- Do NOT touch the off-path `tensorObj_restrict_iso` / `restrictscalars_laxmonoidal` blocks.
- Do NOT add `\leanok` / `\mathlibok` markers.

## References
- `analogies/ts-assoc-gate210.md` — the authoritative recipe (realization 2,
  flat-exactness whiskerLeft) with the exact present-Mathlib lemma names
  (`Module.Flat.lTensor_preserves_injective_linearMap`, `J.WEqualsLocallyBijective`,
  `GrothendieckTopology.instIsLocallyInjectiveToSheafify`, `Module.Flat.of_projective`).
- `references/stacks-modules.tex` (tags 01CS / 0B8K / 01CX) if a `% SOURCE QUOTE` is
  needed for the invertible-object statement.

## Expected outcome
`lem:tensorobj_assoc_iso` proved via the flat-exactness whiskerLeft 3-step composite
(realization 2), backed by a new flat-whiskering bridge lemma; no local-trivialization
prose, no `MonoidalClosed`, no dependence on `tensorObj_restrict_iso`. The chapter is
then dispatchable with a correct, present-Mathlib associator route.
