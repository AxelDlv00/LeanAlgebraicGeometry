# Lean ↔ Blueprint Check Report

## Slug
cechbridge-024

## Iteration
024

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechBridge.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.ses_cech_h1}` (chapter: `lem:ses_cech_h1`, line 2677)

- **Lean target exists**: yes — `theorem ses_cech_h1` at line 655.
- **Signature matches**: yes — faithful realization (see analysis below).
- **Proof follows sketch**: yes — the blueprint proof sketch (lines 2731–2754) accurately previews all main steps in the Lean proof.
- **Notes**:
  - **Blueprint statement**: "If there is a cofinal system of open coverings U with Ȟ¹(U,F)=0, then G(U)→H(U) is surjective", for a SES 0→F→G→H→0 of O_X-modules.
  - **Lean statement**: takes a single cover `U : ι → Opens ↥X`, explicit local lifts `sLoc`/`hlift`, Ȟ¹=0 as `hH1`, and the SES decomposed into presheaf-level conditions `hπι`, `hmono`, `hker` (plus sheaf conditions `hGsh`, `hHsh` on G and H only; F is not required to be a sheaf).
  - **"Cofinal system" handling**: The Lean docstring explicitly documents this: *"The 'cofinal system of covers' of the Stacks statement is captured here by taking a single cover satisfying both Ȟ¹=0 and the local-lift property as hypotheses."* This is an authorized decomposition: the Stacks/blueprint proof proceeds by picking one cover satisfying both conditions (a) Ȟ¹=0 and (b) local-lift. The Lean theorem is the per-cover content; the cofinal-system condition is the application context. No weakening: any client holding a cofinal system can instantiate the theorem at one suitable cover.
  - **SES decomposition**: the Lean's explicit presheaf conditions (`hπι`, `hmono`, `hker`) plus sheaf conditions only on G and H are strictly more general than the blueprint's "SES of O_X-modules" (which would require all three to be sheaves). This is an authorized generalization: F only needs Ȟ¹=0, not sheafness.
  - **Conclusion form**: the Lean output `∃ g, gπ(g) = s` is definitionally the surjectivity statement, matching the blueprint conclusion.
  - **No sorry, no placeholder**: axiom-clean (confirmed by directive; grep of the file finds no `sorry`).

### `\lean{AlgebraicGeometry.cechComplex_hom_identification}` (chapter: `lem:cech_complex_hom_identification`, line 1527)

- **Lean target exists**: yes — `noncomputable def cechComplex_hom_identification` at line 263.
- **Signature matches**: yes — cochain-complex isomorphism `homCechComplex 𝒰 F ≅ sectionCechComplex (coverOpen 𝒰) F`, matching the blueprint's `Hom(K(𝒰)•, F) = Č•(𝒰, F)`.
- **Proof follows sketch**: yes — the blueprint proof (lines 1591–1626) describes: (i) free–Yoneda adjunction per multi-index, (ii) product over multi-indices, (iii) differential matching. The Lean implements this as `(alternatingCofaceMapComplex Ab).mapIso (homCechSectionCosimplicialIso 𝒰 F)`, where the cosimplicial natural isomorphism carries the per-degree and differential content.
- **Notes**: all helpers listed in the blueprint's `\lean{...}` block (lines 1528–1538) — `homCechComplex`, `homCechCosimplicial`, `homCechSectionIsoApp`, `homCechSectionIsoApp_hom_π` (private), `pi_mapIso_hom_eq` (private), `freeYonedaHomAddEquiv_naturality` (private), `homCechSectionCosimplicialIso` — are present in the Lean file. No sorry. This lemma lacks `\leanok` in the blueprint despite the Lean proof being complete; this appears to be a `sync_leanok` artifact (some referenced helpers are `private` Lean declarations that the sync tool may not resolve).

### `\lean{AlgebraicGeometry.homCechComplexMapOpIso}` (chapter: `lem:cech_complex_op_identification`, line 2461)

- **Lean target exists**: yes — `noncomputable def homCechComplexMapOpIso` at line 338.
- **Signature matches**: yes — `homCechComplex 𝒰 F ≅ ((preadditiveYoneda.obj F).mapHomologicalComplex …).obj (HomologicalComplex.op (cechFreePresheafComplex 𝒰))`, matching the blueprint's description.
- **Proof follows sketch**: yes — built via `HomologicalComplex.Hom.isoOfComponents` with identity components and differential squares from `homCechComplex_d_eq`, as the blueprint text describes.
- **Notes**: helpers `homCechComplex_d_eq` (private) and `homCechCosimplicial_δ` (private) match the blueprint's `\lean{...}` list. No sorry. This lemma also lacks `\leanok` in the blueprint (same `sync_leanok` artifact as above, private helpers).

### `\lean{AlgebraicGeometry.sectionCechComplexMapOpIso}` (chapter: `lem:section_cech_complex_mapop_iso`, line 2500)

- **Lean target exists**: yes — `noncomputable def sectionCechComplexMapOpIso` at line 360.
- **Signature matches**: yes — `(preadditiveYoneda.obj F …).obj (HomologicalComplex.op (cechFreePresheafComplex 𝒰)) ≅ sectionCechComplex (coverOpen 𝒰) F`, matching the blueprint.
- **Proof follows sketch**: yes — `(homCechComplexMapOpIso 𝒰 F).symm ≪≫ cechComplex_hom_identification 𝒰 F`, exactly as described.
- **Notes**: has `\leanok` in the blueprint (line 2497). Complete.

### `\lean{AlgebraicGeometry.preadditiveYoneda_obj_preservesFiniteColimits_of_injective}` and `\lean{AlgebraicGeometry.quasiIso_map_preadditiveYoneda_of_injective}` (chapter: `lem:hom_into_injective_exact`, line 2527)

- **Lean target exists**: yes — `instance preadditiveYoneda_obj_preservesFiniteColimits_of_injective` at line 398; `lemma quasiIso_map_preadditiveYoneda_of_injective` at line 418.
- **Signature matches**: yes — both match the blueprint's description of "Hom(-,I) preserves finite colimits / quasi-isos for injective I".
- **Proof follows sketch**: yes — the Lean `instance` uses `Injective.injective_iff_preservesEpimorphisms_preadditiveYoneda_obj` and `Functor.preservesFiniteColimits_iff_forall_exact_map_and_epi`; the `lemma` uses `quasiIsoAt_map_of_preservesHomology`. This matches the blueprint proof (lines 2546–2560).
- **Notes**: no sorry. The blueprint lemma lacks `\leanok` (same artifact; `sync_leanok` may not look up the `instance` declaration by name). The proof is complete.

---

## Red flags

*(None found.)*

No `sorry`, no `:= True`/`:= rfl` on non-trivial claims, no excuse-comments, no `axiom` declarations anywhere in `CechBridge.lean`.

---

## Unreferenced declarations (informational)

The following public `theorem`/`lemma` declarations in `CechBridge.lean` have no `\lean{...}` entry in the blueprint chapter:

| Declaration | Nature | Coverage verdict |
|---|---|---|
| `sectionCech_objD_exact_of_isZero_homology` (line 456) | Substantive theorem (converse of CechAcyclic's `sectionCech_isZero_homology_of_objD_exact`; extraction direction); consumed by `sectionCech_one_coboundary_of_isZero_homology` | **Coverage debt** — should appear in blueprint |
| `sectionCech_one_coboundary_of_isZero_homology` (line 495) | Substantive theorem (the Čech-H¹ heart of `ses_cech_h1`; cocycle-to-coboundary extraction in section coordinates) | **Coverage debt** — should appear in blueprint |

All private helpers (`restr_trans`, `restr_inj_of_eq`, `restr_op_unique`, `restr_g'_transport`, `fι_sectionCechFaceRestr`, `coverConst_iInf`, `coverPair_iInf`, `pair_comp_δ0`, `pair_comp_δ1`) are appropriately private and not expected in the blueprint.

---

## Blueprint adequacy for this file

- **Coverage**: 10/12 public declarations have a corresponding `\lean{...}` block. 2 substantive theorems unreferenced (`sectionCech_objD_exact_of_isZero_homology`, `sectionCech_one_coboundary_of_isZero_homology`).
- **Proof-sketch depth**: **adequate** for the primary target `ses_cech_h1`. The blueprint proof (lines 2731–2754) correctly previews all major steps: (1) choose cover, (2) form sᵢ₀ᵢ₁ differences, (3) these lie in F (exactness), (4) coboundary extraction from Ȟ¹=0, (5) correct and glue. The blueprint does not preview the `sectionCech_objD_exact_of_isZero_homology`/`sectionCech_one_coboundary_of_isZero_homology` route, but these are sub-steps derivable from the mathematical narrative. For `lem:cech_complex_hom_identification`, `lem:cech_complex_op_identification`, and `lem:hom_into_injective_exact` the proof sketches are adequate; the technical detail the Lean needed beyond the sketches is auxiliary bookkeeping.
- **Hint precision**: **precise**. Every `\lean{...}` reference correctly names the Lean declaration (checked by grep and Read). No misspellings or wrong namespace.
- **Generality**: **matches need**. The `ses_cech_h1` statement in Lean is slightly *more* general than the blueprint (presheaf maps vs. sheaf SES; F need not be a sheaf), which is correct and authorized: `sectionCechComplex` is a presheaf construction and F's Ȟ¹ vanishing makes no sheaf assumption on F.
- **Recommended chapter-side actions**:
  - Add a blueprint block for `sectionCech_objD_exact_of_isZero_homology` (`\lean{AlgebraicGeometry.sectionCech_objD_exact_of_isZero_homology}`) — it is the extraction/converse form of `sectionCech_isZero_homology_of_objD_exact` (the latter already has a blueprint entry) and is a genuine sub-result of `lem:ses_cech_h1`.
  - Add a blueprint block for `sectionCech_one_coboundary_of_isZero_homology` (`\lean{AlgebraicGeometry.sectionCech_one_coboundary_of_isZero_homology}`) — this is the Čech-algebra heart of `lem:ses_cech_h1`, isolated as a self-contained statement about the section Čech complex (the `\uses{def:cech_complex}` content). It is the statement "Ȟ¹=0 ⟹ every 1-cocycle is a coboundary" in section coordinates.
  - Investigate the missing `\leanok` markers for `lem:cech_complex_hom_identification`, `lem:cech_complex_op_identification`, and `lem:hom_into_injective_exact`. The Lean proofs are complete and sorry-free; the absence of `\leanok` is likely a `sync_leanok` artifact caused by private helpers listed in the `\lean{...}` blocks. The review agent may wish to annotate these with `% NOTE: \leanok pending sync_leanok private-helper resolution` if the issue persists.

---

## Severity summary

- **must-fix-this-iter**: none.
- **major**: 2 substantive unreferenced declarations (`sectionCech_objD_exact_of_isZero_homology`, `sectionCech_one_coboundary_of_isZero_homology`) — they should have blueprint entries since they are named public theorems consumed by `lem:ses_cech_h1`.
- **minor**: 3 lemmas (`lem:cech_complex_hom_identification`, `lem:cech_complex_op_identification`, `lem:hom_into_injective_exact`) lack `\leanok` despite complete Lean proofs — likely a `sync_leanok` artifact, not a content error.

**Overall verdict**: `ses_cech_h1` is a faithful, axiom-clean realization of `lem:ses_cech_h1`; the "cofinal system" is an explicitly authorized per-cover decomposition; no red flags anywhere in the file. Two substantive helper theorems need blueprint entries (major coverage debt).
