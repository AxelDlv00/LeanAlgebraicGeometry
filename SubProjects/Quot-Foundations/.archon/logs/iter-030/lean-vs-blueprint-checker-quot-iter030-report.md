# Lean ↔ Blueprint Check Report

## Slug
quot-iter030

## Iteration
030

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`
  (chapter covers both `QuotScheme.lean` and `GradedHilbertSerre.lean`)

---

## Per-declaration

Only declarations that **live in `QuotScheme.lean`** are checked here; blueprint blocks
for declarations in `GradedHilbertSerre.lean` are out of scope for this file-pair.

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (chapter: `def:hilbert_polynomial`)
- **Lean target exists**: yes (L123, `noncomputable def hilbertPolynomial`)
- **Signature matches**: partial — Lean accepts any `_L _F : X.Modules` without a coherence/proper-support
  constraint; blueprint prose requires "coherent sheaf whose schematic support is proper over S". The
  file-skeleton docstring documents this explicitly: "iter-177+: the body unfolds to the
  graded-Euler-characteristic construction once χ ... are in scope." Blueprint `\leanok` on the
  statement block authorizes a sorry-present skeleton.
- **Proof follows sketch**: N/A — body is `:= sorry`; blueprint does not require a closed proof.
- **notes**: Authorized skeleton; no red flag.

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (chapter: `def:quot_functor`)
- **Lean target exists**: yes (L161)
- **Signature matches**: yes — `(Over S)ᵒᵖ ⥤ Type u` for a contravariant functor to sets is correct.
- **Proof follows sketch**: N/A — `:= sorry`.
- **notes**: Authorized skeleton.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (chapter: `def:grassmannian_scheme`)
- **Lean target exists**: yes (L198)
- **Signature matches**: yes.
- **Proof follows sketch**: N/A — `:= sorry`.
- **notes**: Authorized skeleton.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (chapter: `thm:grassmannian_representable`)
- **Lean target exists**: yes (L225)
- **Signature matches**: **no** — the Lean statement is
  `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`,
  an existence skeleton that omits smoothness, properness, relative dimension `d(r-d)`,
  the tautological rank-d quotient, and the Plücker embedding that the blueprint prose requires.
  The blueprint itself acknowledges this in a NOTE: "The Lean statement … is currently a weakened
  existence skeleton that omits smoothness … The `\lean{}` pin above points at a declaration that
  under-delivers the prose statement; it should be strengthened or split into a separate skeleton
  label." The body is `:= sorry`.
- **Proof follows sketch**: N/A — `:= sorry`.
- **notes**: The blueprint `\leanok` authorizes a sorry-present stub. However the **statement** is
  structurally weaker than the prose; the blueprint's own NOTE flags this as a known issue. See
  Red Flags → Placeholder.

### `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` (chapter: `def:is_locally_free_of_rank`)
- **Lean target exists**: yes (L253, `def IsLocallyFreeOfRank`)
- **Signature matches**: yes — existential over a cover with local free-rank-d isomorphisms.
- **Proof follows sketch**: N/A — definition, not a theorem.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` (chapter: `def:modules_annihilator`)
- **Lean target exists**: yes (L298)
- **Signature matches**: yes — `noncomputable def annihilator (F : X.Modules) : X.IdealSheafData`
  via `IdealSheafData.ofIdeals`.
- **Proof follows sketch**: N/A — definition.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_ideal_le}` (chapter: `lem:modules_annihilator_ideal_le`)
- **Lean target exists**: yes (L305)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — uses `IdealSheafData.ideal_ofIdeals_le`.
- **notes**: Axiom-clean, one-liner.

### `\lean{Module.annihilator_isLocalizedModule_eq_map}` (chapter: `lem:annihilator_localization_eq_map`)
- **Lean target exists**: yes (L362)
- **Signature matches**: yes — abstract `IsLocalization`/`IsLocalizedModule` form.
- **Proof follows sketch**: yes — two-direction `le_antisymm`; the `⊆` direction uses
  `IsLocalization.mk'_surjective` and a "clear common denominator over the generators" argument
  as in the blueprint.
- **notes**: Axiom-clean; long proof matches blueprint sketch.

### `\lean{AlgebraicGeometry.isLocalizedModule_tilde_restrict}` (chapter: `lem:isLocalizedModule_tilde_restrict`)
- **Lean target exists**: yes (L467)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — uses `tilde.toOpen_res` and `IsLocalizedModule.of_linearEquiv_right`.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ}` (chapter: `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`)
- **Lean target exists**: yes (L510)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — naturality + component linear equivalences + transport.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.isLocalizedModule_basicOpen_of_presentation}` (chapter: `lem:isLocalizedModule_basicOpen_of_presentation`)
- **Lean target exists**: yes (L686)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — two-line: `isIso_fromTildeΓ_of_presentation` then the affine engine.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.map_units_restrict_basicOpen}` (chapter: `lem:map_units_restrict_basicOpen`)
- **Lean target exists**: yes (L705)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `tilde.isUnit_algebraMap_end_basicOpen` + power.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.exists_finite_basicOpen_cover_le_quasicoherentData}` (chapter: `lem:exists_finite_basicOpen_cover_le_quasicoherentData`)
- **Lean target exists**: yes (L730)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `Ideal.span_eq_top_iff_finite` + basic-open basis + sieve membership.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_isLocalizedModule_restrict}` (chapter: `lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict`)
- **Lean target exists**: yes (L614)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `isIso_sheaf_of_isIso_app_basicOpen` + `bijective_comp_of_localizations`.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_iff_isLocalizedModule_restrict}` (chapter: `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict`)
- **Lean target exists**: yes (L653)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — forward + reverse legs.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.bijective_comp_of_localizations}` (chapter: `lem:bijective_comp_of_localizations`)
- **Lean target exists**: yes (L579, `private`)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `IsLocalizedModule.linearEquiv` + `linearMap_ext`.
- **notes**: Private; blueprint NOTE acknowledges. Axiom-clean.

### `\lean{AlgebraicGeometry.isIso_sheaf_of_isIso_app_basicOpen}` (chapter: `lem:isIso_sheaf_of_isIso_app_basicOpen`)
- **Lean target exists**: yes (L554, `private`)
- **Signature matches**: yes.
- **Proof follows sketch**: yes — basis + stalk injectivity + surjectivity by germ lift.
- **notes**: Private; blueprint NOTE acknowledges. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupport}` (chapter: `def:schematic_support`)
- **Lean target exists**: yes (L312)
- **Signature matches**: yes.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupportι}` (chapter: `def:schematic_support_immersion`)
- **Lean target exists**: yes (L320)
- **Signature matches**: yes.
- **notes**: Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.HasProperSupport}` (chapter: `def:has_proper_support`)
- **Lean target exists**: yes (L328)
- **Signature matches**: yes.
- **notes**: Axiom-clean.

### Absent `\lean{}` pins in gap1 cone (not a red flag — blueprint NOTEs explicitly authorize absence)

The following blueprint blocks have `\lean{}` pins that do **not** resolve to any declaration in
`QuotScheme.lean`. Every one of them carries a `% NOTE: the pinned Lean decl … does NOT yet exist`
comment; none of the statement blocks has `\leanok`. These are intentional markers for future work,
not red flags.

| Blueprint block | Pinned decl | Notes |
|----------------|-------------|-------|
| `lem:over_restrict_iso` (C) | `Scheme.Modules.overRestrictIso` | Absent; NOTE says so |
| `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (P1) | `Scheme.Modules.isIso_fromTildeΓ_restrict_basicOpen` | Absent; NOTE says so |
| `lem:section_localization_descent` (D) | `Scheme.Modules.isLocalizedModule_basicOpen_descent` | Absent; NOTE says so |
| `lem:qcoh_affine_isIso_fromTildeΓ` (gap1) | `Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent` | Absent; NOTE says so |
| `lem:qcoh_affine_section_localization` (G1-core) | `Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent` | Absent; NOTE says so |
| `lem:qcoh_section_localization_basicOpen` | `Scheme.Modules.isLocalizedModule_basicOpen` | Absent; NOTE says so |

---

## Red flags

### Placeholder / suspect bodies

- `Grassmannian.representable` at L225: body is `:= sorry`. **But** the blueprint's `\leanok` on the
  statement block authorizes a sorry. The separate issue is that the **statement** (not the body) is
  structurally weaker than the blueprint prose: the Lean type only gives `∃ Y, Nonempty (RepresentableBy Y)`,
  dropping smoothness, properness, relative dimension, tautological quotient, and Plücker embedding.
  The blueprint NOTE at `thm:grassmannian_representable` explicitly flags this: "The `\lean{}` pin above
  points at a declaration that under-delivers the prose statement; it should be strengthened or split."
  This is a blueprint-side issue (the `\lean{}` hint is acknowledged wrong), not a surprise Lean error.
  Severity: **major** (see Blueprint Adequacy section).

### Excuse-comments

None found. The docstrings labelling bodies as "iter-176 file-skeleton ... typed `sorry`" are
**description**, not excuse; they are consistent with the blueprint's blueprint marker policy
(`\leanok` = exists with at least sorry).

### Axioms / Classical.choice on non-trivial claims

None. All 6 new declarations in `section OverSiteSheafEquivalence` and all previously-existing
project-local declarations in `QuotScheme.lean` have axiom-clean bodies (no `axiom` keywords, no
unauthorized `Classical.choice`).

---

## Iter-030 additions: the 6 `OverSiteSheafEquivalence` declarations

This section answers directive question (a): are the 6 new decls honest coverage debt, not fake
statements; were any protected stubs silently re-typed?

**Declarations added (L786–882):**

1. `overEquivalence_functor_isCocontinuous` (instance, L787) — cover-lifting for the functor of
   `Opens.overEquivalence U`. Real proof: constructs the covering sieve using
   `GrothendieckTopology.mem_over_iff`, `Sieve.overEquiv_iff`, and `S.downward_closed`.

2. `overEquivalence_inverse_isCocontinuous` (instance, L815) — cover-lifting for the inverse.
   Real proof: analogous construction using preimage opens.

3. `overEquivalence_inverse_isDenseSubsite` (instance, L841) — derived from the two
   cocontinuities via `Equivalence.isDenseSubsite_inverse_of_isCocontinuous`. Three-line body.

4. `overEquivalence_functor_isContinuous` (instance, L849) — derived from cocontinuity of the
   inverse via the adjunction `Equivalence.symm.toAdjunction.isContinuous_of_isCocontinuous`.

5. `overEquivalence_inverse_isContinuous` (instance, L860) — derived from cocontinuity of the
   functor via the adjunction `Equivalence.toAdjunction.isContinuous_of_isCocontinuous`.

6. `overEquivalence_sheafCongr` (noncomputable def, L877) — the headline result:
   `Sheaf ((grothendieckTopology X).over U) A ≌ Sheaf (grothendieckTopology ↥U) A`,
   assembled by `(Opens.overEquivalence U).sheafCongr`.

**Are they honest coverage debt?**

Yes. The Lean file's section header (L751–775) explicitly cites the Mathlib `Topology/Sheaves/Over.lean`
TODO: "show that both functors of the equivalence `overEquivalence U` are continuous and induce an
equivalence between `Sheaf ((Opens.grothendieckTopology X).over U) A` and
`Sheaf (Opens.grothendieckTopology U) A`". The 6 declarations fill this TODO. They have no blueprint
`\lean{}` pins — exactly as expected for project-local infrastructure supporting the future
`lem:over_restrict_iso` (C).

**Are any protected stubs silently re-typed?**

No. `archon-protected.yaml` lists (as suggested entries, not active entries) only the four
skeleton declarations: `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`,
`Grassmannian.representable`. None of the 6 new declarations appear there or elsewhere as protected.
No existing declaration in the file was renamed or re-typed.

**Body quality:**

All 6 have substantive, non-sorry, non-trivially-true bodies. Declarations 1–2 contain the actual
mathematical work (cover-lifting proofs). Declarations 3–6 are derived combinatorially from 1–2.

---

## Unreferenced declarations (informational)

The following declarations are in `QuotScheme.lean` but have **no** `\lean{}` pin in the blueprint:

| Declaration | Line | Comment |
|-------------|------|---------|
| `overEquivalence_functor_isCocontinuous` | 787 | Infra for C; no blueprint block (discussed above) |
| `overEquivalence_inverse_isCocontinuous` | 815 | Infra for C |
| `overEquivalence_inverse_isDenseSubsite` | 841 | Infra for C |
| `overEquivalence_functor_isContinuous` | 849 | Infra for C |
| `overEquivalence_inverse_isContinuous` | 860 | Infra for C |
| `overEquivalence_sheafCongr` | 877 | The headline topological result; should eventually appear in the blueprint as a dependency of `lem:over_restrict_iso` |

No declaration in the file suggests it "should" be in the blueprint but was missed accidentally; all
six are intentionally infra-only.

---

## Blueprint adequacy for this file

### (a) Coverage

Counting only declarations in `QuotScheme.lean`:

- **20 declarations have a `\lean{}` pin** in the blueprint (including the 4 sorry skeletons,
  the 2 private helpers, the `\mathlibok`-only anchors, and the full set of non-sorry proofs).
- **6 declarations are unreferenced** (the OverSiteSheafEquivalence infra, all intentional).
- **6 absent `\lean{}` pins** for gap1-cone declarations (C, P1, D, gap1, G1-core, isLocalizedModule):
  all correctly **not** marked `\leanok`; blueprint NOTEs explain absence.

Coverage: adequate for all existing axiom-clean declarations. The 6 new declarations are
legitimately outside the blueprint's current declaration graph.

### (b) Proof-sketch depth for the gap1 cone (C → P1 → D → assemble)

| Step | Blueprint detail | Verdict |
|------|-----------------|---------|
| **C** `lem:over_restrict_iso` | Proof says: "The open immersion `U.ι` induces an equivalence between the slice of the opens site over `U` and the opens site of `U.toScheme`" | **Under-specified** — the blueprint describes the endpoint (site equivalence → sheaf equivalence) but does NOT describe the prerequisite step: proving that the functors of `Opens.overEquivalence U` are `IsCocontinuous`, which is the entire substance of the iter-030 work. A prover cannot formalize C from the current blueprint sketch without discovering the IsCocontinuous infrastructure independently. |
| **P1** `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` | Full chain: `QuasicoherentData.bind` + `Presentation.map` + C + affine identification + `isIso_fromTildeΓ_of_presentation` | **Adequate** once C is available. |
| **D** `lem:section_localization_descent` | Mayer–Vietoris equalizer + flatness of localization + per-cover tilde identifications | **Adequate** — detailed enough to guide formalization. |
| **gap1 assembly** `lem:qcoh_affine_isIso_fromTildeΓ` | One-liner: D → `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` | **Adequate**. |

### (c) Hint precision

**Imprecise (major):** The `\lean{}` pin at `thm:grassmannian_representable` names
`AlgebraicGeometry.Scheme.Grassmannian.representable`, but the blueprint's own NOTE says this pin
"points at a declaration that under-delivers the prose statement; it should be strengthened or split
into a separate skeleton label." The pin is technically correct (the name exists) but the prose
statement is substantially stronger than the Lean statement. The blueprint should either (a) weaken
the prose to match the skeleton, or (b) add a skeleton-label to mark the current statement as
a partial formalization.

**Absent (minor):** No `\lean{}` pins exist for the 6 OverSiteSheafEquivalence declarations.
Since these are project-local infra, this is expected, but the absence means the blueprint DAG
does not capture their role as prerequisites of C. A blueprint update should add at least a block
for `overEquivalence_sheafCongr` and wire it into `lem:over_restrict_iso`'s `\uses` chain.

### (d) Generality

Matches need. The OverSiteSheafEquivalence section correctly states the sheaf-equivalence for an
arbitrary category `A` (not just `RingCat`), as needed by the eventual `overRestrictIso` construction.

### Recommended chapter-side actions

1. **(Major) C under-specification:** Add a blueprint block for `overEquivalence_sheafCongr`
   (and optionally the two `IsCocontinuous` instances) explaining that the Mathlib TODO for
   `Opens.overEquivalence` requires proving cover-lifting for both functors before
   `Equivalence.sheafCongr` can be invoked. Wire this into `lem:over_restrict_iso`'s `\uses` chain.

2. **(Major) Grassmannian.representable pin:** The `\lean{}` pin at `thm:grassmannian_representable`
   should be split — add a `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` label on a
   weaker skeleton-only statement block, and keep the stronger prose statement as an unformalized
   theorem awaiting upgrade (no `\leanok`).

3. **(Minor) Dependency edges for gap1 cone:** Add `overEquivalence_sheafCongr` (and the five
   cocontinuity/continuity instances) as project-local declaration blocks under C's
   `\subsubsection` so the blueprint DAG captures the infra layer built in iter-030.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `Grassmannian.representable` Lean statement weaker than prose; blueprint `\lean{}` pin
  acknowledged as over-delivering in the blueprint's own NOTE | **major** |
| C (`lem:over_restrict_iso`) proof sketch does not describe IsCocontinuous prerequisites;
  iter-030 had to discover the 6-step infra independently | **major** |
| `\lean{}` pin at `thm:grassmannian_representable` needs split or prose update | **major** (blueprint side) |
| 6 new OverSiteSheafEquivalence declarations unreferenced in blueprint; no `\uses` edge
  from C | **minor** |
| `hilbertPolynomial` / `QuotFunctor` / `Grassmannian` sigs accept weaker hypotheses than prose
  (no coherence/properness constraints) — documented skeleton choice | **minor** |

**Overall verdict:** The Lean file is axiom-clean and faithful to the blueprint for all existing
formalized declarations; the 6 new iter-030 declarations are honest Mathlib-TODO-filling
infrastructure with real proofs and no blueprint block (legitimate coverage debt). Two **major**
blueprint-side issues: (1) C's proof sketch is too thin to have guided the IsCocontinuous
formalization, and (2) the `\lean{}` pin at `thm:grassmannian_representable` acknowledges it
points at an under-delivering declaration.

— 26 declarations checked, 0 axiom red flags, 2 major blueprint adequacy issues, 2 minor issues
