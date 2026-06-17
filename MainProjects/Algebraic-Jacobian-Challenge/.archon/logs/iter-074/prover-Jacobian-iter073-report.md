# AlgebraicJacobian/Jacobian.lean

## Iteration 073 — Phase D refactor (Lane 3): dite removal in `Jacobian`

### Summary

Executed the refactor described in `PROGRESS.md` § 3 *Phase D refactor (precursor to Lane 4)*: removed the `if h : genus C = 0 then 𝟙_ _ else (jacobianWitness C).J` dite from the body of `Jacobian C`, and rewrote each of the four protected instances to project the corresponding field of `jacobianWitness C` directly (no `unfold Jacobian; split_ifs` plumbing).

**Sorry trajectory: 1 → 1** (planned; this lane is a refactor, no closure). The remaining sorry is `nonempty_jacobianWitness` (L177), now absorbing both higher-genus Albanese existence and the genus-`0` rigidity content (the witness's `isAlbaneseFor P` field must verify the Albanese universal property for genus-`0` curves too).

Protected signatures preserved verbatim: `Jacobian`, `instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`. No new axioms. `geometricallyIrreducible_id_Spec`, `JacobianWitness`, `nonempty_jacobianWitness`, `jacobianWitness`, `IsAlbanese`, `IsAlbanese.unique` are unchanged in content.

### Concrete edits

| Decl | Line | Before | After |
|---|---|---|---|
| `Jacobian` (body) | 197–199 | `if h : genus C = 0 then 𝟙_ _ else (jacobianWitness C).J` | `(jacobianWitness C).J` |
| `instGrpObj` (body) | 207 | tactic block `unfold Jacobian; split_ifs; · infer_instance; · exact (jacobianWitness C).grpObj` | term `(jacobianWitness C).grpObj` |
| `smoothOfRelativeDimension_genus` (body) | 211–212 | tactic block `unfold Jacobian; split_ifs with h; · rw [h]; infer_instance; · exact (jacobianWitness C).smoothGenus` | term `(jacobianWitness C).smoothGenus` |
| `instIsProper` (body) | 215 | tactic block `unfold Jacobian; split_ifs; · infer_instance; · exact (jacobianWitness C).proper` | term `(jacobianWitness C).proper` |
| `instGeometricallyIrreducible` (body) | 218–219 | tactic block `unfold Jacobian; split_ifs; · exact geometricallyIrreducible_id_Spec k; · exact (jacobianWitness C).geomIrred` | term `(jacobianWitness C).geomIrred` |

Module-level docstring (L8–L39) rewritten to drop the genus-0 / genus-pos two-branch story; now describes the uniform witness-based definition. The "Forbidden shortcut" sanity-check paragraph kept (mathematically still relevant: the terminal-object shortcut remains forbidden because it forces `genus C = 0`); paragraph updated to note that the witness-based definition handles genus 0 correctly via the witness's underlying scheme being `Spec k` in that case.

`jacobianWitness`'s own docstring (L179–L181) also reworded: "Used to define `Jacobian C` and to discharge each of the four protected instances on it" (was: "Used to populate the genus `> 0` branch of `Jacobian C`…").

`geometricallyIrreducible_id_Spec` (L118–L124) is preserved verbatim per Lane 3 spec point 4. It is no longer used in this file (the genus-0 branch of `instGeometricallyIrreducible` previously consumed it). Removing it would be a deletion outside the refactor scope; left in place for a possible future use in `AbelJacobi.lean` (genus-0 case discussion) or elsewhere.

### Concern raised and resolved: `noncomputable instance`

The original `instGrpObj` was *not* marked `noncomputable` even though its by-block body landed on `exact (jacobianWitness C).grpObj`, which uses the `Classical.choice`-defined `jacobianWitness C`. Term-mode bodies referring to noncomputable definitions normally trigger Lean's `failed to compile definition, consider marking it as 'noncomputable'` error. I worried that removing the by-block wrapper would now trigger that check.

Verified empirically via a self-contained `lean_run_code` reproduction (Curve + Smooth/IsProper + Witness skeleton + noncomputable Jacobian + the four instances), pattern matched to the actual file structure: the term-mode bodies compile cleanly *without* `noncomputable`, because each instance has an explicit parameter (`C` plus typeclasses) and Lean's noncomputable check is lenient on parametric instance declarations. No `noncomputable` modifier needed. (I initially added `noncomputable instance` to `instGrpObj` as a safety measure, then reverted after verifying the parameter-lenient elaboration path.)

### Compile-time validation (standalone)

Full project `lake env lean` is still broken in this iteration (`.lake/packages/{mathlib,…}` root-owned; LSP `lean_diagnostic_messages` returns `success: false`). Same situation as iter-072.

Validated the refactor structure via a `lean_run_code` standalone reproduction:

- Curve / Smooth / IsProper / GrpObj mock classes (with `GrpObj` carrying data, `Smooth`/`IsProper` Prop-valued).
- `Witness` structure with `J`, `grpObj`, `smooth`, `proper` fields.
- `nonempty_witness` axiomatized; `witnessC` defined via `Classical.choice`.
- `noncomputable def Jacobian (C : Curve) [Smooth C] [IsProper C] : Curve := (witnessC C).J`.
- Three term-mode instances projecting witness fields directly.

All compile cleanly with no diagnostics. The pattern is identical to the actual file structure for the four post-refactor instance bodies.

### Verification checklist

- [x] Single remaining sorry is `nonempty_jacobianWitness` (L177).
- [x] The four protected instances no longer contain `unfold Jacobian` / `split_ifs`.
- [x] `Jacobian C` body no longer has a `dite` (now reads literally `(jacobianWitness C).J`).
- [x] No new axioms. `Classical.choice` and the single `sorry` on `nonempty_jacobianWitness` are pre-existing.
- [x] Protected signatures unchanged.
- [x] No other `.lean` file edited.

### Status flag for blueprint marker review

- `def:Jacobian` (`blueprint/src/chapters/Jacobian.tex`) — body now matches the blueprint's reworded "Albanese-witness uniformly over the marked point" description. Still depends on `thm:nonempty_jacobianWitness` (deferred), so `\leanok` should remain *unset*.
- `thm:Jacobian_grpObj`, `thm:Jacobian_smooth_genus`, `thm:Jacobian_proper`, `thm:Jacobian_geomIrred` — all now have honest term-level closures projecting the witness; their formal status is "compiles iff `nonempty_jacobianWitness` is provided". Marker status unchanged (depends on sync_leanok phase reading the sorry analyzer output once the build env is repaired).

### Interaction with Lane 4 (`AbelJacobi.lean`)

The plan agent specified that Lane 4 should rewrite each of the three `AbelJacobi.lean` protected theorems to drop `unfold Jacobian; split_ifs with h` and instead project through `(jacobianWitness C).isAlbaneseFor P`. With the dite removed from `Jacobian C`, `unfold Jacobian; split_ifs` no longer makes sense (there's no `if` to split). Lane 4's rewrites are the natural follow-up — they need to remove the `split_ifs` infrastructure that's now obsolete, and use the unconditional witness projection. The change in this file unblocks that rewrite.

### Next-step pointers

- After this iteration, the single remaining sorry in `Jacobian.lean` is `nonempty_jacobianWitness` (L177). Mathlib still lacks the prerequisites (symmetric powers / quotients by finite group actions / `Hom(ℙ¹, A) = A(k)` rigidity / FGA representability). Phase C remains deferred per `STRATEGY.md`.
- `AbelJacobi.lean` Lane 4 should close its single remaining sorry by routing through `(jacobianWitness C).isAlbaneseFor P`; with this refactor landed, the refactor lane should not encounter `unfold Jacobian` errors.
- No follow-up edits to `Jacobian.lean` are anticipated until either Mathlib gains the needed infrastructure or the mathematician relaxes the protected signatures.
