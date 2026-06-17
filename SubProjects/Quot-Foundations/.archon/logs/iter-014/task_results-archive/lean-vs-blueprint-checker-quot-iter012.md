# Lean ↔ Blueprint Check Report

## Slug
quot-iter012

## Iteration
012

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Inventory

**Blueprint `\lean{...}` references:** 21 total — 6 `\mathlibok` (Mathlib, not audited), **15 project-side**.

**Sorry diagnostics (LSP-confirmed):** lines 123, 161, 198, 225 — `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`. All other declarations are sorry-free.

**`Module.annihilator_isLocalizedModule_eq_map` axioms (LSP-verified):** `propext`, `Classical.choice`, `Quot.sound` — standard Lean 4 kernel axioms only. Proof is axiom-clean.

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (`def:hilbert_polynomial`)
- **Lean target exists**: yes (line 123)
- **Signature matches**: partial
  - Blueprint prose: finite-type `π : X → S`, noetherian `S`, line bundle `L`, coherent sheaf `F` whose schematic support is proper over `S`, point `s ∈ S` → `Polynomial ℚ`.
  - Lean: `(_L _F : X.Modules)` — both typed as generic `X.Modules`; no proper-support hypothesis for `F`; no line-bundle constraint for `L`.
  - Both omissions are documented in the module header: "whose schematic support is proper over `S` (here encoded as plain `X.Modules` for the file-skeleton)". Intentional staging.
- **Proof follows sketch**: N/A (`:= sorry`)
- **Blueprint `\leanok` on statement block**: yes — consistent (sorry present).
- **Notes**: The `\uses{thm:hilbertPoly_of_sectionModule}` dependency cannot be expressed yet since `hilbertPolynomialOfSectionModule` is not yet formalized.

---

### `\lean{AlgebraicGeometry.sectionGradedRing}` (`def:sectionGradedRing`)
- **Lean target exists**: no — declaration absent from the Lean file.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Blueprint `\leanok`**: absent — correctly unformalized.
- **Notes**: Blocked since iter-007 on absent tensor/monoidal structure for `SheafOfModules` (no `MonoidalCategoryStruct` on `X.Modules` at pinned commit). Blueprint NOTE explains the blocker. No marker inconsistency.

---

### `\lean{AlgebraicGeometry.sectionGradedModule}` (`def:sectionGradedModule`)
- **Lean target exists**: no
- **Blueprint `\leanok`**: absent — correctly unformalized.
- **Notes**: Same infrastructure blocker as `sectionGradedRing`. No marker inconsistency.

---

### `\lean{AlgebraicGeometry.sectionGradedModule_fg}` (`lem:sectionGradedModule_fg`)
- **Lean target exists**: no
- **Blueprint `\leanok`**: absent — correctly unformalized.
- **Notes**: Downstream of `sectionGradedRing`/`sectionGradedModule`. No marker inconsistency.

---

### `\lean{AlgebraicGeometry.gradedModule_hilbertSeries_rational}` (`lem:gradedHilbertSerre_rational`)
- **Lean target exists**: no — the PUBLIC declaration is absent.
- **Blueprint `\leanok`**: absent — correctly unformalized.
- **Proof follows sketch**: the power-series half IS formalized as private helpers in this file: `rationalHilbert_antidiff`, `IsRatHilb`, `IsRatHilb.ofEventuallyZero`, `.bump`, `.sub`, `.shiftRight`, `.antidiff`, `.ofDiffEq`. The blueprint NOTE (iter-012) correctly describes this.
- **Notes**: Blocked on a genuine Mathlib gap: no packaged graded-module quotient `M/xM`, graded kernel of a degree-shifting endomorphism, regrading over `A/(x)`, nor `Module.Finite` transfer through these as GRADED objects. The blueprint NOTE accurately characterizes the remaining work as a multi-lemma sub-build. No marker inconsistency.

---

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomialOfSectionModule}` (`thm:hilbertPoly_of_sectionModule`)
- **Lean target exists**: no
- **Blueprint `\leanok`**: absent — correctly unformalized.
- **Notes**: Downstream of `gradedModule_hilbertSeries_rational`. No marker inconsistency.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` (`def:modules_annihilator`)
- **Lean target exists**: yes (line 298)
- **Signature matches**: yes — `(F : X.Modules) : X.IdealSheafData` matches "ideal sheaf on `X`".
- **Proof follows sketch**: yes — body uses `IdealSheafData.ofIdeals fun U => Module.annihilator Γ(X, U.1) Γ(F, U.1)`, which is exactly the construction the blueprint describes (sidestep `map_ideal_basicOpen` via `ofIdeals`). Blueprint NOTE (iter-011) documents this correctly.
- **Blueprint `\leanok` on statement block**: yes — consistent (sorry-free body).
- **Notes**: Only the `≤` direction of the characterization (`annihilator_ideal_le`) is landed; the full characterization (`annihilator_ideal`) is blocked on `isLocalizedModule_basicOpen`. Blueprint `\uses{}` refers to what the *full* characterization needs, not the definition itself. Correct.

---

### `\lean{Module.annihilator_isLocalizedModule_eq_map}` (`lem:annihilator_localization_eq_map`)
- **Lean target exists**: yes (lines 362–422)
- **Signature matches**: yes — `IsLocalization S Rₚ`, `IsLocalizedModule S f`, `Module.Finite R M`, `f : M →ₗ[R] Mₚ` → `Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ)`. Matches blueprint exactly.
- **Proof follows sketch**: yes — the proof follows the blueprint's two-step argument verbatim:
  - `⊆` direction: clear one common denominator over finitely many generators (the `hgen`/`choose`/`∏` block mirrors the blueprint's "put `u = ∏ uᵢ`" step exactly).
  - `⊇` direction: image of annihilator element annihilates localized elements (the `Ideal.map_le_iff_le_comap` reduction mirrors "∀ r ∈ Ann_R M, r/1 ∈ Ann_{R_S}(M_S)").
- **Proof body**: sorry-free; LSP-verified axioms: `propext`, `Classical.choice`, `Quot.sound` only.
- **Blueprint `\leanok` on statement block**: yes — consistent.
- **Blueprint `\leanok` on proof block**: **absent** — but the Lean proof is complete (no sorry). This should be set by `sync_leanok`. Likely a sync-timing artifact.
- **Notes**: This is the cleanest landing in the file. The proof is faithful to and complete relative to the blueprint sketch.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}` (`lem:qcoh_section_localization_basicOpen`)
- **Lean target exists**: no
- **Blueprint `\leanok`**: absent — correctly unformalized.
- **Notes**: The QCoh→localization bridge; blocked on the transport of Spec-local localization to a general quasi-coherent sheaf via the affine identification. Blueprint proof sketch is detailed. No marker inconsistency.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupport}` (`def:schematic_support`)
- **Lean target exists**: yes (line 312)
- **Signature matches**: yes — `(F : X.Modules) : Scheme.{u}` returns the closed subscheme cut out by `annihilator F`. Matches blueprint.
- **Proof follows sketch**: yes — `(annihilator F).subscheme` is exactly `V(Ann(F))`.
- **Blueprint `\leanok` on statement block**: yes — consistent.
- **Notes**: `schematicSupportι` (line 320, the canonical closed immersion) provides the "equipped with its canonical closed immersion into X" part of the definition but lacks a `\lean{...}` blueprint reference. See "Unreferenced declarations."

---

### `\lean{AlgebraicGeometry.Scheme.Modules.HasProperSupport}` (`def:has_proper_support`)
- **Lean target exists**: yes (line 328)
- **Signature matches**: yes — `(f : X ⟶ S) (F : X.Modules) : Prop := IsProper (schematicSupportι F ≫ f)`. Matches "the composite `schematicSupport(F) ↪ X →ᶠ S` is proper."
- **Blueprint `\leanok` on statement block**: yes — consistent.

---

### `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` (`def:is_locally_free_of_rank`)
- **Lean target exists**: yes (line 253)
- **Signature matches**: yes — `(M : X.Modules) (d : ℕ) : Prop`. Body uses open cover `U : ι → X.Opens` with `⊔ U i = ⊤` and isomorphisms `pullback (U i).ι M ≅ SheafOfModules.free (ULift.{u} (Fin d))`. Matches `M|_{U_i} ≅ O_{U_i}^{⊕d}` exactly.
- **Blueprint `\leanok` on statement block**: yes — consistent.

---

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (`def:quot_functor`)
- **Lean target exists**: yes (line 161)
- **Signature matches**: partial
  - Blueprint: `(S noetherian, π : X → S locally of finite type, L line bundle, E coherent, Φ ∈ Q[λ]) → (Over S)ᵒᵖ ⥤ Set`. Lean: `(_L _E : X.Modules)` — `L` untyped as a line bundle (same `X.Modules` simplification as `hilbertPolynomial`). Rest matches.
- **Proof follows sketch**: N/A (`:= sorry`)
- **Blueprint `\leanok` on statement block**: yes — consistent.
- **Notes**: Minor signature gap for `L`; documented skeleton simplification.

---

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (`def:grassmannian_scheme`)
- **Lean target exists**: yes (line 198)
- **Signature matches**: partial — **[MAJOR]**
  - Blueprint: "Let `S` be a noetherian scheme and let `V` be a locally free `O_S`-module of rank `r`. For an integer `1 ≤ d ≤ r`..."
  - Lean: `(_V : S.Modules) (_d : ℕ)` — no local-freeness hypothesis on `V`, no rank `r`, no `1 ≤ d ≤ r` constraint. The rank `r` of `V` is nowhere in the type.
  - The functor value type `(Over S)ᵒᵖ ⥤ Type u` matches.
- **Proof follows sketch**: N/A (`:= sorry`)
- **Blueprint `\leanok` on statement block**: yes — consistent.
- **Notes**: Missing hypotheses represent a weaker statement than the blueprint specifies; acknowledged as a skeleton.

---

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (`thm:grassmannian_representable`)
- **Lean target exists**: yes (line 225)
- **Signature matches**: **no — [MUST-FIX-THIS-ITER]**
  - Blueprint STATEMENT: "the functor `Grass(V,d)` is representable by a **smooth projective** `S`-scheme `Gr_S(V,d) → S` of **relative dimension `d(r-d)`**, equipped with a **tautological quotient** `π* V ↠ U` of rank `d`. The determinant line bundle `det(U)` is relatively very ample, giving a **Plücker closed embedding** `Gr_S(V,d) ↪ P_S(⋀^d V)`."
  - Lean statement: `∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`
  - Dropped: smoothness, projectivity, relative dimension `d(r-d)`, tautological quotient `π* V ↠ U`, rank-`d` freeness of `U`, Plücker embedding, and the `1 ≤ d ≤ r` rank-range hypothesis on the inputs.
  - The Lean statement asserts only that SOME representing object exists — it could be any (Over S)-object.
- **Proof follows sketch**: N/A (`:= sorry`)
- **Blueprint `\leanok` on statement block**: yes — set by `sync_leanok` (sorry present), but `\leanok` does not validate the statement content.
- **Excuse-comment**: Lean docstring contains: "the additional projective / smooth / Plücker structure is implicit in the construction and is iter-177+ refinement work (once the proof body lands)." This is an explicit excuse-comment for the weakened statement.
- **Notes**: The blueprint's own NOTE (proof section) describes the technical blocker: `thm:relative_spec_univ` provides only `IsAffineHom (structureMorphism A)`, strictly weaker than a `Functor.RepresentableBy` witness. The blocker is real, but the correct response is to gate the statement on a sorry until the stronger statement can be typed — not to file a weaker statement with an excuse-comment. The current Lean statement is not a skeleton of the blueprint statement; it is a structurally different, weaker claim.

---

## Red Flags

### Must-Fix-This-Iter: Weakened statement

**`Grassmannian.representable` (line 225):** Lean statement is structurally weaker than the blueprint text claims — drops smoothness, projectivity, relative dimension `d(r-d)`, tautological quotient `π* V ↠ U`, Plücker embedding, and the rank hypothesis `1 ≤ d ≤ r`. The Lean docstring contains an explicit excuse-comment ("iter-177+ refinement work"). The blueprint declares a full geometric theorem; the Lean has a placeholder skeleton that is neither mathematically equivalent nor a strengthening of the blueprint statement.

**Required action:** Either (a) strengthen the Lean statement to include the missing geometric content (smoothness, projectivity, rel-dim, tautological quotient, Plücker), accepting that the proof body will be a longer-horizon sorry, OR (b) explicitly introduce a weaker `Grassmannian.representable_exists` skeleton separate from the full `Grassmannian.representable` statement that the blueprint pins, so the pin is not corrupted. Do NOT leave the blueprint `\lean{...}` pointing to a declaration whose statement does not match the blueprint text.

### Major: Missing rank/freeness hypotheses

**`Grassmannian` def (line 198) and `QuotFunctor` def (line 161):** Both take `_V : S.Modules` (or `_L : X.Modules`) without the locally-free/line-bundle type constraint that the blueprint prose requires. These are documented skeleton simplifications, but the declarations are registered as sorry-skeletons with `\leanok`, meaning the blueprint will eventually point at these signatures as final. The missing hypotheses should be part of the planned iter-177+ statement refinement.

### Minor: Missing proof-block `\leanok`

**`lem:annihilator_localization_eq_map`** (blueprint line 670 proof block): The Lean proof of `Module.annihilator_isLocalizedModule_eq_map` is sorry-free and axiom-clean (LSP-verified: only `propext`, `Classical.choice`, `Quot.sound`). The blueprint's `\begin{proof}...\end{proof}` block carries no `\leanok`. Per the protocol, a closed proof block should receive `\leanok` from `sync_leanok`. Either `sync_leanok` has not run since this proof was completed, or the proof block structure prevents `sync_leanok` from matching it. The plan agent should verify that `sync_leanok` picks this up in the next run.

### Minor: Unresolved `\lean{}` targets for private helpers

The graded Hilbert–Serre engine (`rationalHilbert_antidiff`, `IsRatHilb`, `IsRatHilb.ofDiffEq`, etc.) is formalized at lines 430–612, sorry-free, as `private` declarations. The blueprint has no `\lean{...}` blocks for these (correctly, since they are private). The blueprint NOTE on `lem:gradedHilbertSerre_rational` accurately describes their status. However, the NOTE references `rationalHilbert_antidiff` and `IsRatHilb.ofDiffEq` by name — these could be promoted to `\lean{...}` blocks if/when they become public. Informational only.

---

## Unreferenced Declarations (informational)

| Declaration | Line | Status |
|---|---|---|
| `Scheme.Modules.annihilator_ideal_le` | 305 | Helper for `annihilator`; proves `≤` direction of the characterization. No `\lean{...}` in blueprint. Should arguably have a block since it's the only landed half of `annihilator_ideal`. Minor omission. |
| `Scheme.Modules.schematicSupportι` | 320 | Canonical closed immersion of the schematic support into `X`. Blueprint `def:schematic_support` describes it as "equipped with its canonical closed immersion"; `\lean{...}` only references `schematicSupport` (the scheme), not `schematicSupportι` (the morphism). The def is incomplete without the morphism. Blueprint should add `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupportι}` to `def:schematic_support`. |
| All `IsRatHilb.*` private helpers | 534–611 | Private; intentionally not blueprint-referenced. Accurately described in blueprint NOTE on `lem:gradedHilbertSerre_rational`. |
| `coeff_invOneSubPow_one_mul` | 430 | Private; support lemma for `rationalHilbert_antidiff`. |

---

## Blueprint Adequacy for This File

- **Coverage**: 9 of 15 project-side `\lean{...}` targets exist in the Lean file. 6 are absent and correctly unformalized (no `\leanok`). There are no cases where `\leanok` is set on a block whose Lean target is missing.
- **Proof-sketch depth**: **adequate for landed declarations**. The blueprint proofs for `lem:annihilator_localization_eq_map`, `lem:gradedHilbertSerre_rational`, and `thm:hilbertPoly_of_sectionModule` are detailed and faithful; the Lean prover clearly used them. The LEAN SIGNATURE comments in the blueprint are precise.
- **Hint precision**: **precise for landed declarations**. The `ofIdeals` encoding strategy for `annihilator`, the `IsLocalizedModule`/`IsLocalization` abstract form for `annihilator_isLocalizedModule_eq_map`, and the `PowerSeries.invOneSubPow` shape for the graded Hilbert–Serre lemma are all pinned correctly.
- **Generality**: **adequate**. The project-built primitives (`annihilator`, `schematicSupport`, `HasProperSupport`, `IsLocallyFreeOfRank`) are at the right generality. The main gap is in the 6 missing declarations, which are blocked on Mathlib rather than blueprint under-specification.
- **Blueprint adequacy for `Grassmannian.representable` statement**: **inadequate as written** — the blueprint prose pins a full geometric theorem (smooth, projective, relative dimension, Plücker) but the blueprint does not have a weaker fallback `\lean{...}` block for the skeleton. This forces the Lean to silently weaken the statement. The blueprint should either (a) introduce a two-level structure (`Grassmannian.representable_basic` for the skeleton + `Grassmannian.representable` for the full statement) or (b) add a clearer NOTE on the statement block explaining what the `\lean{...}` hint is authorizing at this iter.
- **Recommended chapter-side actions:**
  1. Add `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupportι}` to `def:schematic_support` (the canonical immersion is half the definition).
  2. Add `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_ideal_le}` as a helper block under `def:modules_annihilator`.
  3. On `thm:grassmannian_representable`: either (a) split the statement into a skeleton-appropriate weaker claim with its own `\lean{...}` and a full claim marked as future work, or (b) annotate the `\lean{...}` hint with a NOTE that the current Lean decl is a weaker skeleton — so the `\lean{...}` target is not expected to match the prose until iter-177+.

---

## Severity Summary

| Finding | Severity | Declaration |
|---|---|---|
| Lean statement for `Grassmannian.representable` drops smooth/projective/rel-dim/tautological-quotient/Plücker vs. blueprint prose; excuse-comment present | **must-fix-this-iter** | `Grassmannian.representable` (line 225) |
| `Grassmannian` def missing `IsLocallyFreeOfRank V`, rank `r`, and `1 ≤ d ≤ r` hypothesis | **major** | `Grassmannian` (line 198) |
| `QuotFunctor` def: `_L` typed as generic `X.Modules` not line bundle | **major** | `QuotFunctor` (line 161) |
| Blueprint proof block for `lem:annihilator_localization_eq_map` missing `\leanok` despite sorry-free Lean proof | **minor** | blueprint proof block (line 670) |
| `schematicSupportι` unreferenced in blueprint despite being half of `def:schematic_support` | **minor** | `schematicSupportι` (line 320) |
| 6 `\lean{...}` targets absent from Lean file — all correctly unformalized (no `\leanok` set) | **informational** | `sectionGradedRing`, `sectionGradedModule`, `sectionGradedModule_fg`, `gradedHilbertSeries_rational`, `hilbertPolynomialOfSectionModule`, `isLocalizedModule_basicOpen` |

**Overall verdict:** The file faithfully implements all landed declarations — `annihilator`, `schematicSupport`, `HasProperSupport`, `IsLocallyFreeOfRank`, and the complete `Module.annihilator_isLocalizedModule_eq_map` proof (axiom-clean) — but `Grassmannian.representable` carries a weakened statement that does not match the blueprint's prose and must be corrected before this declaration can be used as a foundation for downstream work.
