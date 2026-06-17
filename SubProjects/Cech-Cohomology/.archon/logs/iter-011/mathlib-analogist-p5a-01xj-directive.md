# Mathlib Analogist Directive — p5a-01xj

## Mode: api-alignment

## Question
For the P5a layer of the Čech↔higher-direct-image comparison, what is Mathlib's idiom (existing
API to reuse, or the construction path if absent), where does the proposed shape risk a parallel
API, and what is the cost of misalignment? The P5a layer is **independent of the P3/P3b presheaf
machinery** and we want its design locked now so it becomes a parallel prover lane next iter.

The declarations (all to-be-built; nothing shipped) and their blueprint blocks in
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`:
1. `lem:higher_direct_image_presheaf` / `\lean{AlgebraicGeometry.higherDirectImage_isSheafify_presheafCohomology}`
   (block `:1487`–`:1549`) — Stacks 01XJ: `Rⁱf_*F` is the sheafification of the presheaf
   `V ↦ Hⁱ(f⁻¹V, F|_{f⁻¹V})`.
2. `lem:cech_augmented_resolution` / `\lean{AlgebraicGeometry.cechAugmented_exact}` (block `:1433`)
   — the augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` (with `Cᵖ = ∏ (j_s)_*(F|_{U_s})`) is a
   resolution of `F`.
3. `lem:open_immersion_pushforward_comp` / `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}`
   (block `:1551`) — open immersions are `(·)_*`-acyclic and the derived composition
   `R(f∘jₛ)_* = Rf_* ∘ R(jₛ)_*` degenerates.
4. `lem:cech_term_pushforward_acyclic` / `\lean{AlgebraicGeometry.cechTerm_pushforward_acyclic}`
   (block `:1644`) — each Čech term `Cᵖ` is `(pushforward f)`-acyclic.

## Project artifact(s) to read
- `AlgebraicJacobian/Cohomology/HigherDirectImage.lean` — `higherDirectImage` def
  (`= (pushforward f).rightDerived i`, needs `[HasInjectiveResolutions X.Modules]`).
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` — `CechComplex`, `pushPullFunctor`,
  the nerve machinery; the relative term `Cᵖ`.
- The blocks listed above in the blueprint chapter.
- `references/stacks-cohomology.tex` Tag 01XJ (`lemma-describe-higher-direct-images`, L591) and
  the relative-cohomology application lemmas; `references/homological-acyclic-*.tex` for derived
  functors.

## Specific alignment questions (answer each)
1. **Sheaf cohomology on an open of `X.Modules`.** The 01XJ statement needs `Hⁱ(f⁻¹V, F|_{f⁻¹V})`
   — absolute sheaf cohomology of an `O_X`-module over an open subscheme. Does Mathlib have ANY
   usable `Hⁱ(open, F)` for `Scheme.Modules` / `SheafOfModules`? If not, what is the idiomatic
   surrogate — `((Γ(V,-)).rightDerived i).obj F`? `(global sections functor).rightDerived`?
   restriction `F|_{f⁻¹V}` then derived global sections? Name the exact Mathlib functors.
2. **`Rⁱf_* = sheafify(V ↦ Hⁱ(f⁻¹V))`.** Is there Mathlib API relating
   `(F.rightDerived i).obj` of a composite/sheaf-valued functor to the sheafification of a
   presheaf-valued cohomology? Anything like `Functor.rightDerived` commuting with evaluation /
   restriction, or a sheafification-of-derived comparison? Or must this be built from the
   objectwise-cokernel + sheafify description of homology in `S.Modules`?
3. **Derived composition / open-immersion acyclicity.** For `lem:open_immersion_pushforward_comp`:
   does Mathlib have a Grothendieck/Leray-style `R(g∘f)_* ` comparison, or
   `Functor.rightDerived` of a composite of functors (a Grothendieck spectral sequence /
   composition iso) for abelian categories? Is `(jₛ)_*` for an open immersion known exact /
   `rightDerived`-degenerate in Mathlib (open-immersion pushforward is exact)?
4. **Augmented-resolution exactness.** For `lem:cech_augmented_resolution`: is the stalkwise /
   sectionwise contractibility of the augmented Čech complex of SHEAVES expressible via existing
   Mathlib resolution/`QuasiIso` API, or built from scratch? Relation (if any) to the
   presheaf-level free-complex resolution being built in P3b.
5. **Parallel-API risks.** Flag any place the blueprint's proposed `\lean{}` name/shape would
   fork a notion Mathlib already provides (e.g. a bespoke sheaf-cohomology, a bespoke derived
   composition).

## Note
The `higher_direct_image_presheaf` proof block currently says the comparison is "developed as
part of the chapter's content" via "presheaf-level Čech δ-functor formalism over O_X-modules" —
but that δ-functor machinery has just been DROPPED from the strategy (it is unnecessary; see
`analogies/p3b-presheafcech.md`). So your recommendation should give a self-contained route for
(1)/(2) that does NOT rely on the presheaf δ-functor formalism.

## Output
Per-decision ALIGN / NEEDS_GAP_FILL verdicts with exact Mathlib names (verified via LSP), a
recommendation section, and a persistent `analogies/p5a-01xj.md`. This is exploration input for
next iter's blueprint-writer + scaffolder, not a directive to write code.
