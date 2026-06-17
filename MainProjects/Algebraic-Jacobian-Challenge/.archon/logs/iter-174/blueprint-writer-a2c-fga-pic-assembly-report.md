# Blueprint Writer Report

## Slug
a2c-fga-pic-assembly

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_FGAPicRepresentability.tex (NEW, 640 lines)

## Changes Made
- **Added definition** `\definition`/`\label{def:pic_scheme}`/`\lean{AlgebraicGeometry.Scheme.PicScheme}` — the named Picard scheme, separated and locally of finite type over `k`, abelian group scheme; cited from Kleiman §4 Def.~df:Psch.
- **Added lemma** `\lemma`/`\label{lem:line_bundle_quot_correspondence}`/`\lean{AlgebraicGeometry.Scheme.PicScheme.abelMap}` — the line-bundle / Quot correspondence via the Abel map `D ↦ O(D)`, factoring `Div_{C/k} → Pic^♯_{(C/k)ét}` through the Hilbert scheme `Hilb_{C/k} = Quot_{O_C/C/k}`.
  - Proof sketch added: Y, ~30 lines (uses universal-subscheme effective-divisor criterion + Kleiman §3 Lem.~lm:ctn for flat base change of relative effective divisors).
- **Added theorem** `\theorem`/`\label{thm:fga_pic_representability}`/`\lean{AlgebraicGeometry.Scheme.PicScheme.representable}` — FGA representability: `Pic^♯_{(C/k)ét}` is representable by `Pic_{C/k}` separated and locally of finite type over `k`, a disjoint union of open quasi-projective subschemes (Kleiman §4 Thm.~th:main + Cor.~cor:algsch).
  - Proof sketch added: Y, ~60 lines structured as the four-step argument from Kleiman (i) Hilbert-polynomial stratification, (ii) `m`-regularity twist normalisation, (iii) Abel-map factorisation through `Div_{C/k}`, (iv) descent via the smooth-proper quotient lemma.
- **Added lemma** `\lemma`/`\label{lem:smooth_proper_quotient}`/`\lean{AlgebraicGeometry.Scheme.PicScheme.smoothProperQuotient}` — Kleiman §4 Lem.~lm:qt: a flat-and-proper equivalence relation on a quasi-projective `S`-scheme has a quasi-projective effective quotient; included because it is structurally consumed in step 4 of `fga_pic_representability`.
  - Proof sketch added: Y, ~30 lines (proper monomorphism = closed immersion; Altman–Kleiman effective-equivalence-relation construction inside Hilbert; coequaliser uniqueness).
- **Added theorem** `\theorem`/`\label{thm:pic_is_group_scheme}`/`\lean{AlgebraicGeometry.Scheme.PicScheme.groupSchemeStructure}` — `Pic_{C/k}` is a `k`-group scheme via Yoneda transport of the abelian-group structure on `Pic^♯_{(C/k)ét}` (tensor product, inverse, trivial sheaf).
  - Proof sketch added: Y, ~25 lines (presheaf is already abelian-group-valued; sheafification preserves; Yoneda is fully faithful and limit-preserving so transfers structure to the representing scheme).
- **Added section** "Lean encoding" — itemised mapping of the five declarations to their Lean targets, with explicit dependencies on sibling chapters (`Picard_QuotScheme`, `Picard_RelPicFunctor`).
- **Added sections** "Out of scope" (explicitly excluding `Pic⁰` / A.3, Quot re-derivation, ét-sheafification re-derivation, Poincaré sheaf, Mumford counter-examples) and "Internal-consistency check" (\uses{} chain validation, including forward references to sibling chapters being written this iter).

## Cross-references introduced

Internal to this chapter:
- `\uses{def:pic_scheme}` in `thm:pic_is_group_scheme`, `thm:fga_pic_representability` — defined here.
- `\uses{lem:line_bundle_quot_correspondence}` in `thm:fga_pic_representability` — defined here.
- `\uses{lem:smooth_proper_quotient}` in `thm:fga_pic_representability` (via proof) — defined here.
- `\uses{thm:fga_pic_representability}` in `def:pic_scheme`, `thm:pic_is_group_scheme` — defined here.

To sibling chapters already on disk:
- `\uses{def:line_bundle_on_product}` — `Picard_LineBundlePullback.tex` (on disk, label confirmed).
- `\uses{thm:pullback_natural}` — `Picard_LineBundlePullback.tex` (on disk, label confirmed).
- `\uses{thm:relative_pic_quotient_well_defined}` — `Picard_LineBundlePullback.tex` (on disk, label confirmed).

To sibling chapters being written this iter (forward references — flagged in §"Internal-consistency check"):
- `\uses{thm:quot_representable}` — `Picard_QuotScheme.tex` (A.2.b; written this iter by sibling blueprint-writer).
- `\uses{def:rel_pic_etale_sheafification}` — `Picard_RelPicFunctor.tex` (A.1.c; written this iter by sibling blueprint-writer).

## References consulted
- `references/summary.md` — index of available sources; identified Kleiman and Nitsure as primary.
- `references/kleiman-picard.md` — section-to-page map; located §4 `th:main` at L2155, `lm:qt` at L2368, `cor:algsch` at L2686; §3 `dfn:Abel` at L2135, `th:repDiv` at L1837; §2 `df:Pfs` at L1311 and `df:Psch` at L2057.
- `references/kleiman-picard-src/kleiman-picard.tex` — verbatim quotes for `dfn:Abel` (L2135-L2145), `th:repDiv` (L1837-L1841 statement, L1843-L1866 proof), `th:main` (L2155-L2166 statement, L2168-L2366 proof outline), `lm:qt` (L2368-L2375 statement, L2377-L2417 proof), `cor:algsch` (L2686-L2690), `df:Pfs` (L1311-L1318), `df:Psch` (L2057-L2062). Every `% SOURCE QUOTE:` block in the chapter is a copy from this file.
- `references/nitsure-hilbert-quot.md` — confirmed §1 contains the `Hilb_{X/S} = Quot_{O_X/X/S}` identification at L426-L428 and §5 carries the construction proof (referenced for the line-bundle ↔ Quot translation parenthetical, but not pulled verbatim — Kleiman §3 + §4 are the load-bearing citations).
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` — read §1 (L287-L498) for the Hilb=Quot identification and §5 (L2154-L2542) for the Altman–Kleiman construction; no verbatim quote pulled into this chapter (the line-bundle correspondence is cited via Kleiman §3 because that is the form needed for the Abel map).
- `blueprint/src/chapters/Picard_RelativeSpec.tex` — read in full to confirm chapter conventions (citation discipline, `\uses{}` patterns, "Lean encoding" + "Out of scope" + "Internal-consistency check" section structure, NOTE-style planner directives at the top).
- `blueprint/src/chapters/Picard_LineBundlePullback.tex` — read in full to confirm sibling labels (`def:line_bundle_on_product`, `def:pullback_along_projection`, `lem:pullback_compose`, `thm:relative_pic_quotient_well_defined`, `thm:pullback_natural`) and the set-valued / abelian-group split planner directive that A.1.c will refine.
- `blueprint/src/chapters/Jacobian.tex` — skimmed for Route A framing language ("Pic^0_{C/k} as a g-dimensional abelian variety", "FGA representability for Pic_{C/k}", "Hilbert/Quot prerequisites") to keep the chapter's prose aligned with how this assembly is described in the cross-cutting Jacobian chapter.

## Macros needed (if any)
- `\Pic` — used pervasively. Already in `macros/common.tex` (standard; appears in `Jacobian.tex` and `Picard_RelativeSpec.tex` without redefinition).
- `\Picz` — used in STRATEGY NOTE / Out-of-scope discussion of identity component. Inherited from `Jacobian.tex` usage; if not defined, the planner can add it or replace with `\Pic^0`. No hard dependency in the body of the chapter.
- `\Sch` — used in `\Sch/k`. Already in use in sibling chapters; standard macro.
- `\Set` — used as `\to \Set`. Already used in sibling `Picard_LineBundlePullback.tex` and `Picard_RelativeSpec.tex` without issue.
- `\Div`, `\Hilb`, `\Quot` — used throughout. Already in standard use across the Picard chapters. No new macros introduced.

No new macros required; everything reuses the existing macros/common.tex vocabulary.

## Reference-retriever dispatches (if any)
None — `references/kleiman-picard-src/` and `references/nitsure-hilbert-quot-src/` had every quote I needed.

## Notes for Plan Agent

1. **Forward references to sibling chapters being written this iter.** The chapter uses `\uses{thm:quot_representable}` and `\uses{def:rel_pic_etale_sheafification}` pointing at labels in `Picard_QuotScheme.tex` (A.2.b) and `Picard_RelPicFunctor.tex` (A.1.c) respectively, which are being written by sibling blueprint-writers this same iter. If their final landed labels differ, the planner should regenerate the `\uses{}` chain across the three chapters in lockstep. I flagged this explicitly in the chapter's "Internal-consistency check" section.

2. **Smooth-proper quotient lemma is a hidden external dependency.** `lem:smooth_proper_quotient` (Kleiman §4 lm:qt / Altman–Kleiman effective equivalence relation theorem) is recorded as an Archon-internal block with no `\uses{}` to a sibling chapter, but its proof relies on a substantial external result (flat-and-proper equivalence relations on quasi-projective schemes have effective quotients, descending to a closed subscheme of the Hilbert scheme). If this is not yet in Mathlib and the prover decides to scaffold it, the planner may want to create a separate small chapter `Picard_SmoothProperQuotient.tex` rather than carrying the proof inside this assembly chapter. I noted this in §"Lean encoding".

3. **Group-scheme structure transferred via Yoneda; no explicit verification of axioms.** `thm:pic_is_group_scheme` proves the abelian-group axioms only at the level of `T`-points, then appeals to Yoneda. This is standard but the Lean encoding will need to make the Yoneda transport explicit (likely via Mathlib's `Functor.RepresentableBy` + `GrpObj` / `CommGrp_` machinery). The planner may want to flag this to the prover as a non-trivial Lean step despite the simple math.

4. **Étale sheafification dependency form.** The proof of `thm:fga_pic_representability` quietly assumes the étale sheafification step of A.1.c preserves the openness of subfunctors (so that the Hilbert-polynomial stratification `P^φ ⊆ Pic^♯_{(C/k)ét}` is again an open cover after sheafifying). This is standard but the A.1.c chapter should make this property explicit; if it doesn't, the planner may want to add a one-line gating lemma to A.1.c.

5. **Specialisation to `S = Spec k` versus the general theorem.** The chapter states FGA representability only for `S = Spec k` (the case the Jacobian needs), citing both Kleiman §4 `th:main` and Cor.~`cor:algsch`. The proof outline references the four-step Kleiman §4 argument unchanged; only the base-change/local-on-`S` reductions are dropped. This matches the directive ("for `C/k` smooth proper geometrically irreducible with `k`-rational point (or after étale sheafification for general `k`)"). If the project later needs the relative version over a non-trivial base `S`, the chapter is structured so an "extension to general `S`" section can be added with minimal disturbance.

## Strategy-modifying findings

None. The chapter writes cleanly within the iter-174 strategy as described in the directive (Route A.2.c, assembly chapter, gated on A.2.b + A.1.c). The four-step proof outline of Kleiman §4 carries through verbatim in the specialisation `S = Spec k`, and the group-scheme refinement is a Yoneda transport that introduces no new strategic risk.
