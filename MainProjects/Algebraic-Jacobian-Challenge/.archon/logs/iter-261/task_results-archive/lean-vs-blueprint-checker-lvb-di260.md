# Lean ↔ Blueprint Check Report

## Slug
lvb-di260

## Iteration
260

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
  (consolidated chapter; `dual_restrict_iso` / `sliceDualTransport` content at lines ~5648–5850)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `\lem:dual_restrict_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(dual M).restrict f ≅ dual (M.restrict f)` for `[IsOpenImmersion f]`, matches the informal prose.
- **Proof follows sketch**: **no** — critical route mismatch (see Red Flags §1 below). The blueprint proof (lines 5756–5800) describes `sliceDualTransport` as a consumer of `restrictOverIso`/`unitOverIso` from `overEquivalence` (route-1). The Lean code demonstrates this is structurally impossible. Two `sorry`s remain (lines 257, 388).
- **notes**: `\leanok` on the statement block (line 5652) is correct (declaration exists). The `\uses` list at lines 5656 and 5685 includes `lem:sheafofmodules_restrict_over_iso` and `lem:sheafofmodules_unit_over_iso` — these belong to route-(1) and are wrong; see MUST-FIX §2.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `\lem:dual_isLocallyTrivial`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — the three-step chain `dual_restrict_iso ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` exactly matches blueprint §5.4 steps 1–3. Transitively partial (inherits the `dual_restrict_iso` step-4 sorry), documented correctly in the Lean file header.
- **notes**: No new mismatch here. `\leanok` on statement block (line 5887) is correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` (chapter: `\lem:dual_unit_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf`, matches `dual 𝒪_Y ≅ 𝒪_Y`.
- **Proof follows sketch**: yes — sheafifies `presheafDualUnitIso` (evaluation-at-1 on presheaf endomorphisms of the unit) through the sheafification counit. Matches the blueprint prose. Axiom-clean.
- **notes**: The Lean proof routes through the intermediate `presheafDualUnitIso` / `dualUnitIsoGen` / `unitDualSectionEquiv` chain (§0 of the file). These are absent from the blueprint as `\lean{...}` blocks; see Unreferenced §B below.

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (chapter: `\lem:sheafofmodules_hom_of_local_compat`)
- **Lean target exists**: yes
- **Signature matches**: yes — the sectionwise `hf` re-signed form is in the Lean file, consistent with the blueprint's explanation of the HEq-→-sectionwise re-sign at lines ~5583-5593.
- **Proof follows sketch**: yes — two-step build: (i) glue via `existsUnique_gluing` / `homLocalSection` / `presheafHomSectionsEquiv`, (ii) `homMk` for `𝒪_X`-linearity. Axiom-clean. Matches blueprint §proof.
- **notes**: Clean. `\leanok` (line 6064) is correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` (chapter: `\lem:scheme_modules_hom_local_section`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — `eqToHom`-conjugation, `Subsingleton.elim` for thin-poset naturality, exactly as described. Axiom-clean.
- **notes**: Clean.

---

## Red Flags

### MUST-FIX §1 — Blueprint proof of `lem:dual_restrict_iso` describes a structurally impossible route

**File**: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, lines **5756–5800**.

The blueprint proof writes:

> *"The leg-(A) atom `sliceDualTransport`. Leg (A) is realised by a single `𝒪_Y(V)`-linear equivalence `sliceDualTransport`, which is now a consumer of the shared open-immersion slice equivalence `Scheme.Modules.overEquivalence U` … whose two coherence legs `restrictOverIso` … and `unitOverIso` … supply the comparison of the restriction functors and of the unit. Concretely, `sliceDualTransport` is the per-open localization to `V` of `overEquivalence U` … The close therefore consumes `restrictOverIso` and `unitOverIso` localized to `V`."*

This is route-(1). The Lean code analysis (DualInverse.lean, lines 229–255) demonstrates route-(1) is **structurally impossible**:

- `restrictOverIso` and `unitOverIso` are isomorphisms of **sheaf objects** (`restrict ↦ over` and `unit ↦ unit` at the sheaf level). They say **nothing about `dual`/internal-hom**.
- The reduced goal after `refine LinearEquiv.toModuleIso ?_` (line 256) is a `𝒪_Y(V)`-linear equivalence between two **presheaf internal-hom section modules** over **different slice categories** (`Over_X fV'` vs `Over_Y V`). Its content is that the dual (`internalHomPresheaf · 𝟙_`) **commutes with slice reindexing** along `f.opensFunctor`.
- Producing this commutation from `overEquivalence` would require its functor (`SheafOfModules.pushforward`) to be **strong monoidal closed** — i.e., to preserve internal hom. Neither `restrictOverIso`/`unitOverIso` nor any project decl provides this; it requires `MonoidalClosed (PresheafOfModules R₀)`, the structure the project deliberately avoids (`rem:scheme_modules_monoidal_off_path`).

The blueprint must be updated to describe **route-(2)**: build `sliceDualTransport`'s forward/inverse `≃ₗ` directly (leg-A: `homLocalSection`-style `eqToHom`-conjugation across `f.opensFunctor`, leg-B: `restrictScalarsRingIsoDualEquiv` along `(f.appIso V).inv`). This route-(2) description currently exists **only in the Lean code comments** (lines 192–255 of the Lean file), not in the blueprint.

**Severity**: **must-fix-this-iter**. The blueprint's proof sketch for the only open sorry in this file is demonstrably wrong; a prover following it cannot close the sorry.

---

### MUST-FIX §2 — `\uses` lists for `lem:dual_restrict_iso` cite route-(1) tools

**File**: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, lines **5656** and **5685**.

Both the statement block and the proof block `\uses` lists for `lem:dual_restrict_iso` include:
```
lem:sheafofmodules_restrict_over_iso, lem:sheafofmodules_unit_over_iso
```
These are `Scheme.Modules.restrictOverIso` and `unitOverIso` — the route-(1) tools that the prover has now proven insufficient for `sliceDualTransport`. Including them in `\uses` signals to the blueprint dependency graph that `dual_restrict_iso` depends on those lemmas, which is incorrect for route-(2).

For route-(2), `restrictOverIso`/`unitOverIso` are NOT consumed. The genuine route-(2) `\uses` would be: `lem:restrictscalars_ringiso_dualequiv` (leg-B, already present) and `lem:open_immersion_slice_sheaf_equiv` or just the `image_preimage_of_le` / `eqToHom` machinery (for leg-A). `def:sheafofmodules_over_equivalence` would also not be a direct dependency in route-(2) as currently scoped (since leg-A is built directly, not by consuming the equivalence object).

**Severity**: **must-fix-this-iter** (stale / wrong dependency edges in the blueprint DAG, misleading to both the plan agent and any future prover).

---

## Unreferenced declarations (informational)

### §A. `Scheme.Modules.sliceDualTransport` — **major**
Present in the Lean file as a non-trivial intermediate declaration (lines 184–257) with an open `sorry`, detailed construction plan, and route-1 vs route-2 diagnosis. The blueprint mentions `sliceDualTransport` by name in the proof prose (lines 5756–5796) but does NOT give it a `\lean{...}` block. Given that (a) it carries an open `sorry` that is the actual prover target and (b) the blueprint's prose description of how to close it is now wrong (route-1), the absence of a `\lean{...}` block makes it harder to track. A standalone `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}` block would let `sync_leanok` track its sorry status independently of `dual_restrict_iso`.

### §B. `PresheafOfModules.unitDualSectionEquiv`, `PresheafOfModules.dualUnitIsoGen`, `Scheme.Modules.presheafDualUnitIso` — **minor**
These three declarations (§0 and the lead-in to §B of the Lean file) are helpers for `dual_unit_iso`. `dualUnitIsoGen` is mentioned in the blueprint prose at line 5794 but has no `\lean{...}` block; `unitDualSectionEquiv` and `presheafDualUnitIso` have no blueprint presence at all. All three are subordinate helpers; their absence from `\lean{...}` blocks is acceptable.

### §C. `topSectionToHom`, `topSectionToHom_app`, `image_preimage_of_le` — **minor**
Helpers for `homOfLocalCompat`. `topSectionToHom` converts a section over `⊤` to a global morphism (step (b) of the A-bridge). `image_preimage_of_le` is the down-set identity powering all the `eqToHom`-conjugations. Blueprint prose covers these concepts in the `lem:sheafofmodules_hom_of_local_compat` proof but gives no separate `\lean{...}` blocks. Acceptable as helpers.

---

## Blueprint adequacy for this file

- **Coverage**: 4/4 primary declarations (`dual_restrict_iso`, `dual_isLocallyTrivial`, `dual_unit_iso`, `homOfLocalCompat`) have `\lean{...}` blocks. 1 substantive intermediate (`sliceDualTransport`) is unreferenced. Multiple minor helpers unreferenced (acceptable).
- **Proof-sketch depth**: **wrong** for `lem:dual_restrict_iso`. The blueprint provides a detailed proof of route-(1) that is structurally impossible (MUST-FIX §1). The correct route-(2) has zero coverage in the blueprint — it exists only in Lean code comments.
- **Hint precision**: **wrong** for `sliceDualTransport`. The blueprint's `\uses` lists and proof prose direct a prover to `restrictOverIso`/`unitOverIso`, which cannot close the goal (MUST-FIX §2). The `\lean{...}` for `dual_restrict_iso` itself is precise (correct name).
- **Generality**: matches need for all other declarations.
- **Recommended chapter-side actions**:
  1. **[must-fix]** Replace the route-(1) proof sketch of `lem:dual_restrict_iso` (lines 5756–5800) with the route-(2) direct sectionwise build: leg-A via `eqToHom`-conjugation across `f.opensFunctor` (mirroring `homLocalSection`'s naturality pattern) + leg-B via `restrictScalarsRingIsoDualEquiv` along `(f.appIso V).inv`; naturality on the thin poset by `Subsingleton.elim`. Add a NOTE explaining why route-(1) cannot work (dual does not commute with slice reindexing via `overEquivalence` without `MonoidalClosed`).
  2. **[must-fix]** Update the `\uses` for `lem:dual_restrict_iso` (statement block at line 5656, proof block at line 5685): remove `lem:sheafofmodules_restrict_over_iso` and `lem:sheafofmodules_unit_over_iso`; keep `lem:restrictscalars_ringiso_dualequiv`; consider removing `def:sheafofmodules_over_equivalence` if route-(2) does not directly use the equivalence object.
  3. **[major]** Add a `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}` block (or subsection) so `sync_leanok` tracks its sorry status independently.

---

## Severity summary

| # | Severity | Finding |
|---|----------|---------|
| 1 | **must-fix-this-iter** | Blueprint proof of `lem:dual_restrict_iso` describes route-(1) (`restrictOverIso`/`unitOverIso` consumers) for `sliceDualTransport`, which the Lean code proves is structurally impossible; blueprint must be updated to route-(2) |
| 2 | **must-fix-this-iter** | `\uses` lists for `lem:dual_restrict_iso` (statement + proof) include `lem:sheafofmodules_restrict_over_iso` and `lem:sheafofmodules_unit_over_iso`, which are wrong route-(1) dependencies; must be removed |
| 3 | **major** | `sliceDualTransport` (substantive open sorry, active prover target) has no `\lean{...}` block in the blueprint |
| 4 | **minor** | `presheafDualUnitIso`, `unitDualSectionEquiv`, `dualUnitIsoGen`, `topSectionToHom`, `topSectionToHom_app`, `image_preimage_of_le` are unreferenced helpers (acceptable) |

**Overall verdict**: The blueprint chapter is **adequate for all closed declarations but critically wrong for `dual_restrict_iso`**: the proof sketch describes a structurally impossible route, the wrong route is wired into the `\uses` dependency graph, and the correct route-(2) is absent from the blueprint entirely.
