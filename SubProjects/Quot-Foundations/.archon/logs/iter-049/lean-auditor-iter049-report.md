# Lean Audit Report

## Slug
iter049

## Iteration
049

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged
- **excuse-comments**: none
- **notes**:
  - **[minor] Lines 538–541, 2462–2485 — iter-journal entries in proof bodies.** Comments reading "iter-018 foundation (proved below …)", "SIGNATURE CORRECTNESS FIX (iter-023)" bake development-journal narrative into proof bodies rather than commit messages / task results. They are informative now but will silently become stale as iteration numbers lose meaning. They are NOT excuse-comments (the code they reference is genuinely closed), but they violate the audit rule "don't add comments that would not surprise a future reader".
  - **[minor] Line 1358 — `@[reducible]` on `pullbackModuleAddEquiv`.** The scalar-action record is declared `@[reducible]`, causing eager unfolding by the type-checker wherever the structure appears. This is an unusual choice for a `Module` instance constructor; it can silently slow down instance-search and unification in downstream proofs. No correctness risk, but the reducibility attribute was apparently chosen to make the scalar-tower proofs go through; that rationale belongs in a comment.
  - **Lines 483–485, 1462–1467, 1700–1703, 1821–1824 — raised heartbeat budgets.** Each is paired with an explanatory comment; all budgets are for deep `IsLocalization`/`OreLocalization` synthesis, not for masking proof complexity. Not flagged; documented correctly.
  - **Line 2526 — `sorry` in `genericFlatness`.** Honest sorry: paired with a detailed 70-line roadmap listing the two missing Mathlib bridges (G1 and G3) with counterexample, fix rationale, and route to closure. Not an excuse-comment; the code structure is non-vacuous and the gap is genuine Mathlib absence.
  - **New decl `gf_affine_finite_standard_subcover` (lines 2355–2378):** Genuine, non-vacuous. Hypotheses `hW : IsAffineOpen W` and `hcov : W ≤ ⨆ i, U i` are both load-bearing (used for `exists_basicOpen_le`, `self_le_iSup_basicOpen_iff`, `Ideal.span_eq_top_iff_finite`). Proof chain: point-wise `D(f x)` selection → span by `self_le_iSup_basicOpen_iff` → finite subcover by `Ideal.span_eq_top_iff_finite`. The `TopologicalSpace.Opens.mem_iSup` full-name usage (lines 2364, 2372) is correct per the known gotcha. Axiom-clean.
  - **New decl `gf_finite_gen_iff_free_epi` (lines 2390–2403):** Genuine iff statement between `GeneratingSections.IsFiniteType` and existence of a finite free epi. Forward direction reads off `σ.π`/`σ.epi`; backward direction roundtrips through `M.freeHomEquiv` with `Equiv.symm_apply_apply`. Both directions are trivially correct given the API. Universe `u` in `∃ (I : Type u)` matches `SheafOfModules.free I`. Axiom-clean.
  - **Long deferred block-comment in `genericFlatness` body (lines 2462–2526):** Honest. Documents the signature fix (iter-023), counterexample, fix rationale, route to closure, and two explicitly-named missing bridges. No laundering.

---

### AlgebraicJacobian/Picard/SectionGradedRing.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - **[minor] Lines 97–100, 108–110 — `@[simp]` on `private` lemmas.** `tensorPow_zero`, `tensorPow_succ`, `moduleTensorPow_zero` are tagged `@[simp]` but are also `private`. Lean 4 `@[simp]` on a `private` declaration is a no-op outside the defining module: the simp set in external files will not include these rules. Consumers of the public `tensorPow` / `moduleTensorPow` functions will not benefit from the simp automation and will have to write explicit `show` / `rw` steps. Benign for now (no external consumers yet, as `tensorPowAdd` is deferred), but the tag is misleading; either remove the `@[simp]` or remove the `private`.
  - **Private markings on 10 helpers:** All appropriate. `sheafification` and `MonoidalPresheaf` are implementation details; `unitModule` is an alias for `SheafOfModules.unit`; the four structural isos (`sheafificationCounitIso`, `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`) are internal launching-pad pieces for the deferred `tensorPowAdd`. None hide public API that external consumers require at this stage.
  - **New decl `sectionsMul` (lines 181–187):** Genuine. Domain type is the presheaf objectwise tensor product evaluated at `⊤` (which equals `Γ(X,F) ⊗_{Γ(X,𝒪_X)} Γ(X,G)` by the `PresheafOfModules.monoidalCategory` formula); codomain is `Γ(X, F ⊗ G)` (sheafified tensor product). Body applies the sheafification unit (not the counit) at the presheaf tensor product; this is exactly the lax-monoidal structure map and is axiom-clean.
  - **Absent `tensorPowAdd`:** Correctly absent rather than sorry'd. The DEFERRED block-comment is honest: it identifies the single missing ingredient (strong-monoidality of module sheafification / `MonoidalClosed (PresheafOfModules _)` Mathlib gap), documents both blocked routes, and confirms the launching pad is ready. No laundering.
  - **Universe handling in `sectionsMul`:** The type uses `MonoidalPresheaf X` (a `private abbrev`). Since this is a `noncomputable def`, Lean will print the expanded type in hover info. This is an implementation-level wart (private type in public signature) but not a correctness issue; the expanded type is well-formed and readable.

---

## Must-fix-this-iter

None.

No declaration has an excuse-comment, a weakened-wrong definition, a suspect body on a substantive claim, or a parallel API to an existing Mathlib construct. The single `sorry` (`genericFlatness`, line 2526) is an honest, thoroughly-documented gap backed by a counterexample proof of necessity.

---

## Major

None.

---

## Minor

- `FlatteningStratification.lean:538–541, 2462–2485` — iter-journal entries ("iter-018 foundation …", "SIGNATURE CORRECTNESS FIX (iter-023)") baked into proof bodies. Informative now; will silently date. Move iteration-specific narrative to commit messages / task results.
- `FlatteningStratification.lean:1358` — `@[reducible]` on `pullbackModuleAddEquiv`. No correctness risk; but the reducibility attribute is unexplained and could cause silent performance regressions in downstream proofs that accumulate these transport instances.
- `SectionGradedRing.lean:97–100, 108–110` — `@[simp]` on `private` lemmas `tensorPow_zero`, `tensorPow_succ`, `moduleTensorPow_zero`. The attribute is a no-op outside this module; misleading for anyone who later tries to add an external simp set.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: both files are in good standing — the two new declarations (`gf_affine_finite_standard_subcover`, `gf_finite_gen_iff_free_epi`) are genuine and axiom-clean, the ten newly-private helpers in `SectionGradedRing.lean` are appropriate for an in-progress API, and the single `sorry` in `genericFlatness` is an honest gap backed by a detailed counterexample and route-to-closure.
