# Directive: blueprint-writer — chapter `Cohomology_CechHigherDirectImage.tex`

Edit ONLY `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`. Mathematical prose only;
no Lean tactic syntax. Do NOT add `\leanok` (it is managed deterministically elsewhere). You MAY
add/repoint `\lean{}` pins and `\uses{}`.

## Strategy context (the slice that matters)
The project is relocating the exactness theorem `cechAugmented_exact` (`lem:cech_augmented_resolution`)
out of the most-upstream `CechHigherDirectImage.lean` into a NEW downstream file
`AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`, because every ingredient of its
sections/sheafification proof lives in a file that transitively imports `CechHigherDirectImage.lean`
(import cycle). We are also activating the open-immersion lemma `higherDirectImage_openImmersion_comp`
(`lem:open_immersion_pushforward_comp`) into a NEW file
`AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`. Both new files are covered by THIS
consolidated chapter.

## Tasks (all in this one chapter)

### 1. Extend the `% archon:covers` declaration (top of file, lines ~3–12)
Add two lines so the chapter gates the two new Lean files:
```
% archon:covers AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean
% archon:covers AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean
```

### 2. Add a blueprint block for the 3 already-landed Step-2 site lemmas (coverage debt)
These three Lean declarations exist (in `CechHigherDirectImage.lean`) but have no blueprint entry,
so they show up under `archon dag-query unmatched`. Author ONE coherent lemma block, label
`lem:sheafify_kills_locally_zero`, that bundles all three names in its `\lean{}`:
```
\lean{CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_obj_of_W,
  CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_obj_of_W_isZero,
  CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_obj_of_isLocallyBijective}
```
Statement (project notation): on a site, sheafification carries a locally-bijective map (a map in
the local-isomorphism class `J.W`) to an isomorphism; consequently if a presheaf `P` admits a
locally-bijective map to a presheaf whose sheafification is the zero sheaf (in particular a presheaf
that is locally zero on a basis), then the sheafification of `P` is the zero sheaf. Give the short
informal proof (the `W`-class is inverted by `presheafToSheaf`; `IsZero` transports along the
resulting iso; for the abelian target the locally-bijective hypothesis comes from local injectivity +
local surjectivity). `\uses{}`: this is pure Mathlib site theory — cite the Mathlib facts it rests on
in prose (`GrothendieckTopology.W_iff`, `presheafToSheaf_additive`,
`GrothendieckTopology.W_of_isLocallyBijective`) but it has no project-internal `\uses` dependency.
Reference this new block from Step 2 of the `lem:cech_augmented_resolution` proof `\uses{}`.

### 3. Refresh the `lem:cech_augmented_resolution` block (lines ~7137–7263)
- In the `% NOTE` comment, record that the theorem is now being placed in the new file
  `CechAugmentedResolution.lean` (which imports CechAcyclic + HigherDirectImagePresheaf +
  AffineSerreVanishing + QcohTildeSections); keep the import-cycle explanation.
- In the proof prose Step 1, make explicit that the reflection is through the faithful additive
  forgetful functor `SheafOfModules.toSheaf` (X.Modules → abelian sheaves), which reflects `IsZero`.
- In Step 3, make explicit that the bridge from the module-level homology sheafification
  (`homologyIsoSheafify`) to the abelian-sheaf site lemmas (the new `lem:sheafify_kills_locally_zero`)
  goes through the sheafification square `toSheaf ∘ sheafification ≅ presheafToSheaf ∘ forget`.
- Add `lem:sheafify_kills_locally_zero` to the proof `\uses{}`.
- (Reviewer iter-052 informational) In Step 4, name the degree-0 exactness certificate
  `combDifferential_exact` / `exact_of_isLocalized_span` explicitly in the prose.

### 4. Fold the private helper `affine_tildeVanishing` (coverage debt)
The new private Lean helper `AlgebraicGeometry.affine_tildeVanishing` (in `AffineSerreVanishing.lean`)
is a thin reshaper of `sectionCech_homology_exact_of_localizationAway` into the `ULift (Fin n)`-indexed
hypothesis shape. Being private it needs no standalone block — fold its name into the existing
`\lean{...}` list of `lem:affine_cech_vanishing_qcoh` (or `lem:affine_cech_vanishing_tilde_subcover`,
whichever is the closer mathematical home) so `dag-query unmatched` stays clean.

### 5. (Reviewer iter-052 informational) Fix the mislabeled block
The block at `def:cohomology_sheaf_is_sheafify_homology` (~line 7267) is a `\begin{lemma}` but carries
a `def:`-prefixed label. Rename the label to `lem:cohomology_sheaf_is_sheafify_homology` and update
all `\ref{}`/`\uses{}` that point at it within this chapter.

## Out of scope
Do NOT touch the `lem:open_immersion_pushforward_comp` block (already complete + reviewer-cleared) —
except if task 1's covers line interacts, leave its content alone. Do NOT edit any other chapter.
Do NOT add `\leanok`.
