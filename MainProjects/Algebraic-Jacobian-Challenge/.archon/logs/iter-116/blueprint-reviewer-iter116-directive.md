# Blueprint Reviewer Directive

## Slug
iter116

## Strategy snapshot

The project is formalising the Jacobian of a smooth proper geometrically irreducible curve over a field, following Christian Merten's challenge file (`references/challenge.lean`). The strategic phases:

- **Phase A — Čech acyclicity (`BasicOpenCech.lean`)**: deferred / gated; 6 sorries, all off-limits this iter (L1120 PAUSED; L1212/L1536/L1564 substep-deferred; L1754 gated on L1120; L1846 budget-deferred).
- **Phase B — Cotangent sheaves (`Differentials.lean`)**: 5 sorries.
  - L175 `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` — **iter-115 hard gate FIRED on this route this iter; no prover lane on `Differentials.lean` this iter.** The user has been escalated via `USER_HINTS.md`; the loop is awaiting strategic decision (invest in hand-rolled affine-basis sheaf bridge ~500–1500 LOC; or refactor Phase B against the presheaf-only form; or declare L175 named gap #8).
  - L798 `cotangentExactSeq_structure case h_exact` — named Mathlib gap #2.
  - L880 `smooth_iff_locally_free_omega` — Phase B prover-viable; scheduled iter-117+ at earliest, but pending the L175 escalation outcome.
  - L897 `cotangent_at_section` — Phase B prover-viable (corollary).
  - L1039 `serre_duality_genus` — named Mathlib gap #7.
- **Phase C0 — Monoidal X.Modules**: `instIsMonoidal_W` deferred (named gap #1).
- **Phase C1 — Refined LineBundle**: DONE iter-109; 2 named-gap sorries on `LineBundle.lean` L82/L96 (named gaps #5/#6).
- **Phase C2 — PicardFunctor re-derivation**: largely absorbed by C1; verification round pending.
- **Phase C3 — Representability / `JacobianWitness`**: deferred via JacobianWitness exit policy (named gap #3 + #4).

Iter-116 is a deeper-think iter triggered by the iter-115 hard gate firing; **no prover lane on any file**. The plan agent has dispatched a thin blueprint-writer for two cosmetic Mathlib name slips in `Differentials.tex` (L59 and L73) parallel to your audit. Your audit drives whether iter-117+ can re-open Phase B prover work (subject to the user's escalation response).

## Routes

Single route. The strategy's only viable path forward is the JacobianWitness exit policy + named-gap framing for the framework-conditional layers; alternate routes (full Hilbert / Quot construction; Sym^g / S_g quotient; divisor-class image Pic⁰) are documented but not selected.

## Specific concerns this iter

1. **`Differentials.tex`** — recent (iter-114) two-pass writer round landed the unique-gluing recipe; iter-115 reviewer PASSed but flagged 2 cosmetic Mathlib name slips:
   - L59: `KaehlerDifferential.isLocalizedModule\_map` should drop `\_map` (correct Mathlib name is `KaehlerDifferential.isLocalizedModule` — no `_map` suffix).
   - L73 area: `AlgebraicGeometry.Modules.tilde` should be `AlgebraicGeometry.tilde` (correct namespace is `AlgebraicGeometry`, not `AlgebraicGeometry.Modules`).
   A blueprint-writer is being dispatched in parallel this iter to fix these. **Please re-audit `Differentials.tex` at the end of your audit and report whether the chapter is now `complete: true` AND `correct: true` — your verdict will gate iter-117+ Phase B prover dispatches.** Note: the writer may finish before or after you; if your audit pre-dates the fix, mark this as a known-pending and the iter-117 reviewer dispatch will confirm.

2. **`Differentials.tex` proof of `\lem:relative_kaehler_isSheafUniqueGluing`** — the chapter's recipe is mathematically sound (analogist-verified iter-114) but the Step 2 cofinality descent is explicitly an `[gap]` (no off-the-shelf Mathlib bridge). Confirm the chapter still flags this honestly.

3. **`Differentials.tex` `\thm:serre_duality_genus`** — iter-115 prose was relaxed to `IsIntegral` + `Smooth` to match Lean signature; confirm.

4. **`Cohomology_MayerVietoris.tex`** — iter-115 reviewer flagged a stale `Modules/Monoidal.lean:166` line reference (current correct line is L173); this is non-blocking (BasicOpenCech.lean is off-limits) but flag if it hasn't been fixed.

5. **`Differentials.tex` `\def:relative_kaehler_sheaf`** — iter-115 reviewer flagged a "morally quasi-coherent" prose remnant (soft, non-blocking); flag if still present.

6. **All other chapters** — full whole-blueprint audit per your standard rubric. The cross-chapter view is the point.

## Reference index

```
| File | Description |
| ---- | ----------- |
| challenge.lean | Original AI challenge file by Christian Merten. The Lean skeleton in AlgebraicJacobian/ is a decomposition; signatures in challenge.lean are authoritative. |
```

## Lean files in scope

(For each `.lean` file F, the blueprint chapter C and a brief stamp on whether F is in this iter's prover dispatch.)

- `AlgebraicJacobian/AbelJacobi.lean` ↔ `AbelJacobi.tex` — file 0 sorries; content blocked on Phase C3 + `instIsMonoidal_W`.
- `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` + `MayerVietorisCover.lean` ↔ `Cohomology_MayerVietoris.tex` — files 0 sorries.
- `AlgebraicJacobian/Cohomology/SheafCompose.lean` ↔ `Cohomology_SheafCompose.tex` — file 0 sorries.
- `AlgebraicJacobian/Cohomology/StructureSheafAb.lean` ↔ `Cohomology_StructureSheafAb.tex` — file 0 sorries.
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` ↔ `Cohomology_StructureSheafModuleK.tex` — file 0 sorries.
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` ↔ (no chapter; on-disk in MayerVietoris chapter as transitive infra) — 6 sorries off-limits this iter.
- `AlgebraicJacobian/Differentials.lean` ↔ `Differentials.tex` — 5 sorries; **L175 paused via user escalation; no prover lane this iter.**
- `AlgebraicJacobian/Genus.lean` ↔ `Genus.tex` — file 0 sorries.
- `AlgebraicJacobian/Jacobian.lean` ↔ `Jacobian.tex` — 1 sorry (`nonempty_jacobianWitness`; named gap #3).
- `AlgebraicJacobian/Modules/Monoidal.lean` ↔ `Modules_Monoidal.tex` — 1 sorry (`instIsMonoidal_W`; named gap #1).
- `AlgebraicJacobian/Picard/Functor.lean` ↔ `Picard_Functor.tex` — 1 sorry (`representable`; named gap #4).
- `AlgebraicJacobian/Picard/FunctorAb.lean` ↔ `Picard_FunctorAb.tex` — file 0 sorries.
- `AlgebraicJacobian/Picard/LineBundle.lean` ↔ `Picard_LineBundle.tex` — 2 sorries (`pullback_tensorObj` L82, `pullback_oneIso` L96; named gaps #5/#6).
- `AlgebraicJacobian/Rigidity.lean` ↔ `Rigidity.tex` — file 0 sorries.

## Expected output

Per your standard report format: per-chapter `complete | correct` checklist; soft / soon / must-fix items; HARD GATE per-file verdict (which files may go into iter-117+ objectives, conditional on the user's escalation response); cross-chapter consistency notes; any strategy-modifying findings.
