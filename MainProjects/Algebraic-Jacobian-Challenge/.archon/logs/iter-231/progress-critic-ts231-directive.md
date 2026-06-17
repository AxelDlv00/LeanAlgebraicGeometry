# progress-critic directive — ts231

## Active route under consideration for this iter's prover dispatch

**Route A.1.c.SubT — ⊗-group-law substrate** (sole ungated lane). File:
`Picard/TensorObjSubstrate.lean`. Target: close `exists_tensorObj_inverse`
(every locally-trivial 𝒪_X-module has a ⊗-inverse), which needs the C-bridge
`dual_restrict_iso` (the dual commutes with restriction).

### Signals, last 6 iters (extracted by the planner)

| iter | prover status | project sorry | helpers added | blocker phrase |
|---|---|---|---|---|
| 226 | PARTIAL | 80→80 | +1 (`isIso_of_isIso_restrict`, B-connector) | "A+C bridges still remain" |
| 227 | PARTIAL | 80→80 | +3 (`homMk`, `toPresheaf_map_homMk`, `restrictScalarsRingIsoDualEquiv`) | "real blocker = gluing engine build SIZE, not d.2" |
| 228 | PARTIAL | 80→80 | +3 (dual-iso helpers) | "C-bridge blocked at H2′: slice internal-hom vs sectionwise" |
| 229 | PARTIAL | 80→80 | +3 (`overSliceSheafEquiv` shared root + 2) | "both bridges reduce to one shared root (sheaf-site equiv)" |
| 230 | PROBE / DOES-NOT-CLOSE | 80→80 | 0 | "shared root does NOT serve C-consumer; real blocker = presheaf internal-hom-restriction, varying-ring" |
| 231 (proposed) | — | target 80→79 | — | re-scope: build presheaf-of-modules internal-hom-commutes-with-restriction directly |

Recurring meta-pattern: each iter re-localizes the blocker ("the real blocker is now X").
Project sorry counter flat at 80 since iter-217 (14 iters).

### Strategy estimate vs elapsed
- STRATEGY.md `Iters left` for this phase: **~3–5**.
- Route entered its current "descent re-route" sub-phase at **iter-219** (12 iters elapsed).

### The planner's proposed objective for iter-231
- **1 file**: `Picard/TensorObjSubstrate.lean` — `[prover-mode: mathlib-build]` building the
  **freshly + correctly scoped** target: presheaf-of-modules internal-hom-commutes-with-restriction
  for an open immersion (`j_*(ℋom_{𝒪_U}(L,𝒪_U)) ≅ ℋom_{𝒪_X}(j_* L, 𝒪_X)`), varying-ring aware.
  Planner's claim: on the relevant opens `V ⊆ U` both sides are LITERALLY equal (pushforward along
  an open immersion = restriction), so the prior 14-iter stall was caused by building the WRONG
  target (a global sheaf-site equivalence) rather than this near-definitional presheaf restriction.

### Your question
Is dispatching another round on `TensorObjSubstrate.lean` at this re-scoped target genuine
convergence, or is it the same churn one sub-piece to the right? Specifically pressure-test the
planner's "this target is DIFFERENT, not churning" claim. Give a per-route verdict
(CONVERGING / CHURNING / STUCK / UNCLEAR) and a named corrective TYPE if not converging.
Note: USER has issued a standing directive forbidding escalation-to-user as a corrective and
explicitly authorizing refactoring of dead-ends + file-splitting parallelism — so "escalate to
USER" is NOT an available corrective; name an autonomous corrective instead.
