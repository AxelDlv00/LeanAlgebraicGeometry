# Blueprint Review Report

## Slug
iter057-recheck

## Iteration
057 (scoped fast-path re-review)

## Scope
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` only — fast-path gate for
`CechSectionIdentification.lean`, `AffineSerreVanishing.lean`, and `CechAcyclic.lean`.

---

## Verdict on the four must-fix items

### Item 1 — `lem:cechSection_complex_iso` corrected to augmented form

**RESOLVED.**

Lines 7821–7895. The statement now reads:

> The augmented Čech complex … evaluated at $V$ … is isomorphic, as a cochain complex, to the
> *augmented* concrete section Čech complex
> $D'^\bullet_{\mathrm{aug}} := (\check{\mathcal{C}}^\bullet(\mathcal{U}',\mathcal{F})).\operatorname{augment}\,\varepsilon\, h_\varepsilon$

This is `D ≅ D'_aug`, not the false `D ≅ D'`. The mis-spec is gone. The `% NOTE:` at
line 7827 is a legitimate build-target note (expected per directive). The proof sketch covers:

- Augmentation-node identity: both complexes carry $\Gamma(V,\mathcal{F})$ at the augmentation node,
  matched by the identity (lines 7868–7869).
- Augmentation differential: the lowest differential of $D^\bullet$ is the evaluation at $V$ of the
  Čech augmentation $\varepsilon : \mathcal{F} \to \mathcal{C}^0$, which equals the augmentation map
  of $D'^\bullet_{\mathrm{aug}}$ by construction (lines 7885–7891).
- Both complexes are well-formed by the shared identity $\varepsilon \cdot d^0 = 0$
  (Lemma `lem:cech_augmentation_comp_d`).

Proof sketch is formalizable; all cited `\uses{}` labels resolve.

---

### Item 2 — `lem:cechSection_contractible` corrected to augmented form with explicit degree-0 node

**RESOLVED.**

Lines 7896–7977. The statement now reads:

> Then the *augmented* concrete section Čech complex $D'^\bullet_{\mathrm{aug}}$ … admits a
> contracting homotopy $\mathrm{id}_{D'^\bullet_{\mathrm{aug}}} \simeq 0$.

The `% NOTE:` at line 7902 is a legitimate build-target note (expected). The proof has an explicit
augmentation-node argument at lines 7959–7976:

- The degree-$(-1)$/degree-0 homotopy component is identified as the $i_{\mathrm{fix}}$-th
  coordinate projection $\pi_{i_{\mathrm{fix}}} : (s_j)_j \mapsto s_{i_{\mathrm{fix}}}$, valid
  because $U'_{i_{\mathrm{fix}}} = V$.
- The explicit identity $\varepsilon \circ \pi_{i_{\mathrm{fix}}} + (\text{degree-0 engine term}) =
  \mathrm{id}$ is computed: $(\varepsilon(\pi_{i_{\mathrm{fix}}} s))_j = s_{i_{\mathrm{fix}}}|_{U_j \cap V}$
  and the degree-0 Čech homotopy contributes $s_j - s_{i_{\mathrm{fix}}}|_{U_j \cap V}$; their sum
  is $s_j$.
- This is not delegated to the `depHomotopy` engine; the engine is cited only for positive Čech
  degrees ≥ 1.

The sheaf-equalizer computation is explicit and formalizable. All `\uses{}` labels resolve.

---

### Item 3 — `lem:affine_serre_vanishing_general_open` routes through new seed

**RESOLVED.**

`lem:affine_cech_vanishing_general_seed` is a complete new block at lines 8745–8823.

- **Statement**: for a general affine open $V = \bigcup_i D(g_i)$ of $\operatorname{Spec} R$ (not
  necessarily a single $D(f)$), $\check{H}^p(\{D(g_i)\}, \widetilde{M}) = 0$ for all $p > 0$.
- **Lean target**: `AlgebraicGeometry.sectionCech_homology_exact_of_affineOpen` (with a build-target
  `% NOTE:`; expected per directive).
- **Proof sketch** (lines 8786–8822): routes through change-of-ring to $S = \Gamma(V,\mathcal{O}_V)$
  via the tilde tensor $M \otimes_R S$; uses `Scheme.isoSpec` to transfer to $\operatorname{Spec} S$
  where the family spans the unit ideal; invokes the full-span standard-cover vanishing of
  `lem:cech_acyclic_affine`; transports back. This is route B1 as required. Sketch is complete and
  formalizable.

`lem:affine_serre_vanishing_general_open`'s proof (lines 8920–8955) explicitly says (line 8944):

> condition (3) … is *not* the distinguished-open seed of Lemma~`lem:affine_serre_vanishing`

and routes condition (3) through `lem:affine_cech_vanishing_general_of_tildeVanishing` →
`lem:affine_cech_vanishing_general_seed`. The old false claim is gone.

---

### Item 4 — Coverage debt

**RESOLVED** on all sub-items.

**Seven helper blocks present** (all have `\lean{}` names, valid `\uses{}`, ≥1-sentence proof sketches):

| Label | Line | `\lean{}` name | Notes |
|---|---|---|---|
| `lem:isAffineOpen_specBasicOpen` | 8626 | `isAffineOpen_specBasicOpen` | ✓ |
| `lem:standard_cover_cofinal_affine` | 8644 | `standard_cover_cofinal_affine` | ✓, with `% SOURCE:` |
| `lem:affine_surj_of_vanishing_affine` | 8697 | `affine_surj_of_vanishing_affine` | ✓ |
| `def:affine_cover_system_general` | 8725 | `affineCoverSystemGeneral` | ✓ |
| `lem:affine_cech_vanishing_general_of_tildeVanishing` | 8825 | `affine_cech_vanishing_qcoh_general_of_tildeVanishing` | ✓ |
| `lem:affine_serre_vanishing_general_of_seed` | 8849 | `affine_serre_vanishing_general_of_seed` | ✓ |
| `lem:affine_serre_vanishing_general_of_tildeVanishing` | 8873 | `affine_serre_vanishing_general_of_tildeVanishing` | ✓ |

**`jShriekOU_homEquiv_nat` wired**: `lem:absolute_cohomology_zero_natural` (line 3140) lists
`AlgebraicGeometry.jShriekOU_homEquiv_nat` and `AlgebraicGeometry.jShriekOU_homEquiv_naturality` in
its `\lean{}` hint. ✓

**Dead `CechAcyclic.affine` documented**: `% NOTE:` at line 1347 explicitly records this as a dead
placeholder whose role is subsumed by the `toSheaf`-reflect bridge feeding
`lem:cech_augmented_resolution`, and that it is intentionally left in place, unused. ✓

**Stub-1 split coherent**:
- `lem:cechBackbone_obj_widePullback` (line 7524): `\lean{AlgebraicGeometry.cechBackbone_obj_widePullback}`, `\uses{def:cover_cech_nerve}`, full proof sketch. ✓
- `lem:coproduct_distrib_fibrePower` (line 7558): `\lean{CategoryTheory.FinitaryPreExtensive.widePullback_coproduct_iso}`, `\uses{lem:isIso_sigmaDesc_map_mathlib, lem:sigmaSigmaIso_mathlib, lem:widePullbackCone_isLimitOfFan_mathlib, lem:finitaryExtensive_scheme_mathlib}`, inductive proof sketch. ✓
- `lem:widePullback_openImm_inter` (line 7622): `\lean{AlgebraicGeometry.widePullback_openImm_inter}`, `\uses{def:cech_free_presheaf_complex, lem:isPullback_opens_inf_mathlib}`, inductive proof sketch. ✓
- `lem:cech_backbone_left_sigma` (line 7657): re-pointed to `\uses{lem:cechBackbone_obj_widePullback, lem:coproduct_distrib_fibrePower, lem:widePullback_openImm_inter, def:cover_cech_nerve, def:cech_free_presheaf_complex}`, assembles all three. ✓

All `\uses{}` are valid labels. Build-target `% NOTE:`s on the three new sub-lemmas are expected and
not must-fix items.

---

## leandag check

- `unknown_uses`: **0** (no broken `\uses{}` cross-references anywhere in the blueprint).
- Isolated nodes: **1**, of type `lean_aux` (not a blueprint node) — the
  `AlgebraicGeometry.CechAcyclic.affine` Lean-only placeholder, documented by `% NOTE:` at line 1347
  as an intentionally dead declaration. Disposition: **keep** (documented dead end). Not a must-fix.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All four iter-057 must-fix findings confirmed resolved.
  - Remaining `% NOTE:` annotations are legitimate build-target markers on not-yet-existing Lean
    decls (`cechSection_complex_iso`/`cechSection_contractible` re-signed forms,
    `sectionCech_homology_exact_of_affineOpen`, the three Stub-1 sub-lemmas); explicitly expected
    per directive; not must-fix items.
  - 1 isolated `lean_aux` node (`CechAcyclic.affine`): documented dead placeholder; keep.

---

## Severity summary

**HARD GATE CLEARS — no findings.**

Zero must-fix-this-iter items. Zero broken `\uses{}`. The single isolated node is a documented,
intentional dead placeholder (`lean_aux`, not a blueprint node).

---

**Overall verdict**: `Cohomology_CechHigherDirectImage.tex` is `complete: true`, `correct: true`
with no must-fix findings — all four iter-057 must-fix items are resolved. The HARD GATE clears for
`CechSectionIdentification.lean`, `AffineSerreVanishing.lean`, and `CechAcyclic.lean`.
