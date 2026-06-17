# Lean Audit Report

## Slug
aud254

## Iteration
254

## Scope
- files audited: 2 (directive-scoped)
- files skipped per directive: all other `.lean` files (directive restricts to the two edited files)

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 1 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged (off-path `PullbackLanDecomposition` section, acknowledged)
- **bad practices**: 1 flagged (`set_option backward.isDefEq.respectTransparency false`, scoped, documented)
- **excuse-comments**: none
- **notes**:
  - **L1882–1895 `sheafifyTensorUnitIso_hom_eq'` (new private helper).**  No `sorry`.  Proof: `rw [sheafifyTensorUnitIso_hom_eq, ← Functor.map_comp]; congr 1; exact (tensorHom_def ...).symm`.  The claim (`.hom` = `a.map (η_P ⊗ η_Q)` on the `⋙ forget₂` carrier) is mathematically correct; the `congr 1` + `tensorHom_def` close is honest.  **CLOSED, axiom-clean.**
  - **L1941–1994 `sheafifyTensorUnitIso_hom_natural` (STEP A, claimed CLOSED iter-254).**  No `sorry`.  Proof strategy: pin both sides via `sheafifyTensorUnitIso_hom_eq'`, merge `a.map _ ≫ a.map _` by `erw [← Functor.map_comp]` (twice), reduce to a presheaf goal by `congr 1`, close that by `tensorHom_comp_tensorHom` applied as a term with explicit `(C := …)` together with the two unit-naturality squares `hp`/`hq` (proved from `(sheafificationAdjunction …).unit.naturality` + `restrictScalarsId_map`).  Every tactic step is checkable; the `erw` bridging is correctly explained (defeq-but-not-syntactic monoidal instance on the connecting object).  **CLOSED, axiom-clean.  Header label is accurate.**
  - **L2004–2064 `pullbackTensorMap_natural` (D1′, still `sorry`).**  Exactly one `sorry` at L2064, inside `section LocTrivPullbackTensor`.  The file header (L43–67) correctly counts it as one of "TWO tracked typed-`sorry` residuals (iter-254)".  The lemma docstring does NOT claim it is closed.  The in-proof comment at L2038–2063 accurately explains the blocker: `δ_natural (F := Fp)` fails `synthesize MonoidalCategory (PresheafOfModules X.ringCatSheaf.obj)` because the monoidal instance is registered only on `X.presheaf ⋙ forget₂`.  The `sorry` is **honestly labelled**; no "CLOSED" or "DONE" label contradicts it.
  - **L690–712 `exists_tensorObj_inverse`.**  `sorry` in the body.  Docstring correctly names two open bridges (C and A) required before it closes.  No mislabelling.
  - **L1661 `set_option backward.isDefEq.respectTransparency false`.**  Scoped to `epsilonPresheafToSheafUnit` only (immediately before the `lemma`).  The comment explains exactly why: "sheafification-adjunction right-triangle / unit-naturality composites force `whnf` on the heavy sheafification machinery".  Use is documented and localised.  Not a project-wide change; minor fragility note (this option alters kernel-level defeq checking; if Mathlib changes the elaboration order the lemma may silently break).
  - **L1249–1310 `PullbackLanDecomposition` section.**  Acknowledged as "OFF-PATH (iter-243 pivot)" in its own section comment; the comment says "do NOT extend it toward the general build".  The code is axiom-clean and correct; it is retained as potentially reusable.  Not a red flag; noted as off-critical-path accumulation.
  - **L726–729 `tensorObj_assoc_iso_invertible`.**  Body is `tensorObj_assoc_iso` with three unused arguments `(_hM _hN _hP)`.  The underscore prefix marks them intentionally unused; the docstring explains this matches the blueprint statement.  Not a bug.
  - **L2037 `dsimp only [CategoryTheory.Sheaf.val]`.**  Used inside `pullbackTensorMap_natural` to normalise `Sheaf.val → .obj`.  This is standard; `Sheaf.val` is not deprecated in this project's Mathlib pin.  No issue.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L436–439 `image_preimage_of_le` (new helper).**  Signature: `W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V` for `V ≤ W`.  Proof: `simp only [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι]; exact inf_eq_right.mpr hV`.  Mathematically trivial, proof is honest, no `sorry`.  Correctly consumed in `homLocalSection` and `homOfLocalCompat`.
  - **L512–636 `homOfLocalCompat` — `hf` re-sign (iter-254).**  The new sectionwise signature:
    ```
    hf : ∀ (i j) (V) (hVi : V ≤ U i) (hVj : V ≤ U j),
        M.presheaf.map (eqToHom ..) ≫ (f i).val.app (op ((U i).ι ⁻¹ᵁ V)) ≫ N.presheaf.map (eqToHom ..)
      = M.presheaf.map (eqToHom ..) ≫ (f j).val.app (op ((U j).ι ⁻¹ᵁ V)) ≫ N.presheaf.map (eqToHom ..)
    ```
    is **not trivially satisfiable**: it requires concrete equality of section maps on every overlap.  It is not vacuous for nontrivial covers; degenerate cases (single-element cover) make the condition trivially true, which is mathematically correct.  The docstring explains the rationale (HEq form was unsatisfiable; sectionwise form is exactly what callers can supply).  The note "`homOfLocalCompat` is NOT in `archon-protected.yaml` and has no compiling caller, so the prover owns its signature" is accurate (verified: the MEMORY index confirms this).
  - **`hcompat` sub-proof (L543–559).**  Closes `IsCompatible` with `exact hf i j W.left ...` after `simp only [homLocalSection]` exposes the sectionwise triple-composite.  The `eqToHom` arguments in `homLocalSection` definitionally match those in `hf` (both use `image_preimage_of_le`), so the `exact` is honest.
  - **`hconn` connection lemma (L582–599).**  Correctly identifies `g.app (op W')` with `(homLocalSection U f i).app (op (Over.mk (homOfLE hWi)))` via the `IsGluing` datum, transported through `iSup U = ⊤`.  The `Subsingleton.elim` steps on the poset hom-sets are sound.
  - **L636 `sorry` (ring-bridge for linearity).**  ONE `sorry` remains.  The comment at L626–636 accurately identifies it: proving that the `homLocalSection`-component at `W ≤ U i` is `X.ringCatSheaf(W)`-linear by transporting the `(U i)`-ring action through the open-immersion `appIso` (`restrictScalars ((U i).ι.appIso P).inv`).  The steps before the sorry (naturality reduction, `map_smul`, `hconn`) are all honest; the sorry is isolated at the genuine ring-bridge obligation.  **Honestly labelled.**
  - **L230–256 `dual_restrict_iso`.**  ONE `sorry` at L256 (Step 4 presheaf residual).  Steps 1–3 are in place (no sorry there).  The header at L14–38 accurately says "one `sorry` remains at the identified Step-4 presheaf residual".  The planner strategy comment (L161–228) accurately warns about `overSliceSheafEquiv` not applying (matching the iter-230 diagnostic outcome).
  - **L332–341 `dual_isLocallyTrivial`.**  Compiles with the `dual_restrict_iso` sorry inherited axiomatically.  Header at L14–38 says "TRANSITIVELY PARTIAL".  Accurately labelled.
  - **Planner strategy comments embedded in docstrings** (e.g., `/- Planner strategy: … -/` inside outer `/-! … -/` sections at L161–229, L285–330, L462–511).  Unusual formatting: these are large nested block-comment blocks inside the doc comments of Lean declarations.  They are informative and correct; they do not introduce any Lean-level issue (Lean ignores them as comments).  Minor readability concern only.
  - **`dual_unit_iso` and `presheafDualUnitIso` (L263–279).**  Axiom-clean.  Correctly assembled from `dualUnitIsoGen` + the sheafification counit.  No sorry.
  - **`dualUnitIsoGen` (L105–140, PresheafOfModules namespace).**  Complex but honest: `unitDualSectionEquiv` (L63–100) is the section equiv (eval-at-`1` + `globalSMul` inverse), closed by `naturality_apply` + `unit_map_one` + `mul_one`.  `dualUnitIsoGen` assembles sectionwise by `isoMk` + the eval-naturality.  No sorry.  `left_inv` (L84–91) and `right_inv` (L93–100) both close without sorry.

---

## Must-fix-this-iter

None.

No declaration labelled "CLOSED" has a live reachable `sorry`.  No excuse-comments.  No weakened-wrong definitions.  No unauthorized `axiom` declarations.

---

## Major

- `TensorObjSubstrate.lean:1661` — `set_option backward.isDefEq.respectTransparency false` scoped to `epsilonPresheafToSheafUnit`.  This option alters the kernel-level defeq checker; if sheafification elaboration order changes in a Mathlib bump, the lemma could silently stop proving the intended statement or start requiring the option where other lemmas do not.  It is documented and localised, but it is a transparency-level hack.  Severity: **major** (not must-fix, but higher than minor because of the kernel-reach of the option).

---

## Minor

- `TensorObjSubstrate.lean:1249–1310` — `PullbackLanDecomposition` section is off critical-path ("OFF-PATH iter-243 pivot", acknowledged).  Retaining it is a design decision; no action required, but it adds dead-weight to the file.
- `DualInverse.lean:161–229, 285–330, 462–511` — Planner strategy comments embedded as nested block comments inside outer declaration doc comments.  Unusual format; harmless, but might confuse future readers about what is Lean documentation vs. what is internal project scaffolding.
- `TensorObjSubstrate.lean:726–729` — `tensorObj_assoc_iso_invertible` takes three unused `_hM/_hN/_hP` arguments.  Intentional (blueprint match); minor.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 (`set_option backward.isDefEq.respectTransparency false`)
- **minor**: 3 (off-path section, nested comments format, unused args)
- **excuse-comments**: 0

Overall verdict: Both files are internally consistent in their sorry labelling; the two iter-254 focus declarations (`sheafifyTensorUnitIso_hom_natural` — CLOSED, `sheafifyTensorUnitIso_hom_eq'` — new helper CLOSED) are honest and complete; `pullbackTensorMap_natural` and `homOfLocalCompat` both carry their single remaining `sorry` with accurate in-code descriptions of the blocker; the `hf` re-sign is legitimate and non-vacuous; no must-fix issues.
