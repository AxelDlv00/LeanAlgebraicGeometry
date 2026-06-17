# Blueprint-writer directive — iter-215 — refresh Picard_TensorObjSubstrate.tex

## Chapter to edit (ONLY this one)

`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Strategy context (the slice that matters)

The chapter blueprints the line-bundle ⊗-group law via **route (e)**: instantiate Mathlib's
`Localization.Monoidal.LocalizedMonoidal` on the already-monoidal presheaf category and the
sheafification localizer `J.W`; the sole new obligation is `(J.W).IsMonoidal`, whose load-bearing
field is `lem:islocallyinjective_whisker_of_W` (local injectivity of a whiskered localizer morphism,
proved stalkwise/flatness-free). The chapter's mathematical content is sound and route (e) is
correct — this is a TARGETED FRESHNESS PASS, not a rewrite. Do not change the route, the statements,
or any other chapter.

## Required edits (4 items, all flagged by the iter-214 lean-vs-blueprint-checker)

The prover landed, axiom-clean, the **d.1 linearity core** — four project-side declarations that
package the `R.stalk x`-linear stalk map of a `PresheafOfModules` morphism:
- `PresheafOfModules.stalkLinearMap` — the `R.stalk x`-linear stalk map of a morphism;
- `PresheafOfModules.stalkLinearMap_germ` — its germ characterisation;
- `PresheafOfModules.stalkLinearMap_bijective_of_isIso` — bijectivity from an Ab-stalk iso;
- `PresheafOfModules.stalkLinearEquivOfIsIso` — the bundled `≃ₗ[R.stalk x]` version.

1. **Correct the stale "no stalk infrastructure" paragraph.** In `\section`/`\paragraph`
   "The gap and route (e)" / API survey (around lines 245–264, where a `% NOTE:` from the review
   agent already flags it), the prose currently claims there is "no `PresheafOfModules`
   stalk/fiber/point infrastructure (only `Presheaf/ColimitFunctor`)". This is FACTUALLY WRONG as of
   the project's pinned Mathlib: `Mathlib/Algebra/Category/ModuleCat/Stalk.lean` (Andrew Yang, 2026)
   supplies, for `X : TopCat`, `R : X.Presheaf CommRingCat`, the stalk MODULE structure
   `Module (R.stalk x) (TopCat.Presheaf.stalk M.presheaf x)` and `germ_smul`. Rewrite the clause to
   say: the stalk module structure is present in Mathlib; what was Mathlib-absent is only the
   LINEARITY PACKAGING of the induced stalk map (now built project-side as the four declarations
   above), plus the two residual ingredients d.1-bridge and d.2 below. Remove the review `% NOTE:`
   once corrected (replace it with the corrected prose).

2. **Add a `\lean{...}`-pinned block for the d.1 core.** Add a short lemma/remark block (new label,
   e.g. `lem:stalk_linear_map`) under `sec:tensorobj_route_e`, with
   `\lean{PresheafOfModules.stalkLinearMap, PresheafOfModules.stalkLinearMap_germ, PresheafOfModules.stalkLinearMap_bijective_of_isIso, PresheafOfModules.stalkLinearEquivOfIsIso}`
   and `\uses{def:scheme_modules_tensorobj}`, describing them mathematically: the `R.stalk x`-linear
   map on stalks induced by a morphism of presheaves of modules, characterised on germs, bijective
   when the underlying Ab-stalk map is an iso, bundled as a linear equivalence. State that these are
   the **d.1-partial implementation** (the linearity half of ingredient d.1) consumed by the
   `id ⊗ g_x` step of `lem:islocallyinjective_whisker_of_W`.

3. **Split d.1 in the proof sketch of `lem:islocallyinjective_whisker_of_W`** (around lines
   802–816). The current sketch lists d.1 and d.2 both as "Mathlib-absent". Update to the true
   post-iter-214 picture:
   - **d.1-done**: the `R.stalk x`-linear stalk-map packaging (`stalkLinearMap` & co.) — built
     project-side, axiom-clean. Cite the new block from item 2.
   - **d.1-bridge (remaining)**: the site-`W` ⟺ stalkwise-iso characterisation on `Opens X` — that
     a morphism lies in `J.W` iff its stalk maps are isomorphisms at every point. Note the concrete
     Mathlib assembly route (the `WEqualsLocallyBijective` structure together with the topological
     stalk criteria — local-injectivity ⟺ injective-on-stalks and local-surjectivity ⟺
     surjective-on-stalks — bridging the site-level `Presheaf.IsLocallyInjective/Surjective` to the
     `TopCat.Presheaf` stalk versions).
   - **d.2 (remaining)**: the stalk ⊗ commutation `(F ⊗ᵖ M)_x ≅ F_x ⊗_{R_x} M_x`, identifying
     `(F ◁ g)_x` with `lTensor F_x (stalkLinearMap g x)` — genuinely Mathlib-absent over a varying
     ring (stalk = filtered colimit commuting with the relative tensor); the largest piece. State
     that once d.2 lands, `stalkLinearMap_bijective_of_isIso` + the linear-equivalence `lTensor`
     finish the proof flatness-free.

4. **Name the `WEqualsLocallyBijective` hypothesis.** In the statement of
   `lem:islocallyinjective_whisker_of_W`, add (in prose) that the localizer `J.W` is the locally
   bijective morphisms, i.e. the site carries the `WEqualsLocallyBijective` property for `Ab` — the
   Lean signature carries `[J.WEqualsLocallyBijective Ab]` as a typeclass hypothesis, which the
   current statement does not surface.

## Out of scope (do NOT touch)

- The route, the substrate, any statement signature, any other declaration block, any other chapter.
- Do NOT add or remove `\leanok` or `\mathlibok` markers (the deterministic sync and review agents
  own those).
- Do NOT invent new mathematical content beyond the four items above.

## Citation note

The d.1-core declarations are project-original (Archon-bespoke supplements to Mathlib), so the new
block in item 2 needs no external `% SOURCE` citation. The Mathlib facts cited in item 1
(`ModuleCat/Stalk.lean`) are software references, not literature — name the Mathlib file in prose,
no `% SOURCE QUOTE` needed. You should not need new reference material; `references/**` is authorized
only as a fallback if you discover an external source is genuinely required for the d.2 prose.
