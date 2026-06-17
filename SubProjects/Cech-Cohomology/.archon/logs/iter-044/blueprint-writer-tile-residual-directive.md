# Blueprint-writer directive — chapter `Cohomology_CechHigherDirectImage.tex`

## Scope (edit ONE chapter only)
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`. Three precise edits, all in the
`lem:tile_section_comparison` / Sub-lemma B region (around lines 4412–4470). Do NOT touch any other
block, do NOT add `\leanok`, do NOT restate sources you have not read.

## Strategy context (the slice that matters)
This chapter blueprints the Route-B keystone for `01I8` (quasi-coherent `F ≅ \tilde{Γ F}`). The keystone
uses the Stacks 01HV(4) sheaf-axiom equalizer; the last remaining ingredient is the per-tile section
localisation `lem:tile_section_localization`, which depends on Sub-lemma B
`lem:tile_section_comparison` — a natural `R_g`-linear section-comparison iso between the presented tile
`F_(g)` over `R_g` and the ambient `F` over `R`.

**What changed and why this rewrite is needed.** iter-043's prover landed TWO axiom-clean `rfl` bridge
lemmas (kernel-verified via `lake env lean`, axioms `{propext, Classical.choice, Quot.sound}`):
- `AlgebraicGeometry.modulesSpecToSheaf_smul_eq` — the native `R`-action on a `modulesSpecToSheaf.obj F`
  section over an open `W` equals `c_R • x_F`, where
  `c_R = (ringCatSheaf.map (homOfLE (W ≤ ⊤)).op).hom ((StructureSheaf.globalSectionsIso R).hom r)`
  acting on `x` viewed as a section of `F.val` over `W`. Proof: `rfl`.
- `AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq` — the tile (restricted-module) action transports
  rfl-style through the two open-immersion `appIso` ring maps `(specBasicOpen g).ι.appIso` and
  `(basicOpenIsoSpecAway g).inv.appIso` to `F.val`'s structure-sheaf action. Proof: `rfl`.

These two `rfl` bridges show the SCALAR ACTION on both sides is definitional, and that the underlying
carriers are defeq via `restrict_obj` **provided the F-side open is kept in iterated-image form
`W = (specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ ⊤)`** (NOT rewritten to `D(g)`). The
"not even the same type / ~100–150 LOC" framing in the current sketch is therefore STALE: it is true
only of the *bundled* `ModuleCat R_g` vs `ModuleCat R` at the category level. The genuine residual is
ONE structure-sheaf ring identity (~30–50 LOC):
```
  (ringCatSheaf.map (homOfLE (W ≤ ⊤)).op).hom (algebraMap R Γ(W,𝒪) r)
    = ((basicOpenIsoSpecAway g).inv.appIso ⊤).inv.hom
        (algebraMap R_g Γ(⊤, 𝒪_{Spec R_g}) (algebraMap R R_g r))
```
i.e. "sections over `D(g)` are the localization `R_g`, compatibly with `algebraMap`." Closure routes
(from the prover handoff): (A) geometric — `(specBasicOpen g).ι.appIso = Iso.refl`
(`Scheme.Opens.ι_appIso`), so the `appIso` composite is `(specAwayToSpec g).appIso` with
`specAwayToSpec g = Spec.map (algebraMap R R_g)`, closed via `Spec.map`–Γ naturality
(`Scheme.ΓSpecIso_naturality` / `_inv_naturality`); or (B) algebraic — `Γ(W,𝒪)` is
`IsLocalization.Away g` (`StructureSheaf.IsLocalization.to_basicOpen`, after rewriting `W = D(g)` via
`lem:tile_image_opens_identities`), identify the RHS as the `IsLocalization.Away` comparison and close
by localization uniqueness.

## Edit 1 — add two Mathlib-adjacent `rfl`-bridge lemma blocks (clear coverage debt)
Add two new `\begin{lemma}…\end{lemma}` blocks immediately BEFORE `lem:tile_section_comparison`, one per
new Lean decl. These are project-bespoke `rfl` reconciliations (no external source — omit `% SOURCE`
lines; they stand on the one-line proof). Each needs: a human name, `\label`, `\lean{}` pin, accurate
`\uses{}`, and a one-line informal proof.

- `\label{lem:modulesSpecToSheaf_smul_eq}`, `\lean{AlgebraicGeometry.modulesSpecToSheaf_smul_eq}`.
  Statement (project notation): for `F` an `𝒪_{Spec R}`-module, `W` an open, `r : R`, and `x` a section
  of `modulesSpecToSheaf.obj F` over `W`, the native `R`-action satisfies `r • x = c_R • x_F` with `c_R`
  the restriction to `W` of the global-sections image of `r` (formula above). Proof: holds by
  definitional unfolding of `modulesSpecToSheaf`'s action as restriction-of-scalars along
  `globalSectionsIso` — `rfl`. `\uses{}`: none needed beyond the ambient `modulesSpecToSheaf`
  definition block if one exists in this chapter (otherwise leave `\uses{}` empty).
- `\label{lem:modulesRestrictBasicOpen_smul_eq}`,
  `\lean{AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq}`. Statement: the restricted-module (tile)
  action over `R_g` transports definitionally through the two open-immersion `appIso` ring maps to
  `F.val`'s structure-sheaf action. Proof: `rfl` (restriction = pushforward with the `appIso.inv` ring
  map). `\uses{lem:tile_image_opens_identities}`.

## Edit 2 — rewrite the `lem:tile_section_comparison` proof note to the ACCURATE decomposition
Replace the stale prose + stale `% NOTE` lines in the `\begin{proof}` of `lem:tile_section_comparison`
(the block currently saying "~100–150 LOC construction" and "This bridge is genuinely
non-definitional … not definitionally equal … differ both by the base ring and by the provably-equal but
not-definitionally-equal opens"). The new proof note must state, in mathematical prose (no Lean tactics):
1. The scalar action on each side is definitional, captured by the two new bridge lemmas
   `lem:modulesSpecToSheaf_smul_eq` and `lem:modulesRestrictBasicOpen_smul_eq`; the underlying carriers
   coincide definitionally via `lem:restrict_obj_mathlib` once the F-side open is kept in iterated-image
   form `W` (only the bundled `R_g`- vs `R`-module packaging differs at the category level).
2. The sole remaining content is one structure-sheaf ring identity (the displayed identity above),
   expressing that sections over `D(g)` are the localization `R_g` compatibly with `algebraMap`. Display
   it in project notation.
3. The two closure routes (A geometric via `Spec.map`–Γ naturality; B algebraic via `IsLocalization.Away`
   uniqueness). State them as mathematics, not tactic strings.
Keep the estimate honest: residual ~30–50 LOC, not ~100–150. Remove the now-false "genuinely
non-definitional / not the same type" claim (replace with the precise "bundled `ModuleCat R_g` vs
`ModuleCat R` differ at the category level; carriers and scalar actions are definitional").
Strip the stale review `% NOTE (review iter-043)` once its content is folded into the live prose.

## Edit 3 — wire `\uses{}`
In both the statement and proof `\uses{}` of `lem:tile_section_comparison`, ADD
`lem:modulesSpecToSheaf_smul_eq, lem:modulesRestrictBasicOpen_smul_eq` (keep the existing
`lem:presentation_modulesRestrictBasicOpen, lem:restrict_obj_mathlib, lem:tile_image_opens_identities`).

## Out of scope
- Do NOT edit `lem:tile_section_localization`, `lem:qcoh_section_kernel_comparison`, the keystone block,
  or any block outside the Sub-lemma B region.
- Do NOT add `\leanok` anywhere.
- Do NOT change `lem:tile_image_opens_identities` (it is done + pinned).
- No new sources are needed (all content is project-internal Lean reconciliation); you should not need a
  reference-retriever, but it is authorized if you discover a genuine gap.
