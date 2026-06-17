Target: blueprint/src/chapters/Picard_SectionGradedRing.tex
Action: clear coverage debt — add concise blueprint blocks for 10 axiom-clean Lean helpers that currently have NO `\lean{}` block (they surface as isolated `lean_aux` nodes in `archon dag-query unmatched`). Read the chapter + the Lean file `AlgebraicJacobian/Picard/SectionGradedRing.lean` to get each decl's exact signature and what it depends on, then write an accurate one-line informal statement + accurate `\uses{}` for each.

These are layer-1 tensor/sheafification infrastructure under `AlgebraicGeometry.Scheme.Modules` — slot them under the existing sections `sec:sgr_tensor_powers` (near `def:sheafTensorObj` ~L118 / `def:sheafTensorPow` ~L164 / `def:sheafModuleTwist` ~L200), as small `\begin{definition}`/`\begin{lemma}` blocks. All project-bespoke (no external source quote needed).

Decls to blueprint (use exact `\lean{AlgebraicGeometry.Scheme.Modules.<name>}`):
- `MonoidalPresheaf` — the monoidal structure carrier on the presheaf-of-modules category used to define tensor.
- `unitModule` — the unit object of the tensor structure (structure sheaf as a module over itself).
- `sheafification` — the sheafification functor on presheaves of modules (Mathlib re-export anchor; if it is a direct Mathlib alias, make it a `\mathlibok` Mathlib-dependency anchor naming the Mathlib decl).
- `sheafificationCounitIso` — counit iso of the sheafification adjunction.
- `tensorObjUnitIso` — left/right unit coherence iso for `tensorObj`.
- `tensorObjRightUnitor` — right unitor for `tensorObj`.
- `tensorBraiding` — braiding/symmetry iso for `tensorObj`.
- `tensorPow_zero` — `tensorPow … 0 ≅ unit` (base case).
- `tensorPow_succ` — `tensorPow … (n+1) ≅ tensorObj (tensorPow … n) M` (recursion step).
- `moduleTensorPow_zero` — `moduleTensorPow … 0 ≅ unit` (twist base case).

For each: accurate `\uses{}` to the parent block(s) it builds on (e.g. tensorPow_succ \uses def:sheafTensorPow + def:sheafTensorObj). Keep each block to statement + a one-sentence informal justification.

Constraints: math prose only, no Lean tactics. Do NOT add `\leanok`. You MAY add `\mathlibok` ONLY if a decl is a genuine direct Mathlib re-export (likely just `sheafification`). Keep concise — this is debt-clearing, not exposition.
