# Lean Audit Report

## Slug
ts235

## Iteration
235

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (heavy `erw` throughout)
- **excuse-comments**: none

#### Notes

**Compilation status (LSP + grep):**
- `lean_diagnostic_messages`: no errors, no warnings, no infos — file compiles cleanly.
- `grep sorry|admit|native_decide|^axiom`: zero matches.
- `lean_verify` on `stalkTensorLinearMap`, `stalkTensorDesc`, `stalkTensorBilin_balanced`, `stalkTensorDescU_smul`: all return `["propext","Classical.choice","Quot.sound"]` only — no project-specific axioms.
- **The file is axiom-clean with 0 sorries.**

**Confirmation: the comment block at lines 397–420** (the `revBihom_balanced` gap description) is a pure comment — every line starts with `--`. There is **no** stubbed declaration, no `sorry`-gated definition, and no placeholder `def`. The gap is correctly documented without polluting the declaration namespace.

---

**Genuine constructions (new `private` block, lines 232–395):**

All ten new declarations are genuine, non-vacuous mathematical constructions:

1. **`revInnerLeg` (lines 232–241):** For fixed section `a : A(U)`, defines the additive map `B(V) → stalk(A⊗B)` sending `b` to `germ_{U⊓V}(a|_{U⊓V} ⊗ b|_{U⊓V})`. Genuine: the restriction maps and germ are explicit and non-trivial.

2. **`revInnerLeg_apply` (line 253):** Evaluation lemma proven by `rfl`. Justified because the body of `revInnerLeg` is given by that exact formula definitionally.

3. **`revInner` (lines 257–283):** `colimit.desc` over `B.stalk`. The cocone naturality sub-proof (lines 263–283) is substantive: it reduces the cocone condition to a section equality, applies `germ_res_apply` to a common intersection neighbourhood, then proves the tensor equality by `tensorObj_map_tmul` + `Functor.map_comp` on both factors independently. The `congr 1` applications are split first on the tensor product and then on a morphism in the `Opens X` poset (where morphisms are unique), so they are not escape hatches.

4. **`germ_revInner` (lines 287–291):** `colimit.ι_desc` — the universal property. Not vacuous.

5. **`revInner_germ` (lines 295–306):** Chains `comp_apply` + `germ_revInner` + `revInnerLeg_apply`. Correct.

6. **`revOuterLeg` (lines 312–328):** Additive map `A(U) → (B.stalk x →+ stalk(A⊗B))`. Additivity in `a` is checked on germ generators via `revInner_germ` + `TensorProduct.add_tmul`; zero is analogous. Both sub-proofs reduce to section-level identities using `_root_.map_add`/`map_zero` and tensor bilinearity. Non-trivial and correct.

7. **`revOuterLeg_apply` (lines 331–334):** `rfl`. Justified definitionally.

8. **`revBihom` (lines 339–369):** `colimit.desc` over `A.stalk`. Naturality sub-proof (lines 349–369) mirrors `revInner`'s: obtains a germ representative for the `B`-stalk argument, applies `revInner_germ` twice, rewrites via `germ_res_apply` to the common neighbourhood, then closes both tensor factors with `Functor.map_comp`. Sound.

9. **`germ_revBihom` (lines 372–375):** `colimit.ι_desc`. Not vacuous.

10. **`revBihom_germ_tmul` (lines 379–395):** Applies `germ_revBihom` (to get `revBihom (germ a) = revOuterLeg`) then `revInner_germ`. Correct chain; the proof is 6 lines and each step is justified.

**No declaration in the reverse-map block is degenerate, trivially vacuous, or a stand-in.**

---

**`erw` usage (bad-practices flag):**
The file uses `erw` at lines 83, 123–124, 146–147, 268–269, 275–282, 322–328, 355–368. All are driven by the `RingCat`/`CommRingCat` carrier-duality pattern: Lean cannot see that the `ModuleCat.restrictScalars`-carrier `S := (R ⋙ forget₂).obj (op U)` is defeq to the `CommRingCat`-carrier `↑(R.obj (op U))` for `simp`, requiring `erw` to force unification under the coercion. This is a known, documented pattern in the project (the file's own comment at lines 114–116 explains it for `stalkTensorDescU_smul`). The uses are individually justified, but a future Mathlib refactor of `ConcreteCategory.hom` or `ModuleCat.restrictScalars` could silently break them. No alternative is available without a heavier presheaf-module API.

**Module docstring workflow coupling (lines 23–24):**
> "This iteration builds the forward additive comparison map … see the handoff in `task_results`."

"This iteration" and "task_results" are Archon workflow terms with no meaning to a standalone reader of the Lean file. The mathematical content is correct; the workflow coupling is a cosmetic issue.

**In-source handoff comment (lines 397–420):**
The `-- **Stage (iv) remaining gap …**` block accurately describes the unproven `revBihom_balanced` and prescribes the tactic route for the next prover round. It is correctly NOT a declaration. However, embedding iteration-level workflow instructions in source comments couples source code to the loop's scheduling state. Once `revBihom_balanced` is proved and `stalkTensorRev` is defined, this block will be stale. Low severity now; becomes misleading if left after the proof lands.

---

## Must-fix-this-iter

*None.*

No sorries, no excuse-comments on declarations, no weakened/wrong definitions, no project-specific axioms, no placeholder bodies.

---

## Major

*None.*

---

## Minor

- `StalkTensor.lean:23–24` — Module docstring references "This iteration" and "`task_results`", coupling source code to Archon workflow vocabulary. Should be replaced with a static mathematical description of scope.
- `StalkTensor.lean:397–420` — In-source handoff comment describing the `revBihom_balanced` remaining obligation. Correct as a comment (not a declaration), and accurate, but will become stale once the proof lands; consider moving the technical note to `task_results` at that point.
- `StalkTensor.lean` (multiple sites) — Pervasive `erw` usage for `RingCat`/`CommRingCat` carrier duality coercions. Individually justified and documented; flagged as a maintenance fragility, not a correctness issue.

---

## Excuse-comments (always called out separately)

*None.* No declaration in the file has an attached excuse-comment ("placeholder", "temporary", "wrong but works", "TODO replace"). The comment block at lines 397–420 describes absent functionality, not wrong present functionality — it is not an excuse-comment.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: `StalkTensor.lean` is axiom-clean (standard axioms only, 0 sorries); all ten new `private` reverse-map declarations are genuine non-vacuous constructions with substantive cocone-naturality sub-proofs; the `revBihom_balanced` gap is correctly represented as a comment only, not a stubbed declaration; only minor cosmetic issues (workflow coupling in docstring, in-source handoff comment, `erw` fragility) remain.
