# Picard/LineBundleCoherence.lean

## Overall status (iter-259): LOCALLY SORRY-FREE — HELD, no actionable work in this file

The assigned file is **already locally `sorry`-free and compiles cleanly**
(`lean_diagnostic_messages` → `success: true`, `items: []`). Every line matching
`grep sorry` in this file is in a docstring/comment, not in code. There is **no
inline `sorry` for me to fill** in my write domain.

### Why there is no actionable proof work here

This file is the A.2.c engine. Its only remaining mathematical content
(`chartOverIso`) was redirected at iter-258 to the shared root
`Scheme.Modules.chartOverIso` in `AlgebraicJacobian/Picard/SheafOverEquivalence.lean`:

```lean
noncomputable def chartOverIso (M : X.Modules) (U : X.Opens) (e : …) : … :=
  Scheme.Modules.chartOverIso U M e          -- delegates to the shared root
```

The shared root still carries **2 open sorries**, both in
`SheafOverEquivalence.lean` (NOT my file, NOT my write domain):
- `restrictOverIso`  — `SheafOverEquivalence.lean:235`
- `unitOverIso`      — `SheafOverEquivalence.lean:276`

These feed `Scheme.Modules.chartOverIso`, so my `LineBundle.chartOverIso` (and
its downstream consumers `chartPresentation`, `isFinitePresentation`,
`isFiniteType`) inherit `sorryAx` transitively.

`lean_verify` on `IsLocallyTrivial.isFinitePresentation`:
```
axioms: [propext, sorryAx, Classical.choice, Quot.sound]
```
The `sorryAx` is purely the transitive import dependency on the 2 shared-root
sorries — there is no local source of it.

### Conformance with PROGRESS.md

PROGRESS.md (iter-259) explicitly lists this file under **"HELD this iter (gated
on / consuming the shared root)"**:

> `Picard/LineBundleCoherence.lean` — LOCALLY SORRY-FREE (iter-258 redirect to
> `Scheme.Modules.chartOverIso`). Becomes fully axiom-clean with NO further edits
> the moment the shared root's 2 isos close. **Not a prover lane until then.**

This iter's two active prover lanes are `SheafOverEquivalence.lean` (the shared
root) and `TensorObjSubstrate.lean` (D3′). My file becomes axiom-clean
automatically once `restrictOverIso` + `unitOverIso` close in the shared-root
lane — **no edit to this file is required, possible, or permitted.**

### Action taken

None — and deliberately so. Editing this file would be churn (the 5 pinned
declarations are complete; touching working proofs is banned), and the only sorry
blocker lies in a file I do not own. I did **not** edit `SheafOverEquivalence.lean`
(outside my write domain). No bare `sorry` was introduced anywhere.

### Blueprint markers

All 5 pinned declarations are formalized and locally complete; the chapter
(`Picard_LineBundleCoherence.tex`) blocks already carry `\leanok`. No marker
change requested — `\leanok` is owned by the deterministic `sync_leanok` phase,
which will keep them as-is (file compiles, locally sorry-free). The remaining
transitive `sorryAx` is a cross-file dependency, not a local-block status, so it
does not affect this chapter's per-block markers.

### Next step (for the loop, not this file)

Close `restrictOverIso` + `unitOverIso` in `SheafOverEquivalence.lean` (the other
prover lane this iter). The moment both land, re-`lean_verify`
`IsLocallyTrivial.isFinitePresentation` here: `sorryAx` drops out and the engine
deliverable `IsFinitePresentation` is fully axiom-clean with zero edits to this
file.
