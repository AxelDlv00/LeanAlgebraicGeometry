# Blueprint Review Report

## Slug
iter002

## Iteration
002

## Top-level summaries

### Incomplete parts

- `Cohomology_AcyclicResolution.tex` / `lem:acyclic_dimension_shift`: proof sketch is entirely LES/δ-functor-based (`"the short exact sequence ... induces, via the δ-functor (long exact sequence) structure of the right-derived functors {R^k G}_{k≥0}, the long exact cohomology sequence"`). Mathlib exposes no such LES for `Functor.rightDerived`. The comparison-of-resolutions route intended for Lean is absent from this sub-lemma's proof entirely.
- `Cohomology_AcyclicResolution.tex` / `lem:acyclic_resolution_computes_derived`: main proof body is a dimension-shift induction that calls `lem:acyclic_dimension_shift` repeatedly, making it equally LES-dependent. The comparison-of-resolutions route (choose injective resolution I•, compare J• to I• up to homotopy, transport via `isoRightDerivedObj`) appears only in a closing parenthetical remark, not in the actual proof text a prover would follow.

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:push_pull_unit_mate`: proof body says "Proved directly in Lean." with no route/tactic guidance; Lean declaration exists but has `sorry`.
- `Cohomology_CechHigherDirectImage.tex` / `lem:push_pull_transport_cancel`: same — "Proved directly in Lean." with sorry in Lean. The detailed statements are likely sufficient for a skilled prover, but there is no sketch of the rewriting path.

### Citation discipline

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis`: `% SOURCE QUOTE:` is absent for the statement block. The `% SOURCE:` note explicitly acknowledges: "the standalone statement is in the Stacks 'Cohomology' chapter, not in the local Cohomology-of-Schemes file; the verbatim text quoted below is its application..." — retrieval gap. The `% SOURCE QUOTE PROOF:` (quoting the proof's application context) is present and is verbatim. **Retrieval needed** for `cohomology-lemma-cech-vanish-basis` verbatim statement text.

### Dependency & isolation findings

**Isolated nodes (4 total — all lean_aux):**
All four isolated nodes are `lean_aux` type with no associated chapter. These are uncovered Lean helper declarations, not blueprint nodes. **keep** — no blueprint action required; they represent Lean-level private helpers that happen not to surface in the blueprint DAG.

**Missing `\uses{}` edges:**
- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_term_pushforward_acyclic`: proof uses (a) "the derived pushforward R^k f_* G is the sheaf associated to the presheaf V ↦ H^k(f^{-1}(V), G|_{f^{-1}(V)})" (Stacks `cohomology-lemma-describe-higher-direct-images`), and (b) the Grothendieck composition-spectral-sequence degeneration for `f ∘ j_s` when `j_s` is an affine morphism. Neither appears in `\uses{}` and neither has a separate blueprint declaration. **wire-up** — add a `\mathlibok` anchor for the presheaf description of higher direct images (if Mathlib has it), or promote to a sub-lemma; the composition degeneration step should similarly be isolated. **soon severity** (P5 lane not active this iter).

**Unmatched `\lean{}` (leandag report):** 11 entries. The 3 `\mathlibok` anchors are expected (Mathlib declarations, not local files). The remaining 8 are project-local declarations not yet formalized — normal for the active development phase. No action needed from this reviewer.

**Broken `\uses{}` cross-references:** none (`unknown_uses: []`).

---

## Mathlib anchor faithfulness (Focus area 3)

All three `\mathlibok` anchors in `Cohomology_AcyclicResolution.tex` are **FAITHFUL**:

| Blueprint label | `\lean{}` claim | Mathlib status | Form |
|---|---|---|---|
| `lem:right_derived_injective_resolution` | `CategoryTheory.InjectiveResolution.isoRightDerivedObj` | EXISTS — `Mathlib.CategoryTheory.Abelian.RightDerived` | Definition; given `I : InjectiveResolution X` and additive `F`, provides `(F.rightDerived n).obj X ≅ H^n(F applied to I.cocomplex)`. Matches blueprint's stated form. |
| `lem:right_derived_vanishes_injective` | `CategoryTheory.Functor.isZero_rightDerived_obj_injective_succ` | EXISTS — same module | Theorem; for injective `X`, `IsZero ((F.rightDerived (n + 1)).obj X)`. Matches blueprint exactly (index-shifted form matching the `succ` suffix). |
| `lem:right_derived_zero_iso_self` | `CategoryTheory.Functor.rightDerivedZeroIsoSelf` | EXISTS — same module | Definition; `F.rightDerived 0 ≅ F` under `[F.Additive] [PreservesFiniteLimits F]`. Blueprint states "if G is left exact (preserves finite limits)" — `PreservesFiniteLimits` is exactly the Mathlib spelling of left-exact, so the form matches. |

---

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex

- **complete**: true
- **correct**: partial
- **notes**:
  - **MUST-FIX (blueprint↔route mismatch — blocks P4)** — `lem:acyclic_dimension_shift` / proof: The proof is exclusively a long-exact-sequence argument (`"... via the δ-functor (long exact sequence) structure of the right-derived functors {R^k G}_{k≥0}, the long exact cohomology sequence in B: 0 → G(A) → G(J) → G(Z) → R^1G(A) → ..."`). Strategy P4 explicitly records that Mathlib has NO LES / δ-functor for `Functor.rightDerived`. A Lean prover following this proof will attempt to construct LES infrastructure that does not exist. The comparison-of-resolutions route (comparison J• → I•; `isZero_rightDerived_obj_injective_succ` makes injectives acyclic; transport via `isoRightDerivedObj`) is the only feasible Lean route, and it is entirely absent from this sub-lemma's proof. The proof block must be **replaced** with the comparison route; or the sub-lemma must be **eliminated** and `lem:acyclic_resolution_computes_derived` restructured to avoid it.
  - **MUST-FIX (consequential)** — `lem:acyclic_resolution_computes_derived` / proof: the main proof body performs a dimension-shift induction that calls `lem:acyclic_dimension_shift` at every inductive step. The closing parenthetical remark correctly identifies the comparison route ("choosing an injective resolution I• of A, comparing it with the acyclic resolution J• up to homotopy, and using lem:right_derived_vanishes_injective to see that injective objects are themselves right-G-acyclic") but this is a footnote, not the proof. The remark must be **promoted** to the main proof body, replacing or superseding the dimension-shift induction.
  - **Recommended rewrite direction**: the comparison-of-resolutions proof of `lem:acyclic_resolution_computes_derived` is self-contained and does not require `lem:acyclic_dimension_shift`: (1) fix an injective resolution `I•` of `A` via `HasInjectiveResolutions`; (2) each `I^n` is injective hence right-`G`-acyclic by `lem:right_derived_vanishes_injective`; (3) construct a comparison map `J• → I•` using injectivity of `I^n`; (4) show `G(J•) → G(I•)` is a quasi-isomorphism using that `G(J^n) ≅ (R^0 G)(J^n) = J^n`'s acyclicity kills the mapping cone; (5) transport via `isoRightDerivedObj`. The writer should either restructure the chapter around this direct proof or add a replacement sub-lemma with a comparison-route proof.
  - **Observation**: `def:right_acyclic` and the Mathlib anchors are self-consistent; the definition section and Mathlib dependency section are complete and correctly sourced.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: true
- **correct**: partial
- **notes**:
  - **Drives partial verdict (soon severity — P5 lane not active)** — `lem:cech_term_pushforward_acyclic` / `\uses{}`: proof invokes two steps not listed in `\uses{}` and not separately blueprinted: (a) the identification R^k f_* G = sheafification of V ↦ H^k(f^{-1}(V), G) (Stacks `cohomology-lemma-describe-higher-direct-images`), and (b) the Grothendieck composition-spectral-sequence degeneration for `f ∘ j_s` when `j_s` is affine. **wire-up** — before P5 prover dispatch, add a `\mathlibok` anchor for the presheaf description and an explicit sub-lemma (or inline note citing the Mathlib declaration) for the composition formula.
  - **Drives partial verdict (soon severity — P3 lane not active)** — `lem:cech_to_cohomology_on_basis` / citation: `% SOURCE QUOTE:` for the statement block is absent (acknowledged by the writer: "standalone statement not yet retrieved"). Before P3 prover dispatch, dispatch a reference-retriever for Stacks `cohomology-lemma-cech-vanish-basis` verbatim statement and add the `% SOURCE QUOTE:`.
  - **P1 gate assessment** (`lem:push_pull_comp` → `AlgebraicGeometry.pushPullMap_comp`): The sub-graph feeding this target is clean. `def:push_pull_obj`, `def:push_pull_map` are matched and `\leanok`. `lem:push_pull_unit_mate` (`pushPull_unit_mate`) and `lem:push_pull_transport_cancel` (`pushPull_transport_cancel`) are matched in Lean (not in `unmatched_lean`) with sorry bodies; `lem:push_pull_id` (`pushPullMap_id`) likewise matched with sorry. The blueprint proof of `lem:push_pull_comp` itself is well-specified: route via `conjugateEquiv_comp` + injectivity of the conjugate bijection → `pseudofunctor_associativity`; the two pre-coherence sub-lemmas are identified and their Lean names given. **The partial verdict is driven by P3/P5 issues only. The plan agent may use the same-iter fast-path: dispatch a blueprint-writer scoped to `lem:cech_term_pushforward_acyclic` (wire-up + sub-lemma) and `lem:cech_to_cohomology_on_basis` (SOURCE QUOTE retrieval), then a scoped re-review of those two nodes. If that re-review returns correct: true, the P1 prover may dispatch this iter.**
  - **Informational** — `lem:push_pull_unit_mate`, `lem:push_pull_transport_cancel` proof sketches: "Proved directly in Lean." with sorry in Lean; no tactic/rewrite path given. The detailed statements are sufficient for a prover to attempt closure; the missing guidance is a quality issue only. Recommend the P1 prover objective include closing these two along with `pushPullMap_comp`.
  - **Affine acyclicity gaps (P3) are honest**: `lem:cech_acyclic_affine` proof correctly notes "This proof depends on the following currently-absent Mathlib infrastructure: the explicit description of the standard-cover Čech complex as the complex of localisations ... together with the prime-local, module-level contracting homotopy ... neither of which is available for sheaves of modules on a scheme." This is an accurate and adequately-documented gap for a P3 prover to address.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

---

## Severity summary

**must-fix-this-iter:**

1. `Cohomology_AcyclicResolution.tex` / `lem:acyclic_dimension_shift` — **blueprint↔Lean-route mismatch**: proof prose requires LES/δ-functor structure for `Functor.rightDerived`; Mathlib has none. A prover following this proof pursues unavailable infrastructure. Dispatch blueprint-writer with directive: replace the LES-based proof with the comparison-of-resolutions argument (compare J• to injective I•, use `isoRightDerivedObj` and `isZero_rightDerived_obj_injective_succ`), or eliminate the sub-lemma and restructure the main theorem proof around the comparison route directly. **Blocks P4 prover dispatch.**

2. `Cohomology_AcyclicResolution.tex` / `lem:acyclic_resolution_computes_derived` — **consequential must-fix**: proof body is the dimension-shift induction calling `lem:acyclic_dimension_shift`; closing remark identifying the comparison route must be promoted to the proof body. Fixed by the same writer directive as finding 1.

3. `Cohomology_CechHigherDirectImage.tex` — `correct: partial` due to P3/P5 missing-edge and citation findings: under the HARD GATE rule the P1 gate does not auto-clear. Plan agent must take the **same-iter fast-path** (scoped writer on `lem:cech_term_pushforward_acyclic` + `lem:cech_to_cohomology_on_basis`, then scoped re-review) to enable P1 prover dispatch this iter.

**soon:**

4. `Cohomology_CechHigherDirectImage.tex` / `lem:cech_term_pushforward_acyclic` — missing `\uses{}` edges for presheaf description of R^k f_* and Grothendieck composition degeneration; **wire-up** before P5 prover dispatch.

5. `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis` — missing `% SOURCE QUOTE:` for statement block; dispatch reference-retriever for Stacks `cohomology-lemma-cech-vanish-basis` verbatim text before P3 prover dispatch.

**informational:**

6. `Cohomology_CechHigherDirectImage.tex` / `lem:push_pull_unit_mate`, `lem:push_pull_transport_cancel` — proof sketches "Proved directly in Lean." with sorry bodies; no tactic guidance. Statements are detailed enough for a skilled prover; recommend the P1 prover objective include closing these.

---

Overall verdict: 3 chapters audited; `Cohomology_AcyclicResolution.tex` has a blocking blueprint↔Lean-route mismatch on `lem:acyclic_dimension_shift` and `lem:acyclic_resolution_computes_derived` (LES-based proof vs comparison-of-resolutions route) that must be fixed before P4 prover dispatch; all three Mathlib anchors are faithful; `Cohomology_CechHigherDirectImage.tex` has P3/P5 correctness gaps (missing `\uses{}` wire-up, missing citation SOURCE QUOTE) that technically prevent auto-clearing the P1 HARD GATE but are amenable to same-iter fast-path resolution; `Cohomology_HigherDirectImage.tex` is clean; 0 unstarted-phase proposals (all 5 phases have blueprint coverage).
