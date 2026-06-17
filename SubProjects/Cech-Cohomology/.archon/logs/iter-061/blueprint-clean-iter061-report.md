# Blueprint-clean report — iter-061

Chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Label verification

Both labels referenced by the new `\uses{}` blocks were confirmed present:

| Label | Line | Status |
|---|---|---|
| `lem:forget_reflectsIso_mathlib` | 3896 | ✓ exists |
| `lem:evaluation_preserves_products_mathlib` | 8439 (`\mathlibok` anchor) | ✓ exists |

No new Mathlib anchor blocks were needed.

## Purity edits (2 blocks cleaned)

### 1. `lem:coverArrow_over_sigma` proof (was lines 7993–8008)

**Issue:** Severe Lean leakage — the proof body named Lean implementation declarations
(`coverArrowOverCofan`, `coverArrowOverIsColimit`, `mkCofanColimit`, `Sigma.ι_desc`,
`Sigma.hom_ext`, `Over.homMk`, `coproductIsCoproduct`, `coverArrowOverSigmaIso`) as if
they were mathematical constructs. These names appear in the `\lean{}` field (correct), but
must not appear in the proof text.

**Fix:** Replaced with a mathematical proof describing the coproduct structure, the
triangle equation for the inclusion, the universal-property factorisation, and the
standard-coproduct comparison — all in project notation without Lean identifiers.

### 2. `lem:jshriek_transport_along_iso` proof — first paragraph (was around lines 9634–9641)

**Issue:** The first paragraph (added/updated by the coverage-debt bundling of
`sectionsCorep`/`sectionsCorepPushforward`) named `CorepresentableBy.uniqueUpToIso`,
`sectionsCorepPushforward`, `sectionsCorep`, and `jShriekOU_homEquiv` as if they were
mathematical objects rather than Lean declarations.

**Fix:** Replaced with a clean corepresentability-uniqueness argument: both sides
corepresent the same functor (one via the adjunction underlying `Φ`, the other via
`def:jshriek_ou`), so uniqueness of corepresenting objects identifies them. The
three-step coyoneda chain (items 1–3 below in the proof) was left intact.

## New lemma blocks — no leakage found

The three newly added lemmas were already clean:

- `lem:isIso_modules_of_toPresheaf` — statement and proof use only mathematical language.
- `lem:pushPull_binary_coprod_prod` — proof describes the section-level isomorphism argument
  without Lean-specific identifiers.
- `lem:pushPull_coprod_prod` — empty-base / inductive-step argument is purely mathematical.

## No `.lean` files touched, no `\leanok` markers touched, no other chapters touched.
