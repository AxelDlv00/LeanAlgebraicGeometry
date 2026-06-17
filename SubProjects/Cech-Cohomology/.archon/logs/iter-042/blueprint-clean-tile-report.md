# Blueprint-clean report — slug: tile

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Summary

Enforced blueprint purity on the four edited blocks introduced in the `tile-descent` writer round. All Lean-syntax leakage was removed from visible prose; Lean names were moved into `% NOTE` comments for the prover's benefit. The `lem:qcoh_section_equalizer` `\lean{}` line was left untouched.

## Changes made

### `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap` (lines ~4351–4374)

**Statement:**
- Replaced `\(\operatorname{algebraMap}_{R,A}(f) \in A\)` in prose with "its image in \(A\) under the algebra structure map \(R \to A\)".
- Replaced `\(\varphi.\operatorname{restrictScalars} R\)` (Lean dot-notation) with `\(\varphi\), viewed as an \(R\)-linear map via restriction of scalars along \(R \to A\)`.

**Proof:**
- Added `% NOTE (Lean): converse of IsLocalizedModule.of_restrictScalars; unit clause uses Module.End.isUnit_iff.`
- Replaced `Mathlib's \(\operatorname{IsLocalizedModule.of\_restrictScalars}\)` with "the scalar-restriction direction of the localised-module API".
- Replaced `\(\operatorname{IsLocalizedModule}\)` with "being a localised module".
- Removed `(\(\operatorname{Module.End.isUnit\_iff}\))` parenthetical; the mathematical meaning ("bijectivity is a property of the underlying map independent of the choice of base ring") is preserved in prose.

### `lem:tile_image_opens_identities` (lines ~4376–4405)

**Statement:**
- Moved the entire "Equivalently, in the notation of the structure-sheaf restriction functors…" paragraph (with `''ᵁ` image-open notation, `specBasicOpen`, `basicOpenIsoSpecAway`, `.iota`, `.inv`) into a `% NOTE (Lean)` comment; the mathematical content is already captured by the displayed equations above it.
- Replaced `\operatorname{Localization.Away} g` with `R[g^{-1}]`.
- Replaced `\operatorname{basicOpenIsoSpecAway} g` (in the open-immersion description) with "the canonical homeomorphism \(\Spec R_g \xrightarrow{\sim} D(g)\)".
- Replaced `\bar f = \operatorname{algebraMap}_{R,R_g}(f)` with "\(\bar f\) is the image of \(f\) under the localisation map \(R \to R_g\)".

**Proof:**
- Replaced `\operatorname{basicOpenIsoSpecAway} g` with "the canonical homeomorphism \(\Spec R_g \xrightarrow{\sim} D(g)\)".
- Replaced `by \(\operatorname{PrimeSpectrum.basicOpen\_mul}\) (the basic open of a product is the intersection of the basic opens)` with "since the basic open of a product is the intersection of the basic opens" (mathematical content preserved; Lean lemma name dropped from prose).

### `lem:tile_section_comparison` (lines ~4407–4452)

**Statement:**
- Added `% NOTE (Lean): Γ_{R_g}(−, F_(g)) is modulesSpecToSheaf.obj (ModuleCat R_g-valued); ...` comment before the clarifying sentence.
- Replaced `\(\operatorname{modulesSpecToSheaf}.\operatorname{obj}\)` with "the global-ring section functor".
- Replaced `\(\operatorname{ModuleCat} R_g\)` with "\(R_g\)-modules".

**Proof:**
- Expanded the existing `% NOTE` into a fuller `% NOTE (Lean)` comment naming `restrict_obj/restrict_map`, `modulesSpecToSheaf.obj`, `forgetToSheafModuleCat`, `globalSectionsIso`, and the non-defeq section objects.
- Replaced the entire Lean-heavy proof body:
  - `(the \(\operatorname{restrict\_obj}\) / \(\operatorname{restrict\_map}\) rfl)` → "definitionally" (parenthetical removed; mathematical meaning preserved).
  - `\(\operatorname{SheafOfModules}\) section functor` → "the sheaf-of-modules functor".
  - `the global-ring functor \(\operatorname{modulesSpecToSheaf}.\operatorname{obj}\), which is \(\operatorname{forgetToSheafModuleCat}\) followed by …` → "The global-ring functor is obtained from the local-ring one by composing with restriction of scalars along the global-sections identification …".
  - `\(\operatorname{restrict\_obj}\) identification … two \(\operatorname{globalSectionsIso}\) restrict-scalars bookkeeping maps … using \(\operatorname{restrict\_map}\)` → "take the definitional identification of underlying additive groups, transport it across both global-sections restriction-of-scalars bookkeeping maps … and verify naturality … and compatibility with restriction maps".
  - The non-defeq closing sentence: replaced `\((\operatorname{modulesSpecToSheaf}.\operatorname{obj}\,\mathcal{F}_{(g)}).\operatorname{presheaf}.\operatorname{obj}(V)\)` and similar with `\(\Gamma_{R_g}(V,\mathcal{F}_{(g)})\)` and `\(\Gamma_R(\iota(V),\mathcal{F})\)`. Replaced "defeq" / "not-rfl" with "definitionally equal" / "not-definitionally-equal".

### `lem:tile_section_localization` proof (lines ~4469–4522)

**`% NOTE` comment:**
- Removed project-history references ("inherited from the old bridge.md B6", "was disproved concretely").
- Kept the mathematical substance: the naive recipe is unsound because `restrict_obj` is rfl only for the local-ring functor, not the global-ring one.

**Proof opening:**
- Replaced `Write \(R_g = \operatorname{Localization.Away} g\)` with just `Let \(\iota : \Spec R_g \xrightarrow{\sim} …\)` (R_g was already named in the lemma statement).
- Replaced "for the reason recorded in the note above" (dangling comment-reference) with a proper cross-reference to `Lemma~\ref{lem:tile_section_comparison}`.

**Step 4:**
- Replaced `the global-ring \(\operatorname{modulesSpecToSheaf}\) functor` with "the global-ring section functor".
- Replaced `\(\operatorname{IsLocalizedModule}(\operatorname{powers} \bar f)\)` with "the localisation-at-\(\bar f\) property".
- Replaced `(an \(\operatorname{of\_linearEquiv}\)-style move, \(R_g\)-linear)` with `(\(R_g\)-linearly)`.

**Step 5:**
- Replaced `\(\bar f = \operatorname{algebraMap}_{R,R_g}(f)\)` with "since \(\bar f\) is the image of \(f\) under \(R \to R_g\)".

## Structural validation

- `\uses{}` / `\label{}` dependency structure: **unchanged** — the writer's graph is preserved exactly.
- `\leanok` / `\mathlibok` markers: **not added or removed** — untouched throughout.
- `lem:qcoh_section_equalizer` `\lean{}` line: **untouched** — `AlgebraicGeometry.res_trans_apply` remains.
- No blocks outside the four target blocks were touched.

## Verdict

**CLEAN** — all Lean-syntax leakage removed from visible prose; Lean names preserved in structural commands and `% NOTE` comments; mathematical content and distinctions (local-ring vs global-ring functor, definitional vs non-definitional comparison) faithfully preserved.
