# lean-auditor directive (iter-220)

Audit the following Lean file as Lean (no strategy bias):

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

Focus area: the newly-added block in `namespace PresheafOfModules.InternalHom`
(lines ~996–1305): `restrictionMap`, `restrictionMap_add/_zero/_id/_comp/_comp_hom/_globalSMul/_smul`,
`hom_app_heq`, `restrictionMapAddHom`, `internalHomPresheaf`, and `internalHom` (in `section Assembly`).

Check specifically for:
- any `sorry`/`admit`/`native_decide` in the new declarations;
- any decl that is vacuous, mis-stated, or whose statement does not match its docstring;
- outdated comments / docstrings (the file has a long history; line refs in older comments may be stale);
- bad Lean practices (e.g. `erw` fragility, universe hacks, `@`-applied defs that mask diamonds).

Report a per-file checklist plus a flagged-issues block.
