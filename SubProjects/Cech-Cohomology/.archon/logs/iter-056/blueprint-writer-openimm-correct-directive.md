# Blueprint-writer directive (round 2) — REPLACE the WALL transport route with the sound two-need split

## Chapter to edit
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Why you are re-dispatched (read this carefully)
Your round-1 edit (report: `task_results/blueprint-writer-openimm-transport.md`) made Proof detail (2)
of `lem:open_immersion_pushforward_comp` concrete via a transport along `j⁻¹V ≅ Spec Γ(j⁻¹V)` using
`IsAffineOpen.isoSpec` (the open-subscheme iso), packaged as `lem:sectionsFunctor_isoSpec_transport`.

**A mathlib-analogist audit (report: `task_results/mathlib-analogist-change-of-scheme-cohomology.md`;
rationale: `analogies/change-of-scheme-cohomology.md`) proved that route is a WALL, not a shortcut.**
Read `analogies/change-of-scheme-cohomology.md` IN FULL before editing. The key facts:

- `jShriekOU V` and `H` live in `U.Modules`. The iso `V ≅ Spec Γ(V)` is an iso of the **open
  subscheme** `V = j⁻¹W`, **not** of `U`. Using it forces a restriction `U.Modules → V.Modules`
  (`H ↦ H|_V`), whose derived comparison `Ext^q_U(j_!𝒪_V, H) ≅ H^q(V, H|_V)` IS
  restriction-preserves-injectives — the 200–500 LOC `j_!` gap the project deliberately pivoted
  away from in iter-026 (Form B). `V ↪ U` is an open immersion, not an iso, so there is no
  `U.Modules ≌ V.Modules` to transport `Ext` along. **This is a DEAD END.**

- The general-affine-open vanishing `Ext^q(jShriekOU V, H) = 0` (V a general, possibly
  non-distinguished, affine open) is **genuinely unavoidable** (boundary-straddling affine opens
  `W ⊆ X` force `j⁻¹W` to be a general affine open). But it has a SOUND, Form-B-native, no-new-gap
  discharge, split into two independent needs:

  **Need #2 (general-affine-open vanishing — AMBIENT, no restriction functor):** obtain
  `Ext^q(jShriekOU V, H) = 0` for ANY affine open `V` of `Spec R` directly from the EXISTING
  `cech_eq_cohomology_of_basis s … V hV` by **enlarging the cover-system basis `B` of
  `affineCoverSystem` from `{D f}` (distinguished opens) to ALL affine opens**, keeping
  `Cov = standard covers i ↦ D(g i)`. The proof of `cech_eq_cohomology_of_basis` never touches a
  restriction functor. Re-proof load: `faces_mem` already covered (faces are `D(∏ g)` ⊆ affine);
  `injective_acyclic` unchanged (cover-agnostic `injective_cech_acyclicFam`); ONLY
  `surj_of_vanishing` must generalize from `V = D f` to a general affine open — by replacing
  `PrimeSpectrum.isCompact_basicOpen f` with `IsAffineOpen.isCompact` [verified] in
  `affine_surj_of_vanishing` (`AffineSerreVanishing.lean:233`) and `standard_cover_cofinal` (`:167`).
  ~40–80 LOC, low risk, zero new Mathlib gaps. Lean target lives in `AffineSerreVanishing.lean`.

  **Need #1 (abstract-affine `U` → `Spec Γ(U)` — the SOUND use of `isoSpec`):** the residual lives
  over the abstract affine scheme `U`; move it to `Spec Γ(U)` via the WHOLE-SCHEME iso
  `U ≅ Spec Γ(U)` (`AlgebraicGeometry.Scheme.isoSpec`, `[IsAffine U]`), which is a genuine
  equivalence. Assemble `Φ : U.Modules ≌ (Spec Γ U).Modules` from `Scheme.Modules.pushforward
  U.isoSpec.hom/.inv` + `pushforwardComp`/`pushforwardId`/`pushforwardCongr` [all verified,
  `Modules/Sheaf.lean:190,210,224`], and transport `Ext` via `CategoryTheory.Abelian.Ext.mapExactFunctor`
  [verified, `Ext/Map.lean:126`] (cleaner than `rightDerivedNatIso` here), with `jShriekOU` /
  quasi-coherence naturality under the iso. Under `Φ`, the open `V = j⁻¹W ⊆ U` maps to a general
  affine open of `Spec Γ(U)` — which Need #2 then kills. ~60–120 LOC, low–medium risk.

## Tasks

### Task A — REWRITE Proof detail (2) of `lem:open_immersion_pushforward_comp`
Replace the round-1 `(2a)/(2b)/(2c)` `IsAffineOpen.isoSpec`-on-`V` chain with the sound route:
- (2a) `j` affine (via `isAffineHom_of_affine_separated`) ⇒ `j⁻¹V` (resp. `U ∩ f⁻¹V`) is an affine
  scheme; the residual is `Ext^q(jShriekOU(j⁻¹V), H) = 0` over the abstract affine scheme `U`,
  `q ≥ 1`.
- (2b) **Need #1**: transport along the WHOLE-SCHEME equivalence `U ≅ Spec Γ(U)` (`Scheme.isoSpec`,
  via `Scheme.Modules.pushforward` coherences + `Abelian.Ext.mapExactFunctor`), carrying the residual
  to `Ext^q(jShriekOU V', H')` over `Spec Γ(U)`, where `V'` is the (general) affine open image of
  `j⁻¹V`.
- (2c) **Need #2**: over `Spec Γ(U)`, `V'` is a general affine open, and the enlarged-basis
  cover-system vanishing kills `Ext^q(jShriekOU V', H') = 0` for `q ≥ 1` via
  `cech_eq_cohomology_of_basis` with `B = {affine opens}`.
- Add an explicit `% NOTE:` (or visible `\textit{Remark}`) recording the DEAD END: the naive
  transport along `j⁻¹V ≅ Spec Γ(j⁻¹V)` on the OPEN SUBSCHEME forces restriction-preserves-injectives
  and is rejected (cite the iter-026 Form-B pivot).

### Task B — REPLACE the WALL lemma `lem:sectionsFunctor_isoSpec_transport`
- DELETE the `lem:sectionsFunctor_isoSpec_transport` block (TODO pin
  `AlgebraicGeometry.sectionsFunctorIsoSpecTransport_TODO`) — it encodes the wall.
- ADD a Need #2 target block, e.g. `lem:affine_serre_vanishing_general_open`:
  statement `Ext^q(jShriekOU V, H) = 0` for `V` ANY affine open of `Spec R`, `H` quasi-coherent,
  `q ≥ 1`. `\lean{…TODO…}` pin (the Lean decl does not exist yet — a build target in
  `AffineSerreVanishing.lean`). `\uses{lem:cech_eq_cohomology_of_basis, lem:affine_surj_of_vanishing,
  lem:standard_cover_cofinal}` (adjust to the real labels in the chapter). Informal proof: enlarge the
  basis `B` of `affineCoverSystem` to all affine opens; only `surj_of_vanishing` /
  `standard_cover_cofinal` need the `isCompact_basicOpen → IsAffineOpen.isCompact` swap; the rest of
  the cover-system fields are cover-agnostic / already cover `B ⊇ {D f}`.
- ADD a Need #1 target block, e.g. `lem:modules_isoSpec_ext_transport`:
  statement: for `U` affine, the whole-scheme equivalence `U ≅ Spec Γ(U)` induces
  `Ext^q_{U}(jShriekOU V, H) ≅ Ext^q_{Spec Γ U}(jShriekOU V', H')` (V' the image affine open).
  `\lean{…TODO…}` pin. `\uses{lem:isoSpec_scheme_mathlib, lem:ext_mapExactFunctor_mathlib}` (+ the
  pushforward-coherence anchors). Informal proof per the analogist's Need #1 recipe.
- Replace the Mathlib anchor: the round-1 `lem:isoSpec_mathlib` pins `IsAffineOpen.isoSpec` (the
  open-subscheme iso — WRONG vehicle). Re-point it (or add a new anchor `lem:isoSpec_scheme_mathlib`)
  to `\lean{AlgebraicGeometry.Scheme.isoSpec}` `\mathlibok` — the WHOLE-SCHEME affine iso
  `X ≅ Spec Γ(X,𝒪)` for `[IsAffine X]`. Add a `\mathlibok` Mathlib anchor
  `lem:ext_mapExactFunctor_mathlib` for `CategoryTheory.Abelian.Ext.mapExactFunctor`
  (Ext transports along an exact functor). Keep/adjust the pushforward-coherence references as prose
  (they are Mathlib; you may add a `\mathlibok` anchor `lem:modules_pushforward_mathlib` for
  `Scheme.Modules.pushforward` + coherences if it helps the DAG).
- Update `lem:open_immersion_pushforward_comp`'s `\uses` (statement + proof) to reference the new
  `lem:affine_serre_vanishing_general_open` and `lem:modules_isoSpec_ext_transport` instead of the
  deleted `lem:sectionsFunctor_isoSpec_transport`.

### Task C — keep round-1 Tasks 3/4/5 as-is
The coverage-debt helper blocks (`lem:toPresheofModules_additive`, `lem:sectionsFunctor_additive`,
`lem:sectionsFunctorCorepIso`, `lem:isZero_homology_of_iso_homotopy_id_zero`), the stale-prose
deletion, and the `dep*`-`\uses` clarification from round 1 are CORRECT — leave them. Only adjust
prose that over-claims `rightDerivedNatIso` as the transport vehicle (the analogist Q3 prefers
`Ext.mapExactFunctor` for Need #1; `rightDerivedNatIso`/`sectionsFunctorCorepIso` remain correct
and reusable but are not the main vehicle for the change-of-scheme step).

## Hard constraints
- Edit ONLY `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (+ `references/**` only if
  a retrieval is truly needed — it is not; all anchors are verified in `analogies/change-of-scheme-cohomology.md`).
- Do NOT add/remove `\leanok`. `\mathlibok` ONLY on the genuine Mathlib anchors named above
  (`Scheme.isoSpec`, `Ext.mapExactFunctor`, optionally `Scheme.Modules.pushforward`). The two project
  TODO targets (`affine_serre_vanishing_general_open`, `modules_isoSpec_ext_transport`) get NO marker
  (they are to-be-built).
- `…TODO…` pins for not-yet-existing Lean decls (build targets), never invented real names.
- Keep prose mathematical, textbook-level, project notation. No Lean tactics.

## Out of scope
Do NOT touch the Sub-brick A stub statements or any other chapter. Do NOT re-architect the
`lem:open_immersion_pushforward_comp` statement (it is correct). Do NOT modify the existing
`lem:affine_serre_vanishing` statement (the ⊤-case Lean decl stays; the general-open case is a NEW
sibling target).
