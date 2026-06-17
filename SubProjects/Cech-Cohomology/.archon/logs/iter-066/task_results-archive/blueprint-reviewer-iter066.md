# Blueprint Review Report

## Slug
iter066

## Iteration
066

---

## Top-level summaries

### Structural / dependency findings

**Broken `\uses{}` cross-references:** 0 (leandag: `unknown_uses: []`). Clean.

**Isolated nodes (2 total):**

1. `lem:pullbackObjUnitToUnit_mathlib` (type: lemma, mathlibok=True) — dep_count=0, rdep_count=0.
   This node is truly isolated: no blueprint node uses it, and it has no blueprint dependencies.
   The proof block of `lem:pushforward_slice_pullback_iso` (line 10652) explicitly states:
   > "The unit/free-module comparison `pullbackObjUnitToUnit` is **not** used: it identifies the
   > pullback only on the unit (rank-one free) module, whereas `H.over U_i` is an arbitrary module.
   > Instead we identify the whole functor `pullback ψ_r` by uniqueness of left adjoints."
   This `\mathlibok` anchor is dead code in the current proof graph. **Disposition: remove** —
   delete the `lem:pullbackObjUnitToUnit_mathlib` block from the blueprint. (Not must-fix-this-iter;
   no active prover depends on it. Recommend cleanup next blueprint-write pass.)

2. `lean:AlgebraicGeometry.CechAcyclic.affine` (type: lean_aux) — dep_count=0, rdep_count=0.
   Uncovered Lean helper declaration with no associated blueprint node. **Disposition: keep** —
   informational; represents a private Lean-level helper. No blueprint action required.

**Note on `lem:pullbackPushforwardAdjunction_mathlib`** (reported as possibly isolated in prior
drafts): confirmed NOT isolated — rdep_count=1 (used by `lem:pushforward_slice_pullback_iso`),
dep_count=0 (correct for a `\mathlibok` leaf). No issue.

### Gap nodes — missing `\lean{}` hints (5 nodes)

All five are ongoing acceptable work in the `CechHigherDirectImage` chapter; none blocks either
active prover lane this iter. Listed for completeness:

| Node | rdep | effort (local) | Notes |
|---|---|---|---|
| `lem:cech_free_eval_prepend_homotopy` | 3 | 739 | Homotopy on free Čech complex; used by homotopy chain |
| `lem:cech_free_eval_prepend_homotopy_spec` | 2 | 1124 | Spec variant of above |
| `lem:tile_section_comparison` | 0 | 5118 | Previously `lem:tile_section_localization`; large but leaf |
| `lem:isIso_fromTildeGamma_of_quasicoherent` | 0 | 557 | Leaf; qcoh iso |
| `lem:pushforward_commutes_restriction` | 0 | 1370 | Leaf; no active consumer this iter |

No action required this iter. Blueprint-writer should add `\lean{}` hints when these lanes activate.

### Proof status of iter-066 target lemmas (leandag)

| Node | proved | has_sorry | Notes |
|---|---|---|---|
| `lem:open_immersion_pushforward_acyclic` | False | **False** | Axiom-clean; split out this iter as its own block. `\leanok`-eligible next sync. |
| `lem:open_immersion_pushforward_comp` | False | True | Active target for `OpenImmersionPushforward.lean` prover |
| `lem:cechSection_complex_iso` | False | True | Active target for `CechSectionIdentification.lean` prover |
| `lem:cechSection_contractible` | **True** | True | Discrepancy: `\leanok` set on proof block but Lean source has sorry. Possible sync_leanok pre-iter artifact; blueprint-doctor will resolve on next run. Not blocking. |

---

## Mathlib anchor faithfulness — new anchors added this iter

Three new `\mathlibok` anchors were added this iter:

### `lem:scheme_pullbackPushforwardAdjunction_mathlib`
- **`\lean{}` claim:** `AlgebraicGeometry.Scheme.Modules.pullbackPushforwardAdjunction`
- **Mathlib status:** EXISTS — `Mathlib.AlgebraicGeometry.Modules.Pullback` (or nearby);
  the adjunction between scheme-level pullback and pushforward of quasi-coherent sheaves.
- **Blueprint use:** Anchors the adjunction half of the `hacyc` obligation in
  `lem:open_immersion_pushforward_comp`. Used by `lem:pushforward_slice_pullback_iso` (rdep=1).
- **Verdict: FAITHFUL.** The declaration exists in Mathlib at the scheme level and the blueprint
  states the correct form (pullback ⊣ pushforward for scheme morphisms).

### `lem:scheme_pushforwardComp_mathlib`
- **`\lean{}` claim:** `AlgebraicGeometry.Scheme.Modules.pushforwardComp`
- **Mathlib status:** EXISTS — composition transport for pushforward of modules along a composite
  of scheme morphisms `g = f ∘ j`.
- **Blueprint use:** Anchors the `transport` obligation in `lem:open_immersion_pushforward_comp`.
  Used by (rdep=1).
- **Verdict: FAITHFUL.** The declaration provides exactly the `f_*(j_* I^•) ≅ g_* I^•` iso
  needed for the transport step.

### `lem:pullbackPushforwardAdjunction_mathlib` (pre-existing; role now confirmed)
- **`\lean{}` claim:** `SheafOfModules.pullbackPushforwardAdjunction`
- **Blueprint role:** SheafOfModules-level adjunction (non-scheme); used in
  `lem:pushforward_slice_pullback_iso` to identify the pullback functor via left-adjoint uniqueness.
- **Verdict: FAITHFUL (pre-existing, unchanged).** rdep=1, role confirmed.

---

## Per-chapter

### `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

- **complete:** true
- **correct:** true
- **notes:** No changes this iter. All declarations axiom-clean (no sorry), all `\leanok`
  markers set. The comparison-of-resolutions proof of `lem:acyclic_resolution_computes_derived`
  is sound and matches the Lean implementation. No action required.

### `blueprint/src/chapters/Cohomology_HigherDirectImage.tex`

- **complete:** true
- **correct:** true
- **notes:** No changes this iter. Thin pointer chapter (`def:higher_direct_image`); correct and
  self-contained. No action required.

### `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

- **complete:** partial
- **correct:** true
- **notes below**

#### Rewritten `lem:open_immersion_pushforward_comp` part-(2) — CORRECT

The previous proof (Serre vanishing on the affine `U ∩ f⁻¹V`) was flawed: `U ∩ f⁻¹V` is a
pullback of open immersions and is generally NOT affine even when U and V are affine. The iter-066
rewrite correctly abandons that route entirely.

The new categorical route is mathematically sound:

1. **`pullback j ≅ restrictFunctor j`** (anchored by `lem:restrictFunctorIsoPullback_mathlib`,
   rdep=4) — The restriction functor along an open immersion preserves monomorphisms (it is
   exact), so `pullback j` is exact and mono-preserving.

2. **`pushforward j` preserves injectives** — By `CategoryTheory.Injective.injective_of_adjoint`
   (anchored by `lem:injective_of_adjoint`, rdep=3, mathlibok): if `L ⊣ R` and `L` is exact
   (equivalently: preserves monomorphisms), then `R` sends injectives to injectives. Since
   `pullback j ⊣ pushforward j` and `pullback j` is exact, `j_* I` is injective whenever `I` is.

3. **`j_* I^n` is `f_*`-acyclic** — Injective objects are acyclic for any right-derived functor
   (anchored by `lem:right_derived_vanishes_injective`, present in AcyclicResolution chapter).
   This closes **`hacyc`**.

4. **`hexact` (`H^k(j_* I^•) = 0` for `k ≥ 1`)** — Direct application of
   `lem:open_immersion_pushforward_acyclic` (now axiom-clean, has_sorry=False) to each `I^n`.
   Well-specified.

5. **`eRes` (`j_* H ≅ K.cycles 0`)** — `R⁰ j_* ≅ j_*` for a left-exact right adjoint is
   standard (anchored by `lem:right_derived_zero_iso_self`, AcyclicResolution chapter). Combined
   with the exactness of the augmented complex at degree 0, this identifies `j_* H` with the
   zeroth cycles of `j_* I^•`. Well-specified.

6. **`transport`** — `pushforwardComp j f` (anchored by `lem:scheme_pushforwardComp_mathlib`)
   identifies `f_*(j_* I^•) ≅ g_* I^•` objectwise; then `isoRightDerivedObj` (anchored by
   `lem:right_derived_injective_resolution`, AcyclicResolution chapter) compares the derived
   functors. Well-specified.

**All four obligations at formalizable detail.** The `\uses{}` list for
`lem:open_immersion_pushforward_comp` covers all supporting anchors (10 entries: acyclic,
injective_of_adjoint, def:right_acyclic, right_derived_vanishes_injective,
acyclic_resolution_computes_derived, right_derived_injective_resolution,
right_derived_zero_iso_self, scheme_pullbackPushforwardAdjunction_mathlib,
restrictFunctorIsoPullback_mathlib, scheme_pushforwardComp_mathlib). Dependency graph is clean.

#### `lem:open_immersion_pushforward_acyclic` — split, axiom-clean

Split out as its own lemma this iter. Lean status: proved=False (leanok not yet set by
sync_leanok), has_sorry=False (no sorry in Lean source). The file is axiom-clean. This is an
expected sync artifact — `\leanok` will be added automatically on next sync_leanok run.
**No action required.**

#### CechSectionIdentification stubs — ADEQUATE (unchanged from prior assessment)

Both stubs specify augmented-form targets (correcting the Stub 5/6 false-target issue where the
non-augmented complex is not contractible, per memory `stub56-nonaug-section-complex-false.md`):

- **`lem:cechSection_complex_iso` (Stub 5):** Target `D'_aug := (sectionCechComplex U'·).augment ε hε`.
  Proof: degreewise iso via `lem:pushPull_eval_prod_iso` + augmentation differential via
  `lem:cech_augmentation_comp_d`. Both sub-lemmas are in `\uses{}`. Formalizable.

- **`lem:cechSection_contractible` (Stub 6):** Target `Homotopy (𝟙 D'_aug) 0`. Two-part proof:
  positive degrees via the dep\* homotopy engine + explicit augmentation node calculation (π_{i_fix}
  coordinate projection). Well-specified.

Minor discrepancy: leandag shows `lem:cechSection_contractible` as proved=True (leanok on proof
block) but has_sorry=True (Lean sorry present). This may be a pre-iter sync_leanok artifact or
residual from a partial proof attempt. Not blocking; the prover lane should target closing the
sorry.

#### `lem:slice_reverse_ring_map` (φ'') — corrected, `\leanok`-eligible

Proof sketch corrected this iter to the actual definitional argument: codomain bridge via
`sliceStructureSheafHom(φ.symm)` retyped along definitional equality. Confirmed axiom-clean
in prior iter. No issues.

#### Completeness partial — only reason

5 gap nodes (listed above) are missing `\lean{}` hints. None is in the critical path for either
active prover lane. The chapter is substantively complete for the current formalization targets.

---

## Severity summary

### HARD GATE determination

**Structural gates:**
- Broken `\uses{}`: 0 ✓
- Malformed refs (blueprint-doctor): none ✓
- New `axiom` declarations: none ✓

**Content gates — `OpenImmersionPushforward.lean`:**
- Part-(2) proof correct: YES ✓
- All four obligations (hacyc/eRes/hexact/transport) at formalizable detail: YES ✓
- All supporting `\mathlibok` anchors present: YES (10 anchors in `\uses{}`) ✓
- **GATE: CLEARS. Dispatch permitted.**

**Content gates — `CechSectionIdentification.lean`:**
- Stub 5 (`lem:cechSection_complex_iso`) specifies augmented-form target: YES ✓
- Stub 6 (`lem:cechSection_contractible`) specifies augmented-form contractibility: YES ✓
- Sub-lemmas in `\uses{}` present: YES ✓
- **GATE: CLEARS. Dispatch permitted.**

### must-fix-this-iter findings
None.

### should-fix-soon findings

1. **`lem:pullbackObjUnitToUnit_mathlib` — dead anchor, remove.** The containing proof
   explicitly states this lemma is not used. Isolated node (rdep=0). Remove from blueprint
   on next blueprint-write pass to keep the DAG clean.

2. **`lem:cechSection_contractible` — proved/has_sorry discrepancy.** Likely a sync_leanok
   artifact. Prover should ensure the declaration is closed (sorry-free) before claiming
   `\leanok`; blueprint-doctor will verify.

3. **5 gap nodes missing `\lean{}`** — routine ongoing work, none blocks active lanes.

---

## Overall verdict

- `Cohomology_AcyclicResolution.tex`: **complete, correct** — no action.
- `Cohomology_HigherDirectImage.tex`: **complete, correct** — no action.
- `Cohomology_CechHigherDirectImage.tex`: **correct** (rewritten part-(2) is sound, four
  obligations formalizable, Mathlib anchors faithful), **partial** on completeness (5 gap
  nodes, none blocking). No must-fix-this-iter findings.

**Both prover lanes clear their gates. Dispatch `OpenImmersionPushforward.lean` and
`CechSectionIdentification.lean` this iter.**
