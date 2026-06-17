# Blueprint Writer Report — cov274-ssmk

**Status: COMPLETE**

## Target
`blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex`

## Declarations covered (both in `AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean`)
- `CategoryTheory.Functor.const_additive` → new `\begin{lemma}` `\label{lem:Functor_const_additive}`
  — "the constant functor `Functor.const C : D ⥤ C ⥤ D` is additive when `D` is preadditive."
- `CategoryTheory.Functor.const_linear` → new `\begin{lemma}` `\label{lem:Functor_const_linear}`
  — "the constant functor is `R`-linear when `D` is `R`-linear preadditive."

Each block carries `\lean{}`, a faithful one-line statement from the Lean signature/docstring,
and a `\begin{proof}` body "Proved directly in Lean." No `\leanok` added on either the lemma
or proof environments (owned by the deterministic sync_leanok phase), per directive scope.

## Wiring (statement-level `\uses{}` only)
- `lem:Functor_const_additive` — chain root, no chapter dependencies.
- `lem:Functor_const_linear` `\uses{lem:Functor_const_additive}` (linear builds on additive).
- Hoisted `lem:Functor_const_linear` into the existing consumer block
  `def:Scheme_constantSheafGammaHom_linearEquiv`'s statement-level `\uses{}`.
  Justification: `constantSheafGammaHom_linearEquiv` (Carriers.lean:446) obtains
  `(constantSheaf J _).Additive`/`.Linear` via `unfold constantSheaf; infer_instance`,
  which resolve precisely through these two `Functor.const` instances.

Cluster: `const_additive ← const_linear ← constantSheafGammaHom_linearEquiv` (existing covered node).

## Verification
- `leandag build --json` — succeeds.
- `leandag query --isolated --chapter Cohomology_StructureSheafModuleK` — 0 results (no isolated nodes).
- `leandag query --uncovered` — no entries for Presheaf.lean / `const_*` (uncovered lean-aux count for the file is zero).
- The single `unknown_uses` in the global build (`thm:rational_map_to_av_extends → lem:av_isIntegral_and_codimOneFree`) is pre-existing in another chapter and unrelated to this pass.

## Out-of-scope compliance
- No `%SOURCE` / citation blocks (internal helpers, no external source).
- No other chapters edited; only the permitted statement-level `\uses{}` hoist on an existing block.
- No declarations outside the list touched.
