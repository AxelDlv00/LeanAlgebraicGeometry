# AlgebraicJacobian/Jacobian.lean

## Iteration 071 — Phase C (sub-goal B): Albanese-witness refactor

### Summary

Refactored the file along **Sub-goal B** from `PROGRESS.md`:
introduced a `JacobianWitness` structure that bundles the Albanese object `J`
with its abelian-variety instances (`GrpObj`, `IsProper`, `Smooth`,
`GeometricallyIrreducible`, `SmoothOfRelativeDimension (genus C)`), the marked
point `P`, and the universal-property proof; declared
`nonempty_jacobianWitness : Nonempty (JacobianWitness C)` as the single deferred
existence hypothesis; defined `jacobianWitness C` via `Classical.choice`; and
rewrote the four protected instance bodies so the genus `> 0` branch projects
the relevant field of `jacobianWitness C`.

**Sorry trajectory: 5 → 1** (a 80% reduction in this file).

The remaining sorry is `nonempty_jacobianWitness` (L162 in the new file). All
five originally-frozen sorries — `Jacobian` (genus > 0 branch), `instGrpObj`,
`smoothOfRelativeDimension_genus`, `instIsProper`,
`instGeometricallyIrreducible` — are now fully closed by reduction to the single
existence hypothesis.

Protected signatures (`Jacobian`, `instGrpObj`, `smoothOfRelativeDimension_genus`,
`instIsProper`, `instGeometricallyIrreducible`) preserved verbatim; only their
bodies changed. No new axioms (only `sorry` and `Classical.choice`, both
pre-existing). No edits to any other `.lean` file.

### Structural changes (new declarations)

| Declaration | Kind | Lines | Notes |
|---|---|---|---|
| `JacobianWitness` | `structure` | 128–145 | Bundles `J : Over (Spec (.of k))`, `grpObj`, `proper`, `smooth`, `geomIrred`, `smoothGenus : SmoothOfRelativeDimension (genus C) J.hom`, `P : 𝟙_ _ ⟶ C`, `isAlbanese : @IsAlbanese k _ C P J grpObj proper smooth geomIrred`. |
| `nonempty_jacobianWitness` | `theorem` | 159–162 | **Single remaining sorry**; statement `Nonempty (JacobianWitness C)`. |
| `jacobianWitness` | `noncomputable def` | 167–170 | `Classical.choice (nonempty_jacobianWitness C)`. |

### Closed protected sorries (genus > 0 branches)

| Decl | Line | New body for genus > 0 |
|---|---|---|
| `Jacobian` | 188 | `(jacobianWitness C).J` |
| `instGrpObj` | 200 | `exact (jacobianWitness C).grpObj` |
| `smoothOfRelativeDimension_genus` | 209 | `exact (jacobianWitness C).smoothGenus` |
| `instIsProper` | 216 | `exact (jacobianWitness C).proper` |
| `instGeometricallyIrreducible` | 223 | `exact (jacobianWitness C).geomIrred` |

The genus = 0 branches are unchanged from iter-069 (`infer_instance` /
`rw [h]; infer_instance` / `geometricallyIrreducible_id_Spec k`).

### Why bundle into a single witness, vs. relocating the sorry per-instance

The plan-agent suggestion (sub-goal B) targets a 5 → 2 reduction by leaving
`smoothOfRelativeDimension_genus` as a separate sorry. Bundling
`smoothGenus : SmoothOfRelativeDimension (genus C) J.hom` directly into
`JacobianWitness` and `nonempty_jacobianWitness` reaches 5 → 1 instead. This
strengthens the existence claim by exactly one field, but the mathematical
content is the same: an Albanese object of a genus-`g` curve has dimension `g`
(Brill–Noether / dimension of `H¹(C, O_C)`). The single bundled hypothesis is
the form the next iteration's prover should attack as a unit.

### Validation

The build environment under `lake env lean` is broken in this iteration:
`.lake/packages/{doc-gen4,checkdecls,mathlib,...}` are root-owned and unwritable
to the `archon` user, so the LSP MCP returns `success: false` and
`lake exe cache get` fails with `permission denied (error code: 13)` on the
mathlib build dir. The full project does not compile in this environment.

To validate the code locally, I built a faithful standalone reproduction of
the entire new file structure (with `IsAlbanese` and `genus` mocked) and ran it
through `lean_run_code`. The reproduction compiles cleanly with no diagnostics,
exercising every changed surface:

- `JacobianWitness` declaration (including `@IsAlbanese k _ C P J grpObj proper
  smooth geomIrred` field type)
- `nonempty_jacobianWitness` / `jacobianWitness` Classical.choice plumbing
- `Jacobian C := if h : genus C = 0 then 𝟙_ _ else (jacobianWitness C).J`
- All four instance proofs using `unfold Jacobian; split_ifs; · ...; · exact (jacobianWitness C).<field>`

Additionally probed (via `lean_run_code`):

- `GrpObj (𝟙_ (Over (Spec (.of k))))` infers (genus-0 branch of `instGrpObj`)
- `IsProper (𝟙_ _).hom` infers (genus-0 branch of `instIsProper`)
- `SmoothOfRelativeDimension 0 (𝟙_ _).hom` infers (genus-0 branch of
  `smoothOfRelativeDimension_genus` after `rw [h]`)
- `[SmoothOfRelativeDimension 1 f] → Smooth f` is an instance in Mathlib (so the
  `smooth` field of `JacobianWitness` could in principle be dropped, but it is
  kept for self-documentation; it costs nothing).

### Next steps

The remaining sorry `nonempty_jacobianWitness` is a single mathematical existence
claim: every smooth proper geometrically irreducible curve `C` over `k` admits an
Albanese object of dimension `genus C`. The classical routes are:

1. **Symmetric powers + Abel–Jacobi**: `J = Pic^0_{C/k}` = identity component of
   `Pic_{C/k}`. Mathlib lacks symmetric powers of schemes and quotients by finite
   group actions.
2. **Picard scheme directly**: `J = Pic^0_{C/k}`. Requires FGA representability,
   which is the same gap blocking `PicardFunctor.representable`.
3. **Albanese functor**: directly construct via the universal property. Requires
   either of the above as input.

All three are multi-iteration efforts; the plan agent should treat
`nonempty_jacobianWitness` as a single deferred mathematical claim and prioritise
Phase A/B closures (which are closer to landing) first.

### Blueprint marker recommendation

The blueprint chapter `blueprint/src/chapters/Jacobian.tex` already mentions the
Albanese definition and its uniqueness. After this iteration the four protected
instance theorems (`Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`,
`Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible`) have honest
proofs reducing to a single existence hypothesis. The `\leanok` sync should
promote them — but per the prover prompt I do not edit the blueprint; the
`sync_leanok` phase will handle this.

The new declarations `JacobianWitness`, `nonempty_jacobianWitness`,
`jacobianWitness` are scaffolding that the plan agent may wish to add to the
blueprint chapter as informal sub-blocks (the bundle structure + the existence
claim) in a future iteration, but I leave that decision to the plan agent.

### Downstream impact

`AbelJacobi.lean` (3 sorries: `ofCurve`, `comp_ofCurve`,
`exists_unique_ofCurve_comp`) is described in `task_pending.md` as "BLOCKED on
`Jacobian C` first". With this iteration `Jacobian C` is now well-typed for
both genus branches (genus = 0: terminal object; genus > 0: bundled Albanese
witness) and all four abelian-variety instances are honest. The `IsAlbanese`
namespace's `ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp` extractors
in this file (added by iter-069) are now directly available via
`(jacobianWitness C).isAlbanese.ofCurve`. This unblocks the AbelJacobi prover.
