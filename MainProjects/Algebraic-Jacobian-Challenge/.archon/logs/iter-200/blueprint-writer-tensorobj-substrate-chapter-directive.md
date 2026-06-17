# Blueprint writer directive — iter-200 slug tensorobj-substrate-chapter

## Iteration

200

## Target

Create a NEW blueprint chapter:

- Path: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
- Title: "Relative Picard sheaf — `Scheme.Modules.tensorObj` substrate (A.1.c.SubT)"
- `\input` it from `blueprint/src/content.tex` near the existing `Picard_RelPicFunctor` entry.

## Why now

iter-199 progress-critic `route199` returned Lane RPF **STUCK + OVER BUDGET**: file-level sorries 6 → 1 in iter-198 came entirely from 5 PLACEHOLDER bodies (constant-PUnit-functor / zero-AddMonoidHom / zero-NatTrans), not mathematical progress on the load-bearing `addCommGroup` body at L235 of `RelPicFunctor.lean`. L235 has been open for 10 iters against an original ~6-10 estimate. The primary corrective named by the critic is "Address deferred infrastructure" — open `Scheme.Modules.tensorObj` as an explicit tracked mathlib-build target with a concrete blueprint chapter and per-iter estimate.

The iter-199 review's MED-3 recommendation echoed this: "Lane RPF blueprint-writer for `Picard_TensorObjSubstrate.tex` (per iter-199 plan-agent deferral) before any Lane RPF prover re-engagement."

iter-200 plan-agent STRATEGY.md A.1.c.SubT row commits iter-201+ to a dedicated prover lane on the chapter you write this iter.

## Strategy context (the slice that matters)

The `addCommGroup` body at L235 of `Picard/RelPicFunctor.lean` is the only honest residual sorry in the file. It establishes that the relative Picard sheaf `Pic^♯_{(C/k)et} : (Sch/k)^op ⥤ Type` lifts to an `AddCommGroup`-valued functor — i.e., the étale-sheafified line-bundle-quotient functor is naturally an abelian group object in (Sch/k)-presheaves.

The mathematical content is straightforward: line bundles on `C ×_k T` form an `AddCommGroup` under tensor product (with inverses given by `(−)⁻¹` of an invertible sheaf); the pullback functor `π_T*` from `T` to `C ×_k T` is a group homomorphism; the quotient `Pic(C ×_k T) / π_T* Pic(T)` inherits the `AddCommGroup` structure; étale sheafification preserves abelian group objects.

The Mathlib-level obstruction is the absence of `Scheme.Modules.tensorObj`: the monoidal structure on `PresheafOfModules` exists in Mathlib (`Mathlib.CategoryTheory.Monoidal.PresheafOfModules`), but the lift to the scheme-level `Scheme.Modules` requires explicit construction of the relative tensor product of OX-modules on `Scheme`. This is roughly Stacks 03DM (relative tensor product) packaged into a Mathlib-style monoidal-category instance.

## Required chapter contents (mathematical detail to formalize)

### §1. Mathematical context
- The `addCommGroup` instance for `PicSharp` (Section title), motivated by Kleiman §4 Cor. `cor:repsh` (RelPic is a sheaf of abelian groups) + Nitsure §5.
- Cite-and-read: open `references/kleiman-picard-src/picard.tex` for the verbatim quote of `cor:repsh` and put it in `% SOURCE QUOTE:`. The chapter MUST satisfy the citation discipline in `.archon/prompts/plan.md` — every external statement needs `% SOURCE`, `% SOURCE QUOTE`, and `\textit{Source: …}`.

### §2. The Mathlib API survey
- `Mathlib.CategoryTheory.Monoidal.PresheafOfModules` — what monoidal structure exists at the presheaf level.
- `Mathlib.AlgebraicGeometry.Modules.Tilde` (and friends) — what scheme-level module API exists.
- The gap: `Scheme.Modules.tensorObj` as a named operation lifting `PresheafOfModules.tensorObj` along the `OnProduct` carrier (or via the relative-Spec construction).
- If you need to verify the present state of the Mathlib API, dispatch a `reference-retriever` child to download the relevant Mathlib source files into `references/`. Your write-domain includes `references/**` for this purpose.

### §3. The `Scheme.Modules.tensorObj` substrate
- Definition skeleton: given `M : Scheme.Modules X`, `N : Scheme.Modules X`, define `M ⊗_X N : Scheme.Modules X` via the OX-bilinear tensor product on local sections, glued across an affine cover.
- Functoriality: `(M, N) ⟼ M ⊗_X N` is a functor `Scheme.Modules X × Scheme.Modules X ⥤ Scheme.Modules X` and satisfies the unit/associativity/braiding axioms required by `Mathlib.CategoryTheory.Monoidal.Category.MonoidalCategory`.
- Project-side or Mathlib-upstream? The chapter must record that the project's choice is project-side (Mathlib upstream PR is acceptable but iter-201+ doesn't depend on the PR landing) — this is the iter-200 STRATEGY commitment.

### §4. The lift through `PresheafOfModules.OnProduct`
- The `OnProduct` carrier used by `RelPicFunctor.lean` packages `M ↦ (C ×_k T)`-section restricted along `π_T* M`.
- The monoidal structure on `PresheafOfModules` lifts to the `OnProduct` carrier provided the relative product `C ×_k T` and the pullback `π_T*` are functorial.
- Spell out the diagram: `(M ⊗_X N) restricted to OnProduct ≅ (M restricted to OnProduct) ⊗ (N restricted to OnProduct)`, where the latter tensor uses the `OnProduct`-level monoidal structure.

### §5. The `addCommGroup` instance for the RelPic sheaf
- With the substrate in place, the `addCommGroup` instance for `PicSharp` follows: tensor product of invertible sheaves is the group operation, `(−)⁻¹` is the inverse, the structure sheaf `O_{C ×_k T}` is the unit, and étale sheafification preserves all of this.
- Section ends with a TODO-list for the iter-201+ Lean prover lane (per-step LOC estimates).

### §6. Per-step LOC estimates and prover lane sequencing
- §3 definition skeleton + functoriality: ~80–120 LOC.
- §4 lift through `OnProduct`: ~60–100 LOC.
- §5 `addCommGroup` instance + invertible-sheaf inverse construction: ~60–100 LOC.
- Total: ~200–320 LOC project-side, conservatively budgeted ~200–400 LOC in STRATEGY.

## Lean pins

Pin the following declarations (declarations may not yet exist in Lean — pin them anyway so the iter-201+ prover lane has a target name):

- `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` — the substrate function
- `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` — functoriality
- `\lean{AlgebraicGeometry.Scheme.Modules.monoidalCategory}` — MonoidalCategory instance
- `\lean{AlgebraicGeometry.RelPicFunctor.PicSharp.addCommGroup_via_tensorObj}` — the consumer instance

(Adjust names as the writer sees fit; consistency with project namespace conventions matters more than the exact names above.)

## References

- Kleiman, "The Picard scheme" (FGA Explained / arXiv:math/0504020), §4 Cor. `cor:repsh`. Read from `references/kleiman-picard-src/picard.tex`.
- Stacks Project tag 03DM (relative tensor product of OX-modules). Read from `references/stacks-coherent.tex` or the Stacks website if not present locally.
- Mathlib `Mathlib.CategoryTheory.Monoidal.PresheafOfModules` (file path; use Mathlib's GitHub if needed via `WebFetch`).
- Mathlib `Mathlib.AlgebraicGeometry.Modules` directory tree (file paths).

## Hard rules (verbatim from `.archon/prompts/plan.md`)

- Every external statement gets `% SOURCE: <pointer> (read from references/<file>)` + `% SOURCE QUOTE:` verbatim + visible `\textit{Source: …}`. NEVER write a citation you haven't just read locally.
- Do NOT add `\leanok` or `\mathlibok` markers. The deterministic sync between prover and review handles `\leanok`; the review agent owns `\mathlibok`.
- Project-internal definitions (e.g. the `OnProduct` lift) may stand on the proof sketch alone, no SOURCE lines.

## Out-of-scope items

- Do NOT discharge or close any other sorry in `Picard_RelPicFunctor.tex` or `Picard/RelPicFunctor.lean` — your write-domain is `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` + `references/**` only.
- Do NOT touch `STRATEGY.md`, `PROGRESS.md`, or any `.lean` file.

## Write domain

- `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
- `blueprint/src/content.tex` (to add the `\input{...}` line)
- `references/**` (to authorize a possible reference-retriever child if you need to download more Mathlib monoidal-PresheafOfModules API to cite)

## Report

`task_results/blueprint-writer-tensorobj-substrate-chapter.md`.
