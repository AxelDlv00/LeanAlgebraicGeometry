# Lean ↔ Blueprint Check Report

## Slug
rigiditykbar-iter127

## Iteration
127

## Files audited
- Lean: `AlgebraicJacobian/RigidityKbar.lean` (89 lines, 1 declaration)
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex` (195 lines, 6 `\lean{...}` blocks)

## Per-declaration

### `\lean{AlgebraicGeometry.rigidity_over_kbar}` (chapter: `thm:rigidity_over_kbar`)
- **Lean target exists**: yes — `theorem rigidity_over_kbar` at `RigidityKbar.lean:75`.
- **Signature matches**: **yes** — every hypothesis in the chapter Statement (line 22–29) is reflected verbatim in the Lean signature:
  - Chapter "Let $\bar k$ be a field" → `variable {kbar : Type u} [Field kbar]`. No `[IsAlgClosed kbar]`, matching the explicit iter-127 over-k commitment in the chapter intro (line 14: *"The Lean declaration's signature is already $k$-agnostic ([Field kbar], no [IsAlgClosed kbar])"*).
  - "smooth proper geometrically irreducible curve over $\bar k$ with $\genus(C) = 0$" → `{C : Over (Spec (.of kbar))} [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] (_hgenus : genus C = 0)`.
  - "smooth proper geometrically irreducible group scheme $A$" → `{A : Over (Spec (.of kbar))} [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]`.
  - $f : C \to A$ → `(f : C ⟶ A)`.
  - $p \in C(\bar k)$ with $f(p) = \eta_A$ → `(p : 𝟙_ (Over (Spec (.of kbar))) ⟶ C) (_hf : p ≫ f = η[A])` (terminal-object encoding of a $k$-rational point, which is the standard `Over (Spec _)` idiom).
  - Conclusion $f = C \to \Spec\bar k \xrightarrow{\eta_A} A$ → `f = (toUnit C ≫ η[A])`.
- **Proof follows sketch**: N/A — body is `sorry` (recognised iter-126 scaffold per directive; not flagged).
- **notes**: Encoding-note paragraph in chapter line 31 (abstract genus-0 curve in lieu of literal $\mathbb P^1_{\bar k}$) is consistent with the Lean comment block at `RigidityKbar.lean:32–46`. The `\leanok` marker on this block is appropriate (declaration is formalised with at least a sorry, per the project's blueprint marker vocabulary).

### `\lean{AlgebraicGeometry.GrpObj.lieAlgebra}` (chapter: `lem:GrpObj_lieAlgebra`)
- **Lean target exists**: no — explicitly an iter-128+ target per directive.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: Informational only per directive. Chapter has `\notready` marker (line 93), so the unbuilt status is openly declared rather than hidden.

### `\lean{AlgebraicGeometry.GrpObj.lieAlgebra_finrank_eq_dim}` (chapter: `lem:GrpObj_lieAlgebra_finrank`)
- **Lean target exists**: no — iter-128+ target.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: Informational only. (Note: LaTeX label is `lem:GrpObj_lieAlgebra_finrank`; the Lean target name `…_finrank_eq_dim` is more descriptive — naming drift between label and target slug is harmless.)

### `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}` (chapter: `lem:GrpObj_mulRight_globalises`)
- **Lean target exists**: no — iter-128+ target.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: Informational only. Chapter's "Iter-127 over-k risk register" paragraph (line 136) is the load-bearing prose for the over-k formulation; the future Lean target will need to honour the functorial shear formulation (vs pointwise translation by closed points).

### `\lean{AlgebraicGeometry.GrpObj.omega_free}` (chapter: `lem:GrpObj_omega_free`)
- **Lean target exists**: no — iter-128+ target.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: Informational only.

### `\lean{AlgebraicGeometry.GrpObj.omega_rank_eq_dim}` (chapter: `lem:GrpObj_omega_rank_eq_dim`)
- **Lean target exists**: no — iter-128+ target.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: Informational only.

## Red flags

None.

(The single `sorry` body of `rigidity_over_kbar` is the recognised iter-126 scaffold flagged in the directive's "Known issues" — explicitly excluded from must-fix per the C.2.b/C.2.c/C.2.d gated-on-shared-pile plan, with the chapter's `% Status` paragraph (line 12) honestly documenting iter-128+ closure. No excuse-comments, no `:= True`, no spurious axioms, no `Classical.choice` patterns.)

## Unreferenced declarations (informational)

None. The Lean file contains exactly one declaration (`rigidity_over_kbar`) and it is referenced from the chapter.

## Blueprint adequacy for this file

- **Coverage**: 1 / 1 Lean declarations have a corresponding `\lean{...}` block (`AlgebraicGeometry.rigidity_over_kbar` ↔ `thm:rigidity_over_kbar`). The other 5 `\lean{...}` blocks in the chapter point to iter-128+ targets that intentionally do not exist yet — informational gap, not a coverage failure.
- **Proof-sketch depth**: **adequate** — substantially over-adequate. The chapter has (a) a top-level proof decomposition into C.2.b / C.2.c / C.2.d / C.2.e steps that pin the rigidity-lemma reduction, image-dimension dichotomy, keystone gating, and set-to-scheme promotion; (b) a four-piece shared-pile inventory with per-piece LOC estimates, naming-idiom commitments, and a characteristic-$p$ option pick (Option A: Frobenius iteration); (c) a fresh iter-127 sub-decomposition of piece (i) into (i.a)/(i.b)/(i.c) with five new lemma blocks, each with a proof sketch and `\uses{...}` dependency graph. A prover landing the body iter-128+ has a very clear roadmap.
- **Hint precision**: **precise** — the `\lean{AlgebraicGeometry.rigidity_over_kbar}` block names the exact target. The signature's mathlib predicates (`SmoothOfRelativeDimension 1`, `IsProper`, `GeometricallyIrreducible`, `genus C = 0`, `GrpObj`, `Smooth`, `η[A]`) are pinned by the chapter's encoding-note paragraph (line 31) and consistent throughout. The five iter-128+ `\lean{...}` hints fully-qualify the `AlgebraicGeometry.GrpObj.*` namespace (per the iter-126 mathlib-analogist's naming-idiom alignment).
- **Generality**: **matches need** — chapter intro's "Iter-127 over-k commitment" paragraph (line 14) explicitly documents that the Lean signature is already $k$-agnostic and that the over-k framing requires no signature change. The prose framing shift (over-$\bar k$ → over arbitrary $k$) is annotated as a docstring/variable-name cleanup scheduled for iter-128+, openly noted rather than hidden. The Lean file's `kbar` variable name and `## Rigidity over k̄` docstring header are stale relative to the new chapter framing but consistent with the chapter's own acknowledgement; not a blocker.
- **Recommended chapter-side actions**: none for iter-127 (chapter is already at the high end of detail for a scaffolded keystone; the iter-127 plan agent already drove the over-k commitment and the piece (i) sub-decomposition this iter).

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - Lean file's docstring header (`## Rigidity over k̄`, line 9) and variable name `kbar` are now stale relative to the chapter's iter-127 over-k framing; rename to `k` and prose update are scheduled for iter-128+ per the chapter's own line 14 — already openly tracked, low priority.
  - Label/slug drift: chapter label `lem:GrpObj_lieAlgebra_finrank` vs Lean target slug `lieAlgebra_finrank_eq_dim` — harmless naming difference, no action.

Overall verdict: Lean file and chapter are consistent for the single live declaration `rigidity_over_kbar`; the iter-127 over-k commitment is honestly documented on both sides; the five new iter-128+ `\lean{...}` blocks correctly reference yet-to-exist GrpObj targets without overclaiming existence (`\notready` markers present). No blocking issues.
