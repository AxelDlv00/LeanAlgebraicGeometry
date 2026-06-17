# Lean ↔ Blueprint Check Report

## Slug
basicopencech-iter108

## Iteration
108

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` (1865 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_MayerVietoris.tex` (1207 lines)

## Scope note

This file is the basic-open Čech-acyclicity cohort of the iter-063 split of
`MayerVietoris.lean`. The blueprint chapter covers the *full* Mayer–Vietoris
chapter, so the bulk of `\lean{...}` blocks (sections
`sec:hmodule_prime_mayer_vietoris`, `sec:scheme_affineCoverMVSquare`,
`sec:cover_totality`) target declarations that live in sibling cohort files
(`MayerVietorisCore.lean`, `MayerVietorisCover.lean`), not in this file. I
audit only the blocks whose `\lean{...}` target is a declaration physically
present in `BasicOpenCech.lean` — that is, the `def:Scheme_basicOpenCover`
family, the `splitEpi_pi_lift_of_injective` def, the `cechCohomology` →
`ExactAt` bridge, and the substantive
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf` theorem. Cross-file
consistency (helpers in this file that don't live in the blueprint) is noted
in the *Unreferenced* and *Blueprint adequacy* sections.

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover}` (chapter: `def:Scheme_basicOpenCover`)
- **Lean target exists**: yes (L55-60)
- **Signature matches**: yes — `s : Set Γ(C.left, U)` → `s → Opens` sending `f ↦ C.left.basicOpen f`, exactly the chapter's prose ("$f \in s \mapsto D(f)$").
- **Proof follows sketch**: N/A (definition; no chapter proof body).
- **notes**: parameterised by the project's `C : Over (Spec (.of k))` convention, which the blueprint does not mention but is project-wide. Acceptable.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_supr_of_span_eq_top}` (chapter: `thm:Scheme_basicOpenCover_supr_of_span_eq_top`)
- **Lean target exists**: yes (L73-79)
- **Signature matches**: yes — `IsAffineOpen U` + `Ideal.span s = ⊤` → `⨆ i, basicOpenCover s i = U`.
- **Proof follows sketch**: yes — uses `IsAffineOpen.iSup_basicOpen_eq_self_iff`, exactly the "standard characterisation" the chapter cites.
- **notes**: clean one-line wrapper.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_isAffineOpen}` (chapter: `thm:Scheme_basicOpenCover_isAffineOpen`)
- **Lean target exists**: yes (L91-97)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `IsAffineOpen.basicOpen` is exactly "basic open of an affine scheme is affine."

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_inter_eq_basicOpen_mul}` (chapter: `thm:Scheme_basicOpenCover_inter_eq_basicOpen_mul`)
- **Lean target exists**: yes (L164-171)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `Scheme.basicOpen_mul` is the "standard identity."

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_inter_isAffineOpen}` (chapter: `thm:Scheme_basicOpenCover_inter_isAffineOpen`)
- **Lean target exists**: yes (L187-195)
- **Signature matches**: yes.
- **Proof follows sketch**: yes.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_eq_basicOpen_prod}` (chapter: `thm:Scheme_basicOpenCover_finset_inf_eq_basicOpen_prod`)
- **Lean target exists**: yes (L222-236)
- **Signature matches**: yes — non-empty `Finset s` infimum equals `basicOpen (∏ i ∈ t, i.1)`.
- **Proof follows sketch**: yes — `Finset.cons_induction` chained with `Finset.inf'_cons`, `Finset.prod_cons`, and `Scheme.basicOpen_mul`. Matches "by induction on the finite subset, using the binary case."

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_isAffineOpen}` (chapter: `thm:Scheme_basicOpenCover_finset_inf_isAffineOpen`)
- **Lean target exists**: yes (L261-266)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — chains the previous theorem with `IsAffineOpen.basicOpen`.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_le}` (chapter: `thm:Scheme_basicOpenCover_finset_inf_le`)
- **Lean target exists**: yes (L296-302)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `basicOpen_le` is "a basic open is contained in the ambient affine."

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_isLocalization}` (chapter: `thm:Scheme_basicOpenCover_finset_inf_isLocalization`)
- **Lean target exists**: yes (L330-340)
- **Signature matches**: yes — and uses the explicit `@`-bound `Algebra` slot, which matches the prose's "with the algebra structure given by the presheaf restriction map."
- **Proof follows sketch**: yes — `IsAffineOpen.isLocalization_of_eq_basicOpen` invoked with the inclusion + product-form rewrite.
- **notes**: the explicit `@`-algebra binding is essential and matches the prose claim that algebra is *given by* the restriction map (not just inferred).

### `\lean{AlgebraicGeometry.Scheme.hasAffineCechAcyclicCover_of_basicOpen}` (chapter: `thm:Scheme_hasAffineCechAcyclicCover_of_basicOpen`)
- **Lean target exists**: yes (L117-128)
- **Signature matches**: yes — the existential-bundle form matches the chapter prose.
- **Proof follows sketch**: yes — destructure per-affine evidence and bundle.

### `\lean{AlgebraicGeometry.Scheme.hasAffineCechAcyclicCover_of_basicOpen_curve}` (chapter: `thm:Scheme_hasAffineCechAcyclicCover_of_basicOpen_curve`)
- **Lean target exists**: yes (L139-147)
- **Signature matches**: yes (specialised at `F := toModuleKSheaf C`).
- **Proof follows sketch**: yes — direct dot-form wrapper, matches "Direct application."

### `\lean{AlgebraicGeometry.Scheme.splitEpi_pi_lift_of_injective}` (chapter: `def:Scheme_splitEpi_pi_lift_of_injective`)
- **Lean target exists**: yes (L362-391)
- **Signature matches**: yes — `f : β → α` injective → `SplitEpi (Pi.lift fun b ↦ Pi.π M (f b))` in `ModuleCat k`.
- **Proof follows sketch**: yes — chooses a retraction (via `Classical`), extends families by zero on the complement, verifies pointwise. Matches "choose a retraction… extend… verify pointwise."

### `\lean{AlgebraicGeometry.Scheme.cechCohomology_subsingleton_of_cechCochain_exactAt}` (chapter: `thm:Scheme_cechCohomology_subsingleton_of_cechCochain_exactAt`)
- **Lean target exists**: yes (L404-410)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `ExactAt.isZero_homology` chained with `ModuleCat.subsingleton_of_isZero`. Matches the chapter's "n-cocycles equal n-coboundaries" framing at the categorical-homology layer.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_isCechAcyclicCover_toModuleKSheaf}` (chapter: `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`)
- **Lean target exists**: yes (L1170-1862)
- **Signature matches**: yes.
- **Proof follows sketch**: partial — the proof body executes Step 0 (reduction to `ExactAt`), partially executes Step 1 (per-`f` slice-cover exactness as `h_a`, deferred at L1212), Step 2 (localised-Čech identification, *partially* scaffolded at L1786-L1834 with the budget-deferral at L1846), Step 3 (extra-degeneracy, deferred at L1564), and Step 4 (local-to-global via `exact_of_localized_span` at L1858, which DOES execute conditional on the deferred steps). Six labelled transient sorries remain, matched in the chapter's "Status (iter-108)" paragraph at L1205-1206.
- **notes**: The 5 inline `have`-declarations at L1786-L1834 (`h_V_le_U`, `h_slice_eq`, `h_pi_eq_inf'`, `h_V_affine`, `h_isLoc`) DO correspond to the recipe's components: `h_pi_eq_inf'` implements substep (i) (image-Finset bridge with `Finset.inf_univ_eq_iInf`, `Finset.inf'_eq_inf`, `Finset.inf'_image` + `le_antisymm` framed by `Pi.π`/`Pi.lift`), `h_slice_eq` implements substep (ii) via `Scheme.basicOpen_res`, `h_V_affine` is the affine-witness needed by (iii), and `h_isLoc` implements substep (iii) via `IsAffineOpen.isLocalization_of_eq_basicOpen`. `h_V_le_U` is ancillary plumbing for the presheaf-restriction map. The DEFERRED-budget annotation at L1846-1855 explicitly names `IsLocalizedModule.Away`, `IsLocalizedModule.pi`, `IsLocalizedModule.prodMap`, and `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid` as the Mathlib pieces needed for substep (iv), which matches the chapter's iter-108 escape-valve remark (`rem:basicOpenCover_step2_status`, L1194-1199) — *modulo* the substep-numbering inconsistency flagged below.

### Helpers used inside `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (no chapter block)

The following declarations live in this file and are auxiliary to the substantive theorem above:

- `presheafMap_restrict_collapse` (L425-433)
- `cechCofaceMap_summand_family` (L454-477)
- `cechCofaceMap_summand_family_R_linear` (L502-603)
- `cechCofaceMap_summand_family'` (L612-637)
- `cechCofaceMap_summand_family'_R_linear` (L642-734)
- `alternating_sum_pi_smul_aux` (L764-796)
- `alternating_sum_pi_smul_aux_sum_comp` (L813-837)
- `alternating_zsmul_pi_smul_aux_sum_comp` (L863-902)
- `cechCofaceMap_pi_smul` (L928-1120)

These are project-internal scaffolding for the R-linearity of the Čech
differential needed inside the main theorem. The blueprint does not (and
arguably need not) reference them by name — they are proof-engineering
infrastructure, not mathematical theorems. Per the directive's instruction
to skip auditing `cechCofaceMap_pi_smul`'s body, I confirm only that its
*statement* type-checks (it is the R-linearity claim baked against the local
shape of the consumer in `h_diff_pi_smul_f`) and the body contains a single
labelled `sorry` at L1120 with iter-107 partial-tactic-state preserved.

## Red flags

### Placeholder / suspect bodies

None on declarations the blueprint claims are substantive *with no
acknowledged deferral*. All six `sorry`s in the file are labelled and
explicitly tracked in the chapter's "Status (iter-108)" paragraph at L1205-1206:

- `cechCofaceMap_pi_smul` at L1120: PAUSED `sorry` (iter-107 partial scaffold).
  Acknowledged in the directive as a PAUSED slot and acknowledged in the
  chapter's status paragraph.
- Substep (a) inside `h_a` at L1212: extra-degeneracy slot.
  Acknowledged in chapter status paragraph.
- Outer transport `K → K_0` inside `h_transport` at L1536.
  Acknowledged in chapter status paragraph.
- Substep (a) for `s₀` at L1564.
  Acknowledged in chapter status paragraph.
- Localised-Čech transport at L1846 (DEFERRED budget marker).
  Acknowledged in `rem:basicOpenCover_step2_status` (L1194-1199) AND chapter
  status paragraph (L1205-1206).
- Downstream `map_smul'` for `g_R` at L1754. Acknowledged in chapter status
  paragraph; gated on closure of the L1120 bridge.

### Excuse-comments

None. The "DEFERRED (budget)" marker at L1846-1855 is an explicit deferral
classification, not an excuse-comment. The blueprint's escape-valve remark
mirrors it exactly. The deferral is structurally distinguished from a
MATHLIB-GAP marker (the chapter explicitly enumerates that the project's
MATHLIB-GAP roster is `instIsMonoidal_W`, `h_exact`, `nonempty_jacobianWitness`
and that this `sorry` is *not* on that list).

### Axioms / Classical.choice on non-trivial claims

None. `Classical` is used only inside `splitEpi_pi_lift_of_injective` for
the choice of a retraction of an injective function — chapter prose
authorises this ("choose a retraction of `f`").

## Unreferenced declarations (informational)

The R-linearity scaffolding helpers (`presheafMap_restrict_collapse` through
`cechCofaceMap_pi_smul`) are not referenced by `\lean{...}` blocks in the
chapter. They are project-internal proof-engineering infrastructure for the
substantive Čech-acyclicity proof; promoting them to chapter blocks would
add noise without informational value. Accept as helpers.

## Blueprint adequacy for this file

- **Coverage**: 14/14 substantive Lean declarations have a corresponding
  `\lean{...}` block in the chapter (the 9 helpers listed above are proof-
  engineering infrastructure for the substantive theorem and are
  appropriately unreferenced).

- **Proof-sketch depth**: adequate. The expanded recipe in the proof of
  `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (Step 2, L1166-1182)
  enumerates the four Mathlib API pieces by name (`Finset.inf_univ_eq_iInf`,
  `Finset.inf'_eq_inf`, `Finset.inf'_image`, `Scheme.basicOpen_res`,
  `IsAffineOpen.isLocalization_of_eq_basicOpen`,
  `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`,
  `IsLocalizedModule.pi`, `Function.Exact.iff_of_ladder_linearEquiv`). This
  is the level of detail the iter-107 lean-vs-blueprint-checker flagged as
  the lone "soon" item; the iter-108 expansion via `blueprint-writer mv-step2`
  closes that gap, and the Lean side's inline `have`s at L1786-L1834 use
  exactly these named pieces. Gap successfully closed.

- **Hint precision**: precise. Every `\lean{...}` hint pins a specific
  Mathlib (or project-local) declaration whose signature matches the prose,
  including the explicit `@`-algebra slot on
  `Scheme_basicOpenCover_finset_inf_isLocalization` which prose pins as "with
  the algebra structure given by the presheaf restriction map."

- **Generality**: matches need. The chapter neither over- nor under-
  generalises relative to what the Lean consumes downstream.

- **Recommended chapter-side actions** (minor; not blocking):

  1. **Substep-numbering inconsistency in `rem:basicOpenCover_step2_status`
     (L1196)**. The new iter-108 escape-valve remark cites "Substeps (i) and
     (ii) of the Mathlib-API recipe above (the inclusion $V_x \subseteq U$
     and the restriction-of-section identity)…together with substep (iii)
     (the image-Finset bridge and the per-coord `IsLocalization.Away`
     certificate)". This contradicts the recipe's own numbering at L1167-1176:
     (i) is the *image-Finset bridge*, (ii) is the *restriction-of-section
     identity*, (iii) is the *per-coord `IsLocalization.Away`*. The remark's
     labelling appears to use a different ordering, and "inclusion $V_x
     \subseteq U$" is not actually listed as a substep in the recipe (it's
     ancillary). A reader who picks up the chapter cold would be confused
     about which Lean `have`s correspond to which recipe substeps. Suggested
     fix: re-letter the remark so its (i)/(ii)/(iii) match the recipe, or
     rephrase as "the inline scaffolding at L1786-L1834 covers substeps (i),
     (ii), and (iii) of the Mathlib-API recipe, plus an ancillary `V_x ⊆ U`
     plumbing lemma; substep (iv) is deferred."

  2. **Minor citation drift in `rem:basicOpenCover_step2_status` (L1198)**.
     The remark names `IsLocalizedModule.Away`, `IsLocalizedModule.pi`, and
     the algebra-map adapter. The Lean comment at L1846-1855 additionally
     references `IsLocalizedModule.prodMap`. Either the blueprint should add
     `IsLocalizedModule.prodMap` to its list, or the Lean DEFERRED comment
     should drop it. Cosmetic; does not affect the proof obligation.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - Substep-numbering inconsistency between the recipe in the proof of
    `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (L1167-1176) and
    the new escape-valve remark `rem:basicOpenCover_step2_status` (L1196).
    Cosmetic / readability.
  - Minor citation drift: blueprint remark omits `IsLocalizedModule.prodMap`
    that the Lean DEFERRED annotation cites. Cosmetic.

Overall verdict: **PASS**. The Lean file follows the blueprint chapter
faithfully across all 14 audited `\lean{...}` blocks, every transient
`sorry` is explicitly acknowledged in the chapter (status paragraph + new
iter-108 escape-valve remark), the iter-108 Step-2 expansion mv-step2
successfully closes the iter-107 "soon" gap by enumerating substeps (i)-(iv)
with named Mathlib pieces that the Lean inline scaffolding (L1786-L1834)
uses verbatim, and the budget-deferral marker at L1846 is the correct
classification per the project's MATHLIB-GAP-vs-budget distinction. Two
minor cosmetic items remain inside the new escape-valve remark (substep-
numbering and one citation omission), neither of which gates any downstream
work.
