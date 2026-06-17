# Lean ↔ Blueprint Check Report

## Slug
dualinverse256

## Iteration
256

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (chapter: `\lem:sheafofmodules_hom_of_local_compat`)

- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.Modules.homOfLocalCompat` (DualInverse.lean, line 516)
- **Signature matches**: yes
  - Blueprint informal claim: X scheme, M N : X.Modules, indexed open cover {Ui}, local morphisms fi : M|_{Ui} → N|_{Ui}, such that fi and fj agree on Ui ∩ Uj → unique global f : M → N.
  - Lean signature uses exactly `(hU : ∀ x : X, ∃ i, x ∈ U i)` for the cover exhaustion and the sectionwise overlap hypothesis `(hf : ∀ i j V (hVi : V ≤ U i) (hVj : V ≤ U j), eqToHom-conjugated components of fi and fj agree at op ((Ui.ι ⁻¹ᵁ V)))`. Blueprint sub-step (a) explicitly endorses and defines this sectionwise form (lines 5881–5893). Match is correct.
- **Proof follows sketch**: yes
  - Blueprint's step (i): glue using `existsUnique_gluing` on the presheafHom sheaf → matches Lean's `H.existsUnique_gluing U (fun i => homLocalSection U f i)` (line 544).
  - Blueprint's sub-step (a) — `IsCompatible` via sectionwise `hf` → matches Lean's `hcompat` block (lines 547–563), which reduces to `hf i j W.left _ _` after unfolding `homLocalSection`.
  - Blueprint's sub-step (b) — convert amalgamated section to morphism via `presheafHomSectionsEquiv` / `sheafHomSectionsEquiv` → matches Lean's `topSectionToHom (hsup ▸ (hglue hcompat).choose)` (line 567); `topSectionToHom` wraps `presheafHomSectionsEquiv`.
  - Blueprint's sub-step (c.i) — M-leg via `Scheme.Modules.map_smul M` → Lean line 639 `erw [Scheme.Modules.map_smul M]`. ✓
  - Blueprint's sub-step (c.ii) — f-leg smul bridge: "restriction of scalars along the identity ring map returns the native action, identified by `ModuleCat.restrictScalars.smul_def` together with `Scheme.Opens.ι_appIso`" → Lean's `hbridge` (lines 650–657) uses `erw [ModuleCat.restrictScalars.smul_def']` + `simp [AlgebraicGeometry.Scheme.Opens.ι_appIso]`. ✓ (Note: blueprint says `smul_def`; Lean uses `smul_def'` — these are related primed variants.)
  - Blueprint's sub-step (c.iii) — N-leg via `Scheme.Modules.map_smul N` → Lean line 668 `erw [hfl_native, Scheme.Modules.map_smul N]`. ✓
  - Blueprint's sub-step (d) / scalar reconcile → Lean's `congr 1` + `Subsingleton.elim` closure (lines 672–683). ✓
  - Blueprint's step (ii) — `homMk` wrapper → Lean `homMk` at line 567. ✓
  - **One organizational divergence** (minor): the blueprint lists "(d) the recovery that g|_{Ui} = the underlying ab-sheaf morphism of fi" as a named sub-step (line 5942). In the Lean proof this is the `hconn` connection lemma (lines 586–603), which the proof uses in the body of step (c) rather than as a named separate step. The mathematical content is identical; the labeling differs.
- **notes**:
  - The proof comment in the Lean file (line 577) reads "the SOLE remaining sorry is the inner ring-bridge" — this comment is **stale** as of iter-256 (the ring-bridge is now closed). This is a leftover planning note inside the proof body. Classify: **minor** (stale comment, not an excuse-comment on a wrong body — the proof is axiom-clean).
  - Blueprint proof block (`\begin{proof}` at line 5824) lacks `\leanok` marker. Since the proof is now axiom-clean, `sync_leanok` should add it; if it has already run this iter and the marker is still absent, that is a gap to investigate.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `\lem:dual_restrict_iso`)

- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.Modules.dual_restrict_iso` (DualInverse.lean, line 233)
- **Signature matches**: yes
  - Blueprint: for an open immersion f : Y → X and M : X.Modules, canonical iso `(dual M).restrict f ≅ dual (M.restrict f)`.
  - Lean: `noncomputable def dual_restrict_iso {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules) : (dual M).restrict f ≅ dual (M.restrict f)`. ✓
- **Proof follows sketch**: partial / correct for implemented portion
  - Blueprint stages H1 + Steps 1–3 are implemented: Steps 1–3 (`restrictFunctorIsoPullback`, `sheafificationCompPullback`, strip outer sheafification; lines 237–243) and H1 (`pushforwardPushforwardAdj` + `leftAdjointUniq`; lines 247–257). ✓
  - Step 4 (legs A and B of the residual): `:= sorry` at line 259. The blueprint proof sketch correctly describes the intended route (slice-site Hom base-change for leg A, ring-iso reconciliation via `restrictScalarsRingIsoDualEquiv` for leg B), but this has not yet been implemented.
  - The proof is **correctly PARTIAL** in the Lean file.
- **notes**:
  - Blueprint statement block has `\leanok` (line 5461) — correct, the declaration exists with a sorry body.
  - Blueprint proof block lacks `\leanok` — correct, proof is incomplete.
  - The blueprint prose does NOT use an explicit "PARTIAL" or "INCOMPLETE" annotation in the proof block itself, but the absence of proof `\leanok` is the canonical signal in this project's system. The section-level "Status: deferred, off the group's critical path." (line 4880) also signals deferral.
  - The Lean planner-strategy comment inside the docstring (lines 164–231) records the `:= sorry` residual and warns about the overSliceSheafEquiv inapplicability. These are correctly maintained planning notes, not excuse-comments on a complete proof.
  - The Lean `hf` re-sign note inside the `homOfLocalCompat` docstring (lines 458–463) correctly documents why the `HEq` form was abandoned in favor of the sectionwise form; this matches the blueprint's sub-step (a) discussion (lines 5895–5908).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` (chapter: `\lem:scheme_modules_hom_local_section`)

- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.Modules.homLocalSection` (DualInverse.lean, line 358)
- **Signature matches**: yes — produces `(presheafHom M.val.presheaf N.val.presheaf).obj (op (U i))` from `fi : M.restrict (U i).ι ⟶ N.restrict (U i).ι`, conjugated by eqToHom. Matches blueprint (lines 5765–5778). ✓
- **Proof follows sketch**: yes — naturality closed by `Subsingleton.elim` on thin-poset hom-sets (lines 369–407). Blueprint (lines 5794–5806) says exactly this. ✓
- **notes**: Statement block in blueprint has `\leanok` (line 5759). No sorry in the Lean proof. ✓

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` (chapter: `\lem:dual_unit_iso`)

- **Lean target exists**: yes — `Scheme.Modules.dual_unit_iso` (DualInverse.lean, line 277)
- **Signature matches**: yes — `dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf`. Blueprint (lines 5603–5617): `dual O_Y ≅ O_Y`. ✓
- **Proof follows sketch**: yes — sheafification of presheaf-level evaluation-at-1 iso (`presheafDualUnitIso`) + sheafification counit. Blueprint describes this route. ✓ Axiom-clean (no sorry).
- **notes**: Blueprint statement block has `\leanok` (line 5603). ✓

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `\lem:dual_isLocallyTrivial`)

- **Lean target exists**: yes — `dual_isLocallyTrivial` (DualInverse.lean, line 335)
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L) : LineBundle.IsLocallyTrivial (dual L)`. ✓
- **Proof follows sketch**: partial — three-step chain `dual_restrict_iso ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` is assembled and compiles (line 344); transitively sorry-bearing because `dual_restrict_iso` has Step-4 sorry. Blueprint proof describes the same three-step chain (lines 5666–5689). ✓
- **notes**: Blueprint statement block has `\leanok` (line 5637). Proof block lacks `\leanok` (correct — transitively sorry-bearing). ✓

---

## Red flags

### Stale inline comment (minor)

- `DualInverse.lean:573–576`: Comment says "the SOLE remaining sorry is the inner ring-bridge (linearity of the homLocalSection-component...)" inside the proof of `homOfLocalCompat`. This was accurate during earlier iterations but is now stale — the ring-bridge was closed in iter-256, and the proof is axiom-clean. The comment is a leftover planning note, **not** an excuse-comment on a wrong body; the proof is correct. Severity: **minor**.

### Blueprint proof `\leanok` missing for `homOfLocalCompat` (minor)

- Blueprint proof block for `lem:sheafofmodules_hom_of_local_compat` (lines 5824+) lacks `\leanok`. Since `homOfLocalCompat` is now axiom-clean and sorry-free, `sync_leanok` should add this marker. If `sync_leanok` ran this iteration and the marker is still absent, investigate. Severity: **minor** (timing / sync issue, not a substantive blueprint inaccuracy).

---

## Unreferenced declarations (informational)

The following declarations in DualInverse.lean have no direct `\lean{...}` reference in the blueprint chapter. All are reasonable helpers:

- `PresheafOfModules.unitDualSectionEquiv` (line 66) — presheaf-level section equivalence feeding `dualUnitIsoGen`. Not substantive on its own; helper for `dual_unit_iso`.
- `PresheafOfModules.dualUnitIsoGen` (line 108) — presheaf-level `dual 𝟙_ ≅ 𝟙_`, general base category version. Feeds `presheafDualUnitIso` and `dual_unit_iso`. Blueprint describes the scheme-level result only.
- `Scheme.Modules.presheafDualUnitIso` (line 266) — specialization of `dualUnitIsoGen` to scheme context. Helper for `dual_unit_iso`.
- `topSectionToHom` (line 415) — converts a `presheafHom` top-section to a global morphism; wraps `presheafHomSectionsEquiv`. Blueprint references this step conceptually under sub-step (b) but does not pin it.
- `topSectionToHom_app` (line 428) — sectionwise characterization of `topSectionToHom`. Helper for `hconn`.
- `image_preimage_of_le` (line 439) — proves `W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V` for V ≤ W. Blueprint describes this open-set equality (the "down-set identity") as a key piece of the construction but does not pin a standalone lemma for it.

None of these warrant a substantive blueprint block; they are appropriately helper-only.

---

## Blueprint adequacy for this file

- **Coverage**: 5/5 principal `\lean{...}`-referenced declarations have corresponding blueprint blocks (`homOfLocalCompat`, `dual_restrict_iso`, `homLocalSection`, `dual_unit_iso`, `dual_isLocallyTrivial`). 6 helper declarations are unreferenced — all clearly helper-only.
- **Proof-sketch depth**: **adequate**. The blueprintproof of `homOfLocalCompat` is notably detailed: it spells out the (a)/(b)/(c.i)/(c.ii)/(c.iii) decomposition, names the exact Mathlib lemmas (`ModuleCat.restrictScalars.smul_def`, `AlgebraicGeometry.Scheme.Opens.ι_appIso`, `Scheme.Modules.map_smul`, `presheafHomSectionsEquiv`, `existsUnique_gluing`), and explicitly addresses the HEq-vs-sectionwise design choice. The proof of `dual_restrict_iso` is an adequate sketch for Steps 1–3 + H1 (the implemented portion) and correctly describes legs (A)+(B) for the still-open Step 4.
- **Hint precision**: **precise**. All `\lean{...}` declarations exist with the correct names and namespace. The hint `smul_def` vs `smul_def'` is a minor variant (primed form); the mathematical content is the same.
- **Generality**: matches need. The blueprint's `homOfLocalCompat` is correctly formulated at full generality (arbitrary scheme, arbitrary indexed cover, sectionwise compatibility hypothesis).
- **Recommended chapter-side actions**:
  1. Remove or update the stale comment in `homOfLocalCompat`'s Lean proof body (line 573–576) — optionally reflected in the blueprint as a completed-proof note.
  2. Confirm that `sync_leanok` adds proof `\leanok` to the `lem:sheafofmodules_hom_of_local_compat` proof block.
  3. No structural blueprint changes needed for `dual_restrict_iso` — its partial state is correctly conveyed by the absence of proof `\leanok`.

---

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - Stale planning comment in `homOfLocalCompat` proof body (line 573–576) describing a sorry that no longer exists.
  - Missing proof `\leanok` on `lem:sheafofmodules_hom_of_local_compat` proof block (should be added by `sync_leanok`; verify it ran).

**Overall verdict**: `homOfLocalCompat` is axiom-clean and faithfully implements the blueprint's (a)/(b)/(c) decomposition including the `appIso`/`restrictScalars.smul_def'` bridge of sub-step (c.ii); `dual_restrict_iso` is correctly partial with its Step-4 sorry unambiguously represented; no signature mismatches, no placeholders on claimed-substantive results, no must-fix findings.
