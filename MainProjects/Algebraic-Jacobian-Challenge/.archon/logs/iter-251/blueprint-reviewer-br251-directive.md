# Blueprint review — iter-251 (whole-blueprint audit; HARD GATE for the post-D2′ targets)

Audit the WHOLE blueprint as usual (per-chapter completeness + correctness checklist).
Do not scope-limit — the cross-chapter view is the point.

## Context for THIS iter's gate (where to look hardest)

D2′ on the Picard pullback–tensor critical path **closed axiom-clean in iter-250**
(`lem:pullback_tensor_iso_unit` / `pullbackTensorMap_unit_isIso`). The route now advances,
and this iter we intend to dispatch provers to **author and prove** the next declarations,
all in chapter `Picard_TensorObjSubstrate.tex`. None of these Lean decls exist yet — they
must be authored from the blueprint, so blueprint adequacy is the gate.

**Lane TS-cmp (critical path — will dispatch this iter):**
- `lem:pullback_tensor_map_natural` (D1′, `pullbackTensorMap_natural`)
- `lem:pullback_tensor_map_basechange` (D3′, `pullbackTensorMap_restrict`)
- `lem:pullback_tensor_iso_loctriv` (D4′, `pullbackTensorIsoOfLocallyTrivial`)

**Lane TS-inv (parallel dual-inverse workstream — candidate for this iter, contingent on your verdict):**
- `lem:dual_restrict_iso`
- `lem:dual_isLocallyTrivial`
- `lem:tensorobj_inverse_invertible` (`exists_tensorObj_inverse`) and the gluing/internal-hom
  support it `\uses{}` (`lem:internal_hom_isSheaf`, `lem:sheafofmodules_hom_of_local_compat`, etc.)

For EACH of the above blocks report explicitly in your per-chapter checklist:
- complete? correct? Lean target well-formed (the `\lean{...}` name + statement match what a
  prover would need)? proof sketch detailed enough to formalize without improvisation?
- any broken/stale `\uses{}` or `\cref{}` in these blocks.

I have just (plan-phase, iter-251) repaired four `\uses{\leanok ...}` corruptions and rewritten
the stale D2′ overview bullet (was naming the obsolete `δ_comp_η_tensorHom` route) — confirm those
read cleanly now.

## Output
Your standard per-chapter checklist + the HARD-GATE verdict (complete/correct, must-fix-this-iter)
for `Picard_TensorObjSubstrate.tex`, distinguishing the D1′/D3′/D4′ blocks from the dual-inverse
chain blocks. Also surface any `## Unstarted-phase blueprint proposals` as usual.
